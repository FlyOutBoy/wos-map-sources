library CrocodileSpells initializer InitCrocodileSpells uses GearSystems, GearSystems2, AAADest, TasAbilityChargeBox
    globals
//================================ Crocodile Core ========================================
        integer Crocodile_ID = 'H02M'
        private constant integer CrocodileCore_DataKey = 0
        private constant real CrocodilePeriod = 0.03
        private hashtable CrocodileTable = InitHashtable()
        private hashtable CrocodileDecorHits = InitHashtable()
        private integer CrocodileDecorKey = 0
        private unit CrocodileG_ManaSource = null
        private integer CrocodileG_ManaContext = 0 // 0: normal; -1: no passive burn; positive: W cast.
        private trigger CrocodileW_QContact = null
        private unit CrocodileW_QSource = null
        private real CrocodileW_QStartX = 0.0
        private real CrocodileW_QStartY = 0.0
        private real CrocodileW_QAngle = 0.0
        private real CrocodileW_QFrom = 0.0
        private real CrocodileW_QTo = 0.0
        private real CrocodileW_QRadius = 0.0

//================================ Crocodile Sand ========================================
        real CrocodileSand_Duration = 5.0 // Target debuff; ground patch lifetime is configured below.
        private constant integer CrocodileSand_DebuffKey = 7
        real CrocodileSand_Radius = 250.0
        real CrocodileSand_LargeAoe = 400.0
        real CrocodileSand_GroundDuration = 20.0 // MAIN Object Data's ground lifetime.
        real CrocodileSand_FadeTime = 0.8
        integer CrocodileSand_Alpha = 128
        private constant real CrocodileSand_TrackPeriod = 0.15
        private group CrocodileSand_ScanGroup = null
        constant real CrocodileSand_MinDistance = 180.0
        integer CrocodileSand_Slow = 10

//================================ Crocodile Q ========================================
        integer CrocodileQ_ID = 'A0I7'
        integer CrocodileQ_SandMark_Ability_ID = 'A108' // Assigned by MAIN object integration.
        integer CrocodileQ_SandMark_Buff_ID = 'B03D'
        real CrocodileQ_SandMark_Grace = 0.30 // BuffUnit01's dummy casts asynchronously.
        integer CrocodileQ_GroundSandCount = 8
        real CrocodileQ_GroundSandAoe = 255.0
        real CrocodileQ_Move = 75.0
        real CrocodileQ_Distance = 1655.0
        real CrocodileQ_CastTime = 0.42
        real CrocodileQ_PauseTime = 0.54
        real CrocodileQ_SlashScaleMultiplier = 0.85
        real CrocodileQ_TrailSpacing = 600.0
        real CrocodileQ_DebugTime = 3.0
        real CrocodileQ_EffectStopDistance = 550.0
        real CrocodileQ_ExplosionSpacing = 350.0
        real CrocodileQ_ScanOverlap = 5.0 // AoE 300 -> scan every 295 distance.
        real CrocodileQ_Aoe = 255.0
        real CrocodileQ_DamageAgiBase = 2.0
        real CrocodileQ_DamageAgiStep = 1.0
        integer CrocodileQ_Slow = 10
        integer CrocodileQ_SlowLevel25 = 20
        integer CrocodileQ_SlowLevel35 = 30
        integer CrocodileQ_SecondSlowHeroLevel = 25
        integer CrocodileQ_SharedMarkHeroLevel = 35
        real CrocodileQ_PullDistance = 55.0
        real CrocodileQ_PullDuration = 0.21
        real CrocodileQ_DecorRetryPeriod = 0.06
        real CrocodileQ_DecorRetryDuration = 1.08 // Also covers decor with a 1-second cooldown.
        real CrocodileQ_SandSlowTime = 5.0
        integer CrocodileQ_Animation = 10
        real CrocodileQ_EffectScale = 0.45
        real CrocodileQ_EffectHeight = 40.0
        real CrocodileQ_ExplosionScale = 0.85
        real CrocodileQ_ExplosionDuration = 1.0

//================================ Crocodile W ========================================
        integer CrocodileW_ID = 'A0I8'
        real CrocodileW_Duration = 3.0
        real CrocodileW_CastTime = 0.45
        integer CrocodileW_Hits = 6
        real CrocodileW_Aoe = 600.0
        real CrocodileW_PullSpeed = 187.5
        real CrocodileW_EdgePullMultiplier = 0.50
        real CrocodileW_DecorDamage = 20.0
        real CrocodileW_DecorPeriod = 1.0
        real CrocodileW_DamageAgi = 0.75
        integer CrocodileW_Slow = 30
        real CrocodileW_ComboDamageAgi = 3.0
        real CrocodileW_ComboStun = 1.5
        integer CrocodileW_ManaBurnHits = 4
        integer CrocodileW_Animation = 10

//================================ Crocodile E ========================================
        integer CrocodileE_ID = 'A0I9'
        private constant integer CrocodileE_DataKey = 1
        real CrocodileE_Distance = 750.0
        real CrocodileE_Duration = 0.24
        real CrocodileE_MoveDelay = 0.09
        real CrocodileE_AnimationSpeed = 0.46
        real CrocodileE_SlashScale = 0.4025
        real CrocodileE_Aoe = 375.0
        real CrocodileE_SandAoe = 515.0 // Previous E sand radius 415 + 100.
        real CrocodileE_HitDelay = 0.12
        integer CrocodileE_HitTicks = 5
        real CrocodileE_HitOffset = 150.0
        real CrocodileE_HitAnimationSpeed = 0.01
        real CrocodileE_HitSlowTime = 0.51 // Seconds from cast start; affects animation only during E damage.
        real CrocodileE_DamageAgiBase = 3.0
        real CrocodileE_DamageAgiStep = 1.0
        integer CrocodileE_ThirdChargeHeroLevel = 25
        real CrocodileE_UseCD = 1.5
        integer CrocodileE_Slow = 35
        integer CrocodileE_Animation = 2

//================================ Crocodile R ========================================
        integer CrocodileR_ID = 'A0IA'
        real CrocodileR_Speed = 750.0
        real CrocodileR_SandSpacing = 100.0
        real CrocodileR_Duration = 2.5
        real CrocodileR_StartScale = 0.10
        real CrocodileR_EndScale = 0.85
        real CrocodileR_CastTime = 0.45
        real CrocodileR_StartAoe = 200.0
        real CrocodileR_EndAoe = 400.0
        real CrocodileR_DamageAgi = 0.6
        integer CrocodileR_Hits = 6
        real CrocodileR_StunTime = 1.0
        real CrocodileR_PullSpeed = 1200.0
        private constant integer CrocodileR_TargetKey = 5
        real CrocodileR_OrbitSpeed = 400.0
        real CrocodileR_LiftSpeed = 700.0
        real CrocodileR_Height = 600.0
        real CrocodileR_OrbitRadius = 0.2 // Keep targets near the center, with a small orbit.
        integer CrocodileR_Animation = 6

//================================ Crocodile W + R ========================================
        real CrocodileWR_ComboCenterRadius = 300.0
        real CrocodileWR_SizeMultiplier = 1.15
        real CrocodileWR_ComboEffectScale = 1.0
        real CrocodileWR_ComboEffectHeight = 30.0
        real CrocodileWR_ComboEffectPeriod = 0.12
        real CrocodileWR_DurationBonus = 1.0
        integer CrocodileSandColorR = 255
        integer CrocodileSandColorG = 205
        integer CrocodileSandColorB = 120

//================================ Crocodile T ========================================
        integer CrocodileT_ID = 'A0IB'
        private constant integer CrocodileT_DataKey = 4
        private constant integer CrocodileT_PhaseKey = 8
        real CrocodileT_SpreadTime = 3.0
        real CrocodileT_Duration = 5.0
        real CrocodileT_ManaDrain = 0.08
        real CrocodileT_ManaDrainPeriod = 1.0
        integer CrocodileT_InvulnerabilityHeroLevel = 35
        real CrocodileT_DamageReduction = 0.20
        real CrocodileT_MaxAoe = 1700.0
        real CrocodileT_RingSpacing = 475.0
        real CrocodileT_PatchSpacing = 475.0
        real CrocodileT_MinDistance = 180.0
        real CrocodileT_ScaleMin = 2
        real CrocodileT_PatchBehindWave = 150.0
        real CrocodileT_ScaleMax = 3
        real CrocodileT_SandVisualScale = 1.4
        real CrocodileT_GrowTime = 0.4
        real CrocodileT_RingBuildTime = 0.18
        real CrocodileT_WaveSpacing = 450.0
        integer CrocodileT_MaxWaves = 16
        real CrocodileT_WaveScaleMin = 1.7
        real CrocodileT_WaveScaleMax = 2.6
        real CrocodileT_WaveFadeTime = 0.45
        integer CrocodileT_SandAlpha = 225
        real CrocodileT_SandFadeTime = 0.8
        integer CrocodileT_MaxPatches = 80
        integer CrocodileT_SpawnsPerTick = 8
        integer CrocodileT_Animation = 12
        real CrocodileT_AnimationDelay = 0.03
        real CrocodileT_AnimationSpeed = 1.5
        real CrocodileT_Sound2Time = 1.02
        real CrocodileT_Sound3Period = 1.5

//================================ Crocodile T2 ========================================
        integer CrocodileT2_ID = 'A0IC'
        real CrocodileT2_UnlockTime = 1.0
        real CrocodileT2_CheckPeriod = 0.1
        real CrocodileT2_Window = 10.0
        real CrocodileT2_DamageAgi = 10.0
        real CrocodileT2_MergeDistance = 450.0
        integer CrocodileT2_MergeMaxPatches = 32
        real CrocodileT2_ExplosionBaseRadius = 50.0
        real CrocodileT2_FireScaleMax = 5.0
        real CrocodileT2_PoffScaleMax = 7.5
        real CrocodileT2_KrkScaleMax = 3
        integer CrocodileT2_MaxMainBlasts = 12
        integer CrocodileT2_MinMainBlasts = 3
        real CrocodileT2_BlastDistance = 0.55
        real CrocodileT2_KrkCountMultiplier = 1.5
        real CrocodileT2_KrkOutwardOffset = 120.0
        real CrocodileT2_KrkAngleVariation = 5.0
        real CrocodileT2_KrkRadialVariation = 50.0
        real CrocodileT2_KrkScaleVariation = 0.04
        real CrocodileT2_ExplosionDuration = 1.0
        real CrocodileT2_Delay = 0.5

//================================ Crocodile F ========================================
        integer CrocodileF_ID = 'A0ID'
        private constant integer CrocodileF_DataKey = 2
        integer CrocodileF_MaxStacks = 3
        integer CrocodileF_MinHeroLevel = 12
        real CrocodileF_Range = 800.0
        real CrocodileF_AttackSpeed = 3.0
        real CrocodileF_DamageAgi = 3.0
        real CrocodileF_InternalCD = 2.0
        real CrocodileF_ProjectileSpeed = 2484.0 // Previous speed + 15%.
        real CrocodileF_BladeMoveDelay = 0.15
        real CrocodileF_ProjectileAoe = 155.0
        real CrocodileF_ReleaseDelay = 0.45
        real CrocodileF_ProjectileRange = 1700.0
        real CrocodileF_SpreadAngle = 15.0
        real CrocodileF_TargetPadding = 32.0
        real CrocodileF_SingleOffset = 180.0
        real CrocodileF_SingleScale = 1.5
        real CrocodileF_BladeScale = 5.259375 // Previous blade scale - 15%.
        real CrocodileF_BladeAnimationSpeed = 1.0
        real CrocodileF_BladeHeight = 90.0 // Current 80 height + 12.5%; triple blades only.
        integer CrocodileF_Animation = 2
        real CrocodileF_AnimationSpeed = 2.0
        real CrocodileF_EffectHeight = 80.0
        real CrocodileF_SandSpacing = 180.0

//================================ Crocodile G ========================================
        integer CrocodileG_ID = 'A0IE'
        private constant integer CrocodileG_DataKey = 3
        integer CrocodileG_MoveSpeed = 80
        integer CrocodileG_SandMS_Ability_ID = 'A109' // Assigned by MAIN object integration.
        integer CrocodileG_SandMS_Buff_ID = 'B03E'
        real CrocodileG_SandMS_RefreshPeriod = 0.20
        real CrocodileG_SandMS_Duration = 0.35
        real CrocodileG_BaseMoveSpeed = 310.0 // MAIN H02M base speed; Bloodlust factor is 80 / 310.
        real CrocodileG_ManaDrain = 0.02
        real CrocodileG_MissingScale = 0.0035
        real CrocodileG_MaxBonus = 0.15
    endglobals

    private function CrocodileBonus_Refresh takes unit u, integer abilityId returns nothing
            local ability a = BlzGetUnitAbility(u, abilityId)
            local integer level = GetUnitAbilityLevel(u, abilityId)
            local integer levels = BlzGetAbilityIntegerField(a, ABILITY_IF_LEVELS)
            if a != null and level > 0 then
                // Native item bonuses have one level. Ensure Inc really changes
                // level before restoring it, so updated stat fields are applied.
                if levels <= level then
                    call BlzSetAbilityIntegerField(a, ABILITY_IF_LEVELS, level + 1)
                endif
                call IncUnitAbilityLevel(u, abilityId)
                call DecUnitAbilityLevel(u, abilityId)
                if levels <= level then
                    call BlzSetAbilityIntegerField(a, ABILITY_IF_LEVELS, levels)
                endif
            endif
            set a = null
    endfunction

    // PauseUnit is boolean: overlapping owned casts must release only the last lock.
//================================ Crocodile Sand ========================================
    private struct CrocodileSand_Struct
        static integer array m
        static integer MUI = -1
        unit c
        real x
        real y
        real radius
        real r
        real rmax
        real slowLife
        real pulse
        effect e
        boolean endNow
        boolean largeVisual

        method CrocodileSand_CreateVisual takes nothing returns nothing
            set largeVisual = radius >= CrocodileSand_LargeAoe
            set e = EffectSpawn("war3mapImported\\wos_ysjsm45.mdl",x,y,GetRandomReal(0,359),0.5,radius/165.0,0)
            call BlzSetSpecialEffectAlpha(e,0)
            call ColorEffDummy4(e,0,255,255,255,0.39)
        endmethod


        static method CrocodileSand_IsOnGround takes unit u, unit source returns boolean
            local integer i = 0
            local thistype this
            local real px = GetUnitX(u)
            local real py = GetUnitY(u)
            local real dx
            local real dy
            loop
                exitwhen i > MUI
                set this = m[i]
                if (source == null or c == source) and not endNow and r < rmax then
                    set dx = px-x
                    set dy = py-y
                    if dx*dx+dy*dy <= radius*radius then
                        return true
                    endif
                endif
                set i = i + 1
            endloop
            return false
        endmethod

        static method Loop_CrocodileSand takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            loop
                exitwhen i > MUI
                set this = m[i]
                set r = RoundReal(r+CrocodilePeriod,3)
                set pulse = pulse + CrocodilePeriod
                set slowLife = RMaxBJ(0.0,slowLife-CrocodilePeriod)
                if not endNow and slowLife > 0.0 and pulse + 0.001 >= 0.5 then
                    set pulse = 0.0
                    if CrocodileSand_ScanGroup == null then
                        set CrocodileSand_ScanGroup = CreateGroup()
                    endif
                    call GroupEnumUnitsInRange(CrocodileSand_ScanGroup,x,y,radius,NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(CrocodileSand_ScanGroup)
                        exitwhen u == null
                        call GroupRemoveUnit(CrocodileSand_ScanGroup,u)
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                            call SlowUnit(c,u,CrocodileSand_Slow,1)
                        endif
                    endloop
                endif
                if endNow or r + 0.001 >= rmax or GetUnitTypeId(c) == 0 or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                    if e != null then
                        call ColorEffDummy3(e,0.0,255,255,255,CrocodileSand_FadeTime)
                    endif
                    set c = null
                    set e = null
                    set m[i] = m[MUI]
                    set MUI = MUI - 1
                    call destroy()
                    if MUI == -1 then
                        if CrocodileSand_ScanGroup != null then
                            call DestroyGroup(CrocodileSand_ScanGroup)
                            set CrocodileSand_ScanGroup = null
                        endif
                        call GearTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        static method CrocodileSand_Start takes unit NewC, real NewX, real NewY, real NewAoe, boolean qHit returns nothing
            local integer i = 0
            local thistype this
            local real dx
            local real dy
            loop
                exitwhen i > MUI
                set this = m[i]
                set dx = x-NewX
                set dy = y-NewY
                if not endNow and r < rmax and dx*dx+dy*dy+0.001 < CrocodileSand_MinDistance*CrocodileSand_MinDistance then
                    // All existing sand objects enforce spacing. Only refresh our own.
                    if c == NewC and not qHit then
                        set radius = RMaxBJ(radius,NewAoe)
                        set r = 0.0
                        set rmax = CrocodileSand_GroundDuration
                        set largeVisual = radius >= CrocodileSand_LargeAoe
                        call BlzSetSpecialEffectScale(e,radius/165.0)
                    endif
                    return
                endif
                set i = i + 1
            endloop
            set this = thistype.allocate()
            set MUI = MUI + 1
            set m[MUI] = this
            if MUI == 0 then
                call GearTimer03Acquire()
            endif
            set c = NewC
            set x = NewX
            set y = NewY
            set radius = NewAoe
            set r = 0.0
            set pulse = 0.0
            set slowLife = 0.0
            set endNow = false
            if qHit then
                set slowLife = CrocodileQ_SandSlowTime
            endif
            set rmax = CrocodileSand_GroundDuration
            call CrocodileSand_CreateVisual()
        endmethod


    endstruct

    private function CrocodileQ_MarkLevel takes unit c returns integer
        if GetHeroLevel(c) >= CrocodileQ_SharedMarkHeroLevel then
            return 3
        elseif GetHeroLevel(c) >= CrocodileQ_SecondSlowHeroLevel then
            return 2
        endif
        return 1
    endfunction

    private struct CrocodileSand_Debuff
        static integer array m
        static integer MUI = -1
        unit u
        unit c
        real lastX
        real lastY
        real pulse
        real r
        real rmax
        effect e
        boolean buffSeen
        real buffGrace

        static method Apply takes unit source, unit target returns boolean
            local thistype this
            if source == null or not SpellBoolCaster(source) or IsUnitIllusion(source) or target == null or not SpellBool(target) or not IsUnitEnemy(target,GetOwningPlayer(source)) or IsUnitType(target,UNIT_TYPE_STRUCTURE) or GetUnitAbilityLevel(target,'Aloc') > 0 or CrocodileQ_SandMark_Ability_ID == 0 or CrocodileQ_SandMark_Buff_ID == 0 then
                return false
            endif
            call BuffUnit01(source,target,CrocodileQ_SandMark_Ability_ID,"slow",CrocodileQ_MarkLevel(source))
            set this = LoadInteger(CrocodileTable,GetHandleId(target),CrocodileSand_DebuffKey)
            if this != 0 then
                set c = source // One tracker per target; latest successful mark owns its trail.
                set buffGrace = CrocodileQ_SandMark_Grace
                return false
            endif
            set this = thistype.allocate()
            set c = source
            set u = target
            set lastX = GetUnitX(u)
            set lastY = GetUnitY(u)
            set pulse = 0.0
            set r = 0.0
            set buffSeen = false
            set buffGrace = CrocodileQ_SandMark_Grace
            set e = null // The native buff owns its indicator and lifetime.
            call SaveInteger(CrocodileTable,GetHandleId(u),CrocodileSand_DebuffKey,this)
            set MUI = MUI + 1
            set m[MUI] = this
            if MUI == 0 then
                call GearTimer03Acquire()
            endif
            return true
        endmethod

        static method Loop_CrocodileSandDebuff takes nothing returns nothing
            local integer i = 0
            local thistype this
            local real px
            local real py
            local real dx
            local real dy
            loop
                exitwhen i > MUI
                set this = m[i]
                set r = RoundReal(r+CrocodilePeriod,3)
                set buffGrace = RMaxBJ(0.0,buffGrace-CrocodilePeriod)
                if GetUnitAbilityLevel(u,CrocodileQ_SandMark_Buff_ID) > 0 then
                    set buffSeen = true
                endif
                if (GetUnitAbilityLevel(u,CrocodileQ_SandMark_Buff_ID) == 0 and (buffSeen or buffGrace <= 0.0)) or GetUnitTypeId(u) == 0 or GetWidgetLife(u) <= 0.405 or not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                    call RemoveSavedInteger(CrocodileTable,GetHandleId(u),CrocodileSand_DebuffKey)
                    call DestroyEffect(e)
                    set e = null
                    set u = null
                    set c = null
                    set m[i] = m[MUI]
                    set MUI = MUI - 1
                    call destroy()
                    if MUI == -1 then
                        call GearTimer03Release()
                    endif
                else
                    set pulse = pulse + CrocodilePeriod
                    if pulse + 0.001 >= CrocodileSand_TrackPeriod and GetUnitAbilityLevel(u,CrocodileQ_SandMark_Buff_ID) > 0 and GetUnitTypeId(c) != 0 and IsUnitEnemy(u,GetOwningPlayer(c)) then
                        set pulse = 0.0
                        set px = GetUnitX(u)
                        set py = GetUnitY(u)
                        set dx = px-lastX
                        set dy = py-lastY
                        if dx*dx+dy*dy >= CrocodileSand_MinDistance*CrocodileSand_MinDistance then
                            call CrocodileSand_Struct.CrocodileSand_Start(c,px,py,CrocodileSand_Radius,true)
                            set lastX = px
                            set lastY = py
                        endif
                    endif
                    set i = i + 1
                endif
            endloop
        endmethod
    endstruct

    function CrocodileQ_ApplySandMark takes unit c, unit u returns nothing
        if CrocodileSand_Debuff.Apply(c,u) then
            call CrocodileSand_Struct.CrocodileSand_Start(c,GetUnitX(u),GetUnitY(u),CrocodileSand_Radius,true)
        endif
    endfunction

//================================ Crocodile Q - Desert Spada ========================================
    private function CrocodileDecor_NewKey takes nothing returns integer
        set CrocodileDecorKey = CrocodileDecorKey+1
        return CrocodileDecorKey
    endfunction

    private function CrocodileW_CheckQ takes unit source, real sx, real sy, real angle, real fromDistance, real toDistance, real qRadius returns nothing
        // Synchronous notification avoids a Q/W struct forward dependency.
        set CrocodileW_QSource = source
        set CrocodileW_QStartX = sx
        set CrocodileW_QStartY = sy
        set CrocodileW_QAngle = angle
        set CrocodileW_QFrom = fromDistance
        set CrocodileW_QTo = toDistance
        set CrocodileW_QRadius = qRadius
        if CrocodileW_QContact != null then
            call TriggerEvaluate(CrocodileW_QContact)
        endif
        set CrocodileW_QSource = null
    endfunction

    // MAIN calls this only after a positive final hit. Rejected hits never
    // consume W's per-target allowance. The context is restored after damage.
    function CrocodileG_CanDrainMana takes unit c, unit target returns boolean
        local integer hits
        if c != CrocodileG_ManaSource or CrocodileG_ManaContext == 0 then
            return true
        elseif CrocodileG_ManaContext < 0 then
            return false
        endif
        set hits = LoadInteger(CrocodileDecorHits,CrocodileG_ManaContext,GetHandleId(target))
        if hits >= CrocodileW_ManaBurnHits then
            return false
        endif
        call SaveInteger(CrocodileDecorHits,CrocodileG_ManaContext,GetHandleId(target),hits+1)
        return true
    endfunction

    private function Crocodile_SpellDamage takes unit c, unit target, real amount, integer manaContext returns nothing
        local unit previousSource = CrocodileG_ManaSource
        local integer previousContext = CrocodileG_ManaContext
        set CrocodileG_ManaSource = c
        set CrocodileG_ManaContext = manaContext
        call dmgphys(c,target,amount)
        set CrocodileG_ManaSource = previousSource
        set CrocodileG_ManaContext = previousContext
        set previousSource = null
    endfunction

    private function Crocodile_ApplySharedMark takes unit c, unit target returns nothing
        if GetHeroLevel(c) >= CrocodileQ_SharedMarkHeroLevel then
            call CrocodileQ_ApplySandMark(c,target)
        endif
    endfunction

    private function CrocodileE_MaxCharges takes unit c returns integer
        local integer level = GetUnitAbilityLevel(c,CrocodileE_ID)
        if level == 0 then
            return 0
        elseif GetHeroLevel(c) >= CrocodileE_ThirdChargeHeroLevel then
            return 3
        elseif level >= 3 then
            return 2
        endif
        return 1
    endfunction

    private function CrocodileE_RechargeTime takes unit c returns real
        return RMaxBJ(CrocodilePeriod,BlzGetUnitAbilityCooldown(c,CrocodileE_ID,IMaxBJ(0,GetUnitAbilityLevel(c,CrocodileE_ID)-1)))
    endfunction

    private function CrocodileQ_Pull takes unit u, real x, real y returns nothing
        local real duration = RMaxBJ(CrocodilePeriod,CrocodileQ_PullDuration-CrocodilePeriod)
        local real distance = RMinBJ(CrocodileQ_PullDistance,SR3(u,x,y))
        // MUE includes a final tick at r == rmax. Account for it so both the
        // configured duration and distance are respected; retain MAIN CC resistance.
        if distance > 1.0 then
            call MUE(u,distance*duration/(duration+CrocodilePeriod),duration,Atan2(y-GetUnitY(u),x-GetUnitX(u)))
        endif
    endfunction

    private struct CrocodileQ_ExplosionDecor
        static integer array m
        static integer MUI = -1
        unit c
        real x
        real y
        real a
        real distance
        real radius
        real scanStep
        real r
        real rmax
        real pulse
        integer decorKey

        method CrocodileQExplosionDecor_Scan takes nothing returns nothing
            local real amount = 0.0
            local real section
            loop
                exitwhen amount >= distance
                set section = RMinBJ(scanStep,distance-amount)
                call DecorRemoveLine(c,x+amount*Cos(a),y+amount*Sin(a),a,section,radius,25.0,CrocodileDecorHits,decorKey)
                set amount = amount+section
            endloop
        endmethod

        static method Loop_CrocodileQExplosionDecor takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI
                set this = m[i]
                set r = RoundReal(r+CrocodilePeriod,3)
                set pulse = pulse+CrocodilePeriod
                if SpellBoolCaster(c) and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 and (pulse+0.001 >= CrocodileQ_DecorRetryPeriod or r+0.001 >= rmax) then
                    set pulse = 0.0
                    call CrocodileQExplosionDecor_Scan()
                endif
                if r+0.001 >= rmax or not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                    call FlushChildHashtable(CrocodileDecorHits,decorKey)
                    set c = null
                    set m[i] = m[MUI]
                    set MUI = MUI-1
                    call destroy()
                    if MUI == -1 then
                        call GearTimer03Release()
                    endif
                else
                    set i = i+1
                endif
            endloop
        endmethod

        static method CrocodileQExplosionDecor_Start takes unit NewC, real NewX, real NewY, real NewA, real NewDistance, real NewRadius, real NewScanStep returns nothing
            local thistype this = thistype.allocate()
            set MUI = MUI+1
            set m[MUI] = this
            if MUI == 0 then
                call GearTimer03Acquire()
            endif
            set c = NewC
            set x = NewX
            set y = NewY
            set a = NewA
            set distance = NewDistance
            set radius = NewRadius
            set scanStep = RMaxBJ(1.0,NewScanStep)
            set r = 0.0
            set rmax = RMaxBJ(CrocodilePeriod,CrocodileQ_DecorRetryDuration)
            set pulse = 0.0
            set decorKey = CrocodileDecor_NewKey()
            call CrocodileQExplosionDecor_Scan()
        endmethod
    endstruct

    private struct CrocodileQ_Trail
        effect e
        integer next
        real age
    endstruct

    private struct CrocodileQ_Struct
        static integer array m
        static integer MUI = -1
        unit c
        group g
        group g2
        group g3
        effect e
        integer trails
        real x
        real y
        real startX
        real startY
        real a
        real move
        real distance
        real previousDistance
        real maxDistance
        real effectDistance
        real effectStop
        real scanDistance
        real scanStep
        integer decorKey
        real radius
        real dmg
        real r
        real rmax
        real nextTrail
        boolean qPauseHeld
        boolean finished

        method CrocodileQ_ClearVisuals takes nothing returns nothing
            local CrocodileQ_Trail trail
            call DestroyEffect(e)
            set e = null
            loop
                exitwhen trails == 0
                set trail = trails
                set trails = trail.next
                call DestroyEffect(trail.e)
                set trail.e = null
                call trail.destroy()
            endloop
        endmethod

        method CrocodileQ_HitSand takes unit u returns nothing
            call CrocodileQ_ApplySandMark(c,u)
        endmethod

        static method Loop_CrocodileQ takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer sectionCount
            local unit u
            local real step
            local real projection
            local real px
            local real py
            local real amount
            local real section
            local CrocodileQ_Trail trail
            local boolean removeNow
            loop
                exitwhen i > MUI
                set this = m[i]
                set removeNow = finished and not qPauseHeld
                set r = RoundReal(r+CrocodilePeriod,3)
                if qPauseHeld and (r + 0.001 >= CrocodileQ_PauseTime or not SpellBoolCaster(c) or GetUnitTypeId(c) == 0) then
                    set qPauseHeld = false
                    call StopSpellUnit2(c)
            call MakeSound("war3mapImported\\Hero_Crocodile_Q2")
                endif
                if not finished and r < rmax and SpellBoolCaster(c) and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 then
//---------------- Q cast / moving effect ------------------------------------
                    if r + 0.001 >= CrocodileQ_CastTime and e == null then
                        set e = EffectSpawn("war3mapImported\\wos_File00001240.mdl",startX,startY,a*bj_RADTODEG,1,CrocodileQ_EffectScale*CrocodileQ_SlashScaleMultiplier,CrocodileQ_EffectHeight)
                    endif
                    if r + 0.001 >= CrocodileQ_CastTime then
                        set step = RMinBJ(move,maxDistance-distance)
                        set previousDistance = distance
                        set distance = distance + step
                        set x = startX + distance*Cos(a)
                        set y = startY + distance*Sin(a)
                        // Keep the configured model-length offset proportional to slash scale.
                        if effectDistance < effectStop then
                            call MoveEff(e,RMinBJ(distance,effectStop)-effectDistance,a)
                            set effectDistance = RMinBJ(distance,effectStop)
                        endif
                        loop
                            exitwhen nextTrail > distance
                            set trail = CrocodileQ_Trail.create()
                            set trail.e = EffectSpawn("war3mapImported\\wos_File00001240.mdl",startX+(nextTrail-CrocodileQ_TrailSpacing)*Cos(a),startY+(nextTrail-CrocodileQ_TrailSpacing)*Sin(a),a*bj_RADTODEG,1,CrocodileQ_EffectScale*CrocodileQ_SlashScaleMultiplier,CrocodileQ_EffectHeight)
                            set trail.age = 0.0
                            set trail.next = trails
                            set trails = trail
                            set nextTrail = nextTrail + RMaxBJ(1.0,CrocodileQ_TrailSpacing)
                        endloop
//---------------- Q first pass: scan every moved segment immediately --------
                        loop
                            exitwhen scanDistance >= distance
                            set section = RMinBJ(scanStep,distance-scanDistance)
                            set px = startX+(scanDistance+section/2)*Cos(a)
                            set py = startY+(scanDistance+section/2)*Sin(a)
                            call VisionTimed(GetOwningPlayer(c),px,py,radius*1.5,3.0)
                            call DecorRemoveLine(c,startX+scanDistance*Cos(a),startY+scanDistance*Sin(a),a,section,radius,15.0,CrocodileDecorHits,decorKey)
                            call CrocodileW_CheckQ(c,startX,startY,a,scanDistance,scanDistance+section,radius)
                            call GroupEnumUnitsInRange(g,px,py,radius+section/2,NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                call GroupRemoveUnit(g,u)
                                set projection = RMaxBJ(scanDistance,RMinBJ(scanDistance+section,(GetUnitX(u)-startX)*Cos(a)+(GetUnitY(u)-startY)*Sin(a)))
                                set px = startX+projection*Cos(a)
                                set py = startY+projection*Sin(a)
                                if SpellBool(u) and IsUnitEnemy(u,GetOwningPlayer(c)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) and not IsUnitInGroup(u,g2) and SR3(u,px,py) <= radius then
                                    call GroupAddUnit(g2,u)
                                    call CrocodileQ_HitSand(u)
                                    if CrocodileQ_PullDuration > 0.0 and SR3(u,px,py) > 1.0 then
                                        set projection = RMaxBJ(0.0,RMinBJ(maxDistance,(GetUnitX(u)-startX)*Cos(a)+(GetUnitY(u)-startY)*Sin(a)))
                                        set px = startX+projection*Cos(a)
                                        set py = startY+projection*Sin(a)
                                        call CrocodileQ_Pull(u,px,py)
                                    endif
                                endif
                            endloop
                            set scanDistance = scanDistance + section
                        endloop
                        if distance + 0.001 >= maxDistance then
//---------------- Q endpoint fade / original explosion layout --------------
                            set amount = 250.0
                            set sectionCount = 0
                            loop
                                exitwhen amount > distance or sectionCount >= 6
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_sandSlashUp.mdl",startX+amount*Cos(a),startY+amount*Sin(a),a*bj_RADTODEG,1,CrocodileQ_ExplosionScale,0))
                                set amount = amount+RMaxBJ(1.0,CrocodileQ_ExplosionSpacing)
                                set sectionCount = sectionCount+1
                            endloop
                            call CrocodileQ_ClearVisuals()
                            
            call MakeSound("war3mapImported\\Hero_Crocodile_Q3")
//---------------- Q damage: independent of VFX count; same AoE scan step -----
                            call CrocodileQ_ExplosionDecor.CrocodileQExplosionDecor_Start(c,startX,startY,a,distance,radius,scanStep)
                            set amount = 0.0
                            loop
                                exitwhen amount >= distance
                                set section = RMinBJ(scanStep,distance-amount)
                                call GroupEnumUnitsInRange(g,startX+(amount+section/2)*Cos(a),startY+(amount+section/2)*Sin(a),radius+section/2,NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    call GroupRemoveUnit(g,u)
                                    set projection = RMaxBJ(amount,RMinBJ(amount+section,(GetUnitX(u)-startX)*Cos(a)+(GetUnitY(u)-startY)*Sin(a)))
                                    set px = startX+projection*Cos(a)
                                    set py = startY+projection*Sin(a)
                                    if SpellBool(u) and IsUnitEnemy(u,GetOwningPlayer(c)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) and not IsUnitInGroup(u,g3) and SR3(u,px,py) <= radius then
                                        call GroupAddUnit(g3,u)
                                        if not IsUnitInGroup(u,g2) then
                                            call GroupAddUnit(g2,u)
                                            call CrocodileQ_HitSand(u)
                                        endif
                                        call dmgphys(c,u,dmg)
                                    endif
                                endloop
                                set amount = amount+section
                            endloop
                            set sectionCount = 0
                            loop
                                exitwhen sectionCount >= CrocodileQ_GroundSandCount
                                set amount = distance*(sectionCount+0.5)/IMaxBJ(1,CrocodileQ_GroundSandCount)
                                call CrocodileSand_Struct.CrocodileSand_Start(c,startX+amount*Cos(a),startY+amount*Sin(a),CrocodileQ_GroundSandAoe,true)
                                set sectionCount = sectionCount+1
                            endloop
                            set finished = true // Keep endpoint for W combo this tick.
                        endif
                    endif
                endif
                set trail = trails
                loop
                    exitwhen trail == 0
                    set trail.age = trail.age + CrocodilePeriod
                    call BlzSetSpecialEffectAlpha(trail.e,R2I(255.0*(1.0-RMinBJ(1.0,RMaxBJ(0.0,(trail.age-0.45)/0.15)))))
                    set trail = trail.next
                endloop
                if removeNow or r >= rmax or not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
//---------------- Q cleanup: normal finish OR debug deadline ----------------
                    if qPauseHeld then
                        set qPauseHeld = false
                        call StopSpellUnit2(c)
                    endif
                    call CrocodileQ_ClearVisuals()
                    call FlushChildHashtable(CrocodileDecorHits,decorKey)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    call DestroyGroup(g3)
                    set c = null
                    set e = null
                    set g = null
                    set g2 = null
                    set g3 = null
                    set m[i] = m[MUI]
                    set MUI = MUI - 1
                    call destroy()
                    if MUI == -1 then
                        call GearTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        static method CrocodileQ_Begin takes unit NewC, real NewX, real NewY returns boolean
            local thistype this
            if LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileCore_DataKey) == 0 or IsUnitIllusion(NewC) or not SpellBoolCaster(NewC) or LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileT_PhaseKey) != 0 then
                return false
            endif
            if CrocodileQ_Move <= 0.0 or CrocodileQ_Distance <= 0.0 or CrocodileQ_Aoe <= 0.0 then
                return false
            endif
            set this = thistype.allocate()
            set MUI = MUI + 1
            set m[MUI] = this
            if MUI == 0 then
                call GearTimer03Acquire()
            endif
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set startX = x
            set startY = y
            set a = Atan2(NewY-y,NewX-x)
            set move = CrocodileQ_Move
            set distance = 0.0
            set previousDistance = 0.0
            set maxDistance = CrocodileQ_Distance
            set effectDistance = 0.0
            set effectStop = RMaxBJ(0.0,maxDistance-CrocodileQ_EffectStopDistance*CrocodileQ_SlashScaleMultiplier)
            set scanDistance = 0.0
            set decorKey = CrocodileDecor_NewKey()
            set radius = CrocodileQ_Aoe
            set scanStep = RMaxBJ(1.0,radius-CrocodileQ_ScanOverlap)
            set dmg = GetHeroAgi(c,true)*(CrocodileQ_DamageAgiBase+CrocodileQ_DamageAgiStep*(GetUnitAbilityLevel(c,CrocodileQ_ID)-1))
            set r = 0.0
            // At least 3 sec; large distance/slow movement gets a longer deadline.
            set rmax = RMaxBJ(CrocodileQ_DebugTime,CrocodileQ_CastTime+maxDistance/move*CrocodilePeriod+1.0)
            set nextTrail = RMaxBJ(1.0,CrocodileQ_TrailSpacing)
            set qPauseHeld = true
            call StartSpellUnit2(c)
            set finished = false
            set g = CreateGroup() // Reused for every scan; no CreateGroup in loops.
            set g2 = CreateGroup() // First-pass slow/pull, once per target.
            set g3 = CreateGroup() // Final damage, once per target.
            set e = null
            set trails = 0
            call SetUnitAnimationByIndex(c,CrocodileQ_Animation)
            if GetRandomInt(1,2) == 1 then 
            call MakeSound("war3mapImported\\Hero_Crocodile_Q_2")
            else 
            call MakeSound("war3mapImported\\Hero_Crocodile_Q")
            endif
            return true
        endmethod


    endstruct

//================================ Crocodile W - Desert Girasole ========================================
    private struct CrocodileW_Struct
        static integer array m
        static integer MUI = -1
        unit c
        real x
        real y
        real radius
        real r
        real rmax
        integer hits
        boolean castPauseHeld
        real scanTime
        real dmg
        real damageRmax
        real decorPulse
        group g
        group pullGroup
        effect e
        effect e2
        boolean combo
        boolean comboPending
        real comboPullTime
        integer manaKey


        // Shared only by W cast and Q crossing a pit. One combo per pit.
        method CrocodileW_Combo takes nothing returns nothing
            local unit u
            local effect e2
            if combo then
                return
            endif
            set combo = true
            set comboPullTime = 0.24
            set e2 = EffectSpawn("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl",x,y,0,1,radius/150.0,0)
            call MyRemoveEff(e2,1.0)
            call GroupEnumUnitsInRange(g,x,y,radius,NoDecor_Cond)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                call GroupRemoveUnit(g,u)
                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                    call Crocodile_SpellDamage(c,u,GetHeroAgi(c,true)*CrocodileW_ComboDamageAgi,manaKey)
                    call Crocodile_ApplySharedMark(c,u)
                    call GroupAddUnit(pullGroup,u)
                    call StunUnit(c,u,CrocodileW_ComboStun)
                endif
            endloop
            set u = null
            set e2 = null
        endmethod

        static method CrocodileW_RecordQ takes unit source, real sx, real sy, real angle, real fromDistance, real toDistance, real qRadius returns nothing
            local integer i = 0
            local thistype this
            local real projection
            loop
                exitwhen i > MUI
                set this = m[i]
                if c == source and not combo and r < rmax then
                    set projection = RMaxBJ(fromDistance,RMinBJ(toDistance,(x-sx)*Cos(angle)+(y-sy)*Sin(angle)))
                    if SR0(x,y,sx+projection*Cos(angle),sy+projection*Sin(angle)) <= radius+qRadius then
                        set comboPending = true
                    endif
                endif
                set i = i+1
            endloop
        endmethod

        static method Loop_CrocodileW takes nothing returns nothing
            local thistype this
            local integer i = 0
            local unit u
            local CrocodileQ_Struct slash
            local integer j
            local real projection
            local real distance
            local real depth
            local real pullSpeed
            loop
                exitwhen i > MUI
                set this = m[i]
                if r == 0.51 then 
            call MakeSound("war3mapImported\\Hero_Crocodile_W2")
                endif
                if not combo and SpellBoolCaster(c) and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 then
//---------------- W + Q: check the current segment, including final tick ----
                set j = 0
                loop
                    exitwhen j > CrocodileQ_Struct.MUI
                    set slash = CrocodileQ_Struct.m[j]
                    if slash.c == c and slash.distance > 0.0 and not combo then
                        set projection = RMaxBJ(slash.previousDistance,RMinBJ(slash.distance,(x-slash.startX)*Cos(slash.a)+(y-slash.startY)*Sin(slash.a)))
                        if SR0(x,y,slash.startX+projection*Cos(slash.a),slash.startY+projection*Sin(slash.a)) <= radius+slash.radius then
                            set comboPending = true
                        endif
                    endif
                    set j = j + 1
                endloop
                endif
                set r = RoundReal(r+CrocodilePeriod,3)
                if castPauseHeld and (r + 0.001 >= CrocodileW_CastTime or not SpellBoolCaster(c)) then
                    set castPauseHeld = false
                    call StopSpellUnit2(c)
                endif
                set scanTime = scanTime + CrocodilePeriod
                if SpellBoolCaster(c) and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 and r> 0.51 then
                    if comboPending then
                        call CrocodileW_Combo()
                        set comboPending = false
                    endif
                    set decorPulse = decorPulse+CrocodilePeriod
                    if decorPulse+0.001 >= CrocodileW_DecorPeriod then
                        set decorPulse = decorPulse-RMaxBJ(CrocodilePeriod,CrocodileW_DecorPeriod)
                        call DecorRemove(c,x,y,radius,CrocodileW_DecorDamage)
                    endif
                    if scanTime + 0.001 >= 0.15 or r + 0.001 >= rmax then
                        set scanTime = 0.0
                        call GroupEnumUnitsInRange(pullGroup,x,y,radius,NoDecor_Cond)
                    endif
                    set j = BlzGroupGetSize(pullGroup)-1
                    loop
                        exitwhen j < 0
                        set u = BlzGroupUnitAt(pullGroup,j)
                        if SpellBool(u) and IsUnitEnemy(u,GetOwningPlayer(c)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) then
                            set distance = SR3(u,x,y)
                            if distance > 0.0 and distance <= radius then
                                // Linear depth and a stronger rim keep the outer pull useful.
                                set depth = RMaxBJ(0.0,1.0-distance/RMaxBJ(1.0,radius))
                                set pullSpeed = CrocodileW_PullSpeed*(CrocodileW_EdgePullMultiplier+(1.0-CrocodileW_EdgePullMultiplier)*depth)
                                if comboPullTime > 0.0 then
                                    set pullSpeed = RMaxBJ(pullSpeed,distance/RMaxBJ(CrocodilePeriod,comboPullTime))
                                endif
                                call MoveUnit(u,RMinBJ(pullSpeed*CrocodilePeriod,distance),Atan2(y-GetUnitY(u),x-GetUnitX(u)))
                            endif
                        endif
                        set j = j-1
                    endloop
                    set comboPullTime = RMaxBJ(0.0,RoundReal(comboPullTime-CrocodilePeriod,3))
                    loop
                        exitwhen hits >= CrocodileW_Hits or r + 0.001 < (hits+1)*damageRmax/IMaxBJ(1,CrocodileW_Hits)
                        call GroupEnumUnitsInRange(g,x,y,radius,NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g,u)
                            if SpellBool(u) and IsUnitEnemy(u,GetOwningPlayer(c)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) then
                                call Crocodile_SpellDamage(c,u,dmg,manaKey)
                                call Crocodile_ApplySharedMark(c,u)
                                call SlowUnit(c,u,CrocodileW_Slow,2)
                            endif
                        endloop
                        set hits = hits + 1
                    endloop
                    if r + 0.001 >= rmax then
                        call CrocodileSand_Struct.CrocodileSand_Start(c,x+250*Cos(120*bj_DEGTORAD),y+250*Sin(120*bj_DEGTORAD),radius*0.75,false)
                        call CrocodileSand_Struct.CrocodileSand_Start(c,x+250*Cos(240*bj_DEGTORAD),y+250*Sin(240*bj_DEGTORAD),radius*0.75,false)
                        call CrocodileSand_Struct.CrocodileSand_Start(c,x+250*Cos(360*bj_DEGTORAD),y+250*Sin(360*bj_DEGTORAD),radius*0.75,false)
                    endif
                endif
                if r + 0.001 >= rmax or not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                    if castPauseHeld then
                        set castPauseHeld = false
                        call StopSpellUnit2(c)
                    endif
                    call ScaleEffDummy(e,0.45,radius/900,0.01)
                    call MyRemoveEff(e,0.51)
                    call DestroyEffect(e2)
                    call DestroyGroup(g)
                    call DestroyGroup(pullGroup)
                    call FlushChildHashtable(CrocodileDecorHits,manaKey)
                    set c = null
                    set e = null
                    set e2 = null
                    set g = null
                    set pullGroup = null
                    set m[i] = m[MUI]
                    set MUI = MUI - 1
                    call destroy()
                    if MUI == -1 then
                        call GearTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        static method CrocodileW_Begin takes unit NewC, real NewX, real NewY returns boolean
            local thistype this
            local integer j = 0
            local CrocodileQ_Struct slash
            local real projection
            if LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileCore_DataKey) == 0 or IsUnitIllusion(NewC) or not SpellBoolCaster(NewC) or LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileT_PhaseKey) != 0 then
                return false
            endif
            set this = thistype.allocate()
            set MUI = MUI + 1
            set m[MUI] = this
            if MUI == 0 then
                call GearTimer03Acquire()
            endif
            set c = NewC
            set x = NewX
            set y = NewY
            set radius = CrocodileW_Aoe
            set r = 0.0
            set rmax = RMaxBJ(0.03,CrocodileW_Duration)+0.51
            set decorPulse = 0.0
            call VisionTimed(GetOwningPlayer(c),x,y,radius*1.5,3.0)
            set damageRmax = rmax // Freeze the six original damage times; rmax may extend for R.
            set hits = 0
            set castPauseHeld = true
            call StartSpellUnit2(c)
            set scanTime = 0.0
            set combo = false
            set comboPending = false
            set manaKey = CrocodileDecor_NewKey()
            // Q may have crossed this area before W's windup finishes.
            loop
                exitwhen j > CrocodileQ_Struct.MUI
                set slash = CrocodileQ_Struct.m[j]
                if slash.c == c and slash.distance > 0.0 then
                    set projection = RMaxBJ(0.0,RMinBJ(slash.distance,(x-slash.startX)*Cos(slash.a)+(y-slash.startY)*Sin(slash.a)))
                    if SR0(x,y,slash.startX+projection*Cos(slash.a),slash.startY+projection*Sin(slash.a)) <= radius+slash.radius then
                        set comboPending = true
                    endif
                endif
                set j = j+1
            endloop
            set comboPullTime = 0.0
            set dmg = GetHeroAgi(c,true)*CrocodileW_DamageAgi
            set g = CreateGroup()
            set pullGroup = CreateGroup()
            set e = EffectSpawnScale("war3mapImported\\wos_file00000862.mdl",x,y,0,1,0.01,0,0.51,0.01,radius/1200)
            set e2 = EffectSpawnScale("war3mapImported\\wos_az_f076big.mdl",x,y,0,1,0.01,0,0.3,0.01,1)
            call SetUnitAnimationByIndex(c,CrocodileW_Animation)
            call MakeSound("war3mapImported\\Hero_Crocodile_W")
            return true
        endmethod


    endstruct

    private function CrocodileW_ReceiveQ takes nothing returns boolean
        call CrocodileW_Struct.CrocodileW_RecordQ(CrocodileW_QSource,CrocodileW_QStartX,CrocodileW_QStartY,CrocodileW_QAngle,CrocodileW_QFrom,CrocodileW_QTo,CrocodileW_QRadius)
        return false
    endfunction

//================================ Crocodile E - Crescent Cutlass ========================================
    private struct CrocodileE_Struct
        static integer array m
        static integer MUI = -1
        unit c
        real useCooldown
        real charge1
        real charge2
        real charge3
        integer shownCharges
        boolean castPauseHeld
        boolean active
        boolean cancelDash
        boolean movementStopped
        integer decorKey
        real x
        real y
        real a
        real dirX
        real dirY
        real moveStep
        real pulseDamage
        real r
        integer check 
        real rmax
        real duration
        real moveDelay
        real distance
        real maxDistance
        real radius
        real dmg
        group g
        effect e
        effect e2
        effect e3

        boolean hitStarted
        real hitRemaining
        real hitPulse
        real hitInterval
        integer hitTicks
        integer hitMaxTicks
        real hitX
        real hitY
        real elapsed
        real animationRate
        real slashRate
        boolean hitSlowed

        method CrocodileE_SetTimeScale takes real speed returns nothing
            set animationRate = speed
            set slashRate = speed
            call SetUnitTimeScale(c,speed)
            if e != null then
                call BlzSetSpecialEffectTimeScale(e,speed)
            endif
            if e2 != null then
                call BlzSetSpecialEffectTimeScale(e2,speed)
            endif
            if e3 != null then
                call BlzSetSpecialEffectTimeScale(e3,speed)
            endif
        endmethod

        method CrocodileE_BreakSlash takes nothing returns nothing
            if e2 != null then
                call BlzSetSpecialEffectTimeScale(e2,1.0)
                call BlzPlaySpecialEffect(e2,ANIM_TYPE_DEATH)
                call ColorEffDummy3(e2,0,255,255,255,0.15)
                // The fade helper owns destruction; only the caster keeps moving.
                set e2 = null
                set slashRate = 0.0
            endif
        endmethod

        method CrocodileE_Finish takes nothing returns nothing
            // Release the cast before sand/VFX helpers can execute other code.
            set active = false
            call FlushChildHashtable(CrocodileDecorHits,decorKey)
            if castPauseHeld then
                set castPauseHeld = false
                call StopSpellUnit(c)
            endif
            if LoadInteger(CrocodileTable,GetHandleId(c),CrocodileT_PhaseKey) == 0 then
                call SetUnitTimeScale(c,1.0)
            endif
            call DestroyGroup(g)
            set g = null
            if e != null then
                call BlzSetSpecialEffectTimeScale(e,1.0)
                call MyRemoveEff(e,0.3)
                set e = null
            endif
            if e3 != null then
                call BlzSetSpecialEffectTimeScale(e3,1.0)
                call MyRemoveEff(e3,0.3)
                set e3 = null
            endif
            call CrocodileE_BreakSlash()
            if not cancelDash and SpellBoolCaster(c) and not hitStarted and distance + 0.001 >= maxDistance then
                call CrocodileSand_Struct.CrocodileSand_Start(c,GetUnitX(c)+CrocodileE_HitOffset*dirX,GetUnitY(c)+CrocodileE_HitOffset*dirY,CrocodileE_SandAoe,false)
            endif
        endmethod

        method CrocodileE_DamagePulse takes nothing returns nothing
            local unit u
            call GroupEnumUnitsInRange(g,hitX,hitY,radius,NoDecor_Cond)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null or cancelDash or not SpellBoolCaster(c)
                call GroupRemoveUnit(g,u)
                if SpellBool(u) and IsUnitEnemy(u,GetOwningPlayer(c)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) then
                    call dmgphys(c,u,pulseDamage)
                    call SlowUnit(c,u,CrocodileE_Slow,2)
                    call DestroyEffect(AddSpecialEffectTarget("Units\\Critters\\Albatross\\Albatross.mdl",u,"chest"))
                endif
            endloop
            set u = null
        endmethod


        method CrocodileE_TryContact takes real oldX, real oldY returns nothing
            local unit u
            local real dx = x-oldX
            local real dy = y-oldY
            local real lengthSq = dx*dx+dy*dy
            local real frontX = oldX+CrocodileE_HitOffset*dirX
            local real frontY = oldY+CrocodileE_HitOffset*dirY
            local real fraction
            local real bestFraction = 2.0
            local real targetX = 0.0
            local real targetY = 0.0
            local real nearX
            local real nearY
            local real targetDX
            local real targetDY
            local real unitX
            local real unitY
            local real radiusSq = radius*radius
            // Broad scan once, then test distance to the swept front circle.
            call GroupEnumUnitsInRange(g,frontX+dx/2,frontY+dy/2,radius+SquareRoot(lengthSq)/2,NoDecor_Cond)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                call GroupRemoveUnit(g,u)
                if SpellBool(u) and IsUnitEnemy(u,GetOwningPlayer(c)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) then
                    set unitX = GetUnitX(u)
                    set unitY = GetUnitY(u)
                    if (unitX-oldX)*dirX+(unitY-oldY)*dirY >= 0.0 then
                        set fraction = 0.0
                        set targetDX = unitX-frontX
                        set targetDY = unitY-frontY
                        if lengthSq > 0.001 and targetDX*targetDX+targetDY*targetDY > radiusSq then
                            set fraction = RMaxBJ(0.0,RMinBJ(1.0,(targetDX*dx+targetDY*dy)/lengthSq))
                        endif
                        set nearX = unitX-frontX-fraction*dx
                        set nearY = unitY-frontY-fraction*dy
                        if fraction < bestFraction and nearX*nearX+nearY*nearY <= radiusSq then
                            set bestFraction = fraction
                            set targetX = unitX
                            set targetY = unitY
                        endif
                    endif
                endif
            endloop
            if bestFraction <= 1.0 then
                set hitStarted = true
                call MoveUnit(c,SquareRoot(lengthSq)*(bestFraction-1.0),a)
                set x = GetUnitX(c)
                set y = GetUnitY(c)
                if e2 != null then
                    call MoveEff(e2,SR0(GetEffX(e2),GetEffY(e2),x+100*dirX,y+100*dirY),Atan2(y+100*dirY-GetEffY(e2),x+100*dirX-GetEffX(e2)))
                endif
                set hitX = x+CrocodileE_HitOffset*dirX
                set hitY = y+CrocodileE_HitOffset*dirY
                set hitRemaining = RMaxBJ(CrocodilePeriod,CrocodileE_HitDelay)
                if elapsed+0.001 >= CrocodileE_HitSlowTime then
                    set hitSlowed = true
                    call CrocodileE_SetTimeScale(CrocodileE_HitAnimationSpeed)
                endif
                call DestroyEffect(EffectSpawn("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl",hitX,hitY,0,1,radius/150.0,0))
                // Contact deals damage immediately; animation progress never gates it.
                set hitTicks = 1
                call CrocodileE_DamagePulse()
                if hitTicks >= hitMaxTicks then
                    set hitRemaining = 0.0
                    call CrocodileE_SetTimeScale(1.0)
                    call CrocodileE_BreakSlash()
                endif
                call CrocodileSand_Struct.CrocodileSand_Start(c,targetX,targetY,CrocodileE_SandAoe,false)
            endif
            set u = null
        endmethod

        static method Loop_CrocodileE takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer count
            local integer capacity
            local real remaining
            local real step
            local real oldX
            local real oldY
            loop
                exitwhen i > MUI
                set this = m[i]
//---------------- E: three independent recharge clocks ----------------------
                // Check the bound before UI, movement and hit helpers. If a
                // previous tick aborted in one of them, the cast still unlocks.
                if active then
                    set elapsed = elapsed+CrocodilePeriod
                    if cancelDash or elapsed + 0.001 >= rmax or not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                        call CrocodileE_Finish()
                    endif
                endif
                set useCooldown = RMaxBJ(0.0,useCooldown-CrocodilePeriod)
                set charge1 = RMaxBJ(0.0,charge1-CrocodilePeriod)
                set charge2 = RMaxBJ(0.0,charge2-CrocodilePeriod)
                set charge3 = RMaxBJ(0.0,charge3-CrocodilePeriod)
                set count = 0
                set capacity = CrocodileE_MaxCharges(c)
                set remaining = 999999.0
                if capacity >= 1 and charge1 == 0.0 then
                    set count = count + 1
                elseif capacity >= 1 then
                    set remaining = RMinBJ(remaining,charge1)
                endif
                if capacity >= 2 and charge2 == 0.0 then
                    set count = count + 1
                elseif capacity >= 2 then
                    set remaining = RMinBJ(remaining,charge2)
                endif
                if capacity >= 3 and charge3 == 0.0 then
                    set count = count + 1
                elseif capacity >= 3 then
                    set remaining = RMinBJ(remaining,charge3)
                endif
                if count > 0 or capacity == 0 then
                    set remaining = 0.0
                endif
                set remaining = RMaxBJ(remaining,useCooldown)
                if remaining <= 0.0 then
                    if BlzGetUnitAbilityCooldownRemaining(c,CrocodileE_ID) > 0.0 then
                        call BlzEndUnitAbilityCooldown(c,CrocodileE_ID)
                    endif
                elseif BlzGetUnitAbilityCooldownRemaining(c,CrocodileE_ID) < remaining then
                    call BlzStartUnitAbilityCooldown(c,CrocodileE_ID,remaining)
                endif
                if count != shownCharges and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 then
                    set shownCharges = count
                    call TasAbilityChargeBox_SetValue(c,CrocodileE_ID,I2S(count))
                endif
//---------------- E dash and damage: variables belong to E only ------------
                if active then
                    if not cancelDash and SpellBoolCaster(c) and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 then
                    if hitRemaining > 0.0 then
                        if not hitSlowed and elapsed+0.001 >= CrocodileE_HitSlowTime then
                            set hitSlowed = true
                            call CrocodileE_SetTimeScale(CrocodileE_HitAnimationSpeed)
                        endif
                        // Freeze the movement clock while dealing exactly five pulses.
                        set hitRemaining = RMaxBJ(0.0,RoundReal(hitRemaining-CrocodilePeriod,3))
                        set hitPulse = hitPulse+CrocodilePeriod
                        loop
                            exitwhen cancelDash or not SpellBoolCaster(c) or hitTicks >= hitMaxTicks or (hitPulse+0.001 < hitInterval and hitRemaining > 0.0)
                            set hitPulse = hitPulse-hitInterval
                            set hitTicks = hitTicks+1
                            call CrocodileE_DamagePulse()
                        endloop
                        if hitTicks >= hitMaxTicks then
                            set hitRemaining = 0.0
                            call CrocodileE_SetTimeScale(1.0)
                            call CrocodileE_BreakSlash()
                        endif
                    endif
                    if hitRemaining <= 0.0 and not cancelDash and SpellBoolCaster(c) then
                    set r = RoundReal(r+CrocodilePeriod,3)
                    if r >= moveDelay and check == 0 then 
                    set animationRate = 0.4
                    set slashRate = 1.0
                    call SetUnitTimeScale(c,animationRate)
                    set check = 1                    
                    if e2 != null then
                        call BlzSetSpecialEffectTimeScale(e2,1)
                    endif
                    endif
                    if r > moveDelay then
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        set oldX = x
                        set oldY = y
                        if hitRemaining <= 0.0 and not movementStopped then
                            set step = RMinBJ(moveStep,maxDistance-distance)
                            if not IsTerrainPathable(x+step*dirX,y+step*dirY,PATHING_TYPE_WALKABILITY) then
                                call MoveUnit(c,step,a)
                                if e2 != null then
                                    call MoveEff(e2,SR0(oldX,oldY,GetUnitX(c),GetUnitY(c)),a)
                                endif
                            endif
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            // MAIN can refuse MoveUnit at the arena boundary,
                            // as can terrain pathing. Do not wait for distance
                            // that this dash can no longer cover.
                            if step > 0.001 and SR0(x,y,oldX,oldY) <= 0.001 then
                                set movementStopped = true
                            endif
                            if not hitStarted then
                                call CrocodileE_TryContact(oldX,oldY)
                            endif
                            call DecorRemoveLine(c,oldX+CrocodileE_HitOffset*dirX,oldY+CrocodileE_HitOffset*dirY,a,SR0(x,y,oldX,oldY),radius,20.0,CrocodileDecorHits,decorKey)
                            set distance = distance+SR0(x,y,oldX,oldY)
                        endif
                    endif
                    endif
                    endif
                    if cancelDash or ((movementStopped or distance + 0.001 >= maxDistance) and hitRemaining <= 0.0) or not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                        call CrocodileE_Finish()
                    endif
                endif
                if LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                    call RemoveSavedInteger(CrocodileTable,GetHandleId(c),CrocodileE_DataKey)
                    call TasAbilityChargeBox_ClearValue(c,CrocodileE_ID)
                    set c = null
                    set m[i] = m[MUI]
                    set MUI = MUI - 1
                    call destroy()
                    if MUI == -1 then
                        call GearTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
        endmethod

        static method CrocodileE_Register takes unit NewC returns nothing
            local thistype this = thistype.allocate()
            set MUI = MUI + 1
            set m[MUI] = this
            if MUI == 0 then
                call GearTimer03Acquire()
            endif
            set c = NewC
            set useCooldown = 0.0
            set charge1 = 0.0
            set charge2 = 0.0
            set charge3 = 0.0
            set shownCharges = CrocodileE_MaxCharges(c)
            set castPauseHeld = false
            set active = false
            set cancelDash = false
            set g = null
            set e = null
            call SaveInteger(CrocodileTable,GetHandleId(c),CrocodileE_DataKey,this)
            call TasAbilityChargeBox_SetValue(c,CrocodileE_ID,I2S(shownCharges))
        endmethod

        static method CrocodileE_Begin takes unit NewC, real NewX, real NewY returns boolean
            local thistype this = LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileE_DataKey)
            local integer capacity = CrocodileE_MaxCharges(NewC)
            local real recharge = CrocodileE_RechargeTime(NewC)
            if LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileCore_DataKey) == 0 or IsUnitIllusion(NewC) or not SpellBoolCaster(NewC) or LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileT_PhaseKey) != 0 then
                return false
            endif
            if this == 0 or active or useCooldown > 0.0 or CrocodileE_Duration <= 0.0 then
                return false
            endif
            if capacity >= 1 and charge1 == 0.0 then
                set charge1 = recharge
            elseif capacity >= 2 and charge2 == 0.0 then
                set charge2 = recharge
            elseif capacity >= 3 and charge3 == 0.0 then
                set charge3 = recharge
            else
                return false
            endif
            set useCooldown = CrocodileE_UseCD
            call BlzStartUnitAbilityCooldown(c,CrocodileE_ID,useCooldown)
            set active = true
            set cancelDash = false
            set movementStopped = false
            set decorKey = CrocodileDecor_NewKey()
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set a = Atan2(NewY-y,NewX-x)
            set dirX = Cos(a)
            set dirY = Sin(a)
            set r = 0.0
            set check = 0
            set duration = CrocodileE_Duration
            set moveDelay = RMaxBJ(0.0,CrocodileE_MoveDelay)
            set distance = 0.0
            set maxDistance = CrocodileE_Distance //RMinBJ(CrocodileE_Distance,SR3(c,NewX,NewY))
            set moveStep = maxDistance*CrocodilePeriod/duration
            set radius = CrocodileE_Aoe
            set dmg = GetHeroAgi(c,true)*(CrocodileE_DamageAgiBase+CrocodileE_DamageAgiStep*(GetUnitAbilityLevel(c,CrocodileE_ID)-1))
            set hitStarted = false
            // Correct for a cast between shared timer ticks.
            set elapsed = -TimerGetElapsed(GearTimer03)
            set animationRate = 5.5
            set slashRate = 0.0
            set hitSlowed = false
            set hitRemaining = 0.0
            set hitPulse = 0.0
            set hitTicks = 0
            set hitMaxTicks = IMaxBJ(1,CrocodileE_HitTicks)
            set rmax = moveDelay+duration+RMaxBJ(CrocodilePeriod,CrocodileE_HitDelay)+(hitMaxTicks+2)*CrocodilePeriod
            set pulseDamage = dmg/hitMaxTicks
            set hitInterval = RMaxBJ(CrocodilePeriod,CrocodileE_HitDelay/IMaxBJ(1,hitMaxTicks-1))
            set g = CreateGroup()
            set e = null
            set e2 = null
            set e3 = null
            set castPauseHeld = true
            call StartSpellUnit(c)
//---------------- E effect --------------------------------------------------
            //set e = AddSpecialEffectTarget("war3mapImported\\wos_Death_Spell2.mdl",c,"hand right")
            set e = AddSpecialEffectTarget("war3mapImported\\wos_[DoFT]CrocodileSandSekiro.mdl",c,"hand right")
            set e3 = AddSpecialEffectTarget("war3mapImported\\wos_[DoFT]CrocodileSanding2.mdl",c,"hand right")
       
            call SetUnitAnimationByIndex(c,CrocodileE_Animation)
            call SetUnitTimeScale(c,animationRate)
            set e2 = EffectSpawn3("war3mapImported\\wos_tx-084.mdl",GetUnitX(c)+100*dirX,GetUnitY(c)+100*dirY,a*bj_RADTODEG+0,0.55,CrocodileE_SlashScale+0.24,175,0)
            call BlzSetSpecialEffectAlpha(e2,0)
            call BlzSetSpecialEffectTimeScale(e2,0)
            call ColorEffDummy4(e2,0,255,255,255,0.35)
            call MakeSound("war3mapImported\\Hero_Crocodile_E")
            if GetRandomInt(1,2) == 1 then 
            call MakeSound("war3mapImported\\Hero_Crocodile_E2")
            else 
            call MakeSound("war3mapImported\\Hero_Crocodile_E3")
            endif
            return true
        endmethod


    endstruct

//================================ Crocodile R - Sables ========================================
    private struct CrocodileR_Target
        unit u
        integer owner
        integer previous
        integer next
        real a
        real lift
    endstruct

    private struct CrocodileR_Struct
        static integer array m
        static integer MUI = -1
        unit c
        real x
        real y
        real a
        real r
        real rmax
        real baseDuration
        real decorPulse
        real decorX
        real decorY
        integer decorKey
        real visionX
        real visionY
        real visionPulse
        integer hits
        integer maxHits
        real sandDistance
        real radius
        real dmg
        group g
        integer captured
        effect e
        effect e2
        boolean castPauseHeld
        boolean endNow

        boolean stoppedByW
        real wCenterX
        real wCenterY
        real nextComboEffect

        method CrocodileR_Release takes unit u returns nothing
            local CrocodileR_Target target = LoadInteger(CrocodileTable,GetHandleId(u),CrocodileR_TargetKey)
            local CrocodileR_Target other
            if target == 0 or target.owner != this then
                return
            endif
            // Saved handles also cover units removed from Warcraft's native groups.
            if target.previous == 0 then
                set captured = target.next
            else
                set other = target.previous
                set other.next = target.next
            endif
            if target.next != 0 then
                set other = target.next
                set other.previous = target.previous
            endif
            if GetUnitTypeId(u) != 0 then
                call HeightSet(u,0.5,0)
            endif
            call RemoveSavedInteger(CrocodileTable,GetHandleId(u),CrocodileR_TargetKey)
            set target.u = null
            call target.destroy()
        endmethod

        method CrocodileR_ReleaseAll takes nothing returns nothing
            local CrocodileR_Target target
            loop
                exitwhen captured == 0
                set target = captured
                call CrocodileR_Release(target.u)
            endloop
        endmethod

        static method CrocodileR_Death takes unit dead returns nothing
            local integer i = 0
            local thistype this
            local CrocodileR_Target target = LoadInteger(CrocodileTable,GetHandleId(dead),CrocodileR_TargetKey)
            if target != 0 then
                set this = target.owner
                call CrocodileR_Release(dead)
            endif
            loop
                exitwhen i > MUI
                set this = m[i]
                if c == dead then
                    set endNow = true
                    call CrocodileR_ReleaseAll()
                endif
                set i = i + 1
            endloop
        endmethod

        static method Loop_CrocodileR takes nothing returns nothing
            local integer i = 0
            local integer next
            local CrocodileR_Target target
            local CrocodileR_Target other
            local thistype this
            local unit u
            local real step
            local real angle
            local real sandSpacing
            local real trailOffset
            local real targetX
            local real targetY
            local boolean damageTick
            local integer j
            local CrocodileW_Struct pit
            local CrocodileW_Struct nearest
            local real dx
            local real dy
            local real distanceSq
            local real nearestSq
            local real sizeMultiplier
            loop
                exitwhen i > MUI
                set this = m[i]
                set r = RoundReal(r+CrocodilePeriod,3)
                set damageTick = hits < maxHits and r+0.001 >= (hits+1)*baseDuration/maxHits
                if castPauseHeld and (r + 0.001 >= CrocodileR_CastTime or endNow or not SpellBoolCaster(c)) then
                    set castPauseHeld = false
                    call StopSpellUnit2(c)
                endif
                if not endNow and SpellBoolCaster(c) and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 then
                    set step = 0.0
                    if not stoppedByW then
                        set step = CrocodileR_Speed*CrocodilePeriod
                        call MoveEff(e,step,a)
                        call MoveEff(e2,step,a)
                        set step = SR0(x,y,GetEffX(e),GetEffY(e))
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        set sandDistance = sandDistance + step
                        set sandSpacing = RMaxBJ(CrocodileSand_MinDistance,CrocodileR_SandSpacing)
                        loop
                            exitwhen sandDistance + 0.001 < sandSpacing
                            set trailOffset = sandDistance-sandSpacing
                            // Fresh patches only: shared spacing check skips existing sand.
                            call CrocodileSand_Struct.CrocodileSand_Start(c,x-trailOffset*Cos(a),y-trailOffset*Sin(a),GetRandomReal(350,425),true)
                            set sandDistance = sandDistance-sandSpacing
                        endloop
                        // Only the inner zone of an active own W can guide R to its center.
                        set nearest = 0
                        set nearestSq = RMaxBJ(0.0,CrocodileWR_ComboCenterRadius)*RMaxBJ(0.0,CrocodileWR_ComboCenterRadius)
                        set j = 0
                        loop
                            exitwhen j > CrocodileW_Struct.MUI
                            set pit = CrocodileW_Struct.m[j]
                            if pit.c == c and pit.r > 0.51 and pit.r+0.001 < pit.rmax then
                                set dx = x-pit.x
                                set dy = y-pit.y
                                set distanceSq = dx*dx+dy*dy
                                if distanceSq <= nearestSq then
                                    set nearestSq = distanceSq
                                    set nearest = pit
                                endif
                            endif
                            set j = j+1
                        endloop
                        if nearest != 0 and r+0.001 < rmax then
                            set stoppedByW = true
                            set wCenterX = nearest.x
                            set wCenterY = nearest.y
                            set rmax = rmax+RMaxBJ(0.0,CrocodileWR_DurationBonus)
                            set nearest.rmax = nearest.rmax+RMaxBJ(0.0,CrocodileWR_DurationBonus)
                            set nextComboEffect = r
                            call BlzSetSpecialEffectScale(e2,BlzGetSpecialEffectScale(e2)*CrocodileWR_SizeMultiplier)
                        endif
                    else
                        // Cache coordinates, not a W struct that could already have been destroyed.
                        set step = RMinBJ(CrocodileR_Speed*CrocodilePeriod,SR0(x,y,wCenterX,wCenterY))
                        if step > 0.001 then
                            set angle = Atan2(wCenterY-y,wCenterX-x)
                            call MoveEff(e,step,angle)
                            call MoveEff(e2,step,angle)
                            set step = SR0(x,y,GetEffX(e),GetEffY(e))
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                        endif
                    endif
                    set sizeMultiplier = 1.0
                    if stoppedByW then
                        set sizeMultiplier = CrocodileWR_SizeMultiplier
                        if r+0.001 >= nextComboEffect then
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_3.mdx",x,y,GetRandomReal(0,359),1.0,CrocodileWR_ComboEffectScale,CrocodileWR_ComboEffectHeight,CrocodileSandColorR,CrocodileSandColorG,CrocodileSandColorB,255))
                            set nextComboEffect = nextComboEffect+RMaxBJ(CrocodilePeriod,CrocodileWR_ComboEffectPeriod)
                        endif
                    endif
                    set radius = CrocodileR_StartAoe + (CrocodileR_EndAoe-CrocodileR_StartAoe)*RMinBJ(1.0,r/RMaxBJ(baseDuration,CrocodilePeriod))
                    set radius = radius*sizeMultiplier
                    set decorPulse = decorPulse+CrocodilePeriod
                    if decorPulse+0.001 >= 0.3 or r+0.001 >= rmax then
                        set decorPulse = RMaxBJ(0.0,decorPulse-0.3)
                        call DecorRemoveLine(c,decorX,decorY,Atan2(y-decorY,x-decorX),SR0(x,y,decorX,decorY),radius,50.0,CrocodileDecorHits,decorKey)
                        call FlushChildHashtable(CrocodileDecorHits,decorKey)
                        set decorX = x
                        set decorY = y
                    endif
                    set visionPulse = visionPulse+CrocodilePeriod
                    if SR0(x,y,visionX,visionY)+0.001 >= radius*0.5 or visionPulse+0.001 >= 1.0 or r+0.001 >= rmax then
                        call VisionTimed(GetOwningPlayer(c),x,y,radius*1.5,3.0)
                        set visionX = x
                        set visionY = y
                        set visionPulse = 0.0
                    endif
                    call BlzSetSpecialEffectScale(e,(CrocodileR_StartScale+(CrocodileR_EndScale-CrocodileR_StartScale)*RMinBJ(1.0,r/RMaxBJ(baseDuration,CrocodilePeriod)))*sizeMultiplier)
                    call GroupEnumUnitsInRange(g,x,y,radius,NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        call GroupRemoveUnit(g,u)
                        if SpellBool(u) and IsUnitEnemy(u,GetOwningPlayer(c)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) and not GearCCProtected(u) and LoadInteger(CrocodileTable,GetHandleId(u),CrocodileR_TargetKey) == 0 then
                            set target = CrocodileR_Target.create()
                            set target.u = u
                            set target.owner = this
                            set target.a = Atan2(GetUnitY(u)-y,GetUnitX(u)-x)
                            set target.lift = 0.0
                            set target.previous = 0
                            set target.next = captured
                            if captured != 0 then
                                set other = captured
                                set other.previous = target
                            endif
                            set captured = target
                            call SaveInteger(CrocodileTable,GetHandleId(u),CrocodileR_TargetKey,target)
                            call StunUnit(c,u,CrocodileR_StunTime)
                        endif
                    endloop
                    // Iterate saved records independently of native group membership.
                    set target = captured
                    loop
                        exitwhen target == 0 or endNow
                        set next = target.next
                        set u = target.u
                        if GetUnitTypeId(u) == 0 or not SpellBool(u) or not IsUnitEnemy(u,GetOwningPlayer(c)) or GearCCProtected(u) or SR3(u,x,y) > radius+step then
                            call CrocodileR_Release(u)
                        else
                            set angle = target.a+CrocodileR_OrbitSpeed*bj_DEGTORAD*CrocodilePeriod
                            set target.a = angle
                            set target.lift = RMinBJ(CrocodileR_Height,target.lift+CrocodileR_LiftSpeed*CrocodilePeriod)
                            call SetFly(u,target.lift*(0.85+0.15*Sin(angle)))
                            set targetX = x+radius*CrocodileR_OrbitRadius*Cos(angle)
                            set targetY = y+radius*CrocodileR_OrbitRadius*Sin(angle)
                            call MoveUnit(u,RMinBJ(CrocodileR_PullSpeed*CrocodilePeriod,SR3(u,targetX,targetY)),Atan2(targetY-GetUnitY(u),targetX-GetUnitX(u)))
                            if damageTick then
                                call dmgphys(c,u,dmg)
                                call Crocodile_ApplySharedMark(c,u)
                            endif
                        endif
                        set target = next
                    endloop
                    if damageTick then
                        set hits = hits+1
                    endif
                endif
                if endNow or r + 0.001 >= rmax or not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                    if castPauseHeld then
                        set castPauseHeld = false
                        call StopSpellUnit2(c)
                    endif
                    call CrocodileR_ReleaseAll()
                    call DestroyEffect(e)
                    call FlushChildHashtable(CrocodileDecorHits,decorKey)
                    call DestroyEffect(e2)
                    call DestroyGroup(g)
                    set c = null
                    set e = null
                    set e2 = null
                    set g = null
                    set m[i] = m[MUI]
                    set MUI = MUI - 1
                    call destroy()
                    if MUI == -1 then
                        call GearTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        static method CrocodileR_Begin takes unit NewC, real NewX, real NewY returns boolean
            local thistype this
            if LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileCore_DataKey) == 0 or IsUnitIllusion(NewC) or not SpellBoolCaster(NewC) or LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileT_PhaseKey) != 0 or CrocodileR_Duration <= 0.0 then
                return false
            endif
            set this = thistype.allocate()
            set MUI = MUI + 1
            set m[MUI] = this
            if MUI == 0 then
                call GearTimer03Acquire()
            endif
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set a = Atan2(NewY-y,NewX-x)
            if SR3(c,NewX,NewY) < 1.0 then
                set a = GetUnitFacing(c)*bj_DEGTORAD
            endif
            set r = 0.0
            set rmax = CrocodileR_Duration
            set baseDuration = rmax
            set decorPulse = 0.0
            set decorX = x
            set decorY = y
            set decorKey = CrocodileDecor_NewKey()
            set visionPulse = 0.0
            set visionX = x
            set visionY = y
            call VisionTimed(GetOwningPlayer(c),x,y,CrocodileR_StartAoe*1.5,3.0)
            set stoppedByW = false
            set wCenterX = x
            set wCenterY = y
            set nextComboEffect = 0.0
            set hits = 0
            set maxHits = IMaxBJ(1,CrocodileR_Hits)
            set sandDistance = 0.0
            set radius = CrocodileR_StartAoe
            set dmg = GetHeroAgi(c,true)*CrocodileR_DamageAgi
            set g = CreateGroup()
            set captured = 0
            set castPauseHeld = true
            call StartSpellUnit2(c)
            set endNow = false
//---------------- R effect --------------------------------------------------
            set e = EffectSpawn("war3mapImported\\wos_file00000867.mdl",x,y,0,1,CrocodileR_StartScale,0)
            set e2 = EffectSpawn("war3mapImported\\wos_file00000862.mdl",x,y,0,2,CrocodileR_StartScale,0)
            call SetUnitAnimationByIndex(c,CrocodileR_Animation)
            
            call MakeSound("war3mapImported\\Hero_Crocodile_R_2")
            call MakeSound("war3mapImported\\Hero_Crocodile_R2")
            call NextSound("war3mapImported\\Hero_Crocodile_R6",0.8)
            return true
        endmethod
    endstruct

//================================ Crocodile T - Ground Secco ========================================
    // Owned through one cast's linked lists; patches do not acquire timers or scan units.
    private struct CrocodileT_Sand
        integer next
        integer growthNext
        real x
        real y
        real radius
        real targetScale
        real age
        real growTime
        boolean blastMarked
        boolean fromT
        effect e

        static method CrocodileTSand_Create takes real NewX, real NewY, real NewScale, real NewGrowTime, real angle returns thistype
            local thistype this = thistype.allocate()
            set next = 0
            set growthNext = 0
            set x = NewX
            set y = NewY
            set radius = NewScale*150.0
            set targetScale = radius/165.0*CrocodileT_SandVisualScale
            set age = 0.0
            set growTime = RMaxBJ(CrocodilePeriod,NewGrowTime)
            set blastMarked = false
            set fromT = true
            // Same stationary sand model and visual radius as the passive trails.
            set e = EffectSpawn("war3mapImported\\wos_ysjsm45.mdl",x,y,angle,0.5,targetScale*0.1,0.0)
            call BlzSetSpecialEffectAlpha(e,CrocodileT_SandAlpha)
            return this
        endmethod

        static method CrocodileTSand_Collect takes CrocodileSand_Struct sand returns thistype
            local thistype this = thistype.allocate()
            set next = 0
            set growthNext = 0
            set x = sand.x
            set y = sand.y
            set radius = sand.radius
            set targetScale = radius/165.0
            set age = 0.0
            set growTime = CrocodilePeriod
            set blastMarked = false
            set fromT = false
            set e = sand.e
            set sand.e = null
            set sand.endNow = true
            return this
        endmethod

        method CrocodileTSand_Release takes boolean instant returns nothing
    if instant then
        call BlzSetSpecialEffectScale(e,0.0)
        call BlzSetSpecialEffectAlpha(e,0)
        call BlzSetSpecialEffectZ(e,-10000.0)
        call DestroyEffect(e)
    else
        call ColorEffDummy3(e,0,255,255,255,0.45)
    endif

    set e = null
    call destroy()
endmethod
    endstruct

    // One moving front per direction; no timers or unit enumeration per effect.
    private struct CrocodileT_Wave
        integer next
        real a
        real distance
        effect e

        static method CrocodileTWave_Create takes real x, real y, real angle, real scale returns thistype
            local thistype this = thistype.allocate()
            set next = 0
            set a = angle
            set distance = 0.0
            set e = EffectSpawn("war3mapImported\\wos_[DoFT]CrocodileSanding3.mdl",x,y,angle*bj_RADTODEG,1.0,scale*0.1,0.0)
            call BlzSetSpecialEffectAlpha(e,CrocodileT_SandAlpha)
            return this
        endmethod

        method CrocodileTWave_Release takes boolean instant returns nothing
            if instant then
                call BlzSetSpecialEffectAlpha(e,0)
                call DestroyEffect(e)
            else
                call ColorEffDummy3Alpha(e,0.0,255,255,255,CrocodileT_SandAlpha,CrocodileT_WaveFadeTime)
            endif
            set e = null
            call destroy()
        endmethod
    endstruct

    private struct CrocodileT_Struct
        static integer array m
        static integer MUI = -1
        unit c
        real x
        real y
        real r
        real spreadTime
        real windowTime
        real endTime
        real areaRadius
        real outerRadius
        real nextRing
        real ringSpacing
        real patchSpacing
        real minDistanceSq
        real minScale
        real maxScale
        real growTime
        real ringBuildTime
        real buildDeadline
        real maxReach
        real waveScaleMin
        real waveScaleMax
        real nextSound3
        real t2Time
        real controlTime
        integer ringIndex
        integer ringPoint
        integer ringPoints
        integer patchHead
        integer growthHead
        integer patchCount
        integer waveHead
        boolean spreading
        boolean channelActive
        boolean invulnerabilityHeld
        boolean spreadComplete
        real manaPulse
        real decorPulse
        real visionPulse
        group manaGroup
        boolean animationApplied
        boolean channelFinished
        boolean sound2Played
        boolean t2Pending
        boolean t2PauseHeld
        boolean t2Granted
        boolean t2Available
        timer t2Timer
        boolean endNow
        effect aura

        method CrocodileT_Contains takes real px, real py returns boolean
            local CrocodileT_Sand patch = patchHead
            local real dx
            local real dy
            loop
                exitwhen patch == 0
                set dx = px-patch.x
                set dy = py-patch.y
                if dx*dx+dy*dy <= patch.radius*patch.radius then
                    return true
                endif
                set patch = patch.next
            endloop
            return false
        endmethod

        method CrocodileT_UpdateGrowth takes boolean finish returns nothing
            local CrocodileT_Sand patch = growthHead
            local CrocodileT_Sand previous = 0
            local CrocodileT_Sand following
            loop
                exitwhen patch == 0
                set following = patch.growthNext
                set patch.age = patch.age+CrocodilePeriod
                if finish or patch.age+0.001 >= patch.growTime then
                    call BlzSetSpecialEffectScale(patch.e,patch.targetScale)
                    if previous == 0 then
                        set growthHead = following
                    else
                        set previous.growthNext = following
                    endif
                    set patch.growthNext = 0
                else
                    call BlzSetSpecialEffectScale(patch.e,patch.targetScale*(0.1+0.9*patch.age/patch.growTime))
                    set previous = patch
                endif
                set patch = following
            endloop
        endmethod

        method CrocodileT_AddPatch takes real px, real py, real scale, real angle returns nothing
            local CrocodileT_Sand patch = patchHead
            local real dx
            local real dy
            if patchCount >= IMaxBJ(1,CrocodileT_MaxPatches) then
                return
            endif
            loop
                exitwhen patch == 0
                set dx = px-patch.x
                set dy = py-patch.y
                if dx*dx+dy*dy < minDistanceSq then
                    return
                endif
                set patch = patch.next
            endloop
            set patch = CrocodileT_Sand.CrocodileTSand_Create(px,py,scale,RMinBJ(growTime,RMaxBJ(CrocodilePeriod,spreadTime-r)),angle)
            set patch.next = patchHead
            set patchHead = patch
            set patch.growthNext = growthHead
            set growthHead = patch
            set patchCount = patchCount+1
            set maxReach = RMaxBJ(maxReach,SR0(x,y,px,py)+patch.radius)
        endmethod

        method CrocodileT_CreateWaves takes nothing returns nothing
            local integer count = IMaxBJ(1,IMinBJ(IMaxBJ(1,CrocodileT_MaxWaves),R2I(2.0*bj_PI*outerRadius/RMaxBJ(1.0,CrocodileT_WaveSpacing))+1))
            local integer i = 0
            local CrocodileT_Wave wave
            loop
                exitwhen i >= count
                set wave = CrocodileT_Wave.CrocodileTWave_Create(x,y,2.0*bj_PI*i/count,waveScaleMin)
                set wave.next = waveHead
                set waveHead = wave
                set i = i+1
            endloop
        endmethod

        method CrocodileT_MoveWaves takes nothing returns nothing
            local CrocodileT_Wave wave = waveHead
            local real progress = RMinBJ(1.0,r/spreadTime)
            local real distance = areaRadius*progress
            local real scale = waveScaleMin+(waveScaleMax-waveScaleMin)*progress
            loop
                exitwhen wave == 0
                call MoveEff(wave.e,RMaxBJ(0.0,distance-wave.distance),wave.a)
                set wave.distance = distance
                call BlzSetSpecialEffectScale(wave.e,scale*RMinBJ(1.0,0.1+0.9*r/growTime))
                set wave = wave.next
            endloop
        endmethod

        method CrocodileT_ClearWaves takes boolean instant returns nothing
            local CrocodileT_Wave wave = waveHead
            local CrocodileT_Wave following
            loop
                exitwhen wave == 0
                set following = wave.next
                call wave.CrocodileTWave_Release(instant)
                set wave = following
            endloop
            set waveHead = 0
        endmethod

        method CrocodileT_Spread takes nothing returns nothing
            local integer spawned = 0
            local real due
            local real progress
            local real angle
            local real scale
            loop
                exitwhen nextRing > outerRadius+0.001 or patchCount >= IMaxBJ(1,CrocodileT_MaxPatches) or spawned >= IMaxBJ(1,CrocodileT_SpawnsPerTick)
                if ringPoint == 0 then
                    set ringPoints = IMaxBJ(1,R2I(2.0*bj_PI*nextRing/patchSpacing)+1)
                endif
                set progress = nextRing/RMaxBJ(CrocodilePeriod,outerRadius)

                set due = ((nextRing+CrocodileT_PatchBehindWave)/RMaxBJ(1.0,areaRadius))*spreadTime
                set due = due+ringBuildTime*ringPoint/IMaxBJ(1,ringPoints-1)

                exitwhen r+0.001 < due
                set angle = 2.0*bj_PI*(ringPoint+0.5*ModuloInteger(ringIndex,2))/ringPoints
                set scale = minScale+(maxScale-minScale)*progress
                call CrocodileT_AddPatch(x+nextRing*Cos(angle),y+nextRing*Sin(angle),scale,angle*bj_RADTODEG)
                set spawned = spawned+1
                set ringPoint = ringPoint+1
                if ringPoint >= ringPoints then
                    set ringPoint = 0
                    set ringIndex = ringIndex+1
                    if nextRing+0.001 >= outerRadius then
                        set nextRing = outerRadius+ringSpacing
                    else
                        set nextRing = RMinBJ(outerRadius,nextRing+ringSpacing)
                    endif
                endif
            endloop
        endmethod

        // Any active Crocodile sand permits T2; explosion ownership stays per cast.
        static method CrocodileT_IsOnSand takes unit NewC returns boolean
            local thistype own = LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileT_DataKey)
            local thistype this
            local integer i = 0
            local real px = GetUnitX(NewC)
            local real py = GetUnitY(NewC)
            if own != 0 and not own.endNow and own.r < own.endTime and own.CrocodileT_Contains(px,py) then
                return true
            endif
            if CrocodileSand_Struct.CrocodileSand_IsOnGround(NewC,null) then
                return true
            endif
            loop
                exitwhen i > MUI
                set this = m[i]
                if this != own and not endNow and r < endTime and SpellBoolCaster(c) and CrocodileT_Contains(px,py) then
                    return true
                endif
                set i = i+1
            endloop
            return false
        endmethod

        method CrocodileT_PlaySounds takes nothing returns nothing
            if not sound2Played and r+0.001 >= CrocodileT_Sound2Time then
                set sound2Played = true
                call MakeSound("war3mapImported\\Hero_Crocodile_T_2")
            endif
            if r+0.001 >= nextSound3 then
                set nextSound3 = nextSound3+RMaxBJ(CrocodilePeriod,CrocodileT_Sound3Period)
                call MakeSound("war3mapImported\\Hero_Crocodile_T_3")
            endif
        endmethod

        static method CrocodileT_ControlT2 takes nothing returns nothing
            local thistype this = LoadInteger(CrocodileTable,GetHandleId(GetExpiredTimer()),CrocodileT_DataKey)
            local boolean available
            set controlTime = RoundReal(controlTime+RMaxBJ(0.01,CrocodileT2_CheckPeriod),3)
            if not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                call CrocodileT_Clear(true)
            elseif not t2Pending and r+0.001 >= endTime then
                call CrocodileT_Clear(false)
            elseif not t2Pending and controlTime+0.001 >= CrocodileT2_UnlockTime then
                if not t2Granted then
                    set t2Granted = true
                    if GetUnitAbilityLevel(c,CrocodileT2_ID) == 0 then
                        call UnitAddAbility(c,CrocodileT2_ID)
                        call UnitMakeAbilityPermanent(c,true,CrocodileT2_ID)
                    endif
                    call SetUnitAbilityLevel(c,CrocodileT2_ID,IMaxBJ(1,GetUnitAbilityLevel(c,CrocodileT_ID)))
                    call BlzEndUnitAbilityCooldown(c,CrocodileT2_ID)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c),CrocodileT_ID,false)
                endif
                set available = CrocodileT_IsOnSand(c)
                if available != t2Available then
                    set t2Available = available
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c),CrocodileT2_ID,available)
                endif
            endif
        endmethod

        method CrocodileT_EndSpread takes nothing returns nothing
            if spreadComplete then
                return
            endif
            set spreading = false
            set spreadComplete = true
            call CrocodileT_UpdateGrowth(true)
            call CrocodileT_ClearWaves(false)
        endmethod

        method CrocodileT_EndChannel takes nothing returns nothing
            if not channelActive then
                return
            endif
            set channelActive = false
            if invulnerabilityHeld then
                set invulnerabilityHeld = false
                call UnitRemoveAbility(c,'Avul')
            endif
            call CrocodileT_EndSpread()
            set endTime = r+windowTime
            call RemoveSavedInteger(CrocodileTable,GetHandleId(c),CrocodileT_PhaseKey)
            // Asta E's generic active-cast marker; it is separate from CC immunity.
            call SaveInteger(hs,GetHandleId(c),StringHash("cast r"),0)
            call SaveInteger(hs,GetHandleId(c),StringHash("stop r"),0)
            call GearCCProtect(c,false)
            if manaGroup != null then
                call DestroyGroup(manaGroup)
                set manaGroup = null
            endif
            call DestroyEffect(aura)
            set aura = null
            call SetUnitTimeScale(c,1.0)
            call SetUnitAnimation(c,"stand")
        endmethod

        method CrocodileT_DrainMana takes nothing returns nothing
            local unit u
            local real maxMana
            call GroupEnumUnitsInRange(manaGroup,x,y,maxReach,NoDecor_Cond)
            loop
                set u = FirstOfGroup(manaGroup)
                exitwhen u == null
                call GroupRemoveUnit(manaGroup,u)
                if SpellBool(u) and IsUnitEnemy(u,GetOwningPlayer(c)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) and CrocodileT_Contains(GetUnitX(u),GetUnitY(u)) then
                    call Crocodile_ApplySharedMark(c,u)
                    set maxMana = GetUnitState(u,UNIT_STATE_MAX_MANA)
                    if maxMana > 0.0 then
                        call SetMpCurrent(u,-CrocodileT_ManaDrain*maxMana)
                    endif
                endif
            endloop
            set u = null
        endmethod

        method CrocodileT_Clear takes boolean instant returns nothing
            local CrocodileT_Sand patch = patchHead
            local CrocodileT_Sand following
            local CrocodileSand_Struct sand
            local real remaining = CrocodileSand_GroundDuration-RMaxBJ(0.0,r-(endTime-windowTime))
            if endNow then
                return
            endif
            call CrocodileT_EndChannel()
            set remaining = CrocodileSand_GroundDuration-RMaxBJ(0.0,r-(endTime-windowTime))
            set endNow = true
            if t2PauseHeld then
                set t2PauseHeld = false
                call StopSpellUnit2(c)
            endif
            call RemoveSavedInteger(CrocodileTable,GetHandleId(t2Timer),CrocodileT_DataKey)
            call PauseTimer(t2Timer)
            call DestroyTimer(t2Timer)
            set t2Timer = null
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),CrocodileT2_ID,false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),CrocodileT_ID,true)
            call CrocodileT_ClearWaves(instant)
            call RemoveSavedInteger(CrocodileTable,GetHandleId(c),CrocodileT_DataKey)
            call RemoveSavedInteger(CrocodileTable,GetHandleId(c),CrocodileT_PhaseKey)
            if aura != null then
                call DestroyEffect(aura)
                set aura = null
            endif
            if spreading or t2Pending then
                call SetUnitTimeScale(c,1.0)
                call SetUnitAnimation(c,"stand")
            endif
            loop
                exitwhen patch == 0
                set following = patch.next
                if not instant and not t2Pending and remaining > 0.0 then
                    // Transfer the existing effect to the shared sand clock; do not respawn it.
                    set sand = CrocodileSand_Struct.create()
                    set CrocodileSand_Struct.MUI = CrocodileSand_Struct.MUI+1
                    set CrocodileSand_Struct.m[CrocodileSand_Struct.MUI] = sand
                    if CrocodileSand_Struct.MUI == 0 then
                        call GearTimer03Acquire()
                    endif
                    set sand.c = c
                    set sand.x = patch.x
                    set sand.y = patch.y
                    set sand.radius = patch.radius
                    set sand.r = 0.0
                    set sand.rmax = remaining
                    set sand.slowLife = 0.0
                    set sand.pulse = 0.0
                    set sand.endNow = false
                    set sand.largeVisual = patch.radius >= CrocodileSand_LargeAoe
                    set sand.e = patch.e
                    set patch.e = null
                    call patch.destroy()
                else
                    call patch.CrocodileTSand_Release(instant)
                endif
                set patch = following
            endloop
            set t2Pending = false
            set patchHead = 0
            set growthHead = 0
            set patchCount = 0
        endmethod

        static method CrocodileT_Finish takes unit NewC returns nothing
            local thistype this = LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileT_DataKey)
            if this != 0 then
                call CrocodileT_Clear(true)
            endif
        endmethod

        static method Loop_CrocodileT takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI
                set this = m[i]
                set r = RoundReal(r+CrocodilePeriod,3)
                if not endNow then
                    if not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                        call CrocodileT_Clear(true)
                    elseif t2Pending then
                        set t2Time = RoundReal(t2Time+CrocodilePeriod,3)
                        if not animationApplied and t2Time >= CrocodileT_AnimationDelay then
                            set animationApplied = true
                            call SetUnitTimeScale(c,CrocodileT_AnimationSpeed)
                            call SetUnitAnimationByIndex(c,CrocodileT_Animation)
                        endif
                    elseif channelActive then
                        if not channelFinished then
                            if not animationApplied and r >= CrocodileT_AnimationDelay then
                                set animationApplied = true
                                call SetUnitTimeScale(c,CrocodileT_AnimationSpeed)
                                call SetUnitAnimationByIndex(c,CrocodileT_Animation)
                            endif
                            call CrocodileT_PlaySounds()
                            if spreading then
                                call CrocodileT_MoveWaves()
                                call CrocodileT_UpdateGrowth(false)
                                call CrocodileT_Spread()
                                if r+0.001 >= spreadTime then
                                    call CrocodileT_EndSpread()
                                endif
                            endif
                        endif
                        // SPELL_FINISH can arrive before the shared timer's
                        // final update. Keep the due fifth pulse on a full cast.
                        if not channelFinished or r+0.001 >= CrocodileT_Duration then
                            set decorPulse = decorPulse+CrocodilePeriod
                            if decorPulse+0.001 >= 0.5 then
                                set decorPulse = decorPulse-0.5
                                call DecorRemove(c,x,y,maxReach,100.0)
                            endif
                            set visionPulse = visionPulse+CrocodilePeriod
                            if visionPulse+0.001 >= 1.0 then
                                set visionPulse = visionPulse-1.0
                                call VisionTimed(GetOwningPlayer(c),x,y,maxReach*1.5,3.0)
                            endif
                            set manaPulse = manaPulse+CrocodilePeriod
                            if manaPulse+0.001 >= CrocodileT_ManaDrainPeriod then
                                set manaPulse = manaPulse-RMaxBJ(CrocodilePeriod,CrocodileT_ManaDrainPeriod)
                                call CrocodileT_DrainMana()
                            endif
                        endif
                        if channelFinished or r+0.001 >= CrocodileT_Duration then
                            call CrocodileT_EndChannel()
                        endif
                    endif
                endif
                if endNow then
                    set c = null
                    set m[i] = m[MUI]
                    set MUI = MUI-1
                    call destroy()
                    if MUI == -1 then
                        call GearTimer03Release()
                    endif
                else
                    set i = i+1
                endif
            endloop
        endmethod

        static method CrocodileT_Begin takes unit NewC returns boolean
            local thistype this
            local CrocodileE_Struct dash = LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileE_DataKey)
            if not SpellBoolCaster(NewC) or IsUnitIllusion(NewC) or LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileCore_DataKey) == 0 or LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileT_DataKey) != 0 then
                return false
            endif
            set this = thistype.allocate()
            set MUI = MUI+1
            set m[MUI] = this
            if MUI == 0 then
                call GearTimer03Acquire()
            endif
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = -TimerGetElapsed(GearTimer03)
            set spreadTime = RMaxBJ(CrocodilePeriod,CrocodileT_SpreadTime)
            set nextSound3 = RMaxBJ(CrocodilePeriod,CrocodileT_Sound3Period)
            set t2Time = 0.0
            set controlTime = 0.0
            set windowTime = RMaxBJ(CrocodilePeriod,RMinBJ(CrocodileT2_Window,CrocodileSand_GroundDuration))
            set endTime = RMaxBJ(CrocodilePeriod,CrocodileT_Duration)+windowTime
            set areaRadius = RMaxBJ(1.0,CrocodileT_MaxAoe)
            set minScale = RMaxBJ(0.01,CrocodileT_ScaleMin)
            set maxScale = RMaxBJ(minScale,CrocodileT_ScaleMax)
            set outerRadius = RMaxBJ(0.0,areaRadius-maxScale*150.0)
            set ringSpacing = RMaxBJ(1.0,RMaxBJ(CrocodileT_MinDistance,CrocodileT_RingSpacing))
            set patchSpacing = RMaxBJ(1.0,RMaxBJ(CrocodileT_MinDistance,CrocodileT_PatchSpacing))
            set minDistanceSq = CrocodileT_MinDistance*CrocodileT_MinDistance
            set growTime = RMinBJ(spreadTime/2.0,RMaxBJ(CrocodilePeriod,CrocodileT_GrowTime))
            set ringBuildTime = RMinBJ(spreadTime/4.0,RMaxBJ(CrocodileT_RingBuildTime,(2.0*bj_PI*outerRadius/patchSpacing+1.0)*CrocodilePeriod/IMaxBJ(1,CrocodileT_SpawnsPerTick)+CrocodilePeriod))
            set buildDeadline = RMaxBJ(0.0,spreadTime-ringBuildTime)
            set waveScaleMin = RMaxBJ(0.01,CrocodileT_WaveScaleMin)
            set waveScaleMax = RMaxBJ(waveScaleMin,CrocodileT_WaveScaleMax)
            set nextRing = 0.0
            set ringIndex = 0
            set ringPoint = 0
            set ringPoints = 1
            set patchHead = 0
            set growthHead = 0
            set patchCount = 0
            set waveHead = 0
            set maxReach = 0.0
            set spreading = true
            set channelActive = true
            set invulnerabilityHeld = false
            set spreadComplete = false
            set manaPulse = 0.0
            set decorPulse = 0.0
            set visionPulse = 0.0
            call VisionTimed(GetOwningPlayer(c),x,y,minScale*150.0*1.5,3.0)
            set manaGroup = CreateGroup()
            set animationApplied = false
            set channelFinished = false
            set sound2Played = false
            set t2Pending = false
            set t2PauseHeld = false
            set t2Granted = false
            set t2Available = false
            set endNow = false
            call SaveInteger(CrocodileTable,GetHandleId(c),CrocodileT_DataKey,this)
            call SaveInteger(CrocodileTable,GetHandleId(c),CrocodileT_PhaseKey,1)
            call SaveInteger(hs,GetHandleId(c),StringHash("cast r"),1)
            call SaveInteger(hs,GetHandleId(c),StringHash("stop r"),0)
            call GearCCProtect(c,true)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),CrocodileT2_ID,false)
            set t2Timer = CreateTimer()
            call SaveInteger(CrocodileTable,GetHandleId(t2Timer),CrocodileT_DataKey,this)
            call TimerStart(t2Timer,RMaxBJ(0.01,CrocodileT2_CheckPeriod),true,function thistype.CrocodileT_ControlT2)
            if dash != 0 and dash.active then
                set dash.cancelDash = true
                call dash.CrocodileE_Finish()
            endif
            if GetHeroLevel(c) >= CrocodileT_InvulnerabilityHeroLevel and GetUnitAbilityLevel(c,'Avul') == 0 then
                set invulnerabilityHeld = true
                call UnitAddAbility(c,'Avul')
            endif
            set aura = AddSpecialEffectTarget("war3mapImported\\wos_AjeelAura2.mdl",c,"origin")
            call SetUnitTimeScale(c,1.0)
            call MakeSound("war3mapImported\\Hero_Crocodile_T_1")
            call MakeSound("war3mapImported\\Hero_Crocodile_T_1")
            call CrocodileT_CreateWaves()
            call CrocodileT_Spread()
            return true
        endmethod
    endstruct

//================================ Crocodile T2 - Ground Death ========================================
    private struct CrocodileT2_Struct extends array
        private static integer array cluster
        private static real array blastX
        private static real array blastY
        private static real array blastRadius
        private static integer blastCount = 0

        static method CrocodileT2_AddBlast takes real x, real y, real radius, real factor returns nothing
            set factor = RMinBJ(1.0,RMaxBJ(0.0,factor))+0.15
            set blastX[blastCount] = x
            set blastY[blastCount] = y
            set blastRadius[blastCount] = radius
            set blastCount = blastCount+1
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_newdirtexnofire.mdl",x,y,0,1,CrocodileT2_FireScaleMax*factor,0))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_SandPoff.mdl",x,y,GetRandomReal(0,359),2,CrocodileT2_PoffScaleMax*factor,0))
        endmethod

        static method CrocodileT2_CreateKrkRing takes real x, real y, real tRadius, real progress, integer blastPoints returns nothing
            local integer count = IMaxBJ(1,R2I(blastPoints*CrocodileT2_KrkCountMultiplier+0.5))
            local integer j = 0
            local real distance = tRadius*CrocodileT2_BlastDistance+CrocodileT2_KrkOutwardOffset
            local real angleVariation = RMinBJ(RAbsBJ(CrocodileT2_KrkAngleVariation)*bj_DEGTORAD,bj_PI/count*0.4)
            local real radialVariation = RMinBJ(RAbsBJ(CrocodileT2_KrkRadialVariation),RMaxBJ(0.0,distance)*0.15)
            local real scale = CrocodileT2_KrkScaleMax*(RMinBJ(1.0,RMaxBJ(0.0,progress))+0.15)
            local real angle
            local real radius
            loop
                exitwhen j >= count
                set angle = 2.0*bj_PI*j/count+GetRandomReal(-angleVariation,angleVariation)
                set radius = RMaxBJ(1.0,distance+GetRandomReal(-radialVariation,radialVariation))
                call EffectSpawn2("krk (1889)2.mdl",x+radius*Cos(angle),y+radius*Sin(angle),GetRandomReal(0,359),1,(scale+GetRandomReal(0.05,0.1))*GetRandomReal(1.0-CrocodileT2_KrkScaleVariation,1.0+CrocodileT2_KrkScaleVariation),0,0.75)
                set j = j+1
            endloop
        endmethod

        static method CrocodileT2_CreateBlasts takes CrocodileT_Struct ground returns nothing
            local CrocodileT_Sand seed = ground.patchHead
            local CrocodileT_Sand patch
            local CrocodileT_Sand member
            local integer blastPoints
            local integer outerCount
            local real progress
            local integer count
            local integer j
            local real dx
            local real dy
            local real centerX
            local real centerY
            local real radius
            local real tRadius = 0.0
            local real angle
            local real mergeSq = RMaxBJ(0.0,CrocodileT2_MergeDistance)*RMaxBJ(0.0,CrocodileT2_MergeDistance)
            local boolean covered
            set blastCount = 0
            loop
                exitwhen seed == 0
                if seed.fromT then
                    set seed.blastMarked = true
                    set tRadius = RMaxBJ(tRadius,SR0(ground.x,ground.y,seed.x,seed.y)+seed.radius)
                endif
                set seed = seed.next
            endloop
            if tRadius > 0.0 then
                set progress = RMinBJ(1.0,RMaxBJ(0.0,tRadius/RMaxBJ(1.0,CrocodileT_MaxAoe)))
                set blastPoints = IMinBJ(IMaxBJ(3,CrocodileT2_MaxMainBlasts),IMaxBJ(CrocodileT2_MinMainBlasts,R2I(CrocodileT2_MaxMainBlasts*progress+0.999)))
                set outerCount = blastPoints
                set j = 0
                loop
                    exitwhen j >= outerCount
                    set angle = 2.0*bj_PI*j/outerCount
                    call CrocodileT2_AddBlast(ground.x+tRadius*CrocodileT2_BlastDistance*Cos(angle),ground.y+tRadius*CrocodileT2_BlastDistance*Sin(angle),tRadius*0.7,progress)
                    set j = j+1
                endloop
                call CrocodileT2_CreateKrkRing(ground.x,ground.y,tRadius,progress,blastPoints)
            endif
            set seed = ground.patchHead
            loop
                exitwhen seed == 0
                if not seed.blastMarked then
                    set covered = false
                    set j = 0
                    loop
                        exitwhen j >= blastCount or covered
                        set covered = SR0(seed.x,seed.y,blastX[j],blastY[j])+seed.radius <= blastRadius[j]
                        set j = j+1
                    endloop
                    set seed.blastMarked = true
                    if not covered then
                        set cluster[0] = seed
                        set count = 1
                        set centerX = seed.x
                        set centerY = seed.y
                        set patch = ground.patchHead
                        loop
                            exitwhen patch == 0 or count >= IMaxBJ(1,IMinBJ(8192,CrocodileT2_MergeMaxPatches))
                            if not patch.blastMarked then
                                set dx = patch.x-seed.x
                                set dy = patch.y-seed.y
                                if dx*dx+dy*dy <= mergeSq then
                                    set patch.blastMarked = true
                                    set cluster[count] = patch
                                    set count = count+1
                                    set centerX = centerX+patch.x
                                    set centerY = centerY+patch.y
                                endif
                            endif
                            set patch = patch.next
                        endloop
                        set centerX = centerX/count
                        set centerY = centerY/count
                        set radius = 0.0
                        set j = 0
                        loop
                            exitwhen j >= count
                            set member = cluster[j]
                            set radius = RMaxBJ(radius,SR0(centerX,centerY,member.x,member.y)+member.radius)
                            set cluster[j] = 0
                            set j = j+1
                        endloop
                        call CrocodileT2_AddBlast(centerX,centerY,radius,radius/RMaxBJ(1.0,CrocodileT_MaxAoe))
                        call EffectSpawn2("war3mapimported\\wos_krk (1889)2.mdl",centerX,centerY,GetRandomReal(0,359),1,CrocodileT2_KrkScaleMax*(RMinBJ(1.0,RMaxBJ(0.0,radius/RMaxBJ(1.0,CrocodileT_MaxAoe)))+0.15)+GetRandomReal(0.05,0.1),0,0.75)
                    endif
                endif
                set seed = seed.next
            endloop
        endmethod

        static method CrocodileT2_CollectSand takes CrocodileT_Struct ground returns nothing
            local CrocodileSand_Struct sand
            local CrocodileT_Sand patch
            local integer i = 0
            loop
                exitwhen i > CrocodileSand_Struct.MUI
                set sand = CrocodileSand_Struct.m[i]
                if sand.c == ground.c and not sand.endNow and sand.r < sand.rmax then
                    set patch = CrocodileT_Sand.CrocodileTSand_Collect(sand)
                    set patch.next = ground.patchHead
                    set ground.patchHead = patch
                    set ground.patchCount = ground.patchCount+1
                    set ground.maxReach = RMaxBJ(ground.maxReach,SR0(ground.x,ground.y,patch.x,patch.y)+patch.radius)
                endif
                set i = i+1
            endloop
        endmethod

        static method CrocodileT2_Detonate takes CrocodileT_Struct ground returns nothing
            local unit c = ground.c
            local group scan
            local CrocodileT_Sand patch
            local integer i
            local unit u
            call MakeSound("war3mapImported\\Hero_Crocodile_T2_2")
            call CrocodileT2_CollectSand(ground)
            set patch = ground.patchHead
            loop
                exitwhen patch == 0
                call VisionTimed(GetOwningPlayer(c),patch.x,patch.y,patch.radius*1.5,3.0)
                set patch = patch.next
            endloop
            set scan = CreateGroup()
            // One broad enumeration; exact original patch areas decide the damage.
            call GroupEnumUnitsInRange(scan,ground.x,ground.y,ground.maxReach,NoDecor_Cond)
            set i = BlzGroupGetSize(scan)-1
            loop
                exitwhen i < 0
                set u = BlzGroupUnitAt(scan,i)
                if not SpellBool(u) or not IsUnitEnemy(u,GetOwningPlayer(c)) or IsUnitType(u,UNIT_TYPE_STRUCTURE) or not ground.CrocodileT_Contains(GetUnitX(u),GetUnitY(u)) then
                    call GroupRemoveUnit(scan,u)
                endif
                set i = i-1
            endloop
            call CrocodileT2_CreateBlasts(ground)
            call ground.CrocodileT_Clear(false)
            // Detach the old cast before damage callbacks can kill or recast the hero.
            loop
                set u = FirstOfGroup(scan)
                exitwhen u == null
                call GroupRemoveUnit(scan,u)
                call Crocodile_SpellDamage(c,u,GetHeroAgi(c,true)*CrocodileT2_DamageAgi,-1)
                call Crocodile_ApplySharedMark(c,u)
            endloop
            call DestroyGroup(scan)
            set scan = null
            set u = null
            set c = null
        endmethod

        static method CrocodileT2_Begin takes unit c returns boolean
            local CrocodileT_Struct ground = LoadInteger(CrocodileTable,GetHandleId(c),CrocodileT_DataKey)
            if ground == 0 or ground.endNow or not ground.t2Granted or ground.t2Pending or ground.r+0.001 >= ground.endTime or not SpellBoolCaster(c) or not CrocodileT_Struct.CrocodileT_IsOnSand(c) then
                return false
            endif
            call ground.CrocodileT_EndChannel()
            set ground.animationApplied = false
            set ground.t2Pending = true
            set ground.t2Time = -TimerGetElapsed(GearTimer03)
            set ground.t2PauseHeld = true
            call SaveInteger(CrocodileTable,GetHandleId(c),CrocodileT_PhaseKey,1)
            call StartSpellUnit2(c)
            set ground.t2Available = false
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),CrocodileT2_ID,false)
            call MakeSound("war3mapImported\\Hero_Crocodile_T2_1")
            return true
        endmethod

        static method Loop_CrocodileT2 takes nothing returns nothing
            local CrocodileT_Struct ground
            local integer i = 0
            loop
                exitwhen i > CrocodileT_Struct.MUI
                set ground = CrocodileT_Struct.m[i]
                if not ground.endNow and ground.t2Pending and ground.t2Time+0.001 >= CrocodileT2_Delay then
                    call CrocodileT2_Detonate(ground)
                endif
                set i = i+1
            endloop
        endmethod
    endstruct

//================================ Crocodile F projectile ========================================
    private struct CrocodileF_Projectile
        static integer array m
        static integer MUI = -1
        unit c
        real x
        real y
        real a
        real distance
        real dmg
        real radius
        real spread
        real maxDistance
        real nextSand
        real environmentDistance
        integer decorKey
        real sandSpacing
        group g
        group g2
        effect e
        effect e2
        effect e3
        real moveDelay
        real r2 
        method CrocodileF_HitSegment takes real segmentX, real segmentY, real angle, real length returns nothing
            local unit u
            local real projection
            local real px
            local real py
            call GroupEnumUnitsInRange(g,segmentX+length*0.5*Cos(angle),segmentY+length*0.5*Sin(angle),radius+length*0.5,NoDecor_Cond)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                call GroupRemoveUnit(g,u)
                set projection = RMaxBJ(0.0,RMinBJ(length,(GetUnitX(u)-segmentX)*Cos(angle)+(GetUnitY(u)-segmentY)*Sin(angle)))
                set px = segmentX+projection*Cos(angle)
                set py = segmentY+projection*Sin(angle)
                if SpellBool(u) and IsUnitEnemy(u,GetOwningPlayer(c)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) and not IsUnitInGroup(u,g2) and SR3(u,px,py) <= radius then
                    // A shared group covers all three blades: one 3x hit per enemy.
                    call GroupAddUnit(g2,u)
                    call dmgatk(c,u,dmg)
                endif
            endloop
            set u = null
        endmethod

        method CrocodileF_EnvironmentSegment takes real angle, real length returns nothing
            call VisionTimed(GetOwningPlayer(c),x+(environmentDistance+length*0.5)*Cos(angle),y+(environmentDistance+length*0.5)*Sin(angle),radius*1.5,2.0)
            call DecorRemoveLine(c,x+environmentDistance*Cos(angle),y+environmentDistance*Sin(angle),angle,length,radius,50.0,CrocodileDecorHits,decorKey)
        endmethod

        static method Loop_CrocodileF_Projectile takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real step
            local real section
            loop
                exitwhen i > MUI
                set this = m[i]
                if SpellBoolCaster(c) and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 then
                    if moveDelay > 0.001 then
                        set moveDelay = RMaxBJ(0.0,moveDelay-CrocodilePeriod)
                    else
                    set step = RMinBJ(CrocodileF_ProjectileSpeed*CrocodilePeriod,maxDistance-distance)
                    call CrocodileF_HitSegment(x+distance*Cos(a),y+distance*Sin(a),a,step)
                    call CrocodileF_HitSegment(x+distance*Cos(a+spread),y+distance*Sin(a+spread),a+spread,step)
                    call CrocodileF_HitSegment(x+distance*Cos(a-spread),y+distance*Sin(a-spread),a-spread,step)
                    set distance = distance + step
                    loop
                        exitwhen environmentDistance >= distance or (distance-environmentDistance+0.001 < radius and distance+0.001 < maxDistance)
                        set section = RMinBJ(radius,distance-environmentDistance)
                        call CrocodileF_EnvironmentSegment(a,section)
                        call CrocodileF_EnvironmentSegment(a+spread,section)
                        call CrocodileF_EnvironmentSegment(a-spread,section)
                        set environmentDistance = environmentDistance+section
                    endloop
                    call MoveEff(e,step,a)
                    call MoveEff(e2,step,a+spread)
                    call MoveEff(e3,step,a-spread)
                    loop
                        exitwhen nextSand > distance+0.001
                        call CrocodileSand_Struct.CrocodileSand_Start(c,x+nextSand*Cos(a),y+nextSand*Sin(a),CrocodileSand_Radius,false)
                        call CrocodileSand_Struct.CrocodileSand_Start(c,x+nextSand*Cos(a+spread),y+nextSand*Sin(a+spread),CrocodileSand_Radius,false)
                        call CrocodileSand_Struct.CrocodileSand_Start(c,x+nextSand*Cos(a-spread),y+nextSand*Sin(a-spread),CrocodileSand_Radius,false)
                        set nextSand = nextSand+sandSpacing
                    endloop
                    if r2>0.06 then 
                    set r2 = 0
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_SandExplosion.mdl",x+nextSand*Cos(a),y+nextSand*Sin(a),0,2.5,3,115))
                    //call DestroyEffect(EffectSpawn("war3mapImported\\wos_SandPoff.mdl",x+nextSand*Cos(a),y+nextSand*Sin(a),0,1,2,1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_SandExplosion.mdl",x+nextSand*Cos(a+spread),y+nextSand*Sin(a+spread),0,2.5,3,115))
                    //call DestroyEffect(EffectSpawn("war3mapImported\\wos_SandPoff.mdl",x+nextSand*Cos(a+spread),y+nextSand*Sin(a+spread),0,1,2,1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_SandExplosion.mdl",x+nextSand*Cos(a-spread),y+nextSand*Sin(a-spread),0,2.5,3,115))
                    //call DestroyEffect(EffectSpawn("war3mapImported\\wos_SandPoff.mdl",x+nextSand*Cos(a-spread),y+nextSand*Sin(a-spread),0,1,2,1))
                    else
                    set r2 = r2 + 0.03
                    endif
                    endif
                endif
                if distance >= maxDistance or not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                    call FlushChildHashtable(CrocodileDecorHits,decorKey)
                    call ColorEffDummy3(e,0,255,255,255,0.45)
                    call ColorEffDummy3(e2,0,255,255,255,0.45)
                    call ColorEffDummy3(e3,0,255,255,255,0.45)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set g = null
                    set g2 = null
                    set m[i] = m[MUI]
                    set MUI = MUI - 1
                    call destroy()
                    if MUI == -1 then
                        call GearTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
        endmethod

        static method CrocodileF_Projectile_Start takes unit NewC, unit target returns nothing
            local thistype this = thistype.allocate()
            set MUI = MUI + 1
            set m[MUI] = this
            if MUI == 0 then
                call GearTimer03Acquire()
            endif
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set a = Atan2(GetUnitY(target)-y,GetUnitX(target)-x)
            if SR3(target,x,y) < 1.0 then
                set a = GetUnitFacing(c)*bj_DEGTORAD
            endif
            set x = x + 200*Cos(a)
            set y = y + 200*Sin(a)
            set distance = 0.0
            set moveDelay = RMaxBJ(0.0,CrocodileF_BladeMoveDelay)+TimerGetElapsed(GearTimer03)
            set r2 = 0.0
            set dmg = GetHeroAgi(c,true)*CrocodileF_DamageAgi*3.0
            set spread = CrocodileF_SpreadAngle*bj_DEGTORAD
            // The side rays pass D*sin(15 degrees) away from the aimed target.
            set radius = RMaxBJ(CrocodileF_ProjectileAoe,SR3(target,x,y)*RAbsBJ(Sin(spread))+CrocodileF_TargetPadding)
            set maxDistance = CrocodileF_ProjectileRange
            set sandSpacing = RMaxBJ(CrocodileSand_MinDistance,CrocodileF_SandSpacing)
            set nextSand = sandSpacing
            set environmentDistance = 0.0
            set decorKey = CrocodileDecor_NewKey()
            call VisionTimed(GetOwningPlayer(c),x,y,radius*1.5,2.0)
            set g = CreateGroup()
            set g2 = CreateGroup()
            call MakeSound("war3mapImported\\Hero_Crocodile_F4")
            set e = EffectSpawn("war3mapImported\\wos_[DoFT]CrocodileWeapon.mdl",x,y,a*bj_RADTODEG,CrocodileF_BladeAnimationSpeed,CrocodileF_BladeScale,CrocodileF_BladeHeight)
            set e2 = EffectSpawn("war3mapImported\\wos_[DoFT]CrocodileWeapon.mdl",x,y,(a+spread)*bj_RADTODEG,CrocodileF_BladeAnimationSpeed,CrocodileF_BladeScale,CrocodileF_BladeHeight)
            set e3 = EffectSpawn("war3mapImported\\wos_[DoFT]CrocodileWeapon.mdl",x,y,(a-spread)*bj_RADTODEG,CrocodileF_BladeAnimationSpeed,CrocodileF_BladeScale,CrocodileF_BladeHeight)
            call CrocodileSand_Struct.CrocodileSand_Start(c,x,y,CrocodileSand_Radius,false)
        endmethod
    endstruct

   private struct CrocodileF_Single extends array
    static method CrocodileF_Single_Start takes unit c, unit target returns nothing
        local real x = GetUnitX(target)
        local real y = GetUnitY(target)
        local real a = GetRandomReal(0.0, 2.0*bj_PI)

        local real sx = x + CrocodileF_SingleOffset*Cos(a)
        local real sy = y + CrocodileF_SingleOffset*Sin(a)
        local real face = Atan2(y - sy, x - sx)*bj_RADTODEG+180

        call ColorEffDummy3(EffectSpawn3("war3mapImported\\wos_[DoFT]Crocodile nits.mdl",sx,sy,face,1,CrocodileF_SingleScale,CrocodileF_EffectHeight,-45),0.3,255,255,255,0.3)

        call DestroyEffect(EffectSpawn("war3mapImported\\wos_SandExplosion.mdl",x,y,0,1,3,115))
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_SandPoff.mdl",x,y,0,1,2,1))
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_newdirtexnofire.mdl",x,y,0,1,2,1))
        call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", target, "chest"))
        call VisionTimed(GetOwningPlayer(c),x,y,CrocodileF_ProjectileAoe*1.5,2.0)
        call DecorRemove(c,x,y,CrocodileF_ProjectileAoe,20.0)
        call MakeSound("war3mapImported\\Hero_Crocodile_F5")

        if SpellBool(target) and IsUnitEnemy(target,GetOwningPlayer(c)) and not IsUnitType(target,UNIT_TYPE_STRUCTURE) then
            call dmgatk(c,target,GetHeroAgi(c,true)*CrocodileF_DamageAgi)
        endif
    endmethod
endstruct
//================================ Crocodile F - La Spada ========================================
    private struct CrocodileF_Struct
        static integer array m
        static integer MUI = -1
        unit c
        integer stacks
        boolean enhanced
        boolean ownsAS
        boolean attack1Enabled
        boolean attack2Enabled
        real savedAS
        real savedRange
        real cooldown
        boolean ownsAttackBlock
        boolean applyingOwnAttack
        boolean castPauseHeld
        unit pendingTarget
        integer pendingStacks
        real releaseDelay

        method CrocodileF_SetEnhanced takes boolean enabled returns nothing
            local ability a
            local real current
            if enabled == enhanced then
                return
            endif
            set enhanced = enabled
            if enabled then
                // Native item bonus follows WoS's ability-based stat modifiers.
                set ownsAS = GetUnitAbilityLevel(c, 'AIsx') == 0
                if ownsAS then
                    call UnitAddAbility(c, 'AIsx')
                endif
                set a = BlzGetUnitAbility(c, 'AIsx')
                set savedAS = BlzGetAbilityRealLevelField(a, ABILITY_RLF_ATTACK_SPEED_INCREASE_ISX1, 0)
                if ownsAS then
                    set current = CrocodileF_AttackSpeed
                else
                    set current = savedAS + CrocodileF_AttackSpeed
                endif
                call BlzSetAbilityRealLevelField(a, ABILITY_RLF_ATTACK_SPEED_INCREASE_ISX1, 0, current)
                call CrocodileBonus_Refresh(c, 'AIsx')
                set attack1Enabled = BlzGetUnitWeaponBooleanField(c, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0)
                set attack2Enabled = BlzGetUnitWeaponBooleanField(c, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1)
                // F uses only Attack 1; save its melee range before enhancing it.
                set savedRange = BlzGetUnitWeaponRealField(c, UNIT_WEAPON_RF_ATTACK_RANGE, 0)
                call BlzSetUnitWeaponBooleanField(c, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, true)
                call BlzSetUnitWeaponBooleanField(c, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, false)
                call SetUnitRange(c,CrocodileF_Range)

                // BACKUP PREVIOUS F: both attacks enabled, fixed Weapon 2 range.
                // call BlzSetUnitWeaponBooleanField(c, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, true)
                // call BlzSetUnitWeaponBooleanField(c, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, true)

                // BACKUP OLD F WEAPON SWITCH:
                // call BlzSetUnitWeaponBooleanField(c, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, false)
                // call BlzSetUnitWeaponBooleanField(c, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, true)
            else
                set a = BlzGetUnitAbility(c, 'AIsx')
                set current = BlzGetAbilityRealLevelField(a, ABILITY_RLF_ATTACK_SPEED_INCREASE_ISX1, 0)
                if ownsAS and RAbsBJ(current - CrocodileF_AttackSpeed) < 0.001 then
                    call UnitRemoveAbility(c, 'AIsx')
                else
                    if ownsAS then
                        set current = current - CrocodileF_AttackSpeed + savedAS
                    else
                        set current = current - CrocodileF_AttackSpeed
                    endif
                    call BlzSetAbilityRealLevelField(a, ABILITY_RLF_ATTACK_SPEED_INCREASE_ISX1, 0, current)
                    call CrocodileBonus_Refresh(c, 'AIsx')
                endif
                call BlzSetUnitWeaponBooleanField(c, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, attack1Enabled)
                call BlzSetUnitWeaponBooleanField(c, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, attack2Enabled)
                call SetUnitRange(c,savedRange)
            endif
            set a = null
        endmethod

        method CrocodileF_ReleaseCaster takes nothing returns nothing
            if castPauseHeld then
                set castPauseHeld = false
                call StopSpellUnit2(c)
            endif
            if ownsAttackBlock then
                call UnitRemoveAbility(c,'Abun')
                set ownsAttackBlock = false
            endif
            set pendingTarget = null
            set pendingStacks = 0
            set releaseDelay = 0.0
        endmethod

        static method CrocodileF_Begin takes unit NewC, unit target returns boolean
            local thistype this = LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileF_DataKey)
            if this == 0 or LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileCore_DataKey) == 0 or IsUnitIllusion(NewC) or not SpellBoolCaster(NewC) or IsUnitPaused(NewC) or not IsUnitEnemy(target,GetOwningPlayer(NewC)) or not SpellBool(target) or IsUnitType(target,UNIT_TYPE_STRUCTURE) then
                return false
            endif
            if ownsAttackBlock or stacks <= 0 or GetUnitAbilityLevel(c,CrocodileF_ID) == 0 or cooldown > TimerGetElapsed(GearTimer03) or GetUnitAbilityLevel(c,'Abun') > 0 or CrocodileF_ProjectileSpeed <= 0.0 or CrocodileF_ProjectileRange <= 0.0 then
                return false
            endif
            // Elapsed clock fraction prevents a proc just before a tick shortening the CD.
            set cooldown = CrocodileF_InternalCD+TimerGetElapsed(GearTimer03)
            call BlzStartUnitAbilityCooldown(c,CrocodileF_ID,CrocodileF_InternalCD)
            set ownsAttackBlock = true
            set pendingTarget = target
            set pendingStacks = 1
            if stacks >= 3 then
                set pendingStacks = 3
            endif
            set stacks = stacks-pendingStacks
            call TasAbilityChargeBox_SetValue(c,CrocodileF_ID,I2S(stacks))
            call CrocodileF_SetEnhanced(false)
            call UnitAddAbility(c,'Abun')
            set castPauseHeld = pendingStacks == 3
            if castPauseHeld then
                call StartSpellUnit2(c)
            call MakeSound("war3mapImported\\Hero_Crocodile_F2")
            else
                call IssueImmediateOrder(c,"stop")
            endif
            call MakeSound("war3mapImported\\Hero_Crocodile_F3")
            call SetUnitAnimationByIndex(c,CrocodileF_Animation)
            call SetUnitTimeScale(c,CrocodileF_AnimationSpeed)
            set releaseDelay = RMaxBJ(0.0,CrocodileF_ReleaseDelay)+TimerGetElapsed(GearTimer03)
            
            // Hold Abun through the windup; leave normal attacks during cooldown.
            return true
        endmethod

        static method CrocodileF_Attack takes unit NewC, unit target, real amount returns real
            local thistype this = LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileF_DataKey)
            // F starts at ATTACKED, before the native projectile or damage point.
            if this != 0 and ownsAttackBlock and not applyingOwnAttack then
                return 0.0
            endif
            return amount
        endmethod

        static method Loop_CrocodileF takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI
                set this = m[i]
                set cooldown = RMaxBJ(0.0,cooldown-CrocodilePeriod)
                if ownsAttackBlock then
                    set releaseDelay = RMaxBJ(0.0,releaseDelay-CrocodilePeriod)
                    if SpellBoolCaster(c) and not IsUnitIllusion(c) and GetUnitAbilityLevel(c,CrocodileF_ID) > 0 and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 and GetUnitTypeId(pendingTarget) != 0 and SpellBool(pendingTarget) and IsUnitEnemy(pendingTarget,GetOwningPlayer(c)) then
                        if releaseDelay <= 0.001 then
                            if pendingStacks == 3 then
                                call CrocodileF_Projectile.CrocodileF_Projectile_Start(c,pendingTarget)
                            else
                                set applyingOwnAttack = true
                                call CrocodileF_Single.CrocodileF_Single_Start(c,pendingTarget)
                                set applyingOwnAttack = false
                            endif
                            if LoadInteger(CrocodileTable,GetHandleId(c),CrocodileT_PhaseKey) == 0 then
                                call SetUnitTimeScale(c,1.0)
                            endif
                            call CrocodileF_ReleaseCaster()
                        endif
                    else
                        if LoadInteger(CrocodileTable,GetHandleId(c),CrocodileT_PhaseKey) == 0 then
                            call SetUnitTimeScale(c,1.0)
                        endif
                        call CrocodileF_ReleaseCaster()
                    endif
                endif
                if not SpellBoolCaster(c) or IsUnitIllusion(c) or GetUnitAbilityLevel(c,CrocodileF_ID) == 0 or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                    if stacks != 0 then
                        set stacks = 0
                        call TasAbilityChargeBox_SetValue(c,CrocodileF_ID,"0")
                    endif
                    call CrocodileF_SetEnhanced(false)
                else
                    call CrocodileF_SetEnhanced(stacks > 0 and cooldown <= 0.0 and not ownsAttackBlock)
                endif
                if LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                    call RemoveSavedInteger(CrocodileTable,GetHandleId(c),CrocodileF_DataKey)
                    call TasAbilityChargeBox_ClearValue(c,CrocodileF_ID)
                    set c = null
                    set m[i] = m[MUI]
                    set MUI = MUI - 1
                    call destroy()
                    if MUI == -1 then
                        call GearTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
        endmethod

        static method CrocodileF_Register takes unit NewC returns nothing
            local thistype this = thistype.allocate()
            set MUI = MUI + 1
            set m[MUI] = this
            if MUI == 0 then
                call GearTimer03Acquire()
            endif
            set c = NewC
            set stacks = 0
            set enhanced = false
            set ownsAS = false
            set cooldown = 0.0
            set ownsAttackBlock = false
            set applyingOwnAttack = false
            set castPauseHeld = false
            set pendingTarget = null
            set pendingStacks = 0
            set releaseDelay = 0.0
            call SaveInteger(CrocodileTable,GetHandleId(c),CrocodileF_DataKey,this)
            call TasAbilityChargeBox_SetValue(c,CrocodileF_ID,"0")
        endmethod


    endstruct

//================================ Crocodile G - Suna Suna no Mi ========================================
    function Crocodile_IsOnSand takes unit c returns boolean
        return CrocodileT_Struct.CrocodileT_IsOnSand(c)
    endfunction

    function CrocodileT_IsChanneling takes unit c returns boolean
        local CrocodileT_Struct ground = LoadInteger(CrocodileTable,GetHandleId(c),CrocodileT_DataKey)
        return ground != 0 and ground.channelActive and not ground.endNow and SpellBoolCaster(c) and not IsUnitIllusion(c)
    endfunction

    private struct CrocodileG_Struct
        static integer array m
        static integer MUI = -1
        unit c
        boolean onSand
        real sandBuffPulse

        method CrocodileG_SandSpeed takes boolean enabled returns nothing
            set onSand = enabled
            if enabled and CrocodileG_SandMS_Ability_ID != 0 and CrocodileG_SandMS_Buff_ID != 0 then
                call BuffUnit01(c,c,CrocodileG_SandMS_Ability_ID,"bloodlust",1)
            elseif CrocodileG_SandMS_Buff_ID != 0 then
                call UnitRemoveAbility(c,CrocodileG_SandMS_Buff_ID)
            endif
        endmethod

        static method Loop_CrocodileG takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI
                set this = m[i]
                set sandBuffPulse = sandBuffPulse+CrocodilePeriod
                if sandBuffPulse+0.001 >= CrocodileG_SandMS_RefreshPeriod then
                    set sandBuffPulse = sandBuffPulse-RMaxBJ(CrocodilePeriod,CrocodileG_SandMS_RefreshPeriod)
                    call CrocodileG_SandSpeed(LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 and SpellBoolCaster(c) and not IsUnitIllusion(c) and GetUnitAbilityLevel(c,CrocodileG_ID) > 0 and Crocodile_IsOnSand(c))
                endif
                if not SpellBoolCaster(c) or IsUnitIllusion(c) or GetUnitAbilityLevel(c,CrocodileG_ID) == 0 then
                    call UnitRemoveAbility(c,CrocodileG_SandMS_Buff_ID)
                endif
                if LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                    call UnitRemoveAbility(c,CrocodileG_SandMS_Buff_ID)
                    call RemoveSavedInteger(CrocodileTable,GetHandleId(c),CrocodileG_DataKey)
                    set c = null
                    set m[i] = m[MUI]
                    set MUI = MUI - 1
                    call destroy()
                    if MUI == -1 then
                        call GearTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
        endmethod

        static method CrocodileG_Register takes unit NewC returns nothing
            local thistype this = thistype.allocate()
            set MUI = MUI + 1
            set m[MUI] = this
            if MUI == 0 then
                call GearTimer03Acquire()
            endif
            set c = NewC
            set onSand = false
            set sandBuffPulse = 0.0
            call SaveInteger(CrocodileTable,GetHandleId(c),CrocodileG_DataKey,this)
        endmethod


    endstruct

//================================ Crocodile Registration / shared events ========================================
    private struct CrocodileCore_Struct
        static integer array m
        static integer MUI = -1
        unit c
        integer savedType


        static method Loop_Crocodile takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI
                set this = m[i]
                if GetUnitTypeId(c) != savedType or IsUnitIllusion(c) then
                    call CrocodileCore_Death(c)
                    call RemoveSavedInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey)
                    set c = null
                    set m[i] = m[MUI]
                    set MUI = MUI - 1
                    call destroy()
                    if MUI == -1 then
                        call GearTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            call CrocodileQ_Struct.Loop_CrocodileQ()
            call CrocodileQ_ExplosionDecor.Loop_CrocodileQExplosionDecor()
            call CrocodileW_Struct.Loop_CrocodileW()
            call CrocodileE_Struct.Loop_CrocodileE()
            call CrocodileR_Struct.Loop_CrocodileR()
            call CrocodileT_Struct.Loop_CrocodileT()
            call CrocodileT2_Struct.Loop_CrocodileT2()
            call CrocodileSand_Struct.Loop_CrocodileSand()
            call CrocodileSand_Debuff.Loop_CrocodileSandDebuff()
            call CrocodileF_Struct.Loop_CrocodileF()
            call CrocodileF_Projectile.Loop_CrocodileF_Projectile()
            call CrocodileG_Struct.Loop_CrocodileG()
        endmethod

        static method Register_Crocodile takes unit NewC returns nothing
            local thistype this
            if NewC == null or GetUnitTypeId(NewC) != Crocodile_ID or not IsUnitType(NewC,UNIT_TYPE_HERO) or IsUnitIllusion(NewC) or LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileCore_DataKey) != 0 then
                return
            endif
            set this = thistype.allocate()
            set MUI = MUI + 1
            set m[MUI] = this
            if MUI == 0 then
                call GearTimer03Acquire()
            endif
            set c = NewC
            set savedType = GetUnitTypeId(c)
            call SaveInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey,this)
            call UnitRemoveAbility(c,CrocodileT2_ID)
            call CrocodileE_Struct.CrocodileE_Register(c)
            call CrocodileF_Struct.CrocodileF_Register(c)
            call CrocodileG_Struct.CrocodileG_Register(c)
        endmethod

        static method CrocodileCore_Death takes unit c returns nothing
            local CrocodileE_Struct dash = LoadInteger(CrocodileTable,GetHandleId(c),CrocodileE_DataKey)
            local CrocodileF_Struct attack = LoadInteger(CrocodileTable,GetHandleId(c),CrocodileF_DataKey)
            local CrocodileG_Struct passive = LoadInteger(CrocodileTable,GetHandleId(c),CrocodileG_DataKey)
            call CrocodileR_Struct.CrocodileR_Death(c)
            if LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 then
                call CrocodileT_Struct.CrocodileT_Finish(c)
                if dash != 0 then
                    set dash.cancelDash = true

                endif
                if attack != 0 then
                    set attack.stacks = 0
                    set attack.cooldown = 0.0
                    call BlzEndUnitAbilityCooldown(c,CrocodileF_ID)
                    call attack.CrocodileF_ReleaseCaster()
                    call TasAbilityChargeBox_SetValue(c,CrocodileF_ID,"0")
                    call attack.CrocodileF_SetEnhanced(false)
                endif
                if passive != 0 then
                    call passive.CrocodileG_SandSpeed(false)
                    call UnitRemoveAbility(c,CrocodileG_SandMS_Buff_ID)
                endif
            endif
            set c = null
        endmethod

        static method Crocodile_Summon takes nothing returns nothing
            local unit source = GetSummoningUnit()
            local unit clone = GetSummonedUnit()
            local CrocodileF_Struct attack = LoadInteger(CrocodileTable,GetHandleId(source),CrocodileF_DataKey)
            local CrocodileG_Struct passive = LoadInteger(CrocodileTable,GetHandleId(source),CrocodileG_DataKey)
            local ability a
            if LoadInteger(CrocodileTable,GetHandleId(source),CrocodileCore_DataKey) != 0 and IsUnitIllusion(clone) then
                if attack != 0 and attack.enhanced then
                    call BlzSetUnitWeaponBooleanField(clone,UNIT_WEAPON_BF_ATTACKS_ENABLED,0,attack.attack1Enabled)
                    call BlzSetUnitWeaponBooleanField(clone,UNIT_WEAPON_BF_ATTACKS_ENABLED,1,attack.attack2Enabled)
                    if GetUnitAbilityLevel(clone,'AIsx') > 0 then
                        if attack.ownsAS then
                            call UnitRemoveAbility(clone,'AIsx')
                        else
                            set a = BlzGetUnitAbility(clone,'AIsx')
                            call BlzSetAbilityRealLevelField(a,ABILITY_RLF_ATTACK_SPEED_INCREASE_ISX1,0,attack.savedAS)
                            call CrocodileBonus_Refresh(clone,'AIsx')
                        endif
                    endif
                endif
                call UnitRemoveAbility(clone,CrocodileG_SandMS_Buff_ID)
                call UnitRemoveAbility(clone,CrocodileT2_ID)
            endif
            set a = null
            set source = null
            set clone = null
        endmethod

        static method CrocodileCore_Damage takes unit c, unit td, real amount, integer kind, integer phase returns real
            // Compatibility wrapper. MAIN DmgSys exclusively owns G damage and mana depletion.
            return amount
        endmethod


    endstruct

    // MAIN LvlUpCheck registers real heroes once after granting permanent F/G.
    function Crocodile_Register takes unit c returns nothing
        call CrocodileCore_Struct.Register_Crocodile(c)
    endfunction

    function Crocodile_IsRegistered takes unit c returns boolean
        return LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 and not IsUnitIllusion(c)
    endfunction

    function Crocodile_InitializeHero takes unit c returns nothing
        if c == null or GetUnitTypeId(c) != Crocodile_ID or not IsUnitType(c,UNIT_TYPE_HERO) or IsUnitIllusion(c) then
            return
        endif
        if GetUnitAbilityLevel(c,CrocodileF_ID) == 0 then
            call UnitAddAbility(c,CrocodileF_ID)
        endif
        call UnitMakeAbilityPermanent(c,true,CrocodileF_ID)
        if GetUnitAbilityLevel(c,CrocodileG_ID) == 0 then
            call UnitAddAbility(c,CrocodileG_ID)
        endif
        call UnitMakeAbilityPermanent(c,true,CrocodileG_ID)
        if not Crocodile_IsRegistered(c) then
            call Crocodile_Register(c)
        endif
    endfunction

    function CrocodileQ_Start takes unit c, real x, real y returns boolean
        return CrocodileQ_Struct.CrocodileQ_Begin(c,x,y)
    endfunction

    function CrocodileW_Start takes unit c, real x, real y returns boolean
        return CrocodileW_Struct.CrocodileW_Begin(c,x,y)
    endfunction

    function CrocodileE_Start takes unit c, real x, real y returns boolean
        return CrocodileE_Struct.CrocodileE_Begin(c,x,y)
    endfunction

    function CrocodileR_Start takes unit c, real x, real y returns boolean
        return CrocodileR_Struct.CrocodileR_Begin(c,x,y)
    endfunction

    function CrocodileT_Start takes unit c returns boolean
        return CrocodileT_Struct.CrocodileT_Begin(c)
    endfunction

    function CrocodileT2_Start takes unit c returns boolean
        return CrocodileT2_Struct.CrocodileT2_Begin(c)
    endfunction

    function CrocodileF_AddStack takes unit c returns nothing
        local CrocodileF_Struct attack = LoadInteger(CrocodileTable,GetHandleId(c),CrocodileF_DataKey)
        if Crocodile_IsRegistered(c) and SpellBoolCaster(c) and attack != 0 and GetUnitAbilityLevel(c,CrocodileF_ID) > 0 and GetHeroLevel(c) >= CrocodileF_MinHeroLevel then
            set attack.stacks = IMinBJ(CrocodileF_MaxStacks,attack.stacks+1)
            call TasAbilityChargeBox_SetValue(c,CrocodileF_ID,I2S(attack.stacks))
            call attack.CrocodileF_SetEnhanced(attack.cooldown <= TimerGetElapsed(GearTimer03) and not attack.ownsAttackBlock)
        endif
    endfunction

    function Crocodile_Attack takes unit c, unit td, real dmg returns real
        return CrocodileF_Struct.CrocodileF_Attack(c,td,dmg)
    endfunction

    function Crocodile_Damage takes unit c, unit td, real amount, integer kind, integer phase returns real
        return CrocodileCore_Struct.CrocodileCore_Damage(c,td,amount,kind,phase)
    endfunction

    function Crocodile_Death takes unit c returns nothing
        call CrocodileCore_Struct.CrocodileCore_Death(c)
    endfunction

    private function CrocodileF_OnAttack takes nothing returns nothing
        call CrocodileF_Struct.CrocodileF_Begin(GetAttacker(),GetTriggerUnit())
    endfunction

    private function CrocodileT_OnFinish takes nothing returns nothing
        local CrocodileT_Struct ground = LoadInteger(CrocodileTable,GetHandleId(GetTriggerUnit()),CrocodileT_DataKey)
        if GetSpellAbilityId() == CrocodileT_ID and ground != 0 and ground.channelActive and not ground.endNow then
            set ground.channelFinished = true
        endif
    endfunction

    private function InitCrocodileSpells takes nothing returns nothing
        local trigger summon = CreateTrigger()
        local trigger attackStart = CreateTrigger()
        local trigger finish = CreateTrigger()
        set CrocodileW_QContact = CreateTrigger()
        call TriggerAddCondition(CrocodileW_QContact,Condition(function CrocodileW_ReceiveQ))
        call TriggerAddAction(GearTimer03Listeners,function CrocodileCore_Struct.Loop_Crocodile)
        call TriggerRegisterAnyUnitEventBJ(summon,EVENT_PLAYER_UNIT_SUMMON)
        call TriggerAddAction(summon,function CrocodileCore_Struct.Crocodile_Summon)
        call TriggerRegisterAnyUnitEventBJ(attackStart,EVENT_PLAYER_UNIT_ATTACKED)
        call TriggerAddAction(attackStart,function CrocodileF_OnAttack)
        call TriggerRegisterAnyUnitEventBJ(finish,EVENT_PLAYER_UNIT_SPELL_FINISH)
        call TriggerRegisterAnyUnitEventBJ(finish,EVENT_PLAYER_UNIT_SPELL_ENDCAST)
        call TriggerAddAction(finish,function CrocodileT_OnFinish)
        set summon = null
        set attackStart = null
        set finish = null
    endfunction
endlibrary
