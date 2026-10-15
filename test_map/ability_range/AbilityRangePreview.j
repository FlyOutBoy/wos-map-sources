// Shared hover-only range/AoE preview. Approved Range3 integration.
library AbilityRangePreview initializer AR_Init requires AAUniversalTooltips, WOSUI
globals
    private constant string AR_MODEL = "war3mapImported\\WOSRange\\wos_tx-tsqyuanxing2.mdx"
    private unit array AR_Hero
    private unit array AR_NextHero
    private effect array AR_Effect
    private unit array AR_RequestedHero
    private integer array AR_RequestedAbility
    private integer AR_Visible = -1
    private real AR_Scale = 0.0
    private location AR_Ground = Location(0.0, 0.0)
endglobals

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
            set AR_Hero[i] = AR_NextHero[i]
            if AR_Visible == i then
                set AR_Visible = -1
                set AR_Scale = 0.0
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
        set i = i + 1
    endloop
    set hero = null
endfunction

// Local UI state only. No handles, hashtable writes, sync or gameplay setters.
function AR_Request takes integer pid, unit hero, integer abilityId returns nothing
    if GetLocalPlayer() == Player(pid) then
        set AR_RequestedHero[pid] = hero
        set AR_RequestedAbility[pid] = abilityId

    endif
endfunction

private function AR_Conceal takes nothing returns nothing
    if AR_Visible >= 0 then
        call BlzSetSpecialEffectAlpha(AR_Effect[AR_Visible], 0)
        set AR_Visible = -1
        set AR_Scale = 0.0
    endif
endfunction

// Leaving a skill hides its circle immediately.
function AR_Hide takes integer pid returns nothing
    if GetLocalPlayer() == Player(pid) then
        set AR_RequestedHero[pid] = null
        set AR_RequestedAbility[pid] = 0
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
function AR_Render takes integer pid returns nothing
    local unit hero = AR_RequestedHero[pid]
    local real radius = 0.0
    local integer i = 0
    local integer found = -1
    local integer abilityId = AR_RequestedAbility[pid]
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
    if hero != null and GetUnitTypeId(hero) != 0 and GetOwningPlayer(hero) == Player(pid) and not IsUnitHidden(hero) and not IsUnitType(hero, UNIT_TYPE_DEAD) and not WUI_RangePreviewBlocked() then
        set radius = AAUniversalTooltips_GetPreviewRadius(hero, abilityId)
        if radius > 0.0 and radius <= 2500.0 then
            loop
                exitwhen i >= 14
                if AR_Hero[i] == hero then
                    set found = i
                    exitwhen true
                endif
                set i = i + 1
            endloop
        endif
    endif
    if found < 0 then
        call AR_Conceal()
        set hero = null
        return
    endif
    if AR_Visible >= 0 and AR_Visible != found then
        call BlzSetSpecialEffectAlpha(AR_Effect[AR_Visible], 0)
    endif
    call MoveLocation(AR_Ground, GetUnitX(hero), GetUnitY(hero))
    call BlzSetSpecialEffectPosition(AR_Effect[found], GetUnitX(hero), GetUnitY(hero), GetLocationZ(AR_Ground) + 3.0)
    if AR_Visible != found or AR_Scale != radius / 512.0 then
        set AR_Scale = radius / 512.0
        call BlzSetSpecialEffectScale(AR_Effect[found], AR_Scale)
    endif
    if AR_Visible != found then
        call BlzSetSpecialEffectAlpha(AR_Effect[found], 255)
    endif
    set AR_Visible = found
    set hero = null
endfunction

private function AR_Init takes nothing returns nothing
    // Reconciliation and rendering use the existing AHUI tick; no key control.
endfunction
endlibrary
