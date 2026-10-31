// Shared hover-only range/AoE preview. Approved Range3 integration.
// Red ring = click (cast) range; white ring = actual reach with offsets and area.
library AbilityRangePreview initializer AR_Init requires AAUniversalTooltips, WOSUI, ItemsSpells
globals
    private constant string AR_MODEL = "war3mapImported\\WOSRange\\wos_tx-tsqyuanxing2.mdx"
    private unit array AR_Hero
    private unit array AR_NextHero
    private constant string AR_MODEL_OUTER = "war3mapImported\\WOSRange\\wos_range_white.mdx"
    private effect array AR_Effect
    private effect array AR_Outer
    private unit array AR_RequestedHero
    private integer array AR_RequestedItemSlot
    private unit array AR_ItemOwner
    private item array AR_CachedItem
    private ability array AR_ItemAbility
    private integer array AR_RequestedAbility
    private integer AR_Visible = -1
    private real AR_Scale = 0.0
    private real AR_OuterScale = 0.0
    private constant real AR_MAX_RADIUS = 4000.0
    private real AR_LastX = 0.0
    private real AR_LastY = 0.0
    private location AR_Ground = Location(0.0, 0.0)
endglobals

// Item ability handles are acquired only on this synchronized path, never on hover.
// Only changed inventory slots query an ability; CD carriers never enter the cache.
private function AR_CacheItems takes integer ring, unit hero returns nothing
    local integer slot = 0
    local integer index
    local integer abilityId
    local item current = null
    if hero == null and AR_ItemOwner[ring] == null then
        return
    endif
    set AR_ItemOwner[ring] = hero
    loop
        exitwhen slot >= 6
        set index = ring * 6 + slot
        if hero != null then
            set current = UnitItemInSlot(hero, slot)
        else
            set current = null
        endif
        if current != AR_CachedItem[index] then
            set AR_CachedItem[index] = current
            set AR_ItemAbility[index] = null
            if current != null then
                set abilityId = ItemsSpells_GetPreviewAbility(GetItemTypeId(current))
                if abilityId != 0 then
                    set AR_ItemAbility[index] = BlzGetItemAbility(current, abilityId)
                endif
            endif
        endif
        set slot = slot + 1
    endloop
    set current = null
endfunction

// Runs once per existing AHUI tick, OUTSIDE its local presentation branch.
// Slots 12/13 cover the test replacements. Deduplication also handles shared Hero[].
function AR_Reconcile takes nothing returns nothing
    local integer i = 0
    local integer j
    local unit hero
    loop
        exitwhen i >= 14
        if i < 12 then
            set hero = Hero[i]
        elseif i == 12 then
            set hero = TestUnit
        else
            set hero = TestAllyUnit
        endif
        if hero != null and (GetUnitTypeId(hero) == 0 or IsUnitIllusion(hero) or not IsUnitType(hero, UNIT_TYPE_HERO)) then
            set hero = null
        endif
        set j = 0
        loop
            exitwhen j >= i or hero == null
            if AR_NextHero[j] == hero then
                set hero = null
            endif
            set j = j + 1
        endloop
        set AR_NextHero[i] = hero
        set i = i + 1
    endloop
    // Retire every displaced handle before allocating any replacement: even
    // a same-tick swap between Hero[] slots never duplicates a hero's ring.
    set i = 0
    loop
        exitwhen i >= 14
        if AR_NextHero[i] != AR_Hero[i] then
            if AR_Effect[i] != null then
                call BlzSetSpecialEffectAlpha(AR_Effect[i], 0)
                call DestroyEffect(AR_Effect[i])
            endif
            set AR_Effect[i] = null
            if AR_Outer[i] != null then
                call BlzSetSpecialEffectAlpha(AR_Outer[i], 0)
                call DestroyEffect(AR_Outer[i])
            endif
            set AR_Outer[i] = null
            set AR_Hero[i] = AR_NextHero[i]
            if AR_Visible == i then
                set AR_Visible = -1
                set AR_Scale = 0.0
                set AR_OuterScale = 0.0
            endif
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 14
        set hero = AR_Hero[i]
        if hero != null and AR_Effect[i] == null then
            set AR_Effect[i] = AddSpecialEffect(AR_MODEL, GetUnitX(hero), GetUnitY(hero))
            call BlzSetSpecialEffectAlpha(AR_Effect[i], 0)
            call BlzPlaySpecialEffect(AR_Effect[i], ANIM_TYPE_STAND)
        endif
        if hero != null and AR_Outer[i] == null then
            set AR_Outer[i] = AddSpecialEffect(AR_MODEL_OUTER, GetUnitX(hero), GetUnitY(hero))
            call BlzSetSpecialEffectAlpha(AR_Outer[i], 0)
            call BlzPlaySpecialEffect(AR_Outer[i], ANIM_TYPE_STAND)
        endif
        call AR_CacheItems(i, hero)
        set i = i + 1
    endloop
    set hero = null
endfunction

// Local UI state only. No handles, hashtable writes, sync or gameplay setters.
function AR_Request takes integer pid, unit hero, integer abilityId returns nothing
    if GetLocalPlayer() == Player(pid) then
        set AR_RequestedHero[pid] = hero
        set AR_RequestedAbility[pid] = abilityId
        set AR_RequestedItemSlot[pid] = -1

    endif
endfunction

// Local intent only: the real item/ability handle was already cached on all clients.
function AR_RequestItem takes integer pid, unit hero, integer slot returns nothing
    if GetLocalPlayer() == Player(pid) then
        set AR_RequestedHero[pid] = hero
        set AR_RequestedAbility[pid] = 0
        set AR_RequestedItemSlot[pid] = slot
    endif
endfunction

private function AR_Conceal takes nothing returns nothing
    if AR_Visible >= 0 then
        call BlzSetSpecialEffectAlpha(AR_Effect[AR_Visible], 0)
        call BlzSetSpecialEffectAlpha(AR_Outer[AR_Visible], 0)
        set AR_Visible = -1
        set AR_Scale = 0.0
        set AR_OuterScale = 0.0
    endif
endfunction

// Leaving a skill hides its circle immediately.
function AR_Hide takes integer pid returns nothing
    if GetLocalPlayer() == Player(pid) then
        set AR_RequestedHero[pid] = null
        set AR_RequestedAbility[pid] = 0
        set AR_RequestedItemSlot[pid] = -1
        call AR_Conceal()

    endif
endfunction

// Hard boundary: selection change, hidden/dead hero, covering panel or key editor.
function AR_Cancel takes integer pid returns nothing
    if GetLocalPlayer() == Player(pid) then
        call AR_Hide(pid)
    endif
endfunction

// Invoked after the existing hover/tooltip pass, at 0.05 s. No hidden positioning.
// A hidden ring keeps scale 0 so a later show re-applies its scale.
function AR_Render takes integer pid returns nothing
    local unit hero = AR_RequestedHero[pid]
    local real radius = 0.0
    local real reach = 0.0
    local integer i = 0
    local integer found = -1
    local integer abilityId = AR_RequestedAbility[pid]
    local integer itemSlot = AR_RequestedItemSlot[pid]
    local integer itemIndex
    if GetLocalPlayer() != Player(pid) then
        set hero = null
        return
    endif
    if WUI_RangePreviewBlocked() then
        call AR_Cancel(pid)
        set hero = null
        return
    endif
    if hero != null and (GetUnitTypeId(hero) == 0 or GetOwningPlayer(hero) != Player(pid) or IsUnitHidden(hero) or IsUnitType(hero, UNIT_TYPE_DEAD)) then
        call AR_Cancel(pid)
        set hero = null
        return
    endif
    if hero != null then
        loop
            exitwhen i >= 14
            if AR_Hero[i] == hero then
                set found = i
                exitwhen true
            endif
            set i = i + 1
        endloop
        if itemSlot >= 0 and itemSlot < 6 then
            if found >= 0 then
                set itemIndex = found * 6 + itemSlot
                if AR_ItemOwner[found] == hero and AR_CachedItem[itemIndex] != null and UnitItemInSlot(hero, itemSlot) == AR_CachedItem[itemIndex] then
                    set radius = ItemsSpells_GetItemPreviewRadius(GetItemTypeId(AR_CachedItem[itemIndex]), AR_ItemAbility[itemIndex])
                    set reach = ItemsSpells_GetItemPreviewReach(GetItemTypeId(AR_CachedItem[itemIndex]), AR_ItemAbility[itemIndex])
                endif
            endif
        else
            set reach = AAUniversalTooltips_GetPreviewRadius(hero, abilityId)
            set radius = AAUniversalTooltips_GetPreviewCastRange(hero, abilityId)
        endif
        // Circles up to AR_MAX_RADIUS inclusive; larger/global ranges are not drawn.
        if radius > AR_MAX_RADIUS then
            set radius = 0.0
        endif
        if reach > AR_MAX_RADIUS or R2I(reach) == R2I(radius) then
            set reach = 0.0
        endif
        if radius <= 0.0 and reach <= 0.0 then
            set found = -1
        endif
    endif
    if found < 0 then
        call AR_Conceal()
        set hero = null
        return
    endif
    if AR_Visible >= 0 and AR_Visible != found then
        call AR_Conceal()
    endif
    if AR_Visible != found or AR_LastX != GetUnitX(hero) or AR_LastY != GetUnitY(hero) then
        set AR_LastX = GetUnitX(hero)
        set AR_LastY = GetUnitY(hero)
        call MoveLocation(AR_Ground, AR_LastX, AR_LastY)
        call BlzSetSpecialEffectPosition(AR_Effect[found], AR_LastX, AR_LastY, GetLocationZ(AR_Ground) + 3.0)
        call BlzSetSpecialEffectPosition(AR_Outer[found], AR_LastX, AR_LastY, GetLocationZ(AR_Ground) + 2.0)
    endif
    if radius > 0.0 then
        if AR_Scale != radius / 512.0 then
            if AR_Scale == 0.0 then
                call BlzSetSpecialEffectAlpha(AR_Effect[found], 255)
            endif
            set AR_Scale = radius / 512.0
            call BlzSetSpecialEffectScale(AR_Effect[found], AR_Scale)
        endif
    elseif AR_Scale != 0.0 then
        call BlzSetSpecialEffectAlpha(AR_Effect[found], 0)
        set AR_Scale = 0.0
    endif
    if reach > 0.0 then
        if AR_OuterScale != reach / 512.0 then
            if AR_OuterScale == 0.0 then
                call BlzSetSpecialEffectAlpha(AR_Outer[found], 255)
            endif
            set AR_OuterScale = reach / 512.0
            call BlzSetSpecialEffectScale(AR_Outer[found], AR_OuterScale)
        endif
    elseif AR_OuterScale != 0.0 then
        call BlzSetSpecialEffectAlpha(AR_Outer[found], 0)
        set AR_OuterScale = 0.0
    endif
    set AR_Visible = found
    set hero = null
endfunction

private function AR_Init takes nothing returns nothing
    // Reconciliation and rendering use the existing AHUI tick; no key control.
endfunction
endlibrary
