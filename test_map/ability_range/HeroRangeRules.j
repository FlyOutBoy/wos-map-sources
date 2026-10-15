// TEST-only read-only presentation of actual hero distance formulas.
// All values come from hero globals/state; never alter native cast limits or RNG.
library AbilityRangeRules requires GearSystems

function ARules_GetPreviewSource takes integer abilId returns integer
    if abilId == InoriEAlt_ID or abilId == InoriEAlt2_ID or abilId == InoriEE_ID or abilId == InoriE2_ID then
        return InoriE_ID
    elseif abilId == InoriT3_ID then
        return InoriT_ID
    elseif abilId == KyorakuT0_ID or abilId == KyorakuT1_ID or abilId == KyorakuT2_ID or abilId == KyorakuT3_ID or abilId == KyorakuT5_ID or abilId == KyorakuTSkip_ID then
        return KyorakuT_ID
    elseif abilId == TsunaT2_ID then
        return TsunaT_ID
    endif
    return abilId
endfunction

function ARules_GetCastRange takes unit hero, integer abilId, ability ab, integer level returns real
    local integer uid = GetHandleId(hero)
    local integer owner = GetHandleId(GetOwningPlayer(hero))
    local real radius
    if ab == null or level <= 0 then
        return 0.0
    endif
    if abilId == StarrkQ_ID then
        if LoadInteger(hs, uid, StringHash("stark t")) == 1 then
            return BlzGetAbilityRealLevelField(ab, ABILITY_RLF_CAST_RANGE, level - 1)
        endif
        set radius = StarrkQ_RangeBase + StarrkQ_RangeStep * (level - 1)
        if LoadInteger(hs, owner, StringHash("morph e")) != 0 then
            set radius = radius + StarrkEQ_RangeBonus
        endif
        return radius
    elseif abilId == HarribelQ_ID then
        if LoadInteger(hs, owner, StringHash("morph e")) != 0 then
            return HarribelQ_RangeBase
        endif
        return HarribelQ_RangeBase + HarribelQ_RangeStep * (level - 1)
    elseif abilId == HarribelR2_ID then
        return HarribelER_RangeBase + HarribelER_RangeStep * (GetUnitAbilityLevel(hero, HarribelR_ID) - 1)
    elseif abilId == BarraganQ_ID then
        set radius = BarraganQ_RangeBase + BarraganQ_RangeStep * (level - 1)
        if LoadInteger(hs, owner, StringHash("morph e")) != 0 then
            set radius = radius + BarraganEQ_RangeAdd
            // Both E variants spawn 150 forward and advance a full step before
            // testing the strict > limit: 70 for EQ, 140 for ETQ.
            if LoadInteger(hs, uid, StringHash("barragan t")) > 0 then
                return 150.0 + (R2I(radius / 140.0) + 1) * 140.0
            endif
            return 150.0 + (R2I(radius / 70.0) + 1) * 70.0
        endif
        return radius
    elseif abilId == TsunaQ_ID then
        if GetUnitAbilityLevel(hero, TsunaW_Buff_ID) > 0 then
            return TsunaQ_Range + TsunaWQ_AddRange
        endif
        return TsunaQ_Range
    elseif abilId == AlterSaberQ_ID then
        if LoadInteger(hs, uid, StringHash("mode r")) > 0 then
            return AlterSaberRQ_Range
        endif
        return AlterSaberQ_Range
    elseif abilId == AlucardQ_ID then
        if LoadInteger(hs, owner, StringHash("morph r")) == 1 then
            return AlucardRQ_Range
        endif
        return AlucardQ_RangeBase + AlucardQ_RangeStep * (level - 1)
    elseif abilId == AlucardE_ID then
        set radius = AlucardE_RangeBase + AlucardE_RangeStep * (level - 1)
        if LoadInteger(hs, owner, StringHash("morph r")) == 1 then
            set radius = radius - 350.0
        endif
        return radius
    elseif abilId == BambiettaQ_ID then
        if LoadInteger(hs, owner, StringHash("morph t")) > 0 then
            // Random projectile spread is displayed by its maximum envelope.
            return BambiettaTQ_RangeBase + BambiettaTQ_RangeStep * (level - 1) + 150.0
        endif
        return BambiettaQ_RangeBase + BambiettaQ_RangeStep * (level - 1)
    elseif abilId == BambiettaW_ID then
        return BambiettaW_RangeBase + BambiettaW_RangeStep * (level - 1) + 200.0
    elseif abilId == BambiettaE_ID then
        if LoadInteger(hs, owner, StringHash("morph t")) > 0 then
            return BambiettaTE_RangeBase + BambiettaTE_RangeStep * (level - 1) + 650.0
        endif
        return BambiettaE_RangeBase + BambiettaE_RangeStep * (level - 1) + 350.0
    elseif abilId == InoriQ_ID then
        return InoriQ_Range + InoriQ_RangeADD * (level - 1) + GetHeroInt(hero, true)
    elseif abilId == InoriQ2_ID then
        return InoriEQ_Range
    elseif abilId == InoriQ3_ID then
        return InoriTQ_Range
    elseif abilId == InoriR2_ID then
        return InoriR2_MaxRange
    elseif abilId == NatsuQ_ID then
        if LoadInteger(hs, uid, StringHash("mode g")) > 0 then
            if LoadInteger(hs, uid, StringHash("rev q")) > 0 then
                return NatsuQ_Range3
            endif
            return NatsuQ_Range2
        endif
        return NatsuQ_Range
    elseif abilId == AstaQ_ID then
        // Projectile starts 200 behind the hero; final blast center is 425
        // ahead of it. Preserve the source's net +225 endpoint offset.
        return AstaQ_RangeBase + AstaQ_RangeStep * (level - 1) + 225.0
    elseif abilId == AstaQ2_ID then
        return AstaQ2_RangeBase + AstaQ2_RangeStep * (level - 1) + 225.0
    elseif abilId == AstaW_ID then
        return AstaW_RangeBase + AstaW_RangeStep * (level - 1)
    elseif abilId == LaxusQ2_ID then
        return LaxusQ_Range2
    elseif abilId == MahoragaE_ID then
        return MahoragaE_Range
    elseif abilId == MahoragaE3_ID then
        return MahoragaE3_Range
    elseif abilId == TsunaE_ID then
        return TsunaE_RangeBase + TsunaE_RangeAdd * (level - 1)
    elseif abilId == DarkShikiQ_ID then
        return DarkShikiQ_RangeBase + DarkShikiQ_RangeStep * (level - 1)
    elseif abilId == FrierenQ_ID then
        return FrierenQ_RangeBase + FrierenQ_RangeStep * (level - 1)
    elseif abilId == KiritoQ_ID then
        return KiritoQ_RangeBase + KiritoQ_RangeStep * (level - 1)
    elseif abilId == MilimE_ID then
        return MilimE_RangeBase + MilimE_RangeStep * (level - 1)
    elseif abilId == OkarunQ_ID then
        return OkarunQ_RangeBase + OkarunQ_RangeStep * (level - 1)
    elseif abilId == PatriotQ_ID then
        return PatriotQ_RangeBase + PatriotQ_RangeStep * (level - 1)
    elseif abilId == PatriotR_ID then
        return PatriotR_RangeBase + PatriotR_RangeStep * (level - 1)
    elseif abilId == RimuruQ_ID then
        return RimuruQ_RangeBase + RimuruQ_RangeStep * (level - 1)
    elseif abilId == RimuruE_ID then
        return RimuruE_Range
    elseif abilId == RimuruE4_ID then
        return RimuruE4_Range
    elseif abilId == RimuruW2_ID then
        return RimuruW2_Range
    elseif abilId == TakeshiQ_ID then
        return TakeshiQ_RangeBase + TakeshiQ_RangeStep * (level - 1)
    elseif abilId == TojiW_ID then
        return TojiW_RangeBase + TojiW_RangeStep * (level - 1)
    elseif abilId == TojiE_ID then
        return TojiE_RangeBase + TojiE_RangeStep * (level - 1)
    elseif abilId == GojoQ_ID then
        if level >= 3 then
            return GojoQLvl2_Range
        endif
    elseif abilId == GojoW_ID then
        if level >= 3 then
            return GojoWLvl2_Range
        endif
    elseif abilId == GojoW2_ID then
        return GojoWLvl3_Range
    elseif abilId == AlterSaberW2_ID then
        return AlterSaberW2_Range
    elseif abilId == BarraganT2_ID then
        return BarraganT2_Range
    elseif abilId == CrocodileQ_ID then
        return CrocodileQ_Distance
    elseif abilId == CrocodileE_ID then
        return CrocodileE_Distance
    elseif abilId == Erza2R_ID then
        return Erza2R_Range
    elseif abilId == Erza3T_ID then
        return Erza3T_Range
    elseif abilId == Erza5W_ID then
        return Erza5W_Range
    elseif abilId == Erza6Q_ID then
        return Erza6Q_Range
    elseif abilId == Erza7Q_ID then
        return Erza7Q_Range
    elseif abilId == MilimQ_ID then
        return MilimQ_Range
    elseif abilId == MilimT2_ID then
        return MilimT2_BeamRange
    elseif abilId == NatsuT_ID then
        return NatsuT_Range
    elseif abilId == OkarunR_ID then
        return OkarunR_Range
    elseif abilId == RaidenE_ID then
        return RaidenE_Range
    elseif abilId == TakeshiW_ID then
        return TakeshiW_Range
    elseif abilId == TakeshiGQ_ID then
        return TakeshiGQ_Range
    elseif abilId == TsunaQ2_ID then
        return TsunaQ2_MissileRange
    elseif abilId == TsunaW3_ID then
        return TsunaW3_Range
    endif
    // Native live field already covers Barragan W and all untouched point/unit
    // casts. Push/pull, attack, leash/search and secondary travel are not cast range.
    return BlzGetAbilityRealLevelField(ab, ABILITY_RLF_CAST_RANGE, level - 1)
endfunction
endlibrary
