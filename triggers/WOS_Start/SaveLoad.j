library AAINIT requires WOS2BotCodec

//==============================================================================
// WOS2 LOCAL-ONLY SAVE
//
// Safety model:
// - no save file is read during map initialization or mode selection;
// - the owner's profile may be read on that owner's explicit Career UI open;
// - no BlzSendSyncData and no transfer of saved data between players;
// - only the local owner's cumulative profile is read again at match end;
// - loaded values are never used by gameplay, selection, timers or synchronized UI;
// - the match export is built only from already synchronized current-match state;
// - the old WOS2_v1/WOS2_v3/VIP files are never opened or overwritten.
//==============================================================================
private function IsGamePlayerSlot takes integer pid returns boolean
    return pid >= 0 and pid < 10
endfunction
private function IsObserverSlot takes integer pid returns boolean
    return pid >= 10 and pid <= 14
endfunction
private function IsActivePlayerSlot takes integer pid returns boolean
    return IsGamePlayerSlot(pid) and GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(pid)) == MAP_CONTROL_USER
endfunction
private function IsActiveObserverSlot takes integer pid returns boolean
    return IsObserverSlot(pid) and GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(pid)) == MAP_CONTROL_USER
endfunction
globals
    // The standard FileIO carrier. Saved files may touch only this visual
    // tooltip native; they never call a map function while Preloader runs.
    constant integer SAVE_ABILITY = 'ANdc'
    constant string  SAVE_LOCAL_FORMAT = "WOS2L5|"
    constant string  SAVE_LOCAL_EMPTY = "WOS2L5_EMPTY"
    constant string  SAVE_FOLDER = "save\\"
    constant string  SAVE_LOCAL_PREFIX = "WOS2_local4_"
    constant string  SAVE_BOT_PREFIX = "WOS2_bot_match_"
    constant integer SAVE_BOT_MAX_PLAYERS = 10
    constant integer SAVE_BOT_MAX_ITEMS = 60
    constant integer SAVE_MAX_IGNORED_ITEMS = 128
    constant integer SAVE_LOCAL_MAX_HEROES = 48
    constant integer SAVE_LOCAL_MAX_ITEMS = 240

    // These identities come only from the current synchronized lobby state.
    // No value from disk is ever copied into them.
    string array ss_Identity
    integer array ss_IdentityKeyA
    integer array ss_IdentityKeyB

    // Deliberately divergent LOCAL scalars. They may only be consumed by local
    // file output, local text or local frame rendering.
    integer ss_LocalOwnerPid = -1
    integer ss_LocalGames = 0
    integer ss_LocalWins = 0
    boolean ss_LocalResultPending = false
    boolean ss_LocalPendingWin = false
    boolean ss_LocalLoadFinished = false
    boolean ss_LocalSaveWritten = false
    integer ss_LocalLoadedRecordCount = 0
    integer ss_LocalRejectedRecordCount = 0
    integer ss_LocalSavedRecordCount = 0

    // Sparse profile of this computer's owner only. These arrays intentionally
    // differ between clients and are never read by gameplay code.
    integer ss_LocalHeroCount = 0
    integer array ss_LocalHeroId
    integer array ss_LocalHeroGames
    integer array ss_LocalHeroWins
    integer array ss_LocalHeroRoundWins
    integer array ss_LocalHeroRoundLosses
    integer array ss_LocalHeroCombatGames
    integer array ss_LocalHeroTotalKills
    integer array ss_LocalHeroTotalDeaths
    integer array ss_LocalHeroBestKills
    integer array ss_LocalHeroBestDeaths
    integer array ss_LocalHeroBestKd100
    integer array ss_LocalLastBuild

    integer ss_LocalItemCount = 0
    integer array ss_LocalItemHeroId
    integer array ss_LocalItemId
    integer array ss_LocalItemFinalGames
    integer array ss_LocalItemFinalWins
    integer array ss_LocalItemUsedGames
    integer array ss_LocalItemUsedWins
    integer array ss_LocalRankScratch
    integer ss_LocalPayloadPos = 0

    // Small current-match accumulator. It stores only the local owner's result
    // until the final disk phase; nothing here comes from another save file.
    integer ss_LocalMatchHeroId = 0
    integer ss_LocalMatchKills = 0
    integer ss_LocalMatchDeaths = 0
    integer ss_LocalMatchRoundWins = 0
    integer ss_LocalMatchRoundLosses = 0
    integer array ss_LocalMatchBuild

    // Synchronized current-match registry. Unlike the local career cache,
    // every client has the same values here. It keeps participants after
    // PLAYER_SLOT_STATE_PLAYING becomes false, so the final bot export can
    // still contain players who left the match.
    boolean array ss_MatchParticipant
    boolean array ss_MatchLeft
    integer array ss_MatchLobbySlot
    integer array ss_MatchTeam
    integer array ss_MatchTeamSlot
    integer array ss_MatchVisualSlot
    string array ss_MatchStableName
    unit array ss_MatchHero
    integer array ss_MatchHeroId
    integer array ss_MatchRoundsPlayed
    integer array ss_MatchRoundWins
    integer array ss_MatchRoundLosses
    integer array ss_MatchItemId
    integer array ss_MatchKills
    integer array ss_MatchDeaths
    integer array ss_MatchDamagePhys
    integer array ss_MatchDamageMagic
    integer array ss_MatchHealing
    integer array ss_MatchTakenPhys
    integer array ss_MatchTakenMagic
    boolean array ss_MatchWin
    boolean ss_MatchTeamsReorganized = false
    trigger ss_MatchLeaveTrigger = null

    // Current-match export. These values are filled synchronously from the
    // current game only. They contain no loaded profile information.
    string ss_BotMatchId = ""
    boolean ss_BotExportStarted = false
    boolean ss_BotExportWritten = false
    integer ss_BotTeam1Rounds = 0
    integer ss_BotTeam2Rounds = 0
    integer ss_BotTrainKills = 0
    integer ss_BotPlayerCount = 0
    string array ss_BotPlayerLine
    string array ss_BotStatsLine
    string array ss_BotItemsLine
    integer ss_BotItemCount = 0
    integer array ss_BotItemId
    integer array ss_BotItemGames
    integer array ss_BotItemWins
    timer ss_BotWriteTimer = null
    integer ss_BotWritePhase = 0
    integer ss_BotWritePlayerIndex = 0
    integer ss_BotWritePlayerPart = 0
    integer ss_BotWriteItemIndex = 0
    string array ss_BotSealedLine
    integer ss_BotSealedCount = 0
    string ss_BotSealedHeader = ""

    integer ss_IgnoredItemCount = 0
    integer array ss_IgnoredItem

    timer ss_DeferredSaveTimer = null
    integer ss_DeferredSavePhase = 0
    boolean ss_Initialized = false
    trigger ss_ChatTrigger = null
endglobals

//==============================================================================
// LOCAL OWNER CAREER: OVERALL, HEROES AND ITEMS
//==============================================================================

function SaveSystem_PositiveModulo takes integer value, integer base returns integer
    local integer result = ModuloInteger(value, base)
    if result < 0 then
        set result = result + base
    endif
    return result
endfunction

function SaveSystem_EnsureIdentity takes integer pid returns nothing
    local string stableName
    if pid < 0 or pid >= 16 then
        return
    endif
    if ss_Identity[pid] == "" then
        set stableName = GetPlayerName(Player(pid))
        if stableName == "" then
            set stableName = "Player" + I2S(pid)
        endif
        set ss_Identity[pid] = stableName
    endif
    if ss_IdentityKeyA[pid] == 0 then
        set ss_IdentityKeyA[pid] = StringHash("WOS2:LOCAL4:A:" + ss_Identity[pid])
        if ss_IdentityKeyA[pid] == 0 then
            set ss_IdentityKeyA[pid] = 19001 + pid
        endif
    endif
    if ss_IdentityKeyB[pid] == 0 then
        set ss_IdentityKeyB[pid] = StringHash("WOS2:LOCAL4:B:" + ss_Identity[pid])
        if ss_IdentityKeyB[pid] == 0 then
            set ss_IdentityKeyB[pid] = 29001 + pid
        endif
    endif
endfunction

function SaveSystem_LocalChecksum takes integer pid, integer games, integer wins returns integer
    return SaveSystem_PositiveModulo(games*37 + wins*61 + ss_IdentityKeyA[pid]*3 + ss_IdentityKeyB[pid]*5 + 17041, 999983)
endfunction

function SaveSystem_LocalFilePath takes integer pid returns string
    call SaveSystem_EnsureIdentity(pid)
    return SAVE_FOLDER + SAVE_LOCAL_PREFIX + I2S(ss_IdentityKeyA[pid]) + "_" + I2S(ss_IdentityKeyB[pid]) + ".txt"
endfunction

function SaveSystem_LocalHeroChecksum takes integer pid, integer heroId, integer games, integer wins, integer roundWins, integer roundLosses, integer combatGames, integer kills, integer deaths, integer bestKills, integer bestDeaths, integer bestKd100 returns integer
    return SaveSystem_PositiveModulo(heroId*7 + games*11 + wins*13 + roundWins*17 + roundLosses*19 + combatGames*23 + kills*29 + deaths*31 + bestKills*37 + bestDeaths*41 + bestKd100*43 + ss_IdentityKeyA[pid] + ss_IdentityKeyB[pid] + 27011, 999983)
endfunction

function SaveSystem_LocalItemChecksum takes integer pid, integer heroId, integer itemId, integer finalGames, integer finalWins, integer usedGames, integer usedWins returns integer
    return SaveSystem_PositiveModulo(heroId*7 + itemId*11 + finalGames*17 + finalWins*19 + usedGames*23 + usedWins*29 + ss_IdentityKeyA[pid] + ss_IdentityKeyB[pid] + 37003, 999983)
endfunction

function SaveSystem_LocalBuildChecksum takes integer pid, integer heroId, integer slot, integer itemId returns integer
    return SaveSystem_PositiveModulo(heroId*13 + slot*31 + itemId*17 + ss_IdentityKeyA[pid] + ss_IdentityKeyB[pid] + 47017, 999983)
endfunction

function SaveSystem_LocalFindHero takes integer heroId returns integer
    local integer record = 0
    loop
        exitwhen record >= ss_LocalHeroCount
        if ss_LocalHeroId[record] == heroId then
            return record
        endif
        set record = record + 1
    endloop
    return -1
endfunction

function SaveSystem_LocalEnsureHero takes integer heroId returns integer
    local integer record = SaveSystem_LocalFindHero(heroId)
    local integer slot = 0
    if record >= 0 then
        return record
    endif
    if heroId == 0 or ss_LocalHeroCount >= SAVE_LOCAL_MAX_HEROES then
        return -1
    endif
    set record = ss_LocalHeroCount
    set ss_LocalHeroCount = ss_LocalHeroCount + 1
    set ss_LocalHeroId[record] = heroId
    set ss_LocalHeroGames[record] = 0
    set ss_LocalHeroWins[record] = 0
    set ss_LocalHeroRoundWins[record] = 0
    set ss_LocalHeroRoundLosses[record] = 0
    set ss_LocalHeroCombatGames[record] = 0
    set ss_LocalHeroTotalKills[record] = 0
    set ss_LocalHeroTotalDeaths[record] = 0
    set ss_LocalHeroBestKills[record] = 0
    set ss_LocalHeroBestDeaths[record] = 0
    set ss_LocalHeroBestKd100[record] = 0
    loop
        exitwhen slot >= 6
        set ss_LocalLastBuild[record*6 + slot] = 0
        set slot = slot + 1
    endloop
    return record
endfunction

function SaveSystem_LocalFindItem takes integer heroId, integer itemId returns integer
    local integer record = 0
    loop
        exitwhen record >= ss_LocalItemCount
        if ss_LocalItemHeroId[record] == heroId and ss_LocalItemId[record] == itemId then
            return record
        endif
        set record = record + 1
    endloop
    return -1
endfunction

function SaveSystem_LocalEnsureItem takes integer heroId, integer itemId returns integer
    local integer record = SaveSystem_LocalFindItem(heroId, itemId)
    if record >= 0 then
        return record
    endif
    if heroId == 0 or itemId == 0 or ss_LocalItemCount >= SAVE_LOCAL_MAX_ITEMS then
        return -1
    endif
    set record = ss_LocalItemCount
    set ss_LocalItemCount = ss_LocalItemCount + 1
    set ss_LocalItemHeroId[record] = heroId
    set ss_LocalItemId[record] = itemId
    set ss_LocalItemFinalGames[record] = 0
    set ss_LocalItemFinalWins[record] = 0
    set ss_LocalItemUsedGames[record] = 0
    set ss_LocalItemUsedWins[record] = 0
    return record
endfunction

// Declared before the profile updater because classic pjass does not allow a
// call to a function whose declaration appears later in the script.
function SaveSystem_LocalIsIgnoredItem takes integer itemId returns boolean
    local integer index = 0
    loop
        exitwhen index >= ss_IgnoredItemCount
        if ss_IgnoredItem[index] == itemId then
            return true
        endif
        set index = index + 1
    endloop
    return false
endfunction

function SaveSystem_LocalResetProfile takes nothing returns nothing
    set ss_LocalGames = 0
    set ss_LocalWins = 0
    set ss_LocalHeroCount = 0
    set ss_LocalItemCount = 0
    set ss_LocalLoadedRecordCount = 0
    set ss_LocalRejectedRecordCount = 0
endfunction

// Header loader. The second checksum is accepted only to import the already
// produced WOS2_local4_0_0 file, whose identity keys were accidentally zero.
function SaveSystem_LocalCareerApply takes integer games, integer wins, integer checksum returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local integer zeroKeyChecksum = SaveSystem_PositiveModulo(games*37 + wins*61 + 17041, 999983)
    if games < 0 or wins < 0 or wins > games or (checksum != SaveSystem_LocalChecksum(pid, games, wins) and checksum != zeroKeyChecksum) then
        set ss_LocalRejectedRecordCount = ss_LocalRejectedRecordCount + 1
        return
    endif
    set ss_LocalOwnerPid = pid
    set ss_LocalGames = games
    set ss_LocalWins = wins
    set ss_LocalLoadedRecordCount = ss_LocalLoadedRecordCount + 1
endfunction

function SaveSystem_LocalCareerHeroApply takes integer heroId, integer games, integer wins, integer roundWins, integer roundLosses, integer combatGames, integer kills, integer deaths, integer bestKills, integer bestDeaths, integer bestKd100, integer checksum returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local integer record
    if heroId == 0 or games < 0 or wins < 0 or wins > games or roundWins < 0 or roundLosses < 0 or combatGames < 0 or kills < 0 or deaths < 0 or bestKills < 0 or bestDeaths < 0 or bestKd100 < 0 then
        set ss_LocalRejectedRecordCount = ss_LocalRejectedRecordCount + 1
        return
    endif
    if checksum != SaveSystem_LocalHeroChecksum(pid, heroId, games, wins, roundWins, roundLosses, combatGames, kills, deaths, bestKills, bestDeaths, bestKd100) then
        set ss_LocalRejectedRecordCount = ss_LocalRejectedRecordCount + 1
        return
    endif
    set record = SaveSystem_LocalEnsureHero(heroId)
    if record < 0 then
        set ss_LocalRejectedRecordCount = ss_LocalRejectedRecordCount + 1
        return
    endif
    set ss_LocalHeroGames[record] = games
    set ss_LocalHeroWins[record] = wins
    set ss_LocalHeroRoundWins[record] = roundWins
    set ss_LocalHeroRoundLosses[record] = roundLosses
    set ss_LocalHeroCombatGames[record] = combatGames
    set ss_LocalHeroTotalKills[record] = kills
    set ss_LocalHeroTotalDeaths[record] = deaths
    set ss_LocalHeroBestKills[record] = bestKills
    set ss_LocalHeroBestDeaths[record] = bestDeaths
    set ss_LocalHeroBestKd100[record] = bestKd100
    set ss_LocalLoadedRecordCount = ss_LocalLoadedRecordCount + 1
endfunction

function SaveSystem_LocalCareerItemApply takes integer heroId, integer itemId, integer finalGames, integer finalWins, integer usedGames, integer usedWins, integer checksum returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local integer record
    if heroId == 0 or itemId == 0 or finalGames < 0 or finalWins < 0 or finalWins > finalGames or usedGames < 0 or usedWins < 0 or usedWins > usedGames then
        set ss_LocalRejectedRecordCount = ss_LocalRejectedRecordCount + 1
        return
    endif
    if checksum != SaveSystem_LocalItemChecksum(pid, heroId, itemId, finalGames, finalWins, usedGames, usedWins) then
        set ss_LocalRejectedRecordCount = ss_LocalRejectedRecordCount + 1
        return
    endif
    set record = SaveSystem_LocalEnsureItem(heroId, itemId)
    if record < 0 then
        set ss_LocalRejectedRecordCount = ss_LocalRejectedRecordCount + 1
        return
    endif
    set ss_LocalItemFinalGames[record] = finalGames
    set ss_LocalItemFinalWins[record] = finalWins
    set ss_LocalItemUsedGames[record] = usedGames
    set ss_LocalItemUsedWins[record] = usedWins
    set ss_LocalLoadedRecordCount = ss_LocalLoadedRecordCount + 1
endfunction

function SaveSystem_LocalCareerBuildApply takes integer heroId, integer slot, integer itemId, integer checksum returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local integer record
    if heroId == 0 or slot < 0 or slot >= 6 or itemId == 0 or checksum != SaveSystem_LocalBuildChecksum(pid, heroId, slot, itemId) then
        set ss_LocalRejectedRecordCount = ss_LocalRejectedRecordCount + 1
        return
    endif
    set record = SaveSystem_LocalEnsureHero(heroId)
    if record < 0 then
        set ss_LocalRejectedRecordCount = ss_LocalRejectedRecordCount + 1
        return
    endif
    set ss_LocalLastBuild[record*6 + slot] = itemId
    set ss_LocalLoadedRecordCount = ss_LocalLoadedRecordCount + 1
endfunction

function SaveSystem_LocalPayloadNextInt takes string payload returns integer
    local integer start = ss_LocalPayloadPos
    local integer length = StringLength(payload)
    loop
        exitwhen ss_LocalPayloadPos >= length or SubString(payload, ss_LocalPayloadPos, ss_LocalPayloadPos + 1) == ","
        set ss_LocalPayloadPos = ss_LocalPayloadPos + 1
    endloop
    set ss_LocalPayloadPos = ss_LocalPayloadPos + 1
    return S2I(SubString(payload, start, ss_LocalPayloadPos - 1))
endfunction

// Parse one record only after Preloader has completely returned. The generated
// file itself contains tooltip natives only and never invokes map code.
function SaveSystem_LocalCareerApplyPayload takes string payload returns nothing
    local string recordType
    local integer v0
    local integer v1
    local integer v2
    local integer v3
    local integer v4
    local integer v5
    local integer v6
    local integer v7
    local integer v8
    local integer v9
    local integer v10
    local integer v11
    if StringLength(payload) < 3 or StringLength(payload) > 240 or SubString(payload, 1, 2) != "," then
        set ss_LocalRejectedRecordCount = ss_LocalRejectedRecordCount + 1
        return
    endif
    set recordType = SubString(payload, 0, 1)
    set ss_LocalPayloadPos = 2
    if recordType == "A" then
        set v0 = SaveSystem_LocalPayloadNextInt(payload)
        set v1 = SaveSystem_LocalPayloadNextInt(payload)
        set v2 = SaveSystem_LocalPayloadNextInt(payload)
        call SaveSystem_LocalCareerApply(v0, v1, v2)
    elseif recordType == "H" then
        set v0 = SaveSystem_LocalPayloadNextInt(payload)
        set v1 = SaveSystem_LocalPayloadNextInt(payload)
        set v2 = SaveSystem_LocalPayloadNextInt(payload)
        set v3 = SaveSystem_LocalPayloadNextInt(payload)
        set v4 = SaveSystem_LocalPayloadNextInt(payload)
        set v5 = SaveSystem_LocalPayloadNextInt(payload)
        set v6 = SaveSystem_LocalPayloadNextInt(payload)
        set v7 = SaveSystem_LocalPayloadNextInt(payload)
        set v8 = SaveSystem_LocalPayloadNextInt(payload)
        set v9 = SaveSystem_LocalPayloadNextInt(payload)
        set v10 = SaveSystem_LocalPayloadNextInt(payload)
        set v11 = SaveSystem_LocalPayloadNextInt(payload)
        call SaveSystem_LocalCareerHeroApply(v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11)
    elseif recordType == "B" then
        set v0 = SaveSystem_LocalPayloadNextInt(payload)
        set v1 = SaveSystem_LocalPayloadNextInt(payload)
        set v2 = SaveSystem_LocalPayloadNextInt(payload)
        set v3 = SaveSystem_LocalPayloadNextInt(payload)
        call SaveSystem_LocalCareerBuildApply(v0, v1, v2, v3)
    elseif recordType == "I" then
        set v0 = SaveSystem_LocalPayloadNextInt(payload)
        set v1 = SaveSystem_LocalPayloadNextInt(payload)
        set v2 = SaveSystem_LocalPayloadNextInt(payload)
        set v3 = SaveSystem_LocalPayloadNextInt(payload)
        set v4 = SaveSystem_LocalPayloadNextInt(payload)
        set v5 = SaveSystem_LocalPayloadNextInt(payload)
        set v6 = SaveSystem_LocalPayloadNextInt(payload)
        call SaveSystem_LocalCareerItemApply(v0, v1, v2, v3, v4, v5, v6)
    else
        set ss_LocalRejectedRecordCount = ss_LocalRejectedRecordCount + 1
    endif
endfunction

function SaveSystem_LocalCareerParseBuffer takes string buffer returns nothing
    local integer length = StringLength(buffer)
    local integer start = StringLength(SAVE_LOCAL_FORMAT)
    local integer index = start
    local string payload
    if length < start or SubString(buffer, 0, start) != SAVE_LOCAL_FORMAT then
        return
    endif
    loop
        exitwhen index >= length
        if SubString(buffer, index, index + 1) == "|" then
            set payload = SubString(buffer, start, index)
            if payload != "" then
                call SaveSystem_LocalCareerApplyPayload(payload)
            endif
            set start = index + 1
        endif
        set index = index + 1
    endloop
    if start < length then
        set payload = SubString(buffer, start, length)
        if payload != "" then
            call SaveSystem_LocalCareerApplyPayload(payload)
        endif
    endif
endfunction

function SaveSystem_WriteLocalHeader takes nothing returns nothing
    call Preload("\")\ncall BlzSetAbilityTooltip(" + I2S(SAVE_ABILITY) + ",\"" + SAVE_LOCAL_FORMAT + "\",0)\n//")
endfunction

function SaveSystem_WriteLocalPayload takes string payload returns nothing
    call Preload("\")\ncall BlzSetAbilityTooltip(" + I2S(SAVE_ABILITY) + ",BlzGetAbilityTooltip(" + I2S(SAVE_ABILITY) + ",0)+\"" + payload + "|\",0)\n//")
endfunction

function SaveSystem_LoadOwnCareerAtFinish takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local string originalTooltip = BlzGetAbilityTooltip(SAVE_ABILITY, 0)
    local string buffer
    if not IsGamePlayerSlot(pid) then
        return
    endif
    set ss_LocalOwnerPid = pid
    call SaveSystem_EnsureIdentity(pid)
    call SaveSystem_LocalResetProfile()
    call BlzSetAbilityTooltip(SAVE_ABILITY, SAVE_LOCAL_EMPTY, 0)
    call Preloader(SaveSystem_LocalFilePath(pid))
    set buffer = BlzGetAbilityTooltip(SAVE_ABILITY, 0)
    if StringLength(buffer) < StringLength(SAVE_LOCAL_FORMAT) or SubString(buffer, 0, StringLength(SAVE_LOCAL_FORMAT)) != SAVE_LOCAL_FORMAT then
        // One-time recovery of the file shown as WOS2_local4_0_0.txt.
        call BlzSetAbilityTooltip(SAVE_ABILITY, SAVE_LOCAL_EMPTY, 0)
        call Preloader(SAVE_FOLDER + SAVE_LOCAL_PREFIX + "0_0.txt")
        set buffer = BlzGetAbilityTooltip(SAVE_ABILITY, 0)
    endif
    // Restore the shared object-data field before parsing any local payload.
    call BlzSetAbilityTooltip(SAVE_ABILITY, originalTooltip, 0)
    call SaveSystem_LocalCareerParseBuffer(buffer)
    set ss_LocalLoadFinished = true
endfunction

function SaveSystem_LocalApplyPendingMatch takes nothing returns nothing
    local integer heroRecord
    local integer itemRecord
    local integer slot = 0
    local integer previous
    local integer itemId
    local integer kd100
    local boolean duplicate
    set ss_LocalGames = ss_LocalGames + 1
    if ss_LocalPendingWin then
        set ss_LocalWins = ss_LocalWins + 1
    endif
    if ss_LocalMatchHeroId == 0 then
        return
    endif
    set heroRecord = SaveSystem_LocalEnsureHero(ss_LocalMatchHeroId)
    if heroRecord < 0 then
        return
    endif
    set ss_LocalHeroGames[heroRecord] = ss_LocalHeroGames[heroRecord] + 1
    if ss_LocalPendingWin then
        set ss_LocalHeroWins[heroRecord] = ss_LocalHeroWins[heroRecord] + 1
    endif
    set ss_LocalHeroRoundWins[heroRecord] = ss_LocalHeroRoundWins[heroRecord] + ss_LocalMatchRoundWins
    set ss_LocalHeroRoundLosses[heroRecord] = ss_LocalHeroRoundLosses[heroRecord] + ss_LocalMatchRoundLosses
    if ss_LocalMatchKills >= 0 and ss_LocalMatchDeaths >= 0 then
        if ss_LocalHeroCombatGames[heroRecord] == 0 or ss_LocalMatchDeaths < ss_LocalHeroBestDeaths[heroRecord] then
            set ss_LocalHeroBestDeaths[heroRecord] = ss_LocalMatchDeaths
        endif
        set ss_LocalHeroCombatGames[heroRecord] = ss_LocalHeroCombatGames[heroRecord] + 1
        set ss_LocalHeroTotalKills[heroRecord] = ss_LocalHeroTotalKills[heroRecord] + ss_LocalMatchKills
        set ss_LocalHeroTotalDeaths[heroRecord] = ss_LocalHeroTotalDeaths[heroRecord] + ss_LocalMatchDeaths
        if ss_LocalMatchKills > ss_LocalHeroBestKills[heroRecord] then
            set ss_LocalHeroBestKills[heroRecord] = ss_LocalMatchKills
        endif
        if ss_LocalMatchDeaths <= 0 then
            set kd100 = ss_LocalMatchKills*100
        else
            set kd100 = ss_LocalMatchKills*100/ss_LocalMatchDeaths
        endif
        if kd100 > ss_LocalHeroBestKd100[heroRecord] then
            set ss_LocalHeroBestKd100[heroRecord] = kd100
        endif
    endif
    loop
        exitwhen slot >= 6
        set itemId = ss_LocalMatchBuild[slot]
        set ss_LocalLastBuild[heroRecord*6 + slot] = itemId
        if itemId != 0 and not SaveSystem_LocalIsIgnoredItem(itemId) then
            set duplicate = false
            set previous = 0
            loop
                exitwhen previous >= slot
                if ss_LocalMatchBuild[previous] == itemId then
                    set duplicate = true
                    set previous = slot
                else
                    set previous = previous + 1
                endif
            endloop
            if not duplicate then
                set itemRecord = SaveSystem_LocalEnsureItem(ss_LocalMatchHeroId, itemId)
                if itemRecord >= 0 then
                    set ss_LocalItemFinalGames[itemRecord] = ss_LocalItemFinalGames[itemRecord] + 1
                    set ss_LocalItemUsedGames[itemRecord] = ss_LocalItemUsedGames[itemRecord] + 1
                    if ss_LocalPendingWin then
                        set ss_LocalItemFinalWins[itemRecord] = ss_LocalItemFinalWins[itemRecord] + 1
                        set ss_LocalItemUsedWins[itemRecord] = ss_LocalItemUsedWins[itemRecord] + 1
                    endif
                endif
            endif
        endif
        set slot = slot + 1
    endloop
endfunction

function SaveSystem_WriteOwnCareerAtFinish takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local integer checksum
    local integer record = 0
    local integer slot
    if not IsGamePlayerSlot(pid) or not ss_LocalResultPending then
        return
    endif

    // Reading happens here, after gameplay is already over, never at startup.
    call SaveSystem_LoadOwnCareerAtFinish()
    call SaveSystem_LocalApplyPendingMatch()
    set checksum = SaveSystem_LocalChecksum(pid, ss_LocalGames, ss_LocalWins)

    call PreloadGenClear()
    call PreloadGenStart()
    call SaveSystem_WriteLocalHeader()
    call SaveSystem_WriteLocalPayload("A," + I2S(ss_LocalGames) + "," + I2S(ss_LocalWins) + "," + I2S(checksum))
    set ss_LocalSavedRecordCount = 1
    loop
        exitwhen record >= ss_LocalHeroCount
        set checksum = SaveSystem_LocalHeroChecksum(pid, ss_LocalHeroId[record], ss_LocalHeroGames[record], ss_LocalHeroWins[record], ss_LocalHeroRoundWins[record], ss_LocalHeroRoundLosses[record], ss_LocalHeroCombatGames[record], ss_LocalHeroTotalKills[record], ss_LocalHeroTotalDeaths[record], ss_LocalHeroBestKills[record], ss_LocalHeroBestDeaths[record], ss_LocalHeroBestKd100[record])
        call SaveSystem_WriteLocalPayload("H," + I2S(ss_LocalHeroId[record]) + "," + I2S(ss_LocalHeroGames[record]) + "," + I2S(ss_LocalHeroWins[record]) + "," + I2S(ss_LocalHeroRoundWins[record]) + "," + I2S(ss_LocalHeroRoundLosses[record]) + "," + I2S(ss_LocalHeroCombatGames[record]) + "," + I2S(ss_LocalHeroTotalKills[record]) + "," + I2S(ss_LocalHeroTotalDeaths[record]) + "," + I2S(ss_LocalHeroBestKills[record]) + "," + I2S(ss_LocalHeroBestDeaths[record]) + "," + I2S(ss_LocalHeroBestKd100[record]) + "," + I2S(checksum))
        set ss_LocalSavedRecordCount = ss_LocalSavedRecordCount + 1
        set slot = 0
        loop
            exitwhen slot >= 6
            if ss_LocalLastBuild[record*6 + slot] != 0 then
                set checksum = SaveSystem_LocalBuildChecksum(pid, ss_LocalHeroId[record], slot, ss_LocalLastBuild[record*6 + slot])
                call SaveSystem_WriteLocalPayload("B," + I2S(ss_LocalHeroId[record]) + "," + I2S(slot) + "," + I2S(ss_LocalLastBuild[record*6 + slot]) + "," + I2S(checksum))
                set ss_LocalSavedRecordCount = ss_LocalSavedRecordCount + 1
            endif
            set slot = slot + 1
        endloop
        set record = record + 1
    endloop
    set record = 0
    loop
        exitwhen record >= ss_LocalItemCount
        set checksum = SaveSystem_LocalItemChecksum(pid, ss_LocalItemHeroId[record], ss_LocalItemId[record], ss_LocalItemFinalGames[record], ss_LocalItemFinalWins[record], ss_LocalItemUsedGames[record], ss_LocalItemUsedWins[record])
        call SaveSystem_WriteLocalPayload("I," + I2S(ss_LocalItemHeroId[record]) + "," + I2S(ss_LocalItemId[record]) + "," + I2S(ss_LocalItemFinalGames[record]) + "," + I2S(ss_LocalItemFinalWins[record]) + "," + I2S(ss_LocalItemUsedGames[record]) + "," + I2S(ss_LocalItemUsedWins[record]) + "," + I2S(checksum))
        set ss_LocalSavedRecordCount = ss_LocalSavedRecordCount + 1
        set record = record + 1
    endloop
    call PreloadGenEnd(SaveSystem_LocalFilePath(pid))
    call PreloadGenClear()

    set ss_LocalSaveWritten = true
    set ss_LocalResultPending = false
    set ss_LocalMatchHeroId = 0
    set ss_LocalMatchKills = 0
    set ss_LocalMatchDeaths = 0
    set ss_LocalMatchRoundWins = 0
    set ss_LocalMatchRoundLosses = 0
endfunction

// Old public entry points remain as no-ops for map compatibility. They must not
// be used to load a profile during initialization.
function SaveSystem_FilePath takes integer pid returns string
    return SaveSystem_LocalFilePath(pid)
endfunction

function SaveSystem_LegacyFilePath takes integer pid returns string
    return ""
endfunction

function SaveSystem_LoadLocalPlayer takes integer pid returns nothing
    if not IsGamePlayerSlot(pid) or GetLocalPlayer() != Player(pid) or ss_LocalLoadFinished then
        return
    endif
    call SaveSystem_LoadOwnCareerAtFinish()
endfunction

function SaveSystem_InitLoad takes nothing returns nothing
endfunction

function SaveSystem_WriteFile takes integer pid returns nothing
endfunction

function SaveSystem_SaveLocalCacheNow takes nothing returns nothing
endfunction

function SaveSystem_SavePlayer takes player whichPlayer returns nothing
endfunction

//==============================================================================
// CURRENT-MATCH EXPORT FOR THE BOT / LOCAL ARCHIVE
//==============================================================================

function SaveSystem_IsIgnoredItem takes integer itemId returns boolean
    local integer i = 0
    loop
        exitwhen i >= ss_IgnoredItemCount
        if ss_IgnoredItem[i] == itemId then
            return true
        endif
        set i = i + 1
    endloop
    return false
endfunction

function SaveSystem_RegisterIgnoredItem takes integer itemId returns nothing
    if itemId != 0 and not SaveSystem_IsIgnoredItem(itemId) and ss_IgnoredItemCount < SAVE_MAX_IGNORED_ITEMS then
        set ss_IgnoredItem[ss_IgnoredItemCount] = itemId
        set ss_IgnoredItemCount = ss_IgnoredItemCount + 1
    endif
endfunction

function SaveSystem_IsMatchPid takes integer pid returns boolean
    return pid >= 0 and pid < SAVE_BOT_MAX_PLAYERS
endfunction

function SaveSystem_MatchEnsureParticipant takes integer pid, string stableName returns nothing
    if not SaveSystem_IsMatchPid(pid) then
        return
    endif
    if not ss_MatchParticipant[pid] then
        set ss_MatchParticipant[pid] = true
        set ss_MatchLeft[pid] = false
        set ss_MatchLobbySlot[pid] = pid
        set ss_MatchVisualSlot[pid] = pid
        set ss_MatchRoundsPlayed[pid] = 0
        set ss_MatchRoundWins[pid] = 0
        set ss_MatchRoundLosses[pid] = 0
        if pid < 5 then
            set ss_MatchTeam[pid] = 1
            set ss_MatchTeamSlot[pid] = pid + 1
        else
            set ss_MatchTeam[pid] = 2
            set ss_MatchTeamSlot[pid] = pid - 4
        endif
    endif
    if stableName == "" then
        set stableName = ss_Identity[pid]
    endif
    if stableName == "" then
        set stableName = GetPlayerName(Player(pid))
    endif
    if stableName == "" then
        set stableName = "Player" + I2S(pid)
    endif
    set ss_MatchStableName[pid] = stableName
endfunction

// Capture the authoritative human lobby roster before any local career work or
// hero-frame interaction. This makes the bot report identical on every client.
function SaveSystem_RegisterLobbyParticipants takes nothing returns nothing
    local integer pid = 0
    loop
        exitwhen pid >= SAVE_BOT_MAX_PLAYERS
        if GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(pid)) == MAP_CONTROL_USER then
            call SaveSystem_MatchEnsureParticipant(pid, ss_Identity[pid])
        endif
        set pid = pid + 1
    endloop
endfunction

function SaveSystem_MatchSnapshotHero takes integer pid, unit whichHero returns nothing
    local integer slot = 0
    local item whichItem
    local integer itemId
    local integer heroId
    if not SaveSystem_IsMatchPid(pid) or whichHero == null then
        return
    endif
    set heroId = GetUnitTypeId(whichHero)
    // If another leave trigger already removed the unit, keep the last valid
    // hero/item snapshot instead of replacing it with six zeroes.
    if heroId == 0 then
        return
    endif
    set ss_MatchHero[pid] = whichHero
    set ss_MatchHeroId[pid] = heroId
    loop
        exitwhen slot >= 6
        set itemId = 0
        set whichItem = UnitItemInSlot(whichHero, slot)
        if whichItem != null then
            set itemId = GetItemTypeId(whichItem)
            if SaveSystem_IsIgnoredItem(itemId) then
                set itemId = 0
            endif
        endif
        set ss_MatchItemId[pid*6 + slot] = itemId
        set whichItem = null
        set slot = slot + 1
    endloop
endfunction

// Called when Captain/player-pick mode has produced a new team layout. Clear
// the lobby defaults first so a player who left before being drafted remains
// explicitly unassigned instead of being written into the old lobby team.
function SaveSystem_BeginReorganizedTeams takes nothing returns nothing
    local integer pid = 0
    set ss_MatchTeamsReorganized = true
    loop
        exitwhen pid >= SAVE_BOT_MAX_PLAYERS
        if ss_MatchParticipant[pid] then
            set ss_MatchTeam[pid] = 0
            set ss_MatchTeamSlot[pid] = 0
            set ss_MatchVisualSlot[pid] = -1
        endif
        set pid = pid + 1
    endloop
endfunction

function SaveSystem_SetMatchTeamSlot takes integer pid, integer team, integer teamSlot, integer visualSlot returns nothing
    if not SaveSystem_IsMatchPid(pid) then
        return
    endif
    call SaveSystem_MatchEnsureParticipant(pid, ss_Identity[pid])
    if team != 1 and team != 2 then
        set team = 0
    endif
    if teamSlot < 0 then
        set teamSlot = 0
    endif
    if visualSlot < -1 or visualSlot >= SAVE_BOT_MAX_PLAYERS then
        set visualSlot = -1
    endif
    set ss_MatchTeam[pid] = team
    set ss_MatchTeamSlot[pid] = teamSlot
    set ss_MatchVisualSlot[pid] = visualSlot
endfunction

function SaveSystem_MarkMatchPlayerLeft takes integer pid returns nothing
    if not SaveSystem_IsMatchPid(pid) or not ss_MatchParticipant[pid] then
        return
    endif
    call SaveSystem_MatchSnapshotHero(pid, ss_MatchHero[pid])
    set ss_MatchLeft[pid] = true
endfunction

function SaveSystem_OnMatchPlayerLeave takes nothing returns nothing
    call SaveSystem_MarkMatchPlayerLeft(GetPlayerId(GetTriggerPlayer()))
endfunction

function SaveSystem_IsMatchParticipant takes integer pid returns boolean
    if not SaveSystem_IsMatchPid(pid) then
        return false
    endif
    return ss_MatchParticipant[pid]
endfunction

function SaveSystem_DidMatchPlayerLeave takes integer pid returns boolean
    if not SaveSystem_IsMatchPid(pid) then
        return false
    endif
    return ss_MatchLeft[pid]
endfunction

function SaveSystem_GetMatchTeam takes integer pid returns integer
    if not SaveSystem_IsMatchPid(pid) then
        return 0
    endif
    return ss_MatchTeam[pid]
endfunction

function SaveSystem_GetMatchTeamSlot takes integer pid returns integer
    if not SaveSystem_IsMatchPid(pid) then
        return 0
    endif
    return ss_MatchTeamSlot[pid]
endfunction

function SaveSystem_GetMatchVisualSlot takes integer pid returns integer
    if not SaveSystem_IsMatchPid(pid) then
        return -1
    endif
    return ss_MatchVisualSlot[pid]
endfunction

function SaveSystem_GetMatchRoundsPlayed takes integer pid returns integer
    if not SaveSystem_IsMatchPid(pid) then
        return 0
    endif
    return ss_MatchRoundsPlayed[pid]
endfunction

function SaveSystem_GetMatchHero takes integer pid returns unit
    if not SaveSystem_IsMatchPid(pid) then
        return null
    endif
    return ss_MatchHero[pid]
endfunction

function SaveSystem_GetMatchStableName takes integer pid returns string
    if not SaveSystem_IsMatchPid(pid) then
        return ""
    endif
    return ss_MatchStableName[pid]
endfunction

function SaveSystem_GetMatchHeroId takes integer pid returns integer
    if not SaveSystem_IsMatchPid(pid) then
        return 0
    endif
    return ss_MatchHeroId[pid]
endfunction

function SaveSystem_MatchSetFinalStats takes integer pid, boolean isWin, integer kills, integer deaths, integer damagePhys, integer damageMagic, integer healing, integer takenPhys, integer takenMagic returns nothing
    if not SaveSystem_IsMatchPid(pid) or not ss_MatchParticipant[pid] then
        return
    endif
    set ss_MatchWin[pid] = isWin
    if kills < 0 then
        set kills = 0
    endif
    if deaths < 0 then
        set deaths = 0
    endif
    if damagePhys < 0 then
        set damagePhys = 0
    endif
    if damageMagic < 0 then
        set damageMagic = 0
    endif
    if healing < 0 then
        set healing = 0
    endif
    if takenPhys < 0 then
        set takenPhys = 0
    endif
    if takenMagic < 0 then
        set takenMagic = 0
    endif
    // Combat totals are cumulative. Keeping the maximum also preserves a
    // snapshot made by a leave handler if another system later clears arrays.
    if kills > ss_MatchKills[pid] then
        set ss_MatchKills[pid] = kills
    endif
    if deaths > ss_MatchDeaths[pid] then
        set ss_MatchDeaths[pid] = deaths
    endif
    if damagePhys > ss_MatchDamagePhys[pid] then
        set ss_MatchDamagePhys[pid] = damagePhys
    endif
    if damageMagic > ss_MatchDamageMagic[pid] then
        set ss_MatchDamageMagic[pid] = damageMagic
    endif
    if healing > ss_MatchHealing[pid] then
        set ss_MatchHealing[pid] = healing
    endif
    if takenPhys > ss_MatchTakenPhys[pid] then
        set ss_MatchTakenPhys[pid] = takenPhys
    endif
    if takenMagic > ss_MatchTakenMagic[pid] then
        set ss_MatchTakenMagic[pid] = takenMagic
    endif
endfunction

function SaveSystem_BotSafeText takes string value returns string
    local integer i = 0
    local integer length = StringLength(value)
    local string result = ""
    local string ch
    if length > 48 then
        set length = 48
    endif
    loop
        exitwhen i >= length
        set ch = SubString(value, i, i + 1)
        if ch == "|" or ch == "=" or ch == "," or ch == "\"" or ch == "\\" or ch == "\n" or ch == "\r" then
            set result = result + "_"
        else
            set result = result + ch
        endif
        set i = i + 1
    endloop
    return result
endfunction

function SaveSystem_BotNonNegative takes integer value returns integer
    if value < 0 then
        return 0
    endif
    return value
endfunction

function SaveSystem_BotNewMatchId takes nothing returns string
    return I2S(GetRandomInt(10000000, 99999999)) + "-" + I2S(GetRandomInt(10000000, 99999999)) + "-" + I2S(GetRandomInt(10000000, 99999999)) + "-" + I2S(GetRandomInt(10000000, 99999999))
endfunction

function SaveSystem_BotExportBegin takes integer team1Rounds, integer team2Rounds returns nothing
    local integer i = 0
    if ss_BotExportStarted or ss_BotExportWritten then
        return
    endif
    set ss_BotMatchId = SaveSystem_BotNewMatchId()
    set ss_BotTeam1Rounds = SaveSystem_BotNonNegative(team1Rounds)
    set ss_BotTeam2Rounds = SaveSystem_BotNonNegative(team2Rounds)
    set ss_BotTrainKills = 0
    set ss_BotPlayerCount = 0
    set ss_BotItemCount = 0
    loop
        exitwhen i >= SAVE_BOT_MAX_PLAYERS
        set ss_BotPlayerLine[i] = ""
        set ss_BotStatsLine[i] = ""
        set ss_BotItemsLine[i] = ""
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= SAVE_BOT_MAX_ITEMS
        set ss_BotItemId[i] = 0
        set ss_BotItemGames[i] = 0
        set ss_BotItemWins[i] = 0
        set i = i + 1
    endloop
    set ss_BotExportStarted = true
endfunction

function SaveSystem_BotExportSetTrainKills takes integer trainKills returns nothing
    set ss_BotTrainKills = SaveSystem_BotNonNegative(trainKills)
endfunction

function SaveSystem_BotAddItemResult takes integer itemId, boolean isWin returns nothing
    local integer i = 0
    if itemId == 0 or SaveSystem_IsIgnoredItem(itemId) then
        return
    endif
    loop
        exitwhen i >= ss_BotItemCount
        if ss_BotItemId[i] == itemId then
            set ss_BotItemGames[i] = ss_BotItemGames[i] + 1
            if isWin then
                set ss_BotItemWins[i] = ss_BotItemWins[i] + 1
            endif
            return
        endif
        set i = i + 1
    endloop
    if ss_BotItemCount < SAVE_BOT_MAX_ITEMS then
        set ss_BotItemId[ss_BotItemCount] = itemId
        set ss_BotItemGames[ss_BotItemCount] = 1
        if isWin then
            set ss_BotItemWins[ss_BotItemCount] = 1
        else
            set ss_BotItemWins[ss_BotItemCount] = 0
        endif
        set ss_BotItemCount = ss_BotItemCount + 1
    endif
endfunction

function SaveSystem_BotExportAddPlayer takes player whichPlayer, string stableName, unit whichHero, integer team, boolean isWin, integer kills, integer deaths, integer damagePhys, integer damageMagic, integer healing, integer takenPhys, integer takenMagic returns nothing
    local integer index = ss_BotPlayerCount
    local integer pid
    local integer heroId
    local integer winValue = 0
    local integer slot = 0
    local integer previous
    local integer itemId
    local integer previousItemId
    local boolean duplicate
    local item whichItem
    local item previousItem
    local string line
    local integer leftValue = 0
    if not ss_BotExportStarted or ss_BotExportWritten or index >= SAVE_BOT_MAX_PLAYERS or whichPlayer == null then
        return
    endif
    set pid = GetPlayerId(whichPlayer)
    call SaveSystem_MatchEnsureParticipant(pid, stableName)
    if whichHero != null then
        call SaveSystem_MatchSnapshotHero(pid, whichHero)
    endif
    if not ss_MatchParticipant[pid] then
        return
    endif
    set heroId = ss_MatchHeroId[pid]
    if stableName == "" then
        set stableName = ss_MatchStableName[pid]
    endif
    if ss_MatchTeam[pid] == 1 or ss_MatchTeam[pid] == 2 or ss_MatchTeamsReorganized then
        set team = ss_MatchTeam[pid]
    elseif team != 1 and team != 2 then
        set team = 0
    endif
    if isWin then
        set winValue = 1
    endif
    if ss_MatchLeft[pid] then
        set leftValue = 1
    endif
    call SaveSystem_MatchSetFinalStats(pid, isWin, kills, deaths, damagePhys, damageMagic, healing, takenPhys, takenMagic)

    set line = "PLAYER|n=" + I2S(index + 1) + "|pid=" + I2S(pid) + "|name=" + SaveSystem_BotSafeText(stableName)
    set line = line + "|team=" + I2S(team) + "|win=" + I2S(winValue) + "|hero_id=" + I2S(heroId)
    if heroId == 0 then
        set line = line + "|hero_name=Unknown"
    else
        set line = line + "|hero_name=" + SaveSystem_BotSafeText(GetObjectName(heroId))
    endif
    set line = line + "|left=" + I2S(leftValue)
    set line = line + "|lobby_slot=" + I2S(ss_MatchLobbySlot[pid]) + "|team_slot=" + I2S(ss_MatchTeamSlot[pid])
    set line = line + "|visual_slot=" + I2S(ss_MatchVisualSlot[pid])
    set ss_BotPlayerLine[index] = line

    set line = "STATS|n=" + I2S(index + 1) + "|pid=" + I2S(pid) + "|rounds_played=" + I2S(ss_MatchRoundsPlayed[pid])
    set line = line + "|round_wins=" + I2S(ss_MatchRoundWins[pid]) + "|round_losses=" + I2S(ss_MatchRoundLosses[pid])
    set line = line + "|kills=" + I2S(ss_MatchKills[pid]) + "|deaths=" + I2S(ss_MatchDeaths[pid])
    set line = line + "|damage_phys=" + I2S(ss_MatchDamagePhys[pid]) + "|damage_magic=" + I2S(ss_MatchDamageMagic[pid])
    set line = line + "|damage_total=" + I2S(ss_MatchDamagePhys[pid] + ss_MatchDamageMagic[pid])
    set line = line + "|heal=" + I2S(ss_MatchHealing[pid]) + "|taken_phys=" + I2S(ss_MatchTakenPhys[pid])
    set line = line + "|taken_magic=" + I2S(ss_MatchTakenMagic[pid]) + "|taken_total=" + I2S(ss_MatchTakenPhys[pid] + ss_MatchTakenMagic[pid])
    set ss_BotStatsLine[index] = line

    set line = "ITEMS|n=" + I2S(index + 1) + "|pid=" + I2S(pid)
    loop
        exitwhen slot >= 6
        set itemId = ss_MatchItemId[pid*6 + slot]
        set line = line + "|slot" + I2S(slot + 1) + "=" + I2S(itemId)
        if itemId != 0 then
            set duplicate = false
            set previous = 0
            loop
                exitwhen previous >= slot
                set previousItemId = ss_MatchItemId[pid*6 + previous]
                if previousItemId == itemId then
                    set duplicate = true
                    set previous = slot
                else
                    set previous = previous + 1
                endif
            endloop
            if not duplicate then
                call SaveSystem_BotAddItemResult(itemId, isWin)
            endif
        endif
        set slot = slot + 1
    endloop
    set ss_BotItemsLine[index] = line
    set ss_BotPlayerCount = index + 1
endfunction

function SaveSystem_BotExportWriteTick takes nothing returns nothing
    local timer expired = GetExpiredTimer()
    local integer i = 0
    local integer games
    local integer wins
    local integer reorganized = 0
    local string line

    if ss_BotWritePhase == 0 then
        set ss_BotSealedLine[ss_BotSealedCount] = WOS2BotCodec_SealLine("ID|value=" + ss_BotMatchId + "|format=WOS2_BOT_V2|scope=MATCH")
        set ss_BotSealedCount = ss_BotSealedCount + 1
        set ss_BotWritePhase = 1
    elseif ss_BotWritePhase == 1 then
        if ss_MatchTeamsReorganized then
            set reorganized = 1
        endif
        set ss_BotSealedLine[ss_BotSealedCount] = WOS2BotCodec_SealLine("MATCH|team1_rounds=" + I2S(ss_BotTeam1Rounds) + "|team2_rounds=" + I2S(ss_BotTeam2Rounds) + "|players=" + I2S(ss_BotPlayerCount) + "|schema=2|teams_reorganized=" + I2S(reorganized) + "|train_kills=" + I2S(ss_BotTrainKills))
        set ss_BotSealedCount = ss_BotSealedCount + 1
        set ss_BotWritePhase = 2
    elseif ss_BotWritePhase == 2 then
        if ss_BotWritePlayerIndex >= ss_BotPlayerCount then
            set ss_BotWritePhase = 3
        else
            if ss_BotWritePlayerPart == 0 then
                set line = ss_BotPlayerLine[ss_BotWritePlayerIndex]
                set ss_BotWritePlayerPart = 1
            elseif ss_BotWritePlayerPart == 1 then
                set line = ss_BotStatsLine[ss_BotWritePlayerIndex]
                set ss_BotWritePlayerPart = 2
            else
                set line = ss_BotItemsLine[ss_BotWritePlayerIndex]
                set ss_BotWritePlayerPart = 0
                set ss_BotWritePlayerIndex = ss_BotWritePlayerIndex + 1
            endif
            set ss_BotSealedLine[ss_BotSealedCount] = WOS2BotCodec_SealLine(line)
            set ss_BotSealedCount = ss_BotSealedCount + 1
        endif
    elseif ss_BotWritePhase == 3 then
        if ss_BotWriteItemIndex >= ss_BotItemCount then
            set ss_BotWritePhase = 4
        else
            set games = ss_BotItemGames[ss_BotWriteItemIndex]
            set wins = ss_BotItemWins[ss_BotWriteItemIndex]
            set line = "ITEM_RATE|item_id=" + I2S(ss_BotItemId[ss_BotWriteItemIndex]) + "|item_name=" + SaveSystem_BotSafeText(GetObjectName(ss_BotItemId[ss_BotWriteItemIndex]))
            set line = line + "|games=" + I2S(games) + "|wins=" + I2S(wins)
            if games > 0 then
                set line = line + "|winrate_pct=" + I2S(wins*100/games)
            else
                set line = line + "|winrate_pct=0"
            endif
            set ss_BotSealedLine[ss_BotSealedCount] = WOS2BotCodec_SealLine(line)
            set ss_BotSealedCount = ss_BotSealedCount + 1
            set ss_BotWriteItemIndex = ss_BotWriteItemIndex + 1
        endif
    elseif ss_BotWritePhase == 4 then
        set ss_BotSealedLine[ss_BotSealedCount] = WOS2BotCodec_SealLine("END|id=" + ss_BotMatchId)
        set ss_BotSealedCount = ss_BotSealedCount + 1
        set ss_BotWritePhase = 5
    elseif ss_BotWritePhase == 5 then
        set ss_BotSealedLine[ss_BotSealedCount] = WOS2BotCodec_EndLine()
        set ss_BotSealedCount = ss_BotSealedCount + 1
        set ss_BotWritePhase = 6
    else
        call PauseTimer(expired)
        call DestroyTimer(expired)
        set ss_BotWriteTimer = null
        call PreloadGenClear()
        call PreloadGenStart()
        call Preload(ss_BotSealedHeader)
        loop
            exitwhen i >= ss_BotSealedCount
            call Preload(ss_BotSealedLine[i])
            set ss_BotSealedLine[i] = ""
            set i = i + 1
        endloop
        call PreloadGenEnd(SAVE_FOLDER + SAVE_BOT_PREFIX + ss_BotMatchId + ".txt")
        call PreloadGenClear()
        set ss_BotSealedCount = 0
        set ss_BotSealedHeader = ""
        set ss_BotExportWritten = true
        set ss_BotExportStarted = false
    endif
    set expired = null
endfunction

function SaveSystem_BotExportWrite takes nothing returns nothing
    if not ss_BotExportStarted or ss_BotExportWritten or ss_BotMatchId == "" or ss_BotWriteTimer != null then
        return
    endif
    call WOS2BotCodec_Begin(ss_BotMatchId)
    set ss_BotSealedHeader = WOS2BotCodec_Header()
    set ss_BotWritePhase = 0
    set ss_BotWritePlayerIndex = 0
    set ss_BotWritePlayerPart = 0
    set ss_BotWriteItemIndex = 0
    set ss_BotSealedCount = 0
    set ss_BotWriteTimer = CreateTimer()
    call TimerStart(ss_BotWriteTimer, 0.03, true, function SaveSystem_BotExportWriteTick)
endfunction

// Both clients create and destroy exactly the same timer handle. Only the file
// payload differs locally. Phase 0 closes its PreloadGen session before phase 1.
function SaveSystem_DeferredSaveTick takes nothing returns nothing
    local timer expired = GetExpiredTimer()
    if ss_DeferredSavePhase == 0 then
        set ss_DeferredSavePhase = 1
        set expired = null
        call SaveSystem_WriteOwnCareerAtFinish()
        return
    endif
    call PauseTimer(expired)
    call DestroyTimer(expired)
    set ss_DeferredSaveTimer = null
    set ss_DeferredSavePhase = 2
    set expired = null
    call SaveSystem_BotExportWrite()
endfunction

function SaveSystem_ScheduleDeferredWrites takes nothing returns nothing
    if ss_DeferredSaveTimer != null then
        return
    endif
    set ss_DeferredSavePhase = 0
    set ss_DeferredSaveTimer = CreateTimer()
    call TimerStart(ss_DeferredSaveTimer, 0.05, true, function SaveSystem_DeferredSaveTick)
endfunction

function SaveSystem_WritePendingPlayerFiles takes nothing returns nothing
    call SaveSystem_WriteOwnCareerAtFinish()
endfunction

//==============================================================================
// GAMEPLAY HOOKS: SAVE DATA NEVER ENTERS GAMEPLAY STATE
//==============================================================================

function SaveSystem_SetCurrentHero takes player whichPlayer, unit whichHero returns nothing
    local integer slot = 0
    local integer heroId = 0
    local integer pid
    if whichPlayer == null then
        return
    endif
    set pid = GetPlayerId(whichPlayer)
    if not IsGamePlayerSlot(pid) then
        return
    endif
    call SaveSystem_MatchEnsureParticipant(pid, ss_Identity[pid])
    if whichHero != null then
        set heroId = GetUnitTypeId(whichHero)
        call SaveSystem_MatchSnapshotHero(pid, whichHero)
    endif
    if GetLocalPlayer() != whichPlayer then
        return
    endif
    if heroId != ss_LocalMatchHeroId then
        set ss_LocalMatchHeroId = heroId
        set ss_LocalMatchRoundWins = 0
        set ss_LocalMatchRoundLosses = 0
        loop
            exitwhen slot >= 6
            set ss_LocalMatchBuild[slot] = 0
            set slot = slot + 1
        endloop
    endif
endfunction

function SaveSystem_ClearMatchItems takes integer pid returns nothing
endfunction

function SaveSystem_MarkItemUsed takes integer pid, integer itemId returns nothing
endfunction

function SaveSystem_OnItemAcquired takes unit whichHero, item whichItem returns nothing
endfunction

function SaveSystem_OnItemPickup takes nothing returns nothing
endfunction

function SaveSystem_RecordItemUsed takes integer source, integer heroId, integer itemId, boolean isWin returns nothing
endfunction

function SaveSystem_RecordItemFinal takes integer source, integer heroId, integer itemId, boolean isWin returns nothing
endfunction

function SaveSystem_RecordHeroRelation takes player whichPlayer, unit whichHero, unit otherHero, boolean isTeammate, boolean isWin returns nothing
endfunction

function SaveSystem_OnRoundEnd takes player whichPlayer, boolean isWin returns nothing
    local integer pid
    if whichPlayer == null then
        return
    endif
    set pid = GetPlayerId(whichPlayer)
    if not IsGamePlayerSlot(pid) then
        return
    endif
    if SaveSystem_IsMatchPid(pid) and ss_MatchParticipant[pid] and not ss_MatchLeft[pid] then
        set ss_MatchRoundsPlayed[pid] = ss_MatchRoundsPlayed[pid] + 1
        if isWin then
            set ss_MatchRoundWins[pid] = ss_MatchRoundWins[pid] + 1
        else
            set ss_MatchRoundLosses[pid] = ss_MatchRoundLosses[pid] + 1
        endif
        call SaveSystem_MatchSnapshotHero(pid, ss_MatchHero[pid])
    endif
    if GetLocalPlayer() != whichPlayer then
        return
    endif
    if isWin then
        set ss_LocalMatchRoundWins = ss_LocalMatchRoundWins + 1
    else
        set ss_LocalMatchRoundLosses = ss_LocalMatchRoundLosses + 1
    endif
endfunction

function SaveSystem_OnGameEndDetailed takes player whichPlayer, unit whichHero, boolean isWin, integer kills, integer deaths returns nothing
    local integer slot = 0
    local integer pid
    local item whichItem
    if whichPlayer == null then
        return
    endif
    set pid = GetPlayerId(whichPlayer)
    if not IsGamePlayerSlot(pid) then
        return
    endif
    if SaveSystem_IsMatchPid(pid) and ss_MatchParticipant[pid] then
        if whichHero == null then
            set whichHero = ss_MatchHero[pid]
        endif
        call SaveSystem_MatchSnapshotHero(pid, whichHero)
    endif
    // This branch changes only local scalars. It creates no handles and performs
    // no disk I/O. The synchronized final scheduler does the actual write later.
    if GetLocalPlayer() == whichPlayer and not ss_LocalResultPending then
        set ss_LocalOwnerPid = pid
        set ss_LocalPendingWin = isWin
        if whichHero != null then
            set ss_LocalMatchHeroId = GetUnitTypeId(whichHero)
        endif
        if kills < 0 then
            set kills = 0
        endif
        if deaths < 0 then
            set deaths = 0
        endif
        set ss_LocalMatchKills = kills
        set ss_LocalMatchDeaths = deaths
        loop
            exitwhen slot >= 6
            set ss_LocalMatchBuild[slot] = 0
            if whichHero != null then
                set whichItem = UnitItemInSlot(whichHero, slot)
                if whichItem != null then
                    set ss_LocalMatchBuild[slot] = GetItemTypeId(whichItem)
                endif
            endif
            set whichItem = null
            set slot = slot + 1
        endloop
        set ss_LocalResultPending = true
    endif
    set whichItem = null
endfunction

function SaveSystem_OnGameEndEx takes player whichPlayer, unit whichHero, boolean isWin returns nothing
    call SaveSystem_OnGameEndDetailed(whichPlayer, whichHero, isWin, -1, -1)
endfunction

function SaveSystem_OnGameEnd takes player whichPlayer, boolean isWin returns nothing
    call SaveSystem_OnGameEndDetailed(whichPlayer, null, isWin, -1, -1)
endfunction

//==============================================================================
// LOCAL CAREER GETTERS. Every non-zero result belongs to GetLocalPlayer only.
//==============================================================================

function SaveSystem_GetGamesPlayed takes player whichPlayer returns integer
    if whichPlayer == GetLocalPlayer() then
        return ss_LocalGames
    endif
    return 0
endfunction

function SaveSystem_GetGamesWon takes player whichPlayer returns integer
    if whichPlayer == GetLocalPlayer() then
        return ss_LocalWins
    endif
    return 0
endfunction

function SaveSystem_GetGamesLost takes player whichPlayer returns integer
    return SaveSystem_GetGamesPlayed(whichPlayer) - SaveSystem_GetGamesWon(whichPlayer)
endfunction

function SaveSystem_GetRoundWins takes player whichPlayer returns integer
    local integer record = 0
    local integer total = 0
    if whichPlayer != GetLocalPlayer() then
        return 0
    endif
    loop
        exitwhen record >= ss_LocalHeroCount
        set total = total + ss_LocalHeroRoundWins[record]
        set record = record + 1
    endloop
    return total
endfunction

function SaveSystem_GetRoundLosses takes player whichPlayer returns integer
    local integer record = 0
    local integer total = 0
    if whichPlayer != GetLocalPlayer() then
        return 0
    endif
    loop
        exitwhen record >= ss_LocalHeroCount
        set total = total + ss_LocalHeroRoundLosses[record]
        set record = record + 1
    endloop
    return total
endfunction

function SaveSystem_GetHeroGames takes player whichPlayer, integer heroId returns integer
    local integer record
    if whichPlayer != GetLocalPlayer() then
        return 0
    endif
    set record = SaveSystem_LocalFindHero(heroId)
    if record < 0 then
        return 0
    endif
    return ss_LocalHeroGames[record]
endfunction

function SaveSystem_GetRecordedHeroId takes player whichPlayer, integer rank returns integer
    if whichPlayer != GetLocalPlayer() or rank < 1 or rank > ss_LocalHeroCount then
        return 0
    endif
    return ss_LocalHeroId[rank - 1]
endfunction

function SaveSystem_GetHeroWins takes player whichPlayer, integer heroId returns integer
    local integer record
    if whichPlayer != GetLocalPlayer() then
        return 0
    endif
    set record = SaveSystem_LocalFindHero(heroId)
    if record < 0 then
        return 0
    endif
    return ss_LocalHeroWins[record]
endfunction

function SaveSystem_GetHeroExtraValue takes player whichPlayer, integer heroId, integer field returns integer
    local integer record
    if whichPlayer != GetLocalPlayer() then
        return 0
    endif
    set record = SaveSystem_LocalFindHero(heroId)
    if record < 0 then
        return 0
    endif
    if field == 0 then
        return ss_LocalHeroRoundWins[record]
    elseif field == 1 then
        return ss_LocalHeroRoundLosses[record]
    elseif field == 2 then
        return ss_LocalHeroCombatGames[record]
    elseif field == 3 then
        return ss_LocalHeroTotalKills[record]
    elseif field == 4 then
        return ss_LocalHeroTotalDeaths[record]
    elseif field == 5 then
        return ss_LocalHeroBestKills[record]
    elseif field == 6 then
        return ss_LocalHeroBestDeaths[record]
    endif
    return ss_LocalHeroBestKd100[record]
endfunction

function SaveSystem_GetHeroRoundWins takes player whichPlayer, integer heroId returns integer
    return SaveSystem_GetHeroExtraValue(whichPlayer, heroId, 0)
endfunction

function SaveSystem_GetHeroRoundLosses takes player whichPlayer, integer heroId returns integer
    return SaveSystem_GetHeroExtraValue(whichPlayer, heroId, 1)
endfunction

function SaveSystem_GetHeroCombatGames takes player whichPlayer, integer heroId returns integer
    return SaveSystem_GetHeroExtraValue(whichPlayer, heroId, 2)
endfunction

function SaveSystem_GetHeroTotalKills takes player whichPlayer, integer heroId returns integer
    return SaveSystem_GetHeroExtraValue(whichPlayer, heroId, 3)
endfunction

function SaveSystem_GetHeroTotalDeaths takes player whichPlayer, integer heroId returns integer
    return SaveSystem_GetHeroExtraValue(whichPlayer, heroId, 4)
endfunction

function SaveSystem_GetHeroBestKills takes player whichPlayer, integer heroId returns integer
    return SaveSystem_GetHeroExtraValue(whichPlayer, heroId, 5)
endfunction

function SaveSystem_GetHeroBestDeaths takes player whichPlayer, integer heroId returns integer
    return SaveSystem_GetHeroExtraValue(whichPlayer, heroId, 6)
endfunction

function SaveSystem_GetHeroBestKd100 takes player whichPlayer, integer heroId returns integer
    return SaveSystem_GetHeroExtraValue(whichPlayer, heroId, 7)
endfunction

function SaveSystem_GetGlobalGamesPlayed takes nothing returns integer
    return ss_LocalGames
endfunction

function SaveSystem_GetGlobalGamesWon takes nothing returns integer
    return ss_LocalWins
endfunction

function SaveSystem_GetGlobalHeroGames takes integer heroId returns integer
    local integer record = SaveSystem_LocalFindHero(heroId)
    if record < 0 then
        return 0
    endif
    return ss_LocalHeroGames[record]
endfunction

function SaveSystem_GetGlobalHeroWins takes integer heroId returns integer
    local integer record = SaveSystem_LocalFindHero(heroId)
    if record < 0 then
        return 0
    endif
    return ss_LocalHeroWins[record]
endfunction

function SaveSystem_GetGlobalHeroExtraValue takes integer heroId, integer field returns integer
    local integer record = SaveSystem_LocalFindHero(heroId)
    if record < 0 then
        return 0
    endif
    if field == 0 then
        return ss_LocalHeroRoundWins[record]
    elseif field == 1 then
        return ss_LocalHeroRoundLosses[record]
    elseif field == 2 then
        return ss_LocalHeroCombatGames[record]
    elseif field == 3 then
        return ss_LocalHeroTotalKills[record]
    elseif field == 4 then
        return ss_LocalHeroTotalDeaths[record]
    elseif field == 5 then
        return ss_LocalHeroBestKills[record]
    elseif field == 6 then
        return ss_LocalHeroBestDeaths[record]
    endif
    return ss_LocalHeroBestKd100[record]
endfunction

function SaveSystem_GetGlobalHeroRoundWins takes integer heroId returns integer
    return SaveSystem_GetGlobalHeroExtraValue(heroId, 0)
endfunction

function SaveSystem_GetGlobalHeroRoundLosses takes integer heroId returns integer
    return SaveSystem_GetGlobalHeroExtraValue(heroId, 1)
endfunction

function SaveSystem_GetGlobalHeroCombatGames takes integer heroId returns integer
    return SaveSystem_GetGlobalHeroExtraValue(heroId, 2)
endfunction

function SaveSystem_GetGlobalHeroTotalKills takes integer heroId returns integer
    return SaveSystem_GetGlobalHeroExtraValue(heroId, 3)
endfunction

function SaveSystem_GetGlobalHeroTotalDeaths takes integer heroId returns integer
    return SaveSystem_GetGlobalHeroExtraValue(heroId, 4)
endfunction

function SaveSystem_GetItemValue takes player whichPlayer, integer heroId, integer itemId, integer field returns integer
    local integer record
    if whichPlayer != GetLocalPlayer() then
        return 0
    endif
    set record = SaveSystem_LocalFindItem(heroId, itemId)
    if record < 0 then
        return 0
    endif
    if field == 0 then
        return ss_LocalItemFinalGames[record]
    elseif field == 1 then
        return ss_LocalItemFinalWins[record]
    elseif field == 2 then
        return ss_LocalItemUsedGames[record]
    endif
    return ss_LocalItemUsedWins[record]
endfunction

function SaveSystem_RebuildGlobalItemCache takes nothing returns nothing
endfunction

function SaveSystem_GlobalItemCacheTick takes nothing returns nothing
endfunction

function SaveSystem_GetGlobalItemValue takes integer heroId, integer itemId, integer field returns integer
    local integer record = SaveSystem_LocalFindItem(heroId, itemId)
    if record < 0 then
        return 0
    endif
    if field == 0 then
        return ss_LocalItemFinalGames[record]
    elseif field == 1 then
        return ss_LocalItemFinalWins[record]
    elseif field == 2 then
        return ss_LocalItemUsedGames[record]
    endif
    return ss_LocalItemUsedWins[record]
endfunction

function SaveSystem_LocalBestItemIdMin takes integer heroId, integer rank, integer minGames returns integer
    local integer position = 0
    local integer record
    local integer check
    local integer games
    local integer wins
    local integer bestRecord
    local integer bestGames
    local integer bestWins
    local boolean alreadySelected
    if rank < 1 or rank > 12 then
        return 0
    endif
    loop
        exitwhen position >= rank
        set record = 0
        set bestRecord = -1
        set bestGames = 0
        set bestWins = 0
        loop
            exitwhen record >= ss_LocalItemCount
            if ss_LocalItemHeroId[record] == heroId then
                set games = ss_LocalItemFinalGames[record]
                set wins = ss_LocalItemFinalWins[record]
                set alreadySelected = false
                set check = 0
                loop
                    exitwhen check >= position
                    if ss_LocalRankScratch[check] == record then
                        set alreadySelected = true
                    endif
                    set check = check + 1
                endloop
                if not alreadySelected and games >= minGames then
                    if bestRecord < 0 or wins*bestGames > bestWins*games or (wins*bestGames == bestWins*games and games > bestGames) then
                        set bestRecord = record
                        set bestGames = games
                        set bestWins = wins
                    endif
                endif
            endif
            set record = record + 1
        endloop
        if bestRecord < 0 then
            return 0
        endif
        set ss_LocalRankScratch[position] = bestRecord
        set position = position + 1
    endloop
    return ss_LocalItemId[ss_LocalRankScratch[rank - 1]]
endfunction

function SaveSystem_GetGlobalBestItemIdMin takes integer heroId, integer rank, integer minGames returns integer
    return SaveSystem_LocalBestItemIdMin(heroId, rank, minGames)
endfunction

function SaveSystem_GetGlobalBestItemId takes integer heroId, integer rank returns integer
    local integer result = SaveSystem_LocalBestItemIdMin(heroId, rank, 2)
    if result == 0 then
        return SaveSystem_LocalBestItemIdMin(heroId, rank, 1)
    endif
    return result
endfunction

function SaveSystem_GetBestItemIdMin takes player whichPlayer, integer heroId, integer rank, integer minGames returns integer
    if whichPlayer != GetLocalPlayer() then
        return 0
    endif
    return SaveSystem_LocalBestItemIdMin(heroId, rank, minGames)
endfunction

function SaveSystem_GetBestItemId takes player whichPlayer, integer heroId, integer rank returns integer
    local integer result
    if whichPlayer != GetLocalPlayer() then
        return 0
    endif
    set result = SaveSystem_LocalBestItemIdMin(heroId, rank, 2)
    if result == 0 then
        return SaveSystem_LocalBestItemIdMin(heroId, rank, 1)
    endif
    return result
endfunction

function SaveSystem_GetLastBuildItemId takes player whichPlayer, integer heroId, integer slot returns integer
    local integer record
    if whichPlayer != GetLocalPlayer() or slot < 0 or slot >= 6 then
        return 0
    endif
    set record = SaveSystem_LocalFindHero(heroId)
    if record < 0 then
        return 0
    endif
    return ss_LocalLastBuild[record*6 + slot]
endfunction

function SaveSystem_GetBestRelationHeroId takes player whichPlayer, integer heroId, integer relationType, integer rank returns integer
    return 0
endfunction

function SaveSystem_GetRelationValue takes player whichPlayer, integer heroId, integer otherHeroId, integer relationType, integer field returns integer
    return 0
endfunction

function SaveSystem_GetRelationGames takes player whichPlayer, integer heroId, integer otherHeroId, integer relationType returns integer
    return 0
endfunction

function SaveSystem_GetRelationWins takes player whichPlayer, integer heroId, integer otherHeroId, integer relationType returns integer
    return 0
endfunction

function SaveSystem_GetItemFinalGames takes player whichPlayer, integer heroId, integer itemId returns integer
    return SaveSystem_GetItemValue(whichPlayer, heroId, itemId, 0)
endfunction

function SaveSystem_GetItemFinalWins takes player whichPlayer, integer heroId, integer itemId returns integer
    return SaveSystem_GetItemValue(whichPlayer, heroId, itemId, 1)
endfunction

function SaveSystem_GetItemUsedGames takes player whichPlayer, integer heroId, integer itemId returns integer
    return SaveSystem_GetItemValue(whichPlayer, heroId, itemId, 2)
endfunction

function SaveSystem_GetItemUsedWins takes player whichPlayer, integer heroId, integer itemId returns integer
    return SaveSystem_GetItemValue(whichPlayer, heroId, itemId, 3)
endfunction

function SaveSystem_GetGlobalItemFinalGames takes integer heroId, integer itemId returns integer
    return SaveSystem_GetGlobalItemValue(heroId, itemId, 0)
endfunction

function SaveSystem_GetGlobalItemFinalWins takes integer heroId, integer itemId returns integer
    return SaveSystem_GetGlobalItemValue(heroId, itemId, 1)
endfunction

function SaveSystem_GetGlobalItemUsedGames takes integer heroId, integer itemId returns integer
    return SaveSystem_GetGlobalItemValue(heroId, itemId, 2)
endfunction

function SaveSystem_GetGlobalItemUsedWins takes integer heroId, integer itemId returns integer
    return SaveSystem_GetGlobalItemValue(heroId, itemId, 3)
endfunction

function SaveSystem_IsLocalLoadFinished takes nothing returns boolean
    return ss_LocalLoadFinished
endfunction

function SaveSystem_GetLocalLoadedRecordCount takes nothing returns integer
    return ss_LocalLoadedRecordCount
endfunction

function SaveSystem_GetLocalRejectedRecordCount takes nothing returns integer
    return ss_LocalRejectedRecordCount
endfunction

function SaveSystem_GetLocalSavedRecordCount takes nothing returns integer
    return ss_LocalSavedRecordCount
endfunction

function SaveSystem_IsLocalSaveWritten takes nothing returns boolean
    return ss_LocalSaveWritten
endfunction

function SaveSystem_IsLocalLegacyImported takes nothing returns boolean
    return false
endfunction

function SaveSystem_Percent takes integer wins, integer games returns integer
    if games <= 0 then
        return 0
    endif
    return wins*100/games
endfunction

//==============================================================================
// LOCAL TEXT COMMANDS
//==============================================================================

function SaveSystem_PrintStats takes player whichPlayer returns nothing
    call DisplayTextToPlayer(whichPlayer, 0.00, 0.00, "Локальная карьера: игр " + I2S(SaveSystem_GetGamesPlayed(whichPlayer)) + ", побед " + I2S(SaveSystem_GetGamesWon(whichPlayer)) + ".")
endfunction

function SaveSystem_PrintHeroStats takes player whichPlayer returns nothing
    call DisplayTextToPlayer(whichPlayer, 0.00, 0.00, "Личная история героев сохранена локально. Подробности доступны в Career UI.")
endfunction

function SaveSystem_PrintItemStats takes player whichPlayer returns nothing
    call DisplayTextToPlayer(whichPlayer, 0.00, 0.00, "Личные предметы и последняя сборка сохранены локально. Подробности доступны в Career UI.")
endfunction

function SaveSystem_PrintStatsEnglish takes player whichPlayer returns nothing
    call SaveSystem_PrintStats(whichPlayer)
endfunction

function SaveSystem_PrintHeroStatsEnglish takes player whichPlayer returns nothing
    call SaveSystem_PrintHeroStats(whichPlayer)
endfunction

function SaveSystem_PrintItemStatsEnglish takes player whichPlayer returns nothing
    call SaveSystem_PrintItemStats(whichPlayer)
endfunction

function SaveSystem_OnChat takes nothing returns nothing
    local player whichPlayer = GetTriggerPlayer()
    local string message = GetEventPlayerChatString()
    if message == "-stats" then
        call SaveSystem_PrintStats(whichPlayer)
    elseif message == "-hstats" then
        call SaveSystem_PrintHeroStats(whichPlayer)
    elseif message == "-istats" then
        call SaveSystem_PrintItemStats(whichPlayer)
    endif
    set whichPlayer = null
endfunction

function SaveSystem_RegisterChat takes nothing returns nothing
    local integer pid = 0
    if ss_ChatTrigger != null then
        return
    endif
    set ss_ChatTrigger = CreateTrigger()
    loop
        exitwhen pid >= SAVE_BOT_MAX_PLAYERS
        call TriggerRegisterPlayerChatEvent(ss_ChatTrigger, Player(pid), "-stats", true)
        call TriggerRegisterPlayerChatEvent(ss_ChatTrigger, Player(pid), "-hstats", true)
        call TriggerRegisterPlayerChatEvent(ss_ChatTrigger, Player(pid), "-istats", true)
        set pid = pid + 1
    endloop
    call TriggerAddAction(ss_ChatTrigger, function SaveSystem_OnChat)
endfunction

//==============================================================================
// INITIALIZATION: IDENTITIES ONLY, ZERO FILE I/O
//==============================================================================

function SaveSystem_SetIdentity takes player whichPlayer, string stableName returns nothing
    local integer pid
    if whichPlayer == null then
        return
    endif
    set pid = GetPlayerId(whichPlayer)
    if not IsGamePlayerSlot(pid) then
        return
    endif
    if ss_Identity[pid] != "" and ss_IdentityKeyA[pid] != 0 and ss_IdentityKeyB[pid] != 0 then
        return
    endif
    if stableName == "" then
        if ss_Identity[pid] != "" then
            set stableName = ss_Identity[pid]
        else
            set stableName = GetPlayerName(whichPlayer)
        endif
    endif
    set ss_Identity[pid] = stableName
    set ss_IdentityKeyA[pid] = StringHash("WOS2:LOCAL4:A:" + stableName)
    set ss_IdentityKeyB[pid] = StringHash("WOS2:LOCAL4:B:" + stableName)
    call SaveSystem_EnsureIdentity(pid)
endfunction

function SaveSystem_Init takes nothing returns nothing
    local integer pid = 0
    if ss_Initialized then
        return
    endif
    set ss_Initialized = true
    loop
        exitwhen pid >= SAVE_BOT_MAX_PLAYERS
        if ss_Identity[pid] == "" then
            call SaveSystem_SetIdentity(Player(pid), GetPlayerName(Player(pid)))
        endif
        call SaveSystem_EnsureIdentity(pid)
        set pid = pid + 1
    endloop
    call SaveSystem_RegisterLobbyParticipants()
    set ss_MatchLeaveTrigger = CreateTrigger()
    set pid = 0
    loop
        exitwhen pid >= SAVE_BOT_MAX_PLAYERS
        call TriggerRegisterPlayerEvent(ss_MatchLeaveTrigger, Player(pid), EVENT_PLAYER_LEAVE)
        set pid = pid + 1
    endloop
    call TriggerAddAction(ss_MatchLeaveTrigger, function SaveSystem_OnMatchPlayerLeave)
    // Intentionally no Preloader, no load timer and no item/history trigger.
endfunction

//==============================================================================
// LEGACY API STUBS KEPT ONLY FOR SOURCE COMPATIBILITY
//==============================================================================

function SaveSystem_AlphabetIndex takes string ch returns integer
    return -1
endfunction

function SaveSystem_Keystream takes integer pos returns integer
    return 0
endfunction

function SaveSystem_Encrypt takes string plain returns string
    return plain
endfunction

function SaveSystem_Decrypt takes string cipher returns string
    return cipher
endfunction

function SaveSystem_Checksum takes string body returns integer
    return StringHash(body)
endfunction

function SaveSystem_LastDot takes string value returns integer
    return -1
endfunction

function SaveSystem_ParseToken takes string value returns string
    return ""
endfunction

function SaveSystem_ParseInt takes string value returns integer
    return 0
endfunction

function SaveSystem_MakeRecord takes string body returns string
    return body
endfunction

function SaveSystem_FindSource takes integer keyA, integer keyB returns integer
    return -1
endfunction

function SaveSystem_ClearSourceRecords takes integer source returns nothing
endfunction

function SaveSystem_EnsureSource takes integer keyA, integer keyB, integer incomingGames returns integer
    return -1
endfunction

function SaveSystem_PlayerSource takes integer pid returns integer
    return -1
endfunction

function SaveSystem_FindHeroRecord takes integer source, integer heroId returns integer
    return -1
endfunction

function SaveSystem_EnsureHeroRecord takes integer source, integer heroId returns integer
    return -1
endfunction

function SaveSystem_FindItemRecord takes integer source, integer heroId, integer itemId returns integer
    return -1
endfunction

function SaveSystem_EnsureItemRecord takes integer source, integer heroId, integer itemId returns integer
    return -1
endfunction

function SaveSystem_FindRelationRecord takes integer source, integer heroId, integer otherHeroId, boolean isTeammate returns integer
    return -1
endfunction

function SaveSystem_EnsureRelationRecord takes integer source, integer heroId, integer otherHeroId, boolean isTeammate returns integer
    return -1
endfunction

function SaveSystem_EncodeHeader takes integer source returns string
    return ""
endfunction

function SaveSystem_EncodeHeroRecord takes integer record returns string
    return ""
endfunction

function SaveSystem_EncodeItemRecord takes integer record returns string
    return ""
endfunction

function SaveSystem_EncodeLastBuildRecord takes integer record returns string
    return ""
endfunction

function SaveSystem_EncodeRelationRecord takes integer record returns string
    return ""
endfunction

function SaveSystem_ApplyEncryptedRecord takes string encrypted returns boolean
    return false
endfunction

function SaveSystem_LocalLoadRecord takes string encrypted returns nothing
endfunction

function SaveSystem_LocalLoadFinish takes nothing returns nothing
endfunction

function SaveSystem_LocalLoadAbilityRecord takes nothing returns nothing
endfunction

function SaveSystem_WriteEncryptedRecord takes string encrypted returns nothing
endfunction

function SaveSystem_LegacyParseNext takes string value returns integer
    return 0
endfunction

function SaveSystem_QueueLegacy takes integer pid, string value returns boolean
    return false
endfunction

endlibrary
