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
library EmojiStandalone requires GearSystems

globals
    private constant integer EMOJI_MAX             = 30
    private constant integer EMOJI_COLUMNS         = 3
    private constant integer EMOJI_EFFECT_MAX      = 64

    private constant real    EMOJI_COOLDOWN        = 3.25
    private constant real    EMOJI_EFFECT_DURATION = 3.50
    private constant real    EMOJI_PERIOD          = 0.05

    // 0.0288 * 2: every emoji button is exactly twice the old CustomImage size.
    private constant real    EMOJI_BUTTON_SIZE     = 0.0576
    private constant real    EMOJI_BUTTON_STEP     = 0.0648
    private constant real    EMOJI_HEADER_HEIGHT   = 0.0260
    private constant real    EMOJI_CLOSE_SIZE      = 0.0200
    private constant integer EMOJI_PANEL_ALPHA     = 100
    private constant string  EMOJI_CLOSE_TEXTURE   = "Music\\Music_Close.blp"
    private constant real    EMOJI_PANEL_CENTER_X  = 0.370
    private constant real    EMOJI_PANEL_CENTER_Y  = 0.310

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
    return not EmojiVIP3Only[emojiId] or VIPCheckLvl3(FramePlayerFirstName[GetPlayerId(p)])
endfunction

private function ApplyPaletteForPlayer takes player p returns nothing
    local integer visibleCount = 0
    local integer visibleSlot = 0
    local integer columns
    local integer rows
    local integer column
    local integer row
    local integer i = 1
    local real panelWidth
    local real panelHeight
    local real x
    local real y

    call HidePanelButtons()

    loop
        exitwhen i > EmojiCount
        if IsEmojiAllowed(p, i) then
            set visibleCount = visibleCount + 1
        endif
        set i = i + 1
    endloop

    set columns = visibleCount
    if columns > EMOJI_COLUMNS then
        set columns = EMOJI_COLUMNS
    endif
    if columns <= 0 then
        set columns = 1
    endif

    set rows = (visibleCount + EMOJI_COLUMNS - 1) / EMOJI_COLUMNS
    if rows <= 0 then
        set rows = 1
    endif

    set panelWidth = 0.010 + EMOJI_BUTTON_SIZE + I2R(columns - 1) * EMOJI_BUTTON_STEP
    set panelHeight = 0.010 + EMOJI_BUTTON_SIZE + I2R(rows - 1) * EMOJI_BUTTON_STEP + EMOJI_HEADER_HEIGHT
    call BlzFrameSetSize(EmojiPanel, panelWidth, panelHeight)
    call BlzFrameClearAllPoints(EmojiPanel)
    call BlzFrameSetAbsPoint(EmojiPanel, FRAMEPOINT_CENTER, EMOJI_PANEL_CENTER_X, EMOJI_PANEL_CENTER_Y)

    set i = 1
    loop
        exitwhen i > EmojiCount
        if IsEmojiAllowed(p, i) then
            set column = ModuloInteger(visibleSlot, EMOJI_COLUMNS)
            set row = visibleSlot / EMOJI_COLUMNS
            set x = 0.005 + I2R(column) * EMOJI_BUTTON_STEP
            set y = 0.005 + I2R(rows - 1 - row) * EMOJI_BUTTON_STEP

            call BlzFrameClearAllPoints(EmojiButton[i])
            call BlzFrameSetPoint(EmojiButton[i], FRAMEPOINT_BOTTOMLEFT, EmojiPanel, FRAMEPOINT_BOTTOMLEFT, x, y)
            call BlzFrameSetVisible(EmojiButton[i], true)
            set visibleSlot = visibleSlot + 1
        endif
        set i = i + 1
    endloop
endfunction

private function UpdateCooldownText takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())

    if EmojiPlayerCooldown[pid] > 0.05 then
        call BlzFrameSetText(EmojiCooldownText, "|cffffcc00Cooldown: " + R2SW(EmojiPlayerCooldown[pid], 0, 1) + "s|r")
    else
        call BlzFrameSetText(EmojiCooldownText, "|cff40ff40Ready|r")
    endif
endfunction

function Emoji_ShowMenu takes player p, boolean flag returns nothing
    local integer pid = GetPlayerId(p)

    if GetLocalPlayer() == p then
        set EmojiPanelOpen[pid] = flag
        if flag then
            call ApplyPaletteForPlayer(p)
            call UpdateCooldownText()
        else
            call HidePanelButtons()
        endif
        call BlzFrameSetVisible(EmojiPanel, flag)
        call BlzFrameSetVisible(EmojiCloseButton, flag)
        call BlzFrameSetVisible(EmojiCooldownText, flag)
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

    if GetLocalPlayer() == p then
        call BlzFrameSetEnable(clicked, false)
        call BlzFrameSetEnable(clicked, true)
    endif

    set clicked = null
    set p = null
endfunction

private function OnEmojiKey takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local oskeytype key = BlzGetTriggerPlayerKey()
    local integer metaKey = BlzGetTriggerPlayerMetaKey()
    local integer i = 1

    if key == EmojiMenuKey and metaKey == EmojiMenuMeta then
        call Emoji_ShowMenu(p, not EmojiPanelOpen[pid])
    else
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

    set EmojiPanel = BlzCreateFrameByType("BACKDROP", "WosEmojiPanel", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
    call BlzFrameSetSize(EmojiPanel, panelWidth, panelHeight)
    call BlzFrameSetAbsPoint(EmojiPanel, FRAMEPOINT_CENTER, EMOJI_PANEL_CENTER_X, EMOJI_PANEL_CENTER_Y)
    call BlzFrameSetTexture(EmojiPanel, "Textures\\black32.blp", 0, true)
    call BlzFrameSetAlpha(EmojiPanel, EMOJI_PANEL_ALPHA)
    call BlzFrameSetLevel(EmojiPanel, 1)
    call BlzFrameSetEnable(EmojiPanel, false)

    // Same close-button icon and button style as MusicPlayer.j.
    // It is parented to Game UI so the panel's transparency is not inherited.
    set EmojiCloseButton = BlzCreateFrameByType("BUTTON", "WosEmojiCloseButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetPoint(EmojiCloseButton, FRAMEPOINT_TOPRIGHT, EmojiPanel, FRAMEPOINT_TOPRIGHT, -0.004, -0.004)
    call BlzFrameSetSize(EmojiCloseButton, EMOJI_CLOSE_SIZE, EMOJI_CLOSE_SIZE)
    call BlzFrameSetLevel(EmojiCloseButton, 3)
    call BlzTriggerRegisterFrameEvent(EmojiFrameTrigger, EmojiCloseButton, FRAMEEVENT_CONTROL_CLICK)

    set EmojiCloseIcon = BlzCreateFrameByType("BACKDROP", "WosEmojiCloseIcon", EmojiCloseButton, "", 0)
    call BlzFrameSetAllPoints(EmojiCloseIcon, EmojiCloseButton)
    call BlzFrameSetTexture(EmojiCloseIcon, EMOJI_CLOSE_TEXTURE, 0, true)
    call BlzFrameSetEnable(EmojiCloseIcon, false)

    // Local status line inside the header: green when ready, countdown otherwise.
    set EmojiCooldownText = BlzCreateFrameByType("TEXT", "WosEmojiCooldownText", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
    call BlzFrameSetPoint(EmojiCooldownText, FRAMEPOINT_TOP, EmojiPanel, FRAMEPOINT_TOP, 0.000, -0.006)
    call BlzFrameSetSize(EmojiCooldownText, 0.145, 0.018)
    call BlzFrameSetTextAlignment(EmojiCooldownText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(EmojiCooldownText, 0.85)
    call BlzFrameSetLevel(EmojiCooldownText, 3)
    call BlzFrameSetEnable(EmojiCooldownText, false)
    call BlzFrameSetText(EmojiCooldownText, "|cff40ff40Ready|r")

    loop
        exitwhen i > EmojiCount
        set column = ModuloInteger(i - 1, EMOJI_COLUMNS)
        set row = (i - 1) / EMOJI_COLUMNS
        set x = 0.005 + I2R(column) * EMOJI_BUTTON_STEP
        set y = 0.005 + I2R(rows - 1 - row) * EMOJI_BUTTON_STEP

        // Same visual approach as CustomImage: a Warcraft button template with
        // a separate texture backdrop on top.
        set EmojiButton[i] = BlzCreateFrameByType("BUTTON", "WosEmojiButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "ScoreScreenTabButtonTemplate", 0)
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

    call BlzFrameSetVisible(EmojiPanel, false)
    call BlzFrameSetVisible(EmojiCloseButton, false)
    call BlzFrameSetVisible(EmojiCooldownText, false)
    call HidePanelButtons()
endfunction

private function RegisterKeys takes nothing returns nothing
    local integer pid = 0
    local integer i

    loop
        exitwhen pid >= bj_MAX_PLAYERS
        call BlzTriggerRegisterPlayerKeyEvent(EmojiKeyTrigger, Player(pid), EmojiMenuKey, EmojiMenuMeta, false)

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
    call TimerStart(EmojiTimer, EMOJI_PERIOD, true, function Periodic)
endfunction

endlibrary
