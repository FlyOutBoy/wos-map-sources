// WoS Shop - audited/refactored version
// Invariants: catalogue slots 0..34, craft slots 36..42, inventory slots 0..5.
// Rawcode/item IDs are integers and use 0 (not null) as the empty value.
// В локальных ветках GetLocalPlayer разрешены только прямые операции BlzFrame*.
// Все вычисления, вызовы вспомогательных функций и присваивания выполняются до них.
// Адресные звуки запускаются вне локальных веток через StartSoundForPlayerBJ.

globals
    trigger FrameClick2 
    trigger FrameShopCheckbox
    trigger FrameCraftScroll
    trigger FrameCraftWheel
    trigger FrameShopSearch
    trigger SyncTrigger // NEW: Триггер для синхронизации UI
    framehandle FRAME_ShopMAIN
    framehandle FRAME_ShopSearchEditBox
    framehandle FRAME_ShopSearchLabel
    framehandle FRAME_ShopSearchClear
    framehandle FRAME_ShopSearchClearIcon
    framehandle FRAME_ShopSearchPrevious
    framehandle FRAME_ShopSearchPreviousIcon
    framehandle FRAME_ShopSearchNext
    framehandle FRAME_ShopSearchNextIcon
    framehandle FRAME_ShopSearchPageText
    framehandle array FRAME_ShopSection
    framehandle FRAME_AutoBuyCheckbox
    framehandle FRAME_AutoBuyText
    framehandle FRAME_ShopItemList
    framehandle FRAME_ShopItemInventory
    framehandle FRAME_ShopItemInventoryName
    framehandle FRAME_ShopItemCraft
    framehandle FRAME_ShopItemCraftSprite
    framehandle FRAME_ShopItemCraftSprite2
    framehandle FRAME_ShopItemDescription
    framehandle FRAME_ShopItemDescriptionName
    framehandle FRAME_ShopItemDescriptionName2
    framehandle FRAME_ShopItemCraftGoldSlot
    framehandle FRAME_ShopCraftUpgradeScroll
    framehandle FRAME_ShopCraftComponentScroll
    framehandle FRAME_ShopCraftUpgradeWheelArea
    framehandle FRAME_ShopCraftComponentWheelArea
    framehandle array FRAME_ShopItemInventorySlot
    framehandle array FRAME_ShopItemInventorySlotBack
    framehandle array FRAME_ShopItemInventorySlotCost
    framehandle array FRAME_ShopItem
    framehandle array FRAME_ShopItemBack
    framehandle array FRAME_ShopItemCost
    framehandle array FRAME_ShopItemTooltipText
    framehandle array FRAME_ShopInventoryTooltipText
    boolean array Shop_Active
    integer array ItemsFrameCurrentPage_ID
    integer array ItemsCurrentItemCraft_ID
    integer array ItemsFrameCurrentItem_ID
    integer array ItemsCurrentItem_ID
    integer array ItemsCurrentItem_ID_BACKUP
    integer array ItemsCurrentItemBag_ID
    integer array ItemsCurrentItemBagDescription_ID0
    integer array ItemsCurrentItemBagDescription_ID1
    integer array ItemsCurrentItemBagDescription_ID2
    integer array ItemsCurrentItemBagDescription_ID3
    integer array ItemsCurrentItemBagDescription_ID4
    integer array ItemsCurrentItemBagDescription_ID5
    integer array ItemsPage0_ID
    integer array ItemsPage1_ID
    integer array ItemsPage2_ID
    integer array ItemsPage3_ID
    integer array ItemsPage4_ID
    integer array ItemsPage5_ID
    integer array ItemsPage6_ID
    integer array ItemsSearch_ID
    integer array ItemsSearchAll_ID
    integer array ItemsCraft_ID
    integer array ItemsCraftLeft_ID
    integer array ItemsCraftBottom_ID
    integer array ItemsCraftRight_ID
    integer array ItemsCraftUpperLeft_ID
    integer array ItemsCraftUpperTop_ID
    integer array ItemsCraftUpperRight_ID
    integer array ItemsCraftCenter_ID
    integer array ItemsCraftPlayerDebug_ID
    integer array ItemsCraftPlayerDebug2_ID
    integer array ShopCraftUpgradeOffset
    integer array ShopCraftComponentOffset
    integer array ShopCraftScrollItemId
    integer array ShopCraftUpgradeMaxPage
    integer array ShopCraftComponentMaxPage
    boolean array ShopCraftScrollUpdating
    boolean array ShopSearchActive
    boolean array ShopSearchUpdating
    integer array ShopSearchReturnPage
    integer array ShopSearchResultCount
    integer array ShopSearchPage
    integer array ShopSectionPage
    string array ShopSearchQuery
    unit priceshop = null
    unit pricesell = null
    boolean array UsedSlot
    real Refund100Time = 15 // how much time after buy you have to refund item for full price
    hashtable CraftRecipeTable = InitHashtable()
    hashtable CraftScrollStateTable = InitHashtable()
    hashtable ShopFrameTable = InitHashtable()
    hashtable ShopTooltipTable = InitHashtable()
    integer array ShopInventoryLastId
    integer array ShopInventoryLastRefund
    // Handle героя, чей инвентарь сейчас показан конкретному игроку.
    integer array ShopTargetUnitId
    integer array ShopRenderedItemId
    boolean array ShopRenderedBanned
    boolean array ShopRenderedInitialized
    integer array AutoBuyRecommendedIndex
    integer array AutoBuyRecommendedUnitId
    boolean array AutoBuyRecommendedDone
    integer array ShopRefundKey
    integer ShopTooltipContext = 7000
    real ShopTooltipVerticalOffset = -0.01 // Меняйте это значение для точной высоты подсказки.
    constant integer CRAFT_UPGRADE_COUNT = 0
    constant integer CRAFT_UPGRADE_FIRST = 1
    constant integer CRAFT_COMPONENT_COUNT = 100
    constant integer CRAFT_COMPONENT_FIRST = 101
    constant integer CRAFT_SCROLL_COMPONENT_KEY = 16
    constant integer SHOP_SEARCH_PAGE = 7
    constant integer SHOP_SEARCH_PAGE_SIZE = 35
    constant integer SHOP_SEARCH_MAX_RESULTS = 210
    constant integer SHOP_CATEGORY_MAX_ITEMS = 210
    constant integer SHOP_RECOMMENDED_COUNT = 6
    constant integer SHOP_FIRST_ROUND_BUY_LIMIT = 2
    real RefundPercent = 85 // 85 = 85% of item cost
    boolean ShopUICreated = false
    boolean ShopFirstRoundAutoBuyDone = false
    timer ShopInventoryTimer = null
    timer ShopAutoBuyTimer = null
endglobals

function RefreshItemCache2 takes unit u returns nothing
    local integer unitHid = GetHandleId(u)
    local integer slot = 0
    local item it
    call FlushChildHashtable(ItemCache, unitHid)
    loop
        exitwhen slot > 5
        set it = UnitItemInSlot(u, slot)
        if it != null then
            call SaveBoolean(ItemCache,unitHid,GetItemTypeId(it),true)
        endif
        set slot = slot + 1
    endloop
    set it = null
endfunction

function ShopGetInventoryItemId takes unit u, integer slot returns integer
    local item it = UnitItemInSlot(u, slot)
    local integer id = 0
    if it != null then
        set id = GetItemTypeId(it)
    endif
    set it = null
    return id
endfunction

function ShopCacheItemDescription takes integer id returns nothing
    local item it
    if id != 0 and not HaveSavedString(ShopTooltipTable, id, 0) then
        set it = CreateItem(id, GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster))
        call SaveStr(ShopTooltipTable, id, 0, BlzGetItemTooltip(it))
        call SaveStr(ShopTooltipTable, id, 1, BlzGetItemExtendedTooltip(it))
        call RemoveItem(it)
    endif
    set it = null
endfunction

function ShopShowItemDescription takes integer id, player p returns nothing
    local string name
    local string description
    local string coloredName = ""
    if id == 0 then
        return
    endif
    if HaveSavedString(ShopTooltipTable, id, 0) then
        set name = LoadStr(ShopTooltipTable, id, 0)
        set description = LoadStr(ShopTooltipTable, id, 1)
    else
        call ShopCacheItemDescription(id)
        set name = LoadStr(ShopTooltipTable, id, 0)
        set description = LoadStr(ShopTooltipTable, id, 1)
    endif
    
    // СБОРКА СТРОК ВНЕ GetLocalPlayer
    set coloredName = "|c00FFFF00" + name + "|r"
    if GetLocalPlayer() == p then
        call BlzFrameSetText(FRAME_ShopItemDescriptionName, coloredName)
        call BlzFrameSetText(FRAME_ShopItemDescriptionName2, description)
    endif
endfunction

function ShopCreateItemTooltip takes framehandle whichFrame returns framehandle
    local integer context = ShopTooltipContext
    local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "ShopNativeTooltip", FRAME_ShopMAIN, "", context)
    local framehandle tooltipText = BlzCreateFrameByType("TEXT", "ShopNativeTooltipText", tooltip, "", context)
    set ShopTooltipContext = ShopTooltipContext + 1
    call BlzFrameSetPoint(tooltip, FRAMEPOINT_TOP, whichFrame, FRAMEPOINT_BOTTOM, 0.0, ShopTooltipVerticalOffset)
    call BlzFrameSetSize(tooltip, 0.050, 0.020)
    call BlzFrameSetTexture(tooltip, "textures\\black32.blp", 0, true)
    call BlzFrameSetAlpha(tooltip, 205)
    call BlzFrameSetLevel(tooltip, 50)
    call BlzFrameSetAllPoints(tooltipText, tooltip)
    call BlzFrameSetTextAlignment(tooltipText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(tooltipText, 0.90)
    call BlzFrameSetText(tooltipText, "")
    call BlzFrameSetVisible(tooltip, false)
    call BlzFrameSetTooltip(whichFrame, tooltip)
    set tooltip = null
    return tooltipText
endfunction

function ShopVisibleTextLength takes string text returns integer
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

function ShopGetItemTooltipWidth takes string itemName returns real
    local real width = 0.018 + I2R(ShopVisibleTextLength(itemName)) * 0.0044
    if width < 0.045 then
        set width = 0.045
    elseif width > 0.140 then
        set width = 0.140
    endif
    return width
endfunction

function ShopGetStaticPageItem takes integer page, integer slot returns integer
    if page == 1 then
        return ItemsPage1_ID[slot]
    elseif page == 2 then
        return ItemsPage2_ID[slot]
    elseif page == 3 then
        return ItemsPage3_ID[slot]
    elseif page == 4 then
        return ItemsPage4_ID[slot]
    elseif page == 5 then
        return ItemsPage5_ID[slot]
    elseif page == 6 then
        return ItemsPage6_ID[slot]
    endif
    return 0
endfunction

function ShopGetPlayerPageItem takes integer page, integer pid, integer slot returns integer
    if page == 0 then
        return ItemsPage0_ID[pid * SHOP_SEARCH_PAGE_SIZE + slot]
    elseif page >= 1 and page <= 6 then
        return ShopGetStaticPageItem(page, ShopSectionPage[pid * 7 + page] * SHOP_SEARCH_PAGE_SIZE + slot)
    elseif page == SHOP_SEARCH_PAGE then
        return ItemsSearch_ID[pid * SHOP_SEARCH_PAGE_SIZE + slot]
    endif
    return 0
endfunction

function ShopTextContains takes string source, string needle returns boolean
    local integer sourceLength = StringLength(source)
    local integer needleLength = StringLength(needle)
    local integer index = 0
    if needleLength == 0 then
        return true
    endif
    loop
        exitwhen index + needleLength > sourceLength
        if SubString(source, index, index + needleLength) == needle then
            return true
        endif
        set index = index + 1
    endloop
    return false
endfunction

function ShopSanitizeSearchQuery takes string query returns string
    local string allowed = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-'._"
    local string result = ""
    local string current
    local integer index = 0
    local integer length = StringLength(query)
    loop
        exitwhen index >= length
        set current = SubString(query, index, index + 1)
        if ShopTextContains(allowed, current) then
            set result = result + current
        endif
        set index = index + 1
    endloop
    return result
endfunction

function ShopNameMatchesSearch takes string itemName, string query returns boolean
    local string source = StringCase(itemName, false)
    local string loweredQuery = StringCase(query, false)
    local string current
    local string token = ""
    local integer index = 0
    local integer length = StringLength(loweredQuery)
    local boolean hasToken = false
    loop
        exitwhen index > length
        if index == length then
            set current = " "
        else
            set current = SubString(loweredQuery, index, index + 1)
        endif
        if current == " " then
            if StringLength(token) > 0 then
                set hasToken = true
                if not ShopTextContains(source, token) then
                    return false
                endif
                set token = ""
            endif
        else
            set token = token + current
        endif
        set index = index + 1
    endloop
    return hasToken
endfunction

function ShopSearchAlreadyAdded takes integer pid, integer count, integer itemId returns boolean
    local integer index = 0
    loop
        exitwhen index >= count
        if ItemsSearchAll_ID[pid * SHOP_SEARCH_MAX_RESULTS + index] == itemId then
            return true
        endif
        set index = index + 1
    endloop
    return false
endfunction

function ShopFillSearchVisiblePage takes integer pid returns nothing
    local integer slot = 0
    local integer resultIndex = ShopSearchPage[pid] * SHOP_SEARCH_PAGE_SIZE
    loop
        exitwhen slot >= SHOP_SEARCH_PAGE_SIZE
        if resultIndex < ShopSearchResultCount[pid] then
            set ItemsSearch_ID[pid * SHOP_SEARCH_PAGE_SIZE + slot] = ItemsSearchAll_ID[pid * SHOP_SEARCH_MAX_RESULTS + resultIndex]
        else
            set ItemsSearch_ID[pid * SHOP_SEARCH_PAGE_SIZE + slot] = 0
        endif
        set slot = slot + 1
        set resultIndex = resultIndex + 1
    endloop
endfunction

function ShopSortSearchResultsByPrice takes integer pid, integer count returns nothing
    local integer index = 1
    local integer position
    local integer currentId
    local integer currentPrice
    local integer previousId
    loop
        exitwhen index >= count
        set currentId = ItemsSearchAll_ID[pid * SHOP_SEARCH_MAX_RESULTS + index]
        set currentPrice = GetItemValue(currentId)
        set position = index - 1
        loop
            exitwhen position < 0
            set previousId = ItemsSearchAll_ID[pid * SHOP_SEARCH_MAX_RESULTS + position]
            exitwhen GetItemValue(previousId) <= currentPrice
            set ItemsSearchAll_ID[pid * SHOP_SEARCH_MAX_RESULTS + position + 1] = previousId
            set position = position - 1
        endloop
        set ItemsSearchAll_ID[pid * SHOP_SEARCH_MAX_RESULTS + position + 1] = currentId
        set index = index + 1
    endloop
endfunction

function ShopBuildSearchResults takes integer pid, string query returns nothing
    local integer page = 1
    local integer slot
    local integer itemId
    local integer count = 0
    loop
        exitwhen count >= SHOP_SEARCH_MAX_RESULTS
        set ItemsSearchAll_ID[pid * SHOP_SEARCH_MAX_RESULTS + count] = 0
        set count = count + 1
    endloop
    set count = 0
    loop
        exitwhen page > 6 or count >= SHOP_SEARCH_MAX_RESULTS
        set slot = 0
        loop
            exitwhen slot >= SHOP_CATEGORY_MAX_ITEMS or count >= SHOP_SEARCH_MAX_RESULTS
            set itemId = ShopGetStaticPageItem(page, slot)
            if itemId != 0 and not ShopSearchAlreadyAdded(pid, count, itemId) and ShopNameMatchesSearch(GetObjectName(itemId), query) then
                set ItemsSearchAll_ID[pid * SHOP_SEARCH_MAX_RESULTS + count] = itemId
                set count = count + 1
            endif
            set slot = slot + 1
        endloop
        set page = page + 1
    endloop
    set ShopSearchResultCount[pid] = count
    call ShopSortSearchResultsByPrice(pid, count)
    call ShopFillSearchVisiblePage(pid)
endfunction

function ShopRenderCatalogueSlot takes integer slot, integer id, boolean banned, player p returns nothing
    local integer cacheIndex = GetPlayerId(p) * SHOP_SEARCH_PAGE_SIZE + slot
    local integer price = 0
    local boolean fullRefresh = not ShopRenderedInitialized[cacheIndex] or ShopRenderedItemId[cacheIndex] != id
    local boolean banRefresh = ShopRenderedBanned[cacheIndex] != banned
    local string costStr = ""
    local string tooltipNameStr = ""
    local string itemName = ""
    local string iconPath = "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder"
    local real tooltipWidth = ShopGetItemTooltipWidth("")
    local framehandle tooltip = BlzFrameGetParent(FRAME_ShopItemTooltipText[slot])
    
    if id != 0 then
        set price = GetItemValue(id)
        // Строки собираются глобально для избежания десинка
        set costStr = "|c00FFFF00" + I2S(price) + "|r"
        set itemName = GetObjectName(id)
        set tooltipNameStr = "|cffffffff" + itemName + "|r"
        set tooltipWidth = ShopGetItemTooltipWidth(itemName)
        set iconPath = BlzGetAbilityIcon(id)
        if banned then
            set iconPath = ConvertBTNtoDISBTN(iconPath)
        endif
    endif
    
    if GetLocalPlayer() == p then
        if fullRefresh then
            if id == 0 then
                call BlzFrameSetText(FRAME_ShopItemTooltipText[slot], "")
                call BlzFrameSetSize(tooltip, tooltipWidth, 0.020)
                call BlzFrameSetTexture(FRAME_ShopItemBack[slot], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
                call BlzFrameSetText(FRAME_ShopItemCost[slot], "")
                call BlzFrameSetEnable(FRAME_ShopItem[slot], false)
            else
                call BlzFrameSetSize(tooltip, tooltipWidth, 0.020)
                call BlzFrameSetText(FRAME_ShopItemTooltipText[slot], tooltipNameStr)
                call BlzFrameSetTexture(FRAME_ShopItemBack[slot], iconPath, 0, false)
                call BlzFrameSetText(FRAME_ShopItemCost[slot], costStr)
                call BlzFrameSetEnable(FRAME_ShopItem[slot], not banned)
            endif
        elseif banRefresh then
            call BlzFrameSetTexture(FRAME_ShopItemBack[slot], iconPath, 0, false)
            call BlzFrameSetEnable(FRAME_ShopItem[slot], not banned)
        endif
    endif
    set ShopRenderedItemId[cacheIndex] = id
    set ShopRenderedBanned[cacheIndex] = banned
    set ShopRenderedInitialized[cacheIndex] = true
    set tooltip = null
endfunction

function ShopGetPageItem takes integer page, integer slot returns integer
    return ShopGetStaticPageItem(page, slot)
endfunction

function ShopSetPageItem takes integer page, integer slot, integer itemId returns nothing
    if page == 1 then
        set ItemsPage1_ID[slot] = itemId
    elseif page == 2 then
        set ItemsPage2_ID[slot] = itemId
    elseif page == 3 then
        set ItemsPage3_ID[slot] = itemId
    elseif page == 4 then
        set ItemsPage4_ID[slot] = itemId
    elseif page == 5 then
        set ItemsPage5_ID[slot] = itemId
    elseif page == 6 then
        set ItemsPage6_ID[slot] = itemId
    endif
endfunction

function ShopGetSectionPageCount takes integer page returns integer
    local integer slot = SHOP_CATEGORY_MAX_ITEMS - 1
    if page < 1 or page > 6 then
        return 1
    endif
    loop
        exitwhen slot < 0
        if ShopGetStaticPageItem(page, slot) != 0 then
            return slot / SHOP_SEARCH_PAGE_SIZE + 1
        endif
        set slot = slot - 1
    endloop
    return 1
endfunction

function SortShopPageByPrice takes integer page returns nothing
    local integer left = 0
    local integer right
    local integer leftId
    local integer rightId
    local integer leftValue
    local integer rightValue
    loop
        exitwhen left >= SHOP_CATEGORY_MAX_ITEMS - 1
        set leftId = ShopGetPageItem(page, left)
        if leftId != 0 then
            set leftValue = GetItemValue(leftId)
            set right = left + 1
            loop
                exitwhen right >= SHOP_CATEGORY_MAX_ITEMS
                set rightId = ShopGetPageItem(page, right)
                if rightId != 0 then
                    set rightValue = GetItemValue(rightId)
                    if rightValue < leftValue then
                        call ShopSetPageItem(page, left, rightId)
                        call ShopSetPageItem(page, right, leftId)
                        set leftId = rightId
                        set leftValue = rightValue
                    endif
                endif
                set right = right + 1
            endloop
        endif
        set left = left + 1
    endloop
endfunction

function SortAllShopPagesByPrice takes nothing returns nothing
    local integer page = 1
    loop
        exitwhen page > 6
        call SortShopPageByPrice(page)
        set page = page + 1
    endloop
endfunction

function MyItemsIdInit takes nothing returns nothing
    local item a
    local integer k = 0
    local real x = GetRectCenterX(gg_rct_Caster)
    local real y = GetRectCenterY(gg_rct_Caster)
    local integer i2 = 12
    local integer array itemList
    local integer g1 = GetPlayerState(Player(i2), PLAYER_STATE_RESOURCE_GOLD)
    local integer g2 = 0
    set ItemsPage1_ID[0] = 'I00C' 
    set ItemsPage1_ID[1] = 'I00D' 
    set ItemsPage1_ID[2] = 'I02Z' 
    set ItemsPage1_ID[3] = 'I032' 
    set ItemsPage1_ID[4] = 'I02U' 
    set ItemsPage1_ID[5] = 'I000' 
    set ItemsPage1_ID[6] = 'I018' 
    set ItemsPage1_ID[7] = 'I01J' 
    set ItemsPage1_ID[8] = 'I007' 
    set ItemsPage1_ID[9] = 'I026' 
    set ItemsPage1_ID[10] = 'I027' 
    set ItemsPage1_ID[11] = 'I014' 
    set ItemsPage1_ID[12] = 'I00G' 
    set ItemsPage1_ID[13] = 'I00Q' 
    set ItemsPage1_ID[14] = 'I00N' 
    set ItemsPage1_ID[15] = 'I028' 
    set ItemsPage1_ID[16] = 'I022' 
    set ItemsPage1_ID[21] = 'I02K' 
    set ItemsPage1_ID[22]  = 'I02R' 
    set ItemsPage1_ID[23] = 'I02P' 
    set ItemsPage1_ID[24] = 'I02O' 
    set ItemsPage1_ID[25] = 'I02T' 
    set ItemsPage1_ID[26] = 'I00P' 
    set ItemsPage1_ID[27] = 'I00U' 
    set ItemsPage1_ID[28] = 'I017' 
    set ItemsPage1_ID[29] = 'I00E' 
    set ItemsPage1_ID[30] = 'I00O' 
    set ItemsPage1_ID[31] = 'I01N' 

    set ItemsPage2_ID[0] = 'I005' 
    set ItemsPage2_ID[14] = 'I02L' 
    set ItemsPage2_ID[15] = 'I02G' 
    set ItemsPage2_ID[16] = 'I01K' 
    set ItemsPage2_ID[17] = 'I02J' 
    set ItemsPage2_ID[18] = 'I02H' 

    set ItemsPage3_ID[0] = 'I03D' 
    set ItemsPage3_ID[14] = 'I01I' 
    set ItemsPage3_ID[15] = 'I00T' 
    set ItemsPage3_ID[16] = 'I010' 
    set ItemsPage3_ID[17] = 'I01U' 
    set ItemsPage3_ID[18] = 'I016' 
    set ItemsPage3_ID[19] = 'I024' 

    set ItemsPage4_ID[0] = 'I03H' 
    set ItemsPage4_ID[14] = 'I00H' 
    set ItemsPage4_ID[15] = 'I01B' 
    set ItemsPage4_ID[16] = 'I01C' 
    set ItemsPage4_ID[17] = 'I01S' 
    set ItemsPage4_ID[18] = 'I015' 
    set ItemsPage4_ID[19] = 'I011' 

set k = 0
loop
    exitwhen k == 35
    set itemList[k]=0
    set k = k + 1
endloop
set k = 0
    set itemList[0] = 'I01V' 
    set itemList[1] = 'I012' 
    set itemList[2] = 'I02M' 
    set itemList[3] = 'I02F' 
    set itemList[4] = 'I021' 
    set itemList[5] = 'I00V' 
    set itemList[6] = 'I02A' 
    set itemList[7] = 'I00Z' 
    set itemList[8] = 'I00M' 
    set itemList[9] = 'I01Q' 
    set itemList[10] = 'I01X' 
    set itemList[11] = 'I01Y' 
    set itemList[12] = 'I01P' 
    set itemList[13] = 'I02S' 
    set itemList[14] = 'I01L' 
    set itemList[15] = 'I00R' 
    set itemList[16] = 'I01M' 
    set itemList[17] = 'I00J' 
    set itemList[18] = 'I01O' 
    set itemList[19] = 'I02D' 
    set itemList[20] = 'I023' 
    set itemList[21] = 'I02C' 
    set itemList[22] = 'I02B' 
    set itemList[23] = 'I00W' 
    set itemList[24] = 'I019' 
    set itemList[25] = 'I01W' 
    set itemList[26] = 'I02E' 
    set itemList[27] = 'I03T' 
    set itemList[28] = 'I03U' 
    set itemList[29] = 'I03V' 
    set itemList[30] = 'I03W' 
    set k = 0
loop
    exitwhen k == 35
    if itemList[k] != 0 then
    set ItemsPage5_ID[k] = itemList[k]
    endif
    set k = k + 1
endloop

set k = 0
loop
    exitwhen k == 35
    set itemList[k]=0
    set k = k + 1
endloop
set k = 0
set itemList[0]  = 'I00I' 
set itemList[1]  = 'I00K' 
set itemList[14] = 'I00Y' 
set itemList[15] = 'I020' 
set itemList[16] = 'I00L' 
set itemList[17] = 'I00X' 
set itemList[18] = 'I00B' 
set itemList[19] = 'I013' 
set itemList[20] = 'I02N' 
set k = 0
loop
    exitwhen k == 35
    if itemList[k] != 0 then
    set ItemsPage6_ID[k] = itemList[k]
    endif
    set k = k + 1
endloop

    if priceshop == null then
        set priceshop = CreateUnit(Player(i2), 'ngme', x, y, 0)
    endif
    if pricesell == null then
        set pricesell = CreateUnit(Player(i2), 'Hpal', x, y - 100, 90)
    endif
    call SetUnitVertexColor(priceshop, 0, 0, 0, 0)
    call SetUnitVertexColor(pricesell, 0, 0, 0, 0)
    call UnitAddAbility(priceshop, 'Apiv')
    call UnitAddAbility(pricesell, 'Apiv')
    call UnitAddAbility(priceshop, 'Avul')
    call UnitAddAbility(pricesell, 'Avul')
    call SetScale(pricesell, 0.01)
    call SetScale(priceshop, 0.01)
    set a = UnitAddItemByIdSwapped('I000', pricesell)
    call UnitDropItemTarget(pricesell, a, priceshop)
    set g2 = GetPlayerState(Player(i2), PLAYER_STATE_RESOURCE_GOLD) - g1
    call SetPlayerState(Player(i2), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(i2), PLAYER_STATE_RESOURCE_GOLD) - g2)
    set a = null
    set k = 0
    loop
    exitwhen k >= SHOP_CATEGORY_MAX_ITEMS
    if ItemsPage1_ID[k] != 0 then 
    call GetItemValue(ItemsPage1_ID[k])
    endif
    if ItemsPage2_ID[k] != 0 then 
    call GetItemValue(ItemsPage2_ID[k])
    endif
    if ItemsPage3_ID[k] != 0 then 
    call GetItemValue(ItemsPage3_ID[k])
    endif
    if ItemsPage4_ID[k] != 0 then 
    call GetItemValue(ItemsPage4_ID[k])
    endif
    if ItemsPage5_ID[k] != 0 then 
    call GetItemValue(ItemsPage5_ID[k])
    endif
    if ItemsPage6_ID[k] != 0 then 
    call GetItemValue(ItemsPage6_ID[k])
    endif
    set k = k + 1
    endloop
    set k = 0
    call SortAllShopPagesByPrice()
endfunction

function GetCraftComponentCount takes integer itemId returns integer
    return LoadInteger(CraftRecipeTable, itemId, CRAFT_COMPONENT_COUNT)
endfunction
function GetCraftComponent takes integer itemId, integer index returns integer
    return LoadInteger(CraftRecipeTable, itemId, CRAFT_COMPONENT_FIRST + index)
endfunction
function GetCraftUpgradeCount takes integer itemId returns integer
    return LoadInteger(CraftRecipeTable, itemId, CRAFT_UPGRADE_COUNT)
endfunction
function GetCraftUpgrade takes integer itemId, integer index returns integer
    return LoadInteger(CraftRecipeTable, itemId, CRAFT_UPGRADE_FIRST + index)
endfunction

function GetCraftMaxOffset takes integer count returns integer
    if count <= 3 then
        return 0
    endif
    return ((count - 1) / 3) * 3
endfunction

function GetVisibleCraftRelation takes integer itemId, boolean upgrades, integer offset, integer visibleSlot returns integer
    local integer count
    local integer remaining
    local integer index
    if upgrades then
        set count = GetCraftUpgradeCount(itemId)
    else
        set count = GetCraftComponentCount(itemId)
    endif
    set remaining = count - offset
    if remaining <= 0 then
        return 0
    elseif remaining == 1 then
        if visibleSlot != 1 then
            return 0
        endif
        set index = offset
    elseif remaining == 2 then
        if visibleSlot >= 2 then
            return 0
        endif
        set index = offset + visibleSlot
    else
        set index = offset + visibleSlot
    endif
    if upgrades then
        return GetCraftUpgrade(itemId, index)
    endif
    return GetCraftComponent(itemId, index)
endfunction

function RegisterCraftUpgrade takes integer componentId, integer resultId returns nothing
    local integer count
    local integer index = 0
    if componentId == 0 then
        return
    endif
    set count = GetCraftUpgradeCount(componentId)
    loop
        exitwhen index >= count
        if GetCraftUpgrade(componentId, index) == resultId then
            return
        endif
        set index = index + 1
    endloop
    call SaveInteger(CraftRecipeTable, componentId, CRAFT_UPGRADE_FIRST + count, resultId)
    call SaveInteger(CraftRecipeTable, componentId, CRAFT_UPGRADE_COUNT, count + 1)
endfunction

function RegisterCraftComponent takes integer resultId, integer componentId returns nothing
    local integer count = GetCraftComponentCount(resultId)
    local integer index = 0
    if componentId == 0 then
        return
    endif
    loop
        exitwhen index >= count
        if GetCraftComponent(resultId, index) == componentId then
            return
        endif
        set index = index + 1
    endloop
    call SaveInteger(CraftRecipeTable, resultId, CRAFT_COMPONENT_FIRST + count, componentId)
    call SaveInteger(CraftRecipeTable, resultId, CRAFT_COMPONENT_COUNT, count + 1)
    call RegisterCraftUpgrade(componentId, resultId)
endfunction

function ShopRawcodeCharValue takes string value returns integer
    local string chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    local integer index = 0
    loop
        exitwhen index >= StringLength(chars)
        if SubString(chars, index, index + 1) == value then
            if index < 10 then
                return 48 + index
            elseif index < 36 then
                return 65 + index - 10
            endif
            return 97 + index - 36
        endif
        set index = index + 1
    endloop
    return 0
endfunction

function ShopRawcodeFromString takes string value returns integer
    local integer first
    local integer second
    local integer third
    local integer fourth
    if StringLength(value) != 4 then
        return 0
    endif
    set first = ShopRawcodeCharValue(SubString(value, 0, 1))
    set second = ShopRawcodeCharValue(SubString(value, 1, 2))
    set third = ShopRawcodeCharValue(SubString(value, 2, 3))
    set fourth = ShopRawcodeCharValue(SubString(value, 3, 4))
    if first == 0 or second == 0 or third == 0 or fourth == 0 then
        return 0
    endif
    return ((first * 256 + second) * 256 + third) * 256 + fourth
endfunction

function RegisterCraft takes integer resultId, string componentList returns nothing
    local integer length = StringLength(componentList)
    local integer index = 0
    local integer componentId
    local string current
    local string token = ""
    call SaveInteger(CraftRecipeTable, resultId, CRAFT_COMPONENT_COUNT, 0)
    loop
        exitwhen index > length
        if index == length then
            set current = " "
        else
            set current = SubString(componentList, index, index + 1)
        endif
        if current == " " or current == "," or current == ";" then
            if StringLength(token) > 0 then
                set componentId = ShopRawcodeFromString(token)
                if componentId != 0 then
                    call RegisterCraftComponent(resultId, componentId)
                else
                    call BJDebugMsg("|cffff2020Shop: invalid craft rawcode '" + token + "'.|r")
                endif
                set token = ""
            endif
        else
            set token = token + current
        endif
        set index = index + 1
    endloop
endfunction

function HasCraftComponents takes integer itemId returns boolean
    return GetCraftComponentCount(itemId) > 0
endfunction

function ReduceCostRecursive takes unit u, integer id, integer cost, boolean remove returns integer
    local integer componentCount = GetCraftComponentCount(id)
    local integer componentIndex = 0
    local integer componentId
    local integer inventorySlot
    local boolean found
    local item it
    loop
        exitwhen componentIndex >= componentCount
        set componentId = GetCraftComponent(id, componentIndex)
        set inventorySlot = 0
        set found = false
        loop
            exitwhen inventorySlot >= 6 or found
            set it = UnitItemInSlot(u, inventorySlot)
            if it != null and not UsedSlot[inventorySlot] and GetItemTypeId(it) == componentId then
                set cost = cost - GetItemValue(componentId)
                set UsedSlot[inventorySlot] = true
                set found = true
                if remove then
                    call RemoveItem(it)
                endif
            endif
            set inventorySlot = inventorySlot + 1
        endloop
        if not found then
            set cost = ReduceCostRecursive(u, componentId, cost, remove)
        endif
        set componentIndex = componentIndex + 1
    endloop
    set it = null
    return cost
endfunction

function CheckItemsReduceCostCraft takes unit u, integer cost, integer id, boolean remove returns integer
    local integer slot = 0
    loop
        exitwhen slot >= 6
        set UsedSlot[slot] = false
        set slot = slot + 1
    endloop
    return ReduceCostRecursive(u, id, cost, remove)
endfunction

function CheckBanGroup takes unit c, integer id, integer item1, integer item2, integer item3 returns boolean
    if id == 0 then
        return false
    endif
    if item1 != 0 and id == item1 then
        return (item2 != 0 and IsItemInInventory(c, item2) > 0) or (item3 != 0 and IsItemInInventory(c, item3) > 0)
    elseif item2 != 0 and id == item2 then
        return (item1 != 0 and IsItemInInventory(c, item1) > 0) or (item3 != 0 and IsItemInInventory(c, item3) > 0)
    elseif item3 != 0 and id == item3 then
        return (item1 != 0 and IsItemInInventory(c, item1) > 0) or (item2 != 0 and IsItemInInventory(c, item2) > 0)
    endif
    return false
endfunction

function CheckBanItems takes integer id, unit c returns boolean
    if CheckBanGroup(c, id, 'I01Q', 'I01X', 'I01Y') then
        return true
    endif
    if CheckBanGroup(c, id, 'I00E', 'I00O','I01N' ) then
        return true
    endif
    if CheckBanGroup(c, id, 'I03E', 'I03F','I02T' ) then
        return true
    endif
    if CheckBanGroup(c, id, 'I00J', 'I01M', 0) then
        return true
    endif
    if CheckBanGroup(c, id, 'I00R', 'I01L', 0) then
        return true
    endif
    return false
endfunction

function InitCraftRecipes takes nothing returns nothing
    call RegisterCraft('I03H', "I03G")
    call RegisterCraft('I03G', "I00A")
    call RegisterCraft('I00A', "I02W")
    call RegisterCraft('I02W', "I02V")
    call RegisterCraft('I02V', "I02U")
    call RegisterCraft('I03D', "I03C")
    call RegisterCraft('I03C', "I006")
    call RegisterCraft('I006', "I030")
    call RegisterCraft('I030', "I031")
    call RegisterCraft('I031', "I032")
    call RegisterCraft('I005', "I02X")
    call RegisterCraft('I02X', "I02Y")
    call RegisterCraft('I02Y', "I02Z")
    call RegisterCraft('I037', "I036")
    call RegisterCraft('I036', "I035")
    call RegisterCraft('I035', "I034")
    call RegisterCraft('I034', "I033")
    call RegisterCraft('I033', "I01J")
    call RegisterCraft('I03B', "I03A")
    call RegisterCraft('I03A', "I039")
    call RegisterCraft('I039', "I038")
    call RegisterCraft('I038', "I000")
    call RegisterCraft('I03Q', "I018")
    call RegisterCraft('I03J', "I03I")
    call RegisterCraft('I03I', "I00C")
    call RegisterCraft('I03L', "I03K")
    call RegisterCraft('I03K', "I00D")
    call RegisterCraft('I00U', "I038")
    call RegisterCraft('I02G', "I00G I02Y I01J")
    call RegisterCraft('I01K', "I02Y I00Q I01J")
    call RegisterCraft('I00P', "I014 I01J")
    call RegisterCraft('I02A', "I01J I022")
    call RegisterCraft('I021', "I01J I00Q")
    call RegisterCraft('I02B', "I01J I021")
    call RegisterCraft('I01O', "I036")
    call RegisterCraft('I023', "I035")
    call RegisterCraft('I017', "I03I I03K")
    call RegisterCraft('I01L', "I036")
    call RegisterCraft('I01M', "I036")
    call RegisterCraft('I01S', "I034 I014")
    call RegisterCraft('I01V', "I00G I014")
    call RegisterCraft('I01U', "I033 I00P")
    call RegisterCraft('I01P', "I033 I03F")
    call RegisterCraft('I01X', "I033 I03F")
    call RegisterCraft('I01Y', "I033 I02T")
    call RegisterCraft('I00X', "I00I I028")
    call RegisterCraft('I02E', "I01J I02D")
    call RegisterCraft('I01Q', "I033 I03E")
    call RegisterCraft('I00Z', "I01J I022")
    call RegisterCraft('I01B', "I03H")
    call RegisterCraft('I01I', "I000 I031 I018")
    call RegisterCraft('I01C', "I034 I02V")
    call RegisterCraft('I012', "I02X I030 I02W")
    call RegisterCraft('I010', "I034 I031")
    call RegisterCraft('I00W', "I037")
    call RegisterCraft('I02F', "I036")
    call RegisterCraft('I01W', "I01J I01O")
    call RegisterCraft('I02D', "I036")
    call RegisterCraft('I02C', "I033 I00P")
    call RegisterCraft('I019', "I037")
    call RegisterCraft('I00T', "I030 I02P")
    call RegisterCraft('I013', "I00I I03B")
    call RegisterCraft('I016', "I031 I034")
    call RegisterCraft('I015', "I031 I02V")
    call RegisterCraft('I028', "I026 I027")
    call RegisterCraft('I00M', "I02R I031 I02V")
    call RegisterCraft('I00O', "I03K I007 I00N")
    call RegisterCraft('I00Y', "I03J I02K I038")
    call RegisterCraft('I01N', "I03I I007 I00N")
    call RegisterCraft('I00L', "I00K I028")
    call RegisterCraft('I020', "I00K I039 I03I")
    call RegisterCraft('I00E', "I01J I007 I00N")
    call RegisterCraft('I011', "I03J I02O I03G")
    call RegisterCraft('I00B', "I00I I02K")
    call RegisterCraft('I024', "I03J I03D")
    call RegisterCraft('I00J', "I036")
    call RegisterCraft('I00R', "I036")
    call RegisterCraft('I00H', "I03Q I02V")
    call RegisterCraft('I02H', "I028 I02R")
    call RegisterCraft('I02J', "I02Y I034")
    call RegisterCraft('I02L', "I005")
    call RegisterCraft('I02M', "I036")
    call RegisterCraft('I02N', "I00I I02R I039")
    call RegisterCraft('I02S', "I033 I02T")
    call RegisterCraft('I00V', "I01J I022")
    call RegisterCraft('I03T', "I02R I02P I02O")
    call RegisterCraft('I03U', "I017")
    call RegisterCraft('I03V', "I00U")
    call RegisterCraft('I03W', "I035")
endfunction

function SetPlayerCraftSlot takes integer pid, integer slot, integer itemId returns nothing
    if slot == 0 then
        set ItemsCraftUpperLeft_ID[pid] = itemId
    elseif slot == 1 then
        set ItemsCraftUpperTop_ID[pid] = itemId
    elseif slot == 2 then
        set ItemsCraftUpperRight_ID[pid] = itemId
    elseif slot == 3 then
        set ItemsCraftLeft_ID[pid] = itemId
    elseif slot == 4 then
        set ItemsCraftBottom_ID[pid] = itemId
    else
        set ItemsCraftRight_ID[pid] = itemId
    endif
endfunction

function ResetCraftFrames takes player p returns nothing
    local integer frameIndex = 36
        loop
            exitwhen frameIndex > 41
            if GetLocalPlayer() == p then
                call BlzFrameSetEnable(FRAME_ShopItem[frameIndex], false)
                call BlzFrameSetVisible(FRAME_ShopItemBack[frameIndex], false)
                call BlzFrameSetTexture(FRAME_ShopItemBack[frameIndex], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
                call BlzFrameSetText(FRAME_ShopItemCost[frameIndex], "")
            endif
            set frameIndex = frameIndex + 1
        endloop
endfunction

function ShopSaveCraftScrollState takes integer pid, integer itemId returns nothing
    if itemId != 0 then
        call SaveInteger(CraftScrollStateTable, itemId, pid, ShopCraftUpgradeOffset[pid])
        call SaveInteger(CraftScrollStateTable, itemId, CRAFT_SCROLL_COMPONENT_KEY + pid, ShopCraftComponentOffset[pid])
    endif
endfunction

function ShopLoadCraftScrollState takes integer pid, integer itemId returns nothing
    set ShopCraftUpgradeOffset[pid] = LoadInteger(CraftScrollStateTable, itemId, pid)
    set ShopCraftComponentOffset[pid] = LoadInteger(CraftScrollStateTable, itemId, CRAFT_SCROLL_COMPONENT_KEY + pid)
endfunction

function ShopUpdateCraftScrollbars takes integer id, player p returns nothing
    local integer pid = GetPlayerId(p)
    local integer upgradeCount = GetCraftUpgradeCount(id)
    local integer componentCount = GetCraftComponentCount(id)
    local integer upgradeMaxOffset = GetCraftMaxOffset(upgradeCount)
    local integer componentMaxOffset = GetCraftMaxOffset(componentCount)
    local integer upgradeMaxPage = upgradeMaxOffset / 3
    local integer componentMaxPage = componentMaxOffset / 3
    local integer upgradeValue
    local integer componentValue
    local boolean upgradeRangeChanged = ShopCraftUpgradeMaxPage[pid] != upgradeMaxPage
    local boolean componentRangeChanged = ShopCraftComponentMaxPage[pid] != componentMaxPage
    local real upgradeMaxPageValue = I2R(upgradeMaxPage)
    local real componentMaxPageValue = I2R(componentMaxPage)
    if ShopCraftUpgradeOffset[pid] > upgradeMaxOffset then
        set ShopCraftUpgradeOffset[pid] = upgradeMaxOffset
    endif
    if ShopCraftComponentOffset[pid] > componentMaxOffset then
        set ShopCraftComponentOffset[pid] = componentMaxOffset
    endif
    set ShopCraftUpgradeMaxPage[pid] = upgradeMaxPage
    set ShopCraftComponentMaxPage[pid] = componentMaxPage
    call ShopSaveCraftScrollState(pid, id)
    set upgradeValue = ShopCraftUpgradeOffset[pid] / 3
    set componentValue = ShopCraftComponentOffset[pid] / 3
    set ShopCraftScrollUpdating[pid] = true
    if GetLocalPlayer() == p then
        if upgradeCount > 3 then
            if upgradeRangeChanged then
                call BlzFrameSetMinMaxValue(FRAME_ShopCraftUpgradeScroll, 0.00, upgradeMaxPageValue)
            endif
            if R2I(BlzFrameGetValue(FRAME_ShopCraftUpgradeScroll) + 0.50) != upgradeValue then
                call BlzFrameSetValue(FRAME_ShopCraftUpgradeScroll, I2R(upgradeValue))
            endif
            call BlzFrameSetVisible(FRAME_ShopCraftUpgradeScroll, true)
        else
            call BlzFrameSetVisible(FRAME_ShopCraftUpgradeScroll, false)
        endif
        if componentCount > 3 then
            if componentRangeChanged then
                call BlzFrameSetMinMaxValue(FRAME_ShopCraftComponentScroll, 0.00, componentMaxPageValue)
            endif
            if R2I(BlzFrameGetValue(FRAME_ShopCraftComponentScroll) + 0.50) != componentValue then
                call BlzFrameSetValue(FRAME_ShopCraftComponentScroll, I2R(componentValue))
            endif
            call BlzFrameSetVisible(FRAME_ShopCraftComponentScroll, true)
        else
            call BlzFrameSetVisible(FRAME_ShopCraftComponentScroll, false)
        endif
    endif
    set ShopCraftScrollUpdating[pid] = false
endfunction

function CraftItemCheck takes integer id, player p, integer page returns nothing
    local integer pid = GetPlayerId(p)
    local integer slot = 0
    local integer frameIndex
    local integer relatedId
    local integer value
    local unit selectedUnit = GetSelectedHeroForPlayer(p)
    local string costStr = ""
    local string relatedIconPath = ""
    local boolean relatedBanned = false
    if ShopCraftScrollItemId[pid] != id then
        call ShopSaveCraftScrollState(pid, ShopCraftScrollItemId[pid])
        set ShopCraftScrollItemId[pid] = id
        call ShopLoadCraftScrollState(pid, id)
    endif
    call ShopUpdateCraftScrollbars(id, p)
    call ResetCraftFrames(p)
    loop
        exitwhen slot >= 6
        if slot < 3 then
            set relatedId = GetVisibleCraftRelation(id, true, ShopCraftUpgradeOffset[pid], slot)
        else
            set relatedId = GetVisibleCraftRelation(id, false, ShopCraftComponentOffset[pid], slot - 3)
        endif
        call SetPlayerCraftSlot(pid, slot, relatedId)

        if relatedId != 0 then
            set frameIndex = 36 + slot
            if slot < 3 then
                set value = CheckItemsReduceCostCraft(selectedUnit, GetItemValue(relatedId), relatedId, false)
            else
                set value = GetItemValue(relatedId)
            endif
             
            set costStr = "|c00FFFF00" + I2S(value) + "|r"
            set relatedBanned = CheckBanItems(relatedId, selectedUnit)
            set relatedIconPath = BlzGetAbilityIcon(relatedId)
            if relatedBanned then
                set relatedIconPath = ConvertBTNtoDISBTN(relatedIconPath)
            endif
            if GetLocalPlayer() == p then
                call BlzFrameSetEnable(FRAME_ShopItem[frameIndex], not relatedBanned)
                call BlzFrameSetTexture(FRAME_ShopItemBack[frameIndex], relatedIconPath, 0, false)
                call BlzFrameSetVisible(FRAME_ShopItemBack[frameIndex], true)
                call BlzFrameSetText(FRAME_ShopItemCost[frameIndex], costStr)
            endif
        endif
        set slot = slot + 1
    endloop

    if id == 'I009' or id == 'I002' or id == 'I003' then
        set ItemsCraftPlayerDebug_ID[pid] = 42
    elseif GetCraftUpgradeCount(id) > 0 or HasCraftComponents(id) then
        set ItemsCraftPlayerDebug_ID[pid] = -1
    endif
    set selectedUnit = null
endfunction

// ФИКС АСИНХРОНА UI. Теперь отправляем синхронизированный ивент.
function ShopCraftOnScroll takes nothing returns nothing
    local framehandle changedFrame = BlzGetTriggerFrame()
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local integer id = ItemsCurrentItem_ID[pid]
    local integer sliderValue = R2I(BlzGetTriggerFrameValue() + 0.50)
    local integer currentFrameValue
    local integer maxOffset
    local integer newOffset
    
    if id == 0 or ShopCraftScrollUpdating[pid] then
        set changedFrame = null
        set p = null
        return
    endif
    set currentFrameValue = R2I(BlzFrameGetValue(changedFrame) + 0.50)
    if sliderValue != currentFrameValue then
        set changedFrame = null
        set p = null
        return
    endif
    if changedFrame == FRAME_ShopCraftUpgradeScroll then
        set maxOffset = GetCraftMaxOffset(GetCraftUpgradeCount(id))
        set newOffset = sliderValue * 3
        if newOffset < 0 then
            set newOffset = 0
        elseif newOffset > maxOffset then
            set newOffset = maxOffset
        endif
        if newOffset != ShopCraftUpgradeOffset[pid] then
            call BlzSendSyncData("WScU", I2S(newOffset))
        endif
    elseif changedFrame == FRAME_ShopCraftComponentScroll then
        set maxOffset = GetCraftMaxOffset(GetCraftComponentCount(id))
        set newOffset = sliderValue * 3
        if newOffset < 0 then
            set newOffset = 0
        elseif newOffset > maxOffset then
            set newOffset = maxOffset
        endif
        if newOffset != ShopCraftComponentOffset[pid] then
            call BlzSendSyncData("WScC", I2S(newOffset))
        endif
    endif
    set changedFrame = null
    set p = null
endfunction

function ShopCraftOnWheel takes nothing returns nothing
    local framehandle hoveredFrame = BlzGetTriggerFrame()
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local integer id = ItemsCurrentItem_ID[pid]
    local integer frameCode = LoadInteger(ShopFrameTable, GetHandleId(hoveredFrame), 0)
    local integer upgradeCount = GetCraftUpgradeCount(id)
    local integer componentCount = GetCraftComponentCount(id)
    local integer maxOffset
    local integer newOffset
    local real wheelValue = BlzGetTriggerFrameValue()
    local boolean scrollUpgrades = (frameCode >= 236 and frameCode <= 238) or frameCode == 401 or frameCode == 403
    local boolean scrollComponents = (frameCode >= 239 and frameCode <= 241) or frameCode == 402 or frameCode == 404
    
    if id == 0 then
        set hoveredFrame = null
        set p = null
        return
    endif
    
    if frameCode == 400 then
        if upgradeCount > 3 and componentCount <= 3 then
            set scrollUpgrades = true
        elseif componentCount > 3 and upgradeCount <= 3 then
            set scrollComponents = true
        endif
    endif
    
    if scrollUpgrades and upgradeCount > 3 then
        set maxOffset = GetCraftMaxOffset(upgradeCount)
        set newOffset = ShopCraftUpgradeOffset[pid]
        if wheelValue < 0.00 then
            set newOffset = newOffset - 3
        elseif wheelValue > 0.00 then
            set newOffset = newOffset + 3
        endif
        if newOffset < 0 then
            set newOffset = 0
        elseif newOffset > maxOffset then
            set newOffset = maxOffset
        endif
        if newOffset != ShopCraftUpgradeOffset[pid] then
            call BlzSendSyncData("WScU", I2S(newOffset))
        endif
    elseif scrollComponents and componentCount > 3 then
        set maxOffset = GetCraftMaxOffset(componentCount)
        set newOffset = ShopCraftComponentOffset[pid]
        if wheelValue < 0.00 then
            set newOffset = newOffset - 3
        elseif wheelValue > 0.00 then
            set newOffset = newOffset + 3
        endif
        if newOffset < 0 then
            set newOffset = 0
        elseif newOffset > maxOffset then
            set newOffset = maxOffset
        endif
        if newOffset != ShopCraftComponentOffset[pid] then
            call BlzSendSyncData("WScC", I2S(newOffset))
        endif
    endif
    set hoveredFrame = null
    set p = null
endfunction

function ReloadItemPageCore takes integer page, player p, boolean showControls returns nothing
    local integer pid = GetPlayerId(p)
    local integer slot = 0
    local integer id
    local boolean banned
    local unit selectedUnit = GetSelectedHeroForPlayer(p)

    if showControls  and (CondArena == 0 or TestMode) then
        if GetLocalPlayer() == p then
            call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], true)
            call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], true)
        endif
    endif
    loop
        exitwhen slot == 35
        set id = ShopGetPlayerPageItem(page, pid, slot)
        set banned = id != 0 and CheckBanItems(id, selectedUnit)
        call ShopRenderCatalogueSlot(slot, id, banned, p)
        set slot = slot + 1
    endloop
    set selectedUnit = null
endfunction

function ReloadItemPage takes integer page, player p returns nothing
    call ReloadItemPageCore(page, p, true)
endfunction
function ReloadItemPage2 takes integer page, player p returns nothing
    call ReloadItemPageCore(page, p, false)
endfunction

function ShopUpdateCatalogueNavigation takes integer pid, player p returns nothing
    local integer section = ItemsFrameCurrentPage_ID[pid]
    local integer pageCount = 1
    local integer currentPage = 0
    local boolean visible
    local boolean canGoPrevious
    local boolean canGoNext
    local string pageStr = ""

    if section == SHOP_SEARCH_PAGE and ShopSearchActive[pid] then
        set pageCount = (ShopSearchResultCount[pid] + SHOP_SEARCH_PAGE_SIZE - 1) / SHOP_SEARCH_PAGE_SIZE
        set currentPage = ShopSearchPage[pid]
    elseif section >= 1 and section <= 6 then
        set pageCount = ShopGetSectionPageCount(section)
        set currentPage = ShopSectionPage[pid * 7 + section]
        if currentPage >= pageCount then
            set currentPage = pageCount - 1
            set ShopSectionPage[pid * 7 + section] = currentPage
        endif
    endif
    set visible = pageCount > 1
    set canGoPrevious = currentPage > 0
    set canGoNext = currentPage + 1 < pageCount
    set pageStr = "|c00FFFF00" + I2S(currentPage + 1) + "/" + I2S(pageCount) + "|r"
    
    // GetLocalPlayer используется только для локального изменения фреймов.
    // Все номера страниц и расчёты выше остаются синхронными и привязаны к pid.
    if GetLocalPlayer() == p then
        call BlzFrameSetVisible(FRAME_ShopSearchPrevious, visible)
        call BlzFrameSetVisible(FRAME_ShopSearchPreviousIcon, visible)
        call BlzFrameSetVisible(FRAME_ShopSearchNext, visible)
        call BlzFrameSetVisible(FRAME_ShopSearchNextIcon, visible)
        call BlzFrameSetVisible(FRAME_ShopSearchPageText, visible)
        if visible then
            call BlzFrameSetEnable(FRAME_ShopSearchPrevious, canGoPrevious)
            call BlzFrameSetEnable(FRAME_ShopSearchNext, canGoNext)
            if canGoPrevious then
                call BlzFrameSetAlpha(FRAME_ShopSearchPreviousIcon, 255)
            else
                call BlzFrameSetAlpha(FRAME_ShopSearchPreviousIcon, 90)
            endif
            if canGoNext then
                call BlzFrameSetAlpha(FRAME_ShopSearchNextIcon, 255)
            else
                call BlzFrameSetAlpha(FRAME_ShopSearchNextIcon, 90)
            endif
            call BlzFrameSetText(FRAME_ShopSearchPageText, pageStr)
        else
            call BlzFrameSetText(FRAME_ShopSearchPageText, "")
        endif
    endif
endfunction

function ShopDeactivateSearch takes player p, boolean clearText returns nothing
    local integer pid = GetPlayerId(p)
    if ShopSearchActive[pid] then
        set ShopSearchActive[pid] = false
        set ItemsFrameCurrentPage_ID[pid] = ShopSearchReturnPage[pid]
        call ReloadItemPage(ItemsFrameCurrentPage_ID[pid], p)
    endif
    set ShopSearchQuery[pid] = ""
    set ShopSearchPage[pid] = 0
    call ShopUpdateCatalogueNavigation(pid, p)
    set ShopSearchUpdating[pid] = true
    if clearText and GetLocalPlayer() == p then
        call BlzFrameSetText(FRAME_ShopSearchEditBox, "")
        call BlzFrameSetFocus(FRAME_ShopSearchEditBox, false)
    endif
    set ShopSearchUpdating[pid] = false
endfunction

// ФИКС ПОИСКА (Отправляем текст через SyncData)
function ShopSearchOnTextChanged takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local string enteredText = BlzGetTriggerFrameText()
    local string query = ShopSanitizeSearchQuery(enteredText)
    
    if ShopSearchUpdating[pid] then
        set p = null
        return
    endif
    if enteredText != query then
        set ShopSearchUpdating[pid] = true
        if GetLocalPlayer() == p then
            call BlzFrameSetText(FRAME_ShopSearchEditBox, query)
            call BlzFrameSetFocus(FRAME_ShopSearchEditBox, true)
        endif
        set ShopSearchUpdating[pid] = false
    endif
    
    call BlzSendSyncData("WScS", query)
    set p = null
endfunction

function CheckSlotAvailable takes unit c returns boolean
    local integer i = 0
    loop
        exitwhen i >= 6
        if UnitItemInSlot(c, i) == null then
            return true
        endif
        set i = i + 1
    endloop
    return false
endfunction

function ShopGetCraftDisplayItem takes integer pid, integer slot returns integer
    if slot == 0 then
        return ItemsCraftUpperLeft_ID[pid]
    elseif slot == 1 then
        return ItemsCraftUpperTop_ID[pid]
    elseif slot == 2 then
        return ItemsCraftUpperRight_ID[pid]
    elseif slot == 3 then
        return ItemsCraftLeft_ID[pid]
    elseif slot == 4 then
        return ItemsCraftBottom_ID[pid]
    elseif slot == 5 then
        return ItemsCraftRight_ID[pid]
    endif
    return 0
endfunction

function OnClickItem takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local integer frameCode = LoadInteger(ShopFrameTable, GetHandleId(clicked), 0)
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local integer slot
    local integer id = 0
    local integer value
    local integer baseCost
    local integer remainingCost
    local integer newSlot
    local integer refundSlot
    local integer refundCheck
    local integer section
    local integer pageCount
    local unit d = GetSelectedHeroForPlayer(p)
    local string costStr = ""
    local string iconPath = ""
    if frameCode == 242 then
        set clicked = null
        set d = null
        set p = null
        return
    endif
    if frameCode == 405 then
        call ShopDeactivateSearch(p, true)
        set clicked = null
        set d = null
        set p = null
        return
    endif
    if frameCode == 406 or frameCode == 407 then
        if ShopSearchActive[pid] then
            if frameCode == 406 and ShopSearchPage[pid] > 0 then
                set ShopSearchPage[pid] = ShopSearchPage[pid] - 1
            elseif frameCode == 407 and (ShopSearchPage[pid] + 1) * SHOP_SEARCH_PAGE_SIZE < ShopSearchResultCount[pid] then
                set ShopSearchPage[pid] = ShopSearchPage[pid] + 1
            endif
            call ShopFillSearchVisiblePage(pid)
            call ReloadItemPage(SHOP_SEARCH_PAGE, p)
        else
            set section = ItemsFrameCurrentPage_ID[pid]
            if section >= 1 and section <= 6 then
                set pageCount = ShopGetSectionPageCount(section)
                if frameCode == 406 and ShopSectionPage[pid * 7 + section] > 0 then
                    set ShopSectionPage[pid * 7 + section] = ShopSectionPage[pid * 7 + section] - 1
                elseif frameCode == 407 and ShopSectionPage[pid * 7 + section] + 1 < pageCount then
                    set ShopSectionPage[pid * 7 + section] = ShopSectionPage[pid * 7 + section] + 1
                endif
                call ReloadItemPage(section, p)
            endif
        endif
        call ShopUpdateCatalogueNavigation(pid, p)
        set clicked = null
        set d = null
        set p = null
        return
    endif

    if frameCode >= 100 and frameCode <= 106 then
        if ShopSearchActive[pid] then
            set ShopSearchActive[pid] = false
            set ShopSearchQuery[pid] = ""
            set ShopSearchPage[pid] = 0
            set ShopSearchUpdating[pid] = true
            if GetLocalPlayer() == p then
                call BlzFrameSetText(FRAME_ShopSearchEditBox, "")
                call BlzFrameSetFocus(FRAME_ShopSearchEditBox, false)
            endif
            set ShopSearchUpdating[pid] = false
        endif
        set ItemsFrameCurrentPage_ID[pid] = frameCode - 100
        set ShopSearchReturnPage[pid] = ItemsFrameCurrentPage_ID[pid]
        set ItemsCraftPlayerDebug_ID[pid] = -1
        call ReloadItemPage(ItemsFrameCurrentPage_ID[pid], p)
        call ShopUpdateCatalogueNavigation(pid, p)
        set clicked = null
        set d = null
        set p = null
        return
    endif

    if GetLocalPlayer() == p then
        call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00Item name|r")
        call BlzFrameSetText(FRAME_ShopItemDescriptionName2, "")
        call BlzFrameSetVisible(FRAME_ShopItemCraftSprite2, false)
    endif

    if frameCode >= 200 and frameCode <= 241 then
        set slot = frameCode - 200
        if slot < 35 then
            set id = ShopGetPlayerPageItem(ItemsFrameCurrentPage_ID[pid], pid, slot)
        elseif slot >= 36 then
            set id = ShopGetCraftDisplayItem(pid, slot - 36)
        endif
        if id != 0 then
            set ItemsCurrentItemBag_ID[pid] = 0
            set ItemsCraftPlayerDebug_ID[pid] = slot
            set ItemsCurrentItem_ID[pid] = id
            set ItemsCurrentItem_ID_BACKUP[pid] = id
            set value = CheckItemsReduceCostCraft(d, GetItemValue(id), id, false)
            set costStr = "|c00FFFF00" + I2S(value) + "|r"
            set iconPath = BlzGetAbilityIcon(id)
            if GetLocalPlayer() == p then
                if CondArena == 0 or TestMode == true then
                    call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], true)
                    call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], false)
                endif
                call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, true)
                call BlzFrameSetTexture(FRAME_ShopItemBack[42], iconPath, 0, false)
                call BlzFrameSetText(FRAME_ShopItemCost[42], costStr)
            endif
            call ShopShowItemDescription(id, p)
            call CraftItemCheck(id, p, ItemsFrameCurrentPage_ID[pid])
        endif
    endif

    if frameCode >= 300 and frameCode <= 305 then
        set slot = frameCode - 300
        if UnitItemInSlot(d, slot) != null then
            set id = GetItemTypeId(UnitItemInSlot(d, slot))
            set ItemsCurrentItem_ID[pid] = id
            set ItemsCurrentItemBag_ID[pid] = slot + 1
            set value = GetItemValue(id)
            set costStr = "|c00FFFF00" + I2S(value) + "|r"
            set iconPath = BlzGetAbilityIcon(id)
            if GetLocalPlayer() == p then
                if CondArena == 0 or TestMode == true then
                    call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], true)
                    call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], false)
                endif
                call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, false)
                call BlzFrameSetVisible(FRAME_ShopItemCraftSprite2, true)
                call BlzFrameSetTexture(FRAME_ShopItemBack[42], iconPath, 0, false)
                call BlzFrameSetText(FRAME_ShopItemCost[42], costStr)
                if slot == 0 then
                    call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, -0.025, 0.08)
                elseif slot == 1 then
                    call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, 0.0275, 0.08)
                elseif slot == 2 then
                    call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, -0.025, 0.025)
                elseif slot == 3 then
                    call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, 0.0275, 0.025)
                elseif slot == 4 then
                    call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, -0.025, -0.03)
                else
                    call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, 0.0275, -0.03)
                endif
            endif
            call ShopShowItemDescription(id, p)
            call CraftItemCheck(id, p, ItemsFrameCurrentPage_ID[pid])
        endif
    endif

    if frameCode == 306 then
        set id = ItemsCurrentItem_ID[pid]
        if id != 0 then
            set iconPath = BlzGetAbilityIcon(id)
            if GetLocalPlayer() == p then
                call BlzFrameSetTexture(FRAME_ShopItemBack[42], iconPath, 0, false)
            endif
            call ShopShowItemDescription(id, p)
            if IsItemInInventory(d, id) > 0 then
                call StartSoundForPlayerBJ(p, gg_snd_UpkeepRing)
                call DisplayTimedTextToPlayer(p, 0, 0, 2, "|c00FF0303You already have this item!|r")
            else
                set baseCost = GetItemValue(id)
                set remainingCost = CheckItemsReduceCostCraft(d, baseCost, id, false)
                if remainingCost < baseCost or CheckSlotAvailable(d) then
                    if GetGold(p) >= remainingCost then
                        call CheckItemsReduceCostCraft(d, baseCost, id, true)
                        call AddGold(p, remainingCost, false)
                        call UnitAddItemById(d, id)
                        set newSlot = IsItemInInventory3(d, id)
                        if newSlot != -1 and remainingCost == baseCost then
                            call SaveInteger(hs, GetHandleId(d), StringHash("fullrefund_" + I2S(newSlot)), id)
                            call MyFlush(GetHandleId(d), StringHash("fullrefund_" + I2S(newSlot)), 0, Refund100Time)
                        endif
                        set costStr = "|c00FFFF00" + I2S(baseCost) + "|r"
                        if GetLocalPlayer() == p then
                            call BlzFrameSetText(FRAME_ShopItemCost[42], costStr)
                            call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, true)
                        endif
                        call StartSoundForPlayerBJ(p, gg_snd_AlchemistTransmuteDeath1)
                        call ReloadItemPage2(ItemsFrameCurrentPage_ID[pid], p)
                    else
                        call StartSoundForPlayerBJ(p, gg_snd_SadTrombone)
                        call DisplayTimedTextToPlayer(p, 0, 0, 1, "|c00FF0303Not enough gold|r")
                    endif
                else
                    call StartSoundForPlayerBJ(p, gg_snd_Error)
                endif
            endif
            call CraftItemCheck(id, p, ItemsFrameCurrentPage_ID[pid])
        endif
    endif

    if frameCode == 307 and ItemsCurrentItemBag_ID[pid] != 0 and UnitItemInSlot(d, ItemsCurrentItemBag_ID[pid] - 1) != null then
        set id = ItemsCurrentItem_ID[pid]
        set baseCost = GetItemValue(id)
        set value = GetItemValue(ItemsCurrentItem_ID_BACKUP[pid])
        call SaveInteger(hs, GetHandleId(d), StringHash("sold cd"), 1)
        call MyFlush(GetHandleId(d), StringHash("sold cd"), 1, 0.1)
        set refundSlot = ItemsCurrentItemBag_ID[pid] - 1
        set refundCheck = LoadInteger(hs, GetHandleId(d), StringHash("fullrefund_" + I2S(refundSlot)))
        if refundCheck == id then
            call AddGold(p, baseCost, true)
            call RemoveSavedInteger(hs, GetHandleId(d), StringHash("fullrefund_" + I2S(refundSlot)))
        else
            call AddGold(p, R2I(baseCost * (RefundPercent/100)), true)
        endif
        call RemoveItem(UnitItemInSlot(d, refundSlot))
        call RefreshItemCache2(d)
        set ItemsCurrentItem_ID[pid] = ItemsCurrentItem_ID_BACKUP[pid]
        set costStr = "|c00FFFF00" + I2S(value) + "|r"
        set iconPath = BlzGetAbilityIcon(ItemsCurrentItem_ID[pid])
        if GetLocalPlayer() == p then
            call BlzFrameSetTexture(FRAME_ShopItemBack[42], iconPath, 0, false)
            call BlzFrameSetText(FRAME_ShopItemCost[42], costStr)
            call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], false)
            call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], true)
            call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, true)
        endif
        call StartSoundForPlayerBJ(p, gg_snd_ReceiveGold)
        call ShopShowItemDescription(ItemsCurrentItem_ID[pid], p)
        call CraftItemCheck(ItemsCurrentItem_ID[pid], p, ItemsFrameCurrentPage_ID[pid])
        call ReloadItemPage2(ItemsFrameCurrentPage_ID[pid], p)
    endif

    set clicked = null
    set d = null
    set p = null
endfunction

function BuyAuto takes unit c, integer id returns nothing
    local player p = GetOwningPlayer(c)
    local integer pGold = GetGold(p)
    local integer cost = GetItemValue(id)
    local integer remainingCost
    local integer componentCount
    local integer componentIndex = 0
    local integer componentId
    local boolean canAssemble = false
    if id == 0 or IsItemInInventory(c, id) > 0 then
        set p = null
        return
    endif
    set componentCount = GetCraftComponentCount(id)
    loop
        exitwhen componentIndex >= componentCount
        set componentId = GetCraftComponent(id, componentIndex)
        call BuyAuto(c, componentId)
        set componentIndex = componentIndex + 1
    endloop
    set remainingCost = CheckItemsReduceCostCraft(c, cost, id, false)
    set pGold = GetGold(p)
    if pGold >= remainingCost then
        set canAssemble = CheckSlotAvailable(c)
        if not canAssemble and HasCraftComponents(id) then
            set componentIndex = 0
            loop
                exitwhen componentIndex >= componentCount or canAssemble
                set componentId = GetCraftComponent(id, componentIndex)
                if IsItemInInventory(c, componentId) > 0 then
                    set canAssemble = true
                endif
                set componentIndex = componentIndex + 1
            endloop
        endif
        if canAssemble then
            call AddGold(p, remainingCost, false) 
            call CheckItemsReduceCostCraft(c, cost, id, true) 
            call UnitAddItemById(c, id) 
            call StartSoundForPlayerBJ(p, gg_snd_AlchemistTransmuteDeath1)
        endif
    endif
    set p = null
endfunction

// Одноразовая стартовая покупка использует отдельный жёсткий лимит.
// Каждое добавление предмета, включая сборку результата, расходует единицу лимита.
function BuyAutoLimited takes unit c, integer id, integer remaining returns integer
    local player p = GetOwningPlayer(c)
    local integer pGold
    local integer cost
    local integer remainingCost
    local integer componentCount
    local integer componentIndex = 0
    local integer componentId
    local boolean canAssemble = false

    if remaining <= 0 or id == 0 or IsItemInInventory(c, id) > 0 then
        set p = null
        return remaining
    endif

    set cost = GetItemValue(id)
    set componentCount = GetCraftComponentCount(id)
    loop
        exitwhen componentIndex >= componentCount or remaining <= 0
        set componentId = GetCraftComponent(id, componentIndex)
        set remaining = BuyAutoLimited(c, componentId, remaining)
        set componentIndex = componentIndex + 1
    endloop

    if remaining <= 0 then
        set p = null
        return remaining
    endif

    set remainingCost = CheckItemsReduceCostCraft(c, cost, id, false)
    set pGold = GetGold(p)
    if pGold >= remainingCost then
        set canAssemble = CheckSlotAvailable(c)
        if not canAssemble and HasCraftComponents(id) then
            set componentIndex = 0
            loop
                exitwhen componentIndex >= componentCount or canAssemble
                set componentId = GetCraftComponent(id, componentIndex)
                if IsItemInInventory(c, componentId) > 0 then
                    set canAssemble = true
                endif
                set componentIndex = componentIndex + 1
            endloop
        endif
        if canAssemble then
            call AddGold(p, remainingCost, false)
            call CheckItemsReduceCostCraft(c, cost, id, true)
            call UnitAddItemById(c, id)
            call StartSoundForPlayerBJ(p, gg_snd_AlchemistTransmuteDeath1)
            set remaining = remaining - 1
        endif
    endif

    set p = null
    return remaining
endfunction

// Добавляет игроку не более двух предметов при первой закупке.
function FirstRoundAutoBuyOnce takes unit c, integer pid returns nothing
    local integer index = 0
    local integer itemId

    loop
        exitwhen index >= SHOP_RECOMMENDED_COUNT
        set itemId = ItemsPage0_ID[pid * SHOP_SEARCH_PAGE_SIZE + index]
        if itemId == 0 then
            return
        endif
        exitwhen IsItemInInventory(c, itemId) == 0
        set index = index + 1
    endloop

    if index < SHOP_RECOMMENDED_COUNT then
        call BuyAutoLimited(c, itemId, SHOP_FIRST_ROUND_BUY_LIMIT)
    endif
endfunction

// Прямой принудительный запуск для всех игроков. Функция сама защищена
// от повторного вызова и не оставляет активного фонового режима.
function ShopForceFirstRoundAutoBuy takes nothing returns nothing
    local integer pid = 0
    local unit c

    if ShopFirstRoundAutoBuyDone or Round1Started != 1 or CurrentRound != 1 or TestMode then
        return
    endif
    set ShopFirstRoundAutoBuyDone = true

    loop
        exitwhen pid >= 10
        if IsActivePlayerSlot(pid) and Hero[pid] != null then
            set c = Hero[pid]
            if GetOwningPlayer(c) == Player(pid) and GetGold(Player(pid)) >= 2500 and ItemsPage0_ID[pid * SHOP_SEARCH_PAGE_SIZE] != 0 then
                call FirstRoundAutoBuyOnce(c, pid)
            endif
        endif
        set pid = pid + 1
    endloop

    set c = null
endfunction

function ResetRecommendedAutoBuy takes integer pid, unit c returns nothing
    set AutoBuyRecommendedIndex[pid] = 0
    set AutoBuyRecommendedDone[pid] = false
    if c == null then
        set AutoBuyRecommendedUnitId[pid] = 0
    else
        set AutoBuyRecommendedUnitId[pid] = GetHandleId(c)
    endif
endfunction

function RecommendedAutoBuyTick takes unit c, integer pid returns nothing
    local integer index = AutoBuyRecommendedIndex[pid]
    local integer itemId

    if AutoBuyRecommendedDone[pid] then
        return
    endif

    // Already completed recommendations are skipped. A zero slot means that
    // RecommenedItems has not populated the six-item queue yet, so we wait.
    loop
        exitwhen index >= SHOP_RECOMMENDED_COUNT
        set itemId = ItemsPage0_ID[pid * 35 + index]
        if itemId == 0 then
            set AutoBuyRecommendedIndex[pid] = index
            return
        endif
        exitwhen IsItemInInventory(c, itemId) == 0
        set index = index + 1
    endloop

    set AutoBuyRecommendedIndex[pid] = index
    if index >= SHOP_RECOMMENDED_COUNT then
        set AutoBuyRecommendedDone[pid] = true
        return
    endif

    // BuyAuto recursively assembles only this target and all of its parts.
    // The next recommendation is never touched by this timer tick.
    call BuyAuto(c, itemId)

    if IsItemInInventory(c, itemId) > 0 then
        set index = index + 1
        set AutoBuyRecommendedIndex[pid] = index
        if index >= SHOP_RECOMMENDED_COUNT then
            set AutoBuyRecommendedDone[pid] = true
        endif
    endif
endfunction

function SetInventoryDescriptionId takes integer pid, integer slot, integer id returns nothing
    if slot == 0 then
        set ItemsCurrentItemBagDescription_ID0[pid] = id
    elseif slot == 1 then
        set ItemsCurrentItemBagDescription_ID1[pid] = id
    elseif slot == 2 then
        set ItemsCurrentItemBagDescription_ID2[pid] = id
    elseif slot == 3 then
        set ItemsCurrentItemBagDescription_ID3[pid] = id
    elseif slot == 4 then
        set ItemsCurrentItemBagDescription_ID4[pid] = id
    else
        set ItemsCurrentItemBagDescription_ID5[pid] = id
    endif
endfunction

function PlayerInventoryPeriodic takes nothing returns nothing
    local player p
    local integer pid
    local integer playerNumber = 1
    local integer slot
    local integer cacheIndex
    local integer id
    local integer cost
    local integer refundFlag
    local unit u
    local string invCost1
    local string invCost2
    local string tooltipNameStr
    local string itemName
    local string iconPath
    local real tooltipWidth
    local framehandle tooltip

    loop
        exitwhen playerNumber > 10
        set pid = playerNumber - 1
        set p = Player(pid)

        if ShopSearchActive[pid] and not Shop_Active[pid] then
            call ShopDeactivateSearch(p, true)
        endif

        if Shop_Active[pid] and IsActivePlayerSlot(pid) and Hero[pid] != null then
            set u = GetSelectedHeroForPlayer(p)

            // При смене выделенного героя сразу обновляем ограничения каталога
            // и запрещаем продать предмет из ранее показанного инвентаря.
            if ShopTargetUnitId[pid] != GetHandleId(u) then
                set ShopTargetUnitId[pid] = GetHandleId(u)
                set ItemsCurrentItemBag_ID[pid] = 0
                call ReloadItemPage2(ItemsFrameCurrentPage_ID[pid], p)
                if GetLocalPlayer() == p then
                    call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], false)
                    if ItemsCurrentItem_ID[pid] != 0 and (CondArena == 0 or TestMode) then
                        call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], true)
                    endif
                endif
            endif

            set slot = 0
            loop
                exitwhen slot >= 6
                set id = ShopGetInventoryItemId(u, slot)
                set refundFlag = 0
                set tooltipNameStr = ""
                set invCost1 = ""
                set invCost2 = ""
                set itemName = ""
                set iconPath = "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder"
                set tooltipWidth = ShopGetItemTooltipWidth("")
                set tooltip = BlzFrameGetParent(FRAME_ShopInventoryTooltipText[slot])
                
                if id != 0 then
                    set refundFlag = LoadInteger(hs, GetHandleId(u), ShopRefundKey[slot])
                    set cost = GetItemValue(id)
                    set invCost1 = "|c0000FF00" + I2S(cost) + "|r"
                    set invCost2 = "|c00FFFF00" + I2S(R2I(cost * (RefundPercent/100))) + "|r"
                    set itemName = GetObjectName(id)
                    set tooltipNameStr = "|cffffffff" + itemName + "|r"
                    set iconPath = BlzGetAbilityIcon(id)
                    set tooltipWidth = ShopGetItemTooltipWidth(itemName)
                else
                    set cost = 0
                endif
                
                set cacheIndex = pid * 6 + slot
                
                if GetLocalPlayer() == p then
                    if ShopInventoryLastId[cacheIndex] != id then
                        if id == 0 then
                            call BlzFrameSetText(FRAME_ShopInventoryTooltipText[slot], "")
                            call BlzFrameSetSize(tooltip, tooltipWidth, 0.020)
                            call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[slot], false)
                            call BlzFrameSetTexture(FRAME_ShopItemInventorySlotBack[slot], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
                        else
                            call BlzFrameSetSize(tooltip, tooltipWidth, 0.020)
                            call BlzFrameSetText(FRAME_ShopInventoryTooltipText[slot], tooltipNameStr)
                            call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[slot], true)
                            call BlzFrameSetTexture(FRAME_ShopItemInventorySlotBack[slot], iconPath, 0, false)
                        endif
                    endif
                    if ShopInventoryLastId[cacheIndex] != id or ShopInventoryLastRefund[cacheIndex] != refundFlag then
                        if id == 0 then
                            call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[slot], "")
                        else
                            if refundFlag == id then
                                call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[slot], invCost1)
                            else
                                call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[slot], invCost2)
                            endif
                        endif
                    endif
                endif
                set ShopInventoryLastId[cacheIndex] = id
                set ShopInventoryLastRefund[cacheIndex] = refundFlag
                set slot = slot + 1
            endloop
        endif
        set playerNumber = playerNumber + 1
    endloop
    set tooltip = null
    set u = null
    set p = null
endfunction

function AutoBuyPeriodic takes nothing returns nothing
    local integer playerNumber = 1
    local integer pid
    local unit c
    loop
        exitwhen playerNumber > 10
        set pid = playerNumber - 1
        if IsActivePlayerSlot(pid) and Hero[pid] != null then
            set c = Hero[pid]
            if AutoBuyRecommendedUnitId[pid] != GetHandleId(c) then
                call ResetRecommendedAutoBuy(pid, c)
            endif
            // Старая рабочая схема: значение хранится отдельно под handle игрока.
            if LoadInteger(hs, GetHandleId(Player(pid)), StringHash("autobuy")) == 1 and GetOwningPlayer(c) == Player(pid) and not AutoBuyRecommendedDone[pid] and CondArena == 0 and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) then
                call RecommendedAutoBuyTick(c, pid)
            endif
        endif
        set playerNumber = playerNumber + 1
    endloop
    set c = null
endfunction

function FrameShopCheckboxCheck takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local integer pid = GetPlayerId(GetTriggerPlayer())
    if clicked == FRAME_AutoBuyCheckbox then
        if pid >= 0 and pid < 10 and IsActivePlayerSlot(pid) then
            if BlzGetTriggerFrameEvent() == FRAMEEVENT_CHECKBOX_CHECKED then
                if LoadInteger(hs, GetHandleId(Player(pid)), StringHash("autobuy")) != 1 then
                    call ResetRecommendedAutoBuy(pid, Hero[pid])
                endif
                call SaveInteger(hs, GetHandleId(Player(pid)), StringHash("autobuy"), 1)
            else
                call SaveInteger(hs, GetHandleId(Player(pid)), StringHash("autobuy"), 0)
            endif
        endif
    endif
    set clicked = null
endfunction

// ФИКС АСИНХРОНА: Этот обработчик ловит события UI и меняет глобальные данные.
// Opens the exact item selected in career statistics. All catalogue and
// selection state is prepared synchronously; the local branch draws frames only.
function ShopOpenCareerItem takes integer itemId, player p returns nothing
    local integer pid = GetPlayerId(p)
    local integer value
    local string costStr
    local string iconPath = ""
    local unit d = GetSelectedHeroForPlayer(p)
    if itemId == 0 or pid < 0 or pid > 9 or not ShopUICreated or d == null then
        set d = null
        return
    endif
    if not ShopSearchActive[pid] then
        set ShopSearchReturnPage[pid] = ItemsFrameCurrentPage_ID[pid]
    endif
    set ShopSearchActive[pid] = true
    set ShopSearchQuery[pid] = GetObjectName(itemId)
    set ShopSearchPage[pid] = 0
    set ShopSearchResultCount[pid] = 1
    set ItemsSearchAll_ID[pid*SHOP_SEARCH_MAX_RESULTS] = itemId
    call ShopFillSearchVisiblePage(pid)
    set ItemsFrameCurrentPage_ID[pid] = SHOP_SEARCH_PAGE

    set ItemsCurrentItemBag_ID[pid] = 0
    set ItemsCraftPlayerDebug_ID[pid] = 0
    set ItemsCurrentItem_ID[pid] = itemId
    set ItemsCurrentItem_ID_BACKUP[pid] = itemId
    set value = CheckItemsReduceCostCraft(d, GetItemValue(itemId), itemId, false)
    set costStr = "|c00FFFF00" + I2S(value) + "|r"
    set iconPath = BlzGetAbilityIcon(itemId)
    set Shop_Active[pid] = true

    call ReloadItemPage(SHOP_SEARCH_PAGE, p)
    call ShopUpdateCatalogueNavigation(pid, p)
    call ShopShowItemDescription(itemId, p)
    call CraftItemCheck(itemId, p, SHOP_SEARCH_PAGE)
    if GetLocalPlayer() == p then
        call BlzFrameSetText(FRAME_ShopSearchEditBox, ShopSearchQuery[pid])
        call BlzFrameSetFocus(FRAME_ShopSearchEditBox, false)
        if CondArena == 0 or TestMode then
            call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], true)
            call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], false)
        endif
        call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, true)
        call BlzFrameSetTexture(FRAME_ShopItemBack[42], iconPath, 0, false)
        call BlzFrameSetText(FRAME_ShopItemCost[42], costStr)
        call BlzFrameSetVisible(FRAME_ShopMAIN, true)
    endif
    set d = null
endfunction

function SyncDataHandler takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local string prefix = BlzGetTriggerSyncPrefix()
    local string data = BlzGetTriggerSyncData()
    local integer val = S2I(data)
    local integer id = ItemsCurrentItem_ID[pid]
    
    if prefix == "WScO" then
        call ShopOpenCareerItem(val, p)
    elseif prefix == "WScU" then
        set ShopCraftUpgradeOffset[pid] = val
        call ShopSaveCraftScrollState(pid, id)
        call CraftItemCheck(id, p, ItemsFrameCurrentPage_ID[pid])
    elseif prefix == "WScC" then
        set ShopCraftComponentOffset[pid] = val
        call ShopSaveCraftScrollState(pid, id)
        call CraftItemCheck(id, p, ItemsFrameCurrentPage_ID[pid])
    elseif prefix == "WScS" then
        set ShopSearchQuery[pid] = data
        if StringLength(data) == 0 then
            call ShopDeactivateSearch(p, false)
        else
            if not ShopSearchActive[pid] then
                set ShopSearchReturnPage[pid] = ItemsFrameCurrentPage_ID[pid]
                set ShopSearchActive[pid] = true
            endif
            set ItemsFrameCurrentPage_ID[pid] = SHOP_SEARCH_PAGE
            set ShopSearchPage[pid] = 0
            call ShopBuildSearchResults(pid, data)
            call ReloadItemPage(SHOP_SEARCH_PAGE, p)
            call ShopUpdateCatalogueNavigation(pid, p)
        endif
    endif
endfunction

function CreateItemUI takes nothing returns nothing
    local integer i = 1
    local integer pid
    local integer i2 = 0
    local integer k = 0
    local real x = 0.015
    local real y = -0.05
    local framehandle border
    if ShopUICreated then
        return
    endif
    
    set SyncTrigger = CreateTrigger()
    set i = 0
    loop
        exitwhen i > 23
        call BlzTriggerRegisterPlayerSyncEvent(SyncTrigger, Player(i), "WScU", false)
        call BlzTriggerRegisterPlayerSyncEvent(SyncTrigger, Player(i), "WScC", false)
        call BlzTriggerRegisterPlayerSyncEvent(SyncTrigger, Player(i), "WScS", false)
        call BlzTriggerRegisterPlayerSyncEvent(SyncTrigger, Player(i), "WScO", false)
        set i = i + 1
    endloop
    call TriggerAddAction(SyncTrigger, function SyncDataHandler)
    set i = 1

    loop
        exitwhen i > 10
        set pid = i - 1
        set AutoBuyRecommendedIndex[pid] = 0
        set AutoBuyRecommendedUnitId[pid] = 0
        set AutoBuyRecommendedDone[pid] = false
        call SaveInteger(hs, GetHandleId(Player(pid)), StringHash("autobuy"), 0)
        set ShopCraftUpgradeOffset[pid] = 0
        set ShopCraftComponentOffset[pid] = 0
        set ShopCraftScrollItemId[pid] = 0
        set ShopCraftUpgradeMaxPage[pid] = -1
        set ShopCraftComponentMaxPage[pid] = -1
        set ShopCraftScrollUpdating[pid] = false
        set ShopSearchActive[pid] = false
        set ShopSearchUpdating[pid] = false
        set ItemsFrameCurrentPage_ID[pid] = 0
        set ShopSearchReturnPage[pid] = 0
        set ShopSearchResultCount[pid] = 0
        set ShopSearchPage[pid] = 0
        set ShopSearchQuery[pid] = ""
        set i2 = 0
        loop
            exitwhen i2 >= 7
            set ShopSectionPage[pid * 7 + i2] = 0
            set i2 = i2 + 1
        endloop
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 60
        set ShopInventoryLastId[i] = -1
        set ShopInventoryLastRefund[i] = -1
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 6
        set ShopRefundKey[i] = StringHash("fullrefund_" + I2S(i))
        set i = i + 1
    endloop
    set i = 0
    set FrameClick2 = CreateTrigger()
    set FrameShopCheckbox = CreateTrigger()
    set FrameCraftScroll = CreateTrigger()
    set FrameCraftWheel = CreateTrigger()
    set FrameShopSearch = CreateTrigger()
    call MyItemsIdInit()
    call InitCraftRecipes()
    set FRAME_ShopMAIN = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopMAIN, FRAMEPOINT_CENTER, 0.42, 0.33)
    call BlzFrameSetSize(FRAME_ShopMAIN, 0.96, 0.36)
    set FRAME_ShopItemList = BlzCreateFrame("EscMenuBackdrop", FRAME_ShopMAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopItemList, FRAMEPOINT_CENTER, 0.31, 0.355)
    call BlzFrameSetTexture(FRAME_ShopItemList, "textures\\black32.blp", 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemList, 155)
    call BlzFrameSetSize(FRAME_ShopItemList, 0.38, 0.28)
    set FRAME_ShopItemCraft = BlzCreateFrame("EscMenuBackdrop", FRAME_ShopMAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopItemCraft, FRAMEPOINT_CENTER, 0.5775, 0.405)
    call BlzFrameSetTexture(FRAME_ShopItemCraft, "textures\\black32.blp", 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemCraft, 155)
    call BlzFrameSetSize(FRAME_ShopItemCraft, 0.18, 0.18)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopItemCraft), 0, 400)
    call BlzFrameSetEnable(FRAME_ShopItemCraft, true)
    call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopItemCraft, FRAMEEVENT_MOUSE_WHEEL)
    
    set FRAME_ShopCraftUpgradeWheelArea = BlzCreateFrameByType("BUTTON", "ShopCraftUpgradeWheelArea", FRAME_ShopItemCraft, "", 5101)
    call BlzFrameSetPoint(FRAME_ShopCraftUpgradeWheelArea, FRAMEPOINT_TOPLEFT, FRAME_ShopItemCraft, FRAMEPOINT_TOPLEFT, 0.003, -0.003)
    call BlzFrameSetSize(FRAME_ShopCraftUpgradeWheelArea, 0.174, 0.080)
    call BlzFrameSetAlpha(FRAME_ShopCraftUpgradeWheelArea, 0)
    call BlzFrameSetLevel(FRAME_ShopCraftUpgradeWheelArea, 1)
    call BlzFrameSetEnable(FRAME_ShopCraftUpgradeWheelArea, true)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopCraftUpgradeWheelArea), 0, 403)
    call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopCraftUpgradeWheelArea, FRAMEEVENT_MOUSE_WHEEL)
    set FRAME_ShopCraftComponentWheelArea = BlzCreateFrameByType("BUTTON", "ShopCraftComponentWheelArea", FRAME_ShopItemCraft, "", 5102)
    call BlzFrameSetPoint(FRAME_ShopCraftComponentWheelArea, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemCraft, FRAMEPOINT_BOTTOMLEFT, 0.003, 0.003)
    call BlzFrameSetSize(FRAME_ShopCraftComponentWheelArea, 0.174, 0.065)
    call BlzFrameSetAlpha(FRAME_ShopCraftComponentWheelArea, 0)
    call BlzFrameSetLevel(FRAME_ShopCraftComponentWheelArea, 1)
    call BlzFrameSetEnable(FRAME_ShopCraftComponentWheelArea, true)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopCraftComponentWheelArea), 0, 404)
    call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopCraftComponentWheelArea, FRAMEEVENT_MOUSE_WHEEL)
    set FRAME_ShopItemDescription = BlzCreateFrame("EscMenuBackdrop", FRAME_ShopMAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopItemDescription, FRAMEPOINT_CENTER, 0.5775, 0.2725)
    call BlzFrameSetTexture(FRAME_ShopItemDescription, "textures\\black32.blp", 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemDescription, 155)
    call BlzFrameSetSize(FRAME_ShopItemDescription, 0.18, 0.115)
    set FRAME_ShopItemDescriptionName = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemDescription, "", 0)
    call BlzFrameSetPoint(FRAME_ShopItemDescriptionName, FRAMEPOINT_BOTTOM, FRAME_ShopItemDescription, FRAMEPOINT_TOP, 0, -0.0225 )
    call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00Item name|r")
    set FRAME_ShopItemDescriptionName2 = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemDescription, "", 0)
    call BlzFrameSetSize(FRAME_ShopItemDescriptionName2, 0.15, 0.08)
    call BlzFrameSetPoint(FRAME_ShopItemDescriptionName2, FRAMEPOINT_BOTTOM, FRAME_ShopItemDescription, FRAMEPOINT_CENTER, 0, -0.045 )
    call BlzFrameSetText(FRAME_ShopItemDescriptionName2, "|c00FFFF00|r")
    set FRAME_ShopItemInventory = BlzCreateFrame("EscMenuBackdrop", FRAME_ShopMAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopItemInventory, FRAMEPOINT_CENTER, 0.7225, 0.355)
    call BlzFrameSetTexture(FRAME_ShopItemInventory, "textures\\black32.blp", 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemInventory, 155)
    call BlzFrameSetSize(FRAME_ShopItemInventory, 0.135, 0.28)
    set FRAME_ShopItemInventoryName = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemInventory, "", 0)
    call BlzFrameSetPoint(FRAME_ShopItemInventoryName, FRAMEPOINT_BOTTOM, FRAME_ShopItemInventory, FRAMEPOINT_TOP, 0, -0.025 )
    call BlzFrameSetText(FRAME_ShopItemInventoryName, "|c00FFFF00Inventory|r")
    set FRAME_ShopSearchLabel = BlzCreateFrameByType("TEXT", "ShopSearchLabel", FRAME_ShopMAIN, "", 0)
    call BlzFrameSetAbsPoint(FRAME_ShopSearchLabel, FRAMEPOINT_CENTER, 0.145, 0.185)
    call BlzFrameSetSize(FRAME_ShopSearchLabel, 0.050, 0.020)
    call BlzFrameSetTextAlignment(FRAME_ShopSearchLabel, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_RIGHT)
    call BlzFrameSetScale(FRAME_ShopSearchLabel, 1.10)
    call BlzFrameSetText(FRAME_ShopSearchLabel, "|c00FFD700Search:|r")
    set FRAME_ShopSearchEditBox = BlzCreateFrame("EscMenuEditBoxTemplate", FRAME_ShopMAIN, 0, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopSearchEditBox, FRAMEPOINT_CENTER, 0.285, 0.185)
    call BlzFrameSetSize(FRAME_ShopSearchEditBox, 0.195, 0.030)
    call BlzFrameSetAlpha(FRAME_ShopSearchEditBox, 220)
    call BlzFrameSetText(FRAME_ShopSearchEditBox, "")
    call BlzFrameSetTextSizeLimit(FRAME_ShopSearchEditBox, 48)
    call BlzTriggerRegisterFrameEvent(FrameShopSearch, FRAME_ShopSearchEditBox, FRAMEEVENT_EDITBOX_TEXT_CHANGED)
    
    set FRAME_ShopSearchClear = BlzCreateFrameByType("BUTTON", "ShopSearchClear", FRAME_ShopMAIN, "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetAbsPoint(FRAME_ShopSearchClear, FRAMEPOINT_CENTER, 0.398, 0.185)
    call BlzFrameSetSize(FRAME_ShopSearchClear, 0.020, 0.020)
    set FRAME_ShopSearchClearIcon = BlzCreateFrameByType("BACKDROP", "ShopSearchClearIcon", FRAME_ShopSearchClear, "", 0)
    call BlzFrameSetAllPoints(FRAME_ShopSearchClearIcon, FRAME_ShopSearchClear)
    call BlzFrameSetTexture(FRAME_ShopSearchClearIcon, "Music\\Music_Close.blp", 0, true)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopSearchClear), 0, 405)
    call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopSearchClear, FRAMEEVENT_CONTROL_CLICK)
    set FRAME_ShopSearchPrevious = BlzCreateFrameByType("BUTTON", "ShopSearchPrevious", FRAME_ShopMAIN, "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetAbsPoint(FRAME_ShopSearchPrevious, FRAMEPOINT_CENTER, 0.278, 0.215)
    call BlzFrameSetSize(FRAME_ShopSearchPrevious, 0.018, 0.018)
    set FRAME_ShopSearchPreviousIcon = BlzCreateFrameByType("BACKDROP", "ShopSearchPreviousIcon", FRAME_ShopSearchPrevious, "", 0)
    call BlzFrameSetAllPoints(FRAME_ShopSearchPreviousIcon, FRAME_ShopSearchPrevious)
    call BlzFrameSetTexture(FRAME_ShopSearchPreviousIcon, "Music\\Music_SkipLeft.blp", 0, true)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopSearchPrevious), 0, 406)
    call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopSearchPrevious, FRAMEEVENT_CONTROL_CLICK)
    set FRAME_ShopSearchPageText = BlzCreateFrameByType("TEXT", "ShopSearchPageText", FRAME_ShopMAIN, "", 0)
    call BlzFrameSetAbsPoint(FRAME_ShopSearchPageText, FRAMEPOINT_CENTER, 0.310, 0.215)
    call BlzFrameSetSize(FRAME_ShopSearchPageText, 0.038, 0.016)
    call BlzFrameSetTextAlignment(FRAME_ShopSearchPageText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(FRAME_ShopSearchPageText, 0.90)
    call BlzFrameSetText(FRAME_ShopSearchPageText, "")
    set FRAME_ShopSearchNext = BlzCreateFrameByType("BUTTON", "ShopSearchNext", FRAME_ShopMAIN, "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetAbsPoint(FRAME_ShopSearchNext, FRAMEPOINT_CENTER, 0.342, 0.215)
    call BlzFrameSetSize(FRAME_ShopSearchNext, 0.018, 0.018)
    set FRAME_ShopSearchNextIcon = BlzCreateFrameByType("BACKDROP", "ShopSearchNextIcon", FRAME_ShopSearchNext, "", 0)
    call BlzFrameSetAllPoints(FRAME_ShopSearchNextIcon, FRAME_ShopSearchNext)
    call BlzFrameSetTexture(FRAME_ShopSearchNextIcon, "Music\\Music_SkipRight.blp", 0, true)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopSearchNext), 0, 407)
    call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopSearchNext, FRAMEEVENT_CONTROL_CLICK)
    call BlzFrameSetVisible(FRAME_ShopSearchPrevious, false)
    call BlzFrameSetVisible(FRAME_ShopSearchPreviousIcon, false)
    call BlzFrameSetVisible(FRAME_ShopSearchNext, false)
    call BlzFrameSetVisible(FRAME_ShopSearchNextIcon, false)
    call BlzFrameSetVisible(FRAME_ShopSearchPageText, false)
    set FRAME_ShopItemCraftSprite = BlzCreateFrameByType("SPRITE", "justAName", FRAME_ShopItemCraft, "WarCraftIIILogo", 0)
    call BlzFrameSetPoint(FRAME_ShopItemCraftSprite, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemCraft, FRAMEPOINT_CENTER, 0.0, 0.0)
    call BlzFrameSetSize(FRAME_ShopItemCraftSprite, 1., 1.)
    call BlzFrameSetScale(FRAME_ShopItemCraftSprite, 1.)
    call BlzFrameSetModel(FRAME_ShopItemCraftSprite, "Pick\\selecter5.mdx", 0)
    call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, false)
    set FRAME_ShopItemCraftSprite2 = BlzCreateFrameByType("SPRITE", "justAName", FRAME_ShopItemInventory, "WarCraftIIILogo", 0)
    call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, -0.025, 0.08)
    call BlzFrameSetSize(FRAME_ShopItemCraftSprite2, 1., 1.)
    call BlzFrameSetScale(FRAME_ShopItemCraftSprite2, 1.)
    call BlzFrameSetModel(FRAME_ShopItemCraftSprite2, "Pick\\selecter5.mdx", 0)
    call BlzFrameSetVisible(FRAME_ShopItemCraftSprite2, false)
    set y = 0.47
    set x = 0.075
    set i = 0
    loop
        exitwhen i == 7
        set FRAME_ShopSection[i] = BlzCreateFrameByType("GLUETEXTBUTTON", "MyHeroNameButton", FRAME_ShopMAIN, "ScriptDialogButton", 0)
        call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopSection[i]), 0, 100 + i)
        call BlzFrameSetAbsPoint(FRAME_ShopSection[i], FRAMEPOINT_CENTER, x, y)
        call BlzFrameSetSize(FRAME_ShopSection[i], 0.11, 0.03)
        if i == 0 then
            call BlzFrameSetText(FRAME_ShopSection[i], "Recommended")
        elseif i == 1 then
            call BlzFrameSetText(FRAME_ShopSection[i], "Base")
        elseif i == 2 then
            call BlzFrameSetText(FRAME_ShopSection[i], "Strength")
        elseif i == 3 then
            call BlzFrameSetText(FRAME_ShopSection[i], "Agility")
        elseif i == 4 then
            call BlzFrameSetText(FRAME_ShopSection[i], "Intelligence")
        elseif i == 5 then
            call BlzFrameSetText(FRAME_ShopSection[i], "Universal")
        else
            call BlzFrameSetText(FRAME_ShopSection[i], "Defensive")
        endif
        call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopSection[i], FRAMEEVENT_CONTROL_CLICK)
        set i = i + 1
        set y = y - 0.03
    endloop
    
        set FRAME_AutoBuyCheckbox = BlzCreateFrame("QuestCheckBox2", FRAME_ShopMAIN, 0, 0)
        call BlzFrameSetSize(FRAME_AutoBuyCheckbox, 0.0275, 0.0275)
        call BlzFrameSetPoint(FRAME_AutoBuyCheckbox, FRAMEPOINT_CENTER, FRAME_ShopMAIN, FRAMEPOINT_CENTER, -0.29, -0.08)
        call BlzTriggerRegisterFrameEvent(FrameShopCheckbox, FRAME_AutoBuyCheckbox, FRAMEEVENT_CHECKBOX_CHECKED)
        call BlzTriggerRegisterFrameEvent(FrameShopCheckbox, FRAME_AutoBuyCheckbox, FRAMEEVENT_CHECKBOX_UNCHECKED)
        call TriggerAddAction(FrameShopCheckbox, function FrameShopCheckboxCheck)
        set FRAME_AutoBuyText = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_ShopMAIN, "", 0)
        call BlzFrameSetSize(FRAME_AutoBuyText, 0.04, 0.01)
        call BlzFrameSetScale(FRAME_AutoBuyText,1.5)
        call BlzFrameSetPoint(FRAME_AutoBuyText, FRAMEPOINT_CENTER, FRAME_ShopMAIN, FRAMEPOINT_CENTER, -0.225, -0.055)
        call BlzFrameSetText(FRAME_AutoBuyText, "|c00FFFF00Autobuy|r")
    set i = 0
    set x = 0.02
    set y = -0.039
    loop
        exitwhen i == 35
        set FRAME_ShopItem[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_ShopItemList, "ScoreScreenTabButtonTemplate", 0)
        call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopItem[i]), 0, 200 + i)
        set FRAME_ShopItemBack[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItem[i], "", 0)
        call BlzFrameSetTexture(FRAME_ShopItemBack[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        call BlzFrameSetAllPoints(FRAME_ShopItemBack[i], FRAME_ShopItem[i])
        call BlzFrameSetPoint(FRAME_ShopItem[i], FRAMEPOINT_LEFT, FRAME_ShopItemList, FRAMEPOINT_TOPLEFT, x + 0.05 * k, y )
        call BlzFrameSetSize(FRAME_ShopItem[i], 0.04, 0.04)
        set FRAME_ShopItemTooltipText[i] = ShopCreateItemTooltip(FRAME_ShopItem[i])
        set FRAME_ShopItemCost[i] = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItem[i], "", 0)
        call BlzFrameSetPoint(FRAME_ShopItemCost[i], FRAMEPOINT_BOTTOM, FRAME_ShopItemList, FRAMEPOINT_TOPLEFT, (x + 0.02) + 0.05 * k, y - 0.03 )
        call BlzFrameSetText(FRAME_ShopItemCost[i], "|c00FFFF00|r")
        call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopItem[i], FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetAlpha(FRAME_ShopItemBack[i],255)
        set k = k + 1
        set i = i + 1
        if i == 7 or i == 14 or i == 21 or i == 28 or i == 35 then
            set k = 0
            set y = y - 0.05
        endif
    endloop
    set y = y + 0.25
    set x = x + 0.00
    set i = 36
    loop
        exitwhen i == 43
        if i == 42 then
            set k = 0
            set x = x + 0.05
            set y = y + 0.05
        endif
        set FRAME_ShopItem[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_ShopItemCraft, "ScoreScreenTabButtonTemplate", 0)
        call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopItem[i]), 0, 200 + i)
        set FRAME_ShopItemBack[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItem[i], "", 0)
        call BlzFrameSetAllPoints(FRAME_ShopItemBack[i], FRAME_ShopItem[i])
        call BlzFrameSetPoint(FRAME_ShopItem[i], FRAMEPOINT_LEFT, FRAME_ShopItemCraft, FRAMEPOINT_TOPLEFT, x + 0.05 * k, y )
        call BlzFrameSetSize(FRAME_ShopItem[i], 0.04, 0.04)
        set FRAME_ShopItemCost[i] = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItem[i], "", 0)
        call BlzFrameSetPoint(FRAME_ShopItemCost[i], FRAMEPOINT_BOTTOM, FRAME_ShopItemCraft, FRAMEPOINT_TOPLEFT, (x + 0.02) + 0.05 * k, y - 0.03 )
        call BlzFrameSetText(FRAME_ShopItemCost[i], "|c00FFFF00|r")
        if i < 42 then
            call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopItem[i], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetLevel(FRAME_ShopItem[i], 10)
            call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopItem[i], FRAMEEVENT_MOUSE_WHEEL)
            call BlzFrameSetEnable(FRAME_ShopItem[i], false)
        else
            call BlzFrameSetEnable(FRAME_ShopItem[i], false)
        endif
        if i == 42 then
            set FRAME_ShopItemCraftGoldSlot = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItemCraft, "", 0)
            call BlzFrameSetTexture(FRAME_ShopItemCraftGoldSlot, "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder2", 0, false)
            call BlzFrameSetAllPoints(FRAME_ShopItemCraftGoldSlot, FRAME_ShopItem[42])
            call BlzFrameSetLevel(FRAME_ShopItemCraftGoldSlot, 5)
        else
            call BlzFrameSetVisible(FRAME_ShopItemBack[i], false)
        endif
        call BlzFrameSetAlpha(FRAME_ShopItemBack[i],255)
        call BlzFrameSetTexture(FRAME_ShopItemBack[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
        set k = k + 1
        set i = i + 1
        if i == 39 then
            set k = 0
            set y = y - 0.1
        endif
    endloop

    set FRAME_ShopCraftUpgradeScroll = BlzCreateFrameByType("SLIDER", "ShopCraftUpgradeScroll", FRAME_ShopItemCraft, "QuestMainListScrollBar", 0)
    call BlzFrameSetPoint(FRAME_ShopCraftUpgradeScroll, FRAMEPOINT_TOPRIGHT, FRAME_ShopItemCraft, FRAMEPOINT_TOPRIGHT, -0.001, -0.012)
    call BlzFrameSetSize(FRAME_ShopCraftUpgradeScroll, 0.010, 0.060)
    call BlzFrameSetMinMaxValue(FRAME_ShopCraftUpgradeScroll, 0.00, 1.00)
    call BlzFrameSetStepSize(FRAME_ShopCraftUpgradeScroll, 1.00)
    call BlzFrameSetValue(FRAME_ShopCraftUpgradeScroll, 0.00)
    call BlzFrameSetLevel(FRAME_ShopCraftUpgradeScroll, 20)
    call BlzFrameSetVisible(FRAME_ShopCraftUpgradeScroll, false)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopCraftUpgradeScroll), 0, 401)
    call BlzTriggerRegisterFrameEvent(FrameCraftScroll, FRAME_ShopCraftUpgradeScroll, FRAMEEVENT_SLIDER_VALUE_CHANGED)
    call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopCraftUpgradeScroll, FRAMEEVENT_MOUSE_WHEEL)
    
    set FRAME_ShopCraftComponentScroll = BlzCreateFrameByType("SLIDER", "ShopCraftComponentScroll", FRAME_ShopItemCraft, "QuestMainListScrollBar", 0)
    call BlzFrameSetPoint(FRAME_ShopCraftComponentScroll, FRAMEPOINT_BOTTOMRIGHT, FRAME_ShopItemCraft, FRAMEPOINT_BOTTOMRIGHT, -0.001, 0.012)
    call BlzFrameSetSize(FRAME_ShopCraftComponentScroll, 0.010, 0.060)
    call BlzFrameSetMinMaxValue(FRAME_ShopCraftComponentScroll, 0.00, 1.00)
    call BlzFrameSetStepSize(FRAME_ShopCraftComponentScroll, 1.00)
    call BlzFrameSetValue(FRAME_ShopCraftComponentScroll, 0.00)
    call BlzFrameSetLevel(FRAME_ShopCraftComponentScroll, 20)
    call BlzFrameSetVisible(FRAME_ShopCraftComponentScroll, false)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopCraftComponentScroll), 0, 402)
    call BlzTriggerRegisterFrameEvent(FrameCraftScroll, FRAME_ShopCraftComponentScroll, FRAMEEVENT_SLIDER_VALUE_CHANGED)
    call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopCraftComponentScroll, FRAMEEVENT_MOUSE_WHEEL)
    
    set y = -0.06
    set x = 0.0225
    set i = 0
    set k = 0
    loop
        exitwhen i == 8
        set FRAME_ShopItemInventorySlot[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_ShopItemInventory, "ScoreScreenTabButtonTemplate", 0)
        call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopItemInventorySlot[i]), 0, 300 + i)
        set FRAME_ShopItemInventorySlotBack[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItemInventorySlot[i], "", 0)
        call BlzFrameSetAllPoints(FRAME_ShopItemInventorySlotBack[i], FRAME_ShopItemInventorySlot[i])
        call BlzFrameSetPoint(FRAME_ShopItemInventorySlot[i], FRAMEPOINT_LEFT, FRAME_ShopItemInventory, FRAMEPOINT_TOPLEFT, x + 0.0525 * k, y )
        call BlzFrameSetSize(FRAME_ShopItemInventorySlot[i], 0.04, 0.04)
        if i < 6 then
            set FRAME_ShopInventoryTooltipText[i] = ShopCreateItemTooltip(FRAME_ShopItemInventorySlot[i])
            call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[i], false)
        endif
        call BlzFrameSetTexture(FRAME_ShopItemInventorySlotBack[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        set FRAME_ShopItemInventorySlotCost[i] = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemInventorySlot[i], "", 0)
        call BlzFrameSetPoint(FRAME_ShopItemInventorySlotCost[i], FRAMEPOINT_BOTTOM, FRAME_ShopItemInventory, FRAMEPOINT_TOPLEFT, (x + 0.02) + 0.05 * k, y - 0.032 )
        if i == 6 then
            call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[i], "")
            call BlzFrameSetTexture(FRAME_ShopItemInventorySlotBack[i], "Pick\\BuyButton", 0, true)
            call BlzFrameSetAlpha(FRAME_ShopItemInventorySlotBack[i], 255)
        elseif i == 7 then
            call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[i], "")
            call BlzFrameSetTexture(FRAME_ShopItemInventorySlotBack[i], "Pick\\SellButton", 0, true)
        else
            call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[i], "|c00FFFF00|r")
        endif
        call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopItemInventorySlot[i], FRAMEEVENT_CONTROL_CLICK)
        set k = k + 1
        set i = i + 1
        if i == 2 or i == 4 or i == 6 then
            set k = 0
            set y = y - 0.055
        endif
    endloop
    call TriggerAddAction(FrameClick2, function OnClickItem)
    call TriggerAddAction(FrameCraftScroll, function ShopCraftOnScroll)
    call TriggerAddAction(FrameCraftWheel, function ShopCraftOnWheel)
    call TriggerAddAction(FrameShopSearch, function ShopSearchOnTextChanged)
    set ShopInventoryTimer = CreateTimer()
    set ShopAutoBuyTimer = CreateTimer()
    call TimerStart(ShopInventoryTimer, 0.50, true, function PlayerInventoryPeriodic)
    call TimerStart(ShopAutoBuyTimer, 0.50, true, function AutoBuyPeriodic)
    call BlzFrameSetVisible(FRAME_ShopMAIN, false)
    set ShopUICreated = true
endfunction

function InitTrig_WoS_Shop_Init takes nothing returns nothing
    set gg_trg_WoS_Shop_Init = CreateTrigger()
    call TriggerRegisterTimerEvent(gg_trg_WoS_Shop_Init, 6, false)
    call TriggerAddAction( gg_trg_WoS_Shop_Init, function CreateItemUI )
endfunction
