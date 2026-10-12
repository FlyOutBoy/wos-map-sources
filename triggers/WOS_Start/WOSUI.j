library WOSUI initializer WUI_Init

// Normal FRAME root only. Native SIMPLEFRAME commands/items keep their own tree.
globals
    private leaderboard WUI_ServiceBoard = null
    private framehandle WUI_Root = null
    private framehandle WUI_SimpleRoot = null
    private boolean WUI_FrameDefinitionsReady = false
    private boolean WUI_MusicDefinitionsReady = false
    private boolean WUI_ChargeDefinitionsReady = false
    private boolean WUI_TopVisible = true
    private integer WUI_TopCloseCount = 0
    private trigger array WUI_TopClose
    private integer WUI_TopControlCount = 0
    private framehandle array WUI_TopControl
    private framehandle WUI_NativeBack = null
    private framehandle array WUI_EmptyAbility
    private timer WUI_BootTimer = CreateTimer()
    private boolean WUI_Ready = false
    private integer WUI_ReadyCount = 0
    private trigger array WUI_ReadyOwner
    private timer WUI_DockTimer = CreateTimer()
    // Checkpoint 24: the engine re-anchors the stock tooltip box on every show
    // (it then stretched to the right edge); a local fast timer pins it back.
    private timer WUI_TipTimer = CreateTimer()
    private boolean WUI_CoverClosed = false
    private hashtable WUI_DockKeys = InitHashtable()
    private integer WUI_DockCount = 0
    private framehandle array WUI_DockFrame
    private framehandle array WUI_DockLabel
    private integer array WUI_DockOwner
    private integer array WUI_DockKind
    private boolean array WUI_DockPlaced
    private real array WUI_DockX
    private real array WUI_DockY
    private framehandle WUI_TestPanel = null
    private framehandle WUI_TestToggle = null
    private framehandle WUI_TestText = null
    private framehandle WUI_TestPrevious = null
    private framehandle WUI_TestNext = null
    private framehandle WUI_TestPageLabel = null
    private string array WUI_TestPage
    private integer WUI_TestPageIndex = 0
    // Checkpoint 27: wheel scrolls lines inside a page; pages change by buttons.
    private constant integer WUI_TEST_PAGES = 2
    private constant integer WUI_TEST_ROWS = 15
    private constant integer WUI_TEST_CHARS = 34
    private string array WUI_TestLine
    private integer array WUI_TestLineCount
    private integer WUI_TestOffset = 0
    private framehandle WUI_TestSlider = null
    private boolean WUI_TestSliderUpdating = false
    private integer WUI_TestEcho = 0
    private integer WUI_TestSliderMax = -1
    private integer WUI_TestSliderValue = -1
    private boolean WUI_TestOpen = true
    private boolean WUI_TestEnabled = false
    private integer WUI_ModalCount = 0
    private framehandle array WUI_Modal
    private framehandle array WUI_Command
    private framehandle array WUI_Item
    private framehandle array WUI_System
    private framehandle WUI_SystemBar = null
    private framehandle array WUI_HeroButton
    private framehandle array WUI_MinimapButton
    private framehandle WUI_Menu = null
    private framehandle WUI_Orders = null
    // Orders drawer handle (move/stop/hold/attack/patrol). Hidden while false;
    // set to true to bring the tab back. Hotkeys keep working either way.
    boolean WUI_SHOW_ORDERS = false
    // Checkpoint 22: "Restart" button in the top-left corner (same as
    // Menu > End Game > Restart). Shown only when Player 1 plays alone (no
    // other human players). Set to false to hide it completely.
    boolean WUI_SHOW_RESTART = true
    private framehandle WUI_Restart = null
    // Gold/graphite skins drawn over the stock Menu/Allies/Log drawer buttons.
    private framehandle array WUI_MenuSkin
    private framehandle array WUI_MenuSkinFill
    private framehandle array WUI_MenuSkinText
    // Checkpoint 22: Menu/Allies/Log as one dropdown under the top-right panel.
    private framehandle WUI_MenuDrop = null
    private framehandle WUI_MenuDropMetal = null
    private framehandle WUI_MenuActive = null
    constant real WUI_MENU_DROP_TOP = 0.540
    constant real WUI_MENU_ROW_STEP = 0.023
    private boolean WUI_MenuOpen = false
    private boolean WUI_OrdersOpen = false
    private boolean WUI_CompactCommands = false
    private framehandle WUI_Console = null
    private framehandle WUI_Portrait = null
    private framehandle WUI_PortraitIcon = null
    private string WUI_PortraitTexture = ""
    private framehandle WUI_Resource = null
    private framehandle WUI_HeroBar = null
    private framehandle array WUI_HeroIndicator
    private framehandle WUI_HeroIndicatorOwner = null
    private framehandle WUI_DeadZone = null
    private framehandle WUI_HiddenDetails = null
    private framehandle WUI_Buffs = null
    private framehandle WUI_CommandBar = null
    private framehandle WUI_NativeDetail = null
    private framehandle WUI_NativeDetailParent = null
    private framehandle WUI_TopConsole = null
    private framehandle WUI_BottomConsole = null
    private framehandle WUI_NativeTooltip = null
    private timer WUI_NativeTimer = CreateTimer()
    private boolean WUI_NativeReady = false
    private hashtable WUI_Fills = InitHashtable()
    // Checkpoint 24: hero meter STATUSBARs have no model (nothing was drawn);
    // a purple BACKDROP fill follows their value through the hooks below.
    private hashtable WUI_BarInfo = InitHashtable()
    private hashtable WUI_ButtonStyle = InitHashtable()
    // Checkpoint 21: hero overlays (passives, meters, bankai/board docks) step
    // aside while a covering window (the shop) is open, and come back after.
    private framehandle WUI_CoverWatch = null
    private framehandle WUI_HeroLayer = null
    private boolean WUI_HeroLayerLocked = false
    private boolean WUI_DocksCovered = false
    private hashtable WUI_MeterEdges = InitHashtable()
    private boolean WUI_DockPlacing = false
    private integer WUI_DockTick = 0
    private integer array WUI_NativeSlotState
    private integer array WUI_NativeSlotAge
    // Checkpoint 21: in-game hotkey rebinding. A channel is one rebindable
    // action (0 = team ping wheel, 1 = emote wheel). Keys are per player.
    constant integer WUI_HOTKEY_PING = 0
    constant integer WUI_HOTKEY_EMOTE = 1
    // Checkpoint 24: F2 statistics, F3 clear numbers, F4 load numbers.
    constant integer WUI_HOTKEY_STATS = 2
    constant integer WUI_HOTKEY_CLEAR = 3
    constant integer WUI_HOTKEY_LOAD = 4
    // Checkpoint 27: rebindable shop key (badge on the toolbar shop icon).
    constant integer WUI_HOTKEY_SHOP = 5
    private constant integer WUI_HOTKEY_CHANNELS = 6
    private boolean array WUI_HotkeyOnRelease
    private oskeytype array WUI_HotkeyKey
    private string array WUI_HotkeyName
    private trigger array WUI_HotkeyTrigger
    // Checkpoint 27: keys ever bound per channel/player (16 each); a key event
    // can not be unregistered, so stale ones are filtered by a trigger condition.
    private oskeytype array WUI_HotkeyUsed
    private integer array WUI_HotkeyUsedCount
    private boolean array WUI_HotkeyBothEdges
    private framehandle array WUI_HotkeyLabel
    private framehandle array WUI_HotkeyButton
    private trigger WUI_HotkeyClick = null
    private trigger array WUI_CaptureTrigger
    private integer array WUI_CaptureChannel
    private oskeytype array WUI_KeyCode
    private string array WUI_KeyLabel
    private integer WUI_KeyCount = 0
    private trigger WUI_ButtonEvents = null
    private integer WUI_TextButtonCount = 0
    // Checkpoint 22: stock command card hidden (pick/draft), local.
    private boolean WUI_OriginHidden = false
    private boolean array WUI_OriginHiddenOf
    // FRAME copies of the Menu / Allies / Log skins: the SIMPLEFRAME skins are
    // hidden together with the origin frames during the hero pick / draft.
    private framehandle array WUI_MenuSkinF
    // Checkpoint 26b: map preview shown where the minimap is while the pick
    // hides the origin frames (no bare hole in the HUD).
    private framehandle WUI_MinimapStub = null
    private framehandle array WUI_Ghost
    // Measured from screenshots: stock fill insets of the escape menu.
    constant real WUI_ESC_BUTTON_INSET_X = 0.0045
    constant real WUI_ESC_BUTTON_INSET_Y = 0.0040
    constant real WUI_ESC_PANEL_INSET = 0.0100
    // Checkpoint 23: per-slot hotkey editing is switched off for now (it did
    // not behave well); set true to bring the keyboard toggle back.
    constant boolean WUI_ENABLE_HOTKEYS = false
    private integer WUI_TooltipCount = 0
    // Top-right column: Game Info dropdown (under the Menu dropdown) and the
    // Test commands block always sit directly under whatever is open above.
    private boolean WUI_InfoOpen = false
    private framehandle WUI_InfoButton = null
    private framehandle WUI_InfoPanel = null
    private framehandle WUI_InfoTitle = null
    private framehandle WUI_InfoPageLabel = null
    private framehandle WUI_InfoPrev = null
    private framehandle WUI_InfoNext = null
    private framehandle array WUI_InfoIcon
    private framehandle array WUI_InfoText
    private integer WUI_InfoPage = 0
    // Checkpoint 24: 4 rows per page, 5 pages; each row = icon + text that is
    // vertically centred on the icon (they used to drift apart).
    constant integer WUI_INFO_ROWS = 4
    constant integer WUI_INFO_PAGES = 4
    constant real WUI_INFO_HEIGHT = 0.212
    // Pick / ban feed in the top-left corner (newest on top).
    constant integer WUI_FEED_LINES = 6
    private framehandle array WUI_FeedText
    private real array WUI_FeedAge
    // Checkpoint 24: extra collapsible panels of the right column (hero help
    // such as the Kyoraku bankai stages): header toggle + body.
    private framehandle array WUI_ColPanel
    private framehandle array WUI_ColToggle
    private real array WUI_ColHeight
    private boolean array WUI_ColActive
    private boolean array WUI_ColOpen
    private integer WUI_ColCount = 0
    private hashtable WUI_ColKeys = InitHashtable()
    private trigger WUI_ColClick = null
    private string array WUI_FeedMsg
    private framehandle WUI_StatsButton = null
    // Native FPS/Ping/APM line ends beside the time box's left border:
    // Time box left border .365 minus .005 clearance keeps the last digit visible.
    constant real WUI_FPS_X = 0.360
    constant real WUI_FPS_Y = 0.551
    private framehandle array WUI_ResourceText
    private framehandle array WUI_ResourceMouse
    private framehandle WUI_FpsLine = null
    private integer WUI_FpsTries = 0
    // Checkpoint 22: stock ally-colour minimap button, re-skinned and docked.
    constant integer WUI_ALLY_COLOR_BUTTON = 2
    constant real WUI_ALLY_COLOR_X = 0.150
    constant real WUI_ALLY_COLOR_Y = 0.0170
    constant real WUI_ALLY_COLOR_SIZE = 0.018
    private framehandle WUI_AllyColor = null
    // Checkpoint 22: per-slot custom hotkeys (0..6 skills, 7..12 items).
    constant integer WUI_SLOT_KEYS = 13
    constant real WUI_TOGGLE_X = 0.2885
    constant real WUI_TOGGLE_VOICE_Y = 0.0400
    constant real WUI_TOGGLE_HOTKEY_Y = 0.0185
    constant real WUI_TOGGLE_SIZE = 0.018
    private oskeytype array WUI_SlotKey
    private string array WUI_SlotKeyName
    private boolean array WUI_HotkeyEdit
    private integer array WUI_SlotCapture
    private trigger array WUI_SlotCaptureTrigger
    private trigger WUI_SlotKeyTrigger = null
    private trigger WUI_SlotClick = null
    private hashtable WUI_SlotKeyRegistered = InitHashtable()
    private framehandle WUI_HotkeyToggle = null
    private framehandle WUI_HotkeyHint = null
    private framehandle array WUI_SlotOverlay
    private framehandle array WUI_SlotOverlayEdge
    private framehandle array WUI_SlotBadge
    private framehandle array WUI_SlotBadgeText
    private boolean array WUI_SlotShown
    private timer WUI_PulseTimer = CreateTimer()
    private real WUI_PulsePhase = 0.00
    // Checkpoint 20 bottom HUD: one ability row (QWERTFG) with level pips below.
    constant real WUI_HUD_Y = 0.042
    constant real WUI_PIP_Y = 0.0165
    // Checkpoint 25: wider stats column, the HUD grows 0.020 to the right.
    constant real WUI_COMMAND_X = 0.359
    constant real WUI_COMMAND_STEP = 0.040
    constant real WUI_ICON_SIZE = 0.034
    // Checkpoint 22: items as large as the cell allows, "Inventory" above.
    constant real WUI_ITEM_SIZE = 0.033
    constant real WUI_ITEM_X = 0.676
    constant real WUI_ITEM_STEP_X = 0.0345
    constant real WUI_ITEM_Y = 0.0625
    constant real WUI_ITEM_STEP_Y = 0.0350
    // The stock inventory button is a .039 wrapper whose icon is only .031 and
    // sits in its TOP-LEFT corner (screenshots: icon 80% of the cell, shifted
    // up-left). Scale by the icon and shift the wrapper so the icon is centred.
    constant real WUI_NATIVE_ITEM_ICON = 0.031
    constant real WUI_NATIVE_ITEM_SHIFT = 0.004
    // Chassis (native graphite surface) and the minimap block to its left.
    constant real WUI_CHASSIS_LEFT = 0.160
    constant real WUI_CHASSIS_RIGHT = 0.830
    constant real WUI_CHASSIS_TOP = 0.094
    // Stats column modes (button next to the hero voice toggle): everything
    // right of the stats block moves by WUI_HudShift (local). Re-layout runs
    // only when the mode changes, never on a timer.
    constant real WUI_STATS_COLUMN = 0.044
    // Stock buff icons ~15% larger than before, level with the gear buffs.
    constant real WUI_BUFF_SCALE = 1.52
    real WUI_HudShift = 0.00
    // Left block (minimap, portrait, stats) offset: with three stats columns
    // the whole bottom HUD moves left instead of growing to the right.
    real WUI_HudLeft = 0.00
    integer array WUI_ShiftGroup
    framehandle array WUI_RectFrame
    real array WUI_RectL
    real array WUI_RectB
    real array WUI_RectR
    real array WUI_RectT
    integer WUI_RectCount = 0
    integer WUI_HudMode = 2
    // Saved camera distance per player (synced, 0 = none); Starts.j resets the
    // camera to BaseCam at 10 s and re-applies this right after.
    real array WUI_SavedCamera
    // Top-right row under the action icons: Game Info | Hide UI | Save Keys
    // (centres measured from the right screen edge; same total width as before).
    constant real WUI_TOP_ROW_W = 0.0572
    constant real WUI_TOP_ROW_X1 = 0.15065
    constant real WUI_TOP_ROW_X2 = 0.08995
    constant real WUI_TOP_ROW_X3 = 0.02925
    constant real WUI_TOP_ROW_TEXT = 0.66
    // Saved setting mirror (SaveLoad <-> HeroUnitPanelStats): hero voice muted.
    boolean array WUI_VoiceOff
    framehandle array WUI_ShiftFrame
    real array WUI_ShiftBaseX
    real array WUI_ShiftBaseY
    real array WUI_ShiftBaseW
    real array WUI_ShiftBaseH
    integer WUI_ShiftCount = 0
    hashtable WUI_ShiftTable = InitHashtable()
    trigger array WUI_ShiftHook
    integer WUI_ShiftHookCount = 0
    framehandle WUI_HudPanel = null
    constant real WUI_MINIMAP_SIZE = 0.136
    constant real WUI_MINIMAP_RIGHT = 0.160
    constant real WUI_MINIMAP_TOP = 0.144
    constant string WUI_PANEL_TEXTURE = "UI\\WOS\\panel.tga"
    constant string WUI_BORDER_TEXTURE = "UI\\WOS\\border.tga"
    constant string WUI_EMPTY_TEXTURE = "UI\\WOS\\empty.tga"
    constant string WUI_FILL_NORMAL = "UI\\WOS\\fill-normal.tga"
    constant string WUI_FILL_HOVER = "UI\\WOS\\fill-hover.tga"
    constant string WUI_FILL_PRESSED = "UI\\WOS\\fill-pressed.tga"
    constant string WUI_FILL_SELECTED = "UI\\WOS\\fill-selected.tga"
    constant real WUI_ORNAMENT_SCALE = 1.00
    constant string WUI_ICON_FRAME = "UI\\WOS\\icon-frame.tga"
    constant string WUI_ICON_FRAME_BAN = "UI\\WOS\\icon-frame-ban.tga"
    constant string WUI_GOLD = "|cffd5b876"
    constant string WUI_TEXT = "|cffe1e5eb"
endglobals

// Library initializers register owners only. No frame native may run until the
// bootstrap timer fires in game time; every client allocates the same handles.
// One trigger per owner also keeps large UI builds in separate JASS threads.
function WUI_OnReady takes code callback returns nothing
    local trigger owner = CreateTrigger()
    call TriggerAddAction(owner, callback)
    if WUI_Ready then
        call TriggerExecute(owner)
        call DestroyTrigger(owner)
    else
        set WUI_ReadyCount = WUI_ReadyCount + 1
        set WUI_ReadyOwner[WUI_ReadyCount] = owner
    endif
    set owner = null
endfunction

function WUI_GetRoot takes nothing returns framehandle
    return WUI_Root
endfunction

function WUI_GetSimpleRoot takes nothing returns framehandle
    return WUI_SimpleRoot
endfunction

function WUI_HasMusicDefinitions takes nothing returns boolean
    return WUI_MusicDefinitionsReady
endfunction

function WUI_HasChargeDefinitions takes nothing returns boolean
    return WUI_ChargeDefinitionsReady
endfunction

function WUI_HasFrameDefinitions takes nothing returns boolean
    return WUI_FrameDefinitionsReady
endfunction

// Only decorative/background children are registered, never the round-clock root.
function WUI_RegisterTopControl takes framehandle control returns nothing
    set WUI_TopControlCount = WUI_TopControlCount + 1
    set WUI_TopControl[WUI_TopControlCount] = control
endfunction

function WUI_RegisterTopClose takes code callback returns nothing
    set WUI_TopCloseCount = WUI_TopCloseCount + 1
    set WUI_TopClose[WUI_TopCloseCount] = CreateTrigger()
    call TriggerAddAction(WUI_TopClose[WUI_TopCloseCount], callback)
endfunction

function WUI_ShowTopControls takes boolean visible returns nothing
    local integer i = 1
    set WUI_TopVisible = visible
    loop
        exitwhen i > WUI_TopControlCount
        call BlzFrameSetVisible(WUI_TopControl[i], visible)
        set i = i + 1
    endloop
    if not visible then
        set i = 1
        loop
            exitwhen i > WUI_TopCloseCount
            call TriggerExecute(WUI_TopClose[i])
            set i = i + 1
        endloop
        set WUI_MenuOpen = false
        set i = 0
        loop
            exitwhen i >= 4
            if WUI_MenuSkin[i] != null then
                call BlzFrameSetVisible(WUI_MenuSkin[i], false)
            endif
            call BlzFrameSetVisible(WUI_System[i], false)
            set i = i + 1
        endloop
        if WUI_MenuDrop != null then
            call BlzFrameSetVisible(WUI_MenuDrop, false)
            call BlzFrameSetVisible(WUI_MenuDropMetal, false)
            call BlzFrameSetVisible(WUI_MenuActive, false)
        endif
        call BlzFrameSetVisible(WUI_TestPanel, false)
        call BlzFrameSetVisible(WUI_TestToggle, false)
        if WUI_InfoPanel != null then
            call BlzFrameSetVisible(WUI_InfoPanel, false)
        endif
    else
        if WUI_InfoPanel != null then
            call BlzFrameSetVisible(WUI_InfoPanel, WUI_InfoOpen)
        endif
        call BlzFrameSetVisible(WUI_TestToggle, WUI_TestEnabled)
        call BlzFrameSetVisible(WUI_TestPanel, WUI_TestEnabled and WUI_TestOpen)
    endif
    // Right-column hero panels follow Hide UI too.
    set i = 1
    loop
        exitwhen i > WUI_ColCount
        call BlzFrameSetVisible(WUI_ColToggle[i], WUI_ColActive[i] and visible)
        call BlzFrameSetVisible(WUI_ColPanel[i], WUI_ColActive[i] and WUI_ColOpen[i] and visible)
        set i = i + 1
    endloop
endfunction

// Normal FRAME coordinates extend beyond the 4:3 safe area on wide displays.
// These are presentation-only values; frame allocation stays identical on clients.
function WUI_ScreenRight takes nothing returns real
    return 0.400 + 0.300 * I2R(BlzGetLocalClientWidth()) / RMaxBJ(1.00, I2R(BlzGetLocalClientHeight()))
endfunction

// Checkpoint 23: five slots - Menu, Stats (F2), History, Link, Music.
function WUI_TopActionX takes integer index returns real
    return WUI_ScreenRight() - 0.162 + I2R(index) * 0.036
endfunction

function WUI_GetStatsButton takes nothing returns framehandle
    return WUI_StatsButton
endfunction

// BACKDROP containers never track mouse input. This remains true even if custom
// FDF loading fails. Real pixel alpha hides only their image, never their children.
// Vertex alpha on a BACKDROP is ignored by some Warcraft builds.
function WUI_Passive takes string name, framehandle parent returns framehandle
    local framehandle container = BlzCreateFrameByType("BACKDROP", name, parent, "", 0)
    call BlzFrameSetTexture(container, WUI_EMPTY_TEXTURE, 0, true)
    return container
endfunction

// Keep the stock skill-point glow attached to the replacement portrait. The
// engine re-shows these indicators after level-ups even with HeroBar hidden.
function WUI_BindHeroIndicator takes framehandle owner returns nothing
    local integer i = 0
    set WUI_HeroIndicatorOwner = owner
    loop
        exitwhen i >= 7
        set WUI_HeroIndicator[i] = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON_INDICATOR, i)
        if WUI_HeroIndicator[i] != null then
            call BlzFrameSetVisible(WUI_HeroIndicator[i], false)
            call BlzFrameClearAllPoints(WUI_HeroIndicator[i])
            if i == 0 and owner != null then
                call BlzFrameSetParent(WUI_HeroIndicator[i], owner)
                call BlzFrameSetPoint(WUI_HeroIndicator[i], FRAMEPOINT_BOTTOMLEFT, owner, FRAMEPOINT_BOTTOMLEFT, 0.00, 0.00)
                call BlzFrameSetSize(WUI_HeroIndicator[i], 0.039, 0.039)
                // Checkpoint 20 HUD portrait is .050 square.
                call BlzFrameSetScale(WUI_HeroIndicator[i], 0.050 / 0.039)
            else
                call BlzFrameSetAbsPoint(WUI_HeroIndicator[i], FRAMEPOINT_CENTER, -0.20, -0.20)
            endif
        endif
        set i = i + 1
    endloop
endfunction

// Checkpoint 27d: set visibility only when it changes (periodic owners call
// these every tick; redundant BlzFrameSetVisible calls are not free).
function WUI_Show takes framehandle frame, boolean visible returns nothing
    if frame != null and BlzFrameIsVisible(frame) != visible then
        call BlzFrameSetVisible(frame, visible)
    endif
endfunction

function WUI_ShowHeroIndicator takes boolean visible returns nothing
    local integer i = 0
    loop
        exitwhen i >= 7
        if WUI_HeroIndicator[i] != null then
            call WUI_Show(WUI_HeroIndicator[i], visible and i == 0 and WUI_HeroIndicatorOwner != null)
        endif
        set i = i + 1
    endloop
endfunction

function WUI_Place takes framehandle frame, real x, real y, real width, real height returns nothing
    if frame != null then
        call BlzFrameClearAllPoints(frame)
        call BlzFrameSetAbsPoint(frame, FRAMEPOINT_CENTER, x, y)
        call BlzFrameSetSize(frame, width, height)
    endif
endfunction

// Cooldown children are created lazily for the local selection. Do not enumerate
// them here: the first getter would reserve a handle on only that client.
// The cached native button wrapper supplies the item/command scale below.

// Six existing toolbar actions share one grid and one mouse-target size.
// Right HUD block: gold row on top, then a 3x2 grid of equal square targets.
// A frame right of the stats block (group 0) or in the left block (group 1):
// remembered with its unshifted centre and re-placed by WUI_SetHud.
// Pass x without WUI_HudShift / WUI_HudLeft.
function WUI_PlaceShiftGroup takes framehandle frame, real x, real y, real width, real height, integer shiftGroup returns nothing
    local integer i
    if frame == null then
        return
    endif
    // O(1) lookup (a linear search made big owners hit the op limit).
    set i = LoadInteger(WUI_ShiftTable, GetHandleId(frame), 0) - 1
    if i < 0 then
        set i = WUI_ShiftCount
        set WUI_ShiftCount = WUI_ShiftCount + 1
        call SaveInteger(WUI_ShiftTable, GetHandleId(frame), 0, i + 1)
    endif
    set WUI_ShiftFrame[i] = frame
    set WUI_ShiftBaseX[i] = x
    set WUI_ShiftBaseY[i] = y
    set WUI_ShiftBaseW[i] = width
    set WUI_ShiftBaseH[i] = height
    set WUI_ShiftGroup[i] = shiftGroup
    if shiftGroup == 1 then
        call WUI_Place(frame, x + WUI_HudLeft, y, width, height)
    else
        call WUI_Place(frame, x + WUI_HudShift, y, width, height)
    endif
endfunction

function WUI_PlaceShift takes framehandle frame, real x, real y, real width, real height returns nothing
    call WUI_PlaceShiftGroup(frame, x, y, width, height, 0)
endfunction

function WUI_PlaceShiftLeft takes framehandle frame, real x, real y, real width, real height returns nothing
    call WUI_PlaceShiftGroup(frame, x, y, width, height, 1)
endfunction

// Left-block frame given by two absolute corners.
function WUI_RectShiftLeft takes framehandle frame, real left, real bottom, real right, real top returns nothing
    if frame == null then
        return
    endif
    set WUI_RectFrame[WUI_RectCount] = frame
    set WUI_RectL[WUI_RectCount] = left
    set WUI_RectB[WUI_RectCount] = bottom
    set WUI_RectR[WUI_RectCount] = right
    set WUI_RectT[WUI_RectCount] = top
    set WUI_RectCount = WUI_RectCount + 1
    call BlzFrameClearAllPoints(frame)
    call BlzFrameSetAbsPoint(frame, FRAMEPOINT_BOTTOMLEFT, left + WUI_HudLeft, bottom)
    call BlzFrameSetAbsPoint(frame, FRAMEPOINT_TOPRIGHT, right + WUI_HudLeft, top)
endfunction

// Stock buff bar (SIMPLEFRAME): its scale also multiplies the absolute point
// and the size, so both are given divided by the scale.
function WUI_PlaceBuffBar takes nothing returns nothing
    if WUI_Buffs != null then
        call WUI_Place(WUI_Buffs, (0.671 + WUI_HudShift) / WUI_BUFF_SCALE, 0.164 / WUI_BUFF_SCALE, 0.255 / WUI_BUFF_SCALE, 0.024 / WUI_BUFF_SCALE)
    endif
endfunction

// Once, synchronously: pull the stock buff icons closer (half the stock gap).
// Only touches children that look like icons; otherwise the stock layout stays.
function WUI_TightenBuffBar takes nothing returns nothing
    local integer count
    local integer i = 0
    local framehandle child
    local real width
    if WUI_Buffs == null then
        return
    endif
    set count = BlzFrameGetChildrenCount(WUI_Buffs)
    if count < 2 or count > 16 then
        return
    endif
    set child = BlzFrameGetChild(WUI_Buffs, 0)
    set width = BlzFrameGetWidth(child)
    if width < 0.005 or width > 0.05 then
        set child = null
        return
    endif
    loop
        exitwhen i >= count
        set child = BlzFrameGetChild(WUI_Buffs, i)
        call BlzFrameClearAllPoints(child)
        call BlzFrameSetPoint(child, FRAMEPOINT_TOPLEFT, WUI_Buffs, FRAMEPOINT_TOPLEFT, I2R(i) * width * 1.18, 0.00)
        set i = i + 1
    endloop
    set child = null
endfunction

function WUI_OnHudShift takes code callback returns nothing
    set WUI_ShiftHook[WUI_ShiftHookCount] = CreateTrigger()
    call TriggerAddAction(WUI_ShiftHook[WUI_ShiftHookCount], callback)
    set WUI_ShiftHookCount = WUI_ShiftHookCount + 1
endfunction

function WUI_PlaceToolbar takes framehandle control, integer column, integer row returns nothing
    call WUI_PlaceShift(control, 0.750 + I2R(column) * 0.030, 0.050 - I2R(row) * 0.030, 0.025, 0.025)
endfunction

function WUI_ItemX takes integer index returns real
    return WUI_ITEM_X + WUI_HudShift + I2R(ModuloInteger(index, 3) - 1) * WUI_ITEM_STEP_X
endfunction

function WUI_ItemY takes integer index returns real
    return WUI_ITEM_Y - I2R(index / 3) * WUI_ITEM_STEP_Y
endfunction

// Native wrappers contain fixed-size art, cooldowns, hotkeys and mouse buttons.
// Resize the entire wrapper subtree; changing just its width leaves stock art.
function WUI_PlaceNativeButton takes framehandle control, real x, real y, real size returns nothing
    if control != null then
        call BlzFrameSetScale(control, size / 0.039)
        call WUI_Place(control, x, y, 0.039, 0.039)
    endif
endfunction

function WUI_PlaceNativeItem takes framehandle control, real x, real y, real size returns nothing
    local real scale = size / WUI_NATIVE_ITEM_ICON
    if control != null then
        call BlzFrameSetScale(control, scale)
        call WUI_Place(control, x + WUI_NATIVE_ITEM_SHIFT * scale, y - WUI_NATIVE_ITEM_SHIFT * scale, 0.039, 0.039)
    endif
endfunction

function WUI_Panel takes string name, framehandle parent, real width, real height returns framehandle
    local framehandle panel = BlzCreateFrameByType("BACKDROP", name, parent, "", 0)
    call BlzFrameSetSize(panel, width, height)
    call BlzFrameSetTexture(panel, WUI_PANEL_TEXTURE, 0, true)
    return panel
endfunction

// Textured bars belong to the normal FRAME family with their HUD/text parent.
// STATUSBAR is an animated model; it cannot display a fill texture this way.
function WUI_CreateFill takes string name, framehandle parent, real width, real height, real maximum, string texture returns framehandle
    local framehandle fill = BlzCreateFrameByType("BACKDROP", name, parent, "", 0)
    local integer key = GetHandleId(fill)
    call BlzFrameSetTexture(fill, texture, 0, true)
    call BlzFrameSetSize(fill, width, height)
    call BlzFrameSetEnable(fill, false)
    call SaveReal(WUI_Fills, key, 0, maximum)
    call SaveReal(WUI_Fills, key, 1, width)
    call SaveReal(WUI_Fills, key, 2, height)
    call SaveReal(WUI_Fills, key, 3, maximum)
    return fill
endfunction

function WUI_Border takes string name, framehandle owner returns framehandle
    local framehandle edge = BlzCreateFrameByType("BACKDROP", name, owner, "", 0)
    call BlzFrameSetAllPoints(edge, owner)
    // Checkpoint 25: the 1px border texture stretched over big windows became
    // a blurry yellow band; windows keep only their fill + ornate rails.
    call BlzFrameSetTexture(edge, WUI_EMPTY_TEXTURE, 0, true)
    call BlzFrameSetEnable(edge, false)
    return edge
endfunction

private function WUI_Piece takes string name, framehandle parent, string texture returns framehandle
    local framehandle piece = BlzCreateFrameByType("BACKDROP", name, parent, "", 0)
    call BlzFrameSetTexture(piece, texture, 0, true)
    call BlzFrameSetEnable(piece, false)
    return piece
endfunction

// Checkpoint 20 ornament contract: the rail CENTRE lies exactly on the owner's
// edge, so the fill behind it always reaches the metal (no transparent gap and
// no frame that looks smaller than the real control). Rails are created first;
// the ornate corners draw over their joints. Fractions come from the corner art:
// horizontal rail centre .293c (top) / .307c (bottom), vertical .207c (sides),
// rail texture thickness .125c. Corners overhang outward, never the hit area.
// mask bits: 1 top-left, 2 top-right, 4 bottom-left, 8 bottom-right corner.
function WUI_OrnateBorderEx takes string name, framehandle owner, real corner, integer mask returns framehandle
    local framehandle edge = WUI_Passive(name, owner)
    local framehandle piece
    local real c = corner * WUI_ORNAMENT_SCALE
    local real rail = c * 0.125
    call BlzFrameSetAllPoints(edge, owner)
    call BlzFrameSetEnable(edge, false)
    set piece = WUI_Piece(name + "Top", edge, "UI\\WOS\\ornate-top.tga")
    call BlzFrameSetPoint(piece, FRAMEPOINT_LEFT, owner, FRAMEPOINT_TOPLEFT, c * 0.70, 0.00)
    call BlzFrameSetPoint(piece, FRAMEPOINT_RIGHT, owner, FRAMEPOINT_TOPRIGHT, -c * 0.70, 0.00)
    call BlzFrameSetSize(piece, 0.00, rail)
    set piece = WUI_Piece(name + "Bottom", edge, "UI\\WOS\\ornate-bottom.tga")
    call BlzFrameSetPoint(piece, FRAMEPOINT_LEFT, owner, FRAMEPOINT_BOTTOMLEFT, c * 0.70, 0.00)
    call BlzFrameSetPoint(piece, FRAMEPOINT_RIGHT, owner, FRAMEPOINT_BOTTOMRIGHT, -c * 0.70, 0.00)
    call BlzFrameSetSize(piece, 0.00, rail)
    set piece = WUI_Piece(name + "Left", edge, "UI\\WOS\\ornate-left.tga")
    call BlzFrameSetPoint(piece, FRAMEPOINT_TOP, owner, FRAMEPOINT_TOPLEFT, 0.00, -c * 0.66)
    call BlzFrameSetPoint(piece, FRAMEPOINT_BOTTOM, owner, FRAMEPOINT_BOTTOMLEFT, 0.00, c * 0.66)
    call BlzFrameSetSize(piece, rail, 0.00)
    set piece = WUI_Piece(name + "Right", edge, "UI\\WOS\\ornate-right.tga")
    call BlzFrameSetPoint(piece, FRAMEPOINT_TOP, owner, FRAMEPOINT_TOPRIGHT, 0.00, -c * 0.66)
    call BlzFrameSetPoint(piece, FRAMEPOINT_BOTTOM, owner, FRAMEPOINT_BOTTOMRIGHT, 0.00, c * 0.66)
    call BlzFrameSetSize(piece, rail, 0.00)
    if ModuloInteger(mask, 2) == 1 then
        set piece = WUI_Piece(name + "tl", edge, "UI\\WOS\\ornate-tl.tga")
        call BlzFrameSetPoint(piece, FRAMEPOINT_TOPLEFT, owner, FRAMEPOINT_TOPLEFT, -c * 0.207, c * 0.293)
        call BlzFrameSetSize(piece, c, c)
    endif
    if ModuloInteger(mask, 4) >= 2 then
        set piece = WUI_Piece(name + "tr", edge, "UI\\WOS\\ornate-tr.tga")
        call BlzFrameSetPoint(piece, FRAMEPOINT_TOPRIGHT, owner, FRAMEPOINT_TOPRIGHT, c * 0.207, c * 0.293)
        call BlzFrameSetSize(piece, c, c)
    endif
    if ModuloInteger(mask, 8) >= 4 then
        set piece = WUI_Piece(name + "bl", edge, "UI\\WOS\\ornate-bl.tga")
        call BlzFrameSetPoint(piece, FRAMEPOINT_BOTTOMLEFT, owner, FRAMEPOINT_BOTTOMLEFT, -c * 0.207, -c * 0.307)
        call BlzFrameSetSize(piece, c, c)
    endif
    if mask >= 8 then
        set piece = WUI_Piece(name + "br", edge, "UI\\WOS\\ornate-br.tga")
        call BlzFrameSetPoint(piece, FRAMEPOINT_BOTTOMRIGHT, owner, FRAMEPOINT_BOTTOMRIGHT, c * 0.207, -c * 0.307)
        call BlzFrameSetSize(piece, c, c)
    endif
    set piece = null
    return edge
endfunction

function WUI_OrnateBorder takes string name, framehandle owner, real corner returns framehandle
    return WUI_OrnateBorderEx(name, owner, corner, 15)
endfunction

// Kept for existing callers: windows now use the same flush rails.
function WUI_OrnateWindow takes string name, framehandle owner, real corner returns framehandle
    return WUI_OrnateBorder(name, owner, corner)
endfunction

// Edge for buttons, slots and small boxes (see checkpoint 27 note inside).
function WUI_GoldFrame takes string name, framehandle owner, real thickness, real gem returns framehandle
    // Checkpoint 27: every former bevel + corner-gem frame is the quiet edge of
    // the top-right block: soft fading gold divider lines, no gems. The size
    // arguments are kept for the existing callers.
    local framehandle edge = WUI_Passive(name, owner)
    local framehandle piece
    call BlzFrameSetAllPoints(edge, owner)
    call BlzFrameSetEnable(edge, false)
    set piece = WUI_Piece(name + "T", edge, "UI\\WOS\\divider-h.tga")
    call BlzFrameSetPoint(piece, FRAMEPOINT_LEFT, owner, FRAMEPOINT_TOPLEFT, 0.00, 0.00)
    call BlzFrameSetPoint(piece, FRAMEPOINT_RIGHT, owner, FRAMEPOINT_TOPRIGHT, 0.00, 0.00)
    call BlzFrameSetSize(piece, 0.00, 0.003)
    call BlzFrameSetAlpha(piece, 170)
    set piece = WUI_Piece(name + "B", edge, "UI\\WOS\\divider-h.tga")
    call BlzFrameSetPoint(piece, FRAMEPOINT_LEFT, owner, FRAMEPOINT_BOTTOMLEFT, 0.00, 0.00)
    call BlzFrameSetPoint(piece, FRAMEPOINT_RIGHT, owner, FRAMEPOINT_BOTTOMRIGHT, 0.00, 0.00)
    call BlzFrameSetSize(piece, 0.00, 0.003)
    call BlzFrameSetAlpha(piece, 170)
    set piece = WUI_Piece(name + "L", edge, "UI\\WOS\\divider-v.tga")
    call BlzFrameSetPoint(piece, FRAMEPOINT_TOP, owner, FRAMEPOINT_TOPLEFT, 0.00, 0.00)
    call BlzFrameSetPoint(piece, FRAMEPOINT_BOTTOM, owner, FRAMEPOINT_BOTTOMLEFT, 0.00, 0.00)
    call BlzFrameSetSize(piece, 0.003, 0.00)
    call BlzFrameSetAlpha(piece, 170)
    set piece = WUI_Piece(name + "R", edge, "UI\\WOS\\divider-v.tga")
    call BlzFrameSetPoint(piece, FRAMEPOINT_TOP, owner, FRAMEPOINT_TOPRIGHT, 0.00, 0.00)
    call BlzFrameSetPoint(piece, FRAMEPOINT_BOTTOM, owner, FRAMEPOINT_BOTTOMRIGHT, 0.00, 0.00)
    call BlzFrameSetSize(piece, 0.003, 0.00)
    call BlzFrameSetAlpha(piece, 170)
    set piece = null
    return edge
endfunction

// Checkpoint 22: gold bevel frame over a square icon (replaces the stock BTN
// bevel that showed through). Band is 8.6% of the size, so it hides the BTN
// edge while the icon art stays fully visible. Passive: never takes the mouse.
function WUI_IconFrame takes framehandle owner, string texture returns framehandle
    local framehandle edge = BlzCreateFrameByType("BACKDROP", "WOSIconFrame", owner, "", 0)
    call BlzFrameSetAllPoints(edge, owner)
    call BlzFrameSetTexture(edge, texture, 0, true)
    call BlzFrameSetEnable(edge, false)
    return edge
endfunction

// Passive vertical/horizontal gold separators between HUD sections.
function WUI_Divider takes string name, framehandle parent, real x, real y, real length, boolean vertical returns framehandle
    local framehandle line
    if vertical then
        set line = WUI_Piece(name, parent, "UI\\WOS\\divider-v.tga")
        call WUI_Place(line, x, y, 0.004, length)
    else
        set line = WUI_Piece(name, parent, "UI\\WOS\\divider-h.tga")
        call WUI_Place(line, x, y, length, 0.004)
    endif
    return line
endfunction

function WUI_Window takes string name, framehandle parent, integer layer, integer context returns framehandle
    local framehandle panel = BlzCreateFrameByType("BACKDROP", name, parent, "", context)
    local framehandle edge = WUI_Border(name + "Edge", panel)
    call BlzFrameSetTexture(panel, WUI_PANEL_TEXTURE, 0, true)
    call BlzFrameSetLevel(panel, layer)
    set edge = null
    return panel
endfunction

private function WUI_UpdateBarFill takes integer key, real value returns nothing
    local real low = LoadReal(WUI_BarInfo, key, 1)
    local real high = LoadReal(WUI_BarInfo, key, 0)
    local real part = 0.00
    if high > low then
        set part = RMaxBJ(0.00, RMinBJ(1.00, (value - low) / (high - low)))
    endif
    call SaveReal(WUI_BarInfo, key, 4, value)
    if HaveSavedHandle(WUI_BarInfo, key, 2) then
        call BlzFrameSetSize(LoadFrameHandle(WUI_BarInfo, key, 2), RMaxBJ(0.0002, LoadReal(WUI_BarInfo, key, 3) * part), 0.0060)
    endif
endfunction

private function WUI_OnSetMinMax takes framehandle frame, real minValue, real maxValue returns nothing
    local integer key = GetHandleId(frame)
    call SaveReal(WUI_BarInfo, key, 0, maxValue)
    call SaveReal(WUI_BarInfo, key, 1, minValue)
    if HaveSavedHandle(WUI_BarInfo, key, 2) then
        call WUI_UpdateBarFill(key, LoadReal(WUI_BarInfo, key, 4))
    endif
endfunction

private function WUI_OnSetBarValue takes framehandle frame, real value returns nothing
    local integer key = GetHandleId(frame)
    if HaveSavedReal(WUI_BarInfo, key, 0) then
        call WUI_UpdateBarFill(key, value)
    endif
endfunction

hook BlzFrameSetMinMaxValue WUI_OnSetMinMax
hook BlzFrameSetValue WUI_OnSetBarValue

// Existing hero owners keep their state, values and visibility. Only presentation
// is shared. This helper allocates no handles and can be reused when showing a bar.
function WUI_Pin takes framehandle child, framehandle owner, real x, real y, real width, real height returns nothing
    call BlzFrameClearAllPoints(child)
    call BlzFrameSetPoint(child, FRAMEPOINT_CENTER, owner, FRAMEPOINT_CENTER, x, y)
    call BlzFrameSetSize(child, width, height)
endfunction

function WUI_HeroMeter takes framehandle panel, framehandle back, framehandle bar, framehandle icon, framehandle title, framehandle value returns nothing
    local framehandle edge = null
    call BlzFrameSetSize(panel, 0.140, 0.025)
    // Closed gold frame on all four sides (the old border lost its top edge).
    // Created once per panel; owners call this synchronously at creation.
    if not HaveSavedBoolean(WUI_MeterEdges, GetHandleId(panel), 0) then
        call SaveBoolean(WUI_MeterEdges, GetHandleId(panel), 0, true)
        set edge = WUI_GoldFrame("WOSHeroMeterEdge", panel, 0.0032, 0.0070)
        set edge = null
    endif
    call BlzFrameSetTexture(back, "UI\\WOS\\bar-back.tga", 0, true)
    call WUI_Pin(back, panel, 0.012, -0.004, 0.104, 0.007)
    call BlzFrameSetScale(bar, 1.00)
    // Checkpoint 24: purple fill (meter.tga is a thin rail and looked empty).
    call BlzFrameSetTexture(bar, "UI\\WOS\\meter-fill.tga", 0, true)
    call BlzFrameSetLevel(back, 1)
    call BlzFrameSetLevel(bar, 2)
    call BlzFrameSetLevel(title, 3)
    call BlzFrameSetLevel(value, 3)
    if HaveSavedReal(WUI_Fills, GetHandleId(bar), 0) then
        call BlzFrameClearAllPoints(bar)
        call BlzFrameSetPoint(bar, FRAMEPOINT_LEFT, panel, FRAMEPOINT_CENTER, -0.040, -0.004)
    else
        call WUI_Pin(bar, panel, 0.012, -0.004, 0.104, 0.007)
        if not HaveSavedHandle(WUI_BarInfo, GetHandleId(bar), 2) then
            set edge = BlzCreateFrameByType("BACKDROP", "WOSMeterFill", panel, "", 0)
            call BlzFrameSetTexture(edge, "UI\\WOS\\meter-fill.tga", 0, true)
            call BlzFrameSetPoint(edge, FRAMEPOINT_LEFT, panel, FRAMEPOINT_CENTER, -0.040, -0.004)
            call BlzFrameSetEnable(edge, false)
            call BlzFrameSetLevel(edge, 2)
            call SaveFrameHandle(WUI_BarInfo, GetHandleId(bar), 2, edge)
            call SaveReal(WUI_BarInfo, GetHandleId(bar), 3, 0.104)
            if not HaveSavedReal(WUI_BarInfo, GetHandleId(bar), 0) then
                call SaveReal(WUI_BarInfo, GetHandleId(bar), 0, 1.00)
                call SaveReal(WUI_BarInfo, GetHandleId(bar), 1, 0.00)
            endif
            call WUI_UpdateBarFill(GetHandleId(bar), BlzFrameGetValue(bar))
            set edge = null
        endif
    endif
    call WUI_Pin(icon, panel, -0.055, 0.000, 0.019, 0.019)
    call BlzFrameSetScale(title, 0.70)
    call WUI_Pin(title, panel, 0.012, 0.006, 0.112, 0.011)
    call BlzFrameSetTextAlignment(title, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(value, 0.66)
    // Checkpoint 25: offsets of a scaled frame are scaled too - divide, so the
    // time sits on the bar instead of floating above it.
    call WUI_Pin(value, panel, 0.012 / 0.66, -0.0040 / 0.66, 0.104 / 0.66, 0.009 / 0.66)
    call BlzFrameSetTextAlignment(value, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    // Checkpoint 26b: remember the parts so a meter whose owner later
    // re-anchors pieces with absolute points can be pinned back (docks move).
    call SaveFrameHandle(WUI_MeterEdges, GetHandleId(panel), 1, back)
    call SaveFrameHandle(WUI_MeterEdges, GetHandleId(panel), 2, bar)
    call SaveFrameHandle(WUI_MeterEdges, GetHandleId(panel), 3, icon)
    call SaveFrameHandle(WUI_MeterEdges, GetHandleId(panel), 4, title)
    call SaveFrameHandle(WUI_MeterEdges, GetHandleId(panel), 5, value)
    call SaveFrameHandle(WUI_MeterEdges, GetHandleId(panel), 10, panel)
    call SaveFrameHandle(WUI_MeterEdges, GetHandleId(back), 10, panel)
    call SaveFrameHandle(WUI_MeterEdges, GetHandleId(bar), 10, panel)
    call SaveFrameHandle(WUI_MeterEdges, GetHandleId(icon), 10, panel)
    call SaveFrameHandle(WUI_MeterEdges, GetHandleId(title), 10, panel)
    call SaveFrameHandle(WUI_MeterEdges, GetHandleId(value), 10, panel)
endfunction

// Checkpoint 27c: no BlzFrameSetAbsPoint hook any more (JassHelper turns a hook
// into a TriggerEvaluate on every call - 140 call sites, many per tick, caused
// stutter). WUI_RefreshDocks re-pins registered meters once per second instead.
// Checkpoint 27d: points only (no textures / sizes / fills like WUI_HeroMeter).
private function WUI_RepinMeter takes framehandle panel returns boolean
    local integer id = GetHandleId(panel)
    local framehandle bar
    local framehandle value
    if not HaveSavedHandle(WUI_MeterEdges, id, 1) then
        return false
    endif
    call WUI_Pin(LoadFrameHandle(WUI_MeterEdges, id, 1), panel, 0.012, -0.004, 0.104, 0.007)
    set bar = LoadFrameHandle(WUI_MeterEdges, id, 2)
    if HaveSavedReal(WUI_Fills, GetHandleId(bar), 0) then
        call BlzFrameClearAllPoints(bar)
        call BlzFrameSetPoint(bar, FRAMEPOINT_LEFT, panel, FRAMEPOINT_CENTER, -0.040, -0.004)
    else
        call WUI_Pin(bar, panel, 0.012, -0.004, 0.104, 0.007)
    endif
    call WUI_Pin(LoadFrameHandle(WUI_MeterEdges, id, 3), panel, -0.055, 0.000, 0.019, 0.019)
    call WUI_Pin(LoadFrameHandle(WUI_MeterEdges, id, 4), panel, 0.012, 0.006, 0.112, 0.011)
    set value = LoadFrameHandle(WUI_MeterEdges, id, 5)
    call WUI_Pin(value, panel, 0.012 / 0.66, -0.0040 / 0.66, 0.104 / 0.66, 0.009 / 0.66)
    set bar = null
    set value = null
    return true
endfunction

// Registration is synchronous. Per-client visibility, coordinates and movement
// belong only to presentation; they never feed casting, charges or game timers.
function WUI_RegisterDock takes framehandle panel, framehandle label, integer owner, integer kind, string key returns nothing
    local integer index = LoadInteger(WUI_DockKeys, StringHash(key), 0)
    if panel == null then
        return
    endif
    if index == 0 then
        set WUI_DockCount = WUI_DockCount + 1
        set index = WUI_DockCount
        call SaveInteger(WUI_DockKeys, StringHash(key), 0, index)
    elseif WUI_DockFrame[index] != null and WUI_DockFrame[index] != panel then
        call BlzFrameSetVisible(WUI_DockFrame[index], false)
        if WUI_DockLabel[index] != null then
            call BlzFrameSetVisible(WUI_DockLabel[index], false)
        endif
    endif
    set WUI_DockFrame[index] = panel
    set WUI_DockLabel[index] = label
    set WUI_DockOwner[index] = owner
    set WUI_DockKind[index] = kind
    set WUI_DockPlaced[index] = false
endfunction

function WUI_RegisterMeter takes framehandle panel, integer owner, string key returns nothing
    call WUI_RegisterDock(panel, null, owner, 0, key)
endfunction

// Reusable six-part meter. Obtain/start/update only from synchronized gameplay.
// Dock positioning and owner visibility are presentation; frames are never
// allocated by the local docking poll or a hover callback.
struct WUI_TrackedMeter
    private static hashtable cache = InitHashtable()
    framehandle panel
    private framehandle back
    private framehandle bar
    private framehandle icon
    private framehandle title
    private framehandle value
    private integer owner

    static method get takes integer pid, string key returns thistype
        local thistype this = LoadInteger(cache, pid, StringHash(key))
        if this == 0 then
            set this = thistype.allocate()
            set owner = pid
            set panel = WUI_Window("WOSHeroMeter", WUI_GetRoot(), 0, 0)
            call BlzFrameSetVisible(panel, false)
            set back = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", panel, "", 0)
            set bar = BlzCreateFrameByType("STATUSBAR", "WOSMeterProgress", panel, "", 0)
            set icon = BlzCreateFrameByType("BACKDROP", "WOSMeterIcon", panel, "", 0)
            set title = BlzCreateFrameByType("TEXT", "WOSMeterTitle", panel, "", 0)
            set value = BlzCreateFrameByType("TEXT", "WOSMeterValue", panel, "", 0)
            call WUI_HeroMeter(panel, back, bar, icon, title, value)
            call WUI_RegisterMeter(panel, pid, key)
            call SaveInteger(cache, pid, StringHash(key), this)
        endif
        return this
    endmethod

    method start takes integer abilityId, string label, real maximum returns nothing
        call BlzFrameSetTexture(icon, BlzGetAbilityIcon(abilityId), 0, true)
        call BlzFrameSetText(title, WUI_GOLD + label + "|r")
        call BlzFrameSetMinMaxValue(bar, 0.0, maximum)
        call BlzFrameSetValue(bar, maximum)
        if GetLocalPlayer() == Player(owner) then
            call BlzFrameSetVisible(panel, true)
        endif
    endmethod

    method update takes real remaining, string label, boolean shown returns nothing
        call BlzFrameSetValue(bar, RMaxBJ(0.0, remaining))
        call BlzFrameSetText(title, WUI_GOLD + label + "|r")
        call BlzFrameSetText(value, WUI_TEXT + R2SW(RMaxBJ(0.0, remaining), 0, 1) + "|r")
        if GetLocalPlayer() == Player(owner) then
            call BlzFrameSetVisible(panel, shown)
        endif
    endmethod

    method close takes nothing returns nothing
        call BlzFrameSetVisible(panel, false)
    endmethod
endstruct

function WUI_RegisterPublicMeter takes framehandle panel, string key returns nothing
    call WUI_RegisterDock(panel, null, -1, 2, key)
endfunction

function WUI_RegisterBuff takes framehandle panel, framehandle label, integer owner, string key returns nothing
    call WUI_RegisterDock(panel, label, owner, 1, key)
endfunction

// Checkpoint 26: a replaced/repicked hero leaves no passive meters above the
// minimap. Presentation only; hero state and timers are untouched.
function WUI_ReleaseHeroMeters takes integer owner returns nothing
    local integer index = 1
    loop
        exitwhen index > WUI_DockCount
        if WUI_DockKind[index] == 0 and WUI_DockOwner[index] == owner and WUI_DockFrame[index] != null then
            call BlzFrameSetVisible(WUI_DockFrame[index], false)
            set WUI_DockPlaced[index] = false
        endif
        set index = index + 1
    endloop
endfunction

function WUI_SimpleBorder takes framehandle owner returns nothing
    local framehandle edge = BlzCreateFrameByType("SIMPLESTATUSBAR", "WOSBuffBorder", owner, "", 0)
    call BlzFrameSetAllPoints(edge, owner)
    call BlzFrameSetTexture(edge, WUI_BORDER_TEXTURE, 0, true)
    call BlzFrameSetMinMaxValue(edge, 0.00, 100.00)
    call BlzFrameSetValue(edge, 100.00)
    call BlzFrameSetEnable(edge, false)
    set edge = null
endfunction

function WUI_RegisterModal takes framehandle panel returns nothing
    set WUI_ModalCount = WUI_ModalCount + 1
    set WUI_Modal[WUI_ModalCount] = panel
endfunction

// The shop window (or any covering window) whose visibility hides hero overlays.
function WUI_RegisterCover takes framehandle watched returns nothing
    set WUI_CoverWatch = watched
endfunction

// Parent of legacy hero frames (Starts.j main_frame).
function WUI_RegisterHeroLayer takes framehandle layer returns nothing
    set WUI_HeroLayer = layer
endfunction

// Final scoreboard: the hero layer stays hidden for good.
function WUI_LockHeroLayer takes nothing returns nothing
    set WUI_HeroLayerLocked = true
    if WUI_HeroLayer != null then
        call BlzFrameSetVisible(WUI_HeroLayer, false)
    endif
endfunction

// Local. Moves a slider and returns how many SLIDER_VALUE_CHANGED events this
// produced. Every programmatic change comes back later as a synced event (an
// "echo"); owners count them and drop that many events, otherwise several
// echoes in flight keep bouncing the value back and forth forever (FPS fell
// to zero the longer you scrolled).
function WUI_SliderSet takes framehandle slider, real low, real high, real value returns integer
    local integer echoes = 0
    local real before = BlzFrameGetValue(slider)
    call BlzFrameSetMinMaxValue(slider, low, high)
    if R2I(BlzFrameGetValue(slider) + 0.50) != R2I(before + 0.50) then
        set echoes = 1
        set before = BlzFrameGetValue(slider)
    endif
    if R2I(before + 0.50) != R2I(value + 0.50) then
        call BlzFrameSetValue(slider, value)
        set echoes = echoes + 1
    endif
    return echoes
endfunction

function WUI_SetText takes framehandle frame, string value returns nothing
    if BlzFrameGetText(frame) != value then
        call BlzFrameSetText(frame, value)
    endif
endfunction

// Call only while creating frames synchronously, before local visibility changes.
// Checkpoint 23: tooltip box with a drawn edge (WOSControls.fdf
// WOSTooltipBox); plain panel + border only without the definitions.
function WUI_TooltipBox takes framehandle parent, real width, real height returns framehandle
    local framehandle box = null
    if WUI_FrameDefinitionsReady then
        set WUI_TooltipCount = WUI_TooltipCount + 1
        set box = BlzCreateFrame("WOSTooltipBox", parent, 0, 6000 + WUI_TooltipCount)
    endif
    if box == null then
        set box = WUI_Panel("WOSToolbarTooltip", parent, width, height)
        call WUI_Border("WOSToolbarTooltipBorder", box)
    endif
    call BlzFrameSetSize(box, width, height)
    call BlzFrameSetEnable(box, false)
    // Checkpoint 28: a tooltip box never takes the mouse (it used to cover the
    // inventory row and keep the Autobuy tooltip open over the items).
    call BlzFrameSetEnable(box, false)
    return box
endfunction

function WUI_Tooltip takes framehandle owner, string label returns nothing
    local framehandle box = WUI_TooltipBox(WUI_Root, 0.170, 0.038)
    local framehandle text = BlzCreateFrameByType("TEXT", "WOSToolbarTooltipText", box, "", 0)
    local framehandle edge = null
    call BlzFrameSetPoint(box, FRAMEPOINT_BOTTOMRIGHT, owner, FRAMEPOINT_TOPRIGHT, 0.00, 0.010)
    call BlzFrameSetPoint(text, FRAMEPOINT_CENTER, box, FRAMEPOINT_CENTER, 0.00, 0.00)
    call BlzFrameSetSize(text, 0.158 / 0.66, 0.030 / 0.66)
    call BlzFrameSetScale(text, 0.66)
    call BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetText(text, WUI_TEXT + label + "|r")
    call BlzFrameSetEnable(text, false)
    call BlzFrameSetLevel(box, 60)
    call BlzFrameSetTooltip(owner, box)
    call BlzFrameSetVisible(box, false)
    set box = null
    set text = null
    set edge = null
endfunction

function WUI_TooltipBelowEx takes framehandle owner, string label, boolean leftward returns nothing
    local framehandle box = WUI_TooltipBox(WUI_Root, 0.170, 0.038)
    local framehandle text = BlzCreateFrameByType("TEXT", "WOSToolbarTooltipText", box, "", 0)
    if leftward then
        // Checkpoint 26: top-right controls open their tooltip down-left so
        // it never runs past the right screen edge.
        call BlzFrameSetPoint(box, FRAMEPOINT_TOPRIGHT, owner, FRAMEPOINT_BOTTOMRIGHT, -0.030, -0.010)
    else
        call BlzFrameSetPoint(box, FRAMEPOINT_TOPLEFT, owner, FRAMEPOINT_BOTTOMLEFT, 0.00, -0.010)
    endif
    call BlzFrameSetPoint(text, FRAMEPOINT_CENTER, box, FRAMEPOINT_CENTER, 0.00, 0.00)
    call BlzFrameSetSize(text, 0.158 / 0.66, 0.030 / 0.66)
    call BlzFrameSetScale(text, 0.66)
    call BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetText(text, WUI_TEXT + label + "|r")
    call BlzFrameSetEnable(text, false)
    call BlzFrameSetLevel(box, 60)
    call BlzFrameSetTooltip(owner, box)
    call BlzFrameSetVisible(box, false)
    set box = null
    set text = null
endfunction

function WUI_TooltipBelow takes framehandle owner, string label returns nothing
    call WUI_TooltipBelowEx(owner, label, false)
endfunction

function WUI_TooltipBelowLeft takes framehandle owner, string label returns nothing
    call WUI_TooltipBelowEx(owner, label, true)
endfunction

// ===== Checkpoint 21: rebindable hotkeys =====
private function WUI_InitKeyTable takes nothing returns nothing
    local integer keyCode = 65
    local string letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    if WUI_KeyCount > 0 then
        return
    endif
    // Letters except the ability row (Q W E R T F G) and digits 0-9.
    loop
        exitwhen keyCode > 90
        if keyCode != 81 and keyCode != 87 and keyCode != 69 and keyCode != 82 and keyCode != 84 and keyCode != 70 and keyCode != 71 then
            set WUI_KeyCount = WUI_KeyCount + 1
            set WUI_KeyCode[WUI_KeyCount] = ConvertOsKeyType(keyCode)
            set WUI_KeyLabel[WUI_KeyCount] = SubString(letters, keyCode - 65, keyCode - 64)
        endif
        set keyCode = keyCode + 1
    endloop
    set keyCode = 48
    loop
        exitwhen keyCode > 57
        set WUI_KeyCount = WUI_KeyCount + 1
        set WUI_KeyCode[WUI_KeyCount] = ConvertOsKeyType(keyCode)
        set WUI_KeyLabel[WUI_KeyCount] = I2S(keyCode - 48)
        set keyCode = keyCode + 1
    endloop
    // Checkpoint 27b: Tab can be chosen again (the shop default).
    set WUI_KeyCount = WUI_KeyCount + 1
    set WUI_KeyCode[WUI_KeyCount] = OSKEY_TAB
    set WUI_KeyLabel[WUI_KeyCount] = "TAB"
    // F1..F9 (F10-F12 stay with the game menu).
    set keyCode = 112
    loop
        exitwhen keyCode > 120
        set WUI_KeyCount = WUI_KeyCount + 1
        set WUI_KeyCode[WUI_KeyCount] = ConvertOsKeyType(keyCode)
        set WUI_KeyLabel[WUI_KeyCount] = "F" + I2S(keyCode - 111)
        set keyCode = keyCode + 1
    endloop
endfunction

function WUI_GetHotkey takes integer channel, integer pid returns oskeytype
    return WUI_HotkeyKey[channel * 16 + pid]
endfunction

function WUI_GetHotkeyName takes integer channel, integer pid returns string
    return WUI_HotkeyName[channel * 16 + pid]
endfunction

// Checkpoint 27b: the key cap grows with the key name (K / F2 / TAB).
private function WUI_SizeHotkeyBadge takes integer channel, string name returns nothing
    if WUI_HotkeyButton[channel] == null then
        return
    endif
    if StringLength(name) >= 3 then
        call BlzFrameSetSize(WUI_HotkeyButton[channel], 0.0190, 0.0115)
    elseif StringLength(name) == 2 then
        call BlzFrameSetSize(WUI_HotkeyButton[channel], 0.0145, 0.0110)
    else
        call BlzFrameSetSize(WUI_HotkeyButton[channel], 0.0115, 0.0115)
    endif
endfunction

private function WUI_KeyWasBound takes integer channel, integer pid, oskeytype key returns boolean
    local integer slot = channel * 16 + pid
    local integer i = 0
    loop
        exitwhen i >= WUI_HotkeyUsedCount[slot]
        if WUI_HotkeyUsed[slot * 16 + i] == key then
            return true
        endif
        set i = i + 1
    endloop
    return false
endfunction

// Checkpoint 27: a key that was this channel's hotkey before a rebind no longer
// fires it. Keys the owner registered itself and frame events pass untouched.
private function WUI_HotkeyFilter takes nothing returns boolean
    local oskeytype key = BlzGetTriggerPlayerKey()
    local integer pid
    local integer channel = 0
    local boolean stale = false
    if key == null or GetTriggerPlayer() == null then
        return true
    endif
    set pid = GetPlayerId(GetTriggerPlayer())
    loop
        exitwhen channel >= WUI_HOTKEY_CHANNELS
        if WUI_HotkeyTrigger[channel] == GetTriggeringTrigger() then
            if key == WUI_HotkeyKey[channel * 16 + pid] then
                return true
            endif
            if WUI_KeyWasBound(channel, pid, key) then
                set stale = true
            endif
        endif
        set channel = channel + 1
    endloop
    return not stale
endfunction

private function WUI_RegisterKeyFor takes integer channel, player p, oskeytype key returns nothing
    local integer meta = 0
    local integer slot = channel * 16 + GetPlayerId(p)
    if WUI_KeyWasBound(channel, GetPlayerId(p), key) then
        // Already registered once: the filter lets it through again.
        return
    endif
    if WUI_HotkeyUsedCount[slot] < 16 then
        set WUI_HotkeyUsed[slot * 16 + WUI_HotkeyUsedCount[slot]] = key
        set WUI_HotkeyUsedCount[slot] = WUI_HotkeyUsedCount[slot] + 1
    endif
    loop
        exitwhen meta > 15
        if WUI_HotkeyOnRelease[channel] then
            // Toggles: one event per press (no auto-repeat while held).
            call BlzTriggerRegisterPlayerKeyEvent(WUI_HotkeyTrigger[channel], p, key, meta, false)
        else
            call BlzTriggerRegisterPlayerKeyEvent(WUI_HotkeyTrigger[channel], p, key, meta, true)
            if WUI_HotkeyBothEdges[channel] then
                call BlzTriggerRegisterPlayerKeyEvent(WUI_HotkeyTrigger[channel], p, key, meta, false)
            endif
        endif
        set meta = meta + 1
    endloop
endfunction

// Synced: a key was pressed while this player was choosing a new hotkey.
private function WUI_OnCapture takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local integer channel = WUI_CaptureChannel[pid]
    local oskeytype key = BlzGetTriggerPlayerKey()
    local integer i = 1
    local string name = ""
    call DisableTrigger(GetTriggeringTrigger())
    set WUI_CaptureChannel[pid] = -1
    if channel >= 0 and key != OSKEY_ESCAPE then
        loop
            exitwhen i > WUI_KeyCount
            if WUI_KeyCode[i] == key then
                set name = WUI_KeyLabel[i]
            endif
            set i = i + 1
        endloop
        if name != "" then
            set WUI_HotkeyKey[channel * 16 + pid] = key
            set WUI_HotkeyName[channel * 16 + pid] = name
            // The new key starts firing the owner's trigger for this player;
            // old keys are dropped by WUI_HotkeyFilter (checkpoint 27).
            call WUI_RegisterKeyFor(channel, p, key)
            call DisplayTimedTextToPlayer(p, 0, 0, 3.00, WUI_GOLD + "Hotkey changed to " + name + "|r")
        endif
    endif
    if channel >= 0 and GetLocalPlayer() == p then
        call BlzFrameSetText(WUI_HotkeyLabel[channel], WUI_GOLD + WUI_HotkeyName[channel * 16 + pid] + "|r")
        call WUI_SizeHotkeyBadge(channel, WUI_HotkeyName[channel * 16 + pid])
    endif
    set p = null
    set key = null
endfunction

// Synced click on a hotkey badge: the next letter/digit becomes the hotkey.
private function WUI_OnHotkeyBadge takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local integer channel = 0
    local integer i = 1
    loop
        exitwhen channel >= WUI_HOTKEY_CHANNELS
        if BlzGetTriggerFrame() == WUI_HotkeyButton[channel] then
            exitwhen true
        endif
        set channel = channel + 1
    endloop
    if channel < WUI_HOTKEY_CHANNELS and pid < 16 then
        if WUI_CaptureTrigger[pid] != null then
            call DisableTrigger(WUI_CaptureTrigger[pid])
        endif
        set WUI_CaptureTrigger[pid] = CreateTrigger()
        set WUI_CaptureChannel[pid] = channel
        loop
            exitwhen i > WUI_KeyCount
            call BlzTriggerRegisterPlayerKeyEvent(WUI_CaptureTrigger[pid], p, WUI_KeyCode[i], 0, true)
            set i = i + 1
        endloop
        call BlzTriggerRegisterPlayerKeyEvent(WUI_CaptureTrigger[pid], p, OSKEY_ESCAPE, 0, true)
        call TriggerAddAction(WUI_CaptureTrigger[pid], function WUI_OnCapture)
        if GetLocalPlayer() == p then
            call BlzFrameSetText(WUI_HotkeyLabel[channel], "|cff7ee870?|r")
        endif
        call DisplayTimedTextToPlayer(p, 0, 0, 4.00, WUI_GOLD + "Press a new hotkey (letter, digit or F1-F9). Esc keeps the current one.|r")
    endif
    if GetLocalPlayer() == p then
        call BlzFrameSetEnable(BlzGetTriggerFrame(), false)
        call BlzFrameSetEnable(BlzGetTriggerFrame(), true)
    endif
    set p = null
endfunction

// Owner side (synchronous, once): its key trigger, default key, whether key
// release also fires, and the control whose corner shows the key badge.
// Ex: the badge is a child of `parent` (it hides with it) and `onRelease`
// fires once per press on key-up (toggle windows / actions).
function WUI_RegisterHotkeyEx takes integer channel, trigger keyTrigger, oskeytype defaultKey, string defaultName, boolean bothEdges, framehandle owner, framehandle parent, boolean onRelease returns nothing
    local integer pid = 0
    local framehandle part
    call WUI_InitKeyTable()
    // One filter condition per owner trigger (CLEAR and LOAD share one).
    set pid = 0
    loop
        exitwhen pid >= WUI_HOTKEY_CHANNELS
        exitwhen WUI_HotkeyTrigger[pid] == keyTrigger
        set pid = pid + 1
    endloop
    if pid >= WUI_HOTKEY_CHANNELS and keyTrigger != null then
        call TriggerAddCondition(keyTrigger, Condition(function WUI_HotkeyFilter))
    endif
    set pid = 0
    set WUI_HotkeyTrigger[channel] = keyTrigger
    set WUI_HotkeyBothEdges[channel] = bothEdges
    set WUI_HotkeyOnRelease[channel] = onRelease
    loop
        exitwhen pid >= 16
        set WUI_HotkeyKey[channel * 16 + pid] = defaultKey
        set WUI_HotkeyName[channel * 16 + pid] = defaultName
        set WUI_CaptureChannel[pid] = -1
        call WUI_RegisterKeyFor(channel, Player(pid), defaultKey)
        set pid = pid + 1
    endloop
    if WUI_HotkeyClick == null then
        set WUI_HotkeyClick = CreateTrigger()
        call TriggerAddAction(WUI_HotkeyClick, function WUI_OnHotkeyBadge)
    endif
    // Small key-cap badge over the owner's bottom-right corner.
    set WUI_HotkeyButton[channel] = BlzCreateFrameByType("BUTTON", "WOSHotkeyBadge", parent, "", channel)
    if channel == WUI_HOTKEY_STATS then
        // Off the Stats icon: a click on the icon must open F2, not rebind.
        call BlzFrameSetPoint(WUI_HotkeyButton[channel], FRAMEPOINT_LEFT, owner, FRAMEPOINT_RIGHT, -0.0040, -0.0070)
    else
        if channel == WUI_HOTKEY_SHOP then
            // "TAB" is wide: lower and further right, clear of the cart.
            call BlzFrameSetPoint(WUI_HotkeyButton[channel], FRAMEPOINT_BOTTOMRIGHT, owner, FRAMEPOINT_BOTTOMRIGHT, 0.0075, -0.0045)
        else
            call BlzFrameSetPoint(WUI_HotkeyButton[channel], FRAMEPOINT_BOTTOMRIGHT, owner, FRAMEPOINT_BOTTOMRIGHT, 0.0030, -0.0020)
        endif
    endif
    call WUI_SizeHotkeyBadge(channel, defaultName)
    call BlzFrameSetLevel(WUI_HotkeyButton[channel], 30)
    set part = BlzCreateFrameByType("BACKDROP", "WOSHotkeyBadgeBack", WUI_HotkeyButton[channel], "", channel)
    call BlzFrameSetAllPoints(part, WUI_HotkeyButton[channel])
    call BlzFrameSetTexture(part, "UI\\WOS\\keycap.tga", 0, true)
    call BlzFrameSetEnable(part, false)
    set WUI_HotkeyLabel[channel] = BlzCreateFrameByType("TEXT", "WOSHotkeyBadgeText", WUI_HotkeyButton[channel], "", channel)
    call BlzFrameSetAllPoints(WUI_HotkeyLabel[channel], WUI_HotkeyButton[channel])
    call BlzFrameSetTextAlignment(WUI_HotkeyLabel[channel], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(WUI_HotkeyLabel[channel], 0.62)
    call BlzFrameSetText(WUI_HotkeyLabel[channel], WUI_GOLD + defaultName + "|r")
    call BlzFrameSetEnable(WUI_HotkeyLabel[channel], false)
    call BlzTriggerRegisterFrameEvent(WUI_HotkeyClick, WUI_HotkeyButton[channel], FRAMEEVENT_CONTROL_CLICK)
    // Controls at the very top of the screen open their tooltip downwards.
    if channel == WUI_HOTKEY_STATS then
        call WUI_TooltipBelowLeft(WUI_HotkeyButton[channel], "|cffd5b876HOTKEY|r|nClick, then press a letter, digit or F1-F9 to rebind.")
    else
        call WUI_Tooltip(WUI_HotkeyButton[channel], "|cffd5b876HOTKEY|r|nClick, then press a letter, digit or F1-F9 to rebind.")
    endif
    set part = null
endfunction

function WUI_RegisterHotkey takes integer channel, trigger keyTrigger, oskeytype defaultKey, string defaultName, boolean bothEdges, framehandle owner returns nothing
    call WUI_RegisterHotkeyEx(channel, keyTrigger, defaultKey, defaultName, bothEdges, owner, WUI_Root, false)
endfunction

// Menu / Allies / Log skins mirror the stock buttons' enabled state.
private function WUI_RefreshMenuSkins takes nothing returns nothing
    local integer i = 0
    local boolean enabled
    local framehandle fill
    local framehandle text
    if not WUI_MenuOpen then
        return
    endif
    loop
        exitwhen i >= 3
        if WUI_MenuSkin[i] != null and WUI_System[i] != null then
            // A later BlzHideOriginFrames(true) (pick start) hides them again.
            if not BlzFrameIsVisible(WUI_System[i]) then
                call BlzFrameSetVisible(WUI_System[i], true)
            endif
            set enabled = BlzFrameGetEnable(WUI_System[i])
            set fill = WUI_MenuSkinFill[i]
            set text = WUI_MenuSkinText[i]
            if enabled then
                // Checkpoint 25b: local mouse test (no network events) gives
                // the rows the blue hover of the stock game menu.
                if RAbsBJ(BlzPixelToFrameX(BlzGetMouseScreenPosX()) - (WUI_ScreenRight() - 0.090)) <= 0.075 and RAbsBJ(BlzPixelToFrameY(BlzGetMouseScreenPosY()) - (WUI_MENU_DROP_TOP - 0.0115 - I2R(i) * WUI_MENU_ROW_STEP)) <= 0.00925 then
                    call BlzFrameSetTexture(fill, "UI\\WOS\\fill-hover-blue.tga", 0, true)
                else
                    call BlzFrameSetTexture(fill, WUI_FILL_NORMAL, 0, true)
                endif
                if i == 0 then
                    call WUI_SetText(text, WUI_TEXT + "Menu  |cffd5b876[F10]|r")
                elseif i == 1 then
                    call WUI_SetText(text, WUI_TEXT + "Allies  |cffd5b876[F11]|r")
                else
                    call WUI_SetText(text, WUI_TEXT + "Log  |cffd5b876[F12]|r")
                endif
            else
                call BlzFrameSetTexture(fill, "UI\\WOS\\fill-disabled.tga", 0, true)
                if i == 0 then
                    call WUI_SetText(text, "|cff6a6e76Menu  [F10]|r")
                elseif i == 1 then
                    call WUI_SetText(text, "|cff6a6e76Allies  [F11]|r")
                else
                    call WUI_SetText(text, "|cff6a6e76Log  [F12]|r")
                endif
            endif
        endif
        set i = i + 1
    endloop
    set fill = null
    set text = null
endfunction

function WUI_MenuRowY takes integer row returns real
    return WUI_MENU_DROP_TOP - 0.0115 - I2R(row) * WUI_MENU_ROW_STEP
endfunction

function WUI_MenuDropBottom takes nothing returns real
    if WUI_MenuOpen then
        return WUI_MenuRowY(2) - 0.0145
    endif
    return WUI_MENU_DROP_TOP
endfunction

// Local: Game Info dropdown, then Test commands, each flush under the block
// above it (Menu dropdown when open, else the top-right panel).
// Local: the right column under the top-right block (Menu dropdown when open):
// TEST COMMANDS, Game Info, then hero panels. Whatever does not fit above the
// HUD goes into a second column on its left (Game Info always does when the
// test commands are open, so the two stand side by side).
function WUI_LayoutRightColumn takes nothing returns nothing
    local real top = WUI_MenuDropBottom()
    local real x = WUI_ScreenRight() - 0.090
    local real leftX = WUI_ScreenRight() - 0.274
    local real y = top
    local real leftY = top
    local real need
    local real px
    local real py
    local integer i = 1
    local boolean testShown = WUI_TestToggle != null and BlzFrameIsVisible(WUI_TestToggle)
    local boolean testOpen = testShown and WUI_TestOpen
    // Checkpoint 25: header + body of TEST COMMANDS = exactly the Game Info
    // height, so the two blocks line up when they stand side by side.
    if WUI_TestToggle != null then
        call WUI_Place(WUI_TestToggle, x, y - 0.009, 0.180, 0.018)
        call WUI_Place(WUI_TestPanel, x, y - 0.018 - (WUI_INFO_HEIGHT - 0.018) * 0.5, 0.180, WUI_INFO_HEIGHT - 0.018)
        call WUI_Place(WUI_TestText, x - 0.005, y - 0.018 - (WUI_INFO_HEIGHT - 0.018) * 0.5 + 0.009, 0.156, WUI_INFO_HEIGHT - 0.055)
        if WUI_TestSlider != null then
            call WUI_Place(WUI_TestSlider, x + 0.081, y - 0.018 - (WUI_INFO_HEIGHT - 0.018) * 0.5 + 0.009, 0.008, WUI_INFO_HEIGHT - 0.065)
        endif
        call WUI_Place(WUI_TestPageLabel, x, y - WUI_INFO_HEIGHT + 0.0115, 0.140 / 0.64, 0.012 / 0.64)
        call WUI_Place(WUI_TestPrevious, x - 0.080, y - WUI_INFO_HEIGHT + 0.0115, 0.014, 0.014)
        call WUI_Place(WUI_TestNext, x + 0.080, y - WUI_INFO_HEIGHT + 0.0115, 0.014, 0.014)
        if testShown then
            set y = y - 0.018
            if testOpen then
                set y = y - (WUI_INFO_HEIGHT - 0.018)
            endif
        endif
    endif
    if WUI_InfoPanel != null then
        // Side by side only while the Menu dropdown is open (no room below
        // it); otherwise Game Info stacks under the test commands.
        if testOpen and WUI_MenuOpen then
            call WUI_Place(WUI_InfoPanel, leftX, leftY - WUI_INFO_HEIGHT * 0.5, 0.180, WUI_INFO_HEIGHT)
            if WUI_InfoOpen then
                set leftY = leftY - WUI_INFO_HEIGHT
            endif
        else
            call WUI_Place(WUI_InfoPanel, x, y - WUI_INFO_HEIGHT * 0.5, 0.180, WUI_INFO_HEIGHT)
            if WUI_InfoOpen then
                set y = y - WUI_INFO_HEIGHT
            endif
        endif
        call BlzFrameSetVisible(WUI_InfoPanel, WUI_InfoOpen and WUI_TopVisible)
    endif
    loop
        exitwhen i > WUI_ColCount
        if WUI_ColActive[i] then
            set need = 0.018
            if WUI_ColOpen[i] then
                set need = need + WUI_ColHeight[i]
            endif
            if y - need >= 0.165 then
                set px = x
                set py = y
                set y = y - need
            else
                set px = leftX
                set py = leftY
                set leftY = leftY - need
            endif
            call WUI_Place(WUI_ColToggle[i], px, py - 0.009, 0.180, 0.018)
            call WUI_Place(WUI_ColPanel[i], px, py - 0.018 - WUI_ColHeight[i] * 0.5, 0.180, WUI_ColHeight[i])
        endif
        set i = i + 1
    endloop
endfunction

private function WUI_ColumnApply takes integer i returns nothing
    call BlzFrameSetVisible(WUI_ColToggle[i], WUI_ColActive[i] and WUI_TopVisible)
    call BlzFrameSetVisible(WUI_ColPanel[i], WUI_ColActive[i] and WUI_ColOpen[i] and WUI_TopVisible)
endfunction

// Local: the owner says whether its panel is wanted right now (replaces its
// own BlzFrameSetVisible on the panel); the header toggle collapses it.
function WUI_ColumnShow takes framehandle panel, boolean show returns nothing
    local integer i = LoadInteger(WUI_ColKeys, GetHandleId(panel), 0)
    if i == 0 then
        call BlzFrameSetVisible(panel, show)
        return
    endif
    set WUI_ColActive[i] = show
    call WUI_ColumnApply(i)
    call WUI_LayoutRightColumn()
endfunction

private function WUI_OnColumnToggle takes nothing returns nothing
    local integer i = LoadInteger(WUI_ColKeys, GetHandleId(BlzGetTriggerFrame()), 1)
    if GetLocalPlayer() == GetTriggerPlayer() and i > 0 then
        set WUI_ColOpen[i] = not WUI_ColOpen[i]
        call WUI_ColumnApply(i)
        call WUI_LayoutRightColumn()
        call BlzFrameSetEnable(BlzGetTriggerFrame(), false)
        call BlzFrameSetEnable(BlzGetTriggerFrame(), true)
    endif
endfunction


private function WUI_RefreshHelpVisibility takes nothing returns nothing
    local integer i = 1
    local boolean visible = WUI_TopVisible and WUI_TestEnabled
    loop
        exitwhen i > WUI_ModalCount
        if WUI_Modal[i] != null and BlzFrameIsVisible(WUI_Modal[i]) then
            set visible = false
        endif
        set i = i + 1
    endloop
    if BlzFrameIsVisible(WUI_TestToggle) != visible or BlzFrameIsVisible(WUI_TestPanel) != (visible and WUI_TestOpen) then
        call BlzFrameSetVisible(WUI_TestToggle, visible)
        call BlzFrameSetVisible(WUI_TestPanel, visible and WUI_TestOpen)
        call WUI_LayoutRightColumn()
    endif
endfunction

function WUI_RefreshDocks takes nothing returns nothing
    local integer playerId = GetPlayerId(GetLocalPlayer())
    local integer index = 1
    local integer meterSlot = 0
    local integer buffSlot = 0
    local integer publicSlot = 0
    local integer column
    local integer row
    local real x
    local real y
    local real buffY = 0.144
    local boolean covered = WUI_CoverWatch != null and BlzFrameIsVisible(WUI_CoverWatch)
    local integer publicTotal = 0
    local integer heroButton = 0
    call WUI_RefreshHelpVisibility()
    set WUI_DockPlacing = true
    // Checkpoint 24: shared control re-shows stock hero buttons (a stray green
    // HP pip appeared under the team strip); keep the whole hero bar hidden.
    if WUI_HeroBar != null and BlzFrameIsVisible(WUI_HeroBar) then
        call BlzFrameSetVisible(WUI_HeroBar, false)
    endif
    loop
        exitwhen heroButton >= 7
        if WUI_HeroButton[heroButton] != null and BlzFrameIsVisible(WUI_HeroButton[heroButton]) then
            call BlzFrameSetVisible(WUI_HeroButton[heroButton], false)
        endif
        set heroButton = heroButton + 1
    endloop
    call WUI_RefreshMenuSkins()
    if WUI_OrdersOpen then
        set buffY = 0.181
    endif
    if covered != WUI_DocksCovered then
        set WUI_DocksCovered = covered
        if WUI_HeroLayer != null and not WUI_HeroLayerLocked then
            call BlzFrameSetVisible(WUI_HeroLayer, not covered)
        endif
    endif
    // Checkpoint 24: public meters (Kyoraku bankai, Kenjaku prison realm...)
    // hang right under the Train kills tab: one centred, two side by side
    // with their edges meeting under its middle.
    loop
        exitwhen index > WUI_DockCount
        if WUI_DockKind[index] == 2 and WUI_DockFrame[index] != null and BlzFrameIsVisible(WUI_DockFrame[index]) then
            set publicTotal = publicTotal + 1
        endif
        set index = index + 1
    endloop
    set index = 1
    loop
        exitwhen index > WUI_DockCount
        if WUI_DockOwner[index] == playerId or WUI_DockOwner[index] == -1 then
            if covered and WUI_DockFrame[index] != null and BlzFrameIsVisible(WUI_DockFrame[index]) then
                // Park off-screen; the owner's own visibility state is untouched.
                if WUI_DockPlaced[index] then
                    call BlzFrameClearAllPoints(WUI_DockFrame[index])
                    call BlzFrameSetAbsPoint(WUI_DockFrame[index], FRAMEPOINT_CENTER, -0.50, -0.50)
                    if WUI_DockLabel[index] != null then
                        call WUI_Place(WUI_DockLabel[index], -0.50, -0.50, 0.025, 0.010)
                    endif
                    set WUI_DockPlaced[index] = false
                endif
            elseif BlzFrameIsVisible(WUI_DockFrame[index]) then
                if WUI_DockKind[index] == 0 then
                    set x = 0.075 + WUI_HudLeft
                    set y = 0.162 + I2R(meterSlot) * 0.030
                    set meterSlot = meterSlot + 1
                elseif WUI_DockKind[index] == 1 then
                    // Timed buffs match the enlarged stock icons. Seven fit
                    // above the portrait; additional buffs wrap one row up.
                    set column = ModuloInteger(buffSlot, 7)
                    set row = (buffSlot - column) / 7
                    set x = 0.179 + WUI_HudLeft + I2R(column) * 0.0280
                    set y = 0.114 + I2R(row) * 0.0280
                    set buffSlot = buffSlot + 1
                    if not WUI_DockPlaced[index] then
                        call BlzFrameSetSize(WUI_DockFrame[index], 0.0264, 0.0264)
                    endif
                else
                    set column = ModuloInteger(publicSlot, 2)
                    set row = (publicSlot - column) / 2
                    if publicTotal - row * 2 == 1 then
                        set x = 0.400
                    else
                        set x = 0.330 + I2R(column) * 0.140
                    endif
                    set y = 0.5145 - I2R(row) * 0.027
                    set publicSlot = publicSlot + 1
                endif
                if not WUI_DockPlaced[index] then
                    set WUI_DockX[index] = x
                    set WUI_DockY[index] = y
                else
                    set x = WUI_DockX[index] + (x - WUI_DockX[index]) * 0.60
                    set y = WUI_DockY[index] + (y - WUI_DockY[index]) * 0.60
                endif
                if RAbsBJ(x - WUI_DockX[index]) > 0.0001 or RAbsBJ(y - WUI_DockY[index]) > 0.0001 or not WUI_DockPlaced[index] then
                    // Checkpoint 27e: pieces are re-pinned only when the panel
                    // appears or moves (no periodic re-layout).
                    if WUI_DockKind[index] == 0 and not WUI_DockPlaced[index] then
                        call WUI_RepinMeter(WUI_DockFrame[index])
                    endif
                    call BlzFrameClearAllPoints(WUI_DockFrame[index])
                    call BlzFrameSetAbsPoint(WUI_DockFrame[index], FRAMEPOINT_CENTER, x, y)
                    set WUI_DockX[index] = x
                    set WUI_DockY[index] = y
                    if WUI_DockLabel[index] != null then
                        call WUI_Place(WUI_DockLabel[index], x, y - 0.0045, 0.025, 0.010)
                        call BlzFrameSetScale(WUI_DockLabel[index], 0.66)
                    endif
                endif
                set WUI_DockPlaced[index] = true
            else
                set WUI_DockPlaced[index] = false
            endif
        endif
        set index = index + 1
    endloop
    set WUI_DockPlacing = false
endfunction


function WUI_SetButtonText takes framehandle control, string value returns nothing
    call WUI_SetText(LoadFrameHandle(WUI_ButtonStyle, GetHandleId(control), 1), value)
endfunction

function WUI_SetButtonCaption takes framehandle control, string caption returns nothing
    call BlzFrameSetText(LoadFrameHandle(WUI_ButtonStyle, GetHandleId(control), 1), WUI_TEXT + caption + "|r")
endfunction

function WUI_SetButtonTextScale takes framehandle control, real scale returns nothing
    call BlzFrameSetScale(LoadFrameHandle(WUI_ButtonStyle, GetHandleId(control), 1), scale)
endfunction

function WUI_SetValue takes framehandle frame, real value returns nothing
    local integer key = GetHandleId(frame)
    local real maximum
    if HaveSavedReal(WUI_Fills, key, 0) then
        set maximum = LoadReal(WUI_Fills, key, 0)
        set value = RMaxBJ(0.00, RMinBJ(maximum, value))
        if LoadReal(WUI_Fills, key, 3) != value then
            call BlzFrameSetSize(frame, LoadReal(WUI_Fills, key, 1) * value / RMaxBJ(0.01, maximum), LoadReal(WUI_Fills, key, 2))
            call SaveReal(WUI_Fills, key, 3, value)
        endif
    elseif BlzFrameGetValue(frame) != value then
        call BlzFrameSetValue(frame, value)
    endif
endfunction

// For new heroes: one synchronous add, then update/show from the existing owner.
// Legacy meters attach to the same dock without replacing their frame references.
struct WOSHeroMeter
    framehandle panel
    framehandle back
    framehandle bar
    framehandle icon
    framehandle title
    framehandle value
    integer owner

    static method add takes integer playerId, string key, string iconPath, string caption, real maximum returns thistype
        local thistype this = thistype.allocate()
        set owner = playerId
        set panel = WUI_Window("WOSHeroMeter", WUI_GetRoot(), 0, 0)
        set back = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", panel, "", 0)
        set bar = WUI_CreateFill("WOSMeterFill", panel, 0.104, 0.007, maximum, "UI\\WOS\\meter.tga")
        set icon = BlzCreateFrameByType("BACKDROP", "WOSMeterIcon", panel, "", 0)
        set title = BlzCreateFrameByType("TEXT", "WOSMeterTitle", panel, "", 0)
        set value = BlzCreateFrameByType("TEXT", "WOSMeterValue", panel, "", 0)
        call BlzFrameSetTexture(icon, iconPath, 0, true)
        call BlzFrameSetText(title, WUI_GOLD + caption + "|r")
        call WUI_HeroMeter(panel, back, bar, icon, title, value)
        call BlzFrameSetVisible(panel, false)
        call WUI_RegisterMeter(panel, owner, key)
        return this
    endmethod

    method update takes real amount, string caption returns nothing
        call WUI_SetValue(bar, amount)
        call WUI_SetText(value, WUI_TEXT + caption + "|r")
    endmethod

    method show takes boolean visible returns nothing
        if GetPlayerId(GetLocalPlayer()) == owner then
            call BlzFrameSetVisible(panel, visible)
        endif
        call WUI_RefreshDocks()
    endmethod

    method onDestroy takes nothing returns nothing
        local integer index = 1
        loop
            exitwhen index > WUI_DockCount
            if WUI_DockFrame[index] == panel then
                set WUI_DockFrame[index] = null
                set WUI_DockLabel[index] = null
                set WUI_DockOwner[index] = -2
            endif
            set index = index + 1
        endloop
        call FlushChildHashtable(WUI_Fills, GetHandleId(bar))
        call BlzDestroyFrame(panel)
        set panel = null
        set back = null
        set bar = null
        set icon = null
        set title = null
        set value = null
    endmethod
endstruct

// The engine keeps the selected unit's animated portrait up to date.
// ORIGIN_FRAME_PORTRAIT is reserved during the synchronous controls bootstrap.
function WUI_BindNativePortrait takes framehandle parent returns framehandle
    // The native 3D portrait does not render inside the custom chassis; the
    // cell shows the selected unit's command icon (BTN) instead.
    if WUI_PortraitIcon == null then
        set WUI_PortraitIcon = BlzCreateFrameByType("BACKDROP", "WOSPortraitIcon", parent, "", 0)
        call BlzFrameSetAllPoints(WUI_PortraitIcon, parent)
        call BlzFrameSetEnable(WUI_PortraitIcon, false)
        call BlzFrameSetVisible(WUI_PortraitIcon, false)
    endif
    if WUI_Portrait != null then
        call BlzFrameSetParent(WUI_Portrait, parent)
        call WUI_Place(WUI_Portrait, 0.1945, 0.0550, 0.050, 0.050)
        call BlzFrameSetEnable(WUI_Portrait, false)
    endif
    return WUI_Portrait
endfunction

function WUI_ShowNativePortrait takes boolean visible returns nothing
    call WUI_Show(WUI_Portrait, false)
    call WUI_Show(WUI_PortraitIcon, visible)
endfunction

// Local; the texture is touched only when the selected unit type changes.
function WUI_SetPortraitIcon takes string texture returns nothing
    if WUI_PortraitIcon != null and texture != null and texture != "" and texture != WUI_PortraitTexture then
        set WUI_PortraitTexture = texture
        call BlzFrameSetTexture(WUI_PortraitIcon, texture, 0, true)
    endif
endfunction

function WUI_ShowNativeBuffs takes boolean visible returns nothing
    call WUI_Show(WUI_Buffs, visible)
endfunction


function WUI_StyleButton takes framehandle control returns nothing
    // These five children are backdrops/highlight, never the native text string.
    if control == null then
        return
    endif
    if BlzFrameGetChildrenCount(control) < 5 then
        return
    endif
    call BlzFrameSetTexture(BlzFrameGetChild(control, 0), "UI\\WOS\\button.tga", 0, true)
    call BlzFrameSetTexture(BlzFrameGetChild(control, 1), "UI\\WOS\\pressed.tga", 0, true)
    call BlzFrameSetTexture(BlzFrameGetChild(control, 2), "UI\\WOS\\disabled.tga", 0, true)
    call BlzFrameSetTexture(BlzFrameGetChild(control, 3), "UI\\WOS\\disabled.tga", 0, true)
    call BlzFrameSetAlpha(BlzFrameGetChild(control, 4), 110)
endfunction

function WUI_HideNativeDeadZone takes nothing returns nothing
    if WUI_DeadZone != null then
        call BlzFrameSetVisible(WUI_DeadZone, false)
    endif
endfunction

function WUI_CommandSlot takes integer slot returns integer
    if slot < 4 then
        return slot + 8
    elseif slot == 4 then
        return 7
    endif
    return slot
endfunction

// All seven hero abilities share one row; F/G continue to the right of QWERT.
function WUI_AbilityY takes integer slot returns real
    return WUI_HUD_Y
endfunction

function WUI_AbilityX takes integer slot returns real
    return WUI_COMMAND_X + WUI_HudShift + I2R(slot) * WUI_COMMAND_STEP
endfunction

function WUI_LayoutCommands takes boolean compact returns nothing
    local integer i = 0
    local integer slot
    local real y
    // Checkpoint 27d: native buttons are re-placed here; forget the cache.
    set WUI_NativeSlotState[0] = 0
    set WUI_NativeSlotState[1] = 0
    set WUI_NativeSlotState[2] = 0
    set WUI_NativeSlotState[3] = 0
    set WUI_NativeSlotState[4] = 0
    set WUI_NativeSlotState[5] = 0
    set WUI_NativeSlotState[6] = 0
    set WUI_CompactCommands = compact
    loop
        exitwhen i >= 7
        if WUI_EmptyAbility[i] != null then
            call BlzFrameSetVisible(WUI_EmptyAbility[i], compact)
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 12
        if compact and i < 5 and not WUI_OrdersOpen then
            call WUI_PlaceNativeButton(WUI_Command[i], -0.20, -0.20, WUI_ICON_SIZE)
        elseif compact and i < 5 then
            // Orders drawer: a single row directly above the chassis tab.
            call WUI_PlaceNativeButton(WUI_Command[i], WUI_AbilityX(i), 0.137, WUI_ICON_SIZE)
        elseif not compact then
            // Ordinary units, shop and learn cards retain access to all 12 slots.
            set y = 0.015
            if i < 6 then
                set y = 0.047
            endif
            // Both rows remain below MP; alternative cards cannot cover vitals.
            call WUI_PlaceNativeButton(WUI_Command[i], WUI_AbilityX(ModuloInteger(i, 6)), y, 0.030)
        endif
        set i = i + 1
    endloop
    if compact then
        set slot = 0
        loop
            exitwhen slot >= 7
            call WUI_PlaceNativeButton(WUI_Command[WUI_CommandSlot(slot)], WUI_AbilityX(slot), WUI_AbilityY(slot), WUI_ICON_SIZE)
            set slot = slot + 1
        endloop
    endif
endfunction



// Local: open/close the dropdown (stock buttons, skins, surface, rails and
// the "active" look of the Menu icon move together).
// Synced call; only the given player's client changes its frames.
function WUI_ShowNativeMenu takes player p returns nothing
    if WUI_SystemBar != null and GetLocalPlayer() == p then
        call BlzFrameSetVisible(WUI_SystemBar, true)
    endif
    if WUI_System[0] != null and GetLocalPlayer() == p then
        call BlzFrameSetVisible(WUI_System[0], true)
    endif
endfunction

private function WUI_SetMenuDrop takes boolean open returns nothing
    local integer i = 0
    set WUI_MenuOpen = open
    if open and WUI_SystemBar != null then
        call BlzFrameSetVisible(WUI_SystemBar, true)
    endif
    loop
        exitwhen i >= 3
        if open then
            call WUI_Place(WUI_System[i], WUI_ScreenRight() - 0.090, WUI_MenuRowY(i), 0.150, 0.0185)
            // Hero pick / draft hide the origin frames (stock menu buttons
            // included); the dropdown must still work there (leave the lobby).
            call BlzFrameSetVisible(WUI_System[i], true)
        else
            call WUI_Place(WUI_System[i], -0.20, -0.20, 0.110, 0.021)
        endif
        if WUI_MenuSkin[i] != null then
            call BlzFrameSetVisible(WUI_MenuSkin[i], open)
        endif
        if WUI_MenuSkinF[i] != null then
            call BlzFrameSetVisible(WUI_MenuSkinF[i], open and WUI_OriginHidden)
        endif
        set i = i + 1
    endloop
    if WUI_MenuDrop != null then
        call BlzFrameSetVisible(WUI_MenuDrop, open)
    endif
    if WUI_MenuDropMetal != null then
        call BlzFrameSetVisible(WUI_MenuDropMetal, open)
    endif
    if WUI_MenuActive != null then
        call BlzFrameSetVisible(WUI_MenuActive, open)
    endif
    call WUI_LayoutRightColumn()
endfunction

private function WUI_ControlClick takes nothing returns nothing
    local integer i = 0
    if GetLocalPlayer() == GetTriggerPlayer() then
        if BlzGetTriggerFrame() == WUI_Menu then
            call WUI_SetMenuDrop(not WUI_MenuOpen)
        else
            set WUI_OrdersOpen = not WUI_OrdersOpen
            call WUI_LayoutCommands(WUI_CompactCommands)
        endif
        call BlzFrameSetEnable(BlzGetTriggerFrame(), false)
        call BlzFrameSetEnable(BlzGetTriggerFrame(), true)
    endif
endfunction

private function WUI_CacheNativeSlots takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i >= 12
        set WUI_Command[i] = BlzGetFrameByName("CommandButton_" + I2S(i), 0)
        if WUI_Command[i] == null then
            set WUI_Command[i] = BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, i)
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 6
        set WUI_Item[i] = BlzGetFrameByName("InventoryButton_" + I2S(i), 0)
        if WUI_Item[i] == null then
            set WUI_Item[i] = BlzGetOriginFrame(ORIGIN_FRAME_ITEM_BUTTON, i)
        endif
        set i = i + 1
    endloop
endfunction

// Local, presentation only: compact column above the ability row.
private function WUI_PinNativeTooltip takes nothing returns nothing
    if WUI_NativeTooltip == null or not BlzFrameIsVisible(WUI_NativeTooltip) then
        return
    endif
    call BlzFrameClearAllPoints(WUI_NativeTooltip)
    call BlzFrameSetAbsPoint(WUI_NativeTooltip, FRAMEPOINT_BOTTOMLEFT, 0.296, 0.150)
    call BlzFrameSetAbsPoint(WUI_NativeTooltip, FRAMEPOINT_BOTTOMRIGHT, 0.598, 0.150)
endfunction

private function WUI_ParkNamed takes string name returns nothing
    local framehandle f = BlzGetFrameByName(name, 0)
    // (unused since checkpoint 25c - never touch SimpleFontStrings)
    set f = null
endfunction

// ResourceBarFrame children 0..3 are the gold/lumber/upkeep/food mouse
// listeners (Tasyen's Access Frames by Child table), not its SimpleFontStrings
// or textures. Cache only these four during the synced, deferred bootstrap.
// Never walk the remaining children: the engine-owned FPS line must survive.
private function WUI_CacheResourceMouse takes nothing returns nothing
    local integer i = 0
    local integer count = 0
    if WUI_Resource != null then
        set count = BlzFrameGetChildrenCount(WUI_Resource)
    endif
    loop
        exitwhen i >= 4
        set WUI_ResourceMouse[i] = null
        if i < count then
            set WUI_ResourceMouse[i] = BlzFrameGetChild(WUI_Resource, i)
        endif
        set i = i + 1
    endloop
endfunction

// Keep the bar visible for /fps /ping /apm and preserve its measured offset.
// Transparent resource icons still have active hover listeners; disabling
// their SIMPLEFRAME parent does not remove those listeners. Hide the cached
// mouse frames only, including after the engine restores origin frames.
// Never hide/alpha/re-anchor resource SimpleFontStrings or unknown children:
// those operations were combined in the loading-crash regression (25b/25c).
function WUI_ParkResourceBar takes nothing returns nothing
    local integer i = 0
    if WUI_Resource == null then
        return
    endif
    call BlzFrameSetVisible(WUI_Resource, true)
    call BlzFrameClearAllPoints(WUI_Resource)
    call BlzFrameSetAbsPoint(WUI_Resource, FRAMEPOINT_TOPRIGHT, WUI_FPS_X + 0.44, WUI_FPS_Y + 0.03)
    loop
        exitwhen i >= 4
        if WUI_ResourceMouse[i] != null then
            call BlzFrameSetVisible(WUI_ResourceMouse[i], false)
        endif
        set i = i + 1
    endloop
endfunction

// Local: the engine writes the numbers only when a value changes; clear them
// again (SimpleFontString: text only, never visibility or alpha).
function WUI_BlankResourceTexts takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i >= 4
        if WUI_ResourceText[i] != null and BlzFrameGetText(WUI_ResourceText[i]) != "" then
            call BlzFrameSetText(WUI_ResourceText[i], "")
        endif
        set i = i + 1
    endloop
endfunction

function WUI_InstallNativeLayout takes nothing returns nothing
    local integer i = 0
    local framehandle detail = BlzGetFrameByName("SimpleInfoPanelUnitDetail", 0)
    local framehandle cover = BlzGetFrameByName("SimpleInventoryCover", 0)
    local framehandle minimap = BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP, 0)
    local framehandle label = BlzGetFrameByName("InventoryText", 0)
    local framehandle systemBar = BlzGetFrameByName("UpperButtonBarFrame", 0)
    if WUI_NativeReady or WUI_SimpleRoot == null then
        set detail = null
        set cover = null
        set minimap = null
        return
    endif
    set WUI_CommandBar = BlzGetFrameByName("CommandBarFrame", 0)
    if detail != null then
        set WUI_NativeDetailParent = BlzFrameGetParent(detail)
    endif
    // Reforged 2+ puts the whole stock lower UI under ConsoleBottomBar.
    // Never infer/reparent a container from one command/item slot: those may
    // not exist before selection, or its immediate parent may be a wrapper.
    if WUI_CommandBar == null or WUI_NativeDetailParent == null then
        set detail = null
        set cover = null
        set minimap = null
        return
    endif
    call WUI_CacheNativeSlots()
    // Do not move a SIMPLEFRAME into the normal FRAME hierarchy.
    call BlzFrameSetParent(WUI_CommandBar, WUI_SimpleRoot)
    call BlzFrameSetParent(WUI_NativeDetailParent, WUI_SimpleRoot)
    call BlzFrameSetLevel(WUI_CommandBar, 2)
    call BlzFrameSetLevel(WUI_NativeDetailParent, 2)
    if systemBar != null then
        call BlzFrameSetParent(systemBar, WUI_SimpleRoot)
    endif
    if WUI_NativeTooltip != null then
        call BlzFrameSetParent(WUI_NativeTooltip, WUI_SimpleRoot)
        call BlzFrameClearAllPoints(WUI_NativeTooltip)
        // Compact column over the ability row: both bottom corners fix the
        // width (0.236), so long descriptions wrap instead of spanning the HUD.
        // Checkpoint 25: ONE anchor (the engine's own bottom-right) plus a
        // fixed width: nothing to stretch and no per-frame re-pinning, so
        // tooltips no longer jump from the old spot to the new one.
        call BlzFrameSetAbsPoint(WUI_NativeTooltip, FRAMEPOINT_BOTTOMRIGHT, WUI_CHASSIS_RIGHT + WUI_HudShift - 0.004, WUI_CHASSIS_TOP + 0.010)
        call BlzFrameSetSize(WUI_NativeTooltip, 0.300, 0.050)
    endif
    set WUI_HiddenDetails = BlzCreateFrameByType("SIMPLEFRAME", "WOSHiddenNativeDetails", WUI_SimpleRoot, "", 0)
    call BlzFrameSetVisible(WUI_HiddenDetails, false)
    if detail != null then
        // Keep real status icons/tooltips when the large unit detail panel is hidden.
        if WUI_Buffs != null then
            call BlzFrameSetParent(WUI_Buffs, WUI_SimpleRoot)
            // Stock buffs sit above the chassis, right of seven gear-buff slots.
            // A SIMPLEFRAME's scale multiplies its absolute point too, so the
            // point is divided by the scale (1.5 without it sent them flying).
            call BlzFrameSetScale(WUI_Buffs, WUI_BUFF_SCALE)
            call WUI_PlaceBuffBar()
            call WUI_TightenBuffBar()
        endif
        call BlzFrameSetParent(detail, WUI_HiddenDetails)
    endif
    if cover != null then
        call BlzFrameSetAlpha(cover, 0)
    endif
    if label != null then
        call BlzFrameSetText(label, "")
    endif
    call BlzEnableUIAutoPosition(false)
    if minimap != null then
        call WUI_RectShiftLeft(minimap, 0.004, 0.004, 0.004 + WUI_MINIMAP_SIZE, 0.004 + WUI_MINIMAP_SIZE)
    endif
    loop
        exitwhen i >= 6
        call WUI_PlaceNativeItem(WUI_Item[i], WUI_ItemX(i), WUI_ItemY(i), WUI_ITEM_SIZE)
        set i = i + 1
    endloop
    if WUI_Console != null then
        call BlzFrameSetVisible(WUI_Console, false)
    endif
    if WUI_TopConsole != null then
        call BlzFrameSetVisible(WUI_TopConsole, false)
    endif
    if WUI_BottomConsole != null then
        call BlzFrameSetVisible(WUI_BottomConsole, false)
    endif
    call BlzFrameSetVisible(WUI_CommandBar, true)
    call BlzFrameSetVisible(WUI_NativeDetailParent, true)
    if systemBar != null then
        call BlzFrameSetVisible(systemBar, true)
    endif
    if WUI_Portrait != null then
        call BlzFrameSetVisible(WUI_Portrait, false)
    endif
    if WUI_Resource != null then
        call WUI_ParkResourceBar()
    endif
    if WUI_HeroBar != null then
        call BlzFrameSetVisible(WUI_HeroBar, false)
    endif
    call WUI_HideNativeDeadZone()
    set i = 0
    loop
        exitwhen i >= 5
        set cover = BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP_BUTTON, i)
        // Checkpoint 22: the ally-colour button (Alt+A, stock index 2) stays,
        // docked under the camera slider in the minimap block's right strip.
        if cover != null and i == WUI_ALLY_COLOR_BUTTON then
            set WUI_AllyColor = cover
            call BlzFrameSetVisible(cover, true)
            call WUI_Place(cover, WUI_ALLY_COLOR_X, WUI_ALLY_COLOR_Y, WUI_ALLY_COLOR_SIZE, WUI_ALLY_COLOR_SIZE)
        elseif cover != null then
            call BlzFrameSetVisible(cover, false)
        endif
        set i = i + 1
    endloop
    if minimap != null then
        call BlzFrameSetVisible(minimap, true)
    endif
    set WUI_NativeReady = true
    set detail = null
    set cover = null
    set minimap = null
    set systemBar = null
endfunction



// Placeholder overlays never intercept orders. Empty/unlearned logical slots
// move the native occupant out of the row (including the stock learn button).
function WUI_ShowNativeAbilitySlot takes integer slot, boolean visible returns nothing
    local integer state = 2
    if not WUI_CompactCommands or slot < 0 or slot >= 7 then
        return
    endif
    // Checkpoint 27d: AllyHeroAbilityUI calls this for every slot every 0.15 s.
    // Re-placing and re-scaling a native button subtree is expensive, so it is
    // done on a state change and otherwise only every ~2 s (engine resets).
    if visible then
        set state = 1
    endif
    // Re-placing a live button every ~2 s made its cooldown sprite and digits
    // jump for a frame; only a real state change moves it now (a UI reset is
    // re-laid out by WUI_LayoutCommands, which clears this cache).
    if WUI_NativeSlotState[slot] == state then
        return
    endif
    set WUI_NativeSlotState[slot] = state
    set WUI_NativeSlotAge[slot] = 0
    if visible then
        call WUI_PlaceNativeButton(WUI_Command[WUI_CommandSlot(slot)], WUI_AbilityX(slot), WUI_AbilityY(slot), WUI_ICON_SIZE)
    else
        call WUI_PlaceNativeButton(WUI_Command[WUI_CommandSlot(slot)], -0.20, -0.20, WUI_ICON_SIZE)
    endif
endfunction

function WUI_SetButtonSelected takes framehandle control, boolean selected returns nothing
    local integer key = GetHandleId(control)
    call SaveBoolean(WUI_ButtonStyle, key, 2, selected)
    if selected then
        call BlzFrameSetTexture(LoadFrameHandle(WUI_ButtonStyle, key, 0), WUI_FILL_SELECTED, 0, true)
    else
        call BlzFrameSetTexture(LoadFrameHandle(WUI_ButtonStyle, key, 0), WUI_FILL_NORMAL, 0, true)
    endif
endfunction

// Checkpoint 25: local. Opening the shop closes the dropdown, Game Info and
// TEST COMMANDS; opening F2 closes the dropdown (Scoreboard calls this).
function WUI_CloseMenuDrop takes nothing returns nothing
    if WUI_MenuOpen then
        call WUI_SetMenuDrop(false)
    endif
endfunction

function WUI_CloseTopPanels takes nothing returns nothing
    call WUI_CloseMenuDrop()
    if WUI_InfoOpen then
        set WUI_InfoOpen = false
        if WUI_InfoButton != null then
            call WUI_SetButtonSelected(WUI_InfoButton, false)
        endif
    endif
    if WUI_TestOpen and WUI_TestPanel != null then
        set WUI_TestOpen = false
        call BlzFrameSetVisible(WUI_TestPanel, false)
    endif
    call WUI_LayoutRightColumn()
endfunction

// Checkpoint 27: Hide UI folds every top-right section as if closed (menu
// drawer, TEST COMMANDS, Game Info, hero column panels), so nothing is left
// hanging in the air when the UI comes back.
function WUI_CollapseAllPanels takes nothing returns nothing
    local integer i = 1
    loop
        exitwhen i > WUI_ColCount
        set WUI_ColOpen[i] = false
        call WUI_ColumnApply(i)
        set i = i + 1
    endloop
    call WUI_CloseTopPanels()
endfunction

private function WUI_WatchCover takes nothing returns nothing
    local boolean covered = WUI_CoverWatch != null and BlzFrameIsVisible(WUI_CoverWatch)
    call WUI_BlankResourceTexts()
    if covered and not WUI_CoverClosed then
        call WUI_CloseTopPanels()
    endif
    set WUI_CoverClosed = covered
endfunction


private function WUI_ButtonHover takes nothing returns nothing
    local framehandle control = BlzGetTriggerFrame()
    local integer key = GetHandleId(control)
    if GetLocalPlayer() == GetTriggerPlayer() then
        if BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_ENTER then
            call BlzFrameSetTexture(LoadFrameHandle(WUI_ButtonStyle, key, 0), WUI_FILL_HOVER, 0, true)
        else
            call WUI_SetButtonSelected(control, LoadBoolean(WUI_ButtonStyle, key, 2))
        endif
    endif
    set control = null
endfunction

function WUI_TextButton takes string name, framehandle parent, string caption, real width, real height returns framehandle
    local framehandle control = null
    local framehandle back = null
    local framehandle text = null
    local boolean engineHover = false
    // Preferred: FDF template whose hover highlight is drawn by the engine, so
    // hovering raises no (network-synced) frame events at all.
    if WUI_FrameDefinitionsReady then
        set WUI_TextButtonCount = WUI_TextButtonCount + 1
        set control = BlzCreateFrame("WOSTextButtonTemplate", parent, 0, 7000 + WUI_TextButtonCount)
        if control != null then
            set back = BlzGetFrameByName("WOSTextButtonBack", 7000 + WUI_TextButtonCount)
        endif
        set engineHover = control != null and back != null
    endif
    if not engineHover then
        set control = BlzCreateFrameByType("BUTTON", name, parent, "", 0)
        set back = BlzCreateFrameByType("BACKDROP", name + "Back", control, "", 0)
        call BlzFrameSetAllPoints(back, control)
        call BlzFrameSetTexture(back, WUI_FILL_NORMAL, 0, true)
        call BlzFrameSetEnable(back, false)
    endif
    set text = BlzCreateFrameByType("TEXT", name + "Text", control, "", 0)
    call BlzFrameSetSize(control, width, height)
    call BlzFrameSetAllPoints(text, control)
    call BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(text, 0.90)
    call BlzFrameSetText(text, WUI_TEXT + caption + "|r")
    call BlzFrameSetEnable(text, false)
    call SaveFrameHandle(WUI_ButtonStyle, GetHandleId(control), 0, back)
    call SaveFrameHandle(WUI_ButtonStyle, GetHandleId(control), 1, text)
    if not engineHover then
        if WUI_ButtonEvents == null then
            set WUI_ButtonEvents = CreateTrigger()
            call TriggerAddAction(WUI_ButtonEvents, function WUI_ButtonHover)
        endif
        call BlzTriggerRegisterFrameEvent(WUI_ButtonEvents, control, FRAMEEVENT_MOUSE_ENTER)
        call BlzTriggerRegisterFrameEvent(WUI_ButtonEvents, control, FRAMEEVENT_MOUSE_LEAVE)
    endif
    // The gold hairline is centred on the real button edge: what the player
    // sees as the frame is exactly the clickable rectangle.
    set back = WUI_GoldFrame(name + "Metal", control, 0.0032, RMinBJ(0.0090, height * 0.40))
    call SaveFrameHandle(WUI_ButtonStyle, GetHandleId(control), 2, back)
    set back = null
    set text = null
    return control
endfunction

// Checkpoint 26: quiet variant for the top-right text buttons (Hide UI, Shop
// Key, Game Info, TEST COMMANDS): the bevel + corner gems give way to the soft
// fading gold lines of the HUD stat dividers.
// Soft divider-line frame around any owner (buttons, top actions panel).
function WUI_MinimalEdge takes framehandle control returns nothing
    local framehandle piece
    set piece = WUI_Piece("WOSMinimalTop", control, "UI\\WOS\\divider-h.tga")
    call BlzFrameSetPoint(piece, FRAMEPOINT_LEFT, control, FRAMEPOINT_TOPLEFT, 0.00, 0.00)
    call BlzFrameSetPoint(piece, FRAMEPOINT_RIGHT, control, FRAMEPOINT_TOPRIGHT, 0.00, 0.00)
    call BlzFrameSetSize(piece, 0.00, 0.003)
    call BlzFrameSetAlpha(piece, 170)
    set piece = WUI_Piece("WOSMinimalBottom", control, "UI\\WOS\\divider-h.tga")
    call BlzFrameSetPoint(piece, FRAMEPOINT_LEFT, control, FRAMEPOINT_BOTTOMLEFT, 0.00, 0.00)
    call BlzFrameSetPoint(piece, FRAMEPOINT_RIGHT, control, FRAMEPOINT_BOTTOMRIGHT, 0.00, 0.00)
    call BlzFrameSetSize(piece, 0.00, 0.003)
    call BlzFrameSetAlpha(piece, 170)
    set piece = WUI_Piece("WOSMinimalLeft", control, "UI\\WOS\\divider-v.tga")
    call BlzFrameSetPoint(piece, FRAMEPOINT_TOP, control, FRAMEPOINT_TOPLEFT, 0.00, 0.00)
    call BlzFrameSetPoint(piece, FRAMEPOINT_BOTTOM, control, FRAMEPOINT_BOTTOMLEFT, 0.00, 0.00)
    call BlzFrameSetSize(piece, 0.003, 0.00)
    call BlzFrameSetAlpha(piece, 170)
    set piece = WUI_Piece("WOSMinimalRight", control, "UI\\WOS\\divider-v.tga")
    call BlzFrameSetPoint(piece, FRAMEPOINT_TOP, control, FRAMEPOINT_TOPRIGHT, 0.00, 0.00)
    call BlzFrameSetPoint(piece, FRAMEPOINT_BOTTOM, control, FRAMEPOINT_BOTTOMRIGHT, 0.00, 0.00)
    call BlzFrameSetSize(piece, 0.003, 0.00)
    call BlzFrameSetAlpha(piece, 170)
    set piece = null
endfunction

function WUI_SetButtonMinimal takes framehandle control returns nothing
    local framehandle metal
    local framehandle piece
    if control == null then
        return
    endif
    set metal = LoadFrameHandle(WUI_ButtonStyle, GetHandleId(control), 2)
    if metal != null then
        call BlzFrameSetVisible(metal, false)
    endif
    call WUI_MinimalEdge(control)
    set metal = null
endfunction

// Synchronous, once per panel: header "TITLE  +/-" and the panel's height.
function WUI_RegisterColumnPanel takes framehandle panel, string title, real height returns nothing
    local integer i
    if panel == null or LoadInteger(WUI_ColKeys, GetHandleId(panel), 0) != 0 then
        return
    endif
    set WUI_ColCount = WUI_ColCount + 1
    set i = WUI_ColCount
    set WUI_ColPanel[i] = panel
    set WUI_ColHeight[i] = height
    set WUI_ColActive[i] = false
    set WUI_ColOpen[i] = true
    set WUI_ColToggle[i] = WUI_TextButton("WOSColumnToggle", WUI_Root, title + "  +/-", 0.180, 0.018)
    call WUI_SetButtonTextScale(WUI_ColToggle[i], 0.78)
    // Checkpoint 26b: hero column panels (e.g. Kyoraku BANKAI STAGES) get the
    // same quiet edge as TEST COMMANDS.
    call WUI_SetButtonMinimal(WUI_ColToggle[i])
    call WUI_MinimalEdge(panel)
    call SaveInteger(WUI_ColKeys, GetHandleId(panel), 0, i)
    call SaveInteger(WUI_ColKeys, GetHandleId(WUI_ColToggle[i]), 1, i)
    if WUI_ColClick == null then
        set WUI_ColClick = CreateTrigger()
        call TriggerAddAction(WUI_ColClick, function WUI_OnColumnToggle)
    endif
    call BlzTriggerRegisterFrameEvent(WUI_ColClick, WUI_ColToggle[i], FRAMEEVENT_CONTROL_CLICK)
    call WUI_ColumnApply(i)
    call WUI_LayoutRightColumn()
endfunction

// ===== Checkpoint 22: toggles, origin-frame state, per-slot hotkeys =====
// Synced: every client calls this with the same player (HideBottomUI /
// HideUIExceptTopMenu). Inside the local check only direct frame calls; no
// hook on BlzHideOriginFrames any more (a hook ran TriggerEvaluate locally).
function WUI_SetOriginHidden takes player p, boolean hide returns nothing
    local integer i = 0
    set WUI_OriginHiddenOf[GetPlayerId(p)] = hide
    set WUI_OriginHidden = WUI_OriginHiddenOf[GetPlayerId(GetLocalPlayer())]
    if WUI_MinimapStub != null and GetLocalPlayer() == p then
        call BlzFrameSetVisible(WUI_MinimapStub, hide)
    endif
    loop
        exitwhen i >= 3
        if WUI_MenuSkinF[i] != null and GetLocalPlayer() == p then
            call BlzFrameSetVisible(WUI_MenuSkinF[i], hide and WUI_MenuOpen)
        endif
        set i = i + 1
    endloop
endfunction

// True while the stock command card is hidden (hero pick / draft): learned
// skills are then drawn by AllyHeroAbilityUI instead of the native buttons.
function WUI_NativeCommandsHidden takes nothing returns boolean
    return WUI_OriginHidden
endfunction

function WUI_IsHotkeyEditing takes nothing returns boolean
    return WUI_HotkeyEdit[GetPlayerId(GetLocalPlayer())]
endfunction

// Square toggle: graphite fill, gold glyph, flush gold frame. ON = warm gold
// fill and full-bright glyph; OFF = plain fill and a dimmed glyph.
function WUI_ToggleButton takes string name, real x, real y, real size, string glyph returns framehandle
    local framehandle control = BlzCreateFrameByType("BUTTON", name, WUI_Root, "", 0)
    local framehandle back = BlzCreateFrameByType("BACKDROP", name + "Back", control, "", 0)
    local framehandle icon = BlzCreateFrameByType("BACKDROP", name + "Glyph", control, "", 0)
    local framehandle edge
    call WUI_Place(control, x, y, size, size)
    call BlzFrameSetLevel(control, 40)
    call BlzFrameSetAllPoints(back, control)
    call BlzFrameSetTexture(back, WUI_FILL_NORMAL, 0, true)
    call BlzFrameSetEnable(back, false)
    call BlzFrameSetPoint(icon, FRAMEPOINT_TOPLEFT, control, FRAMEPOINT_TOPLEFT, size * 0.14, -size * 0.14)
    call BlzFrameSetPoint(icon, FRAMEPOINT_BOTTOMRIGHT, control, FRAMEPOINT_BOTTOMRIGHT, -size * 0.14, size * 0.14)
    call BlzFrameSetTexture(icon, glyph, 0, true)
    call BlzFrameSetAlpha(icon, 140)
    call BlzFrameSetEnable(icon, false)
    set edge = WUI_GoldFrame(name + "Edge", control, 0.0026, RMinBJ(0.0060, size * 0.32))
    call SaveFrameHandle(WUI_ButtonStyle, GetHandleId(control), 0, back)
    call SaveFrameHandle(WUI_ButtonStyle, GetHandleId(control), 1, icon)
    set back = null
    set icon = null
    set edge = null
    return control
endfunction

// Local presentation only.
function WUI_SetToggleState takes framehandle control, boolean on returns nothing
    local integer key = GetHandleId(control)
    if on then
        call BlzFrameSetTexture(LoadFrameHandle(WUI_ButtonStyle, key, 0), WUI_FILL_SELECTED, 0, true)
        call BlzFrameSetAlpha(LoadFrameHandle(WUI_ButtonStyle, key, 1), 255)
    else
        call BlzFrameSetTexture(LoadFrameHandle(WUI_ButtonStyle, key, 0), WUI_FILL_NORMAL, 0, true)
        call BlzFrameSetAlpha(LoadFrameHandle(WUI_ButtonStyle, key, 1), 140)
    endif
    call BlzFrameSetEnable(control, false)
    call BlzFrameSetEnable(control, true)
endfunction

// Local presentation only: swaps the glyph of a WUI_ToggleButton.
function WUI_SetToggleGlyph takes framehandle control, string glyph returns nothing
    local framehandle icon = LoadFrameHandle(WUI_ButtonStyle, GetHandleId(control), 1)
    if icon != null then
        call BlzFrameSetTexture(icon, glyph, 0, true)
    endif
    set icon = null
endfunction

// Slots 0..6 = QWERTFG ability row, 7..12 = inventory 1..6.
private function WUI_SlotX takes integer slot returns real
    if slot < 7 then
        return WUI_AbilityX(slot)
    endif
    return WUI_ItemX(slot - 7)
endfunction

private function WUI_SlotY takes integer slot returns real
    if slot < 7 then
        return WUI_HUD_Y
    endif
    return WUI_ItemY(slot - 7)
endfunction

private function WUI_SlotSize takes integer slot returns real
    if slot < 7 then
        return WUI_ICON_SIZE
    endif
    return WUI_ITEM_SIZE
endfunction

private function WUI_SlotTarget takes integer slot returns framehandle
    if slot < 7 then
        return WUI_Command[WUI_CommandSlot(slot)]
    endif
    return WUI_Item[slot - 7]
endfunction

function WUI_SlotKeyLabel takes integer pid, integer slot returns string
    if not WUI_ENABLE_HOTKEYS or WUI_SlotKeyName[pid * WUI_SLOT_KEYS + slot] == null then
        return ""
    endif
    return WUI_SlotKeyName[pid * WUI_SLOT_KEYS + slot]
endfunction

// Stock key of a slot: QWERTFG for skills, nothing for items.
function WUI_SlotDefaultKey takes integer slot returns string
    return SubString("QWERTFG", slot, slot + 1)
endfunction

// Text the player sees on a slot: the custom key, else the stock one.
function WUI_SlotShownKey takes integer pid, integer slot returns string
    local string label = WUI_SlotKeyLabel(pid, slot)
    if label != "" then
        return label
    elseif slot < 7 then
        return WUI_SlotDefaultKey(slot)
    endif
    return "-"
endfunction

private function WUI_SlotTitle takes integer slot returns string
    if slot < 7 then
        return "skill " + WUI_SlotDefaultKey(slot)
    endif
    return "item " + I2S(slot - 6)
endfunction

// AllyHeroAbilityUI tells which skill slots it currently draws for the own
// hero instead of the native button (custom key / pick / edit mode). Local.
function WUI_SetSlotCustomShown takes integer slot, boolean shown returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    if slot < 0 or slot >= 7 or WUI_SlotShown[slot] == shown or WUI_SlotOverlay[slot] == null then
        set WUI_SlotShown[slot] = shown
        return
    endif
    set WUI_SlotShown[slot] = shown
    call BlzFrameSetVisible(WUI_SlotOverlay[slot], WUI_HotkeyEdit[pid] or (shown and WUI_SlotKeyName[pid * WUI_SLOT_KEYS + slot] != ""))
endfunction

// Local: big key labels in edit mode, corner badges for custom item keys,
// click targets over custom-drawn skills, hint and the toggle look.
private function WUI_RefreshSlotBadges takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local integer slot = 0
    local string label
    local boolean editing = WUI_HotkeyEdit[pid]
    local boolean capture
    loop
        exitwhen slot >= WUI_SLOT_KEYS
        set label = WUI_SlotKeyName[pid * WUI_SLOT_KEYS + slot]
        set capture = editing and WUI_SlotCapture[pid] == slot
        call BlzFrameClearAllPoints(WUI_SlotBadge[slot])
        if editing then
            // Edit mode: the key in the middle of the icon, readable.
            call BlzFrameSetPoint(WUI_SlotBadge[slot], FRAMEPOINT_CENTER, WUI_SlotOverlay[slot], FRAMEPOINT_CENTER, 0.00, 0.00)
            call BlzFrameSetSize(WUI_SlotBadge[slot], 0.019, 0.019)
            call BlzFrameSetScale(WUI_SlotBadgeText[slot], 1.00)
            if capture then
                call BlzFrameSetText(WUI_SlotBadgeText[slot], "|cff7ee870?|r")
            elseif label != "" then
                call BlzFrameSetText(WUI_SlotBadgeText[slot], WUI_GOLD + label + "|r")
            else
                call BlzFrameSetText(WUI_SlotBadgeText[slot], WUI_TEXT + WUI_SlotShownKey(pid, slot) + "|r")
            endif
            call BlzFrameSetVisible(WUI_SlotBadge[slot], true)
        else
            // Play: skills show their key through AllyHeroAbilityUI; items
            // keep a small corner badge for a custom key.
            call BlzFrameSetPoint(WUI_SlotBadge[slot], FRAMEPOINT_CENTER, WUI_SlotOverlay[slot], FRAMEPOINT_TOPRIGHT, -0.0035, -0.0035)
            call BlzFrameSetSize(WUI_SlotBadge[slot], 0.0115, 0.0115)
            call BlzFrameSetScale(WUI_SlotBadgeText[slot], 0.62)
            call BlzFrameSetText(WUI_SlotBadgeText[slot], WUI_GOLD + label + "|r")
            call BlzFrameSetVisible(WUI_SlotBadge[slot], slot >= 7 and label != "")
        endif
        call BlzFrameSetVisible(WUI_SlotOverlay[slot], editing or (slot < 7 and WUI_SlotShown[slot] and label != ""))
        call BlzFrameSetVisible(WUI_SlotOverlayEdge[slot], editing)
        if capture then
            call BlzFrameSetAlpha(WUI_SlotOverlayEdge[slot], 255)
        else
            call BlzFrameSetAlpha(WUI_SlotOverlayEdge[slot], 120)
        endif
        set slot = slot + 1
    endloop
    call BlzFrameSetVisible(WUI_HotkeyHint, editing)
    if WUI_HotkeyToggle != null then
        call WUI_SetToggleState(WUI_HotkeyToggle, editing)
    endif
    set label = null
endfunction

// Local pulse of the slot that is waiting for its key.
private function WUI_CapturePulse takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local integer slot = WUI_SlotCapture[pid]
    set WUI_PulsePhase = WUI_PulsePhase + 0.35
    if WUI_PulsePhase > 6.2832 then
        set WUI_PulsePhase = WUI_PulsePhase - 6.2832
    endif
    if slot >= 0 and slot < WUI_SLOT_KEYS then
        call BlzFrameSetAlpha(WUI_SlotOverlayEdge[slot], 150 + R2I(105.00 * Sin(WUI_PulsePhase)))
    endif
endfunction

// Local: press the slot. Skills: the stock hotkey (ForceUIKey) opens the same
// cast/targeting as the real key; items: click the native item button.
private function WUI_UseSlot takes integer slot returns nothing
    if slot < 7 then
        call ForceUIKey(WUI_SlotDefaultKey(slot))
    elseif WUI_Item[slot - 7] != null then
        call BlzFrameClick(WUI_Item[slot - 7])
    endif
endfunction

// Synced: a bound key was pressed (outside edit mode).
private function WUI_OnSlotKey takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local oskeytype key = BlzGetTriggerPlayerKey()
    local integer slot = 0
    local integer found = -1
    if pid >= 16 or WUI_HotkeyEdit[pid] or WUI_SlotCapture[pid] >= 0 then
        set p = null
        set key = null
        return
    endif
    loop
        exitwhen slot >= WUI_SLOT_KEYS
        if WUI_SlotKey[pid * WUI_SLOT_KEYS + slot] == key then
            set found = slot
            exitwhen true
        endif
        set slot = slot + 1
    endloop
    if found >= 0 and GetLocalPlayer() == p then
        call WUI_UseSlot(found)
    endif
    set p = null
    set key = null
endfunction

private function WUI_RegisterSlotKey takes player p, oskeytype key returns nothing
    local integer pid = GetPlayerId(p)
    local integer meta = 0
    if LoadBoolean(WUI_SlotKeyRegistered, pid, GetHandleId(key)) then
        return
    endif
    call SaveBoolean(WUI_SlotKeyRegistered, pid, GetHandleId(key), true)
    loop
        exitwhen meta > 15
        call BlzTriggerRegisterPlayerKeyEvent(WUI_SlotKeyTrigger, p, key, meta, true)
        set meta = meta + 1
    endloop
endfunction

// Why a key cannot be used ("" = free).
private function WUI_SlotKeyConflict takes integer pid, integer slot, oskeytype key, string name returns string
    local integer other = 0
    if name == "" then
        return "only letters and digits can be used"
    elseif name == "Q" or name == "W" or name == "E" or name == "R" or name == "T" or name == "F" or name == "G" then
        return name + " is a stock skill key (Q W E R T F G)"
    elseif name == "A" or name == "S" or name == "H" or name == "M" or name == "P" then
        return name + " is a stock order key (A S H M P)"
    elseif name == "B" or name == "I" then
        return name + " opens the shop (B I Tab Space)"
    elseif key == WUI_GetHotkey(WUI_HOTKEY_PING, pid) then
        return name + " is the ping wheel key"
    elseif key == WUI_GetHotkey(WUI_HOTKEY_EMOTE, pid) then
        return name + " is the emote wheel key"
    endif
    loop
        exitwhen other >= WUI_SLOT_KEYS
        if other != slot and WUI_SlotKey[pid * WUI_SLOT_KEYS + other] == key then
            return name + " is already used by " + WUI_SlotTitle(other)
        endif
        set other = other + 1
    endloop
    return ""
endfunction

// Synced: the key pressed while a slot was waiting for its new hotkey.
private function WUI_OnSlotCapture takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local integer slot = WUI_SlotCapture[pid]
    local oskeytype key = BlzGetTriggerPlayerKey()
    local integer i = 1
    local string name = ""
    local string conflict
    call DisableTrigger(GetTriggeringTrigger())
    set WUI_SlotCapture[pid] = -1
    if slot >= 0 then
        if key == OSKEY_BACKSPACE then
            set WUI_SlotKey[pid * WUI_SLOT_KEYS + slot] = null
            set WUI_SlotKeyName[pid * WUI_SLOT_KEYS + slot] = ""
            call DisplayTimedTextToPlayer(p, 0, 0, 1.00, WUI_GOLD + "Custom hotkey of " + WUI_SlotTitle(slot) + " removed.|r")
        elseif key == OSKEY_ESCAPE then
            call DisplayTimedTextToPlayer(p, 0, 0, 1.00, WUI_TEXT + "Hotkey unchanged.|r")
        else
            loop
                exitwhen i > WUI_KeyCount
                if WUI_KeyCode[i] == key then
                    set name = WUI_KeyLabel[i]
                endif
                set i = i + 1
            endloop
            if key == OSKEY_Q then
                set name = "Q"
            elseif key == OSKEY_W then
                set name = "W"
            elseif key == OSKEY_E then
                set name = "E"
            elseif key == OSKEY_R then
                set name = "R"
            elseif key == OSKEY_T then
                set name = "T"
            elseif key == OSKEY_F then
                set name = "F"
            elseif key == OSKEY_G then
                set name = "G"
            endif
            if slot < 7 and name == WUI_SlotDefaultKey(slot) then
                // Choosing the stock key again simply removes the custom one.
                set WUI_SlotKey[pid * WUI_SLOT_KEYS + slot] = null
                set WUI_SlotKeyName[pid * WUI_SLOT_KEYS + slot] = ""
                call DisplayTimedTextToPlayer(p, 0, 0, 1.00, WUI_GOLD + WUI_SlotTitle(slot) + " uses its stock key again.|r")
            else
                set conflict = WUI_SlotKeyConflict(pid, slot, key, name)
                if conflict == "" then
                    set WUI_SlotKey[pid * WUI_SLOT_KEYS + slot] = key
                    set WUI_SlotKeyName[pid * WUI_SLOT_KEYS + slot] = name
                    call WUI_RegisterSlotKey(p, key)
                    call DisplayTimedTextToPlayer(p, 0, 0, 1.00, WUI_GOLD + "Hotkey changed: " + WUI_SlotTitle(slot) + " -> " + name + "|r")
                else
                    call DisplayTimedTextToPlayer(p, 0, 0, 4.00, "|cffff7a6aKey taken: " + conflict + ".|r|n" + WUI_TEXT + "Taken: Q W E R T F G, A S H M P, B I, your ping/emote keys and keys of other slots.|r")
                endif
            endif
        endif
    endif
    if GetLocalPlayer() == p then
        call PauseTimer(WUI_PulseTimer)
        call WUI_RefreshSlotBadges()
    endif
    set p = null
    set key = null
endfunction

// ===== Checkpoint 27b: saved settings (local4 settings file, AAINIT) =====
// Key from its label ("K", "F2", "TAB", "Q"...); null when unknown.
function WUI_KeyByLabel takes string label returns oskeytype
    local integer i = 1
    call WUI_InitKeyTable()
    loop
        exitwhen i > WUI_KeyCount
        if WUI_KeyLabel[i] == label then
            return WUI_KeyCode[i]
        endif
        set i = i + 1
    endloop
    if label == "Q" then
        return OSKEY_Q
    elseif label == "W" then
        return OSKEY_W
    elseif label == "E" then
        return OSKEY_E
    elseif label == "R" then
        return OSKEY_R
    elseif label == "T" then
        return OSKEY_T
    elseif label == "F" then
        return OSKEY_F
    elseif label == "G" then
        return OSKEY_G
    endif
    return null
endfunction

// Synced (sync-data handler): restore one saved channel hotkey of p.
function WUI_ApplySavedHotkey takes player p, integer channel, string label returns nothing
    local integer pid = GetPlayerId(p)
    local oskeytype key = WUI_KeyByLabel(label)
    if key == null or channel < 0 or channel >= WUI_HOTKEY_CHANNELS or pid >= 16 or WUI_HotkeyTrigger[channel] == null then
        set key = null
        return
    endif
    set WUI_HotkeyKey[channel * 16 + pid] = key
    set WUI_HotkeyName[channel * 16 + pid] = label
    call WUI_RegisterKeyFor(channel, p, key)
    if GetLocalPlayer() == p and WUI_HotkeyLabel[channel] != null then
        call BlzFrameSetText(WUI_HotkeyLabel[channel], WUI_GOLD + label + "|r")
        call WUI_SizeHotkeyBadge(channel, label)
    endif
    set key = null
endfunction

// Synced: restore one saved custom slot key (skills 0-6, items 7-12).
function WUI_ApplySavedSlotKey takes player p, integer slot, string label returns nothing
    local integer pid = GetPlayerId(p)
    local oskeytype key = WUI_KeyByLabel(label)
    if key == null or slot < 0 or slot >= WUI_SLOT_KEYS then
        set key = null
        return
    endif
    if WUI_SlotKeyConflict(pid, slot, key, label) == "" then
        set WUI_SlotKey[pid * WUI_SLOT_KEYS + slot] = key
        set WUI_SlotKeyName[pid * WUI_SLOT_KEYS + slot] = label
        call WUI_RegisterSlotKey(p, key)
    endif
    if GetLocalPlayer() == p then
        call WUI_RefreshSlotBadges()
    endif
    set key = null
endfunction

// Local: "H,channel,label|" per hotkey and "K,slot,label|" per custom slot key.
function WUI_SavedSettingsString takes integer pid returns string
    local string result = ""
    local integer i = 0
    loop
        exitwhen i >= WUI_HOTKEY_CHANNELS
        if WUI_HotkeyName[i * 16 + pid] != null and WUI_HotkeyName[i * 16 + pid] != "" then
            set result = result + "H," + I2S(i) + "," + WUI_HotkeyName[i * 16 + pid] + "|"
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= WUI_SLOT_KEYS
        if WUI_SlotKeyName[pid * WUI_SLOT_KEYS + i] != null and WUI_SlotKeyName[pid * WUI_SLOT_KEYS + i] != "" then
            set result = result + "K," + I2S(i) + "," + WUI_SlotKeyName[pid * WUI_SLOT_KEYS + i] + "|"
        endif
        set i = i + 1
    endloop
    return result
endfunction

private function WUI_StartSlotCapture takes player p, integer slot returns nothing
    local integer pid = GetPlayerId(p)
    local integer i = 1
    if WUI_SlotCaptureTrigger[pid] != null then
        call DisableTrigger(WUI_SlotCaptureTrigger[pid])
    endif
    set WUI_SlotCaptureTrigger[pid] = CreateTrigger()
    set WUI_SlotCapture[pid] = slot
    loop
        exitwhen i > WUI_KeyCount
        call BlzTriggerRegisterPlayerKeyEvent(WUI_SlotCaptureTrigger[pid], p, WUI_KeyCode[i], 0, true)
        set i = i + 1
    endloop
    // Q W E R T F G: re-picking a stock key resets the slot.
    call BlzTriggerRegisterPlayerKeyEvent(WUI_SlotCaptureTrigger[pid], p, OSKEY_Q, 0, true)
    call BlzTriggerRegisterPlayerKeyEvent(WUI_SlotCaptureTrigger[pid], p, OSKEY_W, 0, true)
    call BlzTriggerRegisterPlayerKeyEvent(WUI_SlotCaptureTrigger[pid], p, OSKEY_E, 0, true)
    call BlzTriggerRegisterPlayerKeyEvent(WUI_SlotCaptureTrigger[pid], p, OSKEY_R, 0, true)
    call BlzTriggerRegisterPlayerKeyEvent(WUI_SlotCaptureTrigger[pid], p, OSKEY_T, 0, true)
    call BlzTriggerRegisterPlayerKeyEvent(WUI_SlotCaptureTrigger[pid], p, OSKEY_F, 0, true)
    call BlzTriggerRegisterPlayerKeyEvent(WUI_SlotCaptureTrigger[pid], p, OSKEY_G, 0, true)
    call BlzTriggerRegisterPlayerKeyEvent(WUI_SlotCaptureTrigger[pid], p, OSKEY_ESCAPE, 0, true)
    call BlzTriggerRegisterPlayerKeyEvent(WUI_SlotCaptureTrigger[pid], p, OSKEY_BACKSPACE, 0, true)
    call TriggerAddAction(WUI_SlotCaptureTrigger[pid], function WUI_OnSlotCapture)
    call DisplayTimedTextToPlayer(p, 0, 0, 6.00, WUI_GOLD + "Choose a hotkey for " + WUI_SlotTitle(slot) + ":|r " + WUI_TEXT + "press a letter or digit  (Esc - cancel, Backspace - remove)|r")
    if GetLocalPlayer() == p then
        set WUI_PulsePhase = 0.00
        call TimerStart(WUI_PulseTimer, 0.04, true, function WUI_CapturePulse)
    endif
endfunction

// Synced: toggle click, slot click while editing, or a mouse click on a
// custom-drawn skill outside edit mode (casts it like the real button).
private function WUI_OnSlotClick takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local framehandle clicked = BlzGetTriggerFrame()
    local integer slot = 0
    if pid >= 16 then
        set p = null
        set clicked = null
        return
    endif
    if clicked == WUI_HotkeyToggle then
        set WUI_HotkeyEdit[pid] = not WUI_HotkeyEdit[pid]
        if WUI_SlotCaptureTrigger[pid] != null then
            call DisableTrigger(WUI_SlotCaptureTrigger[pid])
        endif
        set WUI_SlotCapture[pid] = -1
        if WUI_HotkeyEdit[pid] then
            call DisplayTimedTextToPlayer(p, 0, 0, 4.00, WUI_GOLD + "Hotkey mode:|r " + WUI_TEXT + "click a skill or an item, then press its new key. Click the keyboard button again when done.|r")
        else
            call DisplayTimedTextToPlayer(p, 0, 0, 1.50, WUI_GOLD + "Hotkey mode closed.|r")
        endif
        if GetLocalPlayer() == p then
            call PauseTimer(WUI_PulseTimer)
        endif
    else
        loop
            exitwhen slot >= WUI_SLOT_KEYS
            if clicked == WUI_SlotOverlay[slot] then
                exitwhen true
            endif
            set slot = slot + 1
        endloop
        if slot < WUI_SLOT_KEYS then
            if WUI_HotkeyEdit[pid] then
                call WUI_StartSlotCapture(p, slot)
            elseif GetLocalPlayer() == p then
                call WUI_UseSlot(slot)
            endif
        endif
    endif
    if GetLocalPlayer() == p then
        call BlzFrameSetEnable(clicked, false)
        call BlzFrameSetEnable(clicked, true)
        call WUI_RefreshSlotBadges()
    endif
    set p = null
    set clicked = null
endfunction

// Allocated once on every client (WUI_OnReady). Toggle sits in the free right
// part of the stats column (next to the STR/AGI/INT rows).
private function WUI_CreateHotkeyEditor takes nothing returns nothing
    local integer slot = 0
    local integer pid = 0
    local framehandle part
    local real x
    local real y
    local real size
    call WUI_InitKeyTable()
    set WUI_SlotKeyTrigger = CreateTrigger()
    call TriggerAddAction(WUI_SlotKeyTrigger, function WUI_OnSlotKey)
    set WUI_SlotClick = CreateTrigger()
    call TriggerAddAction(WUI_SlotClick, function WUI_OnSlotClick)
    loop
        exitwhen pid >= 16
        set WUI_SlotCapture[pid] = -1
        set WUI_HotkeyEdit[pid] = false
        set slot = 0
        loop
            exitwhen slot >= WUI_SLOT_KEYS
            set WUI_SlotKeyName[pid * WUI_SLOT_KEYS + slot] = ""
            set slot = slot + 1
        endloop
        set pid = pid + 1
    endloop
    set WUI_HotkeyToggle = WUI_ToggleButton("WOSHotkeyToggle", WUI_TOGGLE_X, WUI_TOGGLE_HOTKEY_Y, WUI_TOGGLE_SIZE, "UI\\WOS\\glyph-keyboard.tga")
    call WUI_Tooltip(WUI_HotkeyToggle, "|cffd5b876CHANGE HOTKEYS|r|nClick an ability or item, then press a key.|nEsc cancels, Backspace removes it.|nClick here again to finish.")
    call BlzTriggerRegisterFrameEvent(WUI_SlotClick, WUI_HotkeyToggle, FRAMEEVENT_CONTROL_CLICK)
    set slot = 0
    loop
        exitwhen slot >= WUI_SLOT_KEYS
        set x = WUI_SlotX(slot)
        set y = WUI_SlotY(slot)
        set size = WUI_SlotSize(slot)
        // Edit overlay above the icon (normal frames draw over native buttons,
        // so the click never reaches the ability/item while editing).
        set WUI_SlotOverlay[slot] = BlzCreateFrameByType("BUTTON", "WOSHotkeySlot", WUI_Root, "", slot)
        call WUI_PlaceShift(WUI_SlotOverlay[slot], x - WUI_HudShift, y, size, size)
        call BlzFrameSetLevel(WUI_SlotOverlay[slot], 45)
        set WUI_SlotOverlayEdge[slot] = BlzCreateFrameByType("BACKDROP", "WOSHotkeySlotEdge", WUI_SlotOverlay[slot], "", slot)
        call BlzFrameSetPoint(WUI_SlotOverlayEdge[slot], FRAMEPOINT_TOPLEFT, WUI_SlotOverlay[slot], FRAMEPOINT_TOPLEFT, -0.0025, 0.0025)
        call BlzFrameSetPoint(WUI_SlotOverlayEdge[slot], FRAMEPOINT_BOTTOMRIGHT, WUI_SlotOverlay[slot], FRAMEPOINT_BOTTOMRIGHT, 0.0025, -0.0025)
        call BlzFrameSetTexture(WUI_SlotOverlayEdge[slot], "UI\\WOS\\learn-glow.tga", 0, true)
        call BlzFrameSetEnable(WUI_SlotOverlayEdge[slot], false)
        call BlzTriggerRegisterFrameEvent(WUI_SlotClick, WUI_SlotOverlay[slot], FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetVisible(WUI_SlotOverlay[slot], false)
        // Custom key badge in the top-right corner (the stock key letter stays
        // top-left), shown whenever a custom key is bound.
        set WUI_SlotBadge[slot] = BlzCreateFrameByType("BACKDROP", "WOSHotkeySlotBadge", WUI_Root, "", slot)
        call BlzFrameSetPoint(WUI_SlotBadge[slot], FRAMEPOINT_CENTER, WUI_SlotOverlay[slot], FRAMEPOINT_TOPRIGHT, -0.0035, -0.0035)
        call BlzFrameSetSize(WUI_SlotBadge[slot], 0.0115, 0.0115)
        call BlzFrameSetTexture(WUI_SlotBadge[slot], "UI\\WOS\\keycap.tga", 0, true)
        call BlzFrameSetLevel(WUI_SlotBadge[slot], 46)
        call BlzFrameSetEnable(WUI_SlotBadge[slot], false)
        set WUI_SlotBadgeText[slot] = BlzCreateFrameByType("TEXT", "WOSHotkeySlotBadgeText", WUI_SlotBadge[slot], "", slot)
        call BlzFrameSetAllPoints(WUI_SlotBadgeText[slot], WUI_SlotBadge[slot])
        call BlzFrameSetTextAlignment(WUI_SlotBadgeText[slot], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetScale(WUI_SlotBadgeText[slot], 0.62)
        call BlzFrameSetEnable(WUI_SlotBadgeText[slot], false)
        call BlzFrameSetVisible(WUI_SlotBadge[slot], false)
        set slot = slot + 1
    endloop
    // Hint plate above the ability row while editing.
    set WUI_HotkeyHint = WUI_Panel("WOSHotkeyHint", WUI_Root, 0.330, 0.022)
    call WUI_PlaceShift(WUI_HotkeyHint, 0.511, 0.1095, 0.330, 0.022)
    call BlzFrameSetTexture(WUI_HotkeyHint, "UI\\WOS\\panel-soft.tga", 0, true)
    call BlzFrameSetEnable(WUI_HotkeyHint, false)
    set part = WUI_GoldFrame("WOSHotkeyHintEdge", WUI_HotkeyHint, 0.0030, 0.0070)
    set part = BlzCreateFrameByType("TEXT", "WOSHotkeyHintText", WUI_HotkeyHint, "", 0)
    call BlzFrameSetAllPoints(part, WUI_HotkeyHint)
    call BlzFrameSetTextAlignment(part, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(part, 0.74)
    call BlzFrameSetText(part, WUI_GOLD + "HOTKEY MODE|r  " + WUI_TEXT + "click a skill or item, press a key  |  Esc cancel  |  Backspace remove  |  keyboard button = done|r")
    call BlzFrameSetEnable(part, false)
    call BlzFrameSetVisible(WUI_HotkeyHint, false)
    set part = null
endfunction

// One opaque native-family graphite surface (below native buttons), placed by
// its two corners. Context ids are fixed so every client allocates the same.
private function WUI_NativeSurface takes integer context, real left, real bottom, real right, real top returns framehandle
    local framehandle surface = BlzCreateSimpleFrame("WOSNativeHUDSurface", WUI_SimpleRoot, context)
    local framehandle texture = BlzGetFrameByName("WOSNativeHUDTexture", context)
    call BlzFrameClearAllPoints(surface)
    call BlzFrameSetAbsPoint(surface, FRAMEPOINT_BOTTOMLEFT, left, bottom)
    call BlzFrameSetAbsPoint(surface, FRAMEPOINT_TOPRIGHT, right, top)
    call BlzFrameSetLevel(surface, 1)
    if texture != null then
        call BlzFrameSetTexture(texture, WUI_PANEL_TEXTURE, 0, true)
    endif
    call BlzFrameSetVisible(surface, true)
    set texture = null
    return surface
endfunction

private function WUI_NativeSlot takes integer context, real x, real y, real size returns framehandle
    local framehandle slot = BlzCreateSimpleFrame("WOSNativeEmptyAbility", WUI_SimpleRoot, context)
    call WUI_PlaceShift(slot, x - WUI_HudShift, y, size, size)
    call BlzFrameSetLevel(slot, 1)
    return slot
endfunction

// Layout (4:3 units). Left to right: minimap block | portrait | stats | vitals +
// one ability row + pips | 3x2 items | gold + 3x2 toolbar. No transparent gaps:
// every section sits on the same graphite chassis, separated by thin dividers.
private function WUI_CreateHUDChrome takes nothing returns nothing
    local framehandle panel
    local framehandle edge
    local integer slot = 0
    // Normal FRAMEs draw over native SIMPLEFRAME buttons. Their ornament center
    // must remain empty; opaque surfaces are created in the native family.
    if WUI_SimpleRoot != null and WUI_FrameDefinitionsReady then
        set WUI_NativeBack = WUI_NativeSurface(9050, WUI_CHASSIS_LEFT, 0.000, WUI_CHASSIS_RIGHT, WUI_CHASSIS_TOP)
        // Minimap block: fill only around the native minimap (never under it),
        // so the stock minimap keeps its own draw level.
        set edge = WUI_NativeSurface(9051, 0.004 + WUI_MINIMAP_SIZE, 0.000, WUI_MINIMAP_RIGHT, WUI_MINIMAP_TOP)
        call WUI_RectShiftLeft(edge, 0.004 + WUI_MINIMAP_SIZE, 0.000, WUI_MINIMAP_RIGHT, WUI_MINIMAP_TOP)
        set edge = WUI_NativeSurface(9052, 0.000, 0.004 + WUI_MINIMAP_SIZE, 0.004 + WUI_MINIMAP_SIZE, WUI_MINIMAP_TOP)
        call WUI_RectShiftLeft(edge, 0.000, 0.004 + WUI_MINIMAP_SIZE, 0.004 + WUI_MINIMAP_SIZE, WUI_MINIMAP_TOP)
        set edge = WUI_NativeSurface(9053, 0.000, 0.000, 0.004, 0.004 + WUI_MINIMAP_SIZE)
        call WUI_RectShiftLeft(edge, 0.000, 0.000, 0.004, 0.004 + WUI_MINIMAP_SIZE)
        set edge = WUI_NativeSurface(9054, 0.004, 0.000, 0.004 + WUI_MINIMAP_SIZE, 0.004)
        call WUI_RectShiftLeft(edge, 0.004, 0.000, 0.004 + WUI_MINIMAP_SIZE, 0.004)
        loop
            exitwhen slot >= 7
            set WUI_EmptyAbility[slot] = WUI_NativeSlot(9060 + slot, WUI_AbilityX(slot), WUI_AbilityY(slot), WUI_ICON_SIZE)
            call BlzFrameSetVisible(WUI_EmptyAbility[slot], WUI_CompactCommands)
            set slot = slot + 1
        endloop
        // Recessed empty item cells below the six native item buttons.
        set slot = 0
        loop
            exitwhen slot >= 6
            set edge = WUI_NativeSlot(9070 + slot, WUI_ItemX(slot), WUI_ItemY(slot), WUI_ITEM_SIZE)
            call BlzFrameSetVisible(edge, true)
            set slot = slot + 1
        endloop
    endif
    // Transparent normal-family ornaments only (never opaque over native buttons).
    set panel = WUI_Passive("WOSHUDSurface", WUI_Root)
    call BlzFrameClearAllPoints(panel)
    call BlzFrameSetAbsPoint(panel, FRAMEPOINT_BOTTOMLEFT, WUI_CHASSIS_LEFT, 0.000)
    call BlzFrameSetAbsPoint(panel, FRAMEPOINT_TOPRIGHT, WUI_CHASSIS_RIGHT, WUI_CHASSIS_TOP)
    call BlzFrameSetEnable(panel, false)
    set edge = WUI_OrnateBorderEx("WOSHUDMetal", panel, 0.022, 11)
    set edge = WUI_Divider("WOSHUDDivider", panel, 0.2285, 0.047, 0.078, true)
    call WUI_PlaceShiftLeft(edge, 0.2285, 0.047, 0.004, 0.078)
    set WUI_HudPanel = panel
    set edge = WUI_Divider("WOSHUDDivider", panel, 0.3355, 0.047, 0.078, true)
    call WUI_PlaceShift(edge, 0.3355, 0.047, 0.004, 0.078)
    set edge = WUI_Divider("WOSHUDDivider", panel, 0.6230, 0.047, 0.078, true)
    call WUI_PlaceShift(edge, 0.6230, 0.047, 0.004, 0.078)
    set edge = WUI_Divider("WOSHUDDivider", panel, 0.7290, 0.047, 0.078, true)
    call WUI_PlaceShift(edge, 0.7290, 0.047, 0.004, 0.078)
    set edge = WUI_Divider("WOSHUDDivider", panel, 0.7790, 0.0655, 0.084, false)
    call WUI_PlaceShift(edge, 0.7790, 0.0655, 0.084, 0.004)
    // "INVENTORY" title with gold flourishes above the 3x2 item grid.
    set edge = BlzCreateFrameByType("TEXT", "WOSInventoryTitle", panel, "", 0)
    // Scale also shrinks the box, so size / scale keeps a .068 wide label.
    // Right part of the header: the Autobuy toggle sits on the left.
    call WUI_PlaceShift(edge, WUI_ITEM_X + 0.0245, 0.0858, 0.054 / 0.66, 0.011 / 0.66)
    call BlzFrameSetScale(edge, 0.66)
    call BlzFrameSetTextAlignment(edge, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetText(edge, "|cffe9cf8fINVENTORY|r")
    call BlzFrameSetEnable(edge, false)
    set panel = WUI_Passive("WOSMinimapSurface", WUI_Root)
    call WUI_RectShiftLeft(panel, 0.000, 0.000, WUI_MINIMAP_RIGHT, WUI_MINIMAP_TOP)
    call BlzFrameSetEnable(panel, false)
    set edge = WUI_OrnateBorderEx("WOSMinimapMetal", panel, 0.024, 7)
    set WUI_MinimapStub = BlzCreateFrameByType("BACKDROP", "WOSMinimapStub", panel, "", 0)
    call WUI_RectShiftLeft(WUI_MinimapStub, 0.004, 0.004, 0.004 + WUI_MINIMAP_SIZE, 0.004 + WUI_MINIMAP_SIZE)
    call BlzFrameSetTexture(WUI_MinimapStub, "war3mapMap.blp", 0, true)
    call BlzFrameSetEnable(WUI_MinimapStub, false)
    call BlzFrameSetVisible(WUI_MinimapStub, WUI_OriginHidden)
    // Ally-colour button skin: passive backdrops only, so clicks and the
    // stock tooltip still belong to the native button underneath.
    set edge = WUI_Piece("WOSAllyColorFill", panel, WUI_FILL_NORMAL)
    call WUI_Place(edge, WUI_ALLY_COLOR_X, WUI_ALLY_COLOR_Y, WUI_ALLY_COLOR_SIZE, WUI_ALLY_COLOR_SIZE)
    set edge = WUI_Piece("WOSAllyColorGlyph", panel, "UI\\WOS\\glyph-allycolor.tga")
    call WUI_Place(edge, WUI_ALLY_COLOR_X, WUI_ALLY_COLOR_Y, WUI_ALLY_COLOR_SIZE - 0.004, WUI_ALLY_COLOR_SIZE - 0.004)
    set edge = WUI_Passive("WOSAllyColorEdgeOwner", panel)
    call WUI_Place(edge, WUI_ALLY_COLOR_X, WUI_ALLY_COLOR_Y, WUI_ALLY_COLOR_SIZE, WUI_ALLY_COLOR_SIZE)
    call BlzFrameSetEnable(edge, false)
    set edge = WUI_GoldFrame("WOSAllyColorEdge", edge, 0.0026, 0.0050)
    set panel = null
    set edge = null
endfunction

private function WUI_TryNativeLayout takes nothing returns nothing
    call WUI_InstallNativeLayout()
    if WUI_NativeReady then
        call PauseTimer(WUI_NativeTimer)
        call WUI_LayoutCommands(WUI_CompactCommands)
    endif
endfunction

function WUI_StartNativeLayout takes nothing returns nothing
    call WUI_TryNativeLayout()
    if not WUI_NativeReady then
        call TimerStart(WUI_NativeTimer, 0.25, true, function WUI_TryNativeLayout)
    endif
endfunction

// Hero-pick/draft owners call BlzHideOriginFrames(false) when returning to play.
// That engine call restores stock bars too; reapply the compact skin afterwards.
// Synced call (Systems1 HideBottomUI): every client runs it, only the given
// player's client re-applies its own presentation (cached frames only, no
// lookups, no handle creation).
function WUI_RestoreCompactNative takes player p returns nothing
    local integer i = 0
    if not WUI_NativeReady or GetLocalPlayer() != p then
        return
    endif
    if WUI_Console != null then
        call BlzFrameSetVisible(WUI_Console, false)
    endif
    if WUI_TopConsole != null then
        call BlzFrameSetVisible(WUI_TopConsole, false)
    endif
    if WUI_BottomConsole != null then
        call BlzFrameSetVisible(WUI_BottomConsole, false)
    endif
    if WUI_Resource != null then
        call WUI_ParkResourceBar()
    endif
    if WUI_HeroBar != null then
        call BlzFrameSetVisible(WUI_HeroBar, false)
    endif
    if WUI_Portrait != null then
        call BlzFrameSetVisible(WUI_Portrait, false)
    endif
    call BlzFrameSetVisible(WUI_CommandBar, true)
    call BlzFrameSetVisible(WUI_NativeDetailParent, true)
    call WUI_HideNativeDeadZone()
    // The engine re-shows the minimap buttons with the origin frames.
    set i = 0
    loop
        exitwhen i >= 5
        if WUI_MinimapButton[i] != null then
            call BlzFrameSetVisible(WUI_MinimapButton[i], i == WUI_ALLY_COLOR_BUTTON)
        endif
        set i = i + 1
    endloop
    if WUI_AllyColor != null then
        call WUI_Place(WUI_AllyColor, WUI_ALLY_COLOR_X + WUI_HudLeft, WUI_ALLY_COLOR_Y, WUI_ALLY_COLOR_SIZE, WUI_ALLY_COLOR_SIZE)
    endif
    if WUI_NativeBack != null then
        call BlzFrameSetVisible(WUI_NativeBack, true)
    endif
    call WUI_LayoutCommands(WUI_CompactCommands)
endfunction

private function WUI_CreateControls takes nothing returns nothing
    local integer i = 0
    local framehandle text
    local framehandle back
    local framehandle label
    local trigger events = CreateTrigger()
    set WUI_Console = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    set WUI_TopConsole = BlzGetFrameByName("ConsoleTopBar", 0)
    set WUI_BottomConsole = BlzGetFrameByName("ConsoleBottomBar", 0)
    set WUI_NativeTooltip = BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP, 0)
    set WUI_Portrait = BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT, 0)
    set WUI_Resource = BlzGetFrameByName("ResourceBarFrame", 0)
    set WUI_ResourceText[0] = BlzGetFrameByName("ResourceBarGoldText", 0)
    set WUI_ResourceText[1] = BlzGetFrameByName("ResourceBarLumberText", 0)
    set WUI_ResourceText[2] = BlzGetFrameByName("ResourceBarSupplyText", 0)
    set WUI_ResourceText[3] = BlzGetFrameByName("ResourceBarUpkeepText", 0)
    call WUI_CacheResourceMouse()
    set WUI_HeroBar = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BAR, 0)
    set WUI_SystemBar = BlzGetFrameByName("UpperButtonBarFrame", 0)
    set i = 0
    loop
        exitwhen i >= 7
        set WUI_HeroButton[i] = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, i)
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 5
        set WUI_MinimapButton[i] = BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP_BUTTON, i)
        set i = i + 1
    endloop
    set WUI_Buffs = BlzGetOriginFrame(ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR, 0)
    // A native SimpleFontString cannot safely receive visibility/alpha calls.
    set label = BlzGetOriginFrame(ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR_LABEL, 0)
    if label != null then
        call BlzFrameSetText(label, "")
    endif
    if WUI_SimpleRoot != null then
        if BlzFrameGetChildrenCount(WUI_SimpleRoot) > 5 then
            set WUI_DeadZone = BlzFrameGetChild(WUI_SimpleRoot, 5)
        endif
    endif
    call WUI_CacheNativeSlots()
    set i = 0
    loop
        exitwhen i >= 4
        set WUI_System[i] = BlzGetOriginFrame(ORIGIN_FRAME_SYSTEM_BUTTON, i)
        set i = i + 1
    endloop
    // One passive graphite strip integrates menu, stats, link and music.
    set back = WUI_Panel("WOSTopActionsPanel", WUI_Root, 0.180, 0.072)
    call WUI_Place(back, WUI_ScreenRight() - 0.090, 0.570, 0.180, 0.060)
    call BlzFrameSetEnable(back, false)
    call WUI_RegisterTopControl(back)
    // Checkpoint 26b: quiet edge like the text buttons below it.
    call WUI_MinimalEdge(back)
    set WUI_Menu = BlzCreateFrameByType("BUTTON", "WOSCompactMenu", WUI_Root, "WOSIconButtonTemplate", 0)
    call WUI_RegisterTopControl(WUI_Menu)
    call WUI_Place(WUI_Menu, WUI_TopActionX(0), 0.578, 0.035, 0.034)
    set text = BlzCreateFrameByType("TEXT", "WOSMenuGlyph", WUI_Menu, "", 0)
    call WUI_Place(text, WUI_TopActionX(0), 0.5645, 0.035, 0.010)
    call BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetText(text, WUI_GOLD + "Menu|r")
    call BlzFrameSetScale(text, 0.62)
    call BlzFrameSetEnable(text, false)
    // Active (open) look: warm gold plate behind the glyph + label.
    set WUI_MenuActive = BlzCreateFrameByType("BACKDROP", "WOSMenuActive", WUI_Menu, "", 0)
    call WUI_Place(WUI_MenuActive, WUI_TopActionX(0), 0.5765, 0.038, 0.034)
    call BlzFrameSetTexture(WUI_MenuActive, "UI\\WOS\\learn-glow.tga", 0, true)
    call BlzFrameSetEnable(WUI_MenuActive, false)
    call BlzFrameSetVisible(WUI_MenuActive, false)
    // Checkpoint 22: gold glyph like Stats / Link / Music next to it.
    set back = BlzCreateFrameByType("BACKDROP", "WOSMenuGlyphIcon", WUI_Menu, "", 0)
    call WUI_Place(back, WUI_TopActionX(0), 0.584, 0.020, 0.020)
    call BlzFrameSetTexture(back, "UI\\WOS\\glyph-menu.tga", 0, true)
    call BlzFrameSetEnable(back, false)
    set i = 0
    loop
        exitwhen i >= 4
        set text = BlzCreateFrameByType("TEXT", "WOSTopActionLabel", WUI_Root, "", i)
        call WUI_RegisterTopControl(text)
        call WUI_Place(text, WUI_TopActionX(i + 1), 0.5645, 0.034 / 0.62, 0.010 / 0.62)
        call BlzFrameSetScale(text, 0.62)
        call BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetEnable(text, false)
        if i == 0 then
            call BlzFrameSetText(text, WUI_GOLD + "Stats|r")
        elseif i == 1 then
            call BlzFrameSetText(text, WUI_GOLD + "History|r")
        elseif i == 2 then
            call BlzFrameSetText(text, WUI_GOLD + "Link|r")
        else
            call BlzFrameSetText(text, WUI_GOLD + "Music|r")
        endif
        set i = i + 1
    endloop
    // Stats = the F2 statistics window (Scoreboard registers the click).
    set WUI_StatsButton = BlzCreateFrameByType("BUTTON", "WOSTopStatsButton", WUI_Root, "WOSIconButtonTemplate", 0)
    call WUI_RegisterTopControl(WUI_StatsButton)
    call WUI_Place(WUI_StatsButton, WUI_TopActionX(1), 0.584, 0.022, 0.022)
    set back = BlzCreateFrameByType("BACKDROP", "WOSTopStatsIcon", WUI_StatsButton, "", 0)
    call BlzFrameSetAllPoints(back, WUI_StatsButton)
    call BlzFrameSetTexture(back, "UI\\WOS\\glyph-stats.tga", 0, true)
    call BlzFrameSetEnable(back, false)
    // The F2 badge is the rebindable hotkey badge (Scoreboard registers it).
    call WUI_TooltipBelowLeft(WUI_StatsButton, "|cffd5b876STATISTICS|r|nDamage, healing and items of every player.")
    // Drawer handle: a small styled tab sitting on the chassis top rail.
    set WUI_Orders = WUI_TextButton("WOSOrderDrawer", WUI_Root, "Orders", 0.056, 0.014)
    call WUI_PlaceShift(WUI_Orders, 0.588, 0.1015, 0.056, 0.014)
    call WUI_SetButtonTextScale(WUI_Orders, 0.72)
    call WUI_SetButtonCaption(WUI_Orders, WUI_GOLD + "Orders")
    call BlzFrameSetVisible(WUI_Orders, WUI_SHOW_ORDERS)
    call BlzTriggerRegisterFrameEvent(events, WUI_Menu, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(events, WUI_Orders, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(events, function WUI_ControlClick)
    set i = 0
    loop
        exitwhen i >= 4
        call WUI_Place(WUI_System[i], -0.20, -0.20, 0.110, 0.021)
        set i = i + 1
    endloop
    // Native-family skins (WOSControls.fdf) sit above the stock buttons; they
    // have no button, so clicks still reach the real Menu/Allies/Log buttons.
    set i = 0
    loop
        exitwhen i >= 3
        set WUI_MenuSkin[i] = null
        if WUI_SimpleRoot != null and WUI_FrameDefinitionsReady then
            set WUI_MenuSkin[i] = BlzCreateSimpleFrame("WOSNativeMenuSkin", WUI_SimpleRoot, 9080 + i)
        endif
        if WUI_MenuSkin[i] != null then
            call WUI_Place(WUI_MenuSkin[i], WUI_ScreenRight() - 0.090, WUI_MenuRowY(i), 0.160, 0.0200)
            call BlzFrameSetLevel(WUI_MenuSkin[i], 8)
            // Each row is a separate bevelled button (8:1 art, no stretching).
            call BlzFrameSetTexture(BlzGetFrameByName("WOSNativeMenuSkinEdge", 9080 + i), "UI\\WOS\\menu-row.tga", 0, true)
            set WUI_MenuSkinFill[i] = BlzGetFrameByName("WOSNativeMenuSkinFill", 9080 + i)
            set WUI_MenuSkinText[i] = BlzGetFrameByName("WOSNativeMenuSkinText", 9080 + i)
            set text = WUI_MenuSkinText[i]
            if i == 0 then
                call BlzFrameSetText(text, "Menu  |cffd5b876[F10]|r")
            elseif i == 1 then
                call BlzFrameSetText(text, "Allies  |cffd5b876[F11]|r")
            else
                call BlzFrameSetText(text, "Log  |cffd5b876[F12]|r")
            endif
            call BlzFrameSetVisible(WUI_MenuSkin[i], false)
        endif
        // FRAME twin (passive: clicks still reach the stock button below).
        set WUI_MenuSkinF[i] = BlzCreateFrameByType("BACKDROP", "WOSMenuSkinFrame", WUI_Root, "", i)
        call WUI_Place(WUI_MenuSkinF[i], WUI_ScreenRight() - 0.090, WUI_MenuRowY(i), 0.160, 0.0200)
        call BlzFrameSetTexture(WUI_MenuSkinF[i], WUI_FILL_NORMAL, 0, true)
        call BlzFrameSetLevel(WUI_MenuSkinF[i], 45)
        call BlzFrameSetEnable(WUI_MenuSkinF[i], false)
        set label = BlzCreateFrameByType("BACKDROP", "WOSMenuSkinFrameEdge", WUI_MenuSkinF[i], "", i)
        call BlzFrameSetAllPoints(label, WUI_MenuSkinF[i])
        call BlzFrameSetTexture(label, "UI\\WOS\\menu-row.tga", 0, true)
        call BlzFrameSetEnable(label, false)
        set label = BlzCreateFrameByType("TEXT", "WOSMenuSkinFrameText", WUI_MenuSkinF[i], "", i)
        call BlzFrameSetAllPoints(label, WUI_MenuSkinF[i])
        call BlzFrameSetTextAlignment(label, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetScale(label, 0.95)
        call BlzFrameSetEnable(label, false)
        if i == 0 then
            call BlzFrameSetText(label, WUI_TEXT + "Menu  |cffd5b876[F10]|r")
        elseif i == 1 then
            call BlzFrameSetText(label, WUI_TEXT + "Allies  |cffd5b876[F11]|r")
        else
            call BlzFrameSetText(label, WUI_TEXT + "Log  |cffd5b876[F12]|r")
        endif
        call BlzFrameSetVisible(WUI_MenuSkinF[i], false)
        set i = i + 1
    endloop
    // One native-family surface under the three rows (native buttons draw
    // above it), flush ornate rails outside and thin dividers between rows.
    if WUI_SimpleRoot != null and WUI_FrameDefinitionsReady then
        set WUI_MenuDrop = WUI_NativeSurface(9090, WUI_ScreenRight() - 0.180, WUI_MenuRowY(2) - 0.0145, WUI_ScreenRight(), WUI_MENU_DROP_TOP)
        call BlzFrameSetLevel(WUI_MenuDrop, 1)
        call BlzFrameSetVisible(WUI_MenuDrop, false)
    endif
    set WUI_MenuDropMetal = WUI_Passive("WOSMenuDropFrame", WUI_Root)
    call BlzFrameClearAllPoints(WUI_MenuDropMetal)
    call BlzFrameSetAbsPoint(WUI_MenuDropMetal, FRAMEPOINT_BOTTOMLEFT, WUI_ScreenRight() - 0.180, WUI_MenuRowY(2) - 0.0145)
    call BlzFrameSetAbsPoint(WUI_MenuDropMetal, FRAMEPOINT_TOPRIGHT, WUI_ScreenRight(), WUI_MENU_DROP_TOP)
    call BlzFrameSetEnable(WUI_MenuDropMetal, false)
    // Same quiet edge as the top-right action block above it.
    call WUI_MinimalEdge(WUI_MenuDropMetal)
    call BlzFrameSetVisible(WUI_MenuDropMetal, false)
    set text = null
    set back = null
    set label = null
    set events = null
endfunction

// Only for a solo session: Player 1 is the one human player in the game.
private function WUI_RestartAllowed takes nothing returns boolean
    local integer i = 1
    if not WUI_SHOW_RESTART or GetPlayerSlotState(Player(0)) != PLAYER_SLOT_STATE_PLAYING or GetPlayerController(Player(0)) != MAP_CONTROL_USER then
        return false
    endif
    loop
        exitwhen i >= bj_MAX_PLAYERS
        if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(i)) == MAP_CONTROL_USER then
            return false
        endif
        set i = i + 1
    endloop
    return true
endfunction

// Restart the map (stock RestartGame, no score screen).
private function WUI_RestartClick takes nothing returns nothing
    if GetTriggerPlayer() != Player(0) or not WUI_RestartAllowed() then
        return
    endif
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetEnable(WUI_Restart, false)
    endif
    call RestartGame(false)
endfunction

private function WUI_CreateRestart takes nothing returns nothing
    local trigger click
    local real left = 0.400 - 0.300 * I2R(BlzGetLocalClientWidth()) / RMaxBJ(1.00, I2R(BlzGetLocalClientHeight()))
    // Synced condition (same on every client), so the frame is created only
    // in a solo game of Player 1 and never shows for anybody else.
    if not WUI_RestartAllowed() then
        return
    endif
    set WUI_Restart = WUI_TextButton("WOSRestartButton", WUI_Root, "Restart", 0.062, 0.020)
    // Presentation-only X: the left edge of a wide screen is negative.
    call WUI_Place(WUI_Restart, left + 0.040, 0.585, 0.062, 0.020)
    call WUI_SetButtonTextScale(WUI_Restart, 0.80)
    call WUI_SetButtonCaption(WUI_Restart, WUI_GOLD + "Restart")
    call WUI_TooltipBelow(WUI_Restart, "|cffd5b876RESTART|r|nRestart map.")
    call WUI_RegisterTopControl(WUI_Restart)
    set click = CreateTrigger()
    call BlzTriggerRegisterFrameEvent(click, WUI_Restart, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(click, function WUI_RestartClick)
    set click = null
endfunction

private function WUI_TestClick takes nothing returns nothing
    if GetLocalPlayer() == GetTriggerPlayer() then
        set WUI_TestOpen = not WUI_TestOpen
        call BlzFrameSetVisible(WUI_TestPanel, WUI_TestOpen)
        call WUI_LayoutRightColumn()
        call BlzFrameSetEnable(WUI_TestToggle, false)
        call BlzFrameSetEnable(WUI_TestToggle, true)
    endif
endfunction

function WUI_ShowTestHelp takes boolean enabled returns nothing
    set WUI_TestEnabled = enabled
    call WUI_RefreshHelpVisibility()
endfunction

// Visible characters of a line (colour codes skipped) -> wrapped rows.
private function WUI_TestRows takes string line returns integer
    local integer i = 0
    local integer length = StringLength(line)
    local integer visible = 0
    loop
        exitwhen i >= length
        if SubString(line, i, i + 2) == "|c" then
            set i = i + 10
        elseif SubString(line, i, i + 2) == "|r" then
            set i = i + 2
        else
            set visible = visible + 1
            set i = i + 1
        endif
    endloop
    if visible <= WUI_TEST_CHARS then
        return 1
    endif
    return (visible + WUI_TEST_CHARS - 1) / WUI_TEST_CHARS
endfunction

private function WUI_TestSplit takes integer page returns nothing
    local string text = WUI_TestPage[page]
    local integer i = 0
    local integer start = 0
    local integer count = 0
    local integer length = StringLength(text)
    loop
        exitwhen i > length
        if i == length or SubString(text, i, i + 2) == "|n" then
            set WUI_TestLine[page * 40 + count] = SubString(text, start, i)
            set count = count + 1
            set i = i + 2
            set start = i
        else
            set i = i + 1
        endif
        exitwhen count >= 40
    endloop
    set WUI_TestLineCount[page] = count
endfunction

// Largest first line that still lets the rest of the page fit.
private function WUI_TestMaxOffset takes integer page returns integer
    local integer i = WUI_TestLineCount[page] - 1
    local integer rows = 0
    loop
        exitwhen i < 0
        set rows = rows + WUI_TestRows(WUI_TestLine[page * 40 + i])
        if rows > WUI_TEST_ROWS then
            return i + 1
        endif
        set i = i - 1
    endloop
    return 0
endfunction

// Local presentation only.
private function WUI_TestRender takes nothing returns nothing
    local integer page = WUI_TestPageIndex
    local integer maximum = WUI_TestMaxOffset(page)
    local integer i
    local integer rows = 0
    local string text = ""
    set WUI_TestOffset = IMaxBJ(0, IMinBJ(WUI_TestOffset, maximum))
    set i = WUI_TestOffset
    loop
        exitwhen i >= WUI_TestLineCount[page]
        set rows = rows + WUI_TestRows(WUI_TestLine[page * 40 + i])
        exitwhen rows > WUI_TEST_ROWS and i > WUI_TestOffset
        if i > WUI_TestOffset then
            set text = text + "|n"
        endif
        set text = text + WUI_TestLine[page * 40 + i]
        set i = i + 1
    endloop
    call WUI_SetText(WUI_TestText, text)
    call WUI_SetText(WUI_TestPageLabel, I2S(page + 1) + " / " + I2S(WUI_TEST_PAGES) + "  -  mouse wheel: scroll")
    if WUI_TestSlider != null then
        call WUI_Show(WUI_TestSlider, maximum > 0)
        if maximum > 0 then
            set WUI_TestEcho = WUI_TestEcho + WUI_SliderSet(WUI_TestSlider, 0.00, I2R(maximum), I2R(maximum - WUI_TestOffset))
        endif
    endif
endfunction

private function WUI_TestScroll takes nothing returns nothing
    local framehandle source = BlzGetTriggerFrame()
    if GetLocalPlayer() == GetTriggerPlayer() then
        if source == WUI_TestPrevious then
            set WUI_TestPageIndex = IMaxBJ(0, WUI_TestPageIndex - 1)
            set WUI_TestOffset = 0
        elseif source == WUI_TestNext then
            set WUI_TestPageIndex = IMinBJ(WUI_TEST_PAGES - 1, WUI_TestPageIndex + 1)
            set WUI_TestOffset = 0
        elseif source == WUI_TestSlider and BlzGetTriggerFrameEvent() == FRAMEEVENT_SLIDER_VALUE_CHANGED then
            // Checkpoint 27e: a programmatic SetValue also fires this (synced)
            // event; ignore it when it does not change the offset, otherwise
            // render -> SetValue -> event looped forever (frame drops).
            if WUI_TestEcho > 0 then
                set WUI_TestEcho = WUI_TestEcho - 1
                set source = null
                return
            endif
            if WUI_TestMaxOffset(WUI_TestPageIndex) - R2I(BlzGetTriggerFrameValue() + 0.5) == WUI_TestOffset then
                set source = null
                return
            endif
            set WUI_TestOffset = WUI_TestMaxOffset(WUI_TestPageIndex) - R2I(BlzGetTriggerFrameValue() + 0.5)
        elseif BlzGetTriggerFrameValue() > 0.00 then
            set WUI_TestOffset = WUI_TestOffset - 1
        else
            set WUI_TestOffset = WUI_TestOffset + 1
        endif
        call WUI_TestRender()
    endif
    set source = null
endfunction

private function WUI_CreateTestHelp takes nothing returns nothing
    local framehandle back
    local trigger events = CreateTrigger()
    local trigger scroll = CreateTrigger()
    set WUI_TestPage[0] = "|cffd5b876UNITS, RECOVERY & WINDOWS|r|n|n|cffd5b876Arrow Left|r |cffe1e5ebCreate an enemy on the left.|r|n|cffd5b876Arrow Right|r |cffe1e5ebCreate a wounded ally.|r|n|cffd5b876Arrow Down|r |cffe1e5ebRoot yourself for 2 seconds.|r|n|cffd5b876Arrow Up|r |cffe1e5ebStun yourself for 2 seconds.|r|n|n|cffd5b876Esc|r |cffe1e5ebRestore HP, MP and cooldowns.|r|n|cffd5b876Hold Esc (0.15s+)|r |cffe1e5ebMaximum level.|r|n|n|cffd5b876Tab|r |cffe1e5ebShop; try Autobuy if you are new.|r|n|cffd5b876F2|r |cffe1e5ebOpen or close statistics.|r|n|cffd5b876F3 / F4|r |cffe1e5ebClear / load damage statistics.|r|n|cffd5b876Hold Z|r |cffe1e5ebSelect a sector, release to ping.|r|n|cffd5b876K|r |cffe1e5ebOpen the emote palette.|r"
    set WUI_TestPage[1] = "|cffd5b876SELECTED UNIT & TEST EFFECTS|r|n|n|cffd5b876-lvl X|r |cffe1e5ebSet level, e.g. -lvl 35.|r|n|cffd5b876-pr X|r |cffe1e5ebSet physical resistance %.|r|n|cffd5b876-mr X|r |cffe1e5ebSet magical resistance %.|r|n|cffd5b876-hp X / -mp X|r |cffe1e5ebSet current HP / MP.|r|n|cffd5b876-X|r |cffe1e5ebPlay animation X, e.g. -0.|r|n|n|cffd5b876-slow|r |cffe1e5ebSlow yourself by 50% for 4s.|r|n|cffd5b876-silence|r |cffe1e5ebSilence yourself for 3s.|r|n|cffd5b876-sukuna|r |cffe1e5ebSummon the round ender.|r|n|cffd5b876-killme|r |cffe1e5ebKill your hero after a delay.|r|n|cffd5b876-s1 / -s2|r |cffe1e5ebRimuru: skip to the next form (-s1 first, then -s2).|r|n|n|cffe1e5ebSelect your hero or an enemy before a unit command. You can also buy shop items for a selected enemy.|r"
    // Ordinary text needs no lazy-loaded stock FDF template.
    // Checkpoint 20: the block starts BELOW the Menu drawer (lowest drawer row
    // bottom is .4485), so opening Menu in Test Mode is never covered.
    set WUI_TestPanel = BlzCreateFrameByType("BUTTON", "WOSTestHelpPanel", WUI_Root, "", 0)
    call WUI_Place(WUI_TestPanel, WUI_ScreenRight() - 0.100, 0.3245, 0.188, 0.205)
    set back = WUI_Panel("WOSTestHelpBack", WUI_TestPanel, 0.188, 0.205)
    call BlzFrameSetAllPoints(back, WUI_TestPanel)
    call BlzFrameSetTexture(back, "UI\\WOS\\panel-soft.tga", 0, true)
    call BlzFrameSetEnable(back, false)
    // Checkpoint 26b: quiet divider edge like the top actions block.
    call WUI_MinimalEdge(WUI_TestPanel)
    set WUI_TestText = BlzCreateFrameByType("TEXT", "WOSTestHelpText", WUI_TestPanel, "", 0)
    call WUI_Place(WUI_TestText, WUI_ScreenRight() - 0.100, 0.3355, 0.172, 0.170)
    call BlzFrameSetTextAlignment(WUI_TestText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
    call BlzFrameSetScale(WUI_TestText, 0.80)
    call BlzFrameSetText(WUI_TestText, WUI_TestPage[0])
    call BlzFrameSetEnable(WUI_TestText, false)
    set WUI_TestPageLabel = BlzCreateFrameByType("TEXT", "WOSTestPageLabel", WUI_TestPanel, "", 0)
    // Size in scaled units (scale 0.64), otherwise the hint was cut off.
    call WUI_Place(WUI_TestPageLabel, WUI_ScreenRight() - 0.100, 0.2335, 0.140 / 0.64, 0.012 / 0.64)
    call BlzFrameSetTextAlignment(WUI_TestPageLabel, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(WUI_TestPageLabel, 0.64)
    call BlzFrameSetText(WUI_TestPageLabel, "1 / 2  -  mouse wheel: scroll")
    call BlzFrameSetEnable(WUI_TestPageLabel, false)
    set WUI_TestPrevious = WUI_TextButton("WOSTestPrevious", WUI_TestPanel, "<", 0.014, 0.014)
    call WUI_SetButtonMinimal(WUI_TestPrevious)
    set WUI_TestNext = WUI_TextButton("WOSTestNext", WUI_TestPanel, ">", 0.014, 0.014)
    call WUI_SetButtonMinimal(WUI_TestNext)
    call WUI_Place(WUI_TestPrevious, WUI_ScreenRight() - 0.183, 0.2335, 0.014, 0.014)
    call WUI_Place(WUI_TestNext, WUI_ScreenRight() - 0.017, 0.2335, 0.014, 0.014)
    set WUI_TestToggle = WUI_TextButton("WOSTestHelpToggle", WUI_Root, "TEST COMMANDS  +/-", 0.180, 0.018)
    call WUI_Place(WUI_TestToggle, WUI_ScreenRight() - 0.100, 0.4385, 0.188, 0.018)
    call WUI_SetButtonTextScale(WUI_TestToggle, 0.80)
    call WUI_SetButtonMinimal(WUI_TestToggle)
    call BlzTriggerRegisterFrameEvent(events, WUI_TestToggle, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(events, function WUI_TestClick)
    call BlzTriggerRegisterFrameEvent(scroll, WUI_TestPanel, FRAMEEVENT_MOUSE_WHEEL)
    call BlzTriggerRegisterFrameEvent(scroll, WUI_TestPrevious, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(scroll, WUI_TestNext, FRAMEEVENT_CONTROL_CLICK)
    // Checkpoint 27: styled vertical slider for long pages.
    if WUI_FrameDefinitionsReady then
        set WUI_TestSlider = BlzCreateFrame("WOSVerticalSlider", WUI_TestPanel, 0, 9153)
    endif
    if WUI_TestSlider != null then
        call BlzFrameSetStepSize(WUI_TestSlider, 1.00)
        call BlzFrameSetLevel(WUI_TestSlider, 20)
        call BlzFrameSetVisible(WUI_TestSlider, false)
        // The slider handles the wheel itself (value changed); no second wheel handler.
        call BlzTriggerRegisterFrameEvent(scroll, WUI_TestSlider, FRAMEEVENT_SLIDER_VALUE_CHANGED)
    endif
    call TriggerAddAction(scroll, function WUI_TestScroll)
    call WUI_TestSplit(0)
    call WUI_TestSplit(1)
    call WUI_TestRender()
    call WUI_ShowTestHelp(false)
    set back = null
    set events = null
    set scroll = null
endfunction

// ===== Checkpoint 22: stock FPS / Ping / APM line =====
// Its frame name is not documented, so it is found by its text and moved
// under the team strip (left half, the strip itself covered it). Local only:
// no frame is created, only an existing string is re-anchored.
private function WUI_HasFps takes string text returns boolean
    local integer i = 0
    local integer length = StringLength(text)
    loop
        exitwhen i + 3 > length
        if SubString(text, i, i + 3) == "FPS" or SubString(text, i, i + 3) == "fps" then
            return true
        endif
        set i = i + 1
    endloop
    return false
endfunction

private function WUI_FindFps takes framehandle parent, integer depth returns framehandle
    local integer i = 0
    local integer count
    local framehandle child
    local framehandle found = null
    if parent == null or depth > 5 then
        return null
    endif
    set count = BlzFrameGetChildrenCount(parent)
    loop
        exitwhen i >= count or found != null
        set child = BlzFrameGetChild(parent, i)
        if child != null then
            if WUI_HasFps(BlzFrameGetText(child)) then
                set found = child
            else
                set found = WUI_FindFps(child, depth + 1)
            endif
        endif
        set i = i + 1
    endloop
    set child = null
    return found
endfunction

private function WUI_DockFpsTick takes nothing returns nothing
    local framehandle line = null
    set WUI_FpsTries = WUI_FpsTries + 1
    // The player may type /fps at any time: keep watching the parked bar.
    set line = null
    if line != null and line != WUI_FpsLine then
        set WUI_FpsLine = line
        call BlzFrameClearAllPoints(line)
        call BlzFrameSetAbsPoint(line, FRAMEPOINT_LEFT, WUI_FPS_X, WUI_FPS_Y)
        call BlzFrameSetSize(line, 0.200, 0.012)
    endif
    set line = null
endfunction

// Stock escape-menu art is installed through CustomSkin at build time.
// No lazy stock-frame lookups or conditional frame creation after startup.

private function WUI_InfoRow takes integer row, string icon, string name, string text returns nothing
    if row >= WUI_INFO_ROWS then
        return
    endif
    if icon == "" then
        call BlzFrameSetVisible(WUI_InfoIcon[row], false)
        call BlzFrameSetVisible(WUI_InfoText[row], false)
        return
    endif
    // Checkpoint 25: full texture paths (the map's own BTN icons).
    call BlzFrameSetTexture(WUI_InfoIcon[row], icon, 0, true)
    call BlzFrameSetText(WUI_InfoText[row], WUI_GOLD + name + "|r|n" + WUI_TEXT + text + "|r")
    call BlzFrameSetVisible(WUI_InfoIcon[row], true)
    call BlzFrameSetVisible(WUI_InfoText[row], true)
endfunction

// Local.
private function WUI_InfoShowPage takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i >= WUI_INFO_ROWS
        call WUI_InfoRow(i, "", "", "")
        set i = i + 1
    endloop
    if WUI_InfoPage == 0 then
        call BlzFrameSetText(WUI_InfoTitle, WUI_GOLD + "ELEMENTS|r")
        call WUI_InfoRow(0, "ReplaceableTextures\\CommandButtons\\BTNElem_Fire.blp", "Fire  |cff7caefa[MAGIC]|r", "40 magic damage per second for 5 s.")
        call WUI_InfoRow(1, "ReplaceableTextures\\CommandButtons\\BTNElem_Water.blp", "Water  |cff7caefa[MAGIC]|r", "100 magic damage on hit and 10% slow for 5 s.")
        call WUI_InfoRow(2, "ReplaceableTextures\\CommandButtons\\BTNElem_Lightning.blp", "Lightning", "no damage: after 5 s a 0.6 s stun and 120 mana burned.")
    elseif WUI_InfoPage == 1 then
        call BlzFrameSetText(WUI_InfoTitle, WUI_GOLD + "ELEMENT COMBOS|r")
        call WUI_InfoRow(0, "ReplaceableTextures\\CommandButtons\\BTNElem_Wape.blp", "Vape (Water + Fire)  |cff7caefa[MAGIC]|r", "1.5 x main stat magic damage, +10% physical damage taken for 8 s.")
        call WUI_InfoRow(1, "ReplaceableTextures\\CommandButtons\\BTNElem_Overload.blp", "Overload (Lightning + Fire)  |cff7caefa[MAGIC]|r", "1.5 x main stat magic damage, 1.25 s stun (2.5 s lockout).")
        call WUI_InfoRow(2, "ReplaceableTextures\\CommandButtons\\BTNElem_Electrized.blp", "Electrized (Lightning + Water)  |cff7caefa[MAGIC]|r", "10% slow, 0.4 x main stat magic damage per second for 5 s.")
    elseif WUI_InfoPage == 2 then
        call BlzFrameSetText(WUI_InfoTitle, WUI_GOLD + "DESTRUCTIBLE DECOR|r")
        call WUI_InfoRow(0, "ReplaceableTextures\\CommandButtons\\BTNDECOR_Barrel.blp", "Red barrel  |cff7caefa[MAGIC]|r", "300 magic damage in 350 range, sets the ground on fire.")
        call WUI_InfoRow(1, "ReplaceableTextures\\CommandButtons\\BTNDECOR_WENDING.blp", "Vending machine  |cff7caefa[MAGIC]|r", "200 magic damage in 400 range, applies Lightning.")
        call WUI_InfoRow(2, "ReplaceableTextures\\CommandButtons\\BTNDECOR_CAR.blp", "Car  |cff7caefa[MAGIC]|r", "500 magic damage in 500 range and burns.")
        call WUI_InfoRow(3, "ReplaceableTextures\\CommandButtons\\BTNDECOR_Hydrant.blp", "Hydrant", "no damage: knocks enemies back in 350 range, applies Water.")
    else
        call BlzFrameSetText(WUI_InfoTitle, WUI_GOLD + "ROUND END|r")
        call WUI_InfoRow(0, "ReplaceableTextures\\CommandButtons\\BTNDECOR_TRAIN.blp", "Train  |cffd58cff[PURE]|r", "250 + 100 x round (now " + I2S(250 + CurrentRound * 100) + ") pure damage.")
        call WUI_InfoRow(1, "ReplaceableTextures\\CommandButtons\\BTNDECOR_TRAIN.blp", "Train wreck  |cffd58cff[PURE]|r", "500 + 125 x round (now " + I2S(500 + CurrentRound * 125) + ") pure damage in 650 range.")
        call WUI_InfoRow(2, "ReplaceableTextures\\CommandButtons\\BTNDECOR_TimeLIMIT.blp", "Time limit  |cffd58cff[PURE]|r", "outside the circle: 75 pure damage, +40 per tick, up to 1300.")
    endif
    call BlzFrameSetText(WUI_InfoPageLabel, WUI_GOLD + I2S(WUI_InfoPage + 1) + " / " + I2S(WUI_INFO_PAGES) + "|r")
endfunction

private function WUI_InfoClick takes nothing returns nothing
    if GetLocalPlayer() == GetTriggerPlayer() then
        if BlzGetTriggerFrame() == WUI_InfoButton then
            set WUI_InfoOpen = not WUI_InfoOpen
            call WUI_SetButtonSelected(WUI_InfoButton, WUI_InfoOpen)
        elseif BlzGetTriggerFrame() == WUI_InfoNext then
            set WUI_InfoPage = ModuloInteger(WUI_InfoPage + 1, WUI_INFO_PAGES)
        else
            set WUI_InfoPage = ModuloInteger(WUI_InfoPage + WUI_INFO_PAGES - 1, WUI_INFO_PAGES)
        endif
        call WUI_InfoShowPage()
        call WUI_LayoutRightColumn()
        call BlzFrameSetEnable(BlzGetTriggerFrame(), false)
        call BlzFrameSetEnable(BlzGetTriggerFrame(), true)
    endif
endfunction

// ===== Checkpoint 23: pick / ban feed (top-left) =====
// Replaces the chat lines of picks, bans and draft phases in every mode.
// Synced callers; every client shows the same lines.
private function WUI_FeedTick takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i >= WUI_FEED_LINES
        if WUI_FeedAge[i] > 0.00 then
            set WUI_FeedAge[i] = WUI_FeedAge[i] - 0.25
            if WUI_FeedAge[i] <= 0.00 then
                call BlzFrameSetVisible(WUI_FeedText[i], false)
            elseif WUI_FeedAge[i] < 1.00 then
                call BlzFrameSetAlpha(WUI_FeedText[i], R2I(255.00 * WUI_FeedAge[i]))
            endif
        endif
        set i = i + 1
    endloop
endfunction

function WUI_Feed takes string message, real seconds returns nothing
    local integer i = WUI_FEED_LINES - 1
    if WUI_FeedText[0] == null then
        set i = bj_MAX_PLAYER_SLOTS - 1
        loop
            exitwhen i < 0
            call DisplayTimedTextToPlayer(Player(i), 0, 0, seconds, message)
            set i = i - 1
        endloop
        return
    endif
    // Newest line on top; older ones move down.
    loop
        exitwhen i <= 0
        set WUI_FeedAge[i] = WUI_FeedAge[i - 1]
        set WUI_FeedMsg[i] = WUI_FeedMsg[i - 1]
        call BlzFrameSetText(WUI_FeedText[i], WUI_FeedMsg[i])
        call BlzFrameSetVisible(WUI_FeedText[i], WUI_FeedAge[i] > 0.00)
        call BlzFrameSetAlpha(WUI_FeedText[i], 255)
        set i = i - 1
    endloop
    set WUI_FeedAge[0] = RMaxBJ(8.00, seconds)
    set WUI_FeedMsg[0] = message
    call BlzFrameSetText(WUI_FeedText[0], message)
    call BlzFrameSetAlpha(WUI_FeedText[0], 255)
    call BlzFrameSetVisible(WUI_FeedText[0], true)
endfunction

private function WUI_CreateFeed takes nothing returns nothing
    local integer i = 0
    local real left = 0.400 - 0.300 * I2R(BlzGetLocalClientWidth()) / RMaxBJ(1.00, I2R(BlzGetLocalClientHeight()))
    loop
        exitwhen i >= WUI_FEED_LINES
        set WUI_FeedText[i] = BlzCreateFrameByType("TEXT", "WOSFeedLine", WUI_Root, "", i)
        call BlzFrameClearAllPoints(WUI_FeedText[i])
        // Presentation-only X: the left edge of a wide screen is negative.
        call BlzFrameSetAbsPoint(WUI_FeedText[i], FRAMEPOINT_LEFT, left + 0.012, 0.560 - I2R(i) * 0.015)
        call BlzFrameSetSize(WUI_FeedText[i], 0.240 / 0.86, 0.014 / 0.86)
        call BlzFrameSetScale(WUI_FeedText[i], 0.86)
        call BlzFrameSetTextAlignment(WUI_FeedText[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)
        call BlzFrameSetEnable(WUI_FeedText[i], false)
        call BlzFrameSetLevel(WUI_FeedText[i], 80)
        call BlzFrameSetVisible(WUI_FeedText[i], false)
        set WUI_FeedAge[i] = 0.00
        set i = i + 1
    endloop
    call TimerStart(CreateTimer(), 0.25, true, function WUI_FeedTick)
endfunction

private function WUI_CreateGameInfo takes nothing returns nothing
    local trigger click = CreateTrigger()
    local integer i = 0
    local real x = WUI_ScreenRight() - 0.090
    local framehandle part
    set WUI_InfoButton = WUI_TextButton("WOSGameInfoButton", WUI_Root, "Game Info", WUI_TOP_ROW_W, 0.015)
    // Three buttons share the row (Game Info | Hide UI | Save Keys).
    call WUI_Place(WUI_InfoButton, WUI_ScreenRight() - WUI_TOP_ROW_X1, 0.5495, WUI_TOP_ROW_W, 0.015)
    call WUI_SetButtonTextScale(WUI_InfoButton, WUI_TOP_ROW_TEXT)
    call WUI_SetButtonMinimal(WUI_InfoButton)
    call WUI_RegisterTopControl(WUI_InfoButton)
    call WUI_TooltipBelowLeft(WUI_InfoButton, "|cffd5b876GAME INFO|r|nElements, destructible decor and round end.")
    set WUI_InfoPanel = BlzCreateFrameByType("BUTTON", "WOSGameInfoPanel", WUI_Root, "", 0)
    call WUI_Place(WUI_InfoPanel, x, 0.430, 0.180, WUI_INFO_HEIGHT)
    call BlzFrameSetLevel(WUI_InfoPanel, 20)
    set part = BlzCreateFrameByType("BACKDROP", "WOSGameInfoBack", WUI_InfoPanel, "", 0)
    call BlzFrameSetAllPoints(part, WUI_InfoPanel)
    call BlzFrameSetTexture(part, "UI\\WOS\\panel-soft.tga", 0, true)
    call BlzFrameSetEnable(part, false)
    call WUI_MinimalEdge(WUI_InfoPanel)
    set WUI_InfoTitle = BlzCreateFrameByType("TEXT", "WOSGameInfoTitle", WUI_InfoPanel, "", 0)
    call BlzFrameSetPoint(WUI_InfoTitle, FRAMEPOINT_TOP, WUI_InfoPanel, FRAMEPOINT_TOP, 0.00, -0.006)
    call BlzFrameSetSize(WUI_InfoTitle, 0.160 / 0.80, 0.012 / 0.80)
    call BlzFrameSetScale(WUI_InfoTitle, 0.80)
    call BlzFrameSetTextAlignment(WUI_InfoTitle, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetEnable(WUI_InfoTitle, false)
    loop
        exitwhen i >= WUI_INFO_ROWS
        set WUI_InfoIcon[i] = BlzCreateFrameByType("BACKDROP", "WOSGameInfoIcon", WUI_InfoPanel, "", i)
        call BlzFrameSetPoint(WUI_InfoIcon[i], FRAMEPOINT_LEFT, WUI_InfoPanel, FRAMEPOINT_TOPLEFT, 0.008, -0.044 - I2R(i) * 0.040)
        call BlzFrameSetSize(WUI_InfoIcon[i], 0.022, 0.022)
        call BlzFrameSetEnable(WUI_InfoIcon[i], false)
        // Text block centred on its icon: name on the first line, the
        // description below (up to two more lines).
        set WUI_InfoText[i] = BlzCreateFrameByType("TEXT", "WOSGameInfoText", WUI_InfoPanel, "", i)
        call BlzFrameSetPoint(WUI_InfoText[i], FRAMEPOINT_LEFT, WUI_InfoIcon[i], FRAMEPOINT_RIGHT, 0.005, 0.0)
        call BlzFrameSetSize(WUI_InfoText[i], 0.138 / 0.62, 0.038 / 0.62)
        call BlzFrameSetScale(WUI_InfoText[i], 0.62)
        call BlzFrameSetTextAlignment(WUI_InfoText[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)
        call BlzFrameSetEnable(WUI_InfoText[i], false)
        set i = i + 1
    endloop
    set WUI_InfoPrev = WUI_TextButton("WOSGameInfoPrev", WUI_InfoPanel, "<", 0.014, 0.014)
    call WUI_SetButtonMinimal(WUI_InfoPrev)
    call BlzFrameSetPoint(WUI_InfoPrev, FRAMEPOINT_BOTTOMLEFT, WUI_InfoPanel, FRAMEPOINT_BOTTOMLEFT, 0.006, 0.005)
    set WUI_InfoNext = WUI_TextButton("WOSGameInfoNext", WUI_InfoPanel, ">", 0.014, 0.014)
    call WUI_SetButtonMinimal(WUI_InfoNext)
    call BlzFrameSetPoint(WUI_InfoNext, FRAMEPOINT_BOTTOMRIGHT, WUI_InfoPanel, FRAMEPOINT_BOTTOMRIGHT, -0.006, 0.005)
    set WUI_InfoPageLabel = BlzCreateFrameByType("TEXT", "WOSGameInfoPage", WUI_InfoPanel, "", 0)
    call BlzFrameSetPoint(WUI_InfoPageLabel, FRAMEPOINT_BOTTOM, WUI_InfoPanel, FRAMEPOINT_BOTTOM, 0.00, 0.007)
    call BlzFrameSetSize(WUI_InfoPageLabel, 0.060 / 0.66, 0.012 / 0.66)
    call BlzFrameSetScale(WUI_InfoPageLabel, 0.66)
    call BlzFrameSetTextAlignment(WUI_InfoPageLabel, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetEnable(WUI_InfoPageLabel, false)
    call BlzTriggerRegisterFrameEvent(click, WUI_InfoButton, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(click, WUI_InfoPrev, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(click, WUI_InfoNext, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(click, function WUI_InfoClick)
    call WUI_InfoShowPage()
    call BlzFrameSetVisible(WUI_InfoPanel, false)
    set click = null
    set part = null
endfunction

// Checkpoint 26g: passive placeholders of the controls that are created only
// after the mode is chosen (Link, Music, Discord, Hide UI, Shop Key). They are
// drawn at UI startup so the whole interface appears at once, take no mouse
// input and are hidden by WUI_ReleaseGhost when the real control exists.
private function WUI_GhostIcon takes string name, string texture, real x, real y, real size returns framehandle
    local framehandle icon = BlzCreateFrameByType("BACKDROP", name, WUI_Root, "", 0)
    call WUI_Place(icon, x, y, size, size)
    call BlzFrameSetTexture(icon, texture, 0, true)
    call BlzFrameSetEnable(icon, false)
    return icon
endfunction

private function WUI_GhostText takes string name, string caption, real x returns framehandle
    local framehandle back = BlzCreateFrameByType("BACKDROP", name, WUI_Root, "", 0)
    local framehandle text = BlzCreateFrameByType("TEXT", name + "Text", back, "", 0)
    call WUI_Place(back, x, 0.5495, 0.056, 0.015)
    call BlzFrameSetTexture(back, WUI_FILL_NORMAL, 0, true)
    call BlzFrameSetEnable(back, false)
    call BlzFrameSetAllPoints(text, back)
    call BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(text, 0.90 * 0.74)
    call BlzFrameSetText(text, WUI_TEXT + caption + "|r")
    call BlzFrameSetEnable(text, false)
    call WUI_MinimalEdge(back)
    set text = null
    return back
endfunction

// Local: moves everything right of the stats block (registered frames, stock
// command/item buttons, chassis right edge) and lets owners re-place theirs.
function WUI_SetHud takes real shift, real left returns nothing
    local integer i = 0
    set WUI_HudShift = shift
    set WUI_HudLeft = left
    loop
        exitwhen i >= WUI_ShiftCount
        if WUI_ShiftGroup[i] == 1 then
            call WUI_Place(WUI_ShiftFrame[i], WUI_ShiftBaseX[i] + left, WUI_ShiftBaseY[i], WUI_ShiftBaseW[i], WUI_ShiftBaseH[i])
        else
            call WUI_Place(WUI_ShiftFrame[i], WUI_ShiftBaseX[i] + shift, WUI_ShiftBaseY[i], WUI_ShiftBaseW[i], WUI_ShiftBaseH[i])
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= WUI_RectCount
        call BlzFrameClearAllPoints(WUI_RectFrame[i])
        call BlzFrameSetAbsPoint(WUI_RectFrame[i], FRAMEPOINT_BOTTOMLEFT, WUI_RectL[i] + left, WUI_RectB[i])
        call BlzFrameSetAbsPoint(WUI_RectFrame[i], FRAMEPOINT_TOPRIGHT, WUI_RectR[i] + left, WUI_RectT[i])
        set i = i + 1
    endloop
    if WUI_AllyColor != null then
        call WUI_Place(WUI_AllyColor, WUI_ALLY_COLOR_X + left, WUI_ALLY_COLOR_Y, WUI_ALLY_COLOR_SIZE, WUI_ALLY_COLOR_SIZE)
    endif
    if WUI_NativeBack != null then
        call BlzFrameClearAllPoints(WUI_NativeBack)
        call BlzFrameSetAbsPoint(WUI_NativeBack, FRAMEPOINT_BOTTOMLEFT, WUI_CHASSIS_LEFT + left, 0.000)
        call BlzFrameSetAbsPoint(WUI_NativeBack, FRAMEPOINT_TOPRIGHT, WUI_CHASSIS_RIGHT + shift, WUI_CHASSIS_TOP)
    endif
    if WUI_HudPanel != null then
        call BlzFrameClearAllPoints(WUI_HudPanel)
        call BlzFrameSetAbsPoint(WUI_HudPanel, FRAMEPOINT_BOTTOMLEFT, WUI_CHASSIS_LEFT + left, 0.000)
        call BlzFrameSetAbsPoint(WUI_HudPanel, FRAMEPOINT_TOPRIGHT, WUI_CHASSIS_RIGHT + shift, WUI_CHASSIS_TOP)
    endif
    if WUI_NativeTooltip != null then
        call BlzFrameClearAllPoints(WUI_NativeTooltip)
        call BlzFrameSetAbsPoint(WUI_NativeTooltip, FRAMEPOINT_BOTTOMRIGHT, WUI_CHASSIS_RIGHT + shift - 0.004, WUI_CHASSIS_TOP + 0.010)
    endif
    set i = 0
    loop
        exitwhen i >= 6
        if WUI_Item[i] != null then
            call WUI_PlaceNativeItem(WUI_Item[i], WUI_ItemX(i), WUI_ItemY(i), WUI_ITEM_SIZE)
        endif
        set i = i + 1
    endloop
    call WUI_LayoutCommands(WUI_CompactCommands)
    call WUI_PlaceBuffBar()
    set i = 0
    loop
        exitwhen i >= WUI_ShiftHookCount
        call TriggerExecute(WUI_ShiftHook[i])
        set i = i + 1
    endloop
endfunction

function WUI_SetHudShift takes real shift returns nothing
    call WUI_SetHud(shift, WUI_HudLeft)
endfunction

private function WUI_CreateGhostControls takes nothing returns nothing
    local framehandle part
    set WUI_Ghost[0] = WUI_GhostIcon("WOSGhostLink", "UI\\WOS\\glyph-link.tga", WUI_TopActionX(3), 0.584, 0.022)
    set WUI_Ghost[1] = WUI_GhostIcon("WOSGhostMusic", "UI\\WOS\\glyph-music.tga", WUI_TopActionX(4), 0.584, 0.022)
    set WUI_Ghost[2] = WUI_GhostIcon("WOSGhostDiscord", "UI\\WOS\\toolbar-community.tga", 0.780, 0.050, 0.025)
    set part = BlzCreateFrameByType("BACKDROP", "WOSGhostDiscordIcon", WUI_Ghost[2], "", 0)
    call BlzFrameSetAllPoints(part, WUI_Ghost[2])
    call BlzFrameSetTexture(part, "UI\\WOS\\discord.tga", 0, true)
    call BlzFrameSetEnable(part, false)
    set WUI_Ghost[3] = WUI_GhostText("WOSGhostHideUI", "Hide UI", WUI_ScreenRight() - WUI_TOP_ROW_X2)
    call BlzFrameSetSize(WUI_Ghost[3], WUI_TOP_ROW_W, 0.015)
    set part = null
endfunction

// 0 Link + Music, 1 Discord, 2 Hide UI + Shop Key.
function WUI_ReleaseGhost takes integer which returns nothing
    if which == 0 then
        call BlzFrameSetVisible(WUI_Ghost[0], false)
        call BlzFrameSetVisible(WUI_Ghost[1], false)
    elseif which == 1 then
        call BlzFrameSetVisible(WUI_Ghost[2], false)
    else
        call BlzFrameSetVisible(WUI_Ghost[3], false)
    endif
endfunction

private function WUI_Bootstrap takes nothing returns nothing
    local framehandle board
    local framehandle part
    local integer index = 1
    call DestroyTimer(WUI_BootTimer)
    set WUI_BootTimer = null
    // Same dependency order as the backup: templates first, then UI owners.
    // Engine templates already exist in-game; reloading them causes duplicate definitions.
    set WUI_FrameDefinitionsReady = BlzLoadTOCFile("UI\\WOS\\Templates.toc")
    set WUI_MusicDefinitionsReady = WUI_FrameDefinitionsReady
    set WUI_ChargeDefinitionsReady = WUI_FrameDefinitionsReady
    // Each owner checks its definitions; mode controls retain their passive fallback.
    set WUI_SimpleRoot = BlzGetFrameByName("ConsoleUI", 0)
    // Keep the service board ROOT visible: hidden parents hide their children.
    // Its visual children alone are hidden. No players' existing boards are replaced.
    set WUI_ServiceBoard = CreateLeaderboardBJ(bj_FORCE_ALL_PLAYERS, "WOS UI")
    call LeaderboardSetSizeByItemCount(WUI_ServiceBoard, 0)
    call LeaderboardDisplay(WUI_ServiceBoard, true)
    set board = BlzGetFrameByName("Leaderboard", 0)
    if board == null then
        set board = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    else
        call BlzFrameSetSize(board, 0.00, 0.00)
        set part = BlzGetFrameByName("LeaderboardBackdrop", 0)
        if part != null then
            call BlzFrameSetVisible(part, false)
        endif
        set part = BlzGetFrameByName("LeaderboardTitle", 0)
        if part != null then
            call BlzFrameSetText(part, "")
        endif
    endif
    set WUI_Root = WUI_Passive("WOSIndependentRoot", board)
    call WUI_Place(WUI_Root, 0.00, 0.00, 0.0001, 0.0001)
    // Never disable the ancestor of interactive controls.
    call BlzFrameSetEnable(WUI_Root, true)
    call BlzFrameSetVisible(WUI_Root, true)
    call WUI_CreateTestHelp()
    call WUI_CreateControls()
    call WUI_CreateRestart()
    call WUI_CreateFeed()
    call WUI_CreateGameInfo()
    call WUI_CreateGhostControls()
    call WUI_LayoutRightColumn()
    set WUI_Ready = true
    call WUI_OnReady(function WUI_CreateHUDChrome)
    if WUI_ENABLE_HOTKEYS then
        call WUI_OnReady(function WUI_CreateHotkeyEditor)
    endif
    loop
        exitwhen index > WUI_ReadyCount
        call TriggerExecute(WUI_ReadyOwner[index])
        call DestroyTrigger(WUI_ReadyOwner[index])
        set WUI_ReadyOwner[index] = null
        set index = index + 1
    endloop
    set WUI_ReadyCount = 0
    call TimerStart(WUI_DockTimer, 0.10, true, function WUI_RefreshDocks)
    call TimerStart(CreateTimer(), 0.10, true, function WUI_WatchCover)
    // The FPS line appears only once the game shows it; look for it a while.
    set board = null
    set part = null
endfunction

private function WUI_Init takes nothing returns nothing
    call TimerStart(WUI_BootTimer, 0.10, false, function WUI_Bootstrap)
endfunction

endlibrary
