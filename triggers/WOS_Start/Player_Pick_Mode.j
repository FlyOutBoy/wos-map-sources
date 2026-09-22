// WoS Captain Mode — отдельный подключаемый модуль.
// Кодировка: UTF-8. Добавьте этот файл/триггер раньше основного HeroPick-кода.
// Внутри веток GetLocalPlayer допустимы только прямые операции BlzFrame*.
// Звуки подтверждения Captain Mode запускаются синхронно через MakeSound.
// Основной код сохраняет только точки подключения: InitTrig_UI, PrepareStart, бан-фаза и расчёт команд.

globals
    integer CapPickPhase = 0
    integer CaptainPid1 = -1
    integer CaptainPid2 = -1
    integer array FullTeam1
    integer array FullTeam2
    integer FullTeam1Size = 0
    integer FullTeam2Size = 0
    integer array PickOrderCap // Р РЋРІР‚РЋР В Р’ВµР В РІвЂћвЂ“ Р РЋРІР‚В¦Р В РЎвЂўР В РўвЂ: 0 = cap1, 1 = cap2
    integer array PicksPerTurn // Р РЋР С“Р В РЎвЂќР В РЎвЂўР В Р’В»Р РЋР Р‰Р В РЎвЂќР В РЎвЂў Р В РЎвЂ”Р В РЎвЂР В РЎвЂќР В РЎвЂўР В Р вЂ  Р В Р’В·Р В Р’В° Р РЋРІР‚В¦Р В РЎвЂўР В РўвЂ
    integer CurrentPickTurn = 0
    integer PicksDoneThisTurn = 0
    integer array Team1Pick
    integer array Team2Pick
    integer Team1Count = 0
    integer Team2Count = 0
    boolean array PlayerPicked
    integer array DetCapWinners
    trigger FrameCapClick
    trigger FrameCapClick2
    integer FrameCap_Time = 0
    integer array PlayerScoreVote
    integer array PlayerScoreOwn
    integer TimeToPickCaptain = 10
    integer TimeToPickPlayer = 10
    integer TimeToPrepareHeroPick = 3
    timer FrameCapTimer = CreateTimer()
    timer FrameCapTimer2 = CreateTimer()
    boolean PlayerPickUICreated = false
    framehandle Frame_Cap1_MAIN
    framehandle Frame_Cap1_1
    framehandle Frame_Cap1_2
    framehandle array Frame_Cap1_3
    framehandle array Frame_Cap1_4
    framehandle array Frame_Cap1_5
    framehandle Frame_Cap1_6
    framehandle array Frame_Cap1_7
    framehandle Frame_Cap1_8
    framehandle array Frame_Cap1_9
    framehandle Frame_Cap1_10
    framehandle Frame_Cap1_11
    framehandle Frame_Cap1_12
    framehandle Frame_Cap1_13
    framehandle Frame_Cap1_14
    framehandle Frame_Cap1_15
    framehandle Frame_Cap1_16
    framehandle Frame_Cap2_MAIN
    framehandle Frame_Cap2_1
    framehandle Frame_Cap2_2
    framehandle array Frame_Cap2_3
    framehandle array Frame_Cap2_4
    framehandle array Frame_Cap2_5
    framehandle Frame_Cap2_6
    framehandle array Frame_Cap2_7
    framehandle Frame_Cap2_8
    framehandle array Frame_Cap2_9
    framehandle Frame_Cap2_10
    framehandle Frame_Cap2_11
    framehandle Frame_Cap2_12
    framehandle Frame_Cap2_13
    framehandle Frame_Cap2_14
    framehandle Frame_Cap2_15
    framehandle Frame_Cap2_16
    integer array PlayerVisualSlot
endglobals

function IsCaptainModeEligiblePlayer takes integer pid returns boolean
    return pid >= 0 and pid < 10 and GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(pid)) == MAP_CONTROL_USER
endfunction

// Капитаном может быть только активный пользователь, но в распределении команд
// участвуют все десять игровых слотов. Пустой слот или компьютер считается
// обычным вариантом выбора и позволяет капитану пропустить место в составе.
function IsCaptainModeDraftSlot takes integer pid returns boolean
    return pid >= 0 and pid < 10 and pid != CaptainPid1 and pid != CaptainPid2
endfunction

function SetPlayerVisualPosition takes integer pid, integer visualSlot returns nothing
    set PlayerVisualSlot[pid] = visualSlot
    call SetPlayerColor(Player(pid), ConvertPlayerColor(visualSlot))
endfunction

function MarkStatusPlayerLeft takes integer leavingPid returns nothing
    if FRAME_StatusHero[leavingPid] == null then
        return
    endif

    call BlzFrameSetEnable(FRAME_StatusHero[leavingPid], false)
    call BlzFrameSetText(FRAME_StatusHeroStringPlayerName[leavingPid], SplitName(FramePlayerFirstNameBase[leavingPid]))

    if Leave[leavingPid] == 2 then
        call BlzFrameSetTexture(FRAME_StatusHeroBack[leavingPid], "ReplaceableTextures\\CommandButtons\\BTNleave1.blp", 0, false)
    else
        call BlzFrameSetTexture(FRAME_StatusHeroBack[leavingPid], "ReplaceableTextures\\CommandButtons\\BTNleave2.blp", 0, false)
    endif
endfunction

function RearrangeTeamUI takes nothing returns nothing
    local integer i = 0
    local integer pid = 0
    local integer slot = 0
    // Те же шаг и крайние позиции, что у обычной компактной панели heroicon.
    local real r = 0.030
    local real xBase1 = -0.188
    // При slot = 5 первая иконка правой команды получает X = 0.068.
    local real xBase2 = -0.082
    local real y = 0.0
    local real xpos = 0.0
    local real rkek3 = 1.0 // Р РЋРІР‚С™Р В Р’В°Р В РЎвЂќР В РЎвЂўР В Р’Вµ Р В Р’В¶Р В Р’Вµ Р В Р’В·Р В Р вЂ¦Р В Р’В°Р РЋРІР‚РЋР В Р’ВµР В Р вЂ¦Р В РЎвЂР В Р’Вµ Р В РЎвЂќР В Р’В°Р В РЎвЂќ Р В Р вЂ  CreateStatusHeroUI

    // === Team 1 Р Р†РІР‚В РІР‚в„ў Р В Р’В»Р В Р’ВµР В Р вЂ Р В Р’В°Р РЋР РЏ Р РЋР С“Р РЋРІР‚С™Р В РЎвЂўР РЋР вЂљР В РЎвЂўР В Р вЂ¦Р В Р’В°, Р РЋР С“Р В Р’В»Р В РЎвЂўР РЋРІР‚С™Р РЋРІР‚в„– 0..4 ===
    set i = 0
    loop
        exitwhen i >= FullTeam1Size
        set pid = FullTeam1[i]
        set slot = i
        call SetPlayerVisualPosition(pid, slot)
        call SaveSystem_SetMatchTeamSlot(pid, 1, i + 1, slot)
        set xpos = xBase1 + r * slot

        call BlzFrameClearAllPoints(FRAME_StatusHero[pid])
        call BlzFrameSetPoint(FRAME_StatusHero[pid], FRAMEPOINT_CENTER, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y)

        call BlzFrameClearAllPoints(FRAME_StatusHeroBack2[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroBack2[pid], FRAMEPOINT_CENTER, FRAME_StatusHero[pid], FRAMEPOINT_CENTER, 0.000, 0.019)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerName[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerName[pid], FRAMEPOINT_CENTER, FRAME_StatusHero[pid], FRAMEPOINT_BOTTOM, 0.000, -0.006)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerKill[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerKill[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.045 * rkek3)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerDeath[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDeath[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.055 * rkek3)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerDamagePhys[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamagePhys[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.065 * rkek3)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerDamageMag[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamageMag[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.075 * rkek3)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerHeal[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerHeal[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.085 * rkek3)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerDamageTakenPhys[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamageTakenPhys[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.095 * rkek3)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerDamageTakenMag[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamageTakenMag[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.105 * rkek3)

        set i = i + 1
    endloop

    // === Team 2 Р Р†РІР‚В РІР‚в„ў Р В РЎвЂ”Р РЋР вЂљР В Р’В°Р В Р вЂ Р В Р’В°Р РЋР РЏ Р РЋР С“Р РЋРІР‚С™Р В РЎвЂўР РЋР вЂљР В РЎвЂўР В Р вЂ¦Р В Р’В°, Р РЋР С“Р В Р’В»Р В РЎвЂўР РЋРІР‚С™Р РЋРІР‚в„– 5..9 ===
    set i = 0
    loop
        exitwhen i >= FullTeam2Size
        set pid = FullTeam2[i]
        set slot = 5 + i
        call SetPlayerVisualPosition(pid, slot)
        call SaveSystem_SetMatchTeamSlot(pid, 2, i + 1, slot)
        set xpos = xBase2 + r * slot

        call BlzFrameClearAllPoints(FRAME_StatusHero[pid])
        call BlzFrameSetPoint(FRAME_StatusHero[pid], FRAMEPOINT_CENTER, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y)

        call BlzFrameClearAllPoints(FRAME_StatusHeroBack2[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroBack2[pid], FRAMEPOINT_CENTER, FRAME_StatusHero[pid], FRAMEPOINT_CENTER, 0.000, 0.019)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerName[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerName[pid], FRAMEPOINT_CENTER, FRAME_StatusHero[pid], FRAMEPOINT_BOTTOM, 0.000, -0.006)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerKill[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerKill[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.045 * rkek3)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerDeath[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDeath[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.055 * rkek3)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerDamagePhys[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamagePhys[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.065 * rkek3)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerDamageMag[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamageMag[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.075 * rkek3)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerHeal[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerHeal[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.085 * rkek3)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerDamageTakenPhys[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamageTakenPhys[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.095 * rkek3)

        call BlzFrameClearAllPoints(FRAME_StatusHeroStringPlayerDamageTakenMag[pid])
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamageTakenMag[pid], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, xpos, y - 0.105 * rkek3)

        set i = i + 1
    endloop
endfunction

function SetTeamAlliances takes nothing returns nothing
    local integer i = 0
    local integer j = 0
        call MakeSound("Pick\\PickEnd")
    // Р В Р Р‹Р В Р вЂ¦Р В Р’В°Р РЋРІР‚РЋР В Р’В°Р В Р’В»Р В Р’В° Р РЋР С“Р В Р вЂ¦Р В РЎвЂР В РЎВР В Р’В°Р В Р’ВµР В РЎВ Р В Р вЂ Р РЋР С“Р В Р’Вµ Р РЋР С“Р В РЎвЂўР РЋР вЂ№Р В Р’В·Р РЋРІР‚в„– Р В РЎВР В Р’ВµР В Р’В¶Р В РўвЂР РЋРЎвЂњ Р В Р вЂ Р РЋР С“Р В Р’ВµР В РЎВР В РЎвЂ Р В РЎвЂР В РЎвЂ“Р РЋР вЂљР В РЎвЂўР В РЎвЂќР В Р’В°Р В РЎВР В РЎвЂ
    set i = 0
    loop
        exitwhen i == 10
        if CaptainMode == true then 
    call PauseUnit(Hero[i],false)
    endif
        set j = 0
        loop
            exitwhen j == 10
            if j != i then
                call SetPlayerAllianceStateBJ(Player(i), Player(j), bj_ALLIANCE_UNALLIED)
            endif
            set j = j + 1
        endloop
        set i = i + 1
    endloop

    // Р В Р Р‹Р РЋРІР‚С™Р РЋР вЂљР В РЎвЂўР В РЎвЂР В РЎВ Р В РЎвЂ”Р В РЎвЂўР В Р’В»Р В Р вЂ¦Р РЋРІР‚в„–Р В Р’Вµ Р РЋР С“Р В РЎвЂўР РЋР С“Р РЋРІР‚С™Р В Р’В°Р В Р вЂ Р РЋРІР‚в„– Р В РЎвЂќР В РЎвЂўР В РЎВР В Р’В°Р В Р вЂ¦Р В РўвЂ Р В Р вЂ Р В РЎвЂќР В Р’В»Р РЋР вЂ№Р РЋРІР‚РЋР В Р’В°Р РЋР РЏ Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В РЎвЂўР В Р вЂ 
    set FullTeam1[0] = CaptainPid1
    set FullTeam1Size = 1
    set i = 0
    loop
        exitwhen i >= Team1Count
        set FullTeam1[FullTeam1Size] = Team1Pick[i]
        set FullTeam1Size = FullTeam1Size + 1
        set i = i + 1
    endloop
    set FullTeam2[0] = CaptainPid2
    set FullTeam2Size = 1
    set i = 0
    loop
        exitwhen i >= Team2Count
        set FullTeam2[FullTeam2Size] = Team2Pick[i]
        set FullTeam2Size = FullTeam2Size + 1
        set i = i + 1
    endloop

    // Player-pick teams replace the original lobby layout for match export.
    // RearrangeTeamUI writes every final team slot immediately afterwards.
    call SaveSystem_BeginReorganizedTeams()

    // Р В Р Р‹Р В РЎвЂўР РЋР вЂ№Р В Р’В·Р РЋРІР‚в„– Р В Р вЂ Р В Р вЂ¦Р РЋРЎвЂњР РЋРІР‚С™Р РЋР вЂљР В РЎвЂ Р В РЎвЂќР В РЎвЂўР В РЎВР В Р’В°Р В Р вЂ¦Р В РўвЂР РЋРІР‚в„– 1 Р Р†Р вЂљРІР‚Сњ Р В РЎвЂ”Р В РЎвЂўР В Р’В»Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ NР вЂњРІР‚вЂќN Р В Р вЂ  Р В РЎвЂўР В Р’В±Р В Р’Вµ Р РЋР С“Р РЋРІР‚С™Р В РЎвЂўР РЋР вЂљР В РЎвЂўР В Р вЂ¦Р РЋРІР‚в„–
    set i = 0
    loop
        exitwhen i >= FullTeam1Size
        set j = 0
        loop
            exitwhen j >= FullTeam1Size
            if i != j then
                call SetPlayerAllianceStateBJ(Player(FullTeam1[i]), Player(FullTeam1[j]), bj_ALLIANCE_ALLIED_VISION)
            endif
            set j = j + 1
        endloop
        set i = i + 1
    endloop

    // Р В Р Р‹Р В РЎвЂўР РЋР вЂ№Р В Р’В·Р РЋРІР‚в„– Р В Р вЂ Р В Р вЂ¦Р РЋРЎвЂњР РЋРІР‚С™Р РЋР вЂљР В РЎвЂ Р В РЎвЂќР В РЎвЂўР В РЎВР В Р’В°Р В Р вЂ¦Р В РўвЂР РЋРІР‚в„– 2 Р Р†Р вЂљРІР‚Сњ Р В РЎвЂ”Р В РЎвЂўР В Р’В»Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ NР вЂњРІР‚вЂќN Р В Р вЂ  Р В РЎвЂўР В Р’В±Р В Р’Вµ Р РЋР С“Р РЋРІР‚С™Р В РЎвЂўР РЋР вЂљР В РЎвЂўР В Р вЂ¦Р РЋРІР‚в„–
    set i = 0
    loop
        exitwhen i >= FullTeam2Size
        set j = 0
        loop
            exitwhen j >= FullTeam2Size
            if i != j then
                call SetPlayerAllianceStateBJ(Player(FullTeam2[i]), Player(FullTeam2[j]), bj_ALLIANCE_ALLIED_VISION)
            endif
            set j = j + 1
        endloop
        set i = i + 1
    endloop

    call BlzFrameSetVisible(Frame_Cap2_MAIN, false)
    set CapPickPhase = 4
    call RearrangeTeamUI() // Р Р†РІР‚В РЎвЂ™ Р В РўвЂР В РЎвЂўР В Р’В±Р В Р’В°Р В Р вЂ Р В РЎвЂР РЋРІР‚С™Р РЋР Р‰ Р РЋР С“Р РЋР вЂ№Р В РўвЂР В Р’В°
    set i = 0
    loop
        exitwhen i == 10
        call BlzFrameSetVisible(FRAME_StatusHero[i], true)
        set i = i + 1
    endloop
endfunction

function GetCurrentCaptainPid takes nothing returns integer
    if CurrentPickTurn < 0 or CurrentPickTurn >= 8 then
        return -1
    endif
    if PickOrderCap[CurrentPickTurn] == 0 then
        return CaptainPid1
    endif
    return CaptainPid2
endfunction

function UpdatePickText takes nothing returns nothing
    if PickOrderCap[CurrentPickTurn] == 0 then
        call BlzFrameSetVisible(Frame_Cap2_9[11], true)
        call BlzFrameSetVisible(Frame_Cap2_9[12], false)
        call BlzFrameSetText(Frame_Cap2_6, "|c00FFFF00Captain1 pick: " + I2S(TimeToPickPlayer - FrameCap_Time) + "|r")
    else
        call BlzFrameSetVisible(Frame_Cap2_9[11], false)
        call BlzFrameSetVisible(Frame_Cap2_9[12], true)
        call BlzFrameSetText(Frame_Cap2_6, "|c00FFFF00Captain2 pick: " + I2S(TimeToPickPlayer - FrameCap_Time) + "|r")
    endif
endfunction

function AddPlayerToTeam takes integer playerIdx returns nothing
    local integer slotIdx = 0
    if not IsCaptainModeDraftSlot(playerIdx) or PlayerPicked[playerIdx] or CurrentPickTurn < 0 or CurrentPickTurn >= 8 then
        return
    endif
    // Р В Р Р‹Р В РЎвЂќР РЋР вЂљР РЋРІР‚в„–Р В Р вЂ Р В Р’В°Р В Р’ВµР В РЎВ Р В РЎвЂќР В Р вЂ¦Р В РЎвЂўР В РЎвЂ”Р В РЎвЂќР РЋРЎвЂњ Р В РЎвЂР В РЎвЂ“Р РЋР вЂљР В РЎвЂўР В РЎвЂќР В Р’В° Р В РЎвЂР В Р’В· Р В РЎвЂ”Р РЋРЎвЂњР В Р’В»Р В Р’В° Р В Р вЂ Р РЋРІР‚в„–Р В Р’В±Р В РЎвЂўР РЋР вЂљР В Р’В°
    call BlzFrameSetVisible(Frame_Cap2_3[playerIdx], false)
    call BlzFrameSetVisible(Frame_Cap2_4[playerIdx], false)
    call BlzFrameSetVisible(Frame_Cap2_5[playerIdx], false)
    //call BlzFrameSetVisible(Frame_Cap2_9[playerIdx], false)
    call BlzFrameSetVisible(Frame_Cap2_7[playerIdx], false)
    // Р В РІР‚ВР В Р’В»Р В РЎвЂўР В РЎвЂќР В РЎвЂР РЋР вЂљР РЋРЎвЂњР В Р’ВµР В РЎВ Р РЋР вЂљР В Р’ВµР В РЎвЂ”Р В РЎвЂР В РЎвЂќ Р В РЎвЂР В РЎвЂ“Р РЋР вЂљР В РЎвЂўР В РЎвЂќР РЋРЎвЂњ Р В РЎвЂ”Р В РЎвЂўР РЋР С“Р В Р’В»Р В Р’Вµ Р В Р вЂ Р РЋРІР‚в„–Р В Р’В±Р В РЎвЂўР РЋР вЂљР В Р’В° Р В Р’ВµР В РЎвЂ“Р В РЎвЂў Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В РЎвЂўР В РЎВ
    call BlzFrameSetEnable(FRAME_Repick[playerIdx], false)
    call BlzFrameSetVisible(FRAME_Repick[playerIdx], false)
    set PlayerPicked[playerIdx] = true

    // Р В РІР‚СњР В РЎвЂўР В Р’В±Р В Р’В°Р В Р вЂ Р В Р’В»Р РЋР РЏР В Р’ВµР В РЎВ Р В Р вЂ  Р В РЎвЂќР В РЎвЂўР В РЎВР В Р’В°Р В Р вЂ¦Р В РўвЂР РЋРЎвЂњ Р В РЎвЂ Р В РЎвЂ”Р В РЎвЂўР В РЎвЂќР В Р’В°Р В Р’В·Р РЋРІР‚в„–Р В Р вЂ Р В Р’В°Р В Р’ВµР В РЎВ Р В Р вЂ¦Р В РЎвЂР В РЎвЂќ Р В Р вЂ  Р РЋР С“Р В Р’В»Р В РЎвЂўР РЋРІР‚С™Р В Р’Вµ
    if PickOrderCap[CurrentPickTurn] == 0 then
        set slotIdx = 20 + Team1Count
        set Team1Pick[Team1Count] = playerIdx
        set Team1Count = Team1Count + 1
    else
        set slotIdx = 24 + Team2Count
        set Team2Pick[Team2Count] = playerIdx
        set Team2Count = Team2Count + 1
    endif
    call BlzFrameSetText(Frame_Cap2_5[slotIdx], SplitName(GetPlayerName(Player(playerIdx))))
    call BlzFrameSetTexture(Frame_Cap2_4[slotIdx], BlzGetAbilityIcon(GetUnitTypeId(Hero[playerIdx])), 0, false)
endfunction

function RandomPickRemaining takes nothing returns nothing
    local integer i = 0
    local integer availCount = 0
    local integer roll = 0
    local integer needed = PicksPerTurn[CurrentPickTurn] - PicksDoneThisTurn
    loop
        exitwhen needed <= 0
        set availCount = 0
        set i = 0
        loop
            exitwhen i == 10
            // Р В Р вЂЎР В Р вЂ Р В Р вЂ¦Р В РЎвЂў Р В РЎвЂР РЋР С“Р В РЎвЂќР В Р’В»Р РЋР вЂ№Р РЋРІР‚РЋР В Р’В°Р В Р’ВµР В РЎВ Р В РЎвЂўР В Р’В±Р В РЎвЂўР В РЎвЂР РЋРІР‚В¦ Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В РЎвЂўР В Р вЂ , Р В РўвЂР В Р’В°Р В Р’В¶Р В Р’Вµ Р В Р’ВµР РЋР С“Р В Р’В»Р В РЎвЂ PlayerPicked Р В Р вЂ¦Р В Р’Вµ Р В РЎвЂ”Р РЋР вЂљР В РЎвЂўР РЋР С“Р РЋРІР‚С™Р В Р’В°Р В Р вЂ Р В Р’В»Р В Р’ВµР В Р вЂ¦
            if IsCaptainModeDraftSlot(i) and (not PlayerPicked[i]) then
                set DetCapWinners[availCount] = i
                set availCount = availCount + 1
            endif
            set i = i + 1
        endloop
        // Р В РІР‚СћР РЋР С“Р В Р’В»Р В РЎвЂ Р В РўвЂР В РЎвЂўР РЋР С“Р РЋРІР‚С™Р РЋРЎвЂњР В РЎвЂ”Р В Р вЂ¦Р РЋРІР‚в„–Р РЋРІР‚В¦ Р В Р вЂ¦Р В Р’ВµР РЋРІР‚С™ Р Р†Р вЂљРІР‚Сњ Р В Р вЂ Р РЋРІР‚в„–Р РЋРІР‚В¦Р В РЎвЂўР В РўвЂР В РЎвЂР В РЎВ, Р РЋРІР‚РЋР РЋРІР‚С™Р В РЎвЂўР В Р’В±Р РЋРІР‚в„– Р В Р вЂ¦Р В Р’Вµ Р В РЎвЂќР РЋР вЂљР В Р’В°Р РЋРІвЂљВ¬Р В Р вЂ¦Р РЋРЎвЂњР РЋРІР‚С™Р РЋР Р‰Р РЋР С“Р РЋР РЏ
        exitwhen availCount == 0
        set roll = GetRandomInt(0, availCount - 1)
        call AddPlayerToTeam(DetCapWinners[roll])
        set PicksDoneThisTurn = PicksDoneThisTurn + 1
        set needed = needed - 1
    endloop
endfunction

function CapPickPlayerTime takes nothing returns nothing
    local timer t = GetExpiredTimer()
    set FrameCap_Time = FrameCap_Time + 1
    call UpdatePickText()
    if FrameCap_Time >= TimeToPickPlayer then
        call PauseTimer(t)
        call RandomPickRemaining()
        // === Р В РЎвЂР В Р вЂ¦Р В Р’В»Р В Р’В°Р В РІвЂћвЂ“Р В Р вЂ¦ NextPickTurn ===
        set CurrentPickTurn = CurrentPickTurn + 1
        set PicksDoneThisTurn = 0
        set FrameCap_Time = 0
        if CurrentPickTurn >= 8 then
            call BlzFrameSetText(Frame_Cap2_6, "|c00FFFF00Teams are ready!|r")
            call SetTeamAlliances()
        else
        
        call MakeSound("war3mapimported\\Hero_Kyoraku_T16_4")
            call UpdatePickText()
            call TimerStart(FrameCapTimer, 1, true, function CapPickPlayerTime)
        endif
        // ==========================
    endif
    set t = null
endfunction

function NextPickTurn takes nothing returns nothing
    set CurrentPickTurn = CurrentPickTurn + 1
    set PicksDoneThisTurn = 0
    set FrameCap_Time = 0
    call PauseTimer(FrameCapTimer)
    if CurrentPickTurn >= 8 then
        call BlzFrameSetText(Frame_Cap2_6, "|c00FFFF00Teams are ready!|r")
        // Р РЋРІР‚С™Р РЋРЎвЂњР РЋРІР‚С™ Р В Р вЂ Р РЋРІР‚в„–Р В Р’В·Р В РЎвЂўР В Р вЂ  Р В РўвЂР В Р’В°Р В Р’В»Р РЋР Р‰Р В Р вЂ¦Р В Р’ВµР В РІвЂћвЂ“Р РЋРІвЂљВ¬Р В Р’ВµР В РІвЂћвЂ“ Р В Р’В»Р В РЎвЂўР В РЎвЂ“Р В РЎвЂР В РЎвЂќР В РЎвЂ
        call SetTeamAlliances()
        return
    endif
        call MakeSound("war3mapimported\\Hero_Kyoraku_T16_4")
    call UpdatePickText()
    call TimerStart(FrameCapTimer, 1, true, function CapPickPlayerTime)
endfunction

function CapOnPlayerClick takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local integer i = 0
    local integer slotIdx = 0 // Р Р†РІР‚В РЎвЂ™ Р РЋР С“Р РЋР вЂ№Р В РўвЂР В Р’В°
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    if not IsCaptainModeEligiblePlayer(pid) or pid != GetCurrentCaptainPid() then
        set p = null
        set clicked = null
        return
    endif
    if GetLocalPlayer() == p then
        call BlzFrameSetEnable(clicked, false)
        call BlzFrameSetEnable(clicked, true)
    endif
    loop
        exitwhen i == 10
        if IsCaptainModeDraftSlot(i) then
            if Frame_Cap2_3[i] != null then
                if clicked == Frame_Cap2_3[i] and not PlayerPicked[i] then
                    if PickOrderCap[CurrentPickTurn] == 0 then
                        set slotIdx = 20 + Team1Count
                    else
                        set slotIdx = 24 + Team2Count
                    endif
                    call MakeSound("war3mapimported\\Hero_Rimuru_Death")
                    call AddPlayerToTeam(i)
                    call BlzFrameSetSpriteAnimate(Frame_Cap2_9[i], 1, 0)
                    call BlzFrameSetSpriteAnimate(Frame_Cap2_9[slotIdx], 1, 0)
                    set PicksDoneThisTurn = PicksDoneThisTurn + 1
                    if PicksDoneThisTurn >= PicksPerTurn[CurrentPickTurn] then
                        call NextPickTurn()
                    endif
                    set i = 10
                endif
            endif
        endif
        set i = i + 1
    endloop
    set p = null
    set clicked = null
endfunction

function PlayerUpdateIcon takes nothing returns nothing
    local integer i = 0
    local string icon = ""
    local integer teamIdx = 0
    local integer playerPid = -1

    // Р В РЎСџР РЋРЎвЂњР В Р’В» Р В Р вЂ Р РЋРІР‚в„–Р В Р’В±Р В РЎвЂўР РЋР вЂљР В Р’В° (0..9), Р В РЎвЂ”Р РЋР вЂљР В РЎвЂўР В РЎвЂ”Р РЋРЎвЂњР РЋР С“Р В РЎвЂќР В Р’В°Р В Р’ВµР В РЎВ Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В РЎвЂўР В Р вЂ 
    loop
        exitwhen i == 10
        if i != CaptainPid1 and i != CaptainPid2 then
            if Frame_Cap2_4[i] != null and Hero[i] != null then
                set icon = BlzGetAbilityIcon(GetUnitTypeId(Hero[i]))
                if icon != "" then
                    call BlzFrameSetTexture(Frame_Cap2_4[i], icon, 0, false)
                endif
            endif
        endif
        set i = i + 1
    endloop

    // Р В РЎв„ўР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦ 1
    if CaptainPid1 >= 0 and CaptainPid1 < 10 and Frame_Cap2_4[11] != null and Hero[CaptainPid1] != null then
        set icon = BlzGetAbilityIcon(GetUnitTypeId(Hero[CaptainPid1]))
        if icon != "" then
            call BlzFrameSetTexture(Frame_Cap2_4[11], icon, 0, false)
        endif
    endif

    // Р В РЎв„ўР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦ 2
    if CaptainPid2 >= 0 and CaptainPid2 < 10 and Frame_Cap2_4[12] != null and Hero[CaptainPid2] != null then
        set icon = BlzGetAbilityIcon(GetUnitTypeId(Hero[CaptainPid2]))
        if icon != "" then
            call BlzFrameSetTexture(Frame_Cap2_4[12], icon, 0, false)
        endif
    endif

    // Р В Р Р‹Р В Р’В»Р В РЎвЂўР РЋРІР‚С™Р РЋРІР‚в„– Р В РЎвЂќР В РЎвЂўР В РЎВР В Р’В°Р В Р вЂ¦Р В РўвЂ (20..27)
    set i = 20
    loop
        exitwhen i == 28
        if Frame_Cap2_4[i] != null then
            set playerPid = -1
            if i < 24 then
                set teamIdx = i - 20
                if teamIdx < Team1Count then
                    set playerPid = Team1Pick[teamIdx]
                endif
            else
                set teamIdx = i - 24
                if teamIdx < Team2Count then
                    set playerPid = Team2Pick[teamIdx]
                endif
            endif
            if playerPid >= 0 and Hero[playerPid] != null then
                set icon = BlzGetAbilityIcon(GetUnitTypeId(Hero[playerPid]))
                if icon != "" then
                    call BlzFrameSetTexture(Frame_Cap2_4[i], icon, 0, false)
                endif
            endif
        endif
        set i = i + 1
    endloop
endfunction

function CreatePlayerPickUI takes nothing returns nothing
    local integer i = 0
    local integer i2 = 0
    local integer k = 0
    local real x = 0.025
    local real y = -0.05
    local framehandle border
    if PlayerPickUICreated then
        return
    endif
    set PlayerPickUICreated = true
    call PauseTimer(FrameCapTimer)
    call PauseTimer(FrameCapTimer2)
    set FrameCap_Time = 0
    if GetRandomInt(0, 1) == 0 then
    // Р В РЎСџР В Р’ВµР РЋР вЂљР В Р вЂ Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р В Р вЂ¦Р В Р’В°Р РЋРІР‚РЋР В РЎвЂР В Р вЂ¦Р В Р’В°Р В Р’ВµР РЋРІР‚С™ Captain1
set PickOrderCap[0] = 0
set PickOrderCap[1] = 1
set PickOrderCap[2] = 1
set PickOrderCap[3] = 0
set PickOrderCap[4] = 0
set PickOrderCap[5] = 1
set PickOrderCap[6] = 1
set PickOrderCap[7] = 0

else
    // Р В РЎСџР В Р’ВµР РЋР вЂљР В Р вЂ Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р В Р вЂ¦Р В Р’В°Р РЋРІР‚РЋР В РЎвЂР В Р вЂ¦Р В Р’В°Р В Р’ВµР РЋРІР‚С™ Captain2
set PickOrderCap[0] = 1
set PickOrderCap[1] = 0
set PickOrderCap[2] = 0
set PickOrderCap[3] = 1
set PickOrderCap[4] = 1
set PickOrderCap[5] = 0
set PickOrderCap[6] = 0
set PickOrderCap[7] = 1
endif
set PicksPerTurn[0] = 1
set PicksPerTurn[1] = 1
set PicksPerTurn[2] = 1
set PicksPerTurn[3] = 1
set PicksPerTurn[4] = 1
set PicksPerTurn[5] = 1
set PicksPerTurn[6] = 1
set PicksPerTurn[7] = 1
    set CurrentPickTurn = 0
    set PicksDoneThisTurn = 0
    set Team1Count = 0
    set Team2Count = 0 
    // Р В Р Р‹Р В Р’В±Р РЋР вЂљР В Р’В°Р РЋР С“Р РЋРІР‚в„–Р В Р вЂ Р В Р’В°Р В Р’ВµР В РЎВ PlayerPicked, Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р РЋРІР‚в„– Р РЋРЎвЂњР В Р’В¶Р В Р’Вµ "Р В Р’В·Р В Р’В°Р В Р вЂ¦Р РЋР РЏР РЋРІР‚С™Р РЋРІР‚в„–"
    set k = 0
    loop
        exitwhen k == 10
        set PlayerPicked[k] = false
        set k = k + 1
    endloop
    if CaptainPid1 >= 0 and CaptainPid1 < 10 then
        set PlayerPicked[CaptainPid1] = true
    endif
    if CaptainPid2 >= 0 and CaptainPid2 < 10 then
        set PlayerPicked[CaptainPid2] = true
    endif
    set FrameCapClick2 = CreateTrigger()
    // === Р В РІР‚СљР В Р’В»Р В Р’В°Р В Р вЂ Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р В РЎвЂќР В РЎвЂўР В Р вЂ¦Р РЋРІР‚С™Р В Р’ВµР В РІвЂћвЂ“Р В Р вЂ¦Р В Р’ВµР РЋР вЂљ ===
    set Frame_Cap2_MAIN = BlzCreateFrame("EscMenuBackdrop", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
    call BlzFrameSetAbsPoint(Frame_Cap2_MAIN, FRAMEPOINT_CENTER, 0.40, 0.33)
    call BlzFrameSetSize(Frame_Cap2_MAIN, 0.45, 0.35)
  // set CaptainPid1 = 0 
  //  set CaptainPid2 = 7 
    if CaptainPid1 >= 0 and CaptainPid1 < 10 then
        set PlayerPicked[CaptainPid1] = true
    endif
    if CaptainPid2 >= 0 and CaptainPid2 < 10 then
        set PlayerPicked[CaptainPid2] = true
    endif
    set k = 0
    loop
        exitwhen k == 10
        set PlayerScoreVote[k] = -1
        set PlayerScoreOwn[k] = 0
        set k = k + 1
    endloop
    set y = 0.3
    set x = 0.03
    set i = 0
    set i2 = 0
    loop
        exitwhen i == 10
        // Р В РЎв„ўР В Р’В»Р В РЎвЂР В РЎвЂќР В Р’В°Р В Р’В±Р В Р’ВµР В Р’В»Р РЋР Р‰Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р РЋРІР‚С›Р РЋР вЂљР В Р’ВµР В РІвЂћвЂ“Р В РЎВ (Р В РЎвЂќР В Р вЂ¦Р В РЎвЂўР В РЎвЂ”Р В РЎвЂќР В Р’В°)  
        if i != CaptainPid1 and i != CaptainPid2 then
            set Frame_Cap2_3[i] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap2_MAIN, "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetSize(Frame_Cap2_3[i], 0.035, 0.035)
            call BlzTriggerRegisterFrameEvent(FrameCapClick2, Frame_Cap2_3[i], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetTexture(Frame_Cap2_3[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
            set Frame_Cap2_4[i] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[i], "", 0)
            call BlzFrameSetSize(Frame_Cap2_4[i], 0.035, 0.035)
            call BlzFrameSetAllPoints(Frame_Cap2_4[i], Frame_Cap2_3[i])
            // Декоративный слой не должен перехватывать мышь у кнопки.
            call BlzFrameSetEnable(Frame_Cap2_4[i], false)
            call BlzFrameSetTexture(Frame_Cap2_4[i], BlzGetAbilityIcon(GetUnitTypeId(Hero[i])), 0, false)
        //call BlzFrameSetLevel(Frame_Cap2_3[i], 3)
            set Frame_Cap2_9[i] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap2_MAIN, "WarCraftIIILogo", 0)
            call BlzFrameSetPoint(Frame_Cap2_9[i], FRAMEPOINT_CENTER, Frame_Cap2_3[i], FRAMEPOINT_CENTER, 0, 0)
            call BlzFrameSetSize(Frame_Cap2_9[i], 1., 1.)
            call BlzFrameSetScale(Frame_Cap2_9[i], 0.00003)
            call BlzFrameSetModel(Frame_Cap2_9[i], "war3mapImported\\wos_0713.mdl", 0)
            call BlzFrameSetEnable(Frame_Cap2_9[i], false)
            call BlzFrameSetVisible(Frame_Cap2_9[i], true)
      // set Frame_Cap2_7[i] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[i], "", 0)
      //  call BlzFrameSetSize(Frame_Cap2_7[i], 0.025, 0.025)
      // call BlzFrameSetPoint(Frame_Cap2_7[i],FRAMEPOINT_CENTER,Frame_Cap2_3[i],FRAMEPOINT_CENTER,0,0)
      //  call BlzFrameSetTexture(Frame_Cap2_7[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Stack0", 0, false)
      //  call BlzFrameSetTexture(FRAME_StatusHeroBack2[i], BlzGetAbilityIcon(GetUnitTypeId(Hero[i]), 0, false)
       // call BlzFrameSetLevel(Frame_Cap2_7[i], 3)
       // call BlzFrameSetLevel(Frame_Cap2_4[i], 2)
            call BlzFrameSetPoint(Frame_Cap2_3[i], FRAMEPOINT_LEFT, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, x, y )// - 0.03 * i)
            set Frame_Cap2_5[i] = BlzCreateFrameByType("TEXT", "MyIconTextAbi", Frame_Cap2_3[i], "", 0)
            if i >= 5 then
                if SplitNameCheck(GetPlayerName(Player(i))) then
                    call BlzFrameSetPoint(Frame_Cap2_5[i], FRAMEPOINT_BOTTOM, Frame_Cap2_3[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( 0.059 + 0.05 * I2R(i2) ), (y - 0.0575 ) - 0.025 - 0.02 - 0.1625 )// - 0.03 * i)
                else
                    call BlzFrameSetPoint(Frame_Cap2_5[i], FRAMEPOINT_BOTTOM, Frame_Cap2_3[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( 0.059 + 0.05 * I2R(i2) ), (y - 0.0575 ) - 0.025 - 0.02 - 0.1525 )// - 0.03 * i)
                endif
            else
                if SplitNameCheck(GetPlayerName(Player(i))) then
                    call BlzFrameSetPoint(Frame_Cap2_5[i], FRAMEPOINT_BOTTOM, Frame_Cap2_3[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( 0.059 + 0.05 * I2R(i2) ), (y - 0.0575 ) - 0.025 - 0.095 - 0.1425 )// - 0.03 * i)
                else
                    call BlzFrameSetPoint(Frame_Cap2_5[i], FRAMEPOINT_BOTTOM, Frame_Cap2_3[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( 0.059 + 0.05 * I2R(i2) ), (y - 0.0575 ) - 0.025 - 0.095 - 0.1325 )// - 0.03 * i)
                endif
            endif
            call BlzFrameSetTextAlignment(Frame_Cap2_5[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
            call BlzFrameSetSize(Frame_Cap2_5[i], 0.0, 0.0)
            call BlzFrameSetText(Frame_Cap2_5[i], SplitName(GetPlayerName(Player(i))))
        endif
        set i = i + 1
        set i2 = i2 + 1
        set x = x + 0.05
        if i == 5 then
            set y = 0.24
            set x = 0.03
            set i2 = 0
        endif
    endloop
    set y = 0.09
    set x = -0.24
    set Frame_Cap2_3[11] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap2_MAIN, "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetSize(Frame_Cap2_3[11], 0.035, 0.035)
    call BlzFrameSetEnable(Frame_Cap2_3[11], false)
    call BlzFrameSetPoint(Frame_Cap2_3[11], FRAMEPOINT_LEFT, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.3 + x, 0.05 + y )// - 0.03 * i)
    call BlzFrameSetTexture(Frame_Cap2_3[11], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
    set Frame_Cap2_4[11] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[11], "", 0)
    call BlzFrameSetSize(Frame_Cap2_4[11], 0.035, 0.035)
    call BlzFrameSetAllPoints(Frame_Cap2_4[11], Frame_Cap2_3[11])
    call BlzFrameSetEnable(Frame_Cap2_4[11], false)
    if CaptainPid1 >= 0 and CaptainPid1 < 10 and Hero[CaptainPid1] != null then
        call BlzFrameSetTexture(Frame_Cap2_4[11], BlzGetAbilityIcon(GetUnitTypeId(Hero[CaptainPid1])), 0, false)
    else
        call BlzFrameSetTexture(Frame_Cap2_4[11], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
    endif
        //call BlzFrameSetLevel(Frame_Cap2_3[i], 3)
    set Frame_Cap2_9[11] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap2_MAIN, "WarCraftIIILogo", 0)
    call BlzFrameSetPoint(Frame_Cap2_9[11], FRAMEPOINT_LEFT, Frame_Cap2_3[11], FRAMEPOINT_LEFT, -0.0012, 0.48 )
    call BlzFrameSetSize(Frame_Cap2_9[11], 1., 1.)
    call BlzFrameSetScale(Frame_Cap2_9[11], 1)
    call BlzFrameSetModel(Frame_Cap2_9[11], "Pick\\wos_IconShine1.mdx", 0)
    call BlzFrameSetEnable(Frame_Cap2_9[11], false)
    call BlzFrameSetVisible(Frame_Cap2_9[11], true)
    set Frame_Cap2_7[11] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[11], "", 0)
    call BlzFrameSetSize(Frame_Cap2_7[11], 0.025, 0.025)
    call BlzFrameSetEnable(Frame_Cap2_7[11], false)
    call BlzFrameSetVisible(Frame_Cap2_7[11], false)
    call BlzFrameSetPoint(Frame_Cap2_7[11], FRAMEPOINT_CENTER, Frame_Cap2_3[11], FRAMEPOINT_CENTER, 0, 0)
    call BlzFrameSetTexture(Frame_Cap2_7[11], "ReplaceableTextures\\CommandButtons\\BTNHero_Stack0", 0, false)
    set Frame_Cap2_10 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap2_MAIN, "", 0)
    call BlzFrameSetPoint(Frame_Cap2_10, FRAMEPOINT_BOTTOM, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.3525 + x + 0.045 - 0.035 - 0.0, 0.0625 + y - 0.035 )// - 0.03 * i)
    call BlzFrameSetText(Frame_Cap2_10, "|c00FFFF00Cap1|r")
    call BlzFrameSetSize(Frame_Cap2_10, 0.2, 0.005)
    call BlzFrameSetScale(Frame_Cap2_10, 1.2)
    set Frame_Cap2_13 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap2_MAIN, "", 0)
    call BlzFrameSetPoint(Frame_Cap2_13, FRAMEPOINT_BOTTOM, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.3425 + x, 0.015 + y )// - 0.03 * i)
    call BlzFrameSetText(Frame_Cap2_13, "")
    call BlzFrameSetSize(Frame_Cap2_13, 0.2, 0.1)
    call BlzFrameSetScale(Frame_Cap2_13, 1)
        
    set Frame_Cap2_3[12] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap2_MAIN, "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetSize(Frame_Cap2_3[12], 0.035, 0.035)
    call BlzFrameSetEnable(Frame_Cap2_3[12], false)
    call BlzFrameSetPoint(Frame_Cap2_3[12], FRAMEPOINT_LEFT, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.3 + x, 0.05 + y - 0.07 )// - 0.03 * i)
    call BlzFrameSetTexture(Frame_Cap2_3[12], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
    set Frame_Cap2_4[12] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[12], "", 0)
    call BlzFrameSetSize(Frame_Cap2_4[12], 0.035, 0.035)
    call BlzFrameSetAllPoints(Frame_Cap2_4[12], Frame_Cap2_3[12])
    call BlzFrameSetEnable(Frame_Cap2_4[12], false)
    if CaptainPid2 >= 0 and CaptainPid2 < 10 and Hero[CaptainPid2] != null then
        call BlzFrameSetTexture(Frame_Cap2_4[12], BlzGetAbilityIcon(GetUnitTypeId(Hero[CaptainPid2])), 0, false)
    else
        call BlzFrameSetTexture(Frame_Cap2_4[12], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
    endif
        //call BlzFrameSetLevel(Frame_Cap2_3[i], 3)
    set Frame_Cap2_9[12] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap2_MAIN, "WarCraftIIILogo", 0)
    call BlzFrameSetPoint(Frame_Cap2_9[12], FRAMEPOINT_LEFT, Frame_Cap2_3[12], FRAMEPOINT_LEFT, -0.0012, 0.48 )
    call BlzFrameSetSize(Frame_Cap2_9[12], 1., 1.)
    call BlzFrameSetScale(Frame_Cap2_9[12], 1)
    call BlzFrameSetModel(Frame_Cap2_9[12], "Pick\\wos_IconShine1.mdx", 0)
    call BlzFrameSetEnable(Frame_Cap2_9[12], false)
    call BlzFrameSetVisible(Frame_Cap2_9[12], false)
    set Frame_Cap2_7[12] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[12], "", 0)
    call BlzFrameSetSize(Frame_Cap2_7[12], 0.025, 0.025)
    call BlzFrameSetEnable(Frame_Cap2_7[12], false)
    call BlzFrameSetPoint(Frame_Cap2_7[12], FRAMEPOINT_CENTER, Frame_Cap2_3[12], FRAMEPOINT_CENTER, 0, 0)
    call BlzFrameSetTexture(Frame_Cap2_7[12], "ReplaceableTextures\\CommandButtons\\BTNHero_Stack0", 0, false)
    set Frame_Cap2_11 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap2_MAIN, "", 0)
    call BlzFrameSetPoint(Frame_Cap2_11, FRAMEPOINT_BOTTOM, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.3525 + x + 0.045 - 0.035 - 0.0, 0.0625 + y - 0.0925 )// - 0.03 * i)
    call BlzFrameSetText(Frame_Cap2_11, "|c00FFFF00Cap2|r")
    call BlzFrameSetSize(Frame_Cap2_11, 0.2, 0.005)
    call BlzFrameSetScale(Frame_Cap2_11, 1.2)
    call BlzFrameSetVisible(Frame_Cap2_7[12], false)
    set Frame_Cap2_14 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap2_MAIN, "", 0)
    call BlzFrameSetPoint(Frame_Cap2_14, FRAMEPOINT_BOTTOM, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.3425 + x, 0.01 + y - 0.07 )// - 0.03 * i)
    call BlzFrameSetText(Frame_Cap2_14, "")
    call BlzFrameSetSize(Frame_Cap2_14, 0.2, 0.1)
    call BlzFrameSetScale(Frame_Cap2_14, 1)
    if SplitNameCheck(GetPlayerName(Player(CaptainPid1))) then
        call BlzFrameSetPoint(Frame_Cap2_13, FRAMEPOINT_BOTTOM, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.155, 0.01 + 0.02 - 0.01 - 0.005)
    else
        call BlzFrameSetPoint(Frame_Cap2_13, FRAMEPOINT_BOTTOM, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.1575, 0.01 + 0.02 - 0.01 - 0.005)
    endif
    call BlzFrameSetText(Frame_Cap2_13, SplitName(GetPlayerName(Player(CaptainPid1))) )
        
    if SplitNameCheck(GetPlayerName(Player(CaptainPid2))) then
        call BlzFrameSetPoint(Frame_Cap2_14, FRAMEPOINT_BOTTOM, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.155, 0.01 + 0.02 - 0.085)
    else
        call BlzFrameSetPoint(Frame_Cap2_14, FRAMEPOINT_BOTTOM, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.155, 0.01 + 0.02 - 0.085)
    endif
    call BlzFrameSetText(Frame_Cap2_14, SplitName(GetPlayerName(Player(CaptainPid2))) )

    call BlzFrameSetVisible(Frame_Cap1_9[11], false)
    // Р В РІР‚ВР В Р’В»Р В РЎвЂўР В РЎвЂќР В РЎвЂР РЋР вЂљР РЋРЎвЂњР В Р’ВµР В РЎВ Р В РЎвЂќР В Р вЂ¦Р В РЎвЂўР В РЎвЂ”Р В РЎвЂќР РЋРЎвЂњ Р В Р вЂ Р РЋРІР‚в„–Р В Р’В±Р РЋР вЂљР В Р’В°Р В Р вЂ¦Р В Р вЂ¦Р В РЎвЂўР В РЎвЂ“Р В РЎвЂў Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В Р’В° 1
    call BlzFrameSetEnable(Frame_Cap1_3[11], false)
    call BlzFrameSetVisible(Frame_Cap1_3[11], false)
    call BlzFrameSetVisible(Frame_Cap1_4[11], false)
    call BlzFrameSetVisible(Frame_Cap1_5[11], false)
    call BlzFrameSetVisible(Frame_Cap1_7[11], false)
    call BlzFrameSetVisible(Frame_Cap1_9[12], true)
        
    set Frame_Cap2_6 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap2_MAIN, "", 0)
    call BlzFrameSetPoint(Frame_Cap2_6, FRAMEPOINT_BOTTOM, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.35 - 0.01, 0.07 + 0.13 + 0.06 - 0.015 )// - 0.03 * i)
    call BlzFrameSetText(Frame_Cap2_6, "|c00FFFF00Captain1 pick: " + I2S(TimeToPickPlayer) + "|r")
    call BlzFrameSetSize(Frame_Cap2_6, 0.2, 0.005)
    call BlzFrameSetScale(Frame_Cap2_6, 1.25)
    set Frame_Cap2_8 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap2_MAIN, "", 0)
    call BlzFrameSetPoint(Frame_Cap2_8, FRAMEPOINT_BOTTOM, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.36, 0.06 + 0.13 + 0.06 )// - 0.03 * i)
    call BlzFrameSetText(Frame_Cap2_8, "Click on button to vote|r")  
    call BlzFrameSetSize(Frame_Cap2_8, 0.2, 0.005)
    call BlzFrameSetScale(Frame_Cap2_8, 1.1)
    set y = 0.14
    set x = 0.11
    set i = 20
    set i2 = 0
    loop
        exitwhen i == 28
        // Р В РЎв„ўР В Р’В»Р В РЎвЂР В РЎвЂќР В Р’В°Р В Р’В±Р В Р’ВµР В Р’В»Р РЋР Р‰Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р РЋРІР‚С›Р РЋР вЂљР В Р’ВµР В РІвЂћвЂ“Р В РЎВ (Р В РЎвЂќР В Р вЂ¦Р В РЎвЂўР В РЎвЂ”Р В РЎвЂќР В Р’В°)  
        if i != CaptainPid1 and i != CaptainPid2 then
            set Frame_Cap2_3[i] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap2_MAIN, "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetSize(Frame_Cap2_3[i], 0.035, 0.035)
            // Слоты 20..27 только показывают уже выбранных игроков.
            call BlzFrameSetEnable(Frame_Cap2_3[i], false)
            call BlzTriggerRegisterFrameEvent(FrameCapClick2, Frame_Cap2_3[i], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetTexture(Frame_Cap2_3[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
            set Frame_Cap2_4[i] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[i], "", 0)
            call BlzFrameSetSize(Frame_Cap2_4[i], 0.035, 0.035)
            call BlzFrameSetAllPoints(Frame_Cap2_4[i], Frame_Cap2_3[i])
            call BlzFrameSetEnable(Frame_Cap2_4[i], false)
            call BlzFrameSetTexture(Frame_Cap2_4[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        //call BlzFrameSetLevel(Frame_Cap2_3[i], 3)
            set Frame_Cap2_9[i] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap2_MAIN, "WarCraftIIILogo", 0)
            call BlzFrameSetPoint(Frame_Cap2_9[i], FRAMEPOINT_CENTER, Frame_Cap2_3[i], FRAMEPOINT_CENTER, 0, 0)
            call BlzFrameSetSize(Frame_Cap2_9[i], 1., 1.)
            call BlzFrameSetScale(Frame_Cap2_9[i], 0.00003)
            call BlzFrameSetModel(Frame_Cap2_9[i], "war3mapImported\\wos_0713.mdl", 0)
            call BlzFrameSetEnable(Frame_Cap2_9[i], false)
            call BlzFrameSetVisible(Frame_Cap2_9[i], true)
       //set Frame_Cap2_7[i] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[i], "", 0)
       // call BlzFrameSetSize(Frame_Cap2_7[i], 0.025, 0.025)
       // call BlzFrameSetPoint(Frame_Cap2_7[i],FRAMEPOINT_CENTER,Frame_Cap2_3[i],FRAMEPOINT_CENTER,0,0)
       // call BlzFrameSetTexture(Frame_Cap2_7[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Stack0", 0, false)
       // call BlzFrameSetLevel(Frame_Cap2_7[i], 3)
       // call BlzFrameSetLevel(Frame_Cap2_4[i], 2)
            call BlzFrameSetPoint(Frame_Cap2_3[i], FRAMEPOINT_LEFT, Frame_Cap2_MAIN, FRAMEPOINT_BOTTOMLEFT, x, y )// - 0.03 * i)
            set Frame_Cap2_5[i] = BlzCreateFrameByType("TEXT", "MyIconTextAbi", Frame_Cap2_3[i], "", 0)
            // i здесь является индексом визуального слота 20..27, а не pid.
            // Нельзя вызывать Player(i): Player(24..27) выходит за пределы игроков.
            call BlzFrameSetPoint(Frame_Cap2_5[i], FRAMEPOINT_TOP, Frame_Cap2_3[i], FRAMEPOINT_BOTTOM, 0.000, -0.005)
        
            call BlzFrameSetTextAlignment(Frame_Cap2_5[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
            call BlzFrameSetSize(Frame_Cap2_5[i], 0.0, 0.0)
            call BlzFrameSetText(Frame_Cap2_5[i], "")
        //call BlzFrameSetText(Frame_Cap2_5[i], SplitName(GetPlayerName(Player(i-20))))
        endif
        set i = i + 1
        set i2 = i2 + 1
        set x = x + 0.05
        if i == 24 then
            set y = 0.07
            set x = 0.11
            set i2 = 0
        endif
    endloop

set CapPickPhase = 3

call BlzFrameSetVisible(FRAME_StatusHeroMain, true)

set i = 0
loop
    exitwhen i == 10

    if Hero[i] != null and Leave[i] == 0 then
        call BlzFrameSetVisible(FRAME_StatusHero[i], true)
        call BlzFrameSetEnable(FRAME_StatusHero[i], true)
    else
    endif

    set i = i + 1
endloop

call TriggerAddAction(FrameCapClick2, function CapOnPlayerClick)
    call TimerStart(FrameCapTimer, 1, true, function CapPickPlayerTime)
    call TimerStart(FrameCapTimer2, 0.1, true, function PlayerUpdateIcon)
    
endfunction

function SetVoteStackTexture takes framehandle frame, integer votes returns nothing
    if votes <= 0 then
        call BlzFrameSetTexture(frame, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack0", 0, false)
    elseif votes == 1 then
        call BlzFrameSetTexture(frame, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack1", 0, false)
    elseif votes == 2 then
        call BlzFrameSetTexture(frame, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack2", 0, false)
    elseif votes == 3 then
        call BlzFrameSetTexture(frame, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack3", 0, false)
    elseif votes == 4 then
        call BlzFrameSetTexture(frame, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack4", 0, false)
    elseif votes == 5 then
        call BlzFrameSetTexture(frame, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack5", 0, false)
    elseif votes == 6 then
        call BlzFrameSetTexture(frame, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack6", 0, false)
    elseif votes == 7 then
        call BlzFrameSetTexture(frame, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack7", 0, false)
    elseif votes == 8 then
        call BlzFrameSetTexture(frame, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack8", 0, false)
    elseif votes == 9 then
        call BlzFrameSetTexture(frame, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack9", 0, false)
    elseif votes == 10 then
        call BlzFrameSetTexture(frame, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack10", 0, false)
    endif
    call BlzFrameSetVisible(frame, true)
endfunction

function ResetCapVotes takes nothing returns nothing
    local integer k = 0
    loop
        exitwhen k == 10
        set PlayerScoreVote[k] = -1
        set PlayerScoreOwn[k] = 0
        call BlzFrameSetTexture(Frame_Cap1_7[k], "ReplaceableTextures\\CommandButtons\\BTNHero_Stack0", 0, false)
        set k = k + 1
    endloop
endfunction

function PrepareNormalPick takes nothing returns nothing
    local timer t = GetExpiredTimer()
    set FrameCap_Time = FrameCap_Time + 1
    call BlzFrameSetText(Frame_Cap1_6, "|c00FFFF00Prepare to Hero Pick: " + I2S(TimeToPrepareHeroPick - FrameCap_Time) + "|r")
    if FrameCap_Time == TimeToPrepareHeroPick then
        call PauseTimer(t)
        call BlzFrameSetEnable(Frame_Cap1_MAIN, false)
        call BlzFrameSetVisible(Frame_Cap1_MAIN, false)
        set CapPickPhase = 2
        call ExecuteFunc("CreateUI")
//call BlzFrameSetText(Frame_Cap1_6, "|c00FFFF00Time left|r")
    endif
    set t = null
endfunction

function DetermineCaptain2 takes nothing returns nothing
    local integer i = 0
    local integer maxScore = -1
    local integer winnersCount = 0
    local integer chosen = 0
    local integer roll = 0

    // 1) Р В РЎСљР В Р’В°Р РЋРІР‚В¦Р В РЎвЂўР В РўвЂР В РЎвЂР В РЎВ Р В РЎВР В Р’В°Р В РЎвЂќР РЋР С“Р В РЎвЂР В РЎВР РЋРЎвЂњР В РЎВ, Р В РЎвЂ”Р РЋР вЂљР В РЎвЂўР В РЎвЂ”Р РЋРЎвЂњР РЋР С“Р В РЎвЂќР В Р’В°Р РЋР РЏ Р РЋРЎвЂњР В Р’В¶Р В Р’Вµ Р В Р вЂ Р РЋРІР‚в„–Р В Р’В±Р РЋР вЂљР В Р’В°Р В Р вЂ¦Р В Р вЂ¦Р В РЎвЂўР В РЎвЂ“Р В РЎвЂў Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В Р’В° 1 (Р В Р’ВµР РЋР С“Р В Р’В»Р В РЎвЂ Р РЋРІР‚С›Р В Р’В°Р В Р’В·Р В Р’В° 2)
    loop
        exitwhen i == 10
        if IsCaptainModeEligiblePlayer(i) and ((CapPickPhase == 0) or (i != CaptainPid1)) then
            if PlayerScoreOwn[i] > maxScore then
                set maxScore = PlayerScoreOwn[i]
            endif
        endif
        set i = i + 1
    endloop

    // 2) Р В Р Р‹Р В РЎвЂўР В Р’В±Р В РЎвЂР РЋР вЂљР В Р’В°Р В Р’ВµР В РЎВ Р В Р вЂ Р РЋР С“Р В Р’ВµР РЋРІР‚В¦ Р В РЎвЂќР В Р’В°Р В Р вЂ¦Р В РўвЂР В РЎвЂР В РўвЂР В Р’В°Р РЋРІР‚С™Р В РЎвЂўР В Р вЂ  Р РЋР С“ Р РЋР РЉР РЋРІР‚С™Р В РЎвЂР В РЎВ Р В РЎВР В Р’В°Р В РЎвЂќР РЋР С“Р В РЎвЂР В РЎВР РЋРЎвЂњР В РЎВР В РЎвЂўР В РЎВ
    set i = 0
    set winnersCount = 0
    loop
        exitwhen i == 10
        if IsCaptainModeEligiblePlayer(i) and ((CapPickPhase == 0) or (i != CaptainPid1)) then
            if PlayerScoreOwn[i] == maxScore then
                set DetCapWinners[winnersCount] = i
                set winnersCount = winnersCount + 1
            endif
        endif
        set i = i + 1
    endloop

    // 3) Р В РІР‚СћР РЋР С“Р В Р’В»Р В РЎвЂ Р В Р вЂ¦Р В Р’ВµР РЋР С“Р В РЎвЂќР В РЎвЂўР В Р’В»Р РЋР Р‰Р В РЎвЂќР В РЎвЂў Р В Р’В»Р В РЎвЂР В РўвЂР В Р’ВµР РЋР вЂљР В РЎвЂўР В Р вЂ  (Р В РЎвЂР В Р’В»Р В РЎвЂ Р В Р вЂ¦Р В РЎвЂР В РЎвЂќР РЋРІР‚С™Р В РЎвЂў Р В Р вЂ¦Р В Р’Вµ Р В РЎвЂ“Р В РЎвЂўР В Р’В»Р В РЎвЂўР РЋР С“Р В РЎвЂўР В Р вЂ Р В Р’В°Р В Р’В») Р Р†Р вЂљРІР‚Сњ Р РЋР вЂљР В Р’В°Р В Р вЂ¦Р В РўвЂР В РЎвЂўР В РЎВР В РЎвЂР В РЎВ
    // Если второго реального игрока нет,
// выбираем случайный игровой слот 0..9 кроме Captain1.
if winnersCount <= 0 then
    set i = 0
    set winnersCount = 0

    loop
        exitwhen i == 10

        if i != CaptainPid1 then
            set DetCapWinners[winnersCount] = i
            set winnersCount = winnersCount + 1
        endif

        set i = i + 1
    endloop

    // Теоретически невозможно при 10 слотах,
    // но защита пусть будет.
    if winnersCount <= 0 then
        return
    endif

    set roll = GetRandomInt(0, winnersCount - 1)
    set chosen = DetCapWinners[roll]

elseif winnersCount > 1 then

    set roll = GetRandomInt(0, winnersCount - 1)
    set chosen = DetCapWinners[roll]

else

    set chosen = DetCapWinners[0]

endif
        // === Р В РІР‚вЂќР В Р’В°Р В Р вЂ Р В Р’ВµР РЋР вЂљР РЋРІвЂљВ¬Р В РЎвЂР В Р’В»Р В РЎвЂ Р В Р вЂ Р РЋРІР‚в„–Р В Р’В±Р В РЎвЂўР РЋР вЂљ Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В Р’В° 2 ===
    set CaptainPid2 = chosen
    if SplitNameCheck(GetPlayerName(Player(chosen))) then
        call BlzFrameSetPoint(Frame_Cap1_14, FRAMEPOINT_BOTTOM, Frame_Cap1_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.35 + 0.05, 0.01 + 0.02 - 0.01 - 0.08)
    else
        call BlzFrameSetPoint(Frame_Cap1_14, FRAMEPOINT_BOTTOM, Frame_Cap1_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.35 + 0.05, 0.01 + 0.02 - 0.095)
    endif    
    call MakeSound("war3mapimported\\Hero_Kyoraku_T16_1")
    call BlzFrameSetVisible(Frame_Cap1_9[12], false)
    call BlzFrameSetText(Frame_Cap1_14, SplitName(GetPlayerName(Player(chosen))) )
    call BlzFrameSetEnable(Frame_Cap1_3[chosen], false)
    call BlzFrameSetVisible(Frame_Cap1_3[chosen], false)
    call BlzFrameSetVisible(Frame_Cap1_4[chosen], false)
    call BlzFrameSetVisible(Frame_Cap1_5[chosen], false)
    call BlzFrameSetVisible(Frame_Cap1_7[chosen], false)
// Р В Р Р‹Р РЋРІР‚С™Р В Р’В°Р В Р вЂ Р В РЎвЂР В РЎВ Р В РЎвЂР В РЎвЂќР В РЎвЂўР В Р вЂ¦Р В РЎвЂќР В Р’Вµ Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В Р’В° 2 Р РЋРІР‚С™Р В Р’ВµР В РЎвЂќР РЋР С“Р РЋРІР‚С™Р РЋРЎвЂњР РЋР вЂљР РЋРЎвЂњ Р РЋР С“ Р В Р’ВµР В РЎвЂ“Р В РЎвЂў Р В РЎвЂР РЋРІР‚С™Р В РЎвЂўР В РЎвЂ“Р В РЎвЂўР В Р вЂ Р РЋРІР‚в„–Р В РЎВ Р РЋРІР‚РЋР В РЎвЂР РЋР С“Р В Р’В»Р В РЎвЂўР В РЎВ Р В РЎвЂ“Р В РЎвЂўР В Р’В»Р В РЎвЂўР РЋР С“Р В РЎвЂўР В Р вЂ 
    call SetVoteStackTexture(Frame_Cap1_7[12], PlayerScoreOwn[chosen])
    set FrameCap_Time = 0
    call BlzFrameSetText(Frame_Cap1_6, "|c00FFFF00Prepare to Hero Pick: " + I2S(TimeToPrepareHeroPick - FrameCap_Time) + "|r")
    call PauseTimer(FrameCapTimer)
    call TimerStart(FrameCapTimer, 1.00, true, function PrepareNormalPick)

endfunction

function CapPickTime2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    set FrameCap_Time = FrameCap_Time + 1
    if CapPickPhase == 0 then
        call BlzFrameSetText(Frame_Cap1_6, "|c00FFFF00Time to pick Captain1: " + I2S(TimeToPickCaptain - FrameCap_Time) + "|r")
    else
        call BlzFrameSetText(Frame_Cap1_6, "|c00FFFF00Time to pick Captain2: " + I2S(TimeToPickCaptain - FrameCap_Time) + "|r")
    endif
    if FrameCap_Time == TimeToPickCaptain then
        call PauseTimer(t)
        call DetermineCaptain2()
//call BlzFrameSetText(Frame_Cap1_6, "|c00FFFF00Time left|r")
    endif
    set t = null
endfunction

function DetermineCaptain takes nothing returns nothing
    local integer i = 0
    local integer maxScore = -1
    local integer winnersCount = 0
    local integer chosen = 0
    local integer roll = 0

    // 1) Р В РЎСљР В Р’В°Р РЋРІР‚В¦Р В РЎвЂўР В РўвЂР В РЎвЂР В РЎВ Р В РЎВР В Р’В°Р В РЎвЂќР РЋР С“Р В РЎвЂР В РЎВР РЋРЎвЂњР В РЎВ, Р В РЎвЂ”Р РЋР вЂљР В РЎвЂўР В РЎвЂ”Р РЋРЎвЂњР РЋР С“Р В РЎвЂќР В Р’В°Р РЋР РЏ Р РЋРЎвЂњР В Р’В¶Р В Р’Вµ Р В Р вЂ Р РЋРІР‚в„–Р В Р’В±Р РЋР вЂљР В Р’В°Р В Р вЂ¦Р В Р вЂ¦Р В РЎвЂўР В РЎвЂ“Р В РЎвЂў Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В Р’В° 1 (Р В Р’ВµР РЋР С“Р В Р’В»Р В РЎвЂ Р РЋРІР‚С›Р В Р’В°Р В Р’В·Р В Р’В° 2)
    loop
        exitwhen i == 10
        if IsCaptainModeEligiblePlayer(i) and ((CapPickPhase == 0) or (i != CaptainPid1)) then
            if PlayerScoreOwn[i] > maxScore then
                set maxScore = PlayerScoreOwn[i]
            endif
        endif
        set i = i + 1
    endloop

    // 2) Р В Р Р‹Р В РЎвЂўР В Р’В±Р В РЎвЂР РЋР вЂљР В Р’В°Р В Р’ВµР В РЎВ Р В Р вЂ Р РЋР С“Р В Р’ВµР РЋРІР‚В¦ Р В РЎвЂќР В Р’В°Р В Р вЂ¦Р В РўвЂР В РЎвЂР В РўвЂР В Р’В°Р РЋРІР‚С™Р В РЎвЂўР В Р вЂ  Р РЋР С“ Р РЋР РЉР РЋРІР‚С™Р В РЎвЂР В РЎВ Р В РЎВР В Р’В°Р В РЎвЂќР РЋР С“Р В РЎвЂР В РЎВР РЋРЎвЂњР В РЎВР В РЎвЂўР В РЎВ
    set i = 0
    set winnersCount = 0
    loop
        exitwhen i == 10
        if IsCaptainModeEligiblePlayer(i) and ((CapPickPhase == 0) or (i != CaptainPid1)) then
            if PlayerScoreOwn[i] == maxScore then
                set DetCapWinners[winnersCount] = i
                set winnersCount = winnersCount + 1
            endif
        endif
        set i = i + 1
    endloop

    // 3) Р В РІР‚СћР РЋР С“Р В Р’В»Р В РЎвЂ Р В Р вЂ¦Р В Р’ВµР РЋР С“Р В РЎвЂќР В РЎвЂўР В Р’В»Р РЋР Р‰Р В РЎвЂќР В РЎвЂў Р В Р’В»Р В РЎвЂР В РўвЂР В Р’ВµР РЋР вЂљР В РЎвЂўР В Р вЂ  (Р В РЎвЂР В Р’В»Р В РЎвЂ Р В Р вЂ¦Р В РЎвЂР В РЎвЂќР РЋРІР‚С™Р В РЎвЂў Р В Р вЂ¦Р В Р’Вµ Р В РЎвЂ“Р В РЎвЂўР В Р’В»Р В РЎвЂўР РЋР С“Р В РЎвЂўР В Р вЂ Р В Р’В°Р В Р’В») Р Р†Р вЂљРІР‚Сњ Р РЋР вЂљР В Р’В°Р В Р вЂ¦Р В РўвЂР В РЎвЂўР В РЎВР В РЎвЂР В РЎВ
    if winnersCount <= 0 then
        return
    elseif winnersCount > 1 then
        set roll = GetRandomInt(0, winnersCount - 1)
        set chosen = DetCapWinners[roll]
    else
        set chosen = DetCapWinners[0]
    endif

        // === Р В РІР‚вЂќР В Р’В°Р В Р вЂ Р В Р’ВµР РЋР вЂљР РЋРІвЂљВ¬Р В РЎвЂР В Р’В»Р В РЎвЂ Р В Р вЂ Р РЋРІР‚в„–Р В Р’В±Р В РЎвЂўР РЋР вЂљ Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В Р’В° 1 ===
    set CaptainPid1 = chosen
    if SplitNameCheck(GetPlayerName(Player(chosen))) then
        call BlzFrameSetPoint(Frame_Cap1_13, FRAMEPOINT_BOTTOM, Frame_Cap1_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.35, 0.01 + 0.02 - 0.01 - 0.08)
    else
        call BlzFrameSetPoint(Frame_Cap1_13, FRAMEPOINT_BOTTOM, Frame_Cap1_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.35, 0.01 + 0.02 - 0.095)
    endif
    call BlzFrameSetText(Frame_Cap1_13, SplitName(GetPlayerName(Player(chosen))) )

    // Р В Р Р‹Р РЋРІР‚С™Р В Р’В°Р В Р вЂ Р В РЎвЂР В РЎВ Р В РЎвЂР В РЎвЂќР В РЎвЂўР В Р вЂ¦Р В РЎвЂќР В Р’Вµ Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В Р’В° 1 Р РЋРІР‚С™Р В Р’ВµР В РЎвЂќР РЋР С“Р РЋРІР‚С™Р РЋРЎвЂњР РЋР вЂљР РЋРЎвЂњ Р РЋР С“ Р В Р’ВµР В РЎвЂ“Р В РЎвЂў Р В РЎвЂР РЋРІР‚С™Р В РЎвЂўР В РЎвЂ“Р В РЎвЂўР В Р вЂ Р РЋРІР‚в„–Р В РЎВ Р РЋРІР‚РЋР В РЎвЂР РЋР С“Р В Р’В»Р В РЎвЂўР В РЎВ Р В РЎвЂ“Р В РЎвЂўР В Р’В»Р В РЎвЂўР РЋР С“Р В РЎвЂўР В Р вЂ 
    call SetVoteStackTexture(Frame_Cap1_7[11], PlayerScoreOwn[chosen])

    call BlzFrameSetVisible(Frame_Cap1_9[11], false)
    // Р В РІР‚ВР В Р’В»Р В РЎвЂўР В РЎвЂќР В РЎвЂР РЋР вЂљР РЋРЎвЂњР В Р’ВµР В РЎВ Р В РЎвЂќР В Р вЂ¦Р В РЎвЂўР В РЎвЂ”Р В РЎвЂќР РЋРЎвЂњ Р В Р вЂ Р РЋРІР‚в„–Р В Р’В±Р РЋР вЂљР В Р’В°Р В Р вЂ¦Р В Р вЂ¦Р В РЎвЂўР В РЎвЂ“Р В РЎвЂў Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В Р’В° 1
    call BlzFrameSetEnable(Frame_Cap1_3[chosen], false)
    call BlzFrameSetVisible(Frame_Cap1_3[chosen], false)
    call BlzFrameSetVisible(Frame_Cap1_4[chosen], false)
    call BlzFrameSetVisible(Frame_Cap1_5[chosen], false)
    call BlzFrameSetVisible(Frame_Cap1_7[chosen], false)
    call ResetCapVotes()
    call BlzFrameSetVisible(Frame_Cap1_9[12], true)
    set CapPickPhase = 1
    set FrameCap_Time = 0
    call MakeSound("war3mapimported\\Hero_Kyoraku_T16_1")
    call BlzFrameSetText(Frame_Cap1_6, "|c00FFFF00Time to pick Captain2: " + I2S(TimeToPickCaptain) + "|r")
    call TimerStart(FrameCapTimer, 1, true, function CapPickTime2)
endfunction

function CapPickTime takes nothing returns nothing
    local timer t = GetExpiredTimer()
    set FrameCap_Time = FrameCap_Time + 1
    if CapPickPhase == 0 then
        call BlzFrameSetText(Frame_Cap1_6, "|c00FFFF00Time to pick Captain1: " + I2S(TimeToPickCaptain - FrameCap_Time) + "|r")
    else
        call BlzFrameSetText(Frame_Cap1_6, "|c00FFFF00Time to pick Captain2: " + I2S(TimeToPickCaptain - FrameCap_Time) + "|r")
    endif
    if FrameCap_Time == TimeToPickCaptain then
        call PauseTimer(t)
        call DetermineCaptain()
       // call BlzFrameSetVisible(Frame_Cap1_9[11], false) 
//call BlzFrameSetText(Frame_Cap1_6, "|c00FFFF00Time left|r")
    endif
    set t = null
endfunction

function CapOnClick takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local integer i = 0
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local integer oldVote = 0
    if not IsCaptainModeEligiblePlayer(pid) then
        set p = null
        set clicked = null
        return
    endif
    if GetLocalPlayer() == p then
        call BlzFrameSetEnable(clicked, false)
        call BlzFrameSetEnable(clicked, true)
    endif
    loop
        exitwhen i == 10
        if IsCaptainModeEligiblePlayer(i) and clicked == Frame_Cap1_3[i] then
            // Р В РІР‚вЂќР В Р’В°Р В РЎвЂ”Р РЋР вЂљР В Р’ВµР РЋРІР‚С™ Р В РЎвЂ“Р В РЎвЂўР В Р’В»Р В РЎвЂўР РЋР С“Р В РЎвЂўР В Р вЂ Р В Р’В°Р РЋРІР‚С™Р РЋР Р‰ Р В Р’В·Р В Р’В° Р РЋРЎвЂњР В Р’В¶Р В Р’Вµ Р В Р вЂ Р РЋРІР‚в„–Р В Р’В±Р РЋР вЂљР В Р’В°Р В Р вЂ¦Р В Р вЂ¦Р В РЎвЂўР В РЎвЂ“Р В РЎвЂў Р В РЎвЂќР В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В Р’В° 1 Р В Р вЂ Р В РЎвЂў Р В Р вЂ Р РЋРІР‚С™Р В РЎвЂўР РЋР вЂљР В РЎвЂўР В РІвЂћвЂ“ Р РЋРІР‚С›Р В Р’В°Р В Р’В·Р В Р’Вµ
            if (CapPickPhase == 1) and (i == CaptainPid1) then
                set i = 10 // Р В Р вЂ Р РЋРІР‚в„–Р РЋРІР‚В¦Р В РЎвЂўР В РўвЂР В РЎвЂР В РЎВ Р В РЎвЂР В Р’В· Р РЋРІР‚В Р В РЎвЂР В РЎвЂќР В Р’В»Р В Р’В°, Р В Р вЂ¦Р В РЎвЂР РЋРІР‚РЋР В Р’ВµР В РЎвЂ“Р В РЎвЂў Р В Р вЂ¦Р В Р’Вµ Р В РўвЂР В Р’ВµР В Р’В»Р В Р’В°Р В Р’ВµР В РЎВ
            elseif (PlayerScoreVote[pid] != i) then //and (pid != i) then
                call MakeSound("war3mapimported\\Hero_Rimuru_Death")
                if PlayerScoreVote[pid] != -1 then
                    set oldVote = PlayerScoreVote[pid]
                    set PlayerScoreOwn[oldVote] = PlayerScoreOwn[oldVote] - 1
                    call SetVoteStackTexture(Frame_Cap1_7[oldVote], PlayerScoreOwn[oldVote])
                endif

                set PlayerScoreVote[pid] = i
                set PlayerScoreOwn[i] = PlayerScoreOwn[i] + 1
                
                call SetVoteStackTexture(Frame_Cap1_7[i], PlayerScoreOwn[i])

                call BlzFrameSetSpriteAnimate(Frame_Cap1_9[i], 1, 0)
            endif
        endif
        set i = i + 1
    endloop
    set p = null
    set clicked = null
endfunction

function CreateCaptainUI takes nothing returns nothing
    local integer i = 0
    local integer i2 = 0
    local integer k = 0
    local real x = 0.025
    local real y = -0.05
    local framehandle border
    set FrameCapClick = CreateTrigger()
    // === Р В РІР‚СљР В Р’В»Р В Р’В°Р В Р вЂ Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р В РЎвЂќР В РЎвЂўР В Р вЂ¦Р РЋРІР‚С™Р В Р’ВµР В РІвЂћвЂ“Р В Р вЂ¦Р В Р’ВµР РЋР вЂљ ===
    set Frame_Cap1_MAIN = BlzCreateFrame("EscMenuBackdrop", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
    call BlzFrameSetAbsPoint(Frame_Cap1_MAIN, FRAMEPOINT_CENTER, 0.40, 0.32)
    call BlzFrameSetSize(Frame_Cap1_MAIN, 0.45, 0.2)
    //set Frame_Cap1_1 = BlzCreateFrame("EscMenuBackdrop", Frame_Cap1_MAIN, 1, 0)
    //call BlzFrameSetAbsPoint(Frame_Cap1_1, FRAMEPOINT_CENTER, 0.35, 0.35)
    //call BlzFrameSetSize(Frame_Cap1_1, 0.25, 0.4)
    //set Frame_Cap1_2 = BlzCreateFrame("EscMenuBackdrop", Frame_Cap1_MAIN, 1, 0)
    //call BlzFrameSetAbsPoint(Frame_Cap1_2, FRAMEPOINT_CENTER, 0.625, 0.35)
    //call BlzFrameSetSize(Frame_Cap1_2, 0.3, 0.4)
    
       // call BlzTriggerRegisterFrameEvent(FrameClick, FRAME_ICON5[i], FRAMEEVENT_CONTROL_CLICK)
       // Hover Q..G использует только BlzFrameSetTooltip, без событий мыши.
    set k = 0
    loop
        exitwhen k == 10
        set PlayerScoreVote[k] = -1
        set PlayerScoreOwn[k] = 0
        set k = k + 1
    endloop
    set y = 0.15
    set x = 0.03
    set i = 0
    set i2 = 0
    loop
        exitwhen i == 10
        // Р В РЎв„ўР В Р’В»Р В РЎвЂР В РЎвЂќР В Р’В°Р В Р’В±Р В Р’ВµР В Р’В»Р РЋР Р‰Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р РЋРІР‚С›Р РЋР вЂљР В Р’ВµР В РІвЂћвЂ“Р В РЎВ (Р В РЎвЂќР В Р вЂ¦Р В РЎвЂўР В РЎвЂ”Р В РЎвЂќР В Р’В°)        
        set Frame_Cap1_3[i] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap1_MAIN, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize(Frame_Cap1_3[i], 0.035, 0.035)
        call BlzTriggerRegisterFrameEvent(FrameCapClick, Frame_Cap1_3[i], FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetTexture(Frame_Cap1_3[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
        set Frame_Cap1_4[i] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap1_3[i], "", 0)
        call BlzFrameSetSize(Frame_Cap1_4[i], 0.035, 0.035)
        call BlzFrameSetAllPoints(Frame_Cap1_4[i], Frame_Cap1_3[i])
        // Визуальные слои не участвуют в обработке мыши.
        call BlzFrameSetEnable(Frame_Cap1_4[i], false)
        call BlzFrameSetTexture(Frame_Cap1_4[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        //call BlzFrameSetLevel(Frame_Cap1_3[i], 3)
        set Frame_Cap1_9[i] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap1_MAIN, "WarCraftIIILogo", 0)
        call BlzFrameSetPoint(Frame_Cap1_9[i], FRAMEPOINT_CENTER, Frame_Cap1_3[i], FRAMEPOINT_CENTER, 0, 0)
        call BlzFrameSetSize(Frame_Cap1_9[i], 1., 1.)
        call BlzFrameSetScale(Frame_Cap1_9[i], 0.00003)
        call BlzFrameSetModel(Frame_Cap1_9[i], "war3mapImported\\wos_0713.mdl", 0)
        call BlzFrameSetEnable(Frame_Cap1_9[i], false)
        call BlzFrameSetVisible(Frame_Cap1_9[i], true)
        set Frame_Cap1_7[i] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap1_3[i], "", 0)
        call BlzFrameSetSize(Frame_Cap1_7[i], 0.025, 0.025)
        call BlzFrameSetEnable(Frame_Cap1_7[i], false)
        call BlzFrameSetPoint(Frame_Cap1_7[i], FRAMEPOINT_CENTER, Frame_Cap1_3[i], FRAMEPOINT_CENTER, 0, 0)
        call BlzFrameSetTexture(Frame_Cap1_7[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Stack0", 0, false)
       // call BlzFrameSetLevel(Frame_Cap1_7[i], 3)
       // call BlzFrameSetLevel(Frame_Cap1_4[i], 2)
        call BlzFrameSetPoint(Frame_Cap1_3[i], FRAMEPOINT_LEFT, Frame_Cap1_MAIN, FRAMEPOINT_BOTTOMLEFT, x, y )// - 0.03 * i)
        set Frame_Cap1_5[i] = BlzCreateFrameByType("TEXT", "MyIconTextAbi", Frame_Cap1_3[i], "", 0)
        if i >= 5 then
            if SplitNameCheck(GetPlayerName(Player(i))) then
                call BlzFrameSetPoint(Frame_Cap1_5[i], FRAMEPOINT_BOTTOM, Frame_Cap1_3[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( 0.059 + 0.05 * I2R(i2) ), (y - 0.0575 ) - 0.025 - 0.02 )// - 0.03 * i)
            else
                call BlzFrameSetPoint(Frame_Cap1_5[i], FRAMEPOINT_BOTTOM, Frame_Cap1_3[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( 0.059 + 0.05 * I2R(i2) ), (y - 0.0575 ) - 0.0165 - 0.02 )// - 0.03 * i)
            endif
        else
            if SplitNameCheck(GetPlayerName(Player(i))) then
                call BlzFrameSetPoint(Frame_Cap1_5[i], FRAMEPOINT_BOTTOM, Frame_Cap1_3[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( 0.059 + 0.05 * I2R(i2) ), (y - 0.0575 ) - 0.025 - 0.095 )// - 0.03 * i)
            else
                call BlzFrameSetPoint(Frame_Cap1_5[i], FRAMEPOINT_BOTTOM, Frame_Cap1_3[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( 0.059 + 0.05 * I2R(i2) ), (y - 0.0575 ) - 0.025 - 0.085 )// - 0.03 * i)
            endif
        endif
        call BlzFrameSetTextAlignment(Frame_Cap1_5[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetSize(Frame_Cap1_5[i], 0.0, 0.0)
        call BlzFrameSetText(Frame_Cap1_5[i], SplitName(GetPlayerName(Player(i))))
        set i = i + 1
        set i2 = i2 + 1
        set x = x + 0.05
        if i == 5 then
            set y = 0.075
            set x = 0.03
            set i2 = 0
        endif
    endloop
    set y = 0.02
    set Frame_Cap1_3[11] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap1_MAIN, "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetSize(Frame_Cap1_3[11], 0.035, 0.035)
    call BlzFrameSetEnable(Frame_Cap1_3[11], false)
    call BlzFrameSetPoint(Frame_Cap1_3[11], FRAMEPOINT_LEFT, Frame_Cap1_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.3, 0.05 + y )// - 0.03 * i)
    call BlzFrameSetTexture(Frame_Cap1_3[11], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
    set Frame_Cap1_4[11] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap1_3[11], "", 0)
    call BlzFrameSetSize(Frame_Cap1_4[11], 0.035, 0.035)
    call BlzFrameSetAllPoints(Frame_Cap1_4[11], Frame_Cap1_3[11])
    call BlzFrameSetEnable(Frame_Cap1_4[11], false)
    call BlzFrameSetTexture(Frame_Cap1_4[11], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        //call BlzFrameSetLevel(Frame_Cap1_3[i], 3)
    set Frame_Cap1_9[11] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap1_MAIN, "WarCraftIIILogo", 0)
    call BlzFrameSetPoint(Frame_Cap1_9[11], FRAMEPOINT_LEFT, Frame_Cap1_3[11], FRAMEPOINT_LEFT, -0.0012, 0.48 )
    call BlzFrameSetSize(Frame_Cap1_9[11], 1., 1.)
    call BlzFrameSetScale(Frame_Cap1_9[11], 1)
    call BlzFrameSetModel(Frame_Cap1_9[11], "Pick\\wos_IconShine1.mdx", 0)
    call BlzFrameSetEnable(Frame_Cap1_9[11], false)
    call BlzFrameSetVisible(Frame_Cap1_9[11], true)
    set Frame_Cap1_7[11] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap1_3[11], "", 0)
    call BlzFrameSetSize(Frame_Cap1_7[11], 0.025, 0.025)
    call BlzFrameSetEnable(Frame_Cap1_7[11], false)
    call BlzFrameSetVisible(Frame_Cap1_7[11], false)
    call BlzFrameSetPoint(Frame_Cap1_7[11], FRAMEPOINT_CENTER, Frame_Cap1_3[11], FRAMEPOINT_CENTER, 0, 0)
    call BlzFrameSetTexture(Frame_Cap1_7[11], "ReplaceableTextures\\CommandButtons\\BTNHero_Stack0", 0, false)
    set Frame_Cap1_10 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap1_MAIN, "", 0)
    call BlzFrameSetPoint(Frame_Cap1_10, FRAMEPOINT_BOTTOM, Frame_Cap1_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.3525, 0.0625 + y )// - 0.03 * i)
    call BlzFrameSetText(Frame_Cap1_10, "|c00FFFF00Cap1|r")
    call BlzFrameSetSize(Frame_Cap1_10, 0.2, 0.005)
    call BlzFrameSetScale(Frame_Cap1_10, 1.2)
    set Frame_Cap1_13 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap1_MAIN, "", 0)
    call BlzFrameSetPoint(Frame_Cap1_13, FRAMEPOINT_BOTTOM, Frame_Cap1_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.3425, 0.01 + y )// - 0.03 * i)
    call BlzFrameSetText(Frame_Cap1_13, "") 
    call BlzFrameSetSize(Frame_Cap1_13, 0.2, 0.1)
    call BlzFrameSetScale(Frame_Cap1_13, 1.2)
        
    set Frame_Cap1_3[12] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap1_MAIN, "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetSize(Frame_Cap1_3[12], 0.035, 0.035)
    call BlzFrameSetEnable(Frame_Cap1_3[12], false)
    call BlzFrameSetPoint(Frame_Cap1_3[12], FRAMEPOINT_LEFT, Frame_Cap1_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.3 + 0.06, 0.05 + y )// - 0.03 * i)
    call BlzFrameSetTexture(Frame_Cap1_3[12], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
    set Frame_Cap1_4[12] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap1_3[12], "", 0)
    call BlzFrameSetSize(Frame_Cap1_4[12], 0.035, 0.035)
    call BlzFrameSetAllPoints(Frame_Cap1_4[12], Frame_Cap1_3[12])
    call BlzFrameSetEnable(Frame_Cap1_4[12], false)
    call BlzFrameSetTexture(Frame_Cap1_4[12], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        //call BlzFrameSetLevel(Frame_Cap1_3[i], 3)
    set Frame_Cap1_9[12] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap1_MAIN, "WarCraftIIILogo", 0)
    call BlzFrameSetPoint(Frame_Cap1_9[12], FRAMEPOINT_LEFT, Frame_Cap1_3[12], FRAMEPOINT_LEFT, -0.0012, 0.48 )
    call BlzFrameSetSize(Frame_Cap1_9[12], 1., 1.)
    call BlzFrameSetScale(Frame_Cap1_9[12], 1)
    call BlzFrameSetModel(Frame_Cap1_9[12], "Pick\\wos_IconShine1.mdx", 0)
    call BlzFrameSetEnable(Frame_Cap1_9[12], false)
    call BlzFrameSetVisible(Frame_Cap1_9[12], false)
    set Frame_Cap1_7[12] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap1_3[12], "", 0)
    call BlzFrameSetSize(Frame_Cap1_7[12], 0.025, 0.025)
    call BlzFrameSetEnable(Frame_Cap1_7[12], false)
    call BlzFrameSetPoint(Frame_Cap1_7[12], FRAMEPOINT_CENTER, Frame_Cap1_3[12], FRAMEPOINT_CENTER, 0, 0)
    call BlzFrameSetTexture(Frame_Cap1_7[12], "ReplaceableTextures\\CommandButtons\\BTNHero_Stack0", 0, false)
    set Frame_Cap1_11 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap1_MAIN, "", 0)
    call BlzFrameSetPoint(Frame_Cap1_11, FRAMEPOINT_BOTTOM, Frame_Cap1_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.3525 + 0.05, 0.0625 + y )// - 0.03 * i)
    call BlzFrameSetText(Frame_Cap1_11, "|c00FFFF00Cap2|r")
    call BlzFrameSetSize(Frame_Cap1_11, 0.2, 0.005)
    call BlzFrameSetScale(Frame_Cap1_11, 1.2)
    call BlzFrameSetVisible(Frame_Cap1_7[12], false)
    set Frame_Cap1_14 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap1_MAIN, "", 0)
    call BlzFrameSetPoint(Frame_Cap1_14, FRAMEPOINT_BOTTOM, Frame_Cap1_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.3425 + 0.05, 0.01 + y )// - 0.03 * i)
    call BlzFrameSetText(Frame_Cap1_14, "")
    call BlzFrameSetSize(Frame_Cap1_14, 0.2, 0.1)
    call BlzFrameSetScale(Frame_Cap1_14, 1.2)
        
    set Frame_Cap1_6 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap1_MAIN, "", 0)
    call BlzFrameSetPoint(Frame_Cap1_6, FRAMEPOINT_BOTTOM, Frame_Cap1_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.33, 0.07 + 0.07 )// - 0.03 * i)
    call BlzFrameSetText(Frame_Cap1_6, "|c00FFFF00Time to pick Captain1: " + I2S(TimeToPickCaptain) + "|r")  
    call BlzFrameSetSize(Frame_Cap1_6, 0.2, 0.005)
    call BlzFrameSetScale(Frame_Cap1_6, 1.2)
    set Frame_Cap1_8 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap1_MAIN, "", 0)
    call BlzFrameSetPoint(Frame_Cap1_8, FRAMEPOINT_BOTTOM, Frame_Cap1_MAIN, FRAMEPOINT_BOTTOMLEFT, 0.36, 0.06 + 0.07 )// - 0.03 * i)
    call BlzFrameSetText(Frame_Cap1_8, "Click on button to vote|r")  
    call BlzFrameSetSize(Frame_Cap1_8, 0.2, 0.005)
    call BlzFrameSetScale(Frame_Cap1_8, 1.1)
    call TriggerAddAction(FrameCapClick, function CapOnClick)
    call TimerStart(FrameCapTimer, 1, true, function CapPickTime)
endfunction

function IsInTeam1 takes integer pid returns boolean
    local integer i = 0
    if CaptainMode == false then
        return pid < 5
    endif
    loop
        exitwhen i >= FullTeam1Size
        if FullTeam1[i] == pid then
            return true
        endif
        set i = i + 1
    endloop
    return false
endfunction

