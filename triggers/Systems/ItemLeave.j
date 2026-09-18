function Trig_ItemLeave_Actions takes nothing returns nothing
    local unit c = GetTriggerUnit()
    local item ti = GetManipulatedItem()
    local integer id = GetItemTypeId(ti)
    local integer i = GetPlayerId(GetOwningPlayer(c))
    local real r

    if id == 'I00C' then
        call AddHpRegen(c, 5, false)
    endif
    if id == 'I03I' then
        call AddHpRegen(c, 10, false)
    endif
    if id == 'I03J' then
        call AddHpRegen(c, 15, false)
    endif
    if id == 'I03O' then
        call AddHpRegen(c, 20, false)
    endif
    if id == 'I03P' then
        call AddHpRegen(c, 25, false)
    endif
    if id == 'I00Y' then
        call AddHpRegen(c, 20, false)
    endif
    if id == 'I027' then
        call AddHpRegen(c, 2, false)
    endif
    if id == 'I026' then
        call AddMpRegen(c, 2, false)
    endif
    if id == 'I028' then
        call AddMpRegen(c, 4, false)
        call AddHpRegen(c, 5, false)
    endif
    if id == 'I024' then
        call AddHpRegen(c, 20, false)
    endif
    if id == 'I025' then
        call AddHpRegen(c, 20, false)
    endif
    if id == 'I011' then
        call AddHpRegen(c, 20, false)
    endif
    if id == 'I00G' then
        call AddMpRegen(c, 1, false)
    endif
    if id == 'I00D' then
        call AddMpRegen(c, 2, false)
    endif
    if id == 'I03K' then
        call AddMpRegen(c, 4, false)
    endif
    if id == 'I03L' then
        call AddMpRegen(c, 6, false)
    endif
    if id == 'I03M' then
        call AddMpRegen(c, 8, false)
    endif
    if id == 'I03N' then
        call AddMpRegen(c, 10, false)
    endif
    if id == 'I020' then
        call AddHpRegen(c, 15, false)
    endif
    if id == 'I00O' then
        call AddMpRegen(c, 4, false)
        call AddSpellLevel(c, 'A01C', 7, false)
    endif
    if id == 'I01N' then
        call AddHpRegen(c, 10, false)
        call AddSpellLevel(c, 'A01C', 7, false)
    endif
    if id == 'I018' then
        call AddMpRegen(c, 4, false)
    endif
    if id == 'I00E' then
        call AddSpellLevel(c, 'A01C', 10, false)
    endif
    if id == 'I007' then
        call AddSpellLevel(c, 'A01C', 5, false)
    endif
    if id == 'I017' then
        call AddMpRegen(c, 2, false)
        call AddHpRegen(c, 5, false)
        call AddSpellLevel(c, 'A01C', 2, false)
    endif
    if id == 'I03U' then
        call AddMpRegen(c, 4, false)
        call AddHpRegen(c, 10, false)
        call AddSpellLevel(c, 'A01C', 3, false)
    endif
    
    if debugcditem(id) then
        set r = BlzGetUnitAbilityCooldownRemaining(c, getdebugcditem_abi_id(id))
        call SaveReal(hs, GetHandleId(c), StringHash(I2S(id)), r)
    endif
    if id == 'I00M' or id == 'I043' then
        call UnitRemoveAbility(c, 'A07Q')
    endif
    if id == 'I00T' then
        call AddMpRegen(c, 4, false)
        call AddSpellLevel(c, 'A01C', 3, false)
    endif
    if id == 'I00N' or id == 'I00T' then
        call AddSpellLevel(c, 'A01C', 4, false)
    endif

    // Здесь нет вызова SaveSystem: предмет остаётся в метрике used до конца
    // матча, даже если его продали или выбросили. Метрика final будет получена
    // из реального инвентаря внутри SaveSystem_OnGameEndEx.
    call RefreshItemCache(c)
    call RemoveAinzItemGoldCost(c, ti)
    call SaveBoolean(ItemCache, GetHandleId(c), id, false)
    set ti = null
    set c = null
endfunction

//==============================================================================
function InitTrig_ItemLeave takes nothing returns nothing
    set gg_trg_ItemLeave = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_ItemLeave, EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerAddAction(gg_trg_ItemLeave, function Trig_ItemLeave_Actions)
endfunction
