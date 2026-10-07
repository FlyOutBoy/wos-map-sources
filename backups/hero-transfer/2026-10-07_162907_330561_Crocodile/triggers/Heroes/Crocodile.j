library CrocodileSpells initializer InitCrocodileSpells uses GearSystems, TasAbilityChargeBox
    globals
        // TEST rawcodes. Register explicitly: these IDs belong to other MAIN heroes.

//================================ Crocodile Core ========================================
        integer Crocodile_ID = 'H00A'
        private constant integer CrocodileCore_DataKey = 0
        private constant real CrocodilePeriod = 0.03
        private hashtable CrocodileTable = InitHashtable()

//================================ Crocodile Sand ========================================
        real CrocodileSand_Duration = 20.0
        private constant integer CrocodileSand_DebuffKey = 7
        real CrocodileSand_Radius = 210.0
        real CrocodileSand_LargeAoe = 400.0
        real CrocodileSand_GroundDuration = 8.0
        real CrocodileSand_FadeTime = 0.8
        integer CrocodileSand_Alpha = 128
        private constant real CrocodileSand_TrackPeriod = 0.15
        private group CrocodileSand_ScanGroup = null
        constant real CrocodileSand_MinDistance = 180.0
        integer CrocodileSand_Slow = 10

//================================ Crocodile Q ========================================
        integer CrocodileQ_ID = 'A000'
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
        integer CrocodileQ_Slow = 30
        real CrocodileQ_PullDistance = 55.0
        real CrocodileQ_PullDuration = 0.18
        real CrocodileQ_SandSlowTime = 5.0
        integer CrocodileQ_Animation = 10
        real CrocodileQ_EffectScale = 0.45
        real CrocodileQ_EffectHeight = 40.0
        real CrocodileQ_ExplosionScale = 0.85
        real CrocodileQ_ExplosionDuration = 1.0

//================================ Crocodile W ========================================
        integer CrocodileW_ID = 'A001'
        real CrocodileW_Duration = 3.0
        real CrocodileW_CastTime = 0.45
        integer CrocodileW_Hits = 6
        real CrocodileW_Aoe = 600.0
        real CrocodileW_PullSpeed = 150.0
        real CrocodileW_EdgePullMultiplier = 0.20
        real CrocodileW_DamageAgi = 0.75
        integer CrocodileW_Slow = 30
        real CrocodileW_ComboDamageAgi = 3.0
        real CrocodileW_ComboStun = 1.5
        integer CrocodileW_Animation = 10

//================================ Crocodile E ========================================
        integer CrocodileE_ID = 'A002'
        private constant integer CrocodileE_DataKey = 1
        real CrocodileE_Distance = 600.0
        real CrocodileE_Duration = 0.24
        real CrocodileE_MoveDelay = 0.15
        real CrocodileE_AnimationSpeed = 0.46
        real CrocodileE_SlashScale = 0.4025
        real CrocodileE_Aoe = 200.0
        real CrocodileE_DamageAgiBase = 3.0
        real CrocodileE_DamageAgiStep = 1.0
        real CrocodileE_Recharge = 1.0
        real CrocodileE_UseCD = 1.0
        integer CrocodileE_Slow = 35
        integer CrocodileE_Animation = 3

//================================ Crocodile R ========================================
        integer CrocodileR_ID = 'A003'
        real CrocodileR_Speed = 540.0
        real CrocodileR_SandSpacing = 180.0
        real CrocodileR_Duration = 2.5
        real CrocodileR_StartScale = 0.30
        real CrocodileR_EndScale = 1.00
        real CrocodileR_CastTime = 0.45
        real CrocodileR_StartAoe = 200.0
        real CrocodileR_EndAoe = 445.0
        real CrocodileR_DamageAgi = 0.6
        private constant integer CrocodileR_TargetKey = 5
        real CrocodileR_OrbitSpeed = 400.0
        real CrocodileR_LiftSpeed = 700.0
        real CrocodileR_Height = 600.0
        real CrocodileR_OrbitRadius = 0.8
        integer CrocodileR_Animation = 6

//================================ Crocodile T ========================================
        integer CrocodileT_ID = 'A004'
        private constant integer CrocodileT_DataKey = 4
        real CrocodileT_Duration = 5.0
        real CrocodileT_ManaDrain = 0.10
        real CrocodileT_Reduction = 0.20
        real CrocodileT_SpreadTime = 2.0
        real CrocodileT_MaxAoe = 1800.0
        real CrocodileT_PatchSpacing = 318.0
        integer CrocodileT_Animation = 5

//================================ Crocodile T2 ========================================
        integer CrocodileT2_ID = 'A015'
        real CrocodileT2_Unlock = 1.0
        real CrocodileT2_DamageAgi = 17.0

//================================ Crocodile F ========================================
        integer CrocodileF_ID = 'A01V'
        private constant integer CrocodileF_DataKey = 2
        integer CrocodileF_MaxStacks = 3
        real CrocodileF_Range = 800.0
        real CrocodileF_AttackSpeed = 3.0
        real CrocodileF_DamageAgi = 3.0
        real CrocodileF_InternalCD = 2.0
        real CrocodileF_ProjectileSpeed = 1800.0
        real CrocodileF_ProjectileAoe = 155.0

//================================ Crocodile G ========================================
        integer CrocodileG_ID = 'A01U'
        private constant integer CrocodileG_DataKey = 3
        integer CrocodileG_MoveSpeed = 80
        real CrocodileG_ManaDrain = 0.01
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
            local string model ="war3mapImported\\wos_ysjsm45.mdl"
            set largeVisual = radius >= CrocodileSand_LargeAoe
            if largeVisual then
                set model = "war3mapImported\\wos_ysjsm45.mdl"
            endif
            set e = EffectSpawn(model,x,y,GetRandomReal(0,359),0.5,radius/175.0,0)
            call BlzSetSpecialEffectAlpha(e,0)
            call ColorEffDummy4(e,0,255,255,255,0.39)
        endmethod


        static method CrocodileSand_IsOnGround takes unit u, unit source returns boolean
            local integer i = 0
            local thistype this
            loop
                exitwhen i > MUI
                set this = m[i]
                if c == source and not endNow and SR3(u,x,y) <= radius then
                    return true
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
                    call ColorEffDummy3(e,0.0,255,255,255,CrocodileSand_FadeTime)
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
                        if not largeVisual and radius >= CrocodileSand_LargeAoe then
                            // Let the old fade-in finish before releasing its handle.
                            call MyRemoveEff(e,0.42)
                            call CrocodileSand_CreateVisual()
                        else
                            call BlzSetSpecialEffectScale(e,radius/150.0)
                        endif
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

        static method Apply takes unit source, unit target returns boolean
            local thistype this
            if target == null or not SpellBool(target) or not IsUnitEnemy(target,GetOwningPlayer(source)) or IsUnitType(target,UNIT_TYPE_STRUCTURE) or GetUnitAbilityLevel(target,'Aloc') > 0 then
                return false
            endif
            if LoadInteger(CrocodileTable,GetHandleId(target),CrocodileSand_DebuffKey) != 0 then
                return false
            endif
            set this = thistype.allocate()
            set c = source
            set u = target
            set lastX = GetUnitX(u)
            set lastY = GetUnitY(u)
            set pulse = 0.0
            set r = 0.0
            set rmax = CrocodileSand_Duration
            set e = AddSpecialEffectTarget("war3mapImported\\wos_az_f076_clear.mdl",u,"origin")
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
                if r + 0.001 >= rmax or GetUnitTypeId(u) == 0 or GetWidgetLife(u) <= 0.405 or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
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
                    if pulse + 0.001 >= CrocodileSand_TrackPeriod and GetUnitTypeId(c) != 0 and IsUnitEnemy(u,GetOwningPlayer(c)) then
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

//================================ Crocodile Q - Desert Spada ========================================
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
            // Only a fresh enemy debuff creates ground sand, at the target's position.
            if CrocodileSand_Debuff.Apply(c,u) then
                call CrocodileSand_Struct.CrocodileSand_Start(c,GetUnitX(u),GetUnitY(u),CrocodileSand_Radius,true)
            endif
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
                            set effectDistance = RMinBJ(distance,effectStop)
                            call BlzSetSpecialEffectX(e,startX+effectDistance*Cos(a))
                            call BlzSetSpecialEffectY(e,startY+effectDistance*Sin(a))
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
//---------------- Q first pass: scan by AoE, not every move tick -------------
                        loop
                            exitwhen scanDistance >= distance or (distance-scanDistance+0.001 < scanStep and distance+0.001 < maxDistance)
                            set section = RMinBJ(scanStep,distance-scanDistance)
                            set px = startX+(scanDistance+section/2)*Cos(a)
                            set py = startY+(scanDistance+section/2)*Sin(a)
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
                                    call SlowUnit(c,u,CrocodileQ_Slow,2)
                                    if CrocodileQ_PullDuration > 0.0 and SR3(u,px,py) > 1.0 then
                                        call MUE(u,RMinBJ(CrocodileQ_PullDistance,SR3(u,px,py)),CrocodileQ_PullDuration,Atan2(py-GetUnitY(u),px-GetUnitX(u)))
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
            if LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileCore_DataKey) == 0 or IsUnitIllusion(NewC) or not SpellBoolCaster(NewC) or LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileT_DataKey) != 0 then
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
        group g
        effect e
        boolean combo


        // Shared only by W cast and Q crossing a pit. One combo per pit.
        method CrocodileW_Combo takes nothing returns nothing
            local unit u
            local effect e2
            if combo then
                return
            endif
            set combo = true
            set e2 = EffectSpawn("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl",x,y,0,1,radius/150.0,0)
            call MyRemoveEff(e2,1.0)
            call GroupEnumUnitsInRange(g,x,y,radius,NoDecor_Cond)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                call GroupRemoveUnit(g,u)
                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                    call dmgphys(c,u,GetHeroAgi(c,true)*CrocodileW_ComboDamageAgi)
                    call MUE(u,SR3(u,x,y),0.24,Atan2(y-GetUnitY(u),x-GetUnitX(u)))
                    call StunUnit(c,u,CrocodileW_ComboStun)
                endif
            endloop
            set u = null
            set e2 = null
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
                if r> 0.51 then 
//---------------- W + Q: check the current segment, including final tick ----
                set j = 0
                loop
                    exitwhen j > CrocodileQ_Struct.MUI
                    set slash = CrocodileQ_Struct.m[j]
                    if slash.c == c and slash.distance > 0.0 and not combo then
                        set projection = RMaxBJ(slash.previousDistance,RMinBJ(slash.distance,(x-slash.startX)*Cos(slash.a)+(y-slash.startY)*Sin(slash.a)))
                        if SR0(x,y,slash.startX+projection*Cos(slash.a),slash.startY+projection*Sin(slash.a)) <= radius+slash.radius then
                            call CrocodileW_Combo()
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
                    if scanTime + 0.001 >= 0.15 or r + 0.001 >= rmax then
                        set scanTime = 0.0
                        call GroupEnumUnitsInRange(g,x,y,radius,NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g,u)
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                                set distance = SR3(u,x,y)
                                // Quadratic depth: weak at the rim, stronger near the center.
                                set depth = RMaxBJ(0.0,1.0-distance/RMaxBJ(1.0,radius))
                                set pullSpeed = CrocodileW_PullSpeed*(CrocodileW_EdgePullMultiplier+(1.0-CrocodileW_EdgePullMultiplier)*depth*depth)
                                if distance > 0.0 then
                                    call MUE(u,RMinBJ(pullSpeed*0.15,distance),0.15,Atan2(y-GetUnitY(u),x-GetUnitX(u)))
                                endif
                            endif
                        endloop
                    endif
                    loop
                        exitwhen hits >= CrocodileW_Hits or r + 0.001 < (hits+1)*rmax/IMaxBJ(1,CrocodileW_Hits)
                        call GroupEnumUnitsInRange(g,x,y,radius,NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g,u)
                            if SpellBool(u) and IsUnitEnemy(u,GetOwningPlayer(c)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) then
                                call dmgphys(c,u,dmg)
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
                    call DestroyGroup(g)
                    set c = null
                    set e = null
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

        static method CrocodileW_Begin takes unit NewC, real NewX, real NewY returns boolean
            local thistype this
            if LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileCore_DataKey) == 0 or IsUnitIllusion(NewC) or not SpellBoolCaster(NewC) or LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileT_DataKey) != 0 then
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
            set hits = 0
            set castPauseHeld = true
            call StartSpellUnit2(c)
            set scanTime = 0.0
            set combo = false
            set dmg = GetHeroAgi(c,true)*CrocodileW_DamageAgi
            set g = CreateGroup()
            set e = EffectSpawnScale("war3mapImported\\wos_file00000862.mdl",x,y,0,1,0.01,0,0.51,0.01,radius/1200)
            
            call SetUnitAnimationByIndex(c,CrocodileW_Animation)
            call MakeSound("war3mapImported\\Hero_Crocodile_W")
            return true
        endmethod


    endstruct

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
        real x
        real y
        real a
        effect e2
        real r
        real rmax
        real duration
        real moveDelay
        real distance
        real maxDistance
        real radius
        real dmg
        group g
        group g2
        effect e


        static method Loop_CrocodileE takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer count
            local real remaining
            local real step
            local real oldX
            local real oldY
            local unit u
            loop
                exitwhen i > MUI
                set this = m[i]
//---------------- E: three independent recharge clocks ----------------------
                set useCooldown = RMaxBJ(0.0,useCooldown-CrocodilePeriod)
                set charge1 = RMaxBJ(0.0,charge1-CrocodilePeriod)
                set charge2 = RMaxBJ(0.0,charge2-CrocodilePeriod)
                set charge3 = RMaxBJ(0.0,charge3-CrocodilePeriod)
                set count = 0
                set remaining = CrocodileE_Recharge
                if charge1 == 0.0 then
                    set count = count + 1
                else
                    set remaining = RMinBJ(remaining,charge1)
                endif
                if charge2 == 0.0 then
                    set count = count + 1
                else
                    set remaining = RMinBJ(remaining,charge2)
                endif
                if charge3 == 0.0 then
                    set count = count + 1
                else
                    set remaining = RMinBJ(remaining,charge3)
                endif
                if count > 0 then
                    set remaining = 0.0
                endif
                set remaining = RMaxBJ(remaining,useCooldown)
                if remaining <= 0.0 then
                    call BlzEndUnitAbilityCooldown(c,CrocodileE_ID)
                elseif BlzGetUnitAbilityCooldownRemaining(c,CrocodileE_ID) < remaining then
                    call BlzStartUnitAbilityCooldown(c,CrocodileE_ID,remaining)
                endif
                if count != shownCharges and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 then
                    set shownCharges = count
                    call TasAbilityChargeBox_SetValue(c,CrocodileE_ID,I2S(count))
                endif
//---------------- E dash and damage: variables belong to E only ------------
                if active then
                    set r = RoundReal(r+CrocodilePeriod,3)
                    if r > moveDelay and not cancelDash and SpellBoolCaster(c) and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 then
                        set oldX = x
                        set oldY = y
                        set step = RMinBJ(maxDistance*CrocodilePeriod/duration,maxDistance-distance)
                        if not IsTerrainPathable(x+step*Cos(a),y+step*Sin(a),PATHING_TYPE_WALKABILITY) then
                            call MoveUnit3(c,step,a)
                             call MoveEff(e2,step,a)
                        endif
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        set distance = distance + step
                        call GroupEnumUnitsInRange(g,(x+oldX)/2,(y+oldY)/2,radius+SR0(x,y,oldX,oldY)/2,NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g,u)
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) and not IsUnitInGroup(u,g2) then
                                call GroupAddUnit(g2,u)
                                call dmgphys(c,u,dmg)
                                call SlowUnit(c,u,CrocodileE_Slow,2)
                            endif
                        endloop
                        if r + 0.001 >= moveDelay+duration then
                            call CrocodileSand_Struct.CrocodileSand_Start(c,x,y,CrocodileSand_Radius,false)
                        endif
                    endif
                    if cancelDash or r + 0.001 >= moveDelay+duration or r >= rmax or not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                        set active = false
                        if castPauseHeld then
                            set castPauseHeld = false
                            call StopSpellUnit2(c)
                        endif
                        call DestroyEffect(e)
                        call ColorEffDummy3(e2,0,255,255,255,0.15)
                        call DestroyGroup(g)
                        call DestroyGroup(g2)
                        set e = null
                        set e2 = null
                        set g = null
                        set g2 = null
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
            set u = null
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
            set shownCharges = 3
            set castPauseHeld = false
            set active = false
            set cancelDash = false
            set g = null
            set g2 = null
            set e = null
            call SaveInteger(CrocodileTable,GetHandleId(c),CrocodileE_DataKey,this)
            call TasAbilityChargeBox_SetValue(c,CrocodileE_ID,"3")
        endmethod

        static method CrocodileE_Begin takes unit NewC, real NewX, real NewY returns boolean
            local thistype this = LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileE_DataKey)
            if LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileCore_DataKey) == 0 or IsUnitIllusion(NewC) or not SpellBoolCaster(NewC) or LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileT_DataKey) != 0 then
                return false
            endif
            if this == 0 or active or useCooldown > 0.0 or CrocodileE_Duration <= 0.0 then
                return false
            endif
            if charge1 == 0.0 then
                set charge1 = CrocodileE_Recharge
            elseif charge2 == 0.0 then
                set charge2 = CrocodileE_Recharge
            elseif charge3 == 0.0 then
                set charge3 = CrocodileE_Recharge
            else
                return false
            endif
            set useCooldown = CrocodileE_UseCD
            call BlzStartUnitAbilityCooldown(c,CrocodileE_ID,useCooldown)
            set castPauseHeld = true
            call StartSpellUnit2(c)
            set active = true
            set cancelDash = false
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set a = Atan2(NewY-y,NewX-x)
            set r = 0.0
            set duration = CrocodileE_Duration
            set moveDelay = RMaxBJ(0.0,CrocodileE_MoveDelay)
            set rmax = RMaxBJ(3.0,moveDelay+duration+CrocodilePeriod)
            set distance = 0.0
            set maxDistance = RMinBJ(CrocodileE_Distance,SR3(c,NewX,NewY))
            set radius = CrocodileE_Aoe
            set dmg = GetHeroAgi(c,true)*(CrocodileE_DamageAgiBase+CrocodileE_DamageAgiStep*(GetUnitAbilityLevel(c,CrocodileE_ID)-1))
            set g = CreateGroup()
            set g2 = CreateGroup()
//---------------- E effect --------------------------------------------------
            set e = AddSpecialEffectTarget("war3mapImported\\wos_Death_Spell2.mdl",c,"hand right")

            call SetUnitAnimationByIndex(c,CrocodileE_Animation)
            call SetUnitTimeScale(c,CrocodileE_AnimationSpeed)
            set e2 = EffectSpawn("war3mapImported\\wos_tx-084.mdl",GetUnitX(c)+150*Cos(a),GetUnitY(c)+150*Sin(a),a*bj_RADTODEG,1.25,CrocodileE_SlashScale,110)
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
        real height
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
        real pulse
        real sandDistance
        real radius
        real dmg
        group g
        integer captured
        effect e
        boolean castPauseHeld
        boolean endNow

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
            call SetFly(u,target.height)
            call BlzPauseUnitEx(u,false)
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
            loop
                exitwhen i > MUI
                set this = m[i]
                set r = RoundReal(r+CrocodilePeriod,3)
                set pulse = pulse + CrocodilePeriod
                if castPauseHeld and (r + 0.001 >= CrocodileR_CastTime or endNow or not SpellBoolCaster(c)) then
                    set castPauseHeld = false
                    call StopSpellUnit2(c)
                endif
                if not endNow and SpellBoolCaster(c) and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 then
                    // Aim selects the direction; the tornado keeps travelling for its lifetime.
                    set step = CrocodileR_Speed*CrocodilePeriod
                    set x = x + step*Cos(a)
                    set y = y + step*Sin(a)
                    set sandDistance = sandDistance + step
                    set sandSpacing = RMaxBJ(CrocodileSand_MinDistance,CrocodileR_SandSpacing)
                    loop
                        exitwhen sandDistance + 0.001 < sandSpacing
                        set trailOffset = sandDistance-sandSpacing
                        // Fresh patches only: shared spacing check skips existing sand.
                        call CrocodileSand_Struct.CrocodileSand_Start(c,x-trailOffset*Cos(a),y-trailOffset*Sin(a),CrocodileSand_Radius,true)
                        set sandDistance = sandDistance-sandSpacing
                    endloop
                    set radius = CrocodileR_StartAoe + (CrocodileR_EndAoe-CrocodileR_StartAoe)*RMinBJ(1.0,r/RMaxBJ(rmax,CrocodilePeriod))
                    call BlzSetSpecialEffectX(e,x)
                    call BlzSetSpecialEffectY(e,y)
                    call BlzSetSpecialEffectScale(e,CrocodileR_StartScale+(CrocodileR_EndScale-CrocodileR_StartScale)*RMinBJ(1.0,r/RMaxBJ(rmax,CrocodilePeriod)))
                    call GroupEnumUnitsInRange(g,x,y,radius,NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        call GroupRemoveUnit(g,u)
                        if SpellBool(u) and IsUnitEnemy(u,GetOwningPlayer(c)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) and not GearCCProtected(u) and not IsUnitPaused(u) and LoadInteger(CrocodileTable,GetHandleId(u),CrocodileR_TargetKey) == 0 then
                            set target = CrocodileR_Target.create()
                            set target.u = u
                            set target.owner = this
                            set target.height = GetUnitFlyHeight(u)
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
                            call BlzPauseUnitEx(u,true)
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
                            call SetFly(u,target.height+target.lift*(0.85+0.15*Sin(angle)))
                            call SetUnitX(u,x+radius*CrocodileR_OrbitRadius*Cos(angle))
                            call SetUnitY(u,y+radius*CrocodileR_OrbitRadius*Sin(angle))
                            if pulse + 0.001 >= 1.0 then
                                call dmgphys(c,u,dmg)
                            endif
                        endif
                        set target = next
                    endloop
                    if pulse + 0.001 >= 1.0 then
                        set pulse = pulse - 1.0
                    endif
                endif
                if endNow or r + 0.001 >= rmax or not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                    if castPauseHeld then
                        set castPauseHeld = false
                        call StopSpellUnit2(c)
                    endif
                    call CrocodileR_ReleaseAll()
                    call DestroyEffect(e)
                    call DestroyGroup(g)
                    set c = null
                    set e = null
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
            if LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileCore_DataKey) == 0 or IsUnitIllusion(NewC) or not SpellBoolCaster(NewC) or LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileT_DataKey) != 0 or CrocodileR_Duration <= 0.0 then
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
            set pulse = 0.0
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
            call SetUnitAnimationByIndex(c,CrocodileR_Animation)
            call MakeSound("war3mapImported\\Hero_Crocodile_R_2")
            call MakeSound("war3mapImported\\Hero_Crocodile_R2")
            call NextSound("war3mapImported\\Hero_Crocodile_R6",0.8)
            return true
        endmethod
    endstruct

//================================ Crocodile T - Ground Secco ========================================
    private struct CrocodileT_Struct
        static integer array m
        static integer MUI = -1
        unit c
        real x
        real y
        real radius
        real nextRing
        real r
        real rmax
        real pulse
        group g
        effect e
        effect e2
        boolean endNow


        // Shared by timeout, T2, death and removal. Balanced enhanced pause.
        static method CrocodileT_Finish takes unit NewC returns nothing
            local thistype this = LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileT_DataKey)
            if this == 0 then
                return
            endif
            set endNow = true
            call RemoveSavedInteger(CrocodileTable,GetHandleId(c),CrocodileT_DataKey)
            call StopSpellUnit2(c)
            call GearCCProtect(c,false)





            call UnitRemoveAbility(c,CrocodileT2_ID)
            call SetUnitAnimation(c,"stand")
        endmethod

        static method Loop_CrocodileT takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer j
            local integer points
            local real a
            local unit u
            loop
                exitwhen i > MUI
                set this = m[i]
                set r = RoundReal(r+CrocodilePeriod,3)
                set pulse = pulse + CrocodilePeriod
                if not endNow and SpellBoolCaster(c) and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 then
                    set radius = CrocodileT_MaxAoe*RMinBJ(1.0,r/RMaxBJ(CrocodilePeriod,CrocodileT_SpreadTime))
                    // Materialize each ring once; at most five rings for the default area.
                    loop
                        exitwhen nextRing+CrocodileSand_Radius > radius or nextRing+CrocodileSand_Radius > CrocodileT_MaxAoe
                        set points = R2I(2*bj_PI*nextRing/CrocodileT_PatchSpacing)+1
                        set j = 0
                        loop
                            exitwhen j >= points
                            set a = 2*bj_PI*j/points
                            call CrocodileSand_Struct.CrocodileSand_Start(c,x+nextRing*Cos(a),y+nextRing*Sin(a),CrocodileSand_Radius,false)
                            set j = j + 1
                        endloop
                        set nextRing = nextRing+CrocodileT_PatchSpacing
                    endloop
                    call BlzSetSpecialEffectScale(e,radius/250.0)
                    if r + 0.001 >= CrocodileT2_Unlock and GetUnitAbilityLevel(c,CrocodileT2_ID) == 0 then
                        call UnitAddAbility(c,CrocodileT2_ID)
                        call BlzEndUnitAbilityCooldown(c,CrocodileT2_ID)
                    endif
                    if pulse + 0.001 >= 1.0 then
                        set pulse = pulse - 1.0
                        call GroupEnumUnitsInRange(g,x,y,radius,NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g,u)
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                                call SetMpCurrent(u,-CrocodileT_ManaDrain*GetUnitState(u,UNIT_STATE_MAX_MANA))
                            endif
                        endloop
                    endif
                endif
                if endNow or r + 0.001 >= rmax or not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                    if LoadInteger(CrocodileTable,GetHandleId(c),CrocodileT_DataKey) == this then
                        call CrocodileT_Finish(c)
                    endif
                    call DestroyEffect(e)
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

        static method CrocodileT_Begin takes unit NewC returns boolean
            local thistype this
            local CrocodileE_Struct dash = LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileE_DataKey)
            if LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileCore_DataKey) == 0 or IsUnitIllusion(NewC) or not SpellBoolCaster(NewC) or LoadInteger(CrocodileTable, GetHandleId(NewC), CrocodileT_DataKey) != 0 then
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
            set radius = 0.0
            set nextRing = CrocodileT_PatchSpacing
            set r = 0.0
            set rmax = CrocodileT_Duration
            set pulse = 0.0
            set endNow = false
            set g = CreateGroup()
//---------------- T effect --------------------------------------------------
            set e = EffectSpawn("Abilities\\Spells\\Orc\\EarthQuake\\EarthQuakeTarget.mdl",x,y,0,0.5,0.1,0)
            set e2 = null
            call CrocodileSand_Struct.CrocodileSand_Start(c,x,y,CrocodileSand_Radius,false)
            call SaveInteger(CrocodileTable,GetHandleId(c),CrocodileT_DataKey,this)
            if dash != 0 then
                set dash.cancelDash = true
                if dash.castPauseHeld then
                    set dash.castPauseHeld = false
                    call StopSpellUnit2(c)
                endif
            endif
            call GearCCProtect(c,true)
            call DebuffClear(c)
            call IssueImmediateOrder(c,"stop")
            call StartSpellUnit2(c)





            call SetUnitAnimationByIndex(c,CrocodileT_Animation)
            call MakeSound("war3mapImported\\Hero_Crocodile_T 1")
            return true
        endmethod


    endstruct

//================================ Crocodile T2 - Ground Death ========================================
    private struct CrocodileT2_Struct extends array
        // Immediate detonation needs local groups, not a timer/allocated instance.
        static method CrocodileT2_Begin takes unit c returns boolean
            local CrocodileT_Struct channel = LoadInteger(CrocodileTable,GetHandleId(c),CrocodileT_DataKey)
            local CrocodileSand_Struct sand
            local integer i = 0
            local unit u
            local effect e
            local group g
            local group g2
            if channel == 0 or channel.endNow or channel.r + 0.001 < CrocodileT2_Unlock or not SpellBoolCaster(c) then
                return false
            endif
            set g = CreateGroup()
            set g2 = CreateGroup()
            loop
                exitwhen i > CrocodileSand_Struct.MUI
                set sand = CrocodileSand_Struct.m[i]
                if sand.c == c and not sand.endNow then
                    call GroupEnumUnitsInRange(g,sand.x,sand.y,sand.radius,NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        call GroupRemoveUnit(g,u)
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                            call GroupAddUnit(g2,u)
                        endif
                    endloop
//---------------- T2 sand explosions ---------------------------------------
                    set e = EffectSpawn("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl",sand.x,sand.y,0,1,sand.radius/150.0,0)
                    call MyRemoveEff(e,1.0)
                    set sand.endNow = true
                endif
                set i = i + 1
            endloop
            call CrocodileT_Struct.CrocodileT_Finish(c)
            loop
                set u = FirstOfGroup(g2)
                exitwhen u == null
                call GroupRemoveUnit(g2,u)
                call dmgphys(c,u,GetHeroAgi(c,true)*CrocodileT2_DamageAgi)
            endloop
            call DestroyGroup(g)
            call DestroyGroup(g2)
            set g = null
            set g2 = null
            set e = null
            set u = null
            return true
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
        group g
        group g2
        effect e

        static method Loop_CrocodileF_Projectile takes nothing returns nothing
            local thistype this
            local integer i = 0
            local unit u
            local real step
            local real px
            local real py
            local real projection
            loop
                exitwhen i > MUI
                set this = m[i]
                if SpellBoolCaster(c) and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 then
                    set step = RMinBJ(CrocodileF_ProjectileSpeed*CrocodilePeriod,CrocodileF_Range-distance)
                    call GroupEnumUnitsInRange(g,x+step*0.5*Cos(a),y+step*0.5*Sin(a),CrocodileF_ProjectileAoe+step*0.5,NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        call GroupRemoveUnit(g,u)
                        set projection = RMaxBJ(0.0,RMinBJ(step,(GetUnitX(u)-x)*Cos(a)+(GetUnitY(u)-y)*Sin(a)))
                        set px = x+projection*Cos(a)
                        set py = y+projection*Sin(a)
                        if SpellBool(u) and IsUnitEnemy(u,GetOwningPlayer(c)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) and not IsUnitInGroup(u,g2) and SR3(u,px,py) <= CrocodileF_ProjectileAoe then
                            call GroupAddUnit(g2,u)
                            call dmgphys(c,u,dmg)
                        endif
                    endloop
                    set distance = distance + step
                    set x = x + step*Cos(a)
                    set y = y + step*Sin(a)
                    call BlzSetSpecialEffectX(e,x)
                    call BlzSetSpecialEffectY(e,y)
                endif
                if distance >= CrocodileF_Range or not SpellBoolCaster(c) or LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
                    call DestroyEffect(e)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set e = null
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
            set u = null
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
            set distance = 0.0
            set dmg = GetHeroAgi(c,true)*CrocodileF_DamageAgi
            set g = CreateGroup()
            set g2 = CreateGroup()
            set e = EffectSpawn("war3mapImported\\wos_File00001240.mdl",x,y,a*bj_RADTODEG,1,CrocodileQ_EffectScale,CrocodileQ_EffectHeight)
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
        real cooldown
        boolean ownsAttackBlock
        unit pendingTarget

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
                // Weapon 2 has range 800 in object data; never use the broken range setter.
                call BlzSetUnitWeaponBooleanField(c, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, false)
                call BlzSetUnitWeaponBooleanField(c, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, true)
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
            endif
            set a = null
        endmethod

        static method CrocodileF_Attack takes unit NewC, unit target, real amount returns real
            local thistype this = LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileF_DataKey)
            if this == 0 or LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileCore_DataKey) == 0 or IsUnitIllusion(NewC) or not SpellBoolCaster(NewC) or not IsUnitEnemy(target,GetOwningPlayer(NewC)) or not SpellBool(target) or amount <= 0.0 then
                return amount
            endif
            if stacks <= 0 or GetUnitAbilityLevel(c,CrocodileF_ID) == 0 or cooldown > TimerGetElapsed(GearTimer03) or GetUnitAbilityLevel(c,'Abun') > 0 or CrocodileF_ProjectileSpeed <= 0.0 or CrocodileF_Range <= 0.0 then
                return amount
            endif
            // Elapsed clock fraction prevents a proc just before a tick shortening the CD.
            set cooldown = CrocodileF_InternalCD+TimerGetElapsed(GearTimer03)
            call CrocodileF_SetEnhanced(false)
            call UnitAddAbility(c,'Abun')
            set ownsAttackBlock = true
            set pendingTarget = target
            // Hold Abun until the shared loop actually emits the projectile.
            return 0.0
        endmethod

        static method Loop_CrocodileF takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI
                set this = m[i]
                set cooldown = RMaxBJ(0.0,cooldown-CrocodilePeriod)
                if ownsAttackBlock then
                    if SpellBoolCaster(c) and not IsUnitIllusion(c) and GetUnitAbilityLevel(c,CrocodileF_ID) > 0 and LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 and GetUnitTypeId(pendingTarget) != 0 and SpellBool(pendingTarget) and IsUnitEnemy(pendingTarget,GetOwningPlayer(c)) then
                        call CrocodileF_Projectile.CrocodileF_Projectile_Start(c,pendingTarget)
                        set stacks = IMaxBJ(0,stacks-1)
                        call TasAbilityChargeBox_SetValue(c,CrocodileF_ID,I2S(stacks))
                    endif
                    call UnitRemoveAbility(c,'Abun')
                    set ownsAttackBlock = false
                    set pendingTarget = null
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
            set pendingTarget = null
            call SaveInteger(CrocodileTable,GetHandleId(c),CrocodileF_DataKey,this)
            call TasAbilityChargeBox_SetValue(c,CrocodileF_ID,"0")
        endmethod


    endstruct

//================================ Crocodile G - Suna Suna no Mi ========================================
    private struct CrocodileG_Struct
        static integer array m
        static integer MUI = -1
        unit c
        boolean onSand
        boolean ownsMS
        integer savedMS

        method CrocodileG_SandSpeed takes boolean enabled returns nothing
            local ability a
            local integer value
            if enabled == onSand then
                return
            endif
            set onSand = enabled
            if enabled then
                set ownsMS = GetUnitAbilityLevel(c, 'AIms') == 0
                if ownsMS then
                    call UnitAddAbility(c, 'AIms')
                endif
                set a = BlzGetUnitAbility(c, 'AIms')
                set savedMS = BlzGetAbilityIntegerLevelField(a, ABILITY_ILF_MOVEMENT_SPEED_BONUS, 0)
                if ownsMS then
                    set value = CrocodileG_MoveSpeed
                else
                    set value = savedMS + CrocodileG_MoveSpeed
                endif
                call BlzSetAbilityIntegerLevelField(a, ABILITY_ILF_MOVEMENT_SPEED_BONUS, 0, value)
                call CrocodileBonus_Refresh(c, 'AIms')
            else
                set a = BlzGetUnitAbility(c, 'AIms')
                set value = BlzGetAbilityIntegerLevelField(a, ABILITY_ILF_MOVEMENT_SPEED_BONUS, 0)
                if ownsMS and value == CrocodileG_MoveSpeed then
                    call UnitRemoveAbility(c, 'AIms')
                else
                    if ownsMS then
                        set value = value - CrocodileG_MoveSpeed + savedMS
                    else
                        set value = value - CrocodileG_MoveSpeed
                    endif
                    call BlzSetAbilityIntegerLevelField(a, ABILITY_ILF_MOVEMENT_SPEED_BONUS, 0, value)
                    call CrocodileBonus_Refresh(c, 'AIms')
                endif
            endif
            set a = null
        endmethod

        static method Loop_CrocodileG takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI
                set this = m[i]
                call CrocodileG_SandSpeed(LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 and SpellBoolCaster(c) and GetUnitAbilityLevel(c,CrocodileG_ID) > 0 and CrocodileSand_Struct.CrocodileSand_IsOnGround(c,c))
                if LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 then
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
            set ownsMS = false
            set savedMS = 0
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
            call CrocodileW_Struct.Loop_CrocodileW()
            call CrocodileE_Struct.Loop_CrocodileE()
            call CrocodileR_Struct.Loop_CrocodileR()
            call CrocodileT_Struct.Loop_CrocodileT()
            call CrocodileSand_Struct.Loop_CrocodileSand()
            call CrocodileSand_Debuff.Loop_CrocodileSandDebuff()
            call CrocodileF_Struct.Loop_CrocodileF()
            call CrocodileF_Projectile.Loop_CrocodileF_Projectile()
            call CrocodileG_Struct.Loop_CrocodileG()
        endmethod

        static method Register_Crocodile takes unit NewC returns nothing
            local thistype this
            if NewC == null or IsUnitIllusion(NewC) or LoadInteger(CrocodileTable,GetHandleId(NewC),CrocodileCore_DataKey) != 0 then
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
                    if attack.ownsAttackBlock then
                        call UnitRemoveAbility(c,'Abun')
                        set attack.ownsAttackBlock = false
                        set attack.pendingTarget = null
                    endif
                    call TasAbilityChargeBox_SetValue(c,CrocodileF_ID,"0")
                    call attack.CrocodileF_SetEnhanced(false)
                endif
                if passive != 0 then
                    call passive.CrocodileG_SandSpeed(false)
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
                if passive != 0 and passive.onSand and GetUnitAbilityLevel(clone,'AIms') > 0 then
                    if passive.ownsMS then
                        call UnitRemoveAbility(clone,'AIms')
                    else
                        set a = BlzGetUnitAbility(clone,'AIms')
                        call BlzSetAbilityIntegerLevelField(a,ABILITY_ILF_MOVEMENT_SPEED_BONUS,0,passive.savedMS)
                        call CrocodileBonus_Refresh(clone,'AIms')
                    endif
                endif
                call UnitRemoveAbility(clone,CrocodileT2_ID)
            endif
            set a = null
            set source = null
            set clone = null
        endmethod

        static method CrocodileCore_Damage takes unit c, unit td, real amount, integer kind, integer phase returns real
            local real maxMana
            local real missing
//---------------- T damage reduction ----------------------------------------
            if phase == 2 and LoadInteger(CrocodileTable,GetHandleId(td),CrocodileT_DataKey) != 0 then
                set amount = amount*(1.0-CrocodileT_Reduction)
            endif
            if LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) == 0 or IsUnitIllusion(c) or not IsUnitEnemy(td,GetOwningPlayer(c)) then
                return amount
            endif
//---------------- G: pure multiplier; drain only after positive spell damage -
            if GetUnitAbilityLevel(c,CrocodileG_ID) > 0 then
                if phase == 1 then
                    set maxMana = GetUnitState(td,UNIT_STATE_MAX_MANA)
                    if maxMana > 0.0 then
                        set missing = 100.0*(1.0-GetUnitState(td,UNIT_STATE_MANA)/maxMana)
                        set amount = amount*(1.0+RMinBJ(CrocodileG_MaxBonus,RMaxBJ(0.0,missing)*CrocodileG_MissingScale))
                    endif
                elseif phase == 3 and amount > 0.0 and (kind == 1 or kind == 2) then
                    call SetMpCurrent(td,-CrocodileG_ManaDrain*GetUnitState(td,UNIT_STATE_MAX_MANA))
                endif
            endif
            return amount
        endmethod


    endstruct

    // Explicit TEST registration prevents MAIN rawcode collisions.
    function Crocodile_Register takes unit c returns nothing
        call CrocodileCore_Struct.Register_Crocodile(c)
    endfunction

    function Crocodile_IsRegistered takes unit c returns boolean
        return LoadInteger(CrocodileTable,GetHandleId(c),CrocodileCore_DataKey) != 0 and not IsUnitIllusion(c)
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
        if Crocodile_IsRegistered(c) and SpellBoolCaster(c) and attack != 0 and GetUnitAbilityLevel(c,CrocodileF_ID) > 0 then
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

    private function InitCrocodileSpells takes nothing returns nothing
        local trigger summon = CreateTrigger()
        call TriggerAddAction(GearTimer03Listeners,function CrocodileCore_Struct.Loop_Crocodile)
        call TriggerRegisterAnyUnitEventBJ(summon,EVENT_PLAYER_UNIT_SUMMON)
        call TriggerAddAction(summon,function CrocodileCore_Struct.Crocodile_Summon)
        set summon = null
    endfunction
endlibrary
