//===========================================================================
// WoS Scoreboard — compact Horde edition
// Компактная таблица общей статистики на клавишу P.
//===========================================================================
library WosScoreboard initializer WOS_STATS_Init requires heroicon

globals
    //=======================================================================
    // НАСТРОЙКА ТЕКСТУР
    // Все пути собраны здесь, чтобы оформление можно было менять без поиска
    // по остальному коду.
    //=======================================================================
    private constant string WOS_STATS_FRAME_TEMPLATE = "ListBoxWar3"
    // Р‘РµР»Р°СЏ РѕСЃРЅРѕРІР° РЅСѓР¶РЅР° РґР»СЏ BlzFrameSetVertexColor: С‡С‘СЂРЅСѓСЋ С‚РµРєСЃС‚СѓСЂСѓ РЅРµРІРѕР·РјРѕР¶РЅРѕ РѕРєСЂР°СЃРёС‚СЊ.
    private constant string WOS_STATS_TEX_ROW = "Textures\\white.blp"
    private constant string WOS_STATS_TEX_PANEL_FILL = "Textures\\black32.blp"
    private constant string WOS_STATS_TEX_TOOLTIP = "Textures\\black32.blp"
    private constant string WOS_STATS_TEX_CLOSE = "Music\\Music_Close.blp"
    private constant string WOS_STATS_TEX_OPACITY_OFF = "Pick\\wos_transp.blp"
    private constant string WOS_STATS_TEX_OPACITY_ON = "Pick\\wos_transp2.blp"
    private constant string WOS_STATS_TEX_EXPAND = "Pick\\wos_expand.blp"
    private constant string WOS_STATS_TEX_COLLAPSE = "Pick\\wos_squeze.blp"
    private constant string WOS_STATS_TEX_EMPTY = "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder"

    //=======================================================================
    // НАСТРОЙКА РАЗМЕРА И ПЛОТНОСТИ
    // Максимальная панель занимает меньше половины площади предыдущей версии.
    // При неполных командах высота дополнительно сжимается автоматически.
    //=======================================================================
    private constant integer WOS_STATS_PLAYER_COUNT = 10
    private constant integer WOS_STATS_TEAM_SIZE = 5
    private constant integer WOS_STATS_ITEM_COUNT = 6
    private constant real WOS_STATS_UPDATE_PERIOD = 0.25

    private constant real WOS_STATS_PANEL_X = 0.400
    private constant real WOS_STATS_PANEL_TOP = 0.505
    private constant real WOS_STATS_PANEL_Y = 0.360
    private constant real WOS_STATS_PANEL_WIDTH = 0.420
    private constant real WOS_STATS_PANEL_HEIGHT = 0.290
    private constant real WOS_STATS_CONTENT_WIDTH = 0.408
    private constant real WOS_STATS_CONTENT_HEIGHT = 0.278
    private constant real WOS_STATS_ROW_WIDTH = 0.406
    private constant real WOS_STATS_ROW_HEIGHT = 0.0135
    private constant real WOS_STATS_ROW_STEP = 0.014
    private constant real WOS_STATS_HERO_ICON_SIZE = 0.013
    private constant real WOS_STATS_ITEM_ICON_SIZE = 0.0105
    private constant real WOS_STATS_ITEM_STEP = 0.0122
    private constant integer WOS_STATS_TOOLTIP_ALPHA = 175

    private constant real WOS_STATS_EXPANDED_WIDTH = 0.690
    private constant real WOS_STATS_EXPANDED_CONTENT_WIDTH = 0.678
    private constant real WOS_STATS_EXPANDED_ROW_WIDTH = 0.674
    private constant real WOS_STATS_EXPANDED_ROW_HEIGHT = 0.019
    private constant real WOS_STATS_EXPANDED_ROW_STEP = 0.0205
    // РћС‚РґРµР»СЊРЅС‹Р№ СЃРґРІРёРі С‚РѕР»СЊРєРѕ РґР»СЏ Р±РѕР»СЊС€РѕРіРѕ РѕРєРЅР°; РєРѕРјРїР°РєС‚РЅРѕРµ РѕСЃС‚Р°С‘С‚СЃСЏ РЅР° РјРµСЃС‚Рµ.
    private constant real WOS_STATS_EXPANDED_Y_OFFSET = 0.065

    // true  = всегда показывать полную таблицу 5 на 5, включая пустые слоты.
    // false = рисовать только игроков, которые сейчас играют и имеют героя.
    // Это не constant: значение можно переключать во время игры через set.
    boolean WOS_STATS_SHOW_INACTIVE_PLAYERS = true

    // Общий масштаб всего интерфейса. 1.12 = увеличение на 12%.
    // Меняются панель, координаты, строки, текст, иконки и подсказки.
    real WOS_STATS_UI_SCALE = 1.15

    //=======================================================================
    // НАСТРОЙКА MVP
    // Формула учитывает убийства, нанесённый урон, лечение, танкование и смерти.
    // Делители и веса вынесены сюда для простой балансировки.
    //=======================================================================
    private constant real WOS_STATS_MVP_KILL_WEIGHT = 6.00
    private constant real WOS_STATS_MVP_DEATH_PENALTY = 1.50
    private constant real WOS_STATS_MVP_DAMAGE_DIVISOR = 1000.00
    private constant real WOS_STATS_MVP_HEAL_DIVISOR = 1200.00
    private constant real WOS_STATS_MVP_TAKEN_DIVISOR = 2500.00

    private trigger WOS_STATS_KeyTrigger = null
    private trigger WOS_STATS_CloseTrigger = null
    private trigger WOS_STATS_OpacityTrigger = null
    private trigger WOS_STATS_ExpandTrigger = null
    private timer WOS_STATS_UpdateTimer = null

    private framehandle WOS_STATS_Main = null
    private framehandle WOS_STATS_Inner = null
    private framehandle WOS_STATS_OpaqueBack = null
    private framehandle WOS_STATS_Title = null
    private framehandle WOS_STATS_MatchInfo = null
    private framehandle WOS_STATS_Score = null
    private framehandle WOS_STATS_ScreenshotClock = null
    private framehandle WOS_STATS_GameClock = null
    private framehandle WOS_STATS_CloseButton = null
    private framehandle WOS_STATS_CloseIcon = null
    private framehandle WOS_STATS_OpacityButton = null
    private framehandle WOS_STATS_OpacityIcon = null
    private framehandle WOS_STATS_ExpandButton = null
    private framehandle WOS_STATS_ExpandIcon = null

    private framehandle array WOS_STATS_TeamTitle
    private framehandle array WOS_STATS_HeaderText
    private framehandle array WOS_STATS_RowBack
    private framehandle array WOS_STATS_RowContent
    private framehandle array WOS_STATS_HeroIcon
    private framehandle array WOS_STATS_MvpText
    private framehandle array WOS_STATS_MvpHover
    private framehandle array WOS_STATS_PlayerName
    private framehandle array WOS_STATS_KillText
    private framehandle array WOS_STATS_DeathText
    private framehandle array WOS_STATS_DamageText
    private framehandle array WOS_STATS_DamageMagText
    private framehandle array WOS_STATS_HealText
    private framehandle array WOS_STATS_TakenText
    private framehandle array WOS_STATS_TakenMagText
    private framehandle array WOS_STATS_DamageHover
    private framehandle array WOS_STATS_TakenHover
    private framehandle array WOS_STATS_ItemButton
    private framehandle array WOS_STATS_ItemIcon
    private framehandle array WOS_STATS_ItemTooltip
    private framehandle array WOS_STATS_ItemTooltipText
    private framehandle array WOS_STATS_CombatTooltip
    private framehandle array WOS_STATS_CombatTooltipText
    private framehandle array WOS_STATS_TotalText
    private framehandle array WOS_STATS_TotalLabel
    private framehandle array WOS_STATS_TotalDamageHover
    private framehandle array WOS_STATS_TotalTakenHover

    private integer array WOS_STATS_LastHeroType
    private integer array WOS_STATS_LastItemId
    private integer array WOS_STATS_LastRowPid
    private boolean array WOS_STATS_IsOpen
    private boolean array WOS_STATS_IsOpaque
    private boolean array WOS_STATS_IsExpanded
    private boolean array WOS_STATS_IsFinal

    // Запоминаем состояние старого F2-интерфейса и возвращаем после закрытия.
    private boolean array WOS_STATS_OldTopVisible
    private boolean array WOS_STATS_OldTakenVisible
    private boolean array WOS_STATS_OldOptionsVisible
    private boolean array WOS_STATS_OldCameraVisible
    private boolean array WOS_STATS_OldHeroStatsVisible
endglobals

//===========================================================================
// Форматирование и геометрия
//===========================================================================
private function WOS_STATS_FormatK takes integer value returns string
    // Одинаковое округление в скорборде и HeroIcon.
    return FormatK(value)
endfunction

private function WOS_STATS_Pad2 takes integer value returns string
    if value < 10 then
        return "0" + I2S(value)
    endif
    return I2S(value)
endfunction

// The statistics source can briefly underflow while round data is reset.
// Never let that transient value leak into the scoreboard, team total or MVP score.
private function WOS_STATS_NonNegative takes integer value returns integer
    if value < 0 then
        return 0
    endif
    return value
endfunction

private function WOS_STATS_PlayerSlotColor takes integer pid, integer alpha returns integer
    if pid == 0 then
        return BlzConvertColor(alpha, 255, 3, 3)
    elseif pid == 1 then
        return BlzConvertColor(alpha, 0, 66, 255)
    elseif pid == 2 then
        return BlzConvertColor(alpha, 28, 230, 185)
    elseif pid == 3 then
        return BlzConvertColor(alpha, 84, 0, 129)
    elseif pid == 4 then
        return BlzConvertColor(alpha, 255, 252, 1)
    elseif pid == 5 then
        return BlzConvertColor(alpha, 254, 138, 14)
    elseif pid == 6 then
        return BlzConvertColor(alpha, 32, 192, 0)
    elseif pid == 7 then
        return BlzConvertColor(alpha, 229, 91, 176)
    elseif pid == 8 then
        return BlzConvertColor(alpha, 149, 150, 151)
    endif
    return BlzConvertColor(alpha, 126, 191, 241)
endfunction

private function WOS_STATS_GameTime takes nothing returns string
    if FRAME_GameTimerHour > 0 then
        return I2S(FRAME_GameTimerHour) + ":" + WOS_STATS_Pad2(FRAME_GameTimerMin) + ":" + WOS_STATS_Pad2(FRAME_GameTimerSec)
    endif
    return WOS_STATS_Pad2(FRAME_GameTimerMin) + ":" + WOS_STATS_Pad2(FRAME_GameTimerSec)
endfunction

private function WOS_STATS_Percent takes integer part, integer total returns string
    if total <= 0 then
        return "0.0%"
    endif
    return R2SW(100.00 * I2R(part) / I2R(total), 0, 1) + "%"
endfunction

private function WOS_STATS_OneLine takes string value returns string
    local integer index = 0
    local integer length = StringLength(value)
    local string result = ""

    loop
        exitwhen index >= length
        if index + 2 <= length and SubString(value, index, index + 2) == "|n" then
            set index = index + 2
        else
            set result = result + SubString(value, index, index + 1)
            set index = index + 1
        endif
    endloop
    return result
endfunction

private function WOS_STATS_ColumnX takes integer column returns real
    if column == 0 then
        return 0.340
    elseif column == 1 then
        return 0.365
    elseif column == 2 then
        return 0.405
    elseif column == 3 then
        return 0.455
    endif
    return 0.490
endfunction

private function WOS_STATS_ColumnWidth takes integer column returns real
    if column == 0 then
        return 0.055
    elseif column == 1 then
        return 0.038
    elseif column == 2 then
        return 0.052
    elseif column == 3 then
        return 0.042
    endif
    return 0.042
endfunction

// Семь отдельных статистических колонок подробного режима:
// Kills, Deaths, Physical/Magical Dealt, Heal, Physical/Magical Taken.
private function WOS_STATS_ExpandedColumnX takes integer column returns real
    if column == 0 then
        return 0.230
    elseif column == 1 then
        return 0.275
    elseif column == 2 then
        return 0.335
    elseif column == 3 then
        return 0.395
    elseif column == 4 then
        return 0.450
    elseif column == 5 then
        return 0.515
    endif
    return 0.575
endfunction

private function WOS_STATS_ExpandedColumnWidth takes integer column returns real
    if column == 0 or column == 1 then
        return 0.040
    elseif column == 4 then
        return 0.045
    endif
    return 0.055
endfunction

private function WOS_STATS_RowY takes integer row returns real
    if row < WOS_STATS_TEAM_SIZE then
        return 0.428 - I2R(row) * WOS_STATS_ROW_STEP
    endif
    return 0.313 - I2R(row - WOS_STATS_TEAM_SIZE) * WOS_STATS_ROW_STEP
endfunction

// Возвращает pid из сохранённых Captain-составов без запасных подстановок.
private function WOS_STATS_GetCaptainPidForRowRaw takes integer row returns integer
    local integer teamSlot

    if row < 0 or row >= WOS_STATS_PLAYER_COUNT then
        return -1
    endif
    if row < WOS_STATS_TEAM_SIZE then
        if row < FullTeam1Size then
            return FullTeam1[row]
        endif
        return -1
    endif
    set teamSlot = row - WOS_STATS_TEAM_SIZE
    if teamSlot < FullTeam2Size then
        return FullTeam2[teamSlot]
    endif
    return -1
endfunction

// Один pid разрешён только в первой найденной строке. Это защищает табло,
// даже если внешняя логика состава временно записала игрока повторно.
private function WOS_STATS_IsCaptainPidUsedBeforeRow takes integer pid, integer row returns boolean
    local integer previousRow = 0

    loop
        exitwhen previousRow >= row
        if WOS_STATS_GetCaptainPidForRowRaw(previousRow) == pid then
            return true
        endif
        set previousRow = previousRow + 1
    endloop
    return false
endfunction

// Проверяет, присутствует ли игрок хотя бы в одной сохранённой команде.
// Такой pid нельзя повторно показывать как запасной номер пустой строки.
private function WOS_STATS_IsCaptainPidSaved takes integer pid returns boolean
    local integer row = 0

    loop
        exitwhen row >= WOS_STATS_PLAYER_COUNT
        if WOS_STATS_GetCaptainPidForRowRaw(row) == pid then
            return true
        endif
        set row = row + 1
    endloop
    return false
endfunction

private function WOS_STATS_GetPidForRow takes integer row returns integer
    local integer pid

    if CaptainMode then
        // После окончания матча CapPickPhase может быть уже сброшен, но
        // финальная таблица всё равно должна брать сохранённые составы команд.
        if CapPickPhase < 4 and END1 == 0 then
            return -1
        endif
        set pid = WOS_STATS_GetCaptainPidForRowRaw(row)
        if pid < 0 or pid >= WOS_STATS_PLAYER_COUNT then
            return -1
        endif
        if WOS_STATS_IsCaptainPidUsedBeforeRow(pid, row) then
            return -1
        endif
        return pid
    endif
    return row
endfunction

// После формирования составов запасной pid разрешён только игрокам, которых
// вообще нет в сохранённых командах. Поэтому неактивные игроки остаются
// видимыми, но уже назначенный игрок не может появиться второй раз.
private function WOS_STATS_GetDisplayPidForRow takes integer row returns integer
    local integer pid = WOS_STATS_GetPidForRow(row)

    if pid < 0 and WOS_STATS_SHOW_INACTIVE_PLAYERS then
        if not CaptainMode or (CapPickPhase < 4 and END1 == 0) then
            return row
        endif
        if not WOS_STATS_IsCaptainPidSaved(row) then
            return row
        endif
    endif
    return pid
endfunction

private function WOS_STATS_ShouldDisplayPid takes integer pid returns boolean
    if pid < 0 or pid >= WOS_STATS_PLAYER_COUNT then
        return false
    endif
    if WOS_STATS_SHOW_INACTIVE_PLAYERS then
        return true
    endif
    return Hero[pid] != null and GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING
endfunction

//===========================================================================
// Единый масштаб интерфейса
// X масштабируется относительно центра экрана, Y — относительно верхнего
// края панели. Поэтому увеличение не уводит верхнюю рамку за предел экрана.
//===========================================================================
private function WOS_STATS_GetUIScale takes nothing returns real
    if WOS_STATS_UI_SCALE < 0.50 then
        return 0.50
    elseif WOS_STATS_UI_SCALE > 1.50 then
        return 1.50
    endif
    return WOS_STATS_UI_SCALE
endfunction

private function WOS_STATS_ScaleX takes real x returns real
    return WOS_STATS_PANEL_X + (x - WOS_STATS_PANEL_X) * WOS_STATS_GetUIScale()
endfunction

private function WOS_STATS_ScaleY takes real y returns real
    return WOS_STATS_PANEL_TOP - (WOS_STATS_PANEL_TOP - y) * WOS_STATS_GetUIScale()
endfunction

private function WOS_STATS_ScaleSize takes real value returns real
    return value * WOS_STATS_GetUIScale()
endfunction

private function WOS_STATS_CreateText takes framehandle parent, real x, real y, real width, real height, real scale, textaligntype horizontal, string value, integer context returns framehandle
    local framehandle textFrame = BlzCreateFrameByType("TEXT", "WosStatsText", parent, "", context)

    call BlzFrameSetAbsPoint(textFrame, FRAMEPOINT_CENTER, WOS_STATS_ScaleX(x), WOS_STATS_ScaleY(y))
    call BlzFrameSetSize(textFrame, WOS_STATS_ScaleSize(width), WOS_STATS_ScaleSize(height))
    call BlzFrameSetTextAlignment(textFrame, TEXT_JUSTIFY_MIDDLE, horizontal)
    call BlzFrameSetScale(textFrame, scale * WOS_STATS_GetUIScale())
    call BlzFrameSetText(textFrame, value)
    return textFrame
endfunction

private function WOS_STATS_CreateBackdrop takes framehandle parent, string texture, real x, real y, real width, real height, integer alpha, integer context returns framehandle
    local framehandle back = BlzCreateFrameByType("BACKDROP", "WosStatsBackdrop", parent, "", context)

    call BlzFrameSetAbsPoint(back, FRAMEPOINT_CENTER, WOS_STATS_ScaleX(x), WOS_STATS_ScaleY(y))
    call BlzFrameSetSize(back, WOS_STATS_ScaleSize(width), WOS_STATS_ScaleSize(height))
    call BlzFrameSetTexture(back, texture, 0, true)
    call BlzFrameSetAlpha(back, alpha)
    return back
endfunction

private function WOS_STATS_CreateHoverArea takes framehandle parent, real x, real y, real width, real height, integer context returns framehandle
    local framehandle hover = BlzCreateFrameByType("BUTTON", "WosStatsHoverArea", parent, "", context)

    call BlzFrameSetAbsPoint(hover, FRAMEPOINT_CENTER, WOS_STATS_ScaleX(x), WOS_STATS_ScaleY(y))
    call BlzFrameSetSize(hover, WOS_STATS_ScaleSize(width), WOS_STATS_ScaleSize(height))
    call BlzFrameSetAlpha(hover, 0)
    call BlzFrameSetLevel(hover, 20)
    return hover
endfunction

//===========================================================================
// Подсказки
//===========================================================================
private function WOS_STATS_VisibleTextLength takes string text returns integer
    local integer index = 0
    local integer length = StringLength(text)
    local integer visibleLength = 0

    loop
        exitwhen index >= length
        if index + 10 <= length and SubString(text, index, index + 2) == "|c" then
            set index = index + 10
        elseif index + 2 <= length and SubString(text, index, index + 2) == "|r" then
            set index = index + 2
        else
            set visibleLength = visibleLength + 1
            set index = index + 1
        endif
    endloop
    return visibleLength
endfunction

private function WOS_STATS_ResizeItemTooltip takes framehandle tooltipText, string itemName returns nothing
    local framehandle tooltip = BlzFrameGetParent(tooltipText)
    local real width = 0.010 + I2R(WOS_STATS_VisibleTextLength(itemName)) * 0.0030

    if width < 0.032 then
        set width = 0.032
    elseif width > 0.110 then
        set width = 0.110
    endif
    call BlzFrameSetSize(tooltip, WOS_STATS_ScaleSize(width), WOS_STATS_ScaleSize(0.016))
    set tooltip = null
endfunction

private function WOS_STATS_CreateItemTooltip takes framehandle whichFrame, integer index returns nothing
    local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "WosStatsItemTooltip", WOS_STATS_Main, "", 5000 + index)
    local framehandle tooltipText = BlzCreateFrameByType("TEXT", "WosStatsItemTooltipText", tooltip, "", 5000 + index)

    call BlzFrameSetPoint(tooltip, FRAMEPOINT_BOTTOM, whichFrame, FRAMEPOINT_TOP, 0.0, WOS_STATS_ScaleSize(0.002))
    call BlzFrameSetSize(tooltip, WOS_STATS_ScaleSize(0.040), WOS_STATS_ScaleSize(0.016))
    call BlzFrameSetTexture(tooltip, WOS_STATS_TEX_TOOLTIP, 0, true)
    call BlzFrameSetAlpha(tooltip, WOS_STATS_TOOLTIP_ALPHA)
    call BlzFrameSetLevel(tooltip, 80)
    call BlzFrameSetAllPoints(tooltipText, tooltip)
    call BlzFrameSetTextAlignment(tooltipText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(tooltipText, 0.64 * WOS_STATS_GetUIScale())
    call BlzFrameSetText(tooltipText, "")
    call BlzFrameSetVisible(tooltip, false)
    call BlzFrameSetTooltip(whichFrame, tooltip)

    set WOS_STATS_ItemTooltip[index] = tooltip
    set WOS_STATS_ItemTooltipText[index] = tooltipText
    set tooltip = null
    set tooltipText = null
endfunction

private function WOS_STATS_CreateCombatTooltip takes framehandle whichFrame, integer index returns nothing
    local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "WosStatsCombatTooltip", WOS_STATS_Main, "", 5200 + index)
    local framehandle tooltipText = BlzCreateFrameByType("TEXT", "WosStatsCombatTooltipText", tooltip, "", 5200 + index)

    call BlzFrameSetPoint(tooltip, FRAMEPOINT_BOTTOM, whichFrame, FRAMEPOINT_TOP, 0.0, WOS_STATS_ScaleSize(0.002))
    call BlzFrameSetSize(tooltip, WOS_STATS_ScaleSize(0.105), WOS_STATS_ScaleSize(0.046))
    call BlzFrameSetTexture(tooltip, WOS_STATS_TEX_TOOLTIP, 0, true)
    call BlzFrameSetAlpha(tooltip, WOS_STATS_TOOLTIP_ALPHA)
    call BlzFrameSetLevel(tooltip, 85)
    call BlzFrameSetAllPoints(tooltipText, tooltip)
    call BlzFrameSetTextAlignment(tooltipText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(tooltipText, 0.62 * WOS_STATS_GetUIScale())
    call BlzFrameSetText(tooltipText, "")
    call BlzFrameSetVisible(tooltip, false)
    call BlzFrameSetTooltip(whichFrame, tooltip)

    set WOS_STATS_CombatTooltip[index] = tooltip
    set WOS_STATS_CombatTooltipText[index] = tooltipText
    set tooltip = null
    set tooltipText = null
endfunction

private function WOS_STATS_SetCombatTooltipText takes integer index, string title, integer physical, integer magical returns nothing
    local integer total = physical + magical
    local integer longest = StringLength(title)
    local integer current
    local real width
    local framehandle tooltip = WOS_STATS_CombatTooltip[index]
    local string physicalLine = "Physical: " + I2S(physical) + " (" + WOS_STATS_Percent(physical, total) + ")"
    local string magicalLine = "Magical: " + I2S(magical) + " (" + WOS_STATS_Percent(magical, total) + ")"
    local string totalLine = "Total: " + I2S(total)

    set current = StringLength(physicalLine)
    if current > longest then
        set longest = current
    endif
    set current = StringLength(magicalLine)
    if current > longest then
        set longest = current
    endif
    set current = StringLength(totalLine)
    if current > longest then
        set longest = current
    endif
    set width = 0.010 + I2R(longest) * 0.0030
    if width < 0.078 then
        set width = 0.078
    elseif width > 0.135 then
        set width = 0.135
    endif
    call BlzFrameSetSize(tooltip, WOS_STATS_ScaleSize(width), WOS_STATS_ScaleSize(0.046))

    call BlzFrameSetText(WOS_STATS_CombatTooltipText[index], "|cffffd36b" + title + "|r\n|cffff7777Physical: |r" + I2S(physical) + "  |cff9aa7b4(" + WOS_STATS_Percent(physical, total) + ")|r\n|cff6fa8ffMagical: |r" + I2S(magical) + "  |cff9aa7b4(" + WOS_STATS_Percent(magical, total) + ")|r\n|cffffffffTotal: " + I2S(total) + "|r")
    set tooltip = null
    set physicalLine = null
    set magicalLine = null
    set totalLine = null
endfunction

private function WOS_STATS_SetDamageTooltip takes integer row, integer physical, integer magical returns nothing
    call WOS_STATS_SetCombatTooltipText(row * 2, "DAMAGE DEALT", physical, magical)
endfunction

private function WOS_STATS_SetTakenTooltip takes integer row, integer physical, integer magical returns nothing
    call WOS_STATS_SetCombatTooltipText(row * 2 + 1, "DAMAGE TAKEN", physical, magical)
endfunction

private function WOS_STATS_CreateSimpleTooltip takes framehandle whichFrame, string value, real width, real height, integer context returns nothing
    local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "WosStatsSimpleTooltip", WOS_STATS_Main, "", context)
    local framehandle tooltipText = BlzCreateFrameByType("TEXT", "WosStatsSimpleTooltipText", tooltip, "", context)

    call BlzFrameSetPoint(tooltip, FRAMEPOINT_BOTTOM, whichFrame, FRAMEPOINT_TOP, 0.0, WOS_STATS_ScaleSize(0.002))
    call BlzFrameSetSize(tooltip, WOS_STATS_ScaleSize(width), WOS_STATS_ScaleSize(height))
    call BlzFrameSetTexture(tooltip, WOS_STATS_TEX_TOOLTIP, 0, true)
    call BlzFrameSetAlpha(tooltip, WOS_STATS_TOOLTIP_ALPHA)
    call BlzFrameSetLevel(tooltip, 85)
    call BlzFrameSetAllPoints(tooltipText, tooltip)
    call BlzFrameSetTextAlignment(tooltipText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(tooltipText, 0.60 * WOS_STATS_GetUIScale())
    call BlzFrameSetText(tooltipText, value)
    call BlzFrameSetVisible(tooltip, false)
    call BlzFrameSetTooltip(whichFrame, tooltip)

    set tooltip = null
    set tooltipText = null
endfunction

//===========================================================================
// MVP
//===========================================================================
// До конца матча игрок видит свои текущие значения без суффикса All,
// а статистику остальных игроков — из накопительных массивов *All.
// После END1 == 1 накопительные значения используются для всех строк.
private function WOS_STATS_UseAllStats takes integer viewerPid, integer pid returns boolean
    return END1 == 1 or viewerPid != pid
endfunction

private function WOS_STATS_GetDamagePhysical takes integer viewerPid, integer pid returns integer
    if WOS_STATS_UseAllStats(viewerPid, pid) then
        return PlayerDamagePhysAll[pid]
    endif
    return PlayerDamagePhys[pid]
endfunction

private function WOS_STATS_GetDamageMagical takes integer viewerPid, integer pid returns integer
    if WOS_STATS_UseAllStats(viewerPid, pid) then
        return PlayerDamageMagAll[pid]
    endif
    return PlayerDamageMag[pid]
endfunction

private function WOS_STATS_GetTakenPhysical takes integer viewerPid, integer pid returns integer
    if WOS_STATS_UseAllStats(viewerPid, pid) then
        return R2I(PlayerDamageTakenPhysAll[pid])
    endif
    return R2I(PlayerDamageTakenPhys[pid])
endfunction

private function WOS_STATS_GetTakenMagical takes integer viewerPid, integer pid returns integer
    if WOS_STATS_UseAllStats(viewerPid, pid) then
        return R2I(PlayerDamageTakenMagAll[pid])
    endif
    return R2I(PlayerDamageTakenMag[pid])
endfunction

private function WOS_STATS_GetHeal takes integer viewerPid, integer pid returns integer
    if WOS_STATS_UseAllStats(viewerPid, pid) then
        return WOS_STATS_NonNegative(PlayerHealAll[pid])
    endif
    return WOS_STATS_NonNegative(PlayerHeal[pid])
endfunction

private function WOS_STATS_MvpScore takes integer viewerPid, integer pid returns real
    local integer damage = WOS_STATS_GetDamagePhysical(viewerPid, pid) + WOS_STATS_GetDamageMagical(viewerPid, pid)
    local integer taken = WOS_STATS_GetTakenPhysical(viewerPid, pid) + WOS_STATS_GetTakenMagical(viewerPid, pid)

    return I2R(PlayerKill[pid]) * WOS_STATS_MVP_KILL_WEIGHT - I2R(PlayerDeath[pid]) * WOS_STATS_MVP_DEATH_PENALTY + I2R(damage) / WOS_STATS_MVP_DAMAGE_DIVISOR + I2R(WOS_STATS_GetHeal(viewerPid, pid)) / WOS_STATS_MVP_HEAL_DIVISOR + I2R(taken) / WOS_STATS_MVP_TAKEN_DIVISOR
endfunction

private function WOS_STATS_GetMvpPid takes integer viewerPid returns integer
    local integer pid = 0
    local integer bestPid = -1
    local real score
    local real bestScore = 0.00

    loop
        exitwhen pid >= WOS_STATS_PLAYER_COUNT
        if Hero[pid] != null and WOS_STATS_ShouldDisplayPid(pid) then
            set score = WOS_STATS_MvpScore(viewerPid, pid)
            if score > bestScore then
                set bestScore = score
                set bestPid = pid
            elseif score == bestScore and bestPid >= 0 then
                if PlayerKill[pid] > PlayerKill[bestPid] then
                    set bestPid = pid
                elseif PlayerKill[pid] == PlayerKill[bestPid] and WOS_STATS_GetDamagePhysical(viewerPid, pid) + WOS_STATS_GetDamageMagical(viewerPid, pid) > WOS_STATS_GetDamagePhysical(viewerPid, bestPid) + WOS_STATS_GetDamageMagical(viewerPid, bestPid) then
                    set bestPid = pid
                endif
            endif
        endif
        set pid = pid + 1
    endloop
    return bestPid
endfunction

//===========================================================================
// Обновление строк, предметов и итогов
//===========================================================================
private function WOS_STATS_UpdateItems takes integer row, unit heroUnit returns nothing
    local integer slot = 0
    local integer index
    local integer itemId
    local string itemName
    local item whichItem

    loop
        exitwhen slot >= WOS_STATS_ITEM_COUNT
        set index = row * WOS_STATS_ITEM_COUNT + slot
        set whichItem = UnitItemInSlot(heroUnit, slot)

        if whichItem == null then
            set itemId = 0
            call BlzFrameSetVisible(WOS_STATS_ItemButton[index], false)
        else
            set itemId = GetItemTypeId(whichItem)
            call BlzFrameSetVisible(WOS_STATS_ItemButton[index], true)
            if WOS_STATS_LastItemId[index] != itemId then
                set itemName = GetObjectName(itemId)
                call BlzFrameSetTexture(WOS_STATS_ItemIcon[index], BlzGetAbilityIcon(itemId), 0, false)
                call WOS_STATS_ResizeItemTooltip(WOS_STATS_ItemTooltipText[index], itemName)
                call BlzFrameSetText(WOS_STATS_ItemTooltipText[index], "|cffffffff" + itemName + "|r")
            endif
        endif

        set WOS_STATS_LastItemId[index] = itemId
        set whichItem = null
        set slot = slot + 1
    endloop
endfunction

private function WOS_STATS_ClearItems takes integer row returns nothing
    local integer slot = 0
    local integer index

    loop
        exitwhen slot >= WOS_STATS_ITEM_COUNT
        set index = row * WOS_STATS_ITEM_COUNT + slot
        set WOS_STATS_LastItemId[index] = 0
        call BlzFrameSetVisible(WOS_STATS_ItemButton[index], false)
        set slot = slot + 1
    endloop
endfunction

private function WOS_STATS_UpdateRow takes integer row, integer viewerPid, integer mvpPid returns nothing
    local integer pid = WOS_STATS_GetDisplayPidForRow(row)
    local integer heroType
    local integer damagePhysical
    local integer damageMagical
    local integer takenPhysical
    local integer takenMagical
    local integer rowAlpha
    local unit heroUnit
    local string heroTexture
    local string playerName
    local boolean playerLeft
    local boolean expanded = WOS_STATS_IsExpanded[viewerPid]
    local boolean opaque = WOS_STATS_IsOpaque[viewerPid]

    if not WOS_STATS_ShouldDisplayPid(pid) then
        call BlzFrameSetVisible(WOS_STATS_RowBack[row], false)
        call BlzFrameSetVisible(WOS_STATS_RowContent[row], false)
        call WOS_STATS_ClearItems(row)
        set WOS_STATS_LastRowPid[row] = -1
        return
    endif

    set heroUnit = Hero[pid]
    set damagePhysical = WOS_STATS_GetDamagePhysical(viewerPid, pid)
    set damageMagical = WOS_STATS_GetDamageMagical(viewerPid, pid)
    set takenPhysical = WOS_STATS_GetTakenPhysical(viewerPid, pid)
    set takenMagical = WOS_STATS_GetTakenMagical(viewerPid, pid)
    call BlzFrameSetVisible(WOS_STATS_RowBack[row], true)
    call BlzFrameSetVisible(WOS_STATS_RowContent[row], true)

    if heroUnit == null then
        if WOS_STATS_LastRowPid[row] != pid or WOS_STATS_LastHeroType[row] != 0 then
            call BlzFrameSetTexture(WOS_STATS_HeroIcon[row], WOS_STATS_TEX_EMPTY, 0, false)
        endif
        set WOS_STATS_LastHeroType[row] = 0
        call WOS_STATS_ClearItems(row)
    else
        set heroType = GetUnitTypeId(heroUnit)
        set heroTexture = BlzGetAbilityIcon(heroType)
        if IsUnitType(heroUnit, UNIT_TYPE_DEAD) then
            set heroTexture = ConvertBTNtoDISBTN(heroTexture)
        endif
        if WOS_STATS_LastRowPid[row] != pid or WOS_STATS_LastHeroType[row] != heroType or IsUnitType(heroUnit, UNIT_TYPE_DEAD) then
            call BlzFrameSetTexture(WOS_STATS_HeroIcon[row], heroTexture, 0, false)
            set WOS_STATS_LastHeroType[row] = heroType
        endif
    endif

    set playerName = WOS_STATS_OneLine(SplitName(GetPlayerName(Player(pid))))
    if StringLength(playerName) == 0 then
        set playerName = "Player " + I2S(pid + 1)
    endif
    // На финальном экране не затемняем строки после Victory/Defeat,
    // поскольку движок уже может пометить игроков как вышедших.
    set playerLeft = GetPlayerSlotState(Player(pid)) != PLAYER_SLOT_STATE_PLAYING and not WOS_STATS_IsFinal[viewerPid]

    if pid == mvpPid then
        call BlzFrameSetText(WOS_STATS_MvpText[row], "|cffffd36bMVP|r")
    else
        call BlzFrameSetText(WOS_STATS_MvpText[row], "")
    endif

    // Р‘РµР»Р°СЏ С‚РµРєСЃС‚СѓСЂР° РѕРєСЂР°С€РёРІР°РµС‚СЃСЏ РІ С†РІРµС‚ СЃР»РѕС‚Р° РІ РѕР±РѕРёС… СЂРµР¶РёРјР°С… С„РѕРЅР°.
    // РњРµРЅСЏРµС‚СЃСЏ С‚РѕР»СЊРєРѕ Р°Р»СЊС„Р°: РЅР° РЅРµРїСЂРѕР·СЂР°С‡РЅРѕРј С„РѕРЅРµ РїРѕР»РѕСЃС‹ РЅР°СЃС‹С‰РµРЅРЅРµРµ.
    // Transparent mode: black strips. Opaque mode: subtle slot-colored strips.
    if opaque then
        call BlzFrameSetTexture(WOS_STATS_RowBack[row], WOS_STATS_TEX_ROW, 0, true)
        if playerLeft then
            call BlzFrameSetText(WOS_STATS_PlayerName[row], "|cff777777" + playerName + "|r")
            set rowAlpha = 8
        elseif pid == viewerPid then
            call BlzFrameSetText(WOS_STATS_PlayerName[row], "|cffffd36b" + playerName + "|r")
            set rowAlpha = 35
        elseif pid == mvpPid then
            call BlzFrameSetText(WOS_STATS_PlayerName[row], GetPlayerColorString(Player(pid)) + playerName + "|r")
            set rowAlpha = 28
        elseif row - (row / 2) * 2 == 0 then
            call BlzFrameSetText(WOS_STATS_PlayerName[row], GetPlayerColorString(Player(pid)) + playerName + "|r")
            set rowAlpha = 18
        else
            call BlzFrameSetText(WOS_STATS_PlayerName[row], GetPlayerColorString(Player(pid)) + playerName + "|r")
            set rowAlpha = 12
        endif
        // В непрозрачном режиме подсветка всегда белая и полупрозрачная.
        // Содержимое строки находится в отдельном слое и не наследует эту alpha.
        call BlzFrameSetVertexColor(WOS_STATS_RowBack[row], BlzConvertColor(255, 255, 255, 255))
        call BlzFrameSetAlpha(WOS_STATS_RowBack[row], rowAlpha)
    else
        call BlzFrameSetTexture(WOS_STATS_RowBack[row], WOS_STATS_TEX_PANEL_FILL, 0, true)
        call BlzFrameSetVertexColor(WOS_STATS_RowBack[row], BlzConvertColor(255, 255, 255, 255))
        if playerLeft then
            call BlzFrameSetText(WOS_STATS_PlayerName[row], "|cff777777" + playerName + "|r")
            call BlzFrameSetAlpha(WOS_STATS_RowBack[row], 75)
        elseif pid == viewerPid then
            call BlzFrameSetText(WOS_STATS_PlayerName[row], "|cffffd36b" + playerName + "|r")
            call BlzFrameSetAlpha(WOS_STATS_RowBack[row], 205)
        elseif pid == mvpPid then
            call BlzFrameSetText(WOS_STATS_PlayerName[row], GetPlayerColorString(Player(pid)) + playerName + "|r")
            call BlzFrameSetAlpha(WOS_STATS_RowBack[row], 160)
        else
            call BlzFrameSetText(WOS_STATS_PlayerName[row], GetPlayerColorString(Player(pid)) + playerName + "|r")
            if row - (row / 2) * 2 == 0 then
                call BlzFrameSetAlpha(WOS_STATS_RowBack[row], 128)
            else
                call BlzFrameSetAlpha(WOS_STATS_RowBack[row], 92)
            endif
        endif
    endif

    if expanded then
        call BlzFrameSetText(WOS_STATS_KillText[row], I2S(PlayerKill[pid]))
        call BlzFrameSetText(WOS_STATS_DeathText[row], I2S(PlayerDeath[pid]))
        call BlzFrameSetText(WOS_STATS_DamageText[row], WOS_STATS_FormatK(damagePhysical))
        call BlzFrameSetText(WOS_STATS_DamageMagText[row], WOS_STATS_FormatK(damageMagical))
        call BlzFrameSetText(WOS_STATS_TakenText[row], WOS_STATS_FormatK(takenPhysical))
        call BlzFrameSetText(WOS_STATS_TakenMagText[row], WOS_STATS_FormatK(takenMagical))
    else
        call BlzFrameSetText(WOS_STATS_KillText[row], I2S(PlayerKill[pid]) + " / " + I2S(PlayerDeath[pid]))
        call BlzFrameSetText(WOS_STATS_DamageText[row], WOS_STATS_FormatK(damagePhysical + damageMagical))
        call BlzFrameSetText(WOS_STATS_TakenText[row], WOS_STATS_FormatK(takenPhysical + takenMagical))
    endif
    call BlzFrameSetText(WOS_STATS_HealText[row], WOS_STATS_FormatK(WOS_STATS_GetHeal(viewerPid, pid)))
    call WOS_STATS_SetDamageTooltip(row, damagePhysical, damageMagical)
    call WOS_STATS_SetTakenTooltip(row, takenPhysical, takenMagical)
    if heroUnit != null then
        call WOS_STATS_UpdateItems(row, heroUnit)
    endif

    set WOS_STATS_LastRowPid[row] = pid
    set heroUnit = null
endfunction

private function WOS_STATS_UpdateTeamTotal takes integer viewerPid, integer team, boolean expanded returns nothing
    local integer row = team * WOS_STATS_TEAM_SIZE
    local integer rowEnd = row + WOS_STATS_TEAM_SIZE
    local integer pid
    local integer kills = 0
    local integer deaths = 0
    local integer damagePhysical = 0
    local integer damageMagical = 0
    local integer heal = 0
    local integer takenPhysical = 0
    local integer takenMagical = 0
    local integer base = team * 7

    loop
        exitwhen row >= rowEnd
        set pid = WOS_STATS_GetPidForRow(row)
        if WOS_STATS_ShouldDisplayPid(pid) then
            if Hero[pid] != null then
                set kills = kills + PlayerKill[pid]
                set deaths = deaths + PlayerDeath[pid]
                set damagePhysical = damagePhysical + WOS_STATS_GetDamagePhysical(viewerPid, pid)
                set damageMagical = damageMagical + WOS_STATS_GetDamageMagical(viewerPid, pid)
                set heal = heal + WOS_STATS_GetHeal(viewerPid, pid)
                set takenPhysical = takenPhysical + WOS_STATS_GetTakenPhysical(viewerPid, pid)
                set takenMagical = takenMagical + WOS_STATS_GetTakenMagical(viewerPid, pid)
            endif
        endif
        set row = row + 1
    endloop

    if expanded then
        call BlzFrameSetText(WOS_STATS_TotalText[base + 0], I2S(kills))
        call BlzFrameSetText(WOS_STATS_TotalText[base + 1], I2S(deaths))
        call BlzFrameSetText(WOS_STATS_TotalText[base + 2], WOS_STATS_FormatK(damagePhysical))
        call BlzFrameSetText(WOS_STATS_TotalText[base + 3], WOS_STATS_FormatK(damageMagical))
        call BlzFrameSetText(WOS_STATS_TotalText[base + 4], WOS_STATS_FormatK(heal))
        call BlzFrameSetText(WOS_STATS_TotalText[base + 5], WOS_STATS_FormatK(takenPhysical))
        call BlzFrameSetText(WOS_STATS_TotalText[base + 6], WOS_STATS_FormatK(takenMagical))
    else
        call BlzFrameSetText(WOS_STATS_TotalText[base + 0], I2S(kills) + " / " + I2S(deaths))
        call BlzFrameSetText(WOS_STATS_TotalText[base + 2], WOS_STATS_FormatK(damagePhysical + damageMagical))
        call BlzFrameSetText(WOS_STATS_TotalText[base + 4], WOS_STATS_FormatK(heal))
        call BlzFrameSetText(WOS_STATS_TotalText[base + 5], WOS_STATS_FormatK(takenPhysical + takenMagical))
    endif
    call WOS_STATS_SetCombatTooltipText(20 + team * 2, "TEAM DAMAGE DEALT", damagePhysical, damageMagical)
    call WOS_STATS_SetCombatTooltipText(21 + team * 2, "TEAM DAMAGE TAKEN", takenPhysical, takenMagical)
endfunction

//===========================================================================
// Динамическая плотная раскладка
// Скрытые слоты не оставляют пустые строки, а высота панели меняется под
// фактическое количество героев.
//===========================================================================
private function WOS_STATS_MoveFrame takes framehandle whichFrame, real x, real y returns nothing
    call BlzFrameClearAllPoints(whichFrame)
    call BlzFrameSetAbsPoint(whichFrame, FRAMEPOINT_CENTER, WOS_STATS_ScaleX(x), WOS_STATS_ScaleY(y))
endfunction

private function WOS_STATS_ResizeText takes framehandle whichFrame, real width, real height, real scale returns nothing
    call BlzFrameSetSize(whichFrame, WOS_STATS_ScaleSize(width), WOS_STATS_ScaleSize(height))
    call BlzFrameSetScale(whichFrame, scale * WOS_STATS_GetUIScale())
endfunction

private function WOS_STATS_MoveRow takes integer row, real y, boolean expanded returns nothing
    local integer slot = 0
    local integer itemIndex
    local real itemX
    local real itemStep
    local real itemSize
    local real mvpX
    local real heroX
    local real playerX

    call WOS_STATS_MoveFrame(WOS_STATS_RowBack[row], WOS_STATS_PANEL_X, y)
    call WOS_STATS_MoveFrame(WOS_STATS_RowContent[row], WOS_STATS_PANEL_X, y)

    if expanded then
        // В подробном режиме сдвигаем портрет и имя немного вправо,
        // освобождая отдельное место для крупной метки MVP.
        set mvpX = 0.073
        set heroX = 0.100
        set playerX = 0.160
        // Р“СЂСѓРїРїР° РїСЂРµРґРјРµС‚РѕРІ С†РµРЅС‚СЂРёСЂРѕРІР°РЅР° РјРµР¶РґСѓ РїРѕСЃР»РµРґРЅРµР№ СЃС‚Р°С‚РѕР№ Рё РїСЂР°РІС‹Рј РєСЂР°РµРј.
        set itemX = 0.621
        set itemStep = 0.020
        set itemSize = 0.0175
        call BlzFrameSetSize(WOS_STATS_RowBack[row], WOS_STATS_ScaleSize(WOS_STATS_EXPANDED_ROW_WIDTH), WOS_STATS_ScaleSize(WOS_STATS_EXPANDED_ROW_HEIGHT))
        call BlzFrameSetSize(WOS_STATS_RowContent[row], WOS_STATS_ScaleSize(WOS_STATS_EXPANDED_ROW_WIDTH), WOS_STATS_ScaleSize(WOS_STATS_EXPANDED_ROW_HEIGHT))
        call BlzFrameSetSize(WOS_STATS_HeroIcon[row], WOS_STATS_ScaleSize(0.021), WOS_STATS_ScaleSize(0.021))
        call WOS_STATS_ResizeText(WOS_STATS_PlayerName[row], 0.096, 0.016, 0.61)
        call WOS_STATS_ResizeText(WOS_STATS_MvpText[row], 0.030, 0.012, 0.56)
        call BlzFrameSetSize(WOS_STATS_MvpHover[row], WOS_STATS_ScaleSize(0.032), WOS_STATS_ScaleSize(WOS_STATS_EXPANDED_ROW_HEIGHT))
        call WOS_STATS_ResizeText(WOS_STATS_KillText[row], WOS_STATS_ExpandedColumnWidth(0), 0.017, 0.76)
        call WOS_STATS_ResizeText(WOS_STATS_DeathText[row], WOS_STATS_ExpandedColumnWidth(1), 0.017, 0.76)
        call WOS_STATS_ResizeText(WOS_STATS_DamageText[row], WOS_STATS_ExpandedColumnWidth(2), 0.017, 0.72)
        call WOS_STATS_ResizeText(WOS_STATS_DamageMagText[row], WOS_STATS_ExpandedColumnWidth(3), 0.017, 0.72)
        call WOS_STATS_ResizeText(WOS_STATS_HealText[row], WOS_STATS_ExpandedColumnWidth(4), 0.017, 0.72)
        call WOS_STATS_ResizeText(WOS_STATS_TakenText[row], WOS_STATS_ExpandedColumnWidth(5), 0.017, 0.70)
        call WOS_STATS_ResizeText(WOS_STATS_TakenMagText[row], WOS_STATS_ExpandedColumnWidth(6), 0.017, 0.70)
        call WOS_STATS_MoveFrame(WOS_STATS_KillText[row], WOS_STATS_ExpandedColumnX(0), y)
        call WOS_STATS_MoveFrame(WOS_STATS_DeathText[row], WOS_STATS_ExpandedColumnX(1), y)
        call WOS_STATS_MoveFrame(WOS_STATS_DamageText[row], WOS_STATS_ExpandedColumnX(2), y)
        call WOS_STATS_MoveFrame(WOS_STATS_DamageMagText[row], WOS_STATS_ExpandedColumnX(3), y)
        call WOS_STATS_MoveFrame(WOS_STATS_HealText[row], WOS_STATS_ExpandedColumnX(4), y)
        call WOS_STATS_MoveFrame(WOS_STATS_TakenText[row], WOS_STATS_ExpandedColumnX(5), y)
        call WOS_STATS_MoveFrame(WOS_STATS_TakenMagText[row], WOS_STATS_ExpandedColumnX(6), y)
        call BlzFrameSetVisible(WOS_STATS_DeathText[row], true)
        call BlzFrameSetVisible(WOS_STATS_DamageMagText[row], true)
        call BlzFrameSetVisible(WOS_STATS_TakenMagText[row], true)
        call BlzFrameSetVisible(WOS_STATS_DamageHover[row], false)
        call BlzFrameSetVisible(WOS_STATS_TakenHover[row], false)
    else
        set mvpX = 0.211
        set heroX = 0.233
        set playerX = 0.275
        // РЎРёРјРјРµС‚СЂРёС‡РЅС‹Р№ Р·Р°РїР°СЃ СЃР»РµРІР° Рё СЃРїСЂР°РІР° РѕС‚ РїРѕР»РЅРѕРіРѕ СЂСЏРґР° РёР· С€РµСЃС‚Рё РїСЂРµРґРјРµС‚РѕРІ.
        set itemX = 0.527
        set itemStep = WOS_STATS_ITEM_STEP
        set itemSize = WOS_STATS_ITEM_ICON_SIZE
        call BlzFrameSetSize(WOS_STATS_RowBack[row], WOS_STATS_ScaleSize(WOS_STATS_ROW_WIDTH), WOS_STATS_ScaleSize(WOS_STATS_ROW_HEIGHT))
        call BlzFrameSetSize(WOS_STATS_RowContent[row], WOS_STATS_ScaleSize(WOS_STATS_ROW_WIDTH), WOS_STATS_ScaleSize(WOS_STATS_ROW_HEIGHT))
        call BlzFrameSetSize(WOS_STATS_HeroIcon[row], WOS_STATS_ScaleSize(WOS_STATS_HERO_ICON_SIZE), WOS_STATS_ScaleSize(WOS_STATS_HERO_ICON_SIZE))
        call WOS_STATS_ResizeText(WOS_STATS_PlayerName[row], 0.070, 0.012, 0.52)
        call WOS_STATS_ResizeText(WOS_STATS_MvpText[row], 0.028, 0.0095, 0.46)
        call BlzFrameSetSize(WOS_STATS_MvpHover[row], WOS_STATS_ScaleSize(0.030), WOS_STATS_ScaleSize(WOS_STATS_ROW_HEIGHT))
        call WOS_STATS_ResizeText(WOS_STATS_KillText[row], WOS_STATS_ColumnWidth(0), 0.012, 0.56)
        call WOS_STATS_ResizeText(WOS_STATS_DamageText[row], WOS_STATS_ColumnWidth(2), 0.012, 0.54)
        call WOS_STATS_ResizeText(WOS_STATS_HealText[row], WOS_STATS_ColumnWidth(3), 0.012, 0.54)
        call WOS_STATS_ResizeText(WOS_STATS_TakenText[row], WOS_STATS_ColumnWidth(4), 0.012, 0.52)
        call WOS_STATS_MoveFrame(WOS_STATS_KillText[row], WOS_STATS_ColumnX(0), y)
        call WOS_STATS_MoveFrame(WOS_STATS_DamageText[row], WOS_STATS_ColumnX(2), y)
        call WOS_STATS_MoveFrame(WOS_STATS_HealText[row], WOS_STATS_ColumnX(3), y)
        call WOS_STATS_MoveFrame(WOS_STATS_TakenText[row], WOS_STATS_ColumnX(4), y)
        call WOS_STATS_MoveFrame(WOS_STATS_DamageHover[row], WOS_STATS_ColumnX(2), y)
        call WOS_STATS_MoveFrame(WOS_STATS_TakenHover[row], WOS_STATS_ColumnX(4), y)
        call BlzFrameSetVisible(WOS_STATS_DeathText[row], false)
        call BlzFrameSetVisible(WOS_STATS_DamageMagText[row], false)
        call BlzFrameSetVisible(WOS_STATS_TakenMagText[row], false)
        call BlzFrameSetVisible(WOS_STATS_DamageHover[row], true)
        call BlzFrameSetVisible(WOS_STATS_TakenHover[row], true)
    endif

    // MVP находится в отдельной области слева и не перекрывает портрет.
    call WOS_STATS_MoveFrame(WOS_STATS_HeroIcon[row], heroX, y)
    call WOS_STATS_MoveFrame(WOS_STATS_MvpText[row], mvpX, y)
    call WOS_STATS_MoveFrame(WOS_STATS_MvpHover[row], mvpX, y)
    call WOS_STATS_MoveFrame(WOS_STATS_PlayerName[row], playerX, y)

    loop
        exitwhen slot >= WOS_STATS_ITEM_COUNT
        set itemIndex = row * WOS_STATS_ITEM_COUNT + slot
        call WOS_STATS_MoveFrame(WOS_STATS_ItemButton[itemIndex], itemX + I2R(slot) * itemStep, y)
        call BlzFrameSetSize(WOS_STATS_ItemButton[itemIndex], WOS_STATS_ScaleSize(itemSize), WOS_STATS_ScaleSize(itemSize))
        set slot = slot + 1
    endloop
endfunction

private function WOS_STATS_ConfigureHeaders takes integer team, real y, boolean expanded returns nothing
    local integer base = team * 9
    local integer index = 0

    if expanded then
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 0], "|cffc6cbd1PLAYER|r")
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 1], "|cffffd36bKILLS|r")
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 2], "|cffd58cffDEATHS|r")
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 3], "|cffff8a73PHYS DEALT|r")
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 4], "|cff6fa8ffMAG DEALT|r")
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 5], "|cff63e692HEAL|r")
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 6], "|cffff7777PHYS TAKEN|r")
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 7], "|cff91b8ffMAG TAKEN|r")
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 8], "|cffc6cbd1ITEMS|r")
        call WOS_STATS_MoveFrame(WOS_STATS_HeaderText[base + 0], 0.145, y)
        loop
            exitwhen index >= 7
            call WOS_STATS_MoveFrame(WOS_STATS_HeaderText[base + 1 + index], WOS_STATS_ExpandedColumnX(index), y)
            call BlzFrameSetVisible(WOS_STATS_HeaderText[base + 1 + index], true)
            set index = index + 1
        endloop
        call WOS_STATS_MoveFrame(WOS_STATS_HeaderText[base + 8], 0.671, y)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 0], 0.115, 0.020, 0.62)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 1], 0.040, 0.020, 0.64)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 2], 0.040, 0.020, 0.64)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 3], 0.055, 0.020, 0.58)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 4], 0.055, 0.020, 0.58)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 5], 0.045, 0.020, 0.64)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 6], 0.055, 0.020, 0.58)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 7], 0.055, 0.020, 0.58)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 8], 0.115, 0.020, 0.62)
    else
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 0], "|cffc6cbd1PLAYER|r")
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 1], "|cffffd36bK|r |cffc6cbd1/|r |cffd58cffD|r")
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 3], "|cffff8a73DAMAGE|r")
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 5], "|cff63e692HEAL|r")
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 6], "|cff91b8ffTAKEN DAMAGE|r")
        call BlzFrameSetText(WOS_STATS_HeaderText[base + 8], "|cffc6cbd1ITEMS|r")
        call WOS_STATS_MoveFrame(WOS_STATS_HeaderText[base + 0], 0.275, y)
        call WOS_STATS_MoveFrame(WOS_STATS_HeaderText[base + 1], WOS_STATS_ColumnX(0), y)
        call WOS_STATS_MoveFrame(WOS_STATS_HeaderText[base + 3], WOS_STATS_ColumnX(2), y)
        call WOS_STATS_MoveFrame(WOS_STATS_HeaderText[base + 5], WOS_STATS_ColumnX(3), y)
        call WOS_STATS_MoveFrame(WOS_STATS_HeaderText[base + 6], WOS_STATS_ColumnX(4), y)
        call WOS_STATS_MoveFrame(WOS_STATS_HeaderText[base + 8], 0.560, y)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 0], 0.100, 0.015, 0.50)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 1], 0.060, 0.015, 0.48)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 3], 0.075, 0.015, 0.44)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 5], 0.060, 0.015, 0.48)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 6], 0.100, 0.015, 0.40)
        call WOS_STATS_ResizeText(WOS_STATS_HeaderText[base + 8], 0.080, 0.015, 0.48)
        call BlzFrameSetVisible(WOS_STATS_HeaderText[base + 2], false)
        call BlzFrameSetVisible(WOS_STATS_HeaderText[base + 4], false)
        call BlzFrameSetVisible(WOS_STATS_HeaderText[base + 7], false)
    endif
    call BlzFrameSetVisible(WOS_STATS_HeaderText[base + 0], true)
    call BlzFrameSetVisible(WOS_STATS_HeaderText[base + 1], true)
    call BlzFrameSetVisible(WOS_STATS_HeaderText[base + 3], true)
    call BlzFrameSetVisible(WOS_STATS_HeaderText[base + 5], true)
    call BlzFrameSetVisible(WOS_STATS_HeaderText[base + 6], true)
    call BlzFrameSetVisible(WOS_STATS_HeaderText[base + 8], true)
endfunction

private function WOS_STATS_LayoutTeam takes integer team, real titleY, boolean expanded returns real
    local integer row = team * WOS_STATS_TEAM_SIZE
    local integer rowEnd = row + WOS_STATS_TEAM_SIZE
    local integer pid
    local integer totalBase = team * 7
    local integer column = 0
    local real headerY
    local real rowY
    local real totalY

    if expanded then
        set headerY = titleY - 0.019
        set rowY = headerY - 0.0195
        call WOS_STATS_MoveFrame(WOS_STATS_TeamTitle[team], 0.145, titleY)
        call WOS_STATS_ResizeText(WOS_STATS_TeamTitle[team], 0.140, 0.018, 0.84)
    else
        set headerY = titleY - 0.013
        set rowY = headerY - 0.014
        call WOS_STATS_MoveFrame(WOS_STATS_TeamTitle[team], 0.285, titleY)
        call WOS_STATS_ResizeText(WOS_STATS_TeamTitle[team], 0.130, 0.014, 0.72)
    endif
    call WOS_STATS_ConfigureHeaders(team, headerY, expanded)

    loop
        exitwhen row >= rowEnd
        set pid = WOS_STATS_GetDisplayPidForRow(row)
        if WOS_STATS_ShouldDisplayPid(pid) then
            call WOS_STATS_MoveRow(row, rowY, expanded)
            if expanded then
                set rowY = rowY - WOS_STATS_EXPANDED_ROW_STEP
            else
                set rowY = rowY - WOS_STATS_ROW_STEP
            endif
        endif
        set row = row + 1
    endloop

    set totalY = rowY + 0.001
    if expanded then
        call WOS_STATS_MoveFrame(WOS_STATS_TotalLabel[team], 0.145, totalY)
        call WOS_STATS_ResizeText(WOS_STATS_TotalLabel[team], 0.115, 0.016, 0.56)
        loop
            exitwhen column >= 7
            call WOS_STATS_MoveFrame(WOS_STATS_TotalText[totalBase + column], WOS_STATS_ExpandedColumnX(column), totalY)
            call WOS_STATS_ResizeText(WOS_STATS_TotalText[totalBase + column], WOS_STATS_ExpandedColumnWidth(column), 0.017, 0.70)
            call BlzFrameSetVisible(WOS_STATS_TotalText[totalBase + column], true)
            set column = column + 1
        endloop
        call BlzFrameSetVisible(WOS_STATS_TotalDamageHover[team], false)
        call BlzFrameSetVisible(WOS_STATS_TotalTakenHover[team], false)
        return totalY - 0.018
    endif

    call WOS_STATS_MoveFrame(WOS_STATS_TotalLabel[team], 0.263, totalY)
    call WOS_STATS_ResizeText(WOS_STATS_TotalLabel[team], 0.100, 0.012, 0.42)
    call WOS_STATS_MoveFrame(WOS_STATS_TotalText[totalBase + 0], WOS_STATS_ColumnX(0), totalY)
    call WOS_STATS_MoveFrame(WOS_STATS_TotalText[totalBase + 2], WOS_STATS_ColumnX(2), totalY)
    call WOS_STATS_MoveFrame(WOS_STATS_TotalText[totalBase + 4], WOS_STATS_ColumnX(3), totalY)
    call WOS_STATS_MoveFrame(WOS_STATS_TotalText[totalBase + 5], WOS_STATS_ColumnX(4), totalY)
    call WOS_STATS_ResizeText(WOS_STATS_TotalText[totalBase + 0], WOS_STATS_ColumnWidth(0), 0.012, 0.52)
    call WOS_STATS_ResizeText(WOS_STATS_TotalText[totalBase + 2], WOS_STATS_ColumnWidth(2), 0.012, 0.52)
    call WOS_STATS_ResizeText(WOS_STATS_TotalText[totalBase + 4], WOS_STATS_ColumnWidth(3), 0.012, 0.52)
    call WOS_STATS_ResizeText(WOS_STATS_TotalText[totalBase + 5], WOS_STATS_ColumnWidth(4), 0.012, 0.52)
    call BlzFrameSetVisible(WOS_STATS_TotalText[totalBase + 0], true)
    call BlzFrameSetVisible(WOS_STATS_TotalText[totalBase + 1], false)
    call BlzFrameSetVisible(WOS_STATS_TotalText[totalBase + 2], true)
    call BlzFrameSetVisible(WOS_STATS_TotalText[totalBase + 3], false)
    call BlzFrameSetVisible(WOS_STATS_TotalText[totalBase + 4], true)
    call BlzFrameSetVisible(WOS_STATS_TotalText[totalBase + 5], true)
    call BlzFrameSetVisible(WOS_STATS_TotalText[totalBase + 6], false)
    call WOS_STATS_MoveFrame(WOS_STATS_TotalDamageHover[team], WOS_STATS_ColumnX(2), totalY)
    call WOS_STATS_MoveFrame(WOS_STATS_TotalTakenHover[team], WOS_STATS_ColumnX(4), totalY)
    call BlzFrameSetVisible(WOS_STATS_TotalDamageHover[team], true)
    call BlzFrameSetVisible(WOS_STATS_TotalTakenHover[team], true)
    return totalY - 0.015
endfunction

private function WOS_STATS_Layout takes integer viewerPid returns nothing
    local boolean expanded = WOS_STATS_IsExpanded[viewerPid]
    local real nextY
    local real bottom
    local real height
    local real centerY
    local real width
    local real contentWidth
    local real panelTop = WOS_STATS_PANEL_TOP
    local real yOffset = 0.0

    if expanded then
        set yOffset = WOS_STATS_EXPANDED_Y_OFFSET
        // После скрытия стандартного интерфейса финальное окно визуально
        // оказывается выше обычного. Немного опускаем только финальный режим.
        if WOS_STATS_IsFinal[viewerPid] then
            set yOffset = 0.040
        endif
        set panelTop = WOS_STATS_PANEL_TOP + yOffset
        set nextY = WOS_STATS_LayoutTeam(0, 0.468 + yOffset, true)
        set nextY = WOS_STATS_LayoutTeam(1, nextY, true)
        set width = WOS_STATS_EXPANDED_WIDTH
        set contentWidth = WOS_STATS_EXPANDED_CONTENT_WIDTH
    else
        set nextY = WOS_STATS_LayoutTeam(0, 0.474, false)
        set nextY = WOS_STATS_LayoutTeam(1, nextY, false)
        set width = WOS_STATS_PANEL_WIDTH
        set contentWidth = WOS_STATS_CONTENT_WIDTH
    endif
    // После удаления Hover-надписи возвращаем край сразу после штатного
    // отступа итоговой строки; отдельного резерва под текст больше нет.
    set bottom = nextY
    set height = panelTop - bottom
    if height < 0.125 then
        set height = 0.125
        set bottom = panelTop - height
    endif
    set centerY = (panelTop + bottom) * 0.50

    call WOS_STATS_MoveFrame(WOS_STATS_Main, WOS_STATS_PANEL_X, centerY)
    call BlzFrameSetSize(WOS_STATS_Main, WOS_STATS_ScaleSize(width), WOS_STATS_ScaleSize(height))
    call WOS_STATS_MoveFrame(WOS_STATS_OpaqueBack, WOS_STATS_PANEL_X, centerY)
    call BlzFrameSetSize(WOS_STATS_OpaqueBack, WOS_STATS_ScaleSize(contentWidth), WOS_STATS_ScaleSize(height - 0.012))
    call WOS_STATS_MoveFrame(WOS_STATS_Inner, WOS_STATS_PANEL_X, centerY)
    call BlzFrameSetSize(WOS_STATS_Inner, WOS_STATS_ScaleSize(contentWidth), WOS_STATS_ScaleSize(height - 0.012))
    call WOS_STATS_MoveFrame(WOS_STATS_Score, 0.400, 0.491 + yOffset)
    if expanded then
        call WOS_STATS_ResizeText(WOS_STATS_Title, 0.160, 0.020, 0.72)
        call WOS_STATS_ResizeText(WOS_STATS_Score, 0.100, 0.024, 1.35)
        call WOS_STATS_ResizeText(WOS_STATS_MatchInfo, 0.080, 0.020, 1.05)
        call WOS_STATS_ResizeText(WOS_STATS_ScreenshotClock, 0.085, 0.020, 0.82)
        call WOS_STATS_ResizeText(WOS_STATS_GameClock, 0.065, 0.020, 1.14)
        if WOS_STATS_IsFinal[viewerPid] then
            call WOS_STATS_MoveFrame(WOS_STATS_Title, 0.135, 0.492 + yOffset)
            call WOS_STATS_MoveFrame(WOS_STATS_ScreenshotClock, 0.495, 0.492 + yOffset)
            call WOS_STATS_MoveFrame(WOS_STATS_MatchInfo, 0.585, 0.492 + yOffset)
            call WOS_STATS_MoveFrame(WOS_STATS_GameClock, 0.680, 0.492 + yOffset)
        else
            call WOS_STATS_MoveFrame(WOS_STATS_Title, 0.135, 0.492 + yOffset)
            call WOS_STATS_MoveFrame(WOS_STATS_MatchInfo, 0.565, 0.492 + yOffset)
            call WOS_STATS_MoveFrame(WOS_STATS_GameClock, 0.640, 0.492 + yOffset)
        endif
        call BlzFrameSetVisible(WOS_STATS_ScreenshotClock, WOS_STATS_IsFinal[viewerPid])
        call WOS_STATS_MoveFrame(WOS_STATS_OpacityButton, 0.684, 0.492 + yOffset)
        call WOS_STATS_MoveFrame(WOS_STATS_ExpandButton, 0.706, 0.492 + yOffset)
        call WOS_STATS_MoveFrame(WOS_STATS_CloseButton, 0.728, 0.492 + yOffset)
    else
        call WOS_STATS_ResizeText(WOS_STATS_Title, 0.145, 0.015, 0.62)
        call WOS_STATS_ResizeText(WOS_STATS_Score, 0.085, 0.021, 1.20)
        call WOS_STATS_ResizeText(WOS_STATS_MatchInfo, 0.074, 0.016, 0.90)
        call WOS_STATS_ResizeText(WOS_STATS_GameClock, 0.058, 0.017, 1.02)
        call WOS_STATS_MoveFrame(WOS_STATS_Title, 0.270, 0.492)
        call WOS_STATS_MoveFrame(WOS_STATS_MatchInfo, 0.470, 0.492)
        call WOS_STATS_MoveFrame(WOS_STATS_GameClock, 0.525, 0.492)
        call BlzFrameSetVisible(WOS_STATS_ScreenshotClock, false)
        call WOS_STATS_MoveFrame(WOS_STATS_OpacityButton, 0.558, 0.492)
        call WOS_STATS_MoveFrame(WOS_STATS_ExpandButton, 0.578, 0.492)
        call WOS_STATS_MoveFrame(WOS_STATS_CloseButton, 0.598, 0.492)
    endif
    call BlzFrameSetVisible(WOS_STATS_OpaqueBack, WOS_STATS_IsOpaque[viewerPid] or WOS_STATS_IsFinal[viewerPid])
    if WOS_STATS_IsOpaque[viewerPid] then
        call BlzFrameSetTexture(WOS_STATS_OpacityIcon, WOS_STATS_TEX_OPACITY_ON, 0, true)
    else
        call BlzFrameSetTexture(WOS_STATS_OpacityIcon, WOS_STATS_TEX_OPACITY_OFF, 0, true)
    endif
    if expanded then
        call BlzFrameSetTexture(WOS_STATS_ExpandIcon, WOS_STATS_TEX_COLLAPSE, 0, true)
    else
        call BlzFrameSetTexture(WOS_STATS_ExpandIcon, WOS_STATS_TEX_EXPAND, 0, true)
    endif
endfunction

private function WOS_STATS_UpdateForPlayer takes integer viewerPid returns nothing
    local integer row = 0
    local integer mvpPid = WOS_STATS_GetMvpPid(viewerPid)
    local integer screenshotSeconds = 20 - END2

    call WOS_STATS_Layout(viewerPid)
    call BlzFrameSetText(WOS_STATS_MatchInfo, "|cffb7c0caRound |r|cffffd36b" + I2S(CurrentRound) + "|r")
    call BlzFrameSetText(WOS_STATS_Score, "|cffff4040" + I2S(Team1Round) + "|r |cffffffff:|r |cff4080ff" + I2S(Team2Round) + "|r")
    call BlzFrameSetText(WOS_STATS_GameClock, "|cffc6cbd1" + WOS_STATS_GameTime() + "|r")
    if WOS_STATS_IsFinal[viewerPid] then
        if screenshotSeconds < 0 then
            set screenshotSeconds = 0
        endif
        call BlzFrameSetText(WOS_STATS_ScreenshotClock, "|cffffd36bScreenshot: |r|cffffffff" + I2S(screenshotSeconds) + "s|r")
    else
        call BlzFrameSetText(WOS_STATS_ScreenshotClock, "")
    endif

    loop
        exitwhen row >= WOS_STATS_PLAYER_COUNT
        call WOS_STATS_UpdateRow(row, viewerPid, mvpPid)
        set row = row + 1
    endloop
    call WOS_STATS_UpdateTeamTotal(viewerPid, 0, WOS_STATS_IsExpanded[viewerPid])
    call WOS_STATS_UpdateTeamTotal(viewerPid, 1, WOS_STATS_IsExpanded[viewerPid])
endfunction

//===========================================================================
// Совместимость со старым F2-интерфейсом
//===========================================================================
private function WOS_STATS_SaveAndHideLegacyUI takes integer pid returns nothing
    if FRAME_StatusHeroMain != null then
        set WOS_STATS_OldTopVisible[pid] = BlzFrameIsVisible(FRAME_StatusHeroMain)
        call BlzFrameSetVisible(FRAME_StatusHeroMain, false)
    endif
    if FRAME_StatusHeroMain2 != null then
        set WOS_STATS_OldTakenVisible[pid] = BlzFrameIsVisible(FRAME_StatusHeroMain2)
        call BlzFrameSetVisible(FRAME_StatusHeroMain2, false)
    endif
    if FRAME_StatusHeroMain3 != null then
        set WOS_STATS_OldOptionsVisible[pid] = BlzFrameIsVisible(FRAME_StatusHeroMain3)
        call BlzFrameSetVisible(FRAME_StatusHeroMain3, false)
    endif
    if FRAME_StatusHeroMain4 != null then
        set WOS_STATS_OldCameraVisible[pid] = BlzFrameIsVisible(FRAME_StatusHeroMain4)
        call BlzFrameSetVisible(FRAME_StatusHeroMain4, false)
    endif
    if FRAME_StatsMain != null then
        set WOS_STATS_OldHeroStatsVisible[pid] = BlzFrameIsVisible(FRAME_StatsMain)
        call BlzFrameSetVisible(FRAME_StatsMain, false)
    endif
endfunction

private function WOS_STATS_HideLegacyUI takes nothing returns nothing
    if FRAME_StatusHeroMain != null then
        call BlzFrameSetVisible(FRAME_StatusHeroMain, false)
    endif
    if FRAME_StatusHeroMain2 != null then
        call BlzFrameSetVisible(FRAME_StatusHeroMain2, false)
    endif
    if FRAME_StatusHeroMain3 != null then
        call BlzFrameSetVisible(FRAME_StatusHeroMain3, false)
    endif
    if FRAME_StatusHeroMain4 != null then
        call BlzFrameSetVisible(FRAME_StatusHeroMain4, false)
    endif
    if FRAME_StatsMain != null then
        call BlzFrameSetVisible(FRAME_StatsMain, false)
    endif
endfunction

//===========================================================================
// Финальный экран матча. Вызывается один раз после установки END1 = 1.
// У каждого клиента открывает его локальную копию табло в подробном режиме.
//===========================================================================
function WOS_STATS_ShowFinal takes nothing returns nothing
    local integer pid = 0

    // Всегда оставляем десять строк, включая игроков без активного героя.
    set WOS_STATS_SHOW_INACTIVE_PLAYERS = true

    loop
        exitwhen pid >= WOS_STATS_PLAYER_COUNT
        // Состояние записывается одинаково на всех клиентах.
        set WOS_STATS_IsOpen[pid] = true
        set WOS_STATS_IsExpanded[pid] = true
        set WOS_STATS_IsFinal[pid] = true
        set WOS_STATS_IsOpaque[pid] = true

        // GetLocalPlayer используется только в условии локальной работы
        // с сообщениями и фреймами. Локальный pid нигде не сохраняется.
        if GetLocalPlayer() == Player(pid) then
            // Удаляет с экрана чат и сообщения DisplayTimedTextToPlayer.
            call ClearTextMessages()
            call WOS_STATS_HideLegacyUI()
            call BlzFrameSetVisible(WOS_STATS_Main, true)
            call BlzFrameSetVisible(WOS_STATS_Inner, true)
            call WOS_STATS_UpdateForPlayer(pid)
            call BlzFrameSetAlpha(WOS_STATS_OpaqueBack, 255)
            call BlzFrameSetVisible(WOS_STATS_OpaqueBack, true)

            // На финальном экране управление больше не требуется.
            call BlzFrameSetVisible(WOS_STATS_OpacityButton, false)
            call BlzFrameSetVisible(WOS_STATS_ExpandButton, false)
            call BlzFrameSetVisible(WOS_STATS_CloseButton, false)
        endif
        set pid = pid + 1
    endloop
endfunction

private function WOS_STATS_RestoreLegacyUI takes integer pid returns nothing
    if FRAME_StatusHeroMain != null then
        call BlzFrameSetVisible(FRAME_StatusHeroMain, WOS_STATS_OldTopVisible[pid])
    endif
    if FRAME_StatusHeroMain2 != null then
        call BlzFrameSetVisible(FRAME_StatusHeroMain2, WOS_STATS_OldTakenVisible[pid])
    endif
    if FRAME_StatusHeroMain3 != null then
        call BlzFrameSetVisible(FRAME_StatusHeroMain3, WOS_STATS_OldOptionsVisible[pid])
    endif
    if FRAME_StatusHeroMain4 != null then
        call BlzFrameSetVisible(FRAME_StatusHeroMain4, WOS_STATS_OldCameraVisible[pid])
    endif
    if FRAME_StatsMain != null then
        call BlzFrameSetVisible(FRAME_StatsMain, WOS_STATS_OldHeroStatsVisible[pid])
    endif
endfunction

private function WOS_STATS_SetOpen takes player whichPlayer, boolean open returns nothing
    local integer pid = GetPlayerId(whichPlayer)

    if pid < 0 or pid >= WOS_STATS_PLAYER_COUNT then
        return
    endif
    set WOS_STATS_IsOpen[pid] = open
    if GetLocalPlayer() == whichPlayer then
        if open then
            call WOS_STATS_SaveAndHideLegacyUI(pid)
            call BlzFrameSetVisible(WOS_STATS_Main, true)
            call BlzFrameSetVisible(WOS_STATS_Inner, true)
            call WOS_STATS_UpdateForPlayer(pid)
        else
            call BlzFrameSetVisible(WOS_STATS_Main, false)
            call WOS_STATS_RestoreLegacyUI(pid)
        endif
    endif
endfunction

private function WOS_STATS_OnKey takes nothing returns nothing
    local player whichPlayer = GetTriggerPlayer()
    local integer pid = GetPlayerId(whichPlayer)

    if END1 != 0 then
        set whichPlayer = null
        return
    endif
    call WOS_STATS_SetOpen(whichPlayer, not WOS_STATS_IsOpen[pid])
    set whichPlayer = null
endfunction

private function WOS_STATS_OnClose takes nothing returns nothing
    local player whichPlayer = GetTriggerPlayer()

    if END1 != 0 then
        set whichPlayer = null
        return
    endif
    call WOS_STATS_SetOpen(whichPlayer, false)
    set whichPlayer = null
endfunction

private function WOS_STATS_OnOpacity takes nothing returns nothing
    local player whichPlayer = GetTriggerPlayer()
    local integer pid = GetPlayerId(whichPlayer)

    if END1 != 0 then
        set whichPlayer = null
        return
    endif
    set WOS_STATS_IsOpaque[pid] = not WOS_STATS_IsOpaque[pid]
    if GetLocalPlayer() == whichPlayer then
        call BlzFrameSetEnable(WOS_STATS_OpacityButton, false)
        call BlzFrameSetEnable(WOS_STATS_OpacityButton, true)
        call WOS_STATS_UpdateForPlayer(pid)
    endif
    set whichPlayer = null
endfunction

private function WOS_STATS_OnExpand takes nothing returns nothing
    local player whichPlayer = GetTriggerPlayer()
    local integer pid = GetPlayerId(whichPlayer)

    if END1 != 0 then
        set whichPlayer = null
        return
    endif
    set WOS_STATS_IsExpanded[pid] = not WOS_STATS_IsExpanded[pid]
    if GetLocalPlayer() == whichPlayer then
        call BlzFrameSetEnable(WOS_STATS_ExpandButton, false)
        call BlzFrameSetEnable(WOS_STATS_ExpandButton, true)
        call WOS_STATS_UpdateForPlayer(pid)
    endif
    set whichPlayer = null
endfunction

private function WOS_STATS_Periodic takes nothing returns nothing
    local integer pid = 0

    loop
        exitwhen pid >= WOS_STATS_PLAYER_COUNT
        if WOS_STATS_IsOpen[pid] and GetLocalPlayer() == Player(pid) then
            // Очищаем и новые сообщения локально на протяжении всего времени,
            // пока у этого игрока открыто финальное табло.
            if WOS_STATS_IsFinal[pid] then
                call ClearTextMessages()
            endif
            call WOS_STATS_HideLegacyUI()
            call BlzFrameSetVisible(WOS_STATS_Main, true)
            call WOS_STATS_UpdateForPlayer(pid)
        endif
        set pid = pid + 1
    endloop
endfunction

//===========================================================================
// Создание интерфейса
//===========================================================================
private function WOS_STATS_CreateHeaders takes nothing returns nothing
    local integer team = 0
    local integer column
    local integer index
    local real headerY
    local real totalY
    local string teamColor
    local string teamName

    loop
        exitwhen team >= 2
        if team == 0 then
            set headerY = 0.441
            set totalY = 0.326
            set teamColor = "|cffff4040"
            set teamName = "Wos Enjoyers"
            set WOS_STATS_TeamTitle[team] = WOS_STATS_CreateText(WOS_STATS_Inner, 0.285, 0.474, 0.130, 0.013, 0.64, TEXT_JUSTIFY_LEFT, teamColor + teamName + "|r", 100 + team)
        else
            set headerY = 0.294
            set totalY = 0.179
            set teamColor = "|cff4080ff"
            set teamName = "Wos Haters"
            set WOS_STATS_TeamTitle[team] = WOS_STATS_CreateText(WOS_STATS_Inner, 0.285, 0.340, 0.130, 0.013, 0.64, TEXT_JUSTIFY_LEFT, teamColor + teamName + "|r", 100 + team)
        endif

        set index = team * 9
        set WOS_STATS_HeaderText[index + 0] = WOS_STATS_CreateText(WOS_STATS_Inner, 0.275, headerY, 0.100, 0.014, 0.44, TEXT_JUSTIFY_LEFT, "|cffc6cbd1PLAYER|r", 200 + index)
        set WOS_STATS_HeaderText[index + 1] = WOS_STATS_CreateText(WOS_STATS_Inner, WOS_STATS_ColumnX(0), headerY, 0.060, 0.014, 0.42, TEXT_JUSTIFY_CENTER, "|cffffd36bK|r |cffc6cbd1/|r |cffd58cffD|r", 201 + index)
        set WOS_STATS_HeaderText[index + 2] = WOS_STATS_CreateText(WOS_STATS_Inner, WOS_STATS_ExpandedColumnX(1), headerY, 0.065, 0.014, 0.38, TEXT_JUSTIFY_CENTER, "|cffd58cffDEATHS|r", 202 + index)
        set WOS_STATS_HeaderText[index + 3] = WOS_STATS_CreateText(WOS_STATS_Inner, WOS_STATS_ColumnX(2), headerY, 0.075, 0.014, 0.38, TEXT_JUSTIFY_CENTER, "|cffff8a73DAMAGE|r", 203 + index)
        set WOS_STATS_HeaderText[index + 4] = WOS_STATS_CreateText(WOS_STATS_Inner, WOS_STATS_ExpandedColumnX(3), headerY, 0.075, 0.014, 0.34, TEXT_JUSTIFY_CENTER, "|cff6fa8ffMAGICAL DEALT|r", 204 + index)
        set WOS_STATS_HeaderText[index + 5] = WOS_STATS_CreateText(WOS_STATS_Inner, WOS_STATS_ColumnX(3), headerY, 0.060, 0.014, 0.42, TEXT_JUSTIFY_CENTER, "|cff63e692HEAL|r", 205 + index)
        set WOS_STATS_HeaderText[index + 6] = WOS_STATS_CreateText(WOS_STATS_Inner, WOS_STATS_ColumnX(4), headerY, 0.100, 0.014, 0.34, TEXT_JUSTIFY_CENTER, "|cff91b8ffTAKEN DAMAGE|r", 206 + index)
        set WOS_STATS_HeaderText[index + 7] = WOS_STATS_CreateText(WOS_STATS_Inner, WOS_STATS_ExpandedColumnX(6), headerY, 0.075, 0.014, 0.34, TEXT_JUSTIFY_CENTER, "|cff91b8ffMAGICAL TAKEN|r", 207 + index)
        set WOS_STATS_HeaderText[index + 8] = WOS_STATS_CreateText(WOS_STATS_Inner, 0.560, headerY, 0.080, 0.014, 0.42, TEXT_JUSTIFY_CENTER, "|cffc6cbd1ITEMS|r", 208 + index)
        call BlzFrameSetVisible(WOS_STATS_HeaderText[index + 2], false)
        call BlzFrameSetVisible(WOS_STATS_HeaderText[index + 4], false)
        call BlzFrameSetVisible(WOS_STATS_HeaderText[index + 7], false)

        set WOS_STATS_TotalLabel[team] = WOS_STATS_CreateText(WOS_STATS_Inner, 0.263, totalY, 0.100, 0.011, 0.36, TEXT_JUSTIFY_LEFT, teamColor + "TEAM TOTAL|r", 300 + team)
        set column = 0
        loop
            exitwhen column >= 7
            set WOS_STATS_TotalText[team * 7 + column] = WOS_STATS_CreateText(WOS_STATS_Inner, WOS_STATS_ExpandedColumnX(column), totalY, WOS_STATS_ExpandedColumnWidth(column), 0.014, 0.45, TEXT_JUSTIFY_CENTER, "|cffffffff0|r", 320 + team * 7 + column)
            set column = column + 1
        endloop
        set WOS_STATS_TotalDamageHover[team] = WOS_STATS_CreateHoverArea(WOS_STATS_Inner, WOS_STATS_ColumnX(2), totalY, WOS_STATS_ColumnWidth(2), 0.012, 360 + team * 2)
        set WOS_STATS_TotalTakenHover[team] = WOS_STATS_CreateHoverArea(WOS_STATS_Inner, WOS_STATS_ColumnX(4), totalY, WOS_STATS_ColumnWidth(4), 0.012, 361 + team * 2)
        call WOS_STATS_CreateCombatTooltip(WOS_STATS_TotalDamageHover[team], 20 + team * 2)
        call WOS_STATS_CreateCombatTooltip(WOS_STATS_TotalTakenHover[team], 21 + team * 2)
        set team = team + 1
    endloop
endfunction

private function WOS_STATS_CreateRows takes nothing returns nothing
    local integer row = 0
    local integer slot
    local integer itemIndex
    local real y
    local real itemX
    local framehandle icon

    loop
        exitwhen row >= WOS_STATS_PLAYER_COUNT
        set y = WOS_STATS_RowY(row)
        set WOS_STATS_RowBack[row] = WOS_STATS_CreateBackdrop(WOS_STATS_Inner, WOS_STATS_TEX_ROW, WOS_STATS_PANEL_X, y, WOS_STATS_ROW_WIDTH, WOS_STATS_ROW_HEIGHT, 105, 600 + row)
        call BlzFrameSetLevel(WOS_STATS_RowBack[row], 3)

        // Содержимое является соседним слоем, а не ребёнком полупрозрачной полосы.
        // Поэтому alpha RowBack больше не затрагивает портрет, текст и предметы.
        set WOS_STATS_RowContent[row] = BlzCreateFrameByType("FRAME", "WosStatsRowContent", WOS_STATS_Inner, "", 650 + row)
        call BlzFrameSetAbsPoint(WOS_STATS_RowContent[row], FRAMEPOINT_CENTER, WOS_STATS_ScaleX(WOS_STATS_PANEL_X), WOS_STATS_ScaleY(y))
        call BlzFrameSetSize(WOS_STATS_RowContent[row], WOS_STATS_ScaleSize(WOS_STATS_ROW_WIDTH), WOS_STATS_ScaleSize(WOS_STATS_ROW_HEIGHT))
        call BlzFrameSetLevel(WOS_STATS_RowContent[row], 10)
        call BlzFrameSetAlpha(WOS_STATS_RowContent[row], 255)

        set WOS_STATS_HeroIcon[row] = BlzCreateFrameByType("BACKDROP", "WosStatsHeroIcon", WOS_STATS_RowContent[row], "", 700 + row)
        call BlzFrameSetAbsPoint(WOS_STATS_HeroIcon[row], FRAMEPOINT_CENTER, WOS_STATS_ScaleX(0.233), WOS_STATS_ScaleY(y))
        call BlzFrameSetSize(WOS_STATS_HeroIcon[row], WOS_STATS_ScaleSize(WOS_STATS_HERO_ICON_SIZE), WOS_STATS_ScaleSize(WOS_STATS_HERO_ICON_SIZE))
        call BlzFrameSetTexture(WOS_STATS_HeroIcon[row], WOS_STATS_TEX_EMPTY, 0, false)

        set WOS_STATS_MvpText[row] = WOS_STATS_CreateText(WOS_STATS_RowContent[row], 0.211, y, 0.028, 0.0095, 0.46, TEXT_JUSTIFY_CENTER, "", 680 + row)
        call BlzFrameSetLevel(WOS_STATS_MvpText[row], 30)
        set WOS_STATS_MvpHover[row] = WOS_STATS_CreateHoverArea(WOS_STATS_RowContent[row], 0.211, y, 0.030, WOS_STATS_ROW_HEIGHT, 690 + row)
        call WOS_STATS_CreateSimpleTooltip(WOS_STATS_MvpHover[row], "|cffffd36bMVP|r = highest contribution\nKills + damage + healing + tanking - deaths", 0.120, 0.030, 5400 + row)

        set WOS_STATS_PlayerName[row] = WOS_STATS_CreateText(WOS_STATS_RowContent[row], 0.275, y, 0.068, 0.011, 0.46, TEXT_JUSTIFY_LEFT, "", 800 + row)
        set WOS_STATS_KillText[row] = WOS_STATS_CreateText(WOS_STATS_RowContent[row], WOS_STATS_ColumnX(0), y, WOS_STATS_ColumnWidth(0), 0.011, 0.49, TEXT_JUSTIFY_CENTER, "0", 820 + row)
        set WOS_STATS_DeathText[row] = WOS_STATS_CreateText(WOS_STATS_RowContent[row], WOS_STATS_ColumnX(1), y, WOS_STATS_ColumnWidth(1), 0.011, 0.49, TEXT_JUSTIFY_CENTER, "0", 840 + row)
        set WOS_STATS_DamageText[row] = WOS_STATS_CreateText(WOS_STATS_RowContent[row], WOS_STATS_ColumnX(2), y, WOS_STATS_ColumnWidth(2), 0.011, 0.47, TEXT_JUSTIFY_CENTER, "0", 860 + row)
        set WOS_STATS_DamageMagText[row] = WOS_STATS_CreateText(WOS_STATS_RowContent[row], WOS_STATS_ExpandedColumnX(3), y, WOS_STATS_ExpandedColumnWidth(3), 0.014, 0.47, TEXT_JUSTIFY_CENTER, "0", 870 + row)
        set WOS_STATS_HealText[row] = WOS_STATS_CreateText(WOS_STATS_RowContent[row], WOS_STATS_ColumnX(3), y, WOS_STATS_ColumnWidth(3), 0.011, 0.47, TEXT_JUSTIFY_CENTER, "0", 880 + row)
        set WOS_STATS_TakenText[row] = WOS_STATS_CreateText(WOS_STATS_RowContent[row], WOS_STATS_ColumnX(4), y, WOS_STATS_ColumnWidth(4), 0.011, 0.45, TEXT_JUSTIFY_CENTER, "0", 900 + row)
        set WOS_STATS_TakenMagText[row] = WOS_STATS_CreateText(WOS_STATS_RowContent[row], WOS_STATS_ExpandedColumnX(6), y, WOS_STATS_ExpandedColumnWidth(6), 0.014, 0.45, TEXT_JUSTIFY_CENTER, "0", 910 + row)
        call BlzFrameSetVisible(WOS_STATS_DeathText[row], false)
        call BlzFrameSetVisible(WOS_STATS_DamageMagText[row], false)
        call BlzFrameSetVisible(WOS_STATS_TakenMagText[row], false)

        set WOS_STATS_DamageHover[row] = WOS_STATS_CreateHoverArea(WOS_STATS_RowContent[row], WOS_STATS_ColumnX(2), y, WOS_STATS_ColumnWidth(2), WOS_STATS_ROW_HEIGHT, 920 + row)
        set WOS_STATS_TakenHover[row] = WOS_STATS_CreateHoverArea(WOS_STATS_RowContent[row], WOS_STATS_ColumnX(4), y, WOS_STATS_ColumnWidth(4), WOS_STATS_ROW_HEIGHT, 940 + row)
        call WOS_STATS_CreateCombatTooltip(WOS_STATS_DamageHover[row], row * 2)
        call WOS_STATS_CreateCombatTooltip(WOS_STATS_TakenHover[row], row * 2 + 1)

        set slot = 0
        loop
            exitwhen slot >= WOS_STATS_ITEM_COUNT
            set itemIndex = row * WOS_STATS_ITEM_COUNT + slot
            set itemX = 0.527 + I2R(slot) * WOS_STATS_ITEM_STEP
            set WOS_STATS_ItemButton[itemIndex] = BlzCreateFrameByType("BUTTON", "WosStatsItemButton", WOS_STATS_RowContent[row], "ScoreScreenTabButtonTemplate", 1000 + itemIndex)
            call BlzFrameSetAbsPoint(WOS_STATS_ItemButton[itemIndex], FRAMEPOINT_CENTER, WOS_STATS_ScaleX(itemX), WOS_STATS_ScaleY(y))
            call BlzFrameSetSize(WOS_STATS_ItemButton[itemIndex], WOS_STATS_ScaleSize(WOS_STATS_ITEM_ICON_SIZE), WOS_STATS_ScaleSize(WOS_STATS_ITEM_ICON_SIZE))
            call BlzFrameSetLevel(WOS_STATS_ItemButton[itemIndex], 25)

            set icon = BlzCreateFrameByType("BACKDROP", "WosStatsItemIcon", WOS_STATS_ItemButton[itemIndex], "", 1100 + itemIndex)
            call BlzFrameSetAllPoints(icon, WOS_STATS_ItemButton[itemIndex])
            call BlzFrameSetLevel(icon, 26)
            call BlzFrameSetTexture(icon, WOS_STATS_TEX_EMPTY, 0, false)
            set WOS_STATS_ItemIcon[itemIndex] = icon
            call WOS_STATS_CreateItemTooltip(WOS_STATS_ItemButton[itemIndex], itemIndex)
            call BlzFrameSetVisible(WOS_STATS_ItemButton[itemIndex], false)
            set slot = slot + 1
        endloop

        set WOS_STATS_LastRowPid[row] = -1
        call BlzFrameSetVisible(WOS_STATS_RowBack[row], false)
        call BlzFrameSetVisible(WOS_STATS_RowContent[row], false)
        set row = row + 1
    endloop
    set icon = null
endfunction

private function WOS_STATS_CreateCloseTooltip takes nothing returns nothing
    call WOS_STATS_CreateSimpleTooltip(WOS_STATS_CloseButton, "|cffffffffClose [F2]|r", 0.060, 0.016, 5490)
endfunction

private function WOS_STATS_CreateUI takes nothing returns nothing
    local integer pid = 0
    local framehandle gameUI = BlzGetFrameByName("ConsoleUIBackdrop", 0)

    // Компактная рамка ListBoxWar3: тоньше EscMenuBackdrop и не подрезает
    // верхнюю строку интерфейса толстой каменной кромкой.
    set WOS_STATS_Main = BlzCreateFrame(WOS_STATS_FRAME_TEMPLATE, gameUI, 0, 4700)
    call BlzFrameSetAbsPoint(WOS_STATS_Main, FRAMEPOINT_CENTER, WOS_STATS_ScaleX(WOS_STATS_PANEL_X), WOS_STATS_ScaleY(WOS_STATS_PANEL_Y))
    call BlzFrameSetSize(WOS_STATS_Main, WOS_STATS_ScaleSize(WOS_STATS_PANEL_WIDTH), WOS_STATS_ScaleSize(WOS_STATS_PANEL_HEIGHT))
    set WOS_STATS_OpaqueBack = WOS_STATS_CreateBackdrop(WOS_STATS_Main, WOS_STATS_TEX_PANEL_FILL, WOS_STATS_PANEL_X, WOS_STATS_PANEL_Y, WOS_STATS_CONTENT_WIDTH, WOS_STATS_CONTENT_HEIGHT, 255, 4709)
    call BlzFrameSetLevel(WOS_STATS_OpaqueBack, 1)
    call BlzFrameSetVisible(WOS_STATS_OpaqueBack, false)
    // Невидимый контейнер: он не закрывает текстуру ListBoxWar3 у Main.
    // Чёрный фон остаётся только у WOS_STATS_RowBack каждой строки игрока.
    set WOS_STATS_Inner = BlzCreateFrameByType("FRAME", "WosStatsInner", WOS_STATS_Main, "", 4701)
    call BlzFrameSetAbsPoint(WOS_STATS_Inner, FRAMEPOINT_CENTER, WOS_STATS_ScaleX(WOS_STATS_PANEL_X), WOS_STATS_ScaleY(WOS_STATS_PANEL_Y))
    call BlzFrameSetSize(WOS_STATS_Inner, WOS_STATS_ScaleSize(WOS_STATS_CONTENT_WIDTH), WOS_STATS_ScaleSize(WOS_STATS_CONTENT_HEIGHT))
    call BlzFrameSetLevel(WOS_STATS_Inner, 2)

    set WOS_STATS_Title = WOS_STATS_CreateText(WOS_STATS_Inner, 0.285, 0.492, 0.140, 0.014, 0.55, TEXT_JUSTIFY_LEFT, "|cffffd36bWOS2 STATISTICS|r", 4702)
    set WOS_STATS_Score = WOS_STATS_CreateText(WOS_STATS_Inner, 0.400, 0.491, 0.085, 0.020, 1.10, TEXT_JUSTIFY_CENTER, "", 4707)
    set WOS_STATS_MatchInfo = WOS_STATS_CreateText(WOS_STATS_Inner, 0.480, 0.492, 0.072, 0.015, 0.81, TEXT_JUSTIFY_CENTER, "", 4703)
    set WOS_STATS_ScreenshotClock = WOS_STATS_CreateText(WOS_STATS_Inner, 0.495, 0.492, 0.085, 0.016, 0.82, TEXT_JUSTIFY_CENTER, "", 4714)
    call BlzFrameSetVisible(WOS_STATS_ScreenshotClock, false)
    set WOS_STATS_GameClock = WOS_STATS_CreateText(WOS_STATS_Inner, 0.540, 0.492, 0.055, 0.016, 0.92, TEXT_JUSTIFY_CENTER, "", 4708)

    // Обычный BUTTON без шаблона: hitbox совпадает с визуальной позицией.
    set WOS_STATS_CloseButton = BlzCreateFrameByType("BUTTON", "WosStatsCloseButton", WOS_STATS_Main, "", 4704)
    call BlzFrameSetAbsPoint(WOS_STATS_CloseButton, FRAMEPOINT_CENTER, WOS_STATS_ScaleX(0.598), WOS_STATS_ScaleY(0.492))
    call BlzFrameSetSize(WOS_STATS_CloseButton, WOS_STATS_ScaleSize(0.018), WOS_STATS_ScaleSize(0.018))
    call BlzFrameSetLevel(WOS_STATS_CloseButton, 60)
    set WOS_STATS_CloseIcon = BlzCreateFrameByType("BACKDROP", "WosStatsCloseIcon", WOS_STATS_CloseButton, "", 4705)
    call BlzFrameSetPoint(WOS_STATS_CloseIcon, FRAMEPOINT_CENTER, WOS_STATS_CloseButton, FRAMEPOINT_CENTER, 0.0, 0.0)
    call BlzFrameSetSize(WOS_STATS_CloseIcon, WOS_STATS_ScaleSize(0.011), WOS_STATS_ScaleSize(0.011))
    call BlzFrameSetLevel(WOS_STATS_CloseIcon, 61)
    call BlzFrameSetTexture(WOS_STATS_CloseIcon, WOS_STATS_TEX_CLOSE, 0, true)

    set WOS_STATS_OpacityButton = BlzCreateFrameByType("BUTTON", "WosStatsOpacityButton", WOS_STATS_Main, "", 4710)
    call BlzFrameSetAbsPoint(WOS_STATS_OpacityButton, FRAMEPOINT_CENTER, WOS_STATS_ScaleX(0.558), WOS_STATS_ScaleY(0.492))
    call BlzFrameSetSize(WOS_STATS_OpacityButton, WOS_STATS_ScaleSize(0.018), WOS_STATS_ScaleSize(0.018))
    call BlzFrameSetLevel(WOS_STATS_OpacityButton, 60)
    set WOS_STATS_OpacityIcon = BlzCreateFrameByType("BACKDROP", "WosStatsOpacityIcon", WOS_STATS_OpacityButton, "", 4711)
    call BlzFrameSetPoint(WOS_STATS_OpacityIcon, FRAMEPOINT_CENTER, WOS_STATS_OpacityButton, FRAMEPOINT_CENTER, 0.0, 0.0)
    call BlzFrameSetSize(WOS_STATS_OpacityIcon, WOS_STATS_ScaleSize(0.011), WOS_STATS_ScaleSize(0.011))
    call BlzFrameSetLevel(WOS_STATS_OpacityIcon, 61)
    call BlzFrameSetTexture(WOS_STATS_OpacityIcon, WOS_STATS_TEX_OPACITY_OFF, 0, true)

    set WOS_STATS_ExpandButton = BlzCreateFrameByType("BUTTON", "WosStatsExpandButton", WOS_STATS_Main, "", 4712)
    call BlzFrameSetAbsPoint(WOS_STATS_ExpandButton, FRAMEPOINT_CENTER, WOS_STATS_ScaleX(0.578), WOS_STATS_ScaleY(0.492))
    call BlzFrameSetSize(WOS_STATS_ExpandButton, WOS_STATS_ScaleSize(0.018), WOS_STATS_ScaleSize(0.018))
    call BlzFrameSetLevel(WOS_STATS_ExpandButton, 60)
    set WOS_STATS_ExpandIcon = BlzCreateFrameByType("BACKDROP", "WosStatsExpandIcon", WOS_STATS_ExpandButton, "", 4713)
    call BlzFrameSetPoint(WOS_STATS_ExpandIcon, FRAMEPOINT_CENTER, WOS_STATS_ExpandButton, FRAMEPOINT_CENTER, 0.0, 0.0)
    call BlzFrameSetSize(WOS_STATS_ExpandIcon, WOS_STATS_ScaleSize(0.011), WOS_STATS_ScaleSize(0.011))
    call BlzFrameSetLevel(WOS_STATS_ExpandIcon, 61)
    call BlzFrameSetTexture(WOS_STATS_ExpandIcon, WOS_STATS_TEX_EXPAND, 0, true)

    call WOS_STATS_CreateCloseTooltip()
    call WOS_STATS_CreateSimpleTooltip(WOS_STATS_OpacityButton, "|cffffffffTransparent / opaque background|r", 0.105, 0.016, 5491)
    call WOS_STATS_CreateSimpleTooltip(WOS_STATS_ExpandButton, "|cffffffffExpand / minimize details|r", 0.095, 0.016, 5492)
    call WOS_STATS_CreateHeaders()
    call WOS_STATS_CreateRows()

    set WOS_STATS_KeyTrigger = CreateTrigger()
    set WOS_STATS_CloseTrigger = CreateTrigger()
    set WOS_STATS_OpacityTrigger = CreateTrigger()
    set WOS_STATS_ExpandTrigger = CreateTrigger()
    loop
        exitwhen pid >= WOS_STATS_PLAYER_COUNT
        call BlzTriggerRegisterPlayerKeyEvent(WOS_STATS_KeyTrigger, Player(pid), OSKEY_F2, 0, false)
        set pid = pid + 1
    endloop
    call BlzTriggerRegisterFrameEvent(WOS_STATS_CloseTrigger, WOS_STATS_CloseButton, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(WOS_STATS_OpacityTrigger, WOS_STATS_OpacityButton, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(WOS_STATS_ExpandTrigger, WOS_STATS_ExpandButton, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(WOS_STATS_KeyTrigger, function WOS_STATS_OnKey)
    call TriggerAddAction(WOS_STATS_CloseTrigger, function WOS_STATS_OnClose)
    call TriggerAddAction(WOS_STATS_OpacityTrigger, function WOS_STATS_OnOpacity)
    call TriggerAddAction(WOS_STATS_ExpandTrigger, function WOS_STATS_OnExpand)

    set WOS_STATS_UpdateTimer = CreateTimer()
    call TimerStart(WOS_STATS_UpdateTimer, WOS_STATS_UPDATE_PERIOD, true, function WOS_STATS_Periodic)
    call BlzFrameSetVisible(WOS_STATS_Main, false)
    set gameUI = null
endfunction

private function WOS_STATS_DelayedInit takes nothing returns nothing
    local timer initTimer = GetExpiredTimer()

    call WOS_STATS_CreateUI()
    call DestroyTimer(initTimer)
    set initTimer = null
endfunction

private function WOS_STATS_Init takes nothing returns nothing
    local timer initTimer = CreateTimer()

    call TimerStart(initTimer, 0.00, false, function WOS_STATS_DelayedInit)
    set initTimer = null
endfunction

endlibrary
