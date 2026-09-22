//===========================================================================
// WOS2 Career Statistics
//===========================================================================
library WosCareerStats initializer WCS_Init requires AAINIT, heroicon

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
    private constant real WCS_PANEL_WIDTH = 0.350
    private constant real WCS_PANEL_HEIGHT = 0.265
    private constant real WCS_OPEN_X = 0.825
    private constant real WCS_OPEN_Y = 0.560
    private constant real WCS_OPEN_SIZE = 0.022

    private constant string WCS_TEX_BLACK = "Textures\\black32.blp"
    private constant string WCS_TEX_CLOSE = "Music\\Music_Close.blp"
    private constant string WCS_TEX_EMPTY = "Pick\\wos_stat"
    private constant string WCS_TEX_OPEN = "Pick\\wos_stat"

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

    private framehandle array WCS_CategoryButton
    private framehandle array WCS_CategoryIcon
    private framehandle array WCS_CategoryTooltip
    private framehandle array WCS_HeroButton
    private framehandle array WCS_HeroIcon
    private framehandle array WCS_HeroName
    private framehandle array WCS_HeroTooltip
    private framehandle array WCS_HeroTooltipText
    private integer array WCS_VisibleHeroId

    private framehandle WCS_DetailHeroIcon = null
    private framehandle WCS_DetailHeroName = null
    private framehandle WCS_DetailPersonal = null
    private framehandle WCS_DetailRounds = null 
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

    private boolean array WCS_IsOpen
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
        return "Pick\\Pick_Gacha.blp"
    elseif category == 2 then
        return "Pick\\Pick_Bleach.blp"
    elseif category == 3 then
        return "Pick\\Pick_FairyTail.blp"
    elseif category == 4 then
        return "Pick\\Pick_OnePiece.blp"
    elseif category == 5 then
        return "Pick\\Pick_JujutsuKaisen.blp"
    endif
    return "Pick\\Pick_Other.blp"
endfunction

private function WCS_Percent takes integer wins, integer games returns string
    if games <= 0 then
        return "N/A"
    endif
    return I2S(wins*100/games) + "%"
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
    call BlzFrameSetAbsPoint(result, FRAMEPOINT_CENTER, x, y)
    call BlzFrameSetSize(result, width, height)
    call BlzFrameSetTextAlignment(result, TEXT_JUSTIFY_MIDDLE, horizontal)
    call BlzFrameSetScale(result, scale)
    call BlzFrameSetText(result, value)
    return result
endfunction

private function WCS_CreateBackdrop takes framehandle parent, real x, real y, real width, real height, integer alpha, integer context returns framehandle
    local framehandle result = BlzCreateFrameByType("BACKDROP", "WcsBackdrop", parent, "", context)
    call BlzFrameSetAbsPoint(result, FRAMEPOINT_CENTER, x, y)
    call BlzFrameSetSize(result, width, height)
    call BlzFrameSetTexture(result, WCS_TEX_BLACK, 0, true)
    call BlzFrameSetAlpha(result, alpha)
    return result
endfunction

private function WCS_CreateIconButton takes framehandle parent, real x, real y, real size, integer context returns framehandle
    local framehandle result = BlzCreateFrameByType("BUTTON", "WcsIconButton", parent, "ScoreScreenTabButtonTemplate", context)
    call BlzFrameSetAbsPoint(result, FRAMEPOINT_CENTER, x, y)
    call BlzFrameSetSize(result, size, size)
    return result
endfunction

private function WCS_CreateIcon takes framehandle buttonFrame, string texture, integer context returns framehandle
    local framehandle result = BlzCreateFrameByType("BACKDROP", "WcsIcon", buttonFrame, "", context)
    call BlzFrameSetAllPoints(result, buttonFrame)
    call BlzFrameSetTexture(result, texture, 0, true)
    return result
endfunction

private function WCS_CreateTextButton takes framehandle parent, real x, real y, real width, real height, string value, integer context returns framehandle
    local framehandle buttonFrame = BlzCreateFrame("ScriptDialogButton", parent, 0, context)
    call BlzFrameSetAbsPoint(buttonFrame, FRAMEPOINT_CENTER, x, y)
    call BlzFrameSetSize(buttonFrame, width, height)
    call BlzFrameSetText(buttonFrame, value)
    call BlzFrameSetScale(buttonFrame, 0.80)
    return buttonFrame
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
            set WCS_CatalogHeroId[(category - 1)*WCS_HERO_SLOT_COUNT + slot] = WCS_GetLiveHeroId(category, slot)
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
    local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "WcsTooltip", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", context)
    local framehandle label = BlzCreateFrameByType("TEXT", "WcsTooltipText", tooltip, "", context)
    call BlzFrameSetPoint(tooltip, FRAMEPOINT_BOTTOM, owner, FRAMEPOINT_TOP, 0.0, 0.002)
    call BlzFrameSetSize(tooltip, width, height)
    call BlzFrameSetTexture(tooltip, WCS_TEX_BLACK, 0, true)
    call BlzFrameSetAlpha(tooltip, 225)
    call BlzFrameSetLevel(tooltip, 90)
    call BlzFrameSetAllPoints(label, tooltip)
    call BlzFrameSetTextAlignment(label, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(label, 0.85)
    call BlzFrameSetText(label, "")
    call BlzFrameSetVisible(tooltip, false)
    call BlzFrameSetTooltip(owner, tooltip)
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

private function WCS_UpdateHome takes integer pid returns nothing
    local player viewer =null
    local integer games = SaveSystem_GetGamesPlayed(viewer)
    local integer wins = SaveSystem_GetGamesWon(viewer)
    local integer heroId = 0
    local integer heroGames
    local integer heroWins
    if pid < 0 or pid >= WCS_PLAYER_COUNT or GetLocalPlayer() != Player(pid) then
        return
    endif
   set viewer = Player(pid)
    if Hero[pid] != null then
        set heroId = GetUnitTypeId(Hero[pid])
    endif
    call BlzFrameSetText(WCS_HomeOverall, "|cffffd36bYOUR CAREER|r\n\nGames  |cffffffff" + I2S(games) + "|r\nWins  |cff76d7a8" + I2S(wins) + "|r\nLosses  |cffff7777" + I2S(games - wins) + "|r\nWin rate  |cffffffff" + WCS_Percent(wins, games) + "|r")
    if heroId == 0 then
        call BlzFrameSetText(WCS_HomeHero, "|cffffd36bSELECTED HERO|r\n|cff9aa7b4No hero selected yet.|r")
    else
        set heroGames = SaveSystem_GetHeroGames(viewer, heroId)
        set heroWins = SaveSystem_GetHeroWins(viewer, heroId)
        call BlzFrameSetText(WCS_HomeHero, "|cffffd36bSELECTED HERO|r\n\n|cffffffff" + GetObjectName(heroId) + "|r\nGames  " + I2S(heroGames) + "\nWins  " + I2S(heroWins) + "\nLosses  " + I2S(heroGames - heroWins) + "\nWin rate  |cffffffff" + WCS_Percent(heroWins, heroGames) + "|r")
    endif
    set viewer = null
endfunction

private function WCS_UpdateHeroes takes integer pid returns nothing
    local player viewer = null
    local integer slot = 0
    local integer heroId
    local integer currentHeroId = 0
    local integer extraRank = 1
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
            else
                set heroId = WCS_GetExtraHeroId(viewer, extraRank, currentHeroId)
                set extraRank = extraRank + 1
            endif
        endif
        set WCS_VisibleHeroId[slot] = heroId
        if heroId == 0 then
            call BlzFrameSetVisible(WCS_HeroButton[slot], false)
            call BlzFrameSetVisible(WCS_HeroName[slot], false)
            call BlzFrameSetText(WCS_HeroName[slot], "")
            call BlzFrameSetText(WCS_HeroTooltipText[slot], "")
        else
            set games = SaveSystem_GetHeroGames(viewer, heroId)
            set wins = SaveSystem_GetHeroWins(viewer, heroId)
            call BlzFrameSetVisible(WCS_HeroButton[slot], true)
            call BlzFrameSetVisible(WCS_HeroName[slot], true)
            call BlzFrameSetTexture(WCS_HeroIcon[slot], BlzGetAbilityIcon(heroId), 0, false)
            call BlzFrameSetText(WCS_HeroName[slot], GetObjectName(heroId))
            call BlzFrameSetText(WCS_HeroTooltipText[slot], "|cffffd36b" + GetObjectName(heroId) + "|r\nGames: " + I2S(games) + "   Wins: " + I2S(wins) + "\nWin rate: " + WCS_Percent(wins, games) + "\n|cff9aa7b4Click for details.|r")
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
        call BlzFrameSetText(WCS_LastItemText[slot], "|cff777777- |r")
        return
    endif
    set finalGames = SaveSystem_GetItemFinalGames(viewer, heroId, itemId)
    set finalWins = SaveSystem_GetItemFinalWins(viewer, heroId, itemId)
    set usedGames = SaveSystem_GetItemUsedGames(viewer, heroId, itemId)
    set usedWins = SaveSystem_GetItemUsedWins(viewer, heroId, itemId)
    call BlzFrameSetVisible(WCS_LastItemButton[slot], true)
    call BlzFrameSetTexture(WCS_LastItemIcon[slot], BlzGetAbilityIcon(itemId), 0, false)
    call BlzFrameSetText(WCS_LastItemText[slot], I2S(slot + 1))
    set tooltipText = "|cffffd36b" + GetObjectName(itemId) + "|r\nLast match slot " + I2S(slot + 1) + "\nFinal build: " + I2S(finalWins) + "/" + I2S(finalGames) + " (" + WCS_Percent(finalWins, finalGames) + ")\nUsed: " + I2S(usedWins) + "/" + I2S(usedGames) + " (" + WCS_Percent(usedWins, usedGames) + ")\n\n" + WCS_ItemDescription(itemId)
    call BlzFrameSetSize(WCS_LastItemTooltip[slot], 0.205, WCS_ItemTooltipHeight(tooltipText))
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
    call BlzFrameSetText(WCS_BestItemText[slot], WCS_Percent(finalWins, finalGames) + "\n" + I2S(finalGames) + "g")
    set tooltipText = "|cffffd36b" + GetObjectName(itemId) + "|r\nWin rate: " + WCS_Percent(finalWins, finalGames) + "\nFinal build: " + I2S(finalWins) + "/" + I2S(finalGames) + "\nPopularity: " + I2S(usedGames) + " games\nUsed wins: " + I2S(usedWins) + "/" + I2S(usedGames) + " (" + WCS_Percent(usedWins, usedGames) + ")\n\n" + WCS_ItemDescription(itemId)
    call BlzFrameSetSize(WCS_BestItemTooltip[slot], 0.205, WCS_ItemTooltipHeight(tooltipText))
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
        set slot = 0
        loop
            exitwhen slot >= WCS_RELATION_SLOT_COUNT
            set index = relationType*WCS_RELATION_SLOT_COUNT + slot
            set otherHeroId = SaveSystem_GetBestRelationHeroId(viewer, heroId, relationType, slot + 1)
            if otherHeroId == 0 then
                call BlzFrameSetVisible(WCS_RelationButton[index], false)
                call BlzFrameSetText(WCS_RelationTooltipText[index], "")
            else
                set games = SaveSystem_GetRelationGames(viewer, heroId, otherHeroId, relationType)
                set wins = SaveSystem_GetRelationWins(viewer, heroId, otherHeroId, relationType)
                call BlzFrameSetVisible(WCS_RelationButton[index], true)
                call BlzFrameSetTexture(WCS_RelationIcon[index], BlzGetAbilityIcon(otherHeroId), 0, false)
                call BlzFrameSetText(WCS_RelationTooltipText[index], "|cffffd36b" + GetObjectName(otherHeroId) + "|r\n" + WCS_RelationName(relationType) + "\nGames: " + I2S(games) + "   Wins: " + I2S(wins) + "   Losses: " + I2S(games - wins))
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
    local integer roundWins = SaveSystem_GetHeroRoundWins(viewer, heroId)
    local integer roundLosses = SaveSystem_GetHeroRoundLosses(viewer, heroId)
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
    call BlzFrameSetText(WCS_DetailPersonal, "|cffffd36bMATCHES|r\n\n|cffffffffGames  " + I2S(games) + "\nWins  " + I2S(wins) + "\nLosses  " + I2S(games - wins) + "|r\n|cffffd36b" + WCS_Percent(wins, games) + "|r")
    call BlzFrameSetText(WCS_DetailRounds, "|cffffd36bROUNDS|r\n\n|cffffffffWon  " + I2S(roundWins) + "\nLost  " + I2S(roundLosses) + "|r\n|cffffd36b" + WCS_Percent(roundWins, roundWins + roundLosses) + "|r")
    if combatGames > 0 then
        call BlzFrameSetText(WCS_DetailAverage, "|cffffd36bAVERAGES|r\n\n|cffffffffKills  " + WCS_Decimal100(averageKills) + "\nDeaths  " + WCS_Decimal100(averageDeaths) + "\nGames  " + I2S(combatGames) + "|r")
        call BlzFrameSetText(WCS_DetailBest, "|cffffd36bBEST|r\n\n|cffffffffKills  " + I2S(SaveSystem_GetHeroBestKills(viewer, heroId)) + "\nLow D.  " + I2S(SaveSystem_GetHeroBestDeaths(viewer, heroId)) + "\nK/D  " + WCS_Decimal100(SaveSystem_GetHeroBestKd100(viewer, heroId)) + "|r")
    else
        call BlzFrameSetText(WCS_DetailAverage, "|cffffd36bAVERAGES|r\n\n|cff9aa7b4No data|r")
        call BlzFrameSetText(WCS_DetailBest, "|cffffd36bBEST|r\n\n|cff9aa7b4No data|r")
    endif
    call WCS_UpdateRelations(heroId, viewer)
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
        call SaveSystem_LoadLocalPlayer(pid)
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

private function WCS_ResetClickedFrame takes nothing returns nothing
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetEnable(BlzGetTriggerFrame(), false)
        call BlzFrameSetEnable(BlzGetTriggerFrame(), true)
    endif
endfunction

private function WCS_OnOpen takes nothing returns nothing
    local player viewer = GetTriggerPlayer()
    if GetLocalPlayer() != GetTriggerPlayer() then
        set viewer = null
        return
    endif
    call WCS_ResetClickedFrame()
    call WCS_SetOpen(viewer, true)
    set viewer = null
endfunction

private function WCS_OnClose takes nothing returns nothing
    local player viewer = null
    if GetLocalPlayer() != GetTriggerPlayer() then
        return
    endif
    set viewer = GetTriggerPlayer()
    call WCS_ResetClickedFrame()
    call WCS_SetOpen(viewer, false)
    set viewer = null
endfunction

private function WCS_OnHome takes nothing returns nothing
    local player viewer = null
    local integer pid = 0
    if GetLocalPlayer() != GetTriggerPlayer() then
        return
    endif
    set viewer = GetTriggerPlayer()
set pid = GetPlayerId(viewer)
    call WCS_ResetClickedFrame()
    if pid >= 0 and pid < WCS_PLAYER_COUNT then
        call WCS_SetPage(pid, 0)
        call WCS_UpdateForPlayer(pid)
    endif
    set viewer = null
endfunction

private function WCS_OnHeroes takes nothing returns nothing
    local player viewer = null
    local integer pid = 0
    local integer heroId = 0
    local integer category
    if GetLocalPlayer() != GetTriggerPlayer() then
        return
    endif
    set viewer = GetTriggerPlayer()
set pid = GetPlayerId(viewer)
    call WCS_ResetClickedFrame()
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
endfunction

private function WCS_OnCategory takes nothing returns nothing
    local player viewer = null
    local integer pid 
    local framehandle clicked = null
    local integer category = 1
    if GetLocalPlayer() != GetTriggerPlayer() then
        return
    endif
    set clicked = BlzGetTriggerFrame()
        set viewer = GetTriggerPlayer()
       set pid = GetPlayerId(viewer)
    call WCS_ResetClickedFrame()
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
endfunction

private function WCS_OnHero takes nothing returns nothing
    local player viewer = null
    local integer pid 
    local framehandle clicked = null
    local integer slot = 0
    if GetLocalPlayer() != GetTriggerPlayer() then
        return
    endif
        set clicked = BlzGetTriggerFrame()
        set viewer = GetTriggerPlayer()
       set pid = GetPlayerId(viewer)
    call WCS_ResetClickedFrame()
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
    call WCS_CreateBackdrop(WCS_HomePage, 0.315, 0.310, 0.140, 0.170, 125, 8300)
    call WCS_CreateBackdrop(WCS_HomePage, 0.475, 0.310, 0.155, 0.170, 125, 8301)
    set WCS_HomeOverall = WCS_CreateText(WCS_HomePage, 0.315, 0.310, 0.133, 0.162, 0.90, TEXT_JUSTIFY_CENTER, "", 8310)
    set WCS_HomeHero = WCS_CreateText(WCS_HomePage, 0.475, 0.310, 0.148, 0.162, 0.86, TEXT_JUSTIFY_CENTER, "", 8311)
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
        call BlzFrameSetSize(WCS_CategoryButton[category], 0.055, 0.027)
        set WCS_CategoryIcon[category] = WCS_CreateIcon(WCS_CategoryButton[category], WCS_CategoryTexture(category + 1), 8410 + category)
        set tooltipText = WCS_CreateTooltip(WCS_CategoryButton[category], 0.130, 0.026, 8420 + category)
        set WCS_CategoryTooltip[category] = WCS_LastCreatedTooltip
        call BlzFrameSetText(tooltipText, "|cffffffff" + WCS_CategoryName(category + 1) + "|r")
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
        set WCS_HeroName[slot] = WCS_CreateText(WCS_HeroesPage, x, y - 0.016, 0.045, 0.011, 0.56, TEXT_JUSTIFY_CENTER, "", 9300 + slot)
        set WCS_HeroTooltipText[slot] = WCS_CreateTooltip(WCS_HeroButton[slot], 0.160, 0.055, 9400 + slot)
        set WCS_HeroTooltip[slot] = WCS_LastCreatedTooltip
        call BlzTriggerRegisterFrameEvent(WCS_HeroTrigger, WCS_HeroButton[slot], FRAMEEVENT_CONTROL_CLICK)
        set slot = slot + 1
    endloop
    set tooltipText = null
endfunction

private function WCS_CreateDetailPage takes nothing returns nothing
    local integer relationType = 0
    local integer slot = 0
    local integer index
    local real x
    local real y
    local framehandle tooltipText
    call WCS_CreateBackdrop(WCS_DetailPage, 0.400, 0.325, 0.325, 0.132, 150, 8700)
    call WCS_CreateBackdrop(WCS_DetailPage, 0.315, 0.221, 0.155, 0.062, 155, 8701)
    call WCS_CreateBackdrop(WCS_DetailPage, 0.485, 0.221, 0.155, 0.062, 155, 8702)
    set WCS_DetailHeroIcon = BlzCreateFrameByType("BACKDROP", "WcsDetailHeroIcon", WCS_DetailPage, "", 8710)
    call BlzFrameSetAbsPoint(WCS_DetailHeroIcon, FRAMEPOINT_CENTER, 0.255, 0.398)
    call BlzFrameSetSize(WCS_DetailHeroIcon, 0.036, 0.036)
    set WCS_DetailHeroName = WCS_CreateText(WCS_DetailPage, 0.385, 0.399, 0.210, 0.030, 0.94, TEXT_JUSTIFY_CENTER, "", 8711)
    set WCS_DetailPersonal = WCS_CreateText(WCS_DetailPage, 0.260, 0.326, 0.058, 0.106, 0.48, TEXT_JUSTIFY_CENTER, "", 8720)
    set WCS_DetailRounds = WCS_CreateText(WCS_DetailPage, 0.322, 0.326, 0.058, 0.106, 0.48, TEXT_JUSTIFY_CENTER, "", 8721)
    set WCS_DetailAverage = WCS_CreateText(WCS_DetailPage, 0.384, 0.326, 0.058, 0.106, 0.48, TEXT_JUSTIFY_CENTER, "", 8722)
    set WCS_DetailBest = WCS_CreateText(WCS_DetailPage, 0.446, 0.326, 0.058, 0.106, 0.48, TEXT_JUSTIFY_CENTER, "", 8723)
    call BlzFrameSetTextAlignment(WCS_DetailPersonal, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetTextAlignment(WCS_DetailRounds, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetTextAlignment(WCS_DetailAverage, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetTextAlignment(WCS_DetailBest, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
    loop
        exitwhen relationType >= WCS_RELATION_ROW_COUNT
        set y = 0.378 - I2R(relationType)*0.032
        set WCS_RelationTitle[relationType] = WCS_CreateText(WCS_DetailPage, 0.520, y, 0.088, 0.010, 0.38, TEXT_JUSTIFY_CENTER, "|cffffd36b" + WCS_RelationName(relationType) + "|r", 8730 + relationType)
        set slot = 0
        loop
            exitwhen slot >= WCS_RELATION_SLOT_COUNT
            set index = relationType*WCS_RELATION_SLOT_COUNT + slot
            set x = 0.492 + I2R(slot)*0.014
            set WCS_RelationButton[index] = WCS_CreateIconButton(WCS_DetailPage, x, y - 0.015, 0.012, 8740 + index)
            set WCS_RelationIcon[index] = WCS_CreateIcon(WCS_RelationButton[index], WCS_TEX_EMPTY, 8770 + index)
            set tooltipText = WCS_CreateTooltip(WCS_RelationButton[index], 0.145, 0.043, 8800 + index)
            set WCS_RelationTooltipText[index] = tooltipText
            set WCS_RelationTooltip[index] = WCS_LastCreatedTooltip
            call BlzFrameSetScale(tooltipText, 0.66)
            set slot = slot + 1
        endloop
        set relationType = relationType + 1
    endloop
    set WCS_DetailLastTitle = WCS_CreateText(WCS_DetailPage, 0.315, 0.245, 0.145, 0.012, 0.58, TEXT_JUSTIFY_CENTER, "|cffffd36bLAST MATCH BUILD|r", 8900)
    set slot = 0
    loop
        exitwhen slot >= WCS_LAST_ITEM_COUNT
        set x = 0.259 + I2R(slot)*0.0224
        set WCS_LastItemButton[slot] = WCS_CreateIconButton(WCS_DetailPage, x, 0.220, 0.019, 8910 + slot)
        set WCS_LastItemIcon[slot] = WCS_CreateIcon(WCS_LastItemButton[slot], WCS_TEX_EMPTY, 8920 + slot)
        set WCS_LastItemText[slot] = WCS_CreateText(WCS_DetailPage, x, 0.198, 0.023, 0.012, 0.50, TEXT_JUSTIFY_CENTER, "", 8930 + slot)
        set tooltipText = WCS_CreateTooltip(WCS_LastItemButton[slot], 0.205, 0.058, 8940 + slot)
        set WCS_LastItemTooltipText[slot] = tooltipText
        set WCS_LastItemTooltip[slot] = WCS_LastCreatedTooltip
        call BlzFrameSetScale(tooltipText, 0.61)
        set slot = slot + 1
    endloop
    set WCS_DetailBestItemsTitle = WCS_CreateText(WCS_DetailPage, 0.485, 0.245, 0.145, 0.012, 0.58, TEXT_JUSTIFY_CENTER, "|cffffd36bBEST WIN RATE|r", 8950)
    set slot = 0
    loop
        exitwhen slot >= WCS_BEST_ITEM_COUNT
        set x = 0.429 + I2R(slot)*0.0224
        set WCS_BestItemButton[slot] = WCS_CreateIconButton(WCS_DetailPage, x, 0.220, 0.019, 8960 + slot)
        set WCS_BestItemIcon[slot] = WCS_CreateIcon(WCS_BestItemButton[slot], WCS_TEX_EMPTY, 8980 + slot)
        set WCS_BestItemText[slot] = WCS_CreateText(WCS_DetailPage, x, 0.197, 0.024, 0.016, 0.42, TEXT_JUSTIFY_CENTER, "", 9000 + slot)
        set tooltipText = WCS_CreateTooltip(WCS_BestItemButton[slot], 0.205, 0.058, 9020 + slot)
        set WCS_BestItemTooltipText[slot] = tooltipText
        set WCS_BestItemTooltip[slot] = WCS_LastCreatedTooltip
        call BlzFrameSetScale(tooltipText, 0.61)
        set slot = slot + 1
    endloop
    set tooltipText = null
endfunction

private function WCS_CreateUI takes nothing returns nothing
    local framehandle gameUI = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    local integer pid = 0
    set WCS_OpenButton = WCS_CreateIconButton(gameUI, WCS_OPEN_X, WCS_OPEN_Y, WCS_OPEN_SIZE, 8200)
    set WCS_OpenIcon = WCS_CreateIcon(WCS_OpenButton, WCS_TEX_OPEN, 8201)
    call BlzFrameSetVisible(WCS_OpenButton, false)
    call BlzFrameSetLevel(WCS_OpenButton, 100)
    call BlzFrameSetLevel(WCS_OpenIcon, 101)

    set WCS_Main = BlzCreateFrame("ListBoxWar3", gameUI, 0, 8210)
    call BlzFrameSetAbsPoint(WCS_Main, FRAMEPOINT_CENTER, WCS_PANEL_X, WCS_PANEL_Y)
    call BlzFrameSetSize(WCS_Main, WCS_PANEL_WIDTH, WCS_PANEL_HEIGHT)
    // КРИТИЧНО: панель изначально всегда скрыта.
call BlzFrameSetVisible(WCS_Main, false)
    set WCS_Title = WCS_CreateText(WCS_Main, 0.445, 0.436, 0.160, 0.018, 0.76, TEXT_JUSTIFY_CENTER, "|cffffd36bWOS2 CAREER STATISTICS|r", 8211)

    set WCS_CloseButton = WCS_CreateIconButton(WCS_Main, 0.560, 0.438, 0.012, 8212)
    set WCS_CloseIcon = WCS_CreateIcon(WCS_CloseButton, WCS_TEX_CLOSE, 8213)
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

private function WCS_DelayedInit takes nothing returns nothing
    local timer initTimer = GetExpiredTimer()
    call WCS_CreateUI()
    // MyHeroIdInit fills all pages atomically from the map's 1-second trigger.
    // Retry until at least one real ID exists and no pick/ban has written 12.
    set WCS_CatalogTimer = CreateTimer()
    call TimerStart(WCS_CatalogTimer, 0.10, true, function WCS_CatalogTick)
    call DestroyTimer(initTimer)
    set initTimer = null
endfunction

private function WCS_Init takes nothing returns nothing
    local timer initTimer = CreateTimer()
    call TimerStart(initTimer, 0.00, false, function WCS_DelayedInit)
    set initTimer = null
endfunction

endlibrary
