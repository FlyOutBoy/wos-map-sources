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
//    масштабируются и не отключаются. Они используются только как якоря и
//    как источник событий наведения.

globals
    private constant real AHUI_UPDATE_PERIOD = 0.10
    private constant real AHUI_ICON_SIZE = 0.0385
    private constant real AHUI_COOLDOWN_TEXT_SCALE = 1.80
    private constant integer AHUI_READY_ALPHA = 255

    private constant integer AHUI_SLOT_Q = 0
    private constant integer AHUI_SLOT_W = 1
    private constant integer AHUI_SLOT_E = 2
    private constant integer AHUI_SLOT_R = 3
    private constant integer AHUI_SLOT_T = 4
    private constant integer AHUI_SLOT_F = 5
    private constant integer AHUI_SLOT_G = 6
    private constant integer AHUI_SLOT_COUNT = 7

    private constant integer AHUI_E_REQUIRED_LEVEL = 6
    private constant integer AHUI_R_REQUIRED_LEVEL = 10
    private constant integer AHUI_T_REQUIRED_LEVEL = 25

    // SetPlayerAbilityAvailable не имеет getter-native. Hook только запоминает
    // состояние исходного синхронного вызова и не заменяет его.
    private hashtable AHUI_AbilityAvailability = InitHashtable()
    private hashtable AHUI_UnitAbilityHidden = InitHashtable()
    private hashtable AHUI_UnitAbilityDisabled = InitHashtable()
    private hashtable AHUI_AbilityRequirements = InitHashtable()
    private hashtable AHUI_FrameSlots = InitHashtable()

    // Локальный UI-контекст каждого игрока. На конкретном клиенте изменяется
    // только элемент, соответствующий GetLocalPlayer().
    private unit array AHUI_SelectedHero
    private integer array AHUI_HoveredSlot

    // Результат ручной конфигурации и сканирования hero abilities по позициям.
    private integer array AHUI_CurrentAbility
    private boolean array AHUI_CurrentAbilityPresent
    private boolean array AHUI_CurrentShowAlways

    // Только кэш уже нарисованного локального UI.
    private integer array AHUI_RenderedAbility
    private string array AHUI_RenderedIconPath
    private boolean array AHUI_SlotVisible
    private boolean array AHUI_SlotDisabled

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

    private timer AHUI_UpdateTimer = null
    private trigger AHUI_SelectTrigger = null
    private trigger AHUI_DeselectTrigger = null
    private trigger AHUI_FrameEnterTrigger = null
    private trigger AHUI_FrameLeaveTrigger = null
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

// Публичная настройка дополнительного требования уровня героя.
// Если Object Editor задаёт больший Required Level, используется он.
function AHUI_RegisterAbilityRequirement takes integer abilityId, integer heroLevel returns nothing
    if abilityId != 0 and heroLevel > 0 then
        call SaveInteger(AHUI_AbilityRequirements, 0, abilityId, heroLevel)
    endif
endfunction

private function AHUI_IsAbilityAvailable takes player owner, integer abilityId returns boolean
    local integer pid

    if owner == null or abilityId == 0 then
        return false
    endif

    set pid = GetPlayerId(owner)
    if HaveSavedBoolean(AHUI_AbilityAvailability, pid, abilityId) then
        return LoadBoolean(AHUI_AbilityAvailability, pid, abilityId)
    endif

    // До первого SetPlayerAbilityAvailable способность доступна по умолчанию.
    return true
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

private function AHUI_ResolveHeroId takes integer heroId returns integer
    // Все alias находятся в одном месте. Добавляйте сюда новые unit type,
    // которые должны использовать набор способностей основной формы.
    if heroId == AlterSaber2_ID then
        return AlterSaber_ID
    elseif heroId == ErzaQ_UnitSkin_ID or heroId == ErzaW_UnitSkin_ID or heroId == ErzaE_UnitSkin_ID or heroId == ErzaR_UnitSkin_ID or heroId == ErzaT_UnitSkin_ID or heroId == ErzaG1_UnitSkin_ID or heroId == ErzaG2_UnitSkin_ID then
        return Erza_ID
    elseif heroId == Inori2_ID then
        return Inori_ID
    elseif heroId == Tsuna2_ID then
        return Tsuna_ID
    elseif heroId == Takeshi2_ID then
        return Takeshi_ID
    elseif heroId == Rimuru2_ID or heroId == Rimuru3_ID then
        return Rimuru_ID
    elseif heroId == Harribel_Morph_ID then
        return Harribel_ID
    elseif heroId == Barragan2_ID then
        return Barragan_ID
    elseif heroId == Starrk_Morph_ID then
        return Starrk_ID
    elseif heroId == Alucard_Morph_ID then
        return Alucard_ID
    elseif heroId == Bambietta2_ID then
        return Bambietta_ID
    endif
    return heroId
endfunction

private function AHUI_ClearResolvedAbilities takes nothing returns nothing
    local integer slot = 0

    loop
        exitwhen slot >= AHUI_SLOT_COUNT
        set AHUI_CurrentAbility[slot] = 0
        set AHUI_CurrentAbilityPresent[slot] = false
        set AHUI_CurrentShowAlways[slot] = false
        set slot = slot + 1
    endloop
endfunction

private function AHUI_IsHeroAbilityObject takes ability whichAbility returns boolean
    if whichAbility == null then
        return false
    endif
    return BlzGetAbilityBooleanField(whichAbility, ABILITY_BF_HERO_ABILITY)
endfunction

// Основной фильтр — ABILITY_BF_HERO_ABILITY. Дополнительный безопасный путь
// нужен для alternate-кнопок вроде Erza2Q..Erza2T: ErzaBase явно вызывает для
// них SetPlayerAbilityAvailable(..., true), хотя сами объекты могут быть
// созданы как обычные unit abilities. Простого значения "true по умолчанию"
// недостаточно — обязательна сохранённая hook-ом явная запись.
private function AHUI_IsDisplayAbilityObject takes player owner, ability whichAbility returns boolean
    local integer abilityId = 0
    local integer pid = 0

    if whichAbility == null then
        return false
    endif
    if AHUI_IsHeroAbilityObject(whichAbility) then
        return true
    endif
    if owner == null then
        return false
    endif

    set abilityId = BlzGetAbilityId(whichAbility)
    if abilityId == 0 then
        return false
    endif

    set pid = GetPlayerId(owner)
    return HaveSavedBoolean(AHUI_AbilityAvailability, pid, abilityId) and LoadBoolean(AHUI_AbilityAvailability, pid, abilityId)
endfunction

// Определяет, является ли существующая ability активным кандидатом command
// card. Это не финальная проверка DISBTN: функция нужна только для выбора между
// оставшейся на юните, но скрытой базой и доступной способностью текущей формы.
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

// Внутренняя установка одного кандидата.
// Реально существующая способность ставится в слот по её текущим координатам
// Object Editor. Поэтому смена формы или перенос кнопки автоматически меняет
// и слот панели, и описание на hover.
private function AHUI_OfferSingleAbility takes unit whichHero, integer declaredSlot, integer abilityId, boolean showAlways returns nothing
    local ability currentAbility = null
    local player owner = null
    local integer actualSlot = -1
    local integer buttonX = 0
    local integer buttonY = 0

    if whichHero == null or abilityId == 0 or declaredSlot < 0 or declaredSlot >= AHUI_SLOT_COUNT then
        return
    endif

    set currentAbility = BlzGetUnitAbility(whichHero, abilityId)
    set owner = GetOwningPlayer(whichHero)

    if AHUI_IsDisplayAbilityObject(owner, currentAbility) then
        set buttonX = BlzGetAbilityIntegerField(currentAbility, ABILITY_IF_BUTTON_POSITION_NORMAL_X)
        set buttonY = BlzGetAbilityIntegerField(currentAbility, ABILITY_IF_BUTTON_POSITION_NORMAL_Y)
        set actualSlot = AHUI_GetLogicalSlot(buttonX, buttonY)

        if actualSlot >= 0 then
            // Реальная способность всегда важнее ранее добавленного fallback.
            // Если несколько существующих кандидатов имеют одни координаты,
            // побеждает последняя строка в AHUI_ConfigureHeroAbilities.
            set AHUI_CurrentAbility[actualSlot] = abilityId
            set AHUI_CurrentAbilityPresent[actualSlot] = true
            set AHUI_CurrentShowAlways[actualSlot] = showAlways
        elseif showAlways and AHUI_CurrentAbility[declaredSlot] == 0 then
            // Для true разрешён заявленный вручную слот, даже если способность
            // сейчас отсутствует в command card или имеет служебные координаты.
            set AHUI_CurrentAbility[declaredSlot] = abilityId
            set AHUI_CurrentAbilityPresent[declaredSlot] = true
            set AHUI_CurrentShowAlways[declaredSlot] = true
        endif
    elseif showAlways and AHUI_CurrentAbility[declaredSlot] == 0 then
        // true является явным ручным fallback. Поэтому он может показать
        // rawcode даже тогда, когда объекта ability сейчас нет у героя.
        set AHUI_CurrentAbility[declaredSlot] = abilityId
        set AHUI_CurrentAbilityPresent[declaredSlot] = false
        set AHUI_CurrentShowAlways[declaredSlot] = true
    endif

    set currentAbility = null
    set owner = null
endfunction

// ЭТУ ФУНКЦИЮ НУЖНО РЕДАКТИРОВАТЬ ДЛЯ ДОБАВЛЕНИЯ ГЕРОЕВ/СПОСОБНОСТЕЙ.
//
// Последний аргумент каждой строки:
// false - показывать только когда ability реально есть у героя сейчас;
//         отсутствующая ability полностью скрыта, а существующая, но
//         недоступная, рисуется через DISBTN.
// true  - показывать слот всегда; отсутствующая или недоступная ability
//         остаётся видимой через DISBTN.
//
// Можно добавить несколько rawcode в один declaredSlot. Таймер проверяет их
// каждые AHUI_UPDATE_PERIOD секунд. Существующий кандидат побеждает fallback,
// а при одинаковых координатах побеждает последняя строка.
private function AHUI_AddHeroAbility takes unit whichHero, integer declaredSlot, integer abilityId, boolean showAlways returns nothing
    call AHUI_OfferSingleAbility(whichHero, declaredSlot, abilityId, showAlways)
endfunction

// Каждый тик заново читает фактические abilities выбранного героя и кладёт их
// в Q/W/E/R/T/F/G по текущим координатам Object Editor.
//
// Проход 1: обычное автозаполнение принимает ABILITY_BF_HERO_ABILITY либо
// ability с явным SetPlayerAbilityAvailable(..., true). Второй вариант нужен
// для добавляемых через UnitAddAbility кнопок форм и не пропускает helpers,
// которые никогда явно не включались. Активная ability формы заменяет
// оставшуюся на юните, но отключённую базу.
//
// Проход 2: для КАЖДОЙ ability героя проверяется marker "AHUI swap <rawcode>".
// Явно указанная системой замена получает наивысший приоритет и проходит тот
// же фильтр Hero Ability/явной доступности. Так сохраняется защита от helpers
// и возвращается старый порядок для armor/Cambio/многоступенчатых кнопок.
private function AHUI_ScanHeroAbilitiesByPosition takes unit whichHero returns nothing
    local integer index = 0
    local integer abilityId = 0
    local integer newId = 0
    local integer buttonX = 0
    local integer buttonY = 0
    local integer slot = -1
    local integer heroId = 0
    local boolean currentActive = false
    local boolean candidateActive = false
    local ability currentAbility = null
    local ability newAbility = null
    local player owner = null

    if whichHero == null then
        return
    endif

    set owner = GetOwningPlayer(whichHero)
    set heroId = AHUI_ResolveHeroId(GetUnitTypeId(whichHero))

    // Сначала безопасно выбираем отображаемые abilities по текущим координатам.
    loop
        set currentAbility = BlzGetUnitAbilityByIndex(whichHero, index)
        exitwhen currentAbility == null

        if AHUI_IsDisplayAbilityObject(owner, currentAbility) then
            set abilityId = BlzGetAbilityId(currentAbility)
            set buttonX = BlzGetAbilityIntegerField(currentAbility, ABILITY_IF_BUTTON_POSITION_NORMAL_X)
            set buttonY = BlzGetAbilityIntegerField(currentAbility, ABILITY_IF_BUTTON_POSITION_NORMAL_Y)
            set slot = AHUI_GetLogicalSlot(buttonX, buttonY)

            if abilityId != 0 and slot >= 0 then
                set currentActive = false
                set candidateActive = AHUI_IsActiveSlotCandidate(whichHero, owner, abilityId)

                if AHUI_CurrentAbility[slot] != 0 and AHUI_CurrentAbilityPresent[slot] then
                    set currentActive = AHUI_IsActiveSlotCandidate(whichHero, owner, AHUI_CurrentAbility[slot])
                endif

                // Фактическая ability заменяет отсутствующий fallback. Активная
                // ability формы также заменяет недоступную базу. При двух
                // активных кандидатах сохраняется первый, как в старом коде.
                if AHUI_CurrentAbility[slot] == 0 or not AHUI_CurrentAbilityPresent[slot] or (not currentActive and candidateActive) then
                    set AHUI_CurrentAbility[slot] = abilityId
                    set AHUI_CurrentAbilityPresent[slot] = true
                    set AHUI_CurrentShowAlways[slot] = false
                endif
            endif
        endif

        set index = index + 1
    endloop

    // Затем отдельно применяем все явно зарегистрированные swap-маркеры.
    // Этот второй проход гарантирует, что более поздняя базовая ability из
    // BlzGetUnitAbilityByIndex уже не сможет перезаписать активную замену.
    set index = 0
    loop
        set currentAbility = BlzGetUnitAbilityByIndex(whichHero, index)
        exitwhen currentAbility == null

        set abilityId = BlzGetAbilityId(currentAbility)
        if abilityId != 0 then
            set newId = LoadInteger(hs, GetHandleId(owner), StringHash("AHUI swap " + I2S(abilityId)))
            if newId != 0 and GetUnitAbilityLevel(whichHero, newId) > 0 then
                set newAbility = BlzGetUnitAbility(whichHero, newId)
                if AHUI_IsDisplayAbilityObject(owner, newAbility) then
                    set buttonX = BlzGetAbilityIntegerField(newAbility, ABILITY_IF_BUTTON_POSITION_NORMAL_X)
                    set buttonY = BlzGetAbilityIntegerField(newAbility, ABILITY_IF_BUTTON_POSITION_NORMAL_Y)
                    set slot = AHUI_GetLogicalSlot(buttonX, buttonY)

                    if slot >= 0 then
                        set AHUI_CurrentAbility[slot] = newId
                        set AHUI_CurrentAbilityPresent[slot] = true
                        set AHUI_CurrentShowAlways[slot] = false
                    endif
                endif
            endif
        endif

        set index = index + 1
    endloop

    // В armor-формах Erza слот F относится к ErzaF. Он также проходит общий
    // фильтр Hero Ability и не является обходом защиты от служебных rawcode.
    if heroId == Erza_ID and AHUI_IsAbilityAvailable(owner, ErzaF_ID) then
        set newAbility = BlzGetUnitAbility(whichHero, ErzaF_ID)
        if AHUI_IsDisplayAbilityObject(owner, newAbility) then
            set AHUI_CurrentAbility[AHUI_SLOT_F] = ErzaF_ID
            set AHUI_CurrentAbilityPresent[AHUI_SLOT_F] = true
            set AHUI_CurrentShowAlways[AHUI_SLOT_F] = false
        endif
    endif

    set currentAbility = null
    set newAbility = null
    set owner = null
endfunction

private function AHUI_ConfigureHeroAbilities takes unit whichHero returns nothing
    local integer heroId = AHUI_ResolveHeroId(GetUnitTypeId(whichHero))

    // Все строки по умолчанию используют false: панель показывает только то,
    // что герой действительно имеет в текущий момент. Для постоянного слота
    // замените последний аргумент нужной строки на true.
    if heroId == Ainz_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AinzQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AinzW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, AinzE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, AinzR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, AinzT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, AinzF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, AinzG_ID, false)
    elseif heroId == Raiden_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, RaidenQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, RaidenW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, RaidenE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, RaidenR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, RaidenT_ID, false)
    elseif heroId == Neuvillette_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, NeuvilletteQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, NeuvilletteW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, NeuvilletteE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, NeuvilletteR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, NeuvilletteT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, NeuvilletteF_ID, false)
    elseif heroId == Patriot_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, PatriotQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, PatriotW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, PatriotE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, PatriotR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, PatriotT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, PatriotF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, PatriotG_ID, false)
    elseif heroId == Kyoraku_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, KyorakuQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, KyorakuW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, KyorakuE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, KyorakuR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, KyorakuF_ID, false)
    elseif heroId == BazzB_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, BazzBQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, BazzBW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, BazzBE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, BazzBR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, BazzBT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, BazzBG_ID, false)
    elseif heroId == Harribel_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, HarribelQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, HarribelW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, HarribelE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, HarribelR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, HarribelT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, HarribelG_ID, false)
    elseif heroId == Barragan_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, BarraganQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, BarraganW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, BarraganE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, BarraganR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, BarraganT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, BarraganG_ID, false)
    elseif heroId == Starrk_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, StarrkQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, StarrkW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, StarrkE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, StarrkR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, StarrkT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, StarrkG_ID, false)
    elseif heroId == Bambietta_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, BambiettaQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, BambiettaW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, BambiettaE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, BambiettaR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, BambiettaT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, BambiettaG_ID, false)
    elseif heroId == Natsu_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, NatsuQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, NatsuW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, NatsuE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, NatsuR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, NatsuT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, NatsuF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, NatsuG_ID, false)
    elseif heroId == Erza_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, ErzaQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, ErzaW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, ErzaE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, ErzaR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, ErzaT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, ErzaF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, ErzaG_ID, false)
    elseif heroId == Brandish_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, BrandishQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, BrandishW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, BrandishE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, BrandishR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, BrandishT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, BrandishF_ID, false)
    elseif heroId == Laxus_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, LaxusQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, LaxusW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, LaxusE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, LaxusR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, LaxusT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, LaxusF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, LaxusG_ID, false)
    elseif heroId == Akainu_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AkainuQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AkainuW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, AkainuE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, AkainuR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, AkainuT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, AkainuF_ID, false)
    elseif heroId == Gojo_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, GojoQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, GojoW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, GojoE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, GojoR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, GojoT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, GojoG_ID, false)
    elseif heroId == Kenjaku_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, KenjakuQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, KenjakuW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, KenjakuE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, KenjakuR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KenjakuT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, KenjakuF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, KenjakuG_ID, false)
    elseif heroId == Mahoraga_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, MahoragaQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, MahoragaW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, MahoragaE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, MahoragaR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, MahoragaT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, MahoragaF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, MahoragaG_ID, false)
    elseif heroId == Tomioka_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, TomiokaQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, TomiokaW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, TomiokaE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, TomiokaR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, TomiokaT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, TomiokaF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, TomiokaG_ID, false)
    elseif heroId == AlterSaber_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AlterSaberQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AlterSaberW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, AlterSaberE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, AlterSaberR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, AlterSaberT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, AlterSaberF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, AlterSaberG_ID, false)
    elseif heroId == Inori_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, InoriQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, InoriW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, InoriE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, InoriR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, InoriT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, InoriF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, InoriG_ID, false)
    elseif heroId == Okarun_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, OkarunQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, OkarunW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, OkarunE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, OkarunR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, OkarunT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, OkarunF_ID, false)
    elseif heroId == Tsuna_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, TsunaQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, TsunaW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, TsunaE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, TsunaR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, TsunaT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, TsunaF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, TsunaG_ID, false)
    elseif heroId == Takeshi_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, TakeshiQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, TakeshiW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, TakeshiE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, TakeshiR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, TakeshiT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, TakeshiF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, TakeshiG_ID, false)
    elseif heroId == DarkShiki_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, DarkShikiQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, DarkShikiW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, DarkShikiE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, DarkShikiR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, DarkShikiT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, DarkShikiF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, DarkShikiG_ID, false)
    elseif heroId == Rimuru_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, RimuruQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, RimuruW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, RimuruE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, RimuruR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, RimuruT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, RimuruF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, RimuruG_ID, false)
    elseif heroId == Alucard_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AlucardQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AlucardW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, AlucardE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, AlucardR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, AlucardT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, AlucardF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, AlucardG_ID, false)
    elseif heroId == Kirito_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, KiritoQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, KiritoW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, KiritoE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, KiritoR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KiritoT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, KiritoF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, KiritoG_ID, false)
    elseif heroId == Asta_ID then
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_Q, AstaQ_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_W, AstaW_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_E, AstaE_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_R, AstaR_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, AstaT_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_F, AstaF_ID, false)
        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, AstaG_ID, false)
    endif
endfunction

private function AHUI_GetRequiredHeroLevel takes unit whichHero, integer slot, integer abilityId returns integer
    local integer requiredLevel = LoadInteger(AHUI_AbilityRequirements, 0, abilityId)
    local integer objectLevel = 0
    local ability currentAbility = BlzGetUnitAbility(whichHero, abilityId)

    if slot == AHUI_SLOT_E and requiredLevel < AHUI_E_REQUIRED_LEVEL then
        set requiredLevel = AHUI_E_REQUIRED_LEVEL
    elseif slot == AHUI_SLOT_R and requiredLevel < AHUI_R_REQUIRED_LEVEL then
        set requiredLevel = AHUI_R_REQUIRED_LEVEL
    elseif slot == AHUI_SLOT_T and requiredLevel < AHUI_T_REQUIRED_LEVEL then
        set requiredLevel = AHUI_T_REQUIRED_LEVEL
    endif

    if currentAbility != null then
        set objectLevel = BlzGetAbilityIntegerField(currentAbility, ABILITY_IF_REQUIRED_LEVEL)
        if objectLevel > requiredLevel then
            set requiredLevel = objectLevel
        endif
    endif

    set currentAbility = null
    return requiredLevel
endfunction

private function AHUI_IsAbilityDisabled takes unit whichHero, integer slot, integer abilityId, boolean isPresent returns boolean
    local player owner = null
    local boolean disabled = false

    if not isPresent then
        return true
    endif

    set owner = GetOwningPlayer(whichHero)
    set disabled = not AHUI_IsAbilityAvailable(owner, abilityId)

    if not disabled then
        set disabled = LoadBoolean(AHUI_UnitAbilityHidden, GetHandleId(whichHero), abilityId)
    endif
    if not disabled then
        set disabled = LoadBoolean(AHUI_UnitAbilityDisabled, GetHandleId(whichHero), abilityId)
    endif
    if not disabled then
        set disabled = GetUnitAbilityLevel(whichHero, abilityId) <= 0
    endif
    if not disabled then
        set disabled = GetHeroLevel(whichHero) < AHUI_GetRequiredHeroLevel(whichHero, slot, abilityId)
    endif

    set owner = null
    return disabled
endfunction

private function AHUI_FormatCooldown takes real remaining returns string
    if remaining >= 10.00 then
        return I2S(R2I(remaining + 0.99))
    endif
    return R2SW(remaining, 1, 1)
endfunction

private function AHUI_HideTooltip takes integer pid returns nothing
    call BlzFrameSetVisible(AHUI_TooltipRoot[pid], false)
endfunction

private function AHUI_HideSlot takes integer pid, integer slot returns nothing
    local integer index = AHUI_FrameIndex(pid, slot)

    set AHUI_RenderedAbility[index] = 0
    set AHUI_RenderedIconPath[index] = null
    set AHUI_SlotVisible[index] = false
    set AHUI_SlotDisabled[index] = false

    // Функция вызывается только из локальной ветки соответствующего pid.
    call BlzFrameSetVisible(AHUI_Root[index], false)
    call BlzFrameSetVisible(AHUI_CooldownFill[index], false)
    call BlzFrameSetVisible(AHUI_CooldownText[index], false)
    call BlzFrameSetVisible(AHUI_KeyText[index], false)

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
    local real fullCooldown = 0.00
    local real progress = 0.00
    local string iconPath = null
    local boolean disabled = false

    if abilityId == 0 or (not AHUI_CurrentAbilityPresent[slot] and not AHUI_CurrentShowAlways[slot]) then
        call AHUI_HideSlot(pid, slot)
        return
    endif

    set level = GetUnitAbilityLevel(AHUI_SelectedHero[pid], abilityId)
    set disabled = AHUI_IsAbilityDisabled(AHUI_SelectedHero[pid], slot, abilityId, AHUI_CurrentAbilityPresent[slot])
    set iconPath = BlzGetAbilityIcon(abilityId)

    if AHUI_RenderedAbility[index] != abilityId or AHUI_RenderedIconPath[index] != iconPath then
        set AHUI_RenderedAbility[index] = abilityId
        set AHUI_RenderedIconPath[index] = iconPath
        call BlzFrameSetTexture(AHUI_Icon[index], iconPath, 0, true)
        call BlzFrameSetTexture(AHUI_CooldownFill[index], ConvertBTNtoDISBTN(iconPath), 0, true)
    endif

    set AHUI_SlotVisible[index] = true
    set AHUI_SlotDisabled[index] = disabled
    call BlzFrameSetVisible(AHUI_Root[index], true)
    call BlzFrameSetVisible(AHUI_KeyText[index], true)

    if disabled then
        call BlzFrameSetAlpha(AHUI_Icon[index], 0)
        call BlzFrameSetAlpha(AHUI_CooldownFill[index], 255)
        call BlzFrameSetVisible(AHUI_CooldownFill[index], true)
        call BlzFrameSetVisible(AHUI_CooldownText[index], false)
        set iconPath = null
        return
    endif

    set remaining = BlzGetUnitAbilityCooldownRemaining(AHUI_SelectedHero[pid], abilityId)
    if remaining > 0.05 then
        set fullCooldown = BlzGetUnitAbilityCooldown(AHUI_SelectedHero[pid], abilityId, level - 1)
        if fullCooldown > 0.00 then
            set progress = remaining / fullCooldown
            if progress > 1.00 then
                set progress = 1.00
            elseif progress < 0.00 then
                set progress = 0.00
            endif

            call BlzFrameSetAlpha(AHUI_CooldownFill[index], R2I(255.00 * progress))
            call BlzFrameSetAlpha(AHUI_Icon[index], R2I(255.00 * (1.00 - progress)))
            call BlzFrameSetVisible(AHUI_CooldownFill[index], true)
        else
            call BlzFrameSetAlpha(AHUI_Icon[index], AHUI_READY_ALPHA)
            call BlzFrameSetVisible(AHUI_CooldownFill[index], false)
        endif

        call BlzFrameSetText(AHUI_CooldownText[index], "|cffffffff" + AHUI_FormatCooldown(remaining) + "|r")
        call BlzFrameSetVisible(AHUI_CooldownText[index], true)
    else
        call BlzFrameSetAlpha(AHUI_Icon[index], AHUI_READY_ALPHA)
        call BlzFrameSetVisible(AHUI_CooldownFill[index], false)
        call BlzFrameSetVisible(AHUI_CooldownText[index], false)
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

    if AHUI_SlotDisabled[index] then
        set title = title + " |cffff8080[недоступно]|r"
    endif

    call BlzFrameSetText(AHUI_TooltipTitle[pid], title)
    call BlzFrameSetText(AHUI_TooltipText[pid], description)

    // Позиция каждый раз привязывается именно к стандартному command button,
    // над которым сейчас находится мышь.
    call BlzFrameClearAllPoints(AHUI_TooltipRoot[pid])
    call BlzFrameSetPoint(AHUI_TooltipRoot[pid], FRAMEPOINT_BOTTOM, AHUI_Origin[slot], FRAMEPOINT_TOP, 0.00, 0.008)
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

    set owner = GetOwningPlayer(whichHero)
    set result = owner != Player(viewerId) and IsPlayerAlly(Player(viewerId), owner)

    set owner = null
    return result
endfunction

private function AHUI_ClearSelection takes integer pid returns nothing
    if GetLocalPlayer() != Player(pid) then
        return
    endif

    set AHUI_SelectedHero[pid] = null
    set AHUI_HoveredSlot[pid] = -1
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

    // Никакое состояние не берётся из предыдущего тика: ручные if/elseif и
    // фактические hero abilities по координатам вычисляются заново.
    call AHUI_ClearResolvedAbilities()
    call AHUI_ConfigureHeroAbilities(AHUI_SelectedHero[pid])
    call AHUI_ScanHeroAbilitiesByPosition(AHUI_SelectedHero[pid])

    loop
        exitwhen slot >= AHUI_SLOT_COUNT
        call AHUI_RefreshSlot(pid, slot)
        set slot = slot + 1
    endloop

    call AHUI_RefreshTooltip(pid)
endfunction

private function AHUI_Periodic takes nothing returns nothing
    local integer pid = 0

    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        if GetLocalPlayer() == Player(pid) then
            if AHUI_SelectedHero[pid] != null then
                call AHUI_Refresh(pid)
            elseif AHUI_HoveredSlot[pid] >= 0 then
                call AHUI_HideTooltip(pid)
            endif
        endif
        set pid = pid + 1
    endloop
endfunction

private function AHUI_OnSelect takes nothing returns nothing
    local unit selected = GetTriggerUnit()
    local integer pid = GetPlayerId(GetTriggerPlayer())

    // Никакой переменной player = GetLocalPlayer(): только прямая проверка.
    if GetLocalPlayer() == Player(pid) then
        if AHUI_IsEligibleHero(selected, pid) then
            set AHUI_SelectedHero[pid] = selected
            call AHUI_Refresh(pid)
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

private function AHUI_OnFrameEnter takes nothing returns nothing
    local integer pid = 0

    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        if GetLocalPlayer() == Player(pid) then
            set AHUI_HoveredSlot[pid] = LoadInteger(AHUI_FrameSlots, GetHandleId(BlzGetTriggerFrame()), 0) - 1
            call AHUI_RefreshTooltip(pid)
        endif
        set pid = pid + 1
    endloop
endfunction

private function AHUI_OnFrameLeave takes nothing returns nothing
    local integer pid = 0
    local integer slot = LoadInteger(AHUI_FrameSlots, GetHandleId(BlzGetTriggerFrame()), 0) - 1

    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        if GetLocalPlayer() == Player(pid) and slot == AHUI_HoveredSlot[pid] then
            set AHUI_HoveredSlot[pid] = -1
            call AHUI_HideTooltip(pid)
        endif
        set pid = pid + 1
    endloop
endfunction

// Read-only API совместимости: возвращает реально существующую ability,
// которая сейчас имеет заданные координаты стандартной command card.
function AHUI_GetAbilityAtCommandSlot takes unit whichUnit, integer commandSlot returns integer
    local integer targetY = 0
    local integer targetX = 0
    local integer index = 0
    local integer abilityId = 0
    local integer swapId = 0
    local integer result = 0
    local integer swapResult = 0
    local integer heroId = 0
    local boolean resultActive = false
    local boolean candidateActive = false
    local ability currentAbility = null
    local ability swapAbility = null
    local player owner = null

    if whichUnit == null or commandSlot < 0 or commandSlot > 11 then
        return 0
    endif

    set targetY = R2I(I2R(commandSlot) / 4.00)
    set targetX = commandSlot - targetY * 4
    set owner = GetOwningPlayer(whichUnit)
    set heroId = AHUI_ResolveHeroId(GetUnitTypeId(whichUnit))

    loop
        set currentAbility = BlzGetUnitAbilityByIndex(whichUnit, index)
        exitwhen currentAbility == null
        set abilityId = BlzGetAbilityId(currentAbility)

        if abilityId != 0 and AHUI_IsDisplayAbilityObject(owner, currentAbility) and BlzGetAbilityIntegerField(currentAbility, ABILITY_IF_BUTTON_POSITION_NORMAL_X) == targetX and BlzGetAbilityIntegerField(currentAbility, ABILITY_IF_BUTTON_POSITION_NORMAL_Y) == targetY then
            set candidateActive = AHUI_IsActiveSlotCandidate(whichUnit, owner, abilityId)
            if result == 0 or (not resultActive and candidateActive) then
                set result = abilityId
                set resultActive = candidateActive
            endif
        endif

        set swapId = LoadInteger(hs, GetHandleId(owner), StringHash("AHUI swap " + I2S(abilityId)))
        if swapId != 0 then
            set swapAbility = BlzGetUnitAbility(whichUnit, swapId)
            if AHUI_IsDisplayAbilityObject(owner, swapAbility) and BlzGetAbilityIntegerField(swapAbility, ABILITY_IF_BUTTON_POSITION_NORMAL_X) == targetX and BlzGetAbilityIntegerField(swapAbility, ABILITY_IF_BUTTON_POSITION_NORMAL_Y) == targetY then
                set swapResult = swapId
            endif
        endif

        set index = index + 1
    endloop

    // Swap применяется после полного сканирования и не может быть затёрт
    // более поздней базовой ability из BlzGetUnitAbilityByIndex.
    if swapResult != 0 then
        set result = swapResult
    endif

    if heroId == Erza_ID and targetX == 1 and targetY == 1 and AHUI_IsAbilityAvailable(owner, ErzaF_ID) then
        set swapAbility = BlzGetUnitAbility(whichUnit, ErzaF_ID)
        if AHUI_IsDisplayAbilityObject(owner, swapAbility) then
            set result = ErzaF_ID
        endif
    endif

    set currentAbility = null
    set swapAbility = null
    set owner = null
    return result
endfunction

function AHUI_IsAbilityLearnedAtCommandSlot takes unit whichUnit, integer commandSlot, integer abilityId returns boolean
    local integer targetY = 0
    local integer targetX = 0
    local integer logicalSlot = -1
    local boolean result = false
    local ability currentAbility = null
    local player owner = null

    if whichUnit == null or abilityId == 0 or commandSlot < 0 or commandSlot > 11 then
        return false
    endif
    set currentAbility = BlzGetUnitAbility(whichUnit, abilityId)
    set owner = GetOwningPlayer(whichUnit)
    if not AHUI_IsDisplayAbilityObject(owner, currentAbility) or GetUnitAbilityLevel(whichUnit, abilityId) <= 0 then
        set currentAbility = null
        set owner = null
        return false
    endif

    set targetY = R2I(I2R(commandSlot) / 4.00)
    set targetX = commandSlot - targetY * 4
    set logicalSlot = AHUI_GetLogicalSlot(targetX, targetY)

    if logicalSlot >= 0 then
        set result = GetHeroLevel(whichUnit) >= AHUI_GetRequiredHeroLevel(whichUnit, logicalSlot, abilityId)
    else
        set result = true
    endif

    set currentAbility = null
    set owner = null
    return result
endfunction

private function AHUI_CreateSlotFrames takes nothing returns nothing
    local integer pid = 0
    local integer slot = 0
    local integer index = 0
    local framehandle console = BlzGetFrameByName("ConsoleUIBackdrop", 0)

    // Origin-фреймы общие. Сохраняем их и регистрируем hover ровно один раз.
    loop
        exitwhen slot >= AHUI_SLOT_COUNT
        set AHUI_Origin[slot] = BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, AHUI_GetOriginSlot(slot))
        call SaveInteger(AHUI_FrameSlots, GetHandleId(AHUI_Origin[slot]), 0, slot + 1)
        call BlzTriggerRegisterFrameEvent(AHUI_FrameEnterTrigger, AHUI_Origin[slot], FRAMEEVENT_MOUSE_ENTER)
        call BlzTriggerRegisterFrameEvent(AHUI_FrameLeaveTrigger, AHUI_Origin[slot], FRAMEEVENT_MOUSE_LEAVE)
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
            call BlzFrameSetVisible(AHUI_Icon[index], true)

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
    local framehandle console = BlzGetFrameByName("ConsoleUIBackdrop", 0)

    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS

        set AHUI_TooltipRoot[pid] = BlzCreateFrameByType("FRAME", "AHUITooltipRoot", console, "", pid)
        call BlzFrameSetSize(AHUI_TooltipRoot[pid], 0.300, 0.105)
        call BlzFrameSetLevel(AHUI_TooltipRoot[pid], 200)
        call BlzFrameSetEnable(AHUI_TooltipRoot[pid], false)
        call BlzFrameSetVisible(AHUI_TooltipRoot[pid], false)

        set AHUI_TooltipBackdrop[pid] = BlzCreateFrameByType("BACKDROP", "AHUITooltipBackdrop", AHUI_TooltipRoot[pid], "", pid)
        call BlzFrameSetAllPoints(AHUI_TooltipBackdrop[pid], AHUI_TooltipRoot[pid])
        call BlzFrameSetTexture(AHUI_TooltipBackdrop[pid], "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp", 0, true)
        call BlzFrameSetAlpha(AHUI_TooltipBackdrop[pid], 245)
        call BlzFrameSetLevel(AHUI_TooltipBackdrop[pid], 201)
        call BlzFrameSetEnable(AHUI_TooltipBackdrop[pid], false)

        set AHUI_TooltipTitle[pid] = BlzCreateFrameByType("TEXT", "AHUITooltipTitle", AHUI_TooltipRoot[pid], "", pid)
        call BlzFrameClearAllPoints(AHUI_TooltipTitle[pid])
        call BlzFrameSetSize(AHUI_TooltipTitle[pid], 0.282, 0.020)
        call BlzFrameSetPoint(AHUI_TooltipTitle[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.009, -0.008)
        call BlzFrameSetTextAlignment(AHUI_TooltipTitle[pid], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
        call BlzFrameSetScale(AHUI_TooltipTitle[pid], 1.10)
        call BlzFrameSetLevel(AHUI_TooltipTitle[pid], 202)
        call BlzFrameSetEnable(AHUI_TooltipTitle[pid], false)

        set AHUI_TooltipText[pid] = BlzCreateFrameByType("TEXT", "AHUITooltipText", AHUI_TooltipRoot[pid], "", pid)
        call BlzFrameClearAllPoints(AHUI_TooltipText[pid])
        call BlzFrameSetSize(AHUI_TooltipText[pid], 0.282, 0.069)
        call BlzFrameSetPoint(AHUI_TooltipText[pid], FRAMEPOINT_TOPLEFT, AHUI_TooltipRoot[pid], FRAMEPOINT_TOPLEFT, 0.009, -0.030)
        call BlzFrameSetTextAlignment(AHUI_TooltipText[pid], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
        call BlzFrameSetLevel(AHUI_TooltipText[pid], 202)
        call BlzFrameSetEnable(AHUI_TooltipText[pid], false)

        set pid = pid + 1
    endloop

    set console = null
endfunction

private function AHUI_InitEvents takes nothing returns nothing
    local integer pid = 0

    set AHUI_SelectTrigger = CreateTrigger()
    set AHUI_DeselectTrigger = CreateTrigger()
    set AHUI_FrameEnterTrigger = CreateTrigger()
    set AHUI_FrameLeaveTrigger = CreateTrigger()

    call TriggerAddAction(AHUI_SelectTrigger, function AHUI_OnSelect)
    call TriggerAddAction(AHUI_DeselectTrigger, function AHUI_OnDeselect)
    call TriggerAddAction(AHUI_FrameEnterTrigger, function AHUI_OnFrameEnter)
    call TriggerAddAction(AHUI_FrameLeaveTrigger, function AHUI_OnFrameLeave)

    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        call TriggerRegisterPlayerUnitEvent(AHUI_SelectTrigger, Player(pid), EVENT_PLAYER_UNIT_SELECTED, null)
        call TriggerRegisterPlayerUnitEvent(AHUI_DeselectTrigger, Player(pid), EVENT_PLAYER_UNIT_DESELECTED, null)
        set pid = pid + 1
    endloop
endfunction

private function AHUI_RegisterKnownRequirements takes nothing returns nothing
    call AHUI_RegisterAbilityRequirement(KenjakuF_ID, 35)
    call AHUI_RegisterAbilityRequirement(DarkShikiG_ID, 35)
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
    call AHUI_RegisterKnownRequirements()
    call AHUI_InitPlayerState()
    call AHUI_InitEvents()
    call AHUI_CreateSlotFrames()
    call AHUI_CreateTooltipFrames()

    set AHUI_UpdateTimer = CreateTimer()
    call TimerStart(AHUI_UpdateTimer, AHUI_UPDATE_PERIOD, true, function AHUI_Periodic)
endfunction

endlibrary
