library WOSMatchVotes initializer MV_Init requires heroicon, AAINIT, WOSUI, WOSPlayerLeave, WOSTeamMembership
globals
    // FF toolbar/window: true = available, false = hidden and disabled. Shared setting.
    boolean WOS_FF_ENABLED = true
    private constant real MV_TIMEOUT = 30.00
    private constant real MV_COOLDOWN = 30.00
    private real array MV_RetryLeft
    private boolean array MV_Active
    private integer array MV_Serial
    private integer array MV_Target
    private integer array MV_Initiator
    private integer array MV_Round
    private real array MV_Left
    private boolean array MV_Eligible
    private integer array MV_Choice
    private boolean MV_Ready = false
    private real MV_TickAge = 0.00
    private framehandle array MV_Button
    private framehandle array MV_Glow
    private framehandle MV_Panel
    // Last visibility written by MV_Render (0 unknown, 1 hidden, 2 shown):
    // the 0.24 s render runs all game long, the toolbar rarely changes.
    private integer array MV_ButtonState
    private integer array MV_GlowState
    private integer MV_PanelState = 0
    private framehandle MV_Title
    private framehandle MV_Empty
    private framehandle MV_Body
    private framehandle MV_Start
    private framehandle MV_Yes
    private framehandle MV_No
    private framehandle MV_Close
    private framehandle array MV_Row
    private framehandle array MV_RowText
    private real array MV_ResultLeft
    private framehandle array MV_RowMark
    private framehandle array MV_RowIcon
    // Local presentation only. Never used to decide a shared vote result.
endglobals

// Called only by the synchronized unanimous team-vote result.
function WOS_ApplyForfeit takes integer team returns boolean
    if not WOS_FF_ENABLED or team < 1 or team > 2 or END1 != 0 or WOS_ForfeitTeam != 0 then
        return false
    endif
    set WOS_ForfeitTeam = team
    return true
endfunction

private function MV_Human takes integer pid returns boolean
    return pid >= 0 and pid < 10 and Leave[pid] == 0 and GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(pid)) == MAP_CONTROL_USER
endfunction

private function MV_Team takes integer pid returns integer
    if IsInTeam1(pid) then
        return 1
    endif
    return 2
endfunction

private function MV_Name takes integer pid returns string
    return GetPlayerName(Player(pid))
endfunction

private function MV_Notify takes integer slot, string message returns nothing
    if slot == 0 or MV_Team(GetPlayerId(GetLocalPlayer())) == slot then
        call WUI_Feed("|cffffd36b" + message + "|r", 8.00)
    endif
endfunction

private function MV_Finish takes integer slot, boolean approved returns nothing
    local integer target = MV_Target[slot]
    set MV_Active[slot] = false
    set MV_RetryLeft[slot] = MV_COOLDOWN
    set MV_ResultLeft[slot] = 4.00
    if approved then
        if slot == 0 then
            if MV_Human(target) then
                call MV_Notify(slot, "Vote kick passed: " + MV_Name(target))
                call WOS_HandlePlayerLeave(Player(target))
                call CustomDefeatBJ(Player(target), "Removed by unanimous vote.")
            endif
        else
            if WOS_ApplyForfeit(slot) then
                call MV_Notify(slot, "Team surrender accepted.")
            else
                call MV_Notify(slot, "Surrender cancelled: the round has ended.")
            endif
        endif
    else
        call MV_Notify(slot, "Vote declined.")
    endif
endfunction

private function MV_Evaluate takes integer slot returns nothing
    local integer pid = 0
    local integer yes = 0
    local integer needed = 0
    local integer index
    if not MV_Active[slot] then
        return
    endif
    if slot == 0 and not MV_Human(MV_Target[slot]) then
        call MV_Finish(slot, false)
        return
    endif
    loop
        exitwhen pid >= 10
        set index = slot * 10 + pid
        if MV_Eligible[index] then
            set needed = needed + 1
            // A departure/defeat cannot silently reduce the unanimous threshold.
            if not MV_Human(pid) or MV_Choice[index] == 2 then
                call MV_Finish(slot, false)
                return
            endif
            if MV_Choice[index] == 1 then
                set yes = yes + 1
            endif
        endif
        set pid = pid + 1
    endloop
    if slot == 0 then
        set needed = IMaxBJ(2, needed)
    endif
    if needed > 0 and yes == needed then
        call MV_Finish(slot, true)
    endif
endfunction

private function MV_Begin takes integer pid, integer slot, integer target returns nothing
    local integer i = 0
    local integer index
    if not MV_Ready or not MV_Human(pid) or Hero[pid] == null or END1 != 0 or slot < 0 or slot > 2 then
        return
    endif
    if MV_Active[slot] or MV_RetryLeft[slot] > 0.00 then
        return
    endif
    if slot == 0 then
        if target == pid or not MV_Human(target) then
            return
        endif
    elseif not WOS_FF_ENABLED or MV_Team(pid) != slot or WOS_ForfeitTeam != 0 then
        return
    endif
    set MV_Serial[slot] = MV_Serial[slot] + 1
    set MV_Active[slot] = true
    set MV_ResultLeft[slot] = 0.00
    set MV_Target[slot] = target
    set MV_Initiator[slot] = pid
    set MV_Round[slot] = CurrentRound
    set MV_Left[slot] = MV_TIMEOUT
    loop
        exitwhen i >= 10
        set index = slot * 10 + i
        set MV_Eligible[index] = MV_Human(i) and ((slot == 0 and i != target) or (slot > 0 and MV_Team(i) == slot))
        set MV_Choice[index] = 0
        set i = i + 1
    endloop
    set MV_Choice[slot * 10 + pid] = 1
    if slot == 0 then
        call MV_Notify(slot, MV_Name(pid) + ": Vote kick " + MV_Name(target) + " (30s)")
    else
        call MV_Notify(slot, MV_Name(pid) + ": Surrender vote (30s)")
    endif
    call MV_Notify(slot, MV_Name(pid) + ": YES")
    call MV_Evaluate(slot)
endfunction

private function MV_Answer takes integer pid, integer slot, integer serial, integer answer returns nothing
    local integer index = slot * 10 + pid
    if slot < 0 or slot > 2 or not MV_Active[slot] or serial != MV_Serial[slot] or not MV_Human(pid) then
        return
    endif
    if (slot > 0 and not WOS_FF_ENABLED) or not MV_Eligible[index] or MV_Choice[index] != 0 or (answer != 1 and answer != 2) then
        return
    endif
    set MV_Choice[index] = answer
    if answer == 1 then
        call MV_Notify(slot, MV_Name(pid) + ": YES")
    else
        call MV_Notify(slot, MV_Name(pid) + ": NO")
    endif
    call MV_Evaluate(slot)
endfunction

private function MV_Part takes string value, integer part returns string
    local integer i = 0
    local integer start = 0
    local integer n = 0
    loop
        exitwhen i >= StringLength(value)
        if SubString(value, i, i + 1) == "|" then
            if n == part then
                return SubString(value, start, i)
            endif
            set n = n + 1
            set start = i + 1
        endif
        set i = i + 1
    endloop
    if n == part then
        return SubString(value, start, i)
    endif
    return ""
endfunction

private function MV_OnSync takes nothing returns nothing
    local integer pid = GetPlayerId(GetTriggerPlayer())
    local string packet = BlzGetTriggerSyncData()
    local string action = MV_Part(packet, 0)
    if action == "K" then
        call MV_Begin(pid, 0, S2I(MV_Part(packet, 1)))
    elseif action == "F" then
        call MV_Begin(pid, MV_Team(pid), -1)
    elseif action == "V" then
        call MV_Answer(pid, S2I(MV_Part(packet, 1)), S2I(MV_Part(packet, 2)), S2I(MV_Part(packet, 3)))
    endif
    if GetLocalPlayer() == Player(pid) then
        set MV_View = -1
        set MV_PanelState = 1
        call BlzFrameSetVisible(MV_Panel, false)
    endif
endfunction

private function MV_State takes boolean shown returns integer
    if shown then
        return 2
    endif
    return 1
endfunction

private function MV_Render takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local integer slot = 0
    local integer i = 0
    local integer index
    local boolean pending
    local boolean show = MV_Ready and MV_Human(pid) and Hero[pid] != null and END1 == 0 and WUI_TopShown()
    local string state
    local integer yes = 0
    local integer needed = 0
    local integer rows = 0
    local real height
    loop
        exitwhen i >= 2
        set slot = 0
        if i == 1 then
            set slot = MV_Team(pid)
        endif
        set pending = show and (i == 0 or WOS_FF_ENABLED) and MV_Active[slot] and MV_Eligible[slot * 10 + pid] and MV_Choice[slot * 10 + pid] == 0
        if MV_ButtonState[i] != MV_State(show and (i == 0 or WOS_FF_ENABLED)) then
            set MV_ButtonState[i] = MV_State(show and (i == 0 or WOS_FF_ENABLED))
            call BlzFrameSetVisible(MV_Button[i], show and (i == 0 or WOS_FF_ENABLED))
        endif
        if MV_GlowState[i] != MV_State(pending) then
            set MV_GlowState[i] = MV_State(pending)
            call BlzFrameSetVisible(MV_Glow[i], pending)
        endif
        set i = i + 1
    endloop
    if not show or (MV_View == 1 and not WOS_FF_ENABLED) then
        set MV_View = -1
    endif
    if MV_PanelState != MV_State(MV_View >= 0) then
        set MV_PanelState = MV_State(MV_View >= 0)
        call BlzFrameSetVisible(MV_Panel, MV_View >= 0)
    endif
    if MV_View < 0 then
        return
    endif
    set slot = 0
    if MV_View == 1 then
        set slot = MV_Team(pid)
    endif
    call BlzFrameSetVisible(MV_Start, slot > 0 and not MV_Active[slot])
    call BlzFrameSetEnable(MV_Start, END1 == 0 and WOS_ForfeitTeam == 0 and MV_RetryLeft[slot] <= 0.00)
    set pending = MV_Active[slot] and MV_Eligible[slot * 10 + pid] and MV_Choice[slot * 10 + pid] == 0
    call BlzFrameSetVisible(MV_Yes, pending)
    call BlzFrameSetVisible(MV_No, pending)
    if MV_Active[slot] then
        call WUI_SetText(MV_Title, "|cffffd36bVOTE  |r" + I2S(R2I(MV_Left[slot] + 0.99)) + "s")
        if slot == 0 then
            call WUI_SetText(MV_Body, MV_Name(MV_Initiator[slot]) + " proposes removing " + MV_Name(MV_Target[slot]) + ".|nEvery other active player must agree. At least 2 YES required.")
        else
            call WUI_SetText(MV_Body, MV_Name(MV_Initiator[slot]) + " proposes surrender.|nEvery teammate must agree. Enemy gains 10 round wins.")
        endif
    elseif slot == 0 then
        call WUI_SetText(MV_Title, "|cffffd36bVOTE KICK|r")
        call WUI_SetText(MV_Body, "Choose a player. All other active players must agree; at least 2 YES.|nA missing response after 30 seconds counts as NO.")
    else
        call WUI_SetText(MV_Title, "|cffffd36bTEAM SURRENDER|r")
        call WUI_SetText(MV_Body, "Requires the entire active team. Enemy gains 10 round wins.|nA missing response after 30 seconds counts as NO.")
    endif
    if not MV_Active[slot] and MV_RetryLeft[slot] > 0.00 then
        call WUI_SetText(MV_Title, "|cffffd36bREADY IN " + I2S(R2I(MV_RetryLeft[slot] + 0.99)) + "s|r")
    endif
    set i = 0
    loop
        exitwhen i >= 10
        set index = slot * 10 + i
        set pending = ((MV_Active[slot] or MV_ResultLeft[slot] > 0.00) and MV_Eligible[index]) or (not MV_Active[slot] and MV_ResultLeft[slot] <= 0.00 and MV_Human(i) and ((slot == 0 and i != pid) or (slot > 0 and MV_Team(i) == slot)))
        call BlzFrameSetVisible(MV_Row[i], pending)
        call BlzFrameSetEnable(MV_Row[i], slot == 0 and not MV_Active[slot] and MV_RetryLeft[slot] <= 0.00)
        if pending then
            set rows = rows + 1
            set state = ""
            if MV_Active[slot] then
                set needed = needed + 1
                if MV_Choice[index] == 1 then
                    set state = "  |cff7cdd9bYES|r"
                    set yes = yes + 1
                elseif MV_Choice[index] == 2 then
                    set state = "  |cffff7777NO|r"
                else
                    set state = "  |cffaaa9a3waiting|r"
                endif
            endif
            call WUI_SetText(MV_RowText[i], MV_Name(i))
            call BlzFrameSetVisible(MV_RowMark[i], (MV_Active[slot] or MV_ResultLeft[slot] > 0.00) and MV_Eligible[index] and MV_Choice[index] != 0)
            if MV_Choice[index] == 1 then
                call BlzFrameSetTexture(MV_RowMark[i], "UI\\WOS\\checked.tga", 0, true)
            else
                call BlzFrameSetTexture(MV_RowMark[i], "UI\\WOS\\glyph-close.tga", 0, true)
            endif
            if Hero[i] != null then
                call BlzFrameSetTexture(MV_RowIcon[i], BlzGetAbilityIcon(GetUnitTypeId(Hero[i])), 0, true)
            endif
        endif
        set i = i + 1
    endloop
    set height = RMaxBJ(0.135, 0.105 + I2R((rows + 1) / 2) * 0.021)
    call BlzFrameSetSize(MV_Panel, 0.260, height)
    call WUI_Pin(MV_Title, MV_Panel, -0.006, height * 0.50 - 0.016, 0.222, 0.018)
    call WUI_Pin(MV_Close, MV_Panel, 0.116, height * 0.50 - 0.014, 0.018, 0.018)
    call WUI_Pin(MV_Body, MV_Panel, 0.00, height * 0.50 - 0.047, 0.236, 0.044)
    call WUI_Pin(MV_Start, MV_Panel, 0.00, -height * 0.50 + 0.017, 0.140, 0.022)
    call WUI_Pin(MV_Yes, MV_Panel, -0.050, -height * 0.50 + 0.017, 0.084, 0.022)
    call WUI_Pin(MV_No, MV_Panel, 0.050, -height * 0.50 + 0.017, 0.084, 0.022)
    call WUI_Pin(MV_Empty, MV_Panel, 0.00, -0.018, 0.228, 0.022)
    call BlzFrameSetVisible(MV_Empty, rows == 0)
    set i = 0
    set rows = 0
    loop
        exitwhen i >= 10
        if BlzFrameIsVisible(MV_Row[i]) then
            call WUI_Pin(MV_Row[i], MV_Panel, -0.064 + I2R(ModuloInteger(rows, 2)) * 0.128, height * 0.50 - 0.082 - I2R(rows / 2) * 0.021, 0.122, 0.019)
            set rows = rows + 1
        endif
        set i = i + 1
    endloop
    if slot == 0 then
        set needed = IMaxBJ(2, needed)
    endif
    if MV_Active[slot] then
        call WUI_SetText(MV_Title, "|cffffd36bVOTE " + I2S(yes) + " / " + I2S(needed) + "|r    " + I2S(R2I(MV_Left[slot] + 0.99)) + "s")
    endif
endfunction

private function MV_Click takes nothing returns nothing
    local framehandle f = BlzGetTriggerFrame()
    local integer pid = GetPlayerId(GetTriggerPlayer())
    local integer i = 0
    local integer slot = 0
    local integer answer = 0
    if GetLocalPlayer() == GetTriggerPlayer() then
        if f == MV_Button[0] then
            if MV_View == 0 then
                set MV_View = -1
            else
                set MV_View = 0
            endif
        elseif f == MV_Button[1] and WOS_FF_ENABLED then
            if MV_View == 1 then
                set MV_View = -1
            else
                set MV_View = 1
            endif
        elseif f == MV_Close then
            set MV_View = -1
        elseif f == MV_Start and WOS_FF_ENABLED then
            call BlzSendSyncData("WOSVOTE", "F")
        elseif f == MV_Yes or f == MV_No then
            if MV_View == 1 then
                set slot = MV_Team(pid)
            endif
            set answer = 2
            if f == MV_Yes then
                set answer = 1
            endif
            call BlzSendSyncData("WOSVOTE", "V|" + I2S(slot) + "|" + I2S(MV_Serial[slot]) + "|" + I2S(answer))
        else
            loop
                exitwhen i >= 10
                if f == MV_Row[i] and MV_View == 0 and not MV_Active[0] then
                    call BlzSendSyncData("WOSVOTE", "K|" + I2S(i))
                endif
                set i = i + 1
            endloop
        endif
        call MV_Render()
    endif
    call WUI_ResetClickedButtonFocus()
    set f = null
endfunction

private function MV_Tick takes nothing returns nothing
    local integer slot = 0
    local integer pid
    local integer index
    set MV_TickAge = MV_TickAge + 0.03
    if MV_TickAge < 0.24 then
        return
    endif
    set MV_TickAge = 0.00
    loop
        exitwhen slot >= 3
        set MV_RetryLeft[slot] = RMaxBJ(0.00, MV_RetryLeft[slot] - 0.24)
        set MV_ResultLeft[slot] = RMaxBJ(0.00, MV_ResultLeft[slot] - 0.24)
        if MV_Active[slot] then
            if END1 != 0 or (slot > 0 and (not WOS_FF_ENABLED or MV_Round[slot] != CurrentRound)) then
                call MV_Finish(slot, false)
            else
                set MV_Left[slot] = MV_Left[slot] - 0.24
                if MV_Left[slot] <= 0.00 then
                    set pid = 0
                    loop
                        exitwhen pid >= 10
                        set index = slot * 10 + pid
                        if MV_Eligible[index] and MV_Choice[index] == 0 then
                            set MV_Choice[index] = 2
                            call MV_Notify(slot, MV_Name(pid) + ": NO (timeout)")
                        endif
                        set pid = pid + 1
                    endloop
                    call MV_Finish(slot, false)
                endif
                call MV_Evaluate(slot)
            endif
        endif
        set slot = slot + 1
    endloop
    if MV_Ready then
        call MV_Render()
    endif
endfunction

private function MV_Listener03 takes nothing returns boolean
    call MV_Tick()
    return false
endfunction

private function MV_Escape takes nothing returns nothing
    if GetLocalPlayer() == GetTriggerPlayer() and MV_View >= 0 then
        set MV_View = -1
        set MV_PanelState = 1
        call BlzFrameSetVisible(MV_Panel, false)
    endif
endfunction

private function MV_Build takes nothing returns nothing
    local integer i = 0
    local trigger click = CreateTrigger()
    local trigger escapeKey = CreateTrigger()
    local integer modifier
    local framehandle part
    local framehandle root = WUI_GetTopActionOwner()
    call TriggerAddAction(click, function MV_Click)
    loop
        exitwhen i >= 2
        set MV_Button[i] = WUI_TextButton("WOSVoteButton", root, "", 0.026, 0.026)
        call WUI_Place(MV_Button[i], WOS_REPICK_X - 0.052 + I2R(i) * 0.026, WOS_SWAP_Y, 0.026, 0.026)
        // Exact captain-slot model/transform from Player Pick (same .026 button).
        // Preallocated on every client; visibility follows the unanswered ballot.
        set MV_Glow[i] = BlzCreateFrameByType("SPRITE", "WOSVoteGlow", root, "WarCraftIIILogo", i)
        call BlzFrameSetPoint(MV_Glow[i], FRAMEPOINT_LEFT, MV_Button[i], FRAMEPOINT_LEFT, 0.0000, 0.48)
        call BlzFrameSetSize(MV_Glow[i], 1.00, 1.00)
        call BlzFrameSetScale(MV_Glow[i], 0.72)
        call BlzFrameSetModel(MV_Glow[i], "Pick\\wos_IconShine1.mdx", 0)
        call BlzFrameSetLevel(MV_Glow[i], 8)
        call BlzFrameSetEnable(MV_Glow[i], false)
        call BlzFrameSetVisible(MV_Glow[i], false)
        set part = BlzCreateFrameByType("BACKDROP", "WOSVoteIcon", MV_Button[i], "", 0)
        call WUI_Pin(part, MV_Button[i], 0.00, 0.00, 0.024, 0.024)
        call BlzFrameSetEnable(part, false)
        if i == 0 then
            call BlzFrameSetTexture(part, "UI\\WOS\\vote-kick.tga", 0, true)
            call WUI_Tooltip(MV_Button[i], "Vote kick|nOpen a pending vote or choose a player to remove.")
        else
            call BlzFrameSetTexture(part, "UI\\WOS\\vote-ff.tga", 0, true)
            call WUI_Tooltip(MV_Button[i], "Surrender|nOpen a pending team vote or propose surrender.")
        endif
        call BlzTriggerRegisterFrameEvent(click, MV_Button[i], FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetVisible(MV_Button[i], false)
        set i = i + 1
    endloop
    set MV_Panel = WUI_Window("WOSMatchVote", root, 0, 0)
    call WUI_Place(MV_Panel, 0.400, 0.343, 0.260, 0.135)
    set part = WUI_GoldFrame("WOSMatchVoteEdge", MV_Panel, 0.004, 0.009)
    set MV_Title = BlzCreateFrameByType("TEXT", "WOSVoteTitle", MV_Panel, "", 0)
    call WUI_Pin(MV_Title, MV_Panel, -0.010, 0.146, 0.280, 0.020)
    call BlzFrameSetTextAlignment(MV_Title, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    set MV_Empty = BlzCreateFrameByType("TEXT", "WOSVoteEmpty", MV_Panel, "", 0)
    call BlzFrameSetText(MV_Empty, "|cffaaa9a3No other players available. At least 2 YES are needed.|r")
    call BlzFrameSetTextAlignment(MV_Empty, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(MV_Empty, 0.75)
    call BlzFrameSetEnable(MV_Empty, false)
    set MV_Body = BlzCreateFrameByType("TEXT", "WOSVoteBody", MV_Panel, "", 0)
    call WUI_Pin(MV_Body, MV_Panel, 0.00, 0.108, 0.300, 0.046)
    call BlzFrameSetScale(MV_Body, 0.75)
    call BlzFrameSetTextAlignment(MV_Body, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    set MV_Close = WUI_TextButton("WOSVoteClose", MV_Panel, "X", 0.020, 0.020)
    call WUI_Pin(MV_Close, MV_Panel, 0.147, 0.147, 0.020, 0.020)
    set MV_Start = WUI_TextButton("WOSVoteStart", MV_Panel, "Propose surrender", 0.140, 0.025)
    call WUI_Pin(MV_Start, MV_Panel, 0.00, -0.148, 0.140, 0.025)
    set MV_Yes = WUI_TextButton("WOSVoteYes", MV_Panel, "YES", 0.090, 0.025)
    call WUI_Pin(MV_Yes, MV_Panel, -0.055, -0.148, 0.090, 0.025)
    set MV_No = WUI_TextButton("WOSVoteNo", MV_Panel, "NO", 0.090, 0.025)
    call WUI_Pin(MV_No, MV_Panel, 0.055, -0.148, 0.090, 0.025)
    call BlzTriggerRegisterFrameEvent(click, MV_Close, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(click, MV_Start, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(click, MV_Yes, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(click, MV_No, FRAMEEVENT_CONTROL_CLICK)
    set i = 0
    loop
        exitwhen i >= 10
        set MV_Row[i] = WUI_TextButton("WOSVotePlayer", MV_Panel, "", 0.290, 0.019)
        call WUI_Pin(MV_Row[i], MV_Panel, 0.00, 0.071 - I2R(i) * 0.021, 0.290, 0.019)
        set MV_RowIcon[i] = BlzCreateFrameByType("BACKDROP", "WOSVotePlayerIcon", MV_Row[i], "", 0)
        call WUI_Pin(MV_RowIcon[i], MV_Row[i], -0.050, 0.00, 0.016, 0.016)
        call BlzFrameSetEnable(MV_RowIcon[i], false)
        set MV_RowText[i] = BlzCreateFrameByType("TEXT", "WOSVotePlayerName", MV_Row[i], "", 0)
        call WUI_Pin(MV_RowText[i], MV_Row[i], -0.003, 0.00, 0.072, 0.016)
        call BlzFrameSetScale(MV_RowText[i], 0.70)
        call BlzFrameSetTextAlignment(MV_RowText[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)
        call BlzFrameSetEnable(MV_RowText[i], false)
        set MV_RowMark[i] = BlzCreateFrameByType("BACKDROP", "WOSVotePlayerChoice", MV_Row[i], "", 0)
        call WUI_Pin(MV_RowMark[i], MV_Row[i], 0.050, 0.00, 0.010, 0.010)
        call BlzFrameSetEnable(MV_RowMark[i], false)
        call BlzFrameSetVisible(MV_RowMark[i], false)
        call BlzTriggerRegisterFrameEvent(click, MV_Row[i], FRAMEEVENT_CONTROL_CLICK)
        set i = i + 1
    endloop
    call BlzFrameSetVisible(MV_Panel, false)
    call WUI_RegisterModal(MV_Panel)
    call WUI_RegisterWindowPart(11, MV_Panel)
    call TriggerAddAction(escapeKey, function MV_Escape)
    set i = 0
    loop
        exitwhen i >= 10
        set modifier = 0
        loop
            exitwhen modifier >= 16
            call BlzTriggerRegisterPlayerKeyEvent(escapeKey, Player(i), OSKEY_ESCAPE, modifier, true)
            set modifier = modifier + 1
        endloop
        set i = i + 1
    endloop
    set MV_Ready = true
    set part = null
    set root = null
    set click = null
    set escapeKey = null
endfunction

// Chat "-ff": YES to the running team surrender vote, otherwise starts one.
private function MV_OnChatFF takes nothing returns nothing
    local integer pid = GetPlayerId(GetTriggerPlayer())
    local integer slot = MV_Team(pid)
    if slot < 1 or slot > 2 then
        return
    endif
    if MV_Active[slot] then
        call MV_Answer(pid, slot, MV_Serial[slot], 1)
    else
        call MV_Begin(pid, slot, -1)
    endif
endfunction

private function MV_Init takes nothing returns nothing
    local trigger sync = CreateTrigger()
    local trigger chat = CreateTrigger()
    local integer pid = 0
    loop
        exitwhen pid >= 10
        call BlzTriggerRegisterPlayerSyncEvent(sync, Player(pid), "WOSVOTE", false)
        call TriggerRegisterPlayerChatEvent(chat, Player(pid), "-ff", true)
        set pid = pid + 1
    endloop
    call TriggerAddAction(sync, function MV_OnSync)
    call TriggerAddAction(chat, function MV_OnChatFF)
    call TriggerAddCondition(GearTimer03Listeners, Condition(function MV_Listener03))
    call GearTimer03Acquire()
    call WUI_OnReady(function MV_Build)
    set sync = null
    set chat = null
endfunction
endlibrary
