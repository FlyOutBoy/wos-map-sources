// WoS Shop - audited/refactored version
// Invariants: catalogue slots 0..34, craft slots 36..46 (42 = centre), inventory slots 0..5.
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
    // VIP tab (after Defensive): a promotion page over the catalogue + tree.
    framehandle FRAME_ShopVipPage = null
    framehandle FRAME_ShopVipLink = null
    framehandle FRAME_ShopVipName = null
    // "PURCHASED" plate + thanks line per tier card (shown to its owner only).
    framehandle array FRAME_ShopVipOwned
    trigger ShopVipLinkTrigger = null
    boolean array ShopVipOpen
    constant string SHOP_VIP_URL = "buymeacoffee.com/thunder.gear/membership"
    framehandle FRAME_ShopItemInventory
    framehandle FRAME_ShopItemInventoryName
    framehandle FRAME_ShopItemCraft
    framehandle FRAME_ShopItemCraftSprite
    framehandle FRAME_ShopItemCraftSprite2
    framehandle array FRAME_ShopRecipeLine
    framehandle FRAME_ShopRecipeTitle
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
    // Checkpoint 22: translucent plate under the price inside each icon.
    framehandle array FRAME_ShopItemPricePlate
    framehandle array FRAME_ShopInventoryPricePlate
    framehandle FRAME_ShopClose = null
    framehandle array FRAME_ShopItemTooltipText
    framehandle array FRAME_ShopItemTooltipBox
    framehandle array FRAME_ShopInventoryTooltipBox
    framehandle array FRAME_ShopInventoryItemName
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
integer array ItemsSearchAll_Index
    integer array ItemsCraft_ID
    integer array ItemsCraftLeft_ID
    integer array ItemsCraftBottom_ID
    integer array ItemsCraftRight_ID
    integer array ItemsCraftUpperLeft_ID
    integer array ItemsCraftUpperTop_ID
    integer array ItemsCraftUpperRight_ID
    integer array ItemsCraftCenter_ID
    integer array ItemsCraftPlayerDebug_ID
    // Checkpoint 21 item tree: up to SHOP_TREE_ROW items per row (upgrades on
    // top, components below); icons shrink as a row fills so large trees need
    // far less scrolling. Logical slots: 0-4 upgrades, 5-9 components.
    // Checkpoint 24b: two levels each way, 6 per row. Slots 0-5 upgrades,
    // 6-11 upgrades of those upgrades, 12-17 components, 18-23 components of
    // those components. Paging (slider / wheel) moves the first level by 6.
    // Frames 36..41 and 43..60 (42 = centre).
    constant integer SHOP_TREE_ROW = 6
    constant integer SHOP_TREE_PAGE = 6
    constant integer SHOP_TREE_GROUP = 12
    constant integer SHOP_TREE_SLOTS = 24
    integer array ShopTreeTmpId
    // Checkpoint 25: long item descriptions scroll (wheel over the text or the
    // slider at its right). Local presentation only.
    constant integer SHOP_DESC_LINES = 4
    constant integer SHOP_DESC_CHARS = 62
    string array ShopDescLine
    integer ShopDescCount = 0
    integer ShopDescOffset = 0
    boolean ShopDescUpdating = false
    integer ShopDescEcho = 0
    integer array ShopCraftEchoUp
    integer array ShopCraftEchoDown
    framehandle FRAME_ShopDescScroll = null
    framehandle FRAME_ShopDescWheel = null
    // Checkpoint 24: fast buy (double click on an item) / fast sell (double
    // click on an inventory item); synced flags, local icons.
    boolean array ShopFastBuy
    boolean array ShopFastSell
    integer array ShopLastClickItem
    integer array ShopLastClickCode
    real array ShopLastClickTime
    timer ShopClock = CreateTimer()
    framehandle FRAME_FastBuyToggle = null
    framehandle FRAME_FastBuyIcon = null
    framehandle FRAME_FastSellToggle = null
    framehandle FRAME_FastSellIcon = null
    integer array ShopTreeTmpParent
    // Tree rows (checkpoint 31): four rows around the centre item are shared
    // between upgrades (above) and components (below) by need. Per player:
    // direct rows per side (scroll capacity) and which slots are upgrades.
    integer array ShopTreeRowsUp
    integer array ShopTreeRowsDown
    integer array ShopTreeSlotTopP
    integer ShopTreeNeedDirect = 0
    integer array ShopTreeKid
    constant real SHOP_TREE_X = 0.531
    // Checkpoint 26b: centre (selected) item of the tree.
    constant real SHOP_TREE_CENTER_Y = 0.359
    constant real SHOP_LIST_X = 0.215
    constant real SHOP_INV_X = 0.718
    framehandle array FRAME_ShopItemName
    framehandle FRAME_AutoBuyToggle = null
    integer array ShopCraftSlotItem
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
        // Search debounce
    boolean array ShopSearchPending
    integer array ShopSearchDebounceTicks
    timer ShopSearchDebounceTimer = null

    // Search index — строится один раз при инициализации
    integer ShopSearchIndexCount = 0
    integer array ShopSearchIndex_ID
    string array ShopSearchIndexName

    constant real SHOP_SEARCH_DEBOUNCE_PERIOD = 0.05
    constant integer SHOP_SEARCH_DEBOUNCE_TICKS = 5
        // Последний реально обработанный запрос
    string array ShopSearchLastQuery

    // Запрос, на котором получили 0 результатов.
    // Пока новый текст является его продолжением — искать бессмысленно.
    string array ShopSearchDeadQuery
endglobals

function ShopSearchStartsWith takes string text, string prefix returns boolean
    local integer prefixLength = StringLength(prefix)

    if prefixLength == 0 then
        return true
    endif

    if StringLength(text) < prefixLength then
        return false
    endif

    return SubString(text, 0, prefixLength) == prefix
endfunction
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

// Local: shows SHOP_DESC_LINES wrapped lines starting at ShopDescOffset.
function ShopDescRender takes nothing returns nothing
    local integer i = ShopDescOffset
    local string text = ""
    loop
        exitwhen i >= ShopDescCount or i >= ShopDescOffset + SHOP_DESC_LINES
        if text != "" then
            set text = text + "|n"
        endif
        set text = text + ShopDescLine[i]
        set i = i + 1
    endloop
    call BlzFrameSetText(FRAME_ShopItemDescriptionName2, text)
    if FRAME_ShopDescScroll != null then
        set ShopDescUpdating = true
        call BlzFrameSetVisible(FRAME_ShopDescScroll, ShopDescCount > SHOP_DESC_LINES)
        if ShopDescCount > SHOP_DESC_LINES then
            set ShopDescEcho = ShopDescEcho + WUI_SliderSet(FRAME_ShopDescScroll, 0.00, I2R(ShopDescCount - SHOP_DESC_LINES), I2R(ShopDescCount - SHOP_DESC_LINES - ShopDescOffset))
        endif
        set ShopDescUpdating = false
    endif
endfunction

// Local: word-wraps the description into ShopDescLine[] (colour codes do
// not count as characters and are carried over to the next line).
function ShopDescWrap takes string text returns nothing
    local integer length = StringLength(text)
    local integer i = 0
    local integer visible = 0
    local integer lastSpace = -1
    local integer lineStart = 0
    local string color = ""
    local string lineColor = ""
    local string ch
    set ShopDescCount = 0
    set ShopDescOffset = 0
    loop
        exitwhen i >= length or ShopDescCount >= 60
        set ch = SubString(text, i, i + 1)
        if ch == "|" and i + 1 < length then
            set ch = SubString(text, i + 1, i + 2)
            if (ch == "c" or ch == "C") and i + 10 <= length then
                set color = SubString(text, i, i + 10)
                set i = i + 10
            elseif ch == "r" or ch == "R" then
                set color = ""
                set i = i + 2
            elseif ch == "n" or ch == "N" then
                set ShopDescLine[ShopDescCount] = lineColor + SubString(text, lineStart, i)
                set ShopDescCount = ShopDescCount + 1
                set i = i + 2
                set lineStart = i
                set lineColor = color
                set visible = 0
                set lastSpace = -1
            else
                set i = i + 1
                set visible = visible + 1
            endif
        else
            if ch == " " then
                set lastSpace = i
            endif
            set visible = visible + 1
            set i = i + 1
            if visible > SHOP_DESC_CHARS and lastSpace > lineStart then
                set ShopDescLine[ShopDescCount] = lineColor + SubString(text, lineStart, lastSpace)
                set ShopDescCount = ShopDescCount + 1
                set lineStart = lastSpace + 1
                set lineColor = color
                set visible = i - lineStart
                set lastSpace = -1
            endif
        endif
    endloop
    if lineStart < length and ShopDescCount < 60 then
        set ShopDescLine[ShopDescCount] = lineColor + SubString(text, lineStart, length)
        set ShopDescCount = ShopDescCount + 1
    endif
    call ShopDescRender()
endfunction

function ShopDescOnScroll takes nothing returns nothing
    if GetLocalPlayer() != GetTriggerPlayer() or ShopDescUpdating then
        return
    endif
    if BlzGetTriggerFrame() == FRAME_ShopDescWheel then
        if BlzGetTriggerFrameValue() > 0.00 then
            set ShopDescOffset = IMaxBJ(0, ShopDescOffset - 1)
        else
            set ShopDescOffset = IMinBJ(IMaxBJ(0, ShopDescCount - SHOP_DESC_LINES), ShopDescOffset + 1)
        endif
    else
        // Echo of our own slider move: drop it (see WUI_SliderSet).
        if ShopDescEcho > 0 then
            set ShopDescEcho = ShopDescEcho - 1
            return
        endif
        if IMaxBJ(0, ShopDescCount - SHOP_DESC_LINES - R2I(BlzGetTriggerFrameValue() + 0.50)) == ShopDescOffset then
            return
        endif
        set ShopDescOffset = IMaxBJ(0, ShopDescCount - SHOP_DESC_LINES - R2I(BlzGetTriggerFrameValue() + 0.50))
    endif
    call ShopDescRender()
endfunction

function ShopCreateDescScroll takes nothing returns nothing
    local trigger scroll = CreateTrigger()
    set FRAME_ShopDescWheel = BlzCreateFrameByType("BUTTON", "ShopDescWheel", FRAME_ShopItemDescription, "", 0)
    call WUI_Place(FRAME_ShopDescWheel, SHOP_TREE_X, 0.1905, 0.236, 0.052)
    if WUI_HasFrameDefinitions() then
        set FRAME_ShopDescScroll = BlzCreateFrame("WOSVerticalSlider", FRAME_ShopItemDescription, 0, 9152)
    endif
    if FRAME_ShopDescScroll == null then
        set FRAME_ShopDescScroll = BlzCreateFrame("QuestMainListScrollBar", FRAME_ShopItemDescription, 0, 9152)
    endif
    call WUI_Place(FRAME_ShopDescScroll, SHOP_TREE_X + 0.117, 0.1905, 0.009, 0.048)
    call BlzFrameSetStepSize(FRAME_ShopDescScroll, 1.00)
    call BlzFrameSetLevel(FRAME_ShopDescScroll, 20)
    call BlzFrameSetVisible(FRAME_ShopDescScroll, false)
    call BlzTriggerRegisterFrameEvent(scroll, FRAME_ShopDescWheel, FRAMEEVENT_MOUSE_WHEEL)
    call BlzTriggerRegisterFrameEvent(scroll, FRAME_ShopDescScroll, FRAMEEVENT_SLIDER_VALUE_CHANGED)
    call TriggerAddAction(scroll, function ShopDescOnScroll)
    set scroll = null
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
        call ShopDescWrap(description)
    endif
endfunction

function ShopCreateItemTooltip takes framehandle whichFrame returns framehandle
    local integer context = ShopTooltipContext
    local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "ShopNativeTooltip", FRAME_ShopMAIN, "", context)
    local framehandle tooltipText = BlzCreateFrameByType("TEXT", "ShopNativeTooltipText", tooltip, "", context)
    set ShopTooltipContext = ShopTooltipContext + 1
    call BlzFrameSetSize(tooltip, 0.050, 0.020)
    call BlzFrameSetTexture(tooltip, "textures\\black32.blp", 0, true)
    call BlzFrameSetAlpha(tooltip, 205)
    call BlzFrameSetLevel(tooltip, 50)
    call BlzFrameSetAllPoints(tooltipText, tooltip)
    call BlzFrameSetTextAlignment(tooltipText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(tooltipText, 0.90)
    call BlzFrameSetText(tooltipText, "")
    call BlzFrameSetVisible(tooltip, false)
    if whichFrame != null then
        call BlzFrameSetPoint(tooltip, FRAMEPOINT_TOP, whichFrame, FRAMEPOINT_BOTTOM, 0.0, ShopTooltipVerticalOffset)
        call BlzFrameSetTooltip(whichFrame, tooltip)
    endif
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




function ShopNameMatchesSearchLower takes string source, string query returns boolean
    local string current
    local string token = ""
    local integer index = 0
    local integer length = StringLength(query)
    local boolean hasToken = false

    loop
        exitwhen index > length

        if index == length then
            set current = " "
        else
            set current = SubString(query, index, index + 1)
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


function ShopSearchIndexContains takes integer itemId returns boolean
    local integer i = 0

    loop
        exitwhen i >= ShopSearchIndexCount

        if ShopSearchIndex_ID[i] == itemId then
            return true
        endif

        set i = i + 1
    endloop

    return false
endfunction


// Вызывается ОДИН РАЗ при создании магазина.
function ShopBuildSearchIndex takes nothing returns nothing
    local integer page = 1
    local integer slot
    local integer itemId

    local integer i
    local integer position
    local integer currentId
    local integer currentPrice
    local integer previousId
    local string currentName

    set ShopSearchIndexCount = 0

    // Собираем уникальные предметы один раз.
    loop
        exitwhen page > 6

        set slot = 0

        loop
            exitwhen slot >= SHOP_CATEGORY_MAX_ITEMS

            set itemId = ShopGetStaticPageItem(page, slot)

            if itemId != 0 and not ShopSearchIndexContains(itemId) then
                set ShopSearchIndex_ID[ShopSearchIndexCount] = itemId

                // Имя сразу сохраняем в lower-case.
                // Во время поиска StringCase/GetObjectName больше не нужны.
                set ShopSearchIndexName[ShopSearchIndexCount] = StringCase(GetObjectName(itemId), false)

                set ShopSearchIndexCount = ShopSearchIndexCount + 1
            endif

            set slot = slot + 1
        endloop

        set page = page + 1
    endloop

    // Один раз сортируем индекс по цене.
    // После этого любой отфильтрованный поиск уже автоматически
    // будет отсортирован по цене.
    set i = 1

    loop
        exitwhen i >= ShopSearchIndexCount

        set currentId = ShopSearchIndex_ID[i]
        set currentName = ShopSearchIndexName[i]
        set currentPrice = GetItemValue(currentId)

        set position = i - 1

        loop
            exitwhen position < 0

            set previousId = ShopSearchIndex_ID[position]

            exitwhen GetItemValue(previousId) <= currentPrice

            set ShopSearchIndex_ID[position + 1] = previousId
            set ShopSearchIndexName[position + 1] = ShopSearchIndexName[position]

            set position = position - 1
        endloop

        set ShopSearchIndex_ID[position + 1] = currentId
        set ShopSearchIndexName[position + 1] = currentName

        set i = i + 1
    endloop
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


function ShopBuildSearchResults takes integer pid, string query returns nothing
    local integer baseIndex = pid * SHOP_SEARCH_MAX_RESULTS
    local integer readIndex = 0
    local integer count = 0
    local integer oldCount = ShopSearchResultCount[pid]
    local integer searchIndex = 0
    local string loweredQuery = StringCase(query, false)
    local boolean refinePrevious = false

    // Такой запрос уже был обработан.
    // Вообще ничего повторно не считаем.
    if loweredQuery == ShopSearchLastQuery[pid] then
        call ShopFillSearchVisiblePage(pid)
        return
    endif

    // Если новый запрос является продолжением прошлого:
    //
    // "s"
    // "sw"
    // "swo"
    // "swor"
    //
    // новых совпадений появиться НЕ может.
    // Можно проверять только прошлые результаты.
    if StringLength(ShopSearchLastQuery[pid]) > 0 and /*
    */ ShopSearchStartsWith(loweredQuery, ShopSearchLastQuery[pid]) then
        set refinePrevious = true
    endif

    if refinePrevious then

        // Проверяем ТОЛЬКО результаты предыдущего поиска.
        loop
            exitwhen readIndex >= oldCount

            set searchIndex = ItemsSearchAll_Index[baseIndex + readIndex]

            if searchIndex >= 0 and searchIndex < ShopSearchIndexCount then

                if ShopNameMatchesSearchLower(ShopSearchIndexName[searchIndex], loweredQuery) then

                    // Сжимаем массив прямо на месте.
                    set ItemsSearchAll_ID[baseIndex + count] = ShopSearchIndex_ID[searchIndex]
                    set ItemsSearchAll_Index[baseIndex + count] = searchIndex

                    set count = count + 1
                endif

            endif

            set readIndex = readIndex + 1
        endloop

    else

        // Запрос изменили не обычным дописыванием:
        // например Backspace или изменение текста в середине.
        //
        // Только тогда снова идём по всему готовому индексу.
        set searchIndex = 0

        loop
            exitwhen searchIndex >= ShopSearchIndexCount or /*
            */ count >= SHOP_SEARCH_MAX_RESULTS

            if ShopNameMatchesSearchLower(ShopSearchIndexName[searchIndex], loweredQuery) then

                set ItemsSearchAll_ID[baseIndex + count] = ShopSearchIndex_ID[searchIndex]
                set ItemsSearchAll_Index[baseIndex + count] = searchIndex

                set count = count + 1
            endif

            set searchIndex = searchIndex + 1
        endloop

    endif

    set ShopSearchResultCount[pid] = count
    set ShopSearchLastQuery[pid] = loweredQuery

    // Ноль результатов:
    // запоминаем запрос, после которого продолжать поиск бессмысленно.
    if count == 0 and StringLength(loweredQuery) > 0 then
        set ShopSearchDeadQuery[pid] = loweredQuery
    else
        set ShopSearchDeadQuery[pid] = ""
    endif

    call ShopFillSearchVisiblePage(pid)
endfunction


// Price plate fits the digits (scale .78 font: ~.0047 per digit + margins).
function ShopPricePlateWidth takes integer price returns real
    return 0.0070 + I2R(StringLength(I2S(price))) * 0.0047
endfunction

// Icon of the given size centred at (x, y): price centred just above its
// bottom edge, on a translucent black plate sized to the price.
function ShopPlacePrice takes framehandle cost, framehandle plate, real x, real y, real size returns nothing
    local real py = y - size * 0.5 + 0.0068
    call BlzFrameClearAllPoints(cost)
    call BlzFrameSetAbsPoint(cost, FRAMEPOINT_CENTER, x, py)
    call BlzFrameSetSize(cost, size / 0.78, 0.010 / 0.78)
    call BlzFrameSetScale(cost, 0.78)
    call BlzFrameSetTextAlignment(cost, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetEnable(cost, false)
    call BlzFrameSetLevel(cost, 4)
    if plate != null then
        call WUI_Place(plate, x, py, 0.020, 0.0105)
        call BlzFrameSetLevel(plate, 3)
    endif
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
    local framehandle tooltip = FRAME_ShopItemTooltipBox[slot]
    local real plateWidth = 0.020
    
    if id != 0 then
        set price = GetItemValue(id)
        set plateWidth = ShopPricePlateWidth(price)
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
                call BlzFrameSetText(FRAME_ShopItemName[slot], "")
                call BlzFrameSetSize(tooltip, tooltipWidth, 0.020)
                call BlzFrameSetTexture(FRAME_ShopItemBack[slot], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
                call BlzFrameSetText(FRAME_ShopItemCost[slot], "")
                call BlzFrameSetVisible(FRAME_ShopItemPricePlate[slot], false)
                call BlzFrameSetEnable(FRAME_ShopItem[slot], false)
            else
                call BlzFrameSetSize(FRAME_ShopItemPricePlate[slot], plateWidth, 0.0105)
                call BlzFrameSetVisible(FRAME_ShopItemPricePlate[slot], true)
                call BlzFrameSetSize(tooltip, tooltipWidth, 0.020)
                call BlzFrameSetText(FRAME_ShopItemTooltipText[slot], tooltipNameStr)
                call BlzFrameSetText(FRAME_ShopItemName[slot], WUI_TEXT + itemName + "|r")
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
    local integer read = 0
    local integer count = 0
    local integer left = 0
    local integer right
    local integer itemId
    local integer leftId
    local integer rightId
    local integer leftValue
    local integer rightValue

    // Compact sparse category definitions first. Without this pass, categories
    // that use slots 0 and 14+ keep empty holes and can render stale item frames.
    loop
        exitwhen read >= SHOP_CATEGORY_MAX_ITEMS
        set itemId = ShopGetPageItem(page, read)
        if itemId != 0 then
            if read != count then
                call ShopSetPageItem(page, count, itemId)
                call ShopSetPageItem(page, read, 0)
            endif
            set count = count + 1
        endif
        set read = read + 1
    endloop

    loop
        exitwhen left >= count - 1
        set leftId = ShopGetPageItem(page, left)
        set leftValue = GetItemValue(leftId)
        set right = left + 1
        loop
            exitwhen right >= count
            set rightId = ShopGetPageItem(page, right)
            set rightValue = GetItemValue(rightId)
            if rightValue < leftValue then
                call ShopSetPageItem(page, left, rightId)
                call ShopSetPageItem(page, right, leftId)
                set leftId = rightId
                set leftValue = rightValue
            endif
            set right = right + 1
        endloop
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
    // Price-probe units must never belong to a real lobby slot.
    local integer i2 = bj_PLAYER_NEUTRAL_EXTRA
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
    set ItemsPage1_ID[32] = 'I03Z'

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
    set ItemsPage3_ID[17] = 'I015'
    set ItemsPage3_ID[18] = 'I016' 
    set ItemsPage3_ID[19] = 'I024' 
    set ItemsPage3_ID[21] = 'I042'

    set ItemsPage4_ID[0] = 'I03H' 
    set ItemsPage4_ID[14] = 'I00H' 
    set ItemsPage4_ID[15] = 'I01B' 
    set ItemsPage4_ID[16] = 'I01C' 
    set ItemsPage4_ID[17] = 'I01U'
    set ItemsPage4_ID[18] = 'I01S'
    set ItemsPage4_ID[19] = 'I011' 

set k = 0
loop
    exitwhen k >= SHOP_CATEGORY_MAX_ITEMS
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
    set itemList[31] = 'I03X'
    set itemList[32] = 'I03Y'
    set itemList[33] = 'I040'
    set itemList[34] = 'I041'
    set itemList[35] = 'I043'
    set itemList[36] = 'I044'
    set k = 0
loop
    exitwhen k >= SHOP_CATEGORY_MAX_ITEMS
    set ItemsPage5_ID[k] = itemList[k]
    set k = k + 1
endloop

set k = 0
loop
    exitwhen k >= SHOP_CATEGORY_MAX_ITEMS
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
set itemList[21] = 'I045' 
set k = 0
loop
    exitwhen k >= SHOP_CATEGORY_MAX_ITEMS
    set ItemsPage6_ID[k] = itemList[k]
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
    if count <= SHOP_TREE_PAGE then
        return 0
    endif
    return ((count - 1) / SHOP_TREE_PAGE) * SHOP_TREE_PAGE
endfunction

function GetVisibleCraftRelation takes integer itemId, boolean upgrades, integer offset, integer visibleSlot returns integer
    local integer count
    local integer index = offset + visibleSlot
    if upgrades then
        set count = GetCraftUpgradeCount(itemId)
    else
        set count = GetCraftComponentCount(itemId)
    endif
    if visibleSlot < 0 or visibleSlot >= SHOP_TREE_PAGE or index >= count then
        return 0
    endif
    if upgrades then
        return GetCraftUpgrade(itemId, index)
    endif
    return GetCraftComponent(itemId, index)
endfunction

// Frame index of a logical tree slot (0-11 upgrades, 12-23 components).
function ShopTreeFrame takes integer slot returns integer
    if slot < 6 then
        return 36 + slot
    endif
    return 37 + slot
endfunction

// Inverse of ShopTreeFrame; -1 for non-tree frames (including the centre 42).
function ShopTreeSlotFromFrame takes integer frameIndex returns integer
    if frameIndex >= 36 and frameIndex <= 41 then
        return frameIndex - 36
    elseif frameIndex >= 43 and frameIndex <= 60 then
        return frameIndex - 37
    endif
    return -1
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
    call RegisterCraft('I03X', "I02P I01J")
    call RegisterCraft('I03Y', "I02P I03Z")
    call RegisterCraft('I040', "I02O")
    call RegisterCraft('I041', "I03F")
    call RegisterCraft('I042', "I02P")
    call RegisterCraft('I043', "I00M")
    call RegisterCraft('I044', "I00G I022")
    call RegisterCraft('I045', "I02K")
endfunction

function SetPlayerCraftSlot takes integer pid, integer slot, integer itemId returns nothing
    set ShopCraftSlotItem[pid * SHOP_TREE_SLOTS + slot] = itemId
    // Legacy names for the first three items of each row.
    if slot == 0 then
        set ItemsCraftUpperLeft_ID[pid] = itemId
    elseif slot == 1 then
        set ItemsCraftUpperTop_ID[pid] = itemId
    elseif slot == 2 then
        set ItemsCraftUpperRight_ID[pid] = itemId
    elseif slot == SHOP_TREE_GROUP then
        set ItemsCraftLeft_ID[pid] = itemId
    elseif slot == SHOP_TREE_GROUP + 1 then
        set ItemsCraftBottom_ID[pid] = itemId
    elseif slot == SHOP_TREE_GROUP + 2 then
        set ItemsCraftRight_ID[pid] = itemId
    endif
endfunction

function ResetCraftFrames takes player p returns nothing
    local integer slot = 0
    local integer frameIndex
    loop
        exitwhen slot >= SHOP_TREE_SLOTS
        set frameIndex = ShopTreeFrame(slot)
        if GetLocalPlayer() == p then
            call BlzFrameSetEnable(FRAME_ShopItem[frameIndex], false)
            call BlzFrameSetVisible(FRAME_ShopItemBack[frameIndex], false)
            call BlzFrameSetTexture(FRAME_ShopItemBack[frameIndex], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
            call BlzFrameSetText(FRAME_ShopItemCost[frameIndex], "")
            call BlzFrameSetVisible(FRAME_ShopItemPricePlate[frameIndex], false)
            if FRAME_ShopItemName[frameIndex] != null then
                call BlzFrameSetText(FRAME_ShopItemName[frameIndex], "")
            endif
        endif
        set slot = slot + 1
    endloop
endfunction

// Recipe edges are presentation only. A branch exists only for an actual
// displayed relation, including each player's current three-item scroll page.
function ShopShowRecipeBranch takes integer slot, boolean visible returns nothing
    local integer part = slot * 3
    call BlzFrameSetVisible(FRAME_ShopRecipeLine[part], visible)
    call BlzFrameSetVisible(FRAME_ShopRecipeLine[part + 1], visible)
    call BlzFrameSetVisible(FRAME_ShopRecipeLine[part + 2], visible)
endfunction

// Icon size / spacing for a row holding `count` visible items.
// count = items in one visual row (1..6).
function ShopTreeIconSize takes integer count returns real
    if count <= 3 then
        return 0.030
    endif
    return 0.028
endfunction

function ShopTreeStep takes integer count returns real
    // Checkpoint 26: wider steps so names like "Tome of Agility +10" fit on one line.
    if count <= 3 then
        return 0.060
    elseif count == 4 then
        return 0.052
    elseif count == 5 then
        return 0.044
    endif
    return 0.038
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

// Rows of 6 needed for `count` items (exact division keeps it an integer).
function ShopTreeRowsFor takes integer count returns integer
    local integer padded = count + SHOP_TREE_ROW - 1
    return (padded - ModuloInteger(padded, SHOP_TREE_ROW)) / SHOP_TREE_ROW
endfunction

// Largest scroll offset when `rows` rows of 6 direct items are visible.
function ShopTreeMaxOffset takes integer count, integer rows returns integer
    local integer visible = IMaxBJ(1, rows) * SHOP_TREE_ROW
    local integer pages
    if count <= visible then
        return 0
    endif
    set pages = ShopTreeRowsFor(count - visible)
    return pages * SHOP_TREE_ROW
endfunction

function ShopUpdateCraftScrollbars takes integer id, player p returns nothing
    local integer pid = GetPlayerId(p)
    local integer upgradeCount = GetCraftUpgradeCount(id)
    local integer componentCount = GetCraftComponentCount(id)
    local integer upgradeMaxOffset = ShopTreeMaxOffset(upgradeCount, ShopTreeRowsUp[pid])
    local integer componentMaxOffset = ShopTreeMaxOffset(componentCount, ShopTreeRowsDown[pid])
    local integer upgradeMaxPage = upgradeMaxOffset / SHOP_TREE_PAGE
    local integer componentMaxPage = componentMaxOffset / SHOP_TREE_PAGE
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
    set upgradeValue = ShopCraftUpgradeOffset[pid] / SHOP_TREE_PAGE
    set componentValue = ShopCraftComponentOffset[pid] / SHOP_TREE_PAGE
    set ShopCraftScrollUpdating[pid] = true
    if GetLocalPlayer() == p then
        if upgradeCount > ShopTreeRowsUp[pid] * SHOP_TREE_ROW then
            set ShopCraftEchoUp[pid] = ShopCraftEchoUp[pid] + WUI_SliderSet(FRAME_ShopCraftUpgradeScroll, 0.00, upgradeMaxPageValue, I2R(upgradeValue))
            call BlzFrameSetVisible(FRAME_ShopCraftUpgradeScroll, true)
        else
            call BlzFrameSetVisible(FRAME_ShopCraftUpgradeScroll, false)
        endif
        if componentCount > ShopTreeRowsDown[pid] * SHOP_TREE_ROW then
            set ShopCraftEchoDown[pid] = ShopCraftEchoDown[pid] + WUI_SliderSet(FRAME_ShopCraftComponentScroll, 0.00, componentMaxPageValue, I2R(componentValue))
            call BlzFrameSetVisible(FRAME_ShopCraftComponentScroll, true)
        else
            call BlzFrameSetVisible(FRAME_ShopCraftComponentScroll, false)
        endif
    endif
    set ShopCraftScrollUpdating[pid] = false
endfunction

// Fills ShopTreeTmpId / ShopTreeTmpParent for one group (upgrades or
// components): first level = the visible page, second level = their own
// upgrades (components) in order, no duplicates, at most one row.
function ShopTreeCollect takes integer id, boolean upgrades, integer offset, integer base returns nothing
    local integer k = 0
    local integer j
    local integer n
    local integer count = 0
    local integer parent
    local integer candidate
    local integer m
    local boolean seen
    loop
        exitwhen k >= SHOP_TREE_ROW
        set ShopTreeTmpId[base + k] = GetVisibleCraftRelation(id, upgrades, offset, k)
        set ShopTreeTmpParent[base + k] = -1
        set ShopTreeTmpId[base + SHOP_TREE_ROW + k] = 0
        set ShopTreeTmpParent[base + SHOP_TREE_ROW + k] = -1
        set k = k + 1
    endloop
    set k = 0
    loop
        exitwhen k >= SHOP_TREE_ROW or count >= SHOP_TREE_ROW
        set parent = ShopTreeTmpId[base + k]
        if parent != 0 then
            if upgrades then
                set n = GetCraftUpgradeCount(parent)
            else
                set n = GetCraftComponentCount(parent)
            endif
            set j = 0
            loop
                exitwhen j >= n or count >= SHOP_TREE_ROW
                if upgrades then
                    set candidate = GetCraftUpgrade(parent, j)
                else
                    set candidate = GetCraftComponent(parent, j)
                endif
                set seen = candidate == 0 or candidate == id
                set m = 0
                loop
                    exitwhen m >= count or seen
                    set seen = ShopTreeTmpId[base + SHOP_TREE_ROW + m] == candidate
                    set m = m + 1
                endloop
                if not seen then
                    set ShopTreeTmpId[base + SHOP_TREE_ROW + count] = candidate
                    set ShopTreeTmpParent[base + SHOP_TREE_ROW + count] = k
                    set count = count + 1
                endif
                set j = j + 1
            endloop
        endif
        set k = k + 1
    endloop
endfunction

function ShopTreeRowCount takes integer base returns integer
    local integer k = 0
    local integer count = 0
    loop
        exitwhen k >= SHOP_TREE_ROW
        if ShopTreeTmpId[base + k] != 0 then
            set count = k + 1
        endif
        set k = k + 1
    endloop
    return count
endfunction

function ShopTreeRowX takes integer k, integer count returns real
    if count < 1 then
        set count = 1
    endif
    return SHOP_TREE_X + (I2R(k) - I2R(count - 1) * 0.50) * ShopTreeStep(count)
endfunction

function ShopTreeRelCount takes integer itemId, boolean upgrades returns integer
    if upgrades then
        return GetCraftUpgradeCount(itemId)
    endif
    return GetCraftComponentCount(itemId)
endfunction

function ShopTreeRel takes integer itemId, boolean upgrades, integer index returns integer
    if upgrades then
        return GetCraftUpgrade(itemId, index)
    endif
    return GetCraftComponent(itemId, index)
endfunction

// Rows one side needs to show everything (direct rows + rows of their own
// relations, at most 4); ShopTreeNeedDirect gets the direct rows.
function ShopTreeNeed takes integer id, boolean upgrades returns integer
    local integer n = ShopTreeRelCount(id, upgrades)
    local integer i = 0
    local integer j
    local integer m
    local integer kids = 0
    local integer parent
    local integer candidate
    local boolean seen
    local integer rows = ShopTreeRowsFor(n)
    set ShopTreeNeedDirect = IMinBJ(4, rows)
    loop
        exitwhen i >= n or kids >= 24
        set parent = ShopTreeRel(id, upgrades, i)
        set j = 0
        loop
            exitwhen j >= ShopTreeRelCount(parent, upgrades) or kids >= 24
            set candidate = ShopTreeRel(parent, upgrades, j)
            set seen = candidate == 0 or candidate == id
            set m = 0
            loop
                exitwhen m >= kids or seen
                set seen = ShopTreeKid[m] == candidate
                set m = m + 1
            endloop
            if not seen then
                set ShopTreeKid[kids] = candidate
                set kids = kids + 1
            endif
            set j = j + 1
        endloop
        set i = i + 1
    endloop
    set rows = ShopTreeRowsFor(kids)
    return IMinBJ(4, ShopTreeNeedDirect + rows)
endfunction

// Fills display rows [firstRow, firstRow + directRows + childRows) of one side:
// direct relations from `offset`, then the relations of those shown items.
function ShopTreeFillSide takes integer id, boolean upgrades, integer offset, integer firstRow, integer directRows, integer childRows returns nothing
    local integer n = ShopTreeRelCount(id, upgrades)
    local integer k = 0
    local integer slot
    local integer kids = 0
    local integer parentSlot
    local integer parent
    local integer j
    local integer m
    local integer candidate
    local boolean seen
    loop
        exitwhen k >= directRows * SHOP_TREE_ROW
        set slot = firstRow * SHOP_TREE_ROW + k
        if offset + k < n then
            set ShopTreeTmpId[slot] = ShopTreeRel(id, upgrades, offset + k)
        endif
        set ShopTreeTmpParent[slot] = -1
        set k = k + 1
    endloop
    set parentSlot = firstRow * SHOP_TREE_ROW
    loop
        exitwhen parentSlot >= (firstRow + directRows) * SHOP_TREE_ROW or kids >= childRows * SHOP_TREE_ROW
        set parent = ShopTreeTmpId[parentSlot]
        if parent != 0 then
            set j = 0
            loop
                exitwhen j >= ShopTreeRelCount(parent, upgrades) or kids >= childRows * SHOP_TREE_ROW
                set candidate = ShopTreeRel(parent, upgrades, j)
                set seen = candidate == 0 or candidate == id
                set m = 0
                loop
                    exitwhen m >= kids or seen
                    set seen = ShopTreeTmpId[(firstRow + directRows) * SHOP_TREE_ROW + m] == candidate
                    set m = m + 1
                endloop
                if not seen then
                    set slot = (firstRow + directRows) * SHOP_TREE_ROW + kids
                    set ShopTreeTmpId[slot] = candidate
                    set ShopTreeTmpParent[slot] = parentSlot
                    set kids = kids + 1
                endif
                set j = j + 1
            endloop
        endif
        set parentSlot = parentSlot + 1
    endloop
endfunction

// Height of display row index 0..4 (0 = top).
function ShopTreeRowY takes integer index returns real
    return 0.455 - I2R(index) * 0.0490
endfunction

function CraftItemCheck takes integer id, player p, integer page returns nothing
    local integer pid = GetPlayerId(p)
    local integer slot = 0
    local integer k
    local integer frameIndex
    local integer relatedId
    local integer value
    local integer rowCount
    local integer parentCount
    local integer level
    local unit selectedUnit = GetSelectedHeroForPlayer(p)
    local string costStr = ""
    local string relatedIconPath = ""
    local boolean relatedBanned = false
    local boolean top
    local real size
    local real x
    local real y
    local real joinY
    local real edgeY
    local real costY
    local real priceScale
    local real plateWidth
    local real parentX
    local real parentEdge
    local integer rowBase
    local integer needUp
    local integer needDown
    local integer directUp
    local integer directDown
    local integer rowsUp
    local integer rowsDown
    local real centreY
    local integer slotRow
    local integer parentRow
    if ShopCraftScrollItemId[pid] != id then
        call ShopSaveCraftScrollState(pid, ShopCraftScrollItemId[pid])
        set ShopCraftScrollItemId[pid] = id
        call ShopLoadCraftScrollState(pid, id)
    endif
    // Share the four rows around the centre between both sides by need.
    set needUp = ShopTreeNeed(id, true)
    set directUp = ShopTreeNeedDirect
    set needDown = ShopTreeNeed(id, false)
    set directDown = ShopTreeNeedDirect
    if needUp + needDown <= 4 then
        set rowsUp = needUp
        set rowsDown = needDown
    else
        set rowsUp = IMinBJ(needUp, 2)
        set rowsDown = IMinBJ(needDown, 2)
        if needUp - rowsUp >= needDown - rowsDown then
            set rowsUp = IMinBJ(needUp, 4 - rowsDown)
        else
            set rowsDown = IMinBJ(needDown, 4 - rowsUp)
        endif
        set rowsUp = IMinBJ(needUp, 4 - rowsDown)
    endif
    set directUp = IMinBJ(directUp, rowsUp)
    set directDown = IMinBJ(directDown, rowsDown)
    set ShopTreeRowsUp[pid] = IMaxBJ(1, directUp)
    set ShopTreeRowsDown[pid] = IMaxBJ(1, directDown)
    call ShopUpdateCraftScrollbars(id, p)
    call ResetCraftFrames(p)
    set slot = 0
    loop
        exitwhen slot >= SHOP_TREE_SLOTS
        set ShopTreeTmpId[slot] = 0
        set ShopTreeTmpParent[slot] = -1
        set slot = slot + 1
    endloop
    set slot = 0
    call ShopTreeFillSide(id, true, ShopCraftUpgradeOffset[pid], 0, directUp, rowsUp - directUp)
    call ShopTreeFillSide(id, false, ShopCraftComponentOffset[pid], rowsUp, directDown, rowsDown - directDown)
    // The centre sits right below the upgrade rows (top when there are none).
    set centreY = ShopTreeRowY(rowsUp)
    if GetLocalPlayer() == p then
        call BlzFrameClearAllPoints(FRAME_ShopItem[42])
        call BlzFrameSetAbsPoint(FRAME_ShopItem[42], FRAMEPOINT_CENTER, SHOP_TREE_X, centreY)
        call BlzFrameSetSize(FRAME_ShopItem[42], 0.030, 0.030)
        call BlzFrameClearAllPoints(FRAME_ShopItemCost[42])
        call BlzFrameSetAbsPoint(FRAME_ShopItemCost[42], FRAMEPOINT_CENTER, SHOP_TREE_X, centreY - 0.015 + 0.0068)
        call BlzFrameClearAllPoints(FRAME_ShopItemPricePlate[42])
        call BlzFrameSetAbsPoint(FRAME_ShopItemPricePlate[42], FRAMEPOINT_CENTER, SHOP_TREE_X, centreY - 0.015 + 0.0068)
        call BlzFrameSetSize(FRAME_ShopItemPricePlate[42], 0.0305, 0.0105)
        call BlzFrameClearAllPoints(FRAME_ShopItemName[42])
        call BlzFrameSetAbsPoint(FRAME_ShopItemName[42], FRAMEPOINT_TOP, SHOP_TREE_X, centreY - 0.015 - 0.0012)
        call BlzFrameSetSize(FRAME_ShopItemName[42], 0.080 / 0.56, 0.014 / 0.56)
    endif
    loop
        exitwhen slot >= SHOP_TREE_SLOTS
        set slotRow = (slot - ModuloInteger(slot, SHOP_TREE_ROW)) / SHOP_TREE_ROW
        set rowBase = slotRow * SHOP_TREE_ROW
        set k = slot - rowBase
        set top = slotRow < rowsUp
        set ShopTreeSlotTopP[pid * SHOP_TREE_SLOTS + slot] = IntegerTertiaryOp(top, 1, 0)
        set relatedId = ShopTreeTmpId[slot]
        set rowCount = ShopTreeRowCount(rowBase)
        call SetPlayerCraftSlot(pid, slot, relatedId)
        set frameIndex = ShopTreeFrame(slot)
        set size = ShopTreeIconSize(rowCount)
        set x = ShopTreeRowX(k, rowCount)
        // Upgrade rows go up from the centre, component rows down from it;
        // every rail lies in the gap between a row and the next one inward.
        if top then
            set y = ShopTreeRowY(rowsUp - 1 - slotRow)
            set edgeY = y - size * 0.50 - 0.0105
            set joinY = y - 0.0295
        else
            set y = ShopTreeRowY(slotRow + 1)
            set edgeY = y + size * 0.50
            set joinY = y + 0.019
        endif
        set parentX = SHOP_TREE_X
        if top then
            set parentEdge = centreY + 0.015
        else
            set parentEdge = centreY - 0.015 - 0.0105
        endif
        if ShopTreeTmpParent[slot] >= 0 then
            set parentRow = (ShopTreeTmpParent[slot] - ModuloInteger(ShopTreeTmpParent[slot], SHOP_TREE_ROW)) / SHOP_TREE_ROW
            set parentCount = ShopTreeRowCount(parentRow * SHOP_TREE_ROW)
            set parentX = ShopTreeRowX(ShopTreeTmpParent[slot] - parentRow * SHOP_TREE_ROW, parentCount)
            if top then
                set parentEdge = ShopTreeRowY(rowsUp - 1 - parentRow) + ShopTreeIconSize(parentCount) * 0.50
            else
                set parentEdge = ShopTreeRowY(1 + parentRow) - ShopTreeIconSize(parentCount) * 0.50 - 0.0105
            endif
        endif
        set costY = y - size * 0.50 + 0.0062
        set priceScale = 0.78
        if size < 0.030 then
            set priceScale = 0.64
        endif
        if GetLocalPlayer() == p then
            call ShopShowRecipeBranch(slot, relatedId != 0)
        endif
        if relatedId != 0 then
            if top then
                set value = CheckItemsReduceCostCraft(selectedUnit, GetItemValue(relatedId), relatedId, false)
            else
                set value = GetItemValue(relatedId)
            endif
            set costStr = "|c00FFFF00" + I2S(value) + "|r"
            set plateWidth = ShopPricePlateWidth(value) * priceScale / 0.78
            set relatedBanned = CheckBanItems(relatedId, selectedUnit)
            set relatedIconPath = BlzGetAbilityIcon(relatedId)
            if relatedBanned then
                set relatedIconPath = ConvertBTNtoDISBTN(relatedIconPath)
            endif
            if GetLocalPlayer() == p then
                call BlzFrameClearAllPoints(FRAME_ShopItem[frameIndex])
                call BlzFrameSetAbsPoint(FRAME_ShopItem[frameIndex], FRAMEPOINT_CENTER, x, y)
                call BlzFrameSetSize(FRAME_ShopItem[frameIndex], size, size)
                call BlzFrameClearAllPoints(FRAME_ShopItemCost[frameIndex])
                call BlzFrameSetAbsPoint(FRAME_ShopItemCost[frameIndex], FRAMEPOINT_CENTER, x, costY)
                call BlzFrameSetScale(FRAME_ShopItemCost[frameIndex], priceScale)
                call BlzFrameSetSize(FRAME_ShopItemCost[frameIndex], 0.036 / priceScale, 0.010 / priceScale)
                call BlzFrameSetLevel(FRAME_ShopItemCost[frameIndex], 4)
                call BlzFrameClearAllPoints(FRAME_ShopItemPricePlate[frameIndex])
                call BlzFrameSetAbsPoint(FRAME_ShopItemPricePlate[frameIndex], FRAMEPOINT_CENTER, x, costY)
                call BlzFrameSetSize(FRAME_ShopItemPricePlate[frameIndex], plateWidth, 0.0105 * priceScale / 0.78)
                call BlzFrameSetLevel(FRAME_ShopItemPricePlate[frameIndex], 3)
                call BlzFrameSetVisible(FRAME_ShopItemPricePlate[frameIndex], true)
                // Segment 0: from the icon to its rail; 1: along the rail to the
                // parent's x; 2: (second level only) down/up into the parent.
                call BlzFrameClearAllPoints(FRAME_ShopRecipeLine[slot * 3])
                call BlzFrameSetAbsPoint(FRAME_ShopRecipeLine[slot * 3], FRAMEPOINT_CENTER, x, (edgeY + joinY) * 0.50)
                call BlzFrameSetSize(FRAME_ShopRecipeLine[slot * 3], 0.0008, RAbsBJ(edgeY - joinY))
                call BlzFrameClearAllPoints(FRAME_ShopRecipeLine[slot * 3 + 1])
                call BlzFrameSetAbsPoint(FRAME_ShopRecipeLine[slot * 3 + 1], FRAMEPOINT_CENTER, (x + parentX) * 0.50, joinY)
                call BlzFrameSetSize(FRAME_ShopRecipeLine[slot * 3 + 1], RMaxBJ(0.0008, RAbsBJ(x - parentX)), 0.0008)
                call BlzFrameClearAllPoints(FRAME_ShopRecipeLine[slot * 3 + 2])
                call BlzFrameSetAbsPoint(FRAME_ShopRecipeLine[slot * 3 + 2], FRAMEPOINT_CENTER, parentX, (joinY + parentEdge) * 0.50)
                call BlzFrameSetSize(FRAME_ShopRecipeLine[slot * 3 + 2], 0.0008, RMaxBJ(0.0008, RAbsBJ(joinY - parentEdge)))
                call BlzFrameSetEnable(FRAME_ShopItem[frameIndex], not relatedBanned)
                call BlzFrameSetTexture(FRAME_ShopItemBack[frameIndex], relatedIconPath, 0, false)
                call BlzFrameSetVisible(FRAME_ShopItemBack[frameIndex], true)
                call BlzFrameSetText(FRAME_ShopItemCost[frameIndex], costStr)
                call BlzFrameClearAllPoints(FRAME_ShopItemName[frameIndex])
                call BlzFrameSetAbsPoint(FRAME_ShopItemName[frameIndex], FRAMEPOINT_TOP, x, y - size * 0.50 - 0.0012)
                call BlzFrameSetSize(FRAME_ShopItemName[frameIndex], (ShopTreeStep(rowCount) - 0.002) / 0.56, 0.014 / 0.56)
                call BlzFrameSetText(FRAME_ShopItemName[frameIndex], WUI_TEXT + GetObjectName(relatedId) + "|r")
            endif
        endif
        set slot = slot + 1
    endloop

    // Checkpoint 25b: the selected (centre) item is named like the others.
    if GetLocalPlayer() == p and FRAME_ShopItemName[42] != null then
        call BlzFrameSetText(FRAME_ShopItemName[42], WUI_TEXT + GetObjectName(id) + "|r")
    endif
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
    
    // Only the scrolling player's client decides (and sends) anything.
    if id == 0 or ShopCraftScrollUpdating[pid] or GetLocalPlayer() != p then
        set changedFrame = null
        set p = null
        return
    endif
    // Echo of our own slider move: drop it (see WUI_SliderSet).
    if changedFrame == FRAME_ShopCraftUpgradeScroll and ShopCraftEchoUp[pid] > 0 then
        set ShopCraftEchoUp[pid] = ShopCraftEchoUp[pid] - 1
        set changedFrame = null
        set p = null
        return
    elseif changedFrame == FRAME_ShopCraftComponentScroll and ShopCraftEchoDown[pid] > 0 then
        set ShopCraftEchoDown[pid] = ShopCraftEchoDown[pid] - 1
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
        set maxOffset = ShopTreeMaxOffset(GetCraftUpgradeCount(id), ShopTreeRowsUp[pid])
        set newOffset = sliderValue * SHOP_TREE_PAGE
        if newOffset < 0 then
            set newOffset = 0
        elseif newOffset > maxOffset then
            set newOffset = maxOffset
        endif
        if newOffset != ShopCraftUpgradeOffset[pid] then
            call BlzSendSyncData("WScU", I2S(newOffset))
        endif
    elseif changedFrame == FRAME_ShopCraftComponentScroll then
        set maxOffset = ShopTreeMaxOffset(GetCraftComponentCount(id), ShopTreeRowsDown[pid])
        set newOffset = sliderValue * SHOP_TREE_PAGE
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
    local integer wheelSlot = ShopTreeSlotFromFrame(frameCode - 200)
    local boolean scrollUpgrades = (wheelSlot >= 0 and ShopTreeSlotTopP[pid * SHOP_TREE_SLOTS + wheelSlot] == 1) or frameCode == 401 or frameCode == 403
    local boolean scrollComponents = (wheelSlot >= 0 and ShopTreeSlotTopP[pid * SHOP_TREE_SLOTS + wheelSlot] == 0) or frameCode == 402 or frameCode == 404
    
    if id == 0 then
        set hoveredFrame = null
        set p = null
        return
    endif
    
    if frameCode == 400 then
        if upgradeCount > SHOP_TREE_PAGE and componentCount <= SHOP_TREE_PAGE then
            set scrollUpgrades = true
        elseif componentCount > SHOP_TREE_PAGE and upgradeCount <= SHOP_TREE_PAGE then
            set scrollComponents = true
        endif
    endif
    
    if scrollUpgrades and upgradeCount > SHOP_TREE_PAGE then
        set maxOffset = ShopTreeMaxOffset(upgradeCount, ShopTreeRowsUp[pid])
        set newOffset = ShopCraftUpgradeOffset[pid]
        if wheelValue < 0.00 then
            set newOffset = newOffset - SHOP_TREE_PAGE
        elseif wheelValue > 0.00 then
            set newOffset = newOffset + SHOP_TREE_PAGE
        endif
        if newOffset < 0 then
            set newOffset = 0
        elseif newOffset > maxOffset then
            set newOffset = maxOffset
        endif
        if newOffset != ShopCraftUpgradeOffset[pid] then
            call BlzSendSyncData("WScU", I2S(newOffset))
        endif
    elseif scrollComponents and componentCount > SHOP_TREE_PAGE then
        set maxOffset = ShopTreeMaxOffset(componentCount, ShopTreeRowsDown[pid])
        set newOffset = ShopCraftComponentOffset[pid]
        if wheelValue < 0.00 then
            set newOffset = newOffset - SHOP_TREE_PAGE
        elseif wheelValue > 0.00 then
            set newOffset = newOffset + SHOP_TREE_PAGE
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
    local integer tab = 0
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
    if GetLocalPlayer() == p then
        loop
            exitwhen tab >= 8
            if FRAME_ShopSection[tab] != null then
                call WUI_SetButtonSelected(FRAME_ShopSection[tab], tab == page and not ShopVipOpen[GetPlayerId(p)])
            endif
            set tab = tab + 1
        endloop
    endif

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

    set ShopSearchPending[pid] = false
    set ShopSearchDebounceTicks[pid] = 0
    set ShopSearchLastQuery[pid] = ""
    set ShopSearchDeadQuery[pid] = ""
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

function ShopApplySearch takes integer pid returns nothing
    local player p = Player(pid)
    local string query = ShopSearchQuery[pid]

    if StringLength(query) == 0 then

        call ShopDeactivateSearch(p, false)

    else

        // Запоминаем страницу, с которой игрок вошёл в поиск.
        if not ShopSearchActive[pid] then
            set ShopSearchReturnPage[pid] = ItemsFrameCurrentPage_ID[pid]
            set ShopSearchActive[pid] = true
        endif

        // Только ЭТОТ pid переходит на страницу поиска.
        set ItemsFrameCurrentPage_ID[pid] = SHOP_SEARCH_PAGE
        set ShopSearchPage[pid] = 0

        call ShopBuildSearchResults(pid, query)

        // Функции внутри уже рисуют фреймы только для p.
        call ReloadItemPage(SHOP_SEARCH_PAGE, p)
        call ShopUpdateCatalogueNavigation(pid, p)

    endif

    set p = null
endfunction
function ShopSearchDebounceTick takes nothing returns nothing
    local integer pid = 0

    loop
        exitwhen pid >= 16

        if ShopSearchPending[pid] then

            set ShopSearchDebounceTicks[pid] = ShopSearchDebounceTicks[pid] - 1

            if ShopSearchDebounceTicks[pid] <= 0 then

                set ShopSearchPending[pid] = false
                set ShopSearchDebounceTicks[pid] = 0

                call ShopApplySearch(pid)
            endif

        endif

        set pid = pid + 1
    endloop
endfunction

function ShopSearchOnTextChanged takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local string enteredText = BlzGetTriggerFrameText()
    local string query
    local string loweredQuery

    // Событие вызвано нашим собственным BlzFrameSetText.
    if ShopSearchUpdating[pid] then
        set p = null
        return
    endif

    set query = ShopSanitizeSearchQuery(enteredText)
    set loweredQuery = StringCase(query, false)

    // Исправляем запрещённые символы только локально
    // у конкретного игрока.
    if enteredText != query then

        set ShopSearchUpdating[pid] = true

        if GetLocalPlayer() == p then
            call BlzFrameSetText(FRAME_ShopSearchEditBox, query)
            call BlzFrameSetFocus(FRAME_ShopSearchEditBox, true)
        endif

        set ShopSearchUpdating[pid] = false
    endif

    set ShopSearchQuery[pid] = query

    // Полностью очистили строку поиска.
    // Тут debounce не нужен — сразу выходим из поиска.
    if StringLength(query) == 0 then

        set ShopSearchPending[pid] = false
        set ShopSearchDebounceTicks[pid] = 0
        set ShopSearchLastQuery[pid] = ""
        set ShopSearchDeadQuery[pid] = ""

        call ShopApplySearch(pid)

        set p = null
        return
    endif

    // Например:
    //
    // "xyz" = 0 результатов.
    //
    // После этого:
    // "xyza"
    // "xyzab"
    // "xyzabcdef"
    //
    // тоже гарантированно не могут ничего найти.
    //
    // Даже debounce НЕ запускаем.
    if StringLength(ShopSearchDeadQuery[pid]) > 0 and /*
    */ ShopSearchStartsWith(loweredQuery, ShopSearchDeadQuery[pid]) then

        set ShopSearchPending[pid] = false
        set ShopSearchDebounceTicks[pid] = 0

        set p = null
        return
    endif

    // Нормальный debounce.
    // Каждая новая буква снова сбрасывает счётчик.
    set ShopSearchPending[pid] = true
    set ShopSearchDebounceTicks[pid] = SHOP_SEARCH_DEBOUNCE_TICKS

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
    if slot < 0 or slot >= SHOP_TREE_SLOTS then
        return 0
    endif
    return ShopCraftSlotItem[pid * SHOP_TREE_SLOTS + slot]
endfunction

// Synced double-click state: a tree rebuild can move the selected item to the
// centre or replace the item under the same physical button between clicks.
function ShopFastAction takes integer pid, integer frameCode, integer id returns integer
    local boolean buying = frameCode >= 200 and frameCode <= 260
    local boolean selling = frameCode >= 300 and frameCode <= 305
    local boolean sameItem = id == ShopLastClickItem[pid]
    if id == 0 or not (buying or selling) then
        return frameCode
    endif
    if buying and frameCode == ShopLastClickCode[pid] then
        set sameItem = true
    endif
    if sameItem and buying == (ShopLastClickCode[pid] < 300) and TimerGetElapsed(ShopClock) - ShopLastClickTime[pid] <= 0.40 then
        set id = ShopLastClickItem[pid]
        set ShopLastClickItem[pid] = 0
        if buying and ShopFastBuy[pid] then
            set ItemsCurrentItem_ID[pid] = id
            return 306
        elseif selling and ShopFastSell[pid] then
            return 307
        endif
    else
        set ShopLastClickItem[pid] = id
        set ShopLastClickCode[pid] = frameCode
        set ShopLastClickTime[pid] = TimerGetElapsed(ShopClock)
    endif
    return frameCode
endfunction

// ===== VIP tab: promotion page =====
function ShopVipText takes framehandle parent, string text, real x, real y, real width, real height, real scale returns framehandle
    local framehandle frame = BlzCreateFrameByType("TEXT", "ShopVipText", parent, "", 0)
    call WUI_Place(frame, x, y, width / scale, height / scale)
    call BlzFrameSetScale(frame, scale)
    call BlzFrameSetText(frame, text)
    call BlzFrameSetEnable(frame, false)
    call BlzFrameSetLevel(frame, 4)
    return frame
endfunction

// One row of example icons: the emojis this tier adds; VIP III also shows its
// exclusive emotes. Empty paths are skipped.
function ShopVipIcons takes integer tier, real x, real y returns nothing
    local framehandle icon
    local string path
    local integer n = 0
    local integer shown = 0
    local real step = 0.0195
    local framehandle label = null
    // VIP III fills its card with perks and two icon rows: no caption there.
    if tier < 3 then
        set label = ShopVipText(FRAME_ShopVipPage, "|cff9aa0a8Examples:|r", x, y + 0.018, 0.160, 0.010, 0.70)
        call BlzFrameSetTextAlignment(label, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    endif
    loop
        // VIP III shows two rows (14) so it has the most examples.
        exitwhen (tier < 3 and shown >= 8) or shown >= 14 or n >= 31
        set path = CustomChat_GetTierEmojiPath(tier, n)
        set n = n + 1
        if path != null and path != "" then
            set icon = BlzCreateFrameByType("BACKDROP", "ShopVipEmoji", FRAME_ShopVipPage, "", tier * 16 + shown)
            if tier == 3 then
                call WUI_Place(icon, x + (I2R(ModuloInteger(shown, 7)) - 3.0) * 0.022, y + 0.011 - I2R(shown / 7) * 0.022, 0.0195, 0.0195)
            else
                call WUI_Place(icon, x + (I2R(shown) - 3.5) * step, y, 0.0175, 0.0175)
            endif
            call BlzFrameSetTexture(icon, path, 0, true)
            call BlzFrameSetLevel(icon, 5)
            call BlzFrameSetEnable(icon, false)
            set shown = shown + 1
        endif
    endloop
    set icon = null
    set label = null
    set path = null
endfunction

// Gold (best) sits in the middle, a bit larger and lifted; bronze / silver
// are smaller. Perks are listed in full on every card; higher tiers use a
// larger font and brighter colours.
function ShopVipCard takes integer tier, real x, real y, real width, real height, string title, string price, string perks, real perkScale returns nothing
    local framehandle card
    local framehandle part
    local real top = y + height * 0.5
    local real bottom = y - height * 0.5
    set card = BlzCreateFrameByType("BACKDROP", "ShopVipCard", FRAME_ShopVipPage, "", tier)
    call WUI_Place(card, x, y, width, height)
    call BlzFrameSetTexture(card, "UI\\WOS\\panel-soft.tga", 0, true)
    call BlzFrameSetLevel(card, 2)
    call BlzFrameSetEnable(card, false)
    // Bronze / silver / gold metal frame per tier.
    set part = BlzCreateFrameByType("BACKDROP", "ShopVipCardFrame", FRAME_ShopVipPage, "", tier)
    call WUI_Place(part, x, y, width + 0.004, height + 0.004)
    if tier == 1 then
        call BlzFrameSetTexture(part, "UI\\WOS\\vip-frame-bronze.tga", 0, true)
    elseif tier == 2 then
        call BlzFrameSetTexture(part, "UI\\WOS\\vip-frame-silver.tga", 0, true)
    else
        call BlzFrameSetTexture(part, "UI\\WOS\\vip-frame-gold.tga", 0, true)
    endif
    call BlzFrameSetLevel(part, 3)
    call BlzFrameSetEnable(part, false)
    set part = ShopVipText(FRAME_ShopVipPage, title, x, top - 0.018, width - 0.010, 0.016, 1.00 + 0.05 * I2R(tier))
    call BlzFrameSetTextAlignment(part, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    set part = ShopVipText(FRAME_ShopVipPage, price, x, top - 0.037, width - 0.010, 0.020, 1.10 + 0.05 * I2R(tier))
    call BlzFrameSetTextAlignment(part, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    set part = ShopVipText(FRAME_ShopVipPage, perks, x + 0.004, top - 0.050 - (height - 0.118) * 0.5, width - 0.026, height - 0.118, perkScale)
    call BlzFrameSetTextAlignment(part, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
    call ShopVipIcons(tier, x, bottom + 0.052)
    // Owner plate at the bottom: gold PURCHASED, thanks line with a heart.
    set FRAME_ShopVipOwned[tier] = BlzCreateFrameByType("FRAME", "ShopVipOwned", FRAME_ShopVipPage, "", tier)
    call WUI_Place(FRAME_ShopVipOwned[tier], x, bottom + 0.016, width - 0.010, 0.026)
    call BlzFrameSetLevel(FRAME_ShopVipOwned[tier], 6)
    set part = ShopVipText(FRAME_ShopVipOwned[tier], "|cffffd34dPURCHASED|r", x, bottom + 0.023, width - 0.010, 0.014, 1.15)
    call BlzFrameSetTextAlignment(part, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    set part = ShopVipText(FRAME_ShopVipOwned[tier], "|cffff9aa2Thank you for your support!|r", x - 0.006, bottom + 0.009, width - 0.030, 0.012, 0.78)
    call BlzFrameSetTextAlignment(part, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    set part = BlzCreateFrameByType("BACKDROP", "ShopVipHeart", FRAME_ShopVipOwned[tier], "", tier)
    call WUI_Place(part, x + 0.062, bottom + 0.009, 0.0115, 0.0115)
    call BlzFrameSetTexture(part, "UI\\WOS\\heart.tga", 0, true)
    call BlzFrameSetEnable(part, false)
    call BlzFrameSetVisible(FRAME_ShopVipOwned[tier], false)
    set card = null
    set part = null
endfunction

// The nickname without a "[VIP]" tag it may already carry (no double tag).
function ShopVipBareName takes string name returns string
    local integer i = 0
    local integer length = StringLength(name)
    loop
        exitwhen i + 5 > length
        if StringCase(SubString(name, i, i + 5), true) == "[VIP]" then
            set name = SubString(name, 0, i)
            if i >= 10 and SubString(name, i - 10, i - 8) == "|c" then
                set name = SubString(name, 0, i - 10)
            endif
            return name
        endif
        set i = i + 1
    endloop
    return name
endfunction

// Highest VIP tier of a nickname (0 = none).
function ShopVipTierOf takes string name returns integer
    set name = ShopVipBareName(name)
    if VIPCheckLvl3(name) then
        return 3
    elseif VIPCheckLvl2(name) then
        return 2
    elseif VIPCheckLvl1(name) then
        return 1
    endif
    return 0
endfunction

function ShopVipLinkEdited takes nothing returns nothing
    // Read-only link: any typing restores it (local, like the music link).
    if GetLocalPlayer() == GetTriggerPlayer() and BlzFrameGetText(FRAME_ShopVipLink) != SHOP_VIP_URL then
        call BlzFrameSetText(FRAME_ShopVipLink, SHOP_VIP_URL)
    endif
endfunction

function ShopCreateVipPage takes nothing returns nothing
    local framehandle part
    local string g = "|cffd5b876"
    local string w = "|cffe1e5eb"
    if FRAME_ShopVipPage != null then
        return
    endif
    set FRAME_ShopVipPage = BlzCreateFrameByType("BACKDROP", "ShopVipPage", FRAME_ShopMAIN, "", 0)
    call WUI_Place(FRAME_ShopVipPage, 0.3485, 0.319, 0.617, 0.328)
    call BlzFrameSetTexture(FRAME_ShopVipPage, WUI_PANEL_TEXTURE, 0, true)
    call BlzFrameSetLevel(FRAME_ShopVipPage, 30)
    call BlzFrameSetEnable(FRAME_ShopVipPage, false)
    set part = WUI_GoldFrame("ShopVipPageEdge", FRAME_ShopVipPage, 0.0036, 0.0070)
    set part = ShopVipText(FRAME_ShopVipPage, "|cffffd34dSUPPORT WAR OF SOULS  -  BECOME A VIP|r", 0.3485, 0.4695, 0.600, 0.020, 1.20)
    call BlzFrameSetTextAlignment(part, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    set part = ShopVipText(FRAME_ShopVipPage, w + "Monthly membership on Buy Me a Coffee. Every level keeps the map growing: new heroes, balance and effects. Your perks unlock in game for your nickname.|r", 0.3485, 0.4530, 0.590, 0.014, 0.80)
    call BlzFrameSetTextAlignment(part, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call ShopVipCard(1, 0.1600, 0.3250, 0.172, 0.196, "|cffe0a070BRONZE  -  VIP I|r", "|cffffffff$5|r " + g + "/ month|r", w + "- Hero aura (Arrow Up)|n- Golden skull on enemies|n  you kill|n- 14 chat emojis|n- Discord role|r", 0.74)
    call ShopVipCard(3, 0.3485, 0.3300, 0.198, 0.226, "|cffffd34dGOLD  -  VIP III|r", "|cffffd34d$20|r " + g + "/ month|r", "|cffffd34dBest value - every perk of the map:|r|n|cffffe9a0- All auras: Panda and Sharingan|n  sets (4 styles each)|n- Arrow Up / Down / Left / Right auras|n- Emoji panel (hotkey K)|n  + exclusive emotes|n- 31 chat emojis|n- |cffffd34d[VIP]|r|cffffe9a0 tag after your name|n- Golden skull on enemies you kill|n- Discord role|r", 0.80)
    call ShopVipCard(2, 0.5370, 0.3250, 0.172, 0.196, "|cffdfe3eaSILVER  -  VIP II|r", "|cffffffff$10|r " + g + "/ month|r", "|cffeef2f8- 3 hero aura styles (Arrow Up)|n- Arrow Down / Right auras|n- Emoji panel (hotkey K)|n- 21 chat emojis|n- Golden skull on enemies|n  you kill|n- Discord role|r", 0.77)
    set FRAME_ShopVipName = ShopVipText(FRAME_ShopVipPage, "", 0.3485, 0.2090, 0.200, 0.012, 0.82)
    call BlzFrameSetTextAlignment(FRAME_ShopVipName, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    set part = ShopVipText(FRAME_ShopVipPage, g + "Join here:|r", 0.3485, 0.1945, 0.560, 0.012, 0.80)
    call BlzFrameSetTextAlignment(part, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    set FRAME_ShopVipLink = null
    if WUI_HasFrameDefinitions() then
        set FRAME_ShopVipLink = BlzCreateFrame("WOSEditBox", FRAME_ShopVipPage, 0, 9171)
    endif
    if FRAME_ShopVipLink != null then
        call WUI_Place(FRAME_ShopVipLink, 0.3485, 0.1735, 0.500, 0.022)
        call BlzFrameSetLevel(FRAME_ShopVipLink, 8)
        call BlzFrameSetText(FRAME_ShopVipLink, SHOP_VIP_URL)
        set ShopVipLinkTrigger = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(ShopVipLinkTrigger, FRAME_ShopVipLink, FRAMEEVENT_EDITBOX_TEXT_CHANGED)
        call TriggerAddAction(ShopVipLinkTrigger, function ShopVipLinkEdited)
    endif
    call BlzFrameSetVisible(FRAME_ShopVipPage, false)
    set part = null
endfunction

// Local: VIP page instead of the catalogue / tree / description.
function ShopShowVip takes player p, boolean open returns nothing
    local integer pid = GetPlayerId(p)
    local integer tab = 0
    // Computed for everyone (plain strings), used only in direct frame calls.
    local string bareName = ShopVipBareName(FramePlayerFirstName[pid])
    local integer owned = ShopVipTierOf(FramePlayerFirstName[pid])
    set ShopVipOpen[pid] = open
    if FRAME_ShopVipPage != null and GetLocalPlayer() == p then
        call BlzFrameSetVisible(FRAME_ShopVipOwned[1], open and owned == 1)
        call BlzFrameSetVisible(FRAME_ShopVipOwned[2], open and owned == 2)
        call BlzFrameSetVisible(FRAME_ShopVipOwned[3], open and owned == 3)
        call BlzFrameSetText(FRAME_ShopVipName, "|cff9aa0a8Your name:|r |cffffffff" + bareName + "|r|cffffd34d[VIP]|r")
    endif
    if GetLocalPlayer() != p or FRAME_ShopVipPage == null then
        return
    endif
    call BlzFrameSetVisible(FRAME_ShopVipPage, open)
    call BlzFrameSetVisible(FRAME_ShopItemList, not open)
    call BlzFrameSetVisible(FRAME_ShopItemCraft, not open)
    call BlzFrameSetVisible(FRAME_ShopItemDescription, not open)
    if open and FRAME_ShopVipLink != null then
        call BlzFrameSetText(FRAME_ShopVipLink, SHOP_VIP_URL)
    endif
    loop
        exitwhen tab >= 8
        if FRAME_ShopSection[tab] != null then
            if open then
                call WUI_SetButtonSelected(FRAME_ShopSection[tab], tab == 7)
            elseif tab == 7 then
                call WUI_SetButtonSelected(FRAME_ShopSection[tab], false)
            endif
        endif
        set tab = tab + 1
    endloop
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
    if frameCode == 408 then
        // Same state change as the shop key (ButtonPressed.j WOS_ToggleShop).
        if GetLocalPlayer() == p then
            call BlzFrameSetEnable(clicked, false)
            call BlzFrameSetEnable(clicked, true)
        endif
        if Shop_Active[pid] then
            set Shop_Active[pid] = false
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(FRAME_ShopMAIN, false)
            endif
        endif
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

if frameCode == 107 then
        call ShopShowVip(p, true)
        set clicked = null
        set d = null
        set p = null
        return
    endif

if frameCode >= 100 and frameCode <= 106 then
    call ShopShowVip(p, false)

    set ShopSearchPending[pid] = false
    set ShopSearchDebounceTicks[pid] = 0
    set ShopSearchLastQuery[pid] = ""
    set ShopSearchDeadQuery[pid] = ""
        
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

    if frameCode >= 200 and frameCode <= 260 then
        set slot = frameCode - 200
        if slot < 35 then
            set id = ShopGetPlayerPageItem(ItemsFrameCurrentPage_ID[pid], pid, slot)
        elseif slot == 42 then
            set id = ItemsCurrentItem_ID[pid]
        else
            set id = ShopGetCraftDisplayItem(pid, ShopTreeSlotFromFrame(slot))
        endif
    elseif frameCode >= 300 and frameCode <= 305 then
        set id = ShopGetInventoryItemId(d, frameCode - 300)
    endif
    set frameCode = ShopFastAction(pid, frameCode, id)

    if GetLocalPlayer() == p then
        call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00Item name|r")
        call BlzFrameSetText(FRAME_ShopItemDescriptionName2, "")
        call BlzFrameSetVisible(FRAME_ShopItemCraftSprite2, false)
    endif

    if frameCode >= 200 and frameCode <= 260 then
        set slot = frameCode - 200
        if slot < 35 then
            set id = ShopGetPlayerPageItem(ItemsFrameCurrentPage_ID[pid], pid, slot)
        elseif slot == 42 then
            set id = ItemsCurrentItem_ID[pid]
        elseif slot >= 36 then
            set id = ShopGetCraftDisplayItem(pid, ShopTreeSlotFromFrame(slot))
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
                call BlzFrameClearAllPoints(FRAME_ShopItemCraftSprite2)
                call BlzFrameSetAllPoints(FRAME_ShopItemCraftSprite2, FRAME_ShopItemInventorySlot[slot])
            endif
            call ShopShowItemDescription(id, p)
            call CraftItemCheck(id, p, ItemsFrameCurrentPage_ID[pid])
        endif
    endif

    // Observer slots may inspect the selected item and its recipe, but cannot buy it.
    if frameCode == 306 and not IsObserverSlot(pid) then
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

    // Inventory buttons are read-only for observers, so selling is impossible too.
    if frameCode == 307 and not IsObserverSlot(pid) and ItemsCurrentItemBag_ID[pid] != 0 and UnitItemInSlot(d, ItemsCurrentItemBag_ID[pid] - 1) != null then
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
    local real invPlate = 0.020
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
                set tooltip = FRAME_ShopInventoryTooltipBox[slot]
                
                if id != 0 then
                    set refundFlag = LoadInteger(hs, GetHandleId(u), ShopRefundKey[slot])
                    set cost = GetItemValue(id)
                    set invCost1 = "|c0000FF00" + I2S(cost) + "|r"
                    set invCost2 = "|c00FFFF00" + I2S(R2I(cost * (RefundPercent/100))) + "|r"
                    set invPlate = ShopPricePlateWidth(cost)
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
                        call BlzFrameSetText(FRAME_ShopInventoryItemName[slot], WUI_TEXT + itemName + "|r")
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
                            call BlzFrameSetVisible(FRAME_ShopInventoryPricePlate[slot], false)
                        else
                            if refundFlag == id then
                                call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[slot], invCost1)
                            else
                                call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[slot], invCost2)
                            endif
                            call BlzFrameSetSize(FRAME_ShopInventoryPricePlate[slot], invPlate, 0.0105)
                            call BlzFrameSetVisible(FRAME_ShopInventoryPricePlate[slot], true)
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

// Local look of the HUD Autobuy toggle.
function ShopShowAutoBuyState takes boolean on returns nothing
    if FRAME_AutoBuyToggle == null then
        return
    endif
    call WUI_SetButtonSelected(FRAME_AutoBuyToggle, on)
    if on then
        call WUI_SetButtonText(FRAME_AutoBuyToggle, "|cff7ee870AUTO ON|r")
    else
        call WUI_SetButtonText(FRAME_AutoBuyToggle, "|cff8d96a3AUTO OFF|r")
    endif
endfunction

function FrameShopCheckboxCheck takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local integer pid = GetPlayerId(GetTriggerPlayer())
    local boolean on
    if clicked == FRAME_AutoBuyToggle then
        // Same state as the old shop checkbox (hashtable key "autobuy").
        if pid >= 0 and pid < 10 and IsActivePlayerSlot(pid) then
            set on = LoadInteger(hs, GetHandleId(Player(pid)), StringHash("autobuy")) != 1
            if on then
                call ResetRecommendedAutoBuy(pid, Hero[pid])
                call SaveInteger(hs, GetHandleId(Player(pid)), StringHash("autobuy"), 1)
            else
                call SaveInteger(hs, GetHandleId(Player(pid)), StringHash("autobuy"), 0)
            endif
            if GetLocalPlayer() == GetTriggerPlayer() then
                call ShopShowAutoBuyState(on)
            endif
        endif
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetEnable(clicked, false)
            call BlzFrameSetEnable(clicked, true)
        endif
    elseif clicked == FRAME_AutoBuyCheckbox then
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

set ShopSearchPending[pid] = false
set ShopSearchDebounceTicks[pid] = 0
set ShopSearchLastQuery[pid] = ""
set ShopSearchDeadQuery[pid] = ""
set ShopSearchUpdating[pid] = true

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

set ShopSearchUpdating[pid] = false
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

    endif
endfunction

// Synced toggle of fast buy / fast sell; the icon changes for its owner only.
function ShopFastToggleClick takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    if BlzGetTriggerFrame() == FRAME_FastBuyToggle then
        set ShopFastBuy[pid] = not ShopFastBuy[pid]
        if GetLocalPlayer() == p then
            if ShopFastBuy[pid] then
                call BlzFrameSetTexture(FRAME_FastBuyIcon, "UI\\WOS\\fastbuy-on.tga", 0, true)
            else
                call BlzFrameSetTexture(FRAME_FastBuyIcon, "UI\\WOS\\fastbuy-off.tga", 0, true)
            endif
        endif
    else
        set ShopFastSell[pid] = not ShopFastSell[pid]
        if GetLocalPlayer() == p then
            if ShopFastSell[pid] then
                call BlzFrameSetTexture(FRAME_FastSellIcon, "UI\\WOS\\fastsell-on.tga", 0, true)
            else
                call BlzFrameSetTexture(FRAME_FastSellIcon, "UI\\WOS\\fastsell-off.tga", 0, true)
            endif
        endif
    endif
    if GetLocalPlayer() == p then
        call BlzFrameSetEnable(BlzGetTriggerFrame(), false)
        call BlzFrameSetEnable(BlzGetTriggerFrame(), true)
    endif
    set p = null
endfunction

function ShopCreateFastToggles takes nothing returns nothing
    local trigger click = CreateTrigger()
    set FRAME_FastBuyToggle = BlzCreateFrameByType("BUTTON", "ShopFastBuy", FRAME_ShopItemInventory, "WOSIconButtonTemplate", 0)
    call WUI_Place(FRAME_FastBuyToggle, SHOP_INV_X - 0.024, 0.169, 0.022, 0.022)
    set FRAME_FastBuyIcon = BlzCreateFrameByType("BACKDROP", "ShopFastBuyIcon", FRAME_FastBuyToggle, "", 0)
    call BlzFrameSetAllPoints(FRAME_FastBuyIcon, FRAME_FastBuyToggle)
    call BlzFrameSetTexture(FRAME_FastBuyIcon, "UI\\WOS\\fastbuy-off.tga", 0, true)
    call BlzFrameSetEnable(FRAME_FastBuyIcon, false)
    call WUI_Tooltip(FRAME_FastBuyToggle, "|cff7ee870FAST BUY|r|nWhen on: double-click an item in the list or the tree to buy it.")
    set FRAME_FastSellToggle = BlzCreateFrameByType("BUTTON", "ShopFastSell", FRAME_ShopItemInventory, "WOSIconButtonTemplate", 0)
    call WUI_Place(FRAME_FastSellToggle, SHOP_INV_X + 0.024, 0.169, 0.022, 0.022)
    set FRAME_FastSellIcon = BlzCreateFrameByType("BACKDROP", "ShopFastSellIcon", FRAME_FastSellToggle, "", 0)
    call BlzFrameSetAllPoints(FRAME_FastSellIcon, FRAME_FastSellToggle)
    call BlzFrameSetTexture(FRAME_FastSellIcon, "UI\\WOS\\fastsell-off.tga", 0, true)
    call BlzFrameSetEnable(FRAME_FastSellIcon, false)
    call WUI_Tooltip(FRAME_FastSellToggle, "|cffff8a73FAST SELL|r|nWhen on: double-click an item of your inventory to sell it.")
    call BlzTriggerRegisterFrameEvent(click, FRAME_FastBuyToggle, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(click, FRAME_FastSellToggle, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(click, function ShopFastToggleClick)
    call TimerStart(ShopClock, 1000000.00, false, null)
    set click = null
endfunction

// Graphite plate + gold hairline under a page arrow (catalogue paging).
function ShopStylePageButton takes framehandle control, framehandle icon, string glyph returns nothing
    local framehandle plate = BlzCreateFrameByType("BACKDROP", "ShopPagePlate", control, "", 0)
    call BlzFrameSetAllPoints(plate, control)
    call BlzFrameSetTexture(plate, WUI_FILL_NORMAL, 0, true)
    call BlzFrameSetEnable(plate, false)
    call BlzFrameSetLevel(plate, 1)
    call WUI_MinimalEdge(plate)
    call BlzFrameClearAllPoints(icon)
    call BlzFrameSetPoint(icon, FRAMEPOINT_CENTER, control, FRAMEPOINT_CENTER, 0.0, 0.0)
    call BlzFrameSetSize(icon, 0.011, 0.011)
    call BlzFrameSetTexture(icon, glyph, 0, true)
    call BlzFrameSetLevel(icon, 3)
    set plate = null
endfunction

function WOS_LayoutShop takes nothing returns nothing
    local integer i = 0
    local integer column
    local integer row
    local integer branch
    local real x
    local real y
    local real joinY
    local real distance
    // Checkpoint 24: the window reaches down to just above the minimap block.
    call WUI_Place(FRAME_ShopMAIN, 0.400, 0.337, 0.756, 0.378)
    // Checkpoint 23: narrower catalogue, wider item tree + description.
    call WUI_Place(FRAME_ShopItemList, SHOP_LIST_X, 0.340, 0.350, 0.282)
    // Checkpoint 26b: tree top level with the inventory (.483), description
    // shorter (it scrolls) and flush below it; bottom level with inventory.
    call WUI_Place(FRAME_ShopItemCraft, SHOP_TREE_X, 0.3595, 0.252, 0.247)
    call WUI_Place(FRAME_ShopItemDescription, SHOP_TREE_X, 0.1955, 0.252, 0.081)
    call WUI_Place(FRAME_ShopItemInventory, SHOP_INV_X, 0.319, 0.112, 0.328)
    call ShopCreateVipPage()
    call WUI_Place(FRAME_ShopRecipeTitle, SHOP_TREE_X, 0.4765, 0.157, 0.012)
    call WUI_Place(FRAME_ShopItemDescriptionName, SHOP_TREE_X, 0.2255, 0.230 / 0.85, 0.016 / 0.85)
    call BlzFrameSetScale(FRAME_ShopItemDescriptionName, 0.85)
    call BlzFrameSetTextAlignment(FRAME_ShopItemDescriptionName, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    // Centred description using the whole block.
    call WUI_Place(FRAME_ShopItemDescriptionName2, SHOP_TREE_X, 0.1905, 0.236 / 0.80, 0.050 / 0.80)
    call BlzFrameSetTextAlignment(FRAME_ShopItemDescriptionName2, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(FRAME_ShopItemDescriptionName2, 0.80)
    call BlzFrameSetEnable(FRAME_ShopItemDescriptionName2, false)
    call WUI_Place(FRAME_ShopItemInventoryName, SHOP_INV_X, 0.468, 0.110, 0.016)
    call BlzFrameSetScale(FRAME_ShopItemInventoryName, 0.90)
    call BlzFrameSetTextAlignment(FRAME_ShopItemInventoryName, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetEnable(FRAME_ShopItemInventoryName, false)
    // Search row: gold caption | inset field with gold edge | clear (X) | Autobuy.
    call WUI_Place(FRAME_ShopSearchLabel, 0.070, 0.165, 0.047, 0.016)
    call BlzFrameSetScale(FRAME_ShopSearchLabel, 0.80)
    call BlzFrameSetTextAlignment(FRAME_ShopSearchLabel, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_RIGHT)
    call WUI_Place(FRAME_ShopSearchEditBox, 0.205, 0.165, 0.230, 0.020)
    call WUI_Place(FRAME_ShopSearchClear, 0.336, 0.165, 0.017, 0.017)
    // Page switch of the catalogue: centred under the grid, above the search.
    call WUI_Place(FRAME_ShopSearchPrevious, SHOP_LIST_X - 0.042, 0.1885, 0.018, 0.016)
    call WUI_Place(FRAME_ShopSearchPageText, SHOP_LIST_X, 0.1885, 0.050, 0.012)
    call BlzFrameSetScale(FRAME_ShopSearchPageText, 0.85)
    call WUI_Place(FRAME_ShopSearchNext, SHOP_LIST_X + 0.042, 0.1885, 0.018, 0.016)
    call ShopStylePageButton(FRAME_ShopSearchPrevious, FRAME_ShopSearchPreviousIcon, "UI\\WOS\\glyph-prev.tga")
    call ShopStylePageButton(FRAME_ShopSearchNext, FRAME_ShopSearchNextIcon, "UI\\WOS\\glyph-next.tga")
    if FRAME_FastBuyToggle == null then
        call ShopCreateFastToggles()
        call ShopCreateDescScroll()
    endif
    // Autobuy lives in the HUD inventory header now (FRAME_AutoBuyToggle).
    call WUI_Place(FRAME_AutoBuyCheckbox, -0.40, -0.40, 0.016, 0.016)
    call WUI_Place(FRAME_AutoBuyText, -0.40, -0.40, 0.060, 0.016)
    call BlzFrameSetVisible(FRAME_AutoBuyCheckbox, false)
    call BlzFrameSetVisible(FRAME_AutoBuyText, false)
    call BlzFrameSetScale(FRAME_AutoBuyText, 0.85)
    call BlzFrameSetTextAlignment(FRAME_AutoBuyText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)
    loop
        exitwhen i >= 8
        call WUI_Place(FRAME_ShopSection[i], 0.0805 + I2R(i) * 0.0905, 0.505, 0.087, 0.027)
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 35
        set column = ModuloInteger(i, 7)
        set row = i / 7
        // Checkpoint 23: smaller icons, tighter grid, the name right below.
        set x = SHOP_LIST_X + I2R(column - 3) * 0.049
        set y = 0.4565 - I2R(row) * 0.0560
        call WUI_Place(FRAME_ShopItem[i], x, y, 0.038, 0.038)
        call ShopPlacePrice(FRAME_ShopItemCost[i], FRAME_ShopItemPricePlate[i], x, y, 0.038)
        call BlzFrameClearAllPoints(FRAME_ShopItemName[i])
        call BlzFrameSetAbsPoint(FRAME_ShopItemName[i], FRAMEPOINT_TOP, x, y - 0.0205)
        call BlzFrameSetSize(FRAME_ShopItemName[i], 0.048 / 0.64, 0.014 / 0.64)
        set i = i + 1
    endloop
    // Tree rows are placed per item when shown (CraftItemCheck); only the
    // centre item is fixed. Its price sits to the right, clear of the lines.
    call WUI_Place(FRAME_ShopItem[42], SHOP_TREE_X, SHOP_TREE_CENTER_Y, 0.030, 0.030)
    call ShopPlacePrice(FRAME_ShopItemCost[42], FRAME_ShopItemPricePlate[42], SHOP_TREE_X, SHOP_TREE_CENTER_Y, 0.030)
    call BlzFrameSetSize(FRAME_ShopItemPricePlate[42], 0.0305, 0.0105)
    set FRAME_ShopItemName[42] = BlzCreateFrameByType("TEXT", "ShopTreeItemName", FRAME_ShopItem[42], "", 42)
    call BlzFrameSetTextAlignment(FRAME_ShopItemName[42], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(FRAME_ShopItemName[42], 0.56)
    call BlzFrameSetEnable(FRAME_ShopItemName[42], false)
    call BlzFrameSetAbsPoint(FRAME_ShopItemName[42], FRAMEPOINT_TOP, SHOP_TREE_X, SHOP_TREE_CENTER_Y - 0.015 - 0.0012)
    call BlzFrameSetSize(FRAME_ShopItemName[42], 0.080 / 0.56, 0.014 / 0.56)
    call BlzFrameSetText(FRAME_ShopItemName[42], "")
    call BlzFrameSetVisible(FRAME_ShopItemPricePlate[42], true)
    set i = 0
    loop
        exitwhen i >= SHOP_TREE_SLOTS
        set branch = ShopTreeFrame(i)
        call BlzFrameSetTextAlignment(FRAME_ShopItemCost[branch], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetEnable(FRAME_ShopItemCost[branch], false)
        // Short trunk from each row to the centre item (one per row is enough;
        // every branch's third segment is the same trunk).
        // Trunks into the centre item; second-level segment 2 is dynamic.
        if i < SHOP_TREE_ROW then
            call WUI_Place(FRAME_ShopRecipeLine[i * 3 + 2], SHOP_TREE_X, 0.3910, 0.0008, 0.0012)
        elseif i >= SHOP_TREE_GROUP and i < SHOP_TREE_GROUP + SHOP_TREE_ROW then
            call WUI_Place(FRAME_ShopRecipeLine[i * 3 + 2], SHOP_TREE_X, 0.3482, 0.0008, 0.0025)
        endif
        // Names under the tree icons (catalogue slots already have theirs).
        if FRAME_ShopItemName[branch] == null then
            set FRAME_ShopItemName[branch] = BlzCreateFrameByType("TEXT", "ShopTreeItemName", FRAME_ShopItem[branch], "", branch)
            call BlzFrameSetTextAlignment(FRAME_ShopItemName[branch], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
            call BlzFrameSetScale(FRAME_ShopItemName[branch], 0.56)
            call BlzFrameSetEnable(FRAME_ShopItemName[branch], false)
            call BlzFrameSetText(FRAME_ShopItemName[branch], "")
        endif
        set i = i + 1
    endloop
    call BlzFrameSetAllPoints(FRAME_ShopItemCraftSprite, FRAME_ShopItem[42])
    // Wider gold slider (the stock 0.007 bar was hard to see and to grab).
    call WUI_Place(FRAME_ShopCraftUpgradeScroll, SHOP_TREE_X + 0.115, 0.438, 0.011, 0.070)
    call WUI_Place(FRAME_ShopCraftComponentScroll, SHOP_TREE_X + 0.115, 0.313, 0.011, 0.070)
    call WUI_Place(FRAME_ShopCraftUpgradeWheelArea, SHOP_TREE_X, 0.438, 0.226, 0.076)
    call WUI_Place(FRAME_ShopCraftComponentWheelArea, SHOP_TREE_X, 0.313, 0.226, 0.076)
    set i = 0
    loop
        exitwhen i >= 8
        set x = SHOP_INV_X - 0.024 + I2R(ModuloInteger(i, 2)) * 0.048
        set y = 0.429 - I2R(i / 2) * 0.061
        if i >= 6 then
            set y = 0.205
        endif
        call WUI_Place(FRAME_ShopItemInventorySlot[i], x, y, 0.038, 0.038)
        call ShopPlacePrice(FRAME_ShopItemInventorySlotCost[i], FRAME_ShopInventoryPricePlate[i], x, y, 0.038)
        if i < 6 then
            set FRAME_ShopInventoryItemName[i] = BlzCreateFrameByType("TEXT", "WOSShopInventoryItemName", FRAME_ShopItemInventorySlot[i], "", i)
            call BlzFrameSetAbsPoint(FRAME_ShopInventoryItemName[i], FRAMEPOINT_TOP, x, y - 0.0205)
            call BlzFrameSetSize(FRAME_ShopInventoryItemName[i], 0.046 / 0.64, 0.020 / 0.64)
            call BlzFrameSetScale(FRAME_ShopInventoryItemName[i], 0.64)
            call BlzFrameSetTextAlignment(FRAME_ShopInventoryItemName[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
            call BlzFrameSetEnable(FRAME_ShopInventoryItemName[i], false)
        endif
        set i = i + 1
    endloop
endfunction

function WOS_CreateShopData takes nothing returns nothing
    local integer i = 1
    local integer pid
    local integer i2 = 0
    local integer k = 0
    local real x = 0.015
    local real y = -0.05
    local framehandle border
    
    set SyncTrigger = CreateTrigger()
    set i = 0
    loop
        exitwhen i > 23
        call BlzTriggerRegisterPlayerSyncEvent(SyncTrigger, Player(i), "WScU", false)
call BlzTriggerRegisterPlayerSyncEvent(SyncTrigger, Player(i), "WScC", false)
call BlzTriggerRegisterPlayerSyncEvent(SyncTrigger, Player(i), "WScO", false)
        set i = i + 1
    endloop
    call TriggerAddAction(SyncTrigger, function SyncDataHandler)
    set i = 1

    loop
        exitwhen i > 15
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
        set ShopSearchPending[pid] = false
        set ShopSearchDebounceTicks[pid] = 0
        set ShopSearchLastQuery[pid] = ""
set ShopSearchDeadQuery[pid] = ""
        
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
    call WUI_OnReady(function MyItemsIdInit)
    call WUI_OnReady(function ShopBuildSearchIndex)
    call WUI_OnReady(function InitCraftRecipes)
    set ShopSearchDebounceTimer = CreateTimer()
call TimerStart(ShopSearchDebounceTimer, SHOP_SEARCH_DEBOUNCE_PERIOD, true, function ShopSearchDebounceTick)

endfunction

function WOS_CreateShopShell takes nothing returns nothing
    local integer i = 1
    local integer pid
    local integer i2 = 0
    local integer k = 0
    local real x = 0.015
    local real y = -0.05
    local framehandle border
    local integer line = 0
    set FRAME_ShopMAIN = WUI_Window("WOSWindow", WUI_GetRoot(), 0, 0)
    // Hero overlays step aside while the shop is open (see WUI_RefreshDocks).
    call WUI_RegisterCover(FRAME_ShopMAIN)
    call WUI_RegisterModal(FRAME_ShopMAIN)
    call WUI_Place(FRAME_ShopMAIN, 0.400, 0.339, 0.756, 0.340)
    set FRAME_ShopItemList = WUI_Window("WOSWindow", FRAME_ShopMAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopItemList, FRAMEPOINT_CENTER, 0.31, 0.355)
    call BlzFrameSetTexture(FRAME_ShopItemList, WUI_PANEL_TEXTURE, 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemList, 255)
    call BlzFrameSetSize(FRAME_ShopItemList, 0.38, 0.28)
    set FRAME_ShopItemCraft = WUI_Window("WOSWindow", FRAME_ShopMAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopItemCraft, FRAMEPOINT_CENTER, 0.5775, 0.405)
    call BlzFrameSetTexture(FRAME_ShopItemCraft, WUI_PANEL_TEXTURE, 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemCraft, 255)
    call BlzFrameSetSize(FRAME_ShopItemCraft, 0.18, 0.18)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopItemCraft), 0, 400)
    call BlzFrameSetEnable(FRAME_ShopItemCraft, true)
    call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopItemCraft, FRAMEEVENT_MOUSE_WHEEL)
    
    set FRAME_ShopCraftUpgradeWheelArea = BlzCreateFrameByType("BUTTON", "ShopCraftUpgradeWheelArea", FRAME_ShopItemCraft, "", 5101)
    call BlzFrameSetPoint(FRAME_ShopCraftUpgradeWheelArea, FRAMEPOINT_TOPLEFT, FRAME_ShopItemCraft, FRAMEPOINT_TOPLEFT, 0.003, -0.003)
    call BlzFrameSetSize(FRAME_ShopCraftUpgradeWheelArea, 0.174, 0.090)
    call BlzFrameSetAlpha(FRAME_ShopCraftUpgradeWheelArea, 0)
    call BlzFrameSetLevel(FRAME_ShopCraftUpgradeWheelArea, 1)
    call BlzFrameSetEnable(FRAME_ShopCraftUpgradeWheelArea, true)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopCraftUpgradeWheelArea), 0, 403)
    call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopCraftUpgradeWheelArea, FRAMEEVENT_MOUSE_WHEEL)
    set FRAME_ShopCraftComponentWheelArea = BlzCreateFrameByType("BUTTON", "ShopCraftComponentWheelArea", FRAME_ShopItemCraft, "", 5102)
    call BlzFrameSetPoint(FRAME_ShopCraftComponentWheelArea, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemCraft, FRAMEPOINT_BOTTOMLEFT, 0.003, 0.003)
    call BlzFrameSetSize(FRAME_ShopCraftComponentWheelArea, 0.174, 0.085)
    call BlzFrameSetAlpha(FRAME_ShopCraftComponentWheelArea, 0)
    call BlzFrameSetLevel(FRAME_ShopCraftComponentWheelArea, 1)
    call BlzFrameSetEnable(FRAME_ShopCraftComponentWheelArea, true)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopCraftComponentWheelArea), 0, 404)
    call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopCraftComponentWheelArea, FRAMEEVENT_MOUSE_WHEEL)
    set FRAME_ShopItemDescription = WUI_Window("WOSWindow", FRAME_ShopMAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopItemDescription, FRAMEPOINT_CENTER, 0.5775, 0.2725)
    call BlzFrameSetTexture(FRAME_ShopItemDescription, WUI_PANEL_TEXTURE, 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemDescription, 255)
    call BlzFrameSetSize(FRAME_ShopItemDescription, 0.18, 0.115)
    set FRAME_ShopItemDescriptionName = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemDescription, "", 0)
    call BlzFrameSetPoint(FRAME_ShopItemDescriptionName, FRAMEPOINT_BOTTOM, FRAME_ShopItemDescription, FRAMEPOINT_TOP, 0, -0.0225 )
    call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00Item name|r")
    set FRAME_ShopItemDescriptionName2 = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemDescription, "", 0)
    call BlzFrameSetSize(FRAME_ShopItemDescriptionName2, 0.15, 0.08)
    call BlzFrameSetPoint(FRAME_ShopItemDescriptionName2, FRAMEPOINT_BOTTOM, FRAME_ShopItemDescription, FRAMEPOINT_CENTER, 0, -0.045 )
    call BlzFrameSetText(FRAME_ShopItemDescriptionName2, "|c00FFFF00|r")
    set FRAME_ShopItemInventory = WUI_Window("WOSWindow", FRAME_ShopMAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopItemInventory, FRAMEPOINT_CENTER, 0.7225, 0.355)
    call BlzFrameSetTexture(FRAME_ShopItemInventory, WUI_PANEL_TEXTURE, 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemInventory, 255)
    call BlzFrameSetSize(FRAME_ShopItemInventory, 0.135, 0.28)
    set FRAME_ShopItemInventoryName = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemInventory, "", 0)
    call BlzFrameSetPoint(FRAME_ShopItemInventoryName, FRAMEPOINT_BOTTOM, FRAME_ShopItemInventory, FRAMEPOINT_TOP, 0, -0.025 )
    call BlzFrameSetText(FRAME_ShopItemInventoryName, "|c00FFFF00Inventory|r")
    set FRAME_ShopSearchLabel = BlzCreateFrameByType("TEXT", "ShopSearchLabel", FRAME_ShopMAIN, "", 0)
    call BlzFrameSetAbsPoint(FRAME_ShopSearchLabel, FRAMEPOINT_CENTER, 0.145, 0.185)
    call BlzFrameSetSize(FRAME_ShopSearchLabel, 0.050, 0.020)
    call BlzFrameSetTextAlignment(FRAME_ShopSearchLabel, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_RIGHT)
    call BlzFrameSetScale(FRAME_ShopSearchLabel, 1.10)
    call BlzFrameSetText(FRAME_ShopSearchLabel, WUI_GOLD + "SEARCH|r")
    // Checkpoint 21: inset field in the UI style (the stock LMP edit template
    // drew broken edge tiles). Falls back to the stock template if needed.
    set FRAME_ShopSearchEditBox = null
    if WUI_HasFrameDefinitions() then
        set FRAME_ShopSearchEditBox = BlzCreateFrame("WOSEditBox", FRAME_ShopMAIN, 0, 0)
    endif
    if FRAME_ShopSearchEditBox == null then
        set FRAME_ShopSearchEditBox = BlzCreateFrame("LMPLinkEditTemplate", FRAME_ShopMAIN, 0, 0)
        call BlzFrameSetAlpha(FRAME_ShopSearchEditBox, 220)
    endif
    call BlzFrameSetAbsPoint(FRAME_ShopSearchEditBox, FRAMEPOINT_CENTER, 0.285, 0.185)
    call BlzFrameSetSize(FRAME_ShopSearchEditBox, 0.195, 0.030)
    call WUI_MinimalEdge(FRAME_ShopSearchEditBox)
    call BlzFrameSetText(FRAME_ShopSearchEditBox, "")
    call BlzFrameSetTextSizeLimit(FRAME_ShopSearchEditBox, 48)
    call BlzTriggerRegisterFrameEvent(FrameShopSearch, FRAME_ShopSearchEditBox, FRAMEEVENT_EDITBOX_TEXT_CHANGED)
    
    set FRAME_ShopSearchClear = BlzCreateFrameByType("BUTTON", "ShopSearchClear", FRAME_ShopMAIN, "WOSIconButtonTemplate", 0)
    call BlzFrameSetAbsPoint(FRAME_ShopSearchClear, FRAMEPOINT_CENTER, 0.398, 0.185)
    call BlzFrameSetSize(FRAME_ShopSearchClear, 0.020, 0.020)
    set FRAME_ShopSearchClearIcon = BlzCreateFrameByType("BACKDROP", "ShopSearchClearIcon", FRAME_ShopSearchClear, "", 0)
    call BlzFrameSetAllPoints(FRAME_ShopSearchClearIcon, FRAME_ShopSearchClear)
    call BlzFrameSetTexture(FRAME_ShopSearchClearIcon, "UI\\WOS\\glyph-close.tga", 0, true)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopSearchClear), 0, 405)
    call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopSearchClear, FRAMEEVENT_CONTROL_CLICK)
    set FRAME_ShopSearchPrevious = BlzCreateFrameByType("BUTTON", "ShopSearchPrevious", FRAME_ShopMAIN, "WOSIconButtonTemplate", 0)
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
    set FRAME_ShopSearchNext = BlzCreateFrameByType("BUTTON", "ShopSearchNext", FRAME_ShopMAIN, "WOSIconButtonTemplate", 0)
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
    set FRAME_ShopItemCraftSprite = WUI_Border("ShopSelectedRecipe", FRAME_ShopItemCraft)
    call BlzFrameSetLevel(FRAME_ShopItemCraftSprite, 25)
    call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, false)
    set FRAME_ShopItemCraftSprite2 = WUI_Border("ShopSelectedInventory", FRAME_ShopItemInventory)
    call BlzFrameSetLevel(FRAME_ShopItemCraftSprite2, 25)
    call BlzFrameSetVisible(FRAME_ShopItemCraftSprite2, false)

    set border = WUI_OrnateWindow("ShopMainMetal", FRAME_ShopMAIN, 0.027)
    // Checkpoint 22: close button set into the top rail, right of the tabs.
    set FRAME_ShopClose = BlzCreateFrameByType("BUTTON", "ShopCloseButton", FRAME_ShopMAIN, "", 0)
    call WUI_Place(FRAME_ShopClose, 0.768, 0.516, 0.016, 0.016)
    call BlzFrameSetLevel(FRAME_ShopClose, 30)
    set border = BlzCreateFrameByType("BACKDROP", "ShopCloseBack", FRAME_ShopClose, "", 0)
    call BlzFrameSetAllPoints(border, FRAME_ShopClose)
    call BlzFrameSetTexture(border, WUI_FILL_NORMAL, 0, true)
    call BlzFrameSetEnable(border, false)
    set border = BlzCreateFrameByType("BACKDROP", "ShopCloseGlyph", FRAME_ShopClose, "", 0)
    call BlzFrameSetPoint(border, FRAMEPOINT_TOPLEFT, FRAME_ShopClose, FRAMEPOINT_TOPLEFT, 0.003, -0.003)
    call BlzFrameSetPoint(border, FRAMEPOINT_BOTTOMRIGHT, FRAME_ShopClose, FRAMEPOINT_BOTTOMRIGHT, -0.003, 0.003)
    call BlzFrameSetTexture(border, "UI\\WOS\\glyph-close.tga", 0, true)
    call BlzFrameSetEnable(border, false)
    call WUI_MinimalEdge(FRAME_ShopClose)
    call WUI_Tooltip(FRAME_ShopClose, "|cffd5b876CLOSE SHOP|r|nOr press the shop key again.")
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopClose), 0, 408)
    call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopClose, FRAMEEVENT_CONTROL_CLICK)
    // Checkpoint 26b: inner shop panels/buttons use the quiet divider edge;
    // only the shop window keeps its ornate frame.
    call WUI_MinimalEdge(FRAME_ShopItemList)
    // Checkpoint 26: item tree + description share ONE ornate frame, split by
    // a horizontal gold divider like the HUD stat columns.
    set border = WUI_Passive("ShopTreeBlock", FRAME_ShopMAIN)
    call BlzFrameSetPoint(border, FRAMEPOINT_TOPLEFT, FRAME_ShopItemCraft, FRAMEPOINT_TOPLEFT, 0.00, 0.00)
    call BlzFrameSetPoint(border, FRAMEPOINT_BOTTOMRIGHT, FRAME_ShopItemDescription, FRAMEPOINT_BOTTOMRIGHT, 0.00, 0.00)
    call BlzFrameSetEnable(border, false)
    call BlzFrameSetLevel(border, 3)
    call WUI_MinimalEdge(border)
    set border = BlzCreateFrameByType("BACKDROP", "ShopTreeDivider", FRAME_ShopItemDescription, "", 0)
    call BlzFrameSetTexture(border, "UI\\WOS\\divider-h.tga", 0, true)
    call BlzFrameSetPoint(border, FRAMEPOINT_LEFT, FRAME_ShopItemDescription, FRAMEPOINT_TOPLEFT, 0.012, 0.00)
    call BlzFrameSetPoint(border, FRAMEPOINT_RIGHT, FRAME_ShopItemDescription, FRAMEPOINT_TOPRIGHT, -0.012, 0.00)
    call BlzFrameSetSize(border, 0.00, 0.004)
    call BlzFrameSetLevel(border, 6)
    call BlzFrameSetEnable(border, false)
    call WUI_MinimalEdge(FRAME_ShopItemInventory)
    set FRAME_ShopRecipeTitle = BlzCreateFrameByType("TEXT", "ShopRecipeTitle", FRAME_ShopItemCraft, "", 0)
    call BlzFrameSetTextAlignment(FRAME_ShopRecipeTitle, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(FRAME_ShopRecipeTitle, 0.82)
    call BlzFrameSetText(FRAME_ShopRecipeTitle, WUI_GOLD + "ITEM TREE|r")
    loop
        exitwhen line >= SHOP_TREE_SLOTS * 3
        set FRAME_ShopRecipeLine[line] = BlzCreateFrameByType("BACKDROP", "ShopRecipeEdge", FRAME_ShopItemCraft, "", line)
        call BlzFrameSetTexture(FRAME_ShopRecipeLine[line], "UI\\WOS\\meter.tga", 0, true)
        call BlzFrameSetLevel(FRAME_ShopRecipeLine[line], 2)
        call BlzFrameSetEnable(FRAME_ShopRecipeLine[line], false)
        call BlzFrameSetVisible(FRAME_ShopRecipeLine[line], false)
        set line = line + 1
    endloop

endfunction

function WOS_CreateShopTabs takes nothing returns nothing
    local integer i = 1
    local integer pid
    local integer i2 = 0
    local integer k = 0
    local real x = 0.015
    local real y = -0.05
    local framehandle border
    set y = 0.47
    set x = 0.075
    set i = 0
    loop
        exitwhen i == 8
        set FRAME_ShopSection[i] = WUI_TextButton("ShopCategory" + I2S(i), FRAME_ShopMAIN, "", 0.098, 0.030)
        call WUI_SetButtonMinimal(FRAME_ShopSection[i])
        call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopSection[i]), 0, 100 + i)
        call BlzFrameSetAbsPoint(FRAME_ShopSection[i], FRAMEPOINT_CENTER, x, y)
        call BlzFrameSetSize(FRAME_ShopSection[i], 0.11, 0.03)
        if i == 0 then
            call WUI_SetButtonCaption(FRAME_ShopSection[i], "Recommended")
        elseif i == 1 then
            call WUI_SetButtonCaption(FRAME_ShopSection[i], "Base")
        elseif i == 2 then
            call WUI_SetButtonCaption(FRAME_ShopSection[i], "Strength")
        elseif i == 3 then
            call WUI_SetButtonCaption(FRAME_ShopSection[i], "Agility")
        elseif i == 4 then
            call WUI_SetButtonCaption(FRAME_ShopSection[i], "Intelligence")
        elseif i == 5 then
            call WUI_SetButtonCaption(FRAME_ShopSection[i], "Universal")
        elseif i == 6 then
            call WUI_SetButtonCaption(FRAME_ShopSection[i], "Defensive")
        else
            call WUI_SetButtonCaption(FRAME_ShopSection[i], "|cffffd34dVIP|r")
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
        // Checkpoint 23: Autobuy toggle in the HUD inventory header (left of
        // the INVENTORY title) - green "AUTO ON" / grey "AUTO OFF".
        set FRAME_AutoBuyToggle = WUI_TextButton("WOSAutoBuyToggle", WUI_GetRoot(), "AUTO OFF", 0.040, 0.012)
        call WUI_PlaceShift(FRAME_AutoBuyToggle, 0.6465, 0.0862, 0.036, 0.010)
        call WUI_SetButtonTextScale(FRAME_AutoBuyToggle, 0.62)
        call ShopShowAutoBuyState(false)
        call WUI_Tooltip(FRAME_AutoBuyToggle, "|cffd5b876AUTOBUY|r|nBuys the recommended items for your hero automatically.")
        call BlzTriggerRegisterFrameEvent(FrameShopCheckbox, FRAME_AutoBuyToggle, FRAMEEVENT_CONTROL_CLICK)
        set FRAME_AutoBuyText = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_ShopMAIN, "", 0)
        call BlzFrameSetSize(FRAME_AutoBuyText, 0.04, 0.01)
        call BlzFrameSetScale(FRAME_AutoBuyText,1.5)
        call BlzFrameSetPoint(FRAME_AutoBuyText, FRAMEPOINT_CENTER, FRAME_ShopMAIN, FRAMEPOINT_CENTER, -0.225, -0.055)
        call BlzFrameSetText(FRAME_AutoBuyText, WUI_TEXT + "Autobuy|r")

endfunction

function WOS_CreateShopCatalogue takes nothing returns nothing
    local integer i = 1
    local integer pid
    local integer i2 = 0
    local integer k = 0
    local real x = 0.015
    local real y = -0.05
    local framehandle border
    set i = 0
    set x = 0.02
    set y = -0.039
    loop
        exitwhen i == 35
        set FRAME_ShopItem[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_ShopItemList, "WOSIconButtonTemplate", 0)
        call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopItem[i]), 0, 200 + i)
        set FRAME_ShopItemBack[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItem[i], "", 0)
        call BlzFrameSetTexture(FRAME_ShopItemBack[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        call BlzFrameSetAllPoints(FRAME_ShopItemBack[i], FRAME_ShopItem[i])
        call BlzFrameSetPoint(FRAME_ShopItem[i], FRAMEPOINT_LEFT, FRAME_ShopItemList, FRAMEPOINT_TOPLEFT, x + 0.05 * k, y )
        call BlzFrameSetSize(FRAME_ShopItem[i], 0.04, 0.04)
        // Checkpoint 23: the name is printed under the icon, no hover tooltip.
        set FRAME_ShopItemTooltipText[i] = ShopCreateItemTooltip(null)
        // Cached now (synchronously): a later BlzFrameGetParent in local
        // rendering would allocate a handle on one client only.
        set FRAME_ShopItemTooltipBox[i] = BlzFrameGetParent(FRAME_ShopItemTooltipText[i])
        set FRAME_ShopItemName[i] = BlzCreateFrameByType("TEXT", "ShopItemName", FRAME_ShopItem[i], "", i)
        call BlzFrameSetTextAlignment(FRAME_ShopItemName[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetScale(FRAME_ShopItemName[i], 0.64)
        call BlzFrameSetEnable(FRAME_ShopItemName[i], false)
        set FRAME_ShopItemPricePlate[i] = BlzCreateFrameByType("BACKDROP", "ShopPricePlate", FRAME_ShopItem[i], "", i)
        call BlzFrameSetTexture(FRAME_ShopItemPricePlate[i], "UI\\WOS\\price-plate.tga", 0, true)
        call BlzFrameSetEnable(FRAME_ShopItemPricePlate[i], false)
        call BlzFrameSetVisible(FRAME_ShopItemPricePlate[i], false)
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

endfunction

function WOS_CreateShopRecipes takes nothing returns nothing
    local integer i = 1
    local integer pid
    local integer i2 = 0
    local integer k = 0
    local real x = 0.015
    local real y = -0.05
    local framehandle border
    set y = -0.039
    set x = 0.02
    set k = 0
    set i = 36
    loop
        exitwhen i == 43
        if i == 42 then
            set k = 0
            set x = x + 0.05
            set y = y + 0.05
        endif
        set FRAME_ShopItem[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_ShopItemCraft, "WOSIconButtonTemplate", 0)
        call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopItem[i]), 0, 200 + i)
        set FRAME_ShopItemBack[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItem[i], "", 0)
        call BlzFrameSetAllPoints(FRAME_ShopItemBack[i], FRAME_ShopItem[i])
        call BlzFrameSetPoint(FRAME_ShopItem[i], FRAMEPOINT_LEFT, FRAME_ShopItemCraft, FRAMEPOINT_TOPLEFT, x + 0.05 * k, y )
        call BlzFrameSetSize(FRAME_ShopItem[i], 0.04, 0.04)
        set FRAME_ShopItemPricePlate[i] = BlzCreateFrameByType("BACKDROP", "ShopTreePricePlate", FRAME_ShopItem[i], "", i)
        call BlzFrameSetTexture(FRAME_ShopItemPricePlate[i], "UI\\WOS\\price-plate.tga", 0, true)
        call BlzFrameSetEnable(FRAME_ShopItemPricePlate[i], false)
        call BlzFrameSetVisible(FRAME_ShopItemPricePlate[i], false)
        set FRAME_ShopItemCost[i] = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItem[i], "", 0)
        call BlzFrameSetPoint(FRAME_ShopItemCost[i], FRAMEPOINT_BOTTOM, FRAME_ShopItemCraft, FRAMEPOINT_TOPLEFT, (x + 0.02) + 0.05 * k, y - 0.03 )
        call BlzFrameSetText(FRAME_ShopItemCost[i], "|c00FFFF00|r")
        if i < 42 then
            call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopItem[i], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetLevel(FRAME_ShopItem[i], 10)
            call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopItem[i], FRAMEEVENT_MOUSE_WHEEL)
            call BlzFrameSetEnable(FRAME_ShopItem[i], false)
        else
            // The tree centre (current item) is clickable too: a double click
            // buys it with Fast Buy (the click handler already reads slot 42).
            call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopItem[i], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetLevel(FRAME_ShopItem[i], 10)
            call BlzFrameSetEnable(FRAME_ShopItem[i], true)
        endif
        if i != 42 then
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

    // Remaining tree slots (checkpoint 24: frames 43..60).
    set i = 43
    loop
        exitwhen i > 60
        set FRAME_ShopItem[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_ShopItemCraft, "WOSIconButtonTemplate", 0)
        call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopItem[i]), 0, 200 + i)
        set FRAME_ShopItemBack[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItem[i], "", 0)
        call BlzFrameSetAllPoints(FRAME_ShopItemBack[i], FRAME_ShopItem[i])
        call WUI_Place(FRAME_ShopItem[i], 0.552, 0.377, 0.036, 0.036)
        set FRAME_ShopItemPricePlate[i] = BlzCreateFrameByType("BACKDROP", "ShopTreePricePlate", FRAME_ShopItem[i], "", i)
        call BlzFrameSetTexture(FRAME_ShopItemPricePlate[i], "UI\\WOS\\price-plate.tga", 0, true)
        call BlzFrameSetEnable(FRAME_ShopItemPricePlate[i], false)
        call BlzFrameSetVisible(FRAME_ShopItemPricePlate[i], false)
        set FRAME_ShopItemCost[i] = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItem[i], "", 0)
        call BlzFrameSetText(FRAME_ShopItemCost[i], "")
        call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopItem[i], FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetLevel(FRAME_ShopItem[i], 10)
        call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopItem[i], FRAMEEVENT_MOUSE_WHEEL)
        call BlzFrameSetEnable(FRAME_ShopItem[i], false)
        call BlzFrameSetVisible(FRAME_ShopItemBack[i], false)
        call BlzFrameSetTexture(FRAME_ShopItemBack[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
        set i = i + 1
    endloop
    set FRAME_ShopCraftUpgradeScroll = null
    set FRAME_ShopCraftComponentScroll = null
    if WUI_HasFrameDefinitions() then
        set FRAME_ShopCraftUpgradeScroll = BlzCreateFrame("WOSVerticalSlider", FRAME_ShopItemCraft, 0, 9150)
        set FRAME_ShopCraftComponentScroll = BlzCreateFrame("WOSVerticalSlider", FRAME_ShopItemCraft, 0, 9151)
    endif
    if FRAME_ShopCraftUpgradeScroll == null then
        set FRAME_ShopCraftUpgradeScroll = BlzCreateFrame("QuestMainListScrollBar", FRAME_ShopItemCraft, 0, 9150)
    endif
    call BlzFrameSetPoint(FRAME_ShopCraftUpgradeScroll, FRAMEPOINT_TOPRIGHT, FRAME_ShopItemCraft, FRAMEPOINT_TOPRIGHT, -0.001, -0.012)
    call BlzFrameSetSize(FRAME_ShopCraftUpgradeScroll, 0.010, 0.060)
    call BlzFrameSetMinMaxValue(FRAME_ShopCraftUpgradeScroll, 0.00, 1.00)
    call BlzFrameSetStepSize(FRAME_ShopCraftUpgradeScroll, 1.00)
    call BlzFrameSetValue(FRAME_ShopCraftUpgradeScroll, 0.00)
    call BlzFrameSetLevel(FRAME_ShopCraftUpgradeScroll, 20)
    call BlzFrameSetVisible(FRAME_ShopCraftUpgradeScroll, false)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopCraftUpgradeScroll), 0, 401)
    call BlzTriggerRegisterFrameEvent(FrameCraftScroll, FRAME_ShopCraftUpgradeScroll, FRAMEEVENT_SLIDER_VALUE_CHANGED)
    // The slider takes the wheel itself (value changed event).
    
    if FRAME_ShopCraftComponentScroll == null then
        set FRAME_ShopCraftComponentScroll = BlzCreateFrame("QuestMainListScrollBar", FRAME_ShopItemCraft, 0, 9151)
    endif
    call BlzFrameSetPoint(FRAME_ShopCraftComponentScroll, FRAMEPOINT_BOTTOMRIGHT, FRAME_ShopItemCraft, FRAMEPOINT_BOTTOMRIGHT, -0.001, 0.012)
    call BlzFrameSetSize(FRAME_ShopCraftComponentScroll, 0.010, 0.060)
    call BlzFrameSetMinMaxValue(FRAME_ShopCraftComponentScroll, 0.00, 1.00)
    call BlzFrameSetStepSize(FRAME_ShopCraftComponentScroll, 1.00)
    call BlzFrameSetValue(FRAME_ShopCraftComponentScroll, 0.00)
    call BlzFrameSetLevel(FRAME_ShopCraftComponentScroll, 20)
    call BlzFrameSetVisible(FRAME_ShopCraftComponentScroll, false)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopCraftComponentScroll), 0, 402)
    call BlzTriggerRegisterFrameEvent(FrameCraftScroll, FRAME_ShopCraftComponentScroll, FRAMEEVENT_SLIDER_VALUE_CHANGED)
    // The slider takes the wheel itself (value changed event).
    

endfunction

function WOS_CreateShopInventory takes nothing returns nothing
    local integer i = 1
    local integer pid
    local integer i2 = 0
    local integer k = 0
    local real x = 0.015
    local real y = -0.05
    local framehandle border
    set y = -0.06
    set x = 0.0225
    set i = 0
    set k = 0
    loop
        exitwhen i == 8
        set FRAME_ShopItemInventorySlot[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_ShopItemInventory, "WOSIconButtonTemplate", 0)
        call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopItemInventorySlot[i]), 0, 300 + i)
        set FRAME_ShopItemInventorySlotBack[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItemInventorySlot[i], "", 0)
        call BlzFrameSetAllPoints(FRAME_ShopItemInventorySlotBack[i], FRAME_ShopItemInventorySlot[i])
        call BlzFrameSetPoint(FRAME_ShopItemInventorySlot[i], FRAMEPOINT_LEFT, FRAME_ShopItemInventory, FRAMEPOINT_TOPLEFT, x + 0.0525 * k, y )
        call BlzFrameSetSize(FRAME_ShopItemInventorySlot[i], 0.04, 0.04)
        if i < 6 then
            set FRAME_ShopInventoryTooltipText[i] = ShopCreateItemTooltip(FRAME_ShopItemInventorySlot[i])
            set FRAME_ShopInventoryTooltipBox[i] = BlzFrameGetParent(FRAME_ShopInventoryTooltipText[i])
            call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[i], false)
        endif
        call BlzFrameSetTexture(FRAME_ShopItemInventorySlotBack[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        set FRAME_ShopInventoryPricePlate[i] = null
        if i < 6 then
            set FRAME_ShopInventoryPricePlate[i] = BlzCreateFrameByType("BACKDROP", "ShopInventoryPricePlate", FRAME_ShopItemInventorySlot[i], "", i)
            call BlzFrameSetTexture(FRAME_ShopInventoryPricePlate[i], "UI\\WOS\\price-plate.tga", 0, true)
            call BlzFrameSetEnable(FRAME_ShopInventoryPricePlate[i], false)
            call BlzFrameSetVisible(FRAME_ShopInventoryPricePlate[i], false)
        endif
        set FRAME_ShopItemInventorySlotCost[i] = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemInventorySlot[i], "", 0)
        call BlzFrameSetPoint(FRAME_ShopItemInventorySlotCost[i], FRAMEPOINT_BOTTOM, FRAME_ShopItemInventory, FRAMEPOINT_TOPLEFT, (x + 0.02) + 0.05 * k, y - 0.032 )
        if i == 6 then
            call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[i], "")
            call BlzFrameSetTexture(FRAME_ShopItemInventorySlotBack[i], "UI\\WOS\\btn-buy.tga", 0, true)
            call BlzFrameSetAlpha(FRAME_ShopItemInventorySlotBack[i], 255)
        elseif i == 7 then
            call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[i], "")
            call BlzFrameSetTexture(FRAME_ShopItemInventorySlotBack[i], "UI\\WOS\\btn-sell.tga", 0, true)
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

function CreateItemUI takes nothing returns nothing
    if ShopUICreated then
        return
    endif
    call WUI_OnReady(function WOS_CreateShopData)
    call WUI_OnReady(function WOS_CreateShopShell)
    call WUI_OnReady(function WOS_CreateShopTabs)
    call WUI_OnReady(function WOS_CreateShopCatalogue)
    call WUI_OnReady(function WOS_CreateShopRecipes)
    call WUI_OnReady(function WOS_CreateShopInventory)
    call WUI_OnReady(function WOS_LayoutShop)
endfunction

function InitTrig_WoS_Shop_Init takes nothing returns nothing
    set gg_trg_WoS_Shop_Init = CreateTrigger()
    call TriggerRegisterTimerEvent(gg_trg_WoS_Shop_Init, 6, false)
    call TriggerAddAction( gg_trg_WoS_Shop_Init, function CreateItemUI )
endfunction
