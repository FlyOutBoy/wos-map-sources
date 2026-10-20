library FrostnovaSpells initializer InitFrostnovaSpells uses GearSystems
    globals
        // ==================== COMMON: hero ID and shared state ====================
        integer Frostnova_ID = 'H002'
        private hashtable FrostnovaTable = InitHashtable()
        private group FrostnovaEnum = CreateGroup()
        private unit array FrostnovaDummy
        private boolean FrostnovaListenerOn = false

        // ==================== Q: Ice Javelins ====================
        integer FrostnovaQ_ID = 'A116'
        real FrostnovaQ_DamageIntBase = 1.0
        real FrostnovaQ_DamageIntStep = 0.3
        real FrostnovaQ_Range = 1200.0
        real FrostnovaQ_Speed = 1500.0
        real FrostnovaQ_Aoe = 70.0
        real FrostnovaQ_Recharge = 6.0
        real FrostnovaQ_UseCD = 0.3
        real FrostnovaQ_Stun = 0.1

        // ==================== W: Northern Winds ====================
        integer FrostnovaW_ID = 'A117'
        real FrostnovaW_DamageIntBase = 1.5
        real FrostnovaW_DamageIntStep = 0.4
        real FrostnovaW_Range = 1100.0
        real FrostnovaW_Speed = 1100.0
        real FrostnovaW_Aoe = 220.0
        real FrostnovaW_Push = 150.0
        real FrostnovaTW_Push = 350.0

        // ==================== E: Frostnova ====================
        integer FrostnovaE_ID = 'A118'
        real FrostnovaE_DamageIntBase = 0.35
        real FrostnovaE_DamageIntStep = 0.1
        real FrostnovaE_Aoe = 450.0
        real FrostnovaE_Duration = 6.0
        real FrostnovaE_Invulnerability = 0.6
        real FrostnovaE_Push = 250.0
        real FrostnovaTE_Stun = 1.0

        // ==================== R: Icefield ====================
        integer FrostnovaR_ID = 'A119'
        integer FrostnovaCrystal_ID = 'B044'
        real FrostnovaR_DamageIntBase = 0.2
        real FrostnovaR_DamageIntStep = 0.05
        real FrostnovaR_Aoe = 800.0
        real FrostnovaR_Duration = 12.0
        real FrostnovaR_Range = 1200.0
        real FrostnovaR_CrystalPeriod = 1.5
        integer FrostnovaR_MaxCrystals = 8

        // ==================== T: Winter's Scar ====================
        integer FrostnovaT_ID = 'A11A'
        real FrostnovaT_Duration = 12.0

        // ==================== F: Yeti Princess ====================
        integer FrostnovaF_ID = 'A11B'
        integer FrostnovaCold_ID = 'A11C'
        integer FrostnovaFrostbite_ID = 'A11D'
        integer FrostnovaCold_BuffID = 'B042'
        integer FrostnovaFrostbite_BuffID = 'B043'
        integer FrostnovaF_MaxStacks = 5
        real FrostnovaF_Duration = 4.0
        real FrostnovaTF_Duration = 6.0
        real FrostnovaTF_DamageInt = 0.12

        // ==================== G: no ability assigned ====================
    endglobals

    // ==================== COMMON: shared timer, state and spell instances ====================
    // One entry per real hero. Only recharge, overdrive and E startup need ticks.
    private struct FrostnovaState
        static integer array active
        static integer count = 0
        unit c
        integer charges
        integer capacity
        real recharge
        real scar
        real invulnerable
        boolean ownsInvulnerability
        boolean ticking
        effect modeEffect

        method Activate takes nothing returns nothing
            if not ticking then
                set ticking = true
                set active[count] = this
                set count = count + 1
                call GearTimer03Acquire()
            endif
        endmethod

        method RefreshCharges takes nothing returns nothing
            local integer level = GetUnitAbilityLevel(c, FrostnovaQ_ID)
            local integer maximum = IMinBJ(6, 2 + 2 * ((IMaxBJ(1, level) - 1) / 2))
            if maximum > capacity then
                if charges == 0 then
                    call BlzEndUnitAbilityCooldown(c, FrostnovaQ_ID)
                endif
                set charges = charges + maximum - capacity
                set capacity = maximum
            endif
            call TasAbilityChargeBox_SetValue(c, FrostnovaQ_ID, I2S(charges))
        endmethod

        static method Loop takes nothing returns nothing
            local integer i = 0
            local thistype this
            loop
                exitwhen i >= count
                set this = active[i]
                if not SpellBoolCaster(c) or GetUnitTypeId(c) == 0 then
                    set scar = 0.0
                    set invulnerable = 0.0
                    set charges = capacity
                endif
                if scar > 0.0 then
                    set scar = RMaxBJ(0.0, scar - 0.03)
                endif
                if scar <= 0.0 and modeEffect != null then
                    call DestroyEffect(modeEffect)
                    set modeEffect = null
                endif
                if invulnerable > 0.0 then
                    set invulnerable = RMaxBJ(0.0, invulnerable - 0.03)
                endif
                if invulnerable <= 0.0 and ownsInvulnerability then
                    call UnitRemoveAbility(c, 'Avul')
                    set ownsInvulnerability = false
                endif
                if charges < capacity then
                    set recharge = recharge - 0.03
                    if recharge <= 0.0001 then
                        set charges = charges + 1
                        set recharge = FrostnovaQ_Recharge
                        call TasAbilityChargeBox_SetValue(c, FrostnovaQ_ID, I2S(charges))
                        if charges == 1 then
                            call BlzEndUnitAbilityCooldown(c, FrostnovaQ_ID)
                        endif
                    endif
                endif
                if charges >= capacity and scar <= 0.0 and invulnerable <= 0.0 then
                    set ticking = false
                    set count = count - 1
                    set active[i] = active[count]
                    call GearTimer03Release()
                    if GetUnitTypeId(c) == 0 then
                        call RemoveSavedInteger(FrostnovaTable, GetHandleId(c), 0)
                        set c = null
                        call deallocate()
                    endif
                else
                    set i = i + 1
                endif
            endloop
        endmethod
    endstruct

    // F passive shared by Q/W/E/R: Cold and Frostbite.
    // Native Slow supplies the visible, dispellable buff and movement modifier.
    // Table state owns stacks/DoT; a normal hit never downgrades Frostbite.
    private struct FrostnovaCold_KS
        static integer array active
        static integer count = 0
        unit c
        unit u
        integer stacks
        integer buffId
        real remaining
        real pulse
        real damage
        boolean frostbite

        static method Apply takes unit caster, unit target, boolean enhanced returns nothing
            local thistype this = LoadInteger(FrostnovaTable, GetHandleId(target), 1)
            local unit dummy
            local integer abilityId
            if not SpellBool(target) or IsUnitType(target, UNIT_TYPE_STRUCTURE) or IsUnitType(target, UNIT_TYPE_MAGIC_IMMUNE) then
                return
            endif
            if DebuffImmune_Start(target, 1) == 0 then
                return
            endif
            if this == 0 then
                set this = allocate()
                set u = target
                set stacks = 0
                set frostbite = false
                set pulse = 1.0
                set active[count] = this
                set count = count + 1
                call SaveInteger(FrostnovaTable, GetHandleId(target), 1, this)
                call GearTimer03Acquire()
            elseif GetUnitAbilityLevel(target, buffId) == 0 then
                set stacks = 0
                set frostbite = false
                set pulse = 1.0
            endif
            set c = caster
            set stacks = IMinBJ(FrostnovaF_MaxStacks, stacks + 1)
            set frostbite = frostbite or enhanced
            if frostbite then
                call UnitRemoveAbility(target, FrostnovaCold_BuffID)
                set abilityId = FrostnovaFrostbite_ID
                set buffId = FrostnovaFrostbite_BuffID
                set remaining = FrostnovaTF_Duration
            else
                set abilityId = FrostnovaCold_ID
                set buffId = FrostnovaCold_BuffID
                set remaining = FrostnovaF_Duration
            endif
            set damage = I2R(GetHeroInt(caster, true)) * FrostnovaTF_DamageInt
            // Target-owned dummy can cast on allies/self; no enemy target filter.
            // Shared DummyPlayer already owns another Slow with the same order.
            // Keep one reusable, dedicated caster per target owner instead.
            set dummy = FrostnovaDummy[GetPlayerId(GetOwningPlayer(target))]
            if dummy == null or GetWidgetLife(dummy) <= 0.405 then
                set dummy = CreateUnit(GetOwningPlayer(target), 'h0C9', GetUnitX(target), GetUnitY(target), 0.0)
                set FrostnovaDummy[GetPlayerId(GetOwningPlayer(target))] = dummy
            endif
            if abilityId == FrostnovaCold_ID then
                call UnitRemoveAbility(dummy, FrostnovaFrostbite_ID)
            else
                call UnitRemoveAbility(dummy, FrostnovaCold_ID)
            endif
            call UnitAddAbility(dummy, abilityId)
            call SetUnitAbilityLevel(dummy, abilityId, stacks)
            call IssueTargetOrder(dummy, "slow", target)
            set dummy = null
        endmethod

        static method Loop takes nothing returns nothing
            local integer i = 0
            local thistype this
            loop
                exitwhen i >= count
                set this = active[i]
                set remaining = remaining - 0.03
                set pulse = pulse - 0.03
                if pulse <= 0.0001 and remaining >= -0.0001 and GetUnitTypeId(c) != 0 and SpellBoolCaster(u) and GetUnitAbilityLevel(u, buffId) > 0 then
                    set pulse = pulse + 1.0
                    if frostbite and SpellBool(u) then
                        call DamageSource(FrostnovaF_ID)
                        call dmgmag(c, u, damage * stacks)
                    endif
                endif
                if GetUnitTypeId(u) == 0 or not SpellBoolCaster(u) or GetUnitTypeId(c) == 0 or remaining <= 0.0001 or GetUnitAbilityLevel(u, buffId) == 0 then
                    call UnitRemoveAbility(u, buffId)
                    call RemoveSavedInteger(FrostnovaTable, GetHandleId(u), 1)
                    set c = null
                    set u = null
                    set count = count - 1
                    set active[i] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set i = i + 1
                endif
            endloop
        endmethod
    endstruct

    // Q and W share straight-line travel; W remembers each hit, Q stops once.
    private struct FrostnovaMissile_KS
        static integer array active
        static integer count = 0
        unit c
        real x
        real y
        real angle
        real distance
        real speed
        real radius
        real damage
        real push
        integer abilityId
        boolean enhanced
        group hit
        effect art

        static method Start takes unit caster, real tx, real ty, integer spell, real amount, boolean scar returns nothing
            local thistype this = allocate()
            set c = caster
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set angle = Atan2(ty-y, tx-x)
            set abilityId = spell
            set damage = amount
            set enhanced = scar
            set push = FrostnovaW_Push
            set hit = null
            if spell == FrostnovaQ_ID then
                set distance = FrostnovaQ_Range
                set speed = FrostnovaQ_Speed * 0.03
                set radius = FrostnovaQ_Aoe
                set art = AddSpecialEffect("Abilities\\Weapons\\LichMissile\\LichMissile.mdl", x, y)
            else
                set distance = FrostnovaW_Range
                set speed = FrostnovaW_Speed * 0.03
                set radius = FrostnovaW_Aoe
                set hit = CreateGroup()
                set art = AddSpecialEffect("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", x, y)
                call BlzSetSpecialEffectScale(art, 2.0)
                if enhanced then
                    set push = FrostnovaTW_Push
                endif
            endif
            call BlzSetSpecialEffectYaw(art, angle)
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
        endmethod

        static method Loop takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local unit first
            local real best
            local real d
            local real step
            loop
                exitwhen i >= count
                set this = active[i]
                set step = RMinBJ(speed, distance)
                set x = x + step * Cos(angle)
                set y = y + step * Sin(angle)
                set distance = distance - step
                call BlzSetSpecialEffectX(art, x)
                call BlzSetSpecialEffectY(art, y)
                set first = null
                set best = 99999999.0
                // Sub-step travel is smaller than Q's diameter: no tunnelling.
                call GroupEnumUnitsInRange(FrostnovaEnum, x, y, radius, null)
                loop
                    set u = FirstOfGroup(FrostnovaEnum)
                    exitwhen u == null
                    call GroupRemoveUnit(FrostnovaEnum, u)
                    if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                        if abilityId == FrostnovaQ_ID then
                            // Among overlapping enemies, hit the first along travel.
                            set d = (GetUnitX(u)-x)*Cos(angle) + (GetUnitY(u)-y)*Sin(angle)
                            if d < best then
                                set best = d
                                set first = u
                            endif
                        elseif not IsUnitInGroup(u, hit) then
                            call GroupAddUnit(hit, u)
                            call FrostnovaCold_KS.Apply(c, u, enhanced)
                            call MUE(u, push, 0.3, angle)
                            call DamageSource(abilityId)
                            call dmgmag(c, u, damage)
                        endif
                    endif
                endloop
                if first != null then
                    call FrostnovaCold_KS.Apply(c, first, enhanced)
                    call StunUnit(c, first, FrostnovaQ_Stun)
                    call DamageSource(abilityId)
                    call dmgmag(c, first, damage)
                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", first, "origin"))
                    set distance = 0.0
                endif
                if distance <= 0.0 or GetUnitTypeId(c) == 0 then
                    call DestroyEffect(art)
                    if hit != null then
                        call DestroyGroup(hit)
                    endif
                    set art = null
                    set hit = null
                    set c = null
                    set count = count - 1
                    set active[i] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set i = i + 1
                endif
            endloop
            set u = null
            set first = null
        endmethod
    endstruct

    private struct FrostnovaField_KS
        static integer array active
        static integer count = 0
        unit c
        real x
        real y
        real radius
        real remaining
        real pulse
        real damage
        real crystalTime
        integer crystals
        integer attempts
        integer abilityId
        boolean enhanced
        effect art

        static method Start takes unit caster, real tx, real ty, integer spell, real amount, boolean scar returns nothing
            local thistype this = allocate()
            set c = caster
            set x = tx
            set y = ty
            set abilityId = spell
            set damage = amount
            set enhanced = scar
            set pulse = 1.0
            set crystals = 0
            set attempts = 0
            set crystalTime = 0.5
            set radius = FrostnovaE_Aoe
            set remaining = FrostnovaE_Duration
            if spell == FrostnovaR_ID then
                set radius = FrostnovaR_Aoe
                set remaining = FrostnovaR_Duration
            endif
            set art = AddSpecialEffect("Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathTargetArt.mdl", x, y)
            call BlzSetSpecialEffectScale(art, radius / 200.0)
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
        endmethod

        static method Loop takes nothing returns nothing
            local integer i = 0
            local integer k
            local thistype this
            local unit u
            local destructable crystal
            local real a
            local real cx
            local real cy
            local boolean occupied
            loop
                exitwhen i >= count
                set this = active[i]
                set remaining = remaining - 0.03
                set pulse = pulse - 0.03
                if pulse <= 0.0001 and GetUnitTypeId(c) != 0 then
                    set pulse = pulse + 1.0
                    call GroupEnumUnitsInRange(FrostnovaEnum, x, y, radius, null)
                    loop
                        set u = FirstOfGroup(FrostnovaEnum)
                        exitwhen u == null
                        call GroupRemoveUnit(FrostnovaEnum, u)
                        if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                            call FrostnovaCold_KS.Apply(c, u, enhanced)
                            call DamageSource(abilityId)
                            call dmgmag(c, u, damage)
                        endif
                    endloop
                    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", x, y))
                endif
                if enhanced and abilityId == FrostnovaR_ID and crystals < FrostnovaR_MaxCrystals then
                    set crystalTime = crystalTime - 0.03
                    if crystalTime <= 0.0001 and remaining > 0.03 then
                        set crystalTime = crystalTime + FrostnovaR_CrystalPeriod
                        set a = attempts * 2.39996323
                        set attempts = attempts + 1
                        set cx = x + radius * 0.6 * Cos(a)
                        set cy = y + radius * 0.6 * Sin(a)
                        set occupied = IsTerrainPathable(cx, cy, PATHING_TYPE_WALKABILITY)
                        call GroupEnumUnitsInRange(FrostnovaEnum, cx, cy, 160.0, null)
                        loop
                            set u = FirstOfGroup(FrostnovaEnum)
                            exitwhen u == null
                            call GroupRemoveUnit(FrostnovaEnum, u)
                            if GetWidgetLife(u) > 0.405 and not IsUnitType(u, UNIT_TYPE_FLYING) and GetUnitAbilityLevel(u, 'Aloc') == 0 then
                                set occupied = true
                            endif
                        endloop
                        if not occupied then
                            set crystal = CreateDestructable(FrostnovaCrystal_ID, cx, cy, a*bj_RADTODEG, 1.0, 0)
                            call SetDestructableInvulnerable(crystal, true)
                            call SaveDestructableHandle(FrostnovaTable, this, 10+crystals, crystal)
                            set crystals = crystals + 1
                        endif
                    endif
                endif
                // Ground spells survive caster death; removing the unit cancels them.
                if remaining <= 0.0001 or GetUnitTypeId(c) == 0 then
                    set k = 0
                    loop
                        exitwhen k >= crystals
                        call RemoveDestructable(LoadDestructableHandle(FrostnovaTable, this, 10+k))
                        set k = k + 1
                    endloop
                    call FlushChildHashtable(FrostnovaTable, this)
                    call DestroyEffect(art)
                    set art = null
                    set c = null
                    set count = count - 1
                    set active[i] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set i = i + 1
                endif
            endloop
            set u = null
            set crystal = null
        endmethod
    endstruct

    private function FrostnovaTimer03Loop takes nothing returns boolean
        call FrostnovaState.Loop()
        call FrostnovaMissile_KS.Loop()
        call FrostnovaField_KS.Loop()
        call FrostnovaCold_KS.Loop()
        return false
    endfunction

    function Frostnova_Register takes unit c returns nothing
        local FrostnovaState state
        if GetUnitTypeId(c) != Frostnova_ID or IsUnitIllusion(c) then
            return
        endif
        if not FrostnovaListenerOn then
            set FrostnovaListenerOn = true
            call TriggerAddCondition(GearTimer03Listeners, Condition(function FrostnovaTimer03Loop))
        endif
        set state = LoadInteger(FrostnovaTable, GetHandleId(c), 0)
        if state == 0 then
            set state = FrostnovaState.create()
            set state.c = c
            set state.capacity = 0
            set state.charges = 0
            set state.recharge = FrostnovaQ_Recharge
            set state.scar = 0.0
            set state.invulnerable = 0.0
            set state.ownsInvulnerability = false
            set state.ticking = false
            set state.modeEffect = null
            call SaveInteger(FrostnovaTable, GetHandleId(c), 0, state)
        endif
        call state.RefreshCharges()
        call UnitAddAbility(c, FrostnovaF_ID)
        call UnitMakeAbilityPermanent(c, true, FrostnovaF_ID)
    endfunction

    // ==================== Q: Ice Javelins ====================
    function FrostnovaQ_Start takes unit c, real x, real y returns boolean
        local FrostnovaState state
        local real damage
        call Frostnova_Register(c)
        set state = LoadInteger(FrostnovaTable, GetHandleId(c), 0)
        if state == 0 or state.charges <= 0 then
            call MyAddMana(c, I2R(BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(c, FrostnovaQ_ID), ABILITY_ILF_MANA_COST, GetUnitAbilityLevel(c, FrostnovaQ_ID)-1)), 0.03)
            return false
        endif
        set damage = GetHeroInt(c, true) * (FrostnovaQ_DamageIntBase + FrostnovaQ_DamageIntStep * (GetUnitAbilityLevel(c, FrostnovaQ_ID)-1))
        if state.charges == state.capacity then
            set state.recharge = FrostnovaQ_Recharge
        endif
        set state.charges = state.charges - 1
        call TasAbilityChargeBox_SetValue(c, FrostnovaQ_ID, I2S(state.charges))
        call state.Activate()
        call FrostnovaMissile_KS.Start(c, x, y, FrostnovaQ_ID, damage, state.scar > 0.0)
        if state.charges > 0 then
            call CD_Start(c, 0.03, FrostnovaQ_ID, FrostnovaQ_UseCD)
        else
            call CD_Start(c, 0.03, FrostnovaQ_ID, state.recharge)
        endif
        return true
    endfunction

    // ==================== W: Northern Winds ====================
    function FrostnovaW_Start takes unit c, real x, real y returns nothing
        local FrostnovaState state
        call Frostnova_Register(c)
        set state = LoadInteger(FrostnovaTable, GetHandleId(c), 0)
        call FrostnovaMissile_KS.Start(c, x, y, FrostnovaW_ID, GetHeroInt(c, true) * (FrostnovaW_DamageIntBase + FrostnovaW_DamageIntStep * (GetUnitAbilityLevel(c, FrostnovaW_ID)-1)), state.scar > 0.0)
    endfunction

    // ==================== E: Frostnova ====================
    function FrostnovaE_Start takes unit c returns nothing
        local FrostnovaState state
        local group g = CreateGroup()
        local unit u
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        call Frostnova_Register(c)
        set state = LoadInteger(FrostnovaTable, GetHandleId(c), 0)
        if not state.ownsInvulnerability and GetUnitAbilityLevel(c, 'Avul') == 0 then
            call UnitAddAbility(c, 'Avul')
            set state.ownsInvulnerability = true
        endif
        set state.invulnerable = FrostnovaE_Invulnerability
        call state.Activate()
        call GroupEnumUnitsInRange(g, x, y, FrostnovaE_Aoe, null)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            call GroupRemoveUnit(g, u)
            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                call FrostnovaCold_KS.Apply(c, u, state.scar > 0.0)
                call MUE(u, FrostnovaE_Push, 0.3, Atan2(GetUnitY(u)-y, GetUnitX(u)-x))
                if state.scar > 0.0 then
                    call StunUnit(c, u, FrostnovaTE_Stun)
                endif
            endif
        endloop
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", x, y))
        call FrostnovaField_KS.Start(c, x, y, FrostnovaE_ID, GetHeroInt(c, true) * (FrostnovaE_DamageIntBase + FrostnovaE_DamageIntStep * (GetUnitAbilityLevel(c, FrostnovaE_ID)-1)), state.scar > 0.0)
        call DestroyGroup(g)
        set g = null
        set u = null
    endfunction

    // ==================== R: Icefield ====================
    function FrostnovaR_Start takes unit c, real x, real y returns nothing
        local FrostnovaState state
        local real a = Atan2(y-GetUnitY(c), x-GetUnitX(c))
        local real d = SquareRoot((x-GetUnitX(c))*(x-GetUnitX(c)) + (y-GetUnitY(c))*(y-GetUnitY(c)))
        call Frostnova_Register(c)
        set state = LoadInteger(FrostnovaTable, GetHandleId(c), 0)
        if d > FrostnovaR_Range then
            set x = GetUnitX(c) + FrostnovaR_Range * Cos(a)
            set y = GetUnitY(c) + FrostnovaR_Range * Sin(a)
        endif
        call FrostnovaField_KS.Start(c, x, y, FrostnovaR_ID, GetHeroInt(c, true) * (FrostnovaR_DamageIntBase + FrostnovaR_DamageIntStep * (GetUnitAbilityLevel(c, FrostnovaR_ID)-1)), state.scar > 0.0)
    endfunction

    // ==================== T: Winter's Scar ====================
    function FrostnovaT_Start takes unit c returns nothing
        local FrostnovaState state
        call Frostnova_Register(c)
        set state = LoadInteger(FrostnovaTable, GetHandleId(c), 0)
        set state.scar = FrostnovaT_Duration
        set state.charges = state.capacity
        set state.recharge = FrostnovaQ_Recharge
        call TasAbilityChargeBox_SetValue(c, FrostnovaQ_ID, I2S(state.charges))
        call BlzEndUnitAbilityCooldown(c, FrostnovaQ_ID)
        if state.modeEffect != null then
            call DestroyEffect(state.modeEffect)
        endif
        set state.modeEffect = AddSpecialEffectTarget("Abilities\\Spells\\Other\\FrostDamage\\FrostDamage.mdl", c, "origin")
        call state.Activate()
    endfunction

    // ==================== COMMON: death cleanup and initialization ====================
    function Frostnova_Death takes unit c returns nothing
        local FrostnovaState state = LoadInteger(FrostnovaTable, GetHandleId(c), 0)
        if state != 0 then
            set state.scar = 0.0
            set state.invulnerable = 0.0
            set state.charges = state.capacity
            call TasAbilityChargeBox_SetValue(c, FrostnovaQ_ID, I2S(state.charges))
            call BlzEndUnitAbilityCooldown(c, FrostnovaQ_ID)
            call state.Activate()
        endif
    endfunction

    private function Frostnova_OnLearn takes nothing returns nothing
        if GetLearnedSkill() == FrostnovaQ_ID then
            call Frostnova_Register(GetTriggerUnit())
        endif
    endfunction

    private function InitFrostnovaSpells takes nothing returns nothing
        local trigger learn = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(learn, EVENT_PLAYER_HERO_SKILL)
        call TriggerAddAction(learn, function Frostnova_OnLearn)
        set learn = null
        // Lazy listener registration in Frostnova_Register; no private timer.
    endfunction
endlibrary
