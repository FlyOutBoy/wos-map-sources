library LocalMp3Player initializer LocalMp3Player_Init

globals
    private constant integer LMP_ROWS = 3
    private constant integer LMP_MAX_TRACKS = 100
    // Автоскан проверяет только документированный диапазон Music\\1.mp3..Music\\30.mp3.
    // Вместимость 100 оставлена для треков, добавляемых через публичный API.
    private constant integer LMP_SCAN_FILE_COUNT = 30
    private constant real LMP_TICK = 0.10
    // Start the next track just before Warcraft can automatically repeat the
    // current music stream. This does not change the displayed duration.
    private constant integer LMP_END_GUARD_MS = 100
    // GetSoundFileDuration завышает длину локальных MP3 примерно на 4-6 секунд.
    // Средняя поправка хранится отдельно, чтобы её можно было быстро подстроить.
    private constant integer LMP_DURATION_CORRECTION_MS = 5000
    // Diagnostic switch: false keeps every UI/control feature but executes no
    // playback natives. Leave true for normal use.
    private constant boolean LMP_AUDIO_ENABLED = true
    private constant string LMP_COMMAND = "-music"
    private constant string LMP_LINK_URL = "bit.ly/4x8cOaB"
    private constant string LMP_TEX_BLACK = "Textures\\black32.blp"
    private constant string LMP_TEX_CLOSE = "Music\\Music_Close.blp"
    private constant string LMP_TEX_OPEN = "Music\\Music_Icon.blp"
    private constant string LMP_TEX_LINK = "Music\\Music_Link.blp"
    private constant string LMP_TEX_LOOP_OFF = "Music\\Music_LoopOff.blp"
    private constant string LMP_TEX_LOOP_ON = "Music\\Music_LoopOn.blp"
    private constant string LMP_TEX_SHUFFLE_OFF = "Music\\Music_MergeOff.blp"
    private constant string LMP_TEX_SHUFFLE_ON = "Music\\Music_MergeOn.blp"
    private constant string LMP_TEX_RERUN = "Music\\Music_Rerun.blp"
    private constant string LMP_TEX_BACK_10 = "Music\\Music_SkipLeft.blp"
    private constant string LMP_TEX_FORWARD_10 = "Music\\Music_SkipRight.blp"
    private constant string LMP_TEX_PREVIOUS = "Music\\Music_SkipTrackLeft.blp"
    private constant string LMP_TEX_NEXT = "Music\\Music_SkipTrackRight.blp"
    private constant string LMP_TEX_PLAY = "Music\\Music_Play.blp"
    private constant string LMP_TEX_PAUSE = "Music\\Music_Pause.blp"

    //===========================================================================
    // LAYOUT CONFIG
    //
    // All absolute frame coordinates and sizes are kept here. The main window
    // and its contents have been shifted 0.045 to the right.
    //===========================================================================
    private constant real LMP_OPEN_X = 0.885
    private constant real LMP_OPEN_Y = 0.560
    private constant real LMP_OPEN_SIZE = 0.022
    // Кнопка ссылки расположена справа от кнопки музыки.
    private constant real LMP_LINK_X = 0.855
    private constant real LMP_LINK_Y = 0.560
    private constant real LMP_LINK_SIZE = 0.022
    private constant real LMP_LINK_EDIT_X = 0.525
    private constant real LMP_LINK_EDIT_Y = 0.535
    private constant real LMP_LINK_EDIT_WIDTH = 0.1
    private constant real LMP_LINK_EDIT_HEIGHT = 0.026

    private constant real LMP_PANEL_X = 0.445
    private constant real LMP_PANEL_Y = 0.326
    private constant real LMP_PANEL_WIDTH = 0.270
    private constant real LMP_PANEL_HEIGHT = 0.270
    private constant real LMP_TITLE_X = 0.445
    private constant real LMP_TITLE_Y = 0.434
    private constant real LMP_TITLE_WIDTH = 0.170
    private constant real LMP_TITLE_HEIGHT = 0.016
    private constant real LMP_CLOSE_X = 0.559
    private constant real LMP_CLOSE_Y = 0.434
    private constant real LMP_CLOSE_SIZE = 0.020
    private constant real LMP_NOW_X = 0.445
    private constant real LMP_NOW_Y = 0.411
    private constant real LMP_NOW_WIDTH = 0.205
    private constant real LMP_NOW_HEIGHT = 0.016
    private constant real LMP_TIME_X = 0.445
    private constant real LMP_TIME_Y = 0.358
    private constant real LMP_TIME_WIDTH = 0.110
    private constant real LMP_TIME_HEIGHT = 0.014
    private constant real LMP_PROGRESS_X = 0.445
    private constant real LMP_PROGRESS_Y = 0.375
    private constant real LMP_PROGRESS_WIDTH = 0.215
    private constant real LMP_PROGRESS_HEIGHT = 0.014
    private constant real LMP_EQUALIZER_X = 0.445
    private constant real LMP_EQUALIZER_Y = 0.392
    private constant real LMP_EQUALIZER_WIDTH = 0.205
    private constant real LMP_EQUALIZER_HEIGHT = 0.014

    private constant real LMP_LIST_X = 0.438
    private constant real LMP_LIST_Y = 0.310
    private constant real LMP_LIST_WIDTH = 0.218
    private constant real LMP_LIST_HEIGHT = 0.076
    private constant real LMP_ROW_X = 0.437
    private constant real LMP_ROW_FIRST_Y = 0.334
    private constant real LMP_ROW_STEP_Y = 0.024
    private constant real LMP_ROW_WIDTH = 0.198
    private constant real LMP_ROW_HEIGHT = 0.020
    private constant real LMP_SCROLL_X = 0.558
    private constant real LMP_SCROLL_Y = 0.310
    private constant real LMP_SCROLL_WIDTH = 0.012
    private constant real LMP_SCROLL_HEIGHT = 0.074

    private constant real LMP_CONTROLS_ROW1_Y = 0.255
    private constant real LMP_CONTROLS_ROW2_Y = 0.225
    private constant real LMP_CONTROL_SIZE = 0.019
    private constant real LMP_PREVIOUS_X = 0.350
    private constant real LMP_BACK_10_X = 0.385
    private constant real LMP_PLAY_PAUSE_X = 0.420
    private constant real LMP_FORWARD_10_X = 0.455
    private constant real LMP_NEXT_X = 0.490
    private constant real LMP_RERUN_X = 0.350
    private constant real LMP_LOOP_X = 0.385
    private constant real LMP_SHUFFLE_X = 0.420

    private constant real LMP_VOLUME_X = 0.490
    private constant real LMP_VOLUME_Y = 0.220
    private constant real LMP_VOLUME_WIDTH = 0.115
    private constant real LMP_VOLUME_HEIGHT = 0.014
    private constant real LMP_VOLUME_TEXT_X = 0.490
    private constant real LMP_VOLUME_TEXT_Y = 0.238
    private constant real LMP_VOLUME_TEXT_WIDTH = 0.105
    private constant real LMP_VOLUME_TEXT_HEIGHT = 0.011

    private constant real LMP_TOOLTIP_X = 0.445
    private constant real LMP_TOOLTIP_Y = 0.279
    private constant real LMP_TOOLTIP_WIDTH = 0.122
    private constant real LMP_TOOLTIP_HEIGHT = 0.020

    private integer lmpTrackCount = 0
    private string array lmpPath
    private string array lmpTitle
    private integer array lmpDurationMs
    private integer array lmpCurrent
    private integer array lmpListOffset
    private boolean array lmpPlaying
    private boolean array lmpPaused
    private boolean array lmpLoop
    private boolean array lmpShuffle
    private boolean array lmpVisible
    private boolean array lmpLinkVisible
    private boolean array lmpClickBusy
    private integer array lmpOrder
    private integer array lmpShuffleNonce
    private integer array lmpRowTrack
    private real array lmpElapsed
    private real array lmpUiElapsed
    private real array lmpEqualizerElapsed
    private integer array lmpEqualizerPhase
    private integer array lmpVolume
    private boolean array lmpDefaultMusicStopped
    private integer array lmpActiveMusicTrack
    private integer array lmpPendingMusicTrack
    private integer array lmpPendingMusicPositionMs
    // 0 = idle, 1 = hard stop/clear, 2 = start, 3 = apply seek.
    private integer array lmpMusicSwitchPhase
    private integer array lmpPendingMusicVolume
    private boolean array lmpMusicVolumeDirty
    // Не двигаем UI-счётчик в тики, когда музыка ещё переключается или загружается.
    private boolean array lmpSkipElapsedTick
    private boolean lmpFramesReady = false
    private boolean lmpTocLoaded = false
    private integer lmpTooltipContext = 700

    framehandle lmpOpenButton
    framehandle lmpLinkButton
    framehandle lmpLinkActiveButton
    private framehandle lmpLinkIcon
    private framehandle lmpLinkActiveIcon
    private framehandle lmpLinkEdit
    private framehandle lmpPanel
    private framehandle lmpCloseButton
    private framehandle lmpShuffleButton
    private framehandle lmpShuffleIcon
    private framehandle lmpNowPlaying
    private framehandle lmpTimeText
    private framehandle lmpEqualizer
    private framehandle lmpSeek
    private framehandle lmpSeekBlocker
    private framehandle lmpVolumeSlider
    private framehandle lmpVolumeText
    private framehandle lmpListBox
    private framehandle lmpScroll
    private framehandle array lmpRow
    private framehandle lmpPreviousButton
    private framehandle lmpBack10Button
    private framehandle lmpRerunButton
    private framehandle lmpPlayPauseButton
    private framehandle lmpPlayPauseIcon
    private framehandle lmpForward10Button
    private framehandle lmpNextButton
    private framehandle lmpLoopButton
    private framehandle lmpLoopIcon
    private trigger lmpClickTrigger = CreateTrigger()
    private trigger lmpScrollTrigger = CreateTrigger()
    private trigger lmpWheelTrigger = CreateTrigger()
    private trigger lmpLinkEditTrigger = CreateTrigger()
    private trigger lmpVolumeTrigger = CreateTrigger()
    private trigger lmpChatTrigger = CreateTrigger()
    private timer lmpUpdateTimer = CreateTimer()
    // Scan local MP3 files after map startup in small batches.
    private timer lmpScanTimer = CreateTimer()
    private integer lmpScanTrack = 1
    // Три файла за короткий тик: весь диапазон завершается примерно за 0,5 с,
    // но не складывает все 30 синхронных чтений в один зависший кадр.
    private constant integer LMP_SCAN_BATCH = 1
    private constant real LMP_SCAN_INTERVAL = 0.07
    private constant real LMP_SCAN_DELAY = 2
endglobals

//===========================================================================
// Public track registration API
//===========================================================================
function LocalMp3Player_AddTrackEx takes string filePath, string displayName, integer durationSeconds returns nothing
    if lmpTrackCount >= LMP_MAX_TRACKS then
        return
    endif

    if durationSeconds <= 0 then
        return
    endif

    set lmpTrackCount = lmpTrackCount + 1
    set lmpPath[lmpTrackCount] = filePath
    set lmpTitle[lmpTrackCount] = displayName
    set lmpDurationMs[lmpTrackCount] = durationSeconds * 1000
endfunction
function LocalMp3Player_AddTrack takes string filePath, string displayName returns nothing
    call LocalMp3Player_AddTrackEx(filePath, displayName, 0)
endfunction

function LocalMp3Player_GetTrackCount takes nothing returns integer
    return lmpTrackCount
endfunction

//===========================================================================
// TRACK CONFIG
//
// Local files are checked automatically after map startup:
// Music\1.mp3 ... Music\30.mp3
//
// The scan is intentionally staggered. It does not open all MP3 files inside
// the library initializer.
//===========================================================================

//===========================================================================
// Internal helpers
//===========================================================================
private function LMP_MaxOffset takes nothing returns integer
    if lmpTrackCount > LMP_ROWS then
        return lmpTrackCount - LMP_ROWS
    endif
    return 0
endfunction

private function LMP_ClampOffset takes integer value returns integer
    local integer maxOffset = LMP_MaxOffset()

    if value < 0 then
        return 0
    endif
    if value > maxOffset then
        return maxOffset
    endif
    return value
endfunction

private function LMP_OrderKey takes integer pid, integer position returns integer
    return pid * LMP_MAX_TRACKS + position
endfunction

private function LMP_GetOrderedTrack takes integer pid, integer position returns integer
    local integer trackIndex

    if position < 1 or position > lmpTrackCount then
        return 0
    endif

    set trackIndex = lmpOrder[LMP_OrderKey(pid, position)]
    if trackIndex <= 0 or trackIndex > lmpTrackCount then
        return position
    endif
    return trackIndex
endfunction

private function LMP_ResetOrder takes integer pid returns nothing
    local integer position = 1

    loop
        exitwhen position > lmpTrackCount
        set lmpOrder[LMP_OrderKey(pid, position)] = position
        set position = position + 1
    endloop
endfunction

private function LMP_FindOrderPosition takes integer pid, integer trackIndex returns integer
    local integer position = 1

    loop
        exitwhen position > lmpTrackCount
        if LMP_GetOrderedTrack(pid, position) == trackIndex then
            return position
        endif
        set position = position + 1
    endloop
    return 0
endfunction

private function LMP_GetNextTrack takes integer pid returns integer
    local integer position

    if lmpTrackCount <= 0 then
        return 0
    endif

    set position = LMP_FindOrderPosition(pid, lmpCurrent[pid])
    if position <= 0 or position >= lmpTrackCount then
        set position = 1
    else
        set position = position + 1
    endif
    return LMP_GetOrderedTrack(pid, position)
endfunction

private function LMP_GetPreviousTrack takes integer pid returns integer
    local integer position

    if lmpTrackCount <= 0 then
        return 0
    endif

    set position = LMP_FindOrderPosition(pid, lmpCurrent[pid])
    if position <= 1 then
        set position = lmpTrackCount
    else
        set position = position - 1
    endif
    return LMP_GetOrderedTrack(pid, position)
endfunction

private function LMP_ShuffleOrder takes integer pid returns nothing
    local integer position
    local integer swapPosition
    local integer firstKey
    local integer secondKey
    local integer temporaryTrack
    local integer seed

    call LMP_ResetOrder(pid)
    set lmpShuffleNonce[pid] = lmpShuffleNonce[pid] + 1

    // Small deterministic PRNG: does not touch Warcraft's gameplay RNG.
    set seed = ModuloInteger((pid + 1) * 7919 + lmpShuffleNonce[pid] * 1049 + lmpTrackCount * 101, 32749)
    set position = lmpTrackCount

    loop
        exitwhen position <= 1
        set seed = ModuloInteger(seed * 25173 + 13849, 32749)
        set swapPosition = ModuloInteger(seed, position) + 1
        set firstKey = LMP_OrderKey(pid, position)
        set secondKey = LMP_OrderKey(pid, swapPosition)
        set temporaryTrack = lmpOrder[firstKey]
        set lmpOrder[firstKey] = lmpOrder[secondKey]
        set lmpOrder[secondKey] = temporaryTrack
        set position = position - 1
    endloop
endfunction

private function LMP_FormatTime takes integer totalSeconds returns string
    local integer minutes
    local integer seconds

    if totalSeconds < 0 then
        set totalSeconds = 0
    endif

    set minutes = totalSeconds / 60
    set seconds = totalSeconds - minutes * 60

    if seconds < 10 then
        return I2S(minutes) + ":0" + I2S(seconds)
    endif
    return I2S(minutes) + ":" + I2S(seconds)
endfunction

private function LMP_SetProgress takes player whichPlayer, real value returns nothing
    if value < 0.00 then
        set value = 0.00
    elseif value > 1000.00 then
        set value = 1000.00
    endif

    if GetLocalPlayer() == whichPlayer then
        call BlzFrameSetValue(lmpSeek, value)
    endif
endfunction

private function LMP_StopTrackMusic takes player whichPlayer returns nothing
    local integer pid = GetPlayerId(whichPlayer)

    // Frame callbacks only enqueue music work. The periodic timer performs all
    // music natives outside Warcraft's UI event stack.
    set lmpPendingMusicTrack[pid] = 0
    set lmpPendingMusicPositionMs[pid] = 0
    set lmpMusicSwitchPhase[pid] = 1
    set lmpSkipElapsedTick[pid] = true
endfunction

private function LMP_StartTrackMusic takes player whichPlayer, integer trackIndex, integer positionMs returns nothing
    local integer pid = GetPlayerId(whichPlayer)

    if positionMs < 0 then
        set positionMs = 0
    endif

    set lmpPendingMusicTrack[pid] = trackIndex
    set lmpPendingMusicPositionMs[pid] = positionMs
    set lmpMusicSwitchPhase[pid] = 1
    set lmpSkipElapsedTick[pid] = true
endfunction

private function LMP_ProcessMusicSwitch takes player whichPlayer returns nothing
    local integer pid = GetPlayerId(whichPlayer)
    local integer trackIndex

    if GetLocalPlayer() != whichPlayer then
        return
    endif

    if not LMP_AUDIO_ENABLED then
        set lmpActiveMusicTrack[pid] = 0
        set lmpMusicSwitchPhase[pid] = 0
        set lmpMusicVolumeDirty[pid] = false
        return
    endif

    if lmpMusicVolumeDirty[pid] then
        call SetMusicVolume(lmpPendingMusicVolume[pid])
        set lmpMusicVolumeDirty[pid] = false
    endif

    if lmpMusicSwitchPhase[pid] == 1 then
        // Reset Warcraft's internal music queue before every start. Without
        // ClearMapMusic the client may keep/restart the previously cached MP3.
        call StopMusic(false)
        call ClearMapMusic()
        set lmpActiveMusicTrack[pid] = 0
        if lmpPendingMusicTrack[pid] > 0 then
            set lmpMusicSwitchPhase[pid] = 2
        else
            set lmpMusicSwitchPhase[pid] = 0
        endif
    elseif lmpMusicSwitchPhase[pid] == 2 then
        set trackIndex = lmpPendingMusicTrack[pid]
        if trackIndex > 0 and trackIndex <= lmpTrackCount then
            // Start from zero first. Seeking a freshly loaded external MP3 in
            // the same call is unreliable on Reforged.
            set lmpSkipElapsedTick[pid] = true
            call PlayMusicEx(lmpPath[trackIndex], 0, 0)
            set lmpActiveMusicTrack[pid] = trackIndex
            if lmpPendingMusicPositionMs[pid] > 0 then
                set lmpMusicSwitchPhase[pid] = 3
            else
                set lmpPendingMusicTrack[pid] = 0
                set lmpPendingMusicPositionMs[pid] = 0
                set lmpMusicSwitchPhase[pid] = 0
            endif
        else
            set lmpPendingMusicTrack[pid] = 0
            set lmpPendingMusicPositionMs[pid] = 0
            set lmpMusicSwitchPhase[pid] = 0
        endif
    elseif lmpMusicSwitchPhase[pid] == 3 then
        // Apply the offset one timer tick after PlayMusicEx, when the new MP3
        // has already become the active music stream.
        set lmpSkipElapsedTick[pid] = true
        call SetMusicPlayPosition(lmpPendingMusicPositionMs[pid])
        set lmpPendingMusicTrack[pid] = 0
        set lmpPendingMusicPositionMs[pid] = 0
        set lmpMusicSwitchPhase[pid] = 0
    endif
endfunction

private function LMP_ApplyVolume takes player whichPlayer, integer volume returns nothing
    local integer pid = GetPlayerId(whichPlayer)
    local integer percent

    if volume < 0 then
        set volume = 0
    elseif volume > 127 then
        set volume = 127
    endif

    set lmpVolume[pid] = volume
    set percent = R2I(I2R(volume) * 100.00 / 127.00 + 0.50)

    if GetLocalPlayer() == whichPlayer then
        // Apply on the timer, not inside FRAMEEVENT_SLIDER_VALUE_CHANGED.
        set lmpPendingMusicVolume[pid] = volume
        set lmpMusicVolumeDirty[pid] = true
        call BlzFrameSetText(lmpVolumeText, "|cffffffffVOLUME " + I2S(percent) + "%|r")
    endif
endfunction

private function LMP_UpdateList takes player whichPlayer returns nothing
    local integer pid = GetPlayerId(whichPlayer)
    local integer row = 0
    local integer listPosition
    local integer trackIndex
    local string prefix

    if GetLocalPlayer() == whichPlayer then
        loop
            exitwhen row >= LMP_ROWS
            set listPosition = lmpListOffset[pid] + row + 1
            set trackIndex = LMP_GetOrderedTrack(pid, listPosition)

            if trackIndex > 0 and trackIndex <= lmpTrackCount then
                set lmpRowTrack[row] = trackIndex
                if trackIndex == lmpCurrent[pid] then
                    set prefix = "|cffffcc00> "
                else
                    set prefix = "|cffdddddd  "
                endif
                call BlzFrameSetText(lmpRow[row], prefix + I2S(trackIndex) + ". " + lmpTitle[trackIndex] + "|r")
                call BlzFrameSetEnable(lmpRow[row], true)
            else
                set lmpRowTrack[row] = 0
                call BlzFrameSetText(lmpRow[row], "")
                call BlzFrameSetEnable(lmpRow[row], false)
            endif

            set row = row + 1
        endloop
    endif
endfunction

private function LMP_UpdateHeader takes player whichPlayer returns nothing
    local integer pid = GetPlayerId(whichPlayer)
    local integer trackIndex = lmpCurrent[pid]
    local integer durationSeconds = 0

    if GetLocalPlayer() == whichPlayer then
        if trackIndex > 0 and trackIndex <= lmpTrackCount then
            call BlzFrameSetText(lmpNowPlaying, "|cffffcc00" + lmpTitle[trackIndex] + "|r")
            set durationSeconds = (lmpDurationMs[trackIndex] + 500) / 1000
            call BlzFrameSetText(lmpTimeText, LMP_FormatTime(R2I(lmpElapsed[pid])) + " / " + LMP_FormatTime(durationSeconds))
        else
            call BlzFrameSetText(lmpNowPlaying, "|cffaaaaaaNo tracks imported|r")
            call BlzFrameSetText(lmpTimeText, "0:00 / 0:00")
        endif

        if lmpLoop[pid] then
            call BlzFrameSetTexture(lmpLoopIcon, LMP_TEX_LOOP_ON, 0, true)
        else
            call BlzFrameSetTexture(lmpLoopIcon, LMP_TEX_LOOP_OFF, 0, true)
        endif

        if lmpShuffle[pid] then
            call BlzFrameSetTexture(lmpShuffleIcon, LMP_TEX_SHUFFLE_ON, 0, true)
        else
            call BlzFrameSetTexture(lmpShuffleIcon, LMP_TEX_SHUFFLE_OFF, 0, true)
        endif

        // One transport button: show PAUSE while audio is running and PLAY
        // while it is paused, stopped, or has not started yet.
        if lmpPlaying[pid] then
            call BlzFrameSetTexture(lmpPlayPauseIcon, LMP_TEX_PAUSE, 0, true)
        else
            call BlzFrameSetTexture(lmpPlayPauseIcon, LMP_TEX_PLAY, 0, true)
            call BlzFrameSetText(lmpEqualizer, "|cff666666_____________|r")
        endif
    endif
endfunction

private function LMP_UpdateTimeText takes player whichPlayer returns nothing
    local integer pid = GetPlayerId(whichPlayer)
    local integer trackIndex = lmpCurrent[pid]
    local integer durationSeconds = 0

    if GetLocalPlayer() == whichPlayer then
        if trackIndex > 0 and trackIndex <= lmpTrackCount then
            set durationSeconds = (lmpDurationMs[trackIndex] + 500) / 1000
            call BlzFrameSetText(lmpTimeText, LMP_FormatTime(R2I(lmpElapsed[pid])) + " / " + LMP_FormatTime(durationSeconds))
        else
            call BlzFrameSetText(lmpTimeText, "0:00 / 0:00")
        endif
    endif
endfunction

private function LMP_UpdateAll takes player whichPlayer returns nothing
    call LMP_UpdateList(whichPlayer)
    call LMP_UpdateHeader(whichPlayer)
endfunction

private function LMP_SetVisible takes player whichPlayer, boolean flag returns nothing
    local integer pid = GetPlayerId(whichPlayer)

    set lmpVisible[pid] = flag

    // On the first opening, enqueue stopping the map's default music. All music
    // natives are executed later by the periodic timer.
    if flag and not lmpDefaultMusicStopped[pid] then
        set lmpDefaultMusicStopped[pid] = true
        call LMP_StopTrackMusic(whichPlayer)
    endif

    if GetLocalPlayer() == whichPlayer then
        call BlzFrameSetVisible(lmpPanel, flag)
        call BlzFrameSetVisible(lmpSeek, flag)
        call BlzFrameSetVisible(lmpSeekBlocker, flag)
        call BlzFrameSetVisible(lmpVolumeSlider, flag)
        call BlzFrameSetVisible(lmpOpenButton, not flag)
    endif

    if flag then
        call LMP_UpdateAll(whichPlayer)
    endif
endfunction

private function LMP_Stop takes player whichPlayer returns nothing
    local integer pid = GetPlayerId(whichPlayer)

    call LMP_StopTrackMusic(whichPlayer)

    set lmpPlaying[pid] = false
    set lmpPaused[pid] = false
    set lmpElapsed[pid] = 0.00
    set lmpUiElapsed[pid] = 0.00
    set lmpEqualizerElapsed[pid] = 0.00
    set lmpEqualizerPhase[pid] = 0

    if GetLocalPlayer() == whichPlayer then
        call LMP_SetProgress(whichPlayer, 0.00)
    endif
    call LMP_UpdateHeader(whichPlayer)
endfunction

private function LMP_PlayTrack takes player whichPlayer, integer trackIndex returns nothing
    local integer pid = GetPlayerId(whichPlayer)
    local integer orderPosition

    if lmpTrackCount <= 0 then
        return
    endif

    if trackIndex < 1 then
        set trackIndex = lmpTrackCount
    elseif trackIndex > lmpTrackCount then
        set trackIndex = 1
    endif

    call LMP_StartTrackMusic(whichPlayer, trackIndex, 0)

    set lmpCurrent[pid] = trackIndex
    set lmpElapsed[pid] = 0.00
    set lmpUiElapsed[pid] = 0.00
    set lmpEqualizerElapsed[pid] = 0.00
    set lmpEqualizerPhase[pid] = 0
    set lmpPlaying[pid] = true
    set lmpPaused[pid] = false

    set orderPosition = LMP_FindOrderPosition(pid, trackIndex)
    if orderPosition <= lmpListOffset[pid] then
        set lmpListOffset[pid] = orderPosition - 1
    elseif orderPosition > lmpListOffset[pid] + LMP_ROWS then
        set lmpListOffset[pid] = orderPosition - LMP_ROWS
    endif
    set lmpListOffset[pid] = LMP_ClampOffset(lmpListOffset[pid])

    if GetLocalPlayer() == whichPlayer then
        call LMP_SetProgress(whichPlayer, 0.00)
        call BlzFrameSetValue(lmpScroll, I2R(LMP_MaxOffset() - lmpListOffset[pid]))
    endif

    call LMP_UpdateAll(whichPlayer)
endfunction

private function LMP_Play takes player whichPlayer returns nothing
    local integer pid = GetPlayerId(whichPlayer)

    if lmpTrackCount <= 0 then
        return
    endif

    if lmpCurrent[pid] <= 0 then
        call LMP_PlayTrack(whichPlayer, LMP_GetOrderedTrack(pid, 1))
    elseif lmpPaused[pid] then
        call LMP_StartTrackMusic(whichPlayer, lmpCurrent[pid], R2I(lmpElapsed[pid] * 1000.00))
        set lmpPlaying[pid] = true
        set lmpPaused[pid] = false
        set lmpEqualizerElapsed[pid] = 0.00
        call LMP_UpdateHeader(whichPlayer)
    elseif not lmpPlaying[pid] then
        call LMP_StartTrackMusic(whichPlayer, lmpCurrent[pid], R2I(lmpElapsed[pid] * 1000.00))
        set lmpPlaying[pid] = true
        set lmpPaused[pid] = false
        set lmpEqualizerElapsed[pid] = 0.00
        call LMP_UpdateHeader(whichPlayer)
    endif
endfunction

private function LMP_Pause takes player whichPlayer returns nothing
    local integer pid = GetPlayerId(whichPlayer)
    local integer trackIndex = lmpCurrent[pid]

    if lmpPlaying[pid] and trackIndex > 0 and trackIndex <= lmpTrackCount then
        call LMP_StopTrackMusic(whichPlayer)

        // Keep lmpElapsed unchanged. PLAY starts PlayMusicEx from this position.
        set lmpPlaying[pid] = false
        set lmpPaused[pid] = true
        set lmpUiElapsed[pid] = 0.00
        call LMP_UpdateHeader(whichPlayer)
    endif
endfunction

private function LMP_SetPosition takes player whichPlayer, integer positionMs, boolean updateSlider returns nothing
    local integer pid = GetPlayerId(whichPlayer)
    local integer trackIndex = lmpCurrent[pid]
    local integer durationMs
    local boolean wasPaused = lmpPaused[pid]
    local real seekValue

    if lmpTrackCount <= 0 then
        return
    endif

    if trackIndex <= 0 or trackIndex > lmpTrackCount then
        set trackIndex = LMP_GetOrderedTrack(pid, 1)
        set lmpCurrent[pid] = trackIndex
    endif

    set durationMs = lmpDurationMs[trackIndex]
    if durationMs <= 0 then
        return
    endif

    // Reaching/passing the end immediately starts the next track.
    if positionMs >= durationMs then
        call LMP_PlayTrack(whichPlayer, LMP_GetNextTrack(pid))
        return
    endif

    // Rewinding before the beginning clamps to 0:00.
    if positionMs < 0 then
        set positionMs = 0
    endif

    if not wasPaused then
        call LMP_StartTrackMusic(whichPlayer, trackIndex, positionMs)
    endif

    set lmpElapsed[pid] = I2R(positionMs) / 1000.00
    set lmpUiElapsed[pid] = 0.00

    if wasPaused then
        set lmpPlaying[pid] = false
        set lmpPaused[pid] = true
    else
        set lmpPlaying[pid] = true
        set lmpPaused[pid] = false
    endif

    if updateSlider and GetLocalPlayer() == whichPlayer then
        set seekValue = I2R(positionMs) * 1000.00 / I2R(durationMs)
        call LMP_SetProgress(whichPlayer, seekValue)
    endif

    call LMP_UpdateAll(whichPlayer)
endfunction

private function LMP_SkipSeconds takes player whichPlayer, integer deltaSeconds returns nothing
    local integer pid = GetPlayerId(whichPlayer)
    local integer newPositionMs = R2I(lmpElapsed[pid] * 1000.00) + deltaSeconds * 1000

    call LMP_SetPosition(whichPlayer, newPositionMs, true)
endfunction

private function LMP_Next takes player whichPlayer returns nothing
    local integer pid = GetPlayerId(whichPlayer)
    call LMP_PlayTrack(whichPlayer, LMP_GetNextTrack(pid))
endfunction

private function LMP_Previous takes player whichPlayer returns nothing
    local integer pid = GetPlayerId(whichPlayer)
    call LMP_PlayTrack(whichPlayer, LMP_GetPreviousTrack(pid))
endfunction

private function LMP_Rerun takes player whichPlayer returns nothing
    local integer pid = GetPlayerId(whichPlayer)

    if lmpCurrent[pid] > 0 and lmpCurrent[pid] <= lmpTrackCount then
        call LMP_PlayTrack(whichPlayer, lmpCurrent[pid])
    elseif lmpTrackCount > 0 then
        call LMP_PlayTrack(whichPlayer, LMP_GetOrderedTrack(pid, 1))
    endif
endfunction

private function LMP_ToggleShuffle takes player whichPlayer returns nothing
    local integer pid = GetPlayerId(whichPlayer)
    local integer orderPosition

    if lmpShuffle[pid] then
        set lmpShuffle[pid] = false
        call LMP_ResetOrder(pid)
    else
        set lmpShuffle[pid] = true
        call LMP_ShuffleOrder(pid)
    endif

    // Keep the current audio untouched and only reveal it in the new order.
    set orderPosition = LMP_FindOrderPosition(pid, lmpCurrent[pid])
    if orderPosition <= 0 then
        set lmpListOffset[pid] = 0
    elseif orderPosition <= lmpListOffset[pid] then
        set lmpListOffset[pid] = orderPosition - 1
    elseif orderPosition > lmpListOffset[pid] + LMP_ROWS then
        set lmpListOffset[pid] = orderPosition - LMP_ROWS
    endif
    set lmpListOffset[pid] = LMP_ClampOffset(lmpListOffset[pid])

    if GetLocalPlayer() == whichPlayer then
        call BlzFrameSetValue(lmpScroll, I2R(LMP_MaxOffset() - lmpListOffset[pid]))
    endif
    call LMP_UpdateAll(whichPlayer)
endfunction

private function LMP_UpdateEqualizer takes player whichPlayer returns nothing
    local integer pid = GetPlayerId(whichPlayer)
    local integer phase = lmpEqualizerPhase[pid]

    if GetLocalPlayer() == whichPlayer and lmpPlaying[pid] then
        if phase == 0 then
            call BlzFrameSetText(lmpEqualizer, "|cff33ccff___/\\____/\\/\\____/\\___|r")
        elseif phase == 1 then
            call BlzFrameSetText(lmpEqualizer, "|cff33ccff_/\\/\\___/\\____/\\/\\____|r")
        elseif phase == 2 then
            call BlzFrameSetText(lmpEqualizer, "|cff33ccff/\\___/\\/\\__/\\___/\\_/\\_|r")
        else
            call BlzFrameSetText(lmpEqualizer, "|cff33ccff\\____/\\___/\\/\\____/\\__|r")
        endif
    endif
endfunction

//===========================================================================
// Frame event handlers
//===========================================================================
private function LMP_OnClick takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local framehandle clicked = BlzGetTriggerFrame()
    local integer row = 0
    local integer trackIndex

    if lmpClickBusy[pid] then
        set clicked = null
        set p = null
        return
    endif
    set lmpClickBusy[pid] = true

    if clicked == lmpOpenButton then
        call LMP_SetVisible(p, true)
    elseif clicked == lmpLinkButton then
        set lmpLinkVisible[pid] = true
        if GetLocalPlayer() == p then
            call BlzFrameSetVisible(lmpLinkButton, false)
            call BlzFrameSetVisible(lmpLinkActiveButton, true)
            call BlzFrameSetVisible(lmpLinkEdit, true)
            call BlzFrameSetEnable(lmpLinkEdit, true)
            call BlzFrameSetFocus(lmpLinkEdit, true)
            call BlzFrameSetText(lmpLinkEdit, "")
            call BlzFrameSetText(lmpLinkEdit, LMP_LINK_URL)
        endif
    elseif clicked == lmpLinkActiveButton then
        set lmpLinkVisible[pid] = false
        if GetLocalPlayer() == p then
        
            call BlzFrameSetFocus(lmpLinkEdit, false)
            call BlzFrameSetVisible(lmpLinkEdit, false)
            call BlzFrameSetVisible(lmpLinkActiveButton, false)
            
            call BlzFrameSetVisible(lmpLinkButton, true)
        endif
    elseif clicked == lmpCloseButton then
        call LMP_SetVisible(p, false)
    elseif clicked == lmpShuffleButton then
        call LMP_ToggleShuffle(p)
    elseif clicked == lmpBack10Button then
        call LMP_SkipSeconds(p, -10)
    elseif clicked == lmpPreviousButton then
        call LMP_Previous(p)
    elseif clicked == lmpRerunButton then
        call LMP_Rerun(p)
    elseif clicked == lmpPlayPauseButton then
        if lmpPlaying[pid] then
            call LMP_Pause(p)
        else
            call LMP_Play(p)
        endif
    elseif clicked == lmpForward10Button then
        call LMP_SkipSeconds(p, 10)
    elseif clicked == lmpNextButton then
        call LMP_Next(p)
    elseif clicked == lmpLoopButton then
        set lmpLoop[pid] = not lmpLoop[pid]
        call LMP_UpdateHeader(p)
    else
        loop
            exitwhen row >= LMP_ROWS
            if clicked == lmpRow[row] then
                set trackIndex = lmpRowTrack[row]
                if trackIndex > 0 and trackIndex <= lmpTrackCount then
                    call LMP_PlayTrack(p, trackIndex)
                endif
                set row = LMP_ROWS
            endif
            set row = row + 1
        endloop
    endif

    set lmpClickBusy[pid] = false
    set clicked = null
    set p = null
endfunction

private function LMP_OnLinkEdit takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local framehandle editBox = BlzGetTriggerFrame()

    if GetLocalPlayer() == p then
        call BlzFrameSetFocus(editBox, true)
        call BlzFrameSetText(editBox, "")
        call BlzFrameSetText(editBox, LMP_LINK_URL)
    endif

    set editBox = null
    set p = null
endfunction

private function LMP_OnVolume takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer volume = R2I(BlzGetTriggerFrameValue() + 0.50)

    call LMP_ApplyVolume(p, volume)

    set p = null
endfunction

private function LMP_OnScroll takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local integer sliderValue = R2I(BlzGetTriggerFrameValue() + 0.50)

    set lmpListOffset[pid] = LMP_ClampOffset(LMP_MaxOffset() - sliderValue)
    call LMP_UpdateList(p)

    set p = null
endfunction

private function LMP_OnWheel takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local real wheelValue = BlzGetTriggerFrameValue()

    if wheelValue < 0.00 then
        set lmpListOffset[pid] = LMP_ClampOffset(lmpListOffset[pid] + 1)
    elseif wheelValue > 0.00 then
        set lmpListOffset[pid] = LMP_ClampOffset(lmpListOffset[pid] - 1)
    endif

    if GetLocalPlayer() == p then
        call BlzFrameSetValue(lmpScroll, I2R(LMP_MaxOffset() - lmpListOffset[pid]))
    endif
    call LMP_UpdateList(p)

    set p = null
endfunction

private function LMP_OnChat takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)

    call LMP_SetVisible(p, not lmpVisible[pid])
    set p = null
endfunction

private function LMP_OnTick takes nothing returns nothing
    local integer pid = 0
    local integer trackIndex
    local integer durationMs
    local integer nextTrack
    local real seekValue
    local player p

    loop
        exitwhen pid >= bj_MAX_PLAYERS
        set p = Player(pid)

        call LMP_ProcessMusicSwitch(p)

        // Playback time is intentionally maintained only on the owning client.
        // При Stop/Clear/Play/Seek звук ещё не прошёл полный тик, поэтому этот
        // тик нельзя добавлять к показанному времени.
        if GetLocalPlayer() == p and lmpPlaying[pid] and not lmpSkipElapsedTick[pid] then
            set trackIndex = lmpCurrent[pid]
            if trackIndex > 0 and trackIndex <= lmpTrackCount then
                set lmpElapsed[pid] = lmpElapsed[pid] + LMP_TICK
                set lmpUiElapsed[pid] = lmpUiElapsed[pid] + LMP_TICK
                set lmpEqualizerElapsed[pid] = lmpEqualizerElapsed[pid] + LMP_TICK
                set durationMs = lmpDurationMs[trackIndex]

                if durationMs > 0 then
                    if lmpElapsed[pid] * 1000.00 >= I2R(durationMs - LMP_END_GUARD_MS) then
                        if lmpLoop[pid] then
                            set nextTrack = trackIndex
                        else
                            set nextTrack = LMP_GetNextTrack(pid)
                        endif
                        call LMP_PlayTrack(p, nextTrack)
                    else
                        // Keep the horizontal thumb moving smoothly.
                        set seekValue = lmpElapsed[pid] * 1000000.00 / I2R(durationMs)
                        call LMP_SetProgress(p, seekValue)

                        if lmpEqualizerElapsed[pid] >= 0.20 then
                            set lmpEqualizerElapsed[pid] = 0.00
                            set lmpEqualizerPhase[pid] = ModuloInteger(lmpEqualizerPhase[pid] + 1, 4)
                            call LMP_UpdateEqualizer(p)
                        endif

                        if lmpUiElapsed[pid] >= 0.50 then
                            set lmpUiElapsed[pid] = 0.00
                            // Do not reassign button textures from the timer.
                            // Only the elapsed-time label needs periodic work.
                            call LMP_UpdateTimeText(p)
                        endif
                    endif
                endif
            endif
        endif

        if GetLocalPlayer() == p and lmpSkipElapsedTick[pid] then
            set lmpSkipElapsedTick[pid] = false
        endif

        set pid = pid + 1
    endloop

    set p = null
endfunction

//===========================================================================
// Frame construction
//===========================================================================
private function LMP_CreateTextButton takes framehandle parent, string text, real x, real y, real width, real height, integer context returns framehandle
    local framehandle newFrame = BlzCreateFrame("ScriptDialogButton", parent, 0, context)

    call BlzFrameSetAbsPoint(newFrame, FRAMEPOINT_CENTER, x, y)
    call BlzFrameSetSize(newFrame, width, height)
    call BlzFrameSetText(newFrame, text)
    call BlzTriggerRegisterFrameEvent(lmpClickTrigger, newFrame, FRAMEEVENT_CONTROL_CLICK)

    return newFrame
endfunction

private function LMP_CreateIconButton takes framehandle parent, real x, real y, real size, integer context returns framehandle
    local framehandle newFrame = BlzCreateFrameByType("BUTTON", "LMPIconButton", parent, "ScoreScreenTabButtonTemplate", context)

    call BlzFrameSetAbsPoint(newFrame, FRAMEPOINT_CENTER, x, y)
    call BlzFrameSetSize(newFrame, size, size)
    call BlzTriggerRegisterFrameEvent(lmpClickTrigger, newFrame, FRAMEEVENT_CONTROL_CLICK)

    return newFrame
endfunction

private function LMP_CreateIcon takes framehandle iconParent, string texture returns framehandle
    local framehandle icon = BlzCreateFrameByType("BACKDROP", "LMPIcon", iconParent, "", 0)

    call BlzFrameSetAllPoints(icon, iconParent)
    call BlzFrameSetTexture(icon, texture, 0, true)

    return icon
endfunction

private function LMP_AttachNativeTooltip takes framehandle whichFrame, string whichText returns nothing
    local integer context = lmpTooltipContext
    local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "LMPNativeTooltip", lmpPanel, "", context)
    local framehandle tooltipText = BlzCreateFrameByType("TEXT", "LMPNativeTooltipText", tooltip, "", context)

    set lmpTooltipContext = lmpTooltipContext + 1

    call BlzFrameSetAbsPoint(tooltip, FRAMEPOINT_CENTER, LMP_TOOLTIP_X, LMP_TOOLTIP_Y)
    call BlzFrameSetSize(tooltip, LMP_TOOLTIP_WIDTH, LMP_TOOLTIP_HEIGHT)
    call BlzFrameSetTexture(tooltip, LMP_TEX_BLACK, 0, true)
    call BlzFrameSetAlpha(tooltip, 235)
    call BlzFrameSetLevel(tooltip, 50)

    call BlzFrameSetAllPoints(tooltipText, tooltip)
    call BlzFrameSetTextAlignment(tooltipText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(tooltipText, 0.90)
    call BlzFrameSetText(tooltipText, "|cffffffff" + whichText + "|r")

    // Warcraft owns tooltip visibility. No enter/leave frame events are used.
    call BlzFrameSetVisible(tooltip, false)
    call BlzFrameSetTooltip(whichFrame, tooltip)

    set tooltipText = null
    set tooltip = null
endfunction

private function LMP_CreateFrames takes nothing returns nothing
    local framehandle consoleUI = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    local framehandle gameUI = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    local framehandle title
    local framehandle icon
    local integer row = 0
    local real rowY

    // Independent external buttons: no ResourceBar/Upkeep lookup, mutation or anchor.
    set lmpOpenButton = LMP_CreateIconButton(consoleUI, LMP_OPEN_X, LMP_OPEN_Y, LMP_OPEN_SIZE, 100)
    set icon = LMP_CreateIcon(lmpOpenButton, LMP_TEX_OPEN)
    call BlzFrameSetLevel(lmpOpenButton, 100)
    call BlzFrameSetLevel(icon, 101)
    call BlzFrameSetVisible(lmpOpenButton,false)
    set lmpLinkButton = LMP_CreateIconButton(consoleUI, LMP_LINK_X, LMP_LINK_Y, LMP_LINK_SIZE, 101)
    set lmpLinkIcon = LMP_CreateIcon(lmpLinkButton, LMP_TEX_LINK)
    call BlzFrameSetLevel(lmpLinkButton, 100)
    call BlzFrameSetLevel(lmpLinkIcon, 101)    
    call BlzFrameSetVisible(lmpLinkButton, false)
    
    set lmpLinkActiveButton = LMP_CreateIconButton(consoleUI, LMP_LINK_X, LMP_LINK_Y, LMP_LINK_SIZE, 102)
    set lmpLinkActiveIcon = LMP_CreateIcon(lmpLinkActiveButton, LMP_TEX_CLOSE)
    call BlzFrameSetLevel(lmpLinkActiveButton, 100)
    call BlzFrameSetLevel(lmpLinkActiveIcon, 101)
    call BlzFrameSetVisible(lmpLinkActiveButton, false)

    set lmpLinkEdit = BlzCreateFrame("EscMenuEditBoxTemplate", consoleUI, 0, 0)
    call BlzFrameSetAbsPoint(lmpLinkEdit, FRAMEPOINT_CENTER, LMP_LINK_EDIT_X, LMP_LINK_EDIT_Y)
    call BlzFrameClearAllPoints(lmpLinkEdit)
    call BlzFrameSetPoint(lmpLinkEdit, FRAMEPOINT_TOP, lmpLinkButton, FRAMEPOINT_BOTTOM, 0.000, -0.004)
    call BlzFrameSetSize(lmpLinkEdit, LMP_LINK_EDIT_WIDTH, LMP_LINK_EDIT_HEIGHT)
    call BlzFrameSetText(lmpLinkEdit, LMP_LINK_URL)
    call BlzFrameSetEnable(lmpLinkEdit, true)
    call BlzFrameSetLevel(lmpLinkEdit, 20)
    call BlzFrameSetVisible(lmpLinkEdit, false)
    call BlzTriggerRegisterFrameEvent(lmpLinkEditTrigger, lmpLinkEdit, FRAMEEVENT_EDITBOX_ENTER)
    call BlzTriggerRegisterFrameEvent(lmpLinkEditTrigger, lmpLinkEdit, FRAMEEVENT_CONTROL_CLICK)

    // Plain black translucent background, matching the emoji panel.
    set lmpPanel = BlzCreateFrameByType("BACKDROP", "LMPPanel", consoleUI, "", 0)
    call BlzFrameSetAbsPoint(lmpPanel, FRAMEPOINT_CENTER, LMP_PANEL_X, LMP_PANEL_Y)
    call BlzFrameSetSize(lmpPanel, LMP_PANEL_WIDTH, LMP_PANEL_HEIGHT)
    call BlzFrameSetTexture(lmpPanel, LMP_TEX_BLACK, 0, true)
    call BlzFrameSetAlpha(lmpPanel, 210)

    set title = BlzCreateFrameByType("TEXT", "LMPTitle", lmpPanel, "", 0)
    call BlzFrameSetAbsPoint(title, FRAMEPOINT_CENTER, LMP_TITLE_X, LMP_TITLE_Y)
    call BlzFrameSetSize(title, LMP_TITLE_WIDTH, LMP_TITLE_HEIGHT)
    call BlzFrameSetTextAlignment(title, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(title, 0.82)
    call BlzFrameSetText(title, "|cffffcc00WOS2 Music|r")

    set lmpCloseButton = LMP_CreateIconButton(lmpPanel, LMP_CLOSE_X, LMP_CLOSE_Y, LMP_CLOSE_SIZE, 103)
    set icon = LMP_CreateIcon(lmpCloseButton, LMP_TEX_CLOSE)

    set lmpNowPlaying = BlzCreateFrameByType("TEXT", "LMPNowPlaying", lmpPanel, "", 0)
    call BlzFrameSetAbsPoint(lmpNowPlaying, FRAMEPOINT_CENTER, LMP_NOW_X, LMP_NOW_Y)
    call BlzFrameSetSize(lmpNowPlaying, LMP_NOW_WIDTH, LMP_NOW_HEIGHT)
    call BlzFrameSetTextAlignment(lmpNowPlaying, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)

    set lmpEqualizer = BlzCreateFrameByType("TEXT", "LMPEqualizer", lmpPanel, "", 0)
    call BlzFrameSetAbsPoint(lmpEqualizer, FRAMEPOINT_CENTER, LMP_EQUALIZER_X, LMP_EQUALIZER_Y)
    call BlzFrameSetSize(lmpEqualizer, LMP_EQUALIZER_WIDTH, LMP_EQUALIZER_HEIGHT)
    call BlzFrameSetTextAlignment(lmpEqualizer, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(lmpEqualizer, 0.78)
    call BlzFrameSetText(lmpEqualizer, "|cff666666_____________|r")

    set lmpTimeText = BlzCreateFrameByType("TEXT", "LMPTime", lmpPanel, "", 0)
    call BlzFrameSetAbsPoint(lmpTimeText, FRAMEPOINT_CENTER, LMP_TIME_X, LMP_TIME_Y)
    call BlzFrameSetSize(lmpTimeText, LMP_TIME_WIDTH, LMP_TIME_HEIGHT)
    call BlzFrameSetTextAlignment(lmpTimeText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(lmpTimeText, 0.78)

    // Native horizontal template from UI\FrameDef\UI\escmenutemplates.fdf.
    // Templates.TOC is loaded immediately before LocalMp3Player_CreateUI.
    set lmpSeek = BlzCreateFrame("EscMenuSliderTemplate", gameUI, 0, 0)
    if lmpSeek == null then
        call BJDebugMsg("|cffff2020LocalMp3Player: native EscMenuSliderTemplate was not created.|r")
        return
    endif
    call BlzFrameClearAllPoints(lmpSeek)
    call BlzFrameSetAbsPoint(lmpSeek, FRAMEPOINT_CENTER, LMP_PROGRESS_X, LMP_PROGRESS_Y)
    call BlzFrameSetSize(lmpSeek, LMP_PROGRESS_WIDTH, LMP_PROGRESS_HEIGHT)
    call BlzFrameSetMinMaxValue(lmpSeek, 0.00, 1000.00)
    call BlzFrameSetStepSize(lmpSeek, 1.00)
    call BlzFrameSetAlpha(lmpSeek, 255)
    call BlzFrameSetValue(lmpSeek, 0.00)
    call BlzFrameSetEnable(lmpSeek, true)
    call BlzFrameSetVisible(lmpSeek, true)
    call BlzFrameSetLevel(lmpSeek, 20)

    // The duration bar is display-only. This transparent frame consumes mouse
    // clicks while leaving the slider and its moving thumb fully visible.
    set lmpSeekBlocker = BlzCreateFrameByType("BUTTON", "LMPProgressBlocker", gameUI, "", 600)
    call BlzFrameClearAllPoints(lmpSeekBlocker)
    call BlzFrameSetAbsPoint(lmpSeekBlocker, FRAMEPOINT_CENTER, LMP_PROGRESS_X, LMP_PROGRESS_Y)
    call BlzFrameSetSize(lmpSeekBlocker, LMP_PROGRESS_WIDTH, LMP_PROGRESS_HEIGHT)
    call BlzFrameSetAlpha(lmpSeekBlocker, 0)
    call BlzFrameSetLevel(lmpSeekBlocker, 21)

    // Three visible tracks; additional tracks are reached by wheel/scrollbar.
    set lmpListBox = BlzCreateFrameByType("BACKDROP", "LMPListBox", lmpPanel, "", 0)
    call BlzFrameSetAbsPoint(lmpListBox, FRAMEPOINT_CENTER, LMP_LIST_X, LMP_LIST_Y)
    call BlzFrameSetSize(lmpListBox, LMP_LIST_WIDTH, LMP_LIST_HEIGHT)
    call BlzFrameSetTexture(lmpListBox, LMP_TEX_BLACK, 0, true)
    call BlzFrameSetAlpha(lmpListBox, 210)
    call BlzFrameSetEnable(lmpListBox, true)
    call BlzTriggerRegisterFrameEvent(lmpWheelTrigger, lmpListBox, FRAMEEVENT_MOUSE_WHEEL)

    loop
        exitwhen row >= LMP_ROWS
        set rowY = LMP_ROW_FIRST_Y - I2R(row) * LMP_ROW_STEP_Y
        set lmpRow[row] = LMP_CreateTextButton(lmpListBox, "", LMP_ROW_X, rowY, LMP_ROW_WIDTH, LMP_ROW_HEIGHT, 300 + row)
        call BlzTriggerRegisterFrameEvent(lmpWheelTrigger, lmpRow[row], FRAMEEVENT_MOUSE_WHEEL)
        set row = row + 1
    endloop

    set lmpScroll = BlzCreateFrameByType("SLIDER", "LMPScroll", lmpPanel, "QuestMainListScrollBar", 0)
    call BlzFrameSetAbsPoint(lmpScroll, FRAMEPOINT_CENTER, LMP_SCROLL_X, LMP_SCROLL_Y)
    call BlzFrameSetSize(lmpScroll, LMP_SCROLL_WIDTH, LMP_SCROLL_HEIGHT)
    call BlzFrameSetMinMaxValue(lmpScroll, 0.00, I2R(LMP_MaxOffset()))
    call BlzFrameSetStepSize(lmpScroll, 1.00)
    call BlzFrameSetValue(lmpScroll, I2R(LMP_MaxOffset()))
    call BlzTriggerRegisterFrameEvent(lmpScrollTrigger, lmpScroll, FRAMEEVENT_SLIDER_VALUE_CHANGED)

    // First row: previous, -10, play/pause, +10, next.
    set lmpPreviousButton = LMP_CreateIconButton(lmpPanel, LMP_PREVIOUS_X, LMP_CONTROLS_ROW1_Y, LMP_CONTROL_SIZE, 200)
    set icon = LMP_CreateIcon(lmpPreviousButton, LMP_TEX_PREVIOUS)
    set lmpBack10Button = LMP_CreateIconButton(lmpPanel, LMP_BACK_10_X, LMP_CONTROLS_ROW1_Y, LMP_CONTROL_SIZE, 201)
    set icon = LMP_CreateIcon(lmpBack10Button, LMP_TEX_BACK_10)
    set lmpPlayPauseButton = LMP_CreateIconButton(lmpPanel, LMP_PLAY_PAUSE_X, LMP_CONTROLS_ROW1_Y, LMP_CONTROL_SIZE, 202)
    set lmpPlayPauseIcon = LMP_CreateIcon(lmpPlayPauseButton, LMP_TEX_PLAY)
    set lmpForward10Button = LMP_CreateIconButton(lmpPanel, LMP_FORWARD_10_X, LMP_CONTROLS_ROW1_Y, LMP_CONTROL_SIZE, 203)
    set icon = LMP_CreateIcon(lmpForward10Button, LMP_TEX_FORWARD_10)
    set lmpNextButton = LMP_CreateIconButton(lmpPanel, LMP_NEXT_X, LMP_CONTROLS_ROW1_Y, LMP_CONTROL_SIZE, 204)
    set icon = LMP_CreateIcon(lmpNextButton, LMP_TEX_NEXT)

    // Second centered row: restart, loop, shuffle.
    set lmpRerunButton = LMP_CreateIconButton(lmpPanel, LMP_RERUN_X, LMP_CONTROLS_ROW2_Y, LMP_CONTROL_SIZE, 205)
    set icon = LMP_CreateIcon(lmpRerunButton, LMP_TEX_RERUN)
    set lmpLoopButton = LMP_CreateIconButton(lmpPanel, LMP_LOOP_X, LMP_CONTROLS_ROW2_Y, LMP_CONTROL_SIZE, 206)
    set lmpLoopIcon = LMP_CreateIcon(lmpLoopButton, LMP_TEX_LOOP_OFF)
    set lmpShuffleButton = LMP_CreateIconButton(lmpPanel, LMP_SHUFFLE_X, LMP_CONTROLS_ROW2_Y, LMP_CONTROL_SIZE, 207)
    set lmpShuffleIcon = LMP_CreateIcon(lmpShuffleButton, LMP_TEX_SHUFFLE_OFF)

    call LMP_AttachNativeTooltip(lmpPreviousButton, "Previous track")
    call LMP_AttachNativeTooltip(lmpBack10Button, "Rewind 10 seconds")
    call LMP_AttachNativeTooltip(lmpPlayPauseButton, "Play / pause")
    call LMP_AttachNativeTooltip(lmpForward10Button, "Forward 10 seconds")
    call LMP_AttachNativeTooltip(lmpNextButton, "Next track")
    call LMP_AttachNativeTooltip(lmpRerunButton, "Restart current track")
    call LMP_AttachNativeTooltip(lmpLoopButton, "Repeat current track")
    call LMP_AttachNativeTooltip(lmpShuffleButton, "Shuffle playlist")

    // Real horizontal interactive volume slider using the same built-in skin.
    set lmpVolumeText = BlzCreateFrameByType("TEXT", "LMPVolumeText", lmpPanel, "", 0)
    call BlzFrameSetAbsPoint(lmpVolumeText, FRAMEPOINT_CENTER, LMP_VOLUME_TEXT_X, LMP_VOLUME_TEXT_Y)
    call BlzFrameSetSize(lmpVolumeText, LMP_VOLUME_TEXT_WIDTH, LMP_VOLUME_TEXT_HEIGHT)
    call BlzFrameSetTextAlignment(lmpVolumeText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(lmpVolumeText, 0.72)
    call BlzFrameSetText(lmpVolumeText, "|cffffffffVOLUME 100%|r")

    set lmpVolumeSlider = BlzCreateFrame("EscMenuSliderTemplate", gameUI, 0, 1)
    if lmpVolumeSlider == null then
        call BJDebugMsg("|cffff2020LocalMp3Player: native volume EscMenuSliderTemplate was not created.|r")
        return
    endif
    call BlzFrameClearAllPoints(lmpVolumeSlider)
    call BlzFrameSetAbsPoint(lmpVolumeSlider, FRAMEPOINT_CENTER, LMP_VOLUME_X, LMP_VOLUME_Y)
    call BlzFrameSetSize(lmpVolumeSlider, LMP_VOLUME_WIDTH, LMP_VOLUME_HEIGHT)
    call BlzFrameSetMinMaxValue(lmpVolumeSlider, 0.00, 127.00)
    call BlzFrameSetStepSize(lmpVolumeSlider, 1.00)
    call BlzFrameSetAlpha(lmpVolumeSlider, 255)
    call BlzFrameSetValue(lmpVolumeSlider, 127.00)
    call BlzFrameSetEnable(lmpVolumeSlider, true)
    call BlzFrameSetVisible(lmpVolumeSlider, true)
    call BlzFrameSetLevel(lmpVolumeSlider, 20)
    call BlzTriggerRegisterFrameEvent(lmpVolumeTrigger, lmpVolumeSlider, FRAMEEVENT_SLIDER_VALUE_CHANGED)

    call BlzFrameSetVisible(lmpPanel, false)
    call BlzFrameSetVisible(lmpSeek, false)
    call BlzFrameSetVisible(lmpSeekBlocker, false)
    call BlzFrameSetVisible(lmpVolumeSlider, false)
    // После полного создания музыкального UI показываем кнопку открытия.
    call BlzFrameSetVisible(lmpOpenButton, true)
    call BlzFrameSetVisible(lmpLinkButton, true)

    call TriggerAddAction(lmpClickTrigger, function LMP_OnClick)
    call TriggerAddAction(lmpScrollTrigger, function LMP_OnScroll)
    call TriggerAddAction(lmpWheelTrigger, function LMP_OnWheel)
    call TriggerAddAction(lmpLinkEditTrigger, function LMP_OnLinkEdit)
    call TriggerAddAction(lmpVolumeTrigger, function LMP_OnVolume)

    set lmpFramesReady = true
    set icon = null
    set title = null
    set gameUI = null
    set consoleUI = null
endfunction

//===========================================================================
// Deferred local MP3 duration scan
//===========================================================================
private function LMP_FinishTrackScan takes nothing returns nothing
    local integer pid = 0
    local player p

    call PauseTimer(lmpScanTimer)

    loop
        exitwhen pid >= bj_MAX_PLAYERS
        call LMP_ResetOrder(pid)

        if lmpFramesReady then
            set p = Player(pid)
            if GetLocalPlayer() == p then
                set lmpListOffset[pid] = 0
                call BlzFrameSetMinMaxValue(lmpScroll, 0.00, I2R(LMP_MaxOffset()))
                call BlzFrameSetValue(lmpScroll, I2R(LMP_MaxOffset()))
            endif
            call LMP_UpdateAll(p)
        endif

        set pid = pid + 1
    endloop

    set p = null
endfunction

private function LMP_ScanTrackTick takes nothing returns nothing
    local string filePath
    local string displayName
    local integer durationMs
    local integer batch = 0

    if lmpScanTrack > LMP_SCAN_FILE_COUNT then
        call LMP_FinishTrackScan()
        return
    endif

    // Один файл за тик ограничивает максимальный синхронный I/O-всплеск.
    loop
        exitwhen batch >= LMP_SCAN_BATCH or lmpScanTrack > LMP_SCAN_FILE_COUNT

        set filePath = "Music\\" + I2S(lmpScanTrack) + ".mp3"
        if lmpScanTrack < 10 then
            set displayName = "Track 0" + I2S(lmpScanTrack)
        else
            set displayName = "Track " + I2S(lmpScanTrack)
        endif

        // Натив читает локальный файл напрямую и не создаёт sound-handle.
        // Поэтому локальная замена Music\\N.mp3 по-прежнему получает свою длительность.
        set durationMs = GetSoundFileDuration(filePath)
        if durationMs > LMP_DURATION_CORRECTION_MS then
            set durationMs = durationMs - LMP_DURATION_CORRECTION_MS
        endif

        if durationMs > 0 and lmpTrackCount < LMP_MAX_TRACKS then
            set lmpTrackCount = lmpTrackCount + 1
            set lmpPath[lmpTrackCount] = filePath
            set lmpTitle[lmpTrackCount] = displayName
            set lmpDurationMs[lmpTrackCount] = durationMs
        endif

        set lmpScanTrack = lmpScanTrack + 1
        set batch = batch + 1
    endloop

    if lmpScanTrack > LMP_SCAN_FILE_COUNT then
        call LMP_FinishTrackScan()
    endif
endfunction

private function LMP_BeginTrackScan takes nothing returns nothing
    set lmpScanTrack = 1
    set lmpTrackCount = 0
    call TimerStart(lmpScanTimer, LMP_SCAN_INTERVAL, true, function LMP_ScanTrackTick)
endfunction
//===========================================================================
// Initialization
//===========================================================================
function LocalMp3Player_CreateUI takes nothing returns nothing
    local integer pid = 0
    local player p

    if lmpFramesReady then
        return
    endif

    // The TOC is normally loaded by the library initializer. Retry once here
    // in case another map system requested the UI unusually early.
    if not lmpTocLoaded then
        set lmpTocLoaded = BlzLoadTOCFile("war3mapImported\\Templates.toc")
    endif

    if not lmpTocLoaded then
        call BJDebugMsg("|cffff2020LocalMp3Player: failed to load war3mapImported\\Templates.toc.|r")
        return
    endif

    call LMP_CreateFrames()

    if lmpFramesReady then
        loop
            exitwhen pid >= bj_MAX_PLAYERS
            set p = Player(pid)
            if GetLocalPlayer() == p then
                call BlzFrameSetText(lmpVolumeText, "|cffffffffVOLUME 100%|r")
            endif
            set pid = pid + 1
        endloop
        call TimerStart(lmpUpdateTimer, LMP_TICK, true, function LMP_OnTick)
    endif

    set p = null
endfunction



private function LocalMp3Player_Init takes nothing returns nothing
    local integer pid = 0
    local player p
    // Load all required frame definitions once, before any player UI is built.
    set lmpTocLoaded = BlzLoadTOCFile("war3mapImported\\Templates.toc")
    if not lmpTocLoaded then
        call BJDebugMsg("|cffff2020LocalMp3Player: failed to load war3mapImported\\Templates.toc during initialization.|r")
    endif
    loop
        exitwhen pid >= 10
        set p = Player(pid)
        set lmpCurrent[pid] = 0
        set lmpListOffset[pid] = 0
        set lmpPlaying[pid] = false
        set lmpPaused[pid] = false
        set lmpLoop[pid] = false
        set lmpShuffle[pid] = false
        set lmpVisible[pid] = false
        set lmpLinkVisible[pid] = false
        set lmpClickBusy[pid] = false
        set lmpShuffleNonce[pid] = 0
        set lmpElapsed[pid] = 0.00
        set lmpUiElapsed[pid] = 0.00
        set lmpEqualizerElapsed[pid] = 0.00
        set lmpEqualizerPhase[pid] = 0
        set lmpVolume[pid] = 127
        set lmpDefaultMusicStopped[pid] = false
        set lmpActiveMusicTrack[pid] = 0
        set lmpPendingMusicTrack[pid] = 0
        set lmpPendingMusicPositionMs[pid] = 0
        set lmpMusicSwitchPhase[pid] = 0
        set lmpPendingMusicVolume[pid] = 127
        set lmpMusicVolumeDirty[pid] = false
        set lmpSkipElapsedTick[pid] = false
        call LMP_ResetOrder(pid)
        call TriggerRegisterPlayerChatEvent(lmpChatTrigger, p, LMP_COMMAND, true)
        set pid = pid + 1
    endloop

    call TriggerAddAction(lmpChatTrigger, function LMP_OnChat)

    // Let map music and mode-selection initialization finish first.
    call TimerStart(lmpScanTimer, LMP_SCAN_DELAY, false, function LMP_BeginTrackScan)

    set p = null
endfunction

endlibrary

