library AinzSpells initializer InitAinzSpells uses GearSystems
    globals
        private timer AinzTimer03
        private code AinzTimer03Callback
        private integer AinzTimer03Users = 0

//--------------------------------------Ainz Core---------------------------------------------------------
        integer Ainz_ID = 'H02E'
        boolean AinzPicked = false

//---------------Q ability (Explosive Land Mine)-------------------------------
        integer AinzQ_ID = 'A0FH'
        real AinzQ_DamageIntBase = 1.5
        real AinzQ_DamageIntStep = 0.25
        real AinzQ_Damage2StaticBase = 100.0
        real AinzQ_Damage2StaticStep = 0.0
        real AinzQ_DamageAoe = 375.00
        real AinzQ_MineDuration = 40.00
        real AinzQ_MineTriggerAoe = 300.00
        real AinzQ_MineMinDistance = 300.00
        real AinzQ_MineChainAoe = 425.00
        boolean AinzQ_IsInvul = false
        real AinzQ_CastTime = 0.00
        real AinzQ_DecorDamage = 50.0

//---------------Q2 ability (Ring of Mines - F Chant)--------------------------
        integer AinzQ2_ID = 'A0FI'
        real AinzQ2_MineOffset = 500.00
        integer AinzQ2_MineCount = 6
        boolean AinzQ2_IsInvul = false
        real AinzQ2_CastTime = 0.00
        real AinzQ2_DecorDamage = 50.0

//---------------TQ / Q3 ability (Twin Dragon Lightning - T Mode)--------------
        integer AinzQ3_ID = 'A0FJ'
        private group AinzTQEnumGroup
        real AinzTQ_DamageIntBase = 5.0
        real AinzTQ_DamageIntBase2 = 5.00
        real AinzTQ_DamageAoe = 250.00
        real AinzTQ_DamageAoe2 = 750.00
        real AinzTQ_SearchAoe = 1000.00
        real AinzTQ_MinChainDistance = 300.00
        integer AinzTQ_MaxChain = 4
        real AinzTQ_StartAngle = 30.00
        real AinzTQ_StartOffset = 100.00
        real AinzTQ_Move = 3000.00
        real AinzTQ_Height = 100.00
        real AinzTQ_HitRange = 125.00
        real AinzTQ_DamagePeriod = 0.09
        real AinzTQ_EffectPeriod = 0.15
        boolean AinzTQ_SideApproachOnBounce = false
        boolean AinzTQ_IsInvul = false
        real AinzTQ_CastTime = 0.36
        real AinzTQ_DecorDamage = 50.0

//---------------W ability (Summon Death Knight)-------------------------------
        integer AinzW_ID = 'A0FK'
        integer AinzW_Unit_ID = 'h02F'
        real AinzW_Duration = 20.0
        integer AinzW_SummonHpBase = 400
        integer AinzW_SummonHpStep = 400
        boolean AinzW_IsInvul = false
        real AinzW_CastTime = 0.00
        real AinzW_DecorDamage = 25.0

//---------------W2 ability (Knight Charge / Protect)--------------------------
        integer AinzW2_ID = 'A0FL'
        integer AinzW_Buff_ID = 'B02P'
        real AinzW2_DamageIntBase = 1.5
        real AinzW2_DamageIntStep = 0.25
        real AinzW2_Damage2StaticBase = 100.0
        real AinzW2_Damage2StaticStep = 0.0
        real AinzW_KnightSearchRange = 1800.00
        real AinzW_KnightRunRange = 1210.00
        real AinzW_KnightSpeed = 75.00
        real AinzW_KnightHitAoe = 225.00
        boolean AinzW2_IsInvul = false
        real AinzW2_CastTime = 0.00
        real AinzW2_DecorDamage = 25.0

//---------------W3 ability (Triple Knight Charge)-----------------------------
        integer AinzW3_ID = 'A0FM'
        boolean AinzW3_IsInvul = false
        real AinzW3_CastTime = 0.00
        real AinzW3_DecorDamage = 25.0

//---------------TW / W4 ability (Negative Burst - T Mode)---------------------
        integer AinzW4_ID = 'A0FN'
        real AinzTW_DamageIntBase = 5.0
        real AinzTW_DamageIntStep = 0.0
        real AinzTW_Damage2StaticBase = 0.0
        real AinzTW_Damage2StaticStep = 0.0
        real AinzTW_DamageAoe = 1100.0
        integer AinzTW_Slow = 60
        integer AinzTW_Duration = 1
        boolean AinzTW_IsInvul = true
        real AinzTW_CastTime = 0.60
        real AinzTW_DecorDamage = 50.0

//---------------E ability (Wall of Skeleton)----------------------------------
        integer AinzE_ID = 'A0FO'
        real AinzE_DamageIntBase = 1.0
        real AinzE_DamageIntStep = 0.0
        real AinzE_RectLength = 1600.00
        real AinzE_RectWidth = 575.00
        real AinzE_DurationBase = 3.0
        real AinzE_DurationStep = 1.0
        real AinzE_WallLength = 1600.00
        real AinzE_WallCurve = 100.00
        real AinzE_WallForwardOffset = 0.00
        integer AinzE_WallEffectCount = 8
        integer AinzE_PathBlockerId = 'YTfb'
        real AinzE_WallBlockerSpacing = 32.00
        real AinzE_WallHitDamageInt = 2.00
        real AinzE_WallHitStun = 1.50
        real AinzE_WallHitRadius = 96.00
        real AinzE_WallCheckStep = 16.00
        integer AinzE_Slow = 20
        boolean AinzE_IsInvul = false
        real AinzE_CastTime = 0.00
        real AinzE_DecorDamage = 50.0

//---------------E2 ability (Hold of Ribs - Lv. 5 Unlock)----------------------
        integer AinzE2_ID = 'A0FP'
        real AinzE2_DamageIntBase = 1.0
        real AinzE2_DamageIntStep = 1.0
        real AinzE2_RootDuration = 2.00
        real AinzE2_DamagePeriod = 0.50
        integer AinzE2_RootBuff_ID = 'BEer'
        real AinzE2_RootApplyGrace = 0.30
        real AinzE2_EffectRadius = 10.00
        real AinzE2_EffectScale = 2.20
        real AinzE2_EffectHeight = 0.00
        boolean AinzE2_IsInvul = false
        real AinzE2_CastTime = 0.00
        real AinzE2_DecorDamage = 40.0

//---------------TE / E3 ability (Black Hole - T Mode)-------------------------
        integer AinzE3_ID = 'A0FQ'
        real AinzTE_DamageIntBase = 5.0
        real AinzTE_DamageIntStep = 0.0
        real AinzTE_DamageAoe = 750.00
        real AinzTE_DamagePeriod = 0.20
        real AinzTE_PulsePeriod = 0.30
        integer AinzTE_PulseCount = 4
        real AinzTE_Duration = 1.20
        real AinzTE_PullDuration = 0.18
        real AinzTE_PullMaxRange = 150.00
        boolean AinzTE_IsInvul = false
        real AinzTE_CastTime = 0.00
        real AinzTE_DecorDamage = 50.0

//---------------R ability (True Dark Lightning)-------------------------------
        integer AinzR_ID = 'A0FR'
        real AinzR_DamageIntBase = 5.0
        real AinzR_DamageIntStep = 1.0
        real AinzR_Damage2StaticBase = 0.0
        real AinzR_Damage2StaticStep = 0.0
        real AinzR_DamageAoe = 600.0
        real AinzR_PushRange = 450.0
        real AinzR_PushDuration = 0.30
        real AinzR_Stun = 1.0
        real AinzR_BonusAdd = 3.0
        real AinzR_BonusMax = 15.0
        boolean AinzR_IsInvul = true
        real AinzR_CastTime = 0.81
        real AinzR_DecorDamage = 50.0
        integer AinzR_Debuff = 3

//---------------TR / R2 ability (Reality Slash - T Mode)----------------------
        integer AinzR2_ID = 'A0FS'
        real AinzTR_DamageIntBase = 4.0
        real AinzTR_DamageIntStep = 1.0
        real AinzTR_MaxRange = 1900.00
        real AinzTR_StartRange = 80.00
        real AinzTR_GrowSpeed = 100.00
        real AinzTR_ConeWidth = 0.30
        real AinzTR_HitWidth = 110.00
        real AinzTR_EffectPeriod = 0.12
        boolean AinzTR_IsInvul = false
        real AinzTR_CastTime = 0.51
        real AinzTR_DecorDamage = 100.0

//---------------T ability (The Goal of All Life is Death)---------------------
        integer AinzT_ID = 'A0FT'
        integer AinzT_DebuffSpell_ID = 'A0FX'
        integer AinzT_Debuff_ID = 'B02H'
        real AinzT_DamageAoe = 1255.0
        real AinzT_ResistReduce = 30.0
        real AinzT_Duration = 12.0
        real AinzT_AddDuration = 15.0
        boolean AinzT_IsInvul = false
        real AinzT_CastTime = 0.00
        real AinzT_DecorDamage = 100.0

//---------------F ability (Dozen Layer Buffs)---------------------------------
        integer AinzF_ID = 'A0FU'
        integer AinzF_BuffSpell_ID = 'A0FW'
        integer AinzF_Buff0_ID = 'B02I'
        integer AinzF_Buff1_ID = 'B02J'
        integer AinzF_Buff2_ID = 'B02K'
        integer AinzF_Buff3_ID = 'B02L'
        integer AinzF_Buff4_ID = 'B02M'
        integer AinzF_Buff5_ID = 'B02N'
        integer AinzF_Buff6_ID = 'B02O'
        integer AinzF_Stats_ID = 'A0FY'
        real AinzF_Q2Duration = 5.00
        real AinzF_DamageIntBase = 6.0
        real AinzGF_DamageIntBonus = 1.5
        real AinzF_PushRange = 200.0
        real AinzF_PushDuration = 0.39
        real AinzF_Stun = 0.5
        boolean AinzF_IsInvul = false
        real AinzF_CastTime = 9.00
        real AinzF_DecorDamage = 0.0

//---------------G ability (Fallen Down)---------------------------------------
        integer AinzG_ID = 'A0FV'
        real AinzG_PrepareTime = 2.10
        real AinzG_DamagePeriod = 0.30
        integer AinzG_DamageCount = 8
        real AinzG_Duration = 2.40
        real AinzG_DamageIntBase = 8.0
        real AinzG_DamageIntStep = 0.0
        real AinzG_Aoe = 1200.00
        boolean AinzG_IsInvul = false
        real AinzG_CastTime = 2.10
        real AinzG_DecorDamage = 100.0

        // Хэш и расчёт стоимости предметов
        hashtable AinzGoldCostCache = InitHashtable()
        real array goldcost
    endglobals

    //===========================================================================
    // Система перехвата приказов (Order Tracking) для каста на ходу
    //===========================================================================
    private function OnHeroPointOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord = GetIssuedOrderId()
        if GetUnitTypeId(u) == Ainz_ID then
            if ord == 851971 or ord == 851986 or ord == 851990 then
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_mode"), 1)
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_id"), ord)
                call SaveReal(hs, GetHandleId(u), StringHash("ord_x"), GetOrderPointX())
                call SaveReal(hs, GetHandleId(u), StringHash("ord_y"), GetOrderPointY())
            endif
        endif
        set u = null
        return false
    endfunction

    private function OnHeroTargetOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord = GetIssuedOrderId()
        if GetUnitTypeId(u) == Ainz_ID then
            if ord == 851971 or ord == 851983 then
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_mode"), 2)
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_id"), ord)
                call SaveUnitHandle(hs, GetHandleId(u), StringHash("ord_target"), GetOrderTargetUnit())
            endif
        endif
        set u = null
        return false
    endfunction

    private function OnHeroImmediateOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord = GetIssuedOrderId()
        if GetUnitTypeId(u) == Ainz_ID then
            if ord == 851972 or ord == 851993 then
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_mode"), 0)
            endif
        endif
        set u = null
        return false
    endfunction

    function Ainz_RestoreOrder takes unit c, integer animIndex returns nothing
        local integer mode = LoadInteger(hs, GetHandleId(c), StringHash("ord_mode"))
        local real ox
        local real oy
        local real dx
        local real dy
        local integer oid
        local unit tu

        if mode == 1 then
            set ox = LoadReal(hs, GetHandleId(c), StringHash("ord_x"))
            set oy = LoadReal(hs, GetHandleId(c), StringHash("ord_y"))
            set dx = ox - GetUnitX(c)
            set dy = oy - GetUnitY(c)
            if (dx * dx + dy * dy) > 5625.0 then
                set oid = LoadInteger(hs, GetHandleId(c), StringHash("ord_id"))
                call IssuePointOrderById(c, oid, ox, oy)
                return
            endif
        elseif mode == 2 then
            set tu = LoadUnitHandle(hs, GetHandleId(c), StringHash("ord_target"))
            if tu != null and GetWidgetLife(tu) > 0.405 then
                set oid = LoadInteger(hs, GetHandleId(c), StringHash("ord_id"))
                call IssueTargetOrderById(c, oid, tu)
                set tu = null
                return
            endif
            set tu = null
        endif

        if animIndex >= 0 then
            call SetUnitAnimationByIndex(c, animIndex)
        endif
    endfunction

    private struct AinzOrderInit extends array
        private static method onInit takes nothing returns nothing
            local trigger tPoint = CreateTrigger()
            local trigger tTarget = CreateTrigger()
            local trigger tImmediate = CreateTrigger()
            local integer i = 0
            loop
                exitwhen i >= 16
                call TriggerRegisterPlayerUnitEvent(tPoint, Player(i), EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER, null)
                call TriggerRegisterPlayerUnitEvent(tTarget, Player(i), EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, null)
                call TriggerRegisterPlayerUnitEvent(tImmediate, Player(i), EVENT_PLAYER_UNIT_ISSUED_ORDER, null)
                set i = i + 1
            endloop
            call TriggerAddCondition(tPoint, Condition(function OnHeroPointOrder))
            call TriggerAddCondition(tTarget, Condition(function OnHeroTargetOrder))
            call TriggerAddCondition(tImmediate, Condition(function OnHeroImmediateOrder))
            set tPoint = null
            set tTarget = null
            set tImmediate = null
        endmethod
    endstruct

    function AddAinzItemGoldCost takes unit c, item whichItem returns nothing
        local integer pid
        local integer itemHid
        local real itemCost

        if c == null or whichItem == null or GetUnitTypeId(c) != Ainz_ID then
            return
        endif
        if not UnitHasItem(c, whichItem) then
            return
        endif

        set pid = GetPlayerId(GetOwningPlayer(c))
        set itemHid = GetHandleId(whichItem)

        if LoadBoolean(AinzGoldCostCache, itemHid, 0) then
            return
        endif

        set itemCost = I2R(GetItemValue(GetItemTypeId(whichItem)))
        set goldcost[pid] = goldcost[pid] + itemCost
        call SaveBoolean(AinzGoldCostCache, itemHid, 0, true)
        call SaveReal(AinzGoldCostCache, itemHid, 1, itemCost)
        call SaveInteger(AinzGoldCostCache, itemHid, 2, pid)
    endfunction

    function RemoveAinzItemGoldCost takes unit c, item whichItem returns nothing
        local integer pid
        local integer itemHid

        if c == null or whichItem == null or GetUnitTypeId(c) != Ainz_ID then
            return
        endif

        set pid = GetPlayerId(GetOwningPlayer(c))
        set itemHid = GetHandleId(whichItem)

        if not LoadBoolean(AinzGoldCostCache, itemHid, 0) or LoadInteger(AinzGoldCostCache, itemHid, 2) != pid then
            return
        endif

        set goldcost[pid] = goldcost[pid] - LoadReal(AinzGoldCostCache, itemHid, 1)
        call FlushChildHashtable(AinzGoldCostCache, itemHid)

        if goldcost[pid] < 0.00 then
            set goldcost[pid] = 0.00
        endif
    endfunction

    private function AinzTimer03Acquire takes nothing returns nothing
        set AinzTimer03Users = AinzTimer03Users + 1
        if AinzTimer03Users == 1 then
            call TimerStart(AinzTimer03, 0.03, true, AinzTimer03Callback)
        endif
    endfunction

    private function AinzTimer03Release takes nothing returns nothing
        set AinzTimer03Users = AinzTimer03Users - 1
        if AinzTimer03Users <= 0 then
            set AinzTimer03Users = 0
            call PauseTimer(AinzTimer03)
        endif
    endfunction

    private function AinzSwapPatch takes unit c, integer oldId, integer state returns nothing
        call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(oldId)), state)
    endfunction

    private function AinzFinishSwap takes unit c, integer oldId returns nothing
        if LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 1 then
            call SaveInteger(hs, GetHandleId(c), StringHash("Ainz pending swap " + I2S(oldId)), 1)
        else
            call AinzSwapPatch(c, oldId, 1)
        endif
    endfunction

    private function AinzFlushPendingSwaps takes unit c returns nothing
        if LoadInteger(hs, GetHandleId(c), StringHash("Ainz pending swap " + I2S(AinzQ_ID))) == 1 then
            call SaveInteger(hs, GetHandleId(c), StringHash("Ainz pending swap " + I2S(AinzQ_ID)), 0)
            call AinzSwapPatch(c, AinzQ_ID, 1)
        endif
        if LoadInteger(hs, GetHandleId(c), StringHash("Ainz pending swap " + I2S(AinzW_ID))) == 1 then
            call SaveInteger(hs, GetHandleId(c), StringHash("Ainz pending swap " + I2S(AinzW_ID)), 0)
            call AinzSwapPatch(c, AinzW_ID, 1)
        endif
        if LoadInteger(hs, GetHandleId(c), StringHash("Ainz pending swap " + I2S(AinzW2_ID))) == 1 then
            call SaveInteger(hs, GetHandleId(c), StringHash("Ainz pending swap " + I2S(AinzW2_ID)), 0)
            call AinzSwapPatch(c, AinzW2_ID, 1)
        endif
        if LoadInteger(hs, GetHandleId(c), StringHash("Ainz pending swap " + I2S(AinzE_ID))) == 1 then
            call SaveInteger(hs, GetHandleId(c), StringHash("Ainz pending swap " + I2S(AinzE_ID)), 0)
            call AinzSwapPatch(c, AinzE_ID, 1)
        endif
    endfunction

    private struct AinzQ_KS
        private static integer array m_AinzQ
        private static integer MUI_AinzQ = -1
        private static constant real ARM_DELAY = 1.00
        private static constant integer MINE_KIND_Q = 1
        private static constant integer MINE_KIND_Q2 = 2
        private static integer currentLoopTick = 0

        unit c
        player owner
        group g
        effect e
        effect e2
        real x
        real y
        real r
        real scan
        real dmg
        integer check2
        real scale
        integer mineKind
        boolean active
        boolean exploded
        boolean armed
        boolean chainTriggered
        integer chainTriggerTick

        public static method IsMinePositionFree takes real NewX, real NewY returns boolean
            local integer i = 0
            local thistype mine
            local real dx
            local real dy
            loop
                exitwhen i > MUI_AinzQ
                set mine = m_AinzQ[i]
                if mine.active and not mine.exploded and mine.e != null then
                    set dx = NewX - mine.x
                    set dy = NewY - mine.y
                    if dx * dx + dy * dy <= AinzQ_MineMinDistance * AinzQ_MineMinDistance then
                        return false
                    endif
                endif
                set i = i + 1
            endloop
            return true
        endmethod

        private static method CanPlaceRing takes real CenterX, real CenterY returns boolean
            local integer i = 0
            local integer j
            local real angle
            local real angle2
            local real px
            local real py
            local real px2
            local real py2
            local real dx
            local real dy
            loop
                exitwhen i >= AinzQ2_MineCount
                set angle = (360.00 / I2R(AinzQ2_MineCount)) * I2R(i) * bj_DEGTORAD
                set px = CenterX + AinzQ2_MineOffset * Cos(angle)
                set py = CenterY + AinzQ2_MineOffset * Sin(angle)

                if not thistype.IsMinePositionFree(px, py) then
                    return false
                endif

                set j = 0
                loop
                    exitwhen j >= i
                    set angle2 = (360.00 / I2R(AinzQ2_MineCount)) * I2R(j) * bj_DEGTORAD
                    set px2 = CenterX + AinzQ2_MineOffset * Cos(angle2)
                    set py2 = CenterY + AinzQ2_MineOffset * Sin(angle2)
                    set dx = px - px2
                    set dy = py - py2
                    if dx * dx + dy * dy <= AinzQ_MineMinDistance * AinzQ_MineMinDistance then
                        return false
                    endif
                    set j = j + 1
                endloop
                set i = i + 1
            endloop
            return true
        endmethod

        public static method IsMineRingFree takes real CenterX, real CenterY returns boolean
            return thistype.CanPlaceRing(CenterX, CenterY)
        endmethod

        private static method RefundCast takes unit NewC returns nothing
            local integer level = GetUnitAbilityLevel(NewC, AinzQ_ID)
            local integer manaCost
            if level < 1 then
                set level = 1
            endif
            set manaCost = BlzGetAbilityManaCost(AinzQ_ID, level - 1)
            call IssueImmediateOrder(NewC, "stop")
            call BlzEndUnitAbilityCooldown(NewC, AinzQ_ID)
            call SetUnitState(NewC, UNIT_STATE_MANA, GetUnitState(NewC, UNIT_STATE_MANA) + I2R(manaCost))
            if IntegerCd(NewC, "cd warning", 5) then 
                call DisplayTimedTextToPlayer(GetOwningPlayer(NewC), 0.00, 0.00, 1.00, "|cffffcc00Mine placement cancelled: another active mine is too close.|r")
            endif
        endmethod

        private method HasEnemyNearby takes nothing returns boolean
            local unit u
            local boolean found = false
            local real triggerAoe = AinzQ_MineTriggerAoe

            if mineKind == MINE_KIND_Q2 then
                set triggerAoe = AinzQ_MineTriggerAoe
            endif

            call GroupClear(g)
            call GroupEnumUnitsInRange(g, x, y, triggerAoe, NoDecor_Cond)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if SpellBool(u) and IsUnitEnemy(u, owner) then
                    set found = true
                endif
                call GroupRemoveUnit(g, u)
            endloop
            set u = null
            return found
        endmethod

        private method Explode takes nothing returns nothing
            local unit u
            local integer i = 0
            local thistype mine
            local real dx
            local real dy

            if not active or exploded then
                return
            endif

            set exploded = true
            set active = false
            call BlzSetSpecialEffectTimeScale(e, 1)
            call DestroyEffect(e)
            set e = null
            call DestroyEffect(e2)
            set e2 = null

            if mineKind == MINE_KIND_Q2 then
                if IntegerCd(c, "cd sound", 15) then
                    call MakeSound("war3mapimported\\Hero_Ainz_Q4")
                endif
                call MakeSound("war3mapimported\\Hero_Ainz_Q3")
            else
                call MakeSound("war3mapimported\\Hero_Ainz_Q1")
                if IntegerCd(c, "cd sound", 10) then
                    call MakeSound("war3mapimported\\Hero_Ainz_Q2")
                endif
            endif

            call VisionTimed(owner, x, y, AinzQ_DamageAoe * 1.35, 1.50)
            call DecorRemove(c, x, y, AinzQ_DamageAoe, AinzQ_DecorDamage)
            call EffectSpawn2("war3mapImported\\wos_opdef (1054).mdl", x, y, 0, 2, 1.1, 115, 0.7)
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion.mdx", x, y, GetRandomReal(0, 359), 1.35, 1.85, 15))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_bwaxec2.mdl", x, y, GetRandomReal(0, 359), 0.5, 1, 0))

            call GroupClear(g)
            call GroupEnumUnitsInRange(g, x, y, AinzQ_DamageAoe, NoDecor_Cond)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if SpellBool(u) and IsUnitEnemy(u, owner) then
                    call dmgmag(c, u, dmg)
                endif
                call GroupRemoveUnit(g, u)
            endloop
            set u = null

            loop
                exitwhen i > MUI_AinzQ
                set mine = m_AinzQ[i]
                if mine != this and mine.active and mine.armed and not mine.exploded and mine.e != null then
                    set dx = x - mine.x
                    set dy = y - mine.y
                    if dx * dx + dy * dy <= AinzQ_MineChainAoe * AinzQ_MineChainAoe then
                        set mine.chainTriggered = true
                        set mine.chainTriggerTick = currentLoopTick
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        private static method CreateMine takes unit NewC, real NewX, real NewY, integer NewMineKind returns nothing
            local thistype this = thistype.create()
            local integer kk = 0
            local integer level = GetUnitAbilityLevel(NewC, AinzQ_ID)
            if level < 1 then
                set level = 1
            endif

            set c = NewC
            set owner = GetOwningPlayer(NewC)
            set x = NewX
            set y = NewY
            set r = 0.00
            set scan = 0.00
            set mineKind = NewMineKind
            set active = true
            set exploded = false
            set armed = false
            set chainTriggered = false
            set chainTriggerTick = 0
            set check2 = 0
            set g = CreateGroup()

            set dmg = GetHeroInt(c, true) * (AinzQ_DamageIntBase + AinzQ_DamageIntStep * (level - 1))
            set dmg = dmg + AinzQ_Damage2StaticBase + AinzQ_Damage2StaticStep * (level - 1)
            set scale = AinzQ_DamageAoe / 375.0

            set e = AddSpecialEffect("war3mapImported\\wos_mineorange.mdl", x, y)
            call BlzSetSpecialEffectScale(e, 0.85)
            call BlzSetSpecialEffectHeight(e, 100)
            call BlzSetSpecialEffectTimeScale(e, 0.5)
            call BlzSetSpecialEffectYaw(e, GetRandomReal(0.00, 360.00) * bj_DEGTORAD)
            call BlzSetSpecialEffectAlpha(e, 0)
            set e2 = EffectSpawnScale("war3mapImported\\wos_lightning circlered.mdl", x, y, 1, 1, 0.01, 1, 1, 0.01, 1.425 * scale)
            call VisionTimed(owner, x, y, AinzQ_MineTriggerAoe, 1.00)
            call BlzSetSpecialEffectAlpha(e2, 0)

            set kk = 0 
            loop
                exitwhen kk == 10 
                if IsPlayerAlly(GetOwningPlayer(c), Player(kk)) then 
                    if GetLocalPlayer() == Player(kk) then
                        call BlzSetSpecialEffectAlpha(e, 255)
                        call BlzSetSpecialEffectAlpha(e2, 255)
                    endif
                endif
                set kk = kk + 1 
            endloop

            set MUI_AinzQ = MUI_AinzQ + 1
            set m_AinzQ[MUI_AinzQ] = this
            if MUI_AinzQ == 0 then
                call AinzTimer03Acquire()
            endif
        endmethod

        public static method Loop_AinzQ takes nothing returns nothing
            local integer i = 0
            local thistype this

            set currentLoopTick = currentLoopTick + 1

            loop
                exitwhen i > MUI_AinzQ
                set this = m_AinzQ[i]

                if active then
                    if chainTriggered then
                        if chainTriggerTick < currentLoopTick then
                            set chainTriggered = false
                            call this.Explode()
                        endif
                    else
                        set r = r + 0.03
                        if not armed and r >= ARM_DELAY then
                            set armed = true
                            set scan = 0.00
                        endif

                        if r >= AinzQ_MineDuration then
                            set active = false
                        elseif armed then
                            set scan = scan + 0.03
                            if scan >= 0.09 then
                                set scan = 0.00
                                if this.HasEnemyNearby() then
                                    call this.Explode()
                                endif
                            endif
                        endif
                    endif
                endif

                if not active then
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    set e2 = null
                    call DestroyGroup(g)
                    set e = null
                    set g = null
                    set c = null
                    set owner = null

                    set m_AinzQ[i] = m_AinzQ[MUI_AinzQ]
                    set MUI_AinzQ = MUI_AinzQ - 1

                    if MUI_AinzQ == -1 then
                        call AinzTimer03Release()
                    endif

                    call deallocate(this)
                    set i = i - 1
                endif

                set i = i + 1
            endloop
        endmethod

        public static method AinzQ_Start takes unit NewC, real NewX, real NewY returns nothing
            if not thistype.IsMinePositionFree(NewX, NewY) then
                call thistype.RefundCast(NewC)
                return
            endif

            call AinzSwapPatch(NewC, AinzQ_ID, 0)
            call SetUnitFacing(NewC, GAngle2(NewC, NewX, NewY) * bj_RADTODEG)
            call MakeSound("war3mapimported\\Hero_Ainz_Q")
            call thistype.CreateMine(NewC, NewX, NewY, MINE_KIND_Q)
            call Ainz_RestoreOrder(NewC, -1)
        endmethod

        public static method AinzQ2_Start takes unit NewC, real NewX, real NewY returns nothing
            local integer i = 0
            local real angle
            local real px
            local real py

            if not thistype.CanPlaceRing(NewX, NewY) then
                call thistype.RefundCast(NewC)
                return
            endif

            call AinzSwapPatch(NewC, AinzQ_ID, 0)
            call SetUnitFacing(NewC, GAngle2(NewC, NewX, NewY) * bj_RADTODEG)
            call MakeSound("war3mapimported\\Hero_Ainz_Q3")
            loop
                exitwhen i >= AinzQ2_MineCount
                set angle = (360.00 / I2R(AinzQ2_MineCount)) * I2R(i) * bj_DEGTORAD
                set px = NewX + AinzQ2_MineOffset * Cos(angle)
                set py = NewY + AinzQ2_MineOffset * Sin(angle)
                call thistype.CreateMine(NewC, px, py, MINE_KIND_Q2)
                set i = i + 1
            endloop
            call AinzFinishSwap(NewC, AinzQ_ID)
            call Ainz_RestoreOrder(NewC, -1)
        endmethod
    endstruct

    private struct AinzW_KS
        private static integer array m_AinzW2
        private static integer MUI_AinzW2 = -1
        private static trigger knightAcquireTrig = CreateTrigger()
        private static trigger knightDamageTrig = CreateTrigger()
        private static integer array m_AinzW
        private static integer MUI_AinzW = -1
        private static integer array m_AinzW3
        private static integer MUI_AinzW3 = -1
        unit d
        boolean b
        unit c
        integer level
        real distance
        unit td
        real x
        real y
        real x1
        real y1
        framehandle array frame1_pas1 [10]
        framehandle array frame1_pas2 [10]
        framehandle array frame1_pas3 [10]
        framehandle array frame1_pas4 [10]
        framehandle array frame1_pas5 [10]
        framehandle array frame1_pas6 [10]
        real r2
        integer k
        integer k2
        integer k3
        real r3
        real r4
        unit array dd[18]
        real r5
        group g
        group g2
        group g3
        unit u
        real dmg
        real a2
        integer check
        integer count
        integer check2
        real aoe
        real move
        real r
        effect e2
        real a
        real rmax

        private static method OnknightAcquire takes nothing returns nothing
            local unit knight = GetTriggerUnit()
            local unit target = GetEventTargetUnit()
            local unit caster = LoadUnitHandle(hs, GetHandleId(knight), StringHash("AinzW caster"))
            if caster != null and target != null and SpellBool(target) and IsUnitEnemy(target, GetOwningPlayer(caster)) then
                call SaveUnitHandle(hs, GetHandleId(knight), StringHash("AinzW target"), target)
            endif
            set knight = null
            set target = null
            set caster = null
        endmethod

        private static method OnknightDamage takes nothing returns nothing
            local unit knight = GetEventDamageSource()
            local unit target = GetTriggerUnit()
            local unit caster = LoadUnitHandle(hs, GetHandleId(knight), StringHash("AinzW caster"))
            if caster != null and target != null and BlzGetEventIsAttack() and SpellBool(target) and IsUnitEnemy(target, GetOwningPlayer(caster)) then
                call SaveUnitHandle(hs, GetHandleId(knight), StringHash("AinzW target"), target)
            endif
            set knight = null
            set target = null
            set caster = null
        endmethod

        public static method InitknightEvents takes nothing returns nothing
            call TriggerAddAction(knightAcquireTrig, function thistype.OnknightAcquire)
            call TriggerAddAction(knightDamageTrig, function thistype.OnknightDamage)
        endmethod

        public static method Loop_AinzW2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local group wolves
            local real wallMove
            loop
                exitwhen i > MUI_AinzW2
                set this = m_AinzW2[i]
                if SpellBoolCaster(c) and d != null and GetUnitState(d, UNIT_STATE_LIFE) > 0.405 and distance < AinzW_KnightRunRange then
                    set r = r + 0.03
                    if r < 0.39 then 
                        set a = GAngle(d, td)
                    endif
                    set r2 = r2 + 0.03
                    set r3 = r3 + 0.03
                    if not b and r >= 0.30 then
                        set b = true
                    endif
                    if b then
                        set wallMove = AinzW_KnightSpeed
                        if wallMove > 0.00 then
                            call MoveUnit3(d, wallMove, a)
                        endif
                        if r2 >= 0.06 then
                            set r2 = 0
                            call DecorRemove(c, GetUnitX(d), GetUnitY(d), AinzW_KnightHitAoe, AinzW2_DecorDamage)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_cf1.mdl", GetUnitX(d) + 1 * Cos(a), GetUnitY(d) + 1 * Sin(a), GetRandomReal(0, 359), 1, 1.25, 0))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_DanGe_Wid_ChongFengQiLiu.mdl", GetUnitX(d) + 350 * Cos(a), GetUnitY(d) + 350 * Sin(a), a * bj_RADTODEG, 1.5, 1.95, 0, 255, 255, 255, 125))
                        endif
                        if r3 >= 0.12 then
                            set r3 = 0
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(d) + 1 * Cos(a), GetUnitY(d) + 1 * Sin(a), a * bj_RADTODEG, 3, 2.25, 1, 255, 255, 255, 125))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", GetUnitX(d) + 1 * Cos(a), GetUnitY(d) + 1 * Sin(a), GetRandomReal(0, 359), 1, 1.25, 0))
                        endif
                        set distance = distance + AinzW_KnightSpeed
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, GetUnitX(d), GetUnitY(d), AinzW_KnightHitAoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                if not IsUnitInGroup(u, g2) then
                                    call GroupAddUnit(g2, u)
                                    call dmgphys(c, u, dmg)
                                endif
                                set wallMove = UnitMoveWall.GetMoveDistance(d, GetUnitX(d), GetUnitY(d), a, AinzW_KnightSpeed)
                                if wallMove < AinzW_KnightSpeed then
                                    if not IsUnitInGroup(u, g3) then
                                        call GroupAddUnit(g3, u)
                                        call dmgmag(c, u, GetHeroInt(c, true) * AinzE_WallHitDamageInt)
                                        call StunUnit(c, u, AinzE_WallHitStun)
                                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 0.75, 1.35, 0))
                                    endif
                                    if wallMove > 0.00 then
                                        call MoveUnit3(u, wallMove, a)
                                    endif
                                else
                                    call MoveUnit3(u, AinzW_KnightSpeed, a)
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                else
                    set wolves = LoadGroupHandle(hs, GetHandleId(c), StringHash("knight group"))
                    call AinzFinishSwap(c, AinzW2_ID)
                    if d != null and GetUnitState(d, UNIT_STATE_LIFE) > 0.405 then
                        call KillUnit(d)
                        call EffectSpawn2("war3mapImported\\wos_raidenei-4.mdl", GetUnitX(d), GetUnitY(d), a * bj_RADTODEG, 2, 1.5, 0, 0.3)
                        call ColorDummy3(d, 0, 255, 255, 255, 0.3)
                    endif
                    if wolves != null and d != null then
                        call GroupRemoveUnit(wolves, d)
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("AinzW timer pause"), 0)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    call DestroyGroup(g3)
                    set d = null
                    set c = null
                    set td = null
                    set g = null
                    set g2 = null
                    set g3 = null
                    set wolves = null
                    set m_AinzW2[i] = m_AinzW2[MUI_AinzW2]
                    set MUI_AinzW2 = MUI_AinzW2 - 1
                    if MUI_AinzW2 == -1 then
                        call AinzTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AinzW2_Start takes unit NewC, unit NewTeleportUnit, unit NewTd returns nothing
            local thistype this = thistype.create()
            local group wolves = LoadGroupHandle(hs, GetHandleId(NewC), StringHash("knight group"))
            local unit teleportUnit = NewTeleportUnit
            local real near = 0.00
            local real cur
            set c = NewC
            set td = NewTd
            if teleportUnit == null or GetWidgetLife(teleportUnit) <= 0.405 then
                set teleportUnit = c
            endif
            call AinzSwapPatch(c, AinzW_ID, 0)
            call AinzSwapPatch(c, AinzW2_ID, 0)
            set r = 0
            set r2 = 0
            set b = false
            set d = null
            set g = CreateGroup()
            set g2 = CreateGroup()
            set g3 = CreateGroup()
            if wolves != null then
                call GroupEnumUnitsOfPlayer(g, GetOwningPlayer(c), null)
                loop
                    set u = FirstOfGroup(g)
                    exitwhen u == null
                    if IsUnitInGroup(u, wolves) and GetUnitTypeId(u) == AinzW_Unit_ID and GetUnitState(u, UNIT_STATE_LIFE) > 0.405 then
                        set cur = SR2(c, u)
                        if d == null or cur < near then
                            set d = u
                            set near = cur
                        endif
                    endif
                    call GroupRemoveUnit(g, u)
                endloop
            endif
            if d == null then
                call DestroyGroup(g)
                call DestroyGroup(g2)
                call DestroyGroup(g3)
                set wolves = null
                set teleportUnit = null
                call deallocate(this)
                return
            endif
            set level = GetUnitAbilityLevel(c, AinzW_ID)
            set dmg = GetHeroInt(c, true) * (AinzW2_DamageIntBase + (AinzW2_DamageIntStep * GetUnitAbilityLevel(c, AinzW_ID)))
            set dmg = dmg + AinzW2_Damage2StaticBase + (AinzW2_Damage2StaticStep * (GetUnitAbilityLevel(c, AinzW_ID) - 1))
            set a = GAngle(teleportUnit, td)
            set distance = 0.00
            call PauseUnit(d, true)
            call UnitAddAbility(d, 'Avul')

            call MakeSound("war3mapimported\\Hero_Ainz_W2")
            call MakeSound("war3mapimported\\Hero_Ainz_W6")
            call PosUnit(d, GetUnitX(teleportUnit) + 180.00 * Cos(a), GetUnitY(teleportUnit) + 180.00 * Sin(a))
            call EffectSpawn2("war3mapImported\\wos_raidenei-4.mdl", GetUnitX(d), GetUnitY(d), a * bj_RADTODEG, 2, 1.5, 0, 0.3)
            call BlzSetUnitFacingEx(d, a * bj_RADTODEG)
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", GetUnitX(d), GetUnitY(d), a * bj_RADTODEG, 1, 1.25, 0))
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_cf1.mdl", GetUnitX(d), GetUnitY(d), a * bj_RADTODEG, 1, 1.25, 0))
            call UnitAddAbility(c, AinzW3_ID)
            call SetUnitAbilityLevel(c, AinzW3_ID, GetUnitAbilityLevel(c, AinzW_ID))
            call SetUnitTimeScale(d, 0.2)
            call SetUnitAnimationByIndex(d, 1)
            if LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 0 then
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), AinzW2_ID, false)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), AinzW3_ID, true)
                call BlzStartUnitAbilityCooldown(c, AinzW3_ID, 1.5)
            endif
            call SaveInteger(hs, GetHandleId(c), StringHash("AinzW W3 ready"), 1)
            call SaveInteger(hs, GetHandleId(c), StringHash("AinzW timer pause"), 1)
            set MUI_AinzW2 = MUI_AinzW2 + 1
            set m_AinzW2[MUI_AinzW2] = this
            if MUI_AinzW2 == 0 then
                call AinzTimer03Acquire()
            endif
            set wolves = null
            set teleportUnit = null
            call Ainz_RestoreOrder(NewC, -1)
        endmethod

        public static method Loop_AinzW3 takes nothing returns nothing
            local integer this
            local integer i = 0
            local integer k
            local integer alive
            local group wolves
            local real wallMove
            loop
                exitwhen i > MUI_AinzW3
                set this = m_AinzW3[i]
                set alive = 0
                if SpellBoolCaster(c) and distance < AinzW_KnightRunRange then
                    set r = r + 0.03
                    if not b and r >= 0.30 then
                        set b = true
                    endif
                    if b then
                        set r2 = r2 + 0.03
                        set r3 = r3 + 0.03
                        set k = 0
                        loop
                            exitwhen k == count
                            if dd[k] != null and GetUnitState(dd[k], UNIT_STATE_LIFE) > 0.405 then
                                set alive = alive + 1
                                set wallMove = AinzW_KnightSpeed
                                if wallMove > 0.00 then
                                    call MoveUnit3(dd[k], wallMove, a)
                                endif
                                if r2 >= 0.06 then
                                    call DecorRemove(c, GetUnitX(dd[k]), GetUnitY(dd[k]), AinzW_KnightHitAoe, AinzW3_DecorDamage)
                                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_cf1.mdl", GetUnitX(dd[k]) + 1 * Cos(a), GetUnitY(dd[k]) + 1 * Sin(a), GetRandomReal(0, 359), 1, 1.25, 0))
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_DanGe_Wid_ChongFengQiLiu.mdl", GetUnitX(dd[k]) + 300 * Cos(a), GetUnitY(dd[k]) + 300 * Sin(a), a * bj_RADTODEG, 1.5, 1.95, 0, 255, 255, 255, 125))
                                endif
                                if r3 >= 0.12 then
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(dd[k]) + 1 * Cos(a), GetUnitY(dd[k]) + 1 * Sin(a), a * bj_RADTODEG, 3, 2.25, 1, 255, 255, 255, 125))
                                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", GetUnitX(dd[k]) + 1 * Cos(a), GetUnitY(dd[k]) + 1 * Sin(a), GetRandomReal(0, 359), 1, 1.25, 0))
                                endif
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, GetUnitX(dd[k]), GetUnitY(dd[k]), AinzW_KnightHitAoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                        if not IsUnitInGroup(u, g2) then
                                            call GroupAddUnit(g2, u)
                                            call dmgphys(c, u, dmg)
                                        endif
                                        set wallMove = UnitMoveWall.GetMoveDistance(dd[k], GetUnitX(dd[k]), GetUnitY(dd[k]), a, AinzW_KnightSpeed)
                                        if wallMove < AinzW_KnightSpeed then
                                            if not IsUnitInGroup(u, g3) then
                                                call GroupAddUnit(g3, u)
                                                call dmgmag(c, u, GetHeroInt(c, true) * AinzE_WallHitDamageInt)
                                                call StunUnit(c, u, AinzE_WallHitStun)
                                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 0.75, 1.35, 0))
                                            endif
                                            if wallMove > 0.00 then
                                                call MoveUnit3(u, wallMove, a)
                                            endif
                                        else
                                            call MoveUnit3(u, AinzW_KnightSpeed, a)
                                        endif
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                            endif
                            set k = k + 1
                        endloop

                        if r2 >= 0.06 then
                            set r2 = 0
                        endif
                        if r3 >= 0.12 then
                            set r3 = 0
                        endif
                        set distance = distance + AinzW_KnightSpeed
                    endif
                endif

                if not SpellBoolCaster(c) or (b and (distance >= AinzW_KnightRunRange or alive == 0)) then
                    call AinzFinishSwap(c, AinzW2_ID)
                    set wolves = LoadGroupHandle(hs, GetHandleId(c), StringHash("knight group"))
                    set k = 0
                    loop
                        exitwhen k == count
                        if dd[k] != null and GetUnitState(dd[k], UNIT_STATE_LIFE) > 0.405 then
                            call KillUnit(dd[k])
                            call EffectSpawn2("war3mapImported\\wos_raidenei-4.mdl", GetUnitX(dd[k]), GetUnitY(dd[k]), a * bj_RADTODEG, 2, 1.5, 0, 0.3)
                            call ColorDummy3(dd[k], 0, 255, 255, 255, 0.3)
                        endif
                        if wolves != null and dd[k] != null then
                            call GroupRemoveUnit(wolves, dd[k])
                        endif
                        set dd[k] = null
                        set k = k + 1
                    endloop
                    call SaveInteger(hs, GetHandleId(c), StringHash("AinzW timer pause"), 0)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    call DestroyGroup(g3)
                    set c = null
                    set g = null
                    set g2 = null
                    set g3 = null
                    set wolves = null
                    set m_AinzW3[i] = m_AinzW3[MUI_AinzW3]
                    set MUI_AinzW3 = MUI_AinzW3 - 1
                    if MUI_AinzW3 == -1 then
                        call AinzTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AinzW3_Start takes unit NewC, real tx, real ty returns nothing
            local thistype this = thistype.create()
            local group wolves = LoadGroupHandle(hs, GetHandleId(NewC), StringHash("knight group"))
            local real cur
            local real side
            local integer k = 0
            set c = NewC
            call AinzSwapPatch(c, AinzW_ID, 0)
            call AinzSwapPatch(c, AinzW2_ID, 0)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set g3 = CreateGroup()
            set dd[0] = null
            set dd[1] = null
            set dd[2] = null
            if wolves != null then
                call GroupEnumUnitsOfPlayer(g, GetOwningPlayer(c), null)
                loop
                    set u = FirstOfGroup(g)
                    exitwhen u == null
                    if IsUnitInGroup(u, wolves) and GetUnitTypeId(u) == AinzW_Unit_ID and GetUnitState(u, UNIT_STATE_LIFE) > 0.405 then
                        set cur = SR2(c, u)
                        if dd[0] == null or cur < SR2(c, dd[0]) then
                            set dd[2] = dd[1]
                            set dd[1] = dd[0]
                            set dd[0] = u
                        elseif dd[1] == null or cur < SR2(c, dd[1]) then
                            set dd[2] = dd[1]
                            set dd[1] = u
                        elseif dd[2] == null or cur < SR2(c, dd[2]) then
                            set dd[2] = u
                        endif
                    endif
                    call GroupRemoveUnit(g, u)
                endloop
            endif
            if dd[0] == null then
                call DestroyGroup(g)
                call DestroyGroup(g2)
                call DestroyGroup(g3)
                call deallocate(this)
                return
            endif
            set count = 1
            if dd[1] != null then
                set count = 2
            endif
            if dd[2] != null then
                set count = 3
            endif
            set level = GetUnitAbilityLevel(c, AinzW_ID)
            if level < 1 then
                set level = GetUnitAbilityLevel(c, AinzW2_ID)
            endif
            if level < 1 then
                set level = GetUnitAbilityLevel(c, AinzW3_ID)
            endif
            if level < 1 then
                set level = 1
            endif
            set dmg = GetHeroInt(c, true) * (AinzW2_DamageIntBase + (AinzW2_DamageIntStep * GetUnitAbilityLevel(c, AinzW_ID)))
            set dmg = dmg + AinzW2_Damage2StaticBase + (AinzW2_Damage2StaticStep * (GetUnitAbilityLevel(c, AinzW_ID) - 1))
            set a = GAngle2(c, tx, ty)
            set distance = 0.00
            set r = 0
            set r2 = 0
            set r3 = 0
            set b = false
            call MakeSound("war3mapimported\\Hero_Ainz_W3")
            call MakeSound("war3mapimported\\Hero_Ainz_W7")
            loop
                exitwhen k == count
                set side = (I2R(k) - I2R(count - 1) * 0.5) * 140.00
                call PauseUnit(dd[k], true)
                call UnitAddAbility(dd[k], 'Avul')
                call PosUnit(dd[k], GetUnitX(c) + 180.00 * Cos(a) + side * Cos(a + bj_PI * 0.5), GetUnitY(c) + 180.00 * Sin(a) + side * Sin(a + bj_PI * 0.5))
                call EffectSpawn2("war3mapImported\\wos_raidenei-4.mdl", GetUnitX(dd[k]), GetUnitY(dd[k]), a * bj_RADTODEG, 2, 1.5, 0, 0.3)
                call BlzSetUnitFacingEx(dd[k], a * bj_RADTODEG)
                call SetUnitAnimationByIndex(dd[k], 1)
                call SetUnitTimeScale(dd[k], 0.5)
                call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", GetUnitX(dd[k]), GetUnitY(dd[k]), a * bj_RADTODEG, 1, 1.25, 0))
                call DestroyEffect(EffectSpawn("war3mapimported\\wos_cf1.mdl", GetUnitX(dd[k]), GetUnitY(dd[k]), a * bj_RADTODEG, 1, 1.25, 0))
                set k = k + 1
            endloop
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), AinzW3_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), AinzW2_ID, true)
            call SaveInteger(hs, GetHandleId(c), StringHash("AinzW W3 ready"), 0)
            call BlzStartUnitAbilityCooldown(c, AinzW3_ID, 1)
            call SaveInteger(hs, GetHandleId(c), StringHash("AinzW timer pause"), 1)
            set MUI_AinzW3 = MUI_AinzW3 + 1
            set m_AinzW3[MUI_AinzW3] = this
            if MUI_AinzW3 == 0 then
                call AinzTimer03Acquire()
            endif
            call Ainz_RestoreOrder(NewC, -1)
        endmethod

        public static method Loop_AinzW takes nothing returns nothing
            local integer this
            local integer i = 0
            local real x1 = 0
            local real y1 = 0
            local real kek1 = 0
            local real kek2 = 0
            local integer hp 
            loop
                exitwhen i > MUI_AinzW
                set this = m_AinzW[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                    if LoadInteger(hs, GetHandleId(c), StringHash("AinzW timer pause")) == 0 then
                        set r = r + 0.03
                    endif
                    set r = S2R(R2SW(r, 0, 3))

                    if r == 0.03 then
                        set k = 0
                        loop
                            exitwhen k == count
                            set x1 = GetUnitX(c) + 375.00 * Cos((72.00 * k) * bj_DEGTORAD)
                            set y1 = GetUnitY(c) + 375.00 * Sin((72.00 * k) * bj_DEGTORAD)
                            set dd[k] = CreateUnit(GetOwningPlayer(c), AinzW_Unit_ID, x1, y1, 72.00 * k)
                            set hp = AinzW_SummonHpBase + (AinzW_SummonHpStep * (GetUnitAbilityLevel(c, AinzW_ID) - 1))
                            call BlzSetUnitMaxHP(dd[k], hp)
                            call SetHpCurrent(dd[k], 999999)            
                            call UnitAddAbility(dd[k], 'A0FZ')
                            call SetUnitAbilityLevel(dd[k], 'A0FZ', GetUnitAbilityLevel(c, AinzW_ID))
                            call SaveUnitHandle(hs, GetHandleId(dd[k]), StringHash("AinzW caster"), c)
                            call TriggerRegisterUnitEvent(knightAcquireTrig, dd[k], EVENT_UNIT_ACQUIRED_TARGET)
                            call TriggerRegisterUnitEvent(knightDamageTrig, dd[k], EVENT_UNIT_DAMAGED)
                            call GroupAddUnit(g2, dd[k])
                            call SetScale(dd[k], 1.35)
                            call SetUnitVertexColor(dd[k], 255, 255, 255, 0)
                            call ColorDummy4(dd[k], 0, 255, 255, 255, 0.45)
                            call EffectSpawn2("war3mapImported\\wos_raidenei-4.mdl", x1, y1, a * bj_RADTODEG, 2, 1.5, 0, 0.3)
                            set k = k + 1
                        endloop

                        set r4 = 10
                        set r5 = 0
                        set kek1 = 0.0375
                        if frame1_pas1[check2] == null then
                            set frame1_pas1[check2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                            call BlzFrameSetAbsPoint(frame1_pas1[check2], FRAMEPOINT_CENTER, 0.055, 0.18 + kek1)
                            call BlzFrameSetSize(frame1_pas1[check2], 0.135, 0.035)
                            call BlzFrameSetTexture(frame1_pas1[check2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                            call BlzFrameSetVisible(frame1_pas1[check2], false)
                            if GetLocalPlayer() == GetOwningPlayer(c) then
                                call BlzFrameSetVisible(frame1_pas1[check2], true)
                            endif
                            set frame1_pas2[check2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame1_pas1[check2], 0, 0)
                            call BlzFrameSetAbsPoint(frame1_pas2[check2], FRAMEPOINT_CENTER, 0.07, 0.185 + kek1)
                            call BlzFrameSetSize(frame1_pas2[check2], 0.1, 0.019)
                            set frame1_pas3[check2] = BlzCreateFrameByType("STATUSBAR", "", frame1_pas1[check2], "", 0)
                            call BlzFrameSetSize(frame1_pas3[check2], 0.1, 0.035)
                            call BlzFrameSetScale(frame1_pas3[check2], 0.5)
                            call BlzFrameSetModel(frame1_pas3[check2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                            call BlzFrameSetAbsPoint(frame1_pas3[check2], FRAMEPOINT_CENTER, 0.05, 0.175 + kek1)
                            call BlzFrameSetMinMaxValue(frame1_pas3[check2], 0, rmax + 2)
                            call BlzFrameSetValue(frame1_pas3[check2], rmax)
                            set frame1_pas4[check2] = BlzCreateFrameByType("BACKDROP", "SS", frame1_pas1[check2], "", 0)
                            call BlzFrameSetAbsPoint(frame1_pas4[check2], FRAMEPOINT_CENTER, 0.005, 0.18 + kek1)
                            call BlzFrameSetSize(frame1_pas4[check2], 0.03, 0.03)
                            call BlzFrameSetTexture(frame1_pas4[check2], "ReplaceableTextures\\CommandButtons\\BTNHero_Ainz_W", 0, false)
                            set frame1_pas5[check2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1_pas1[check2], "", 0)
                            call BlzFrameSetAbsPoint(frame1_pas5[check2], FRAMEPOINT_CENTER, 0.07, 0.185 + kek1)
                            call BlzFrameSetText(frame1_pas5[check2], "|c00FFFF00" + "knights Time Left:" + "|r")
                            call BlzFrameSetScale(frame1_pas5[check2], 0.9)
                            set frame1_pas6[check2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1_pas1[check2], "", 0)
                            call BlzFrameSetAbsPoint(frame1_pas6[check2], FRAMEPOINT_CENTER, 0.07, 0.17 + kek1)
                            call BlzFrameSetText(frame1_pas6[check2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                            call BlzFrameSetScale(frame1_pas6[check2], 0.9)
                        else
                            if GetLocalPlayer() == GetOwningPlayer(c) then
                                call BlzFrameSetVisible(frame1_pas1[check2], true)
                            endif
                            call BlzFrameSetMinMaxValue(frame1_pas3[check2], 0, rmax + 2)
                            call BlzFrameSetValue(frame1_pas3[check2], rmax)
                        endif
                    endif
                    if r > 0.03 then
                        call BlzFrameSetValue(frame1_pas3[check2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame1_pas6[check2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)

                        call GroupClear(g3)
                        set k = 0
                        loop
                            set u = FirstOfGroup(g2)
                            exitwhen u == null
                            call GroupRemoveUnit(g2, u)
                            if GetUnitState(u, UNIT_STATE_LIFE) > 0.405 then
                                set k = k + 1
                                call GroupAddUnit(g3, u)
                            else
                                call RemoveSavedHandle(hs, GetHandleId(u), StringHash("AinzW caster"))
                                call RemoveSavedHandle(hs, GetHandleId(u), StringHash("AinzW target"))
                                call EffectSpawn2("war3mapImported\\wos_raidenei-4.mdl", GetUnitX(u), GetUnitY(u), a * bj_RADTODEG, 2, 1.5, 0, 0.3)
                                call ColorDummy3(u, 0, 255, 255, 255, 0.5)
                            endif
                        endloop
                        loop
                            set u = FirstOfGroup(g3)
                            exitwhen u == null
                            call GroupRemoveUnit(g3, u)
                            call GroupAddUnit(g2, u)
                        endloop
                        set u = null

                        if k < 3 and LoadInteger(hs, GetHandleId(c), StringHash("AinzW W3 ready")) == 1 then
                            if LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 0 then
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), AinzW3_ID, false)
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), AinzW2_ID, true)
                            endif
                            call SaveInteger(hs, GetHandleId(c), StringHash("AinzW W3 ready"), 0)
                        endif
                        if FirstOfGroup(g2) == null then
                            set r = 99999
                        endif
                        if r4 > 0.45 then
                            set r4 = 0
                            call BlzStartUnitAbilityCooldown(c, AinzW_ID, BlzGetAbilityCooldown(AinzW_ID, GetUnitAbilityLevel(c, AinzW_ID) - 1))
                            call GroupClear(g)
                            call GroupEnumUnitsOfPlayer(g, GetOwningPlayer(c), null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitInGroup(u, g2) and IsUnitPaused(u) == false then
                                    set kek1 = GetRandomReal(0, 359) * bj_DEGTORAD
                                    set kek2 = GetRandomReal(475, 1050)
                                    set td = LoadUnitHandle(hs, GetHandleId(u), StringHash("AinzW target"))
                                    if td != null and (not SpellBool(td) or not IsUnitEnemy(td, GetOwningPlayer(c))) then
                                        call RemoveSavedHandle(hs, GetHandleId(u), StringHash("AinzW target"))
                                        set td = null
                                    endif
                                    if td == null and GetUnitCurrentOrder(u) != OrderId("move") and LoadInteger(hs, GetHandleId(u), StringHash("stop move")) == 0 then
                                        call SaveInteger(hs, GetHandleId(u), StringHash("stop move"), 1)
                                        call MyFlush(GetHandleId(u), StringHash("stop move"), 0, 1.5)
                                        set x1 = GetUnitX(c) + kek2 * Cos(kek1)
                                        set y1 = GetUnitY(c) + kek2 * Sin(kek1)
                                    endif
                                    if SR2(c, u) > 1700 then
                                        set kek1 = GetRandomReal(0, 359) * bj_DEGTORAD
                                        set kek2 = GetRandomReal(375, 600)
                                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_raidenei-4.mdl", u, "chest"))
                                        call SetUnitPosition(u, GetUnitX(c) + kek2 * Cos(kek1), GetUnitY(c) + kek2 * Sin(kek1))
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("knight ult")) == 0 then
                                set r4 = r4 + 0.03
                            endif
                        endif
                        if r5 > 1.95 and LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("knight ult")) == 0 then
                            set r5 = 0
                            set k3 = 0
                            set k2 = 0
                            set k = 0
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                    set k = k + 1
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                            if k > 0 then
                                set k2 = GetRandomInt(1, k)
                                set k = 0
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null or k3 > 0
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                        set k = k + 1
                                        if k == k2 then
                                            set k3 = 1
                                            set td = FirstOfGroup(g2)
                                        endif
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set u = null
                            endif
                        else
                            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("knight ult")) == 0 then
                                set r5 = r5 + 0.03
                            endif
                        endif
                    endif
                else
                    call AinzFinishSwap(c, AinzW_ID)
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame1_pas1[check2], false)
                    endif

                    call MakeSound("war3mapimported\\Hero_Ainz_W4")
                    call SetPlayerAbilityAvailable(Player(check2), AinzW_ID, LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 0)
                    call SetPlayerAbilityAvailable(Player(check2), AinzW2_ID, false)
                    call SetPlayerAbilityAvailable(Player(check2), AinzW3_ID, false)
                    call SaveInteger(hs, GetHandleId(c), StringHash("AinzW W3 ready"), 0)
                    call UnitRemoveAbility(c, AinzW2_ID)
                    call UnitRemoveAbility(c, AinzW3_ID)
                    set k = 0
                    loop
                        exitwhen k == count
                        if dd[k] != null and GetWidgetLife(dd[k]) > 1 then
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_raidenei-4.mdl", dd[k], "chest"))
                            call RemoveSavedHandle(hs, GetHandleId(dd[k]), StringHash("AinzW caster"))
                            call RemoveSavedHandle(hs, GetHandleId(dd[k]), StringHash("AinzW target"))
                            call EffectSpawn2("war3mapImported\\wos_raidenei-4.mdl", GetUnitX(dd[k]), GetUnitY(dd[k]), a * bj_RADTODEG, 2, 1.5, 0, 0.3)
                            call ColorDummy3(dd[k], 0, 255, 255, 255, 0.5)
                        endif
                        set dd[k] = null
                        set k = k + 1
                    endloop
                    call SaveGroupHandle(hs, GetHandleId(c), StringHash("knight group"), null)
                    call DestroyGroup(g)
                    set g = null
                    call DestroyGroup(g2)
                    set g2 = null
                    call DestroyGroup(g3)
                    set g3 = null
                    set td = null
                    set c = null
                    set e2 = null
                    set m_AinzW[i] = m_AinzW[MUI_AinzW]
                    set MUI_AinzW = MUI_AinzW - 1
                    if MUI_AinzW == -1 then
                        call AinzTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AinzW_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_AinzW = MUI_AinzW + 1
            set m_AinzW[MUI_AinzW] = this
            set c = NewC
            call AinzSwapPatch(c, AinzW_ID, 0)
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set check = 0
            set a2 = 0
            set r2 = 10
            set check2 = GetPlayerId(GetOwningPlayer(c))
            set move = 85
            set g = CreateGroup()
            set g2 = CreateGroup()
            set g3 = CreateGroup()
            call SaveGroupHandle(hs, GetHandleId(c), StringHash("knight group"), g2)
            set aoe = 444
            set count = GetUnitAbilityLevel(c, AinzW_ID)
            call SetPlayerAbilityAvailable(Player(check2), AinzW_ID, false)
            call SetPlayerAbilityAvailable(Player(check2), AinzW2_ID, true)
            call UnitAddAbility(c, AinzW2_ID)
            call SetUnitAbilityLevel(c, AinzW2_ID, GetUnitAbilityLevel(c, AinzW_ID))
            set a = GetUnitFacing(c) * bj_DEGTORAD
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            call MakeSound("war3mapimported\\Hero_Ainz_W1")
            set rmax = AinzW_Duration
            call VisionTimed(GetOwningPlayer(c), x, y, 1800, 5)
            if MUI_AinzW == 0 then
                call AinzTimer03Acquire()
            endif
            call Ainz_RestoreOrder(NewC, -1)
        endmethod
    endstruct

    private struct AinzE_KS
        private static integer array m_AinzE
        private static integer MUI_AinzE = -1
        unit c
        unit td
        real x
        real y
        group g
        unit u
        real r2
        real dmg
        real aoe
        real r
        effect e
        real a
        real rmax
        integer blockerCount
        integer spellType
        boolean rootSeen
        effect array e2Effect[6]

        private method CreateE2Effects takes nothing returns nothing
            local integer index = 0
            local real angle
            local real effectX
            local real effectY
            local real xx
            local real yy
            loop
                exitwhen index >= 6
                set angle = 2.00 * bj_PI * I2R(index) / 6.00
                set effectX = GetUnitX(td) + AinzE2_EffectRadius * Cos(angle)
                set effectY = GetUnitY(td) + AinzE2_EffectRadius * Sin(angle)
                set xx = GetUnitX(td) + 350 * Cos(angle)
                set yy = GetUnitY(td) + 350 * Sin(angle)
                call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", xx, yy, GetRandomReal(0, 359), 0.5, 1.35, 0))
                call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Eat_DiBanZhaKai2.mdx", xx, yy, GetRandomReal(0, 359), 1.5, 0.8, 0))
                set e2Effect[index] = AddSpecialEffect("war3mapImported\\wos_ainze2.mdl", effectX, effectY)
                call BlzSetSpecialEffectYaw(e2Effect[index], angle + bj_PI)
                call ScaleEffDummy(e2Effect[index], 0.21, 0.01, AinzE2_EffectScale)
                call BlzSetSpecialEffectTimeScale(e2Effect[index], 0.85)
                call BlzSetSpecialEffectHeight(e2Effect[index], BlzGetLocalSpecialEffectZ(e2Effect[index]) + AinzE2_EffectHeight)
                set index = index + 1
            endloop
        endmethod

        private method DestroyE2Effects takes nothing returns nothing
            local integer index = 0
            loop
                exitwhen index >= 6
                call DestroyEffect(e2Effect[index])
                set e2Effect[index] = null
                set index = index + 1
            endloop
        endmethod

        private method IsInsideRectangle takes unit target returns boolean
            local real dx = GetUnitX(target) - x
            local real dy = GetUnitY(target) - y
            local real lengthAngle = a + bj_PI * 0.50
            local real localLength = dx * Cos(lengthAngle) + dy * Sin(lengthAngle)
            local real localWidth = dx * Cos(a) + dy * Sin(a)
            return localLength >= -AinzE_RectLength * 0.50 and localLength <= AinzE_RectLength * 0.50 and localWidth >= -AinzE_RectWidth * 0.50 and localWidth <= AinzE_RectWidth * 0.50
        endmethod

        private method CreatePathingBlockers takes nothing returns nothing
            local real maxSlope = 4.00 * AinzE_WallCurve / AinzE_WallLength
            local real projectedSpacing = AinzE_WallBlockerSpacing / SquareRoot(1.00 + maxSlope * maxSlope)
            local integer halfCount = R2I((AinzE_WallLength * 0.50) / projectedSpacing) + 1
            local integer index = -halfCount
            local real localLength
            local real actualSpacing = (AinzE_WallLength * 0.50) / I2R(halfCount)
            local real normalized
            local real curveOffset
            local real blockX
            local real blockY
            local real lengthAngle = a + bj_PI * 0.50
            local destructable d

            loop
                exitwhen index > halfCount
                set localLength = I2R(index) * actualSpacing
                set normalized = localLength / (AinzE_WallLength * 0.50)
                set curveOffset = AinzE_WallForwardOffset - AinzE_WallCurve * normalized * normalized
                set blockX = x + localLength * Cos(lengthAngle) + curveOffset * Cos(a)
                set blockY = y + localLength * Sin(lengthAngle) + curveOffset * Sin(a)
                set d = CreateDestructable(AinzE_PathBlockerId, blockX, blockY, a * bj_RADTODEG, 1.00, 0)
                call MyRemoveDest(d, 10)
                call SaveDestructableHandle(hs, this, blockerCount, d)
                set blockerCount = blockerCount + 1
                set index = index + 1
            endloop
            set d = null
        endmethod

        private method CreateWallEffects takes nothing returns nothing
            local integer index = 0
            local integer count = AinzE_WallEffectCount
            local real localLength
            local real normalized
            local real curveOffset
            local real effectX
            local real effectY
            local real lengthAngle = a + bj_PI * 0.50

            if count < 2 then
                set count = 2
            endif

            loop
                exitwhen index >= count
                set localLength = -AinzE_WallLength * 0.50 + I2R(index) * AinzE_WallLength / I2R(count - 1)
                set normalized = localLength / (AinzE_WallLength * 0.50)
                set curveOffset = AinzE_WallForwardOffset - AinzE_WallCurve * normalized * normalized
                set effectX = x + localLength * Cos(lengthAngle) + curveOffset * Cos(a)
                set effectY = y + localLength * Sin(lengthAngle) + curveOffset * Sin(a)
                call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", effectX, effectY, GetRandomReal(0, 359), 0.5, 1.25, 0))
                call DestroyEffect(EffectSpawn("war3mapimported\\wos_LD2209 (157).mdx", effectX, effectY, GetRandomReal(0.00, 359.00), 0.50, 1.50, 0.00))
                set index = index + 1
            endloop
        endmethod

        private method RemovePathingBlockers takes nothing returns nothing
            local integer index = 0
            local destructable d
            loop
                exitwhen index >= blockerCount
                set d = LoadDestructableHandle(hs, this, index)
                if d != null then
                    call RemoveDestructable(d)
                    call RemoveSavedHandle(hs, this, index)
                endif
                set index = index + 1
            endloop
            set blockerCount = 0
            set d = null
        endmethod

        public static method Loop_AinzE takes nothing returns nothing
            local integer this
            local integer i = 0
            local boolean active
            loop
                exitwhen i > MUI_AinzE
                set this = m_AinzE[i]
                set active = SpellBoolCaster(c)

                if spellType == 1 then
                    set active = active and r <= rmax
                    if active then
                        set r = RoundReal(r + 0.03, 3)
                        if r2 > 0.9 then
                            set r2 = 0
                            call DecorRemove(c, x, y, aoe, AinzE_DecorDamage)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsInsideRectangle(u) then
                                    call dmgphys(c, u, dmg)
                                    call SlowUnit(c, u, AinzE_Slow, 1)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                elseif spellType == 2 then
                    set r = RoundReal(r + 0.03, 3)
                    if not active or td == null or GetWidgetLife(td) <= 5.00 then
                        set active = false
                    elseif not rootSeen then
                        if GetUnitAbilityLevel(td, AinzE2_RootBuff_ID) > 0 then
                            set rootSeen = true
                            set r2 = 0.00
                            call dmgphys(c, td, dmg * AinzE2_DamagePeriod / AinzE2_RootDuration)
                        elseif r >= AinzE2_RootApplyGrace then
                            set active = false
                        endif
                    elseif GetUnitAbilityLevel(td, AinzE2_RootBuff_ID) == 0 then
                        set active = false
                    else
                        set r2 = r2 + 0.03
                        if r2 >= AinzE2_DamagePeriod then
                            set r2 = r2 - AinzE2_DamagePeriod
                            call dmgphys(c, td, dmg * (AinzE2_DamagePeriod / AinzE2_RootDuration))
                        endif
                    endif
                else
                    set active = false
                endif

                if not active then
                    if spellType == 1 then
                        call UnitMoveWall.Remove(this)
                    endif
                    call AinzFinishSwap(c, AinzE_ID)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), AinzE_ID, LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 0)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), AinzE2_ID, false)
                    call UnitRemoveAbility(c, AinzE2_ID)
                    call DestroyEffect(e)
                    call DestroyE2Effects()
                    call RemovePathingBlockers()
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set td = null
                    set e = null
                    set u = null
                    set m_AinzE[i] = m_AinzE[MUI_AinzE]
                    set MUI_AinzE = MUI_AinzE - 1
                    if MUI_AinzE == -1 then
                        call AinzTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AinzE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_AinzE = MUI_AinzE + 1
            set m_AinzE[MUI_AinzE] = this
            set c = NewC
            call AinzSwapPatch(c, AinzE_ID, 0)
            set td = null
            set x = NewX
            set y = NewY
            set a = GAngle2(c, x, y)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            set r = 0
            set r2 = 0
            set g = CreateGroup()
            set u = null
            set aoe = SquareRoot(AinzE_RectLength * AinzE_RectLength * 0.25 + AinzE_RectWidth * AinzE_RectWidth * 0.25)
            set dmg = GetHeroInt(c, true) * (AinzE_DamageIntBase + (AinzE_DamageIntStep * (GetUnitAbilityLevel(c, AinzE_ID) - 1)))
            set rmax = (AinzE_DurationBase + (AinzE_DurationStep * (GetUnitAbilityLevel(c, AinzE_ID) - 1)))
            set blockerCount = 0
            set spellType = 1
            set rootSeen = false
            call UnitMoveWall.Add(this, x, y, a, AinzE_WallLength, AinzE_WallCurve, AinzE_WallForwardOffset, AinzE_WallHitRadius, AinzE_WallCheckStep)
            call CreatePathingBlockers()
            call DecorRemove(c, x, y, aoe, AinzE_DecorDamage)
            call CreateWallEffects()
            call MakeSound("war3mapimported\\Hero_Ainz_E")
            call MakeSound("war3mapimported\\Hero_Ainz_E2")
            if GetUnitAbilityLevel(c, AinzE_ID) >= 5 then 
                call UnitAddAbility(c, AinzE2_ID)
                call SetUnitAbilityLevel(c, AinzE2_ID, GetUnitAbilityLevel(c, AinzE_ID))
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), AinzE_ID, false)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), AinzE2_ID, true)
            endif
            set e = EffectSpawn("war3mapImported\\wos_pack6 (153).mdl", x, y, a * bj_RADTODEG + 180, 1.25, 2, 1)
            if MUI_AinzE == 0 then
                call AinzTimer03Acquire()
            endif
            call Ainz_RestoreOrder(c, 7)
        endmethod

        public static method AinzE2_Start takes unit NewC, unit NewTarget returns nothing
            local thistype this
            if NewC == null or NewTarget == null or not SpellBool(NewTarget) or not IsUnitEnemy(NewTarget, GetOwningPlayer(NewC)) then
                return
            endif

            set this = thistype.create()
            set MUI_AinzE = MUI_AinzE + 1
            set m_AinzE[MUI_AinzE] = this
            set c = NewC
            call AinzSwapPatch(c, AinzE_ID, 0)
            set td = NewTarget
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set a = GAngle2(c, x, y)
            set r = 0.00
            set r2 = 0.00
            set rmax = AinzE2_RootDuration + AinzE2_RootApplyGrace
            set g = CreateGroup()
            set u = null
            set e = null
            set blockerCount = 0
            set spellType = 2
            set rootSeen = false

            call DecorRemove(c, x, y, 600, AinzE2_DecorDamage)
            call VisionTimed(GetOwningPlayer(c), x, y, 600, 2)
            set dmg = GetHeroInt(c, true) * (AinzE2_DamageIntBase + (AinzE2_DamageIntStep * (GetUnitAbilityLevel(c, AinzE_ID) - 1)))
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            call CreateE2Effects()
            call RootUnit(c, td, AinzE2_RootDuration)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_Ainz_E3")
            else
                call MakeSound("war3mapimported\\Hero_Ainz_E4")
            endif
            if MUI_AinzE == 0 then
                call AinzTimer03Acquire()
            endif
            call Ainz_RestoreOrder(NewC, -1)
        endmethod
    endstruct

    private struct AinzR_KS
        private static integer array m_AinzR
        private static integer MUI_AinzR = -1
        unit c
        unit td
        real x
        real y
        real r2
        group g
        group g2
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        effect e2
        effect e3
        effect e4
        real a
        integer check2
        real rmax

        public static method Loop_AinzR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AinzR
                set this = m_AinzR[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < AinzR_CastTime then
                        if AinzR_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif
                    endif
                    if r == AinzR_CastTime then
                        set r = 999
                        call MakeSound("war3mapimported\\Hero_Laxus_W2 2")
                        call VisionTimed(GetOwningPlayer(c), x, y, aoe, 1)
                        call DecorRemove(c, x, y, aoe, AinzR_DecorDamage)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3_x2.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (431232).mdl", x, y, GetRandomReal(0, 359), 1.15, 2.35, 15))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutblue2.mdl", x, y, GetRandomReal(0, 359), 1.25, 1.1, 1, 255, 255, 255, 255))
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_by_wood_effect_yubanmeiqin_lightning_zhenzhengdeluolei_blue.mdl", x, y, 1, 1, 3, 1), 0.6, 255, 255, 255, 0.35)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgmag(c, u, dmg)
                                if AinzR_Debuff > 0 then
                                    call ErzaPassive(c, u, AinzR_Debuff)
                                endif
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                else
                    if AinzR_IsInvul then
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set td = null
                    set u = null
                    set m_AinzR[i] = m_AinzR[MUI_AinzR]
                    set MUI_AinzR = MUI_AinzR - 1
                    if MUI_AinzR == -1 then
                        call AinzTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AinzR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_AinzR = MUI_AinzR + 1
            set m_AinzR[MUI_AinzR] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set move = 140
            if AinzR_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set r2 = 10
            set dmg = GetHeroInt(c, true) * (AinzR_DamageIntBase + AinzR_DamageIntStep * (GetUnitAbilityLevel(c, AinzR_ID) - 1))
            set check2 = 0
            set e = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "weapon")
            set a = GAngle2(c, x, y)
            set aoe = AinzR_DamageAoe
            set rmax = 2.4
            call SetUnitAnimationByIndex(c, 10)
            call SetUnitTimeScale(c, 0.5)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_Ainz_R")
            else
                call MakeSound("war3mapimported\\Hero_Ainz_R3")
            endif
            if MUI_AinzR == 0 then
                call AinzTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct AinzT_KS
        private static integer array m_AinzT
        private static integer MUI_AinzT = -1
        unit c
        integer k2
        private static framehandle array frame_pas1
        private static framehandle array frame_pas2
        private static framehandle array frame_pas3
        private static framehandle array frame_pas4
        private static framehandle array frame_pas5
        private static framehandle array frame_pas6
        real r
        group g
        unit u
        real r2
        real aoe
        effect e
        effect e2
        real x
        integer check
        real y
        real a
        real rmax

        private static method SetMode takes unit whichUnit, boolean enabled returns nothing
            local player p = GetOwningPlayer(whichUnit)
            if enabled then
                call UnitAddAbility(whichUnit, AinzQ3_ID)
                call UnitAddAbility(whichUnit, AinzW4_ID)
                call UnitAddAbility(whichUnit, AinzE3_ID)
                call UnitAddAbility(whichUnit, AinzR2_ID)
                call SetUnitAbilityLevel(whichUnit, AinzQ3_ID, GetUnitAbilityLevel(whichUnit, AinzQ_ID))
                call SetUnitAbilityLevel(whichUnit, AinzW4_ID, GetUnitAbilityLevel(whichUnit, AinzW_ID))
                call SetUnitAbilityLevel(whichUnit, AinzE3_ID, GetUnitAbilityLevel(whichUnit, AinzE_ID))
                call SetUnitAbilityLevel(whichUnit, AinzR2_ID, GetUnitAbilityLevel(whichUnit, AinzR_ID))
            else
                call AinzFlushPendingSwaps(whichUnit)
            endif
            call SetPlayerAbilityAvailable(p, AinzQ_ID, not enabled)
            call SetPlayerAbilityAvailable(p, AinzQ2_ID, false)
            call SetPlayerAbilityAvailable(p, AinzW_ID, not enabled)
            call SetPlayerAbilityAvailable(p, AinzW2_ID, false)
            call SetPlayerAbilityAvailable(p, AinzW3_ID, false)
            call SetPlayerAbilityAvailable(p, AinzE_ID, not enabled)
            call SetPlayerAbilityAvailable(p, AinzE2_ID, false)
            call SetPlayerAbilityAvailable(p, AinzR_ID, not enabled)
            call SetPlayerAbilityAvailable(p, AinzQ3_ID, enabled)
            call SetPlayerAbilityAvailable(p, AinzW4_ID, enabled)
            call SetPlayerAbilityAvailable(p, AinzE3_ID, enabled)
            call SetPlayerAbilityAvailable(p, AinzR2_ID, enabled)
            set p = null
        endmethod

        public static method Loop_AinzT takes nothing returns nothing
            local integer this
            local integer i = 0
            local real remaining
            local integer k = 0
            loop
                exitwhen i > MUI_AinzT
                set this = m_AinzT[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                    if check == 0 then
                        if r == 11.01 then
                            call MakeSound("war3mapimported\\Hero_Ainz_T4")
                        endif
                        if r < rmax then
                            set r = RoundReal(r + 0.03, 3)
                            if r == 0.03 then
                                call thistype.SetMode(c, true)
                            elseif r == 0.06 then
                                call thistype.SetMode(c, true)
                                call BlzStartUnitAbilityCooldown(c, AinzQ3_ID, BlzGetUnitAbilityCooldownRemaining(c, AinzQ_ID) - 10)
                                call BlzStartUnitAbilityCooldown(c, AinzW4_ID, BlzGetUnitAbilityCooldownRemaining(c, AinzW_ID) - 10)
                                call BlzStartUnitAbilityCooldown(c, AinzE3_ID, BlzGetUnitAbilityCooldownRemaining(c, AinzE_ID) - 10)
                                call BlzStartUnitAbilityCooldown(c, AinzR2_ID, BlzGetUnitAbilityCooldownRemaining(c, AinzR_ID) - 10)
                            endif
                            call thistype.SetMode(c, true)
                            if r2 > 0.96 and r < 11.5 then
                                set r2 = 0.00
                                call MakeSound("war3mapimported\\Hero_Ainz_T3")
                            else
                                set r2 = r2 + 0.03
                            endif
                            set a = GetUnitFacing(c) * bj_DEGTORAD
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            call BlzSetSpecialEffectPosition(e2, x, y, 5)
                            call BlzSetSpecialEffectPosition(e, x - 10 * Cos(a), y - 10 * Sin(a), 225)
                            call BlzSetSpecialEffectYaw(e, a)
                            set remaining = rmax - r
                            if remaining < 0 then
                                set remaining = 0
                            endif
                            call BlzFrameSetValue(frame_pas3[k2], remaining)
                            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(remaining, 0, 2) + "|r")
                        else
                            set check = 1
                            set r = 0
                            set rmax = 0.51
                            call SetUnitAnimationByIndex(c, 13)
                            call StartSpellUnit(c)
                        endif
                    elseif check == 1 then
                        call DebugUnit(c)
                        set r = RoundReal(r + 0.03, 3)
                        if r == 0.03 then
                            call AnimDummyEff(e, 0.24, 0)
                            call ScaleEffDummy(e, 0.3, 2.55, 1.6)
                            call ColorEffDummy3(e2, 0, 255, 255, 255, 0.21)
                            call BlzSetSpecialEffectTimeScale(e2, 3)
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            set k = 0
                            loop
                                exitwhen k == 14
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_dustwave222.mdx", x, y, GetRandomReal(0, 359), 1.15, k * 0.75, 1))
                                set k = k + 1
                            endloop
                            call DecorRemove(c, x, y, aoe, AinzT_DecorDamage)
                            call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_almagest1.mdl", x, y, GetRandomReal(0, 359), 0.75, 1, 1, 0.5, 1, 4.9))
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) then
                                    call BuffUnit01(c, u, AinzT_DebuffSpell_ID, "curse", 1)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        endif
                        if r == rmax then
                            set check = 2
                            set r = 0
                            set rmax = AinzT_AddDuration
                            call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax + 0.25)
                            call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Swap Ability Time:" + "|r")
                            call StopSpellUnit(c)
                        endif
                    elseif check == 2 then
                        if IsUnitPaused(c) == false then
                            set r = RoundReal(r + 0.03, 3)
                        endif
                        call thistype.SetMode(c, true)
                        set remaining = rmax - r
                        if remaining < 0 then
                            set remaining = 0
                        endif
                        call BlzFrameSetValue(frame_pas3[k2], remaining)
                        call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(remaining, 0, 2) + "|r")
                        set a = GetUnitFacing(c) * bj_DEGTORAD
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call BlzSetSpecialEffectPosition(e, x - 10 * Cos(a), y - 10 * Sin(a), 225)
                        call BlzSetSpecialEffectYaw(e, a)
                    endif
                else
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    if GetLocalPlayer() == Player(k2) then
                        call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif

                    call DestroyEffect(e)
                    call BlzSetSpecialEffectTimeScale(e, 3)
                    if check < 2 then                     
                        call ColorEffDummy3(e2, 0, 255, 255, 255, 0.21)
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("lvl4"), 0)
                    if check == 1 then
                        call StopSpellUnit(c)
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("mode t"), 0)
                    call thistype.SetMode(c, false)
                    call AAUniversalTooltips_SetUnitForm(c, 0)
                    call SpellStacksShowAndResume(c)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_AinzT[i] = m_AinzT[MUI_AinzT]
                    set MUI_AinzT = MUI_AinzT - 1
                    if MUI_AinzT == -1 then
                        call AinzTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AinzT_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_AinzT = MUI_AinzT + 1
            set m_AinzT[MUI_AinzT] = this
            set c = NewC
            set r = 0
            set r2 = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set rmax = AinzT_Duration
            set u = null
            set g = CreateGroup()
            call SpellStacksHideAndPause(c)
            call AinzSwapPatch(c, AinzQ_ID, 0)
            call AinzSwapPatch(c, AinzW_ID, 0)
            call AinzSwapPatch(c, AinzW2_ID, 0)
            call AinzSwapPatch(c, AinzE_ID, 0)
            call SaveInteger(hs, GetHandleId(c), StringHash("mode t"), 1)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AinzQ_ID)), 1)
            call thistype.SetMode(c, true)
            call AAUniversalTooltips_SetUnitForm(c, 1)
            set check = 0
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
                call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax)
                call BlzFrameSetValue(frame_pas3[k2], rmax)
                set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
                call BlzFrameSetSize(frame_pas4[k2], 0.0275, 0.0275)
                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Ainz_Icon2.blp", 0, false)
                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Goal All Life is Death:" + "|r")
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

            call MakeSound("war3mapimported\\Hero_Ainz_T")
            call MakeSound("war3mapimported\\Hero_Ainz_T2")
            set e = EffectSpawn("war3mapImported\\wos_ClockAinz.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 0.95, 2.55, 150)
            set e2 = EffectSpawnScale("war3mapImported\\wos_clockwisetimer3.mdl", GetUnitX(c), GetUnitY(c), 0, 0.97, 0.01, 5, 0.45, 0.01, 7.5)
            call BlzPlaySpecialEffect(e2, ANIM_TYPE_STAND)
            call BlzSetSpecialEffectAlpha(e2, 90)
            call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Ainz_T.blp", 0, false)
            set aoe = 1600

            if MUI_AinzT == 0 then
                call AinzTimer03Acquire()
            endif
            call Ainz_RestoreOrder(NewC, 14)
        endmethod
    endstruct

    private struct AinzTQ_KS
        private static integer array m_AinzTQ
        private static integer MUI_AinzTQ = -1
        unit c
        unit td
        player p
        group g
        group g2
        group g3
        effect e
        effect e2
        real x
        real y
        real a
        real a2
        real a3
        real r
        real r2
        real r3
        real move
        real dmg
        real dmg2
        integer check
        integer check2
        integer check3

        public static method Loop_AinzTQ takes nothing returns nothing
            local integer this
            local integer i = 0
            local unit u
            local unit td2
            local real x1
            local real y1
            local real rr1
            local real rr2
            local real cur
            local real score
            local boolean findTarget
            local boolean dealDamage
            loop
                exitwhen i > MUI_AinzTQ
                set this = m_AinzTQ[i]
                set td2 = null
                set findTarget = false
                set dealDamage = false

                if check2 == 0 then
                    set r = RoundReal(r + 0.03, 2)
                    if r >= AinzTQ_CastTime then
                        set r = 0
                        call DestroyEffect(e2)
                        set e2 = null
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        if td != null and SpellBool(td) and IsUnitEnemy(td, p) then
                            set a = Atan2(GetUnitY(td) - y, GetUnitX(td) - x)
                        else
                            set a = GetUnitFacing(c) * bj_DEGTORAD
                        endif
                        set x = x + AinzTQ_StartOffset * Cos(a + a2)
                        set y = y + AinzTQ_StartOffset * Sin(a + a2)
                        set e = EffectSpawnScale("war3mapImported\\wos_dragonhead.mdl", x, y, a * bj_RADTODEG, 1, 1, AinzTQ_Height, 0.3, 0.01, 6)
                        set r2 = AinzTQ_DamagePeriod
                        set check2 = 1
                    endif
                endif

                if check2 == 1 then
                    if td == null then
                        set findTarget = true
                    elseif not SpellBool(td) or not IsUnitEnemy(td, p) then
                        call GroupAddUnit(g2, td)
                        set findTarget = true
                    else
                        set x1 = GetUnitX(td)
                        set y1 = GetUnitY(td)
                        set a = Atan2(y1 - y, x1 - x)
                        set rr1 = (x1 - x) * (x1 - x) + (y1 - y) * (y1 - y)
                        if rr1 <= (AinzTQ_HitRange + move) * (AinzTQ_HitRange + move) then
                            set x = x1
                            set y = y1
                            if e != null then
                                call BlzSetSpecialEffectPosition(e, x, y, AinzTQ_Height)
                                call BlzSetSpecialEffectYaw(e, a)
                            endif
                            call GroupAddUnit(g2, td)
                            set dealDamage = true
                            set findTarget = true
                        elseif rr1 > 0.00 then
                            if check == 0 or AinzTQ_SideApproachOnBounce then
                                set a3 = a + a2
                            else
                                set a3 = a
                            endif
                            set x = x + move * Cos(a3)
                            set y = y + move * Sin(a3)
                            if e != null then
                                call BlzSetSpecialEffectPosition(e, x, y, AinzTQ_Height)
                                call BlzSetSpecialEffectYaw(e, a)
                            endif
                        endif
                    endif

                    set r2 = RoundReal(r2 + 0.03, 2)
                    if r2 >= AinzTQ_DamagePeriod then
                        set r2 = 0
                        set dealDamage = true
                    endif

                    if dealDamage then
                        call GroupClear(AinzTQEnumGroup)
                        call GroupEnumUnitsInRange(AinzTQEnumGroup, x, y, AinzTQ_DamageAoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(AinzTQEnumGroup)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, p) and not IsUnitInGroup(u, g) then
                                call GroupAddUnit(g, u)
                                call dmgmag(c, u, dmg)
                            endif
                            call GroupRemoveUnit(AinzTQEnumGroup, u)
                        endloop
                    endif

                    if findTarget then
                        if check >= AinzTQ_MaxChain then
                            set check2 = 2
                        else
                            set rr1 = AinzTQ_SearchAoe * AinzTQ_SearchAoe * 8.00 + 1.00
                            call GroupClear(AinzTQEnumGroup)
                            call GroupEnumUnitsInRange(AinzTQEnumGroup, x, y, AinzTQ_SearchAoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(AinzTQEnumGroup)
                                exitwhen u == null
                                if u != td and SpellBool(u) and IsUnitEnemy(u, p) and not IsUnitInGroup(u, g2) then
                                    set cur = (GetUnitX(u) - x) * (GetUnitX(u) - x) + (GetUnitY(u) - y) * (GetUnitY(u) - y)
                                    set score = cur
                                    if cur < AinzTQ_MinChainDistance * AinzTQ_MinChainDistance then
                                        set score = score + AinzTQ_SearchAoe * AinzTQ_SearchAoe * 4.00
                                    endif
                                    set rr2 = Cos(a) * (GetUnitY(u) - y) - Sin(a) * (GetUnitX(u) - x)
                                    if (a2 < 0.00 and rr2 >= 0.00) or (a2 > 0.00 and rr2 <= 0.00) then
                                        set score = score + AinzTQ_SearchAoe * AinzTQ_SearchAoe * 2.00
                                    endif

                                    if score < rr1 then
                                        set rr1 = score
                                        set td2 = u
                                    endif
                                endif
                                call GroupRemoveUnit(AinzTQEnumGroup, u)
                            endloop
                            if td2 == null then
                                set check2 = 2
                            else
                                call GroupAddUnit(g2, td2)
                                set td = td2
                                set a2 = -a2
                                set td2 = null
                                set check = check + 1
                            endif
                        endif
                    endif
                    if check2 == 1 then
                        set r3 = RoundReal(r3 + 0.03, 2)
                        if r3 >= AinzTQ_EffectPeriod then
                            set r3 = 0
                            call DecorRemove(c, x, y, 450, AinzTQ_DecorDamage)
                            set rr1 = GetRandomReal(25.00, 55.00)
                            set rr2 = GetRandomReal(0.00, 360.00) * bj_DEGTORAD
                            set x1 = x - rr1 * Cos(rr2)
                            set y1 = y - rr1 * Sin(rr2)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_SasukeYh-41.mdl", x, y, a * bj_RADTODEG, 1.1, 2.2, 1))
                            set rr1 = GetRandomReal(155.00, 175.00)
                            set rr2 = GetRandomReal(0.00, 360.00) * bj_DEGTORAD
                            set x1 = x + rr1 * Cos(rr2)
                            set y1 = y + rr1 * Sin(rr2)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x1, y1, a * bj_RADTODEG, 0.55, 1.5, 155))
                        endif
                    endif
                endif

                if check2 == 2 then
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    set e = null
                    set e2 = null
                    call VisionTimed(p, x, y, AinzTQ_DamageAoe2, 1)
                    call DecorRemove(c, x, y, AinzTQ_DamageAoe2, AinzTQ_DecorDamage)
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3_x2.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (431232).mdl", x, y, GetRandomReal(0, 359), 1.15, 2.35, 15))
                    call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutblue2.mdl", x, y, GetRandomReal(0, 359), 1.25, 1.1, 1, 255, 255, 255, 255))
                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_by_wood_effect_yubanmeiqin_lightning_zhenzhengdeluolei_blue.mdl", x, y, 1, 1, 3, 1), 0.6, 255, 255, 255, 0.35)

                    call GroupClear(AinzTQEnumGroup)
                    call GroupEnumUnitsInRange(AinzTQEnumGroup, x, y, AinzTQ_DamageAoe2, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(AinzTQEnumGroup)
                        exitwhen u == null
                        if SpellBool(u) and IsUnitEnemy(u, p) and not IsUnitInGroup(u, g) then
                            call GroupAddUnit(g, u)
                            call dmgmag(c, u, dmg)
                        endif
                        call GroupRemoveUnit(AinzTQEnumGroup, u)
                    endloop

                    set check3 = LoadInteger(hs, GetHandleId(g), StringHash("AinzTQ users")) - 1
                    if check3 <= 0 then
                        call FlushChildHashtable(hs, GetHandleId(g))
                        call DestroyGroup(g)
                        call DestroyGroup(g2)
                        call DestroyGroup(g3)
                    else
                        call SaveInteger(hs, GetHandleId(g), StringHash("AinzTQ users"), check3)
                    endif
                    set g = null
                    set g2 = null
                    set g3 = null
                    set c = null
                    set td = null
                    set p = null
                    set m_AinzTQ[i] = m_AinzTQ[MUI_AinzTQ]
                    set m_AinzTQ[MUI_AinzTQ] = 0
                    set MUI_AinzTQ = MUI_AinzTQ - 1
                    if MUI_AinzTQ == -1 then
                        call AinzTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
            set u = null
            set td2 = null
        endmethod

        public static method AinzTQ_Start takes unit NewC, unit NewTd returns nothing
            local thistype this
            local integer k = 0
            local unit u
            local unit td2
            local unit startTd
            local player p2
            local group g4
            local group g5
            local group g6
            local real x1
            local real y1
            local real rr1
            local real cur
            if NewC == null then
                return
            endif

            set p2 = GetOwningPlayer(NewC)
            set td2 = null
            if NewTd != null then
                set x1 = GetUnitX(NewTd)
                set y1 = GetUnitY(NewTd)
            else
                set x1 = GetUnitX(NewC)
                set y1 = GetUnitY(NewC)
            endif
            set rr1 = AinzTQ_SearchAoe * AinzTQ_SearchAoe + 1.00
            call GroupClear(AinzTQEnumGroup)
            call GroupEnumUnitsInRange(AinzTQEnumGroup, x1, y1, AinzTQ_SearchAoe, NoDecor_Cond)
            loop
                set u = FirstOfGroup(AinzTQEnumGroup)
                exitwhen u == null
                if u != NewTd and SpellBool(u) and IsUnitEnemy(u, p2) then
                    set cur = (GetUnitX(u) - x1) * (GetUnitX(u) - x1) + (GetUnitY(u) - y1) * (GetUnitY(u) - y1)
                    if cur < rr1 then
                        set rr1 = cur
                        set td2 = u
                    endif
                endif
                call GroupRemoveUnit(AinzTQEnumGroup, u)
            endloop

            call SetUnitAnimationByIndex(NewC, 11)
            call MakeSound("war3mapimported\\Hero_Ainz_TQ")
            call MakeSound("war3mapimported\\Hero_Ainz_R2")
            if NewTd != null and SpellBool(NewTd) and IsUnitEnemy(NewTd, p2) then
                call SetUnitFacing(NewC, Atan2(GetUnitY(NewTd) - GetUnitY(NewC), GetUnitX(NewTd) - GetUnitX(NewC)) * bj_RADTODEG)
            endif

            set g4 = CreateGroup()
            set g5 = CreateGroup()
            set g6 = CreateGroup()
            call SaveInteger(hs, GetHandleId(g4), StringHash("AinzTQ users"), 2)
            loop
                exitwhen k >= 2
                if k == 0 or td2 == null then
                    set startTd = NewTd
                else
                    set startTd = td2
                endif

                set this = thistype.create()
                set MUI_AinzTQ = MUI_AinzTQ + 1
                set m_AinzTQ[MUI_AinzTQ] = this
                set c = NewC
                set td = startTd
                set p = p2
                set x = GetUnitX(c)
                set y = GetUnitY(c)
                set a = 0
                set a3 = 0
                if k == 0 then
                    set a2 = AinzTQ_StartAngle * bj_DEGTORAD
                else
                    set a2 = -AinzTQ_StartAngle * bj_DEGTORAD
                endif
                set r = 0
                set r2 = 0
                set r3 = 0
                set move = AinzTQ_Move * 0.03
                set dmg = GetHeroInt(c, true) * AinzTQ_DamageIntBase
                set dmg2 = GetHeroInt(c, true) * AinzTQ_DamageIntBase2
                set check = 0
                set check2 = 0
                set check3 = 0
                set e = null
                set e2 = null
                set g = g4
                set g2 = g6
                set g3 = g5
                if startTd != null and SpellBool(startTd) and IsUnitEnemy(startTd, p) then
                    call GroupAddUnit(g2, startTd)
                endif
                if k == 0 then
                    set e2 = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "weapon")
                endif
                if MUI_AinzTQ == 0 then
                    call AinzTimer03Acquire()
                endif
                set k = k + 1
            endloop

            set u = null
            set td2 = null
            set startTd = null
            set p2 = null
            set g4 = null
            set g5 = null
            set g6 = null
        endmethod
    endstruct

    private struct AinzTW_KS
        private static integer array m_AinzTW
        private static integer MUI_AinzTW = -1
        unit c
        real x
        real y
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e3
        real a
        real rmax

        public static method Loop_AinzTW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AinzTW
                set this = m_AinzTW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if AinzTW_IsInvul then
                        call DebugUnit(c)
                    else
                        call DebugUnit2(c)
                    endif
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)

                    if r == 0.42 then
                        call EffectSpawn2("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiPurple.mdl", x, y, GetRandomReal(0, 359), 0.55, 13, 250, 0.35)
                        call EffectSpawn2("war3mapImported\\wos_jn_hero_aonengr.mdl", x, y, GetRandomReal(0, 359), 1, 1.35, 0, 0.3)
                        call EffectSpawn2("war3mapImported\\wos_jn_hero_aonengr.mdl", x, y, GetRandomReal(0, 359), 1, 1.35, 0, 0.3)
                        call EffectSpawn2("war3mapImported\\wos_jn_hero_aonengr.mdl", x, y, GetRandomReal(0, 359), 1, 1.35, 0, 0.3)
                        call MakeSound("war3mapimported\\Hero_Ainz_TW2")
                    endif
                    if r == rmax then
                        set r = 9999
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutpurple3.mdx", x, y, GetRandomReal(0, 359), 0.8, 1.9, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_kyaru_skill02purple.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.25, 0.5, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_kyaru_skill02purple.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.25, 0.85, 0))

                        call DecorRemove(c, x, y, aoe, AinzTW_DecorDamage)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgphys(c, u, dmg)
                                call SlowUnit(c, u, AinzTW_Slow, AinzTW_Duration)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    endif
                else
                    call AinzFinishSwap(c, AinzW_ID)
                    if AinzTW_IsInvul then
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    call SetUnitTimeScale(c, 1)
                    call DestroyEffect(e3)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set e3 = null
                    set u = null
                    set m_AinzTW[i] = m_AinzTW[MUI_AinzTW]
                    set MUI_AinzTW = MUI_AinzTW - 1
                    if MUI_AinzTW == -1 then
                        call AinzTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AinzTW_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_AinzTW = MUI_AinzTW + 1
            set m_AinzTW[MUI_AinzTW] = this
            set c = NewC
            call AinzSwapPatch(c, AinzW_ID, 0)
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            set r = 0
            if AinzTW_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set g = CreateGroup()
            set u = null
            set aoe = AinzTW_DamageAoe
            set dmg = GetHeroInt(c, true) * AinzTW_DamageIntBase
            set rmax = AinzTW_CastTime
            call SetUnitAnimationByIndex(c, 11)
            call SetUnitTimeScale(c, 0.85)
            call MakeSound("war3mapimported\\Hero_Ainz_TW")
            set e3 = AddSpecialEffectTarget("war3mapImported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiPurple.mdl", c, "weapon")
            if MUI_AinzTW == 0 then
                call AinzTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct AinzTE_KS
        private static timer t_AinzTE = CreateTimer()
        private static integer array m_AinzTE
        private static integer MUI_AinzTE = -1
        unit c
        unit u
        group g
        effect e
        real x
        real y
        real r
        real r2
        real r3
        real r4
        real rmax
        real aoe
        real dmg
        integer k

        public static method Loop_AinzTE takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr
            loop
                exitwhen i > MUI_AinzTE
                set this = m_AinzTE[i]
                if SpellBoolCaster(c) and r < rmax and k < AinzTE_PulseCount then
                    set r = RoundReal(r + 0.03, 3)
                    set r2 = RoundReal(r2 + 0.03, 3)
                    set r3 = RoundReal(r3 + 0.03, 3)
                    set r4 = RoundReal(r4 + 0.03, 3)

                    if r2 >= AinzTE_PulsePeriod then
                        set r2 = 0.00
                        set k = k + 1
                        call DecorRemove(c, x, y, aoe * 1.25, AinzTE_DecorDamage)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                set rr = SR3(u, x, y)
                                if rr > AinzTE_PullMaxRange then
                                    set rr = AinzTE_PullMaxRange
                                endif
                                call MUE(u, rr, AinzTE_PullDuration, GAngle2(u, x, y))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                    if r4 > 0.5 then
                        set r4 = 0
                        call EffectSpawn2("war3mapimported\\wos_Naruto_Effect_DaiTu_ShenWei.mdl", x, y, GetRandomReal(0, 359), 0.65, 3, 275, 0.5)
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_BY_Wood_Effect_Void_KaKaXi_ShenWei_FangChu.mdl", x, y, GetRandomReal(0, 359), 0.65, 2.75, 275, 255, 255, 255, 255))
                    else
                        set r4 = r4 + 0.03
                    endif
                    if r3 >= AinzTE_DamagePeriod then
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
                else
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set u = null
                    set e = null
                    set m_AinzTE[i] = m_AinzTE[MUI_AinzTE]
                    set m_AinzTE[MUI_AinzTE] = 0
                    set MUI_AinzTE = MUI_AinzTE - 1
                    if MUI_AinzTE == -1 then
                        call PauseTimer(t_AinzTE)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        public static method AinzTE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this
            local integer lvl
            local real a
            if NewC == null then
                return
            endif

            set this = thistype.create()
            set MUI_AinzTE = MUI_AinzTE + 1
            set m_AinzTE[MUI_AinzTE] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.00
            set r2 = AinzTE_PulsePeriod
            set r3 = AinzTE_DamagePeriod
            set rmax = AinzTE_Duration
            set aoe = AinzTE_DamageAoe
            set k = 0
            set g = CreateGroup()
            set u = null
            set lvl = GetUnitAbilityLevel(c, AinzE3_ID)
            if lvl < 1 then
                set lvl = 1
            endif
            set r4 = 10
            set dmg = GetHeroInt(c, true) * (AinzTE_DamageIntBase + AinzTE_DamageIntStep * (lvl - 1))
            set dmg = dmg / 5.0
            set a = GAngle2(c, x, y)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex(c, 10)
            call EffectSpawn2("war3mapImported\\wos_blackwhiteaura_3.mdx", x, y, 1, 2, 2, 1, 0.25)
            call ScaleEffDummy(e, 0.35, 0.01, 2.35)
            call VisionTimed(GetOwningPlayer(c), x, y, aoe, rmax)
            call MakeSound("war3mapimported\\Hero_Ainz_TE")
            call MakeSound("war3mapimported\\Hero_Ainz_TE2")
            if MUI_AinzTE == 0 then
                call TimerStart(t_AinzTE, 0.03, true, function thistype.Loop_AinzTE)
            endif
            call Ainz_RestoreOrder(NewC, -1)
        endmethod
    endstruct

    private struct AinzTR_KS
        private static integer array m_AinzTR
        private static integer MUI_AinzTR = -1
        unit c
        unit u
        group g
        group g2
        group g3
        effect e
        real x
        real y
        real scale
        real a
        real r
        real r2
        real r3
        real front
        real lastFront
        real dmg

        public static method Loop_AinzTR takes nothing returns nothing
            local integer this
            local integer i = 0
            local real dx
            local real dy
            local real forward
            local real side
            local real waveX
            local real waveY
            local real waveSide
            local real wallMove
            local boolean checkUnits
            loop
                exitwhen i > MUI_AinzTR
                set this = m_AinzTR[i]
                set checkUnits = false
                if SpellBoolCaster(c) and (front < AinzTR_MaxRange or r3 < 0.50) then
                    set r = RoundReal(r + 0.03, 3)
                    if r < AinzTR_CastTime then
                        if AinzTR_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif
                    endif
                    if r == 0.3 then
                        call MakeSound("war3mapimported\\Hero_Ainz_TR3")
                    endif
                    if r == AinzTR_CastTime then 
                        if AinzTR_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                    endif
                    if r > AinzTR_CastTime then
                        if front < AinzTR_MaxRange then
                            set r2 = r2 + 0.03
                            set lastFront = front
                            set front = front + AinzTR_GrowSpeed
                            if front > AinzTR_MaxRange then
                                set front = AinzTR_MaxRange
                            endif
                            set checkUnits = true

                            call BlzSetSpecialEffectScale(e, 0.10 + 1.50 * front / 2350.00)
                            if r2 >= AinzTR_EffectPeriod then
                                set r2 = 0.00
                                set waveX = x + (front - 200) * Cos(a)
                                set waveY = y + (front - 200) * Sin(a)
                                set waveSide = front * AinzTR_ConeWidth
                                set scale = scale + 0.2
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_cf2.mdl", waveX, waveY, a * bj_RADTODEG, 0.30, 1.5 * scale, 0))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_cf2.mdl", waveX + waveSide * Cos(a + bj_PI * 0.50), waveY + waveSide * Sin(a + bj_PI * 0.50), a * bj_RADTODEG, 0.30, 1.5 * scale, 0))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_cf2.mdl", waveX - waveSide * Cos(a + bj_PI * 0.50), waveY - waveSide * Sin(a + bj_PI * 0.50), a * bj_RADTODEG, 0.30, 1.5 * scale, 0))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_gnaden_air.mdx", waveX, waveY, a * bj_RADTODEG, 0.30, 3 * scale, 0))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_gnaden_air.mdx", waveX + waveSide * Cos(a + bj_PI * 0.50), waveY + waveSide * Sin(a + bj_PI * 0.50), a * bj_RADTODEG, 0.30, 3 * scale, 0))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_gnaden_air.mdx", waveX - waveSide * Cos(a + bj_PI * 0.50), waveY - waveSide * Sin(a + bj_PI * 0.50), a * bj_RADTODEG, 0.30, 3 * scale, 0))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_siwen2.mdx", waveX, waveY, a * bj_RADTODEG, 0.30, 2.25 * scale, 0))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_siwen2.mdx", waveX + waveSide * Cos(a + bj_PI * 0.50), waveY + waveSide * Sin(a + bj_PI * 0.50), a * bj_RADTODEG, 0.30, 2.25 * scale, 0))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_siwen2.mdx", waveX - waveSide * Cos(a + bj_PI * 0.50), waveY - waveSide * Sin(a + bj_PI * 0.50), a * bj_RADTODEG, 0.30, 2.25 * scale, 0))
                            endif
                            if front == AinzTR_MaxRange then
                                set r2 = 0.00
                            endif
                        else
                            set r3 = RoundReal(r3 + 0.03, 3)
                            set r2 = r2 + 0.03
                            if r2 >= AinzTR_EffectPeriod then
                                set r2 = 0.00
                                set lastFront = 0.00
                                set checkUnits = true
                            endif
                        endif

                        if checkUnits then
                            call DecorRemove(c, x, y, 800, AinzTR_DecorDamage)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, front + AinzTR_HitWidth, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                    set dx = GetUnitX(u) - x
                                    set dy = GetUnitY(u) - y
                                    set forward = dx * Cos(a) + dy * Sin(a)
                                    set side = dx * Cos(a + bj_PI * 0.50) + dy * Sin(a + bj_PI * 0.50)
                                    if side < 0.00 then
                                        set side = -side
                                    endif
                                    if forward >= lastFront - AinzTR_HitWidth and forward <= front + AinzTR_HitWidth and forward >= 0.00 and side <= forward * AinzTR_ConeWidth + AinzTR_HitWidth then
                                        call GroupAddUnit(g2, u)
                                        call dmgmag(c, u, dmg)
                                        set wallMove = UnitMoveWall.GetMoveDistance(u, GetUnitX(u), GetUnitY(u), a, AinzR_PushRange)
                                        if wallMove < AinzR_PushRange then
                                            if not IsUnitInGroup(u, g3) then
                                                call GroupAddUnit(g3, u)
                                                call dmgmag(c, u, GetHeroInt(c, true) * AinzE_WallHitDamageInt)
                                                call StunUnit(c, u, AinzE_WallHitStun)
                                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 1.00, 1.50, 0))
                                            endif
                                            if wallMove > 0.00 then
                                                call MUE(u, wallMove, AinzR_PushDuration, a)
                                            endif
                                        else
                                            call MUE(u, AinzR_PushRange, AinzR_PushDuration, a)
                                        endif
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        endif
                    endif
                else
                    call DestroyEffect(e)
                    call SetUnitTimeScale(c, 1.00)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    call DestroyGroup(g3)
                    if r < AinzTR_CastTime then 
                        if AinzTR_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                    endif
                    set c = null
                    set u = null
                    set e = null
                    set g = null
                    set g2 = null
                    set g3 = null
                    set m_AinzTR[i] = m_AinzTR[MUI_AinzTR]
                    set MUI_AinzTR = MUI_AinzTR - 1
                    if MUI_AinzTR == -1 then
                        call AinzTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AinzTR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, AinzR_ID)
            if level < 1 then
                set level = 1
            endif
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set a = GAngle2(c, NewX, NewY)
            set r = 0.00
            set r2 = 0.00
            set r3 = 0.00
            set front = AinzTR_StartRange
            set lastFront = 0.00
            set dmg = GetHeroInt(c, true) * (AinzTR_DamageIntBase + AinzTR_DamageIntStep * (level - 1))
            set g = CreateGroup()
            set g2 = CreateGroup()
            set g3 = CreateGroup()
            set u = null
            set e = AddSpecialEffect("war3mapImported\\droch (876).mdl", x + 250.00 * Cos(a), y + 250.00 * Sin(a))
            call BlzSetSpecialEffectYaw(e, a)
            call BlzSetSpecialEffectScale(e, 0.10)
            call BlzSetSpecialEffectTimeScale(e, 0.85)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            set scale = 0.5
            if AinzTR_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            call SetUnitAnimationByIndex(c, 10)
            call SetUnitTimeScale(c, 0.75)

            call MakeSound("war3mapimported\\Hero_Ainz_TR2")
            set MUI_AinzTR = MUI_AinzTR + 1
            set m_AinzTR[MUI_AinzTR] = this
            if MUI_AinzTR == 0 then
                call AinzTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct AinzF_KS
        private static integer array m_AinzF
        private static integer MUI_AinzF = -1
        unit c
        effect e
        effect e2
        real r
        real rmax
        integer phase

        private static method ClearBuffs takes unit whichUnit returns nothing
            call UnitRemoveAbility(whichUnit, AinzF_Buff1_ID)
            call UnitRemoveAbility(whichUnit, AinzF_Buff2_ID)
            call UnitRemoveAbility(whichUnit, AinzF_Buff3_ID)
            call UnitRemoveAbility(whichUnit, AinzF_Buff4_ID)
            call UnitRemoveAbility(whichUnit, AinzF_Buff5_ID)
            call UnitRemoveAbility(whichUnit, AinzF_Buff6_ID)
        endmethod

        private static method SetQ2Mode takes unit whichUnit, boolean enabled returns nothing
            if enabled then
                call AinzSwapPatch(whichUnit, AinzQ_ID, 0)
                call SwapAbility(whichUnit, AinzF_Q2Duration, AinzQ2_ID, AinzQ_ID)
                call SetUnitAbilityLevel(whichUnit, AinzQ2_ID, GetUnitAbilityLevel(whichUnit, AinzQ_ID))
                if LoadInteger(hs, GetHandleId(whichUnit), StringHash("mode t")) == 1 then
                    call SetPlayerAbilityAvailable(GetOwningPlayer(whichUnit), AinzQ_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(whichUnit), AinzQ2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(whichUnit), AinzQ3_ID, true)
                endif
            else
                if LoadInteger(hs, GetHandleId(whichUnit), StringHash("mode t")) == 0 then
                    call AinzFinishSwap(whichUnit, AinzQ_ID)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(whichUnit), AinzQ_ID, LoadInteger(hs, GetHandleId(whichUnit), StringHash("mode t")) == 0)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(whichUnit), AinzQ2_ID, false)
                    if LoadInteger(hs, GetHandleId(whichUnit), StringHash("mode t")) == 0 then
                        call SpellStacksShowAndResume(whichUnit)
                    endif
                endif
            endif
        endmethod

        public static method Loop_AinzF takes nothing returns nothing
            local integer this
            local integer i = 0
            local boolean remove
            loop
                exitwhen i > MUI_AinzF
                set this = m_AinzF[i]
                set remove = false
                if phase == 0 then
                    if SpellBoolCaster(c) and GetUnitCurrentOrder(c) == OrderId("magicdefense") then
                        set r = RoundReal(r + 0.03, 3)
                        if r == 0.30 then
                            call thistype.ClearBuffs(c)
                            call BuffUnit01(c, c, AinzF_BuffSpell_ID, "bloodlust", 2)
                        elseif r == 1.8 then
                            call SetUnitAnimationByIndex(c, 9)
                            call DestroyEffect(e)
                            set e = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_yellow_XuLi.mdx", c, "hand right")
                        elseif r == 2.10 then
                            call thistype.ClearBuffs(c)
                            call BuffUnit01(c, c, AinzF_BuffSpell_ID, "bloodlust", 3)
                        elseif r == 3.3 then
                            call SetUnitAnimationByIndex(c, 9)
                        elseif r == 3.99 then
                            call thistype.ClearBuffs(c)
                            call BuffUnit01(c, c, AinzF_BuffSpell_ID, "bloodlust", 4)
                        elseif r == 5.4 then
                            call SetUnitAnimationByIndex(c, 9)
                        elseif r == 5.79 then
                            call thistype.ClearBuffs(c)
                            call BuffUnit01(c, c, AinzF_BuffSpell_ID, "bloodlust", 5)
                        elseif r == 6.9 then
                            call SetUnitAnimationByIndex(c, 9)
                            call DestroyEffect(e)
                            set e = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiGreen.mdx", c, "hand right")
                        elseif r == 7.20 then                        
                            call thistype.ClearBuffs(c)
                            call BuffUnit01(c, c, AinzF_BuffSpell_ID, "bloodlust", 6)
                        elseif r == 8.7 then
                            call SetUnitAnimationByIndex(c, 9)
                        elseif r == 9.00 then
                            call thistype.ClearBuffs(c)
                            call BuffUnit01(c, c, AinzF_BuffSpell_ID, "bloodlust", 7)
                            call UnitAddAbility(c, AinzF_Stats_ID)
                            call MyRemoveAbility2(c, AinzF_Stats_ID, 1, AinzF_Buff6_ID)
                            call IssueImmediateOrder(c, "stop")
                        endif
                        if r > rmax then 
                            call IssueImmediateOrder(c, "stop")
                        endif
                    else
                        if r < 9 then                 
                            call StopSound(gg_snd_Hero_Ainz_F, false, false)
                        endif
                        call DestroyEffect(e)
                        set e = null
                        set e2 = null
                        call SetUnitTimeScale(c, 1.00)
                        call thistype.SetQ2Mode(c, true)
                        set phase = 1
                        set r = 0.00
                    endif
                elseif r < AinzF_Q2Duration then
                    set r = RoundReal(r + 0.03, 3)
                else
                    call thistype.SetQ2Mode(c, false)
                    set remove = true
                endif

                if remove then
                    set c = null
                    set m_AinzF[i] = m_AinzF[MUI_AinzF]
                    set MUI_AinzF = MUI_AinzF - 1
                    if MUI_AinzF == -1 then
                        call AinzTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AinzF_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set c = NewC
            set r = 0.00
            set phase = 0            
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AinzQ_ID)), 0)
            call SpellStacksHideAndPause(c)
            call SetUnitAnimationByIndex(c, 9)
            call SetUnitTimeScale(c, 1.10)
            call StopSound(gg_snd_Hero_Ainz_F, false, false)
            call StartSound(gg_snd_Hero_Ainz_F)
            if GetHeroLevel(c) >= 35 then 
                set rmax = 999
            elseif GetHeroLevel(c) >= 25 then
                set rmax = 5.82
            elseif GetHeroLevel(c) >= 12 then
                set rmax = 2.13
            endif
            call thistype.ClearBuffs(c)
            call BuffUnit01(c, c, AinzF_BuffSpell_ID, "bloodlust", 1)
            set e = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdx", c, "hand right")
            set MUI_AinzF = MUI_AinzF + 1
            set m_AinzF[MUI_AinzF] = this
            if MUI_AinzF == 0 then
                call AinzTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct AinzG_KS
        private static integer array m_AinzG
        private static integer MUI_AinzG = -1
        unit c
        unit u
        group g
        real r
        effect e
        effect e2
        effect e3
        real r2
        real x1
        real y1
        real dmg
        integer count

        public static method Loop_AinzG takes nothing returns nothing
            local integer this
            local integer i = 0
            local real x
            local integer k = 0
            local real y
            loop
                exitwhen i > MUI_AinzG
                set this = m_AinzG[i]
                if SpellBoolCaster(c) and count < AinzG_DamageCount and LoadInteger(hs,GetHandleId(c),StringHash("stop r"))== 0 then
                    set r = RoundReal(r + 0.03, 3)
                    if r < AinzG_PrepareTime then
                        if AinzG_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif
                        if r == 1.02 then  
                            call BlzPlaySpecialEffect(e, ANIM_TYPE_DEATH)
                            call BlzSetSpecialEffectTimeScale(e, 2)
                            call MakeSound("war3mapimported\\Hero_Ainz_G2")
                        endif                        
                        if r == 1.56 then  
                            call ScaleEffDummy(e, 0.15, 2.25, 1.45)
                        endif
                    elseif r == AinzG_PrepareTime then 
                        set x1 = GetUnitX(c)
                        set y1 = GetUnitY(c)
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        set e2 = EffectSpawnScale("war3mapImported\\wos_bluebeamfromair.mdl", x, y, 1, 1.4, 1, 0, 1.02, 1, 3.4)
                        set e3 = EffectSpawnScale("war3mapImported\\wos_bluebeamfromair.mdl", x, y, 1, 1.4, 1, 0, 1.02, 1, 5.4)
                        call BlzSetSpecialEffectTimeScale(e, 0.75)
                        call MakeSound("war3mapimported\\Hero_Ainz_G3")
                    elseif count == 0 or r2 >= AinzG_DamagePeriod then
                        set r2 = 0.00
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call BlzSetSpecialEffectPosition(e,x,y,0)
                        call BlzSetSpecialEffectPosition(e2,x,y,0)
                        call BlzSetSpecialEffectPosition(e3,x,y,0)
                        set k = 0
                        if count < AinzG_DamageCount - 1 then 
                            loop
                                exitwhen k == 4
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx", x, y, GetRandomReal(0, 359), 0.65, 6 + count + k * 0.1, 1, 255, 255, 255, 90))
                                set k = k + 1
                            endloop
                        endif
                        call DecorRemove(c, x, y, AinzG_Aoe, AinzG_DecorDamage)
                        call GroupEnumUnitsInRange(g, x, y, AinzG_Aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgmag(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set count = count + 1
                    else
                        set r2 = r2 + 0.03
                        call PosUnit(c, x1, y1)
                        if AinzG_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif
                    endif
                else
                    if AinzG_IsInvul then
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.15)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    call BlzSetSpecialEffectTimeScale(e2,1.5)
                    call BlzSetSpecialEffectTimeScale(e3,1.5)
                    call DestroyGroup(g)
                    call SaveInteger(hs,GetHandleId(c),StringHash("stop r"),0)
                    call SaveInteger(hs,GetHandleId(c),StringHash("cast r"),0)
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set u = null
                    set g = null
                    set m_AinzG[i] = m_AinzG[MUI_AinzG]
                    set MUI_AinzG = MUI_AinzG - 1
                    if MUI_AinzG == -1 then
                        call AinzTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AinzG_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, AinzG_ID)
            if level < 1 then
                set level = 1
            endif
            set c = NewC
            set u = null
            set g = CreateGroup()
            set r = 0.00
            set r2 = 0.00
            set count = 0
            set dmg = GetHeroInt(c, true) * (AinzG_DamageIntBase + AinzG_DamageIntStep * (level - 1))
            set dmg = dmg / 8.0
            if AinzG_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            call MakeSound("war3mapimported\\Hero_Ainz_G1")
            set e = EffectSpawn("war3mapImported\\wos_gatmofazhen.mdl", GetUnitX(c), GetUnitY(c), 0, 1.5, 1, 0)
            call BlzSetSpecialEffectAlpha(e, 0)
            call ColorEffDummy4(e, 0, 255, 255, 255, 0.51)
            call SaveInteger(hs,GetHandleId(c),StringHash("cast r"),1)
            call BlzSetSpecialEffectScale(e, 2.25)
            call SetUnitAnimationByIndex(c, 13)
            call SetUnitTimeScale(c, 0.55)
            set MUI_AinzG = MUI_AinzG + 1
            set m_AinzG[MUI_AinzG] = this
            if MUI_AinzG == 0 then
                call AinzTimer03Acquire()
            endif
        endmethod
    endstruct

    private function AinzTimer03Loop takes nothing returns nothing
        call AinzQ_KS.Loop_AinzQ()
        call AinzTQ_KS.Loop_AinzTQ()
        call AinzTW_KS.Loop_AinzTW()
        call AinzW_KS.Loop_AinzW()
        call AinzW_KS.Loop_AinzW2()
        call AinzW_KS.Loop_AinzW3()
        call AinzE_KS.Loop_AinzE()
        call AinzTR_KS.Loop_AinzTR()
        call AinzR_KS.Loop_AinzR()
        call AinzT_KS.Loop_AinzT()
        call AinzF_KS.Loop_AinzF()
        call AinzG_KS.Loop_AinzG()
    endfunction

    private function InitAinzSpells takes nothing returns nothing
        set AinzTimer03 = CreateTimer()
        set AinzTQEnumGroup = CreateGroup()
        set AinzTimer03Callback = function AinzTimer03Loop
        call AinzW_KS.InitknightEvents()
    endfunction

    function AinzQ_IsMinePositionFree takes real x, real y returns boolean
        return AinzQ_KS.IsMinePositionFree(x, y)
    endfunction

    function AinzQ2_IsMineRingFree takes real x, real y returns boolean
        return AinzQ_KS.IsMineRingFree(x, y)
    endfunction

    function AinzQ_Start takes unit c, real x, real y returns nothing
        if AinzQ_IsMinePositionFree(x, y) == true then
            call MyRemoveStack(c)
        endif
        call AinzQ_KS.AinzQ_Start(c, x, y)
    endfunction

    function AinzQ2_Start takes unit c, real x, real y returns nothing
        if AinzQ2_IsMineRingFree(x, y) == true then
            call MyRemoveStack(c)
        endif
        call AinzQ_KS.AinzQ2_Start(c, x, y)
    endfunction

    function AinzTQ_Start takes unit c, unit target returns nothing
        call AinzTQ_KS.AinzTQ_Start(c, target)
    endfunction

    function AinzW_Start takes unit c returns nothing
        call AinzW_KS.AinzW_Start(c)
    endfunction

    function AinzW2SaveCaster takes unit ainz, unit protectedUnit returns nothing
        if ainz == null or protectedUnit == null then
            return
        endif
        call SaveUnitHandle(hs, GetHandleId(protectedUnit), StringHash("AinzW2 ally caster"), ainz)
    endfunction

    function AinzW2_Start takes unit c, unit td returns nothing
        if IsUnitEnemy(td, GetOwningPlayer(c)) then 
            call AinzW_KS.AinzW2_Start(c, c, td)
        else
            call AinzW2SaveCaster(c, td)
            call BuffUnit01(c, td, AinzF_BuffSpell_ID, "bloodlust", 8)
        endif
    endfunction

    function AinzW2ClearCaster takes unit protectedUnit returns nothing
        if protectedUnit != null then
            call RemoveSavedHandle(hs, GetHandleId(protectedUnit), StringHash("AinzW2 ally caster"))
        endif
    endfunction

    function AinzW2Alternative_Start takes unit protectedUnit, unit attacker returns nothing
        local unit ainz

        if protectedUnit == null then
            return
        endif

        set ainz = LoadUnitHandle(hs, GetHandleId(protectedUnit), StringHash("AinzW2 ally caster"))
        call RemoveSavedHandle(hs, GetHandleId(protectedUnit), StringHash("AinzW2 ally caster"))

        if ainz != null and GetUnitTypeId(ainz) == Ainz_ID and GetWidgetLife(ainz) > 0.405 and attacker != null and GetWidgetLife(attacker) > 0.405 then
            call AinzW_KS.AinzW2_Start(ainz, protectedUnit, attacker)
        endif

        set ainz = null
        set attacker = null
    endfunction

    function AinzW3_Start takes unit c, real x, real y returns nothing
        call AinzW_KS.AinzW3_Start(c, x, y)
    endfunction

    function AinzE_Start takes unit c, real x, real y returns nothing
        call AinzE_KS.AinzE_Start(c, x, y)
    endfunction

    function AinzE2_Start takes unit c, unit td returns nothing
        call AinzE_KS.AinzE2_Start(c, td)
    endfunction

    function AinzR_Start takes unit c, real x, real y returns nothing
        call AinzR_KS.AinzR_Start(c, x, y)
    endfunction

    function AinzTW_Start takes unit c returns nothing
        call AinzTW_KS.AinzTW_Start(c)
    endfunction

    function AinzTE_Start takes unit c, real x, real y returns nothing
        call AinzTE_KS.AinzTE_Start(c, x, y)
    endfunction

    function AinzTR_Start takes unit c, real x, real y returns nothing
        call AinzTR_KS.AinzTR_Start(c, x, y)
    endfunction

    function AinzT_Start takes unit c returns nothing
        call AinzT_KS.AinzT_Start(c)
    endfunction

    function AinzF_Start takes unit c returns nothing
        call AinzF_KS.AinzF_Start(c)
    endfunction

    function AinzG_Start takes unit c returns nothing
        call AinzG_KS.AinzG_Start(c)
    endfunction
endlibrary