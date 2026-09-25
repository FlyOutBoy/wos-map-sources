globals
    // Captain Draft settings: edit only these values to tune the mode.
    integer CaptainDraftPreTime = 10
    integer CaptainDraftVoteTime = 10
    integer CaptainDraftBanTime = 15
    integer CaptainDraftPickTime = 30
    integer CaptainDraftClaimTime = 20
    integer CaptainDraftThinkTime = 60
    integer CaptainDraftBanTotal = 6
    integer CaptainDraftPickTotal = 10
    // Hero rawcode protected from bans only in Captain Draft. Keep 0 to
    // allow every hero (including Milim) to be banned.
    integer CaptainDraftBanImmuneHero = 0
    // Sound paths do not include the .mp3 extension. Empty string disables a sound.
    string CaptainDraftSoundTurn = "Pick\\PickCount2"
    string CaptainDraftSoundBanConfirm = "war3mapimported\\Hero_Rimuru_Death"
    string CaptainDraftSoundBanPhase = "war3mapimported\\Hero_Kyoraku_T16_1"
    string CaptainDraftSoundPickPhase = "war3mapimported\\Hero_Kyoraku_T16_1"
    // Plays once immediately after Captain Draft is selected, during the
    // countdown before the BAN phase.
    string CaptainDraftSoundModeStart = "war3mapimported\\Hero_Kyoraku_T1"
    // Plays once after the captains finish all picks and players may claim
    // one of their team's drafted heroes.
    string CaptainDraftSoundClaimPhase = "war3mapimported\\Hero_Kyoraku_T4"

    // Captain Draft UI positions. Change only these values to tune the layout.
    // Start text uses absolute screen coordinates.
    real CaptainDraftStartTextX = 0.40
    real CaptainDraftStartTextY = 0.198
    real CaptainDraftStartTextWidth = 0.320
    real CaptainDraftStartTextHeight = 0.026
    // BAN/PICK text offsets are relative to their corresponding action button.
    // Positive X moves right; positive Y moves up.
    real CaptainDraftBanTextOffsetX = 0.054
    real CaptainDraftBanTextOffsetY = 0.000
    real CaptainDraftBanTextWidth = 0.220
    real CaptainDraftBanTextHeight = 0.026
    real CaptainDraftPickTextOffsetX = -0.065
    real CaptainDraftPickTextOffsetY = 0.000
    real CaptainDraftPickTextWidth = 0.220
    real CaptainDraftPickTextHeight = 0.026
    // Final player-claim text uses absolute screen coordinates.
    real CaptainDraftClaimTextX = 0.400
    real CaptainDraftClaimTextY = 0.198
    real CaptainDraftClaimTextWidth = 0.320
    real CaptainDraftClaimTextHeight = 0.026
    // Moving PanelX/PanelY moves the BANS frame, label and every icon together.
    real CaptainDraftPanelX = 0.394
    real CaptainDraftPanelY = 0.1225
    real CaptainDraftPanelWidth = 0.285
    real CaptainDraftPanelHeight = 0.054
    real CaptainDraftBanLabelOffsetX = 0.020
    real CaptainDraftBanLabelOffsetY = 0.000
    real CaptainDraftBanFirstIconOffsetX = 0.071
    real CaptainDraftBanIconOffsetY = 0.000
    real CaptainDraftBanIconStepX = 0.026
    real CaptainDraftBanIconSize = 0.024
    // Normal mode uses 0.001 for a 0.035 icon. This is proportional to 0.024,
    // with a small extra margin so the effect remains clearly visible.
    real CaptainDraftBanEffectScale = 0.00075

    integer CaptainDraftStage = 0
    integer CaptainDraftTurn = 0
    integer CaptainDraftTime = 0
    integer CaptainDraftBanCount = 0
    integer CaptainDraftPickCount = 0
    integer CaptainDraftClaimCount = 0
    integer CaptainDraftCaptain1 = 0
    integer CaptainDraftCaptain2 = 5
    integer CaptainDraftFirstSide = 0
    integer CaptainDraftVoteTeam1 = 0
    integer CaptainDraftVoteTeam2 = 0
    boolean CaptainDraftVoteActive = false
    boolean CaptainDraftVoteFinished = false
    boolean array CaptainDraftPlayerVoted
    dialog CaptainDraftVoteDialog = null
    button CaptainDraftVoteButton1 = null
    button CaptainDraftVoteButton2 = null
    trigger CaptainDraftVoteTrigger = null
    timer CaptainDraftVoteTimer = null
    integer CaptainDraftActionCount = 0
    integer array CaptainDraftActionType
    integer array CaptainDraftActionSide
    integer array CaptainDraftBannedHero
    integer array CaptainDraftPickedHero
    integer array CaptainDraftTeamPickCount
    integer array CaptainDraftClaimedBy
    integer array CaptainDraftPlayerHero
    integer CaptainDraftClaimTargetCount = 0
    boolean CaptainDraftFinished = false
    boolean CaptainDraftUICreated = false
    framehandle CaptainDraftPanel
    framehandle CaptainDraftStatus
    framehandle CaptainDraftBanLabel
    framehandle array CaptainDraftBanButton
    framehandle array CaptainDraftBanIcon
    framehandle array CaptainDraftBanTooltip
    framehandle array CaptainDraftBanTooltipText
    framehandle array CaptainDraftBanHighlight
    framehandle array CaptainDraftClaimHover
    timer array CaptainDraftBanEffectTimer
    trigger CaptainDraftHoverTrigger = null
    boolean CaptainDraftPagesDirty = false
    boolean CaptainDraftPostCreatePending = false
    boolean CaptainDraftFinishPending = false
    boolean CaptainDraftConfirmBusy = false
    // Remains true during the post-draft preparation even after
    // CaptainDraftMode itself is switched off by CaptainDraft_Finish.
    boolean CaptainDraftPreRoundUnlimitedSwap = false
endglobals
function AAAAATojiZeroManaPeriodic2 takes nothing returns nothing
    local integer pid = 0
    local unit u

    loop
        exitwhen pid >= 10
        set u = Hero[pid]

        if u != null and GetUnitTypeId(u) == Toji_ID then
            // Сначала убираем максимум, затем текущее значение.
            // Это исправляет повторное появление маны после снятия предметов
            // с интеллектом и пересчёта максимального запаса маны.
            call BlzSetUnitMaxMana(u, 0)
            call SetUnitState(u, UNIT_STATE_MANA, 0.0)
        endif

        set pid = pid + 1
    endloop

    set u = null
endfunction
// Dota-style Captain Draft
//===========================================================================
function CaptainDraft_IsPlaying takes integer pid returns boolean
    return pid >= 0 and pid < 10 and GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(pid)) == MAP_CONTROL_USER
endfunction

function CaptainDraft_FinishFirstSideVote takes nothing returns nothing
    local integer pid = 0
    if not CaptainDraftVoteActive then
        return
    endif
    set CaptainDraftVoteActive = false
    set CaptainDraftVoteFinished = true
    if CaptainDraftVoteTeam1 > CaptainDraftVoteTeam2 then
        set CaptainDraftFirstSide = 0
    elseif CaptainDraftVoteTeam2 > CaptainDraftVoteTeam1 then
        set CaptainDraftFirstSide = 1
    else
        set CaptainDraftFirstSide = GetRandomInt(0, 1)
    endif
    loop
        exitwhen pid >= 10
        if CaptainDraft_IsPlaying(pid) then
            call DialogDisplay(Player(pid), CaptainDraftVoteDialog, false)
        endif
        set pid = pid + 1
    endloop
    if CaptainDraftFirstSide == 0 then
        call PlayersMsg("|cffffd36bCaptain Draft: Team 1 won the vote and acts first.|r", 1)
    else
        call PlayersMsg("|cffffd36bCaptain Draft: Team 2 won the vote and acts first.|r", 1)
    endif
    if CaptainDraftVoteTimer != null then
        call PauseTimer(CaptainDraftVoteTimer)
        call DestroyTimer(CaptainDraftVoteTimer)
        set CaptainDraftVoteTimer = null
    endif
    if CaptainDraftVoteTrigger != null then
        call DestroyTrigger(CaptainDraftVoteTrigger)
        set CaptainDraftVoteTrigger = null
    endif
    if CaptainDraftVoteDialog != null then
        call DialogDestroy(CaptainDraftVoteDialog)
        set CaptainDraftVoteDialog = null
    endif
    set CaptainDraftVoteButton1 = null
    set CaptainDraftVoteButton2 = null
endfunction

function CaptainDraft_OnFirstSideVote takes nothing returns nothing
    local integer pid = GetPlayerId(GetTriggerPlayer())
    local button clicked = GetClickedButton()
    if CaptainDraftVoteActive and CaptainDraft_IsPlaying(pid) and not CaptainDraftPlayerVoted[pid] then
        set CaptainDraftPlayerVoted[pid] = true
        if clicked == CaptainDraftVoteButton1 then
            set CaptainDraftVoteTeam1 = CaptainDraftVoteTeam1 + 1
        elseif clicked == CaptainDraftVoteButton2 then
            set CaptainDraftVoteTeam2 = CaptainDraftVoteTeam2 + 1
        endif
        call DialogDisplay(Player(pid), CaptainDraftVoteDialog, false)
    endif
    set clicked = null
endfunction

function CaptainDraft_StartFirstSideVote takes nothing returns nothing
    local integer pid = 0
    set CaptainDraftVoteTeam1 = 0
    set CaptainDraftVoteTeam2 = 0
    set CaptainDraftVoteActive = true
    set CaptainDraftVoteFinished = false
    set CaptainDraftFirstSide = 0
    loop
        exitwhen pid >= 10
        set CaptainDraftPlayerVoted[pid] = false
        set pid = pid + 1
    endloop
    set CaptainDraftVoteDialog = DialogCreate()
    call DialogSetMessage(CaptainDraftVoteDialog, "Who gets the first pick? (" + I2S(CaptainDraftVoteTime) + " sec)")
    set CaptainDraftVoteButton1 = DialogAddButton(CaptainDraftVoteDialog, "Team 1 starts", 0)
    set CaptainDraftVoteButton2 = DialogAddButton(CaptainDraftVoteDialog, "Team 2 starts", 0)
    set CaptainDraftVoteTrigger = CreateTrigger()
    call TriggerRegisterDialogEvent(CaptainDraftVoteTrigger, CaptainDraftVoteDialog)
    call TriggerAddAction(CaptainDraftVoteTrigger, function CaptainDraft_OnFirstSideVote)
    set pid = 0
    loop
        exitwhen pid >= 10
        if CaptainDraft_IsPlaying(pid) then
            call DialogDisplay(Player(pid), CaptainDraftVoteDialog, true)
        endif
        set pid = pid + 1
    endloop
    set CaptainDraftVoteTimer = CreateTimer()
    call TimerStart(CaptainDraftVoteTimer, I2R(CaptainDraftVoteTime), false, function CaptainDraft_FinishFirstSideVote)
    call PlayersMsg("|cffffd36bVote for the team that gets the first pick. You have " + I2S(CaptainDraftVoteTime) + " seconds.|r", 1)
endfunction

function CaptainDraft_PlayConfiguredSound takes string soundPath returns nothing
    if soundPath != "" then
        call MakeSound(soundPath)
    endif
endfunction

function CaptainDraft_HeroUsed takes integer heroId returns boolean
    local integer i = 0
    loop
        exitwhen i >= CaptainDraftBanCount
        if CaptainDraftBannedHero[i] == heroId then
            return true
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 10
        if CaptainDraftPickedHero[i] == heroId then
            return true
        endif
        set i = i + 1
    endloop
    return false
endfunction

function CaptainDraft_GetHeroIdRaw takes integer page, integer slot returns integer
    if page == 1 then
        return Hero_ID0[slot]
    elseif page == 2 then
        return Hero_ID1[slot]
    elseif page == 3 then
        return Hero_ID2[slot]
    elseif page == 4 then
        return Hero_ID3[slot]
    elseif page == 5 then
        return Hero_ID4[slot]
    elseif page == 6 then
        return Hero_ID5[slot]
    endif
    return 0
endfunction

function CaptainDraft_SetHeroIdRaw takes integer page, integer slot, integer heroId returns nothing
    if page == 1 then
        set Hero_ID0[slot] = heroId
    elseif page == 2 then
        set Hero_ID1[slot] = heroId
    elseif page == 3 then
        set Hero_ID2[slot] = heroId
    elseif page == 4 then
        set Hero_ID3[slot] = heroId
    elseif page == 5 then
        set Hero_ID4[slot] = heroId
    elseif page == 6 then
        set Hero_ID5[slot] = heroId
    endif
endfunction

function CaptainDraft_HeroExistsRaw takes integer heroId returns boolean
    local integer page = 1
    local integer slot
    if heroId == 0 or heroId == 12 then
        return false
    endif
    loop
        exitwhen page > 6
        set slot = 0
        loop
            exitwhen slot >= 30
            if CaptainDraft_GetHeroIdRaw(page, slot) == heroId then
                return true
            endif
            set slot = slot + 1
        endloop
        set page = page + 1
    endloop
    return false
endfunction

function CaptainDraft_IsHeroTypeBannedRaw takes integer heroId returns boolean
    local integer i = 0
    loop
        exitwhen i >= BannedHeroCount
        if BannedHeroType[i] == heroId then
            return true
        endif
        set i = i + 1
    endloop
    return false
endfunction

function CaptainDraft_LockBannedHero takes integer heroId returns nothing
    local integer page = 1
    local integer slot
    local boolean found = false
    if heroId == 0 or heroId == 12 or CaptainDraft_IsHeroTypeBannedRaw(heroId) then
        return
    endif
    loop
        exitwhen page > 6
        set slot = 0
        loop
            exitwhen slot >= 30
            if CaptainDraft_GetHeroIdRaw(page, slot) == heroId then
                set BanLockedHeroTypeBySlot[(page - 1) * 30 + slot] = heroId
                call CaptainDraft_SetHeroIdRaw(page, slot, 12)
                set found = true
            endif
            set slot = slot + 1
        endloop
        set page = page + 1
    endloop
    if found then
        set BannedHeroType[BannedHeroCount] = heroId
        set BannedHeroCount = BannedHeroCount + 1
    endif
endfunction

function CaptainDraft_IsBanImmune takes integer heroId returns boolean
    return CaptainDraftBanImmuneHero != 0 and heroId == CaptainDraftBanImmuneHero
endfunction

function CaptainDraft_FindRandomHero takes boolean forBan returns integer
    local integer page = 1
    local integer slot
    local integer heroId
    local integer available = 0
    local integer chosen = 0

    loop
        exitwhen page > 6
        set slot = 0
        loop
            exitwhen slot >= 30
            set heroId = CaptainDraft_GetHeroIdRaw(page, slot)
            if heroId != 0 and heroId != 12 and not CaptainDraft_HeroUsed(heroId) and (not forBan or not CaptainDraft_IsBanImmune(heroId)) then
                set available = available + 1
                if GetRandomInt(1, available) == 1 then
                    set chosen = heroId
                endif
            endif
            set slot = slot + 1
        endloop
        set page = page + 1
    endloop
    return chosen
endfunction

function CaptainDraft_HideLegacyUI takes nothing returns nothing
    local integer i = 0
    local integer localPid = GetPlayerId(GetLocalPlayer())

    // The normal picker creates a red ban sprite for every player. Captain
    // Draft has its own BAN row, so those old sprites must not duplicate it.
    if FRAME_BanSpinSprite != null then
        call BlzFrameSetVisible(FRAME_BanSpinSprite, false)
    endif
    loop
        exitwhen i >= 10
        if FRAME_BanHighlight[i] != null then
            call BlzFrameSetVisible(FRAME_BanHighlight[i], false)
        endif
        set i = i + 1
    endloop
    if FRAME_PlayerPickDifficultText != null then
        call BlzFrameSetVisible(FRAME_PlayerPickDifficultText, false)
    endif
    if FRAME_Pick[3] != null then
        call BlzFrameSetVisible(FRAME_Pick[3], false)
    endif
    // Observers watch the complete ban/pick draft. Hide the picker from them
    // only when players begin claiming their team's drafted heroes.
    if CaptainDraftStage == 3 and localPid >= 10 and localPid < 15 and FRAME_MAIN != null then
        call BlzFrameSetVisible(FRAME_MAIN, false)
    endif
endfunction

function CaptainDraft_SetStatus takes string text returns nothing
    if FRAME_TimerToStart != null then
        call BlzFrameSetText(FRAME_TimerToStart, text)
    endif
    if CaptainDraftStatus != null then
        call BlzFrameSetText(CaptainDraftStatus, text)
    endif
endfunction

function CaptainDraft_PositionStatus takes nothing returns nothing
    if FRAME_TimerToStart == null then
        return
    endif
    call BlzFrameClearAllPoints(FRAME_TimerToStart)
    if CaptainDraftStage == 1 then
        // During BAN the text occupies the free space to the left of the ban button.
        call BlzFrameSetSize(FRAME_TimerToStart, CaptainDraftBanTextWidth, CaptainDraftBanTextHeight)
        call BlzFrameSetPoint(FRAME_TimerToStart, FRAMEPOINT_RIGHT, FRAME_Pick[4], FRAMEPOINT_LEFT, CaptainDraftBanTextOffsetX, CaptainDraftBanTextOffsetY)
        call BlzFrameSetTextAlignment(FRAME_TimerToStart, TEXT_JUSTIFY_RIGHT, TEXT_JUSTIFY_MIDDLE)
    elseif CaptainDraftStage == 2 then
        // During PICK it starts after the green button and has enough width for a full nickname.
        call BlzFrameSetSize(FRAME_TimerToStart, CaptainDraftPickTextWidth, CaptainDraftPickTextHeight)
        call BlzFrameSetPoint(FRAME_TimerToStart, FRAMEPOINT_LEFT, FRAME_Pick[2], FRAMEPOINT_RIGHT, CaptainDraftPickTextOffsetX, CaptainDraftPickTextOffsetY)
        call BlzFrameSetTextAlignment(FRAME_TimerToStart, TEXT_JUSTIFY_LEFT, TEXT_JUSTIFY_MIDDLE)
    elseif CaptainDraftStage == 0 then
        call BlzFrameSetAbsPoint(FRAME_TimerToStart, FRAMEPOINT_CENTER, CaptainDraftStartTextX, CaptainDraftStartTextY)
        call BlzFrameSetSize(FRAME_TimerToStart, CaptainDraftStartTextWidth, CaptainDraftStartTextHeight)
        call BlzFrameSetTextAlignment(FRAME_TimerToStart, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
    else
        call BlzFrameSetAbsPoint(FRAME_TimerToStart, FRAMEPOINT_CENTER, CaptainDraftClaimTextX, CaptainDraftClaimTextY)
        call BlzFrameSetSize(FRAME_TimerToStart, CaptainDraftClaimTextWidth, CaptainDraftClaimTextHeight)
        call BlzFrameSetTextAlignment(FRAME_TimerToStart, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
    endif
endfunction

function CaptainDraft_HideBanEffect takes nothing returns nothing
    local timer expired = GetExpiredTimer()
    local integer i = 0
    loop
        exitwhen i >= 10
        if CaptainDraftBanEffectTimer[i] == expired then
            if CaptainDraftBanHighlight[i] != null then
                call BlzFrameSetVisible(CaptainDraftBanHighlight[i], false)
            endif
            call PauseTimer(expired)
            call DestroyTimer(expired)
            set CaptainDraftBanEffectTimer[i] = null
            set expired = null
            return
        endif
        set i = i + 1
    endloop
    call PauseTimer(expired)
    call DestroyTimer(expired)
    set expired = null
endfunction

function CaptainDraft_PlayBanEffect takes integer slot returns nothing
    if slot < 0 or slot >= CaptainDraftBanTotal or CaptainDraftBanHighlight[slot] == null then
        return
    endif
    if CaptainDraftBanEffectTimer[slot] != null then
        call PauseTimer(CaptainDraftBanEffectTimer[slot])
        call DestroyTimer(CaptainDraftBanEffectTimer[slot])
    endif
    call BlzFrameSetVisible(CaptainDraftBanHighlight[slot], true)
    call BlzFrameSetSpriteAnimate(CaptainDraftBanHighlight[slot], 0, 0)
    set CaptainDraftBanEffectTimer[slot] = CreateTimer()
    call TimerStart(CaptainDraftBanEffectTimer[slot], 2.0, false, function CaptainDraft_HideBanEffect)
endfunction

function CaptainDraft_CanHoverClaimSlot takes integer slot returns boolean
    local integer pid = GetPlayerId(GetLocalPlayer())
    return CaptainDraftMode and CaptainDraftStage == 3 and pid >= 0 and pid < 10 and CaptainDraft_IsPlaying(pid) and CaptainDraftPlayerHero[pid] == 0 and slot >= 0 and slot < 10 and CaptainDraftPickedHero[slot] != 0 and CaptainDraftClaimedBy[slot] < 0 and ((pid < 5 and slot < 5) or (pid >= 5 and slot >= 5))
endfunction

function CaptainDraft_OnClaimHover takes nothing returns nothing
    local framehandle hovered = BlzGetTriggerFrame()
    local frameeventtype eventType = BlzGetTriggerFrameEvent()
    local integer i = 0
    loop
        exitwhen i >= 10
        if hovered == FRAME_PlayerPick[i] then
            if eventType == FRAMEEVENT_MOUSE_ENTER and CaptainDraft_CanHoverClaimSlot(i) then
                call BlzFrameSetVisible(CaptainDraftClaimHover[i], true)
                call BlzFrameSetSpriteAnimate(CaptainDraftClaimHover[i], 0, 0)
            else
                call BlzFrameSetVisible(CaptainDraftClaimHover[i], false)
            endif
            set hovered = null
            set eventType = null
            return
        endif
        set i = i + 1
    endloop
    set hovered = null
    set eventType = null
endfunction

function CaptainDraft_UpdateRows takes nothing returns nothing
    local integer i = 0
    local string icon
    local integer heroId

    loop
        exitwhen i >= CaptainDraftBanTotal
        set heroId = CaptainDraftBannedHero[i]
        if heroId != 0 then
            call BlzFrameSetTexture(CaptainDraftBanIcon[i], ConvertBTNtoDISBTN(BlzGetAbilityIcon(heroId)), 0, false)
            call BlzFrameSetText(CaptainDraftBanTooltipText[i], "|cffffd36b" + GetObjectName(heroId) + "|r")
            call BlzFrameSetEnable(CaptainDraftBanButton[i], true)
        else
            call BlzFrameSetTexture(CaptainDraftBanIcon[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
            call BlzFrameSetText(CaptainDraftBanTooltipText[i], "")
            // Keep the tooltip handle attached for the entire game. Replacing
            // it with null while the mouse moves between slots can crash the UI.
            call BlzFrameSetEnable(CaptainDraftBanButton[i], false)
        endif
        set i = i + 1
    endloop

    set i = 0
    loop
        exitwhen i >= 10
        set heroId = CaptainDraftPickedHero[i]
        if heroId != 0 then
            set icon = BlzGetAbilityIcon(heroId)
            if CaptainDraftClaimedBy[i] >= 0 then
                set icon = ConvertBTNtoDISBTN(icon)
            endif
            call BlzFrameSetTexture(FRAME_PlayerPickBack[i], icon, 0, false)
        else
            call BlzFrameSetTexture(FRAME_PlayerPickBack[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        endif
        if heroId != 0 and CaptainDraftClaimedBy[i] >= 0 then
            call BlzFrameSetText(FRAME_PlayerPickText[i], SplitName(GetPlayerName(Player(CaptainDraftClaimedBy[i]))))
            call BlzFrameSetVisible(FRAME_PlayerPickText[i], true)
        else
            call BlzFrameSetText(FRAME_PlayerPickText[i], "")
            call BlzFrameSetVisible(FRAME_PlayerPickText[i], false)
        endif
        set i = i + 1
    endloop

    set icon = null
endfunction

function CaptainDraft_UpdateControls takes nothing returns nothing
    local integer i = 0
    local integer activePid = -1
    local integer localPid = GetPlayerId(GetLocalPlayer())

    if CaptainDraftStage == 1 then
        if CaptainDraftActionSide[CaptainDraftTurn] == 0 then
            set activePid = CaptainDraftCaptain1
        else
            set activePid = CaptainDraftCaptain2
        endif
    elseif CaptainDraftStage == 2 then
        if CaptainDraftActionSide[CaptainDraftTurn] == 0 then
            set activePid = CaptainDraftCaptain1
        else
            set activePid = CaptainDraftCaptain2
        endif
    endif

    call BlzFrameSetEnable(FRAME_Pick[2], false)
    call BlzFrameSetEnable(FRAME_Pick[3], false)
    call BlzFrameSetEnable(FRAME_Pick[4], false)
    call BlzFrameSetEnable(FRAME_ICON_Pick[2], false)
    call BlzFrameSetEnable(FRAME_ICON_Pick[3], false)
    call BlzFrameSetEnable(FRAME_ICON_Pick[4], false)
    call BlzFrameSetTexture(FRAME_ICON_Pick[2], "Pick\\PickButton_Pick_Manual2", 0, true)
    call BlzFrameSetTexture(FRAME_ICON_Pick[4], "Pick\\PickButton_Pick_Ban2", 0, true)
    call BlzFrameSetVisible(FRAME_Pick[2], CaptainDraftStage == 2)
    call BlzFrameSetVisible(FRAME_Pick[3], false)
    call BlzFrameSetVisible(FRAME_Pick[4], CaptainDraftStage == 1)

    if activePid >= 0 and GetLocalPlayer() == Player(activePid) then
        if CaptainDraftStage == 1 then
            call BlzFrameSetTexture(FRAME_ICON_Pick[4], "Pick\\PickButton_Pick_Ban", 0, true)
            call BlzFrameSetEnable(FRAME_Pick[4], true)
            call BlzFrameSetEnable(FRAME_ICON_Pick[4], true)
        else
            call BlzFrameSetEnable(FRAME_Pick[2], true)
            call BlzFrameSetEnable(FRAME_ICON_Pick[2], true)
            call BlzFrameSetTexture(FRAME_ICON_Pick[2], "Pick\\PickButton_Pick_Manual", 0, true)
        endif
    endif

    set i = 0
    loop
        exitwhen i >= 10
        call BlzFrameSetEnable(FRAME_PlayerPick[i], false)
        if not CaptainDraft_CanHoverClaimSlot(i) then
            call BlzFrameSetVisible(CaptainDraftClaimHover[i], false)
        endif
        set i = i + 1
    endloop

    if CaptainDraftStage == 3 and localPid >= 0 and localPid < 10 and CaptainDraft_IsPlaying(localPid) and CaptainDraftPlayerHero[localPid] == 0 then
        set i = 0
        loop
            exitwhen i >= 10
            if CaptainDraftPickedHero[i] != 0 and CaptainDraftClaimedBy[i] < 0 and ((localPid < 5 and i < 5) or (localPid >= 5 and i >= 5)) then
                call BlzFrameSetEnable(FRAME_PlayerPick[i], true)
            endif
            set i = i + 1
        endloop
    endif
endfunction

function CaptainDraft_CreateUI takes nothing returns nothing
    local integer i = 0
    local framehandle tooltip
    local framehandle tooltipText
    local framehandle parent = BlzGetFrameByName("ConsoleUIBackdrop", 0)

    if CaptainDraftUICreated then
        return
    endif
    set CaptainDraftUICreated = true
    set CaptainDraftHoverTrigger = CreateTrigger()
    call TriggerAddAction(CaptainDraftHoverTrigger, function CaptainDraft_OnClaimHover)
    // A tight scoreboard-style border around BANS only; no opaque black plate.
    set CaptainDraftPanel = BlzCreateFrame("ListBoxWar3", parent, 0, 9500)
    call BlzFrameSetAbsPoint(CaptainDraftPanel, FRAMEPOINT_CENTER, CaptainDraftPanelX, CaptainDraftPanelY)
    call BlzFrameSetSize(CaptainDraftPanel, CaptainDraftPanelWidth, CaptainDraftPanelHeight)

    set CaptainDraftStatus = BlzCreateFrameByType("TEXT", "CaptainDraftStatus", CaptainDraftPanel, "", 9501)
    call BlzFrameSetAbsPoint(CaptainDraftStatus, FRAMEPOINT_CENTER, CaptainDraftStartTextX, CaptainDraftStartTextY)
    call BlzFrameSetSize(CaptainDraftStatus, 0.28, 0.018)
    call BlzFrameSetTextAlignment(CaptainDraftStatus, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
    call BlzFrameSetScale(CaptainDraftStatus, 1.0)
    call BlzFrameSetVisible(CaptainDraftStatus, false)

    set CaptainDraftBanLabel = BlzCreateFrameByType("TEXT", "CaptainDraftBanLabel", CaptainDraftPanel, "", 9502)
    call BlzFrameSetPoint(CaptainDraftBanLabel, FRAMEPOINT_LEFT, CaptainDraftPanel, FRAMEPOINT_LEFT, CaptainDraftBanLabelOffsetX, CaptainDraftBanLabelOffsetY)
    call BlzFrameSetSize(CaptainDraftBanLabel, 0.038, 0.012)
    call BlzFrameSetText(CaptainDraftBanLabel, "|cffff6060BANS|r")
    call BlzFrameSetScale(CaptainDraftBanLabel, 0.78)

    loop
        exitwhen i >= CaptainDraftBanTotal
        set CaptainDraftBanButton[i] = BlzCreateFrameByType("BUTTON", "CaptainDraftBanButton", CaptainDraftPanel, "ScoreScreenTabButtonTemplate", 9510 + i)
        call BlzFrameSetPoint(CaptainDraftBanButton[i], FRAMEPOINT_CENTER, CaptainDraftPanel, FRAMEPOINT_LEFT, CaptainDraftBanFirstIconOffsetX + I2R(i) * CaptainDraftBanIconStepX, CaptainDraftBanIconOffsetY)
        call BlzFrameSetSize(CaptainDraftBanButton[i], CaptainDraftBanIconSize, CaptainDraftBanIconSize)
        set CaptainDraftBanIcon[i] = BlzCreateFrameByType("BACKDROP", "CaptainDraftBanIcon", CaptainDraftBanButton[i], "", 9520 + i)
        call BlzFrameSetAllPoints(CaptainDraftBanIcon[i], CaptainDraftBanButton[i])
        call BlzFrameSetTexture(CaptainDraftBanIcon[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        set tooltip = BlzCreateFrameByType("BACKDROP", "CaptainDraftBanTooltip", CaptainDraftPanel, "", 9550 + i)
        call BlzFrameSetPoint(tooltip, FRAMEPOINT_BOTTOM, CaptainDraftBanButton[i], FRAMEPOINT_TOP, 0.0, 0.003)
        call BlzFrameSetSize(tooltip, 0.090, 0.018)
        call BlzFrameSetTexture(tooltip, "Textures\\black32.blp", 0, true)
        call BlzFrameSetAlpha(tooltip, 235)
        call BlzFrameSetLevel(tooltip, 9700)
        set tooltipText = BlzCreateFrameByType("TEXT", "CaptainDraftBanTooltipText", tooltip, "", 9560 + i)
        call BlzFrameSetAllPoints(tooltipText, tooltip)
        call BlzFrameSetTextAlignment(tooltipText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetScale(tooltipText, 0.82)
        call BlzFrameSetText(tooltipText, "")
        call BlzFrameSetVisible(tooltip, false)
        call BlzFrameSetTooltip(CaptainDraftBanButton[i], tooltip)
        set CaptainDraftBanTooltip[i] = tooltip
        set CaptainDraftBanTooltipText[i] = tooltipText
        set CaptainDraftBanHighlight[i] = BlzCreateFrameByType("SPRITE", "CaptainDraftBanHighlight", CaptainDraftPanel, "WarCraftIIILogo", 9570 + i)
        call BlzFrameSetPoint(CaptainDraftBanHighlight[i], FRAMEPOINT_CENTER, CaptainDraftBanButton[i], FRAMEPOINT_CENTER, 0.0, 0.0)
        call BlzFrameSetSize(CaptainDraftBanHighlight[i], 0.01, 0.01)
        call BlzFrameSetLevel(CaptainDraftBanHighlight[i], 10)
        call BlzFrameSetScale(CaptainDraftBanHighlight[i], CaptainDraftBanEffectScale)
        call BlzFrameSetModel(CaptainDraftBanHighlight[i], "war3mapImported\\wos_az_ui_baoji.mdl", 0)
        call BlzFrameSetVisible(CaptainDraftBanHighlight[i], false)
        set i = i + 1
    endloop

    set i = 0
    loop
        exitwhen i >= 10
        set CaptainDraftClaimHover[i] = BlzCreateFrameByType("SPRITE", "CaptainDraftClaimHover", FRAME_MAIN, "WarCraftIIILogo", 9590 + i)
        call BlzFrameSetPoint(CaptainDraftClaimHover[i], FRAMEPOINT_LEFT, FRAME_PlayerPick[i], FRAMEPOINT_LEFT, -0.0012, 0.48)
        call BlzFrameSetSize(CaptainDraftClaimHover[i], 1.0, 1.0)
        call BlzFrameSetScale(CaptainDraftClaimHover[i], 1.0)
        call BlzFrameSetLevel(CaptainDraftClaimHover[i], 10)
        call BlzFrameSetModel(CaptainDraftClaimHover[i], "Pick\\wos_IconShine1.mdx", 0)
        call BlzFrameSetEnable(CaptainDraftClaimHover[i], false)
        call BlzFrameSetVisible(CaptainDraftClaimHover[i], false)
        call BlzTriggerRegisterFrameEvent(CaptainDraftHoverTrigger, FRAME_PlayerPick[i], FRAMEEVENT_MOUSE_ENTER)
        call BlzTriggerRegisterFrameEvent(CaptainDraftHoverTrigger, FRAME_PlayerPick[i], FRAMEEVENT_MOUSE_LEAVE)
        set i = i + 1
    endloop

    call BlzFrameSetVisible(CaptainDraftPanel, CaptainDraftMode)
    if CaptainDraftMode then
        call CaptainDraft_HideLegacyUI()
        call CaptainDraft_UpdateRows()
        call CaptainDraft_UpdateControls()
        call CaptainDraft_SetStatus("|cffffd36bVote: which team gets the first pick? " + I2S(CaptainDraftVoteTime) + "s|r")
        if FRAME_TimerToStart != null then
            call BlzFrameClearAllPoints(FRAME_TimerToStart)
            call BlzFrameSetAbsPoint(FRAME_TimerToStart, FRAMEPOINT_CENTER, CaptainDraftStartTextX, CaptainDraftStartTextY)
            call BlzFrameSetSize(FRAME_TimerToStart, CaptainDraftStartTextWidth, CaptainDraftStartTextHeight)
            call BlzFrameSetScale(FRAME_TimerToStart, 1.05)
            call BlzFrameSetTextAlignment(FRAME_TimerToStart, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
            call BlzFrameSetLevel(FRAME_TimerToStart, 9600)
            call BlzFrameSetVisible(FRAME_TimerToStart, true)
        endif
    endif
    set tooltip = null
    set tooltipText = null
    set parent = null
endfunction

function CaptainDraft_ResolveCaptains takes nothing returns nothing
    // Captain slots are fixed by the globals. An empty captain slot keeps its
    // turn and is resolved by the normal timeout randomizer.
    set CaptainPid1 = CaptainDraftCaptain1
    set CaptainPid2 = CaptainDraftCaptain2
endfunction

function CaptainDraft_AddAction takes integer actionType, integer side returns nothing
    if CaptainDraftActionCount < 20 then
        set CaptainDraftActionType[CaptainDraftActionCount] = actionType
        if side == 0 then
            set CaptainDraftActionSide[CaptainDraftActionCount] = CaptainDraftFirstSide
        else
            set CaptainDraftActionSide[CaptainDraftActionCount] = 1 - CaptainDraftFirstSide
        endif
        set CaptainDraftActionCount = CaptainDraftActionCount + 1
    endif
endfunction

function CaptainDraft_InitOrders takes nothing returns nothing
    local integer i = 0
    local integer active = 0
    local integer bansAdded = 0
    local integer picksAdded = 0
    local integer team1Picks = 0
    local integer team2Picks = 0
    local integer side = 0

    call CaptainDraft_ResolveCaptains()
    // Keep the configurable pool sizes safe for the ten available slots.
    if CaptainDraftBanTotal < 1 then
        set CaptainDraftBanTotal = 1
    elseif CaptainDraftBanTotal > 10 then
        set CaptainDraftBanTotal = 10
    endif
    if CaptainDraftPickTotal < 1 then
        set CaptainDraftPickTotal = 1
    elseif CaptainDraftPickTotal > 10 then
        set CaptainDraftPickTotal = 10
    endif

    loop
        exitwhen i >= 10
        if CaptainDraft_IsPlaying(i) then
            set active = active + 1
        endif
        set CaptainDraftPlayerHero[i] = 0
        set i = i + 1
    endloop

    set i = 0
    loop
        exitwhen i >= 10
        set CaptainDraftPickedHero[i] = 0
        set CaptainDraftBannedHero[i] = 0
        set CaptainDraftClaimedBy[i] = -1
        set i = i + 1
    endloop

    // Draft order from the reference:
    // B1 B2 B1 B2, P1, P2 P2, P1 P1, P2,
    // B1/B2, P2, optional B1/B2 for an eight-ban draft, P1 P1, P2.
    set CaptainDraftActionCount = 0
    loop
        exitwhen bansAdded >= CaptainDraftBanTotal or bansAdded >= 4
        call CaptainDraft_AddAction(1, bansAdded - (bansAdded / 2) * 2)
        set bansAdded = bansAdded + 1
    endloop

    if picksAdded < CaptainDraftPickTotal then
        call CaptainDraft_AddAction(2, 0)
        set team1Picks = team1Picks + 1
        set picksAdded = picksAdded + 1
    endif
    set i = 0
    loop
        exitwhen i >= 2 or picksAdded >= CaptainDraftPickTotal
        call CaptainDraft_AddAction(2, 1)
        set team2Picks = team2Picks + 1
        set picksAdded = picksAdded + 1
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 2 or picksAdded >= CaptainDraftPickTotal
        call CaptainDraft_AddAction(2, 0)
        set team1Picks = team1Picks + 1
        set picksAdded = picksAdded + 1
        set i = i + 1
    endloop
    if picksAdded < CaptainDraftPickTotal then
        call CaptainDraft_AddAction(2, 1)
        set team2Picks = team2Picks + 1
        set picksAdded = picksAdded + 1
    endif

    set side = 0
    set i = 0
    loop
        exitwhen bansAdded >= CaptainDraftBanTotal or i >= 2
        call CaptainDraft_AddAction(1, side)
        set bansAdded = bansAdded + 1
        set side = 1 - side
        set i = i + 1
    endloop

    // The captain who acted second takes the first hero of the final block.
    if picksAdded < CaptainDraftPickTotal then
        call CaptainDraft_AddAction(2, 1)
        set team2Picks = team2Picks + 1
        set picksAdded = picksAdded + 1
    endif

    // In an eight-ban draft, bans seven and eight occur before the second
    // hero of the final pick block.
    set side = 0
    loop
        exitwhen bansAdded >= CaptainDraftBanTotal
        call CaptainDraft_AddAction(1, side)
        set bansAdded = bansAdded + 1
        set side = 1 - side
    endloop

    set i = 0
    loop
        exitwhen i >= 2 or picksAdded >= CaptainDraftPickTotal
        call CaptainDraft_AddAction(2, 0)
        set team1Picks = team1Picks + 1
        set picksAdded = picksAdded + 1
        set i = i + 1
    endloop
    if picksAdded < CaptainDraftPickTotal then
        call CaptainDraft_AddAction(2, 1)
        set team2Picks = team2Picks + 1
        set picksAdded = picksAdded + 1
    endif

    set CaptainDraftTurn = 0
    set CaptainDraftTime = 0
    set CaptainDraftBanCount = 0
    set CaptainDraftPickCount = 0
    set CaptainDraftClaimCount = 0
    set CaptainDraftClaimTargetCount = active
    set CaptainDraftTeamPickCount[0] = 0
    set CaptainDraftTeamPickCount[1] = 0
    set BannedHeroCount = 0
endfunction

function CaptainDraft_UpdateTurnUI takes nothing returns nothing
    local integer pid = -1
    local string side = ""
    local integer limit = CaptainDraftPickTime
    local integer remaining

    if CaptainDraftStage == 1 then
        set pid = CaptainDraftCaptain1
        if CaptainDraftActionSide[CaptainDraftTurn] == 1 then
            set pid = CaptainDraftCaptain2
        endif
        set side = "BAN"
        set limit = CaptainDraftBanTime
    elseif CaptainDraftStage == 2 then
        set pid = CaptainDraftCaptain1
        if CaptainDraftActionSide[CaptainDraftTurn] == 1 then
            set pid = CaptainDraftCaptain2
        endif
        set side = "PICK"
    elseif CaptainDraftStage == 3 then
        set side = "CHOOSE YOUR HERO"
        set limit = CaptainDraftClaimTime
    endif

    set remaining = limit - CaptainDraftTime
    if remaining < 0 then
        set remaining = 0
    endif

    call CaptainDraft_PositionStatus()
    if CaptainDraftStage == 3 then
        call CaptainDraft_SetStatus("|cff70d6ff" + side + "|r  " + I2S(remaining) + "s")
    elseif pid >= 0 and pid < 10 then
        call CaptainDraft_SetStatus("|cffffd36b" + side + "|r  " + GetPlayerName(Player(pid)) + "  " + I2S(remaining) + "s")
    endif
    call CaptainDraft_UpdateControls()
endfunction

function CaptainDraft_StartClaim takes nothing returns nothing
    set CaptainDraftStage = 3
    set CaptainDraftTurn = 0
    set CaptainDraftTime = 0
    set CaptainDraftClaimCount = 0
    call CaptainDraft_HideLegacyUI()
    call CaptainDraft_PlayConfiguredSound(CaptainDraftSoundClaimPhase)
    call CaptainDraft_UpdateRows()
    call CaptainDraft_UpdateTurnUI()
    call PlayersMsg("|cff70d6ffCaptain Draft: choose one of the drafted heroes.|r", 1)
endfunction

function CaptainDraft_AdvanceAction takes integer previousSide returns nothing
    local integer previousStage = CaptainDraftStage
    set CaptainDraftTurn = CaptainDraftTurn + 1
    set CaptainDraftTime = 0

    if CaptainDraftTurn >= CaptainDraftActionCount or (CaptainDraftBanCount >= CaptainDraftBanTotal and CaptainDraftPickCount >= CaptainDraftPickTotal) then
        call CaptainDraft_StartClaim()
        return
    endif

    set CaptainDraftStage = CaptainDraftActionType[CaptainDraftTurn]
    if CaptainDraftStage != previousStage then
        if CaptainDraftStage == 1 then
            call PlayersMsg("|cffff6060Captain Draft: BAN phase.|r", 1)
            call CaptainDraft_PlayConfiguredSound(CaptainDraftSoundBanPhase)
        else
            call PlayersMsg("|cff70d6ffCaptain Draft: PICK phase.|r", 1)
            call CaptainDraft_PlayConfiguredSound(CaptainDraftSoundPickPhase)
        endif
    endif
    if CaptainDraftActionSide[CaptainDraftTurn] != previousSide then
        call CaptainDraft_PlayConfiguredSound(CaptainDraftSoundTurn)
    endif
    call CaptainDraft_UpdateRows()
    call CaptainDraft_UpdateTurnUI()
endfunction

function CaptainDraft_RecordBan takes integer heroId returns nothing
    local integer effectSlot = CaptainDraftBanCount
    local integer side = CaptainDraftActionSide[CaptainDraftTurn]
    if heroId == 0 or CaptainDraft_IsBanImmune(heroId) or CaptainDraft_HeroUsed(heroId) or not CaptainDraft_HeroExistsRaw(heroId) then
        return
    endif
    set CaptainDraftBannedHero[CaptainDraftBanCount] = heroId
    set CaptainDraftBanCount = CaptainDraftBanCount + 1
    // Do not replace the shared Hero_ID page entry with 12 here. Captain Draft
    // already locks used heroes in ReloadHeroPage, while mutating the shared
    // page arrays during a frame click can leave adjacent hero buttons with
    // stale ID/dummy data and may crash Reforged on the next selection.
    set CaptainDraftPagesDirty = true
    call PlayersMsg("|cffff6060BAN:|r " + GetObjectName(heroId), 1)
    call CaptainDraft_UpdateRows()
    call CaptainDraft_PlayBanEffect(effectSlot)
    call CaptainDraft_PlayConfiguredSound(CaptainDraftSoundBanConfirm)
    call CaptainDraft_AdvanceAction(side)
endfunction

function CaptainDraft_RecordPick takes integer heroId returns nothing
    local integer side = CaptainDraftActionSide[CaptainDraftTurn]
    local integer slot
    if heroId == 0 or CaptainDraft_HeroUsed(heroId) or not CaptainDraft_HeroExistsRaw(heroId) then
        return
    endif
    if side == 0 then
        set slot = CaptainDraftTeamPickCount[0]
    else
        set slot = 5 + CaptainDraftTeamPickCount[1]
    endif
    if slot < 0 or slot >= 10 or CaptainDraftTeamPickCount[side] >= 5 then
        return
    endif
    set CaptainDraftPickedHero[slot] = heroId
    set CaptainDraftClaimedBy[slot] = -1
    set CaptainDraftTeamPickCount[side] = CaptainDraftTeamPickCount[side] + 1
    set CaptainDraftPickCount = CaptainDraftPickCount + 1
    set CaptainDraftPagesDirty = true
    call PlayersMsg("|cff70d6ffPICK:|r " + GetObjectName(heroId), 1)
    call CaptainDraft_AdvanceAction(side)
endfunction

function CaptainDraft_Confirm takes integer pid returns nothing
    local integer heroId = PlayerFrameCurrent_ID[pid]
    local integer expected = CaptainDraftCaptain1

    if CaptainDraftConfirmBusy then
        return
    endif

    if CaptainDraftStage == 1 then
        if CaptainDraftActionSide[CaptainDraftTurn] == 1 then
            set expected = CaptainDraftCaptain2
        endif
    elseif CaptainDraftStage == 2 then
        if CaptainDraftActionSide[CaptainDraftTurn] == 1 then
            set expected = CaptainDraftCaptain2
        endif
    else
        return
    endif
    if pid != expected or heroId == 0 or heroId == 12 or not CaptainDraft_HeroExistsRaw(heroId) then
        return
    endif
    // A captain may still have the previous hero selected in the preview even
    // after another captain banned or picked it. Never pass that stale ID on.
    if CaptainDraft_HeroUsed(heroId) then
        set CaptainDraftPagesDirty = true
        return
    endif
    set CaptainDraftConfirmBusy = true
    if CaptainDraftStage == 1 then
        call CaptainDraft_RecordBan(heroId)
    else
        call CaptainDraft_RecordPick(heroId)
    endif
    set CaptainDraftPagesDirty = true
    set CaptainDraftConfirmBusy = false
endfunction

function CaptainDraft_AllPlayersClaimed takes nothing returns boolean
    local integer pid = 0
    loop
        exitwhen pid >= 10
        if CaptainDraft_IsPlaying(pid) and CaptainDraftPlayerHero[pid] == 0 then
            return false
        endif
        set pid = pid + 1
    endloop
    return true
endfunction

function CaptainDraft_Claim takes integer pid, integer slot returns nothing
    local integer heroId
    if CaptainDraftStage != 3 or pid < 0 or pid >= 10 or CaptainDraftPlayerHero[pid] != 0 or slot < 0 or slot >= 10 then
        return
    endif
    if CaptainDraftClaimedBy[slot] >= 0 then
        return
    endif
    if (pid < 5 and slot >= 5) or (pid >= 5 and slot < 5) then
        return
    endif
    set heroId = CaptainDraftPickedHero[slot]
    if heroId == 0 then
        return
    endif
    set CaptainDraftPlayerHero[pid] = heroId
    set CaptainDraftClaimedBy[slot] = pid
    set CaptainDraftClaimCount = CaptainDraftClaimCount + 1
    call PlayersMsg(GetPlayerColorString(Player(pid)) + GetPlayerName(Player(pid)) + "|r chose |cff70d6ff" + GetObjectName(heroId) + "|r", 1)
    call CaptainDraft_UpdateRows()
    call CaptainDraft_UpdateControls()
    // Start the preparation countdown only after the last currently active
    // player has claimed a hero (or after the claim-stage timeout auto-claims).
    if CaptainDraft_AllPlayersClaimed() then
        set CaptainDraftFinishPending = true
    endif
endfunction

function CaptainDraft_AutoClaim takes nothing returns nothing
    local integer pid = 0
    local integer slot = 0
    local integer slotEnd = 5
    loop
        exitwhen pid >= 10
        if CaptainDraft_IsPlaying(pid) and CaptainDraftPlayerHero[pid] == 0 then
            if pid < 5 then
                set slot = 0
                set slotEnd = 5
            else
                set slot = 5
                set slotEnd = 10
            endif
            loop
                exitwhen slot >= slotEnd or CaptainDraftClaimedBy[slot] < 0
                set slot = slot + 1
            endloop
            if slot < slotEnd then
                call CaptainDraft_Claim(pid, slot)
            endif
        endif
        set pid = pid + 1
    endloop
endfunction

function CaptainDraft_CreateHero takes integer pid, integer heroId returns nothing
    local unit u
    local real x = GetRectCenterX(gg_rct_Pick)
    local real y = GetRectCenterY(gg_rct_Pick)
    if not CaptainDraft_IsPlaying(pid) or heroId == 0 or Hero[pid] != null then
        return
    endif
    set u = CreateUnit(Player(pid), heroId, x, y, 270)
    set Hero[pid] = u
    call SetFlyInit(u)
    call SetHeroLevel(u, 2, false)
    call LearnHeroSpells(u)
    call HideBottomUI(Player(pid), false)
    set PlayerVision[pid] = CreateFogModifierRadius(Player(pid), FOG_OF_WAR_VISIBLE, x, y, 1800, true, false)
    call FogModifierStart(PlayerVision[pid])
    call RecommenedItems(Player(pid))
    // Recommended items and intelligence recalculation can rebuild max mana.
    // Reapply Toji's permanent zero-mana state after those changes as well.
    call SaveSystem_SetCurrentHero(Player(pid), u)
    call SelectUnitForPlayerSingle(u, Player(pid))
    set FRAME_PlayerPickString[pid] = GetObjectName(heroId)
    if GetLocalPlayer() == Player(pid) then
        call BlzFrameSetVisible(FRAME_MAIN, false)
        call BlzFrameSetVisible(FRAME_StatusHeroMain, true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain2, true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain3, true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain4, true)
        call BlzFrameSetVisible(FRAME_LINK2, true)
        call SetCameraFieldForPlayer(Player(pid), CAMERA_FIELD_TARGET_DISTANCE, 3500, 0.25)
        call PanCameraToTimedForPlayer(Player(pid), x, y, 0.25)
    endif
    set u = null
endfunction

function CaptainDraft_AssignTeams takes nothing returns nothing
    local integer i = 0
    set FullTeam1Size = 0
    set FullTeam2Size = 0
    loop
        exitwhen i >= 10
        if CaptainDraft_IsPlaying(i) then
            if i < 5 then
                set FullTeam1[FullTeam1Size] = i
                set FullTeam1Size = FullTeam1Size + 1
            else
                set FullTeam2[FullTeam2Size] = i
                set FullTeam2Size = FullTeam2Size + 1
            endif
        endif
        set i = i + 1
    endloop
endfunction

// The draft creates heroes through CaptainDraft_CreateHero instead of the
// normal picker, so the normal code never reveals the swap button. Enable each
// player's own button for the post-draft preparation period. The first-round
// start code disables it again and clears all pending requests.
function CaptainDraft_EnablePreRoundSwap takes nothing returns nothing
    local integer pid = 0

    set CaptainDraftPreRoundUnlimitedSwap = true
    loop
        exitwhen pid >= 10
        set FRAME_SwapActive[pid] = 0
        set SwapRequests[pid] = -1

        if CaptainDraft_IsPlaying(pid) and Hero[pid] != null and GetLocalPlayer() == Player(pid) then
            call BlzFrameSetEnable(FRAME_Swap[pid], true)
            call BlzFrameSetVisible(FRAME_Swap[pid], true)
        endif

        set pid = pid + 1
    endloop
endfunction

// A later legacy-pick tick may rebuild part of the bottom UI.  Re-assert only
// the local button visibility here (without resetting pending swap requests),
// so the post-draft button cannot disappear during the think timer.
function CaptainDraft_RefreshPreRoundSwapButtons takes nothing returns nothing
    local integer pid = 0
    if not CaptainDraftPreRoundUnlimitedSwap then
        return
    endif
    loop
        exitwhen pid >= 10
        if CaptainDraft_IsPlaying(pid) and Hero[pid] != null and GetLocalPlayer() == Player(pid) then
            call BlzFrameSetEnable(FRAME_Swap[pid], true)
            call BlzFrameSetVisible(FRAME_Swap[pid], true)
        endif
        set pid = pid + 1
    endloop
endfunction

function CaptainDraft_CloseUI takes nothing returns nothing
    local integer i = 0
    if CaptainDraftPanel != null then
        call BlzFrameSetVisible(CaptainDraftPanel, false)
    endif
    if FRAME_TimerToStart != null then
        call BlzFrameSetVisible(FRAME_TimerToStart, false)
    endif
    if FRAME_Pick[2] != null then
        call BlzFrameSetVisible(FRAME_Pick[2], false)
        call BlzFrameSetEnable(FRAME_Pick[2], false)
    endif
    if FRAME_Pick[3] != null then
        call BlzFrameSetVisible(FRAME_Pick[3], false)
        call BlzFrameSetEnable(FRAME_Pick[3], false)
    endif
    if FRAME_Pick[4] != null then
        call BlzFrameSetVisible(FRAME_Pick[4], false)
        call BlzFrameSetEnable(FRAME_Pick[4], false)
    endif
    loop
        exitwhen i >= 10
        if FRAME_PlayerPick[i] != null then
            call BlzFrameSetEnable(FRAME_PlayerPick[i], false)
        endif
        if CaptainDraftClaimHover[i] != null then
            call BlzFrameSetVisible(CaptainDraftClaimHover[i], false)
        endif
        if CaptainDraftBanHighlight[i] != null then
            call BlzFrameSetVisible(CaptainDraftBanHighlight[i], false)
        endif
        if CaptainDraftBanEffectTimer[i] != null then
            call PauseTimer(CaptainDraftBanEffectTimer[i])
            call DestroyTimer(CaptainDraftBanEffectTimer[i])
            set CaptainDraftBanEffectTimer[i] = null
        endif
        set i = i + 1
    endloop
endfunction

function CaptainDraft_Finish takes nothing returns nothing
    local integer pid = 0
    local integer slot = 0
    local integer slotEnd = 5
    local integer thinkMinutes = CaptainDraftThinkTime / 60
    local integer thinkSeconds = CaptainDraftThinkTime - thinkMinutes * 60
    if CaptainDraftFinished then
        return
    endif
    set CaptainDraftFinishPending = false
    call CaptainDraft_AutoClaim()
    // If the claim timer expires before every player clicks, distribute the
    // remaining drafted slots. Never generate a hero outside that player's
    // five-hero team pool.
    loop
        exitwhen pid >= 10
        if CaptainDraft_IsPlaying(pid) and CaptainDraftPlayerHero[pid] == 0 then
            if pid < 5 then
                set slot = 0
                set slotEnd = 5
            else
                set slot = 5
                set slotEnd = 10
            endif
            loop
                exitwhen slot >= slotEnd or CaptainDraftClaimedBy[slot] < 0
                set slot = slot + 1
            endloop
            if slot < slotEnd then
                set CaptainDraftPlayerHero[pid] = CaptainDraftPickedHero[slot]
                set CaptainDraftClaimedBy[slot] = pid
            endif
        endif
        if CaptainDraft_IsPlaying(pid) then
            call CaptainDraft_CreateHero(pid, CaptainDraftPlayerHero[pid])
        endif
        set pid = pid + 1
    endloop
    call CaptainDraft_AssignTeams()
    // Close every draft frame before switching the mode flags. This prevents
    // the following legacy picker tick from leaving the draft overlay visible.
    call CaptainDraft_CloseUI()
    // Observers do not create a hero, so restore their normal gameplay UI
    // explicitly after the draft picker is closed.
    set pid = 10
    loop
        exitwhen pid >= 15
        if IsActiveObserverSlot(pid) then
            call HideBottomUI(Player(pid), false)
            if GetLocalPlayer() == Player(pid) then
                call BlzFrameSetVisible(FRAME_MAIN, false)
                call BlzFrameSetVisible(FRAME_StatusHeroMain, true)
                call BlzFrameSetVisible(FRAME_StatusHeroMain2, true)
                call BlzFrameSetVisible(FRAME_StatusHeroMain3, true)
                call BlzFrameSetVisible(FRAME_StatusHeroMain4, true)
                call BlzFrameSetVisible(FRAME_LINK2, true)
            endif
        endif
        set pid = pid + 1
    endloop
    set CaptainMode = true
    set CaptainDraftMode = false
    set CaptainDraftFinished = true
    set CapPickPhase = 4
    set PickPhaseActive = true
    set RandomAllPlayers = 1
    set BanPhaseActive = false
    set BanPhaseTriggered = true
    set CanPickRandom = 1
    if CaptainDraftThinkTime >= TimeRound then
        set TimeMove = 0
    else
        set TimeMove = TimeRound - CaptainDraftThinkTime
    endif
    if FRAME_RoundTimer != null then
        if thinkSeconds < 10 then
            call BlzFrameSetText(FRAME_RoundTimer, "Round Start In: |c00FFFF00" + I2S(thinkMinutes) + ":0" + I2S(thinkSeconds) + "|r")
        else
            call BlzFrameSetText(FRAME_RoundTimer, "Round Start In: |c00FFFF00" + I2S(thinkMinutes) + ":" + I2S(thinkSeconds) + "|r")
        endif
    endif
    call SetTeamAlliances()
    call RearrangeTeamUI()
    call CaptainDraft_EnablePreRoundSwap()
    call PlayersMsg("|cff70d6ffCaptain Draft complete. The round starts soon.|r", 1)
endfunction

function CaptainDraft_Tick takes nothing returns nothing
    local integer heroId
    local integer voteRemaining
    if CaptainDraftFinished then
        return
    endif
    call CaptainDraft_HideLegacyUI()
    if CaptainDraftFinishPending then
        call CaptainDraft_Finish()
        return
    endif
    if CaptainDraftStage == 0 then
        set CaptainDraftTime = CaptainDraftTime + 1
        if not CaptainDraftVoteFinished then
            set voteRemaining = CaptainDraftVoteTime - CaptainDraftTime
            if voteRemaining < 0 then
                set voteRemaining = 0
            endif
            call CaptainDraft_SetStatus("|cffffd36bVote: which team gets the first pick? " + I2S(voteRemaining) + "s|r")
            return
        endif
        call CaptainDraft_InitOrders()
        set CaptainDraftStage = 1
        set CaptainDraftTime = 0
        call BlzFrameSetVisible(CaptainDraftPanel, true)
        call BlzFrameSetVisible(FRAME_TimerToStart, true)
        // CreateUI starts before a mode is selected, so initialize every
        // active player's hero page explicitly when the draft begins.
        set heroId = 0
        loop
            exitwhen heroId >= 10
            if CaptainDraft_IsPlaying(heroId) then
                if PlayerFrameCurrentPage_ID[heroId] < 1 or PlayerFrameCurrentPage_ID[heroId] > 6 then
                    set PlayerFrameCurrentPage_ID[heroId] = 1
                endif
            endif
            set heroId = heroId + 1
        endloop
        set CaptainDraftPagesDirty = true
        call PlayersMsg("|cffff6060Captain Draft: BAN phase.|r", 1)
        call CaptainDraft_PlayConfiguredSound(CaptainDraftSoundBanPhase)
        call CaptainDraft_UpdateRows()
        call CaptainDraft_UpdateTurnUI()
        return
    endif

    set CaptainDraftTime = CaptainDraftTime + 1
    if CaptainDraftStage == 1 and CaptainDraftTime >= CaptainDraftBanTime then
        set heroId = CaptainDraft_FindRandomHero(true)
        if heroId != 0 then
            call CaptainDraft_RecordBan(heroId)
        else
            set CaptainDraftTime = 0
            call CaptainDraft_UpdateTurnUI()
        endif
    elseif CaptainDraftStage == 2 and CaptainDraftTime >= CaptainDraftPickTime then
        set heroId = CaptainDraft_FindRandomHero(false)
        if heroId != 0 then
            call CaptainDraft_RecordPick(heroId)
        else
            set CaptainDraftTime = 0
            call CaptainDraft_UpdateTurnUI()
        endif
    elseif CaptainDraftStage == 3 and CaptainDraftTime >= CaptainDraftClaimTime then
        call CaptainDraft_AutoClaim()
        call CaptainDraft_Finish()
    else
        call CaptainDraft_UpdateTurnUI()
    endif
endfunction
