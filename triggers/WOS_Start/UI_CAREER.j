//===========================================================================
// WOS2 Career Statistics
//===========================================================================
library WosCareerStats initializer WCS_Init requires AAINIT, heroicon, WOSUI

globals
    private constant integer WCS_PLAYER_COUNT = 10
    private constant integer WCS_CATEGORY_COUNT = 6
    private constant integer WCS_HERO_SLOT_COUNT = 30
    private constant integer WCS_HERO_COLUMN_COUNT = 6
    private constant integer WCS_LAST_ITEM_COUNT = 6
    private constant integer WCS_BEST_ITEM_COUNT = 6
    private constant integer WCS_RELATION_ROW_COUNT = 4
    private constant integer WCS_RELATION_SLOT_COUNT = 5

    private constant real WCS_PANEL_X = 0.400
    private constant real WCS_PANEL_Y = 0.315
    // Checkpoint 23: the whole window is laid out 1.2x larger around its
    // centre (WCS_X / WCS_Y / WCS_S), with a readable minimum text scale.
    private constant real WCS_ZOOM = 1.20
    private constant real WCS_MIN_TEXT = 0.62
    private constant real WCS_PANEL_WIDTH = 0.350 * WCS_ZOOM
    private constant real WCS_PANEL_HEIGHT = 0.265 * WCS_ZOOM
    private constant real WCS_OPEN_X = 0.691
    private constant real WCS_OPEN_Y = 0.548
    private constant real WCS_OPEN_SIZE = 0.022

    private constant string WCS_TEX_BLACK = WUI_PANEL_TEXTURE
    private constant string WCS_TEX_CLOSE = "Music\\Music_Close.blp"
    private constant string WCS_TEX_EMPTY = "Pick\\wos_stat"
    private constant string WCS_TEX_OPEN = "UI\\WOS\\glyph-history.tga"

    private framehandle WCS_Main = null
    private framehandle WCS_OpenButton = null
    private framehandle WCS_OpenIcon = null
    private framehandle WCS_CloseButton = null
    private framehandle WCS_CloseIcon = null
    private framehandle WCS_HomeButton = null
    private framehandle WCS_HeroesButton = null
    private framehandle WCS_Title = null
    private framehandle WCS_HomePage = null
    private framehandle WCS_HeroesPage = null
    private framehandle WCS_DetailPage = null

    private framehandle WCS_HomeOverall = null
    private framehandle WCS_HomeHero = null
    // Career window layout (2026-10-19): label / value columns, hero icon cards,
    // a most-played strip and short fixed-size tooltips (no per-character sizing).
    private constant integer WCS_TOP_HERO_COUNT = 6
    private constant integer WCS_TOP_HERO_SCAN = 64
    private constant string WCS_LABEL = "|cffc9b98a"
    private constant string WCS_MUTED = "|cff8a96a3"
    private framehandle WCS_HomeSource = null
    private framehandle WCS_HomeOverallLabels = null
    private framehandle WCS_HomeHeroIconFrame = null
    private framehandle WCS_HomeHeroName = null
    private framehandle WCS_HomeHeroLabels = null
    private framehandle WCS_HomeHeroValues = null
    private framehandle WCS_HomeTopEmpty = null
    // Rank by finished games (the profile counter only grows at the end of a match).
    private framehandle WCS_RankText = null
    private framehandle WCS_RankNext = null
    private framehandle WCS_RankBack = null
    private framehandle WCS_RankFill = null
    private constant real WCS_RANK_BAR_WIDTH = 0.300
    private constant real WCS_LEVEL_BAR_WIDTH = 0.236
    // Blend textures rank-fill-<rank>-<step>.tga (BlzFrameSetVertexColor does not tint BACKDROPs).
    private constant string WCS_TEX_RANK_FILL = "UI\\WOS\\rank-fill-0-0.tga"
    private constant string WCS_TEX_RANK_GOLD = "UI\\WOS\\rank-gold.tga"
    private framehandle WCS_LevelText = null
    private framehandle WCS_LevelBack = null
    private framehandle WCS_LevelFill = null
    private constant integer WCS_RANK_MAX = 5
    private framehandle WCS_RankSensor = null
    private framehandle WCS_RankTooltip = null
    private framehandle WCS_RankTooltipText = null
    private framehandle array WCS_TopHeroButton
    private framehandle array WCS_TopHeroIcon
    private framehandle array WCS_TopHeroText
    private framehandle array WCS_TopHeroTooltip
    private framehandle array WCS_TopHeroTooltipText
    private integer array WCS_TopHeroId
    private integer array WCS_TopHeroGames
    private framehandle WCS_DetailSubtitle = null
    private framehandle array WCS_DetailCardLabels
    private framehandle array WCS_DetailCardValues
    private framehandle array WCS_RelationEmpty
    private framehandle WCS_LastItemsEmpty = null
    private framehandle WCS_BestItemsEmpty = null

    private framehandle array WCS_CategoryButton
    private framehandle array WCS_CategoryIcon
    private framehandle array WCS_CategoryTooltip
    private framehandle array WCS_HeroButton
    private framehandle array WCS_HeroIcon
    private framehandle array WCS_HeroName
    private framehandle array WCS_HeroStatBack
    private framehandle array WCS_HeroStat
    private framehandle array WCS_HeroTooltip
    private framehandle array WCS_HeroTooltipText
    private integer array WCS_VisibleHeroId

    private framehandle WCS_DetailHeroIcon = null
    private framehandle WCS_DetailHeroName = null
    private framehandle WCS_DetailPersonal = null
    private framehandle WCS_DetailAverage = null
    private framehandle WCS_DetailBest = null
    private framehandle WCS_DetailLastTitle = null
    private framehandle WCS_DetailBestItemsTitle = null
    private framehandle array WCS_LastItemButton
    private framehandle array WCS_LastItemIcon
    private framehandle array WCS_LastItemText
    private framehandle array WCS_LastItemTooltip
    private framehandle array WCS_LastItemTooltipText
    private framehandle array WCS_BestItemButton
    private framehandle array WCS_BestItemIcon
    private framehandle array WCS_BestItemText
    private framehandle array WCS_BestItemTooltip
    private framehandle array WCS_BestItemTooltipText
    private framehandle array WCS_RelationTitle
    private framehandle array WCS_RelationButton
    private framehandle array WCS_RelationIcon
    private framehandle array WCS_RelationTooltip
    private framehandle array WCS_RelationTooltipText
    private framehandle array WCS_RelationText

    private trigger WCS_OpenTrigger = null
    private trigger WCS_CloseTrigger = null
    private trigger WCS_HomeTrigger = null
    private trigger WCS_HeroesTrigger = null
    private trigger WCS_CategoryTrigger = null
    private trigger WCS_HeroTrigger = null
    private trigger WCS_HotkeyTrigger = null
    private timer WCS_CatalogTimer = null

    // Hero_ID0..5 are a live pick pool: ReloadAfterPick/ban code replaces a
    // taken hero with 12. Career UI needs the original immutable catalogue.
    private integer array WCS_CatalogHeroId
    private boolean WCS_CatalogReady = false
    // heroId -> category + 1 once the catalogue is frozen (was a 6x30 scan per lookup;
    // the OTHER page repeated it per slot and per recorded hero and hit the op limit).
    private hashtable WCS_CategoryTable = InitHashtable()
    private integer array WCS_ExtraList
    private integer array WCS_Page
    private integer array WCS_Category
    private integer array WCS_DetailHeroId
    // Эти значения намеренно могут различаться между клиентами. Они читаются
    // только локальным UI и никогда не участвуют в игровой логике.
    private framehandle WCS_LastCreatedTooltip = null
endglobals

private function WCS_CategoryName takes integer category returns string
    if category == 1 then
        return "GACHA"
    elseif category == 2 then
        return "BLEACH"
    elseif category == 3 then
        return "FAIRY TAIL"
    elseif category == 4 then
        return "ONE PIECE"
    elseif category == 5 then
        return "JUJUTSU KAISEN"
    endif
    return "OTHER"
endfunction

private function WCS_CategoryTexture takes integer category returns string
    if category == 1 then
        return "UI\\WOS\\pick-logo-gacha.tga"
    elseif category == 2 then
        return "UI\\WOS\\pick-logo-bleach.tga"
    elseif category == 3 then
        return "UI\\WOS\\pick-logo-fairytail.tga"
    elseif category == 4 then
        return "UI\\WOS\\pick-logo-onepiece.tga"
    elseif category == 5 then
        return "UI\\WOS\\pick-logo-jujutsu.tga"
    endif
    return "UI\\WOS\\pick-logo-other.tga"
endfunction

private function WCS_X takes real x returns real
    return WCS_PANEL_X + (x - WCS_PANEL_X) * WCS_ZOOM
endfunction

private function WCS_Y takes real y returns real
    return WCS_PANEL_Y + (y - WCS_PANEL_Y) * WCS_ZOOM
endfunction

private function WCS_S takes real value returns real
    return value * WCS_ZOOM
endfunction

private function WCS_Percent takes integer wins, integer games returns string
    if games <= 0 then
        return "N/A"
    endif
    return I2S(wins*100/games) + "%"
endfunction

// Винрейт героя: за текущий сезон WOS App (если в нём есть игры), иначе за всё время.
private function WCS_HeroRate takes player viewer, integer heroId, integer wins, integer games returns string
    local integer seasonGames = SaveSystem_GetHeroSeasonGames(viewer, heroId)
    if seasonGames > 0 then
        return WCS_Percent(SaveSystem_GetHeroSeasonWins(viewer, heroId), seasonGames)
    endif
    return WCS_Percent(wins, games)
endfunction

// Средний винрейт по сезонам с 5+ играми на герое.
private function WCS_HeroAverage takes player viewer, integer heroId returns string
    local integer value = SaveSystem_GetHeroSeasonAvgWr100(viewer, heroId)
    if value < 0 then
        return "N/A"
    endif
    return I2S((value + 50)/100) + "%"
endfunction

// Строки подсказки: всё время + сезон + средний по сезонам.
private function WCS_HeroRateLines takes player viewer, integer heroId, integer wins, integer games returns string
    local string result = "Games: " + I2S(games) + "   Wins: " + I2S(wins) + "\nAll time: " + WCS_Percent(wins, games)
    if SaveSystem_HasHeroSeason(viewer, heroId) then
        set result = result + "\nSeason: " + WCS_Percent(SaveSystem_GetHeroSeasonWins(viewer, heroId), SaveSystem_GetHeroSeasonGames(viewer, heroId)) + " (" + I2S(SaveSystem_GetHeroSeasonGames(viewer, heroId)) + " games)\nSeasons average: " + WCS_HeroAverage(viewer, heroId)
    endif
    return result
endfunction

private function WCS_Decimal100 takes integer value returns string
    local integer whole = value/100
    local integer fraction = ModuloInteger(value, 100)
    if fraction < 0 then
        set fraction = -fraction
    endif
    if fraction < 10 then
        return I2S(whole) + ".0" + I2S(fraction)
    endif
    return I2S(whole) + "." + I2S(fraction)
endfunction

private function WCS_CreateText takes framehandle parent, real x, real y, real width, real height, real scale, textaligntype horizontal, string value, integer context returns framehandle
    local framehandle result = BlzCreateFrameByType("TEXT", "WcsText", parent, "", context)
    local real shown = RMaxBJ(scale * WCS_ZOOM, WCS_MIN_TEXT)
    call BlzFrameSetAbsPoint(result, FRAMEPOINT_CENTER, WCS_X(x), WCS_Y(y))
    // Scale shrinks the box too: keep the zoomed on-screen box size.
    call BlzFrameSetSize(result, WCS_S(width) * scale / shown, WCS_S(height) * scale / shown)
    call BlzFrameSetTextAlignment(result, TEXT_JUSTIFY_MIDDLE, horizontal)
    call BlzFrameSetScale(result, shown)
    call BlzFrameSetText(result, value)
    return result
endfunction

private function WCS_CreateBackdrop takes framehandle parent, real x, real y, real width, real height, integer alpha, integer context returns framehandle
    local framehandle result = BlzCreateFrameByType("BACKDROP", "WcsBackdrop", parent, "", context)
    call BlzFrameSetAbsPoint(result, FRAMEPOINT_CENTER, WCS_X(x), WCS_Y(y))
    call BlzFrameSetSize(result, WCS_S(width), WCS_S(height))
    call BlzFrameSetTexture(result, WCS_TEX_BLACK, 0, true)
    call BlzFrameSetAlpha(result, alpha)
    return result
endfunction

private function WCS_CreateIconButton takes framehandle parent, real x, real y, real size, integer context returns framehandle
    local framehandle result = BlzCreateFrameByType("BUTTON", "WcsIconButton", parent, "WOSIconButtonTemplate", context)
    call BlzFrameSetAbsPoint(result, FRAMEPOINT_CENTER, WCS_X(x), WCS_Y(y))
    call BlzFrameSetSize(result, WCS_S(size), WCS_S(size))
    return result
endfunction

private function WCS_CreateIcon takes framehandle buttonFrame, string texture, integer context returns framehandle
    local framehandle result = BlzCreateFrameByType("BACKDROP", "WcsIcon", buttonFrame, "", context)
    call BlzFrameSetAllPoints(result, buttonFrame)
    call BlzFrameSetTexture(result, texture, 0, true)
    return result
endfunction

// Same gold text button as Hide UI / Shop Key.
private function WCS_CreateTextButton takes framehandle parent, real x, real y, real width, real height, string value, integer context returns framehandle
    local framehandle buttonFrame = WUI_TextButton("WcsTextButton", parent, value, WCS_S(width), WCS_S(height) * 0.80)
    call WUI_Place(buttonFrame, WCS_X(x), WCS_Y(y), WCS_S(width), WCS_S(height) * 0.80)
    call WUI_SetButtonTextScale(buttonFrame, 0.86)
    return buttonFrame
endfunction

// Card: dark fill + gold header line text; returns nothing (frames are static).
private function WCS_CreateCard takes framehandle parent, real x, real y, real width, real height, string title, integer context returns nothing
    local framehandle header
    set header = WCS_CreateBackdrop(parent, x, y, width, height, 165, context)
    set header = WCS_CreateBackdrop(parent, x, y + height*0.5 - 0.0075, width - 0.004, 0.013, 230, context + 1)
    call BlzFrameSetTexture(header, WUI_FILL_NORMAL, 0, true)
    set header = WCS_CreateText(parent, x, y + height*0.5 - 0.0075, width - 0.006, 0.012, 0.56, TEXT_JUSTIFY_CENTER, "|cffffd36b" + title + "|r", context + 2)
    set header = null
endfunction

private function WCS_GetLiveHeroId takes integer category, integer slot returns integer
    if category == 1 then
        return Hero_ID0[slot]
    elseif category == 2 then
        return Hero_ID1[slot]
    elseif category == 3 then
        return Hero_ID2[slot]
    elseif category == 4 then
        return Hero_ID3[slot]
    elseif category == 5 then
        return Hero_ID4[slot]
    elseif category == 6 then
        return Hero_ID5[slot]
    endif
    return 0
endfunction

private function WCS_GetHeroId takes integer category, integer slot returns integer
    if category < 1 or category > WCS_CATEGORY_COUNT or slot < 0 or slot >= WCS_HERO_SLOT_COUNT then
        return 0
    endif
    if WCS_CatalogReady then
        return WCS_CatalogHeroId[(category - 1)*WCS_HERO_SLOT_COUNT + slot]
    endif
    return WCS_GetLiveHeroId(category, slot)
endfunction

private function WCS_CaptureHeroCatalog takes nothing returns boolean
    local integer category = 1
    local integer slot
    local integer heroId
    local integer heroCount = 0
    local boolean alreadyMutated = false
    if WCS_CatalogReady then
        return true
    endif

    // Hero IDs are filled by MyHeroIdInit about one second after map start.
    // Never freeze an empty or already modified (12) pick pool.
    loop
        exitwhen category > WCS_CATEGORY_COUNT
        set slot = 0
        loop
            exitwhen slot >= WCS_HERO_SLOT_COUNT
            set heroId = WCS_GetLiveHeroId(category, slot)
            if heroId == 12 then
                set alreadyMutated = true
            elseif heroId != 0 then
                set heroCount = heroCount + 1
            endif
            set slot = slot + 1
        endloop
        set category = category + 1
    endloop
    if heroCount == 0 or alreadyMutated then
        return false
    endif

    set category = 1
    loop
        exitwhen category > WCS_CATEGORY_COUNT
        set slot = 0
        loop
            exitwhen slot >= WCS_HERO_SLOT_COUNT
            set heroId = WCS_GetLiveHeroId(category, slot)
            set WCS_CatalogHeroId[(category - 1)*WCS_HERO_SLOT_COUNT + slot] = heroId
            if heroId != 0 and heroId != 12 and not HaveSavedInteger(WCS_CategoryTable, heroId, 0) then
                call SaveInteger(WCS_CategoryTable, heroId, 0, category + 1)
            endif
            set slot = slot + 1
        endloop
        set category = category + 1
    endloop
    set WCS_CatalogReady = true
    return true
endfunction

private function WCS_CatalogTick takes nothing returns nothing
    local timer catalogTimer = GetExpiredTimer()
    if WCS_CaptureHeroCatalog() then
        call PauseTimer(catalogTimer)
        call DestroyTimer(catalogTimer)
        set WCS_CatalogTimer = null
    endif
    set catalogTimer = null
endfunction

private function WCS_FindHeroCategory takes integer heroId returns integer
    local integer category = 1
    local integer slot
    if heroId == 0 or heroId == 12 then
        return 0
    endif
    if WCS_CatalogReady then
        return IMaxBJ(0, LoadInteger(WCS_CategoryTable, heroId, 0) - 1)
    endif
    loop
        exitwhen category > WCS_CATEGORY_COUNT
        set slot = 0
        loop
            exitwhen slot >= WCS_HERO_SLOT_COUNT
            if WCS_GetHeroId(category, slot) == heroId then
                return category
            endif
            set slot = slot + 1
        endloop
        set category = category + 1
    endloop
    return 0
endfunction

private function WCS_GetExtraHeroId takes player viewer, integer rank, integer excludedHeroId returns integer
    local integer recordRank = 1
    local integer found = 0
    local integer heroId
    loop
        set heroId = SaveSystem_GetRecordedHeroId(viewer, recordRank)
        exitwhen heroId == 0
        if heroId != 12 and heroId != excludedHeroId and WCS_FindHeroCategory(heroId) == 0 then
            set found = found + 1
            if found == rank then
                return heroId
            endif
        endif
        set recordRank = recordRank + 1
    endloop
    return 0
endfunction

private function WCS_CreateTooltip takes framehandle owner, real width, real height, integer context returns framehandle
    // Checkpoint 23: shared tooltip box with a drawn gold edge.
    // Wider frame around the text: the gold edge no longer touches the letters.
    local framehandle tooltip = WUI_TooltipBox(WUI_GetRoot(), width + 0.018, height + 0.012)
    local framehandle label = BlzCreateFrameByType("TEXT", "WcsTooltipText", tooltip, "", context)
    call BlzFrameSetPoint(tooltip, FRAMEPOINT_BOTTOM, owner, FRAMEPOINT_TOP, 0.0, 0.003)
    call BlzFrameSetLevel(tooltip, 90)
    call BlzFrameSetPoint(label, FRAMEPOINT_TOPLEFT, tooltip, FRAMEPOINT_TOPLEFT, 0.011, -0.008)
    call BlzFrameSetPoint(label, FRAMEPOINT_BOTTOMRIGHT, tooltip, FRAMEPOINT_BOTTOMRIGHT, -0.011, 0.008)
    call BlzFrameSetTextAlignment(label, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(label, 0.85)
    call BlzFrameSetEnable(label, false)
    call BlzFrameSetText(label, "")
    call BlzFrameSetVisible(tooltip, false)
    call BlzFrameSetTooltip(owner, tooltip)
    call WUI_RegisterCareerTip(tooltip)
    set WCS_LastCreatedTooltip = tooltip
    set tooltip = null
    return label
endfunction

private function WCS_HideTooltips takes integer pid returns nothing
    local integer index = 0
    if pid < 0 or pid >= WCS_PLAYER_COUNT or GetLocalPlayer() != Player(pid) then
        return
    endif
    loop
        exitwhen index >= WCS_CATEGORY_COUNT
        if WCS_CategoryTooltip[index] != null then
            call BlzFrameSetVisible(WCS_CategoryTooltip[index], false)
        endif
        set index = index + 1
    endloop
    set index = 0
    loop
        exitwhen index >= WCS_HERO_SLOT_COUNT
        if WCS_HeroTooltip[index] != null then
            call BlzFrameSetVisible(WCS_HeroTooltip[index], false)
        endif
        set index = index + 1
    endloop
    set index = 0
    loop
        exitwhen index >= WCS_LAST_ITEM_COUNT
        if WCS_LastItemTooltip[index] != null then
            call BlzFrameSetVisible(WCS_LastItemTooltip[index], false)
        endif
        set index = index + 1
    endloop
    set index = 0
    loop
        exitwhen index >= WCS_BEST_ITEM_COUNT
        if WCS_BestItemTooltip[index] != null then
            call BlzFrameSetVisible(WCS_BestItemTooltip[index], false)
        endif
        set index = index + 1
    endloop
    set index = 0
    loop
        exitwhen index >= WCS_RELATION_ROW_COUNT*WCS_RELATION_SLOT_COUNT
        if WCS_RelationTooltip[index] != null then
            call BlzFrameSetVisible(WCS_RelationTooltip[index], false)
        endif
        set index = index + 1
    endloop
    if WCS_RankTooltip != null then
        call BlzFrameSetVisible(WCS_RankTooltip, false)
    endif
    set index = 0
    loop
        exitwhen index >= WCS_TOP_HERO_COUNT
        if WCS_TopHeroTooltip[index] != null then
            call BlzFrameSetVisible(WCS_TopHeroTooltip[index], false)
        endif
        set index = index + 1
    endloop
endfunction

private function WCS_SetPage takes integer pid, integer page returns nothing
    if pid < 0 or pid >= WCS_PLAYER_COUNT or GetLocalPlayer() != Player(pid) then
        return
    endif
    if page < 0 or page > 2 then
        set page = 0
    endif
    set WCS_Page[pid] = page
    call WCS_HideTooltips(pid)
    call BlzFrameSetVisible(WCS_HomePage, page == 0)
    call BlzFrameSetVisible(WCS_HeroesPage, page == 1)
    call BlzFrameSetVisible(WCS_DetailPage, page == 2)
endfunction

// Rank ladder by finished games (index 0..WCS_RANK_MAX); 1000 games = top rank.
private function WCS_RankFloor takes integer rank returns integer
    if rank <= 0 then
        return 0
    elseif rank == 1 then
        return 50
    elseif rank == 2 then
        return 100
    elseif rank == 3 then
        return 250
    elseif rank == 4 then
        return 500
    endif
    return 1000
endfunction

// Rank colour stops (smooth blend between them on the status bar).
private function WCS_RankRed takes integer rank returns integer
    if rank <= 0 then
        return 86
    elseif rank == 1 then
        return 255
    elseif rank == 2 then
        return 72
    elseif rank == 3 then
        return 176
    elseif rank == 4 then
        return 255
    endif
    return 255
endfunction

private function WCS_RankGreen takes integer rank returns integer
    if rank <= 0 then
        return 214
    elseif rank == 1 then
        return 150
    elseif rank == 2 then
        return 168
    elseif rank == 3 then
        return 96
    elseif rank == 4 then
        return 82
    endif
    return 206
endfunction

private function WCS_RankBlue takes integer rank returns integer
    if rank <= 0 then
        return 92
    elseif rank == 1 then
        return 40
    elseif rank == 2 then
        return 255
    elseif rank == 3 then
        return 255
    elseif rank == 4 then
        return 82
    endif
    return 74
endfunction

private function WCS_RankName takes integer rank returns string
    if rank <= 0 then
        return "|cff56d65cNOOB|r"
    elseif rank == 1 then
        return "|cffff9628NORMAL|r"
    elseif rank == 2 then
        return "|cff48a8ffADVANCED|r"
    elseif rank == 3 then
        return "|cffb060ffEXPERT|r"
    elseif rank == 4 then
        return "|cffff5252MASTER|r"
    endif
    return "|cffffce4aSOUL KING|r"
endfunction

private function WCS_RankOf takes integer games returns integer
    local integer rank = 0
    loop
        exitwhen rank >= WCS_RANK_MAX or games < WCS_RankFloor(rank + 1)
        set rank = rank + 1
    endloop
    return rank
endfunction

// Local: status bar (the whole ladder, colour blends rank to rank), level bar
// (games inside the current rank) and the ladder tooltip.
private function WCS_UpdateRank takes integer games returns nothing
    local integer rank = WCS_RankOf(games)
    local integer low = WCS_RankFloor(rank)
    local integer high = WCS_RankFloor(rank + 1)
    local integer step = WCS_RANK_MAX
    local real part = 1.0
    local real status
    local integer red
    local integer green
    local integer blue
    local string ladder = ""
    if rank < WCS_RANK_MAX and high > low then
        set part = I2R(games - low) / I2R(high - low)
    endif
    if part < 0.0 then
        set part = 0.0
    elseif part > 1.0 then
        set part = 1.0
    endif
    // Equal segment per rank on the status bar.
    set status = (I2R(rank) + part) / I2R(WCS_RANK_MAX)
    if rank >= WCS_RANK_MAX then
        set status = 1.0
    endif
    call BlzFrameSetText(WCS_RankText, "|cffffffffSTATUS|r   " + WCS_RankName(rank))
    call BlzFrameSetText(WCS_RankNext, "")
    if rank >= WCS_RANK_MAX then
        call BlzFrameSetTexture(WCS_RankFill, WCS_TEX_RANK_GOLD, 0, true)
        call BlzFrameSetTexture(WCS_LevelFill, WCS_TEX_RANK_GOLD, 0, true)
    else
        // Status colour blends toward the next rank (10 steps per rank).
        set red = R2I(part * 9.0 + 0.5)
        call BlzFrameSetTexture(WCS_RankFill, "UI\\WOS\\rank-fill-" + I2S(rank) + "-" + I2S(red) + ".tga", 0, true)
        call BlzFrameSetTexture(WCS_LevelFill, "UI\\WOS\\rank-fill-" + I2S(rank) + "-0.tga", 0, true)
    endif
    call BlzFrameSetVisible(WCS_RankFill, status > 0.001)
    call BlzFrameSetSize(WCS_RankFill, RMaxBJ(0.001, WCS_S(WCS_RANK_BAR_WIDTH) * status), WCS_S(0.012))
    // Level = finished games out of the next rank threshold.
    if rank < WCS_RANK_MAX then
        call BlzFrameSetText(WCS_LevelText, "|cffffffffLEVEL  " + I2S(games) + " / " + I2S(high) + "|r")
    else
        call BlzFrameSetText(WCS_LevelText, "|cffffffffLEVEL  " + I2S(games) + "  MAX|r")
    endif
    call BlzFrameSetVisible(WCS_LevelFill, part > 0.001)
    call BlzFrameSetSize(WCS_LevelFill, RMaxBJ(0.001, WCS_S(WCS_LEVEL_BAR_WIDTH) * part), WCS_S(0.009))
    // Ladder, top rank first; the current one is marked.
    loop
        exitwhen step < 0
        if step == rank then
            set ladder = ladder + "|cffffffff>  |r" + WCS_RankName(step) + "   |cffffffff" + I2S(WCS_RankFloor(step)) + "+ games|r"
        else
            set ladder = ladder + "    " + WCS_RankName(step) + "   " + WCS_MUTED + I2S(WCS_RankFloor(step)) + "+ games|r"
        endif
        if step > 0 then
            set ladder = ladder + "\n"
        endif
        set step = step - 1
    endloop
    if rank < WCS_RANK_MAX then
        set ladder = ladder + "\n\n" + WCS_MUTED + "Next: |r" + WCS_RankName(rank + 1) + WCS_MUTED + " in " + I2S(high - games) + " games|r"
    endif
    call BlzFrameSetText(WCS_RankTooltipText, "|cffffd36bRANK LADDER|r\n" + WCS_MUTED + "Finished games, counted at match end.|r\n\n" + ladder)
endfunction

// Local: up to WCS_TOP_HERO_COUNT recorded heroes with the most games.
private function WCS_FillTopHeroes takes player viewer returns integer
    local integer rank = 1
    local integer count = 0
    local integer heroId
    local integer games
    local integer index
    loop
        exitwhen rank > WCS_TOP_HERO_SCAN
        set heroId = SaveSystem_GetRecordedHeroId(viewer, rank)
        exitwhen heroId == 0
        if heroId != 12 then
            set games = SaveSystem_GetHeroGames(viewer, heroId)
            if games > 0 then
                // Insertion into the short sorted list.
                set index = count
                if count < WCS_TOP_HERO_COUNT then
                    set count = count + 1
                elseif games <= WCS_TopHeroGames[WCS_TOP_HERO_COUNT - 1] then
                    set index = -1
                else
                    set index = WCS_TOP_HERO_COUNT - 1
                endif
                loop
                    exitwhen index <= 0 or WCS_TopHeroGames[index - 1] >= games
                    set WCS_TopHeroGames[index] = WCS_TopHeroGames[index - 1]
                    set WCS_TopHeroId[index] = WCS_TopHeroId[index - 1]
                    set index = index - 1
                endloop
                if index >= 0 then
                    set WCS_TopHeroGames[index] = games
                    set WCS_TopHeroId[index] = heroId
                endif
            endif
        endif
        set rank = rank + 1
    endloop
    return count
endfunction

private function WCS_UpdateHome takes integer pid returns nothing
    local player viewer = null
    local integer games
    local integer wins
    local integer heroId = 0
    local integer heroGames
    local integer heroWins
    local integer count
    local integer slot = 0
    if pid < 0 or pid >= WCS_PLAYER_COUNT or GetLocalPlayer() != Player(pid) then
        return
    endif
    set viewer = Player(pid)
    set games = SaveSystem_GetGamesPlayed(viewer)
    set wins = SaveSystem_GetGamesWon(viewer)
    if Hero[pid] != null then
        set heroId = GetUnitTypeId(Hero[pid])
    endif
    call WCS_UpdateRank(games)
    if SaveSystem_GetSeasonName() != "" then
        call BlzFrameSetText(WCS_HomeSource, WCS_MUTED + "Source: " + SaveSystem_CareerSource() + "|r   |cffffd36b" + SaveSystem_GetSeasonName() + "|r")
    else
        call BlzFrameSetText(WCS_HomeSource, WCS_MUTED + "Source: " + SaveSystem_CareerSource() + "|r")
    endif
    call BlzFrameSetText(WCS_HomeOverallLabels, WCS_LABEL + "Games\nWins\nLosses\nWin rate\nLocal games\nLocal win rate\nKilled by the train|r")
    call BlzFrameSetText(WCS_HomeOverall, "|cffffffff" + I2S(games) + "|r\n|cff76d7a8" + I2S(wins) + "|r\n|cffff7777" + I2S(games - wins) + "|r\n|cffffd36b" + WCS_Percent(wins, games) + "|r\n|cffffffff" + I2S(SaveSystem_GetLocalGames()) + "|r\n|cffffffff" + WCS_Percent(SaveSystem_GetLocalWins(), SaveSystem_GetLocalGames()) + "|r\n|cffff9a5a" + I2S(SaveSystem_GetLocalTrainDeaths()) + "|r")
    if SaveSystem_IsLocalLoadFailed() and not SaveSystem_HasAppProfile() then
        call BlzFrameSetText(WCS_HomeOverallLabels, "")
        call BlzFrameSetText(WCS_HomeOverall, "")
        call BlzFrameSetText(WCS_HomeSource, "|cffff7777Profile unavailable - saved progress kept.|r")
    endif
    if heroId == 0 then
        call BlzFrameSetVisible(WCS_HomeHeroIconFrame, false)
        call BlzFrameSetText(WCS_HomeHeroName, "")
        call BlzFrameSetText(WCS_HomeHeroLabels, "")
        call BlzFrameSetText(WCS_HomeHeroValues, "")
        call BlzFrameSetText(WCS_HomeHero, WCS_MUTED + "No hero selected yet.|r")
    else
        set heroGames = SaveSystem_GetHeroGames(viewer, heroId)
        set heroWins = SaveSystem_GetHeroWins(viewer, heroId)
        call BlzFrameSetVisible(WCS_HomeHeroIconFrame, true)
        call BlzFrameSetTexture(WCS_HomeHeroIconFrame, BlzGetAbilityIcon(heroId), 0, false)
        call BlzFrameSetText(WCS_HomeHeroName, "|cffffffff" + GetObjectName(heroId) + "|r")
        call BlzFrameSetText(WCS_HomeHero, "")
        call BlzFrameSetText(WCS_HomeHeroLabels, WCS_LABEL + "Games\nWins\nSeason win rate\nSeasons average|r")
        call BlzFrameSetText(WCS_HomeHeroValues, "|cffffffff" + I2S(heroGames) + "|r\n|cff76d7a8" + I2S(heroWins) + "|r\n|cffffd36b" + WCS_HeroRate(viewer, heroId, heroWins, heroGames) + "|r\n|cffffffff" + WCS_HeroAverage(viewer, heroId) + "|r")
    endif
    set count = WCS_FillTopHeroes(viewer)
    call BlzFrameSetVisible(WCS_HomeTopEmpty, count == 0)
    loop
        exitwhen slot >= WCS_TOP_HERO_COUNT
        if slot < count then
            set heroId = WCS_TopHeroId[slot]
            set heroGames = WCS_TopHeroGames[slot]
            set heroWins = SaveSystem_GetHeroWins(viewer, heroId)
            call BlzFrameSetVisible(WCS_TopHeroButton[slot], true)
            call BlzFrameSetTexture(WCS_TopHeroIcon[slot], BlzGetAbilityIcon(heroId), 0, false)
            call BlzFrameSetText(WCS_TopHeroText[slot], "|cffffffff" + I2S(heroGames) + "|r " + WCS_LABEL + WCS_HeroRate(viewer, heroId, heroWins, heroGames) + "|r")
            call BlzFrameSetText(WCS_TopHeroTooltipText[slot], "|cffffd36b" + GetObjectName(heroId) + "|r\n" + WCS_HeroRateLines(viewer, heroId, heroWins, heroGames))
        else
            call BlzFrameSetVisible(WCS_TopHeroButton[slot], false)
            call BlzFrameSetText(WCS_TopHeroText[slot], "")
        endif
        set slot = slot + 1
    endloop
    set viewer = null
endfunction

private function WCS_UpdateHeroes takes integer pid returns nothing
    local player viewer = null
    local integer slot = 0
    local integer heroId
    local integer currentHeroId = 0
    local integer extraRank = 1
    local integer extraCount = 0
    local integer extraNext = 0
    local integer games
    local integer wins
    local boolean currentExtraPlaced = false
    if pid < 0 or pid >= WCS_PLAYER_COUNT or GetLocalPlayer() != Player(pid) then
        return
    endif
   set viewer = Player(pid)
    if Hero[pid] != null then
        set currentHeroId = GetUnitTypeId(Hero[pid])
    endif
    call BlzFrameSetText(WCS_Title, "|cffffd36bHEROES / " + WCS_CategoryName(WCS_Category[pid]) + "|r")
    // OTHER: recorded heroes outside the catalogue, collected in one pass.
    if WCS_Category[pid] == 6 then
        loop
            exitwhen extraRank > 64 or extraCount >= WCS_HERO_SLOT_COUNT
            set heroId = SaveSystem_GetRecordedHeroId(viewer, extraRank)
            exitwhen heroId == 0
            if heroId != 12 and heroId != currentHeroId and WCS_FindHeroCategory(heroId) == 0 then
                set WCS_ExtraList[extraCount] = heroId
                set extraCount = extraCount + 1
            endif
            set extraRank = extraRank + 1
        endloop
    endif
    loop
        exitwhen slot >= WCS_HERO_SLOT_COUNT
        set heroId = WCS_GetHeroId(WCS_Category[pid], slot)
        if heroId == 12 then
            set heroId = 0
        endif
        // Герои, которых нет в статических Hero_ID0..5, не теряются:
        // текущий и сохранённые профили занимают свободные ячейки OTHER.
        if WCS_Category[pid] == 6 and heroId == 0 then
            if currentHeroId != 0 and WCS_FindHeroCategory(currentHeroId) == 0 and not currentExtraPlaced then
                set heroId = currentHeroId
                set currentExtraPlaced = true
            elseif extraNext < extraCount then
                set heroId = WCS_ExtraList[extraNext]
                set extraNext = extraNext + 1
            endif
        endif
        set WCS_VisibleHeroId[slot] = heroId
        if heroId == 0 then
            call BlzFrameSetVisible(WCS_HeroButton[slot], false)
            call BlzFrameSetVisible(WCS_HeroName[slot], false)
            call BlzFrameSetText(WCS_HeroName[slot], "")
            call BlzFrameSetText(WCS_HeroTooltipText[slot], "")
            call BlzFrameSetVisible(WCS_HeroStatBack[slot], false)
        else
            set games = SaveSystem_GetHeroGames(viewer, heroId)
            set wins = SaveSystem_GetHeroWins(viewer, heroId)
            call BlzFrameSetVisible(WCS_HeroButton[slot], true)
            call BlzFrameSetVisible(WCS_HeroName[slot], true)
            call BlzFrameSetTexture(WCS_HeroIcon[slot], BlzGetAbilityIcon(heroId), 0, false)
            call BlzFrameSetText(WCS_HeroName[slot], GetObjectName(heroId))
            call BlzFrameSetVisible(WCS_HeroStatBack[slot], games > 0)
            if games > 0 then
                call BlzFrameSetText(WCS_HeroStat[slot], "|cffffffff" + I2S(games) + "|r |cffffd36b" + WCS_HeroRate(viewer, heroId, wins, games) + "|r")
            endif
            call BlzFrameSetText(WCS_HeroTooltipText[slot], "|cffffd36b" + GetObjectName(heroId) + "|r\n" + WCS_HeroRateLines(viewer, heroId, wins, games) + "\n|cff9aa7b4Click for details.|r")
        endif
        set slot = slot + 1
    endloop
    set viewer = null
endfunction

private function WCS_ItemDescription takes integer itemId returns string
    local string tooltip = BlzGetAbilityTooltip(itemId, 0)
    local string description = BlzGetAbilityExtendedTooltip(itemId, 0)
    if tooltip == "" and description == "" then
        return "|cff9aa7b4No object description available.|r"
    endif
    if tooltip == "" then
        return description
    endif
    if description == "" or description == tooltip then
        return tooltip
    endif
    set description = tooltip + "\n" + description
    return description
endfunction

// Item descriptions vary a lot in length. Estimate wrapped line count at the
// tooltip's fixed readable width and resize only the local frame backdrop.
private function WCS_ItemTooltipHeight takes string value returns real
    local integer length = StringLength(value)
    local integer index = 0
    local integer column = 0
    local integer lines = 1
    local real height
    loop
        exitwhen index >= length
        if SubString(value, index, index + 1) == "\n" then
            set lines = lines + 1
            set column = 0
        else
            set column = column + 1
            if column >= 43 then
                set lines = lines + 1
                set column = 0
            endif
        endif
        set index = index + 1
    endloop
    set height = 0.018 + I2R(lines)*0.0072
    if height < 0.058 then
        set height = 0.058
    elseif height > 0.190 then
        set height = 0.190
    endif
    return height
endfunction

private function WCS_UpdateLastItem takes integer slot, integer heroId, player viewer returns nothing
    local integer itemId = SaveSystem_GetLastBuildItemId(viewer, heroId, slot)
    local integer finalGames
    local integer finalWins
    local integer usedGames
    local integer usedWins
    local string tooltipText
    if viewer == null or GetLocalPlayer() != viewer then
        return
    endif
    if itemId == 0 then
        call BlzFrameSetVisible(WCS_LastItemButton[slot], false)
        call BlzFrameSetText(WCS_LastItemText[slot], "")
        return
    endif
    set finalGames = SaveSystem_GetItemFinalGames(viewer, heroId, itemId)
    set finalWins = SaveSystem_GetItemFinalWins(viewer, heroId, itemId)
    set usedGames = SaveSystem_GetItemUsedGames(viewer, heroId, itemId)
    set usedWins = SaveSystem_GetItemUsedWins(viewer, heroId, itemId)
    call BlzFrameSetVisible(WCS_LastItemButton[slot], true)
    call BlzFrameSetTexture(WCS_LastItemIcon[slot], BlzGetAbilityIcon(itemId), 0, false)
    call BlzFrameSetText(WCS_LastItemText[slot], WCS_LABEL + WCS_Percent(finalWins, finalGames) + "|r")
    set tooltipText = "|cffffd36b" + GetObjectName(itemId) + "|r\nIn final build: " + WCS_Percent(finalWins, finalGames) + " wins (" + I2S(finalGames) + ")\nUsed: " + WCS_Percent(usedWins, usedGames) + " wins (" + I2S(usedGames) + ")"
    call BlzFrameSetText(WCS_LastItemTooltipText[slot], tooltipText)
endfunction

private function WCS_UpdateBestItem takes integer slot, integer heroId, player viewer returns nothing
    local integer itemId = SaveSystem_GetBestItemId(viewer, heroId, slot + 1)
    local integer finalGames
    local integer finalWins
    local integer usedGames
    local integer usedWins
    local string tooltipText
    if viewer == null or GetLocalPlayer() != viewer then
        return
    endif
    if itemId == 0 then
        call BlzFrameSetVisible(WCS_BestItemButton[slot], false)
        call BlzFrameSetText(WCS_BestItemText[slot], "")
        return
    endif
    set finalGames = SaveSystem_GetItemFinalGames(viewer, heroId, itemId)
    set finalWins = SaveSystem_GetItemFinalWins(viewer, heroId, itemId)
    set usedGames = SaveSystem_GetItemUsedGames(viewer, heroId, itemId)
    set usedWins = SaveSystem_GetItemUsedWins(viewer, heroId, itemId)
    call BlzFrameSetVisible(WCS_BestItemButton[slot], true)
    call BlzFrameSetTexture(WCS_BestItemIcon[slot], BlzGetAbilityIcon(itemId), 0, false)
    call BlzFrameSetText(WCS_BestItemText[slot], "|cffffd36b" + WCS_Percent(finalWins, finalGames) + "|r")
    set tooltipText = "|cffffd36b" + GetObjectName(itemId) + "|r\nIn final build: " + WCS_Percent(finalWins, finalGames) + " wins (" + I2S(finalGames) + ")\nUsed: " + WCS_Percent(usedWins, usedGames) + " wins (" + I2S(usedGames) + ")"
    call BlzFrameSetText(WCS_BestItemTooltipText[slot], tooltipText)
endfunction

private function WCS_RelationName takes integer relationType returns string
    if relationType == 0 then
        return "GOOD AGAINST"
    elseif relationType == 1 then
        return "BAD AGAINST"
    elseif relationType == 2 then
        return "GOOD WITH"
    endif
    return "BAD WITH"
endfunction

private function WCS_UpdateRelations takes integer heroId, player viewer returns nothing
    local integer relationType = 0
    local integer slot
    local integer index
    local integer otherHeroId
    local integer games
    local integer wins
    if viewer == null or GetLocalPlayer() != viewer then
        return
    endif
    loop
        exitwhen relationType >= WCS_RELATION_ROW_COUNT
        call BlzFrameSetVisible(WCS_RelationEmpty[relationType], SaveSystem_GetBestRelationHeroId(viewer, heroId, relationType, 1) == 0)
        set slot = 0
        loop
            exitwhen slot >= WCS_RELATION_SLOT_COUNT
            set index = relationType*WCS_RELATION_SLOT_COUNT + slot
            set otherHeroId = SaveSystem_GetBestRelationHeroId(viewer, heroId, relationType, slot + 1)
            if otherHeroId == 0 then
                call BlzFrameSetVisible(WCS_RelationButton[index], false)
                call BlzFrameSetText(WCS_RelationTooltipText[index], "")
                call BlzFrameSetText(WCS_RelationText[index], "")
            else
                set games = SaveSystem_GetRelationGames(viewer, heroId, otherHeroId, relationType)
                set wins = SaveSystem_GetRelationWins(viewer, heroId, otherHeroId, relationType)
                call BlzFrameSetVisible(WCS_RelationButton[index], true)
                call BlzFrameSetTexture(WCS_RelationIcon[index], BlzGetAbilityIcon(otherHeroId), 0, false)
                call BlzFrameSetText(WCS_RelationTooltipText[index], "|cffffd36b" + GetObjectName(otherHeroId) + "|r\n" + I2S(games) + " games, " + WCS_Percent(wins, games) + " wins")
                call BlzFrameSetText(WCS_RelationText[index], WCS_LABEL + WCS_Percent(wins, games) + "|r")
            endif
            set slot = slot + 1
        endloop
        set relationType = relationType + 1
    endloop
endfunction

private function WCS_UpdateDetail takes integer pid returns nothing
    local player viewer = Player(pid)
    local integer heroId = WCS_DetailHeroId[pid]
    local integer games = SaveSystem_GetHeroGames(viewer, heroId)
    local integer wins = SaveSystem_GetHeroWins(viewer, heroId)
    local integer combatGames = SaveSystem_GetHeroCombatGames(viewer, heroId)
    local integer kills = SaveSystem_GetHeroTotalKills(viewer, heroId)
    local integer deaths = SaveSystem_GetHeroTotalDeaths(viewer, heroId)
    local integer averageKills = 0
    local integer averageDeaths = 0
    local integer slot = 0
    if pid < 0 or pid >= WCS_PLAYER_COUNT or GetLocalPlayer() != Player(pid) then
        set viewer = null
        return
    endif
    if heroId == 0 then
        call WCS_SetPage(pid, 1)
        set viewer = null
        return
    endif
    if combatGames > 0 then
        set averageKills = kills*100/combatGames
        set averageDeaths = deaths*100/combatGames
    endif
    call BlzFrameSetText(WCS_Title, "|cffffd36bHERO DETAILS|r")
    call BlzFrameSetTexture(WCS_DetailHeroIcon, BlzGetAbilityIcon(heroId), 0, false)
    call BlzFrameSetText(WCS_DetailHeroName, "|cffffd36b" + GetObjectName(heroId) + "|r")
    if SaveSystem_HasHeroSeason(viewer, heroId) then
        call BlzFrameSetText(WCS_DetailSubtitle, WCS_MUTED + SaveSystem_HeroCareerSource(heroId) + ":|r |cffffffff" + I2S(games) + " games|r  " + WCS_LABEL + "season|r |cffffd36b" + WCS_HeroRate(viewer, heroId, wins, games) + "|r  " + WCS_LABEL + "avg|r |cffffffff" + WCS_HeroAverage(viewer, heroId) + "|r")
    else
        call BlzFrameSetText(WCS_DetailSubtitle, WCS_MUTED + SaveSystem_HeroCareerSource(heroId) + ":|r |cffffffff" + I2S(games) + " games|r  " + WCS_LABEL + "win rate|r |cffffd36b" + WCS_Percent(wins, games) + "|r")
    endif
    call BlzFrameSetText(WCS_DetailCardLabels[0], WCS_LABEL + "Wins\nLosses\nLocal|r")
    call BlzFrameSetText(WCS_DetailCardValues[0], "|cff76d7a8" + I2S(wins) + "|r\n|cffff7777" + I2S(games - wins) + "|r\n|cffffffff" + I2S(SaveSystem_GetLocalHeroGames(heroId)) + "|r")
    if combatGames > 0 then
        call BlzFrameSetText(WCS_DetailCardLabels[2], WCS_LABEL + "Kills\nDeaths\nGames|r")
        call BlzFrameSetText(WCS_DetailCardValues[2], "|cffffffff" + WCS_Decimal100(averageKills) + "\n" + WCS_Decimal100(averageDeaths) + "\n" + I2S(combatGames) + "|r")
        call BlzFrameSetText(WCS_DetailCardLabels[3], WCS_LABEL + "Kills\nLow deaths\nK/D|r")
        call BlzFrameSetText(WCS_DetailCardValues[3], "|cffffffff" + I2S(SaveSystem_GetHeroBestKills(viewer, heroId)) + "\n" + I2S(SaveSystem_GetHeroBestDeaths(viewer, heroId)) + "\n" + WCS_Decimal100(SaveSystem_GetHeroBestKd100(viewer, heroId)) + "|r")
    else
        call BlzFrameSetText(WCS_DetailCardLabels[2], "")
        call BlzFrameSetText(WCS_DetailCardValues[2], "")
        call BlzFrameSetText(WCS_DetailCardLabels[3], "")
        call BlzFrameSetText(WCS_DetailCardValues[3], "")
        call BlzFrameSetText(WCS_DetailCardLabels[2], WCS_MUTED + "No data yet|r")
        call BlzFrameSetText(WCS_DetailCardLabels[3], WCS_MUTED + "No data yet|r")
    endif
    call WCS_UpdateRelations(heroId, viewer)
    call BlzFrameSetVisible(WCS_LastItemsEmpty, SaveSystem_GetLastBuildItemId(viewer, heroId, 0) == 0)
    call BlzFrameSetVisible(WCS_BestItemsEmpty, SaveSystem_GetBestItemId(viewer, heroId, 1) == 0)
    loop
        exitwhen slot >= WCS_LAST_ITEM_COUNT
        call WCS_UpdateLastItem(slot, heroId, viewer)
        set slot = slot + 1
    endloop
    set slot = 0
    loop
        exitwhen slot >= WCS_BEST_ITEM_COUNT
        call WCS_UpdateBestItem(slot, heroId, viewer)
        set slot = slot + 1
    endloop
    set viewer = null
endfunction

private function WCS_UpdateForPlayer takes integer pid returns nothing
    if pid < 0 or pid >= WCS_PLAYER_COUNT or GetLocalPlayer() != Player(pid) then
        return
    endif
    if WCS_Page[pid] == 0 then
        call BlzFrameSetText(WCS_Title, "|cffffd36bWOS2 CAREER STATISTICS|r")
        call WCS_UpdateHome(pid)
    elseif WCS_Page[pid] == 1 then
        call WCS_UpdateHeroes(pid)
    else
        call WCS_UpdateDetail(pid)
    endif
endfunction

private function WCS_SetOpen takes player viewer, boolean open returns nothing
    local integer pid
    if viewer == null or GetLocalPlayer() != viewer then
        return
    endif
    set pid = GetPlayerId(viewer)
    if pid < 0 or pid >= WCS_PLAYER_COUNT then
        return
    endif
    set WCS_IsOpen[pid] = open
    if open then
        // Only this client's cumulative profile is read. The loader has no sync
        // native and never exposes its values to gameplay or other players.
        // Startup already loads this owner cache; opening only draws cached data.
        // Keep the last local page. Every frame mutation below is protected by
        // the direct GetLocalPlayer owner check above.
        call WCS_SetPage(pid, WCS_Page[pid])
        call WCS_UpdateForPlayer(pid)
        call BlzFrameSetVisible(WCS_Main, true)
    else
        call WCS_HideTooltips(pid)
        call BlzFrameSetVisible(WCS_Main, false)
    endif
endfunction

private function WCS_OnOpen takes nothing returns nothing
    local player viewer = GetTriggerPlayer()
    if GetLocalPlayer() != GetTriggerPlayer() then
        set viewer = null
        call WUI_ReleaseClickFocus()
        return
    endif
    call WCS_SetOpen(viewer, true)
    set viewer = null
    call WUI_ReleaseClickFocus()
endfunction

private function WCS_OnClose takes nothing returns nothing
    local player viewer = null
    if GetLocalPlayer() != GetTriggerPlayer() then
        call WUI_ReleaseClickFocus()
        return
    endif
    set viewer = GetTriggerPlayer()
    call WCS_SetOpen(viewer, false)
    set viewer = null
    call WUI_ReleaseClickFocus()
endfunction

private function WCS_OnHome takes nothing returns nothing
    local player viewer = null
    local integer pid = 0
    if GetLocalPlayer() != GetTriggerPlayer() then
        call WUI_ReleaseClickFocus()
        return
    endif
    set viewer = GetTriggerPlayer()
set pid = GetPlayerId(viewer)
    if pid >= 0 and pid < WCS_PLAYER_COUNT then
        call WCS_SetPage(pid, 0)
        call WCS_UpdateForPlayer(pid)
    endif
    set viewer = null
    call WUI_ReleaseClickFocus()
endfunction

private function WCS_OnHeroes takes nothing returns nothing
    local player viewer = null
    local integer pid = 0
    local integer heroId = 0
    local integer category
    if GetLocalPlayer() != GetTriggerPlayer() then
        call WUI_ReleaseClickFocus()
        return
    endif
    set viewer = GetTriggerPlayer()
set pid = GetPlayerId(viewer)
    if pid >= 0 and pid < WCS_PLAYER_COUNT then
        if Hero[pid] != null then
            set heroId = GetUnitTypeId(Hero[pid])
            set category = WCS_FindHeroCategory(heroId)
            if category > 0 then
                set WCS_Category[pid] = category
            else
                set WCS_Category[pid] = 6
            endif
        endif
        call WCS_SetPage(pid, 1)
        call WCS_UpdateForPlayer(pid)
    endif
    set viewer = null
    call WUI_ReleaseClickFocus()
endfunction

private function WCS_OnCategory takes nothing returns nothing
    local player viewer = null
    local integer pid 
    local framehandle clicked = null
    local integer category = 1
    if GetLocalPlayer() != GetTriggerPlayer() then
        call WUI_ReleaseClickFocus()
        return
    endif
    set clicked = BlzGetTriggerFrame()
        set viewer = GetTriggerPlayer()
       set pid = GetPlayerId(viewer)
    if pid >= 0 and pid < WCS_PLAYER_COUNT then
        loop
            exitwhen category > WCS_CATEGORY_COUNT
            if clicked == WCS_CategoryButton[category - 1] then
                set WCS_Category[pid] = category
                call WCS_SetPage(pid, 1)
                call WCS_UpdateForPlayer(pid)
                set category = WCS_CATEGORY_COUNT + 1
            else
                set category = category + 1
            endif
        endloop
    endif
    set clicked = null
    set viewer = null
    call WUI_ReleaseClickFocus()
endfunction

private function WCS_OnHero takes nothing returns nothing
    local player viewer = null
    local integer pid 
    local framehandle clicked = null
    local integer slot = 0
    if GetLocalPlayer() != GetTriggerPlayer() then
        call WUI_ReleaseClickFocus()
        return
    endif
        set clicked = BlzGetTriggerFrame()
        set viewer = GetTriggerPlayer()
       set pid = GetPlayerId(viewer)
    if pid >= 0 and pid < WCS_PLAYER_COUNT then
        loop
            exitwhen slot >= WCS_HERO_SLOT_COUNT
            if clicked == WCS_HeroButton[slot] and WCS_VisibleHeroId[slot] != 0 then
                set WCS_DetailHeroId[pid] = WCS_VisibleHeroId[slot]
                call WCS_SetPage(pid, 2)
                call WCS_UpdateForPlayer(pid)
                set slot = WCS_HERO_SLOT_COUNT
            else
                set slot = slot + 1
            endif
        endloop
    endif
    set clicked = null
    set viewer = null
    call WUI_ReleaseClickFocus()
endfunction

private function WCS_OnHotkey takes nothing returns nothing
    local player viewer = GetTriggerPlayer()
    local integer pid = GetPlayerId(viewer)
    // The key event itself is local; this handler changes UI state only.
    if GetLocalPlayer() != GetTriggerPlayer() then
        set viewer = null
        return
    endif
    if pid >= 0 and pid < WCS_PLAYER_COUNT then
        call WCS_SetOpen(viewer, not WCS_IsOpen[pid])
    endif
    set viewer = null
endfunction

private function WCS_CreateHomePage takes nothing returns nothing
    local integer slot = 0
    local real x
    local framehandle tooltipText
    // Rank line and progress bar (finished games).
    // Status bar: the whole rank ladder.
    set WCS_RankBack = WCS_CreateBackdrop(WCS_HomePage, 0.400, 0.398, WCS_RANK_BAR_WIDTH + 0.004, 0.016, 220, 8382)
    set WCS_RankFill = BlzCreateFrameByType("BACKDROP", "WcsRankFill", WCS_RankBack, "", 8383)
    call BlzFrameSetPoint(WCS_RankFill, FRAMEPOINT_LEFT, WCS_RankBack, FRAMEPOINT_LEFT, WCS_S(0.002), 0.0)
    call BlzFrameSetSize(WCS_RankFill, 0.001, WCS_S(0.012))
    call BlzFrameSetTexture(WCS_RankFill, WCS_TEX_RANK_FILL, 0, true)
    call BlzFrameSetEnable(WCS_RankFill, false)
    call WUI_GoldFrame("WcsRankEdge", WCS_RankBack, 0.0014, 0.0000)
    // Status text sits on the bar.
    set WCS_RankText = WCS_CreateText(WCS_HomePage, 0.400, 0.398, WCS_RANK_BAR_WIDTH, 0.014, 0.66, TEXT_JUSTIFY_CENTER, "", 8380)
    set WCS_RankNext = WCS_CreateText(WCS_HomePage, 0.400, 0.398, 0.010, 0.010, 0.50, TEXT_JUSTIFY_CENTER, "", 8381)
    call BlzFrameSetLevel(WCS_RankText, 5)
    call BlzFrameSetEnable(WCS_RankText, false)
    // Level bar: finished games out of the next rank threshold, text on the bar.
    set WCS_LevelBack = WCS_CreateBackdrop(WCS_HomePage, 0.400, 0.380, WCS_LEVEL_BAR_WIDTH + 0.004, 0.013, 220, 8387)
    set WCS_LevelFill = BlzCreateFrameByType("BACKDROP", "WcsLevelFill", WCS_LevelBack, "", 8388)
    call BlzFrameSetPoint(WCS_LevelFill, FRAMEPOINT_LEFT, WCS_LevelBack, FRAMEPOINT_LEFT, WCS_S(0.002), 0.0)
    call BlzFrameSetSize(WCS_LevelFill, 0.001, WCS_S(0.009))
    call BlzFrameSetTexture(WCS_LevelFill, WCS_TEX_RANK_FILL, 0, true)
    call BlzFrameSetEnable(WCS_LevelFill, false)
    call WUI_GoldFrame("WcsLevelEdge", WCS_LevelBack, 0.0012, 0.0000)
    set WCS_LevelText = WCS_CreateText(WCS_HomePage, 0.400, 0.380, WCS_LEVEL_BAR_WIDTH, 0.011, 0.58, TEXT_JUSTIFY_CENTER, "", 8386)
    call BlzFrameSetLevel(WCS_LevelText, 5)
    call BlzFrameSetEnable(WCS_LevelText, false)
    // Invisible hover sensor over both bars: ladder tooltip.
    set WCS_RankSensor = BlzCreateFrameByType("BUTTON", "WcsRankSensor", WCS_HomePage, "", 8384)
    call BlzFrameSetAbsPoint(WCS_RankSensor, FRAMEPOINT_CENTER, WCS_X(0.400), WCS_Y(0.389))
    call BlzFrameSetSize(WCS_RankSensor, WCS_S(WCS_RANK_BAR_WIDTH + 0.006), WCS_S(0.034))
    set WCS_RankTooltipText = WCS_CreateTooltip(WCS_RankSensor, 0.200, 0.098, 8385)
    set WCS_RankTooltip = WCS_LastCreatedTooltip
    call BlzFrameSetScale(WCS_RankTooltipText, 0.74)
    call BlzFrameSetTextAlignment(WCS_RankTooltipText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
    // Left card: whole career.
    call WCS_CreateCard(WCS_HomePage, 0.318, 0.313, 0.150, 0.100, "YOUR CAREER", 8300)
    set WCS_HomeSource = WCS_CreateText(WCS_HomePage, 0.318, 0.344, 0.140, 0.010, 0.48, TEXT_JUSTIFY_CENTER, "", 8304)
    set WCS_HomeOverallLabels = WCS_CreateText(WCS_HomePage, 0.318, 0.303, 0.126, 0.066, 0.70, TEXT_JUSTIFY_LEFT, "", 8305)
    set WCS_HomeOverall = WCS_CreateText(WCS_HomePage, 0.318, 0.303, 0.126, 0.066, 0.70, TEXT_JUSTIFY_RIGHT, "", 8310)
    // Right card: selected hero with its icon.
    call WCS_CreateCard(WCS_HomePage, 0.482, 0.313, 0.150, 0.100, "SELECTED HERO", 8306)
    set WCS_HomeHeroIconFrame = BlzCreateFrameByType("BACKDROP", "WcsHomeHeroIcon", WCS_HomePage, "", 8312)
    call BlzFrameSetAbsPoint(WCS_HomeHeroIconFrame, FRAMEPOINT_CENTER, WCS_X(0.427), WCS_Y(0.334))
    call BlzFrameSetSize(WCS_HomeHeroIconFrame, WCS_S(0.026), WCS_S(0.026))
    call BlzFrameSetTexture(WCS_HomeHeroIconFrame, WCS_TEX_EMPTY, 0, true)
    set tooltipText = WUI_IconFrame(WCS_HomeHeroIconFrame, WUI_ICON_FRAME)
    set WCS_HomeHeroName = WCS_CreateText(WCS_HomePage, 0.497, 0.334, 0.104, 0.020, 0.66, TEXT_JUSTIFY_LEFT, "", 8313)
    set WCS_HomeHeroLabels = WCS_CreateText(WCS_HomePage, 0.482, 0.293, 0.126, 0.044, 0.70, TEXT_JUSTIFY_LEFT, "", 8314)
    set WCS_HomeHeroValues = WCS_CreateText(WCS_HomePage, 0.482, 0.293, 0.126, 0.044, 0.70, TEXT_JUSTIFY_RIGHT, "", 8315)
    set WCS_HomeHero = WCS_CreateText(WCS_HomePage, 0.482, 0.303, 0.130, 0.060, 0.70, TEXT_JUSTIFY_CENTER, "", 8311)
    // Bottom strip: most played heroes.
    call WCS_CreateCard(WCS_HomePage, 0.400, 0.226, 0.314, 0.062, "MOST PLAYED", 8320)
    set WCS_HomeTopEmpty = WCS_CreateText(WCS_HomePage, 0.400, 0.219, 0.200, 0.012, 0.58, TEXT_JUSTIFY_CENTER, WCS_MUTED + "No matches recorded yet|r", 8324)
    loop
        exitwhen slot >= WCS_TOP_HERO_COUNT
        set x = 0.290 + I2R(slot)*0.044
        set WCS_TopHeroButton[slot] = WCS_CreateIconButton(WCS_HomePage, x, 0.222, 0.024, 8330 + slot)
        set WCS_TopHeroIcon[slot] = WCS_CreateIcon(WCS_TopHeroButton[slot], WCS_TEX_EMPTY, 8340 + slot)
        set tooltipText = WUI_IconFrame(WCS_TopHeroButton[slot], WUI_ICON_FRAME)
        set WCS_TopHeroText[slot] = WCS_CreateText(WCS_HomePage, x, 0.201, 0.042, 0.010, 0.46, TEXT_JUSTIFY_CENTER, "", 8350 + slot)
        set WCS_TopHeroTooltipText[slot] = WCS_CreateTooltip(WCS_TopHeroButton[slot], 0.120, 0.038, 8360 + slot)
        set WCS_TopHeroTooltip[slot] = WCS_LastCreatedTooltip
        call BlzFrameSetVisible(WCS_TopHeroButton[slot], false)
        set slot = slot + 1
    endloop
    set tooltipText = null
endfunction

private function WCS_CreateHeroesPage takes nothing returns nothing
    local integer category = 0
    local integer slot = 0
    local integer row
    local integer column
    local real x
    local real y
    local framehandle tooltipText
    loop
        exitwhen category >= WCS_CATEGORY_COUNT
        set x = 0.264
        set y = 0.390 - I2R(category)*0.036
        set WCS_CategoryButton[category] = WCS_CreateIconButton(WCS_HeroesPage, x, y, 0.025, 8400 + category)
        // 4:1 franchise plates (same art as the hero pick).
        call BlzFrameSetSize(WCS_CategoryButton[category], WCS_S(0.064), WCS_S(0.016))
        set WCS_CategoryIcon[category] = WCS_CreateIcon(WCS_CategoryButton[category], WCS_CategoryTexture(category + 1), 8410 + category)
        // No hover tooltip: the logo already names the franchise (the box covered the next logo).
        set WCS_CategoryTooltip[category] = null
        call BlzTriggerRegisterFrameEvent(WCS_CategoryTrigger, WCS_CategoryButton[category], FRAMEEVENT_CONTROL_CLICK)
        set category = category + 1
    endloop
    loop
        exitwhen slot >= WCS_HERO_SLOT_COUNT
        set row = slot/WCS_HERO_COLUMN_COUNT
        set column = ModuloInteger(slot, WCS_HERO_COLUMN_COUNT)
        set x = 0.306 + I2R(column)*0.047
        set y = 0.390 - I2R(row)*0.043
        set WCS_HeroButton[slot] = WCS_CreateIconButton(WCS_HeroesPage, x, y + 0.004, 0.028, 9100 + slot)
        set WCS_HeroIcon[slot] = WCS_CreateIcon(WCS_HeroButton[slot], WCS_TEX_EMPTY, 9200 + slot)
        set tooltipText = WUI_IconFrame(WCS_HeroButton[slot], WUI_ICON_FRAME)
        set WCS_HeroName[slot] = WCS_CreateText(WCS_HeroesPage, x, y - 0.016, 0.045, 0.011, 0.56, TEXT_JUSTIFY_CENTER, "", 9300 + slot)
        // Short career line over the bottom of the icon: games / win rate.
        set WCS_HeroStatBack[slot] = BlzCreateFrameByType("BACKDROP", "WcsHeroStatBack", WCS_HeroButton[slot], "", 9500 + slot)
        call BlzFrameSetPoint(WCS_HeroStatBack[slot], FRAMEPOINT_BOTTOMLEFT, WCS_HeroButton[slot], FRAMEPOINT_BOTTOMLEFT, WCS_S(0.0020), WCS_S(0.0020))
        call BlzFrameSetPoint(WCS_HeroStatBack[slot], FRAMEPOINT_TOPRIGHT, WCS_HeroButton[slot], FRAMEPOINT_BOTTOMRIGHT, -WCS_S(0.0020), WCS_S(0.0110))
        call BlzFrameSetTexture(WCS_HeroStatBack[slot], WCS_TEX_BLACK, 0, true)
        call BlzFrameSetAlpha(WCS_HeroStatBack[slot], 200)
        call BlzFrameSetEnable(WCS_HeroStatBack[slot], false)
        set WCS_HeroStat[slot] = BlzCreateFrameByType("TEXT", "WcsHeroStat", WCS_HeroStatBack[slot], "", 9600 + slot)
        call BlzFrameSetAllPoints(WCS_HeroStat[slot], WCS_HeroStatBack[slot])
        call BlzFrameSetScale(WCS_HeroStat[slot], 0.62)
        call BlzFrameSetTextAlignment(WCS_HeroStat[slot], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetEnable(WCS_HeroStat[slot], false)
        call BlzFrameSetVisible(WCS_HeroStatBack[slot], false)
        set WCS_HeroTooltipText[slot] = WCS_CreateTooltip(WCS_HeroButton[slot], 0.160, 0.055, 9400 + slot)
        set WCS_HeroTooltip[slot] = WCS_LastCreatedTooltip
        // Hidden until a category fills the slot (no placeholder icons on first open).
        call BlzFrameSetVisible(WCS_HeroButton[slot], false)
        call BlzFrameSetVisible(WCS_HeroName[slot], false)
        call BlzTriggerRegisterFrameEvent(WCS_HeroTrigger, WCS_HeroButton[slot], FRAMEEVENT_CONTROL_CLICK)
        set slot = slot + 1
    endloop
    set tooltipText = null
endfunction

private function WCS_CreateDetailPage takes nothing returns nothing
    local integer relationType = 0
    local integer slot = 0
    local integer index
    local integer card = 0
    local real x
    local real y
    local framehandle tooltipText
    // Header: icon, name, one-line summary.
    set WCS_DetailHeroIcon = BlzCreateFrameByType("BACKDROP", "WcsDetailHeroIcon", WCS_DetailPage, "", 8710)
    call BlzFrameSetAbsPoint(WCS_DetailHeroIcon, FRAMEPOINT_CENTER, WCS_X(0.256), WCS_Y(0.392))
    call BlzFrameSetSize(WCS_DetailHeroIcon, WCS_S(0.032), WCS_S(0.032))
    set tooltipText = WUI_IconFrame(WCS_DetailHeroIcon, WUI_ICON_FRAME)
    set WCS_DetailHeroName = WCS_CreateText(WCS_DetailPage, 0.364, 0.399, 0.170, 0.018, 0.90, TEXT_JUSTIFY_LEFT, "", 8711)
    set WCS_DetailSubtitle = WCS_CreateText(WCS_DetailPage, 0.364, 0.384, 0.170, 0.010, 0.52, TEXT_JUSTIFY_LEFT, "", 8712)
    // Three stat cards across the old four-card span (ROUNDS removed; indices 0/2/3 kept).
    loop
        exitwhen card >= 4
        if card != 1 then
            set x = 0.29158 + I2R(IMaxBJ(card - 1, 0))*0.10867
            if card == 0 then
                call WCS_CreateCard(WCS_DetailPage, x, 0.336, 0.10417, 0.060, "MATCHES", 8700 + card*4)
            elseif card == 2 then
                call WCS_CreateCard(WCS_DetailPage, x, 0.336, 0.10417, 0.060, "AVERAGES", 8700 + card*4)
            else
                call WCS_CreateCard(WCS_DetailPage, x, 0.336, 0.10417, 0.060, "BEST", 8700 + card*4)
            endif
            set WCS_DetailCardLabels[card] = WCS_CreateText(WCS_DetailPage, x, 0.327, 0.092, 0.036, 0.52, TEXT_JUSTIFY_LEFT, "", 8720 + card)
            set WCS_DetailCardValues[card] = WCS_CreateText(WCS_DetailPage, x, 0.327, 0.092, 0.036, 0.52, TEXT_JUSTIFY_RIGHT, "", 8724 + card)
        endif
        set card = card + 1
    endloop
    // Kept for the old text paths (unused text, hidden).
    set WCS_DetailPersonal = WCS_DetailCardValues[0]
    set WCS_DetailAverage = WCS_DetailCardValues[2]
    set WCS_DetailBest = WCS_DetailCardValues[3]
    // Relations: four groups in a row under the cards.
    loop
        exitwhen relationType >= WCS_RELATION_ROW_COUNT
        set x = 0.278 + I2R(relationType)*0.0815
        call WCS_CreateCard(WCS_DetailPage, x, 0.276, 0.077, 0.044, WCS_RelationName(relationType), 8730 + relationType*4)
        set WCS_RelationTitle[relationType] = null
        set WCS_RelationEmpty[relationType] = WCS_CreateText(WCS_DetailPage, x, 0.270, 0.070, 0.010, 0.46, TEXT_JUSTIFY_CENTER, WCS_MUTED + "No data yet|r", 8790 + relationType)
        set slot = 0
        loop
            exitwhen slot >= WCS_RELATION_SLOT_COUNT
            set index = relationType*WCS_RELATION_SLOT_COUNT + slot
            set WCS_RelationButton[index] = WCS_CreateIconButton(WCS_DetailPage, x + I2R(slot - 2)*0.0142, 0.270, 0.0128, 8740 + index)
            set WCS_RelationText[index] = WCS_CreateText(WCS_DetailPage, x + I2R(slot - 2)*0.0142, 0.258, 0.0150, 0.007, 0.34, TEXT_JUSTIFY_CENTER, "", 8840 + index)
            set WCS_RelationIcon[index] = WCS_CreateIcon(WCS_RelationButton[index], WCS_TEX_EMPTY, 8770 + index)
            set tooltipText = WCS_CreateTooltip(WCS_RelationButton[index], 0.120, 0.034, 8800 + index)
            set WCS_RelationTooltipText[index] = tooltipText
            set WCS_RelationTooltip[index] = WCS_LastCreatedTooltip
            call BlzFrameSetScale(tooltipText, 0.70)
            call BlzFrameSetVisible(WCS_RelationButton[index], false)
            set slot = slot + 1
        endloop
        set relationType = relationType + 1
    endloop
    // Items: last match build (left) and best win rate (right).
    call WCS_CreateCard(WCS_DetailPage, 0.318, 0.218, 0.155, 0.060, "LAST MATCH BUILD", 8900)
    call WCS_CreateCard(WCS_DetailPage, 0.482, 0.218, 0.155, 0.060, "BEST WIN RATE", 8950)
    set WCS_DetailLastTitle = null
    set WCS_DetailBestItemsTitle = null
    set WCS_LastItemsEmpty = WCS_CreateText(WCS_DetailPage, 0.318, 0.212, 0.140, 0.010, 0.50, TEXT_JUSTIFY_CENTER, WCS_MUTED + "No data yet|r", 8904)
    set WCS_BestItemsEmpty = WCS_CreateText(WCS_DetailPage, 0.482, 0.212, 0.140, 0.010, 0.50, TEXT_JUSTIFY_CENTER, WCS_MUTED + "No data yet|r", 8954)
    set slot = 0
    loop
        exitwhen slot >= WCS_LAST_ITEM_COUNT
        set x = 0.318 + (I2R(slot) - 2.5)*0.0235
        set WCS_LastItemButton[slot] = WCS_CreateIconButton(WCS_DetailPage, x, 0.216, 0.0195, 8910 + slot)
        set WCS_LastItemIcon[slot] = WCS_CreateIcon(WCS_LastItemButton[slot], WCS_TEX_EMPTY, 8920 + slot)
        set WCS_LastItemText[slot] = WCS_CreateText(WCS_DetailPage, x, 0.198, 0.032, 0.008, 0.40, TEXT_JUSTIFY_CENTER, "", 8930 + slot)
        set tooltipText = WCS_CreateTooltip(WCS_LastItemButton[slot], 0.140, 0.040, 8940 + slot)
        set WCS_LastItemTooltipText[slot] = tooltipText
        set WCS_LastItemTooltip[slot] = WCS_LastCreatedTooltip
        call BlzFrameSetScale(tooltipText, 0.70)
        call BlzFrameSetVisible(WCS_LastItemButton[slot], false)
        set slot = slot + 1
    endloop
    set slot = 0
    loop
        exitwhen slot >= WCS_BEST_ITEM_COUNT
        set x = 0.482 + (I2R(slot) - 2.5)*0.0235
        set WCS_BestItemButton[slot] = WCS_CreateIconButton(WCS_DetailPage, x, 0.216, 0.0195, 8960 + slot)
        set WCS_BestItemIcon[slot] = WCS_CreateIcon(WCS_BestItemButton[slot], WCS_TEX_EMPTY, 8980 + slot)
        set WCS_BestItemText[slot] = WCS_CreateText(WCS_DetailPage, x, 0.198, 0.032, 0.008, 0.40, TEXT_JUSTIFY_CENTER, "", 9000 + slot)
        set tooltipText = WCS_CreateTooltip(WCS_BestItemButton[slot], 0.140, 0.040, 9020 + slot)
        set WCS_BestItemTooltipText[slot] = tooltipText
        set WCS_BestItemTooltip[slot] = WCS_LastCreatedTooltip
        call BlzFrameSetScale(tooltipText, 0.70)
        call BlzFrameSetVisible(WCS_BestItemButton[slot], false)
        set slot = slot + 1
    endloop
    set tooltipText = null
endfunction

private function WCS_CreateUI takes nothing returns nothing
    local framehandle gameUI = WUI_GetRoot()
    local integer pid = 0
    set WCS_OpenButton = WCS_CreateIconButton(gameUI, WUI_TopActionX(2), 0.584, WCS_OPEN_SIZE, 8200)
    // Top-bar position is screen space, not the zoomed career window space.
    call WUI_PlaceRight(WCS_OpenButton, 0.090, 0.584, WCS_OPEN_SIZE, WCS_OPEN_SIZE)
    call WUI_RegisterTopControl(WCS_OpenButton)

    set WCS_OpenIcon = WCS_CreateIcon(WCS_OpenButton, WCS_TEX_OPEN, 8201)
    call BlzFrameSetVisible(WCS_OpenButton, false)
    call BlzFrameSetLevel(WCS_OpenButton, 100)
    call BlzFrameSetLevel(WCS_OpenIcon, 101)

    set WCS_Main = WUI_Window("WOSCareerWindow", gameUI, 0, 8210)
    call WUI_RegisterWindowPart(10, WCS_Main)
    call WUI_RegisterRangeCover(WCS_Main)
    call BlzFrameSetAbsPoint(WCS_Main, FRAMEPOINT_CENTER, WCS_PANEL_X, WCS_PANEL_Y)
    call BlzFrameSetSize(WCS_Main, WCS_PANEL_WIDTH, WCS_PANEL_HEIGHT)
    set WCS_CloseIcon = WUI_OrnateWindow("WOSCareerMetal", WCS_Main, 0.024)
    // КРИТИЧНО: панель изначально всегда скрыта.
call BlzFrameSetVisible(WCS_Main, false)
    set WCS_Title = WCS_CreateText(WCS_Main, 0.470, 0.432, 0.170, 0.018, 0.76, TEXT_JUSTIFY_CENTER, "|cffffd36bWOS2 CAREER STATISTICS|r", 8211)

    // Shop-style close button: graphite fill, gold X, gold hairline.
    set WCS_CloseButton = BlzCreateFrameByType("BUTTON", "WcsCloseButton", WCS_Main, "", 8212)
    call WUI_Place(WCS_CloseButton, WCS_PANEL_X + WCS_PANEL_WIDTH * 0.5 - 0.016, WCS_PANEL_Y + WCS_PANEL_HEIGHT * 0.5 - 0.016, 0.016, 0.016)
    set WCS_CloseIcon = WCS_CreateIcon(WCS_CloseButton, WUI_FILL_NORMAL, 8213)
    set WCS_CloseIcon = BlzCreateFrameByType("BACKDROP", "WcsCloseGlyph", WCS_CloseButton, "", 8215)
    call BlzFrameSetPoint(WCS_CloseIcon, FRAMEPOINT_TOPLEFT, WCS_CloseButton, FRAMEPOINT_TOPLEFT, 0.003, -0.003)
    call BlzFrameSetPoint(WCS_CloseIcon, FRAMEPOINT_BOTTOMRIGHT, WCS_CloseButton, FRAMEPOINT_BOTTOMRIGHT, -0.003, 0.003)
    call BlzFrameSetTexture(WCS_CloseIcon, "UI\\WOS\\glyph-close.tga", 0, true)
    call BlzFrameSetEnable(WCS_CloseIcon, false)
    call WUI_GoldFrame("WcsCloseEdge", WCS_CloseButton, 0.0026, 0.0000)
    set WCS_HomeButton = WCS_CreateTextButton(WCS_Main, 0.258, 0.430, 0.064, 0.024, "HOME", 8214)
    set WCS_HeroesButton = WCS_CreateTextButton(WCS_Main, 0.334, 0.430, 0.078, 0.024, "HEROES", 8216)
    set WCS_HomePage = BlzCreateFrameByType("FRAME", "WcsHomePage", WCS_Main, "", 8230)
    set WCS_HeroesPage = BlzCreateFrameByType("FRAME", "WcsHeroesPage", WCS_Main, "", 8231)
    set WCS_DetailPage = BlzCreateFrameByType("FRAME", "WcsDetailPage", WCS_Main, "", 8232)
    call BlzFrameSetAllPoints(WCS_HomePage, WCS_Main)
    call BlzFrameSetAllPoints(WCS_HeroesPage, WCS_Main)
    call BlzFrameSetAllPoints(WCS_DetailPage, WCS_Main)
    call BlzFrameSetLevel(WCS_HomePage, 1)
    call BlzFrameSetLevel(WCS_HeroesPage, 1)
    call BlzFrameSetLevel(WCS_DetailPage, 1)

    // Navigation is deliberately above every page container so pages cannot
    // intercept HOME, HEROES, or CLOSE mouse events.
    call BlzFrameSetLevel(WCS_Title, 90)
    call BlzFrameSetLevel(WCS_HomeButton, 100)
    call BlzFrameSetLevel(WCS_HeroesButton, 100)
    call BlzFrameSetLevel(WCS_CloseButton, 100)
    call BlzFrameSetLevel(WCS_CloseIcon, 101)

    set WCS_OpenTrigger = CreateTrigger()
    set WCS_CloseTrigger = CreateTrigger()
    set WCS_HomeTrigger = CreateTrigger()
    set WCS_HeroesTrigger = CreateTrigger()
    set WCS_CategoryTrigger = CreateTrigger()
    set WCS_HeroTrigger = CreateTrigger()
    set WCS_HotkeyTrigger = CreateTrigger()
    call BlzTriggerRegisterFrameEvent(WCS_OpenTrigger, WCS_OpenButton, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(WCS_CloseTrigger, WCS_CloseButton, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(WCS_HomeTrigger, WCS_HomeButton, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(WCS_HeroesTrigger, WCS_HeroesButton, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(WCS_OpenTrigger, function WCS_OnOpen)
    call TriggerAddAction(WCS_CloseTrigger, function WCS_OnClose)
    call TriggerAddAction(WCS_HomeTrigger, function WCS_OnHome)
    call TriggerAddAction(WCS_HeroesTrigger, function WCS_OnHeroes)
    call TriggerAddAction(WCS_CategoryTrigger, function WCS_OnCategory)
    call TriggerAddAction(WCS_HeroTrigger, function WCS_OnHero)
    call TriggerAddAction(WCS_HotkeyTrigger, function WCS_OnHotkey)

    call WCS_CreateHomePage()
    call WCS_CreateHeroesPage()
    call WCS_CreateDetailPage()
    loop
        exitwhen pid >= WCS_PLAYER_COUNT
        call BlzTriggerRegisterPlayerKeyEvent(WCS_HotkeyTrigger, Player(pid), OSKEY_F5, 0, false)
        set WCS_Page[pid] = 0
        set WCS_Category[pid] = 1
        set WCS_DetailHeroId[pid] = 0
        set WCS_IsOpen[pid] = false
        set pid = pid + 1
    endloop
    // Initial visibility is also applied per client without storing
    // GetLocalPlayer() in any variable.
    set pid = 0
    loop
        exitwhen pid >= WCS_PLAYER_COUNT
        if GetLocalPlayer() == Player(pid) then
            if GetPlayerId(GetLocalPlayer()) < WCS_PLAYER_COUNT then
    call BlzFrameSetVisible(WCS_OpenButton, true)
else

    call BlzFrameSetVisible(WCS_OpenButton, false)
    call BlzFrameSetVisible(WCS_Main, false)
endif
        endif
        set pid = pid + 1
    endloop
    set gameUI = null
endfunction

private function WCS_StartUI takes nothing returns nothing
    call WCS_CreateUI()
    // MyHeroIdInit fills all pages atomically from the map's 1-second trigger.
    // Retry until at least one real ID exists and no pick/ban has written 12.
    set WCS_CatalogTimer = CreateTimer()
    call TimerStart(WCS_CatalogTimer, 0.10, true, function WCS_CatalogTick)
endfunction

private function WCS_Init takes nothing returns nothing
    call WUI_OnReady(function WCS_StartUI)
endfunction

endlibrary
