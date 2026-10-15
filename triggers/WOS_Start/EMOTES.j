// ============================================================================
//  STANDALONE EMOJI TRIGGER
//
//  Paste this file into one custom-text trigger and remove the old emoji code
//  from ButtonPressed / WoS_Hero_Icons_Init to avoid duplicate effects.
//
//  Hotkey meta values used by Warcraft III:
//      0 = ordinary key, 1 = Shift, 2 = Ctrl, 4 = Alt
//
//  The only section normally edited is ConfigureEmojis below.
// ============================================================================
library EmojiStandalone requires GearSystems, WOSUI, CustomImageChat

globals
    private constant integer EMOJI_MAX             = 30
    private constant integer EMOJI_COLUMNS         = 3
    private constant integer EMOJI_EFFECT_MAX      = 64

    private constant real    EMOJI_COOLDOWN        = 3.25
    private constant real    EMOJI_EFFECT_DURATION = 3.50
    private constant real    EMOJI_PERIOD          = 0.05

    // Compact icon grid; effect IDs, permissions and sync handlers are unchanged.
    private constant real    EMOJI_BUTTON_SIZE     = 0.0420
    private constant real    EMOJI_BUTTON_STEP     = 0.0480
    private constant real    EMOJI_HEADER_HEIGHT   = 0.0260
    private constant real    EMOJI_CLOSE_SIZE      = 0.0200
    private constant integer EMOJI_PANEL_ALPHA     = 235
    private constant string  EMOJI_CLOSE_TEXTURE   = "Music\\Music_Close.blp"
    private constant real    EMOJI_PANEL_CENTER_X  = 0.370
    private constant real    EMOJI_PANEL_CENTER_Y  = 0.310
    // Checkpoint 21 wheel (same interaction as the Z ping wheel): hold the
    // emote key, hover an emote, release or click to send; Esc/right click
    // cancels. Clicking the toolbar button opens it in the screen centre.
    private constant real    EMOJI_WHEEL_SIZE      = 0.210
    private constant real    EMOJI_WHEEL_RADIUS    = 0.074
    private constant real    EMOJI_ICON_SIZE       = 0.034
    private constant real    EMOJI_ICON_HOVER      = 0.044
    private integer array EmojiWheelSlot
    private integer EmojiWheelCount = 0
    private integer EmojiHover = 0
    private boolean EmojiHold = false
    private real EmojiCenterX = 0.40
    private real EmojiCenterY = 0.32
    private framehandle EmojiHotkeyOwner = null
    private boolean EmojiHotkeyRegistered = false
    private boolean EmojiRightWasDown = false
    // Checkpoint 22: pages of 15 emotes, page arrows only when needed, a
    // glow ring marks the hovered emote (icons no longer change size).
    private constant integer EMOJI_PAGE_SIZE = 15
    private integer EmojiPage = 0
    private integer EmojiPageCount = 1
    private integer EmojiAllowedCount = 0
    private framehandle EmojiPrev = null
    private framehandle EmojiNext = null
    private framehandle EmojiPageText = null
    private framehandle EmojiHoverGlow = null

    private integer EmojiCount = 0
    private string array EmojiModel
    private string array EmojiTexture
    private boolean array EmojiVIP3Only
    private oskeytype array EmojiHotkey
    private integer array EmojiHotkeyMeta
    private boolean EmojiInitialized = false

    private oskeytype EmojiMenuKey = OSKEY_K
    private integer EmojiMenuMeta = 0

    private framehandle EmojiPanel = null
    private framehandle EmojiCloseButton = null
    private framehandle EmojiCloseIcon = null
    private framehandle EmojiCooldownText = null
    private framehandle array EmojiButton
    private framehandle array EmojiButtonIcon
    private trigger EmojiFrameTrigger = null
    private trigger EmojiSyncTrigger = null
    private trigger EmojiKeyTrigger = null
    private timer EmojiTimer = null

    // This state is used only for local frame visibility.
    private boolean array EmojiPanelOpen

    private real array EmojiPlayerCooldown
    private unit array EmojiBoundHero
    private group EmojiSearchGroup = null
    private boolexpr EmojiSearchFilter = null
    private unit EmojiSearchResult = null

    private integer EmojiEffectCount = 0
    private effect array EmojiEffect
    private real array EmojiEffectAge
endglobals

// Adds one emoji and returns its ID.
// modelPath   = the .mdx shown above the hero.
// texturePath = the .blp/.dds shown on the window button.
function Emoji_Add takes string modelPath, string texturePath returns integer
    if EmojiCount >= EMOJI_MAX or texturePath == "" then
        return 0
    endif

    set EmojiCount = EmojiCount + 1
    set EmojiModel[EmojiCount] = modelPath
    set EmojiTexture[EmojiCount] = texturePath
    set EmojiVIP3Only[EmojiCount] = false
    set EmojiHotkey[EmojiCount] = null
    set EmojiHotkeyMeta[EmojiCount] = 0
    return EmojiCount
endfunction

// Marks an emoji as VIP3-only (true), or makes it available to everyone (false).
// Shop VIP page: texture of the n-th (1-based) emote, VIP III-only or common.
function Emoji_GetEmoteTexture takes integer index, boolean vip3 returns string
    local integer i = 1
    local integer found = 0
    loop
        exitwhen i > EmojiCount
        if EmojiVIP3Only[i] == vip3 then
            set found = found + 1
            if found == index then
                return EmojiTexture[i]
            endif
        endif
        set i = i + 1
    endloop
    return ""
endfunction

function Emoji_SetVIP3Only takes integer emojiId, boolean flag returns nothing
    if emojiId > 0 and emojiId <= EmojiCount then
        set EmojiVIP3Only[emojiId] = flag
    endif
endfunction

// metaKey: 2 for Ctrl+key, 0 for a normal key.
// Call this from ConfigureEmojis, before the library finishes initialization.
function Emoji_SetHotkey takes integer emojiId, oskeytype key, integer metaKey returns nothing
    if emojiId > 0 and emojiId <= EmojiCount then
        set EmojiHotkey[emojiId] = key
        set EmojiHotkeyMeta[emojiId] = metaKey
    endif
endfunction

// Changes the key which opens/closes the emoji window. Default: K.
function Emoji_SetMenuHotkey takes oskeytype key, integer metaKey returns nothing
    set EmojiMenuKey = key
    set EmojiMenuMeta = metaKey
endfunction

// Optional exact hero binding. Call it after creating/replacing a player's hero:
//     call Emoji_BindHero(Player(pid), Hero[pid])
// Without this call the system automatically finds the first living hero owned
// by that player.
function Emoji_BindHero takes player p, unit hero returns nothing
    set EmojiBoundHero[GetPlayerId(p)] = hero
endfunction

// ---------------------------------------------------------------------------
// EDIT THIS SECTION TO ADD/REMOVE EMOJIS OR CHANGE HOTKEYS.
// ---------------------------------------------------------------------------
private function ConfigureEmojis takes nothing returns nothing
    local integer id

    call Emoji_SetMenuHotkey(OSKEY_K, 0)

    set id = Emoji_Add("war3mapImported\\wos_emoji_11.mdx", "war3mapImported\\wos_emoji_11.blp")
    call Emoji_SetHotkey(id, OSKEY_1, 2)

    set id = Emoji_Add("war3mapImported\\wos_emoji_3.mdx", "war3mapImported\\wos_emoji_3.blp")
    call Emoji_SetHotkey(id, OSKEY_2, 2)

    set id = Emoji_Add("war3mapImported\\wos_emoji_5.mdx", "war3mapImported\\wos_emoji_5.blp")
    call Emoji_SetHotkey(id, OSKEY_3, 2)

    set id = Emoji_Add("war3mapImported\\wos_emoji_7.mdx", "war3mapImported\\wos_emoji_7.blp")
    call Emoji_SetHotkey(id, OSKEY_4, 2)

    set id = Emoji_Add("war3mapImported\\wos_emoji_8.mdx", "war3mapImported\\wos_emoji_8.blp")
    call Emoji_SetHotkey(id, OSKEY_5, 2)

    set id = Emoji_Add("war3mapImported\\wos_emoji_9.mdx", "war3mapImported\\wos_emoji_9.blp")
    call Emoji_SetHotkey(id, OSKEY_6, 2)

    // These six are available by clicking their x2 buttons in the K window.
    // Give any of them a key with Emoji_SetHotkey if needed.
    set id = Emoji_Add("war3mapImported\\wos_[bq]16.mdx", "war3mapImported\\wos_[bq]16_0.blp")
    call Emoji_SetVIP3Only(id, true)
    set id = Emoji_Add("war3mapImported\\wos_[bq]17.mdx", "war3mapImported\\wos_[bq]17_0.blp")
    call Emoji_SetVIP3Only(id, true)
    set id = Emoji_Add("war3mapImported\\wos_[bq]18.mdx", "war3mapImported\\wos_[bq]18_0.blp")
    call Emoji_SetVIP3Only(id, true)
    set id = Emoji_Add("war3mapImported\\wos_[bq]19.mdx", "war3mapImported\\wos_[bq]19_0.blp")
    call Emoji_SetVIP3Only(id, true)
    set id = Emoji_Add("war3mapImported\\wos_[bq]20.mdx", "war3mapImported\\wos_[bq]20_0.blp")
    call Emoji_SetVIP3Only(id, true)
    set id = Emoji_Add("war3mapImported\\wos_[bq]21.mdx", "war3mapImported\\wos_[bq]21_0.blp")
    call Emoji_SetVIP3Only(id, true)

    // Example of a new emoji on an ordinary, unused Z key:
    // set id = Emoji_Add("war3mapImported\\my_emoji.mdx", "war3mapImported\\my_emoji.blp")
    // call Emoji_SetHotkey(id, OSKEY_Z, 0)
endfunction

private function IsLivingHero takes nothing returns boolean
    local unit u = GetFilterUnit()

    if EmojiSearchResult == null and IsUnitType(u, UNIT_TYPE_HERO) and GetWidgetLife(u) > 0.405 then
        set EmojiSearchResult = u
    endif

    set u = null
    return false
endfunction

private function GetEmojiHero takes player p returns unit
    local integer pid = GetPlayerId(p)

    if EmojiBoundHero[pid] != null and GetWidgetLife(EmojiBoundHero[pid]) > 0.405 then
        return EmojiBoundHero[pid]
    endif

    set EmojiSearchResult = null
    call GroupEnumUnitsOfPlayer(EmojiSearchGroup, p, EmojiSearchFilter)
    return EmojiSearchResult
endfunction

private function RemoveEffectAt takes integer index returns nothing
    local integer i = index

    if EmojiEffect[index] != null then
        call DestroyEffect(EmojiEffect[index])
    endif

    loop
        exitwhen i >= EmojiEffectCount
        set EmojiEffect[i] = EmojiEffect[i + 1]
        set EmojiEffectAge[i] = EmojiEffectAge[i + 1]
        set i = i + 1
    endloop

    set EmojiEffect[EmojiEffectCount] = null
    set EmojiEffectAge[EmojiEffectCount] = 0.00
    set EmojiEffectCount = EmojiEffectCount - 1
endfunction

private function AddHeroEffect takes unit hero, string modelPath returns nothing
    if hero == null or modelPath == "" then
        return
    endif

    if EmojiEffectCount >= EMOJI_EFFECT_MAX then
        call RemoveEffectAt(1)
    endif

    set EmojiEffectCount = EmojiEffectCount + 1
    set EmojiEffect[EmojiEffectCount] = AddSpecialEffectTarget(modelPath, hero, "origin")
    set EmojiEffectAge[EmojiEffectCount] = 0.00
endfunction

private function HidePanelButtons takes nothing returns nothing
    local integer i = 1

    loop
        exitwhen i > EmojiCount
        call BlzFrameSetVisible(EmojiButton[i], false)
        set i = i + 1
    endloop
endfunction

private function IsEmojiAllowed takes player p, integer emojiId returns boolean
    if emojiId <= 0 or emojiId > EmojiCount then
        return false
    endif

    // Reuse the map's existing VIP3 source directly; no access-level
    // functions are copied or redeclared in this standalone trigger.
    // VIP emotes: same VIP level as the chat emojis (set at map start), the
    // nickname list, or Test Mode (so they can be tried out there).
    return not EmojiVIP3Only[emojiId] or TestMode or CustomChat_GetPlayerAccessLevel(p) >= 3 or VIPCheckLvl3(FramePlayerFirstName[GetPlayerId(p)])
endfunction

private function ApplyPaletteForPlayer takes player p returns nothing
    local integer i = 1
    local integer slot = 0
    local integer order = 0
    local real angle
    call HidePanelButtons()
    set EmojiWheelCount = 0
    set EmojiAllowedCount = 0
    loop
        exitwhen i > EmojiCount
        if IsEmojiAllowed(p, i) then
            set EmojiAllowedCount = EmojiAllowedCount + 1
        endif
        set i = i + 1
    endloop
    set EmojiPageCount = IMaxBJ(1, (EmojiAllowedCount + EMOJI_PAGE_SIZE - 1) / EMOJI_PAGE_SIZE)
    if EmojiPage >= EmojiPageCount then
        set EmojiPage = 0
    endif
    // Only the current page's emotes are spread around the ring.
    set i = 1
    loop
        exitwhen i > EmojiCount
        set EmojiWheelSlot[i] = -1
        if IsEmojiAllowed(p, i) then
            if order >= EmojiPage * EMOJI_PAGE_SIZE and order < (EmojiPage + 1) * EMOJI_PAGE_SIZE then
                set EmojiWheelSlot[i] = EmojiWheelCount
                set EmojiWheelCount = EmojiWheelCount + 1
            endif
            set order = order + 1
        endif
        set i = i + 1
    endloop
    call BlzFrameClearAllPoints(EmojiPanel)
    call BlzFrameSetAbsPoint(EmojiPanel, FRAMEPOINT_CENTER, EmojiCenterX, EmojiCenterY)
    call BlzFrameSetSize(EmojiPanel, EMOJI_WHEEL_SIZE, EMOJI_WHEEL_SIZE)
    set i = 1
    loop
        exitwhen i > EmojiCount
        set slot = EmojiWheelSlot[i]
        if slot >= 0 then
            // Clockwise from the top, evenly spread around the ring.
            set angle = (90.00 - I2R(slot) * 360.00 / I2R(EmojiWheelCount)) * bj_DEGTORAD
            call BlzFrameClearAllPoints(EmojiButton[i])
            call BlzFrameSetPoint(EmojiButton[i], FRAMEPOINT_CENTER, EmojiPanel, FRAMEPOINT_CENTER, EMOJI_WHEEL_RADIUS * Cos(angle), EMOJI_WHEEL_RADIUS * Sin(angle))
            call BlzFrameSetSize(EmojiButton[i], EMOJI_ICON_SIZE, EMOJI_ICON_SIZE)
            call BlzFrameSetVisible(EmojiButton[i], true)
        endif
        set i = i + 1
    endloop
    set EmojiHover = 0
    call BlzFrameSetVisible(EmojiHoverGlow, false)
    call BlzFrameSetVisible(EmojiPrev, EmojiPageCount > 1)
    call BlzFrameSetVisible(EmojiNext, EmojiPageCount > 1)
    call BlzFrameSetVisible(EmojiPageText, EmojiPageCount > 1)
    call BlzFrameSetText(EmojiPageText, WUI_GOLD + I2S(EmojiPage + 1) + " / " + I2S(EmojiPageCount) + "|r")
endfunction

private function UpdateCooldownText takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    if EmojiPlayerCooldown[pid] > 0.05 then
        call BlzFrameSetText(EmojiCooldownText, "|cffffcc00" + R2SW(EmojiPlayerCooldown[pid], 0, 1) + "s|r")
    elseif EmojiHover > 0 then
        call BlzFrameSetText(EmojiCooldownText, WUI_GOLD + "Send|r")
    else
        call BlzFrameSetText(EmojiCooldownText, WUI_GOLD + "Emote|r")
    endif
endfunction

// Local: which emote lies under the mouse (by angle around the wheel centre).
private function UpdateEmojiHover takes nothing returns nothing
    local real dx = BlzPixelToFrameX(BlzGetMouseScreenPosX()) - EmojiCenterX
    local real dy = BlzPixelToFrameY(BlzGetMouseScreenPosY()) - EmojiCenterY
    local real radius = SquareRoot(dx * dx + dy * dy)
    local integer slot = -1
    local integer hover = 0
    local integer i = 1
    local real turn
    if EmojiWheelCount > 0 and radius >= 0.030 and radius <= 0.112 then
        // Angle measured clockwise from the top, shifted by half a sector.
        set turn = 90.00 - Atan2(dy, dx) * bj_RADTODEG + 180.00 / I2R(EmojiWheelCount)
        loop
            exitwhen turn >= 0.00
            set turn = turn + 360.00
        endloop
        set slot = ModuloInteger(R2I(turn * I2R(EmojiWheelCount) / 360.00), EmojiWheelCount)
    endif
    loop
        exitwhen i > EmojiCount
        if EmojiWheelSlot[i] >= 0 and EmojiWheelSlot[i] == slot then
            set hover = i
        endif
        set i = i + 1
    endloop
    if hover != EmojiHover then
        if hover > 0 then
            call BlzFrameClearAllPoints(EmojiHoverGlow)
            call BlzFrameSetPoint(EmojiHoverGlow, FRAMEPOINT_CENTER, EmojiButton[hover], FRAMEPOINT_CENTER, 0.00, 0.00)
            call BlzFrameSetSize(EmojiHoverGlow, EMOJI_ICON_HOVER, EMOJI_ICON_HOVER)
        endif
        call BlzFrameSetVisible(EmojiHoverGlow, hover > 0)
    endif
    set EmojiHover = hover
endfunction

function Emoji_ShowMenu takes player p, boolean flag returns nothing
    local integer pid = GetPlayerId(p)

    if GetLocalPlayer() == p then
        set EmojiPanelOpen[pid] = flag
        if flag then
            set EmojiRightWasDown = BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_RIGHT)
            call ApplyPaletteForPlayer(p)
            call UpdateCooldownText()
        else
            set EmojiHold = false
            set EmojiHover = 0
            call HidePanelButtons()
        endif
        call BlzFrameSetVisible(EmojiPanel, flag)
        call BlzFrameSetVisible(EmojiCloseButton, flag)
        call BlzFrameSetVisible(EmojiCooldownText, flag)
        if not flag then
            call BlzFrameSetVisible(EmojiHoverGlow, false)
            call BlzFrameSetVisible(EmojiPrev, false)
            call BlzFrameSetVisible(EmojiNext, false)
            call BlzFrameSetVisible(EmojiPageText, false)
        endif
    endif
endfunction

function Emoji_ToggleMenu takes player p returns nothing
    if EmojiInitialized and GetLocalPlayer() == p then
        // Toolbar click: the wheel opens in the screen centre and stays open.
        set EmojiCenterX = 0.40
        set EmojiCenterY = 0.32
        set EmojiHold = false
        call Emoji_ShowMenu(p, not EmojiPanelOpen[GetPlayerId(p)])
    endif
endfunction

function Emoji_Send takes player sender, integer emojiId returns nothing
    local integer pid = GetPlayerId(sender)
    local unit hero

    if not IsEmojiAllowed(sender, emojiId) then
        return
    endif

    if EmojiPlayerCooldown[pid] > 0.00 then
        call DisplayTimedTextToPlayer(sender, 0.00, 0.00, 0.75, "|cffffcc00Emoji cooldown|r")
        return
    endif

    set hero = GetEmojiHero(sender)
    call AddHeroEffect(hero, EmojiModel[emojiId])
    set EmojiPlayerCooldown[pid] = EMOJI_COOLDOWN
    call Emoji_ShowMenu(sender, false)
    set hero = null
endfunction

private function OnEmojiSync takes nothing returns nothing
    call Emoji_Send(GetTriggerPlayer(), S2I(BlzGetTriggerSyncData()))
endfunction

private function OnEmojiClick takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local player p = GetTriggerPlayer()
    local integer i = 1

    if clicked == EmojiCloseButton then
        call Emoji_ShowMenu(p, false)
    elseif clicked == EmojiPrev or clicked == EmojiNext then
        // Page arrows: local presentation; the wheel stays where it is.
        if GetLocalPlayer() == p then
            if clicked == EmojiNext then
                set EmojiPage = ModuloInteger(EmojiPage + 1, IMaxBJ(1, EmojiPageCount))
            else
                set EmojiPage = ModuloInteger(EmojiPage - 1 + EmojiPageCount, IMaxBJ(1, EmojiPageCount))
            endif
            set EmojiHold = false
            call ApplyPaletteForPlayer(p)
        endif
    else
        loop
            exitwhen i > EmojiCount
            if clicked == EmojiButton[i] then
                if GetLocalPlayer() == p then
                    call BlzSendSyncData("WEMJ", I2S(i))
                endif
                set i = EmojiCount + 1
            else
                set i = i + 1
            endif
        endloop
    endif


    set clicked = null
    set p = null
    call WUI_ResetClickedButtonFocus()
endfunction

private function OnEmojiKey takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local oskeytype key = BlzGetTriggerPlayerKey()
    local integer metaKey = BlzGetTriggerPlayerMetaKey()
    local integer i = 1

    if key == WUI_GetHotkey(WUI_HOTKEY_EMOTE, pid) then
        // Hold to open at the cursor, release to send the hovered emote.
        if GetLocalPlayer() == p then
            if BlzGetTriggerPlayerIsKeyDown() then
                if not EmojiPanelOpen[pid] and EmojiInitialized then
                    set EmojiCenterX = RMaxBJ(0.13, RMinBJ(0.67, BlzPixelToFrameX(BlzGetMouseScreenPosX())))
                    set EmojiCenterY = RMaxBJ(0.25, RMinBJ(0.46, BlzPixelToFrameY(BlzGetMouseScreenPosY())))
                    call Emoji_ShowMenu(p, true)
                    set EmojiHold = true
                endif
            elseif EmojiHold then
                call UpdateEmojiHover()
                if EmojiHover > 0 then
                    call BlzSendSyncData("WEMJ", I2S(EmojiHover))
                endif
                call Emoji_ShowMenu(p, false)
            endif
        endif
    elseif key == OSKEY_ESCAPE then
        call Emoji_ShowMenu(p, false)
    elseif BlzGetTriggerPlayerIsKeyDown() == false then
        loop
            exitwhen i > EmojiCount
            if key == EmojiHotkey[i] and metaKey == EmojiHotkeyMeta[i] then
                call Emoji_Send(p, i)
                set i = EmojiCount + 1
            else
                set i = i + 1
            endif
        endloop
    endif

    set key = null
    set p = null
endfunction

// Owner-local and inactive while the palette is closed; no world click events.
private function Emoji_PollMouse takes nothing returns nothing
    local player p = GetLocalPlayer()
    local boolean rightDown
    if EmojiPanelOpen[GetPlayerId(p)] then
        set rightDown = BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_RIGHT)
        if rightDown and not EmojiRightWasDown then
            call Emoji_ShowMenu(p, false)
        endif
        set EmojiRightWasDown = rightDown
    endif
    set p = null
endfunction

// The toolbar button owns the key badge; registration runs once both the
// key trigger (Emoji_Init) and the owner (toolbar) exist, in either order.
private function Emoji_TryRegisterHotkey takes nothing returns nothing
    if not EmojiHotkeyRegistered and EmojiKeyTrigger != null and EmojiHotkeyOwner != null then
        set EmojiHotkeyRegistered = true
        call WUI_RegisterHotkey(WUI_HOTKEY_EMOTE, EmojiKeyTrigger, EmojiMenuKey, "K", true, EmojiHotkeyOwner)
    endif
endfunction

function Emoji_AttachHotkeyBadge takes framehandle owner returns nothing
    set EmojiHotkeyOwner = owner
    call Emoji_TryRegisterHotkey()
endfunction

private function Periodic takes nothing returns nothing
    local integer i = 0
    local integer localPid = GetPlayerId(GetLocalPlayer())

    loop
        exitwhen i >= bj_MAX_PLAYERS
        if EmojiPlayerCooldown[i] > 0.00 then
            set EmojiPlayerCooldown[i] = EmojiPlayerCooldown[i] - EMOJI_PERIOD
            if EmojiPlayerCooldown[i] < 0.00 then
                set EmojiPlayerCooldown[i] = 0.00
            endif
        endif
        set i = i + 1
    endloop

    if EmojiPanelOpen[localPid] then
        call Emoji_PollMouse()
    endif
    if EmojiPanelOpen[localPid] then
        call UpdateEmojiHover()
        call UpdateCooldownText()
    endif

    set i = 1
    loop
        exitwhen i > EmojiEffectCount
        set EmojiEffectAge[i] = EmojiEffectAge[i] + EMOJI_PERIOD
        if EmojiEffectAge[i] >= EMOJI_EFFECT_DURATION then
            call RemoveEffectAt(i)
        else
            set i = i + 1
        endif
    endloop
endfunction

private function CreatePanel takes nothing returns nothing
    local integer columns = EmojiCount
    local integer rows
    local integer column
    local integer row
    local integer i = 1
    local real panelWidth
    local real panelHeight
    local real x
    local real y

    if columns > EMOJI_COLUMNS then
        set columns = EMOJI_COLUMNS
    endif
    if columns <= 0 then
        set columns = 1
    endif

    set rows = (EmojiCount + EMOJI_COLUMNS - 1) / EMOJI_COLUMNS
    if rows <= 0 then
        set rows = 1
    endif

    set panelWidth = 0.010 + EMOJI_BUTTON_SIZE + I2R(columns - 1) * EMOJI_BUTTON_STEP
    set panelHeight = 0.010 + EMOJI_BUTTON_SIZE + I2R(rows - 1) * EMOJI_BUTTON_STEP + EMOJI_HEADER_HEIGHT

    // Same graphite + gold wheel as the team pings.
    set EmojiPanel = BlzCreateFrameByType("BACKDROP", "WOSEmoteWheel", WUI_GetRoot(), "", 0)
    call WUI_RegisterRangeCover(EmojiPanel)
    call BlzFrameSetSize(EmojiPanel, EMOJI_WHEEL_SIZE, EMOJI_WHEEL_SIZE)
    call BlzFrameSetAbsPoint(EmojiPanel, FRAMEPOINT_CENTER, EMOJI_PANEL_CENTER_X, EMOJI_PANEL_CENTER_Y)
    call BlzFrameSetTexture(EmojiPanel, "UI\\WOS\\wheel-ring.tga", 0, true)
    call BlzFrameSetLevel(EmojiPanel, 1)
    call BlzFrameSetEnable(EmojiPanel, false)

    // Same close-button icon and button style as MusicPlayer.j.
    // It is parented to Game UI so the panel's transparency is not inherited.
    set EmojiCloseButton = BlzCreateFrameByType("BUTTON", "WosEmojiCloseButton", WUI_GetRoot(), "WOSIconButtonTemplate", 0)
    call BlzFrameSetPoint(EmojiCloseButton, FRAMEPOINT_TOPRIGHT, EmojiPanel, FRAMEPOINT_TOPRIGHT, -0.010, -0.010)
    call BlzFrameSetSize(EmojiCloseButton, EMOJI_CLOSE_SIZE, EMOJI_CLOSE_SIZE)
    call BlzFrameSetLevel(EmojiCloseButton, 3)
    call BlzTriggerRegisterFrameEvent(EmojiFrameTrigger, EmojiCloseButton, FRAMEEVENT_CONTROL_CLICK)

    set EmojiCloseIcon = BlzCreateFrameByType("BACKDROP", "WosEmojiCloseIcon", EmojiCloseButton, "", 0)
    call BlzFrameSetAllPoints(EmojiCloseIcon, EmojiCloseButton)
    call BlzFrameSetTexture(EmojiCloseIcon, "UI\\WOS\\glyph-close.tga", 0, true)
    call BlzFrameSetEnable(EmojiCloseIcon, false)

    // Local status line inside the header: green when ready, countdown otherwise.
    set EmojiCooldownText = BlzCreateFrameByType("TEXT", "WosEmojiCooldownText", WUI_GetRoot(), "", 0)
    call BlzFrameSetPoint(EmojiCooldownText, FRAMEPOINT_CENTER, EmojiPanel, FRAMEPOINT_CENTER, 0.000, 0.000)
    call BlzFrameSetSize(EmojiCooldownText, 0.050, 0.018)
    call BlzFrameSetTextAlignment(EmojiCooldownText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(EmojiCooldownText, 0.85)
    call BlzFrameSetLevel(EmojiCooldownText, 3)
    call BlzFrameSetEnable(EmojiCooldownText, false)
    call BlzFrameSetText(EmojiCooldownText, WUI_GOLD + "Emote|r")

    loop
        exitwhen i > EmojiCount
        set column = ModuloInteger(i - 1, EMOJI_COLUMNS)
        set row = (i - 1) / EMOJI_COLUMNS
        set x = 0.005 + I2R(column) * EMOJI_BUTTON_STEP
        set y = 0.005 + I2R(rows - 1 - row) * EMOJI_BUTTON_STEP

        // Same visual approach as CustomImage: a Warcraft button template with
        // a separate texture backdrop on top.
        set EmojiButton[i] = BlzCreateFrameByType("BUTTON", "WosEmojiButton", WUI_GetRoot(), "WOSIconButtonTemplate", 0)
        call BlzFrameSetLevel(EmojiButton[i], 3)
        call BlzFrameSetPoint(EmojiButton[i], FRAMEPOINT_BOTTOMLEFT, EmojiPanel, FRAMEPOINT_BOTTOMLEFT, x, y)
        call BlzFrameSetSize(EmojiButton[i], EMOJI_BUTTON_SIZE, EMOJI_BUTTON_SIZE)
        call BlzFrameSetAlpha(EmojiButton[i], 255)
        call BlzFrameSetLevel(EmojiButton[i], 2)

        set EmojiButtonIcon[i] = BlzCreateFrameByType("BACKDROP", "WosEmojiButtonIcon", EmojiButton[i], "", 0)
        call BlzFrameSetAllPoints(EmojiButtonIcon[i], EmojiButton[i])
        call BlzFrameSetTexture(EmojiButtonIcon[i], EmojiTexture[i], 0, true)
        call BlzFrameSetAlpha(EmojiButtonIcon[i], 255)
        call BlzFrameSetEnable(EmojiButtonIcon[i], false)
        call BlzTriggerRegisterFrameEvent(EmojiFrameTrigger, EmojiButton[i], FRAMEEVENT_CONTROL_CLICK)
        set i = i + 1
    endloop

    // Hover ring + page arrows (bottom of the wheel), created once.
    set EmojiHoverGlow = BlzCreateFrameByType("BACKDROP", "WosEmojiHoverGlow", WUI_GetRoot(), "", 0)
    call BlzFrameSetTexture(EmojiHoverGlow, "UI\\WOS\\learn-glow.tga", 0, true)
    call BlzFrameSetLevel(EmojiHoverGlow, 4)
    call BlzFrameSetEnable(EmojiHoverGlow, false)
    set EmojiPrev = WUI_TextButton("WosEmojiPrev", WUI_GetRoot(), "<", 0.016, 0.016)
    call BlzFrameSetPoint(EmojiPrev, FRAMEPOINT_CENTER, EmojiPanel, FRAMEPOINT_BOTTOM, -0.024, 0.010)
    call BlzFrameSetLevel(EmojiPrev, 5)
    set EmojiNext = WUI_TextButton("WosEmojiNext", WUI_GetRoot(), ">", 0.016, 0.016)
    call BlzFrameSetPoint(EmojiNext, FRAMEPOINT_CENTER, EmojiPanel, FRAMEPOINT_BOTTOM, 0.024, 0.010)
    call BlzFrameSetLevel(EmojiNext, 5)
    set EmojiPageText = BlzCreateFrameByType("TEXT", "WosEmojiPageText", WUI_GetRoot(), "", 0)
    call BlzFrameSetPoint(EmojiPageText, FRAMEPOINT_CENTER, EmojiPanel, FRAMEPOINT_BOTTOM, 0.00, 0.010)
    call BlzFrameSetSize(EmojiPageText, 0.030 / 0.70, 0.012 / 0.70)
    call BlzFrameSetScale(EmojiPageText, 0.70)
    call BlzFrameSetTextAlignment(EmojiPageText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetEnable(EmojiPageText, false)
    call BlzTriggerRegisterFrameEvent(EmojiFrameTrigger, EmojiPrev, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(EmojiFrameTrigger, EmojiNext, FRAMEEVENT_CONTROL_CLICK)

    call BlzFrameSetVisible(EmojiPanel, false)
    call BlzFrameSetVisible(EmojiCloseButton, false)
    call BlzFrameSetVisible(EmojiCooldownText, false)
    call BlzFrameSetVisible(EmojiHoverGlow, false)
    call BlzFrameSetVisible(EmojiPrev, false)
    call BlzFrameSetVisible(EmojiNext, false)
    call BlzFrameSetVisible(EmojiPageText, false)
    call HidePanelButtons()
endfunction

private function RegisterKeys takes nothing returns nothing
    local integer pid = 0
    local integer i

    loop
        exitwhen pid >= bj_MAX_PLAYERS
        call BlzTriggerRegisterPlayerKeyEvent(EmojiKeyTrigger, Player(pid), OSKEY_ESCAPE, 0, true)

        set i = 1
        loop
            exitwhen i > EmojiCount
            if EmojiHotkey[i] != null then
                call BlzTriggerRegisterPlayerKeyEvent(EmojiKeyTrigger, Player(pid), EmojiHotkey[i], EmojiHotkeyMeta[i], false)
            endif
            set i = i + 1
        endloop
        set pid = pid + 1
    endloop
endfunction

// Call this once from your Map Start trigger:
//     call Emoji_Init()
function Emoji_Init takes nothing returns nothing
    local integer pid = 0

    if EmojiInitialized then
        return
    endif
    set EmojiInitialized = true

    call ConfigureEmojis()

    set EmojiFrameTrigger = CreateTrigger()
    set EmojiSyncTrigger = CreateTrigger()
    set EmojiKeyTrigger = CreateTrigger()
    set EmojiTimer = CreateTimer()
    set EmojiSearchGroup = CreateGroup()
    set EmojiSearchFilter = Condition(function IsLivingHero)

    call CreatePanel()
    call RegisterKeys()

    loop
        exitwhen pid >= bj_MAX_PLAYERS
        call BlzTriggerRegisterPlayerSyncEvent(EmojiSyncTrigger, Player(pid), "WEMJ", false)
        set pid = pid + 1
    endloop

    call TriggerAddAction(EmojiFrameTrigger, function OnEmojiClick)
    call TriggerAddAction(EmojiSyncTrigger, function OnEmojiSync)
    call TriggerAddAction(EmojiKeyTrigger, function OnEmojiKey)
    call Emoji_TryRegisterHotkey()
    call TimerStart(EmojiTimer, EMOJI_PERIOD, true, function Periodic)
endfunction

endlibrary
