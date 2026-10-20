library AllyHeroAbilityUI initializer InitAllyHeroAbilityUI requires GearSystems, WOSUI, TasAbilityChargeBox, AbilityRangePreview
    globals
        // Hashed once at map load (was StringHash(...) on every call).
        private integer SH_MODE_R = StringHash("mode r")
        private integer SH_TAKESHI_DMG = StringHash("takeshi dmg")
    endglobals

// Descriptions for selected heroes and seven passive placeholders for own heroes.
// Learned available own commands remain native; enemy cooldowns remain private.
//
// Важные правила безопасности:
// 1. Фреймы создаются синхронно для каждого pid, но изменяются только внутри
//    прямой проверки GetLocalPlayer() == Player(pid).
// 2. GetLocalPlayer() нигде не присваивается переменной.
// 3. У каждого игрока свой контекст выбранного героя и свой набор фреймов.
// 4. Кулдауны читаются только на локальном клиенте и только для чужого героя
//    союзного игрока (наблюдатели 11–15 сохраняют полный просмотр).
//    Для врагов доступны иконки и описания без чтения оставшегося КД.
//    Выбор собственного Hero[pid] очищает панель.
// 5. Игровые объекты, синхронные hashtable и игровое состояние из локальных
//    UI-веток не создаются и не изменяются.
// 6. Стандартные command buttons не скрываются, не перемещаются, не
//    масштабируются и не отключаются. Они используются только как визуальные якоря.
globals
    private integer AHUI_SeenHudRevision = 0
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
    // Checkpoint 27d: 0.05 s hover / 0.15 s full refresh (was 0.03 / 0.09).
    private constant real AHUI_UPDATE_PERIOD = 0.05
    // 10 existing hover ticks: descriptions expire .50 s after icon/pip leave.
    private constant integer AHUI_TOOLTIP_LEAVE_TICKS = 4 // 0.2 s linger after the cursor leaves (was 0.5 s)
    private constant integer AHUI_REFRESH_TICKS = 5
    // Fixed cache: seven slots x two tooltip modes per player, no new frames.
    private integer AHUI_TipEpoch = 0
    private integer AHUI_TipClock = 0
    private integer array AHUI_TipShown
    private integer array AHUI_TipShownMana
    private integer array AHUI_CooldownTicks
    private unit array AHUI_TCHero
    private integer array AHUI_TCAbility
    private integer array AHUI_TCLevel
    private integer array AHUI_TCPoints
    private integer array AHUI_TCHeroLevel
    private integer array AHUI_TCType
    private integer array AHUI_TCEpoch
    private integer array AHUI_TCRevision
    private integer array AHUI_TCSettings
    private integer array AHUI_TCMana
    private integer array AHUI_TCRawMana
    private string array AHUI_TCRawTitle
    private string array AHUI_TCRawDescription
    private string array AHUI_TCTitle
    private string array AHUI_TCDescription
    private string array AHUI_TooltipKey
    private framehandle array AHUI_PausedText
    // Counter box (parent of AHUI_ChargeText), cached at creation: no frame
    // lookups in the local refresh.
    private framehandle array AHUI_ChargeBox
    private integer array AHUI_TooltipAge
    private constant real AHUI_ICON_SIZE = WUI_ICON_SIZE
    private constant real AHUI_COOLDOWN_TEXT_SCALE = 1.15
    // Compact tooltip column (was 0.300, which spanned most of the HUD).
    private constant real AHUI_TOOLTIP_WIDTH = 0.236
    // Checkpoint 26b: compact tooltip over the level pips.
    private constant real AHUI_PIP_TOOLTIP_WIDTH = 0.200
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
    // Deselect is confirmed on the next periodic tick: F1 / re-click fires
    // deselect + select of the same hero and must not rebuild the whole row.
    private boolean array AHUI_DeselectPending
    // Created once (synced); filled only with the local player's selection.
    private group AHUI_SelGroup = CreateGroup()
    private boolean AHUI_MultiShown = false
    private integer array AHUI_HoveredSlot
    // A key badge can remain visible over a native F/G command.
    private boolean array AHUI_NativeCommandShown

    // Результат белого списка способностей базового ID выбранного героя.
    private integer array AHUI_CurrentAbility
    private boolean AHUI_AllowCooldownRead = false

    // Только кэш уже нарисованного локального UI.
    private integer array AHUI_RenderedAbility
    private string array AHUI_RenderedIconPath
    private boolean array AHUI_SlotVisible
    private real array AHUI_CooldownPeak
    private real array AHUI_LastRemaining
    // Last state written by AHUI_RefreshSlot (0 = unknown, reset by AHUI_HideSlot),
    // so the 0.25 s refresh only touches natives whose value really changed.
    // Parts per index: 0 root, 1 icon, 2 cooldown fill, 3 cooldown text, 4 charge box.
    private integer array AHUI_PartState
    private integer array AHUI_IconAlphaSet
    private integer array AHUI_FillAlphaSet

    private framehandle array AHUI_Origin
    private framehandle array AHUI_Root
    // Toggle-on glow (Player Pick captain shine) over the F slot; F slot indices only.
    private framehandle array AHUI_ToggleGlow
    private boolean array AHUI_ToggleGlowShown
    private framehandle array AHUI_Icon
    private framehandle array AHUI_CooldownFill
    private framehandle array AHUI_CooldownText
    private framehandle array AHUI_ChargeText
    private framehandle array AHUI_KeyText
    private framehandle array AHUI_KeyBox
    private constant string AHUI_KEY_BOX_TEXTURE = "UI\\WOS\\panel.tga"

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
    private trigger AHUI_DeadHeroKey = null

    // Checkpoint 21: every hero skill is previewed (dimmed until learned),
    // pips match the skill's real level count, and clicking the pip strip
    // learns the next level. Frames are allocated once on every client; only
    // the local player's copy changes visibility/texture. Clicks are synced.
    private constant integer AHUI_LEARN_SLOTS = 5
    private constant integer AHUI_PIP_SLOTS = 7
    private constant integer AHUI_MAX_PIPS = 6
    private constant real AHUI_PIP_SIZE = 0.0052
    private constant real AHUI_PIP_STEP = 0.0063
    // Warcraft default for "Hero Ability Level Skip" (not overridden in Misc).
    private constant integer AHUI_DEFAULT_LEVEL_SKIP = 2
    private hashtable AHUI_LevelData = InitHashtable()
    private integer array AHUI_BaseAbility
    private framehandle array AHUI_Pip
    private string array AHUI_PipTexture
    private integer array AHUI_PipMax
    private framehandle array AHUI_LearnButton
    private framehandle array AHUI_LearnGlow
    private framehandle array AHUI_ReqText
    private integer array AHUI_PingHoverGrace
    private boolean array AHUI_PingRmbHeld
    private boolean array AHUI_HoverPips
    private trigger AHUI_LearnTrigger = null
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





private function AHUI_RequirementLocked takes unit hero, integer abilityId returns boolean
    if abilityId == RaidenF_ID then
        return Raiden_F_Dummy == null or GetOwningPlayer(Raiden_F_Dummy) != GetOwningPlayer(hero)
    endif
    if abilityId == TakeshiG_ID then
        return LoadReal(hs, GetHandleId(hero), SH_TAKESHI_DMG) < TakeshiG_TakenDamageToEnter
    endif
    return false
endfunction

private function AHUI_IsActiveSlotCandidate takes unit whichHero, player owner, integer abilityId returns boolean
    if whichHero == null or owner == null or abilityId == 0 then
        return false
    endif

    if GetUnitAbilityLevel(whichHero, abilityId) <= 0 then
        return false
    endif

    if AHUI_RequirementLocked(whichHero, abilityId) or not AHUI_IsAbilityAvailable(owner, abilityId) then
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
    return WUI_COMMAND_X + WUI_HudShift + WUI_COMMAND_STEP * I2R(slot)
endfunction

private function AHUI_GetSlotCenterY takes integer slot returns real
    return WUI_AbilityY(slot)
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
        set AHUI_BaseAbility[slot] = 0
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
        // The first rawcode of a slot is the learnable hero skill.
        set AHUI_BaseAbility[slot] = abilityId
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
    set swappedAbility = LoadInteger(hs, GetHandleId(owner), GearKey(GEAR_KEY_AHUI_SWAP, "AHUI swap ", currentId))

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

private function AHUI_CanReadCooldown takes unit whichHero, integer viewerId returns boolean
    local player owner = null
    local boolean result = false
    if whichHero == null or viewerId < 0 or viewerId >= bj_MAX_PLAYER_SLOTS then
        return false
    endif
    set owner = GetOwningPlayer(whichHero)
    if viewerId >= 10 and viewerId <= 14 then
        set result = owner != Player(viewerId)
    else
        // Own hero too: while paused (or the stock card is hidden) its skills are
        // drawn by this overlay and must keep showing their cooldowns.
        set result = owner == Player(viewerId) or IsPlayerAlly(Player(viewerId), owner)
    endif
    set owner = null
    return result
endfunction

private function AHUI_ConfigureHeroAbilities takes unit whichHero returns nothing
    local integer heroId = GetUnitTypeId(whichHero)
    // Проверяются только базовые unit type ID. Скины и вторичные model ID не
    // меняют GetUnitTypeId героя и поэтому здесь намеренно не перечисляются.
    if heroId == Frostnova_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, FrostnovaQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, FrostnovaW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, FrostnovaE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, FrostnovaR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, FrostnovaT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, FrostnovaF_ID)
    elseif heroId == Crocodile_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, CrocodileQ_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, CrocodileW_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, CrocodileE_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, CrocodileR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, CrocodileT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, CrocodileT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, CrocodileF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, CrocodileG_ID)
    elseif heroId == Ainz_ID then
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
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, KyorakuE4_ID) // Takaoni while swapped with E
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, KyorakuR_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT0_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT1_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT3_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT5_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, KyorakuF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, KyorakuTSkip_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, KyorakuT4_ID)
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
        // The learnable hero skill is GojoT2 (A01X, see Systems1); GojoT is
        // added on the first cast. The first rawcode drives the level pips.
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, GojoT2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, GojoT_ID)
        // Checkpoint 27: Six Eyes passive on F; G only shows the domain
        // cancel while Gojo actually has it (during R).
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, GojoF_ID)
        if GetUnitAbilityLevel(whichHero, GojoRCancel_ID) > 0 then
            call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, GojoRCancel_ID)
        endif
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
        // F toggle swaps to the "On" button; without it the slot went empty after the first press.
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, AlterSaberF_Active_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, AlterSaberG_ID)
        if LoadInteger(hs, GetHandleId(whichHero), SH_MODE_R) > 0 then
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
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, TakeshiG_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, TakeshiG2_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, TakeshiF_ID)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, TakeshiGF_ID)
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
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, RimuruG3_2_ID) // Black Flame while swapped with G3
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

// ===== Checkpoint 21: ability levels and learning =====

private function AHUI_SetLevelInfo takes integer abilityId, integer levels, integer required, integer skip returns nothing
    call SaveInteger(AHUI_LevelData, abilityId, 0, levels)
    call SaveInteger(AHUI_LevelData, abilityId, 1, required)
    call SaveInteger(AHUI_LevelData, abilityId, 2, skip)
endfunction

// Object-editor values for every listed hero skill (unlearned skills have no
// ability handle, so these cannot be read at runtime). Regenerate with
// tools/build_ability_level_table.py after editing abilities.
private function AHUI_InitLevelTable takes nothing returns nothing
    // BEGIN GENERATED ABILITY LEVELS (tools/build_ability_level_table.py)
    call AHUI_SetLevelInfo('A0I7', 5, 1, 4)
    call AHUI_SetLevelInfo('A0I8', 5, 1, 4)
    call AHUI_SetLevelInfo('A0I9', 5, 6, 4)
    call AHUI_SetLevelInfo('A0IA', 5, 10, 4)
    call AHUI_SetLevelInfo('A0IB', 1, 25, 3)
    call AHUI_SetLevelInfo('A0IC', 1, 25, 3)
    call AHUI_SetLevelInfo('A0ID', 1, 12, 0)
    call AHUI_SetLevelInfo('A0IE', 1, 1, 0)
    call AHUI_SetLevelInfo('A0FH', 5, 1, 4)
    call AHUI_SetLevelInfo('A0FI', 5, 1, 4)
    call AHUI_SetLevelInfo('A0FJ', 1, 1, 4)
    call AHUI_SetLevelInfo('A0FK', 5, 1, 4)
    call AHUI_SetLevelInfo('A0FL', 5, 1, 4)
    call AHUI_SetLevelInfo('A0FM', 5, 1, 4)
    call AHUI_SetLevelInfo('A0FN', 1, 1, 4)
    call AHUI_SetLevelInfo('A0FO', 5, 6, 4)
    call AHUI_SetLevelInfo('A0FP', 5, 6, 4)
    call AHUI_SetLevelInfo('A0FQ', 1, 6, 4)
    call AHUI_SetLevelInfo('A0FR', 5, 10, 4)
    call AHUI_SetLevelInfo('A0FS', 5, 10, 0)
    call AHUI_SetLevelInfo('A0FT', 1, 25, 3)
    call AHUI_SetLevelInfo('A0FU', 1, 1, 4)
    call AHUI_SetLevelInfo('A0FV', 1, 1, 0)
    call AHUI_SetLevelInfo('A000', 5, 1, 4)
    call AHUI_SetLevelInfo('A001', 5, 1, 4)
    call AHUI_SetLevelInfo('A002', 5, 6, 4)
    call AHUI_SetLevelInfo('A003', 5, 10, 4)
    call AHUI_SetLevelInfo('A004', 1, 25, 0)
    call AHUI_SetLevelInfo('A005', 1, 25, 0)
    call AHUI_SetLevelInfo('A0GF', 1, 1, 4)
    call AHUI_SetLevelInfo('A0GD', 1, 1, 0)
    call AHUI_SetLevelInfo('A07R', 5, 1, 4)
    call AHUI_SetLevelInfo('A07S', 5, 1, 4)
    call AHUI_SetLevelInfo('A07T', 5, 6, 4)
    call AHUI_SetLevelInfo('A07U', 5, 10, 4)
    call AHUI_SetLevelInfo('A07V', 1, 25, 0)
    call AHUI_SetLevelInfo('A07W', 1, 1, 0)
    call AHUI_SetLevelInfo('A0E7', 5, 1, 4)
    call AHUI_SetLevelInfo('A0E8', 5, 1, 4)
    call AHUI_SetLevelInfo('A0E9', 5, 6, 4)
    call AHUI_SetLevelInfo('A0EA', 5, 10, 4)
    call AHUI_SetLevelInfo('A0EB', 1, 25, 0)
    call AHUI_SetLevelInfo('A0EC', 1, 25, 0)
    call AHUI_SetLevelInfo('A0EE', 1, 1, 0)
    call AHUI_SetLevelInfo('A0ED', 1, 1, 0)
    call AHUI_SetLevelInfo('A0EF', 1, 12, 0)
    call AHUI_SetLevelInfo('A050', 5, 1, 4)
    call AHUI_SetLevelInfo('A056', 5, 1, 4)
    call AHUI_SetLevelInfo('A051', 5, 1, 4)
    call AHUI_SetLevelInfo('A057', 5, 1, 4)
    call AHUI_SetLevelInfo('A052', 5, 6, 4)
    call AHUI_SetLevelInfo('A058', 5, 6, 4)
    call AHUI_SetLevelInfo('A114', 5, 6, 4)
    call AHUI_SetLevelInfo('A113', 1, 10, 0)
    call AHUI_SetLevelInfo('A053', 5, 10, 4)
    call AHUI_SetLevelInfo('A054', 1, 25, 0)
    call AHUI_SetLevelInfo('A05D', 1, 1, 0)
    call AHUI_SetLevelInfo('A05A', 1, 1, 0)
    call AHUI_SetLevelInfo('A05B', 1, 1, 0)
    call AHUI_SetLevelInfo('A05C', 1, 1, 0)
    call AHUI_SetLevelInfo('A059', 1, 25, 0)
    call AHUI_SetLevelInfo('A05E', 1, 25, 0)
    call AHUI_SetLevelInfo('A055', 1, 1, 0)
    call AHUI_SetLevelInfo('A0DY', 1, 25, 0)
    call AHUI_SetLevelInfo('A08M', 5, 1, 4)
    call AHUI_SetLevelInfo('A08N', 5, 1, 4)
    call AHUI_SetLevelInfo('A08O', 5, 6, 4)
    call AHUI_SetLevelInfo('A08P', 5, 10, 4)
    call AHUI_SetLevelInfo('A08Q', 1, 25, 3)
    call AHUI_SetLevelInfo('A08R', 1, 1, 0)
    call AHUI_SetLevelInfo('A0AM', 5, 1, 4)
    call AHUI_SetLevelInfo('A0AN', 5, 1, 4)
    call AHUI_SetLevelInfo('A0AO', 5, 6, 4)
    call AHUI_SetLevelInfo('A0AT', 5, 6, 4)
    call AHUI_SetLevelInfo('A0AP', 5, 10, 4)
    call AHUI_SetLevelInfo('A0AQ', 5, 10, 4)
    call AHUI_SetLevelInfo('A0AR', 1, 25, 3)
    call AHUI_SetLevelInfo('A0AS', 1, 12, 0)
    call AHUI_SetLevelInfo('A0B1', 5, 1, 4)
    call AHUI_SetLevelInfo('A0B2', 5, 1, 4)
    call AHUI_SetLevelInfo('A0B7', 1, 1, 4)
    call AHUI_SetLevelInfo('A0B3', 5, 6, 4)
    call AHUI_SetLevelInfo('A0BG', 1, 1, 4)
    call AHUI_SetLevelInfo('A0B4', 5, 10, 4)
    call AHUI_SetLevelInfo('A0B5', 1, 25, 3)
    call AHUI_SetLevelInfo('A0B6', 1, 25, 3)
    call AHUI_SetLevelInfo('A0B8', 4, 1, 0)
    call AHUI_SetLevelInfo('A0BH', 5, 1, 4)
    call AHUI_SetLevelInfo('A0BI', 5, 1, 4)
    call AHUI_SetLevelInfo('A0BJ', 5, 6, 4)
    call AHUI_SetLevelInfo('A0BQ', 5, 6, 4)
    call AHUI_SetLevelInfo('A0BP', 5, 10, 4)
    call AHUI_SetLevelInfo('A0BK', 5, 10, 4)
    call AHUI_SetLevelInfo('A0BN', 1, 10, 4)
    call AHUI_SetLevelInfo('A0BL', 1, 25, 3)
    call AHUI_SetLevelInfo('A0BM', 1, 25, 3)
    call AHUI_SetLevelInfo('A0F2', 1, 25, 0)
    call AHUI_SetLevelInfo('A0BO', 1, 1, 0)
    call AHUI_SetLevelInfo('A0DE', 5, 1, 4)
    call AHUI_SetLevelInfo('A0DF', 5, 1, 4)
    call AHUI_SetLevelInfo('A0DG', 5, 6, 4)
    call AHUI_SetLevelInfo('A0DH', 5, 10, 4)
    call AHUI_SetLevelInfo('A0DI', 1, 25, 0)
    call AHUI_SetLevelInfo('A0DK', 1, 25, 0)
    call AHUI_SetLevelInfo('A0DJ', 1, 12, 0)
    call AHUI_SetLevelInfo('A00E', 5, 1, 4)
    call AHUI_SetLevelInfo('A00F', 5, 1, 4)
    call AHUI_SetLevelInfo('A00G', 5, 6, 4)
    call AHUI_SetLevelInfo('A00H', 5, 10, 4)
    call AHUI_SetLevelInfo('A00N', 5, 10, 4)
    call AHUI_SetLevelInfo('A00I', 1, 25, 0)
    call AHUI_SetLevelInfo('A00O', 1, 25, 0)
    call AHUI_SetLevelInfo('A00L', 1, 12, 0)
    call AHUI_SetLevelInfo('A00J', 1, 1, 0)
    call AHUI_SetLevelInfo('A00K', 1, 1, 0)
    call AHUI_SetLevelInfo('A02V', 5, 1, 4)
    call AHUI_SetLevelInfo('A032', 5, 1, 4)
    call AHUI_SetLevelInfo('A037', 5, 1, 4)
    call AHUI_SetLevelInfo('A03C', 5, 1, 4)
    call AHUI_SetLevelInfo('A03H', 5, 1, 4)
    call AHUI_SetLevelInfo('A03N', 1, 1, 4)
    call AHUI_SetLevelInfo('A04A', 1, 1, 4)
    call AHUI_SetLevelInfo('A04F', 1, 1, 4)
    call AHUI_SetLevelInfo('A02W', 5, 1, 4)
    call AHUI_SetLevelInfo('A033', 5, 1, 4)
    call AHUI_SetLevelInfo('A038', 5, 1, 4)
    call AHUI_SetLevelInfo('A03D', 5, 1, 4)
    call AHUI_SetLevelInfo('A03I', 5, 1, 4)
    call AHUI_SetLevelInfo('A03O', 1, 1, 4)
    call AHUI_SetLevelInfo('A04B', 1, 1, 4)
    call AHUI_SetLevelInfo('A04G', 1, 1, 4)
    call AHUI_SetLevelInfo('A02X', 5, 6, 4)
    call AHUI_SetLevelInfo('A034', 5, 6, 4)
    call AHUI_SetLevelInfo('A039', 5, 6, 4)
    call AHUI_SetLevelInfo('A03E', 5, 6, 4)
    call AHUI_SetLevelInfo('A03J', 5, 6, 4)
    call AHUI_SetLevelInfo('A03P', 1, 6, 4)
    call AHUI_SetLevelInfo('A04C', 1, 6, 4)
    call AHUI_SetLevelInfo('A04H', 1, 6, 4)
    call AHUI_SetLevelInfo('A02Y', 5, 10, 4)
    call AHUI_SetLevelInfo('A035', 5, 1, 4)
    call AHUI_SetLevelInfo('A03A', 5, 1, 4)
    call AHUI_SetLevelInfo('A03F', 5, 1, 4)
    call AHUI_SetLevelInfo('A03K', 5, 1, 4)
    call AHUI_SetLevelInfo('A03Q', 1, 1, 4)
    call AHUI_SetLevelInfo('A04D', 1, 1, 4)
    call AHUI_SetLevelInfo('A04I', 1, 1, 4)
    call AHUI_SetLevelInfo('A02Z', 1, 25, 0)
    call AHUI_SetLevelInfo('A036', 1, 1, 3)
    call AHUI_SetLevelInfo('A03B', 1, 1, 3)
    call AHUI_SetLevelInfo('A03G', 1, 1, 3)
    call AHUI_SetLevelInfo('A03L', 1, 1, 3)
    call AHUI_SetLevelInfo('A03R', 1, 1, 3)
    call AHUI_SetLevelInfo('A04E', 1, 1, 3)
    call AHUI_SetLevelInfo('A04J', 1, 25, 0)
    call AHUI_SetLevelInfo('A030', 1, 1, 0)
    call AHUI_SetLevelInfo('A031', 1, 1, 0)
    call AHUI_SetLevelInfo('A049', 1, 1, 0)
    call AHUI_SetLevelInfo('A03M', 1, 1, 3)
    call AHUI_SetLevelInfo('A03S', 1, 1, 3)
    call AHUI_SetLevelInfo('A0EH', 5, 1, 4)
    call AHUI_SetLevelInfo('A0EI', 5, 1, 4)
    call AHUI_SetLevelInfo('A0EJ', 5, 6, 4)
    call AHUI_SetLevelInfo('A0EK', 5, 10, 4)
    call AHUI_SetLevelInfo('A0EL', 1, 25, 0)
    call AHUI_SetLevelInfo('A0EM', 1, 1, 0)
    call AHUI_SetLevelInfo('A0ES', 5, 1, 4)
    call AHUI_SetLevelInfo('A0F1', 5, 1, 4)
    call AHUI_SetLevelInfo('A0ET', 5, 1, 4)
    call AHUI_SetLevelInfo('A0EU', 1, 1, 4)
    call AHUI_SetLevelInfo('A0EV', 5, 6, 4)
    call AHUI_SetLevelInfo('A0EW', 5, 10, 4)
    call AHUI_SetLevelInfo('A0EX', 1, 25, 0)
    call AHUI_SetLevelInfo('A0EY', 1, 10, 4)
    call AHUI_SetLevelInfo('A0EZ', 2, 1, 0)
    call AHUI_SetLevelInfo('A06V', 5, 1, 4)
    call AHUI_SetLevelInfo('A06W', 5, 1, 4)
    call AHUI_SetLevelInfo('A06X', 5, 6, 4)
    call AHUI_SetLevelInfo('A06Y', 5, 10, 4)
    call AHUI_SetLevelInfo('A06Z', 1, 25, 0)
    call AHUI_SetLevelInfo('A070', 1, 35, 0)
    call AHUI_SetLevelInfo('A01J', 5, 1, 4)
    call AHUI_SetLevelInfo('A01L', 1, 1, 4)
    call AHUI_SetLevelInfo('A01Q', 5, 1, 4)
    call AHUI_SetLevelInfo('A01K', 5, 1, 4)
    call AHUI_SetLevelInfo('A01M', 1, 1, 4)
    call AHUI_SetLevelInfo('A01R', 5, 1, 4)
    call AHUI_SetLevelInfo('A01N', 5, 6, 0)
    call AHUI_SetLevelInfo('A01O', 1, 6, 4)
    call AHUI_SetLevelInfo('A01P', 5, 10, 4)
    call AHUI_SetLevelInfo('A01S', 5, 10, 4)
    call AHUI_SetLevelInfo('A01X', 1, 25, 0)
    call AHUI_SetLevelInfo('A01T', 1, 25, 0)
    call AHUI_SetLevelInfo('A01U', 1, 1, 0)
    call AHUI_SetLevelInfo('A09Q', 1, 6, 3)
    call AHUI_SetLevelInfo('A05I', 5, 1, 4)
    call AHUI_SetLevelInfo('A05N', 5, 1, 4)
    call AHUI_SetLevelInfo('A05O', 5, 1, 4)
    call AHUI_SetLevelInfo('A05J', 5, 1, 4)
    call AHUI_SetLevelInfo('A05P', 5, 1, 4)
    call AHUI_SetLevelInfo('A05Q', 5, 1, 4)
    call AHUI_SetLevelInfo('A05K', 5, 6, 4)
    call AHUI_SetLevelInfo('A05R', 5, 6, 4)
    call AHUI_SetLevelInfo('A05S', 5, 1, 4)
    call AHUI_SetLevelInfo('A05L', 5, 10, 4)
    call AHUI_SetLevelInfo('A05T', 5, 10, 4)
    call AHUI_SetLevelInfo('A05M', 1, 25, 0)
    call AHUI_SetLevelInfo('A05V', 1, 1, 0)
    call AHUI_SetLevelInfo('A05W', 1, 1, 0)
    call AHUI_SetLevelInfo('A05U', 1, 1, 0)
    call AHUI_SetLevelInfo('A0CD', 5, 1, 4)
    call AHUI_SetLevelInfo('A0CE', 1, 1, 4)
    call AHUI_SetLevelInfo('A0CF', 5, 1, 4)
    call AHUI_SetLevelInfo('A0CG', 1, 1, 4)
    call AHUI_SetLevelInfo('A0CH', 5, 6, 4)
    call AHUI_SetLevelInfo('A0CI', 1, 6, 4)
    call AHUI_SetLevelInfo('A0CJ', 1, 6, 4)
    call AHUI_SetLevelInfo('A0CK', 5, 10, 4)
    call AHUI_SetLevelInfo('A0CL', 1, 25, 0)
    call AHUI_SetLevelInfo('A0CM', 1, 1, 4)
    call AHUI_SetLevelInfo('A0CN', 1, 1, 4)
    call AHUI_SetLevelInfo('A021', 5, 1, 4)
    call AHUI_SetLevelInfo('A022', 5, 1, 4)
    call AHUI_SetLevelInfo('A023', 5, 6, 4)
    call AHUI_SetLevelInfo('A024', 5, 10, 4)
    call AHUI_SetLevelInfo('A025', 1, 25, 0)
    call AHUI_SetLevelInfo('A027', 1, 1, 0)
    call AHUI_SetLevelInfo('A026', 1, 1, 0)
    call AHUI_SetLevelInfo('A01F', 5, 1, 4)
    call AHUI_SetLevelInfo('A05F', 5, 1, 4)
    call AHUI_SetLevelInfo('A05G', 5, 1, 4)
    call AHUI_SetLevelInfo('A029', 5, 6, 4)
    call AHUI_SetLevelInfo('A02A', 5, 10, 4)
    call AHUI_SetLevelInfo('A02B', 1, 25, 0)
    call AHUI_SetLevelInfo('A02C', 1, 1, 0)
    call AHUI_SetLevelInfo('A115', 1, 1, 0)
    call AHUI_SetLevelInfo('A02F', 3, 12, 0)
    call AHUI_SetLevelInfo('A05Z', 5, 1, 4)
    call AHUI_SetLevelInfo('A067', 5, 1, 4)
    call AHUI_SetLevelInfo('A068', 1, 1, 4)
    call AHUI_SetLevelInfo('A060', 5, 1, 4)
    call AHUI_SetLevelInfo('A069', 5, 1, 4)
    call AHUI_SetLevelInfo('A06A', 1, 1, 4)
    call AHUI_SetLevelInfo('A09S', 5, 6, 4)
    call AHUI_SetLevelInfo('A09T', 1, 1, 0)
    call AHUI_SetLevelInfo('A061', 5, 6, 0)
    call AHUI_SetLevelInfo('A06U', 5, 6, 3)
    call AHUI_SetLevelInfo('A06D', 1, 1, 4)
    call AHUI_SetLevelInfo('A062', 5, 10, 4)
    call AHUI_SetLevelInfo('A06B', 5, 10, 4)
    call AHUI_SetLevelInfo('A06C', 1, 10, 4)
    call AHUI_SetLevelInfo('A063', 1, 25, 0)
    call AHUI_SetLevelInfo('A064', 1, 25, 0)
    call AHUI_SetLevelInfo('A06E', 1, 6, 3)
    call AHUI_SetLevelInfo('A065', 1, 1, 0)
    call AHUI_SetLevelInfo('A066', 1, 1, 0)
    call AHUI_SetLevelInfo('A077', 5, 1, 4)
    call AHUI_SetLevelInfo('A078', 5, 1, 4)
    call AHUI_SetLevelInfo('A079', 5, 6, 4)
    call AHUI_SetLevelInfo('A07A', 5, 10, 4)
    call AHUI_SetLevelInfo('A07B', 1, 25, 0)
    call AHUI_SetLevelInfo('A07C', 1, 1, 0)
    call AHUI_SetLevelInfo('A082', 5, 1, 4)
    call AHUI_SetLevelInfo('A08C', 1, 1, 4)
    call AHUI_SetLevelInfo('A083', 5, 1, 0)
    call AHUI_SetLevelInfo('A084', 5, 1, 4)
    call AHUI_SetLevelInfo('A08D', 1, 1, 4)
    call AHUI_SetLevelInfo('A085', 5, 6, 4)
    call AHUI_SetLevelInfo('A08E', 1, 1, 4)
    call AHUI_SetLevelInfo('A086', 5, 10, 4)
    call AHUI_SetLevelInfo('A08F', 1, 1, 4)
    call AHUI_SetLevelInfo('A087', 1, 25, 0)
    call AHUI_SetLevelInfo('A088', 1, 25, 0)
    call AHUI_SetLevelInfo('A08G', 1, 1, 3)
    call AHUI_SetLevelInfo('A089', 1, 12, 0)
    call AHUI_SetLevelInfo('A08A', 1, 1, 0)
    call AHUI_SetLevelInfo('A08B', 1, 1, 0)
    call AHUI_SetLevelInfo('A08H', 1, 1, 0)
    call AHUI_SetLevelInfo('A08S', 5, 1, 4)
    call AHUI_SetLevelInfo('A08Z', 5, 1, 4)
    call AHUI_SetLevelInfo('A093', 1, 1, 4)
    call AHUI_SetLevelInfo('A095', 1, 1, 4)
    call AHUI_SetLevelInfo('A08T', 5, 1, 4)
    call AHUI_SetLevelInfo('A090', 5, 1, 4)
    call AHUI_SetLevelInfo('A096', 1, 1, 4)
    call AHUI_SetLevelInfo('A08U', 5, 6, 4)
    call AHUI_SetLevelInfo('A091', 5, 6, 4)
    call AHUI_SetLevelInfo('A097', 1, 1, 4)
    call AHUI_SetLevelInfo('A08V', 5, 10, 4)
    call AHUI_SetLevelInfo('A092', 5, 10, 4)
    call AHUI_SetLevelInfo('A098', 1, 1, 4)
    call AHUI_SetLevelInfo('A08W', 1, 25, 0)
    call AHUI_SetLevelInfo('A08X', 2, 1, 0)
    call AHUI_SetLevelInfo('A099', 1, 1, 0)
    call AHUI_SetLevelInfo('A08Y', 1, 1, 0)
    call AHUI_SetLevelInfo('A09A', 1, 1, 0)
    call AHUI_SetLevelInfo('A09D', 5, 1, 4)
    call AHUI_SetLevelInfo('A09E', 1, 1, 4)
    call AHUI_SetLevelInfo('A09F', 5, 1, 4)
    call AHUI_SetLevelInfo('A09G', 5, 6, 4)
    call AHUI_SetLevelInfo('A09H', 5, 10, 4)
    call AHUI_SetLevelInfo('A09I', 1, 25, 3)
    call AHUI_SetLevelInfo('A09J', 1, 1, 0)
    call AHUI_SetLevelInfo('A0CO', 1, 1, 4)
    call AHUI_SetLevelInfo('A09V', 5, 1, 4)
    call AHUI_SetLevelInfo('A0A3', 5, 1, 4)
    call AHUI_SetLevelInfo('A0AA', 1, 1, 4)
    call AHUI_SetLevelInfo('A09W', 5, 1, 4)
    call AHUI_SetLevelInfo('A0A4', 5, 1, 4)
    call AHUI_SetLevelInfo('A0AB', 1, 1, 4)
    call AHUI_SetLevelInfo('A09Y', 5, 6, 4)
    call AHUI_SetLevelInfo('A0A5', 5, 6, 4)
    call AHUI_SetLevelInfo('A0AD', 1, 6, 4)
    call AHUI_SetLevelInfo('A0AC', 1, 6, 4)
    call AHUI_SetLevelInfo('A0AE', 1, 6, 4)
    call AHUI_SetLevelInfo('A0A0', 5, 10, 4)
    call AHUI_SetLevelInfo('A0A6', 5, 10, 4)
    call AHUI_SetLevelInfo('A0AF', 1, 10, 4)
    call AHUI_SetLevelInfo('A09Z', 1, 18, 3)
    call AHUI_SetLevelInfo('A0A7', 1, 25, 3)
    call AHUI_SetLevelInfo('A0AG', 1, 25, 3)
    call AHUI_SetLevelInfo('A0A1', 1, 1, 0)
    call AHUI_SetLevelInfo('A0A8', 1, 1, 0)
    call AHUI_SetLevelInfo('A0AH', 1, 1, 0)
    call AHUI_SetLevelInfo('A0A2', 1, 1, 0)
    call AHUI_SetLevelInfo('A0A9', 1, 1, 0)
    call AHUI_SetLevelInfo('A0AI', 1, 1, 0)
    call AHUI_SetLevelInfo('A0C0', 5, 1, 4)
    call AHUI_SetLevelInfo('A0C1', 5, 1, 4)
    call AHUI_SetLevelInfo('A0C2', 5, 1, 4)
    call AHUI_SetLevelInfo('A0C4', 5, 6, 4)
    call AHUI_SetLevelInfo('A0C5', 5, 10, 4)
    call AHUI_SetLevelInfo('A0C3', 5, 1, 4)
    call AHUI_SetLevelInfo('A0C6', 1, 25, 3)
    call AHUI_SetLevelInfo('A0C7', 1, 25, 3)
    call AHUI_SetLevelInfo('A0C8', 1, 12, 0)
    call AHUI_SetLevelInfo('A0C9', 1, 1, 0)
    call AHUI_SetLevelInfo('A0D3', 5, 1, 4)
    call AHUI_SetLevelInfo('A0D4', 5, 1, 4)
    call AHUI_SetLevelInfo('A0D5', 5, 6, 4)
    call AHUI_SetLevelInfo('A0E2', 1, 6, 4)
    call AHUI_SetLevelInfo('A0D6', 5, 10, 4)
    call AHUI_SetLevelInfo('A0D7', 1, 10, 4)
    call AHUI_SetLevelInfo('A0D8', 1, 25, 3)
    call AHUI_SetLevelInfo('A0D9', 1, 25, 3)
    call AHUI_SetLevelInfo('A0DA', 1, 1, 0)
    call AHUI_SetLevelInfo('A0DB', 1, 1, 0)
    call AHUI_SetLevelInfo('A0E3', 2, 6, 4)
    call AHUI_SetLevelInfo('A0DL', 5, 1, 4)
    call AHUI_SetLevelInfo('A0DS', 1, 1, 4)
    call AHUI_SetLevelInfo('A0DM', 5, 1, 4)
    call AHUI_SetLevelInfo('A0DT', 1, 1, 4)
    call AHUI_SetLevelInfo('A0DN', 5, 6, 4)
    call AHUI_SetLevelInfo('A0DO', 5, 10, 4)
    call AHUI_SetLevelInfo('A0DU', 1, 12, 4)
    call AHUI_SetLevelInfo('A0DP', 1, 25, 0)
    call AHUI_SetLevelInfo('A0DV', 1, 25, 0)
    call AHUI_SetLevelInfo('A0DR', 1, 1, 4)
    call AHUI_SetLevelInfo('A0DQ', 1, 1, 0)
    call AHUI_SetLevelInfo('A0GK', 5, 1, 4)
    call AHUI_SetLevelInfo('A0GL', 5, 1, 4)
    call AHUI_SetLevelInfo('A0GM', 1, 1, 4)
    call AHUI_SetLevelInfo('A0GN', 5, 1, 4)
    call AHUI_SetLevelInfo('A0GO', 1, 1, 4)
    call AHUI_SetLevelInfo('A0GP', 5, 6, 4)
    call AHUI_SetLevelInfo('A0GQ', 5, 10, 4)
    call AHUI_SetLevelInfo('A0GR', 1, 25, 3)
    call AHUI_SetLevelInfo('A0GT', 1, 25, 3)
    call AHUI_SetLevelInfo('A0GW', 1, 1, 0)
    call AHUI_SetLevelInfo('A0GV', 1, 1, 4)
    call AHUI_SetLevelInfo('A0GU', 1, 1, 0)
    call AHUI_SetLevelInfo('A0GY', 5, 1, 4)
    call AHUI_SetLevelInfo('A0GZ', 5, 1, 4)
    call AHUI_SetLevelInfo('A0H0', 5, 1, 4)
    call AHUI_SetLevelInfo('A0H1', 5, 1, 4)
    call AHUI_SetLevelInfo('A0H2', 5, 1, 4)
    call AHUI_SetLevelInfo('A0H3', 5, 6, 4)
    call AHUI_SetLevelInfo('A0H4', 5, 10, 4)
    call AHUI_SetLevelInfo('A0H5', 1, 25, 0)
    call AHUI_SetLevelInfo('A0H6', 1, 1, 4)
    call AHUI_SetLevelInfo('A0H7', 1, 1, 0)
    call AHUI_SetLevelInfo('A0H8', 1, 1, 0)
    call AHUI_SetLevelInfo('A0HG', 5, 1, 4)
    call AHUI_SetLevelInfo('A0HH', 5, 1, 4)
    call AHUI_SetLevelInfo('A0HI', 5, 1, 4)
    call AHUI_SetLevelInfo('A0HJ', 5, 6, 4)
    call AHUI_SetLevelInfo('A0HK', 5, 10, 4)
    call AHUI_SetLevelInfo('A0HL', 1, 25, 3)
    call AHUI_SetLevelInfo('A0HM', 1, 25, 3)
    call AHUI_SetLevelInfo('A0HN', 1, 1, 0)
    call AHUI_SetLevelInfo('A0HO', 1, 1, 0)
    // END GENERATED ABILITY LEVELS
endfunction

// Level count: object data first, then the live ability, else one level.
private function AHUI_MaxLevel takes unit hero, integer abilityId returns integer
    local integer levels = 0
    if abilityId == 0 then
        return 0
    endif
    if HaveSavedInteger(AHUI_LevelData, abilityId, 0) then
        set levels = LoadInteger(AHUI_LevelData, abilityId, 0)
    endif
    if levels < 1 then
        return 1
    elseif levels > AHUI_MAX_PIPS then
        return AHUI_MAX_PIPS
    endif
    return levels
endfunction

// Hero level needed for skill level `level` (1-based), Warcraft's formula:
// required + (level - 1) * skip, where skip 0 means the gameplay constant.
private function AHUI_RequiredHeroLevel takes integer abilityId, integer level returns integer
    local integer required = 1
    local integer skip = AHUI_DEFAULT_LEVEL_SKIP
    if HaveSavedInteger(AHUI_LevelData, abilityId, 1) then
        set required = IMaxBJ(1, LoadInteger(AHUI_LevelData, abilityId, 1))
        if LoadInteger(AHUI_LevelData, abilityId, 2) > 0 then
            set skip = LoadInteger(AHUI_LevelData, abilityId, 2)
        endif
    endif
    return required + IMaxBJ(0, level - 1) * skip
endfunction

private function AHUI_IsLearnableSkill takes integer abilityId returns boolean
    return abilityId != 0 and HaveSavedInteger(AHUI_LevelData, abilityId, 0)
endfunction

// True when one more level could be learned right now.
private function AHUI_CanLearn takes unit hero, integer abilityId returns boolean
    local integer level = 0
    if hero == null or not AHUI_IsLearnableSkill(abilityId) or GetHeroSkillPoints(hero) <= 0 then
        return false
    endif
    set level = GetUnitAbilityLevel(hero, abilityId)
    if level >= AHUI_MaxLevel(hero, abilityId) then
        return false
    endif
    return GetHeroLevel(hero) >= AHUI_RequiredHeroLevel(abilityId, level + 1)
endfunction

// "Lv 1 · 5 · 9 · 13 · 17" with learned levels gold, the next one green when
// learnable now, and locked ones grey.
private function AHUI_LevelSchedule takes unit hero, integer abilityId returns string
    local integer maximum = AHUI_MaxLevel(hero, abilityId)
    local integer level = GetUnitAbilityLevel(hero, abilityId)
    local integer k = 1
    local integer need = 0
    local string result = "|cff9aa0a8Hero level:|r "
    loop
        exitwhen k > maximum
        set need = AHUI_RequiredHeroLevel(abilityId, k)
        if k > 1 then
            set result = result + " |cff5a5e66·|r "
        endif
        if k <= level then
            set result = result + "|cffd5b876" + I2S(need) + "|r"
        elseif k == level + 1 and GetHeroLevel(hero) >= need then
            set result = result + "|cff7ee870" + I2S(need) + "|r"
        else
            set result = result + "|cff7a7e86" + I2S(need) + "|r"
        endif
        set k = k + 1
    endloop
    return result
endfunction

// Synced: runs on every client from a frame click. Uses only global state.
private function AHUI_TryLearn takes unit hero, integer slot returns nothing
    local integer abilityId = 0
    if hero == null or slot < 0 or slot >= AHUI_LEARN_SLOTS or GetHeroSkillPoints(hero) <= 0 then
        return
    endif
    call AHUI_ClearResolvedAbilities()
    set AHUI_AllowCooldownRead = false
    call AHUI_ConfigureHeroAbilities(hero)
    set abilityId = AHUI_BaseAbility[slot]
    if AHUI_CurrentAbility[slot] != abilityId and GetUnitTypeId(hero) != Rimuru_ID then
        return
    endif
    if AHUI_CanLearn(hero, abilityId) then
        call SelectHeroSkill(hero, abilityId)
    endif
endfunction

private function AHUI_OnLearnClick takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local player whichPlayer = GetTriggerPlayer()
    local integer pid = GetPlayerId(whichPlayer)
    local integer slot = 0
    local unit hero = Hero[pid]
    if hero != null and GetOwningPlayer(hero) == whichPlayer then
        loop
            exitwhen slot >= AHUI_LEARN_SLOTS
            if clicked == AHUI_LearnButton[slot] then
                call AHUI_TryLearn(hero, slot)
                exitwhen true
            endif
            set slot = slot + 1
        endloop
    endif
    set clicked = null
    set whichPlayer = null
    set hero = null
    call WUI_ResetClickedButtonFocus()
endfunction

private function AHUI_HideLearning takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i >= AHUI_PIP_SLOTS * AHUI_MAX_PIPS
        if AHUI_PipTexture[i] != null then
            call BlzFrameSetVisible(AHUI_Pip[i], false)
            set AHUI_PipTexture[i] = null
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= AHUI_PIP_SLOTS
        set AHUI_PipMax[i] = 0
        if i < AHUI_LEARN_SLOTS then
            call BlzFrameSetVisible(AHUI_LearnButton[i], false)
            call BlzFrameSetVisible(AHUI_ReqText[i], false)
        endif
        set i = i + 1
    endloop
endfunction

// Local presentation only (caller guarantees GetLocalPlayer() == Player(pid)).
// Requires AHUI_BaseAbility resolved for AHUI_SelectedHero[pid] this tick.
private function AHUI_RefreshLearning takes integer pid returns nothing
    local unit hero = AHUI_SelectedHero[pid]
    local boolean ownMain = false
    local boolean hasPoints = false
    local boolean learnable = false
    local boolean replaced = false
    local integer slot = 0
    local integer k = 0
    local integer index = 0
    local integer abilityId = 0
    local integer level = 0
    local integer maximum = 0
    local integer need = 0
    local string texture = null
    if hero == null then
        call AHUI_HideLearning()
        return
    endif
    // Learning targets the player's own main hero, exactly like the click handler.
    set ownMain = hero == Hero[pid] and GetOwningPlayer(hero) == Player(pid)
    set hasPoints = ownMain and GetHeroSkillPoints(hero) > 0
    loop
        exitwhen slot >= AHUI_PIP_SLOTS
        set abilityId = AHUI_BaseAbility[slot]
        set replaced = false
        // Evolution removes the base spells; pips describe the displayed replacement.
        if GetUnitTypeId(hero) == Rimuru_ID and AHUI_CurrentAbility[slot] != 0 then
            set abilityId = AHUI_CurrentAbility[slot]
        elseif AHUI_CurrentAbility[slot] != 0 and AHUI_CurrentAbility[slot] != abilityId then
            // A temporary replacement occupies the slot: no learning until it returns.
            set replaced = true
        endif
        set level = 0
        set maximum = 0
        set learnable = false
        if abilityId != 0 then
            set level = GetUnitAbilityLevel(hero, abilityId)
            set maximum = AHUI_MaxLevel(hero, abilityId)
            set learnable = hasPoints and not replaced and slot < AHUI_LEARN_SLOTS and AHUI_CanLearn(hero, abilityId)
        endif
        // A changed level count re-centres the whole pip row.
        if AHUI_PipMax[slot] != maximum then
            set k = 0
            loop
                exitwhen k >= AHUI_MAX_PIPS
                set index = slot * AHUI_MAX_PIPS + k
                if AHUI_PipTexture[index] != null then
                    call WUI_Show(AHUI_Pip[index], false)
                    set AHUI_PipTexture[index] = null
                endif
                set k = k + 1
            endloop
            set AHUI_PipMax[slot] = maximum
        endif
        set k = 0
        loop
            exitwhen k >= AHUI_MAX_PIPS
            set index = slot * AHUI_MAX_PIPS + k
            if k < maximum then
                if k < level then
                    set texture = "UI\\WOS\\pip-full.tga"
                elseif k == level and learnable then
                    set texture = "UI\\WOS\\pip-ready.tga"
                else
                    set texture = "UI\\WOS\\pip-empty.tga"
                endif
                if AHUI_PipTexture[index] != texture then
                    if AHUI_PipTexture[index] == null then
                        call BlzFrameClearAllPoints(AHUI_Pip[index])
                        call BlzFrameSetAbsPoint(AHUI_Pip[index], FRAMEPOINT_CENTER, WUI_AbilityX(slot) + (I2R(k) - I2R(maximum - 1) * 0.50) * AHUI_PIP_STEP, WUI_PIP_Y)
                        call WUI_Show(AHUI_Pip[index], true)
                    endif
                    call BlzFrameSetTexture(AHUI_Pip[index], texture, 0, true)
                    set AHUI_PipTexture[index] = texture
                endif
            elseif AHUI_PipTexture[index] != null then
                call WUI_Show(AHUI_Pip[index], false)
                set AHUI_PipTexture[index] = null
            endif
            set k = k + 1
        endloop
        if slot < AHUI_LEARN_SLOTS then
            // The strip is the click target for learning; its glow appears only
            // while a skill point can actually be spent on this skill.
            // Glow is a child of the button: hide it directly (a hidden button would skip it).
            if learnable then
                call WUI_Show(AHUI_LearnGlow[slot], true)
            else
                call BlzFrameSetVisible(AHUI_LearnGlow[slot], false)
            endif
            call WUI_Show(AHUI_LearnButton[slot], ownMain and not replaced and AHUI_IsLearnableSkill(abilityId))
            // Locked next level: show the hero level that unlocks it.
            set need = 0
            if ownMain and not replaced and AHUI_IsLearnableSkill(abilityId) and level < maximum then
                set need = AHUI_RequiredHeroLevel(abilityId, level + 1)
                if GetHeroLevel(hero) >= need then
                    set need = 0
                endif
            endif
            if need > 0 then
                call WUI_SetText(AHUI_ReqText[slot], "|cff8a8f98Lv " + I2S(need) + "|r")
            endif
            call WUI_Show(AHUI_ReqText[slot], need > 0)
        endif
        set slot = slot + 1
    endloop
    set hero = null
    set texture = null
endfunction

private function AHUI_FormatCooldown takes real remaining returns string
    local integer seconds = R2I(remaining)
    if I2R(seconds) < remaining then
        set seconds = seconds + 1
    endif
    return I2S(IMaxBJ(0, seconds))
endfunction

private function AHUI_HideTooltip takes integer pid returns nothing
    call AR_Hide(pid)
    // Checkpoint 27d: called every tick while nothing is hovered - only act
    // when the tooltip is actually shown.
    set AHUI_TooltipKey[pid] = ""
    set AHUI_TipShown[pid] = 0
    if AHUI_TooltipRoot[pid] == null or not BlzFrameIsVisible(AHUI_TooltipRoot[pid]) then
        return
    endif
    call BlzFrameSetVisible(AHUI_TooltipRoot[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipBackdrop[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipTitle[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipText[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipManaIcon[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipManaText[pid], false)
    call BlzFrameSetVisible(AHUI_TooltipSeparator[pid], false)
endfunction

// Key letter in the stock hotkey style: white letter on a small dark square.
private function AHUI_ShowKey takes integer index, boolean visible returns nothing
    if AHUI_KeyBox[index] != null then
        call WUI_Show(AHUI_KeyBox[index], visible)
    endif
    call WUI_Show(AHUI_KeyText[index], visible)
endfunction

// Cached setters for AHUI_RefreshSlot (local). State 1 = hidden, 2 = shown.
private function AHUI_ShowPart takes integer index, integer part, framehandle frame, boolean visible returns nothing
    local integer state = 1
    if visible then
        set state = 2
    endif
    if AHUI_PartState[index * 5 + part] != state then
        set AHUI_PartState[index * 5 + part] = state
        call BlzFrameSetVisible(frame, visible)
    endif
endfunction

private function AHUI_SetIconAlpha takes integer index, integer alpha returns nothing
    if AHUI_IconAlphaSet[index] != alpha + 1 then
        set AHUI_IconAlphaSet[index] = alpha + 1
        call BlzFrameSetAlpha(AHUI_Icon[index], alpha)
    endif
endfunction

private function AHUI_SetFillAlpha takes integer index, integer alpha returns nothing
    if AHUI_FillAlphaSet[index] != alpha + 1 then
        set AHUI_FillAlphaSet[index] = alpha + 1
        call BlzFrameSetAlpha(AHUI_CooldownFill[index], alpha)
    endif
endfunction

private function AHUI_HideSlot takes integer pid, integer slot returns nothing
    local integer index = AHUI_FrameIndex(pid, slot)
    local boolean changed = AHUI_SlotVisible[index] or AHUI_RenderedAbility[index] != 0

    set AHUI_RenderedAbility[index] = 0
    set AHUI_RenderedIconPath[index] = null
    set AHUI_SlotVisible[index] = false
    set AHUI_NativeCommandShown[index] = false
    call WUI_Show(AHUI_PausedText[index], false)
    set AHUI_CooldownPeak[index] = 0.00
    set AHUI_LastRemaining[index] = 0.00
    set AHUI_CooldownTicks[index] = 0

    // Функция вызывается только из локальной ветки соответствующего pid.
    // Children first, the root last: a child hidden under an already hidden root
    // kept its own flag and came back stale (old icon / key) with the root.
    if AHUI_ToggleGlowShown[index] then
        set AHUI_ToggleGlowShown[index] = false
        call BlzFrameSetVisible(AHUI_ToggleGlow[index], false)
    endif
    if changed then
        call BlzFrameSetVisible(AHUI_Icon[index], false)
        call BlzFrameSetVisible(AHUI_CooldownFill[index], false)
        call BlzFrameSetVisible(AHUI_CooldownText[index], false)
        if AHUI_KeyBox[index] != null then
            call BlzFrameSetVisible(AHUI_KeyBox[index], false)
        endif
        call BlzFrameSetVisible(AHUI_KeyText[index], false)
        call BlzFrameSetVisible(AHUI_ChargeBox[index], false)
    endif
    call WUI_Show(AHUI_Root[index], false)
    // WUI_Show may skip the root under a hidden HUD: its real flag is unknown now.
    set AHUI_PartState[index * 5] = 0
    if changed then
        call BlzFrameSetAlpha(AHUI_Icon[index], AHUI_READY_ALPHA)
        call BlzFrameSetAlpha(AHUI_CooldownFill[index], 255)
        call BlzFrameSetAlpha(AHUI_CooldownText[index], 255)
        call BlzFrameSetAlpha(AHUI_KeyText[index], 255)
        set AHUI_PartState[index * 5 + 1] = 1
        set AHUI_PartState[index * 5 + 2] = 1
        set AHUI_PartState[index * 5 + 3] = 1
        set AHUI_PartState[index * 5 + 4] = 1
        set AHUI_IconAlphaSet[index] = AHUI_READY_ALPHA + 1
        set AHUI_FillAlphaSet[index] = 256
    endif

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

// F/G passives unlock at their object "Required level" (arlv, generated
// table): below it the slot is drawn like an unlearned skill (DISBTN). Runs
// locally, so no ability handle is requested here.
private function AHUI_PassiveLocked takes unit hero, integer slot, integer abilityId returns boolean
    if slot < AHUI_SLOT_F or abilityId == 0 or hero == null or not HaveSavedInteger(AHUI_LevelData, abilityId, 1) then
        return false
    endif
    return GetHeroLevel(hero) < LoadInteger(AHUI_LevelData, abilityId, 1)
endfunction

private function AHUI_RefreshSlot takes integer pid, integer slot returns nothing
    local integer index = AHUI_FrameIndex(pid, slot)
    local integer abilityId = AHUI_CurrentAbility[slot]
    local integer level = 0
    local real remaining = 0.00
    local real progress = 0.00
    local string iconPath = null
    local string charge = ""
    local boolean ownHero = GetOwningPlayer(AHUI_SelectedHero[pid]) == Player(pid)

    if GetLocalPlayer() != Player(pid) then
        return
    endif

    set AHUI_NativeCommandShown[index] = false

    // Own row: learned skills are Warcraft's native commands. A skill that is
    // not learned yet is previewed as its dimmed icon (no native button exists
    // for it), so the whole kit is visible from level 1.
    if ownHero then
        if abilityId != 0 then
            set level = GetUnitAbilityLevel(AHUI_SelectedHero[pid], abilityId)
        endif
        if level > 0 and (AHUI_PassiveLocked(AHUI_SelectedHero[pid], slot, abilityId) or AHUI_RequirementLocked(AHUI_SelectedHero[pid], abilityId)) then
            set level = 0
        endif
        // Checkpoint 22: while the stock command card is hidden (hero pick /
        // draft) or the player edits hotkeys, learned skills are drawn here
        // too, so the full kit stays visible and clickable slots are ours.
        // A slot with a custom hotkey is drawn here as well, so the stock
        // key letter disappears and the new key is shown on the icon.
        // Checkpoint 24: the stock button is used only when it really sits in
        // this slot's command-card cell; skills placed elsewhere (Gojo F,
        // Inori G...) are drawn here, otherwise the slot stayed empty.
        if (abilityId == 0 or (level > 0 and (slot < AHUI_SLOT_F or (BlzGetAbilityPosX(abilityId) == AHUI_GetSlotX(slot) and BlzGetAbilityPosY(abilityId) == AHUI_GetSlotY(slot))))) and not IsUnitType(AHUI_SelectedHero[pid], UNIT_TYPE_DEAD) and not WUI_NativeCommandsHidden() and not WUI_IsHotkeyEditing() and WUI_SlotKeyLabel(pid, slot) == "" and not IsUnitPaused(AHUI_SelectedHero[pid]) then
            if slot >= AHUI_SLOT_F and AHUI_RenderedAbility[index] == -2 and abilityId != 0 and level > 0 and AHUI_IsActiveSlotCandidate(AHUI_SelectedHero[pid], GetOwningPlayer(AHUI_SelectedHero[pid]), abilityId) then
                // Same F/G key badge over the live stock button as on the last
                // refresh: no hide + re-show of the whole slot every 0.25 s.
                set AHUI_SlotVisible[index] = true
                set AHUI_NativeCommandShown[index] = true
                call WUI_SetSlotCustomShown(slot, false)
                call WUI_ShowNativeAbilitySlot(slot, true)
                call AHUI_ShowPart(index, 0, AHUI_Root[index], true)
                call AHUI_ShowKey(index, true)
                return
            endif
            call AHUI_HideSlot(pid, slot)
            call WUI_SetSlotCustomShown(slot, false)
            set AHUI_NativeCommandShown[index] = abilityId != 0 and AHUI_IsActiveSlotCandidate(AHUI_SelectedHero[pid], GetOwningPlayer(AHUI_SelectedHero[pid]), abilityId)
            call WUI_ShowNativeAbilitySlot(slot, AHUI_NativeCommandShown[index])
            if abilityId != 0 and level > 0 and AHUI_IsActiveSlotCandidate(AHUI_SelectedHero[pid], GetOwningPlayer(AHUI_SelectedHero[pid]), abilityId) then
                // Over a live stock button only the F/G key letter is ours: the
                // stock Tas box already shows the counter (no second copy) and
                // the pause chains are cleared once the unit is unpaused.
                if slot >= AHUI_SLOT_F then
                    call AHUI_ShowPart(index, 0, AHUI_Root[index], true)
                    // F/G stock buttons sit outside the stock hotkey grid: draw the WOS key badge.
                    // SlotVisible lets the next HideSlot really hide this root and badge.
                    set AHUI_SlotVisible[index] = true
                    // -2: key badge state, kept by the fast path above.
                    set AHUI_RenderedAbility[index] = -2
                    call AHUI_ShowKey(index, true)
                    call AHUI_ShowPart(index, 4, AHUI_ChargeBox[index], false)
                    call WUI_Show(AHUI_PausedText[index], false)
                endif
            endif
            return
        endif
        call WUI_SetSlotCustomShown(slot, abilityId != 0 and level > 0)
        call WUI_ShowNativeAbilitySlot(slot, false)
    endif

    if abilityId == 0 then
        // -1: empty-slot placeholder already drawn; only the first refresh
        // clears the slot and sets the texture.
        if AHUI_RenderedAbility[index] != -1 or not AHUI_SlotVisible[index] then
            call AHUI_HideSlot(pid, slot)
            call BlzFrameSetTexture(AHUI_Icon[index], "UI\\WOS\\disabled.tga", 0, true)
            set AHUI_RenderedAbility[index] = -1
        endif
        call AHUI_SetIconAlpha(index, 255)
        set AHUI_SlotVisible[index] = true
        call AHUI_ShowPart(index, 0, AHUI_Root[index], true)
        call AHUI_ShowPart(index, 1, AHUI_Icon[index], true)
        call AHUI_ShowKey(index, true)
        if ownHero then
            call WUI_ShowNativeAbilitySlot(slot, false)
        endif
        return
    endif

    set level = GetUnitAbilityLevel(AHUI_SelectedHero[pid], abilityId)
    if level > 0 and (AHUI_PassiveLocked(AHUI_SelectedHero[pid], slot, abilityId) or AHUI_RequirementLocked(AHUI_SelectedHero[pid], abilityId)) then
        set level = 0
    endif
    // A learned skill the owner cannot use right now (SetPlayerAbilityAvailable false /
    // disabled, e.g. Erza's blocked base Q-R) is drawn as DISBTN, as the owner sees it.
    if level > 0 and not AHUI_IsActiveSlotCandidate(AHUI_SelectedHero[pid], GetOwningPlayer(AHUI_SelectedHero[pid]), abilityId) then
        set level = 0
    endif
    set iconPath = BlzGetAbilityIcon(abilityId)

    if AHUI_RenderedAbility[index] != abilityId or AHUI_RenderedIconPath[index] != iconPath then
        set AHUI_RenderedAbility[index] = abilityId
        set AHUI_CooldownTicks[index] = 0
        set AHUI_RenderedIconPath[index] = iconPath
        set AHUI_CooldownPeak[index] = 0.00
        set AHUI_LastRemaining[index] = 0.00
        call BlzFrameSetTexture(AHUI_Icon[index], iconPath, 0, true)
        call BlzFrameSetTexture(AHUI_CooldownFill[index], ConvertBTNtoDISBTN(iconPath), 0, true)
    endif

    set AHUI_SlotVisible[index] = true
    call AHUI_ShowPart(index, 0, AHUI_Root[index], true)
    call AHUI_ShowPart(index, 1, AHUI_Icon[index], true)
    // Checkpoint 28: a paused hero (own, ally or enemy) keeps its skills on
    // screen through this UI, each marked PAUSED.
    call WUI_Show(AHUI_PausedText[index], IsUnitPaused(AHUI_SelectedHero[pid]))
    if ownHero then
        call WUI_SetText(AHUI_KeyText[index], "|cffffffff" + WUI_SlotShownKey(pid, slot) + "|r")
    else
        call WUI_SetText(AHUI_KeyText[index], "|cffffffff" + AHUI_GetKeyText(slot) + "|r")
    endif
    // Edit mode prints the key big in the middle; hide the corner letter.
    call AHUI_ShowKey(index, not (ownHero and WUI_IsHotkeyEditing()))
    if level > 0 and AHUI_CanReadCooldown(AHUI_SelectedHero[pid], pid) then
        set charge = TasAbilityChargeBox_GetValue(AHUI_SelectedHero[pid], abilityId)
    endif
    call WUI_SetText(AHUI_ChargeText[index], charge)
    call AHUI_ShowPart(index, 4, AHUI_ChargeBox[index], charge != "" and charge != null)

    // Неизученная или сейчас отсутствующая способность остаётся видимой как
    // DISBTN, но без выдуманного таймера.
    if level <= 0 then
        set AHUI_CooldownPeak[index] = 0.00
        set AHUI_LastRemaining[index] = 0.00
        call AHUI_SetIconAlpha(index, 0)
        call AHUI_SetFillAlpha(index, 255)
        call AHUI_ShowPart(index, 2, AHUI_CooldownFill[index], true)
        call AHUI_ShowPart(index, 3, AHUI_CooldownText[index], false)
        set iconPath = null
        return
    endif

    // При выборе врага или смене alliance очищаем весь старый прогресс.
    // Не читаем remaining даже для определения состояния иконки.
    if not AHUI_CanReadCooldown(AHUI_SelectedHero[pid], pid) then
        set AHUI_CooldownPeak[index] = 0.00
        set AHUI_LastRemaining[index] = 0.00
        set AHUI_CooldownTicks[index] = 0
        call AHUI_SetIconAlpha(index, AHUI_READY_ALPHA)
        call AHUI_ShowPart(index, 2, AHUI_CooldownFill[index], false)
        call WUI_SetText(AHUI_CooldownText[index], "")
        call AHUI_ShowPart(index, 3, AHUI_CooldownText[index], false)
        set iconPath = null
        return
    endif

    // Источник прогресса — только фактический remaining юнита. При старте или
    // перезапуске КД запоминается реально наблюдаемая вершина, поэтому ручные
    // BlzStartUnitAbilityCooldown и уменьшения КД не подменяются Object Editor.
    if AHUI_CooldownTicks[index] > 0 and AHUI_RenderedAbility[index] == abilityId then
        set AHUI_CooldownTicks[index] = AHUI_CooldownTicks[index] - 1
        set iconPath = null
        return
    endif
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

        call AHUI_SetIconAlpha(index, R2I(255.00 * (1.00 - progress)))
        call AHUI_SetFillAlpha(index, R2I(255.00 * progress))
        call AHUI_ShowPart(index, 2, AHUI_CooldownFill[index], true)
        call WUI_SetText(AHUI_CooldownText[index], "|cffffffff" + AHUI_FormatCooldown(remaining) + "|r")
        call AHUI_ShowPart(index, 3, AHUI_CooldownText[index], true)
    else
        set AHUI_CooldownPeak[index] = 0.00
        call AHUI_SetIconAlpha(index, AHUI_READY_ALPHA)
        call AHUI_ShowPart(index, 2, AHUI_CooldownFill[index], false)
        call AHUI_ShowPart(index, 3, AHUI_CooldownText[index], false)
    endif

    set AHUI_LastRemaining[index] = remaining
    if remaining > 0.05 then
        set AHUI_CooldownTicks[index] = 3
    else
        set AHUI_CooldownTicks[index] = 0
    endif

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
local real width = AHUI_TOOLTIP_WIDTH
local boolean hasMana = false
local integer cacheIndex
local integer skillPoints
local integer heroLevel
local integer heroType
local boolean validCache
local boolean buildText = true
     if not AHUI_TooltipsReady then
        call AHUI_HideTooltip(pid)
        return
    endif
    if slot < 0 or slot >= AHUI_SLOT_COUNT then
        call AHUI_HideTooltip(pid)
        return
    endif

    set index = AHUI_FrameIndex(pid, slot)
    // Do not infer tooltip ownership from the visible F/G key badge.
    // Check before the text cache so an old preview closes on unlock.
    if (not AHUI_SlotVisible[index] or AHUI_NativeCommandShown[index]) and not AHUI_HoverPips[pid] then
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
    set cacheIndex = index * 2
    if AHUI_HoverPips[pid] then
        set cacheIndex = cacheIndex + 1
    endif
    set skillPoints = GetHeroSkillPoints(AHUI_SelectedHero[pid])
    set heroLevel = GetHeroLevel(AHUI_SelectedHero[pid])
    set heroType = GetUnitTypeId(AHUI_SelectedHero[pid])
    set validCache = AHUI_TCHero[cacheIndex] == AHUI_SelectedHero[pid] and AHUI_TCAbility[cacheIndex] == abilityId and AHUI_TCLevel[cacheIndex] == abilityLevel and AHUI_TCPoints[cacheIndex] == skillPoints and AHUI_TCHeroLevel[cacheIndex] == heroLevel and AHUI_TCType[cacheIndex] == heroType and AHUI_TCSettings[cacheIndex] == WUI_SettingsRevision
    if validCache and AHUI_TCRevision[cacheIndex] == TooltipTextRevision and AHUI_TCEpoch[cacheIndex] == AHUI_TipEpoch then
        set buildText = false
    else
        set title = BlzGetAbilityTooltip(abilityId, objectLevel)
        set description = BlzGetAbilityExtendedTooltip(abilityId, objectLevel)
        set manaCost = BlzGetAbilityManaCost(abilityId, objectLevel)
        if validCache and title == AHUI_TCRawTitle[cacheIndex] and description == AHUI_TCRawDescription[cacheIndex] and manaCost == AHUI_TCRawMana[cacheIndex] then
            set buildText = false
        else
            set AHUI_TCRawTitle[cacheIndex] = title
            set AHUI_TCRawDescription[cacheIndex] = description
            set AHUI_TCRawMana[cacheIndex] = manaCost
        endif
        set AHUI_TCEpoch[cacheIndex] = AHUI_TipEpoch
        set AHUI_TCRevision[cacheIndex] = TooltipTextRevision
    endif
    if buildText then
// Learnable skills list the hero levels that unlock each skill level.
if slot < AHUI_LEARN_SLOTS and AHUI_IsLearnableSkill(AHUI_BaseAbility[slot]) then
    if AHUI_HoverPips[pid] then
        set description = AHUI_LevelSchedule(AHUI_SelectedHero[pid], AHUI_BaseAbility[slot])
        // Checkpoint 26: say plainly that the strip itself is the upgrade button.
        if AHUI_SelectedHero[pid] == Hero[pid] then
            if AHUI_CurrentAbility[slot] != AHUI_BaseAbility[slot] and GetUnitTypeId(AHUI_SelectedHero[pid]) != Rimuru_ID then
                // Replacement shown: learning waits for the base skill.
            elseif AHUI_CanLearn(AHUI_SelectedHero[pid], AHUI_BaseAbility[slot]) then
                set description = description + "|n|cff7ee870Click here to upgrade this ability|r |cff9aa0a8(skill points: " + I2S(GetHeroSkillPoints(AHUI_SelectedHero[pid])) + ")|r"
            elseif GetHeroSkillPoints(AHUI_SelectedHero[pid]) > 0 then
                set description = description + "|n|cff9aa0a8Skill points: " + I2S(GetHeroSkillPoints(AHUI_SelectedHero[pid])) + " - this ability cannot be upgraded at the current hero level.|r"
            endif
        endif
        set manaCost = 0
    else
        set description = description + "|n|n" + AHUI_LevelSchedule(AHUI_SelectedHero[pid], AHUI_BaseAbility[slot])
    endif
endif

if AHUI_SelectedHero[pid] == Hero[pid] and GetOwningPlayer(Hero[pid]) == Player(pid) then
    set description = description + "|n|cff9aa0a8Shift + RMB: report ability CD to allies (5 sec interval)|r"
endif

// Flame Dash [Level 5] (Q)
set title = title + " (" + AHUI_GetKeyText(slot) + ")"

    set AHUI_TCHero[cacheIndex] = AHUI_SelectedHero[pid]
    set AHUI_TCAbility[cacheIndex] = abilityId
    set AHUI_TCLevel[cacheIndex] = abilityLevel
    set AHUI_TCPoints[cacheIndex] = skillPoints
    set AHUI_TCHeroLevel[cacheIndex] = heroLevel
    set AHUI_TCType[cacheIndex] = heroType
    set AHUI_TCRevision[cacheIndex] = TooltipTextRevision
    set AHUI_TCSettings[cacheIndex] = WUI_SettingsRevision
    set AHUI_TCMana[cacheIndex] = manaCost
    set AHUI_TCTitle[cacheIndex] = title
    set AHUI_TCDescription[cacheIndex] = description
    else
        set title = AHUI_TCTitle[cacheIndex]
        set description = AHUI_TCDescription[cacheIndex]
        set manaCost = AHUI_TCMana[cacheIndex]
    endif
    // Revalidation of identical text never resets the visible layout.
    if AHUI_TipShown[pid] == cacheIndex + 1 and BlzFrameIsVisible(AHUI_TooltipRoot[pid]) and BlzFrameGetText(AHUI_TooltipTitle[pid]) == title and BlzFrameGetText(AHUI_TooltipText[pid]) == description and AHUI_TipShownMana[pid] == manaCost then
        return
    endif
    set AHUI_TipShown[pid] = cacheIndex + 1
    set AHUI_TipShownMana[pid] = manaCost

// Checkpoint 26b: the pip-strip tooltip is compact and sized to its text;
// its title is centred on the whole box (the title frame is scaled .90, so
// its size is divided by the scale and it hangs from the box's TOP centre).
if AHUI_HoverPips[pid] then
    set width = AHUI_PIP_TOOLTIP_WIDTH
    call BlzFrameClearAllPoints(AHUI_TooltipTitle[pid])
    call BlzFrameSetPoint(AHUI_TooltipTitle[pid], FRAMEPOINT_TOP, AHUI_TooltipRoot[pid], FRAMEPOINT_TOP, 0.000, -0.008 / 0.90)
    call BlzFrameSetSize(AHUI_TooltipTitle[pid], (width - 0.016) / 0.90, 0.014 / 0.90)
    call BlzFrameSetTextAlignment(AHUI_TooltipTitle[pid], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
else
    set width = AHUI_TOOLTIP_WIDTH
    call BlzFrameClearAllPoints(AHUI_TooltipTitle[pid])
    call BlzFrameSetPoint(AHUI_TooltipTitle[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.011, -0.009)
    call BlzFrameSetSize(AHUI_TooltipTitle[pid], AHUI_TOOLTIP_WIDTH - 0.022, 0.020)
    call BlzFrameSetTextAlignment(AHUI_TooltipTitle[pid], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
endif
call BlzFrameSetText(AHUI_TooltipTitle[pid], title)
call BlzFrameSetText(AHUI_TooltipText[pid], description)

// ВАЖНО: пересчитываем layout текста (compact column, not the HUD width)
call BlzFrameSetSize(AHUI_TooltipText[pid], width - 0.022, 0.0)

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
    if AHUI_HoverPips[pid] then
        call BlzFrameSetPoint(AHUI_TooltipText[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.011, -0.026)
    else
        call BlzFrameSetPoint(AHUI_TooltipText[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.011, -0.032)
    endif
endif

set textHeight = BlzFrameGetHeight(AHUI_TooltipText[pid])

if hasMana then
    set boxHeight = textHeight + 0.067
elseif AHUI_HoverPips[pid] then
    set boxHeight = textHeight + 0.034
else
    set boxHeight = textHeight + 0.042
endif

if AHUI_HoverPips[pid] then
    if boxHeight < 0.042 then
        set boxHeight = 0.042
    endif
elseif boxHeight < 0.080 then
    set boxHeight = 0.080
endif

call BlzFrameSetSize(AHUI_TooltipRoot[pid], width, boxHeight)

// Позиция окна: над наведённой кнопкой, в пределах корпуса HUD.
call BlzFrameClearAllPoints(AHUI_TooltipRoot[pid])
call BlzFrameSetAbsPoint(AHUI_TooltipRoot[pid], FRAMEPOINT_BOTTOM, RMinBJ(RMaxBJ(WUI_AbilityX(slot), WUI_CHASSIS_LEFT + width * 0.50), WUI_CHASSIS_RIGHT - width * 0.50), WUI_CHASSIS_TOP + 0.024)

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

    // Чужой герой доступен для просмотра описаний независимо от alliance.
    // Право читать кулдауны проверяется отдельно в AHUI_CanReadCooldown.
    set result = true

set owner = null
return result
endfunction

// Hover определяется только чтением локальной позиции мыши. Никакие BUTTON,
// SIMPLEBUTTON, hitbox-frame или frame mouse events не используются.
// Pure local hit test using cached tooltip handle and existing HUD geometry.
function AHUI_CooldownTooltipContains takes integer pid, real x, real y returns boolean
    local integer slot = AHUI_HoveredSlot[pid]
    local real width
    local real height
    local real centre
    local real bottom = WUI_CHASSIS_TOP + 0.024
    if GetLocalPlayer() != Player(pid) or slot < 0 or slot >= AHUI_SLOT_COUNT or AHUI_TooltipRoot[pid] == null then
        return false
    endif
    if not BlzFrameIsVisible(AHUI_TooltipRoot[pid]) then
        return false
    endif
    set width = BlzFrameGetWidth(AHUI_TooltipRoot[pid])
    set height = BlzFrameGetHeight(AHUI_TooltipRoot[pid])
    set centre = RMinBJ(RMaxBJ(WUI_AbilityX(slot), WUI_CHASSIS_LEFT + width * 0.50), WUI_CHASSIS_RIGHT - width * 0.50)
    return x >= centre - width * 0.50 and x <= centre + width * 0.50 and y >= bottom and y <= bottom + height
endfunction

function AHUI_CooldownPingCommandAt takes integer pid, real x, real y returns integer
    local integer slot = 0
    local real centre
    if GetLocalPlayer() != Player(pid) or pid < 0 or pid >= 10 or Hero[pid] == null or AHUI_SelectedHero[pid] != Hero[pid] then
        return -1
    endif
    if GetOwningPlayer(Hero[pid]) != Player(pid) or WUI_IsHotkeyEditing() then
        return -1
    endif
    if AHUI_CooldownTooltipContains(pid, x, y) then
        return AHUI_GetOriginSlot(AHUI_HoveredSlot[pid])
    endif
    loop
        exitwhen slot >= AHUI_SLOT_COUNT
        set centre = AHUI_GetSlotCenterX(slot)
        if AHUI_PipMax[slot] > 0 and RAbsBJ(x - centre) <= AHUI_ICON_SIZE * 0.50 and y >= WUI_PIP_Y - 0.010 and y < AHUI_GetSlotCenterY(slot) - AHUI_ICON_SIZE * 0.50 then
            return AHUI_GetOriginSlot(slot)
        endif
        set slot = slot + 1
    endloop
    return -1
endfunction

// Input selects a command slot only. Ability identity/CD/name are resolved after sync.
function AHUI_RequestCooldownPing takes integer pid, real x, real y returns nothing
    local integer slot
    if GetLocalPlayer() != Player(pid) or pid < 0 or pid >= 10 or AHUI_PingRmbHeld[pid] then
        return
    endif
    set AHUI_PingRmbHeld[pid] = true
    if QB_SyncTrigger == null or QB_Hero[pid] == 0 then
        return
    endif
    set slot = AHUI_CooldownPingCommandAt(pid, x, y)
    if slot < 0 then
        return
    endif
    set QB_LocalSequence = QB_LocalSequence + 1
    call BlzSendSyncData(QB_SYNC, "P," + I2S(QB_Hero[pid]) + "," + I2S(QB_Version[pid]) + "," + I2S(QB_LocalSequence) + "," + I2S(slot) + "," + I2S(GetHandleId(Hero[pid])))
endfunction

function AHUI_ReleaseCooldownPing takes integer pid returns nothing
    if GetLocalPlayer() == Player(pid) then
        set AHUI_PingRmbHeld[pid] = false
    endif
endfunction

// No world-click listener: sample RMB only over a pingable pip/description.
// Entering while RMB is already held must not report a cooldown accidentally.
globals
    private boolean array AHUI_PingInputInside
    // Synced Left Shift state: cooldown chat pings need Shift + RMB.
    private boolean array AHUI_ShiftHeld
    private trigger AHUI_ShiftTrigger = null
endglobals
private function AHUI_PollCooldownMouse takes integer pid, real x, real y returns nothing
    if GetLocalPlayer() != Player(pid) then
        return
    endif
    if AHUI_CooldownPingCommandAt(pid, x, y) < 0 then
        set AHUI_PingInputInside[pid] = false
        call AHUI_ReleaseCooldownPing(pid)
        return
    endif
    if not AHUI_PingInputInside[pid] then
        set AHUI_PingInputInside[pid] = true
        set AHUI_PingRmbHeld[pid] = BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_RIGHT)
        return
    endif
    if BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_RIGHT) and AHUI_ShiftHeld[pid] then
        call AHUI_RequestCooldownPing(pid, x, y)
    else
        call AHUI_ReleaseCooldownPing(pid)
    endif
endfunction

private function AHUI_UpdateHoveredSlot takes integer pid returns nothing
    local integer slot = 0
    local integer index = 0
    local real mouseX = 0.00
    local real mouseY = 0.00
    local real centerX = 0.00
    local real centerY = 0.00
    local real halfSize = AHUI_ICON_SIZE * 0.50
    local integer previousSlot = AHUI_HoveredSlot[pid]
    local boolean previousPips = AHUI_HoverPips[pid]

    if GetLocalPlayer() != Player(pid) then
        return
    endif
    if WUI_RangePreviewBlocked() then
        call AR_Hide(pid)
        // Preserve existing tooltip/chat behavior; only the new ring is gated.
    endif
    if not AHUI_IsEligibleHero(AHUI_SelectedHero[pid], pid) then
        set AHUI_HoveredSlot[pid] = -1
        call AHUI_HideTooltip(pid)
        return
    endif

    call AR_Request(pid, null, 0)
    set mouseX = BlzPixelToFrameX(BlzGetMouseScreenPosX())
    set mouseY = BlzPixelToFrameY(BlzGetMouseScreenPosY())
    call AHUI_PollCooldownMouse(pid, mouseX, mouseY)
    set AHUI_HoveredSlot[pid] = -1
    set AHUI_HoverPips[pid] = false

    // Inventory and abilities share one ring and the existing screen-coordinate poll.
    // Empty slots/proc-only items still clear the previous ability preview.
    if GetOwningPlayer(AHUI_SelectedHero[pid]) == Player(pid) then
        loop
            exitwhen slot >= 6
            if RAbsBJ(mouseX - WUI_ItemX(slot)) <= WUI_ITEM_SIZE * 0.50 and RAbsBJ(mouseY - WUI_ItemY(slot)) <= WUI_ITEM_SIZE * 0.50 and WUI_RangeNativeItemVisible(slot) then
                if BlzFrameIsVisible(AHUI_TooltipRoot[pid]) then
                    call AHUI_HideTooltip(pid)
                endif
                set AHUI_PingHoverGrace[pid] = 0
                call AR_RequestItem(pid, AHUI_SelectedHero[pid], slot)
                return
            endif
            set slot = slot + 1
        endloop
    endif
    set slot = 0
    loop
        exitwhen slot >= AHUI_SLOT_COUNT
        set index = AHUI_FrameIndex(pid, slot)
        set centerX = AHUI_GetSlotCenterX(slot)
        set centerY = AHUI_GetSlotCenterY(slot)
        if mouseX >= centerX - halfSize and mouseX <= centerX + halfSize then
            // Learned own abilities use native buttons, with no custom tooltip.
            if AHUI_NativeCommandShown[index] and GetOwningPlayer(AHUI_SelectedHero[pid]) == Player(pid) and mouseY >= centerY - halfSize and mouseY <= centerY + halfSize and WUI_RangeNativeSlotVisible(slot) then
                if BlzFrameIsVisible(AHUI_TooltipRoot[pid]) then
                    call AHUI_HideTooltip(pid)
                endif
                call AR_Request(pid, AHUI_SelectedHero[pid], AHUI_CurrentAbility[slot])
                return
            endif
            if AHUI_SlotVisible[index] and mouseY >= centerY - halfSize and mouseY <= centerY + halfSize then
                set AHUI_HoveredSlot[pid] = slot
                set AHUI_PingHoverGrace[pid] = AHUI_TOOLTIP_LEAVE_TICKS
                call AHUI_RefreshTooltip(pid)
                if BlzFrameIsVisible(AHUI_TooltipRoot[pid]) then
                    call AR_Request(pid, AHUI_SelectedHero[pid], AHUI_CurrentAbility[slot])
                endif
                return
            endif
            // Pip strip under QWERT: level schedule (also for learned skills,
            // whose icon tooltip is the native one).
            if slot < AHUI_LEARN_SLOTS and AHUI_PipMax[slot] > 0 and mouseY >= WUI_PIP_Y - 0.010 and mouseY < centerY - halfSize then
                set AHUI_HoveredSlot[pid] = slot
                set AHUI_HoverPips[pid] = true
                set AHUI_PingHoverGrace[pid] = AHUI_TOOLTIP_LEAVE_TICKS
                call AHUI_RefreshTooltip(pid)
                return
            endif
        endif
        set slot = slot + 1
    endloop

    if AHUI_SelectedHero[pid] == Hero[pid] and previousSlot >= 0 and AHUI_PingHoverGrace[pid] > 0 then
        set AHUI_PingHoverGrace[pid] = AHUI_PingHoverGrace[pid] - 1
        if AHUI_PingHoverGrace[pid] > 0 then
            set AHUI_HoveredSlot[pid] = previousSlot
            set AHUI_HoverPips[pid] = previousPips
            // Keep RMB-on-description usable during the short leave window.
            // The description itself never renews that window.
            if AHUI_CooldownTooltipContains(pid, mouseX, mouseY) then
                call AHUI_RefreshTooltip(pid)
            endif
            return
        endif
    endif
    call AHUI_HideTooltip(pid)
endfunction

private function AHUI_ClearSelection takes integer pid returns nothing
    if GetLocalPlayer() != Player(pid) then
        return
    endif

    call AR_Cancel(pid)
    set AHUI_SelectedHero[pid] = null
    set AHUI_HoveredSlot[pid] = -1
    set AHUI_PingHoverGrace[pid] = 0
    set AHUI_PingRmbHeld[pid] = false
    set AHUI_AllowCooldownRead = false
    call AHUI_ClearResolvedAbilities()
    call AHUI_HideAll(pid)
    call AHUI_HideLearning()
endfunction

// Local: more than one unit selected. The engine then shows the active subgroup's
// command card (a summon, a knight...), so the hero overlay must not cover it.
private function AHUI_MultiSelected takes integer pid returns boolean
    local integer count = 0
    local unit u
    call GroupClear(AHUI_SelGroup)
    call GroupEnumUnitsSelected(AHUI_SelGroup, Player(pid), null)
    loop
        set u = FirstOfGroup(AHUI_SelGroup)
        exitwhen u == null or count > 1
        call GroupRemoveUnit(AHUI_SelGroup, u)
        set count = count + 1
    endloop
    call GroupClear(AHUI_SelGroup)
    set u = null
    return count > 1
endfunction

// Local: glow around F while a toggle passive is On (Alter Saber F).
private function AHUI_RefreshToggleGlow takes integer pid returns nothing
    local integer index = AHUI_FrameIndex(pid, AHUI_SLOT_F)
    local unit hero = AHUI_SelectedHero[pid]
    local integer abilityId = AHUI_CurrentAbility[AHUI_SLOT_F]
    local boolean on = AHUI_SlotVisible[index] and hero != null and (abilityId == AlterSaberF_ID or abilityId == AlterSaberF_Active_ID) and GetUnitAbilityLevel(hero, abilityId) > 0 and LoadBoolean(hs, GetHandleId(hero), SH_ALTERSABER_F_ACTIVE)
    if on != AHUI_ToggleGlowShown[index] and AHUI_ToggleGlow[index] != null then
        set AHUI_ToggleGlowShown[index] = on
        call BlzFrameSetVisible(AHUI_ToggleGlow[index], on)
    endif
    set hero = null
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

    if AHUI_MultiSelected(pid) then
        // Native command card only (whatever unit is active); restored once.
        if not AHUI_MultiShown then
            set AHUI_MultiShown = true
            call AHUI_HideAll(pid)
            call AHUI_HideLearning()
            loop
                exitwhen slot >= 7
                call WUI_SetSlotCustomShown(slot, false)
                call WUI_ShowNativeAbilitySlot(slot, true)
                set slot = slot + 1
            endloop
        endif
        return
    endif
    set AHUI_MultiShown = false

    // Никакое состояние не берётся из предыдущего тика: белый список героя и
    // разрешённый остаток КД каждой его основной/вторичной способности читаются заново.
    call AHUI_ClearResolvedAbilities()
    set AHUI_AllowCooldownRead = AHUI_CanReadCooldown(AHUI_SelectedHero[pid], pid)
    call AHUI_ConfigureHeroAbilities(AHUI_SelectedHero[pid])
    set AHUI_AllowCooldownRead = false

    loop
        exitwhen slot >= AHUI_SLOT_COUNT
        call AHUI_RefreshSlot(pid, slot)
        set slot = slot + 1
    endloop
    call AHUI_RefreshLearning(pid)
    call AHUI_RefreshToggleGlow(pid)

endfunction

private function AHUI_ApplyShift takes nothing returns nothing
    local integer index = 0
    loop
        exitwhen index >= AHUI_PIP_SLOTS * AHUI_MAX_PIPS
        set AHUI_PipTexture[index] = null
        set index = index + 1
    endloop
endfunction

private function AHUI_Periodic takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local boolean refreshAbilities = AHUI_UpdateTick == 0

    if AHUI_SeenHudRevision != WUI_HudRevision then
        set AHUI_SeenHudRevision = WUI_HudRevision
        call AHUI_ApplyShift()
    endif
    if refreshAbilities then
        call AR_Reconcile()
    endif
    if pid < bj_MAX_PLAYER_SLOTS and AHUI_DeselectPending[pid] then
        set AHUI_DeselectPending[pid] = false
        if AHUI_SelectedHero[pid] != null and not IsUnitSelected(AHUI_SelectedHero[pid], Player(pid)) then
            call AHUI_ClearSelection(pid)
        endif
    endif
    if pid < bj_MAX_PLAYER_SLOTS then
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
        call AR_Render(pid)
    endif

    set AHUI_TipClock = AHUI_TipClock + 1
    if AHUI_TipClock >= 100 then
        set AHUI_TipClock = 0
        set AHUI_TipEpoch = AHUI_TipEpoch + 1
    endif
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
        set AHUI_DeselectPending[pid] = false
        if selected == AHUI_SelectedHero[pid] and selected != null then
            // Same hero again (F1, held F1, re-click): nothing to rebuild.
            set selected = null
            return
        endif
        if AHUI_IsEligibleHero(selected, pid) then
            // Полный reset не даёт предыдущему союзнику мигнуть даже один кадр.
            call AHUI_ClearSelection(pid)
            set AHUI_SelectedHero[pid] = selected
            call AHUI_Refresh(pid)
            call AHUI_UpdateHoveredSlot(pid)
        else
            // Обычный юнит, иллюзия и собственный герой сразу
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
        set AHUI_DeselectPending[pid] = true
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
    local framehandle console = WUI_GetRoot()

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

            set AHUI_Root[index] = BlzCreateFrameByType("FRAME", "AHUIRoot", console, "WOSPassiveFrame", index)
            call BlzFrameClearAllPoints(AHUI_Root[index])
            call BlzFrameSetSize(AHUI_Root[index], AHUI_ICON_SIZE, AHUI_ICON_SIZE)
            // A normal FRAME cannot safely anchor to a native SIMPLEFRAME tree.
            call WUI_PlaceShift(AHUI_Root[index], AHUI_GetSlotCenterX(slot) - WUI_HudShift, AHUI_GetSlotCenterY(slot), AHUI_ICON_SIZE, AHUI_ICON_SIZE)
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

            // Paused: two thin chains crossing the icon (like the ban cross).
            set AHUI_PausedText[index] = BlzCreateFrameByType("BACKDROP", "AHUIPausedChains", AHUI_Root[index], "", index)
            call BlzFrameSetAllPoints(AHUI_PausedText[index], AHUI_Root[index])
            call BlzFrameSetTexture(AHUI_PausedText[index], "UI\\WOS\\skill-chains.tga", 0, true)
            call BlzFrameSetLevel(AHUI_PausedText[index], 112)
            call BlzFrameSetEnable(AHUI_PausedText[index], false)
            call BlzFrameSetVisible(AHUI_PausedText[index], false)

            if slot == AHUI_SLOT_F then
                // Same shine/transform as the Player Pick captain slot, scaled to the HUD icon.
                set AHUI_ToggleGlow[index] = BlzCreateFrameByType("SPRITE", "AHUIToggleGlow", AHUI_Root[index], "WarCraftIIILogo", index)
                call BlzFrameSetPoint(AHUI_ToggleGlow[index], FRAMEPOINT_LEFT, AHUI_Root[index], FRAMEPOINT_LEFT, 0.0000, 0.48)
                call BlzFrameSetSize(AHUI_ToggleGlow[index], 1.00, 1.00)
                call BlzFrameSetScale(AHUI_ToggleGlow[index], 0.72 * AHUI_ICON_SIZE / 0.027)
                call BlzFrameSetModel(AHUI_ToggleGlow[index], "Pick\\wos_IconShine1.mdx", 0)
                call BlzFrameSetLevel(AHUI_ToggleGlow[index], 114)
                call BlzFrameSetEnable(AHUI_ToggleGlow[index], false)
                call BlzFrameSetVisible(AHUI_ToggleGlow[index], false)
            endif

            set AHUI_KeyBox[index] = BlzCreateFrameByType("BACKDROP", "AHUIKeyBox", AHUI_Root[index], "", index)
            call BlzFrameSetPoint(AHUI_KeyBox[index], FRAMEPOINT_TOPLEFT, AHUI_Root[index], FRAMEPOINT_TOPLEFT, 0.0015, -0.0015)
            call BlzFrameSetSize(AHUI_KeyBox[index], 0.0092, 0.0092)
            call BlzFrameSetTexture(AHUI_KeyBox[index], AHUI_KEY_BOX_TEXTURE, 0, true)
            call BlzFrameSetAlpha(AHUI_KeyBox[index], 215)
            call BlzFrameSetLevel(AHUI_KeyBox[index], 110)
            call BlzFrameSetEnable(AHUI_KeyBox[index], false)
            call BlzFrameSetVisible(AHUI_KeyBox[index], false)
            set AHUI_KeyText[index] = BlzCreateFrameByType("TEXT", "AHUIKeyText", AHUI_Root[index], "", index)
            set AHUI_ChargeText[index] = TasAbilityChargeBox_CreatePortraitLabel(AHUI_Root[index])
            set AHUI_ChargeBox[index] = BlzFrameGetParent(AHUI_ChargeText[index])
            call BlzFrameSetLevel(AHUI_ChargeText[index], 113)
            call BlzFrameSetVisible(AHUI_ChargeBox[index], false)
            call BlzFrameClearAllPoints(AHUI_KeyText[index])
            call BlzFrameSetAllPoints(AHUI_KeyText[index], AHUI_KeyBox[index])
            call BlzFrameSetTextAlignment(AHUI_KeyText[index], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
            call BlzFrameSetScale(AHUI_KeyText[index], 0.72)
            call BlzFrameSetText(AHUI_KeyText[index], "|cffffffff" + AHUI_GetKeyText(slot) + "|r")
            call BlzFrameSetAlpha(AHUI_KeyText[index], 255)
            call BlzFrameSetLevel(AHUI_KeyText[index], 111)
            call BlzFrameSetEnable(AHUI_KeyText[index], false)
            call AHUI_ShowKey(index, false)

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
        call BlzFrameSetSize(AHUI_TooltipRoot[pid], AHUI_TOOLTIP_WIDTH, 0.180)
        call BlzFrameSetLevel(AHUI_TooltipRoot[pid], 1000)
        call BlzFrameSetEnable(AHUI_TooltipRoot[pid], false)
        call BlzFrameSetVisible(AHUI_TooltipRoot[pid], false)

        // Shared graphite surface; existing tooltip content and sizing are retained.
        set AHUI_TooltipBackdrop[pid] = WUI_Window("WOSAbilityTooltip", AHUI_TooltipRoot[pid], 0, pid)
        call BlzFrameSetAllPoints(AHUI_TooltipBackdrop[pid], AHUI_TooltipRoot[pid])
        call BlzFrameSetLevel(AHUI_TooltipBackdrop[pid], 1001)
        call BlzFrameSetEnable(AHUI_TooltipBackdrop[pid], false)
        call BlzFrameSetVisible(AHUI_TooltipBackdrop[pid], false)

        // TITLE
        set AHUI_TooltipTitle[pid] = BlzCreateFrameByType("TEXT", "AHUITooltipTitle", AHUI_TooltipRoot[pid], "", pid)
        call BlzFrameSetSize(AHUI_TooltipTitle[pid], AHUI_TOOLTIP_WIDTH - 0.022, 0.020)
        call BlzFrameSetPoint(AHUI_TooltipTitle[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.011, -0.009)
        call BlzFrameSetTextAlignment(AHUI_TooltipTitle[pid], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
        call BlzFrameSetScale(AHUI_TooltipTitle[pid], 0.90)
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
call BlzFrameSetSize(AHUI_TooltipSeparator[pid], AHUI_TOOLTIP_WIDTH - 0.022, 0.0012)
call BlzFrameSetPoint(AHUI_TooltipSeparator[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.011, -0.047)
call BlzFrameSetTexture(AHUI_TooltipSeparator[pid], "UI\\Widgets\\ToolTips\\Human\\HorizontalSeparator.blp", 0, false)
call BlzFrameSetLevel(AHUI_TooltipSeparator[pid], 1002)
call BlzFrameSetEnable(AHUI_TooltipSeparator[pid], false)
call BlzFrameSetVisible(AHUI_TooltipSeparator[pid], false)
        
        // DESCRIPTION + TooltipBuilder content
        set AHUI_TooltipText[pid] = BlzCreateFrameByType("TEXT", "AHUITooltipText", AHUI_TooltipRoot[pid], "", pid)
        call BlzFrameSetSize(AHUI_TooltipText[pid], AHUI_TOOLTIP_WIDTH - 0.022, 0.0)
        call BlzFrameSetPoint(AHUI_TooltipText[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.011, -0.050)
        call BlzFrameSetTextAlignment(AHUI_TooltipText[pid], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetLevel(AHUI_TooltipText[pid], 1002)
        call BlzFrameSetEnable(AHUI_TooltipText[pid], false)
        call BlzFrameSetVisible(AHUI_TooltipText[pid], false)

        set pid = pid + 1
    endloop
endfunction

// Synchronous allocation on every client: 42 pips, 5 learn strips and 5
// unlock labels. Visibility is local; strip clicks are synced frame events.
// Stats column mode changed: pips are re-placed on the next refresh (their
// texture cache is cleared); roots / learn targets are WUI-registered.

private function AHUI_CreateLearnFrames takes nothing returns nothing
    local framehandle root = WUI_GetRoot()
    local integer slot = 0
    local integer k = 0
    local integer index = 0
    set AHUI_LearnTrigger = CreateTrigger()
    loop
        exitwhen slot >= AHUI_PIP_SLOTS
        set k = 0
        loop
            exitwhen k >= AHUI_MAX_PIPS
            set index = slot * AHUI_MAX_PIPS + k
            set AHUI_Pip[index] = BlzCreateFrameByType("BACKDROP", "AHUIPip", root, "", index)
            call WUI_Place(AHUI_Pip[index], WUI_AbilityX(slot), WUI_PIP_Y, AHUI_PIP_SIZE, AHUI_PIP_SIZE)
            call BlzFrameSetTexture(AHUI_Pip[index], "UI\\WOS\\pip-empty.tga", 0, true)
            call BlzFrameSetLevel(AHUI_Pip[index], 125)
            call BlzFrameSetEnable(AHUI_Pip[index], false)
            call BlzFrameSetVisible(AHUI_Pip[index], false)
            set AHUI_PipTexture[index] = null
            set k = k + 1
        endloop
        set AHUI_PipMax[slot] = 0
        set slot = slot + 1
    endloop
    set slot = 0
    loop
        exitwhen slot >= AHUI_LEARN_SLOTS
        // Click target covering the pip row; learning happens only when the
        // next level is unlocked and a skill point is available.
        set AHUI_LearnButton[slot] = BlzCreateFrameByType("BUTTON", "AHUILearn", root, "", slot)
        // Checkpoint 22: from just below the pips up to just under the icon
        // (icon bottom = WUI_HUD_Y - WUI_ICON_SIZE / 2), full slot width.
        call WUI_PlaceShift(AHUI_LearnButton[slot], WUI_AbilityX(slot) - WUI_HudShift, (WUI_PIP_Y - 0.0050 + WUI_HUD_Y - WUI_ICON_SIZE * 0.5 - 0.0008) * 0.5, WUI_COMMAND_STEP - 0.001, WUI_HUD_Y - WUI_ICON_SIZE * 0.5 - 0.0008 - (WUI_PIP_Y - 0.0050))
        call BlzFrameSetLevel(AHUI_LearnButton[slot], 120)
        set AHUI_LearnGlow[slot] = BlzCreateFrameByType("BACKDROP", "AHUILearnGlow", AHUI_LearnButton[slot], "", slot)
        call BlzFrameSetAllPoints(AHUI_LearnGlow[slot], AHUI_LearnButton[slot])
        call BlzFrameSetTexture(AHUI_LearnGlow[slot], "UI\\WOS\\learn-glow.tga", 0, true)
        call BlzFrameSetEnable(AHUI_LearnGlow[slot], false)
        call BlzFrameSetVisible(AHUI_LearnGlow[slot], false)
        call BlzTriggerRegisterFrameEvent(AHUI_LearnTrigger, AHUI_LearnButton[slot], FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetVisible(AHUI_LearnButton[slot], false)
        // "Lv 6": hero level that unlocks the next skill level.
        set AHUI_ReqText[slot] = BlzCreateFrameByType("TEXT", "AHUIReqText", root, "", slot)
        if slot == 0 then
            // Reserve a separate footer row under Q for the new hold binding.
            call WUI_PlaceShift(AHUI_ReqText[slot], WUI_AbilityX(slot) - WUI_HudShift, WUI_PIP_Y - 0.0060, 0.040, 0.006)
        else
            call WUI_PlaceShift(AHUI_ReqText[slot], WUI_AbilityX(slot) - WUI_HudShift, WUI_PIP_Y - 0.0085, 0.040, 0.008)
        endif
        call BlzFrameSetTextAlignment(AHUI_ReqText[slot], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        if slot == 0 then
            call BlzFrameSetScale(AHUI_ReqText[slot], 0.52)
        else
            call BlzFrameSetScale(AHUI_ReqText[slot], 0.62)
        endif
        call BlzFrameSetLevel(AHUI_ReqText[slot], 126)
        call BlzFrameSetEnable(AHUI_ReqText[slot], false)
        call BlzFrameSetVisible(AHUI_ReqText[slot], false)
        set slot = slot + 1
    endloop
    call TriggerAddAction(AHUI_LearnTrigger, function AHUI_OnLearnClick)
    set root = null
endfunction

private function AHUI_OnShiftKey takes nothing returns nothing
    set AHUI_ShiftHeld[GetPlayerId(GetTriggerPlayer())] = BlzGetTriggerPlayerIsKeyDown()
endfunction

// F1 while the own hero is dead: a corpse cannot be selected, so the panel shows
// the hero as if it were selected (descriptions, levels). Live heroes keep stock F1.
private function AHUI_OnDeadHeroKey takes nothing returns nothing
    local integer pid = GetPlayerId(GetTriggerPlayer())
    local unit hero
    if pid >= 10 or Hero[pid] == null or not IsUnitType(Hero[pid], UNIT_TYPE_DEAD) then
        return
    endif
    set hero = Hero[pid]
    if GetLocalPlayer() == Player(pid) and AHUI_SelectedHero[pid] != hero then
        set AHUI_DeselectPending[pid] = false
        call AHUI_ClearSelection(pid)
        set AHUI_SelectedHero[pid] = hero
        call AHUI_Refresh(pid)
        call AHUI_UpdateHoveredSlot(pid)
    endif
    set hero = null
endfunction

private function AHUI_InitEvents takes nothing returns nothing
    local integer pid = 0
    local integer metaKey

    set AHUI_SelectTrigger = CreateTrigger()
    set AHUI_DeselectTrigger = CreateTrigger()

    call TriggerAddAction(AHUI_SelectTrigger, function AHUI_OnSelect)
    call TriggerAddAction(AHUI_DeselectTrigger, function AHUI_OnDeselect)
    set AHUI_ShiftTrigger = CreateTrigger()
    call TriggerAddAction(AHUI_ShiftTrigger, function AHUI_OnShiftKey)
    set AHUI_DeadHeroKey = CreateTrigger()
    call TriggerAddAction(AHUI_DeadHeroKey, function AHUI_OnDeadHeroKey)

    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        if pid < 10 then
            set metaKey = 0
            loop
                exitwhen metaKey > 15
                call BlzTriggerRegisterPlayerKeyEvent(AHUI_ShiftTrigger, Player(pid), OSKEY_LSHIFT, metaKey, true)
                call BlzTriggerRegisterPlayerKeyEvent(AHUI_ShiftTrigger, Player(pid), OSKEY_LSHIFT, metaKey, false)
                set metaKey = metaKey + 1
            endloop
            call BlzTriggerRegisterPlayerKeyEvent(AHUI_DeadHeroKey, Player(pid), OSKEY_F1, 0, true)
        endif
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

private function AHUI_StartUI takes nothing returns nothing
    set AHUI_GameUI = WUI_GetRoot()
    set AHUI_ConsoleBackdrop = BlzGetFrameByName("ConsoleUIBackdrop", 0)

    call AHUI_InitLevelTable()
    call AHUI_InitPlayerState()
    call AHUI_InitEvents()
    call AHUI_CreateSlotFrames()
    call AHUI_CreateTooltipFrames()
    call AHUI_CreateLearnFrames()

    set AHUI_UpdateTimer = CreateTimer()
    call TimerStart(AHUI_UpdateTimer, AHUI_UPDATE_PERIOD, true, function AHUI_Periodic)

    call TimerStart(CreateTimer(), AHUI_TooltipsDelay, false, function AHUI_EnableTooltips)
endfunction

private function InitAllyHeroAbilityUI takes nothing returns nothing
    call WUI_OnReady(function AHUI_StartUI)
endfunction

endlibrary
