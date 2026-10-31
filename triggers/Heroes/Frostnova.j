library FrostnovaSpells initializer InitFrostnovaSpells uses GearSystems, AAADest
    globals
        // ==================== COMMON: hero ID and shared state ====================
        integer Frostnova_ID = 'H002'
        private hashtable FrostnovaTable = InitHashtable()
        private unit array FrostnovaDummy
        private boolean FrostnovaListenerOn = false

        // Only Winter's Scar voice lines share a lock; normal casts play immediately.
        private string FrostnovaSoundPath = "war3mapImported\\Hero_Frostnova_"

        // ==================== Q: Ice Javelins ====================
        integer FrostnovaQ_ID = 'A116'
        real FrostnovaQ_DamageIntBase = 1.0
        real FrostnovaQ_DamageIntStep = 0.35
        real FrostnovaQ_DamageStatic = 75.0
        boolean FrostnovaQ_IsInvul = false
        real FrostnovaQ_Range = 1500.0
        real FrostnovaQ_RangeStep = 50.0
        real FrostnovaQ_RangeBonus35 = 150.0
        real FrostnovaQ_Speed = 2310.0
        real FrostnovaTQ_SpeedMultiplier = 1.15
        real FrostnovaQ_DecorDamage = 20.0
        real FrostnovaQ_Aoe = 150.0
        real FrostnovaQ_Recharge = 17.0
        real FrostnovaQ_RechargeStep = -1.0
        real FrostnovaQ_Stun = 0.1
        string FrostnovaQ_Model = "war3mapImported\\wos_ice_shard-7716D.mdx"
        string FrostnovaQ_TrailModel = "war3mapImported\\wos_[skillm]als-tx (6).mdx"
        string FrostnovaTQ_Model = "war3mapImported\\wos_ice_shard-7716D-dark.mdx"
        string FrostnovaTQ_ShadowModel = "war3mapImported\\wos_Frostnova_TQ_Smoke.mdx"
        real FrostnovaTQ_ParticleScale = 0.65
        integer FrostnovaTQ_ParticleAlpha = 180
        real FrostnovaQ_TrailScale = 0.7
        real FrostnovaQ_TrailHeightOffset = -40.0
        real FrostnovaTQ_ImpactScale = 0.5
        string FrostnovaTQ_ImpactModel = "war3mapImported\\wos_file00003436_2-dark.mdx"
        string FrostnovaQ_ImpactModel = "war3mapImported\\wos_file00003436_2.mdx"
        real FrostnovaQ_ModelScale = 0.7
        real FrostnovaQ_OrbitScaleDivisor = 3.0
        real FrostnovaQ_GrowTime = 0.18
        real FrostnovaQ_FlightHeight = 150.0
        real FrostnovaQ_DescendTime = 0.30
        real FrostnovaQ_OrbitSide = 110.0
        real FrostnovaQ_OrbitRowSide = 20.0
        real FrostnovaQ_OrbitSpeed = 1.4 // radians per second
        real FrostnovaQ_OrbitHeight = 25.0
        real FrostnovaQ_OrbitLayerHeight = 35.0
        real FrostnovaQ_OrbitSway = 12.0

        // ==================== W: Northern Winds ====================
        integer FrostnovaW_ID = 'A117'
        real FrostnovaW_DamageIntBase = 1
        real FrostnovaW_DamageIntStep = 1
        real FrostnovaW_DamageStatic = 100.0
        boolean FrostnovaW_IsInvul = false
        boolean FrostnovaTW_IsInvul = true
        real FrostnovaW_DecorDamage = 50.0
        real FrostnovaW_Range = 1600.0
        real FrostnovaW_RangeBonus35 = 150.0
        real FrostnovaW_Speed = 1540.0
        real FrostnovaW_SpeedBonus25 = 1.20
        real FrostnovaW_Aoe = 300.0
        real FrostnovaW_StartAoe = 80.0
        real FrostnovaW_Preparation = 0.51
        real FrostnovaW_Push = 450.0 // at the cast point; fades with wave distance
        real FrostnovaTW_Push = 750.0
        real FrostnovaW_PushFalloff = 0.35 // push multiplier at max range
        real FrostnovaTW_Angle = 25.0
        string FrostnovaW_Model = "war3mapImported\\wos_file00002579_1.mdx"
        string FrostnovaW_AirModel = "war3mapImported\\wos_tx026_1.mdx"
        real FrostnovaW_AirScale = 1.65
        real FrostnovaW_ModelScale = 1.65

        // ==================== E: Frostnova ====================
        integer FrostnovaE_ID = 'A118'
        real FrostnovaE_BurstDamageIntBase = 2.0
        real FrostnovaE_BurstDamageIntStep = 1.0
        real FrostnovaE_DecorDamage = 50.0
        real FrostnovaE_DamageIntBase = 0.30
        real FrostnovaE_DamageIntStep = 0.05
        real FrostnovaE_Aoe = 850.0
        real FrostnovaE_Duration = 8.0
        real FrostnovaE_Preparation = 0.75
        real FrostnovaE_Invulnerability = 0.6
        boolean FrostnovaE_IsInvul = true
        real FrostnovaE_Push = 250.0
        real FrostnovaTE_Stun = 1.0
        string FrostnovaE_Model = "war3mapImported\\wos_file00004977.mdx"
        real FrostnovaE_ModelScale = 3.25
        real FrostnovaE_BurstDuration = 0.75
        integer FrostnovaE_ResistBuffID = 'B0F0'
        integer FrostnovaE_HealCutBuffID = 'B0F1'
        integer FrostnovaE_ResistAbilityID = 'A1F0'
        integer FrostnovaE_HealCutAbilityID = 'A1F1'
        real FrostnovaE_Resist = 0.30
        real FrostnovaE_HealCut = 0.35
        real FrostnovaE_BuffPeriod = 0.12
        real FrostnovaE_SpikeScale = 4.0
        real FrostnovaTE_Aoe = 750.0
        real FrostnovaTE_DamageInt = 0.5
        string FrostnovaTE_Model = "war3mapImported\\wos_Frostnova_TE_Aura.mdx"
        string FrostnovaTE_AreaModel = "war3mapImported\\wos_Frostnova_TE_Area.mdx"

        // ==================== R: Icefield ====================
        integer FrostnovaR_ID = 'A119'
        real FrostnovaR_DecorDamage = 50.0
        real FrostnovaR_DamageIntBase = 1.0
        real FrostnovaR_DamageIntStep = 0.0
        real FrostnovaR_StackDamageInt = 0.05 // per Yeti Princess stack, per second
        real FrostnovaR_Aoe = 1050.0
        real FrostnovaR_Duration = 4.0
        real FrostnovaR_DurationStep = 1.0
        real FrostnovaR_Formation = 0.5
        real FrostnovaR_Range = 1200.0
        real FrostnovaTR_StartRoot = 1.0
        string FrostnovaTR_StartModel = "war3mapImported\\wos_emt-8.mdx"
        real FrostnovaTR_StartScale = 3.0
        real FrostnovaTR_BurstPeriod = 0.36
        real FrostnovaTR_BurstAoe = 450.0
        real FrostnovaTR_BurstDamageInt = 0.5
        string FrostnovaTR_BurstModel = "war3mapImported\\wos_az_kaldr_blast_t2small.mdx"
        real FrostnovaTR_BurstScale = 1
        string FrostnovaTR_CrystalModel = "war3mapImported\\wos_Frostnova_Ice_Shard-6CC27.mdx"
        real FrostnovaTR_CrystalScale = 2.0
        real FrostnovaTR_ExitRoot = 1.0
        real FrostnovaTR_ExitBand = 100.0
        real FrostnovaTR_TrapRadius = 110.0
        private integer array FrostnovaIcefields
        private integer FrostnovaIcefieldCount = 0
        private real array FrostnovaIcefieldX
        private real array FrostnovaIcefieldY
        private real array FrostnovaIcefieldRadius
        string FrostnovaR_Model = "war3mapImported\\wos_file00005537_3.mdx"
        real FrostnovaR_ModelRadius = 1050.0
        boolean FrostnovaR_IsInvul = false

        // ==================== T: Winter's Scar ====================
        integer FrostnovaT_ID = 'A11A'
        real FrostnovaT_Duration = 20.0
        real FrostnovaT_CooldownReduction = 10.0
        integer FrostnovaT_ShieldBuffID = 'B0F3'
        integer FrostnovaT_ShieldAbilityID = 'A1F2'
        real FrostnovaT_ShieldDuration = 2.0 // Native A1F2 duration; the "Shielded" title comes from Starts' full-shield visual.
        boolean FrostnovaT_IsInvul = false
        string FrostnovaT_Model = "war3mapImported\\wos_file00000456.mdx"

        // ==================== F: Yeti Princess ====================
        integer FrostnovaF_ID = 'A11B'
        integer FrostnovaF_DebuffID = 'A11C' // F debuff: levels 1-5 normal, 6-10 enhanced
        integer FrostnovaF1_BuffID = 'B042'
        integer FrostnovaTF1_BuffID = 'B043'
        integer FrostnovaF2_BuffID = 'B045'
        integer FrostnovaF3_BuffID = 'B046'
        integer FrostnovaF4_BuffID = 'B047'
        integer FrostnovaF5_BuffID = 'B048'
        integer FrostnovaTF2_BuffID = 'B049'
        integer FrostnovaTF3_BuffID = 'B04A'
        integer FrostnovaTF4_BuffID = 'B04B'
        integer FrostnovaTF5_BuffID = 'B04C'
        private integer array FrostnovaFBuff
        integer FrostnovaF_MaxStacks = 5
        integer FrostnovaF_RequiredLevel = 12
        real FrostnovaF_Duration = 4.0
        real FrostnovaTF_Duration = 5.0
        real FrostnovaTF_DamageInt = 0.12
        real FrostnovaTF_DamageBonus35 = 0.12 // Flat INT multiplier per tick, not per stack.
        real FrostnovaF_ApplyGrace = 0.15 // Native Slow order may resolve after Apply returns.

        // ==================== G: no ability assigned ====================
    endglobals

    function FrostnovaQRange takes unit hero, integer level returns real
        local real distance = FrostnovaQ_Range + FrostnovaQ_RangeStep*(IMaxBJ(1, level)-1)
        if GetHeroLevel(hero) >= 35 then
            set distance = distance + FrostnovaQ_RangeBonus35
        endif
        return distance
    endfunction

    function FrostnovaWRange takes unit hero returns real
        if GetHeroLevel(hero) >= 35 then
            return FrostnovaW_Range + FrostnovaW_RangeBonus35
        endif
        return FrostnovaW_Range
    endfunction

    // Q7 plays at 90% of MakeSound's volume.
    private function FrostnovaQ7Sound takes nothing returns nothing
        if BankaiActive then
            call GearSoundPlay(FrostnovaSoundPath + "Q7.mp3", 36, false, null)
        else
            call GearSoundPlay(FrostnovaSoundPath + "Q7.mp3", 114, false, null)
        endif
    endfunction

    /*
    1 - q
    3 - e
    4 - r
    6 - t
    */
    // A dead hero can read life above 0.405 (a heal landing after death), so
    // SpellBoolCaster alone kept Q charges orbiting her corpse until revive.
    private function FrostnovaAlive takes unit hero returns boolean
        return SpellBoolCaster(hero) and not IsUnitType(hero, UNIT_TYPE_DEAD)
    endfunction

    // ==================== COMMON: Q charges and shared mode flag ====================
    private struct FrostnovaState
        static integer array active
        static integer count = 0
        unit hero
        integer qLevel
        real qCastDelay
        integer previousQCharges
        real winterRemaining
        boolean ticking
        real orbitTime
        real voiceRemaining
        real voiceDuration
        real shieldRemaining
        integer nextNormalVoice
        integer nextVoice
        boolean enhancedShards
        boolean rangeBonus

        method Activate takes nothing returns nothing
            if not ticking then
                set ticking = true
                set active[count] = this
                set count = count + 1
                call GearTimer03Acquire()
            endif
        endmethod

        method RefreshShield takes nothing returns nothing
            // Rare cast: the shared one-shot buff caster in gg_rct_Caster; a recast renews the native 4 sec buff.
            call BuffUnit01(hero, hero, FrostnovaT_ShieldAbilityID, "frostarmor", 1)
            set shieldRemaining = FrostnovaT_ShieldDuration
            call Activate()
        endmethod

        method SetIcons takes boolean enhanced returns nothing
            local integer level = 0
            local string prefix = "ReplaceableTextures\\CommandButtons\\BTNHero_Frostnova_"
            if enhanced then
                set prefix = prefix + "T"
            endif
            // Per-unit art avoids changing a second Frostnova's normal icons.
            loop
                exitwhen level >= 5
                call BlzSetAbilityStringLevelField(BlzGetUnitAbility(hero, FrostnovaQ_ID), ABILITY_SLF_ICON_NORMAL, level, prefix + "Q.blp")
                call BlzSetAbilityStringLevelField(BlzGetUnitAbility(hero, FrostnovaW_ID), ABILITY_SLF_ICON_NORMAL, level, prefix + "W.blp")
                call BlzSetAbilityStringLevelField(BlzGetUnitAbility(hero, FrostnovaE_ID), ABILITY_SLF_ICON_NORMAL, level, prefix + "E.blp")
                call BlzSetAbilityStringLevelField(BlzGetUnitAbility(hero, FrostnovaR_ID), ABILITY_SLF_ICON_NORMAL, level, prefix + "R.blp")
                set level = level + 1
            endloop
        endmethod

        // Only a Q/W/E/R cast can start a line. Casts during speech are skipped.
        method Voice takes boolean onCast returns nothing
            local real duration = 4.05
            if not onCast or winterRemaining <= 0.0 or voiceRemaining > 0.0001 then
                return
            endif
            if nextVoice == 3 then
                set duration = 4.677
            elseif nextVoice == 4 then
                set duration = 5.252
            endif
            call MakeSound(FrostnovaSoundPath + "T" + I2S(nextVoice))
            call this.RefreshShield()
            set nextVoice = nextVoice + 1
            if nextVoice > 4 then
                set nextVoice = 2
            endif
            set voiceRemaining = duration + 0.03
            set voiceDuration = voiceRemaining
        endmethod



        // Six slots are the Q charges themselves. Only effect alpha is local.
        method UpdateShards takes nothing returns nothing
            local integer index = 0
            local integer row
            local real side
            local real orbitAngle
            local real orientationAngle = GetUnitFacing(hero) * bj_DEGTORAD
            local real positionX
            local real positionY
            local real z
            local integer alpha = 255
            local effect shardEffect
            local effect shadow
            set enhancedShards = winterRemaining > 0.0
            // Use the actual viewer: a neutral player's vision must not hide
            // the charges from a player who can see the hero.
            if IsUnitInvisible(hero, GetLocalPlayer()) or not IsUnitVisible(hero, GetLocalPlayer()) then
                set alpha = 0
            endif
            loop
                exitwhen index >= 6
                set shardEffect = LoadEffectHandle(FrostnovaTable, GetHandleId(hero), 100+index)
                if index < SpellStacksGet(hero) and FrostnovaAlive(hero) and GetUnitTypeId(hero) != 0 then
                    set row = R2I(I2R(index) / 2.0)
                    set side = 1.0
                    if ModuloInteger(index, 2) == 0 then
                        set side = -1.0
                    endif
                    set orbitAngle = orientationAngle + orbitTime*FrostnovaQ_OrbitSpeed + row*bj_PI/3.0 + side*bj_PI/2.0
                    set positionX = GetUnitX(hero) + (FrostnovaQ_OrbitSide+row*FrostnovaQ_OrbitRowSide)*Cos(orbitAngle)
                    set positionY = GetUnitY(hero) + (FrostnovaQ_OrbitSide+row*FrostnovaQ_OrbitRowSide)*Sin(orbitAngle)
                    set z = BlzGetUnitZ(hero) + FrostnovaQ_OrbitHeight + index*FrostnovaQ_OrbitLayerHeight + Sin(orbitTime*1.7+index)*FrostnovaQ_OrbitSway
                    if shardEffect == null then
                        set shardEffect = AddSpecialEffect(FrostnovaQ_Model, positionX, positionY)
                        call SaveEffectHandle(FrostnovaTable, GetHandleId(hero), 100+index, shardEffect)
                        call BlzSetSpecialEffectScale(shardEffect, FrostnovaQ_ModelScale/FrostnovaQ_OrbitScaleDivisor)
                        call BlzPlaySpecialEffect(shardEffect, ANIM_TYPE_STAND)
                    endif
                    call BlzSetSpecialEffectPosition(shardEffect, positionX, positionY, z)
                    call BlzSetSpecialEffectYaw(shardEffect, orbitAngle+bj_PI/2.0)
                    call BlzSetSpecialEffectAlpha(shardEffect, alpha)
                elseif shardEffect != null then
                    call DestroyEffect(shardEffect)
                    call RemoveSavedHandle(FrostnovaTable, GetHandleId(hero), 100+index)
                endif
                set shadow = LoadEffectHandle(FrostnovaTable, GetHandleId(hero), 200+index)
                if enhancedShards and index < SpellStacksGet(hero) and FrostnovaAlive(hero) and GetUnitTypeId(hero) != 0 then
                    if shadow == null then
                        set shadow = AddSpecialEffect(FrostnovaTQ_ShadowModel, positionX, positionY)
                        call SaveEffectHandle(FrostnovaTable, GetHandleId(hero), 200+index, shadow)
                        call BlzSetSpecialEffectScale(shadow, FrostnovaQ_ModelScale*FrostnovaTQ_ParticleScale/FrostnovaQ_OrbitScaleDivisor)
                        call BlzPlaySpecialEffect(shadow, ANIM_TYPE_STAND)
                    endif
                    call BlzSetSpecialEffectPosition(shadow, positionX-35.0*Cos(orbitAngle+bj_PI/2.0), positionY-35.0*Sin(orbitAngle+bj_PI/2.0), z-10.0)
                    call BlzSetSpecialEffectYaw(shadow, orbitAngle+bj_PI/2.0)
                    call BlzSetSpecialEffectAlpha(shadow, alpha*FrostnovaTQ_ParticleAlpha/255)
                elseif shadow != null then
                    call DestroyEffect(shadow)
                    call RemoveSavedHandle(FrostnovaTable, GetHandleId(hero), 200+index)
                endif
                set index = index + 1
            endloop
            set shadow = null
            set shardEffect = null
        endmethod

        method RefreshRange takes nothing returns nothing
            local integer level = 0
            local boolean enhancedRange = GetHeroLevel(hero) >= 35
            if rangeBonus == enhancedRange then
                return
            endif
            set rangeBonus = enhancedRange
            loop
                exitwhen level == 5
                call BlzSetAbilityRealLevelField(BlzGetUnitAbility(hero, FrostnovaQ_ID), ABILITY_RLF_CAST_RANGE, level, FrostnovaQRange(hero, level+1))
                call BlzSetAbilityRealLevelField(BlzGetUnitAbility(hero, FrostnovaW_ID), ABILITY_RLF_CAST_RANGE, level, FrostnovaWRange(hero))
                set level = level + 1
            endloop
        endmethod

        method RefreshCharges takes nothing returns nothing
            local integer level = GetUnitAbilityLevel(hero, FrostnovaQ_ID)
            local integer maximum = IMinBJ(6, 2 + 2 * ((IMaxBJ(1, level) - 1) / 2))
            local integer oldMaximum = SpellStacksGetMax(hero)
            set qLevel = level
            // Same tracker and native cooldown scheduling as TojiE.
            call SpellStacksStart(hero, FrostnovaQ_ID, 0, maximum, FrostnovaQ_Recharge + FrostnovaQ_RechargeStep*(IMaxBJ(1, level)-1))
            if oldMaximum > 0 and maximum > oldMaximum then
                call SpellStacksAdd(hero, maximum-oldMaximum)
            endif
            call UpdateShards()
            call Activate()
        endmethod

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            loop
                exitwhen index >= count
                set this = active[index]
                if GetUnitTypeId(hero) != 0 and GetUnitAbilityLevel(hero, FrostnovaQ_ID) != qLevel then
                    call RefreshCharges()
                endif
                if GetUnitTypeId(hero) != 0 and rangeBonus != (GetHeroLevel(hero) >= 35) then
                    call RefreshRange()
                endif
                set qCastDelay = RMaxBJ(0.0, qCastDelay - 0.03)
                set orbitTime = orbitTime + 0.03
                set voiceRemaining = RMaxBJ(0.0, voiceRemaining - 0.03)
                if shieldRemaining > 0.0 then
                    if not IsUnitPaused(hero) then
                        set shieldRemaining = RMaxBJ(0.0, shieldRemaining - 0.03)
                    endif
                    if shieldRemaining <= 0.0001 or GetWidgetLife(hero) <= 0.405 then
                        set shieldRemaining = 0.0
                        call UnitRemoveAbility(hero, FrostnovaT_ShieldBuffID)
                    endif
                endif
                if not FrostnovaAlive(hero) or GetUnitTypeId(hero) == 0 then
                    set winterRemaining = 0.0
                endif
                // Any recovered charge, including an early grant, makes Q ready.
                if SpellStacksGet(hero) > previousQCharges then
                    set qCastDelay = 0.0
                endif
                // A delayed spell callback may reapply cooldown after the charge UI.
                // Retain the shared between-throw pause, but never a refill cooldown.
                if SpellStacksGet(hero) > 0 and qCastDelay <= 0.0001 and BlzGetUnitAbilityCooldownRemaining(hero, FrostnovaQ_ID) > 0.0 then
                    call BlzEndUnitAbilityCooldown(hero, FrostnovaQ_ID)
                endif
                set previousQCharges = SpellStacksGet(hero)
                call UpdateShards()
                if GetUnitTypeId(hero) == 0 then
                    set ticking = false
                    set count = count - 1
                    set active[index] = active[count]
                    call GearTimer03Release()
                    call SpellStacksStop(hero)
                    call RemoveSavedInteger(FrostnovaTable, GetHandleId(hero), 0)
                    set hero = null
                    call deallocate()
                else
                    set index = index + 1
                endif
            endloop
        endmethod
    endstruct
    // Clamp the displacement ray to every Icefield that currently contains u.
    private function FrostnovaIcefieldPush takes unit target, real remainingDistance, real angle returns real
        local integer index = 0
        local integer field
        local real dx
        local real dy
        local real projection
        local real perpendicular
        local real radius
        loop
            exitwhen index >= FrostnovaIcefieldCount
            set field = FrostnovaIcefields[index]
            set dx = GetUnitX(target)-FrostnovaIcefieldX[field]
            set dy = GetUnitY(target)-FrostnovaIcefieldY[field]
            set radius = FrostnovaIcefieldRadius[field]
            if dx*dx+dy*dy <= radius*radius then
                set projection = dx*Cos(angle)+dy*Sin(angle)
                set perpendicular = dx*Sin(angle)-dy*Cos(angle)
                set remainingDistance = RMinBJ(remainingDistance, RMaxBJ(0.0, SquareRoot(RMaxBJ(0.0, radius*radius-perpendicular*perpendicular))-projection-16.0))
            endif
            set index = index + 1
        endloop
        return remainingDistance
    endfunction

    // ==================== F: Yeti Princess (shared debuff) ====================
    private struct FrostnovaF_KS
        static integer array active
        static integer count = 0
        unit hero
        unit target
        integer stacks
        integer buffId
        real remainingTime
        real damageCountdown
        real applyRemaining
        real damage
        boolean empowered

        static method StacksOn takes unit target returns integer
            local thistype this = LoadInteger(FrostnovaTable, GetHandleId(target), 1)
            if this == 0 or (GetUnitAbilityLevel(target, buffId) == 0 and applyRemaining <= 0.0001) then
                return 0
            endif
            return stacks
        endmethod

        static method ClearOldBuffs takes unit target, integer currentBuff returns nothing
            local integer level = 1
            loop
                exitwhen level > 10
                if FrostnovaFBuff[level] != currentBuff and GetUnitAbilityLevel(target, FrostnovaFBuff[level]) > 0 then
                    call UnitRemoveAbility(target, FrostnovaFBuff[level])
                endif
                set level = level + 1
            endloop
        endmethod

        static method Apply takes unit caster, unit target, boolean enhanced returns nothing
            local thistype this = LoadInteger(FrostnovaTable, GetHandleId(target), 1)
            local unit dummy
            local integer abilityLevel
            local integer nativeStacks = 0
            local integer nativeLevel
            local boolean nativeEnhanced = false
            if GetHeroLevel(caster) < FrostnovaF_RequiredLevel or not IsUnitEnemy(target, GetOwningPlayer(caster)) or not SpellBool(target) or IsUnitType(target, UNIT_TYPE_STRUCTURE) or IsUnitType(target, UNIT_TYPE_MAGIC_IMMUNE) then
                return
            endif
            if DebuffImmune_Start(target, 1) == 0 then
                return
            endif
            // Recover the visible count before replacing every older F/TF tier.
            set abilityLevel = 1
            loop
                exitwhen abilityLevel > 10
                if GetUnitAbilityLevel(target, FrostnovaFBuff[abilityLevel]) > 0 then
                    set nativeLevel = abilityLevel
                    if nativeLevel > 5 then
                        set nativeLevel = nativeLevel - 5
                        set nativeEnhanced = true
                    endif
                    set nativeStacks = IMaxBJ(nativeStacks, nativeLevel)
                endif
                set abilityLevel = abilityLevel + 1
            endloop
            if this == 0 then
                set this = allocate()
                set this.target = target
                set stacks = nativeStacks
                set empowered = nativeEnhanced
                set buffId = 0
                set damageCountdown = 1.0
                set active[count] = this
                set count = count + 1
                call SaveInteger(FrostnovaTable, GetHandleId(target), 1, this)
                call GearTimer03Acquire()
            elseif nativeStacks > 0 then
                set stacks = IMaxBJ(stacks, nativeStacks)
                set empowered = empowered or nativeEnhanced
            elseif applyRemaining <= 0.0001 then
                set stacks = 0
                set empowered = false
                set damageCountdown = 1.0
            endif
            set hero = caster
            set stacks = IMinBJ(FrostnovaF_MaxStacks, stacks + 1)
            set empowered = empowered or enhanced
            if empowered then
                set abilityLevel = stacks + 5
                set buffId = FrostnovaFBuff[abilityLevel]
                set remainingTime = FrostnovaTF_Duration
            else
                set abilityLevel = stacks
                set buffId = FrostnovaFBuff[abilityLevel]
                set remainingTime = FrostnovaF_Duration
            endif
            set applyRemaining = FrostnovaF_ApplyGrace
            call VisionTimed(GetOwningPlayer(caster), GetUnitX(target), GetUnitY(target), FrostnovaQ_Aoe*2.0, 1.0)
            set damage = I2R(GetHeroInt(caster, true)) * FrostnovaTF_DamageInt
            // Dedicated caster: never put two Slow abilities on DummyPlayer.
            // Offensive orders use Frostnova's owner, not the victim's owner.
            set dummy = FrostnovaDummy[GetPlayerId(GetOwningPlayer(caster))]
            if dummy == null or GetWidgetLife(dummy) <= 0.405 then
                set dummy = CreateUnit(GetOwningPlayer(caster), 'h0C9', GetUnitX(target), GetUnitY(target), 0.0)
                set FrostnovaDummy[GetPlayerId(GetOwningPlayer(caster))] = dummy
            endif
            call UnitAddAbility(dummy, FrostnovaF_DebuffID)
            call IssueImmediateOrder(dummy, "slowoff")
            call SetUnitAbilityLevel(dummy, FrostnovaF_DebuffID, abilityLevel)
            call BlzEndUnitAbilityCooldown(dummy, FrostnovaF_DebuffID)
            call IssueTargetOrder(dummy, "slow", target)
            if GetUnitAbilityLevel(target, buffId) > 0 then
                call ClearOldBuffs(target, buffId)
                set applyRemaining = 0.0
            endif
            set dummy = null
        endmethod

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            local real pulseDamage
            loop
                exitwhen index >= count
                set this = active[index]
                set applyRemaining = RMaxBJ(0.0, applyRemaining - 0.03)
                if applyRemaining > 0.0 and GetUnitAbilityLevel(target, buffId) > 0 then
                    call ClearOldBuffs(target, buffId)
                    set applyRemaining = 0.0
                endif
                set remainingTime = remainingTime - 0.03
                set damageCountdown = damageCountdown - 0.03
                // The last second ends inside this 0.03 step when the duration is not a
                // multiple of it (4 / 5 sec): still pay that final tick.
                if damageCountdown <= 0.0001 and remainingTime > -0.0299 and GetUnitTypeId(hero) != 0 and SpellBoolCaster(target) and GetUnitAbilityLevel(target, buffId) > 0 then
                    set damageCountdown = damageCountdown + 1.0
                    if (empowered or GetHeroLevel(hero) >= 35) and SpellBool(target) then
                        set pulseDamage = damage * stacks
                        if empowered and GetHeroLevel(hero) >= 35 then
                            set pulseDamage = pulseDamage + GetHeroInt(hero, true)*FrostnovaTF_DamageBonus35
                        endif
                        call DamageSource(FrostnovaF_ID)
                        call dmgmag(hero, target, pulseDamage)
                    endif
                endif
                if GetUnitTypeId(target) == 0 or not SpellBoolCaster(target) or GetUnitTypeId(hero) == 0 or remainingTime <= 0.0001 or (GetUnitAbilityLevel(target, buffId) == 0 and applyRemaining <= 0.0001) then
                    call UnitRemoveAbility(target, buffId)
                    call RemoveSavedInteger(FrostnovaTable, GetHandleId(target), 1)
                    set hero = null
                    set target = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set index = index + 1
                endif
            endloop
        endmethod
    endstruct
    // ==================== Q: Ice Javelins ====================
    private struct FrostnovaQ_KS
        static integer array active
        static integer count = 0
        unit hero
        real positionX
        real positionY
        real angle
        real remainingDistance
        real distancePerTick
        real radius
        real environmentCountdown
        real height
        real startHeight
        real flightTime
        real originZ
        real damage
        boolean enhanced
        group targets
        group hit
        effect mainEffect
        effect trail
        effect shadow

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            local unit target
            local effect impact
            local unit firstTarget
            local real best
            local real d
            local real step
            loop
                exitwhen index >= count
                set this = active[index]
                // A dead or removed caster ends her javelins in place: no flight, hit or damage.
                if GetUnitTypeId(hero) == 0 or not FrostnovaAlive(hero) then
                    set remainingDistance = 0.0
                else
                    set step = RMinBJ(distancePerTick, remainingDistance)
                    if not PathableCheck(positionX+step*Cos(angle), positionY+step*Sin(angle)) then
                        set step = 0.0
                        set remainingDistance = 0.0
                    endif
                    call MoveEff2(mainEffect, step, angle)
                    call MoveEff2(trail, step, angle)
                    if shadow != null then
                        call MoveEff2(shadow, step, angle)
                    endif
                    set positionX = GetEffX(mainEffect)
                    set positionY = GetEffY(mainEffect)
                    set remainingDistance = remainingDistance - step
                    set flightTime = flightTime + 0.03
                    set height = startHeight + (FrostnovaQ_FlightHeight-startHeight)*RMinBJ(1.0, flightTime/FrostnovaQ_DescendTime)
                    call BlzSetSpecialEffectZ(mainEffect, originZ + height)
                    if shadow != null then
                        call BlzSetSpecialEffectZ(shadow, originZ+height-10.0)
                    endif
                    call BlzSetSpecialEffectZ(trail, originZ + height + FrostnovaQ_TrailHeightOffset)
                    set firstTarget = null
                    set best = 99999999.0
                    call GroupEnumUnitsInRange(targets, positionX, positionY, radius, null)
                    loop
                        set target = FirstOfGroup(targets)
                        exitwhen target == null
                        call GroupRemoveUnit(targets, target)
                        if IsUnitEnemy(target, GetOwningPlayer(hero)) and SpellBool(target) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) and not IsUnitInGroup(target, hit) then
                            if enhanced then
                                call GroupAddUnit(hit, target)
                                call FrostnovaQ7Sound()
                                call FrostnovaF_KS.Apply(hero, target, true)
                                call StunUnit(hero, target, FrostnovaQ_Stun)
                                call DamageSource(FrostnovaQ_ID)
                                call dmgmag(hero, target, damage)
                                // Keep the requested half-size hit in world space;
                                // never scale an effect attached to a unit.
                                set impact = AddSpecialEffect(FrostnovaTQ_ImpactModel, GetUnitX(target), GetUnitY(target))
                                call BlzSetSpecialEffectZ(impact, BlzGetUnitZ(target)+80.0)
                                call BlzSetSpecialEffectScale(impact, FrostnovaTQ_ImpactScale)
                                call DestroyEffect(impact)
                            else
                            set d = (GetUnitX(target)-positionX)*Cos(angle) + (GetUnitY(target)-positionY)*Sin(angle)
                            if d < best then
                                set best = d
                                set firstTarget = target
                            endif
                            endif
                        endif
                    endloop
                    set environmentCountdown = environmentCountdown - 0.03
                    if environmentCountdown <= 0.0001 or firstTarget != null or remainingDistance <= 0.0 then
                        set environmentCountdown = 0.12
                        call VisionTimed(GetOwningPlayer(hero), positionX, positionY, radius*2.0, 1.0)
                        call DecorRemove(hero, positionX, positionY, radius, FrostnovaQ_DecorDamage)
                    endif
                    if firstTarget != null then
                        call FrostnovaQ7Sound()
                        call FrostnovaF_KS.Apply(hero, firstTarget, enhanced)
                        call StunUnit(hero, firstTarget, FrostnovaQ_Stun)
                        call DamageSource(FrostnovaQ_ID)
                        call dmgmag(hero, firstTarget, damage)
                        // Play the full hit animation in world space; do not inherit the hero's attachment scale.
                        set impact = AddSpecialEffect(FrostnovaQ_ImpactModel, GetUnitX(firstTarget), GetUnitY(firstTarget))
                        call BlzSetSpecialEffectZ(impact, BlzGetUnitZ(firstTarget)+80.0)
                        call MyRemoveEff(impact, 1.0)
                        set remainingDistance = 0.0
                    endif
                endif
                if remainingDistance <= 0.0 or GetUnitTypeId(hero) == 0 then
                    call DestroyEffect(mainEffect)
                    if shadow != null then
                        call DestroyEffect(shadow)
                        set shadow = null
                    endif
                    call DestroyEffect(trail)
                    call DestroyGroup(hit)
                    set hit = null
                    call DestroyGroup(targets)
                    set mainEffect = null
                    set trail = null
                    set targets = null
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set index = index + 1
                endif
            endloop
            set target = null
            set firstTarget = null
            set impact = null
        endmethod

        static method Start takes unit caster, real targetX, real targetY returns boolean
            local FrostnovaState state = LoadInteger(FrostnovaTable, GetHandleId(caster), 0)
            local thistype this
            local integer slot
            local integer row
            local real side = 1.0
            local real orientationAngle
            local real orbitAngle
            local effect shard
            if state == 0 then
                return false
            endif
            call state.UpdateShards()
            set slot = SpellStacksGet(caster) - 1
            if not SpellStacksTryUse(caster) then
                call MyAddMana(caster, I2R(BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(caster, FrostnovaQ_ID), ABILITY_ILF_MANA_COST, GetUnitAbilityLevel(caster, FrostnovaQ_ID)-1)), 0.03)
                return false
            endif
            set state.qCastDelay = KS_SpellStacks.STACK_USE_COOLDOWN + 0.03
            set state.previousQCharges = SpellStacksGet(caster)
            // Seed the empty-pool cooldown before the shared 0.05 tick can
            // mistake the engine's pending cooldown write for a free charge.
            // The shared deferred callback restores the exact recharge remainder.
            if state.previousQCharges == 0 then
                call BlzStartUnitAbilityCooldown(caster, FrostnovaQ_ID, FrostnovaQ_Recharge + FrostnovaQ_RechargeStep*(GetUnitAbilityLevel(caster, FrostnovaQ_ID)-1))
            endif
            set shard = LoadEffectHandle(FrostnovaTable, GetHandleId(caster), 100+slot)
            call RemoveSavedHandle(FrostnovaTable, GetHandleId(caster), 100+slot)
            set this = allocate()
            set hero = caster
            set row = R2I(I2R(slot) / 2.0)
            if ModuloInteger(slot, 2) == 0 then
                set side = -1.0
            endif
            set orientationAngle = GetUnitFacing(hero)*bj_DEGTORAD
            set orbitAngle = orientationAngle + state.orbitTime*FrostnovaQ_OrbitSpeed + row*bj_PI/3.0 + side*bj_PI/2.0
            set positionX = GetUnitX(hero) + (FrostnovaQ_OrbitSide+row*FrostnovaQ_OrbitRowSide)*Cos(orbitAngle)
            set positionY = GetUnitY(hero) + (FrostnovaQ_OrbitSide+row*FrostnovaQ_OrbitRowSide)*Sin(orbitAngle)
            set height = FrostnovaQ_OrbitHeight + slot*FrostnovaQ_OrbitLayerHeight + Sin(state.orbitTime*1.7+slot)*FrostnovaQ_OrbitSway
            set startHeight = height
            set flightTime = 0.0
            set originZ = BlzGetUnitZ(hero)
            set angle = Atan2(targetY-positionY, targetX-positionX)
            set damage = FrostnovaQ_DamageStatic + GetHeroInt(hero, true) * (FrostnovaQ_DamageIntBase + FrostnovaQ_DamageIntStep * (GetUnitAbilityLevel(hero, FrostnovaQ_ID)-1))
            set enhanced = state.winterRemaining > 0.0
            if enhanced then
                call state.Voice(true)
            else
                set state.nextNormalVoice = ModuloInteger(state.nextNormalVoice, 5) + 1
                call MakeSound(FrostnovaSoundPath + "Q" + I2S(state.nextNormalVoice))
            endif

            call MakeSoundVolume(FrostnovaSoundPath + "Q6", 114)
            set remainingDistance = FrostnovaQRange(hero, GetUnitAbilityLevel(hero, FrostnovaQ_ID))
            set distancePerTick = FrostnovaQ_Speed * 0.03
            if enhanced then
                set distancePerTick = distancePerTick*FrostnovaTQ_SpeedMultiplier
            endif
            set radius = FrostnovaQ_Aoe
            set environmentCountdown = 0.0
            set targets = CreateGroup()
            set hit = CreateGroup()
            set shadow = LoadEffectHandle(FrostnovaTable, GetHandleId(caster), 200+slot)
            call RemoveSavedHandle(FrostnovaTable, GetHandleId(caster), 200+slot)
            if enhanced and shard != null then
                call DestroyEffect(shard)
                set shard = null
            endif
            set mainEffect = shard
            set shard = null
            if mainEffect == null then
                if enhanced then
                    set mainEffect = AddSpecialEffect(FrostnovaTQ_Model, positionX, positionY)
                else
                    set mainEffect = AddSpecialEffect(FrostnovaQ_Model, positionX, positionY)
                endif
                call BlzPlaySpecialEffect(mainEffect, ANIM_TYPE_STAND)
            endif
            call SetAnimIndex(hero,0.01,1)
            if enhanced and shadow == null then
                set shadow = AddSpecialEffect(FrostnovaTQ_ShadowModel, positionX, positionY)
                call BlzPlaySpecialEffect(shadow, ANIM_TYPE_STAND)
            endif
            if shadow != null then
                call ScaleEffDummy(shadow, FrostnovaQ_GrowTime, FrostnovaQ_ModelScale*FrostnovaTQ_ParticleScale/FrostnovaQ_OrbitScaleDivisor, FrostnovaQ_ModelScale*FrostnovaTQ_ParticleScale)
                call BlzSetSpecialEffectAlpha(shadow, FrostnovaTQ_ParticleAlpha)
                call BlzSetSpecialEffectPosition(shadow, positionX-55.0*Cos(angle), positionY-55.0*Sin(angle), originZ+height-10.0)
                call BlzSetSpecialEffectYaw(shadow, angle)
            endif
            call ScaleEffDummy(mainEffect, FrostnovaQ_GrowTime, FrostnovaQ_ModelScale/FrostnovaQ_OrbitScaleDivisor, FrostnovaQ_ModelScale)
            call BlzSetSpecialEffectAlpha(mainEffect, 255)
            set trail = AddSpecialEffect(FrostnovaQ_TrailModel, positionX, positionY)
            call BlzSetSpecialEffectScale(trail, FrostnovaQ_TrailScale)
            call BlzSetSpecialEffectPosition(trail, positionX, positionY, originZ + height + FrostnovaQ_TrailHeightOffset)
            call BlzSetSpecialEffectYaw(trail, angle)
            call state.UpdateShards()
            call BlzSetSpecialEffectZ(mainEffect, originZ + height)
            call BlzSetSpecialEffectYaw(mainEffect, angle)
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
            return true
        endmethod
    endstruct
    // ==================== W: Northern Winds ====================
    private struct FrostnovaW_KS
        static integer array active
        static integer count = 0
        unit hero
        real positionX
        real positionY
        real angle
        real remainingDistance
        real maxDistance
        real distancePerTick
        real push
        real damage
        real preparationRemaining
        real radius
        real environmentCountdown
        boolean paused
        boolean ownsInvulnerability
        boolean voiced
        effect hand
        boolean enhanced
        group targets
        group hit
        effect mainEffect
        effect trail

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            local boolean blocked
            local unit target
            local real visualRadius
            local real progress
            local real step
            loop
                exitwhen index >= count
                set this = active[index]
                set blocked = false
                if preparationRemaining > 0.0 then
                    set preparationRemaining = RMaxBJ(0.0, preparationRemaining - 0.03)
                    if not FrostnovaAlive(hero) or GetUnitTypeId(hero) == 0 then
                        set preparationRemaining = 0.0
                        set remainingDistance = 0.0
                    elseif preparationRemaining <= 0.0001 then
                        set preparationRemaining = 0.0
                        set positionX = GetUnitX(hero)
                        set positionY = GetUnitY(hero)
                        set mainEffect = AddSpecialEffect(FrostnovaW_Model, positionX, positionY)
                        set trail = AddSpecialEffect(FrostnovaW_AirModel, positionX, positionY)
                        call BlzSetSpecialEffectYaw(mainEffect, angle)
                        call BlzSetSpecialEffectYaw(trail, angle)
                        if voiced then
                            call MakeSound(FrostnovaSoundPath + "W3")
                        endif
                    endif
                    if preparationRemaining <= 0.0001 and paused then
                        if ownsInvulnerability then
                            call StopSpellUnit(hero)
                            set ownsInvulnerability = false
                        else
                            call StopSpellUnit2(hero)
                        endif
                        set paused = false
                        call DestroyEffect(hand)
                        set hand = null
                    endif
                endif
                if preparationRemaining <= 0.0001 and remainingDistance > 0.0 then
                    set step = RMinBJ(distancePerTick, remainingDistance)
                    if not PathableCheck(positionX+step*Cos(angle), positionY+step*Sin(angle)) then
                        set step = 0.0
                        set blocked = true
                    endif
                    call MoveEff2(mainEffect, step, angle)
                    call MoveEff2(trail, step, angle)
                    set positionX = GetEffX(mainEffect)
                    set positionY = GetEffY(mainEffect)
                    set remainingDistance = remainingDistance - step
                    call BlzSetSpecialEffectZ(mainEffect, BlzGetUnitZ(hero) + 80.0)
                    call BlzSetSpecialEffectZ(trail, BlzGetUnitZ(hero) + 80.0)
                    set progress = 1.0 - remainingDistance/maxDistance

                    set radius = FrostnovaW_StartAoe + (FrostnovaW_Aoe-FrostnovaW_StartAoe)*progress
                    set visualRadius = radius

                    if enhanced then
                        set radius = RMaxBJ(radius, FrostnovaW_StartAoe+(maxDistance-remainingDistance)*Sin(FrostnovaTW_Angle*bj_DEGTORAD/2.0))

                        set visualRadius = visualRadius + (radius-visualRadius)*progress*progress
                    endif
                    if enhanced then
                    set visualRadius = visualRadius * (1.0 - 0.5 * (1.0 - remainingDistance / maxDistance))
                    endif
                    call BlzSetSpecialEffectScale(mainEffect, FrostnovaW_ModelScale*visualRadius/FrostnovaW_Aoe)
                    call BlzSetSpecialEffectScale(trail, FrostnovaW_AirScale*visualRadius/FrostnovaW_Aoe)
                    set environmentCountdown = environmentCountdown - 0.03
                    if environmentCountdown <= 0.0001 or remainingDistance <= 0.0 then
                        set environmentCountdown = 0.12
                        call VisionTimed(GetOwningPlayer(hero), positionX, positionY, radius*2.0, 1.0)
                        call DecorRemove(hero, positionX, positionY, radius, FrostnovaW_DecorDamage)
                    endif
                    call GroupEnumUnitsInRange(targets, positionX, positionY, radius, null)
                    loop
                        set target = FirstOfGroup(targets)
                        exitwhen target == null
                        call GroupRemoveUnit(targets, target)
                        if IsUnitEnemy(target, GetOwningPlayer(hero)) and SpellBool(target) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) and not IsUnitInGroup(target, hit) then
                            call GroupAddUnit(hit, target)
                            call FrostnovaF_KS.Apply(hero, target, enhanced)
                            call MUE(target, FrostnovaIcefieldPush(target, push*(1.0-(1.0-FrostnovaW_PushFalloff)*RMinBJ(1.0, (maxDistance-remainingDistance)/maxDistance)), angle), 0.3, angle)
                            call DamageSource(FrostnovaW_ID)
                            call dmgmag(hero, target, damage)
                        endif
                    endloop
                endif
                if blocked or remainingDistance <= 0.0 or GetUnitTypeId(hero) == 0 then
                    call DestroyEffect(mainEffect)
                    call DestroyEffect(trail)
                    call DestroyGroup(targets)
                    call SaveInteger(FrostnovaTable, GetHandleId(hit), 0, LoadInteger(FrostnovaTable, GetHandleId(hit), 0)-1)
                    if LoadInteger(FrostnovaTable, GetHandleId(hit), 0) == 0 then
                        call FlushChildHashtable(FrostnovaTable, GetHandleId(hit))
                        call DestroyGroup(hit)
                    endif
                    set mainEffect = null
                    set trail = null
                    set targets = null
                    set hit = null
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set index = index + 1
                endif
            endloop
            set target = null
        endmethod

        static method Start takes unit caster, real targetX, real targetY returns nothing
            local FrostnovaState state = LoadInteger(FrostnovaTable, GetHandleId(caster), 0)
            local thistype this
            local integer k = 0
            local integer maximum = 0
            local boolean hadInvulnerability = GetUnitAbilityLevel(caster, 'Avul') > 0
            local group sharedHit = CreateGroup()
            if state.winterRemaining > 0.0 then
                call state.Voice(true)
            else
                call MakeSound(FrostnovaSoundPath + "W")
            endif
            call MakeSound(FrostnovaSoundPath + "W2")
            if state.winterRemaining > 0.0 then
                call StartSpellUnit(caster)
            else
                call StartSpellUnit2(caster)
            endif
            if state.winterRemaining > 0.0 then
                set k = -1
                set maximum = 1
            endif
            call SaveInteger(FrostnovaTable, GetHandleId(sharedHit), 0, maximum-k+1)
            loop
                exitwhen k > maximum
                set this = allocate()
                set hero = caster
                set positionX = GetUnitX(hero)
                set positionY = GetUnitY(hero)
                set angle = Atan2(targetY-positionY, targetX-positionX) + k*FrostnovaTW_Angle*bj_DEGTORAD
                set enhanced = state.winterRemaining > 0.0
                set damage = FrostnovaW_DamageStatic + GetHeroInt(hero, true) * (FrostnovaW_DamageIntBase + FrostnovaW_DamageIntStep * (GetUnitAbilityLevel(hero, FrostnovaW_ID)-1))
                set maxDistance = FrostnovaWRange(hero)
                set remainingDistance = maxDistance
                set distancePerTick = FrostnovaW_Speed * 0.03
                if GetHeroLevel(hero) >= 25 then
                    set distancePerTick = distancePerTick * FrostnovaW_SpeedBonus25
                endif
                set push = FrostnovaW_Push

            call SetUnitAnimationByIndex(hero,1)
                if enhanced then
                    set push = FrostnovaTW_Push
                endif
                set environmentCountdown = 0.0
                set targets = CreateGroup()
                set hit = sharedHit
                set preparationRemaining = FrostnovaW_Preparation
                set radius = FrostnovaW_StartAoe
                set paused = k == 0
                set ownsInvulnerability = paused and enhanced and not hadInvulnerability
                set voiced = k == 0
                set mainEffect = null
                set trail = null
                set hand = null
                if paused then
                    set hand = AddSpecialEffectTarget("war3mapImported\\wos_Frostnova_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdx", hero, "hand left")

                endif
                set active[count] = this
                set count = count + 1
                call GearTimer03Acquire()
                set k = k + 1
            endloop
            set sharedHit = null
        endmethod
    endstruct
    // ==================== E: Frostnova ====================
    // One field per caster: recasting moves/refreshes it, never adds another loop.
    private struct FrostnovaE_KS
        static integer array active
        static integer count = 0
        unit hero
        real positionX
        real positionY
        real damage
        real remainingTime
        real damageCountdown
        real buffCountdown
        real invulnerabilityRemaining
        real burstCountdown
        real preparationRemaining
        boolean paused
        boolean enhanced
        boolean ownsInvulnerability
        group targets
        effect mainEffect
        effect fieldEffect
        effect aura
        effect area
        effect burst
        effect burst2

        method RefreshBuffs takes nothing returns nothing
            local unit target
            local unit dummy
            if FrostnovaAlive(hero) and (GetUnitX(hero)-positionX)*(GetUnitX(hero)-positionX)+(GetUnitY(hero)-positionY)*(GetUnitY(hero)-positionY) <= FrostnovaE_Aoe*FrostnovaE_Aoe then
                // Own one-shot caster: the shared dummy's Cripple/Slow orders below replaced this Inner Fire order.
                call BuffUnit01(hero, hero, FrostnovaE_ResistAbilityID, "innerfire", 1)
            endif
            call GroupEnumUnitsInRange(targets, positionX, positionY, FrostnovaE_Aoe, null)
            loop
                set target = FirstOfGroup(targets)
                exitwhen target == null
                call GroupRemoveUnit(targets, target)
                if IsUnitEnemy(target, GetOwningPlayer(hero)) and SpellBool(target) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) and not IsUnitType(target, UNIT_TYPE_MAGIC_IMMUNE) then
                    set dummy = FrostnovaDummy[GetPlayerId(GetOwningPlayer(hero))]
                    if dummy == null or GetWidgetLife(dummy) <= 0.405 then
                        set dummy = CreateUnit(GetOwningPlayer(hero), 'h0C9', GetUnitX(target), GetUnitY(target), 0.0)
                        set FrostnovaDummy[GetPlayerId(GetOwningPlayer(hero))] = dummy
                    endif
                    call UnitAddAbility(dummy, FrostnovaE_HealCutAbilityID)
                    call IssueTargetOrder(dummy, "cripple", target)
                endif
            endloop
            set dummy = null
            set target = null
        endmethod

        method Explode takes nothing returns nothing
            local unit target
            local integer k
            set positionX = GetUnitX(hero)
            set positionY = GetUnitY(hero)
            set mainEffect = AddSpecialEffect(FrostnovaE_Model, positionX, positionY)
            set fieldEffect = EffectSpawn("war3mapImported\\wos_az_snowflake01.mdx", positionX, positionY,1,1,4,1)
            call BlzSetSpecialEffectScale(mainEffect, FrostnovaE_ModelScale)
            if enhanced then
                set aura = AddSpecialEffectTarget(FrostnovaTE_Model, hero, "origin")
                set area = AddSpecialEffectTarget(FrostnovaTE_AreaModel, hero, "origin")
                call BlzPlaySpecialEffect(aura, ANIM_TYPE_STAND)
                call BlzPlaySpecialEffect(area, ANIM_TYPE_STAND)
            endif
            call MyFrameTimed(hero, remainingTime, "BTNHero_Frostnova_E", 2)
            if enhanced then
                call MyFrameTimed(hero, remainingTime, "BTNHero_Frostnova_TE", 3)
            endif
            call VisionTimed(GetOwningPlayer(hero), positionX, positionY, FrostnovaE_Aoe*1.5, remainingTime)
            call DecorRemove(hero, positionX, positionY, FrostnovaE_Aoe, FrostnovaE_DecorDamage)
            call RefreshBuffs()
            set buffCountdown = FrostnovaE_BuffPeriod
            call MakeSound(FrostnovaSoundPath + "E3")
            call MakeSound(FrostnovaSoundPath + "E4")
            call GroupEnumUnitsInRange(targets, positionX, positionY, FrostnovaE_Aoe, null)
            loop
                set target = FirstOfGroup(targets)
                exitwhen target == null
                call GroupRemoveUnit(targets, target)
                if IsUnitEnemy(target, GetOwningPlayer(hero)) and SpellBool(target) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) then
                    call FrostnovaF_KS.Apply(hero, target, enhanced)
                    call DamageSource(FrostnovaE_ID)
                    call dmgmag(hero, target, GetHeroInt(hero, true)*(FrostnovaE_BurstDamageIntBase+FrostnovaE_BurstDamageIntStep*(GetUnitAbilityLevel(hero, FrostnovaE_ID)-1)))
                    call MUE(target, FrostnovaE_Push, 0.3, Atan2(GetUnitY(target)-positionY, GetUnitX(target)-positionX))
                    if enhanced then
                        call StunUnit(hero, target, FrostnovaTE_Stun)
                    endif
                endif
            endloop
            if burst != null then
                call DestroyEffect(burst)
                call DestroyEffect(burst2)
            endif
            set k = 0
            loop
                exitwhen k >= 8
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_Frostnova_a (81).mdx", positionX+105.0*Cos(k*bj_PI/4.0), positionY+105.0*Sin(k*bj_PI/4.0), k*45.0, 1.25, FrostnovaE_SpikeScale, 0))
                set k = k + 1
            endloop
            set burst = AddSpecialEffect(FrostnovaQ_ImpactModel, positionX, positionY)
            set burstCountdown = FrostnovaE_BurstDuration
            set target = null
        endmethod

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            local unit target
            loop
                exitwhen index >= count
                set this = active[index]
                if preparationRemaining > 0.0 then
                    set preparationRemaining = RMaxBJ(0.0, preparationRemaining - 0.03)
                    if not FrostnovaAlive(hero) or GetUnitTypeId(hero) == 0 then
                        set preparationRemaining = 0.0
                        set remainingTime = 0.0
                    elseif preparationRemaining <= 0.0001 then
                        set preparationRemaining = 0.0
                        call Explode()
                    endif
                    if preparationRemaining <= 0.0001 and paused then
                        call StopSpellUnit2(hero)
                        set paused = false
                    endif
                else
                    set remainingTime = remainingTime - 0.03
                    set buffCountdown = buffCountdown - 0.03
                    if buffCountdown <= 0.0001 and remainingTime > 0.0 then
                        set buffCountdown = FrostnovaE_BuffPeriod
                        call RefreshBuffs()
                    endif
                    if aura != null and not FrostnovaAlive(hero) then
                        call DestroyEffect(aura)
                        call DestroyEffect(area)
                        set area = null
                        set aura = null
                        call MyFrameTimed(hero, 0.0, "BTNHero_Frostnova_TE", 3)
                    endif
                    set damageCountdown = damageCountdown - 0.03
                    set burstCountdown = burstCountdown - 0.03
                    if burst != null and burstCountdown <= 0.0001 then
                        // The Splat Stand loops every second; keep it only for the burst.

                        call DestroyEffect(burst)
                        set burst = null
                        call DestroyEffect(burst2)
                        set burst2 = null
                    endif
                    if damageCountdown <= 0.0001 and GetUnitTypeId(hero) != 0 then
                        set damageCountdown = damageCountdown + 1.0
                        call GroupEnumUnitsInRange(targets, positionX, positionY, FrostnovaE_Aoe, null)
                        loop
                            set target = FirstOfGroup(targets)
                            exitwhen target == null
                            call GroupRemoveUnit(targets, target)
                            if IsUnitEnemy(target, GetOwningPlayer(hero)) and SpellBool(target) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) then
                                call FrostnovaF_KS.Apply(hero, target, enhanced)
                                call DamageSource(FrostnovaE_ID)
                                call dmgmag(hero, target, damage)
                            endif
                        endloop
                        if enhanced and FrostnovaAlive(hero) then
                            call VisionTimed(GetOwningPlayer(hero), GetUnitX(hero), GetUnitY(hero), FrostnovaTE_Aoe*1.5, 1.1)
                            call GroupEnumUnitsInRange(targets, GetUnitX(hero), GetUnitY(hero), FrostnovaTE_Aoe, null)
                            loop
                                set target = FirstOfGroup(targets)
                                exitwhen target == null
                                call GroupRemoveUnit(targets, target)
                                if IsUnitEnemy(target, GetOwningPlayer(hero)) and SpellBool(target) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) then
                                    call FrostnovaF_KS.Apply(hero, target, true)
                                    call DamageSource(FrostnovaE_ID)
                                    call dmgmag(hero, target, GetHeroInt(hero, true)*FrostnovaTE_DamageInt)
                                endif
                            endloop
                        endif
                    endif
                endif
                set invulnerabilityRemaining = RMaxBJ(0.0, invulnerabilityRemaining - 0.03)
                if (invulnerabilityRemaining <= 0.0001 or not FrostnovaAlive(hero)) and ownsInvulnerability then
                    call UnitRemoveAbility(hero, 'Avul')
                    set ownsInvulnerability = false
                endif
                if remainingTime <= 0.0001 or GetUnitTypeId(hero) == 0 then
                    if ownsInvulnerability then
                        call UnitRemoveAbility(hero, 'Avul')
                    endif
                    call MyFrameTimed(hero, 0.0, "BTNHero_Frostnova_E", 2)
                    call MyFrameTimed(hero, 0.0, "BTNHero_Frostnova_TE", 3)
                    call RemoveSavedInteger(FrostnovaTable, GetHandleId(hero), 2)
                    if burst != null then
                        call DestroyEffect(burst)
                        set burst = null
                        call DestroyEffect(burst2)
                        set burst2 = null
                    endif
                    call DestroyEffect(mainEffect)
                    call DestroyEffect(fieldEffect)
                    call DestroyEffect(aura)
                    call DestroyEffect(area)
                    set area = null
                    set aura = null
                    call DestroyGroup(targets)
                    set mainEffect = null
                    set fieldEffect = null
                    set targets = null
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set index = index + 1
                endif
            endloop
            set target = null
        endmethod

        static method Start takes unit caster returns nothing
            local FrostnovaState state = LoadInteger(FrostnovaTable, GetHandleId(caster), 0)
            local thistype this = LoadInteger(FrostnovaTable, GetHandleId(caster), 2)
            if this == 0 then
                set this = allocate()
                set hero = caster
                set ownsInvulnerability = false
                set burst = null
                set targets = CreateGroup()
                set mainEffect = null
                set fieldEffect = null
                set aura = null
                set area = null
                set paused = false
                call SaveInteger(FrostnovaTable, GetHandleId(hero), 2, this)
                set active[count] = this
                set count = count + 1
                call GearTimer03Acquire()
            endif
            call DestroyEffect(aura)
            call DestroyEffect(area)
            set area = null
            set aura = null
            set buffCountdown = 0.0
            set positionX = GetUnitX(hero)
            set positionY = GetUnitY(hero)
            set preparationRemaining = FrostnovaE_Preparation
            set remainingTime = FrostnovaE_Duration
            if not paused then
                call StartSpellUnit2(hero)
                set paused = true
            endif
            if state.winterRemaining > 0.0 then
                call state.Voice(true)
            else
                call MakeSound(FrostnovaSoundPath + "E")
            endif
            call MakeSound(FrostnovaSoundPath + "E2")
            if mainEffect != null then
                call DestroyEffect(mainEffect)
                set mainEffect = null
            endif
            if fieldEffect != null then
                call DestroyEffect(fieldEffect)
                set fieldEffect = null
            endif
            set damageCountdown = 1.0
            set damage = GetHeroInt(hero, true) * (FrostnovaE_DamageIntBase + FrostnovaE_DamageIntStep * (GetUnitAbilityLevel(hero, FrostnovaE_ID)-1))
            set enhanced = state.winterRemaining > 0.0
            if not ownsInvulnerability and GetUnitAbilityLevel(hero, 'Avul') == 0 then
                call UnitAddAbility(hero, 'Avul')
                set ownsInvulnerability = true
            endif
            call SetUnitAnimationByIndex(hero,3)
            call SetUnitTimeScale(hero,1.5)
            set invulnerabilityRemaining = FrostnovaE_Preparation + FrostnovaE_Invulnerability
        endmethod
    endstruct
    // ==================== R: Icefield ====================
    private struct FrostnovaR_KS
        static integer array active
        static integer count = 0
        unit hero
        real positionX
        real positionY
        real radius
        real remainingTime
        real damageCountdown
        real damage
        real burstCountdown
        real formation
        boolean enhanced
        effect mainEffect
        group targets
        real exitCountdown
        integer crystalCount
        group insideTargets

        method CheckExits takes nothing returns nothing
            local unit target
            local integer targetHandle
            local integer crystalIndex
            local real targetDistance
            local real previousDistance
            local real angle
            local effect crystal
            call GroupEnumUnitsInRange(targets, positionX, positionY, radius+FrostnovaTR_ExitBand, null)
            // Observe every previously inside unit, even after a long blink.
            loop
                set target = FirstOfGroup(insideTargets)
                exitwhen target == null
                call GroupRemoveUnit(insideTargets, target)
                call GroupAddUnit(targets, target)
            endloop
            loop
                set target = FirstOfGroup(targets)
                exitwhen target == null
                call GroupRemoveUnit(targets, target)
                if IsUnitEnemy(target, GetOwningPlayer(hero)) and SpellBool(target) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) then
                    set targetHandle = GetHandleId(target)
                    set targetDistance = SquareRoot((GetUnitX(target)-positionX)*(GetUnitX(target)-positionX)+(GetUnitY(target)-positionY)*(GetUnitY(target)-positionY))
                    if HaveSavedReal(FrostnovaTable, this, targetHandle) then
                        set previousDistance = LoadReal(FrostnovaTable, this, targetHandle)
                        // Only an actual exit into the outer band applies a native root.
                        if previousDistance <= radius and targetDistance > radius and targetDistance <= radius+FrostnovaTR_ExitBand and not HaveSavedReal(FrostnovaTable, this, -targetHandle) then
                            call RootUnit(hero, target, FrostnovaTR_ExitRoot)
                            call SaveReal(FrostnovaTable, this, -targetHandle, 1.0)
                            set crystalIndex = 0
                            set angle = GetRandomReal(0.0, 2.0*bj_PI)
                            loop
                                exitwhen crystalIndex == 4
                                set crystal = AddSpecialEffect(FrostnovaTR_CrystalModel, GetUnitX(target)+FrostnovaTR_TrapRadius*Cos(angle), GetUnitY(target)+FrostnovaTR_TrapRadius*Sin(angle))
                                call BlzSetSpecialEffectScale(crystal, FrostnovaTR_CrystalScale)
                                call BlzPlaySpecialEffect(crystal, ANIM_TYPE_STAND)
                                call SaveEffectHandle(FrostnovaTable, this, -1000-crystalCount, crystal)
                                set crystalCount = crystalCount + 1
                                set angle = angle + bj_PI/2.0
                                set crystalIndex = crystalIndex + 1
                            endloop
                        endif
                    endif
                    if targetDistance <= radius then
                        call SaveReal(FrostnovaTable, this, targetHandle, targetDistance)
                        call GroupAddUnit(insideTargets, target)
                    else
                        call RemoveSavedReal(FrostnovaTable, this, targetHandle)
                    endif
                else
                    call RemoveSavedReal(FrostnovaTable, this, GetHandleId(target))
                endif
            endloop
            set target = null
            set crystal = null
        endmethod

        static method Loop takes nothing returns nothing
            local integer index = 0
            local integer fieldIndex
            local thistype this
            local unit target
            local real orientationAngle
            local real radial
            local real cx
            local real cy
            local effect blast
            loop
                exitwhen index >= count
                set this = active[index]
                if formation > 0.0 then
                    set formation = RMaxBJ(0.0, formation - 0.03)
                    call BlzSetSpecialEffectScale(mainEffect, RMaxBJ(0.05, 1.0-formation/FrostnovaR_Formation)*radius/FrostnovaR_ModelRadius)
                    if formation <= 0.0001 then
                        set formation = 0.0
                        call MakeSound(FrostnovaSoundPath + "R3")
                        if LoadInteger(FrostnovaTable, GetHandleId(hero), 4) == this then
                            call MyFrameTimed(hero, remainingTime, "BTNHero_Frostnova_R", 4)
                        endif
                    endif
                else
                    set remainingTime = remainingTime - 0.03
                    if enhanced then
                        set exitCountdown = exitCountdown - 0.03
                        if exitCountdown <= 0.0001 then
                            set exitCountdown = exitCountdown + 0.12
                            call this.CheckExits()
                        endif
                    endif
                    set damageCountdown = damageCountdown - 0.03
                    if damageCountdown <= 0.0001 and GetUnitTypeId(hero) != 0 then
                        set damageCountdown = damageCountdown + 1.0
                        call DecorRemove(hero, positionX, positionY, radius, FrostnovaR_DecorDamage)
                        call GroupEnumUnitsInRange(targets, positionX, positionY, radius, null)
                        loop
                            set target = FirstOfGroup(targets)
                            exitwhen target == null
                            call GroupRemoveUnit(targets, target)
                            if IsUnitEnemy(target, GetOwningPlayer(hero)) and SpellBool(target) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) then
                                call FrostnovaF_KS.Apply(hero, target, enhanced)
                                call DamageSource(FrostnovaR_ID)
                                call dmgmag(hero, target, damage + GetHeroInt(hero, true)*FrostnovaR_StackDamageInt*FrostnovaF_KS.StacksOn(target))
                            endif
                        endloop
                    endif
                    if enhanced and GetUnitTypeId(hero) != 0 then
                        set burstCountdown = burstCountdown - 0.03
                        if burstCountdown <= 0.0001 then
                            set burstCountdown = burstCountdown + FrostnovaTR_BurstPeriod
                            set orientationAngle = GetRandomReal(0.0, 2.0*bj_PI)
                            set radial = RMaxBJ(0.0, radius-FrostnovaTR_BurstAoe)*SquareRoot(GetRandomReal(0.0, 1.0))
                            set cx = positionX + radial*Cos(orientationAngle)
                            set cy = positionY + radial*Sin(orientationAngle)
                            set blast = AddSpecialEffect(FrostnovaTR_BurstModel, cx, cy)
                            call BlzSetSpecialEffectScale(blast, FrostnovaTR_BurstScale)
                            call DestroyEffect(blast)
                            call GroupEnumUnitsInRange(targets, cx, cy, FrostnovaTR_BurstAoe, null)
                            loop
                                set target = FirstOfGroup(targets)
                                exitwhen target == null
                                call GroupRemoveUnit(targets, target)
                                if IsUnitEnemy(target, GetOwningPlayer(hero)) and SpellBool(target) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) then
                                    call FrostnovaF_KS.Apply(hero, target, true)
                                    call DamageSource(FrostnovaR_ID)
                                    call dmgmag(hero, target, GetHeroInt(hero, true)*FrostnovaTR_BurstDamageInt)
                                endif
                            endloop
                        endif
                    endif
                endif
                // Fixed gameplay radius. Only the initial formation scales the art.
                if remainingTime <= 0.0001 or GetUnitTypeId(hero) == 0 then
                    loop
                        exitwhen crystalCount == 0
                        set crystalCount = crystalCount - 1
                        call DestroyEffect(LoadEffectHandle(FrostnovaTable, this, -1000-crystalCount))
                    endloop
                    set fieldIndex = LoadInteger(FrostnovaTable, this, 30)
                    set FrostnovaIcefieldCount = FrostnovaIcefieldCount - 1
                    set FrostnovaIcefields[fieldIndex] = FrostnovaIcefields[FrostnovaIcefieldCount]
                    call SaveInteger(FrostnovaTable, FrostnovaIcefields[fieldIndex], 30, fieldIndex)
                    if LoadInteger(FrostnovaTable, GetHandleId(hero), 4) == this then
                        call MyFrameTimed(hero, 0.0, "BTNHero_Frostnova_R", 4)
                        call RemoveSavedInteger(FrostnovaTable, GetHandleId(hero), 4)
                    endif
                    call FlushChildHashtable(FrostnovaTable, this)
                    call DestroyEffect(mainEffect)
                    call DestroyGroup(targets)
                    call DestroyGroup(insideTargets)
                    set insideTargets = null
                    set targets = null
                    set mainEffect = null
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set index = index + 1
                endif
            endloop
            set target = null
            set blast = null
        endmethod

        static method Start takes unit caster, real targetX, real targetY returns nothing
            local FrostnovaState state = LoadInteger(FrostnovaTable, GetHandleId(caster), 0)
            local thistype this = allocate()
            local unit target
            set hero = caster
            set positionX = targetX
            set positionY = targetY
            set damage = GetHeroInt(hero, true) * (FrostnovaR_DamageIntBase + FrostnovaR_DamageIntStep * (GetUnitAbilityLevel(hero, FrostnovaR_ID)-1))
            set enhanced = state.winterRemaining > 0.0
            if enhanced then
                call state.Voice(true)
            else
                call MakeSound(FrostnovaSoundPath + "R")
            endif
            call MakeSound(FrostnovaSoundPath + "R2")
            call SaveInteger(FrostnovaTable, GetHandleId(hero), 4, this)
            call MyFrameTimed(hero, 0.0, "BTNHero_Frostnova_R", 4)
            set formation = FrostnovaR_Formation
            set damageCountdown = 1.0
            set burstCountdown = FrostnovaTR_BurstPeriod
            set radius = FrostnovaR_Aoe
            set remainingTime = FrostnovaR_Duration + FrostnovaR_DurationStep * (GetUnitAbilityLevel(hero, FrostnovaR_ID)-1)
            call VisionTimed(GetOwningPlayer(hero), positionX, positionY, radius*1.5, remainingTime+formation)
            set exitCountdown = 0.0
            set crystalCount = 0
            set FrostnovaIcefields[FrostnovaIcefieldCount] = this
            call SaveInteger(FrostnovaTable, this, 30, FrostnovaIcefieldCount)
            set FrostnovaIcefieldCount = FrostnovaIcefieldCount + 1
            set FrostnovaIcefieldX[this] = positionX
            set FrostnovaIcefieldY[this] = positionY
            set FrostnovaIcefieldRadius[this] = radius
            call SetUnitAnimationByIndex(hero,4)
            set targets = CreateGroup()
            set insideTargets = CreateGroup()
            if enhanced then
                call DestroyEffect(EffectSpawn(FrostnovaTR_StartModel, positionX, positionY, 1, 1, FrostnovaTR_StartScale, 15))
                call GroupEnumUnitsInRange(targets, positionX, positionY, radius, null)
                loop
                    set target = FirstOfGroup(targets)
                    exitwhen target == null
                    call GroupRemoveUnit(targets, target)
                    if IsUnitEnemy(target, GetOwningPlayer(hero)) and SpellBool(target) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) then
                        call RootUnit(hero, target, FrostnovaTR_StartRoot)
                        call SaveReal(FrostnovaTable, this, GetHandleId(target), SquareRoot((GetUnitX(target)-positionX)*(GetUnitX(target)-positionX)+(GetUnitY(target)-positionY)*(GetUnitY(target)-positionY)))
                        call GroupAddUnit(insideTargets, target)
                    endif
                endloop
            endif
            set mainEffect = AddSpecialEffect(FrostnovaR_Model, positionX, positionY)
            call BlzSetSpecialEffectAlpha(mainEffect,200)
            call BlzSetSpecialEffectScale(mainEffect, 0.05*radius / FrostnovaR_ModelRadius)
            call BlzSetSpecialEffectColor(mainEffect, 80, 180, 255)
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
            set target = null
        endmethod
    endstruct
    // ==================== T: Winter's Scar ====================
    private struct FrostnovaT_KS
        static integer array active
        static integer count = 0
        unit hero
        effect mainEffect

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            local FrostnovaState state
            loop
                exitwhen index >= count
                set this = active[index]
                set state = LoadInteger(FrostnovaTable, GetHandleId(hero), 0)
                if not IsUnitPaused(hero) then
                    set state.winterRemaining = RMaxBJ(0.0, state.winterRemaining - 0.03)
                endif
                if not FrostnovaAlive(hero) or GetUnitTypeId(hero) == 0 then
                    set state.winterRemaining = 0.0
                endif
                if state.winterRemaining <= 0.0001 then
                    set state.winterRemaining = 0.0
                    call state.SetIcons(false)
                    call state.UpdateShards()
                    call WUI_HeroProgress(hero, FrostnovaT_ID, "Winter's Scar", 0.0, 0.0, true)
                    call RemoveSavedInteger(FrostnovaTable, GetHandleId(hero), 3)
                    call DestroyEffect(mainEffect)
                    set mainEffect = null
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    if state.voiceRemaining > 0.0001 then
                        call WUI_HeroProgressDualText(hero, FrostnovaT_ID, "Winter's Scar", state.winterRemaining, FrostnovaT_Duration, state.shieldRemaining, FrostnovaT_ShieldDuration, "|cffffffffShield: " + R2SW(state.shieldRemaining, 0, 1) + "s|r")
                    else
                        call WUI_HeroProgressDualText(hero, FrostnovaT_ID, "Winter's Scar", state.winterRemaining, FrostnovaT_Duration, 0.0, 1.0, "|cffffffffShield Ready|r")
                    endif
                    set index = index + 1
                endif
            endloop
        endmethod

        static method Start takes unit caster returns nothing
            local FrostnovaState state = LoadInteger(FrostnovaTable, GetHandleId(caster), 0)
            local thistype this = LoadInteger(FrostnovaTable, GetHandleId(caster), 3)
            if this == 0 then
                set this = allocate()
                set hero = caster
                set mainEffect = AddSpecialEffectTarget(FrostnovaT_Model, hero, "origin")
                call BlzPlaySpecialEffect(mainEffect, ANIM_TYPE_STAND)
                call SaveInteger(FrostnovaTable, GetHandleId(hero), 3, this)
                set active[count] = this
                set count = count + 1
                call GearTimer03Acquire()
            endif
            call VisionTimed(GetOwningPlayer(hero), GetUnitX(hero), GetUnitY(hero), FrostnovaTE_Aoe*2.0, 2.0)
            call MakeSound(FrostnovaSoundPath + "T1")
            call MakeSound(FrostnovaSoundPath + "T5")
            set state.voiceRemaining = RMaxBJ(state.voiceRemaining, 4.393)
            set state.voiceDuration = state.voiceRemaining
            set state.nextVoice = 2
            set state.winterRemaining = FrostnovaT_Duration
            call state.SetIcons(true)
            call state.RefreshShield()
            call BlzStartUnitAbilityCooldown(hero, FrostnovaW_ID, RMaxBJ(0.0, BlzGetUnitAbilityCooldownRemaining(hero, FrostnovaW_ID)-FrostnovaT_CooldownReduction))
            call BlzStartUnitAbilityCooldown(hero, FrostnovaE_ID, RMaxBJ(0.0, BlzGetUnitAbilityCooldownRemaining(hero, FrostnovaE_ID)-FrostnovaT_CooldownReduction))
            call BlzStartUnitAbilityCooldown(hero, FrostnovaR_ID, RMaxBJ(0.0, BlzGetUnitAbilityCooldownRemaining(hero, FrostnovaR_ID)-FrostnovaT_CooldownReduction))
            call WUI_HeroProgressDualText(hero, FrostnovaT_ID, "Winter's Scar", state.winterRemaining, FrostnovaT_Duration, state.shieldRemaining, FrostnovaT_ShieldDuration, "|cffffffffShield: " + R2SW(state.shieldRemaining, 0, 1) + "s|r")
            call SpellStacksFill(hero)
            set state.qCastDelay = 0.0
            call SetAnimIndex(hero,0.03,6)
            call SetUnitTimeScale(hero,2.15)
            call AnimDummy(hero,0.5,1)
            call BlzEndUnitAbilityCooldown(hero, FrostnovaQ_ID)
            call state.UpdateShards()
        endmethod
    endstruct
    // ==================== COMMON: one timer listener and hero lifecycle ====================
    private function FrostnovaTimer03Loop takes nothing returns boolean
        call FrostnovaQ_KS.Loop()
        call FrostnovaW_KS.Loop()
        call FrostnovaE_KS.Loop()
        call FrostnovaR_KS.Loop()
        call FrostnovaT_KS.Loop()
        call FrostnovaF_KS.Loop()
        call FrostnovaState.Loop()
        return false
    endfunction
    function Frostnova_Register takes unit hero returns nothing
        local FrostnovaState state
        if GetUnitTypeId(hero) != Frostnova_ID or IsUnitIllusion(hero) then
            return
        endif
        if not FrostnovaListenerOn then
            set FrostnovaListenerOn = true
            call TriggerAddCondition(GearTimer03Listeners, Condition(function FrostnovaTimer03Loop))
        endif
        set state = LoadInteger(FrostnovaTable, GetHandleId(hero), 0)
        if state == 0 then
            set state = FrostnovaState.create()
            set state.hero = hero
            set state.qLevel = 0
            set state.qCastDelay = 0.0
            set state.previousQCharges = 0
            set state.winterRemaining = 0.0
            set state.ticking = false
            set state.orbitTime = 0.0
            set state.voiceRemaining = 0.0
            set state.voiceDuration = 0.0
            set state.shieldRemaining = 0.0
            set state.nextVoice = 2
            set state.nextNormalVoice = 0
            set state.enhancedShards = false
            set state.rangeBonus = false
            call SaveInteger(FrostnovaTable, GetHandleId(hero), 0, state)
            call UnitAddAbility(hero, FrostnovaF_ID)
            call UnitMakeAbilityPermanent(hero, true, FrostnovaF_ID)
        endif
        call state.RefreshRange()
        if state.qLevel != GetUnitAbilityLevel(hero, FrostnovaQ_ID) or SpellStacksGetMax(hero) == 0 then
            call state.RefreshCharges()
        endif
    endfunction
    function Frostnova_ResetForTest takes unit hero returns nothing
        local FrostnovaState state
        call Frostnova_Register(hero)
        set state = LoadInteger(FrostnovaTable, GetHandleId(hero), 0)
        if state == 0 then
            return
        endif
        set state.qCastDelay = 0.0
        call SpellStacksResetForEscape(hero)
        call state.UpdateShards()
    endfunction
    function Frostnova_Death takes unit hero returns nothing
        local FrostnovaState state = LoadInteger(FrostnovaTable, GetHandleId(hero), 0)
        if state != 0 then
            set state.winterRemaining = 0.0
            call SpellStacksFill(hero)
            set state.qCastDelay = 0.0
            call state.UpdateShards()
            call state.Activate()
        endif
    endfunction

    // ==================== Q / W / E / R / T: CastCheck entry points ====================
    function FrostnovaQ_Start takes unit hero, real positionX, real positionY returns boolean
        call Frostnova_Register(hero)
        return FrostnovaQ_KS.Start(hero, positionX, positionY)
    endfunction

    function FrostnovaW_Start takes unit hero, real positionX, real positionY returns nothing
        call Frostnova_Register(hero)
        call FrostnovaW_KS.Start(hero, positionX, positionY)
    endfunction

    function FrostnovaE_Start takes unit hero returns nothing
        call Frostnova_Register(hero)
        call FrostnovaE_KS.Start(hero)
    endfunction

    function FrostnovaR_Start takes unit hero, real positionX, real positionY returns nothing
        call Frostnova_Register(hero)
        call FrostnovaR_KS.Start(hero, positionX, positionY)
    endfunction

    function FrostnovaT_Start takes unit hero returns nothing
        call Frostnova_Register(hero)
        call FrostnovaT_KS.Start(hero)
    endfunction
    private function InitFrostnovaSpells takes nothing returns nothing
        set FrostnovaFBuff[1] = FrostnovaF1_BuffID
        set FrostnovaFBuff[2] = FrostnovaF2_BuffID
        set FrostnovaFBuff[3] = FrostnovaF3_BuffID
        set FrostnovaFBuff[4] = FrostnovaF4_BuffID
        set FrostnovaFBuff[5] = FrostnovaF5_BuffID
        set FrostnovaFBuff[6] = FrostnovaTF1_BuffID
        set FrostnovaFBuff[7] = FrostnovaTF2_BuffID
        set FrostnovaFBuff[8] = FrostnovaTF3_BuffID
        set FrostnovaFBuff[9] = FrostnovaTF4_BuffID
        set FrostnovaFBuff[10] = FrostnovaTF5_BuffID
        // Lazy listener registration in Frostnova_Register; no private timer.
    endfunction
endlibrary
