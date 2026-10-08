library AllyHeroAbilityUI initializer InitAllyHeroAbilityUI requires GearSystems

// Информационная панель способностей выбранного союзного героя.
//
// Важные правила безопасности:
// 1. Фреймы создаются синхронно для каждого pid, но изменяются только внутри
//    прямой проверки GetLocalPlayer() == Player(pid).
// 2. GetLocalPlayer() нигде не присваивается переменной.
// 3. У каждого игрока свой контекст выбранного героя и свой набор фреймов.
// 4. Кулдауны читаются только на локальном клиенте и только для чужого героя
//    союзного игрока. Выбор собственного Hero[pid] очищает панель.
// 5. Игровые объекты, синхронные hashtable и игровое состояние из локальных
//    UI-веток не создаются и не изменяются.
// 6. Стандартные command buttons не скрываются, не перемещаются, не
//    масштабируются и не отключаются. Они используются только как визуальные якоря.
globals
    private boolean AHUI_TooltipsReady = false
    private real AHUI_TooltipsDelay = 6
    private framehandle array AHUI_TooltipManaIcon
private framehandle array AHUI_TooltipManaText
private framehandle array AHUI_TooltipSeparator
// Текущее состояние SetPlayerAbilityAvailable.
// У этой native нет getter, поэтому запоминаем вызовы сами.
private hashtable AHUI_AbilityAvailability = InitHashtable()
// Дополнительно учитываем скрытие/disable конкретной ability юнита.
private hashtable AHUI_UnitAbilityHidden = InitHashtable()
private hashtable AHUI_UnitAbilityDisabled = InitHashtable()
endglobals

globals
    private constant real AHUI_UPDATE_PERIOD = 0.03
    private constant integer AHUI_REFRESH_TICKS = 3
    private constant real AHUI_ICON_SIZE = 0.0385
    private constant real AHUI_COOLDOWN_TEXT_SCALE = 1.80
    private constant real AHUI_COMMAND_X0 = 0.6375
    private constant real AHUI_COMMAND_X_STEP = 0.0434
    private constant real AHUI_COMMAND_BOTTOM_Y = 0.0258
    private constant real AHUI_COMMAND_MIDDLE_Y = 0.0697
    private constant integer AHUI_READY_ALPHA = 255

    private constant integer AHUI_SLOT_Q = 0
    private constant integer AHUI_SLOT_W = 1
    private constant integer AHUI_SLOT_E = 2
    private constant integer AHUI_SLOT_R = 3
    private constant integer AHUI_SLOT_T = 4
    private constant integer AHUI_SLOT_F = 5
    private constant integer AHUI_SLOT_G = 6
    private constant integer AHUI_SLOT_COUNT = 7

    // Локальный UI-контекст каждого игрока. На конкретном клиенте изменяется
    // только элемент, соответствующий GetLocalPlayer().
    private unit array AHUI_SelectedHero
    private integer array AHUI_HoveredSlot

    // Результат белого списка способностей базового ID выбранного героя.
    private integer array AHUI_CurrentAbility
    private boolean AHUI_AllowCooldownRead = false

    // Только кэш уже нарисованного локального UI.
    private integer array AHUI_RenderedAbility
    private string array AHUI_RenderedIconPath
    private boolean array AHUI_SlotVisible
    private real array AHUI_CooldownPeak
    private real array AHUI_LastRemaining

    private framehandle array AHUI_Origin
    private framehandle array AHUI_Root
    private framehandle array AHUI_Icon
    private framehandle array AHUI_CooldownFill
    private framehandle array AHUI_CooldownText
    private framehandle array AHUI_KeyText

    private framehandle array AHUI_TooltipRoot
    private framehandle array AHUI_TooltipBackdrop
    private framehandle array AHUI_TooltipTitle
    private framehandle array AHUI_TooltipText
    private framehandle AHUI_GameUI = null
    private framehandle AHUI_ConsoleBackdrop = null

    private timer AHUI_UpdateTimer = null
    private integer AHUI_UpdateTick = 0
    private trigger AHUI_SelectTrigger = null
    private trigger AHUI_DeselectTrigger = null
endglobals
private function AHUI_OnSetPlayerAbilityAvailable takes player whichPlayer, integer abilityId, boolean available returns nothing
    if whichPlayer != null and abilityId != 0 then
        call SaveBoolean(AHUI_AbilityAvailability, GetPlayerId(whichPlayer), abilityId, available)
    endif
endfunction

hook SetPlayerAbilityAvailable AHUI_OnSetPlayerAbilityAvailable


private function AHUI_OnBlzUnitHideAbility takes unit whichUnit, integer abilityId, boolean hidden returns nothing
    if whichUnit != null and abilityId != 0 then
        call SaveBoolean(AHUI_UnitAbilityHidden, GetHandleId(whichUnit), abilityId, hidden)
    endif
endfunction

hook BlzUnitHideAbility AHUI_OnBlzUnitHideAbility


private function AHUI_OnBlzUnitDisableAbility takes unit whichUnit, integer abilityId, boolean disabled, boolean hideUI returns nothing
    if whichUnit != null and abilityId != 0 then
        call SaveBoolean(AHUI_UnitAbilityDisabled, GetHandleId(whichUnit), abilityId, disabled)
    endif
endfunction

hook BlzUnitDisableAbility AHUI_OnBlzUnitDisableAbility


private function AHUI_IsAbilityAvailable takes player owner, integer abilityId returns boolean
    local integer pid

    if owner == null or abilityId == 0 then
        return false
    endif

    set pid = GetPlayerId(owner)

    if HaveSavedBoolean(AHUI_AbilityAvailability, pid, abilityId) then
        return LoadBoolean(AHUI_AbilityAvailability, pid, abilityId)
    endif

    // Если SetPlayerAbilityAvailable ещё никогда не вызывался,
    // Warcraft считает ability доступной.
    return true
endfunction





private function AHUI_IsActiveSlotCandidate takes unit whichHero, player owner, integer abilityId returns boolean
    if whichHero == null or owner == null or abilityId == 0 then
        return false
    endif

    if GetUnitAbilityLevel(whichHero, abilityId) <= 0 then
        return false
    endif

    if not AHUI_IsAbilityAvailable(owner, abilityId) then
        return false
    endif

    if LoadBoolean(AHUI_UnitAbilityHidden, GetHandleId(whichHero), abilityId) then
        return false
    endif

    if LoadBoolean(AHUI_UnitAbilityDisabled, GetHandleId(whichHero), abilityId) then
        return false
    endif

    return true
endfunction
private function AHUI_EnableTooltips takes nothing returns nothing
    set AHUI_TooltipsReady = true
    call DestroyTimer(GetExpiredTimer())
endfunction
private function AHUI_GetLogicalSlot takes integer buttonX, integer buttonY returns integer
    if buttonY == 2 and buttonX >= 0 and buttonX < 4 then
        return buttonX
    elseif buttonY == 1 then
        if buttonX == 3 then
            return AHUI_SLOT_T
        elseif buttonX == 1 then
            return AHUI_SLOT_F
        elseif buttonX == 2 then
            return AHUI_SLOT_G
        endif
    endif
    return -1
endfunction

private function AHUI_GetSlotX takes integer slot returns integer
    if slot < 4 then
        return slot
    elseif slot == AHUI_SLOT_T then
        return 3
    elseif slot == AHUI_SLOT_F then
        return 1
    endif
    return 2
endfunction

private function AHUI_GetSlotY takes integer slot returns integer
    if slot < 4 then
        return 2
    endif
    return 1
endfunction

private function AHUI_GetOriginSlot takes integer slot returns integer
    return GetSlotByXY(AHUI_GetSlotX(slot), AHUI_GetSlotY(slot))
endfunction

private function AHUI_GetSlotCenterX takes integer slot returns real
    return AHUI_COMMAND_X0 + AHUI_COMMAND_X_STEP * I2R(AHUI_GetSlotX(slot))
endfunction

private function AHUI_GetSlotCenterY takes integer slot returns real
    if slot < 4 then
        return AHUI_COMMAND_BOTTOM_Y
    endif
    return AHUI_COMMAND_MIDDLE_Y
endfunction

// Индекс собственного набора фреймов игрока. При bj_MAX_PLAYER_SLOTS == 24
// используется только 168 элементов, что безопасно для JASS-массивов.
private function AHUI_FrameIndex takes integer pid, integer slot returns integer
    return pid * AHUI_SLOT_COUNT + slot
endfunction

private function AHUI_GetKeyText takes integer slot returns string
    if slot == AHUI_SLOT_Q then
        return "Q"
    elseif slot == AHUI_SLOT_W then
        return "W"
    elseif slot == AHUI_SLOT_E then
        return "E"
    elseif slot == AHUI_SLOT_R then
        return "R"
    elseif slot == AHUI_SLOT_T then
        return "T"
    elseif slot == AHUI_SLOT_F then
        return "F"
    endif
    return "G"
endfunction

private function AHUI_ClearResolvedAbilities takes nothing returns nothing
    local integer slot = 0

    loop
        exitwhen slot >= AHUI_SLOT_COUNT
        set AHUI_CurrentAbility[slot] = 0
        set slot = slot + 1
    endloop
endfunction

// Единственная точка отбора. Способность должна быть явно перечислена у героя
// и реально присутствовать/быть изучена. Слот задаётся вручную в конфигурации:
// это обязательно для F/G-вариантов со служебными координатами (0, 1), иначе
// их кнопки пересекаются с предметными ячейками.
// Первый rawcode каждого слота также служит fallback для ещё не изученной
// способности: она рисуется как DISBTN. Вторичные варианты перечислены после
// базовых и заменяют их во время своего реального КД либо активного SwapAbility.
private function AHUI_AddHeroAbility takes unit whichHero, integer slot, integer abilityId returns nothing
    local integer level = 0
    local integer currentId = 0
    local integer swappedAbility = 0
    local real remaining = 0.00
    local boolean currentActive = false
    local boolean candidateActive = false
    local player owner = null

    if whichHero == null or abilityId == 0 or slot < 0 or slot >= AHUI_SLOT_COUNT then
        return
    endif

    set owner = GetOwningPlayer(whichHero)
    set level = GetUnitAbilityLevel(whichHero, abilityId)

    // Первый rawcode остаётся fallback для неизученной способности.
    if AHUI_CurrentAbility[slot] == 0 then
        set AHUI_CurrentAbility[slot] = abilityId
        set owner = null
        return
    endif

    if level <= 0 then
        set owner = null
        return
    endif

    set currentId = AHUI_CurrentAbility[slot]

    set candidateActive = AHUI_IsActiveSlotCandidate(whichHero, owner, abilityId)
    set currentActive = AHUI_IsActiveSlotCandidate(whichHero, owner, currentId)

    if AHUI_AllowCooldownRead then
        set remaining = BlzGetUnitAbilityCooldownRemaining(whichHero, abilityId)
    endif

    // Проверяем SwapAbility marker.
    set swappedAbility = LoadInteger(hs, GetHandleId(owner), StringHash("AHUI swap " + I2S(currentId)))

    // Приоритет:
    // 1. SwapAbility
    // 2. Новая доступная кнопка вместо скрытой/disabled старой
    // 3. Способность, которая сейчас реально ушла на CD
    if swappedAbility == abilityId and candidateActive then
        set AHUI_CurrentAbility[slot] = abilityId

    elseif candidateActive and not currentActive then
        set AHUI_CurrentAbility[slot] = abilityId

    elseif candidateActive and remaining > 0.05 then
        set AHUI_CurrentAbility[slot] = abilityId
    endif

    set owner = null
endfunction
// Явный выбор текущей формы для героев, которые переключают command card через
// SetPlayerAbilityAvailable и собственное состояние, а не через SwapAbility.
private function AHUI_SetActiveHeroAbility takes unit whichHero, integer slot, integer abilityId returns nothing
    if whichHero != null and abilityId != 0 and slot >= 0 and slot < AHUI_SLOT_COUNT and GetUnitAbilityLevel(whichHero, abilityId) > 0 then
        set AHUI_CurrentAbility[slot] = abilityId
    endif
endfunction

private function AHUI_ConfigureHeroAbilities takes unit whichHero returns nothing
    local integer heroId = GetUnitTypeId(whichHero)
    // Проверяются только базовые unit type ID. Скины и вторичные model ID не
    // меняют GetUnitTypeId героя и поэтому здесь намеренно не перечисляются.
    if heroId == Ainz_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AinzQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AinzQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AinzQ3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AinzW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AinzW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AinzW3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AinzW4_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, AinzE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, AinzE2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, AinzE3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, AinzR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, AinzR2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, AinzT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, AinzF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, AinzG_ID)
    elseif heroId == Raiden_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, RaidenQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, RaidenW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, RaidenE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, RaidenR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, RaidenT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, RaidenTT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, RaidenF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, RaidenG_ID)
    elseif heroId == Neuvillette_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, NeuvilletteQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, NeuvilletteW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, NeuvilletteE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, NeuvilletteR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, NeuvilletteT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, NeuvilletteF_ID)
    elseif heroId == Patriot_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, PatriotQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, PatriotW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, PatriotE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, PatriotR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, PatriotT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, PatriotT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, PatriotF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, PatriotF2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, PatriotG_ID)
    elseif heroId == Kyoraku_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, KyorakuQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, KyorakuQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, KyorakuW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, KyorakuW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, KyorakuE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, KyorakuE2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, KyorakuR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT0_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT1_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT4_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT5_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, KyorakuF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, KyorakuTSkip_ID)
    elseif heroId == BazzB_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, BazzBQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, BazzBW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, BazzBE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, BazzBR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, BazzBT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, BazzBG_ID)
    elseif heroId == Harribel_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, HarribelQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, HarribelW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, HarribelE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, HarribelE2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, HarribelR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, HarribelR2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, HarribelT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, HarribelG_ID)
    elseif heroId == Barragan_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, BarraganQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, BarraganW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, BarraganW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, BarraganE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, BarraganE2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, BarraganR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, BarraganT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, BarraganT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, BarraganG_ID)
    elseif heroId == Starrk_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, StarrkQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, StarrkW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, StarrkE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, StarrkE2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, StarrkR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, StarrkR2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, StarrkR3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, StarrkT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, StarrkT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, StarrkF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, StarrkG_ID)
    elseif heroId == Bambietta_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, BambiettaQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, BambiettaW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, BambiettaE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, BambiettaR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, BambiettaT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, BambiettaT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, BambiettaG_ID)
    elseif heroId == Natsu_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, NatsuQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, NatsuW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, NatsuE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, NatsuR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, NatsuFR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, NatsuT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, NatsuFT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, NatsuF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, NatsuG_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, NatsuG2_ID)
    elseif heroId == Erza_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, ErzaQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, Erza1Q_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, Erza2Q_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, Erza3Q_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, Erza4Q_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, Erza5Q_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, Erza6Q_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, Erza7Q_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, ErzaW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, Erza1W_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, Erza2W_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, Erza3W_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, Erza4W_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, Erza5W_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, Erza6W_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, Erza7W_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, ErzaE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, Erza1E_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, Erza2E_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, Erza3E_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, Erza4E_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, Erza5E_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, Erza6E_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, Erza7E_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, ErzaR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, Erza1R_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, Erza2R_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, Erza3R_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, Erza4R_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, Erza5R_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, Erza6R_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, Erza7R_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, ErzaT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, Erza1T_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, Erza2T_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, Erza3T_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, Erza4T_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, Erza5T_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, Erza6T_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, Erza7T_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, ErzaF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, ErzaG_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, ErzaG2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, Erza4F_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, Erza5F_ID)
    elseif heroId == Brandish_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, BrandishQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, BrandishW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, BrandishE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, BrandishR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, BrandishT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, BrandishF_ID)
    elseif heroId == Laxus_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, LaxusQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, LaxusQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, LaxusW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, LaxusW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, LaxusE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, LaxusR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, LaxusT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, LaxusF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, LaxusG_ID)
    elseif heroId == Akainu_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AkainuQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AkainuW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, AkainuE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, AkainuR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, AkainuT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, AkainuF_ID)
    elseif heroId == Gojo_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, GojoQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, GojoQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, GojoRQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, GojoW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, GojoW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, GojoRW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, GojoE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, GojoE2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, GojoR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, GojoRR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, GojoT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, GojoT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, GojoG_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, GojoRCancel_ID)
    elseif heroId == Kenjaku_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, KenjakuQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, KenjakuQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, KenjakuQ3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, KenjakuW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, KenjakuW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, KenjakuW3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, KenjakuE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, KenjakuE2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, KenjakuE3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, KenjakuR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, KenjakuR2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KenjakuT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, KenjakuF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, KenjakuF2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, KenjakuG_ID)
    elseif heroId == Mahoraga_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, MahoragaQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, MahoragaQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, MahoragaW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, MahoragaW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, MahoragaE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, MahoragaE2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, MahoragaE3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, MahoragaR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, MahoragaT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, MahoragaF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, MahoragaG_ID)
    elseif heroId == Tomioka_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, TomiokaQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, TomiokaW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, TomiokaE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, TomiokaR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, TomiokaT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, TomiokaF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, TomiokaG_ID)
    elseif heroId == AlterSaber_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AlterSaberQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AlterSaberW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AlterSaberComboE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, AlterSaberE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, AlterSaberR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, AlterSaberT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, AlterSaberF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, AlterSaberG_ID)
        if LoadInteger(hs, GetHandleId(whichHero), StringHash("mode r")) > 0 then
            call AHUI_SetActiveHeroAbility(whichHero, AHUI_SLOT_W, AlterSaberW2_ID)
            call AHUI_SetActiveHeroAbility(whichHero, AHUI_SLOT_R, AlterSaberRR_ID)
        endif
    elseif heroId == Inori_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, InoriQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, InoriQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, InoriQ3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, InoriW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, InoriW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, InoriW3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, InoriE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, InoriEAlt_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, InoriEAlt2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, InoriEE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, InoriE2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, InoriR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, InoriER_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, InoriR2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, InoriT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, InoriT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, InoriT3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, InoriF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, InoriG_ID)
    elseif heroId == Okarun_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, OkarunQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, OkarunW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, OkarunE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, OkarunR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, OkarunT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, OkarunF_ID)
    elseif heroId == Tsuna_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, TsunaQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, TsunaQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, TsunaW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, TsunaW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, TsunaW3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, TsunaE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, TsunaE2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, TsunaR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, TsunaR2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, TsunaT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, TsunaT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, TsunaT3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, TsunaF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, TsunaG_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, TsunaG2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, TsunaG3_ID)
    elseif heroId == Takeshi_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, TakeshiQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, TakeshiQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, TakeshiQ3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, TakeshiGQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, TakeshiW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, TakeshiW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, TakeshiGW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, TakeshiE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, TakeshiE2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, TakeshiGE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, TakeshiR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, TakeshiR2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, TakeshiGR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, TakeshiT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, TakeshiF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, TakeshiGF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, TakeshiG_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, TakeshiG2_ID)
    elseif heroId == DarkShiki_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, DarkShikiQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, DarkShikiQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, DarkShikiW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, DarkShikiE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, DarkShikiR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, DarkShikiT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, DarkShikiF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, DarkShikiG_ID)
    elseif heroId == Rimuru_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, RimuruQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, RimuruQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, RimuruQ3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, RimuruW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, RimuruW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, RimuruW3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, RimuruE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, RimuruE2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, RimuruE3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, RimuruE4_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, RimuruE5_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, RimuruR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, RimuruR2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, RimuruR3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, RimuruT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, RimuruT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, RimuruT3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, RimuruF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, RimuruF2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, RimuruF3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, RimuruG_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, RimuruG2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, RimuruG3_ID)
    elseif heroId == Alucard_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AlucardQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AlucardQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AlucardW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, AlucardE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, AlucardR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, AlucardW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, AlucardT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, AlucardT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, AlucardF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, AlucardG_ID)
    elseif heroId == Kirito_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, KiritoQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, KiritoW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, KiritoE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, KiritoE2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, KiritoR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, KiritoR2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KiritoT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KiritoT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, KiritoF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, KiritoG_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, KiritoG2_ID)
    elseif heroId == Asta_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AstaQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AstaQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AstaW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AstaW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, AstaE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, AstaR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, AstaR2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, AstaT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, AstaT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, AstaF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, AstaG_ID)
    elseif heroId == Frieren_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, FrierenQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, FrierenQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, FrierenQ3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, FrierenW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, FrierenW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, FrierenE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, FrierenR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, FrierenT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, FrierenT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, FrierenF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, FrierenTF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, FrierenG_ID)
    elseif heroId == Toji_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, TojiQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, TojiQ2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, TojiQ3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, TojiW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, TojiW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, TojiE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, TojiR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, TojiT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, TojiF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, TojiG_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, TojiG2_ID)
    elseif heroId == Milim_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, MilimQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, MilimW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, MilimW2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, MilimE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, MilimR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, MilimT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, MilimT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, MilimF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, MilimG_ID)
    endif
endfunction

private function AHUI_FormatCooldown takes real remaining returns string
    if remaining >= 10.00 then
        return I2S(R2I(remaining + 0.99))
    endif
    return R2SW(remaining, 1, 1)
endfunction

private function AHUI_HideTooltip takes integer pid returns nothing
    call BlzFrameSetVisible(AHUI_TooltipRoot[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipBackdrop[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipTitle[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipText[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipManaIcon[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipManaText[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipSeparator[pid], false)
endfunction

private function AHUI_HideSlot takes integer pid, integer slot returns nothing
    local integer index = AHUI_FrameIndex(pid, slot)

    set AHUI_RenderedAbility[index] = 0
    set AHUI_RenderedIconPath[index] = null
    set AHUI_SlotVisible[index] = false
    set AHUI_CooldownPeak[index] = 0.00
    set AHUI_LastRemaining[index] = 0.00

    // Функция вызывается только из локальной ветки соответствующего pid.
    call BlzFrameSetVisible(AHUI_Root[index], false)
    call BlzFrameSetVisible(AHUI_Icon[index], false)
    call BlzFrameSetVisible(AHUI_CooldownFill[index], false)
    call BlzFrameSetVisible(AHUI_CooldownText[index], false)
    call BlzFrameSetVisible(AHUI_KeyText[index], false)
    call BlzFrameSetAlpha(AHUI_Icon[index], AHUI_READY_ALPHA)
    call BlzFrameSetAlpha(AHUI_CooldownFill[index], 255)
    call BlzFrameSetAlpha(AHUI_CooldownText[index], 255)
    call BlzFrameSetAlpha(AHUI_KeyText[index], 255)

    if AHUI_HoveredSlot[pid] == slot then
        call AHUI_HideTooltip(pid)
    endif
endfunction

private function AHUI_HideAll takes integer pid returns nothing
    local integer slot = 0

    loop
        exitwhen slot >= AHUI_SLOT_COUNT
        call AHUI_HideSlot(pid, slot)
        set slot = slot + 1
    endloop

    call AHUI_HideTooltip(pid)
endfunction

private function AHUI_RefreshSlot takes integer pid, integer slot returns nothing
    local integer index = AHUI_FrameIndex(pid, slot)
    local integer abilityId = AHUI_CurrentAbility[slot]
    local integer level = 0
    local real remaining = 0.00
    local real progress = 0.00
    local string iconPath = null

    if abilityId == 0 then
        call AHUI_HideSlot(pid, slot)
        return
    endif

    set level = GetUnitAbilityLevel(AHUI_SelectedHero[pid], abilityId)
    set iconPath = BlzGetAbilityIcon(abilityId)

    if AHUI_RenderedAbility[index] != abilityId or AHUI_RenderedIconPath[index] != iconPath then
        set AHUI_RenderedAbility[index] = abilityId
        set AHUI_RenderedIconPath[index] = iconPath
        set AHUI_CooldownPeak[index] = 0.00
        set AHUI_LastRemaining[index] = 0.00
        call BlzFrameSetTexture(AHUI_Icon[index], iconPath, 0, true)
        call BlzFrameSetTexture(AHUI_CooldownFill[index], ConvertBTNtoDISBTN(iconPath), 0, true)
    endif

    set AHUI_SlotVisible[index] = true
    call BlzFrameSetVisible(AHUI_Root[index], true)
    call BlzFrameSetVisible(AHUI_Icon[index], true)
    call BlzFrameSetVisible(AHUI_KeyText[index], true)

    // Неизученная или сейчас отсутствующая способность остаётся видимой как
    // DISBTN, но без выдуманного таймера.
    if level <= 0 then
        set AHUI_CooldownPeak[index] = 0.00
        set AHUI_LastRemaining[index] = 0.00
        call BlzFrameSetAlpha(AHUI_Icon[index], 0)
        call BlzFrameSetAlpha(AHUI_CooldownFill[index], 255)
        call BlzFrameSetVisible(AHUI_CooldownFill[index], true)
        call BlzFrameSetVisible(AHUI_CooldownText[index], false)
        set iconPath = null
        return
    endif

    // Источник прогресса — только фактический remaining юнита. При старте или
    // перезапуске КД запоминается реально наблюдаемая вершина, поэтому ручные
    // BlzStartUnitAbilityCooldown и уменьшения КД не подменяются Object Editor.
    set remaining = BlzGetUnitAbilityCooldownRemaining(AHUI_SelectedHero[pid], abilityId)
    if remaining > 0.05 then
        if AHUI_CooldownPeak[index] <= 0.05 or remaining > AHUI_LastRemaining[index] + 0.15 then
            set AHUI_CooldownPeak[index] = remaining
        elseif remaining > AHUI_CooldownPeak[index] then
            set AHUI_CooldownPeak[index] = remaining
        endif

        set progress = remaining / AHUI_CooldownPeak[index]
        if progress > 1.00 then
            set progress = 1.00
        elseif progress < 0.00 then
            set progress = 0.00
        endif

        call BlzFrameSetAlpha(AHUI_Icon[index], R2I(255.00 * (1.00 - progress)))
        call BlzFrameSetAlpha(AHUI_CooldownFill[index], R2I(255.00 * progress))
        call BlzFrameSetVisible(AHUI_CooldownFill[index], true)
        call BlzFrameSetText(AHUI_CooldownText[index], "|cffffffff" + AHUI_FormatCooldown(remaining) + "|r")
        call BlzFrameSetVisible(AHUI_CooldownText[index], true)
    else
        set AHUI_CooldownPeak[index] = 0.00
        call BlzFrameSetAlpha(AHUI_Icon[index], AHUI_READY_ALPHA)
        call BlzFrameSetVisible(AHUI_CooldownFill[index], false)
        call BlzFrameSetVisible(AHUI_CooldownText[index], false)
    endif

    set AHUI_LastRemaining[index] = remaining

    set iconPath = null
endfunction

private function AHUI_RefreshTooltip takes integer pid returns nothing
    local integer slot = AHUI_HoveredSlot[pid]
    local integer index = 0
    local integer abilityId = 0
    local integer abilityLevel = 0
    local integer objectLevel = 0
    local string title = null
    local string description = null
    local integer manaCost = 0
local real textHeight = 0.0
local real boxHeight = 0.0
local boolean hasMana = false
     if not AHUI_TooltipsReady then
        call AHUI_HideTooltip(pid)
        return
    endif
    if slot < 0 or slot >= AHUI_SLOT_COUNT then
        call AHUI_HideTooltip(pid)
        return
    endif

    set index = AHUI_FrameIndex(pid, slot)
    if not AHUI_SlotVisible[index] then
        call AHUI_HideTooltip(pid)
        return
    endif

    set abilityId = AHUI_CurrentAbility[slot]
    if abilityId == 0 then
        call AHUI_HideTooltip(pid)
        return
    endif

    set abilityLevel = GetUnitAbilityLevel(AHUI_SelectedHero[pid], abilityId)
    if abilityLevel > 0 then
        set objectLevel = abilityLevel - 1
    endif

    // Текст перечитывается во время каждого тика, пока мышь над кнопкой.
    // Это учитывает не только смену rawcode/уровня, но и динамическое изменение
    // tooltip другими системами карты.
set title = BlzGetAbilityTooltip(abilityId, objectLevel)
set description = BlzGetAbilityExtendedTooltip(abilityId, objectLevel)
set manaCost = BlzGetAbilityManaCost(abilityId, objectLevel)

// Flame Dash [Level 5] (Q)
set title = title + " (" + AHUI_GetKeyText(slot) + ")"

call BlzFrameSetText(AHUI_TooltipTitle[pid], title)
call BlzFrameSetText(AHUI_TooltipText[pid], description)

// ВАЖНО: пересчитываем layout текста
call BlzFrameSetSize(AHUI_TooltipText[pid], 0.278, 0.0)

set hasMana = manaCost > 0

if hasMana then
    call BlzFrameSetText(AHUI_TooltipManaText[pid], "|cffffcc00" + I2S(manaCost) + "|r")

    // Показываем mana + separator
    call BlzFrameSetVisible(AHUI_TooltipManaIcon[pid], true)
    call BlzFrameSetVisible(AHUI_TooltipManaText[pid], true)
    call BlzFrameSetVisible(AHUI_TooltipSeparator[pid], true)

    // Текст начинается НИЖЕ separator
    call BlzFrameClearAllPoints(AHUI_TooltipText[pid])
    call BlzFrameSetPoint(AHUI_TooltipText[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.011, -0.054)
else
    call BlzFrameSetVisible(AHUI_TooltipManaIcon[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipManaText[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipSeparator[pid], false)

    call BlzFrameClearAllPoints(AHUI_TooltipText[pid])
    call BlzFrameSetPoint(AHUI_TooltipText[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.011, -0.032)
endif

set textHeight = BlzFrameGetHeight(AHUI_TooltipText[pid])

if hasMana then
    set boxHeight = textHeight + 0.067
else
    set boxHeight = textHeight + 0.042
endif

if boxHeight < 0.080 then
    set boxHeight = 0.080
endif

call BlzFrameSetSize(AHUI_TooltipRoot[pid], 0.300, boxHeight)

// Позиция окна
call BlzFrameClearAllPoints(AHUI_TooltipRoot[pid])
call BlzFrameSetPoint(AHUI_TooltipRoot[pid], FRAMEPOINT_BOTTOMRIGHT, AHUI_ConsoleBackdrop, FRAMEPOINT_TOPRIGHT, -0.006, 0.025)

// Показываем tooltip
call BlzFrameSetVisible(AHUI_TooltipBackdrop[pid], true)
call BlzFrameSetVisible(AHUI_TooltipTitle[pid], true)
call BlzFrameSetVisible(AHUI_TooltipText[pid], true)
call BlzFrameSetVisible(AHUI_TooltipRoot[pid], true)

set title = null
set description = null
endfunction

private function AHUI_IsEligibleHero takes unit whichHero, integer viewerId returns boolean
    local player owner = null
    local boolean result = false

    if whichHero == null or viewerId < 0 or viewerId >= bj_MAX_PLAYER_SLOTS or GetUnitTypeId(whichHero) == 0 then
        return false
    endif
    if not IsUnitType(whichHero, UNIT_TYPE_HERO) or IsUnitIllusion(whichHero) then
        return false
    endif

    // В TestMode оба управляемых тестовых героя разрешены независимо от
    // владельца: TestUnit остаётся юнитом тестового игрока 6 даже после
    // передачи управления текущему игроку.
    if TestMode and (whichHero == TestUnit or whichHero == TestAllyUnit) then
        return true
    endif

    set owner = GetOwningPlayer(whichHero)

// Игроки 11-15 могут смотреть cooldown ЛЮБОГО чужого героя,
// независимо от alliance.
if viewerId >= 10 and viewerId <= 14 then
    set result = owner != Player(viewerId)
else
    // Остальные — только союзники, как раньше.
    set result = owner != Player(viewerId) and IsPlayerAlly(Player(viewerId), owner)
endif

set owner = null
return result
endfunction

// Hover определяется только чтением локальной позиции мыши. Никакие BUTTON,
// SIMPLEBUTTON, hitbox-frame или frame mouse events не используются.
private function AHUI_UpdateHoveredSlot takes integer pid returns nothing
    local integer slot = 0
    local integer index = 0
    local real mouseX = 0.00
    local real mouseY = 0.00
    local real centerX = 0.00
    local real centerY = 0.00
    local real halfSize = AHUI_ICON_SIZE * 0.50

    if GetLocalPlayer() != Player(pid) then
        return
    endif
    if not AHUI_IsEligibleHero(AHUI_SelectedHero[pid], pid) then
        set AHUI_HoveredSlot[pid] = -1
        call AHUI_HideTooltip(pid)
        return
    endif

    set mouseX = BlzPixelToFrameX(BlzGetMouseScreenPosX())
    set mouseY = BlzPixelToFrameY(BlzGetMouseScreenPosY())
    set AHUI_HoveredSlot[pid] = -1

    loop
        exitwhen slot >= AHUI_SLOT_COUNT
        set index = AHUI_FrameIndex(pid, slot)
        if AHUI_SlotVisible[index] then
            set centerX = AHUI_GetSlotCenterX(slot)
            set centerY = AHUI_GetSlotCenterY(slot)
            if mouseX >= centerX - halfSize and mouseX <= centerX + halfSize and mouseY >= centerY - halfSize and mouseY <= centerY + halfSize then
                set AHUI_HoveredSlot[pid] = slot
                call AHUI_RefreshTooltip(pid)
                return
            endif
        endif
        set slot = slot + 1
    endloop

    call AHUI_HideTooltip(pid)
endfunction

private function AHUI_ClearSelection takes integer pid returns nothing
    if GetLocalPlayer() != Player(pid) then
        return
    endif

    set AHUI_SelectedHero[pid] = null
    set AHUI_HoveredSlot[pid] = -1
    set AHUI_AllowCooldownRead = false
    call AHUI_ClearResolvedAbilities()
    call AHUI_HideAll(pid)
endfunction

private function AHUI_Refresh takes integer pid returns nothing
    local integer slot = 0

    // Защитный барьер: ни чтение кулдауна, ни изменение фрейма чужого pid
    // никогда не выполняются на этом клиенте.
    if GetLocalPlayer() != Player(pid) then
        return
    endif

    if not AHUI_IsEligibleHero(AHUI_SelectedHero[pid], pid) then
        call AHUI_ClearSelection(pid)
        return
    endif

    // Никакое состояние не берётся из предыдущего тика: белый список героя и
    // фактический остаток КД каждой его основной/вторичной способности читаются заново.
    call AHUI_ClearResolvedAbilities()
    set AHUI_AllowCooldownRead = true
    call AHUI_ConfigureHeroAbilities(AHUI_SelectedHero[pid])
    set AHUI_AllowCooldownRead = false

    loop
        exitwhen slot >= AHUI_SLOT_COUNT
        call AHUI_RefreshSlot(pid, slot)
        set slot = slot + 1
    endloop

endfunction

private function AHUI_Periodic takes nothing returns nothing
    local integer pid = 0
    local boolean refreshAbilities = AHUI_UpdateTick == 0

    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        if GetLocalPlayer() == Player(pid) then
            if AHUI_SelectedHero[pid] != null then
                if refreshAbilities then
                    call AHUI_Refresh(pid)
                endif
                if AHUI_SelectedHero[pid] != null then
                    call AHUI_UpdateHoveredSlot(pid)
                endif
            else
                set AHUI_HoveredSlot[pid] = -1
                call AHUI_HideTooltip(pid)
            endif
        endif
        set pid = pid + 1
    endloop

    set AHUI_UpdateTick = AHUI_UpdateTick + 1
    if AHUI_UpdateTick >= AHUI_REFRESH_TICKS then
        set AHUI_UpdateTick = 0
    endif
endfunction

private function AHUI_OnSelect takes nothing returns nothing
    local unit selected = GetTriggerUnit()
    local integer pid = GetPlayerId(GetTriggerPlayer())

    // Никакой переменной player = GetLocalPlayer(): только прямая проверка.
    if GetLocalPlayer() == Player(pid) then
        if AHUI_IsEligibleHero(selected, pid) then
            // Полный reset не даёт предыдущему союзнику мигнуть даже один кадр.
            call AHUI_ClearSelection(pid)
            set AHUI_SelectedHero[pid] = selected
            call AHUI_Refresh(pid)
            call AHUI_UpdateHoveredSlot(pid)
        else
            // Враг, чужой обычный юнит и неосновной собственный юнит сразу
            // очищают локальную панель, поэтому старый кулдаун не мигнёт.
            call AHUI_ClearSelection(pid)
        endif
    endif

    set selected = null
endfunction

private function AHUI_OnDeselect takes nothing returns nothing
    local unit deselected = GetTriggerUnit()
    local integer pid = GetPlayerId(GetTriggerPlayer())

    if GetLocalPlayer() == Player(pid) and deselected == AHUI_SelectedHero[pid] then
        call AHUI_ClearSelection(pid)
    endif

    set deselected = null
endfunction

// Read-only API для ShowTextCD. Он использует тот же белый список, поэтому
// предметные и служебные abilities больше не могут попасть в command slot.
function AHUI_GetAbilityAtCommandSlot takes unit whichUnit, integer commandSlot returns integer
    local integer targetY = 0
    local integer targetX = 0
    local integer logicalSlot = -1

    if whichUnit == null or commandSlot < 0 or commandSlot > 11 then
        return 0
    endif

    set targetY = R2I(I2R(commandSlot) / 4.00)
    set targetX = commandSlot - targetY * 4
    set logicalSlot = AHUI_GetLogicalSlot(targetX, targetY)
    if logicalSlot < 0 then
        return 0
    endif

    call AHUI_ClearResolvedAbilities()
    set AHUI_AllowCooldownRead = false
    call AHUI_ConfigureHeroAbilities(whichUnit)
    return AHUI_CurrentAbility[logicalSlot]
endfunction

function AHUI_IsAbilityLearnedAtCommandSlot takes unit whichUnit, integer commandSlot, integer abilityId returns boolean
    if whichUnit == null or abilityId == 0 or commandSlot < 0 or commandSlot > 11 then
        return false
    endif
    return GetUnitAbilityLevel(whichUnit, abilityId) > 0
endfunction

private function AHUI_CreateSlotFrames takes nothing returns nothing
    local integer pid = 0
    local integer slot = 0
    local integer index = 0
    local framehandle console = BlzGetFrameByName("ConsoleUIBackdrop", 0)

    // Origin-фреймы используются только как визуальные якоря. Hover считается
    // отдельно по локальным screen coordinates мыши.
    loop
        exitwhen slot >= AHUI_SLOT_COUNT
        set AHUI_Origin[slot] = BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, AHUI_GetOriginSlot(slot))
        set slot = slot + 1
    endloop

    // Все клиенты создают одинаковые handle-последовательности. Видимость и
    // содержимое позже меняет только локальный владелец конкретного pid.
    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        set slot = 0
        loop
            exitwhen slot >= AHUI_SLOT_COUNT
            set index = AHUI_FrameIndex(pid, slot)

            set AHUI_Root[index] = BlzCreateFrameByType("FRAME", "AHUIRoot", console, "", index)
            call BlzFrameClearAllPoints(AHUI_Root[index])
            call BlzFrameSetSize(AHUI_Root[index], AHUI_ICON_SIZE, AHUI_ICON_SIZE)
            call BlzFrameSetPoint(AHUI_Root[index], FRAMEPOINT_CENTER, AHUI_Origin[slot], FRAMEPOINT_CENTER, 0.00, 0.00)
            call BlzFrameSetLevel(AHUI_Root[index], 100)
            call BlzFrameSetEnable(AHUI_Root[index], false)
            call BlzFrameSetVisible(AHUI_Root[index], false)

            set AHUI_Icon[index] = BlzCreateFrameByType("BACKDROP", "AHUIIcon", AHUI_Root[index], "", index)
            call BlzFrameClearAllPoints(AHUI_Icon[index])
            call BlzFrameSetAllPoints(AHUI_Icon[index], AHUI_Root[index])
            call BlzFrameSetLevel(AHUI_Icon[index], 101)
            call BlzFrameSetEnable(AHUI_Icon[index], false)
            call BlzFrameSetVisible(AHUI_Icon[index], false)

            set AHUI_CooldownFill[index] = BlzCreateFrameByType("BACKDROP", "AHUICooldownFill", AHUI_Root[index], "", index)
            call BlzFrameClearAllPoints(AHUI_CooldownFill[index])
            call BlzFrameSetAllPoints(AHUI_CooldownFill[index], AHUI_Root[index])
            call BlzFrameSetAlpha(AHUI_CooldownFill[index], 255)
            call BlzFrameSetLevel(AHUI_CooldownFill[index], 102)
            call BlzFrameSetEnable(AHUI_CooldownFill[index], false)
            call BlzFrameSetVisible(AHUI_CooldownFill[index], false)

            set AHUI_CooldownText[index] = BlzCreateFrameByType("TEXT", "AHUICooldownText", AHUI_Root[index], "", index)
            call BlzFrameClearAllPoints(AHUI_CooldownText[index])
            call BlzFrameSetSize(AHUI_CooldownText[index], AHUI_ICON_SIZE, AHUI_ICON_SIZE)
            call BlzFrameSetPoint(AHUI_CooldownText[index], FRAMEPOINT_CENTER, AHUI_Root[index], FRAMEPOINT_CENTER, 0.00, 0.00)
            call BlzFrameSetTextAlignment(AHUI_CooldownText[index], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
            call BlzFrameSetScale(AHUI_CooldownText[index], AHUI_COOLDOWN_TEXT_SCALE)
            call BlzFrameSetAlpha(AHUI_CooldownText[index], 255)
            call BlzFrameSetLevel(AHUI_CooldownText[index], 110)
            call BlzFrameSetEnable(AHUI_CooldownText[index], false)
            call BlzFrameSetVisible(AHUI_CooldownText[index], false)

            set AHUI_KeyText[index] = BlzCreateFrameByType("TEXT", "AHUIKeyText", AHUI_Root[index], "", index)
            call BlzFrameClearAllPoints(AHUI_KeyText[index])
            call BlzFrameSetSize(AHUI_KeyText[index], 0.014, 0.014)
            call BlzFrameSetPoint(AHUI_KeyText[index], FRAMEPOINT_TOPLEFT, AHUI_Root[index], FRAMEPOINT_TOPLEFT, 0.002, -0.002)
            call BlzFrameSetTextAlignment(AHUI_KeyText[index], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
            call BlzFrameSetScale(AHUI_KeyText[index], 1.15)
            call BlzFrameSetText(AHUI_KeyText[index], "|cffffcc00" + AHUI_GetKeyText(slot) + "|r")
            call BlzFrameSetAlpha(AHUI_KeyText[index], 255)
            call BlzFrameSetLevel(AHUI_KeyText[index], 111)
            call BlzFrameSetEnable(AHUI_KeyText[index], false)
            call BlzFrameSetVisible(AHUI_KeyText[index], false)

            set slot = slot + 1
        endloop
        set pid = pid + 1
    endloop

    set console = null
endfunction

private function AHUI_CreateTooltipFrames takes nothing returns nothing
    local integer pid = 0

    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS

        // ROOT
        set AHUI_TooltipRoot[pid] = BlzCreateFrameByType("FRAME", "AHUITooltipRoot", AHUI_GameUI, "", pid)
        call BlzFrameSetSize(AHUI_TooltipRoot[pid], 0.300, 0.180)
        call BlzFrameSetLevel(AHUI_TooltipRoot[pid], 1000)
        call BlzFrameSetEnable(AHUI_TooltipRoot[pid], false)
        call BlzFrameSetVisible(AHUI_TooltipRoot[pid], false)

        // Warcraft-like backdrop + border
        set AHUI_TooltipBackdrop[pid] = BlzCreateFrame("EscMenuControlBackdropTemplate", AHUI_TooltipRoot[pid], 0, pid)
        call BlzFrameSetAllPoints(AHUI_TooltipBackdrop[pid], AHUI_TooltipRoot[pid])
        call BlzFrameSetLevel(AHUI_TooltipBackdrop[pid], 1001)
        call BlzFrameSetEnable(AHUI_TooltipBackdrop[pid], false)
        call BlzFrameSetVisible(AHUI_TooltipBackdrop[pid], false)

        // TITLE
        set AHUI_TooltipTitle[pid] = BlzCreateFrameByType("TEXT", "AHUITooltipTitle", AHUI_TooltipRoot[pid], "", pid)
        call BlzFrameSetSize(AHUI_TooltipTitle[pid], 0.278, 0.020)
        call BlzFrameSetPoint(AHUI_TooltipTitle[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.011, -0.009)
        call BlzFrameSetTextAlignment(AHUI_TooltipTitle[pid], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
        call BlzFrameSetScale(AHUI_TooltipTitle[pid], 1.10)
        call BlzFrameSetLevel(AHUI_TooltipTitle[pid], 1002)
        call BlzFrameSetEnable(AHUI_TooltipTitle[pid], false)
        call BlzFrameSetVisible(AHUI_TooltipTitle[pid], false)

        // MANA ICON
        set AHUI_TooltipManaIcon[pid] = BlzCreateFrameByType("BACKDROP", "AHUITooltipManaIcon", AHUI_TooltipRoot[pid], "", pid)
call BlzFrameSetSize(AHUI_TooltipManaIcon[pid], 0.015, 0.015)
call BlzFrameSetPoint(AHUI_TooltipManaIcon[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.011, -0.027)
call BlzFrameSetTexture(AHUI_TooltipManaIcon[pid], "UI\\Widgets\\ToolTips\\Human\\ToolTipManaIcon.blp", 0, false)
        call BlzFrameSetLevel(AHUI_TooltipManaIcon[pid], 1002)
        call BlzFrameSetEnable(AHUI_TooltipManaIcon[pid], false)
        call BlzFrameSetVisible(AHUI_TooltipManaIcon[pid], false)

        // MANA VALUE
        set AHUI_TooltipManaText[pid] = BlzCreateFrameByType("TEXT", "AHUITooltipManaText", AHUI_TooltipRoot[pid], "", pid)
        call BlzFrameSetSize(AHUI_TooltipManaText[pid], 0.250, 0.014)
        call BlzFrameSetPoint(AHUI_TooltipManaText[pid], FRAMEPOINT_LEFT, AHUI_TooltipManaIcon[pid], FRAMEPOINT_RIGHT, 0.005, 0.0)
        call BlzFrameSetTextAlignment(AHUI_TooltipManaText[pid], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)
        call BlzFrameSetLevel(AHUI_TooltipManaText[pid], 1002)
        call BlzFrameSetEnable(AHUI_TooltipManaText[pid], false)
        call BlzFrameSetVisible(AHUI_TooltipManaText[pid], false)
        
        // Горизонтальный разделитель как в стандартном Warcraft tooltip
set AHUI_TooltipSeparator[pid] = BlzCreateFrameByType("BACKDROP", "AHUITooltipSeparator", AHUI_TooltipRoot[pid], "", pid)
call BlzFrameSetSize(AHUI_TooltipSeparator[pid], 0.278, 0.0012)
call BlzFrameSetPoint(AHUI_TooltipSeparator[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.011, -0.047)
call BlzFrameSetTexture(AHUI_TooltipSeparator[pid], "UI\\Widgets\\ToolTips\\Human\\HorizontalSeparator.blp", 0, false)
call BlzFrameSetLevel(AHUI_TooltipSeparator[pid], 1002)
call BlzFrameSetEnable(AHUI_TooltipSeparator[pid], false)
call BlzFrameSetVisible(AHUI_TooltipSeparator[pid], false)
        
        // DESCRIPTION + TooltipBuilder content
        set AHUI_TooltipText[pid] = BlzCreateFrameByType("TEXT", "AHUITooltipText", AHUI_TooltipRoot[pid], "", pid)
        call BlzFrameSetSize(AHUI_TooltipText[pid], 0.278, 0.0)
        call BlzFrameSetPoint(AHUI_TooltipText[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.011, -0.050)
        call BlzFrameSetTextAlignment(AHUI_TooltipText[pid], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
        call BlzFrameSetLevel(AHUI_TooltipText[pid], 1002)
        call BlzFrameSetEnable(AHUI_TooltipText[pid], false)
        call BlzFrameSetVisible(AHUI_TooltipText[pid], false)

        set pid = pid + 1
    endloop
endfunction

private function AHUI_InitEvents takes nothing returns nothing
    local integer pid = 0

    set AHUI_SelectTrigger = CreateTrigger()
    set AHUI_DeselectTrigger = CreateTrigger()

    call TriggerAddAction(AHUI_SelectTrigger, function AHUI_OnSelect)
    call TriggerAddAction(AHUI_DeselectTrigger, function AHUI_OnDeselect)

    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        call TriggerRegisterPlayerUnitEvent(AHUI_SelectTrigger, Player(pid), EVENT_PLAYER_UNIT_SELECTED, null)
        call TriggerRegisterPlayerUnitEvent(AHUI_DeselectTrigger, Player(pid), EVENT_PLAYER_UNIT_DESELECTED, null)
        set pid = pid + 1
    endloop
endfunction

private function AHUI_InitPlayerState takes nothing returns nothing
    local integer pid = 0

    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        set AHUI_SelectedHero[pid] = null
        set AHUI_HoveredSlot[pid] = -1
        set pid = pid + 1
    endloop
endfunction

private function InitAllyHeroAbilityUI takes nothing returns nothing
    set AHUI_GameUI = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    set AHUI_ConsoleBackdrop = BlzGetFrameByName("ConsoleUIBackdrop", 0)

    call AHUI_InitPlayerState()
    call AHUI_InitEvents()
    call AHUI_CreateSlotFrames()
    call AHUI_CreateTooltipFrames()

    set AHUI_UpdateTimer = CreateTimer()
    call TimerStart(AHUI_UpdateTimer, AHUI_UPDATE_PERIOD, true, function AHUI_Periodic)

    call TimerStart(CreateTimer(), AHUI_TooltipsDelay, false, function AHUI_EnableTooltips)
endfunction

endlibrary
