globals
    // Hashed once at map load (was StringHash(...) on every call).
        integer SH_WoS_Shop_Init_AUTOBUY = StringHash("autobuy")
        integer SH_WoS_Shop_Init_SHOP_KEY_GUARD = StringHash("shop key guard")
        integer SH_WoS_Shop_Init_SOLD_CD = StringHash("sold cd")
endglobals
//==============================================================================
//  SHOP CATALOGUE - which items every tab shows (inside a tab items are sorted by price).
//  Add an item: one line   call ShopCat(SHOP_TAB_<TAB>, 'Ixxx') // name
//  The same item may be listed in several tabs. Recipes: InitCraftRecipes (RegisterCraft).
//==============================================================================
function ShopCat takes integer page, integer itemId returns nothing
    local integer slot = ShopCatCount[page]
    if page < 1 or page > SHOP_PAGE_LAST or slot >= SHOP_CATEGORY_MAX_ITEMS then
        return
    endif
    set ShopCatCount[page] = slot + 1
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
    elseif page == 7 then
        set ItemsPage7_ID[slot] = itemId
    endif
endfunction

function ShopCatalogue_Define takes nothing returns nothing
    local integer page = 1
    loop
        exitwhen page > SHOP_PAGE_LAST
        set ShopCatCount[page] = 0
        set page = page + 1
    endloop
    // ---------------- Base --------------------------------------------------------
    call ShopCat(SHOP_TAB_BASE,          'I00C') // Seal +5
    call ShopCat(SHOP_TAB_BASE,          'I00D') // Urahara Hat +2
    call ShopCat(SHOP_TAB_BASE,          'I04D') // Scroll of Mastery (+2 all stats, round 15+)
    call ShopCat(SHOP_TAB_BASE,          'I02Z') // Tome of Strength +5
    call ShopCat(SHOP_TAB_BASE,          'I032') // Tome of Agility +5
    call ShopCat(SHOP_TAB_BASE,          'I02U') // Tome of Intelligence +5
    call ShopCat(SHOP_TAB_BASE,          'I000') // Necklace +500
    call ShopCat(SHOP_TAB_BASE,          'I018') // Itachi Apron +250
    call ShopCat(SHOP_TAB_BASE,          'I01J') // Pakkun +5
    call ShopCat(SHOP_TAB_BASE,          'I007') // Boots of Speed
    call ShopCat(SHOP_TAB_BASE,          'I026') // School Skirt
    call ShopCat(SHOP_TAB_BASE,          'I027') // School Shirt
    call ShopCat(SHOP_TAB_BASE,          'I014') // Rock Lee Weights
    call ShopCat(SHOP_TAB_BASE,          'I00G') // Funny Barrel
    call ShopCat(SHOP_TAB_BASE,          'I00Q') // Hungry Sin
    call ShopCat(SHOP_TAB_BASE,          'I00N') // Urahara Cane
    call ShopCat(SHOP_TAB_BASE,          'I028') // School Uniform
    call ShopCat(SHOP_TAB_BASE,          'I022') // Future Diary
    call ShopCat(SHOP_TAB_BASE,          'I02K') // Avalon
    call ShopCat(SHOP_TAB_BASE,          'I02R') // Sea God Shield
    call ShopCat(SHOP_TAB_BASE,          'I02P') // Shiki Knife
    call ShopCat(SHOP_TAB_BASE,          'I02O') // Elixir of Life
    call ShopCat(SHOP_TAB_BASE,          'I02T') // Electro Slime
    call ShopCat(SHOP_TAB_BASE,          'I00U') // Hokage Hat
    call ShopCat(SHOP_TAB_BASE,          'I017') // Chogurt
    call ShopCat(SHOP_TAB_BASE,          'I00E') // Incursio
    call ShopCat(SHOP_TAB_BASE,          'I00O') // Urahara Set
    call ShopCat(SHOP_TAB_BASE,          'I01N') // Hiraishin
    call ShopCat(SHOP_TAB_BASE,          'I03Z') // Katana
    // ---------------- Strength ----------------------------------------------------
    call ShopCat(SHOP_TAB_STRENGTH,      'I005') // Tome of Strength +20
    call ShopCat(SHOP_TAB_STRENGTH,      'I02L') // Rhitta
    call ShopCat(SHOP_TAB_STRENGTH,      'I02G') // Mera Mera no Mi
    call ShopCat(SHOP_TAB_STRENGTH,      'I01K') // Frozen Heart
    call ShopCat(SHOP_TAB_STRENGTH,      'I02J') // Guts Armor
    call ShopCat(SHOP_TAB_STRENGTH,      'I02H') // Mirror of Yata
    call ShopCat(SHOP_TAB_STRENGTH,      'I04A') // Hashirama Cells
    // ---------------- Agility -----------------------------------------------------
    call ShopCat(SHOP_TAB_AGILITY,       'I03D') // Tome of Agility +30
    call ShopCat(SHOP_TAB_AGILITY,       'I01I') // Sword of Dracule Mihawk
    call ShopCat(SHOP_TAB_AGILITY,       'I00T') // Raikage Hat
    call ShopCat(SHOP_TAB_AGILITY,       'I010') // Pochita
    call ShopCat(SHOP_TAB_AGILITY,       'I015') // Raijin's Wrath
    call ShopCat(SHOP_TAB_AGILITY,       'I016') // Shark Trail
    call ShopCat(SHOP_TAB_AGILITY,       'I024') // Prison Realm (Active)
    call ShopCat(SHOP_TAB_AGILITY,       'I042') // Shiki Knife Evolved
    call ShopCat(SHOP_TAB_AGILITY,       'I04C') // Ashisogi Jizo
    // ---------------- Intelligence ------------------------------------------------
    call ShopCat(SHOP_TAB_INTELLIGENCE,  'I03H') // Tome of Intelligence +30
    call ShopCat(SHOP_TAB_INTELLIGENCE,  'I00H') // Black Heart
    call ShopCat(SHOP_TAB_INTELLIGENCE,  'I01B') // Itachi Set
    call ShopCat(SHOP_TAB_INTELLIGENCE,  'I01C') // Gokon Tekko
    call ShopCat(SHOP_TAB_INTELLIGENCE,  'I01U') // Red Flower
    call ShopCat(SHOP_TAB_INTELLIGENCE,  'I01S') // Red Cup
    call ShopCat(SHOP_TAB_INTELLIGENCE,  'I011') // Okarun Egg
    // ---------------- Universal ---------------------------------------------------
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I01V') // Tusk Barrel
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I012') // Fairy Tail Emblem
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I02M') // Sacred Gear Booster
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I02F') // Hell Blaze
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I021') // Holy Grail
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I00V') // Bunshin Scroll
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I02A') // Turbo Neko
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I00Z') // Naofumi Shield
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I00M') // Cup of Tea
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I01Q') // Ryujin Jakka
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I01X') // Nejibana
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I01Y') // Gonryomaru
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I01P') // Sogyo no Kotowari
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I02S') // Tachikaze
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I01L') // True Zangetsu
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I00R') // Kazekage Hat
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I01M') // Nichirin Sword Whip
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I00J') // Kansho and Bakuya
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I01O') // Lust Sin
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I02D') // Envy Sin
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I023') // Quincy Cross
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I02B') // Dark Holy Grail
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I00W') // Kurikara
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I019') // Earth Power
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I01W') // Lust Sin Evolved
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I02E') // Wrath Sin
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I03T') // Hogyoku
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I03U') // Chogurt Evolved
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I03V') // Hokage Hat Evolved
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I03W') // Sakura Sesshou
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I040') // Philosopher's Stone
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I041') // Demon-Dweller Sword
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I043') // Cup of Tea Evolved
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I044') // Death Note
    call ShopCat(SHOP_TAB_UNIVERSAL,     'I04B') // Shun Shun Rikka
    // ---------------- Defensive ---------------------------------------------------
    call ShopCat(SHOP_TAB_DEFENSIVE,     'I00I') // Midnight Cloak
    call ShopCat(SHOP_TAB_DEFENSIVE,     'I00K') // Mizukage Hat
    call ShopCat(SHOP_TAB_DEFENSIVE,     'I00Y') // Angel's Blessing
    call ShopCat(SHOP_TAB_DEFENSIVE,     'I020') // The Jewel of Four Souls
    call ShopCat(SHOP_TAB_DEFENSIVE,     'I00L') // Witch Sin
    call ShopCat(SHOP_TAB_DEFENSIVE,     'I00X') // Emperor's Blue Armor
    call ShopCat(SHOP_TAB_DEFENSIVE,     'I00B') // Oken
    call ShopCat(SHOP_TAB_DEFENSIVE,     'I013') // Black Clover
    call ShopCat(SHOP_TAB_DEFENSIVE,     'I02N') // Susanoo Shield
    call ShopCat(SHOP_TAB_DEFENSIVE,     'I045') // Avalon Evolved
    // ---------------- Attack ------------------------------------------------------
    call ShopCat(SHOP_TAB_ATTACK,        'I03Z') // Katana
    call ShopCat(SHOP_TAB_ATTACK,        'I00P') // Tsuchikage Hat
    call ShopCat(SHOP_TAB_ATTACK,        'I02C') // Tsuchikage Hat Evolved
    call ShopCat(SHOP_TAB_ATTACK,        'I03X') // Demon Sword Lostvayne
    call ShopCat(SHOP_TAB_ATTACK,        'I03Y') // Murasame
    call ShopCat(SHOP_TAB_ATTACK,        'I046') // Kusanagi
    call ShopCat(SHOP_TAB_ATTACK,        'I047') // Kusanagi: Blaze Release
    call ShopCat(SHOP_TAB_ATTACK,        'I048') // Kusanagi: Water Release
    call ShopCat(SHOP_TAB_ATTACK,        'I049') // Chidori Kusanagi
endfunction

// WoS Shop - audited/refactored version
// Invariants: catalogue slots 0..34, craft slots 36..46 (42 = centre), inventory slots 0..5.
// Rawcode/item IDs are integers and use 0 (not null) as the empty value.
// В локальных ветках GetLocalPlayer разрешены только прямые операции BlzFrame*.
// Все вычисления, вызовы вспомогательных функций и присваивания выполняются до них.
// Адресные звуки запускаются вне локальных веток через StartSoundForPlayerBJ.

globals
    constant real QB_ABILITY_CHAT_COOLDOWN = 5.00
    real array QB_AbilityChatNext
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
    // Dota-style gold plate in the inventory corner: coin + bright green amount.
    framehandle FRAME_ShopGoldPlate = null
    framehandle FRAME_ShopGoldText = null
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
    integer array ItemsPage7_ID
    integer array ShopCatCount // items declared per page by ShopCat
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
    // Value of consumed components that were still inside their full-refund window.
    integer ShopCraftRefundCredit = 0
    // Charges of a consumed Cup of Tea: the Evolved cup keeps the old threshold.
    integer ShopCraftTeaCharges = 0
    // Scroll of Mastery: consumed on purchase (+2 all stats), sold from this round on.
    constant integer ScrollOfMastery_ID = 'I04D'
    constant integer ScrollOfMastery_Round = 15
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
    // Catalogue tabs: FRAME_ShopSection index == page id; VIP is the last tab.
    constant integer SHOP_TAB_RECOMMENDED = 0
    constant integer SHOP_TAB_BASE = 1
    constant integer SHOP_TAB_STRENGTH = 2
    constant integer SHOP_TAB_AGILITY = 3
    constant integer SHOP_TAB_INTELLIGENCE = 4
    constant integer SHOP_TAB_UNIVERSAL = 5
    constant integer SHOP_TAB_DEFENSIVE = 6
    constant integer SHOP_TAB_ATTACK = 7
    constant integer SHOP_PAGE_LAST = 7 // last catalogue page (ItemsPage1..7_ID)
    constant integer SHOP_TAB_VIP = 8
    constant integer SHOP_TAB_COUNT = 9
    constant integer SHOP_SECTION_STRIDE = 8 // ShopSectionPage[pid * SHOP_SECTION_STRIDE + page]
    constant integer SHOP_SEARCH_PAGE = 9
    constant integer SHOP_SEARCH_PAGE_SIZE = 35
    constant integer SHOP_SEARCH_MAX_RESULTS = 210
    constant integer SHOP_CATEGORY_MAX_ITEMS = 210
    constant integer SHOP_RECOMMENDED_COUNT = 6
    constant integer SHOP_FIRST_ROUND_BUY_LIMIT = 2
    real RefundPercent = 85 // 85 = 85% of item cost
    boolean ShopUICreated = false
    boolean ShopFirstRoundAutoBuyDone = false
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
globals
    hashtable QB_Data = null
    hashtable QB_Frames = null
    unit array QB_AssignedUnit
    integer array QB_Hero
    integer array QB_Version
    integer array QB_Sequence
    integer QB_LocalSequence = 0
    boolean QB_AnyFirstDeferred = false
    boolean array QB_FirstDeferred
    boolean array QB_Awaiting
    integer array QB_Count
    integer array QB_GoalSerial
    integer array QB_NextSerial
    integer array QB_Token
    integer array QB_Order
    integer array QB_OrderCount
    integer array QB_Target
    integer array QB_StepCount
    integer array QB_Step
    integer array QB_Group
    integer array QB_Cost
    integer array QB_StepKey
    boolean array QB_StepMissing
    boolean array QB_AnyMissing
    integer array QB_SubtreeStart
    integer QB_DeferredCost = 0
    sound QB_AddSound = null
    sound QB_RemoveSound = null
    sound QB_ClearSound = null
    // Feedback aliases: change assignments in QB_CreateUI; handles already exist.
    sound REC_AddSound = null
    sound REC_RemoveSound = null
    boolean array QB_Excluded
    integer QB_BuildNode = 0
    boolean QB_ExpansionMissing = false
    string array QB_Error
    integer array QB_Status
    integer array QB_Lock
    integer array QB_Inventory
    boolean array QB_Used
    integer array QB_Stack
    integer QB_BuildPid = 0
    integer QB_BuildGroup = 0
    boolean QB_BuildError = false
    integer QB_DragAge = 0
    boolean QB_AddAvailable = true
    boolean QB_LastShopOpen = false
    integer array QB_AddId
    boolean array QB_AddBanned
    boolean array QB_AddShown
    integer QB_Page = 0
    constant integer REC_CAPACITY = 28
    constant string REC_SYNC = "WOSREC1"
    integer array REC_Item
    integer array REC_Default
    integer array REC_Count
    integer array REC_Version
    integer array REC_Sequence
    integer array REC_LoadBase
    integer array REC_Lock
    integer array REC_LoadMask
    integer array REC_Pending
    integer array REC_LocalItem
    integer REC_LocalSequence = 0
    boolean REC_FileWritable = true
    framehandle array REC_AddButton
    boolean array REC_AddShown
    framehandle REC_Hint = null
    // REC_Render cache (0 unknown, 1 off, 2 on).
    integer REC_ShownState = 0
    integer REC_EnableState = 0
    framehandle array REC_Action
    framehandle array REC_Remove
    framehandle REC_DragLight = null
    framehandle REC_DropLine = null
    integer REC_DragFrom = -1
    integer REC_DragTo = -1
    integer REC_DragVersion = 0
    integer QB_DragTo = -1
    integer array QB_PriceParent
    integer array QB_PriceRemaining
    integer array QB_PriceQueued
    integer array QB_DisplayCost
    integer array ShopRenderedPrice
    integer array ShopPriceInventory
    integer QB_SeenCloseSerial = 0
    integer QB_SeenRenderSerial = 0
    integer QB_DragFrom = -1
    integer QB_DragVersion = 0
    real QB_DragX = 0.00
    real QB_DragY = 0.00
    framehandle array QB_DragArrow
    integer QB_LastViewVersion = -1
    integer QB_LastViewStatus = -1
    integer QB_LastViewPage = -1
    integer array QB_LastPreview
    integer array QB_LastIcon
    boolean array QB_LastSlotShown
    integer array QB_LastCost
    real QB_Right = 0.00
    real QB_Left = 0.665
    real QB_Width = 0.00
    real QB_Size = 0.032
    real QB_InventorySize = 0.028
    integer QB_ViewCount = 12
    integer QB_Columns = 3
    framehandle QB_Panel = null
    framehandle QB_Title = null
    framehandle QB_Hint = null
    framehandle QB_StateText = null
    framehandle QB_First = null
    framehandle QB_StateIcon = null
    framehandle QB_DragLight = null
    framehandle QB_DropLine = null
    framehandle QB_Clear = null
    framehandle QB_Previous = null
    framehandle QB_Next = null
    framehandle array QB_Slot
    framehandle array QB_Icon
    framehandle array QB_SlotEdge
    framehandle array QB_SlotBolt
    framehandle array QB_StepPlate
    framehandle array QB_PriceText
    framehandle array QB_Tip
    framehandle array QB_TipBox
    framehandle array QB_Name
    boolean QB_RightWasDown = false
    framehandle array QB_Remove
    framehandle array QB_Preview
    integer array QB_PreviewStep
    integer array QB_PreviewVersion
    framehandle array QB_PreviewIcon
    framehandle array QB_PreviewPlate
    framehandle array QB_PreviewMinusFace
    framehandle array QB_PreviewRemove
    framehandle array QB_PreviewPrice
    framehandle array QB_PreviewEdge
    framehandle array QB_PreviewBolt
    framehandle array QB_Add
    trigger QB_ClickTrigger = null
    trigger QB_MouseTrigger = null
    trigger QB_SyncTrigger = null
    constant string QB_SYNC = "WOSQB1"
    constant string QB_TEXTURE = "UI\\WOS\\QuickBuy\\qb-"
    constant integer QB_MAX_STEPS = 128
    constant integer QB_VISIBLE = 15
endglobals



// Inlined into TEST WoS_Shop_Init.j. Cache only passive UI geometry, never game
// data. Reapply existing frames on a viewport change without creating handles.
globals
    hashtable Shop_Position = InitHashtable()
    integer Shop_PositionCount = 0
    framehandle array Shop_Frame
    framepointtype array Shop_Point
    boolean array Shop_PlaceMode
    real array Shop_X
    real array Shop_Y
    real array Shop_W
    real array Shop_H
endglobals

function Shop_Shift takes nothing returns real
    return 0.400 - (0.022 + RMinBJ(0.910, WUI_ScreenRight() - 0.012)) * 0.50
endfunction

function Shop_PositionIndex takes framehandle frame returns integer
    local integer index = LoadInteger(Shop_Position, GetHandleId(frame), 0)
    if index == 0 then
        set Shop_PositionCount = Shop_PositionCount + 1
        set index = Shop_PositionCount
        set Shop_Frame[index] = frame
        call SaveInteger(Shop_Position, GetHandleId(frame), 0, index)
    endif
    return index
endfunction

function Shop_Place takes framehandle frame, real x, real y, real width, real height returns nothing
    local integer index
    if frame == null then
        return
    endif
    set index = Shop_PositionIndex(frame)
    set Shop_PlaceMode[index] = true
    set Shop_X[index] = x
    set Shop_Y[index] = y
    set Shop_W[index] = width
    set Shop_H[index] = height
    call WUI_Place(frame, x + Shop_Shift(), y, width, height)
endfunction

function Shop_SetAbsPoint takes framehandle frame, framepointtype point, real x, real y returns nothing
    local integer index
    if frame == null then
        return
    endif
    set index = Shop_PositionIndex(frame)
    set Shop_PlaceMode[index] = false
    set Shop_Point[index] = point
    set Shop_X[index] = x
    set Shop_Y[index] = y
    call BlzFrameSetAbsPoint(frame, point, x + Shop_Shift(), y)
endfunction

function Shop_Recenter takes nothing returns nothing
    local integer index = 1
    local real shift = Shop_Shift()
    loop
        exitwhen index > Shop_PositionCount
        if Shop_PlaceMode[index] then
            call WUI_Place(Shop_Frame[index], Shop_X[index] + shift, Shop_Y[index], Shop_W[index], Shop_H[index])
        else
            call BlzFrameSetAbsPoint(Shop_Frame[index], Shop_Point[index], Shop_X[index] + shift, Shop_Y[index])
        endif
        set index = index + 1
    endloop
endfunction

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
        if ch == "\n" or ch == "\r" then
            // Object-editor tooltips use real line breaks, not only |n.
            set ShopDescLine[ShopDescCount] = lineColor + SubString(text, lineStart, i)
            set ShopDescCount = ShopDescCount + 1
            set i = i + 1
            if ch == "\r" and SubString(text, i, i + 1) == "\n" then
                set i = i + 1
            endif
            set lineStart = i
            set lineColor = color
            set visible = 0
            set lastSpace = -1
        elseif ch == "|" and i + 1 < length then
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
    call WUI_RegisterPassiveFocus(FRAME_ShopDescWheel)
    call Shop_Place(FRAME_ShopDescWheel, SHOP_TREE_X, 0.1905, 0.236, 0.052)
    if WUI_HasFrameDefinitions() then
        set FRAME_ShopDescScroll = BlzCreateFrame("WOSVerticalSlider", FRAME_ShopItemDescription, 0, 9152)
    endif
    if FRAME_ShopDescScroll == null then
        set FRAME_ShopDescScroll = BlzCreateFrame("QuestMainListScrollBar", FRAME_ShopItemDescription, 0, 9152)
    endif
    call Shop_Place(FRAME_ShopDescScroll, SHOP_TREE_X + 0.117, 0.1905, 0.009, 0.048)
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
    elseif page == 7 then
        return ItemsPage7_ID[slot]
    endif
    return 0
endfunction

function ShopGetPlayerPageItem takes integer page, integer pid, integer slot returns integer
    if page == 0 then
        return ItemsPage0_ID[pid * SHOP_SEARCH_PAGE_SIZE + slot]
    elseif page >= 1 and page <= SHOP_PAGE_LAST then
        return ShopGetStaticPageItem(page, ShopSectionPage[pid * SHOP_SECTION_STRIDE + page] * SHOP_SEARCH_PAGE_SIZE + slot)
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
        exitwhen page > SHOP_PAGE_LAST

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
    call Shop_SetAbsPoint(cost, FRAMEPOINT_CENTER, x, py)
    call BlzFrameSetSize(cost, size / 0.78, 0.010 / 0.78)
    call BlzFrameSetScale(cost, 0.78)
    call BlzFrameSetTextAlignment(cost, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetEnable(cost, false)
    call BlzFrameSetLevel(cost, 4)
    if plate != null then
        call Shop_Place(plate, x, py, 0.020, 0.0105)
        call BlzFrameSetLevel(plate, 3)
    endif
endfunction

// Local presentation cache, fed by the actual catalogue/tree renderers.
// Called only from agreed paths; local templates never feed gameplay directly.


function QB_SetAddFrame takes integer index, integer id, boolean banned returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local boolean shown = false
    local integer targetIndex = 0
    set QB_AddId[index] = id
    set QB_AddBanned[index] = banned
    if REC_AddButton[index] != null then
        set shown = IsGamePlayerSlot(pid) and id != 0 and not banned and LoadBoolean(QB_Data, id, 0) and QB_Hero[pid] != 0 and not QB_Awaiting[pid] and REC_Count[pid] < REC_CAPACITY
        if index < 35 and ItemsFrameCurrentPage_ID[pid] == 0 and not ShopSearchActive[pid] then
            set shown = false
        endif
        set targetIndex = 0
        loop
            exitwhen not shown or targetIndex >= REC_Count[pid]
            if REC_Item[pid * REC_CAPACITY + targetIndex] == id then
                set shown = false
            endif
            set targetIndex = targetIndex + 1
        endloop
        if REC_AddShown[index] != shown then
            set REC_AddShown[index] = shown
            call BlzFrameSetVisible(REC_AddButton[index], shown)
        endif
    endif
    set shown = false
    set targetIndex = 0
    if QB_Add[index] == null then
        return
    endif
    if IsGamePlayerSlot(pid) and QB_Data != null then
        set shown = id != 0 and not banned and LoadBoolean(QB_Data, id, 0) and QB_Hero[pid] != 0 and not QB_Awaiting[pid] and QB_Count[pid] < 6
    endif
    loop
        exitwhen not shown or targetIndex >= QB_Count[pid]
        if QB_Target[pid * 6 + targetIndex] == id then
            set shown = false
        endif
        set targetIndex = targetIndex + 1
    endloop
    if QB_AddShown[index] != shown then
        set QB_AddShown[index] = shown
        call BlzFrameSetVisible(QB_Add[index], shown)
    endif
endfunction

function QB_RefreshAdds takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i >= 61
        if QB_Add[i] != null then
            call QB_SetAddFrame(i, QB_AddId[i], QB_AddBanned[i])
        endif
        set i = i + 1
    endloop
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
    elseif page == 7 then
        set ItemsPage7_ID[slot] = itemId
    endif
endfunction

function ShopGetSectionPageCount takes integer page returns integer
    local integer slot = SHOP_CATEGORY_MAX_ITEMS - 1
    if page < 1 or page > SHOP_PAGE_LAST then
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
        exitwhen page > SHOP_PAGE_LAST
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
    call ShopCatalogue_Define()

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
    if ItemsPage7_ID[k] != 0 then
    call GetItemValue(ItemsPage7_ID[k])
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
                    if LoadInteger(hs, GetHandleId(u), GearKey(GEAR_KEY_FULLREFUND, "fullrefund_", inventorySlot)) == componentId then
                        set ShopCraftRefundCredit = ShopCraftRefundCredit + GetItemValue(componentId)
                        call RemoveSavedInteger(hs, GetHandleId(u), GearKey(GEAR_KEY_FULLREFUND, "fullrefund_", inventorySlot))
                    endif
                    if componentId == 'I00M' then
                        set ShopCraftTeaCharges = GetItemCharges(it)
                    endif
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
    if remove then
        set ShopCraftRefundCredit = 0
        set ShopCraftTeaCharges = 0
    endif
    return ReduceCostRecursive(u, id, cost, remove)
endfunction

// Round-gated items (manual buy, Quick Buy and Auto Buy all ask here before paying).
function ShopRoundLocked takes integer id returns boolean
    return id == ScrollOfMastery_ID and CurrentRound < ScrollOfMastery_Round
endfunction

// After UnitAddItemById: the item sells back at full price for Refund100Time when the
// whole value was paid within the window (gold now + components still under their mark).
// Quick Buy / Auto Buy assemble from parts, so they now get the same refund as one click.
function ShopMarkFullRefund takes unit u, integer id, integer paid returns nothing
    local integer slot = IsItemInInventory3(u, id)
    if slot != -1 and paid + ShopCraftRefundCredit >= GetItemValue(id) then
        call SaveInteger(hs, GetHandleId(u), GearKey(GEAR_KEY_FULLREFUND, "fullrefund_", slot), id)
        call MyFlush(GetHandleId(u), GearKey(GEAR_KEY_FULLREFUND, "fullrefund_", slot), 0, Refund100Time)
    endif
    set ShopCraftRefundCredit = 0
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
    // Round-gated items look and act like banned combinations until their round.
    if ShopRoundLocked(id) then
        return true
    endif
    if CheckBanGroup(c, id, 'I01Q', 'I01X', 'I01Y') then
        return true
    endif
    if CheckBanGroup(c, id, 'I00E', 'I00O','I01N' ) then
        return true
    endif
    if CheckBanGroup(c, id, 'I03E', 'I03F','I02T' ) then
        return true
    endif
    if CheckBanGroup(c, id, KusanagiFire_ID, KusanagiWater_ID, KusanagiElectro_ID) then // one elemental Kusanagi
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
    call RegisterCraft('I046', "I03Z I035") // Kusanagi: Katana + Pakkun +12 (+1250)
    call RegisterCraft('I047', "I046 I03E") // Kusanagi: Blaze Release: Kusanagi + Piro Slime (+3500)
    call RegisterCraft('I048', "I046 I03F") // Kusanagi: Water Release: Kusanagi + Hydro Slime (+3500)
    call RegisterCraft('I049', "I046 I02T") // Chidori Kusanagi: Kusanagi + Electro Slime (+3500)
    call RegisterCraft('I04A', "I02K I02Y") // Hashirama Cells: Avalon + Tome of Strength +10 (+1500)
    call RegisterCraft('I04B', "I000 I036") // Shun Shun Rikka: Necklace +500 + Pakkun +15 (+1250)
    call RegisterCraft('I04C', "I031 I034") // Ashisogi Jizo: Tome of Agility +10 + Pakkun +10 (+2000)
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
            call QB_SetAddFrame(frameIndex, 0, true)
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

// Agreed selection reset; only the owner's existing frames are painted below.
function ShopClearItemTree takes player p returns nothing
    local integer pid = GetPlayerId(p)
    local integer slot = 0
    local integer fr
    set ItemsCurrentItem_ID[pid] = 0
    set ItemsCurrentItem_ID_BACKUP[pid] = 0
    set ItemsCurrentItemBag_ID[pid] = 0
    set ItemsCurrentItemCraft_ID[pid] = 0
    set ItemsFrameCurrentItem_ID[pid] = 0
    set ItemsCraftPlayerDebug_ID[pid] = -1
    set ItemsCraftPlayerDebug2_ID[pid] = -1
    set ShopCraftScrollItemId[pid] = 0
    set ShopCraftUpgradeOffset[pid] = 0
    set ShopCraftComponentOffset[pid] = 0
    set ShopCraftUpgradeMaxPage[pid] = 0
    set ShopCraftComponentMaxPage[pid] = 0
    set ShopTreeRowsUp[pid] = 0
    set ShopTreeRowsDown[pid] = 0
    set ShopLastClickItem[pid] = 0
    set ShopLastClickCode[pid] = 0
    set ShopLastClickTime[pid] = 0.00
    loop
        exitwhen slot >= SHOP_TREE_SLOTS
        call SetPlayerCraftSlot(pid, slot, 0)
        set ShopTreeSlotTopP[pid * SHOP_TREE_SLOTS + slot] = 0
        set slot = slot + 1
    endloop
    call ResetCraftFrames(p)
    if GetLocalPlayer() == p then
        set slot = 0
        loop
            exitwhen slot >= SHOP_TREE_SLOTS
            set fr = ShopTreeFrame(slot)
            call BlzFrameSetVisible(FRAME_ShopItem[fr], false)
            call ShopShowRecipeBranch(slot, false)
            set slot = slot + 1
        endloop
        call QB_SetAddFrame(42, 0, true)
        call BlzFrameSetEnable(FRAME_ShopItem[42], false)
        call BlzFrameSetVisible(FRAME_ShopItem[42], false)
        call BlzFrameSetTexture(FRAME_ShopItemBack[42], WUI_EMPTY_TEXTURE, 0, true)
        call BlzFrameSetText(FRAME_ShopItemCost[42], "")
        call BlzFrameSetText(FRAME_ShopItemName[42], "")
        call BlzFrameSetText(FRAME_ShopItemTooltipText[42], "")
        call BlzFrameSetVisible(FRAME_ShopItemTooltipBox[42], false)
        call BlzFrameSetVisible(FRAME_ShopItemPricePlate[42], false)
        call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, false)
        call BlzFrameSetVisible(FRAME_ShopItemCraftSprite2, false)
        call BlzFrameSetVisible(FRAME_ShopCraftUpgradeScroll, false)
        call BlzFrameSetVisible(FRAME_ShopCraftComponentScroll, false)
        call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], false)
        call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], false)
        call BlzFrameSetText(FRAME_ShopItemDescriptionName, "")
        set ShopDescCount = 0
        set ShopDescOffset = 0
        call ShopDescRender()
    endif
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
    local boolean centreBanned = false
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
    if id == 0 then
        call ShopClearItemTree(p)
        set selectedUnit = null
        return
    endif
    set centreBanned = CheckBanItems(id, selectedUnit)
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
        call BlzFrameSetVisible(FRAME_ShopItem[42], true)
        call BlzFrameSetEnable(FRAME_ShopItem[42], not centreBanned)
        call BlzFrameSetVisible(FRAME_ShopItemPricePlate[42], true)
        call BlzFrameSetText(FRAME_ShopItemTooltipText[42], WUI_TEXT + GetObjectName(id) + "|r")
        call BlzFrameClearAllPoints(FRAME_ShopItem[42])
        call Shop_SetAbsPoint(FRAME_ShopItem[42], FRAMEPOINT_CENTER, SHOP_TREE_X, centreY)
        call BlzFrameSetSize(FRAME_ShopItem[42], 0.030, 0.030)
        call BlzFrameClearAllPoints(FRAME_ShopItemCost[42])
        call Shop_SetAbsPoint(FRAME_ShopItemCost[42], FRAMEPOINT_CENTER, SHOP_TREE_X, centreY - 0.015 + 0.0068)
        call BlzFrameClearAllPoints(FRAME_ShopItemPricePlate[42])
        call Shop_SetAbsPoint(FRAME_ShopItemPricePlate[42], FRAMEPOINT_CENTER, SHOP_TREE_X, centreY - 0.015 + 0.0068)
        call BlzFrameSetSize(FRAME_ShopItemPricePlate[42], 0.0305, 0.0105)
        call BlzFrameClearAllPoints(FRAME_ShopItemName[42])
        call Shop_SetAbsPoint(FRAME_ShopItemName[42], FRAMEPOINT_TOP, SHOP_TREE_X, centreY - 0.015 - 0.0012)
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
                call Shop_SetAbsPoint(FRAME_ShopItem[frameIndex], FRAMEPOINT_CENTER, x, y)
                call BlzFrameSetSize(FRAME_ShopItem[frameIndex], size, size)
                call BlzFrameClearAllPoints(FRAME_ShopItemCost[frameIndex])
                call Shop_SetAbsPoint(FRAME_ShopItemCost[frameIndex], FRAMEPOINT_CENTER, x, costY)
                call BlzFrameSetScale(FRAME_ShopItemCost[frameIndex], priceScale)
                call BlzFrameSetSize(FRAME_ShopItemCost[frameIndex], 0.036 / priceScale, 0.010 / priceScale)
                call BlzFrameSetLevel(FRAME_ShopItemCost[frameIndex], 4)
                call BlzFrameClearAllPoints(FRAME_ShopItemPricePlate[frameIndex])
                call Shop_SetAbsPoint(FRAME_ShopItemPricePlate[frameIndex], FRAMEPOINT_CENTER, x, costY)
                call BlzFrameSetSize(FRAME_ShopItemPricePlate[frameIndex], plateWidth, 0.0105 * priceScale / 0.78)
                call BlzFrameSetLevel(FRAME_ShopItemPricePlate[frameIndex], 3)
                call BlzFrameSetVisible(FRAME_ShopItemPricePlate[frameIndex], true)
                // Segment 0: from the icon to its rail; 1: along the rail to the
                // parent's x; 2: (second level only) down/up into the parent.
                call BlzFrameClearAllPoints(FRAME_ShopRecipeLine[slot * 3])
                call Shop_SetAbsPoint(FRAME_ShopRecipeLine[slot * 3], FRAMEPOINT_CENTER, x, (edgeY + joinY) * 0.50)
                call BlzFrameSetSize(FRAME_ShopRecipeLine[slot * 3], 0.0008, RAbsBJ(edgeY - joinY))
                call BlzFrameClearAllPoints(FRAME_ShopRecipeLine[slot * 3 + 1])
                call Shop_SetAbsPoint(FRAME_ShopRecipeLine[slot * 3 + 1], FRAMEPOINT_CENTER, (x + parentX) * 0.50, joinY)
                call BlzFrameSetSize(FRAME_ShopRecipeLine[slot * 3 + 1], RMaxBJ(0.0008, RAbsBJ(x - parentX)), 0.0008)
                call BlzFrameClearAllPoints(FRAME_ShopRecipeLine[slot * 3 + 2])
                call Shop_SetAbsPoint(FRAME_ShopRecipeLine[slot * 3 + 2], FRAMEPOINT_CENTER, parentX, (joinY + parentEdge) * 0.50)
                call BlzFrameSetSize(FRAME_ShopRecipeLine[slot * 3 + 2], 0.0008, RMaxBJ(0.0008, RAbsBJ(joinY - parentEdge)))
                call BlzFrameSetEnable(FRAME_ShopItem[frameIndex], not relatedBanned)
                call QB_SetAddFrame(frameIndex, relatedId, relatedBanned)
                call BlzFrameSetTexture(FRAME_ShopItemBack[frameIndex], relatedIconPath, 0, false)
                call BlzFrameSetVisible(FRAME_ShopItem[frameIndex], true)
                call BlzFrameSetVisible(FRAME_ShopItemBack[frameIndex], true)
                call BlzFrameSetText(FRAME_ShopItemCost[frameIndex], costStr)
                call BlzFrameClearAllPoints(FRAME_ShopItemName[frameIndex])
                call Shop_SetAbsPoint(FRAME_ShopItemName[frameIndex], FRAMEPOINT_TOP, x, y - size * 0.50 - 0.0012)
                call BlzFrameSetSize(FRAME_ShopItemName[frameIndex], (ShopTreeStep(rowCount) - 0.002) / 0.56, 0.014 / 0.56)
                call BlzFrameSetText(FRAME_ShopItemName[frameIndex], WUI_TEXT + GetObjectName(relatedId) + "|r")
            endif
        endif
        set slot = slot + 1
    endloop

    if GetLocalPlayer() == p then
        call QB_SetAddFrame(42, id, centreBanned)
    endif
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

function QB_Valid takes integer id returns boolean
    return id != 0 and LoadBoolean(QB_Data, id, 0)
endfunction

function REC_Active takes integer pid returns boolean
    return ItemsFrameCurrentPage_ID[pid] == 0 and not ShopSearchActive[pid] and not ShopVipOpen[pid]
endfunction

function REC_Render takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local integer i = 0
    local boolean shown
    local boolean slotShown
    local integer state
    if REC_Action[0] == null or not IsGamePlayerSlot(pid) then
        return
    endif
    set shown = REC_Active(pid)
    // 0.50 s render: hint/actions are written only when their state changes.
    set state = 1
    if shown then
        set state = 2
    endif
    if REC_ShownState != state then
        set REC_ShownState = state
        if REC_Hint != null then
            call BlzFrameSetVisible(REC_Hint, shown)
        endif
        loop
            exitwhen i >= 4
            call BlzFrameSetVisible(REC_Action[i], shown)
            set i = i + 1
        endloop
    endif
    set state = 1
    if QB_Hero[pid] != 0 and not QB_Awaiting[pid] then
        set state = 2
    endif
    if REC_EnableState != state then
        set REC_EnableState = state
        set i = 0
        loop
            exitwhen i >= 4
            call BlzFrameSetEnable(REC_Action[i], QB_Hero[pid] != 0 and not QB_Awaiting[pid])
            set i = i + 1
        endloop
    endif
    set i = 0
    loop
        exitwhen i >= 35
        set slotShown = not shown or i < REC_CAPACITY
        if BlzFrameIsVisible(FRAME_ShopItem[i]) != slotShown then
            call BlzFrameSetVisible(FRAME_ShopItem[i], slotShown)
        endif
        if i < REC_CAPACITY then
            if BlzFrameIsVisible(REC_Remove[i]) != (shown and i < REC_Count[pid]) then
                call BlzFrameSetVisible(REC_Remove[i], shown and i < REC_Count[pid])
            endif
        endif
        set i = i + 1
    endloop
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
    local real tooltipWidth = 0.045
    local framehandle tooltip = FRAME_ShopItemTooltipBox[slot]
    local real plateWidth = 0.020
    
    if id != 0 then
        if QB_Data != null and QB_Valid(id) then
            set price = LoadInteger(QB_Data, id, 1)
        else
            set price = GetItemValue(id)
        endif
        if Hero[GetPlayerId(p)] != null then
            set price = IMaxBJ(0, CheckItemsReduceCostCraft(Hero[GetPlayerId(p)], price, id, false))
        endif
        // Строки собираются глобально для избежания десинка, но только для
        // изменившихся ячеек: full/ban/price флаги одинаковы на всех клиентах.
        if fullRefresh or ShopRenderedPrice[cacheIndex] != price then
            set plateWidth = ShopPricePlateWidth(price)
            set costStr = "|c00FFFF00" + I2S(price) + "|r"
        endif
        if fullRefresh then
            set itemName = GetObjectName(id)
            set tooltipNameStr = "|cffffffff" + itemName + "|r"
            set tooltipWidth = ShopGetItemTooltipWidth(itemName)
        endif
        if fullRefresh or banRefresh then
            set iconPath = BlzGetAbilityIcon(id)
            if banned then
                set iconPath = ConvertBTNtoDISBTN(iconPath)
            endif
        endif
    elseif fullRefresh then
        set tooltipWidth = ShopGetItemTooltipWidth("")
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
        if id != 0 and ShopRenderedPrice[cacheIndex] != price then
            call BlzFrameSetText(FRAME_ShopItemCost[slot], costStr)
            call BlzFrameSetSize(FRAME_ShopItemPricePlate[slot], plateWidth, 0.0105)
        endif
    endif
    if GetLocalPlayer() == p then
        call QB_SetAddFrame(slot, id, banned)
    endif
    set ShopRenderedPrice[cacheIndex] = price
    set ShopRenderedItemId[cacheIndex] = id
    set ShopRenderedBanned[cacheIndex] = banned
    set ShopRenderedInitialized[cacheIndex] = true
    set tooltip = null
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
        call REC_Render()
        loop
            exitwhen tab >= SHOP_TAB_COUNT
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
    elseif section >= 1 and section <= SHOP_PAGE_LAST then
        set pageCount = ShopGetSectionPageCount(section)
        set currentPage = ShopSectionPage[pid * SHOP_SECTION_STRIDE + section]
        if currentPage >= pageCount then
            set currentPage = pageCount - 1
            set ShopSectionPage[pid * SHOP_SECTION_STRIDE + section] = currentPage
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
    call Shop_Place(frame, x, y, width / scale, height / scale)
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
                call Shop_Place(icon, x + (I2R(ModuloInteger(shown, 7)) - 3.0) * 0.022, y + 0.011 - I2R(shown / 7) * 0.022, 0.0195, 0.0195)
            else
                call Shop_Place(icon, x + (I2R(shown) - 3.5) * step, y, 0.0175, 0.0175)
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
    call Shop_Place(card, x, y, width, height)
    call BlzFrameSetTexture(card, "UI\\WOS\\panel-soft.tga", 0, true)
    call BlzFrameSetLevel(card, 2)
    call BlzFrameSetEnable(card, false)
    // Bronze / silver / gold metal frame per tier.
    set part = BlzCreateFrameByType("BACKDROP", "ShopVipCardFrame", FRAME_ShopVipPage, "", tier)
    call Shop_Place(part, x, y, width + 0.004, height + 0.004)
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
    call Shop_Place(FRAME_ShopVipOwned[tier], x, bottom + 0.016, width - 0.010, 0.026)
    call BlzFrameSetLevel(FRAME_ShopVipOwned[tier], 6)
    set part = ShopVipText(FRAME_ShopVipOwned[tier], "|cffffd34dPURCHASED|r", x, bottom + 0.023, width - 0.010, 0.014, 1.15)
    call BlzFrameSetTextAlignment(part, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    set part = ShopVipText(FRAME_ShopVipOwned[tier], "|cffff9aa2Thank you for your support!|r", x - 0.006, bottom + 0.009, width - 0.030, 0.012, 0.78)
    call BlzFrameSetTextAlignment(part, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    set part = BlzCreateFrameByType("BACKDROP", "ShopVipHeart", FRAME_ShopVipOwned[tier], "", tier)
    call Shop_Place(part, x + 0.062, bottom + 0.009, 0.0115, 0.0115)
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
    call Shop_Place(FRAME_ShopVipPage, 0.3485, 0.319, 0.617, 0.328)
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
        call Shop_Place(FRAME_ShopVipLink, 0.3485, 0.1735, 0.500, 0.022)
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
        exitwhen tab >= SHOP_TAB_COUNT
        if FRAME_ShopSection[tab] != null then
            if open then
                call WUI_SetButtonSelected(FRAME_ShopSection[tab], tab == SHOP_TAB_VIP)
            elseif tab == SHOP_TAB_VIP then
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
        if Shop_Active[pid] then
            set Shop_Active[pid] = false
            call WUI_SetShopRmb(pid, false)
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(FRAME_ShopMAIN, false)
            endif
        endif
        set clicked = null
        set d = null
        set p = null
        call WUI_ReleaseClickFocus()
        return
    endif
    if frameCode == 405 then
        call ShopDeactivateSearch(p, true)
        set clicked = null
        set d = null
        set p = null
        call WUI_ReleaseClickFocus()
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
            if section >= 1 and section <= SHOP_PAGE_LAST then
                set pageCount = ShopGetSectionPageCount(section)
                if frameCode == 406 and ShopSectionPage[pid * SHOP_SECTION_STRIDE + section] > 0 then
                    set ShopSectionPage[pid * SHOP_SECTION_STRIDE + section] = ShopSectionPage[pid * SHOP_SECTION_STRIDE + section] - 1
                elseif frameCode == 407 and ShopSectionPage[pid * SHOP_SECTION_STRIDE + section] + 1 < pageCount then
                    set ShopSectionPage[pid * SHOP_SECTION_STRIDE + section] = ShopSectionPage[pid * SHOP_SECTION_STRIDE + section] + 1
                endif
                call ReloadItemPage(section, p)
            endif
        endif
        call ShopUpdateCatalogueNavigation(pid, p)
        set clicked = null
        set d = null
        set p = null
        call WUI_ReleaseClickFocus()
        return
    endif

if frameCode == 100 + SHOP_TAB_VIP then
        call ShopShowVip(p, true)
        set clicked = null
        set d = null
        set p = null
        call WUI_ReleaseClickFocus()
        return
    endif

if frameCode >= 100 and frameCode <= 100 + SHOP_PAGE_LAST then
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
        call WUI_ReleaseClickFocus()
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
            elseif ShopRoundLocked(id) then
                call StartSoundForPlayerBJ(p, gg_snd_Error)
                call DisplayTimedTextToPlayer(p, 0, 0, 2, "|c00FF0303Available from round " + I2S(ScrollOfMastery_Round) + ".|r")
            else
                set baseCost = GetItemValue(id)
                set remainingCost = CheckItemsReduceCostCraft(d, baseCost, id, false)
                if remainingCost < baseCost or CheckSlotAvailable(d) then
                    if GetGold(p) >= remainingCost then
                        call CheckItemsReduceCostCraft(d, baseCost, id, true)
                        call AddGold(p, remainingCost, false)
                        call UnitAddItemById(d, id)
                        call ShopMarkFullRefund(d, id, remainingCost)
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

        call SaveInteger(hs, GetHandleId(d), SH_WoS_Shop_Init_SOLD_CD, 1)
        call MyFlush(GetHandleId(d), SH_WoS_Shop_Init_SOLD_CD, 1, 0.1)
        set refundSlot = ItemsCurrentItemBag_ID[pid] - 1
        set refundCheck = LoadInteger(hs, GetHandleId(d), GearKey(GEAR_KEY_FULLREFUND, "fullrefund_", refundSlot))
        if refundCheck == id then
            call AddGold(p, baseCost, true)
            call RemoveSavedInteger(hs, GetHandleId(d), GearKey(GEAR_KEY_FULLREFUND, "fullrefund_", refundSlot))
        else
            call AddGold(p, R2I(baseCost * (RefundPercent/100)), true)
        endif
        call RemoveItem(UnitItemInSlot(d, refundSlot))
        call RefreshItemCache2(d)
        call ShopClearItemTree(p)
        call StartSoundForPlayerBJ(p, gg_snd_ReceiveGold)
        call ReloadItemPage2(ItemsFrameCurrentPage_ID[pid], p)
    endif

    set clicked = null
    set d = null
    set p = null
    call WUI_ReleaseClickFocus()
endfunction

function AutoBuyHasBoots takes integer id, integer depth returns boolean
    local integer i = 0
    if id == 'I007' then
        return true
    endif
    if depth >= 32 then
        return false
    endif
    loop
        exitwhen i >= GetCraftComponentCount(id)
        if AutoBuyHasBoots(GetCraftComponent(id, i), depth + 1) then
            return true
        endif
        set i = i + 1
    endloop
    return false
endfunction

function AutoBuyNeedsBoots takes unit c, integer id, integer depth returns boolean
    local integer i = 0
    if IsItemInInventory(c, id) > 0 or depth >= 32 then
        return false
    endif
    if id == 'I007' then
        return true
    endif
    loop
        exitwhen i >= GetCraftComponentCount(id)
        if AutoBuyNeedsBoots(c, GetCraftComponent(id, i), depth + 1) then
            return true
        endif
        set i = i + 1
    endloop
    return false
endfunction

function AutoBuyComponent takes integer id, integer index returns integer
    local integer i = 0
    local integer priority = -1
    local integer count = GetCraftComponentCount(id)
    loop
        exitwhen i >= count or priority >= 0
        if AutoBuyHasBoots(GetCraftComponent(id, i), 0) then
            set priority = i
        endif
        set i = i + 1
    endloop
    if priority > 0 then
        if index == 0 then
            return GetCraftComponent(id, priority)
        elseif index <= priority then
            return GetCraftComponent(id, index - 1)
        endif
    endif
    return GetCraftComponent(id, index)
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
    if id == 0 or IsItemInInventory(c, id) > 0 or ShopRoundLocked(id) then
        set p = null
        return
    endif
    set componentCount = GetCraftComponentCount(id)
    loop
        exitwhen componentIndex >= componentCount
        set componentId = AutoBuyComponent(id, componentIndex)
        call BuyAuto(c, componentId)
        if AutoBuyNeedsBoots(c, componentId, 0) then
            set p = null
            return
        endif
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

    if remaining <= 0 or id == 0 or IsItemInInventory(c, id) > 0 or ShopRoundLocked(id) then
        set p = null
        return remaining
    endif

    set cost = GetItemValue(id)
    set componentCount = GetCraftComponentCount(id)
    loop
        exitwhen componentIndex >= componentCount or remaining <= 0
        set componentId = AutoBuyComponent(id, componentIndex)
        set remaining = BuyAutoLimited(c, componentId, remaining)
        if AutoBuyNeedsBoots(c, componentId, 0) then
            set p = null
            return remaining
        endif
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
            call ShopMarkFullRefund(c, id, remainingCost)
            call ShopMarkFullRefund(c, id, remainingCost)
            call StartSoundForPlayerBJ(p, gg_snd_AlchemistTransmuteDeath1)
            set remaining = remaining - 1
        endif
    endif

    set p = null
    return remaining
endfunction

function QB_Field takes string text, integer field returns string
    local integer i = 0
    local integer start = 0
    local integer n = 0
    loop
        exitwhen i > StringLength(text)
        if i == StringLength(text) or SubString(text, i, i + 1) == "," then
            if n == field then
                return SubString(text, start, i)
            endif
            set n = n + 1
            set start = i + 1
        endif
        set i = i + 1
    endloop
    return ""
endfunction

function QB_Int takes string text returns integer
    local integer value = S2I(text)
    if I2S(value) != text or value < 0 then
        return -1
    endif
    return value
endfunction



// Called only during agreed bootstrap. Price getter may use the game's seller.
function QB_CacheItem takes integer id, integer depth returns nothing
    local integer i = 0
    if id == 0 or depth > 32 or LoadBoolean(QB_Data, id, 0) then
        return
    endif
    call SaveBoolean(QB_Data, id, 0, true)
    call SaveInteger(QB_Data, id, 1, GetItemValue(id))
    call SaveStr(QB_Data, id, 2, BlzGetAbilityIcon(id))
    call SaveStr(QB_Data, id, 3, GetObjectName(id))
    loop
        exitwhen i >= GetCraftComponentCount(id)
        call QB_CacheItem(GetCraftComponent(id, i), depth + 1)
        set i = i + 1
    endloop
endfunction

// Stable postorder keys include owned subtrees, so manual deletion cannot be
// resurrected by inventory changes or a group's move to another position.
function QB_ClearExcluded takes integer pid, integer goalIndex returns nothing
    local integer node = 0
    loop
        exitwhen node >= QB_MAX_STEPS
        set QB_Excluded[pid * 768 + goalIndex * QB_MAX_STEPS + node] = false
        set node = node + 1
    endloop
endfunction

function QB_CopyExcluded takes integer pid, integer sourceIndex, integer dest returns nothing
    local integer node = 0
    loop
        exitwhen node >= QB_MAX_STEPS
        set QB_Excluded[pid * 768 + dest * QB_MAX_STEPS + node] = QB_Excluded[pid * 768 + sourceIndex * QB_MAX_STEPS + node]
        set node = node + 1
    endloop
endfunction



function QB_RemoveTarget takes integer pid, integer index returns nothing
    local integer i = index
    if index < 0 or index >= QB_Count[pid] then
        return
    endif
    loop
        exitwhen i + 1 >= QB_Count[pid]
        set QB_GoalSerial[pid * 6 + i] = QB_GoalSerial[pid * 6 + i + 1]
        set QB_Target[pid * 6 + i] = QB_Target[pid * 6 + i + 1]
        call QB_CopyExcluded(pid, i + 1, i)
        set i = i + 1
    endloop
    set QB_Count[pid] = QB_Count[pid] - 1
    set QB_Target[pid * 6 + QB_Count[pid]] = 0
    set QB_GoalSerial[pid * 6 + QB_Count[pid]] = 0
    call QB_ClearExcluded(pid, QB_Count[pid])
endfunction

function QB_SkipOwnedNodes takes integer id, integer depth returns nothing
    local integer i = 0
    if depth >= 32 or QB_BuildNode >= QB_MAX_STEPS or QB_BuildError then
        set QB_BuildError = true
        return
    endif
    loop
        exitwhen i >= depth
        if QB_Stack[i] == id then
            set QB_BuildError = true
            return
        endif
        set i = i + 1
    endloop
    set QB_Stack[depth] = id
    set i = 0
    loop
        exitwhen i >= GetCraftComponentCount(id) or QB_BuildError
        call QB_SkipOwnedNodes(GetCraftComponent(id, i), depth + 1)
        set i = i + 1
    endloop
    set QB_BuildNode = QB_BuildNode + 1
endfunction

function QB_Expand takes integer id, integer depth returns nothing
    local integer i = 0
    local integer n = GetCraftComponentCount(id)
    local integer slot = 0
    local integer node
    local integer startNode = QB_BuildNode
    local integer endNode
    local integer cost = LoadInteger(QB_Data, id, 1)
    local integer offset = QB_BuildPid * QB_MAX_STEPS
    local boolean missing = false
    set QB_ExpansionMissing = false
    set QB_DeferredCost = 0
    if QB_BuildError then
        return
    endif
    if not QB_Valid(id) or depth >= 32 then
        set QB_BuildError = true
        return
    endif
    // Reserve owned copies for retained occurrences, not deleted duplicates.
    // Count structural nodes with the existing validated walker; no handles.
    call QB_SkipOwnedNodes(id, depth)
    set endNode = QB_BuildNode - 1
    set QB_BuildNode = startNode
    if QB_BuildError then
        return
    endif
    loop
        exitwhen slot >= 6
        if not QB_Excluded[QB_BuildPid * 768 + QB_BuildGroup * QB_MAX_STEPS + endNode] and not QB_Used[slot] and QB_Inventory[QB_BuildPid * 6 + slot] == id then
            set QB_Used[slot] = true
            call QB_SkipOwnedNodes(id, depth)
            return
        endif
        set slot = slot + 1
    endloop
    loop
        exitwhen i >= depth
        if QB_Stack[i] == id then
            set QB_BuildError = true
            return
        endif
        set i = i + 1
    endloop
    set QB_Stack[depth] = id
    set i = 0
    loop
        exitwhen i >= n or QB_BuildError
        call QB_Expand(GetCraftComponent(id, i), depth + 1)
        set missing = missing or QB_ExpansionMissing
        set cost = cost - LoadInteger(QB_Data, GetCraftComponent(id, i), 1) + QB_DeferredCost
        set i = i + 1
    endloop
    set node = QB_BuildNode
    set QB_BuildNode = QB_BuildNode + 1
    if QB_BuildError or node >= QB_MAX_STEPS then
        set QB_BuildError = true
        return
    endif
    if QB_Excluded[QB_BuildPid * 768 + QB_BuildGroup * QB_MAX_STEPS + node] then
        set QB_ExpansionMissing = true
        set QB_DeferredCost = IMaxBJ(0, cost)
        return
    endif
    if QB_StepCount[QB_BuildPid] >= QB_MAX_STEPS then
        set QB_BuildError = true
        return
    endif
    set offset = offset + QB_StepCount[QB_BuildPid]
    set QB_Step[offset] = id
    set QB_Group[offset] = QB_BuildGroup
    set QB_Cost[offset] = IMaxBJ(0, cost)
    set QB_StepKey[offset] = node
    set QB_SubtreeStart[offset] = startNode
    set QB_Token[offset] = QB_GoalSerial[QB_BuildPid * 6 + QB_BuildGroup] * QB_MAX_STEPS + node
    set QB_StepMissing[offset] = missing
    set QB_AnyMissing[QB_BuildPid] = QB_AnyMissing[QB_BuildPid] or missing
    // Retained steps pay their own deferred portion; ancestors must not count it twice.
    set QB_ExpansionMissing = false
    set QB_DeferredCost = 0
    set QB_StepCount[QB_BuildPid] = QB_StepCount[QB_BuildPid] + 1
endfunction

// Move one agreed purchase step. Its group/dependency/key stay attached.
function QB_MoveStep takes integer pid, integer sourceIndex, integer dest returns nothing
    local integer off = pid * QB_MAX_STEPS
    local integer i = sourceIndex
    local integer nextIndex
    local integer id = QB_Step[off + i]
    local integer cost = QB_Cost[off + i]
    local integer groupIndex = QB_Group[off + i]
    local integer key = QB_StepKey[off + i]
    local integer token = QB_Token[off + i]
    local integer subtreeStart = QB_SubtreeStart[off + i]
    local boolean missing = QB_StepMissing[off + i]
    loop
        exitwhen i == dest
        if i < dest then
            set nextIndex = i + 1
        else
            set nextIndex = i - 1
        endif
        set QB_Step[off + i] = QB_Step[off + nextIndex]
        set QB_Cost[off + i] = QB_Cost[off + nextIndex]
        set QB_Group[off + i] = QB_Group[off + nextIndex]
        set QB_StepKey[off + i] = QB_StepKey[off + nextIndex]
        set QB_Token[off + i] = QB_Token[off + nextIndex]
        set QB_SubtreeStart[off + i] = QB_SubtreeStart[off + nextIndex]
        set QB_StepMissing[off + i] = QB_StepMissing[off + nextIndex]
        set i = nextIndex
    endloop
    set QB_Step[off + dest] = id
    set QB_Cost[off + dest] = cost
    set QB_Group[off + dest] = groupIndex
    set QB_StepKey[off + dest] = key
    set QB_Token[off + dest] = token
    set QB_SubtreeStart[off + dest] = subtreeStart
    set QB_StepMissing[off + dest] = missing
endfunction

function QB_CaptureOrder takes integer pid returns nothing
    local integer i = 0
    loop
        exitwhen i >= QB_StepCount[pid]
        set QB_Order[pid * QB_MAX_STEPS + i] = QB_Token[pid * QB_MAX_STEPS + i]
        set i = i + 1
    endloop
    set QB_OrderCount[pid] = QB_StepCount[pid]
endfunction

function QB_ApplyOrder takes integer pid returns nothing
    local integer i = 0
    local integer j
    local integer dest = 0
    local integer off = pid * QB_MAX_STEPS
    if QB_OrderCount[pid] == 0 then
        return
    endif
    loop
        exitwhen i >= QB_OrderCount[pid]
        set j = dest
        loop
            exitwhen j >= QB_StepCount[pid] or QB_Token[off + j] == QB_Order[off + i]
            set j = j + 1
        endloop
        if j < QB_StepCount[pid] then
            call QB_MoveStep(pid, j, dest)
            set dest = dest + 1
        endif
        set i = i + 1
    endloop
    call QB_CaptureOrder(pid)
endfunction

// Current inventory discounts minus retained child operations for deferred steps.
// Parent search uses structural keys, so reorder does not change the price.
// Structural parents change on rebuild/reorder, not on every UI refresh.
function QB_CachePriceParents takes integer pid returns nothing
    local integer off = pid * QB_MAX_STEPS
    local integer i = 0
    local integer j
    local integer parent
    loop
        exitwhen i >= QB_StepCount[pid]
        set parent = -1
        set j = 0
        loop
            exitwhen j >= QB_StepCount[pid]
            if QB_Group[off + j] == QB_Group[off + i] and QB_StepKey[off + i] >= QB_SubtreeStart[off + j] and QB_StepKey[off + i] < QB_StepKey[off + j] then
                if parent < 0 or QB_StepKey[off + j] < QB_StepKey[off + parent] then
                    set parent = j
                endif
            endif
            set j = j + 1
        endloop
        set QB_PriceParent[off + i] = parent
        set i = i + 1
    endloop
endfunction

function QB_RefreshPrices takes integer pid returns boolean
    local integer i = 0
    local integer parent
    local integer off = pid * QB_MAX_STEPS
    local integer id
    local integer price
    local boolean changed = false
    loop
        exitwhen i >= QB_StepCount[pid]
        set id = QB_Step[off + i]
        set QB_PriceRemaining[off + i] = IMaxBJ(0, CheckItemsReduceCostCraft(Hero[pid], LoadInteger(QB_Data, id, 1), id, false))
        set QB_PriceQueued[off + i] = 0
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= QB_StepCount[pid]
        set parent = QB_PriceParent[off + i]
        if parent >= 0 then
            set QB_PriceQueued[off + parent] = QB_PriceQueued[off + parent] + QB_PriceRemaining[off + i]
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= QB_StepCount[pid]
        set price = IMaxBJ(0, QB_PriceRemaining[off + i] - QB_PriceQueued[off + i])
        if QB_DisplayCost[off + i] != price then
            set QB_DisplayCost[off + i] = price
            set changed = true
        endif
        set i = i + 1
    endloop
    return changed
endfunction

function QB_Rebuild takes integer pid returns nothing
    local integer i = 0
    local integer id
    local integer start
    local item it
    set QB_StepCount[pid] = 0
    set QB_AnyMissing[pid] = false
    set QB_BuildPid = pid
    set QB_BuildError = false
    loop
        exitwhen i >= 6
        set it = UnitItemInSlot(Hero[pid], i)
        set QB_Inventory[pid * 6 + i] = GetItemTypeId(it)
        set QB_Used[i] = false
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= QB_Count[pid]
        set id = QB_Target[pid * 6 + i]
        if IsItemInInventory(Hero[pid], id) > 0 then
            call QB_RemoveTarget(pid, i)
        else
            set i = i + 1
        endif
    endloop
    set i = 0
    loop
        exitwhen i >= QB_Count[pid] or QB_BuildError
        if QB_GoalSerial[pid * 6 + i] == 0 then
            set QB_NextSerial[pid] = QB_NextSerial[pid] + 1
            set QB_GoalSerial[pid * 6 + i] = QB_NextSerial[pid]
        endif
        set QB_BuildGroup = i
        set QB_BuildNode = 0
        set start = QB_StepCount[pid]
        call QB_Expand(QB_Target[pid * 6 + i], 0)
        if not QB_BuildError and start == QB_StepCount[pid] then
            call QB_RemoveTarget(pid, i)
        else
            set i = i + 1
        endif
    endloop
    if QB_BuildError then
        set QB_Status[pid] = 3
        set QB_Error[pid] = "Invalid or cyclic recipe"
    else
        set QB_Status[pid] = 0
    endif
    call QB_ApplyOrder(pid)
    call QB_CachePriceParents(pid)
    call QB_RefreshPrices(pid)
    set QB_Version[pid] = QB_Version[pid] + 1
    set it = null
endfunction
















// Recommended is agreed per-player data. File buffers and mouse paint are local only.


function REC_Apply takes integer pid returns nothing
    local integer i = 0
    loop
        exitwhen i >= SHOP_SEARCH_PAGE_SIZE
        if i < REC_CAPACITY then
            set ItemsPage0_ID[pid * SHOP_SEARCH_PAGE_SIZE + i] = REC_Item[pid * REC_CAPACITY + i]
        else
            set ItemsPage0_ID[pid * SHOP_SEARCH_PAGE_SIZE + i] = 0
        endif
        set i = i + 1
    endloop
    set AutoBuyRecommendedIndex[pid] = 0
    set AutoBuyRecommendedDone[pid] = false
    set AutoBuyRecommendedUnitId[pid] = GetHandleId(Hero[pid])
    set REC_Lock[pid] = 0
    set REC_Version[pid] = REC_Version[pid] + 1
endfunction



function REC_FilePath takes integer pid, integer heroId returns string
    local string name = GetObjectName(heroId)
    local string safe = ""
    local string ch
    local integer i = 0
    loop
        exitwhen i >= StringLength(name) or i >= 48
        set ch = SubString(name, i, i + 1)
        if ch == "" then
            // Empty characters cannot become path separators.
        elseif ShopTextContains("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", ch) then
            set safe = safe + ch
        else
            set safe = safe + "_"
        endif
        set i = i + 1
    endloop
    if safe == "" then
        set safe = "Hero"
    endif
    return "WosHeroes\\" + safe + "_" + I2S(heroId) + "_" + I2S(ss_IdentityKeyA[pid]) + "_" + I2S(ss_IdentityKeyB[pid]) + ".txt"
endfunction

function REC_Send takes string op, string data returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    if QB_Hero[pid] == 0 then
        return
    endif
    set REC_LocalSequence = REC_LocalSequence + 1
    call BlzSendSyncData(REC_SYNC, op + "," + I2S(QB_Hero[pid]) + "," + I2S(REC_Version[pid]) + "," + I2S(REC_LocalSequence) + "," + data)
endfunction

// All file IO is explicit, owner-only; never called from Save Keys or QB queue edits.
function REC_SaveLocal takes integer pid returns nothing
    local integer i = 0
    local string record = "WOSR1|" + I2S(QB_Hero[pid]) + "|"
    if not REC_FileWritable then
        call DisplayTimedTextToPlayer(Player(pid), 0, 0, 5, "[WoS] Invalid build file preserved; restore it before saving.")
        return
    endif
    loop
        exitwhen i >= REC_CAPACITY
        if i > 0 then
            set record = record + ","
        endif
        set record = record + I2S(REC_Item[pid * REC_CAPACITY + i])
        set i = i + 1
    endloop
    call PreloadGenClear()
    call PreloadGenStart()
    call SaveSystem_ChunkBegin(record + "|")
    call SaveSystem_ChunkFlush(REC_FilePath(pid, QB_Hero[pid]))
    call PreloadGenClear()
    call DisplayTimedTextToPlayer(Player(pid), 0, 0, 4, "[WoS] Hero's Recommended build saved.")
endfunction

function REC_LoadLocal takes integer pid, boolean initial returns nothing
    local string buffer = SaveSystem_ChunkRead(REC_FilePath(pid, QB_Hero[pid]))
    local string record = ""
    local string text
    local integer i = 0
    local integer start = 6
    local integer split = 6
    local integer chunk = 0
    local integer id
    local boolean valid = true
    if buffer == "" then
        set REC_FileWritable = true
        if not initial then
            call DisplayTimedTextToPlayer(Player(pid), 0, 0, 4, "[WoS] No personal build for this hero.")
            return
        endif
        loop
            exitwhen i >= REC_CAPACITY
            set REC_LocalItem[i] = REC_Default[pid * REC_CAPACITY + i]
            set i = i + 1
        endloop
    else
        loop
            exitwhen split >= StringLength(buffer) or SubString(buffer, split, split + 1) == "|"
            set split = split + 1
        endloop
        set valid = SubString(buffer, 0, 6) == "WOSR1|" and QB_Int(SubString(buffer, start, split)) == QB_Hero[pid] and SubString(buffer, StringLength(buffer) - 1, StringLength(buffer)) == "|" and StringLength(buffer) <= 1024
        set record = SubString(buffer, split + 1, StringLength(buffer) - 1)
        if QB_Field(record, REC_CAPACITY) != "" then
            set valid = false
        endif
        loop
            exitwhen i >= REC_CAPACITY
            set id = QB_Int(QB_Field(record, i))
            if QB_Field(record, i) == "" or id < 0 or (id != 0 and not QB_Valid(id)) then
                set valid = false
            endif
            set REC_LocalItem[i] = id
            set i = i + 1
        endloop
        set REC_FileWritable = valid
        if not valid then
            call DisplayTimedTextToPlayer(Player(pid), 0, 0, 5, "[WoS] Invalid hero build ignored; current Recommended kept.")
            call REC_Send("X", "0")
            return
        endif
    endif
    // Four bounded packets, applied atomically. Queue/version never enters this protocol.
    loop
        exitwhen chunk >= 4
        set text = I2S(chunk)
        set i = 0
        loop
            exitwhen i >= 7
            set text = text + "," + I2S(REC_LocalItem[chunk * 7 + i])
            set i = i + 1
        endloop
        call REC_Send("L", text)
        set chunk = chunk + 1
    endloop
endfunction

function REC_InitHero takes integer pid returns nothing
    local integer i = 0
    local integer count = 0
    local integer id
    call SaveSystem_EnsureIdentity(pid)
    loop
        exitwhen i >= REC_CAPACITY
        set id = 0
        if i < SHOP_RECOMMENDED_COUNT then
            set id = ItemsPage0_ID[pid * SHOP_SEARCH_PAGE_SIZE + i]
        endif
        if id != 0 and QB_Valid(id) then
            set REC_Default[pid * REC_CAPACITY + count] = id
            set REC_Item[pid * REC_CAPACITY + count] = id
            set count = count + 1
        endif
        set i = i + 1
    endloop
    set REC_Count[pid] = count
    loop
        exitwhen count >= REC_CAPACITY
        set REC_Default[pid * REC_CAPACITY + count] = 0
        set REC_Item[pid * REC_CAPACITY + count] = 0
        set count = count + 1
    endloop
    set REC_LoadMask[pid] = 0
    call REC_Apply(pid)
    if GetLocalPlayer() == Player(pid) then
        call REC_LoadLocal(pid, true)
    endif
endfunction



function QB_Send takes string operation, string data returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    if QB_Hero[pid] == 0 then
        return
    endif
    set QB_LocalSequence = QB_LocalSequence + 1
    call BlzSendSyncData(QB_SYNC, operation + "," + I2S(QB_Hero[pid]) + "," + I2S(QB_Version[pid]) + "," + I2S(QB_LocalSequence) + "," + data)
endfunction

function QB_OnHero takes integer pid, integer originalId returns nothing
    local integer goalIndex = 0
    if QB_Data == null or pid < 0 or pid >= 10 or originalId == 0 or (QB_Hero[pid] == originalId and QB_AssignedUnit[pid] == Hero[pid]) then
        return
    endif
    loop
        exitwhen goalIndex >= 6
        call QB_ClearExcluded(pid, goalIndex)
        set QB_GoalSerial[pid * 6 + goalIndex] = 0
        set goalIndex = goalIndex + 1
    endloop
    set QB_AssignedUnit[pid] = Hero[pid]
    set QB_Hero[pid] = originalId
    set QB_Count[pid] = 0
    set QB_OrderCount[pid] = 0
    set QB_Lock[pid] = 0
    set QB_Awaiting[pid] = true
    call QB_Rebuild(pid)
    call REC_InitHero(pid)
    if GetLocalPlayer() == Player(pid) then
        set QB_DragFrom = -1
        set REC_DragFrom = -1
        set QB_Page = 0
    endif
endfunction

// Hero changes are agreed requests; consume before shared purchase/sync work.
function QB_ApplyHeroRequests takes nothing returns nothing
    local integer pid = 0
    local integer originalId
    if QB_Data == null then
        return
    endif
    loop
        exitwhen pid >= 10
        set originalId = WUI_ShopHeroRequest[pid]
        if originalId != 0 then
            set WUI_ShopHeroRequest[pid] = 0
            call QB_OnHero(pid, originalId)
        endif
        set pid = pid + 1
    endloop
endfunction

function QB_SlotX takes integer slot returns real
    return QB_Left + (I2R(ModuloInteger(slot, QB_Columns)) + 0.50) * QB_Width / I2R(QB_Columns)
endfunction
function QB_SlotY takes integer slot returns real
    return 0.312 - I2R(slot / QB_Columns) * 0.065
endfunction

// Preserve native hover/focus while data changes but the hitbox stays visible.
function QB_ShowSlot takes integer index, boolean shown returns nothing
    if QB_LastSlotShown[index] != shown then
        set QB_LastSlotShown[index] = shown
        call BlzFrameSetVisible(QB_Slot[index], shown)
        call BlzFrameSetVisible(QB_Remove[index], shown)
        call BlzFrameSetVisible(QB_Name[index], shown)
        if not shown then
            call BlzFrameSetVisible(QB_TipBox[index], false)
        endif
    endif
endfunction

// Cached, non-interactive pointers surround the insertion target.
function QB_DragCues takes integer family, boolean show, real x, real y, real size returns nothing
    local integer i = 0
    local real px
    local real py
    local integer index
    loop
        exitwhen i >= 4
        set index = family * 4 + i
        set px = x
        set py = y
        if i == 0 then
            set px = x - size * 0.64
        elseif i == 1 then
            set px = x + size * 0.64
        elseif i == 2 then
            set py = y - size * 0.64
        else
            set py = y + size * 0.64
        endif
        if show then
            call Shop_Place(QB_DragArrow[index], px, py, 0.012, 0.012)
        endif
        call BlzFrameSetVisible(QB_DragArrow[index], show)
        set i = i + 1
    endloop
endfunction

function QB_DragPreview takes nothing returns boolean
    local integer slot = QB_DragFrom - QB_Page * QB_ViewCount
    local integer target = QB_DragTo - QB_Page * QB_ViewCount
    if slot < 0 or slot >= QB_ViewCount then
        call QB_DragCues(0, false, 0.00, 0.00, QB_Size)
        return false
    endif
    call Shop_Place(QB_DragLight, QB_SlotX(slot), QB_SlotY(slot), QB_Size, QB_Size)
    call QB_DragCues(0, target >= 0 and target < QB_ViewCount and QB_DragTo != QB_DragFrom, QB_SlotX(target), QB_SlotY(target), QB_Size)
    return true
endfunction

function QB_DragRender takes nothing returns nothing
    local boolean sourceVisible = false
    local integer pid = GetPlayerId(GetLocalPlayer())
    if QB_DragFrom >= 0 then
        set sourceVisible = QB_DragPreview()
    else
        call QB_DragCues(0, false, 0.00, 0.00, QB_Size)
    endif
    call BlzFrameSetVisible(QB_DragLight, sourceVisible)
    call BlzFrameSetVisible(QB_DropLine, false)
    set sourceVisible = REC_DragFrom >= 0 and REC_Active(pid)
    if sourceVisible then
        call Shop_Place(REC_DragLight, SHOP_LIST_X + I2R(ModuloInteger(REC_DragFrom, 7) - 3) * 0.049, 0.4565 - I2R(REC_DragFrom / 7) * 0.056, 0.038, 0.038)
    endif
    call QB_DragCues(1, sourceVisible and REC_DragTo != REC_DragFrom, SHOP_LIST_X + I2R(ModuloInteger(REC_DragTo, 7) - 3) * 0.049, 0.4565 - I2R(REC_DragTo / 7) * 0.056, 0.038)
    call BlzFrameSetVisible(REC_DragLight, sourceVisible)
    call BlzFrameSetVisible(REC_DropLine, false)
endfunction

function QB_StringChoice takes boolean choice, string yes, string no returns string
    if choice then
        return yes
    endif
    return no
endfunction

// Existing 0.50s render checks the viewport only; geometry is reapplied on change.
function QB_Layout takes nothing returns nothing
    local real right = RMinBJ(0.910, WUI_ScreenRight() - 0.012)
    local real tabWidth
    local real width
    local real invSize
    local real invStep
    local real invX
    local real invY
    local real iconSize
    local real buttonSize
    local integer i = 0
    if RAbsBJ(right - QB_Right) < 0.0001 then
        return
    endif
    call Shop_Recenter()
    set QB_Right = right
    set QB_Width = right - QB_Left
    set QB_Columns = 5
    set QB_ViewCount = QB_VISIBLE
    set QB_Size = RMinBJ(0.036, QB_Width / 5.00 - 0.004)
    call Shop_Place(FRAME_ShopMAIN, (0.022 + right) * 0.50, 0.312, right - 0.022, 0.428)
    set tabWidth = (right - 0.062) / I2R(SHOP_TAB_COUNT)
    loop
        exitwhen i >= SHOP_TAB_COUNT
        call Shop_Place(FRAME_ShopSection[i], 0.033 + (I2R(i) + 0.50) * tabWidth, 0.505, tabWidth, 0.027)
        set i = i + 1
    endloop
    call Shop_Place(FRAME_ShopClose, right - 0.013, 0.513, 0.018, 0.018)
    call Shop_Place(FRAME_ShopItemInventory, QB_Left + QB_Width * 0.50, 0.422, QB_Width, 0.120)
    call Shop_Place(FRAME_ShopItemInventoryName, QB_Left + QB_Width * 0.32, 0.473, QB_Width * 0.60, 0.016)
    call BlzFrameSetTextAlignment(FRAME_ShopItemInventoryName, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)
    set invStep = QB_Width * 0.19
    set invSize = RMinBJ(0.035, invStep - 0.003)
    set QB_InventorySize = invSize
    set i = 0
    loop
        exitwhen i >= 6
        set invX = QB_Left + QB_Width * 0.34 + I2R(ModuloInteger(i, 3)) * invStep
        set invY = 0.431 - I2R(i / 3) * 0.044
        call Shop_Place(FRAME_ShopItemInventorySlot[i], invX, invY, invSize, invSize)
        // Reset the icon's constraints too: its art must share the real hitbox.
        call BlzFrameClearAllPoints(FRAME_ShopItemInventorySlotBack[i])
        call BlzFrameSetAllPoints(FRAME_ShopItemInventorySlotBack[i], FRAME_ShopItemInventorySlot[i])
        call ShopPlacePrice(FRAME_ShopItemInventorySlotCost[i], FRAME_ShopInventoryPricePlate[i], invX, invY, invSize)
        call BlzFrameSetScale(FRAME_ShopItemInventorySlotCost[i], 0.65)
        call BlzFrameSetSize(FRAME_ShopItemInventorySlotCost[i], invSize / 0.65, 0.016)
        call BlzFrameSetVisible(FRAME_ShopInventoryItemName[i], false)
        set i = i + 1
    endloop
    set buttonSize = RMinBJ(0.030, QB_Width * 0.15)
    call Shop_Place(FRAME_ShopItemInventorySlot[6], QB_Left + QB_Width * 0.09, 0.440, buttonSize, buttonSize)
    call Shop_Place(FRAME_ShopItemInventorySlot[7], QB_Left + QB_Width * 0.09, 0.397, buttonSize, buttonSize)
    set i = 6
    loop
        exitwhen i >= 8
        call BlzFrameClearAllPoints(FRAME_ShopItemInventorySlotBack[i])
        call BlzFrameSetAllPoints(FRAME_ShopItemInventorySlotBack[i], FRAME_ShopItemInventorySlot[i])
        set i = i + 1
    endloop
    set buttonSize = RMinBJ(0.018515, QB_Width * 0.09545)
    call Shop_Place(FRAME_FastBuyToggle, right - QB_Width * 0.075, 0.429, buttonSize, buttonSize)
    call Shop_Place(FRAME_FastSellToggle, right - QB_Width * 0.075, 0.389, buttonSize, buttonSize)
    call Shop_Place(QB_Panel, QB_Left + QB_Width * 0.50, 0.2255, QB_Width, 0.255)
    call Shop_Place(QB_Title, QB_Left + QB_Width * 0.50, 0.342, (QB_Width - 0.052) / 0.72, 0.012 / 0.72)
    call Shop_Place(QB_StateText, QB_Left + QB_Width * 0.50, 0.107, (QB_Width - 0.046) / 0.60, 0.010 / 0.60)
    call Shop_Place(QB_Hint, QB_Left + QB_Width * 0.50, 0.126, (QB_Width - 0.046) / 0.52, 0.013 / 0.52)
    call Shop_Place(QB_StateIcon, QB_Left + 0.010, 0.342, 0.014, 0.014)
    call Shop_Place(QB_Clear, right - 0.012, 0.342, 0.018, 0.018)
    call Shop_Place(QB_Previous, QB_Left + 0.011, 0.126, 0.016, 0.016)
    call Shop_Place(QB_Next, right - 0.011, 0.126, 0.016, 0.016)
    set i = 0
    loop
        exitwhen i >= QB_VISIBLE
        call Shop_Place(QB_Slot[i], QB_SlotX(i), QB_SlotY(i), QB_Size, QB_Size)
        call BlzFrameSetSize(QB_Name[i], (QB_Width / I2R(QB_Columns) - 0.003) / 0.52, 0.013 / 0.52)
        call BlzFrameSetSize(QB_Icon[i], QB_Size - 0.004, QB_Size - 0.004)
        call BlzFrameSetSize(QB_StepPlate[i], RMinBJ(0.030, QB_Size), 0.010)
        call BlzFrameSetSize(QB_PriceText[i], QB_Size / 0.57, 0.010 / 0.57)
        set i = i + 1
    endloop
    call Shop_Place(QB_First, QB_SlotX(0), QB_SlotY(0), QB_Size + 0.004, QB_Size + 0.004)
    if QB_DragFrom >= 0 then
        set QB_DragFrom = -1
        call QB_Send("U", "0")
        call QB_DragRender()
    endif
    set QB_LastViewVersion = -1
endfunction

// Both cached controls refer to one versioned preview operation.
function QB_ShowPreviewRemove takes integer index, boolean shown returns nothing
    if BlzFrameIsVisible(QB_PreviewRemove[index]) != shown then
        call BlzFrameSetVisible(QB_PreviewRemove[index], shown)
    endif
    if BlzFrameGetEnable(QB_PreviewRemove[index]) != shown then
        call BlzFrameSetEnable(QB_PreviewRemove[index], shown)
    endif
    if BlzFrameIsVisible(QB_PreviewMinusFace[index]) != shown then
        call BlzFrameSetVisible(QB_PreviewMinusFace[index], shown)
    endif
    if BlzFrameGetEnable(QB_PreviewMinusFace[index]) != shown then
        call BlzFrameSetEnable(QB_PreviewMinusFace[index], shown)
    endif
endfunction

function QB_RenderLocal takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local integer i = 0
    local integer k
    local integer id
    local integer cost
    local integer future = 0
    local boolean canAdd
    local boolean dirty
    local boolean queueChanged
    local string label = "Empty"
    if QB_Panel == null or not IsGamePlayerSlot(pid) then
        return
    endif
    call QB_Layout()
    call REC_Render()
    if QB_LastShopOpen != Shop_Active[pid] then
        set QB_LastShopOpen = Shop_Active[pid]
        call QB_RefreshAdds()
    endif
    if QB_Page * QB_ViewCount >= QB_StepCount[pid] then
        set QB_Page = 0
    endif
    set queueChanged = QB_LastViewVersion != QB_Version[pid]
    set dirty = queueChanged or QB_LastViewStatus != QB_Status[pid] or QB_LastViewPage != QB_Page
    if dirty then
        set QB_LastViewVersion = QB_Version[pid]
        set QB_LastViewStatus = QB_Status[pid]
        set QB_LastViewPage = QB_Page
        loop
            exitwhen i >= QB_VISIBLE
            set k = QB_Page * QB_ViewCount + i
            set id = 0
            set cost = 0
            if i < QB_ViewCount and k < QB_StepCount[pid] then
                set id = QB_Step[pid * QB_MAX_STEPS + k]
                set cost = QB_DisplayCost[pid * QB_MAX_STEPS + k]
            endif
            call QB_ShowSlot(i, id != 0)
            if id != 0 then
                call BlzFrameSetText(QB_Name[i], WUI_TEXT + LoadStr(QB_Data, id, 3) + "|r")
                call BlzFrameSetText(QB_Tip[i], WUI_GOLD + LoadStr(QB_Data, id, 3) + "|r|nTarget: " + LoadStr(QB_Data, QB_Target[pid * 6 + QB_Group[pid * QB_MAX_STEPS + k]], 3) + "|nCost of this step: " + I2S(cost) + "|nPlanned charge: " + I2S(QB_Cost[pid * QB_MAX_STEPS + k]) + "|n" + QB_StringChoice(QB_Status[pid] == 3, QB_Error[pid], QB_StringChoice(QB_StepMissing[pid * QB_MAX_STEPS + k], "Skipped portion paid during assembly; other components buy normally", "Right-drag in any direction; release to reorder")))
                if QB_LastIcon[i] != id then
                    call BlzFrameSetTexture(QB_Icon[i], LoadStr(QB_Data, id, 2), 0, true)
                    set QB_LastIcon[i] = id
                endif
                call BlzFrameSetAlpha(QB_Icon[i], 255)
                if QB_LastCost[i] != cost + 1 then
                    call BlzFrameSetText(QB_PriceText[i], WUI_GOLD + I2S(cost) + "|r")
                    set QB_LastCost[i] = cost + 1
                endif
            endif
            set i = i + 1
        endloop
        call BlzFrameSetVisible(QB_First, QB_StepCount[pid] > 0 and QB_Page == 0)
        set canAdd = QB_Hero[pid] != 0 and not QB_Awaiting[pid] and QB_Count[pid] < 6
        if QB_AddAvailable != canAdd or queueChanged then
            set QB_AddAvailable = canAdd
            if Shop_Active[pid] then
                call QB_RefreshAdds()
            endif
        endif
        call BlzFrameSetEnable(QB_Clear, QB_Count[pid] > 0)
        call BlzFrameSetEnable(QB_Previous, QB_Page > 0)
        call BlzFrameSetEnable(QB_Next, (QB_Page + 1) * QB_ViewCount < QB_StepCount[pid])
        if QB_Awaiting[pid] then
            set label = "Sync pending"
        elseif QB_Count[pid] > 0 then
            set label = QB_StringChoice(QB_AnyMissing[pid], "Deferred portion active", "Quick Buy active")
            if QB_Status[pid] == 1 then
                set label = "Need gold"
            elseif QB_Status[pid] == 2 then
                set label = ""
            elseif QB_Status[pid] == 4 then
                set label = "Waiting for deferred portion"
            elseif QB_Status[pid] == 3 then
                set label = "Unavailable item"
            endif
        endif
        call BlzFrameSetText(QB_StateText, WUI_TEXT + label + "|r")
        call BlzFrameSetVisible(QB_StateIcon, QB_Status[pid] == 1 or QB_Status[pid] == 3)
        if QB_Status[pid] == 1 then
            call BlzFrameSetTexture(QB_StateIcon, QB_TEXTURE + "gold.tga", 0, true)
        else
            call BlzFrameSetTexture(QB_StateIcon, QB_TEXTURE + "error.tga", 0, true)
        endif
    endif
    set i = 0
    loop
        exitwhen i >= 6
        set id = 0
        set k = -1
        if Hero[pid] != null and UNITSTAT_GetSelected(pid) == Hero[pid] and UnitItemInSlot(Hero[pid], i) == null then
            if future < QB_StepCount[pid] then
                set k = future
                set id = QB_Step[pid * QB_MAX_STEPS + future]
                set cost = QB_DisplayCost[pid * QB_MAX_STEPS + future]
                set future = future + 1
            endif
        endif
        set QB_PreviewStep[i] = k
        set QB_PreviewVersion[i] = QB_Version[pid]
        if id != QB_LastPreview[i] or dirty then
            set QB_LastPreview[i] = id
            call BlzFrameSetVisible(QB_Preview[i], id != 0)
            call QB_ShowPreviewRemove(i, id != 0)
            if id != 0 then
                call BlzFrameSetTexture(QB_PreviewIcon[i], LoadStr(QB_Data, id, 2), 0, true)
                call BlzFrameSetText(QB_PreviewPrice[i], WUI_GOLD + I2S(cost) + "|r")
            endif
        endif
        set i = i + 1
    endloop
    if QB_DragFrom >= 0 and (not Shop_Active[pid] or not WUI_TopShown() or QB_DragVersion != QB_Version[pid]) then
        set QB_DragFrom = -1
        set QB_LastViewVersion = -1
        call QB_Send("U", "0")
        call QB_DragRender()
    endif
endfunction

function REC_OnSync takes nothing returns nothing
    local integer pid = GetPlayerId(GetTriggerPlayer())
    local string text = BlzGetTriggerSyncData()
    local string op = QB_Field(text, 0)
    local integer heroId = QB_Int(QB_Field(text, 1))
    local integer packetVersion = QB_Int(QB_Field(text, 2))
    local integer seq = QB_Int(QB_Field(text, 3))
    local integer value = QB_Int(QB_Field(text, 4))
    local integer dest = QB_Int(QB_Field(text, 5))
    local integer i = 0
    local integer id
    local integer count = 0
    local integer targetIndex
    local boolean present
    if not IsGamePlayerSlot(pid) or Hero[pid] == null or GetOwningPlayer(Hero[pid]) != Player(pid) or heroId != QB_Hero[pid] or seq <= REC_Sequence[pid] or StringLength(text) > 220 then
        return
    endif
    set REC_Sequence[pid] = seq
    if packetVersion != REC_Version[pid] then
        if op == "L" then
            set REC_LoadMask[pid] = 0
            set QB_Awaiting[pid] = false
            set REC_Lock[pid] = 0
        endif
        return
    endif
    if op == "L" and value >= 0 and value < 4 then
        if value == 0 then
            set REC_LoadMask[pid] = 0
            set REC_LoadBase[pid] = seq
            set REC_Lock[pid] = 60
        endif
        if REC_LoadMask[pid] != value or seq != REC_LoadBase[pid] + value or QB_Field(text, 12) != "" then
            set REC_LoadMask[pid] = 0
            set QB_Awaiting[pid] = false
            set REC_Lock[pid] = 0
            return
        endif
        loop
            exitwhen i >= 7
            set id = QB_Int(QB_Field(text, i + 5))
            if QB_Field(text, i + 5) == "" or id < 0 or (id != 0 and not QB_Valid(id)) then
                set REC_LoadMask[pid] = 0
                set QB_Awaiting[pid] = false
            set REC_Lock[pid] = 0
                return
            endif
            set REC_Pending[pid * REC_CAPACITY + value * 7 + i] = id
            set i = i + 1
        endloop
        set REC_LoadMask[pid] = value + 1
        if value != 3 then
            return
        endif
        set i = 0
        loop
            exitwhen i >= REC_CAPACITY
            set id = REC_Pending[pid * REC_CAPACITY + i]
            if id != 0 then
                set REC_Item[pid * REC_CAPACITY + count] = id
                set count = count + 1
            endif
            set i = i + 1
        endloop
        set REC_Count[pid] = count
        loop
            exitwhen count >= REC_CAPACITY
            set REC_Item[pid * REC_CAPACITY + count] = 0
            set count = count + 1
        endloop
        set REC_LoadMask[pid] = 0
        set QB_Awaiting[pid] = false
            set REC_Lock[pid] = 0
        call REC_Apply(pid)
    elseif op == "X" then
        set REC_LoadMask[pid] = 0
        set QB_Awaiting[pid] = false
            set REC_Lock[pid] = 0
        return
    elseif op == "A" and QB_Valid(value) and REC_Count[pid] < REC_CAPACITY and not QB_Awaiting[pid] and not CheckBanItems(value, Hero[pid]) then
        loop
            exitwhen i >= REC_Count[pid]
            if REC_Item[pid * REC_CAPACITY + i] == value then
                return
            endif
            set i = i + 1
        endloop
        set REC_Item[pid * REC_CAPACITY + REC_Count[pid]] = value
        set REC_Count[pid] = REC_Count[pid] + 1
        call REC_Apply(pid)
        call StartSoundForPlayerBJ(Player(pid), REC_AddSound)
    elseif op == "D" and value >= 0 and value < REC_Count[pid] and not QB_Awaiting[pid] then
        set i = value
        loop
            exitwhen i + 1 >= REC_Count[pid]
            set REC_Item[pid * REC_CAPACITY + i] = REC_Item[pid * REC_CAPACITY + i + 1]
            set i = i + 1
        endloop
        set REC_Count[pid] = REC_Count[pid] - 1
        set REC_Item[pid * REC_CAPACITY + REC_Count[pid]] = 0
        call REC_Apply(pid)
        call StartSoundForPlayerBJ(Player(pid), REC_RemoveSound)
    elseif op == "M" and value >= 0 and value < REC_Count[pid] and dest >= 0 and dest < REC_Count[pid] and not QB_Awaiting[pid] then
        set id = REC_Item[pid * REC_CAPACITY + value]
        set i = value
        loop
            exitwhen i == dest
            if i < dest then
                set REC_Item[pid * REC_CAPACITY + i] = REC_Item[pid * REC_CAPACITY + i + 1]
                set i = i + 1
            else
                set REC_Item[pid * REC_CAPACITY + i] = REC_Item[pid * REC_CAPACITY + i - 1]
                set i = i - 1
            endif
        endloop
        set REC_Item[pid * REC_CAPACITY + dest] = id
        call REC_Apply(pid)
    elseif op == "R" and not QB_Awaiting[pid] then
        loop
            exitwhen i >= REC_CAPACITY
            set REC_Item[pid * REC_CAPACITY + i] = REC_Default[pid * REC_CAPACITY + i]
            if REC_Item[pid * REC_CAPACITY + i] != 0 then
                set count = count + 1
            endif
            set i = i + 1
        endloop
        set REC_Count[pid] = count
        call REC_Apply(pid)
    elseif op == "Q" and not QB_Awaiting[pid] then
        // Append the first six current recommendations without clearing user steps.
        loop
            exitwhen i >= IMinBJ(6, REC_Count[pid]) or QB_Count[pid] >= 6
            set id = REC_Item[pid * REC_CAPACITY + i]
            set targetIndex = 0
            set present = false
            loop
                exitwhen targetIndex >= QB_Count[pid]
                set present = present or QB_Target[pid * 6 + targetIndex] == id
                set targetIndex = targetIndex + 1
            endloop
            if not present then
                call QB_ClearExcluded(pid, QB_Count[pid])
                set QB_GoalSerial[pid * 6 + QB_Count[pid]] = 0
                set QB_Target[pid * 6 + QB_Count[pid]] = id
                set QB_Count[pid] = QB_Count[pid] + 1
                set count = count + 1
            endif
            set i = i + 1
        endloop
        set QB_Lock[pid] = 0
        if count > 0 then
            call QB_Rebuild(pid)
            call StartSoundForPlayerBJ(Player(pid), QB_AddSound)
        elseif GetLocalPlayer() == Player(pid) then
            call DisplayTimedTextToPlayer(Player(pid), 0, 0, 4, "[WoS] Quick Buy is full or these targets are already queued.")
        endif
    elseif op == "B" and not QB_Awaiting[pid] then
        set REC_Lock[pid] = 60
        return
    elseif op == "U" then
        set REC_Lock[pid] = 0
        return
    elseif op == "S" and not QB_Awaiting[pid] then
        if GetLocalPlayer() == Player(pid) then
            call REC_SaveLocal(pid)
        endif
        return
    else
        return
    endif
    if Shop_Active[pid] and REC_Active(pid) then
        call ReloadItemPage2(0, Player(pid))
    endif
    if GetLocalPlayer() == Player(pid) then
        call QB_RefreshAdds()
    endif
    call QB_RenderLocal()
endfunction

// Agreed inspection command. No local recipe lookup or gameplay cache mutation.
function QB_Inspect takes integer pid, integer id returns nothing
    local player p = Player(pid)
    local integer cost = IMaxBJ(0, CheckItemsReduceCostCraft(Hero[pid], LoadInteger(QB_Data, id, 1), id, false))
    set ItemsCurrentItemBag_ID[pid] = 0
    set ItemsCraftPlayerDebug_ID[pid] = 42
    set ItemsCurrentItem_ID[pid] = id
    set ItemsCurrentItem_ID_BACKUP[pid] = id
    if GetLocalPlayer() == p then
        call BlzFrameSetVisible(FRAME_ShopItemCraftSprite2, false)
        call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, true)
        call BlzFrameSetTexture(FRAME_ShopItemBack[42], LoadStr(QB_Data, id, 2), 0, false)
        call BlzFrameSetText(FRAME_ShopItemCost[42], "|c00FFFF00" + I2S(cost) + "|r")
        call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], CondArena == 0 or TestMode)
        call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], false)
    endif
    call ShopShowItemDescription(id, p)
    call CraftItemCheck(id, p, ItemsFrameCurrentPage_ID[pid])
    set p = null
endfunction

// Allies only. A plain text message (not BlzDisplayChatMessage) so Esc's
// ClearTextMessages wipes it like any other notice.
function QB_TeamChat takes player sender, string message returns nothing
    if IsPlayerAlly(GetLocalPlayer(), sender) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 6.00, "|cff9aa0a8[Allies]|r " + GetPlayerColorString(sender) + GetPlayerName(sender) + "|r: " + message)
    endif
endfunction

// Called only from the agreed versioned UI request. No ability handle lookup.
function QB_AnnounceHeroCooldown takes player sender, integer commandSlot returns nothing
    local integer pid = GetPlayerId(sender)
    local unit u = Hero[pid]
    local integer id
    local integer level
    local real now
    local string name
    local real cooldown
    local string duration
    if pid < 0 or pid >= 10 or u == null or GetUnitTypeId(u) == 0 or GetOwningPlayer(u) != sender or commandSlot < 0 or commandSlot > 11 then
        set u = null
        return
    endif
    set now = TimerGetElapsed(ShopClock)
    if now < QB_AbilityChatNext[pid] then
        set u = null
        return
    endif
    set id = AHUI_GetAbilityAtCommandSlot(u, commandSlot)
    if id == 0 then
        set u = null
        return
    endif
    set level = GetUnitAbilityLevel(u, id)
    set name = BlzGetAbilityTooltip(id, IMaxBJ(0, level - 1))
    if name == "" then
        set name = GetObjectName(id)
    endif
    set QB_AbilityChatNext[pid] = now + QB_ABILITY_CHAT_COOLDOWN
    if level <= 0 then
        call QB_TeamChat(sender, "Ability |cffffffff" + name + "|r is not learned.")
    else
        set cooldown = BlzGetUnitAbilityCooldownRemaining(u, id)
        if cooldown <= 0.05 then
            call QB_TeamChat(sender, "Ability |cffffffff" + name + "|r is |cff40ff40ready|r.")
        else
            if cooldown >= 10.00 then
                set duration = I2S(R2I(cooldown + 0.99))
            else
                set duration = R2SW(cooldown, 1, 1)
            endif
            call QB_TeamChat(sender, "Ability |cffffffff" + name + "|r - CD: |cffffcc00" + duration + " sec.|r")
        endif
    endif
    set u = null
    set name = null
endfunction

function QB_OnSync takes nothing returns nothing
    local integer pid = GetPlayerId(GetTriggerPlayer())
    local string text = BlzGetTriggerSyncData()
    local string op = QB_Field(text, 0)
    local integer heroId = QB_Int(QB_Field(text, 1))
    local integer packetVersion = QB_Int(QB_Field(text, 2))
    local integer sequence = QB_Int(QB_Field(text, 3))
    local integer value = QB_Int(QB_Field(text, 4))
    local integer to = QB_Int(QB_Field(text, 5))
    local integer i = 0
    local integer goalIndex
    local integer node
    call QB_ApplyHeroRequests()
    if BlzGetTriggerSyncPrefix() == REC_SYNC then
        call REC_OnSync()
        return
    endif
    if not IsGamePlayerSlot(pid) or Hero[pid] == null or GetOwningPlayer(Hero[pid]) != Player(pid) or heroId != QB_Hero[pid] or sequence <= QB_Sequence[pid] or StringLength(text) > 220 then
        return
    endif
    set QB_Sequence[pid] = sequence
    // Chat has its own cooldown; purchases must not stale this non-queue request.
    if op == "P" then
        if value >= 0 and value < 12 and to == GetHandleId(Hero[pid]) and QB_Field(text, 6) == "" then
            call QB_AnnounceHeroCooldown(Player(pid), value)
        endif
        return
    endif
    if packetVersion != QB_Version[pid] then
        if op == "U" then
            set QB_Lock[pid] = 0
        endif
        return
    endif
    if op == "A" and QB_Valid(value) and QB_Count[pid] < 6 and not QB_Awaiting[pid] then
        loop
            exitwhen i >= QB_Count[pid]
            if QB_Target[pid * 6 + i] == value then
                return
            endif
            set i = i + 1
        endloop
        call QB_ClearExcluded(pid, QB_Count[pid])
        set QB_GoalSerial[pid * 6 + QB_Count[pid]] = 0
        set QB_Target[pid * 6 + QB_Count[pid]] = value
        set QB_Count[pid] = QB_Count[pid] + 1
        call QB_Rebuild(pid)
        call StartSoundForPlayerBJ(Player(pid), QB_AddSound)
    elseif op == "V" and value >= 0 and value < QB_StepCount[pid] and Shop_Active[pid] and not QB_Awaiting[pid] then
        call QB_Inspect(pid, QB_Step[pid * QB_MAX_STEPS + value])
    elseif op == "D" and value >= 0 and value < QB_StepCount[pid] then
        set goalIndex = QB_Group[pid * QB_MAX_STEPS + value]
        set node = QB_StepKey[pid * QB_MAX_STEPS + value]
        set QB_Excluded[pid * 768 + goalIndex * QB_MAX_STEPS + node] = true
        set QB_Lock[pid] = 0
        call QB_Rebuild(pid)
        call StartSoundForPlayerBJ(Player(pid), QB_RemoveSound)
    elseif op == "C" and QB_Count[pid] > 0 then
        set i = 0
        loop
            exitwhen i >= 6
            call QB_ClearExcluded(pid, i)
            set i = i + 1
        endloop
        set QB_Lock[pid] = 0
        set QB_Count[pid] = 0
        set QB_OrderCount[pid] = 0
        set QB_Awaiting[pid] = false
        call QB_Rebuild(pid)
        call StartSoundForPlayerBJ(Player(pid), QB_ClearSound)
    elseif op == "B" then
        set QB_Lock[pid] = 60
    elseif op == "U" then
        set QB_Lock[pid] = 0
    elseif op == "M" and value >= 0 and value < QB_StepCount[pid] and to >= 0 and to < QB_StepCount[pid] then
        call QB_MoveStep(pid, value, to)
        call QB_CaptureOrder(pid)
        call QB_CachePriceParents(pid)
        call QB_RefreshPrices(pid)
        set QB_Lock[pid] = 0
        set QB_Version[pid] = QB_Version[pid] + 1
    endif
    call QB_RenderLocal()
endfunction
// Round the two axes independently. Bounds never wrap across grid rows.
function QB_GridDragTarget takes integer source, integer count, integer columns, real dx, real dy, real stepX, real stepY returns integer
    local integer col = ModuloInteger(source, columns)
    local integer row = R2I(I2R(source) / I2R(columns))
    if dx >= 0.00 then
        set col = col + R2I(dx / stepX + 0.50)
    else
        set col = col - R2I(-dx / stepX + 0.50)
    endif
    if dy >= 0.00 then
        set row = row + R2I(dy / stepY + 0.50)
    else
        set row = row - R2I(-dy / stepY + 0.50)
    endif
    set col = IMaxBJ(0, IMinBJ(columns - 1, col))
    set row = IMaxBJ(0, IMinBJ(R2I(I2R(count - 1) / I2R(columns)), row))
    return IMaxBJ(0, IMinBJ(count - 1, row * columns + col))
endfunction

// Local input only; the authenticated M command applies the resulting order.
function QB_UpdateDragTarget takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local real dx = (BlzPixelToFrameX(BlzGetMouseScreenPosX()) - Shop_Shift()) - QB_DragX
    local real dy = QB_DragY - BlzPixelToFrameY(BlzGetMouseScreenPosY())
    if QB_DragFrom >= 0 then
        set QB_DragTo = QB_GridDragTarget(QB_DragFrom, QB_StepCount[pid], QB_Columns, dx, dy, QB_Width / I2R(QB_Columns), 0.065)
    endif
    if REC_DragFrom >= 0 then
        set REC_DragTo = QB_GridDragTarget(REC_DragFrom, REC_Count[pid], 7, dx, dy, 0.049, 0.056)
    endif
    call QB_DragRender()
endfunction

// Press/release snapshots are local input; only bounded commands cross sync.
function QB_FinishDrag takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local integer dest
    call QB_UpdateDragTarget()
    if QB_DragFrom >= 0 then
        set dest = QB_DragTo
        if dest != QB_DragFrom and QB_DragVersion == QB_Version[pid] and Shop_Active[pid] and WUI_TopShown() then
            call QB_Send("M", I2S(QB_DragFrom) + "," + I2S(dest))
        else
            call QB_Send("U", "0")
        endif
        set QB_DragFrom = -1
    endif
    if REC_DragFrom >= 0 then
        set dest = REC_DragTo
        if dest != REC_DragFrom and REC_DragVersion == REC_Version[pid] and Shop_Active[pid] and WUI_TopShown() and REC_Active(pid) then
            call REC_Send("M", I2S(REC_DragFrom) + "," + I2S(dest))
        else
            call REC_Send("U", "0")
        endif
        set REC_DragFrom = -1
    endif
    set QB_LastViewVersion = -1
    call QB_DragRender()
endfunction

function QB_CancelDrag takes nothing returns nothing
    if QB_DragFrom >= 0 then
        set QB_DragFrom = -1
        call QB_Send("U", "0")
    endif
    if REC_DragFrom >= 0 then
        set REC_DragFrom = -1
        call REC_Send("U", "0")
    endif
    set QB_LastViewVersion = -1
    call QB_DragRender()
endfunction

function QB_ButtonEvent takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local framehandle fr = BlzGetTriggerFrame()
    local integer codeId = LoadInteger(QB_Frames, GetHandleId(fr), 0)
    local integer i
    local integer id = 0
    if GetLocalPlayer() != p then
        set p = null
        set fr = null
        call WUI_ReleaseClickFocus()
        return
    endif
    if BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_UP then
        if not BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_RIGHT) then
            set QB_RightWasDown = false
        endif
        if (QB_DragFrom >= 0 or REC_DragFrom >= 0) and not BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_RIGHT) then
            call QB_FinishDrag()
        endif
    elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
        if codeId < 500 or codeId >= 600 then
            call QB_CancelDrag()
        endif
        if codeId >= 100 and codeId <= 160 then
            set i = codeId - 100
            set id = QB_AddId[i]
            if QB_Valid(id) then
                call QB_Send("A", I2S(id))
            endif
        elseif codeId >= 200 and codeId < 200 + QB_VISIBLE then
            set i = QB_Page * QB_ViewCount + codeId - 200
            if i < QB_StepCount[pid] then
                call QB_Send("D", I2S(i))
            endif
        elseif codeId >= 400 and codeId < 406 then
            set i = codeId - 400
            if Hero[pid] != null and UNITSTAT_GetSelected(pid) == Hero[pid] and QB_PreviewVersion[i] == QB_Version[pid] and QB_PreviewStep[i] >= 0 and QB_PreviewStep[i] < QB_StepCount[pid] and UnitItemInSlot(Hero[pid], i) == null then
                call QB_Send("D", I2S(QB_PreviewStep[i]))
            endif
        elseif codeId == 300 then
            call QB_Send("C", "0")
        elseif codeId >= 500 and codeId < 500 + QB_VISIBLE and QB_DragFrom < 0 and REC_DragFrom < 0 then
            set i = QB_Page * QB_ViewCount + codeId - 500
            if i < QB_StepCount[pid] then
                call QB_Send("V", I2S(i))
            endif
        elseif codeId >= 800 and codeId <= 860 then
            set id = QB_AddId[codeId - 800]
            if QB_Valid(id) then
                call REC_Send("A", I2S(id))
            endif
        elseif codeId >= 600 and codeId < 600 + REC_CAPACITY and REC_Active(pid) then
            call REC_Send("D", I2S(codeId - 600))
        elseif codeId == 700 then
            call REC_Send("R", "0")
        elseif codeId == 701 then
            call REC_LoadLocal(pid, false)
        elseif codeId == 702 then
            call REC_Send("S", "0")
        elseif codeId == 703 then
            call REC_Send("Q", "0")
        elseif codeId == 301 and QB_Page > 0 then
            set QB_Page = QB_Page - 1
        elseif codeId == 302 and (QB_Page + 1) * QB_ViewCount < QB_StepCount[pid] then
            set QB_Page = QB_Page + 1
        endif
        call QB_RenderLocal()
    endif
    set fr = null
    set p = null
    if codeId >= 600 and codeId < 600 + REC_CAPACITY then
        call WUI_ResetClickedButtonFocus()
    else
        call WUI_ReleaseClickFocus()
    endif
endfunction

function QB_Decor takes string name, framehandle parent, string texture returns framehandle
    local framehandle fr = BlzCreateFrameByType("BACKDROP", name, parent, "", 0)
    call BlzFrameSetTexture(fr, texture, 0, true)
    call BlzFrameSetEnable(fr, false)
    return fr
endfunction

function QB_Text takes string name, framehandle parent, real size returns framehandle
    local framehandle fr = BlzCreateFrameByType("TEXT", name, parent, "", 0)
    call BlzFrameSetEnable(fr, false)
    call BlzFrameSetScale(fr, size)
    call BlzFrameSetTextAlignment(fr, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    return fr
endfunction

function QB_CreateTip takes integer index returns nothing
    set QB_TipBox[index] = WUI_TooltipBox(WUI_GetRoot(), 0.190, 0.075)
    set QB_Tip[index] = QB_Text("WOSQuickBuyTooltipText", QB_TipBox[index], 0.62)
    call BlzFrameSetPoint(QB_TipBox[index], FRAMEPOINT_BOTTOMRIGHT, QB_Slot[index], FRAMEPOINT_TOPRIGHT, 0.00, 0.010)
    call BlzFrameSetPoint(QB_Tip[index], FRAMEPOINT_CENTER, QB_TipBox[index], FRAMEPOINT_CENTER, 0.00, 0.00)
    call BlzFrameSetSize(QB_Tip[index], 0.178 / 0.62, 0.067 / 0.62)
    // Engine-owned tooltip, matching the catalogue; no hover trigger callbacks.
    call BlzFrameSetTooltip(QB_Slot[index], QB_TipBox[index])
    call BlzFrameSetLevel(QB_TipBox[index], 60)
    call BlzFrameSetVisible(QB_TipBox[index], false)
endfunction

function QB_Button takes string name, framehandle parent, string glyph, integer codeId returns framehandle
    local framehandle fr = BlzCreateFrameByType("BUTTON", name, parent, "WOSQB" + glyph + "Template", codeId)
    call BlzFrameSetLevel(fr, 30)
    call SaveInteger(QB_Frames, GetHandleId(fr), 0, codeId)
    call BlzTriggerRegisterFrameEvent(QB_ClickTrigger, fr, FRAMEEVENT_CONTROL_CLICK)
    return fr
endfunction



// Right press/release; native item hover has no scripted events.
// Called only for a pressed RMB, never for cursor ENTER/LEAVE.
function QB_BeginRightDrag takes integer pid, real x, real y returns nothing
    local integer i = 0
    local integer k
    set x = x - Shop_Shift()
    if GetLocalPlayer() != Player(pid) or not IsGamePlayerSlot(pid) then
        return
    endif
    if not Shop_Active[pid] or not WUI_TopShown() or QB_DragFrom >= 0 or REC_DragFrom >= 0 or QB_Awaiting[pid] then
        return
    endif
    loop
        exitwhen i >= QB_ViewCount
        set k = QB_Page * QB_ViewCount + i
        if k < QB_StepCount[pid] and QB_StepCount[pid] > 1 and RAbsBJ(x - QB_SlotX(i)) <= QB_Size * 0.50 and RAbsBJ(y - QB_SlotY(i)) <= QB_Size * 0.50 then
            set QB_DragFrom = k
            set QB_DragTo = k
            set QB_DragX = x
            set QB_DragY = y
            set QB_DragAge = 0
            set QB_DragVersion = QB_Version[pid]
            call BlzFrameSetVisible(QB_TipBox[i], false)
            call QB_Send("B", "0")
            call QB_DragRender()
            return
        endif
        set i = i + 1
    endloop
    if not REC_Active(pid) or REC_Count[pid] < 2 then
        return
    endif
    set i = 0
    loop
        exitwhen i >= REC_Count[pid]
        if RAbsBJ(x - (SHOP_LIST_X + I2R(ModuloInteger(i, 7) - 3) * 0.049)) <= 0.019 and RAbsBJ(y - (0.4565 - I2R(i / 7) * 0.056)) <= 0.019 then
            set REC_DragFrom = i
            set REC_DragTo = i
            set REC_DragVersion = REC_Version[pid]
            set QB_DragX = x
            set QB_DragY = y
            set QB_DragAge = 0
            call REC_Send("B", "0")
            call QB_DragRender()
            return
        endif
        set i = i + 1
    endloop
endfunction

// Inventory events only. World mouse clicks are not registered by the shop.
function QB_OnMouse takes nothing returns nothing
    local integer pid = GetPlayerId(GetTriggerPlayer())
    local integer i = 0
    if GetLocalPlayer() != GetTriggerPlayer() or not IsGamePlayerSlot(pid) then
        return
    endif
    if GetTriggerEventId() == EVENT_PLAYER_UNIT_PICKUP_ITEM or GetTriggerEventId() == EVENT_PLAYER_UNIT_DROP_ITEM then
        if GetTriggerUnit() == Hero[pid] then
            loop
                exitwhen i >= 6
                call BlzFrameSetVisible(QB_Preview[i], false)
                call QB_ShowPreviewRemove(i, false)
                set QB_LastPreview[i] = -1
                set QB_PreviewStep[i] = -1
                set i = i + 1
            endloop
        endif
        return
    endif
endfunction

// Owner-local input; called directly by the existing .05 shop debounce timer.
function QB_ApplyLocalUIChanges takes nothing returns nothing
    if QB_SeenCloseSerial != WUI_ShopCloseSerial then
        set QB_SeenCloseSerial = WUI_ShopCloseSerial
        call QB_CancelDrag()
    endif
    if QB_SeenRenderSerial != WUI_ShopRenderSerial then
        set QB_SeenRenderSerial = WUI_ShopRenderSerial
        call QB_RenderLocal()
    endif
endfunction

// Invoked only by this player's enabled shop-input trigger.
function QB_CheckDrag takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    call QB_ApplyLocalUIChanges()
    if QB_DragFrom < 0 and REC_DragFrom < 0 then
        if not Shop_Active[pid] or not WUI_TopShown() then
            return
        endif
        if not BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_RIGHT) then
            set QB_RightWasDown = false
            return
        endif
        if QB_RightWasDown then
            return
        endif
        set QB_RightWasDown = true
        call QB_BeginRightDrag(pid, BlzPixelToFrameX(BlzGetMouseScreenPosX()), BlzPixelToFrameY(BlzGetMouseScreenPosY()))
        if QB_DragFrom < 0 and REC_DragFrom < 0 then
            return
        endif
    endif
    set QB_DragAge = QB_DragAge + 1
    if QB_DragAge >= 600 or not Shop_Active[pid] or not WUI_TopShown() or (REC_DragFrom >= 0 and (not REC_Active(pid) or REC_DragVersion != REC_Version[pid])) or (QB_DragFrom >= 0 and QB_DragVersion != QB_Version[pid]) then
        call QB_CancelDrag()
    elseif not BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_RIGHT) then
        // Swallowed player/UI release: read final X only for an active drag.
        set QB_RightWasDown = false
        call QB_FinishDrag()
    else
        call QB_UpdateDragTarget()
    endif
endfunction

function QB_OnRmbTick takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    if pid < 10 and GetTriggeringTrigger() == WUI_ShopRmbTrigger[pid] then
        call QB_CheckDrag()
    endif
endfunction

// Existing shared timer; local drag paint is isolated inside QB_CheckDrag.
function ShopSearchDebounceTick takes nothing returns nothing
    local integer pid = 0

    call QB_ApplyHeroRequests()
    call QB_ApplyLocalUIChanges()
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

globals
    // Local presentation only: last gold number written into the inventory caption.
    integer ShopGoldShown = -1
endglobals

// Own gold inside the shop (inventory caption). Text only, local client, on change.
function ShopRefreshGoldLabel takes boolean always returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local integer gold
    if not ShopUICreated or FRAME_ShopGoldText == null or pid >= 12 or not Shop_Active[pid] then
        return
    endif
    set gold = GetPlayerState(GetLocalPlayer(), PLAYER_STATE_RESOURCE_GOLD)
    if always or gold != ShopGoldShown then
        set ShopGoldShown = gold
        call BlzFrameSetText(FRAME_ShopGoldText, "|cff3cff3c" + I2S(gold) + "|r")
    endif
endfunction

function WOS_ToggleShop takes player p returns nothing
    local integer id = GetPlayerId(p)
    local integer playerHandleId = GetHandleId(p)
    if Hero[id] == null and not IsObserverSlot(id) then
        return
    endif
    if LoadInteger(hs, playerHandleId, SH_WoS_Shop_Init_SHOP_KEY_GUARD) != 0 then
        return
    endif
    call SaveInteger(hs, playerHandleId, SH_WoS_Shop_Init_SHOP_KEY_GUARD, 1)
    call MyFlush(playerHandleId, SH_WoS_Shop_Init_SHOP_KEY_GUARD, 0, 0.15)
    if Shop_Active[id] then
        set Shop_Active[id] = false
        call WUI_SetShopRmb(id, false)
        if GetLocalPlayer() == p then
            call QB_CancelDrag()
        endif
        if ShopUICreated and FRAME_ShopMAIN != null and GetLocalPlayer() == p then
            call BlzFrameSetVisible(FRAME_ShopMAIN, false)
        endif
    elseif END1 == 0 then
        if not ShopUICreated or FRAME_ShopMAIN == null then
            call DisplayTimedTextToPlayer(p, 0, 0, 1.50, "Shop UI is not ready yet")
        else
            set Shop_Active[id] = true
            set ItemsCraftPlayerDebug_ID[id] = -1
            call ReloadItemPage(ItemsFrameCurrentPage_ID[id], p)
            call ShopUpdateCatalogueNavigation(id, p)
            call WUI_EnterExclusiveWindow(0, p)
            if GetLocalPlayer() == p then
                if IsObserverSlot(id) then
                    call BlzFrameSetVisible(FRAME_AutoBuyCheckbox, false)
                    call BlzFrameSetVisible(FRAME_AutoBuyText, false)
                    call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[6], false)
                    call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[7], false)
                endif
                call BlzFrameSetVisible(FRAME_ShopMAIN, true)
            endif
            call ShopRefreshGoldLabel(true)
        endif
    endif
endfunction


function QB_ShopKey takes nothing returns nothing
    if BlzGetTriggerPlayerKey() == WUI_GetHotkey(WUI_HOTKEY_SHOP, GetPlayerId(GetTriggerPlayer())) then
        call WOS_ToggleShop(GetTriggerPlayer())
    endif
endfunction

function QB_ShopButton takes nothing returns nothing
    call WOS_ToggleShop(GetTriggerPlayer())
    call WUI_ReleaseClickFocus()
endfunction

function QB_CreateUI takes nothing returns nothing
    local trigger shopKeys = CreateTrigger()
    local trigger shopClick = CreateTrigger()
    local integer i = 0
    local integer id
    local integer slot
    local framehandle text
    local framehandle fr
    call TriggerAddAction(shopKeys, function QB_ShopKey)
    call WUI_RegisterHotkeyEx(WUI_HOTKEY_SHOP, shopKeys, OSKEY_TAB, "TAB", false, UNITSTAT_Shop, WUI_GetRoot(), true)
    call BlzTriggerRegisterFrameEvent(shopClick, UNITSTAT_Shop, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(shopClick, function QB_ShopButton)
    set shopKeys = null
    set shopClick = null
    // Reuse existing agreed sound handles. No local sound allocation.
    set QB_AddSound = gg_snd_UpkeepRing
    set QB_RemoveSound = gg_snd_ReceiveGold
    set QB_ClearSound = gg_snd_AlchemistTransmuteDeath1
    set REC_AddSound = gg_snd_Swap
    set REC_RemoveSound = gg_snd_BattleNetTick
    set QB_Data = InitHashtable()
    set QB_Frames = InitHashtable()
    loop
        exitwhen i >= ShopSearchIndexCount
        call QB_CacheItem(ShopSearchIndex_ID[i], 0)
        set i = i + 1
    endloop
    set QB_ClickTrigger = CreateTrigger()
    set QB_MouseTrigger = CreateTrigger()
    set QB_SyncTrigger = CreateTrigger()
    call TriggerAddAction(QB_ClickTrigger, function QB_ButtonEvent)
    call TriggerAddAction(QB_MouseTrigger, function QB_OnMouse)
    call TriggerAddAction(QB_SyncTrigger, function QB_OnSync)
    set i = 0
    loop
        exitwhen i >= 10
        set WUI_ShopRmbTrigger[i] = CreateTrigger()
        call TriggerRegisterTimerExpireEvent(WUI_ShopRmbTrigger[i], ShopSearchDebounceTimer)
        call TriggerAddAction(WUI_ShopRmbTrigger[i], function QB_OnRmbTick)
        call DisableTrigger(WUI_ShopRmbTrigger[i])
        call WUI_SetShopRmb(i, Shop_Active[i])
        call BlzTriggerRegisterPlayerSyncEvent(QB_SyncTrigger, Player(i), QB_SYNC, false)
        call BlzTriggerRegisterPlayerSyncEvent(QB_SyncTrigger, Player(i), REC_SYNC, false)
        call TriggerRegisterPlayerUnitEvent(QB_MouseTrigger, Player(i), EVENT_PLAYER_UNIT_PICKUP_ITEM, null)
        call TriggerRegisterPlayerUnitEvent(QB_MouseTrigger, Player(i), EVENT_PLAYER_UNIT_DROP_ITEM, null)
        set i = i + 1
    endloop


    // A reserved row in Recommended, never in other catalogue categories.
    set i = 0
    loop
        exitwhen i >= 4
        set REC_Action[i] = WUI_TextButton("WOSRecommendedAction", FRAME_ShopItemList, "", 0.077, 0.022)
        call WUI_SetButtonMinimal(REC_Action[i])
        call WUI_SetButtonTextScale(REC_Action[i], 0.62)
        call Shop_Place(REC_Action[i], SHOP_LIST_X - 0.126 + I2R(i) * 0.084, 0.2325, 0.077, 0.022)
        call SaveInteger(QB_Frames, GetHandleId(REC_Action[i]), 0, 700 + i)
        call BlzTriggerRegisterFrameEvent(QB_ClickTrigger, REC_Action[i], FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetVisible(REC_Action[i], false)
        set i = i + 1
    endloop
    call WUI_SetButtonCaption(REC_Action[0], "Reset")
    call WUI_SetButtonCaption(REC_Action[1], "Load Build")
    call WUI_SetButtonCaption(REC_Action[2], "Save Build")
    call WUI_SetButtonCaption(REC_Action[3], "Add to QB")
    call WUI_Tooltip(REC_Action[0], "Restore this hero's original map recommendations.")
    call WUI_Tooltip(REC_Action[1], "Load your personal recommendations for this hero.")
    call WUI_Tooltip(REC_Action[2], "Save the current Recommended list for this hero. Quick Buy is not saved.")
    call WUI_Tooltip(REC_Action[3], "Add the first six current recommendations, up to six active targets. Existing steps are kept.")
    set REC_Hint = QB_Text("WOSRecommendedDragHint", FRAME_ShopItemList, 0.54)
    call Shop_Place(REC_Hint, SHOP_LIST_X, 0.2115, 0.334 / 0.54, 0.012 / 0.54)
    call BlzFrameSetText(REC_Hint, WUI_TEXT + "Hold RMB on an item: drag left/right|r")
    call BlzFrameSetVisible(REC_Hint, false)
    set i = 0
    loop
        exitwhen i >= REC_CAPACITY
        set REC_Remove[i] = QB_Button("WOSRecommendedRemove", FRAME_ShopItemList, "remove", 600 + i)
        call BlzFrameSetPoint(REC_Remove[i], FRAMEPOINT_TOPLEFT, FRAME_ShopItem[i], FRAMEPOINT_TOPLEFT, 0.001, -0.001)
        call BlzFrameSetSize(REC_Remove[i], 0.010, 0.010)
        call BlzFrameSetLevel(REC_Remove[i], 55)
        call BlzFrameSetVisible(REC_Remove[i], false)
        call WUI_Tooltip(REC_Remove[i], "Remove this recommendation; the remaining items shift left.")
        call BlzTriggerRegisterFrameEvent(QB_ClickTrigger, FRAME_ShopItem[i], FRAMEEVENT_MOUSE_UP)
        set i = i + 1
    endloop
    set REC_DragLight = QB_Decor("WOSRecommendedDrag", FRAME_ShopItemList, QB_TEXTURE + "drag.tga")
    set REC_DropLine = QB_Decor("WOSRecommendedDrop", FRAME_ShopItemList, QB_TEXTURE + "drop.tga")
    call BlzFrameSetLevel(REC_DragLight, 50)
    call BlzFrameSetLevel(REC_DropLine, 50)
    call BlzFrameSetVisible(REC_DragLight, false)
    call BlzFrameSetVisible(REC_DropLine, false)
    set QB_Panel = WUI_Window("WOSQuickBuyPanel", FRAME_ShopMAIN, 92, 0)
    call WUI_MinimalEdge(QB_Panel)
    call Shop_Place(QB_Panel, QB_Left + QB_Width * 0.50, 0.2255, QB_Width, 0.255)
    set QB_Title = QB_Text("WOSQuickBuyTitle", QB_Panel, 0.72)
    call Shop_Place(QB_Title, QB_Left + QB_Width * 0.50, 0.328, (QB_Width - 0.052) / 0.72, 0.012 / 0.72)
    call BlzFrameSetText(QB_Title, WUI_GOLD + "QUICK BUY|r")
    set QB_Hint = QB_Text("WOSQuickBuyDragHint", QB_Panel, 0.52)
    call Shop_Place(QB_Hint, QB_Left + QB_Width * 0.50, 0.126, (QB_Width - 0.046) / 0.52, 0.013 / 0.52)
    call BlzFrameSetText(QB_Hint, WUI_TEXT + "Hold RMB: drag left / right / up / down|r")
    set QB_StateText = QB_Text("WOSQuickBuyState", QB_Panel, 0.60)
    call Shop_Place(QB_StateText, QB_Left + QB_Width * 0.50, 0.107, (QB_Width - 0.046) / 0.60, 0.010 / 0.60)
    set QB_StateIcon = QB_Decor("WOSQuickBuyStateIcon", QB_Panel, QB_TEXTURE + "gold.tga")
    call Shop_Place(QB_StateIcon, QB_Left + 0.010, 0.328, 0.014, 0.014)
    set QB_Clear = QB_Button("WOSQuickBuyClear", QB_Panel, "clear", 300)
    call Shop_Place(QB_Clear, QB_Right - 0.012, 0.328, 0.018, 0.018)
    call WUI_Tooltip(QB_Clear, "Clear the active Quick Buy queue. The saved build is kept.")
    set QB_Previous = QB_Button("WOSQuickBuyPrevious", QB_Panel, "prev", 301)
    set QB_Next = QB_Button("WOSQuickBuyNext", QB_Panel, "next", 302)
    call Shop_Place(QB_Previous, QB_Left + 0.011, 0.126, 0.016, 0.016)
    call Shop_Place(QB_Next, QB_Right - 0.011, 0.126, 0.016, 0.016)
    set i = 0
    loop
        exitwhen i >= QB_VISIBLE
        set QB_Slot[i] = BlzCreateFrameByType("BUTTON", "WOSQuickBuySlot", QB_Panel, "WOSQBslotTemplate", i)
        call Shop_Place(QB_Slot[i], QB_SlotX(i), QB_SlotY(i), QB_Size, QB_Size)
        set QB_Icon[i] = QB_Decor("WOSQuickBuyIcon", QB_Slot[i], WUI_EMPTY_TEXTURE)
        call BlzFrameSetPoint(QB_Icon[i], FRAMEPOINT_CENTER, QB_Slot[i], FRAMEPOINT_CENTER, 0.00, 0.00)
        set QB_SlotEdge[i] = QB_Decor("WOSQuickBuySlotEdge", QB_Slot[i], QB_TEXTURE + "rim.tga")
        call BlzFrameSetAllPoints(QB_SlotEdge[i], QB_Slot[i])
        set QB_SlotBolt[i] = QB_Decor("WOSQuickBuySlotBolt", QB_Slot[i], QB_TEXTURE + "bolt.tga")
        call BlzFrameSetPoint(QB_SlotBolt[i], FRAMEPOINT_CENTER, QB_Slot[i], FRAMEPOINT_CENTER, 0.00, 0.00)
        call BlzFrameSetSize(QB_SlotBolt[i], 0.018, 0.018)
        call BlzFrameSetAlpha(QB_SlotBolt[i], 180)
        set QB_StepPlate[i] = QB_Decor("WOSQuickBuyPricePlate", QB_Slot[i], "UI\\WOS\\price-plate.tga")
        call BlzFrameSetPoint(QB_StepPlate[i], FRAMEPOINT_BOTTOM, QB_Slot[i], FRAMEPOINT_BOTTOM, 0.00, 0.001)
        call BlzFrameSetSize(QB_StepPlate[i], RMinBJ(0.034, QB_Size), 0.010)
        set QB_PriceText[i] = QB_Text("WOSQuickBuyPrice", QB_Slot[i], 0.57)
        call BlzFrameSetPoint(QB_PriceText[i], FRAMEPOINT_BOTTOM, QB_Slot[i], FRAMEPOINT_BOTTOM, 0.00, 0.001)
        call BlzFrameSetSize(QB_PriceText[i], 0.050, 0.018)
        set QB_Name[i] = QB_Text("WOSQuickBuyItemName", QB_Panel, 0.52)
        call BlzFrameSetPoint(QB_Name[i], FRAMEPOINT_TOP, QB_Slot[i], FRAMEPOINT_BOTTOM, 0.00, -0.001)
        call BlzFrameSetSize(QB_Name[i], (QB_Width / I2R(QB_Columns) - 0.003) / 0.52, 0.013 / 0.52)
        call BlzFrameSetVisible(QB_Name[i], false)
        set QB_Remove[i] = QB_Button("WOSQuickBuyRemove", QB_Panel, "remove", 200 + i)
        call BlzFrameSetPoint(QB_Remove[i], FRAMEPOINT_TOP, QB_Slot[i], FRAMEPOINT_BOTTOM, 0.00, -0.016)
        call BlzFrameSetSize(QB_Remove[i], 0.014, 0.010)
        call WUI_Tooltip(QB_Remove[i], "Remove this step only. Pay its skipped portion during assembly; other components buy normally.")
        call QB_CreateTip(i)
        call SaveInteger(QB_Frames, GetHandleId(QB_Slot[i]), 0, 500 + i)
        call BlzTriggerRegisterFrameEvent(QB_ClickTrigger, QB_Slot[i], FRAMEEVENT_CONTROL_CLICK)
        call BlzTriggerRegisterFrameEvent(QB_ClickTrigger, QB_Slot[i], FRAMEEVENT_MOUSE_UP)
        call BlzFrameSetVisible(QB_Slot[i], false)
        call BlzFrameSetVisible(QB_Remove[i], false)
        set i = i + 1
    endloop
    set QB_First = QB_Decor("WOSQuickBuyFirst", QB_Panel, QB_TEXTURE + "first.tga")
    call Shop_Place(QB_First, QB_SlotX(0), QB_SlotY(0), QB_Size + 0.004, QB_Size + 0.004)
    set QB_DragLight = QB_Decor("WOSQuickBuyDrag", QB_Panel, QB_TEXTURE + "drag.tga")
    set i = 0
    loop
        exitwhen i >= 8
        if i < 4 then
            set QB_DragArrow[i] = QB_Decor("WOSDragPointer", QB_Panel, "UI\\WOS\\drag-arrow-right.tga")
        else
            set QB_DragArrow[i] = QB_Decor("WOSDragPointer", FRAME_ShopItemList, "UI\\WOS\\drag-arrow-right.tga")
        endif
        if ModuloInteger(i, 4) == 1 then
            call BlzFrameSetTexture(QB_DragArrow[i], "UI\\WOS\\drag-arrow-left.tga", 0, true)
        elseif ModuloInteger(i, 4) == 2 then
            call BlzFrameSetTexture(QB_DragArrow[i], "UI\\WOS\\drag-arrow-up.tga", 0, true)
        elseif ModuloInteger(i, 4) == 3 then
            call BlzFrameSetTexture(QB_DragArrow[i], "UI\\WOS\\drag-arrow-down.tga", 0, true)
        endif
        call BlzFrameSetEnable(QB_DragArrow[i], false)
        call BlzFrameSetLevel(QB_DragArrow[i], 60)
        call BlzFrameSetVisible(QB_DragArrow[i], false)
        set i = i + 1
    endloop

    set QB_DropLine = QB_Decor("WOSQuickBuyDrop", QB_Panel, QB_TEXTURE + "drop.tga")
    call BlzFrameSetLevel(QB_First, 40)
    call BlzFrameSetLevel(QB_DragLight, 40)
    call BlzFrameSetLevel(QB_DropLine, 40)
    call BlzFrameSetVisible(QB_DragLight, false)
    call BlzFrameSetVisible(QB_DropLine, false)
    set i = 0
    loop
        exitwhen i >= 61
        if i < 35 or i >= 36 then
            set REC_AddButton[i] = QB_Button("WOSRecommendedAdd", FRAME_ShopItem[i], "rec-add", 800 + i)
            call BlzFrameSetPoint(REC_AddButton[i], FRAMEPOINT_TOPLEFT, FRAME_ShopItem[i], FRAMEPOINT_TOPLEFT, 0.001, -0.001)
            call BlzFrameSetSize(REC_AddButton[i], 0.010, 0.010)
            call BlzFrameSetVisible(REC_AddButton[i], false)
            call WUI_Tooltip(REC_AddButton[i], "Add this item to your current Recommended list. Use Save Build to save the list to disk.")
            set QB_Add[i] = QB_Button("WOSQuickBuyAdd", FRAME_ShopItem[i], "add", 100 + i)
            call BlzFrameSetPoint(QB_Add[i], FRAMEPOINT_TOPRIGHT, FRAME_ShopItem[i], FRAMEPOINT_TOPRIGHT, -0.001, -0.001)
            call BlzFrameSetSize(QB_Add[i], 0.010, 0.010)
            call BlzFrameSetVisible(QB_Add[i], false)
            call WUI_Tooltip(QB_Add[i], "Add to Quick Buy. Up to six targets; recipes expand automatically.")
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 6
        set QB_Preview[i] = BlzCreateFrameByType("FRAME", "WOSQuickBuyPreviewRoot", WUI_GetRoot(), "", i)
        call WUI_PlaceShift(QB_Preview[i], WUI_ItemX(i) - WUI_HudShift, WUI_ItemY(i), 0.028, 0.028)
        call BlzFrameSetLevel(QB_Preview[i], 30)
        set QB_PreviewIcon[i] = QB_Decor("WOSQuickBuyPreviewIcon", QB_Preview[i], WUI_EMPTY_TEXTURE)
        call BlzFrameSetPoint(QB_PreviewIcon[i], FRAMEPOINT_CENTER, QB_Preview[i], FRAMEPOINT_CENTER, 0.00, 0.00)
        call BlzFrameSetSize(QB_PreviewIcon[i], 0.026, 0.026)
        call BlzFrameSetAlpha(QB_PreviewIcon[i], 100)
        set QB_PreviewEdge[i] = QB_Decor("WOSQuickBuyPreviewEdge", QB_Preview[i], "UI\\WOS\\QuickBuy\\BTNPAS.tga")
        call BlzFrameSetAllPoints(QB_PreviewEdge[i], QB_Preview[i])
        call BlzFrameSetAlpha(QB_PreviewEdge[i], 170)
        set QB_PreviewBolt[i] = QB_Decor("WOSQuickBuyPreviewBolt", QB_Preview[i], QB_TEXTURE + "bolt.tga")
        call BlzFrameSetPoint(QB_PreviewBolt[i], FRAMEPOINT_CENTER, QB_Preview[i], FRAMEPOINT_CENTER, 0.00, 0.00)
        call BlzFrameSetSize(QB_PreviewBolt[i], 0.016, 0.016)
        call BlzFrameSetAlpha(QB_PreviewBolt[i], 180)
        set QB_PreviewPlate[i] = QB_Decor("WOSQuickBuyPreviewPlate", QB_Preview[i], "UI\\WOS\\price-plate.tga")
        call BlzFrameSetPoint(QB_PreviewPlate[i], FRAMEPOINT_BOTTOM, QB_Preview[i], FRAMEPOINT_BOTTOM, 0.00, 0.001)
        call BlzFrameSetSize(QB_PreviewPlate[i], 0.026, 0.010)
        call BlzFrameSetAlpha(QB_PreviewPlate[i], 220)
        set QB_PreviewPrice[i] = QB_Text("WOSQuickBuyPreviewPrice", QB_Preview[i], 0.62)
        call BlzFrameSetPoint(QB_PreviewPrice[i], FRAMEPOINT_BOTTOM, QB_Preview[i], FRAMEPOINT_BOTTOM, 0.00, 0.0015)
        call BlzFrameSetSize(QB_PreviewPrice[i], 0.028 / 0.62, 0.010 / 0.62)
        // SIMPLEBUTTON shares the native inventory input family; root stays visible.
        // Created and registered once, agreed. Never changes the native item button.
        set QB_PreviewRemove[i] = BlzCreateSimpleFrame("WOSQBHUDRemove", WUI_GetSimpleRoot(), 9300 + i)
        call SaveInteger(QB_Frames, GetHandleId(QB_PreviewRemove[i]), 0, 400 + i)
        call BlzTriggerRegisterFrameEvent(QB_ClickTrigger, QB_PreviewRemove[i], FRAMEEVENT_CONTROL_CLICK)
        // Slim control under its own preview, on the lower rim between native rows.
        call WUI_PlaceShift(QB_PreviewRemove[i], WUI_ItemX(i) - WUI_HudShift, WUI_ItemY(i) - 0.0140, 0.014, 0.00525)
        call BlzFrameSetLevel(QB_PreviewRemove[i], 55)
        // Normal-frame skin is visible above the HUD art; SIMPLEBUTTON retains input.
        set QB_PreviewMinusFace[i] = QB_Button("WOSQuickBuyHUDMinusFace", WUI_GetRoot(), "hudremove", 400 + i)
        call WUI_PlaceShift(QB_PreviewMinusFace[i], WUI_ItemX(i) - WUI_HudShift, WUI_ItemY(i) - 0.0140, 0.014, 0.00525)
        call BlzFrameSetLevel(QB_PreviewMinusFace[i], 80)
        call BlzFrameSetEnable(QB_PreviewMinusFace[i], false)
        call BlzFrameSetVisible(QB_PreviewMinusFace[i], false)
        // SIMPLEBUTTON supports click; no normal-frame tooltip/focus on this handle.
        set QB_PreviewStep[i] = -1
        call BlzFrameSetVisible(QB_Preview[i], false)
        call BlzFrameSetEnable(QB_PreviewRemove[i], false)
        call BlzFrameSetVisible(QB_PreviewRemove[i], false)
        set i = i + 1
    endloop
    call QB_Layout()
    call QB_RefreshAdds()
    set i = 0
    loop
        exitwhen i >= 10
        if Hero[i] != null then
            call QB_OnHero(i, GetUnitTypeId(Hero[i]))
        endif
        set i = i + 1
    endloop
    call QB_RenderLocal()
    set text = null
    set fr = null
endfunction

// Existing AutoBuy timer is the only purchase scheduler. Max one successful
// item addition per player per 0.50 s. No gameplay read from local templates.
function QB_CanBuyStep takes integer pid, integer id returns boolean
    local integer i = 0
    local integer j
    local integer component
    loop
        exitwhen i >= 6
        set QB_Used[i] = false
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= GetCraftComponentCount(id)
        set component = GetCraftComponent(id, i)
        set j = 0
        loop
            exitwhen j >= 6 or (not QB_Used[j] and QB_Inventory[pid * 6 + j] == component)
            set j = j + 1
        endloop
        if j >= 6 then
            return false
        endif
        set QB_Used[j] = true
        set i = i + 1
    endloop
    return true
endfunction

// A deferred assembly cannot absorb retained steps still scheduled below it,
// even if the player has dragged the parent ahead of those steps.
function QB_ReadyDeferred takes integer pid, integer step returns boolean
    local integer off = pid * QB_MAX_STEPS
    local integer i = 0
    local integer node = QB_StepKey[off + step]
    local integer startNode = QB_SubtreeStart[off + step]
    local integer groupIndex = QB_Group[off + step]
    loop
        exitwhen i >= QB_StepCount[pid]
        if QB_Group[off + i] == groupIndex and QB_StepKey[off + i] >= startNode and QB_StepKey[off + i] < node then
            return false
        endif
        set i = i + 1
    endloop
    return true
endfunction

function QB_BuyWhole takes integer pid, unit c, integer id, integer cost returns integer
    local integer slot = 0
    local boolean space = CheckSlotAvailable(c)
    // The preceding agreed cost calculation populated UsedSlot.
    loop
        exitwhen slot >= 6 or space
        set space = UsedSlot[slot]
        set slot = slot + 1
    endloop
    if not space or GetGold(Player(pid)) < cost or ShopRoundLocked(id) then
        return 1
    endif
    call AddGold(Player(pid), cost, false)
    call CheckItemsReduceCostCraft(c, LoadInteger(QB_Data, id, 1), id, true)
    call UnitAddItemById(c, id)
    call ShopMarkFullRefund(c, id, cost)
    call StartSoundForPlayerBJ(Player(pid), gg_snd_AlchemistTransmuteDeath1)
    return 0
endfunction



// Full inventory fallback: fold missing parts into one ready assembly operation.
// 0 = purchased, 1 = gold missing for a space-releasing recipe, 2 = no safe slot.
function QB_TryFullAssembly takes integer pid, unit c returns integer
    local integer step = 0
    local integer id
    local integer slot
    local integer cost
    local integer result
    local boolean releases
    local boolean needGold = false
    local boolean changed = false
    loop
        exitwhen step >= QB_StepCount[pid]
        set id = QB_Step[pid * QB_MAX_STEPS + step]
        if QB_Valid(id) and GetCraftComponentCount(id) > 0 and not CheckBanItems(id, c) then
            set cost = IMaxBJ(0, CheckItemsReduceCostCraft(c, LoadInteger(QB_Data, id, 1), id, false))
            set releases = false
            set slot = 0
            loop
                exitwhen slot >= 6
                set releases = releases or UsedSlot[slot]
                set slot = slot + 1
            endloop
            if releases then
                if GetGold(Player(pid)) >= cost then
                    set result = QB_BuyWhole(pid, c, id, cost)
                    if result == 0 then
                        set slot = 0
                        loop
                            exitwhen slot >= 6
                            set changed = changed or QB_Inventory[pid * 6 + slot] != GetItemTypeId(UnitItemInSlot(c, slot))
                            set slot = slot + 1
                        endloop
                        if changed then
                            call QB_Rebuild(pid)
                        else
                            set QB_Error[pid] = "Purchase result not confirmed"
                            set QB_Status[pid] = 3
                        endif
                        return 0
                    endif
                else
                    set needGold = true
                endif
            endif
        endif
        set step = step + 1
    endloop
    if needGold then
        return 1
    endif
    return 2
endfunction

function ShopPricesTick takes integer pid, unit c returns nothing
    local integer i = 0
    local integer id
    local boolean changed = false
    loop
        exitwhen i >= 6
        set id = GetItemTypeId(UnitItemInSlot(c, i))
        if ShopPriceInventory[pid * 6 + i] != id then
            set ShopPriceInventory[pid * 6 + i] = id
            set changed = true
        endif
        set i = i + 1
    endloop
    if changed and Shop_Active[pid] then
        call ReloadItemPage2(ItemsFrameCurrentPage_ID[pid], Player(pid))
    endif
endfunction

function QB_Tick takes integer pid, unit c returns boolean
    local integer i = 0
    local integer id
    local integer before
    local integer result
    local integer step = 0
    local boolean deferred = false
    local integer cost
    local boolean waitDeferredGold = false
    local boolean dirty = false
    local boolean changed = false
    if QB_Awaiting[pid] then
        return true
    endif
    if QB_Count[pid] == 0 then
        return false
    endif
    if QB_Lock[pid] > 0 then
        set QB_Lock[pid] = QB_Lock[pid] - 1
        return true
    endif
    loop
        exitwhen i >= 6
        if QB_Inventory[pid * 6 + i] != GetItemTypeId(UnitItemInSlot(c, i)) then
            set dirty = true
        endif
        set i = i + 1
    endloop
    if dirty then
        call QB_Rebuild(pid)
    endif
    if QB_Count[pid] == 0 then
        return false
    endif
    if QB_Status[pid] == 3 then
        return true
    endif
    if c == null or GetUnitTypeId(c) == 0 or IsUnitType(c, UNIT_TYPE_DEAD) or GetOwningPlayer(c) != Player(pid) or (CondArena != 0 or not CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c))) then
        set QB_Status[pid] = 2
        return true
    endif
    if not CheckSlotAvailable(c) then
        set result = QB_TryFullAssembly(pid, c)
        if result != 0 then
            set QB_Status[pid] = result
        endif
        return true
    endif
    loop
        exitwhen step >= QB_StepCount[pid]
        set id = QB_Step[pid * QB_MAX_STEPS + step]
        set deferred = QB_StepMissing[pid * QB_MAX_STEPS + step]
        if QB_Valid(id) and not CheckBanItems(id, c) then
            if deferred and QB_ReadyDeferred(pid, step) then
                // Strict queue order: a ready step waits for its gold instead of
                // letting later (cheaper) steps jump ahead of it.
                set cost = IMaxBJ(0, CheckItemsReduceCostCraft(c, LoadInteger(QB_Data, id, 1), id, false))
                set QB_Cost[pid * QB_MAX_STEPS + step] = cost
                exitwhen true
            elseif not deferred and QB_CanBuyStep(pid, id) then
                exitwhen true
            endif
        endif
        set step = step + 1
    endloop
    if step >= QB_StepCount[pid] then
        set QB_Error[pid] = "Waiting for an available recipe; queue retained"
        if waitDeferredGold then
            set QB_Status[pid] = 1
        else
            set QB_Status[pid] = 4
        endif
        return true
    endif
    set before = GetGold(Player(pid))
    set cost = IMaxBJ(0, CheckItemsReduceCostCraft(c, LoadInteger(QB_Data, id, 1), id, false))
    set QB_Cost[pid * QB_MAX_STEPS + step] = cost
    if before < cost then
        set QB_Status[pid] = 1
        return true
    endif
    set QB_Status[pid] = 2
    if deferred then
        set result = QB_BuyWhole(pid, c, id, cost)
    else
        set result = BuyAutoLimited(c, id, 1)
    endif
    set i = 0
    loop
        exitwhen i >= 6
        if QB_Inventory[pid * 6 + i] != GetItemTypeId(UnitItemInSlot(c, i)) then
            set changed = true
        endif
        set i = i + 1
    endloop
    if result == 0 and changed then
        call QB_Rebuild(pid)
    elseif result == 0 then
        // A purchase attempted but its inventory result was not confirmed.
        set QB_Error[pid] = "Purchase result not confirmed"
        set QB_Status[pid] = 3
    endif
    return true
endfunction

// Добавляет игроку не более двух предметов при первой закупке.
function FirstRoundAutoBuyOnce takes unit c, integer pid returns nothing
    local integer index = 0
    local integer itemId

    if QB_Awaiting[pid] then
        set QB_FirstDeferred[pid] = true
        set QB_AnyFirstDeferred = true
        return
    endif
    if QB_Count[pid] > 0 then
        return
    endif
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
// Preserve the old forced opening purchase when an empty saved build's ACK
// arrives after round start. A nonempty Quick Buy still owns the purchase slot.
function QB_RunDeferredFirst takes nothing returns nothing
    local integer pid = 0
    if not QB_AnyFirstDeferred then
        return
    endif
    set QB_AnyFirstDeferred = false
    loop
        exitwhen pid >= 10
        if QB_FirstDeferred[pid] then
            if QB_Awaiting[pid] then
                set QB_AnyFirstDeferred = true
            else
                set QB_FirstDeferred[pid] = false
                if QB_Count[pid] == 0 and Hero[pid] != null and Round1Started == 1 and CurrentRound == 1 and not TestMode then
                    call FirstRoundAutoBuyOnce(Hero[pid], pid)
                endif
            endif
        endif
        set pid = pid + 1
    endloop
endfunction

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
            set AutoBuyRecommendedDone[pid] = true
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
                if id != 0 then
                    set refundFlag = LoadInteger(hs, GetHandleId(u), ShopRefundKey[slot])
                endif

                set cacheIndex = pid * 6 + slot
                
                if GetLocalPlayer() == p then
                    if ShopInventoryLastId[cacheIndex] != id or ShopInventoryLastRefund[cacheIndex] != refundFlag then
                        set tooltipNameStr = ""
                        set invCost1 = ""
                        set invCost2 = ""
                        set itemName = ""
                        set iconPath = "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder"
                        set tooltipWidth = ShopGetItemTooltipWidth("")
                        set tooltip = FRAME_ShopInventoryTooltipBox[slot]
                
                        if id != 0 then
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
                
                    endif
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
                            call BlzFrameSetSize(FRAME_ShopInventoryPricePlate[slot], RMinBJ(invPlate, QB_InventorySize), RMinBJ(0.0105, QB_InventorySize * 0.35))
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
    call PlayerInventoryPeriodic()
    call ShopRefreshGoldLabel(false)
    call QB_ApplyHeroRequests()
    call QB_RunDeferredFirst()
    loop
        exitwhen playerNumber > 10
        set pid = playerNumber - 1
        if IsActivePlayerSlot(pid) and Hero[pid] != null then
            set c = Hero[pid]
            if QB_Hero[pid] == 0 then
                call QB_OnHero(pid, GetUnitTypeId(c))
            endif
            if AutoBuyRecommendedUnitId[pid] != GetHandleId(c) then
                call ResetRecommendedAutoBuy(pid, c)
            endif
            if REC_Lock[pid] > 0 then
                set REC_Lock[pid] = REC_Lock[pid] - 1
            endif
            call ShopPricesTick(pid, c)
            // Старая рабочая схема: значение хранится отдельно под handle игрока.
            if not QB_Tick(pid, c) then
            if REC_Lock[pid] == 0 and not QB_Awaiting[pid] and LoadInteger(hs, GetHandleId(Player(pid)), SH_WoS_Shop_Init_AUTOBUY) == 1 and GetOwningPlayer(c) == Player(pid) and not AutoBuyRecommendedDone[pid] and CondArena == 0 and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) then
                call RecommendedAutoBuyTick(c, pid)
            endif
            endif
        endif
        set playerNumber = playerNumber + 1
    endloop
    call QB_RenderLocal()
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
            set on = LoadInteger(hs, GetHandleId(Player(pid)), SH_WoS_Shop_Init_AUTOBUY) != 1
            if on then
                call ResetRecommendedAutoBuy(pid, Hero[pid])
                call SaveInteger(hs, GetHandleId(Player(pid)), SH_WoS_Shop_Init_AUTOBUY, 1)
            else
                call SaveInteger(hs, GetHandleId(Player(pid)), SH_WoS_Shop_Init_AUTOBUY, 0)
            endif
            if GetLocalPlayer() == GetTriggerPlayer() then
                call ShopShowAutoBuyState(on)
            endif
        endif
    elseif clicked == FRAME_AutoBuyCheckbox then
        if pid >= 0 and pid < 10 and IsActivePlayerSlot(pid) then
            if BlzGetTriggerFrameEvent() == FRAMEEVENT_CHECKBOX_CHECKED then
                if LoadInteger(hs, GetHandleId(Player(pid)), SH_WoS_Shop_Init_AUTOBUY) != 1 then
                    call ResetRecommendedAutoBuy(pid, Hero[pid])
                endif
                call SaveInteger(hs, GetHandleId(Player(pid)), SH_WoS_Shop_Init_AUTOBUY, 1)
            else
                call SaveInteger(hs, GetHandleId(Player(pid)), SH_WoS_Shop_Init_AUTOBUY, 0)
            endif
        endif
    endif
    set clicked = null
    call WUI_ResetClickedButtonFocus()
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

call WUI_EnterExclusiveWindow(0, p)
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
    
    if id == 0 and (prefix == "WScU" or prefix == "WScC") then
        set p = null
        return
    endif
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
    set p = null
    call WUI_ReleaseClickFocus()
endfunction

function ShopCreateFastToggles takes nothing returns nothing
    local trigger click = CreateTrigger()
    set FRAME_FastBuyToggle = BlzCreateFrameByType("BUTTON", "ShopFastBuy", FRAME_ShopItemInventory, "WOSIconButtonTemplate", 0)
    call Shop_Place(FRAME_FastBuyToggle, SHOP_INV_X - 0.024, 0.169, 0.022, 0.022)
    set FRAME_FastBuyIcon = BlzCreateFrameByType("BACKDROP", "ShopFastBuyIcon", FRAME_FastBuyToggle, "", 0)
    call BlzFrameSetAllPoints(FRAME_FastBuyIcon, FRAME_FastBuyToggle)
    call BlzFrameSetTexture(FRAME_FastBuyIcon, "UI\\WOS\\fastbuy-off.tga", 0, true)
    call BlzFrameSetEnable(FRAME_FastBuyIcon, false)
    call WUI_Tooltip(FRAME_FastBuyToggle, "|cff7ee870FAST BUY|r|nWhen on: double-click an item in the list or the tree to buy it.")
    set FRAME_FastSellToggle = BlzCreateFrameByType("BUTTON", "ShopFastSell", FRAME_ShopItemInventory, "WOSIconButtonTemplate", 0)
    call Shop_Place(FRAME_FastSellToggle, SHOP_INV_X + 0.024, 0.169, 0.022, 0.022)
    set FRAME_FastSellIcon = BlzCreateFrameByType("BACKDROP", "ShopFastSellIcon", FRAME_FastSellToggle, "", 0)
    call BlzFrameSetAllPoints(FRAME_FastSellIcon, FRAME_FastSellToggle)
    call BlzFrameSetTexture(FRAME_FastSellIcon, "UI\\WOS\\fastsell-off.tga", 0, true)
    call BlzFrameSetEnable(FRAME_FastSellIcon, false)
    call WUI_Tooltip(FRAME_FastSellToggle, "|cffff8a73FAST SELL|r|nWhen on: double-click an item of your inventory to sell it.")
    call BlzTriggerRegisterFrameEvent(click, FRAME_FastBuyToggle, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(click, FRAME_FastSellToggle, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(click, function ShopFastToggleClick)
    // Saved settings may arrive before these handles are created.
    // Both handles already exist here; only paint the owner's existing icons.
    if ShopFastBuy[GetPlayerId(GetLocalPlayer())] then
        call BlzFrameSetTexture(FRAME_FastBuyIcon, "UI\\WOS\\fastbuy-on.tga", 0, true)
    endif
    if ShopFastSell[GetPlayerId(GetLocalPlayer())] then
        call BlzFrameSetTexture(FRAME_FastSellIcon, "UI\\WOS\\fastsell-on.tga", 0, true)
    endif
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
    call Shop_Place(FRAME_ShopMAIN, 0.400, 0.337, 0.756, 0.378)
    // Checkpoint 23: narrower catalogue, wider item tree + description.
    call Shop_Place(FRAME_ShopItemList, SHOP_LIST_X, 0.340, 0.350, 0.282)
    // Checkpoint 26b: tree top level with the inventory (.483), description
    // shorter (it scrolls) and flush below it; bottom level with inventory.
    call Shop_Place(FRAME_ShopItemCraft, SHOP_TREE_X, 0.3595, 0.252, 0.247)
    call Shop_Place(FRAME_ShopItemDescription, SHOP_TREE_X, 0.1955, 0.252, 0.081)
    call Shop_Place(FRAME_ShopItemInventory, SHOP_INV_X, 0.319, 0.112, 0.328)
    call ShopCreateVipPage()
    call Shop_Place(FRAME_ShopRecipeTitle, SHOP_TREE_X, 0.4765, 0.157, 0.012)
    call Shop_Place(FRAME_ShopItemDescriptionName, SHOP_TREE_X, 0.2255, 0.230 / 0.85, 0.016 / 0.85)
    call BlzFrameSetScale(FRAME_ShopItemDescriptionName, 0.85)
    call BlzFrameSetTextAlignment(FRAME_ShopItemDescriptionName, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    // Centred description using the whole block.
    call Shop_Place(FRAME_ShopItemDescriptionName2, SHOP_TREE_X, 0.1905, 0.236 / 0.80, 0.050 / 0.80)
    call BlzFrameSetTextAlignment(FRAME_ShopItemDescriptionName2, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(FRAME_ShopItemDescriptionName2, 0.80)
    call BlzFrameSetEnable(FRAME_ShopItemDescriptionName2, false)
    call Shop_Place(FRAME_ShopItemInventoryName, SHOP_INV_X + 0.004, 0.468, 0.104, 0.016)
    call BlzFrameSetScale(FRAME_ShopItemInventoryName, 0.90)
    call BlzFrameSetTextAlignment(FRAME_ShopItemInventoryName, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)
    call BlzFrameSetEnable(FRAME_ShopItemInventoryName, false)
    // Search row: gold caption | inset field with gold edge | clear (X) | Autobuy.
    call Shop_Place(FRAME_ShopSearchLabel, 0.070, 0.165, 0.047, 0.016)
    call BlzFrameSetScale(FRAME_ShopSearchLabel, 0.80)
    call BlzFrameSetTextAlignment(FRAME_ShopSearchLabel, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_RIGHT)
    call Shop_Place(FRAME_ShopSearchEditBox, 0.205, 0.165, 0.230, 0.020)
    call Shop_Place(FRAME_ShopSearchClear, 0.336, 0.165, 0.017, 0.017)
    // Page switch of the catalogue: centred under the grid, above the search.
    call Shop_Place(FRAME_ShopSearchPrevious, SHOP_LIST_X - 0.042, 0.1885, 0.018, 0.016)
    call Shop_Place(FRAME_ShopSearchPageText, SHOP_LIST_X, 0.1885, 0.050, 0.012)
    call BlzFrameSetScale(FRAME_ShopSearchPageText, 0.85)
    call Shop_Place(FRAME_ShopSearchNext, SHOP_LIST_X + 0.042, 0.1885, 0.018, 0.016)
    call ShopStylePageButton(FRAME_ShopSearchPrevious, FRAME_ShopSearchPreviousIcon, "UI\\WOS\\glyph-prev.tga")
    call ShopStylePageButton(FRAME_ShopSearchNext, FRAME_ShopSearchNextIcon, "UI\\WOS\\glyph-next.tga")
    if FRAME_FastBuyToggle == null then
        call ShopCreateFastToggles()
        call ShopCreateDescScroll()
    endif
    // Autobuy lives in the HUD inventory header now (FRAME_AutoBuyToggle).
    call Shop_Place(FRAME_AutoBuyCheckbox, -0.40, -0.40, 0.016, 0.016)
    call Shop_Place(FRAME_AutoBuyText, -0.40, -0.40, 0.060, 0.016)
    call BlzFrameSetVisible(FRAME_AutoBuyCheckbox, false)
    call BlzFrameSetVisible(FRAME_AutoBuyText, false)
    call BlzFrameSetScale(FRAME_AutoBuyText, 0.85)
    call BlzFrameSetTextAlignment(FRAME_AutoBuyText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)
    loop
        exitwhen i >= SHOP_TAB_COUNT
        call Shop_Place(FRAME_ShopSection[i], 0.077 + I2R(i) * 0.0800, 0.505, 0.077, 0.027)
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
        call Shop_Place(FRAME_ShopItem[i], x, y, 0.038, 0.038)
        call ShopPlacePrice(FRAME_ShopItemCost[i], FRAME_ShopItemPricePlate[i], x, y, 0.038)
        call BlzFrameClearAllPoints(FRAME_ShopItemName[i])
        call Shop_SetAbsPoint(FRAME_ShopItemName[i], FRAMEPOINT_TOP, x, y - 0.0205)
        call BlzFrameSetSize(FRAME_ShopItemName[i], 0.048 / 0.64, 0.014 / 0.64)
        set i = i + 1
    endloop
    // Tree rows are placed per item when shown (CraftItemCheck); only the
    // centre item is fixed. Its price sits to the right, clear of the lines.
    call Shop_Place(FRAME_ShopItem[42], SHOP_TREE_X, SHOP_TREE_CENTER_Y, 0.030, 0.030)
    call ShopPlacePrice(FRAME_ShopItemCost[42], FRAME_ShopItemPricePlate[42], SHOP_TREE_X, SHOP_TREE_CENTER_Y, 0.030)
    call BlzFrameSetSize(FRAME_ShopItemPricePlate[42], 0.0305, 0.0105)
    set FRAME_ShopItemName[42] = BlzCreateFrameByType("TEXT", "ShopTreeItemName", FRAME_ShopItem[42], "", 42)
    call BlzFrameSetTextAlignment(FRAME_ShopItemName[42], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(FRAME_ShopItemName[42], 0.56)
    call BlzFrameSetEnable(FRAME_ShopItemName[42], false)
    call Shop_SetAbsPoint(FRAME_ShopItemName[42], FRAMEPOINT_TOP, SHOP_TREE_X, SHOP_TREE_CENTER_Y - 0.015 - 0.0012)
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
            call Shop_Place(FRAME_ShopRecipeLine[i * 3 + 2], SHOP_TREE_X, 0.3910, 0.0008, 0.0012)
        elseif i >= SHOP_TREE_GROUP and i < SHOP_TREE_GROUP + SHOP_TREE_ROW then
            call Shop_Place(FRAME_ShopRecipeLine[i * 3 + 2], SHOP_TREE_X, 0.3482, 0.0008, 0.0025)
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
    call Shop_Place(FRAME_ShopCraftUpgradeScroll, SHOP_TREE_X + 0.115, 0.438, 0.011, 0.070)
    call Shop_Place(FRAME_ShopCraftComponentScroll, SHOP_TREE_X + 0.115, 0.313, 0.011, 0.070)
    call Shop_Place(FRAME_ShopCraftUpgradeWheelArea, SHOP_TREE_X, 0.438, 0.226, 0.076)
    call Shop_Place(FRAME_ShopCraftComponentWheelArea, SHOP_TREE_X, 0.313, 0.226, 0.076)
    set i = 0
    loop
        exitwhen i >= 8
        set x = SHOP_INV_X - 0.024 + I2R(ModuloInteger(i, 2)) * 0.048
        set y = 0.429 - I2R(i / 2) * 0.061
        if i >= 6 then
            set y = 0.205
        endif
        call Shop_Place(FRAME_ShopItemInventorySlot[i], x, y, 0.038, 0.038)
        call ShopPlacePrice(FRAME_ShopItemInventorySlotCost[i], FRAME_ShopInventoryPricePlate[i], x, y, 0.038)
        if i < 6 then
            set FRAME_ShopInventoryItemName[i] = BlzCreateFrameByType("TEXT", "WOSShopInventoryItemName", FRAME_ShopItemInventorySlot[i], "", i)
            call Shop_SetAbsPoint(FRAME_ShopInventoryItemName[i], FRAMEPOINT_TOP, x, y - 0.0205)
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
        call SaveInteger(hs, GetHandleId(Player(pid)), SH_WoS_Shop_Init_AUTOBUY, 0)
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
            exitwhen i2 >= SHOP_SECTION_STRIDE
            set ShopSectionPage[pid * SHOP_SECTION_STRIDE + i2] = 0
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
    call WUI_RegisterWindowPart(0, FRAME_ShopMAIN)
    // Hero overlays step aside while the shop is open (see WUI_RefreshDocks).
    call WUI_RegisterCover(FRAME_ShopMAIN)
    call WUI_RegisterModal(FRAME_ShopMAIN)
    call Shop_Place(FRAME_ShopMAIN, 0.400, 0.339, 0.756, 0.340)
    set FRAME_ShopItemList = WUI_Window("WOSWindow", FRAME_ShopMAIN, 1, 0)
    call Shop_SetAbsPoint(FRAME_ShopItemList, FRAMEPOINT_CENTER, 0.31, 0.355)
    call BlzFrameSetTexture(FRAME_ShopItemList, WUI_PANEL_TEXTURE, 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemList, 255)
    call BlzFrameSetSize(FRAME_ShopItemList, 0.38, 0.28)
    set FRAME_ShopItemCraft = WUI_Window("WOSWindow", FRAME_ShopMAIN, 1, 0)
    call Shop_SetAbsPoint(FRAME_ShopItemCraft, FRAMEPOINT_CENTER, 0.5775, 0.405)
    call BlzFrameSetTexture(FRAME_ShopItemCraft, WUI_PANEL_TEXTURE, 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemCraft, 255)
    call BlzFrameSetSize(FRAME_ShopItemCraft, 0.18, 0.18)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopItemCraft), 0, 400)
    call BlzFrameSetEnable(FRAME_ShopItemCraft, true)
    call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopItemCraft, FRAMEEVENT_MOUSE_WHEEL)
    
    set FRAME_ShopCraftUpgradeWheelArea = BlzCreateFrameByType("BUTTON", "ShopCraftUpgradeWheelArea", FRAME_ShopItemCraft, "", 5101)
    call WUI_RegisterPassiveFocus(FRAME_ShopCraftUpgradeWheelArea)
    call BlzFrameSetPoint(FRAME_ShopCraftUpgradeWheelArea, FRAMEPOINT_TOPLEFT, FRAME_ShopItemCraft, FRAMEPOINT_TOPLEFT, 0.003, -0.003)
    call BlzFrameSetSize(FRAME_ShopCraftUpgradeWheelArea, 0.174, 0.090)
    call BlzFrameSetAlpha(FRAME_ShopCraftUpgradeWheelArea, 0)
    call BlzFrameSetLevel(FRAME_ShopCraftUpgradeWheelArea, 1)
    call BlzFrameSetEnable(FRAME_ShopCraftUpgradeWheelArea, true)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopCraftUpgradeWheelArea), 0, 403)
    call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopCraftUpgradeWheelArea, FRAMEEVENT_MOUSE_WHEEL)
    set FRAME_ShopCraftComponentWheelArea = BlzCreateFrameByType("BUTTON", "ShopCraftComponentWheelArea", FRAME_ShopItemCraft, "", 5102)
    call WUI_RegisterPassiveFocus(FRAME_ShopCraftComponentWheelArea)
    call BlzFrameSetPoint(FRAME_ShopCraftComponentWheelArea, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemCraft, FRAMEPOINT_BOTTOMLEFT, 0.003, 0.003)
    call BlzFrameSetSize(FRAME_ShopCraftComponentWheelArea, 0.174, 0.085)
    call BlzFrameSetAlpha(FRAME_ShopCraftComponentWheelArea, 0)
    call BlzFrameSetLevel(FRAME_ShopCraftComponentWheelArea, 1)
    call BlzFrameSetEnable(FRAME_ShopCraftComponentWheelArea, true)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopCraftComponentWheelArea), 0, 404)
    call BlzTriggerRegisterFrameEvent(FrameCraftWheel, FRAME_ShopCraftComponentWheelArea, FRAMEEVENT_MOUSE_WHEEL)
    set FRAME_ShopItemDescription = WUI_Window("WOSWindow", FRAME_ShopMAIN, 1, 0)
    call Shop_SetAbsPoint(FRAME_ShopItemDescription, FRAMEPOINT_CENTER, 0.5775, 0.2725)
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
    call Shop_SetAbsPoint(FRAME_ShopItemInventory, FRAMEPOINT_CENTER, 0.7225, 0.355)
    call BlzFrameSetTexture(FRAME_ShopItemInventory, WUI_PANEL_TEXTURE, 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemInventory, 255)
    call BlzFrameSetSize(FRAME_ShopItemInventory, 0.135, 0.28)
    set FRAME_ShopItemInventoryName = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemInventory, "", 0)
    call BlzFrameSetPoint(FRAME_ShopItemInventoryName, FRAMEPOINT_BOTTOM, FRAME_ShopItemInventory, FRAMEPOINT_TOP, 0, -0.025 )
    call BlzFrameSetText(FRAME_ShopItemInventoryName, "|c00FFFF00Inventory|r")
    set FRAME_ShopGoldPlate = WUI_Panel("ShopGoldPlate", FRAME_ShopItemInventory, 0.066, 0.020)
    call BlzFrameSetPoint(FRAME_ShopGoldPlate, FRAMEPOINT_TOPRIGHT, FRAME_ShopItemInventory, FRAMEPOINT_TOPRIGHT, -0.005, -0.004)
    call BlzFrameSetEnable(FRAME_ShopGoldPlate, false)
    call BlzFrameSetLevel(FRAME_ShopGoldPlate, 5)
    call WUI_GoldFrame("ShopGoldPlateEdge", FRAME_ShopGoldPlate, 0.0030, 0.0060)
    set FRAME_ShopGoldText = BlzCreateFrameByType("BACKDROP", "ShopGoldCoin", FRAME_ShopGoldPlate, "", 0)
    call BlzFrameSetTexture(FRAME_ShopGoldText, "UI\\Feedback\\Resources\\ResourceGold.blp", 0, true)
    call BlzFrameSetSize(FRAME_ShopGoldText, 0.015, 0.015)
    call BlzFrameSetPoint(FRAME_ShopGoldText, FRAMEPOINT_LEFT, FRAME_ShopGoldPlate, FRAMEPOINT_LEFT, 0.004, 0.000)
    call BlzFrameSetEnable(FRAME_ShopGoldText, false)
    set FRAME_ShopGoldText = BlzCreateFrameByType("TEXT", "ShopGoldText", FRAME_ShopGoldPlate, "", 0)
    call BlzFrameSetPoint(FRAME_ShopGoldText, FRAMEPOINT_RIGHT, FRAME_ShopGoldPlate, FRAMEPOINT_RIGHT, -0.004 / 1.10, 0.000)
    call BlzFrameSetSize(FRAME_ShopGoldText, 0.040 / 1.10, 0.016 / 1.10)
    call BlzFrameSetTextAlignment(FRAME_ShopGoldText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_RIGHT)
    call BlzFrameSetScale(FRAME_ShopGoldText, 1.10)
    call BlzFrameSetEnable(FRAME_ShopGoldText, false)
    call BlzFrameSetText(FRAME_ShopGoldText, "|cff3cff3c0|r")
    set FRAME_ShopSearchLabel = BlzCreateFrameByType("TEXT", "ShopSearchLabel", FRAME_ShopMAIN, "", 0)
    call Shop_SetAbsPoint(FRAME_ShopSearchLabel, FRAMEPOINT_CENTER, 0.145, 0.185)
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
    call Shop_SetAbsPoint(FRAME_ShopSearchEditBox, FRAMEPOINT_CENTER, 0.285, 0.185)
    call BlzFrameSetSize(FRAME_ShopSearchEditBox, 0.195, 0.030)
    call WUI_MinimalEdge(FRAME_ShopSearchEditBox)
    call BlzFrameSetText(FRAME_ShopSearchEditBox, "")
    call BlzFrameSetTextSizeLimit(FRAME_ShopSearchEditBox, 48)
    call BlzTriggerRegisterFrameEvent(FrameShopSearch, FRAME_ShopSearchEditBox, FRAMEEVENT_EDITBOX_TEXT_CHANGED)
    
    set FRAME_ShopSearchClear = BlzCreateFrameByType("BUTTON", "ShopSearchClear", FRAME_ShopMAIN, "WOSIconButtonTemplate", 0)
    call Shop_SetAbsPoint(FRAME_ShopSearchClear, FRAMEPOINT_CENTER, 0.398, 0.185)
    call BlzFrameSetSize(FRAME_ShopSearchClear, 0.020, 0.020)
    set FRAME_ShopSearchClearIcon = BlzCreateFrameByType("BACKDROP", "ShopSearchClearIcon", FRAME_ShopSearchClear, "", 0)
    call BlzFrameSetAllPoints(FRAME_ShopSearchClearIcon, FRAME_ShopSearchClear)
    call BlzFrameSetTexture(FRAME_ShopSearchClearIcon, "UI\\WOS\\glyph-close.tga", 0, true)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopSearchClear), 0, 405)
    call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopSearchClear, FRAMEEVENT_CONTROL_CLICK)
    set FRAME_ShopSearchPrevious = BlzCreateFrameByType("BUTTON", "ShopSearchPrevious", FRAME_ShopMAIN, "WOSIconButtonTemplate", 0)
    call Shop_SetAbsPoint(FRAME_ShopSearchPrevious, FRAMEPOINT_CENTER, 0.278, 0.215)
    call BlzFrameSetSize(FRAME_ShopSearchPrevious, 0.018, 0.018)
    set FRAME_ShopSearchPreviousIcon = BlzCreateFrameByType("BACKDROP", "ShopSearchPreviousIcon", FRAME_ShopSearchPrevious, "", 0)
    call BlzFrameSetAllPoints(FRAME_ShopSearchPreviousIcon, FRAME_ShopSearchPrevious)
    call BlzFrameSetTexture(FRAME_ShopSearchPreviousIcon, "Music\\Music_SkipLeft.blp", 0, true)
    call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopSearchPrevious), 0, 406)
    call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopSearchPrevious, FRAMEEVENT_CONTROL_CLICK)
    set FRAME_ShopSearchPageText = BlzCreateFrameByType("TEXT", "ShopSearchPageText", FRAME_ShopMAIN, "", 0)
    call Shop_SetAbsPoint(FRAME_ShopSearchPageText, FRAMEPOINT_CENTER, 0.310, 0.215)
    call BlzFrameSetSize(FRAME_ShopSearchPageText, 0.038, 0.016)
    call BlzFrameSetTextAlignment(FRAME_ShopSearchPageText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(FRAME_ShopSearchPageText, 0.90)
    call BlzFrameSetText(FRAME_ShopSearchPageText, "")
    set FRAME_ShopSearchNext = BlzCreateFrameByType("BUTTON", "ShopSearchNext", FRAME_ShopMAIN, "WOSIconButtonTemplate", 0)
    call Shop_SetAbsPoint(FRAME_ShopSearchNext, FRAMEPOINT_CENTER, 0.342, 0.215)
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
    call Shop_Place(FRAME_ShopClose, 0.768, 0.516, 0.016, 0.016)
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
    call WUI_Tooltip(FRAME_ShopClose, "|cffd5b876CLOSE WINDOW|r|nHotkey: ESC")
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
        exitwhen i == SHOP_TAB_COUNT
        set FRAME_ShopSection[i] = WUI_TextButton("ShopCategory" + I2S(i), FRAME_ShopMAIN, "", 0.098, 0.030)
        call WUI_SetButtonMinimal(FRAME_ShopSection[i])
        call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopSection[i]), 0, 100 + i)
        call Shop_SetAbsPoint(FRAME_ShopSection[i], FRAMEPOINT_CENTER, x, y)
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
        elseif i == SHOP_TAB_ATTACK then
            call WUI_SetButtonCaption(FRAME_ShopSection[i], "Attack")
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
        call WUI_PlaceShift(FRAME_AutoBuyToggle, 0.6465, 0.0839, 0.036, 0.010)
        call WUI_SetButtonTextScale(FRAME_AutoBuyToggle, 0.62)
        call ShopShowAutoBuyState(false)
        call WUI_RegisterHelpTarget(3, FRAME_AutoBuyToggle)
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
        call Shop_Place(FRAME_ShopItem[i], 0.552, 0.377, 0.036, 0.036)
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
    call WUI_FrameSetMinMaxValue(FRAME_ShopCraftUpgradeScroll, 0.00, 1.00)
    call BlzFrameSetStepSize(FRAME_ShopCraftUpgradeScroll, 1.00)
    call WUI_FrameSetValue(FRAME_ShopCraftUpgradeScroll, 0.00)
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
    call WUI_FrameSetMinMaxValue(FRAME_ShopCraftComponentScroll, 0.00, 1.00)
    call BlzFrameSetStepSize(FRAME_ShopCraftComponentScroll, 1.00)
    call WUI_FrameSetValue(FRAME_ShopCraftComponentScroll, 0.00)
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
    set ShopAutoBuyTimer = CreateTimer()
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
    call WUI_OnReady(function QB_CreateUI)
endfunction

function InitTrig_WoS_Shop_Init takes nothing returns nothing
    set gg_trg_WoS_Shop_Init = CreateTrigger()
    call TriggerRegisterTimerEvent(gg_trg_WoS_Shop_Init, 6, false)
    call TriggerAddAction( gg_trg_WoS_Shop_Init, function CreateItemUI )
endfunction
