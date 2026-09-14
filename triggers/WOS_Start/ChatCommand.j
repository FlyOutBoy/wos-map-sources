library CustomImageChat initializer Init uses GearSystems
globals
    private integer array PlayerEmojiAccessLevel
endglobals
globals
    // -------------------------------------------------------------------------
    // LAYOUT: change only these values if the palette/feed overlaps another UI.
    // Warcraft UI coordinates normally use X = 0.00..0.80 and Y = 0.00..0.60.
    private constant real EMOJI_TOGGLE_X = 0.22
    private constant real EMOJI_TOGGLE_Y = 0.1325
    private constant real EMOJI_MUTE_X   = 0.25
    private constant real EMOJI_MUTE_Y   = 0.1325
    private constant real EMOJI_PANEL_X  = 0.390
    private constant real EMOJI_PANEL_Y  = 0.215
    private constant real EMOJI_FEED_X   = 0.12
    private constant real EMOJI_FEED_Y   = 0.20

    // Reserve enough IDs for future additions. Only registered/allowed IDs
    // actually create visible buttons.
    private constant integer EMOJI_MAX_TYPES = 50
    private constant integer EMOJI_FEED_SIZE = 5
    private constant integer EMOJI_COLUMNS   = 5

    // Both the main button and palette buttons are 20% smaller than before.
    private constant real EMOJI_TOGGLE_SIZE = 0.0224
    // Palette emojis are 20% larger: 0.0240 -> 0.0288.
    private constant real EMOJI_BUTTON_SIZE = 0.0288
    private constant real EMOJI_BUTTON_STEP = 0.0324
    private constant real EMOJI_ROW_HEIGHT  = 0.030
    private constant real EMOJI_DURATION    = 7.00
    private constant real EMOJI_FADE_TIME   = 1.25

    // false = clean button-only mode (recommended).
    // true  = exact words such as "kek" also post an emoji, but the native chat
    //         will still display the typed word because native chat cannot cancel it.
    private constant boolean EMOJI_ENABLE_TYPED_COMMANDS = false

     framehandle EmojiToggle = null
    private framehandle EmojiToggleIcon = null
     framehandle EmojiMuteButton = null
    private framehandle EmojiMuteIcon = null
    private framehandle EmojiPanel = null
    private framehandle array EmojiButton
    private framehandle array EmojiButtonIcon

    private framehandle array EmojiFeedName
    private framehandle array EmojiFeedIcon

    private string array EmojiPath
    string array ChatImageCommand
    integer ChatImageCommandCount = 0

    // Explicit access lists. Values are emoji IDs from RegisterDefaultEmojis.
    private integer array EmojiAccessFree
    private integer array EmojiAccessVIP3
    private integer array EmojiAccessVIP2
    private integer array EmojiAccessVIP1
    private integer EmojiAccessFreeCount = 0
    private integer EmojiAccessVIP3Count = 0
    private integer EmojiAccessVIP2Count = 0
    private integer EmojiAccessVIP1Count = 0

    private integer array FeedSenderPid
    private integer array FeedEmojiId
    private real array FeedAge
    private integer FeedCount = 0

    private trigger EmojiClickTrig = null
    private trigger EmojiSyncTrig = null
    private trigger EmojiTypedTrig = null
    private timer EmojiTimer = null
    private boolean EmojiPanelOpen = false
    private boolean array PlayerEmojiEnabled
endglobals
function CustomChat_SetPlayerAccessLevel takes player p, integer level returns nothing
    set PlayerEmojiAccessLevel[GetPlayerId(p)] = level
endfunction
private function GetColoredPlayerName takes player p returns string
    local integer id = GetPlayerId(p)

    if id == 0 then
        return "|cffff0303" + GetPlayerName(p)
    elseif id == 1 then
        return "|cff0042ff" + GetPlayerName(p)
    elseif id == 2 then
        return "|cff1be7ba" + GetPlayerName(p)
    elseif id == 3 then
        return "|cff550081" + GetPlayerName(p)
    elseif id == 4 then
        return "|cfffefc00" + GetPlayerName(p)
    elseif id == 5 then
        return "|cfffe890d" + GetPlayerName(p)
    elseif id == 6 then
        return "|cff21bf00" + GetPlayerName(p)
    elseif id == 7 then
        return "|cffe45caf" + GetPlayerName(p)
    elseif id == 8 then
        return "|cff939596" + GetPlayerName(p)
    elseif id == 9 then
        return "|cff7ebff1" + GetPlayerName(p)
    elseif id == 10 then
        return "|cff106247" + GetPlayerName(p)
    elseif id == 11 then
        return "|cff4f2b05" + GetPlayerName(p)
    endif

    return "|cffffffff" + GetPlayerName(p)
endfunction

// VIP3 is the highest level, then VIP2, VIP1 and finally the free list.
// If one nickname is present in several VIPCheck functions, the highest level wins.
private function GetEmojiAccessLevel takes player p returns integer
    return PlayerEmojiAccessLevel[GetPlayerId(p)]
endfunction

private function GetEmojiAccessCount takes integer accessLevel returns integer
    if accessLevel == 1 then
        return EmojiAccessVIP1Count
    elseif accessLevel == 2 then
        return EmojiAccessVIP2Count
    elseif accessLevel == 3 then
        return EmojiAccessVIP3Count
    endif

    return EmojiAccessFreeCount
endfunction

private function GetEmojiAccessId takes integer accessLevel, integer slot returns integer
    if accessLevel == 1 then
        return EmojiAccessVIP1[slot]
    elseif accessLevel == 2 then
        return EmojiAccessVIP2[slot]
    elseif accessLevel == 3 then
        return EmojiAccessVIP3[slot]
    endif

    return EmojiAccessFree[slot]
endfunction

private function IsEmojiAllowed takes player p, integer emojiId returns boolean
    local integer accessLevel = GetEmojiAccessLevel(p)
    local integer accessCount = GetEmojiAccessCount(accessLevel)
    local integer slot = 1

    loop
        exitwhen slot > accessCount

        if GetEmojiAccessId(accessLevel, slot) == emojiId then
            return true
        endif

        set slot = slot + 1
    endloop

    return false
endfunction

private function GetFeedAlpha takes integer index returns integer
    local real fadeStart = EMOJI_DURATION - EMOJI_FADE_TIME
    local integer alpha

    if FeedAge[index] <= fadeStart then
        return 255
    endif

    set alpha = 255 - R2I(((FeedAge[index] - fadeStart) / EMOJI_FADE_TIME) * 255.00)

    if alpha < 0 then
        return 0
    endif

    return alpha
endfunction

private function HideFeedFrames takes nothing returns nothing
    local integer i = 1

    loop
        exitwhen i > EMOJI_FEED_SIZE
        call BlzFrameSetVisible(EmojiFeedName[i], false)
        call BlzFrameSetVisible(EmojiFeedIcon[i], false)
        set i = i + 1
    endloop
endfunction

private function RenderFeed takes nothing returns nothing
    local integer i = 1
    local integer alpha
    local real y

    call HideFeedFrames()

    if not PlayerEmojiEnabled[GetPlayerId(GetLocalPlayer())] then
        return
    endif

    loop
        exitwhen i > FeedCount

        // The newest post stays at the bottom; older posts move upward.
        set y = I2R(FeedCount - i) * EMOJI_ROW_HEIGHT
        set alpha = GetFeedAlpha(i)

        call BlzFrameClearAllPoints(EmojiFeedName[i])
        call BlzFrameSetAbsPoint(EmojiFeedName[i], FRAMEPOINT_BOTTOMLEFT, EMOJI_FEED_X, EMOJI_FEED_Y + y + 0.005)
        call BlzFrameSetText(EmojiFeedName[i], GetColoredPlayerName(Player(FeedSenderPid[i])) + ":|r")
        call BlzFrameSetAlpha(EmojiFeedName[i], alpha)
        call BlzFrameSetVisible(EmojiFeedName[i], true)

        call BlzFrameClearAllPoints(EmojiFeedIcon[i])
        call BlzFrameSetAbsPoint(EmojiFeedIcon[i], FRAMEPOINT_BOTTOMLEFT, EMOJI_FEED_X + 0.105, EMOJI_FEED_Y + y)
        call BlzFrameSetTexture(EmojiFeedIcon[i], EmojiPath[FeedEmojiId[i]], 0, true)
        call BlzFrameSetAlpha(EmojiFeedIcon[i], alpha)
        call BlzFrameSetVisible(EmojiFeedIcon[i], true)

        set i = i + 1
    endloop
endfunction

private function ShiftFeedLeft takes nothing returns nothing
    local integer i = 1

    loop
        exitwhen i >= FeedCount
        set FeedSenderPid[i] = FeedSenderPid[i + 1]
        set FeedEmojiId[i] = FeedEmojiId[i + 1]
        set FeedAge[i] = FeedAge[i + 1]
        set i = i + 1
    endloop

    if FeedCount > 0 then
        set FeedSenderPid[FeedCount] = 0
        set FeedEmojiId[FeedCount] = 0
        set FeedAge[FeedCount] = 0.00
        set FeedCount = FeedCount - 1
    endif
endfunction

private function AddEmojiPost takes player sender, integer emojiId returns nothing
    if emojiId <= 0 or emojiId > ChatImageCommandCount or EmojiPath[emojiId] == "" then
        return
    endif

    // This is a local display preference. Feed arrays are used only by frames,
    // so clients are allowed to keep different local histories.
    if not PlayerEmojiEnabled[GetPlayerId(GetLocalPlayer())] then
        return
    endif

    if not IsEmojiAllowed(sender, emojiId) then
        return
    endif

    if FeedCount >= EMOJI_FEED_SIZE then
        call ShiftFeedLeft()
    endif

    set FeedCount = FeedCount + 1
    set FeedSenderPid[FeedCount] = GetPlayerId(sender)
    set FeedEmojiId[FeedCount] = emojiId
    set FeedAge[FeedCount] = 0.00

    call RenderFeed()
endfunction

private function EmojiPeriodic takes nothing returns nothing
    local integer i = 1

    loop
        exitwhen i > FeedCount
        set FeedAge[i] = FeedAge[i] + 0.05
        set i = i + 1
    endloop

    loop
        exitwhen FeedCount == 0 or FeedAge[1] < EMOJI_DURATION
        call ShiftFeedLeft()
    endloop

    call RenderFeed()
endfunction

private function OnEmojiSync takes nothing returns nothing
    local integer emojiId = S2I(BlzGetTriggerSyncData())

    if emojiId > 0 and emojiId <= ChatImageCommandCount then
        call AddEmojiPost(GetTriggerPlayer(), emojiId)
    endif
endfunction

private function HideEmojiPaletteButtons takes nothing returns nothing
    local integer i = 1

    loop
        exitwhen i > ChatImageCommandCount
        call BlzFrameSetVisible(EmojiButton[i], false)
        set i = i + 1
    endloop
endfunction

private function ApplyEmojiPaletteForPlayer takes player p returns nothing
    local integer accessLevel = GetEmojiAccessLevel(p)
    local integer accessCount = GetEmojiAccessCount(accessLevel)
    local integer visibleCount = 0
    local integer visibleSlot = 0
    local integer columnsUsed
    local integer rowsUsed
    local integer emojiId
    local integer column
    local integer row
    local integer i = 1
    local real panelWidth
    local real panelHeight
    local real x
    local real y

    // Hide the complete shared button pool first. Only the local player's
    // explicitly allowed IDs are made visible below.
    call HideEmojiPaletteButtons()

    set i = 1
    loop
        exitwhen i > accessCount
        set emojiId = GetEmojiAccessId(accessLevel, i)

        if emojiId > 0 and emojiId <= ChatImageCommandCount and EmojiPath[emojiId] != "" then
            set visibleCount = visibleCount + 1
        endif

        set i = i + 1
    endloop

    if visibleCount <= 0 then
        call BlzFrameSetSize(EmojiPanel, 0.040, 0.040)
        return
    endif

    set columnsUsed = visibleCount
    if columnsUsed > EMOJI_COLUMNS then
        set columnsUsed = EMOJI_COLUMNS
    endif

    set rowsUsed = (visibleCount + EMOJI_COLUMNS - 1) / EMOJI_COLUMNS
    set panelWidth = 0.010 + EMOJI_BUTTON_SIZE + I2R(columnsUsed - 1) * EMOJI_BUTTON_STEP
    set panelHeight = 0.010 + EMOJI_BUTTON_SIZE + I2R(rowsUsed - 1) * EMOJI_BUTTON_STEP
    call BlzFrameSetSize(EmojiPanel, panelWidth, panelHeight)

    set i = 1
    loop
        exitwhen i > accessCount
        set emojiId = GetEmojiAccessId(accessLevel, i)

        if emojiId > 0 and emojiId <= ChatImageCommandCount and EmojiPath[emojiId] != "" then
            set column = ModuloInteger(visibleSlot, EMOJI_COLUMNS)
            set row = visibleSlot / EMOJI_COLUMNS
            set x = 0.005 + I2R(column) * EMOJI_BUTTON_STEP
            set y = 0.005 + I2R(row) * EMOJI_BUTTON_STEP

            call BlzFrameClearAllPoints(EmojiButton[emojiId])
            call BlzFrameSetPoint(EmojiButton[emojiId], FRAMEPOINT_BOTTOMLEFT, EmojiPanel, FRAMEPOINT_BOTTOMLEFT, x, y)
            call BlzFrameSetVisible(EmojiButton[emojiId], true)

            set visibleSlot = visibleSlot + 1
        endif

        set i = i + 1
    endloop
endfunction

private function OnEmojiFrameClick takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local integer i = 1

    if clicked == EmojiToggle then
        if GetLocalPlayer() == p then
            set EmojiPanelOpen = not EmojiPanelOpen
            if EmojiPanelOpen then
                call ApplyEmojiPaletteForPlayer(p)
            else
                call HideEmojiPaletteButtons()
            endif
            call BlzFrameSetVisible(EmojiPanel, EmojiPanelOpen)
        endif
    elseif clicked == EmojiMuteButton then
        if GetLocalPlayer() == p then
            set PlayerEmojiEnabled[pid] = not PlayerEmojiEnabled[pid]

            if PlayerEmojiEnabled[pid] then
                // The button now offers the "block emojis" action.
                call BlzFrameSetTexture(EmojiMuteIcon, "Pick\\PickButton_Pick_Ban", 0, true)
            else
                // The button now offers the "enable emojis" action.
                call BlzFrameSetTexture(EmojiMuteIcon, "Pick\\PickButton_Pick_Manual", 0, true)
                set FeedCount = 0
                call HideFeedFrames()
            endif
        endif
    else
        loop
            exitwhen i > ChatImageCommandCount

            if clicked == EmojiButton[i] then
                if GetLocalPlayer() == p then
                    // Frame clicks are local; sync converts the click into one
                    // deterministic post received by every player.
                    call BlzSendSyncData("NEMJ", I2S(i))
                    set EmojiPanelOpen = false
                    call BlzFrameSetVisible(EmojiPanel, false)
                    call HideEmojiPaletteButtons()
                endif

                set i = ChatImageCommandCount + 1
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

private function OnTypedEmoji takes nothing returns nothing
    local string message = GetEventPlayerChatString()
    local integer i = 1

    loop
        exitwhen i > ChatImageCommandCount

        if message == ChatImageCommand[i] then
            // A native chat event is already synchronized, so no extra sync is needed.
            call AddEmojiPost(GetTriggerPlayer(), i)
            return
        endif

        set i = i + 1
    endloop
endfunction

// Compatibility API retained from the old CustomImageChat library.
function CustomChat_RegisterImage takes integer id, string path returns nothing
    if id > 0 and id <= EMOJI_MAX_TYPES then
        set EmojiPath[id] = path
    endif
endfunction

function CustomChat_RegisterCommand takes integer id, string command, string texture returns nothing
    if id > 0 and id <= EMOJI_MAX_TYPES then
        set ChatImageCommand[id] = command
        set EmojiPath[id] = texture

        if id > ChatImageCommandCount then
            set ChatImageCommandCount = id
        endif
    endif
endfunction

function CustomChat_SendImage takes player sender, integer imageId returns nothing
    call AddEmojiPost(sender, imageId)
endfunction

function ChatImageSend takes player sender, integer imageId returns nothing
    call CustomChat_SendImage(sender, imageId)
endfunction

private function RegisterDefaultEmojis takes nothing returns nothing
    // Change command names and imported texture paths here.
    call CustomChat_RegisterCommand(1,  "kek",     "war3mapImported\\Emoji_KEKW.blp")
    call CustomChat_RegisterCommand(2,  "sadge",   "war3mapImported\\Emoji_Sadge.blp")
    call CustomChat_RegisterCommand(3,  "pog",     "war3mapImported\\Emoji_pog.blp")
    call CustomChat_RegisterCommand(4,  "balance", "war3mapImported\\Emoji_balance.blp")
    call CustomChat_RegisterCommand(5,  "cringe",  "war3mapImported\\Emoji_cringe.blp")
    call CustomChat_RegisterCommand(6,  "cry",     "war3mapImported\\Emoji_cry.blp")
    call CustomChat_RegisterCommand(7,  "excited", "war3mapImported\\Emoji_excited.blp")
    call CustomChat_RegisterCommand(8,  "gay",     "war3mapImported\\Emoji_gay.blp")
    call CustomChat_RegisterCommand(9,  "gun",     "war3mapImported\\Emoji_gun.blp")
    call CustomChat_RegisterCommand(10, "heh",     "war3mapImported\\Emoji_heh.blp")
    call CustomChat_RegisterCommand(11, "oreha",   "war3mapImported\\Emoji_oreha.blp")
    call CustomChat_RegisterCommand(12, "poebat",  "war3mapImported\\Emoji_poebat.blp")
    call CustomChat_RegisterCommand(13, "pominki", "war3mapImported\\Emoji_pominki.blp")
    call CustomChat_RegisterCommand(14, "ustal",   "war3mapImported\\Emoji_ustal.blp")
    call CustomChat_RegisterCommand(15, "what",    "war3mapImported\\Emoji_whaaat.blp")
endfunction

private function ConfigureEmojiAccess takes nothing returns nothing
    // =====================================================================
    // FREE PLAYER: 5 explicitly selected emojis.
    // Change the Count and IDs below. IDs refer to RegisterDefaultEmojis.
    set EmojiAccessFreeCount = 5
    set EmojiAccessFree[1] = 1   // kek
    set EmojiAccessFree[2] = 2   // sadge
    set EmojiAccessFree[3] = 3   // pog
    set EmojiAccessFree[4] = 6   // cry
    set EmojiAccessFree[5] = 15  // what

    // VIP LEVEL 3 (HIGHEST): all 15 registered emojis.
    set EmojiAccessVIP3Count = 15
    set EmojiAccessVIP3[1] = 1
    set EmojiAccessVIP3[2] = 2
    set EmojiAccessVIP3[3] = 3
    set EmojiAccessVIP3[4] = 4
    set EmojiAccessVIP3[5] = 5
    set EmojiAccessVIP3[6] = 6
    set EmojiAccessVIP3[7] = 7
    set EmojiAccessVIP3[8] = 8
    set EmojiAccessVIP3[9] = 9
    set EmojiAccessVIP3[10] = 10
    set EmojiAccessVIP3[11] = 11
    set EmojiAccessVIP3[12] = 12
    set EmojiAccessVIP3[13] = 13
    set EmojiAccessVIP3[14] = 14
    set EmojiAccessVIP3[15] = 15

    // VIP LEVEL 2: 12 explicitly selected emojis.
    set EmojiAccessVIP2Count = 12
    set EmojiAccessVIP2[1] = 1
    set EmojiAccessVIP2[2] = 2
    set EmojiAccessVIP2[3] = 3
    set EmojiAccessVIP2[4] = 4
    set EmojiAccessVIP2[5] = 5
    set EmojiAccessVIP2[6] = 6
    set EmojiAccessVIP2[7] = 7
    set EmojiAccessVIP2[8] = 8
    set EmojiAccessVIP2[9] = 9
    set EmojiAccessVIP2[10] = 10
    set EmojiAccessVIP2[11] = 11
    set EmojiAccessVIP2[12] = 12

    // VIP LEVEL 1 (LOWEST VIP): 9 explicitly selected emojis.
    set EmojiAccessVIP1Count = 9
    set EmojiAccessVIP1[1] = 1
    set EmojiAccessVIP1[2] = 2
    set EmojiAccessVIP1[3] = 3
    set EmojiAccessVIP1[4] = 4
    set EmojiAccessVIP1[5] = 5
    set EmojiAccessVIP1[6] = 6
    set EmojiAccessVIP1[7] = 7
    set EmojiAccessVIP1[8] = 10
    set EmojiAccessVIP1[9] = 15
    // =====================================================================
endfunction

private function CreateEmojiFeed takes nothing returns nothing
    local integer i = 1

    loop
        exitwhen i > EMOJI_FEED_SIZE

        // These output frames are attached directly to Game UI. There is no
        // sized parent FRAME, so no invisible 0.145 x 0.150 mouse-blocking box.
        set EmojiFeedName[i] = BlzCreateFrameByType("TEXT", "NativeEmojiFeedName", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
        call BlzFrameSetSize(EmojiFeedName[i], 0.102, 0.018)
        call BlzFrameSetFont(EmojiFeedName[i], "Fonts\\FRIZQT__.TTF", 0.011, 0)
        call BlzFrameSetTextAlignment(EmojiFeedName[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_RIGHT)
        call BlzFrameSetEnable(EmojiFeedName[i], false)
        call BlzFrameSetVisible(EmojiFeedName[i], false)

        set EmojiFeedIcon[i] = BlzCreateFrameByType("BACKDROP", "NativeEmojiFeedIcon", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
        call BlzFrameSetSize(EmojiFeedIcon[i], 0.027, 0.027)
        call BlzFrameSetEnable(EmojiFeedIcon[i], false)
        call BlzFrameSetVisible(EmojiFeedIcon[i], false)

        set i = i + 1
    endloop
endfunction

private function CreateEmojiPalette takes nothing returns nothing
    local integer i = 1
    local integer column
    local integer row
    local real x
    local real y

    set EmojiToggle = BlzCreateFrameByType("BUTTON", "NativeEmojiToggle", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetAbsPoint(EmojiToggle, FRAMEPOINT_CENTER, EMOJI_TOGGLE_X, EMOJI_TOGGLE_Y)
    call BlzFrameSetSize(EmojiToggle, EMOJI_TOGGLE_SIZE, EMOJI_TOGGLE_SIZE)
    call BlzFrameSetVisible(EmojiToggle, false)
    set EmojiToggleIcon = BlzCreateFrameByType("BACKDROP", "NativeEmojiToggleIcon", EmojiToggle, "", 0)
    call BlzFrameSetAllPoints(EmojiToggleIcon, EmojiToggle)
    call BlzFrameSetTexture(EmojiToggleIcon, EmojiPath[1], 0, true)
    call BlzFrameSetEnable(EmojiToggleIcon, false)
    set EmojiMuteButton = BlzCreateFrameByType("BUTTON", "NativeEmojiMuteButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetAbsPoint(EmojiMuteButton, FRAMEPOINT_CENTER, EMOJI_MUTE_X, EMOJI_MUTE_Y)
    call BlzFrameSetSize(EmojiMuteButton, EMOJI_TOGGLE_SIZE, EMOJI_TOGGLE_SIZE)

    set EmojiMuteIcon = BlzCreateFrameByType("BACKDROP", "NativeEmojiMuteIcon", EmojiMuteButton, "", 0)
    call BlzFrameSetAllPoints(EmojiMuteIcon, EmojiMuteButton)
    call BlzFrameSetTexture(EmojiMuteIcon, "Pick\\PickButton_Pick_Ban", 0, true)
    call BlzFrameSetEnable(EmojiMuteIcon, false)
    
    call BlzFrameSetVisible(EmojiMuteButton, false)
    set EmojiPanel = BlzCreateFrameByType("BACKDROP", "NativeEmojiPanel", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
    call BlzFrameSetAbsPoint(EmojiPanel, FRAMEPOINT_BOTTOMLEFT, EMOJI_PANEL_X, EMOJI_PANEL_Y)
    call BlzFrameSetSize(EmojiPanel, 0.172, 0.106)
    call BlzFrameSetTexture(EmojiPanel, "Textures\\black32.blp", 0, true)
    call BlzFrameSetAlpha(EmojiPanel, 190)
    call BlzFrameSetLevel(EmojiPanel, 1)
    // Disable the semi-transparent backdrop itself. EmojiButton frames are
    // independent Game UI children and remain fully opaque/interactable.
    call BlzFrameSetEnable(EmojiPanel, false)

    loop
        exitwhen i > ChatImageCommandCount

        set column = ModuloInteger(i - 1, EMOJI_COLUMNS)
        set row = (i - 1) / EMOJI_COLUMNS
        set x = 0.005 + I2R(column) * EMOJI_BUTTON_STEP
        set y = 0.005 + I2R(2 - row) * EMOJI_BUTTON_STEP

        // Parent buttons directly to Game UI. EmojiPanel has alpha 190;
        // keeping buttons outside it prevents inherited transparency.
        set EmojiButton[i] = BlzCreateFrameByType("BUTTON", "NativeEmojiButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetPoint(EmojiButton[i], FRAMEPOINT_BOTTOMLEFT, EmojiPanel, FRAMEPOINT_BOTTOMLEFT, x, y)
        call BlzFrameSetSize(EmojiButton[i], EMOJI_BUTTON_SIZE, EMOJI_BUTTON_SIZE)
        call BlzFrameSetAlpha(EmojiButton[i], 255)
        call BlzFrameSetLevel(EmojiButton[i], 2)

        set EmojiButtonIcon[i] = BlzCreateFrameByType("BACKDROP", "NativeEmojiButtonIcon", EmojiButton[i], "", 0)
        call BlzFrameSetAllPoints(EmojiButtonIcon[i], EmojiButton[i])
        call BlzFrameSetTexture(EmojiButtonIcon[i], EmojiPath[i], 0, true)
        call BlzFrameSetAlpha(EmojiButtonIcon[i], 255)
        call BlzFrameSetEnable(EmojiButtonIcon[i], false)
        call BlzFrameSetVisible(EmojiButton[i], false)

        call BlzTriggerRegisterFrameEvent(EmojiClickTrig, EmojiButton[i], FRAMEEVENT_CONTROL_CLICK)

        set i = i + 1
    endloop

    call BlzTriggerRegisterFrameEvent(EmojiClickTrig, EmojiToggle, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(EmojiClickTrig, EmojiMuteButton, FRAMEEVENT_CONTROL_CLICK)
    call BlzFrameSetVisible(EmojiPanel, false)
endfunction

private function Init takes nothing returns nothing
    local integer i = 0

    call RegisterDefaultEmojis()
    call ConfigureEmojiAccess()

    set EmojiClickTrig = CreateTrigger()
    set EmojiSyncTrig = CreateTrigger()
    set EmojiTypedTrig = CreateTrigger()
    set EmojiTimer = CreateTimer()

    call CreateEmojiFeed()
    call CreateEmojiPalette()

    loop
        exitwhen i >= bj_MAX_PLAYERS

        set PlayerEmojiEnabled[i] = true
        call BlzTriggerRegisterPlayerSyncEvent(EmojiSyncTrig, Player(i), "NEMJ", false)

        if EMOJI_ENABLE_TYPED_COMMANDS then
            call TriggerRegisterPlayerChatEvent(EmojiTypedTrig, Player(i), "", false)
        endif

        set i = i + 1
    endloop

    call TriggerAddAction(EmojiClickTrig, function OnEmojiFrameClick)
    call TriggerAddAction(EmojiSyncTrig, function OnEmojiSync)

    if EMOJI_ENABLE_TYPED_COMMANDS then
        call TriggerAddAction(EmojiTypedTrig, function OnTypedEmoji)
    endif

    call TimerStart(EmojiTimer, 0.05, true, function EmojiPeriodic)

    // IMPORTANT: ORIGIN_FRAME_CHAT_MSG is intentionally never hidden.
    // Native chat remains fully functional and is not duplicated.
endfunction

endlibrary
