library heroicon requires LocalMp3Player, AAINIT, GearSystems
    globals
        integer firsttimecleardummy = 0
        trigger FrameClickHeroMain
        trigger FrameEnterHeroMain
        trigger FrameLeaveHeroMain
        trigger FrameLinkMain
        trigger FrameLinkMain2
        trigger FrameAltHeroMainOn
        trigger FrameAltHeroMainOff
        trigger FrameBoxCheck
        trigger FrameSliderCheck
        framehandle FRAME_StatusHeroMain
        framehandle FRAME_StatusHeroMain2
        integer Test_int = 0
        real Test_real = 0
        real MinCam = 2500
        real MaxCam = 5800
        framehandle FRAME_Chat0
        framehandle FRAME_Chat1
        framehandle FRAME_Chat2
        framehandle FRAME_Chat3
        framehandle FRAME_Chat4
        framehandle FRAME_Chat5
        framehandle FRAME_Chat6
        framehandle FRAME_Chat7
        framehandle FRAME_Chat8
        framehandle FRAME_Chat9
        framehandle FRAME_Chat10
        framehandle FRAME_Chat11
        framehandle FRAME_Chat12
        framehandle FRAME_ShopButtonCheck
        framehandle FRAME_ShopButtonText
        framehandle FRAME_LINK_Main
        framehandle FRAME_LINK
        framehandle FRAME_LINK2
        framehandle FRAME_LINK3
        framehandle FRAME_LINK4
        framehandle FRAME_LINK5
        framehandle FRAME_TEST
        framehandle FRAME_TEST2
        framehandle FRAME_TEST3
        framehandle FRAME_TEST4
        framehandle FRAME_TEST5
        framehandle FRAME_TEST6
        framehandle FRAME_StatsMain
        framehandle FRAME_StatsBack
        framehandle FRAME_Stats0
        framehandle FRAME_Stats1
        framehandle FRAME_Stats2
        framehandle FRAME_Stats3
        framehandle FRAME_Stats4
        framehandle FRAME_Stats5
        framehandle FRAME_Stats6
        framehandle FRAME_Stats7
        framehandle FRAME_Stats8
        framehandle FRAME_Stats9
        framehandle FRAME_Stats10
        framehandle FRAME_Stats11
        framehandle FRAME_Stats12
        framehandle FRAME_StatsCheckbox
        framehandle FRAME_StatsCheckboxString
        framehandle FRAME_StatusHeroMain3
        framehandle FRAME_StatusHeroMain4
        framehandle array FRAME_StatusHero
        framehandle array FRAME_StatusHeroBack
        framehandle array FRAME_StatusHeroBack2
        framehandle array FRAME_StatusHeroTooltip
        framehandle array FRAME_StatusHeroTooltipText
        framehandle FRAME_DefaultClock
        framehandle FRAME_TopCheckbox
        framehandle FRAME_TopCheckboxString
        framehandle FRAME_CamSlider
        framehandle FRAME_CamSliderString
        framehandle FRAME_CamSliderStringBack
        string array FRAME_StatusHeroStringIcon
        boolean array FRAME_StatusHeroStringPlayerShowBoolean
        framehandle array FRAME_StatusHeroStringPlayerName
        framehandle array FRAME_StatusHeroStringPlayerKill
        framehandle array FRAME_StatusHeroStringPlayerDeath
        framehandle array FRAME_StatusHeroStringPlayerHeal
        framehandle array FRAME_StatusHeroStringPlayerDamagePhys
        framehandle array FRAME_StatusHeroStringPlayerDamageMag
        framehandle array FRAME_StatusHeroStringPlayerDamageTakenPhys
        framehandle array FRAME_StatusHeroStringPlayerDamageTakenMag
        framehandle FRAME_StatusHeroStringPlayerTakenDamageMag
        framehandle FRAME_StatusHeroStringPlayerTakenDamagePhys
        framehandle FRAME_RoundCount
        framehandle FRAME_RoundTimer
        framehandle FRAME_GameTimer
        framehandle FRAME_Team1Rounds
        framehandle FRAME_Team2Rounds
        integer FRAME_RoundCountSecBasePrepare = 60
        integer FRAME_RoundCountSecBase = 59
        integer FRAME_RoundCountMinBase = 4
        integer FRAME_RoundCountSec = 30
        integer FRAME_RoundCountMin = 0
        integer FRAME_GameTimerSec = 0
        integer FRAME_GameTimerMin = 0
        integer FRAME_GameTimerHour = 0
        integer CurrentRound = 1
        integer Team1Round = 0
        integer Team2Round = 0
        integer MaxRounds = 10
        integer array PlayerAltPressed
        integer array PlayerKill
        integer TrainKill = 0
        integer array PlayerDeath
        integer array PlayerDamagePhys
        integer array PlayerDamageMag
        integer array PlayerDamagePhysAll
        integer array PlayerDamageMagAll
        integer array PlayerHeal
        integer array PlayerHealAll
        real array PlayerDamageTakenPhys
        real array PlayerDamageTakenMag
        real array PlayerDamageTakenPhysAll
        real array PlayerDamageTakenMagAll
        real array CameraSetup
        private integer array StatusLastHeroType
        private integer array StatusLastLeave
        private boolean array StatusLastDead
        private boolean array StatusLastVisible
        private boolean array StatusSlotInitialized
        private integer array StatusHeroHovered
        private integer array StatusHeroPendingReset
        private integer StatusLastTrainKill = -1
        private integer StatusLastTeam1Round = -1
        private integer StatusLastTeam2Round = -1
        private integer StatusLastMaxRounds = -1
        private boolean StatusHeroUICreated = false
        private timer StatusHeroUpdateTimer = null

        // Параметры компактной верхней панели. Центральная точка интерфейса Warcraft III — 0.40.
        private constant real STATUS_BAR_CENTER_X = 0.400
        // Табло опущено под строку Ping/FPS, а опции имеют отдельную высоту.
        private constant real STATUS_BAR_CENTER_Y = 0.535
        // Общая позиция блока Hide UI / Shop Key.
        // X расположен немного левее центра иконки 6-го игрока, Y поднят на 0.045.
        private constant real STATUS_OPTIONS_CENTER_X = 0.445
        private constant real STATUS_OPTIONS_CENTER_Y = 0.56
        // Общая позиция текста Round Ends / Round Start In относительно центра табло.
        private constant real STATUS_ROUND_TIMER_X = 0.000
        private constant real STATUS_ROUND_TIMER_Y = -0.03
        private constant real STATUS_HERO_SIZE = 0.030
        private constant real STATUS_HERO_STEP = 0.030
        private constant real STATUS_LEFT_FIRST = -0.188
        private constant real STATUS_RIGHT_SHIFT = 0.106
    endglobals

    // Rebuilds the final inventory cache without depending on trigger order.
    private function HeroIcon_RefreshItemCache takes unit whichUnit returns nothing
        local integer unitHandleId
        local integer slot = 0
        local item slotItem

        if whichUnit == null then
            return
        endif

        set unitHandleId = GetHandleId(whichUnit)
        call FlushChildHashtable(ItemCache, unitHandleId)
        loop
            exitwhen slot >= 6
            set slotItem = UnitItemInSlot(whichUnit, slot)
            if slotItem != null then
                call SaveBoolean(ItemCache, unitHandleId, GetItemTypeId(slotItem), true)
            endif
            set slotItem = null
            set slot = slot + 1
        endloop
    endfunction

    // Скрывает штатный индикатор дня/ночи, который иначе перекрывает центр табло.
    private function HideStandardClock takes nothing returns nothing
        set FRAME_DefaultClock = BlzGetFrameByName("TimeOfDayIndicator", 0)
        if FRAME_DefaultClock == null then
            set FRAME_DefaultClock = BlzGetFrameByName("TimeOfDayIndicatorFrame", 0)
        endif
        if FRAME_DefaultClock == null then
            set FRAME_DefaultClock = BlzGetFrameByName("DayNightClock", 0)
        endif
        if FRAME_DefaultClock != null then
            call BlzFrameSetVisible(FRAME_DefaultClock, false)
        endif
    endfunction

    // Возвращает только время без длинной подписи, чтобы центральный блок оставался миниатюрным.
    private function GetCompactGameTimerText takes nothing returns string
        local string minutes = I2S(FRAME_GameTimerMin)
        local string seconds = I2S(FRAME_GameTimerSec)

        if FRAME_GameTimerMin < 10 then
            set minutes = "0" + minutes
        endif
        if FRAME_GameTimerSec < 10 then
            set seconds = "0" + seconds
        endif

        if FRAME_GameTimerHour > 0 then
            return "|cffffff00" + I2S(FRAME_GameTimerHour) + ":" + minutes + ":" + seconds + "|r"
        endif
        return "|cffffff00" + minutes + ":" + seconds + "|r"
    endfunction
       
    private function UpdateStatusHeroSlotOptimized takes integer i returns nothing
        local unit u = Hero[i]
        local integer heroType
        local integer leaveState
        local boolean dead
        local boolean typeChanged
        local boolean shouldShow = u != null and (not CaptainMode or CapPickPhase >= 2)
        local string icon

        if not shouldShow then
            if StatusLastVisible[i] then
                call BlzFrameSetVisible(FRAME_StatusHero[i], false)
                set StatusLastVisible[i] = false
            endif
            if u == null then
                set StatusSlotInitialized[i] = false
                set StatusLastHeroType[i] = 0
                set StatusLastLeave[i] = -1
                set StatusLastDead[i] = false
            endif
            set u = null
            return
        endif

        set heroType = GetUnitTypeId(u)
        set leaveState = Leave[i]
        set dead = IsUnitType(u, UNIT_TYPE_DEAD)
        set typeChanged = not StatusSlotInitialized[i] or StatusLastHeroType[i] != heroType

        if typeChanged then
            set icon = BlzGetAbilityIcon(heroType)
            set FRAME_StatusHeroStringIcon[i] = icon
            call BlzFrameSetTexture(FRAME_StatusHeroBack2[i], icon, 0, false)
        else
            set icon = FRAME_StatusHeroStringIcon[i]
        endif

        if not StatusSlotInitialized[i] or typeChanged or StatusLastDead[i] != dead or StatusLastLeave[i] != leaveState then
            if leaveState == 1 then
                call BlzFrameSetTexture(FRAME_StatusHeroBack[i], "ReplaceableTextures\\CommandButtons\\BTNleave2.blp", 0, false)
            elseif leaveState == 2 then
                call BlzFrameSetTexture(FRAME_StatusHeroBack[i], "ReplaceableTextures\\CommandButtons\\BTNleave1.blp", 0, false)
            elseif dead then
                call BlzFrameSetTexture(FRAME_StatusHeroBack[i], ConvertBTNtoDISBTN(icon), 0, false)
            else
                call BlzFrameSetTexture(FRAME_StatusHeroBack[i], icon, 0, false)
            endif
        endif

        if not StatusSlotInitialized[i] or StatusLastLeave[i] != leaveState then
            if leaveState == 0 then
                call BlzFrameSetText(FRAME_StatusHeroStringPlayerName[i], SplitName(GetPlayerName(Player(i))))
                call BlzFrameSetText(FRAME_StatusHeroTooltipText[i], "|cffffffff" + GetPlayerName(Player(i)) + "|r")
                call BlzFrameSetEnable(FRAME_StatusHero[i], true)
            else
                call BlzFrameSetText(FRAME_StatusHeroStringPlayerName[i], SplitName(FramePlayerFirstNameBase[i]))
                call BlzFrameSetText(FRAME_StatusHeroTooltipText[i], "|cffb7c0ca" + FramePlayerFirstNameBase[i] + "|r")
                call BlzFrameSetEnable(FRAME_StatusHero[i], false)
            endif
        endif

        if not StatusLastVisible[i] then
            call BlzFrameSetVisible(FRAME_StatusHero[i], true)
            set StatusLastVisible[i] = true
        endif

        set StatusLastHeroType[i] = heroType
        set StatusLastLeave[i] = leaveState
        set StatusLastDead[i] = dead
        set StatusSlotInitialized[i] = true
        set u = null
    endfunction

       function SwapActions takes player p, player p2 returns nothing
    local integer pid = GetPlayerId(p)
    local integer pid2 = GetPlayerId(p2)
    local unit heroA
    local unit heroB
    local integer typeA
    local integer k = 0
    local integer typeB   
    local integer i = 0
    local integer savedCount = 0
    local integer array savedItems
    local integer array savedItems2
    local item it
    local integer countA = 0
local integer countB = 0
    local integer slot = 0
    if Round1Started == 0 then 
    if Hero[pid2] == null then
        call DisplayTimedTextToPlayer(p, 0, 0, 5, "|cffFFCC00This player have not picked hero!|r")
        return
    endif
    if SwapRequests[pid2] == pid then
        set heroA = Hero[pid]
        set heroB = Hero[pid2]
        set Hero[pid] = heroB
        set Hero[pid2] = heroA
        call SetFlyInit(Hero[pid])
        call SetFlyInit(Hero[pid2])
        loop
    exitwhen slot >= 6
    set it = UnitItemInSlot(heroA, slot)
    if it != null then
        set savedItems[countA] = GetItemTypeId(it)
        set countA = countA + 1
        call RemoveItem( it)
    endif
    set slot = slot + 1
endloop
set slot = 0
loop
    exitwhen slot >= 6
    set it = UnitItemInSlot(heroB, slot)
    if it != null then
        set savedItems2[countB] = GetItemTypeId(it)
        set countB = countB + 1
        call RemoveItem(it)
    endif
    set slot = slot + 1
endloop
// Р вЂ™Р С•РЎРѓРЎРѓРЎвЂљР В°Р Р…Р С•Р Р†Р В»Р ВµР Р…Р С‘Р Вµ Р С•РЎвЂљР Т‘Р ВµР В»РЎРЉР Р…РЎвЂ№Р СР С‘ РЎвЂ Р С‘Р С”Р В»Р В°Р СР С‘, Р С”Р В°Р В¶Р Т‘РЎвЂ№Р в„– Р С—Р С• РЎРѓР Р†Р С•Р ВµР СРЎС“ РЎРѓРЎвЂЎРЎвЂРЎвЂљРЎвЂЎР С‘Р С”РЎС“
set i = 0
loop
    exitwhen i >= countA
    call UnitAddItemById(heroB, savedItems[i])
    set savedItems[i] = 0
    set i = i + 1
endloop
set i = 0
loop
    exitwhen i >= countB
    call UnitAddItemById(heroA, savedItems2[i])
    set savedItems2[i] = 0
    set i = i + 1
endloop
        call HeroIcon_RefreshItemCache(heroA)
        call HeroIcon_RefreshItemCache(heroB)
        call SetUnitOwner(heroA, p2, true)
        call SetUnitOwner(heroB, p, true)
        // После swap статистика должна ссылаться на новых героев владельцев.
        // Обмен разрешён до первого раунда, поэтому временный список предметов
        // безопасно начинается заново для обоих игроков.
        call SaveSystem_SetCurrentHero(p, Hero[pid])
        call SaveSystem_SetCurrentHero(p2, Hero[pid2])
        set typeA = GetUnitTypeId(heroA)
        set typeB = GetUnitTypeId(heroB)
        call BlzFrameSetTexture(FRAME_PlayerPickBack[pid], BlzGetAbilityIcon(typeB), 0, false)
        call BlzFrameSetTexture(FRAME_PlayerPickBack[pid2], BlzGetAbilityIcon(typeA), 0, false)
        if GetLocalPlayer() == p then
            call ClearSelection()
            call SelectUnit(heroB, true)
            call PanCameraToTimed(GetUnitX(heroB), GetUnitY(heroB), 0.25)
        endif
        // Р С›Р В±Р Р…Р С•Р Р†Р В»РЎРЏР ВµР С Р Р†РЎвЂ№Р Т‘Р ВµР В»Р ВµР Р…Р С‘Р Вµ Р С‘ Р С”Р В°Р СР ВµРЎР‚РЎС“ Р Т‘Р В»РЎРЏ Р ВР С–РЎР‚Р С•Р С”Р В° Р вЂ Р В»Р С•Р С”Р В°Р В»РЎРЉР Р…Р С•
        if GetLocalPlayer() == p2 then
            call ClearSelection()
            call SelectUnit(heroA, true)
            call PanCameraToTimed(GetUnitX(heroA), GetUnitY(heroA), 0.25)
        endif
        set k = 0
        loop
        exitwhen k == 10 
        call DisplayTimedTextToPlayer(Player(k),0,0,5, GetPlayerName(p) + "|r |c00FF1111and|r " +  GetPlayerName(p2) + "|r |c00FF1111swapped heroes with each other!|r")
        set k = k + 1
        endloop
         set k = 0
         set FRAME_SwapActive[pid] = 0
         set FRAME_SwapActive[pid2] = 0
        loop
        exitwhen k == 10
        if GetLocalPlayer() == p or GetLocalPlayer() == p2 then 
        call BlzFrameSetVisible(FRAME_SwapSprite[k],false)
        call BlzFrameSetVisible(FRAME_SwapSprite2[k],false)
        call BlzFrameSetEnable(FRAME_Swap[k], false)
        call BlzFrameSetVisible(FRAME_Swap[k], false)
        endif
        set k = k + 1
        endloop
        // Р РЋР В±РЎР‚Р В°РЎРѓРЎвЂ№Р Р†Р В°Р ВµР С Р В·Р В°Р С—РЎР‚Р С•РЎРѓРЎвЂ№ Р С•Р В±Р СР ВµР Р…Р В°
        set SwapRequests[pid] = -1
        set SwapRequests[pid2] = -1
        call RecommenedItems(p)
        call RecommenedItems(p2)
    else
        // Р вЂўРЎРѓР В»Р С‘ Р Р†РЎРѓРЎвЂљРЎР‚Р ВµРЎвЂЎР Р…Р С•Р С–Р С• Р В·Р В°Р С—РЎР‚Р С•РЎРѓР В° Р Р…Р ВµРЎвЂљ РІР‚вЂќ РЎР‚Р ВµР С–Р С‘РЎРѓРЎвЂљРЎР‚Р С‘РЎР‚РЎС“Р ВµР С Р Р…Р В°РЎв‚¬ Р В·Р В°Р С—РЎР‚Р С•РЎРѓ
        set SwapRequests[pid] = pid2
        set k = 0
        loop
        exitwhen k == 10
        if GetLocalPlayer() == p then 
        call BlzFrameSetVisible(FRAME_SwapSprite[k],false)
        call BlzFrameSetVisible(FRAME_SwapSprite2[k],false)
        endif
        set k = k + 1
        endloop
        if GetLocalPlayer() == p then 
        call BlzFrameSetVisible(FRAME_SwapSprite2[pid2],true)
        endif
        if LoadInteger(hs,GetHandleId(p),StringHash("cd s")) == 0 then 
        call SaveInteger(hs,GetHandleId(p),StringHash("cd s"),1)
        call MyFlush(GetHandleId(p),StringHash("cd s"),0,10)
        if GetLocalPlayer() == p2 then 
        call StartSound(gg_snd_Swap)
        endif
        call DisplayTimedTextToPlayer(p2, 0, 0, 10, GetPlayerName(p) + "|r |c00FF1111wants to change with you heroes! press swap button and pick this player to accept.|r")
        endif
        call DisplayTimedTextToPlayer(p, 0, 0, 1, "|c00FF1111Request sent. Waiting for |r"+GetPlayerName(p2) +"|c00FF1111 consent.|r")
    endif
    endif
    set it = null
    set heroA = null
    set heroB = null
endfunction
    function OnClickStatusHero takes nothing returns nothing
        local framehandle clicked = BlzGetTriggerFrame()
        local integer i = 0
        local integer i2 = 0
        local string s
        local string s_name
        local integer id = 0
        local integer k2 = 0
        local integer end = 0
        local player p = GetTriggerPlayer()
        local integer pid = GetPlayerId(p)
        local item temp_item = null
        local integer number_hero
        local real x = 0.025
        local real y = -0.05
        local integer k = 0
        loop
            exitwhen i == 10
            if clicked == FRAME_StatusHero[i] then 
             if Round1Started == 0 and FRAME_SwapActive[pid] == 1 and IsPlayerAlly(Player(i),p) and Player(i) != p then 
             call SwapActions(p,Player(i))
             else
            if IsUnitVisible(Hero[i], p) then
                if GetLocalPlayer() == p then
                    call ClearSelection()
                    call SelectUnit(Hero[i], true)
                    call PanCameraToTimed(GetUnitX(Hero[i]), GetUnitY(Hero[i]), 0.25)
                endif
            endif            
            endif
            endif
            set i = i + 1
        endloop
        set s = null
        set s_name = null
        set p = null
        set temp_item = null
    endfunction
    function FormatK takes integer value returns string
        local integer thousands
        local integer remainder
        if value < 1000 then
            return I2S(value)
        endif
        set thousands = value / 1000
        set remainder = value - thousands * 1000
    // Р Т‘Р С• 100k РІР‚вЂќ Р С—Р С•Р С”Р В°Р В·РЎвЂ№Р Р†Р В°Р ВµР С Р С•Р Т‘Р Р…РЎС“ РЎвЂ Р С‘РЎвЂћРЎР‚РЎС“ Р С—Р С•РЎРѓР В»Р Вµ РЎвЂљР С•РЎвЂЎР С”Р С‘
        if value < 100000 then
            return I2S(thousands) + "." + I2S(remainder / 100) + "k"
        endif
    // 100k Р С‘ Р Р†РЎвЂ№РЎв‚¬Р Вµ РІР‚вЂќ Р В±Р ВµР В· Р Т‘РЎР‚Р С•Р В±Р ВµР в„–
        return I2S(thousands) + "k"
    endfunction

    // Компактная ширина плашки: небольшой отступ по краям текста ника.
    private function GetStatusHeroTooltipWidth takes string playerName returns real
        local real width = 0.008 + I2R(StringLength(playerName)) * 0.003

        if width < 0.030 then
            set width = 0.030
        elseif width > 0.115 then
            set width = 0.115
        endif
        return width
    endfunction

    function StatusHeroEnterItem takes nothing returns nothing
        local framehandle clicked = BlzGetTriggerFrame()
        local integer i = 0
        local integer hovered = -1
        local integer previous
        local player p = GetTriggerPlayer()
        local integer pid = GetPlayerId(p)

        loop
            exitwhen i == 10
            if clicked == FRAME_StatusHero[i] and Hero[i] != null then
                set hovered = i
            endif
            set i = i + 1
        endloop

        if hovered < 0 then
            set clicked = null
            set p = null
            return
        endif

        // Для одной и той же иконки событие обрабатывается только один раз.
        // Подсказка меняется лишь после перехода на другого героя.
        if StatusHeroHovered[pid] == hovered then
            set clicked = null
            set p = null
            return
        endif

        set previous = StatusHeroHovered[pid]
        set StatusHeroHovered[pid] = hovered
        set StatusHeroPendingReset[pid] = -1

        if GetLocalPlayer() == p then
            if previous >= 0 and previous < 10 then
                call BlzFrameSetVisible(FRAME_StatusHeroTooltip[previous], false)
            endif
            call BlzFrameSetVisible(FRAME_StatusHeroTooltip[hovered], true)
        endif

        set clicked = null
        set p = null
    endfunction

    function StatusHeroLeaveItem takes nothing returns nothing
        local framehandle clicked = BlzGetTriggerFrame()
        local player p = GetTriggerPlayer()
        local integer pid = GetPlayerId(p)
        local integer i = 0
        local integer leftIcon = -1

        loop
            exitwhen i == 10
            if clicked == FRAME_StatusHero[i] then
                set leftIcon = i
            endif
            set i = i + 1
        endloop

        if leftIcon >= 0 and StatusHeroHovered[pid] == leftIcon then
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(FRAME_StatusHeroTooltip[leftIcon], false)
            endif
            // Не даём ложному повторному ENTER сразу снова показать подсказку.
            set StatusHeroPendingReset[pid] = leftIcon
        endif

        set clicked = null
        set p = null
    endfunction
   
    private function UpdateLocalStatusDetails takes integer pid returns nothing
        local integer i = 0
        local real takenMag
        local real takenPhys
        local unit d

        if pid < 0 or pid >= 10 or Hero[pid] == null then
            return
        endif

        if FRAME_StatusHeroStringPlayerShowBoolean[pid] then
            // Нижняя строка всегда показывает статистику локального игрока.
            // После конца матча используем те же накопительные массивы, что и скорборд.
            if END1 == 1 then
                call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF" + FormatK(R2I(PlayerDamageTakenMagAll[pid])) + " Mag|r/|cffff0000" + FormatK(R2I(PlayerDamageTakenPhysAll[pid])) + " Phys|r")
            else
                call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF" + FormatK(R2I(PlayerDamageTakenMag[pid])) + " Mag|r/|cffff0000" + FormatK(R2I(PlayerDamageTakenPhys[pid])) + " Phys|r")
            endif
            loop
                exitwhen i == 10
                if Hero[i] != null then
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[i], "|c00FFFF00Kills: |r" + I2S(PlayerKill[i]))
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[i], "|c00A74FFFDeaths: |r" + I2S(PlayerDeath[i]))
                    if i == pid then
                        if TestMode then
                            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "|cffff0000Phys: |r" + I2S(PlayerDamagePhys[i]))
                            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "|c004675FFMag: |r" + I2S(PlayerDamageMag[i]))
                        else
                            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "|cffff0000Phys: |r" + FormatK(PlayerDamagePhys[i]))
                            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "|c004675FFMag: |r" + FormatK(PlayerDamageMag[i]))
                        endif
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageTakenPhys[i], "|cffff0000T P:|r" + FormatK(R2I(PlayerDamageTakenPhys[i])))
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageTakenMag[i], "|c004675FFT M:|r" + FormatK(R2I(PlayerDamageTakenMag[i])))
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerHeal[i], "|c0013F807Heal: |r" + FormatK(PlayerHeal[i]))
                    else
                        if TestMode then
                            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "|cffff0000Phys: |r" + I2S(PlayerDamagePhysAll[i]))
                            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "|c004675FFMag: |r" + I2S(PlayerDamageMagAll[i]))
                        else
                            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "|cffff0000Phys: |r" + FormatK(PlayerDamagePhysAll[i]))
                            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "|c004675FFMag: |r" + FormatK(PlayerDamageMagAll[i]))
                        endif
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageTakenPhys[i], "|cffff0000T P:|r" + FormatK(R2I(PlayerDamageTakenPhysAll[i])))
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageTakenMag[i], "|c004675FFT M:|r" + FormatK(R2I(PlayerDamageTakenMagAll[i])))
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerHeal[i], "|c0013F807Heal: |r" + FormatK(PlayerHealAll[i]))
                    endif
                endif
                set i = i + 1
            endloop

            if HeroChosen[pid] == null then
                set d = Hero[pid]
            else
                set d = HeroChosen[pid]
            endif
            if d != null then
                call BlzFrameSetText(FRAME_Stats0, "[|c00FFFC01" + SplitName2(GetUnitName(d)) + "|r]")
                call BlzFrameSetText(FRAME_Stats2, "|c0000FD00Hp regen: " + R2SW(GetHpRegen(d), 0, 2) + "|r")
                call BlzFrameSetText(FRAME_Stats3, "|c004675FFMp regen: " + R2SW(GetMpRegen(d), 0, 2) + "|r")
                call BlzFrameSetText(FRAME_Stats4, "|cffff0000Phys res: " + R2SW(GetPhysRes(d), 0, 2) + "%|r")
                call BlzFrameSetText(FRAME_Stats5, "|c005959FFMag res: " + R2SW(GetMagRes(d), 0, 2) + "%|r")
                call BlzFrameSetText(FRAME_Stats6, "|c00FFFF00Movespeed: " + I2S(R2I(GetUnitMoveSpeed(d))) + "|r")
                call BlzFrameSetText(FRAME_Stats7, "|c00E2E2E2Atk cd: " + R2SW(GetAS(d), 0, 2) + "|r")
                call BlzFrameSetText(FRAME_Stats8, "|c002DFF00Atk range: " + R2SW(BlzGetUnitWeaponRealField(d, UNIT_WEAPON_RF_ATTACK_RANGE, 0), 0, 2) + "|r")
                if IsUnitType(d, UNIT_TYPE_HERO) then
                    call BlzFrameSetText(FRAME_Stats9, "|cffff0000Str: " + I2S(BlzGetUnitIntegerField(d, UNIT_IF_STRENGTH)) + "+" + R2SW(BlzGetUnitRealField(d, UNIT_RF_STRENGTH_PER_LEVEL), 0, 2) + "|r")
                    call BlzFrameSetText(FRAME_Stats10, "|cff289b1eAgi: " + I2S(BlzGetUnitIntegerField(d, UNIT_IF_AGILITY)) + "+" + R2SW(BlzGetUnitRealField(d, UNIT_RF_AGILITY_PER_LEVEL), 0, 2) + "|r")
                    call BlzFrameSetText(FRAME_Stats11, "|cff3737ffInt: " + I2S(BlzGetUnitIntegerField(d, UNIT_IF_INTELLIGENCE)) + "+" + R2SW(BlzGetUnitRealField(d, UNIT_RF_INTELLIGENCE_PER_LEVEL), 0, 2) + "|r")
                else
                    call BlzFrameSetText(FRAME_Stats9, "|cffff0000Str: 0|r")
                    call BlzFrameSetText(FRAME_Stats10, "|cff289b1eAgi: 0|r")
                    call BlzFrameSetText(FRAME_Stats11, "|cff3737ffInt: 0|r")
                endif
                call BlzFrameSetText(FRAME_Stats12, "Camera range: " + I2S(R2I(CameraSetup[pid])) + "|r")
            endif
        else
            set takenMag = GetPlayerTakenMag(Player(pid))
            set takenPhys = GetPlayerTakenPhys(Player(pid))
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF" + R2SW(takenMag, 0, 1) + "%Mag|r/|cffff0000" + R2SW(takenPhys, 0, 1) + "%Phys|r")
        endif
        set d = null
    endfunction

    function PlayerStatusHeroPeriodic takes nothing returns nothing
        local integer i = 0
        local integer remaining
        local integer remainingStart
        local integer viewerPid = GetPlayerId(GetLocalPlayer())

        // Некоторые варианты стандартного интерфейса повторно показывают часы после обновления UI.
        if FRAME_DefaultClock != null then
            if BlzFrameIsVisible(FRAME_DefaultClock) then
                call BlzFrameSetVisible(FRAME_DefaultClock, false)
            endif
        endif

        loop
            exitwhen i == 10
            call UpdateStatusHeroSlotOptimized(i)
            if StatusHeroPendingReset[i] >= 0 then
                set StatusHeroHovered[i] = -1
                set StatusHeroPendingReset[i] = -1
            endif
            set i = i + 1
        endloop

        // Общие фреймы деталей нельзя обновлять по очереди для всех pid:
        // последний открывший панель игрок перезаписывал личный полученный урон.
        if IsObserverSlot(viewerPid) then
            if FRAME_StatsMain != null then
                call BlzFrameSetVisible(FRAME_StatsMain, false)
            endif
        else
            call UpdateLocalStatusDetails(viewerPid)
        endif

        if StatusLastTrainKill != TrainKill then
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[10], "|cffffff00Kills:" + I2S(TrainKill) + "|r")
            set StatusLastTrainKill = TrainKill
        endif

            
       

        if StatusLastTeam1Round != Team1Round or StatusLastMaxRounds != MaxRounds then
            call BlzFrameSetText(FRAME_Team1Rounds, "|cffff4040" + I2S(Team1Round) + "|r")
            set StatusLastTeam1Round = Team1Round
        endif
        if StatusLastTeam2Round != Team2Round or StatusLastMaxRounds != MaxRounds then
            call BlzFrameSetText(FRAME_Team2Rounds, "|cff4080ff" + I2S(Team2Round) + "|r")
            set StatusLastTeam2Round = Team2Round
        endif
        set StatusLastMaxRounds = MaxRounds

        if RoundJustStarted == 1 then
            set RoundJustStarted = 0
            if (Time_RoundEnd - (Time_RoundEnd / 60) * 60) < 10 then
                call BlzFrameSetText(FRAME_RoundTimer, "Round Ends: |c00FFFF00" + I2S(Time_RoundEnd / 60) + ":0" + I2S(Time_RoundEnd - (Time_RoundEnd / 60) * 60))
            else
                call BlzFrameSetText(FRAME_RoundTimer, "Round Ends: |c00FFFF00" + I2S(Time_RoundEnd / 60) + ":" + I2S(Time_RoundEnd - (Time_RoundEnd / 60) * 60))
            endif
        elseif PrepJustStarted == 1 then
            set PrepJustStarted = 0
            if (TimeRound - (TimeRound / 60) * 60) < 10 then
                call BlzFrameSetText(FRAME_RoundTimer, "Round Start In: |c00FFFF00" + I2S(TimeRound / 60) + ":0" + I2S(TimeRound - (TimeRound / 60) * 60))
            else
                call BlzFrameSetText(FRAME_RoundTimer, "Round Start In: |c00FFFF00" + I2S(TimeRound / 60) + ":" + I2S(TimeRound - (TimeRound / 60) * 60))
            endif
        elseif CondArena == 1 then
            set remaining = Time_RoundEnd - R2I(TimeMove)
            if remaining < 0 then
                set remaining = 0
            endif
            if TimeMove == Time_RoundEnd - 1 then
                call BlzFrameSetText(FRAME_RoundTimer, "|c00FF0303Round Ends now!")
            elseif (remaining - (remaining / 60) * 60) < 10 then
                call BlzFrameSetText(FRAME_RoundTimer, "Round Ends: |c00FFFF00" + I2S(remaining / 60) + ":0" + I2S(remaining - (remaining / 60) * 60))
            else
                call BlzFrameSetText(FRAME_RoundTimer, "Round Ends: |c00FFFF00" + I2S(remaining / 60) + ":" + I2S(remaining - (remaining / 60) * 60))
            endif
        else
            set remainingStart = TimeRound - R2I(TimeMove)
            if remainingStart < 0 then
                set remainingStart = 0
            endif
            if remainingStart == TimeRound and TimeMove == 0 then
                if (Time_RoundEnd - (Time_RoundEnd / 60) * 60) < 10 then
                    call BlzFrameSetText(FRAME_RoundTimer, "Round Ends: |c00FFFF00" + I2S(Time_RoundEnd / 60) + ":0" + I2S(Time_RoundEnd - (Time_RoundEnd / 60) * 60))
                else
                    call BlzFrameSetText(FRAME_RoundTimer, "Round Ends: |c00FFFF00" + I2S(Time_RoundEnd / 60) + ":" + I2S(Time_RoundEnd - (Time_RoundEnd / 60) * 60))
                endif
            elseif TimeMove == TimeRound - 1 then
                call BlzFrameSetText(FRAME_RoundTimer, "|c00FFFF00Round Starts now!")
            elseif (remainingStart - (remainingStart / 60) * 60) < 10 then
                call BlzFrameSetText(FRAME_RoundTimer, "Round Start In: |c00FFFF00" + I2S(remainingStart / 60) + ":0" + I2S(remainingStart - (remainingStart / 60) * 60))
            else
                call BlzFrameSetText(FRAME_RoundTimer, "Round Start In: |c00FFFF00" + I2S(remainingStart / 60) + ":" + I2S(remainingStart - (remainingStart / 60) * 60))
            endif
        endif

        set FRAME_GameTimerSec = FRAME_GameTimerSec + 1
        if FRAME_GameTimerSec > 59 then
            set FRAME_GameTimerSec = 0
            set FRAME_GameTimerMin = FRAME_GameTimerMin + 1
            if FRAME_GameTimerMin > 59 then
                set FRAME_GameTimerMin = 0
                set FRAME_GameTimerHour = FRAME_GameTimerHour + 1
            endif
        endif

        if FRAME_GameTimerMin == 2 and FRAME_GameTimerSec == 0 and firsttimecleardummy == 0 then
            set i = 0
            loop
                exitwhen i > 32
                if Hero_ID0_Dummy[i] != null then
                    call RemoveUnit(Hero_ID0_Dummy[i])
                    set Hero_ID0_Dummy[i] = null
                endif
                if Hero_ID1_Dummy[i] != null then
                    call RemoveUnit(Hero_ID1_Dummy[i])
                    set Hero_ID1_Dummy[i] = null
                endif
                if Hero_ID2_Dummy[i] != null then
                    call RemoveUnit(Hero_ID2_Dummy[i])
                    set Hero_ID2_Dummy[i] = null
                endif
                if Hero_ID3_Dummy[i] != null then
                    call RemoveUnit(Hero_ID3_Dummy[i])
                    set Hero_ID3_Dummy[i] = null
                endif
                if Hero_ID4_Dummy[i] != null then
                    call RemoveUnit(Hero_ID4_Dummy[i])
                    set Hero_ID4_Dummy[i] = null
                endif
                set i = i + 1
            endloop
            set firsttimecleardummy = 1
        endif

        call BlzFrameSetText(FRAME_GameTimer, GetCompactGameTimerText())
    endfunction

    function FrameAlt_Show_True takes nothing returns nothing
        local integer i = 0
        local player p = GetTriggerPlayer()
        local integer id = GetPlayerId(p)
        if IsObserverSlot(id) then
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(FRAME_StatsMain, false)
            endif
            set p = null
            return
        endif
        if END1 != 0 then
    set p = null
    return
endif
        if FRAME_StatusHeroStringPlayerShowBoolean[id] == false then
            set FRAME_StatusHeroStringPlayerShowBoolean[id] = true
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(FRAME_StatsMain , true)
                call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF" + FormatK(R2I(PlayerDamageTakenMag[id])) + " Mag|r/|cffff0000" + FormatK(R2I(PlayerDamageTakenPhys[id])) + " Phys|r")
            endif
            loop
                exitwhen i == 10
                if Hero[i] != null then
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[i], "|c00FFFF00Kills: |r" + I2S(PlayerKill[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[i], "|c00A74FFFDeaths: |r" + I2S(PlayerDeath[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "|cffff0000Phys: |r" + FormatK(PlayerDamagePhys[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "|c004675FFMag: |r" + FormatK(PlayerDamageMag[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerHeal[i], "|c0013F807Heal: |r" + FormatK(PlayerHeal[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageTakenPhys[i], "|cffff0000T P:|r" + FormatK(R2I(PlayerDamageTakenPhys[i])) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageTakenMag[i], "|c004675FFT M:|r" + FormatK(R2I(PlayerDamageTakenMag[i])) + "") 
                    endif
                endif
                set i = i + 1
            endloop
        endif
        set i = 0
        set p = null
    endfunction
    function FrameAlt_Show_False takes nothing returns nothing
        local integer i = 0
        local player p = GetTriggerPlayer()
        local integer id = GetPlayerId(p)
        local real rr1
        local real rr2
        local integer check = LoadInteger(hs, GetHandleId(Player(id)), StringHash("stats left"))
        if IsObserverSlot(id) then
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(FRAME_StatsMain, false)
            endif
            set p = null
            return
        endif
        //call HeroTooltip(p)
        if END1 != 0 then
    set p = null
    return
endif
        if FRAME_StatusHeroStringPlayerShowBoolean[id] == false then
            set FRAME_StatusHeroStringPlayerShowBoolean[id] = true
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(FRAME_StatsMain , true)
                call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF" + FormatK(R2I(PlayerDamageTakenMag[id])) + " Mag|r/|cffff0000" + FormatK(R2I(PlayerDamageTakenPhys[id])) + " Phys|r")
            endif
            loop
                exitwhen i == 10
                if Hero[i] != null then
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[i], "|c00FFFF00Kills: |r" + I2S(PlayerKill[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[i], "|c00A74FFFDeaths: |r" + I2S(PlayerDeath[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "|cffff0000Phys: |r" + FormatK(PlayerDamagePhys[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "|c004675FFMag: |r" + FormatK(PlayerDamageMag[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerHeal[i], "|c0013F807Heal: |r" + FormatK(PlayerHeal[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageTakenPhys[i], "|cffff0000T P:|r" + FormatK(R2I(PlayerDamageTakenPhys[i])) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageTakenMag[i], "|c004675FFT M:|r" + FormatK(R2I(PlayerDamageTakenMag[i])) + "") 
                    endif
                endif
                set i = i + 1
            endloop
            else
            set FRAME_StatusHeroStringPlayerShowBoolean[id] = false
        if GetLocalPlayer() == p then
            if check == 0 then
                call BlzFrameSetVisible(FRAME_StatsMain , false)
            endif
            set rr1 = GetPlayerTakenMag(p)
            set rr2 = GetPlayerTakenPhys(p)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF" + R2SW(rr1,0,1) + "%Mag|r/|cffff0000" + R2SW(rr2,0,1) + "%Phys|r")
        endif
        loop
            exitwhen i == 10
            if Hero[i] != null then
                if GetLocalPlayer() == p then
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[i], "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[i], "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerHeal[i], "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageTakenPhys[i],  "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageTakenMag[i],  "") 
                endif
            endif
            set i = i + 1
        endloop
        endif       
        set i = 0
        set p = null
    endfunction
    function CheckBoxCheck takes nothing returns nothing
        local framehandle clicked = BlzGetTriggerFrame()
        local integer i = GetPlayerId(GetTriggerPlayer())
        if IsObserverSlot(i) and clicked == FRAME_StatsCheckbox then
            if GetLocalPlayer() == GetTriggerPlayer() then
                call BlzFrameSetVisible(FRAME_StatsMain, false)
            endif
            set clicked = null
            return
        endif
        if clicked == FRAME_ShopButtonCheck then
            if BlzGetTriggerFrameEvent() == FRAMEEVENT_CHECKBOX_CHECKED then
                set PlayerShopButton[i] = null
                call DisplayTextToPlayer(Player(i), 0, 0, "Press |c00FFFC01'Tab'|r or |c00FFFC01'I'|r or |c00FFFC01'B'|r to change Shop hotkey")
            endif
            if GetLocalPlayer() == GetTriggerPlayer() then
                call SaveInteger(hs, GetHandleId(Player(i)), StringHash("stats left"), 0)
            endif
        endif
        if clicked == FRAME_StatsCheckbox then
            if BlzGetTriggerFrameEvent() == FRAMEEVENT_CHECKBOX_CHECKED then
                call SaveInteger(hs, GetHandleId(Player(i)), StringHash("stats left"), 1)
            else
                if FRAME_StatusHeroStringPlayerShowBoolean[i] == false then
                    if GetLocalPlayer() == GetTriggerPlayer() then
                        call BlzFrameSetVisible(FRAME_StatsMain , false)
                    endif
                endif
                if GetLocalPlayer() == GetTriggerPlayer() then
                    call SaveInteger(hs, GetHandleId(Player(i)), StringHash("stats left"), 0)
                endif
            endif
        endif
        if clicked == FRAME_TopCheckbox then
            if BlzGetTriggerFrameEvent() == FRAMEEVENT_CHECKBOX_CHECKED then
                if GetLocalPlayer() == GetTriggerPlayer() then
                    call BlzFrameSetVisible(FRAME_StatusHeroMain, false)
                endif
            else
                if GetLocalPlayer() == GetTriggerPlayer() then
                    call BlzFrameSetVisible(FRAME_StatusHeroMain, true)
                endif
            endif
        endif
        set clicked = null
    endfunction
    function SliderCheck takes nothing returns nothing
        local real value = BlzGetTriggerFrameValue()
        local integer i = GetPlayerId(GetTriggerPlayer())
        set CameraSetup[i] = value
        if GetLocalPlayer() == Player(i) then
            call SetCameraField( CAMERA_FIELD_TARGET_DISTANCE, CameraSetup[i], 0 )
        endif
    endfunction
    function BarCheck takes nothing returns nothing
        set Test_int = Test_int - 1
        call BlzFrameSetValue(FRAME_TEST2, Test_int)
        set Test_real = Test_real - 0.1
        call BlzFrameSetText(FRAME_TEST6, "|c00FFFF00" + R2SW(Test_real, 0, 2) + "|r")
    endfunction
    function OnEditBoxFocus takes nothing returns nothing
    local framehandle f = BlzGetTriggerFrame()
    call BlzFrameSetText(f, "")   // Р С•РЎвЂЎР С‘РЎРѓРЎвЂљР С‘РЎвЂљРЎРЉ
    call BlzFrameSetText(f,"discord.gg/wos2")    // Р Р†Р ВµРЎР‚Р Р…РЎС“РЎвЂљРЎРЉ -> Р Р†РЎвЂ№Р Т‘Р ВµР В»Р С‘РЎвЂљРЎРѓРЎРЏ
    set f = null
endfunction
function OnClickFrameLink takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local integer i = 0
    local integer i2 = 0
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local real x = 0.025
    local real y = -0.05  
    local integer k = 0
    if clicked == FRAME_LINK2 then 
        if GetLocalPlayer() == p then
        call BlzFrameSetText(FRAME_LINK, "")  
        call BlzFrameSetVisible(FRAME_LINK2,false)
        call BlzFrameSetVisible(FRAME_LINK,true)
        call BlzFrameSetVisible(FRAME_LINK4,true)
        call BlzFrameSetVisible(FRAME_LINK5,true)
        call BlzFrameSetVisible(FRAME_LINK3,true)
        call BlzFrameSetText(FRAME_LINK,"discord.gg/wos2")
        endif
    endif
     if clicked == FRAME_Chat1 or clicked == FRAME_Chat2 or clicked == FRAME_Chat3 or clicked == FRAME_Chat4 or clicked == FRAME_Chat5 or clicked == FRAME_Chat6 then 
     if clicked == FRAME_Chat1 then 
     call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_emoji_11.mdx",Hero[pid],"origin"),3.5)
     elseif clicked == FRAME_Chat2 then 
     call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_emoji_3.mdx",Hero[pid],"origin"),3.5)
     elseif clicked == FRAME_Chat3 then 
     call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_emoji_5.mdx",Hero[pid],"origin"),3.5)
     elseif clicked == FRAME_Chat4 then 
     call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_emoji_7.mdx",Hero[pid],"origin"),3.5)
     elseif clicked == FRAME_Chat5 then 
     call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_emoji_8.mdx",Hero[pid],"origin"),3.5)
     elseif clicked == FRAME_Chat6 then 
     call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_emoji_9.mdx",Hero[pid],"origin"),3.5)
     endif
     call SaveInteger(hs,GetHandleId(p),StringHash("chat cd"),1)
     call MyFlush(GetHandleId(p),StringHash("chat cd"),0,3.25)
        set Chat_Active[pid] = false
        if GetLocalPlayer() == p then
        call BlzFrameSetVisible(FRAME_Chat0,false)        
        endif
    endif
    if clicked == FRAME_LINK4 then 
    if GetLocalPlayer() == p then
        call BlzFrameSetText(FRAME_LINK,"discord.gg/wos2")
        call BlzFrameSetVisible(FRAME_LINK,false)
        call BlzFrameSetVisible(FRAME_LINK4,false)
        call BlzFrameSetVisible(FRAME_LINK5,false)
        call BlzFrameSetVisible(FRAME_LINK2,true)
        call BlzFrameSetVisible(FRAME_LINK3,true)
        endif        
    endif
    set clicked = null
    set p = null
endfunction
    function CreateStatusHeroUI takes nothing returns nothing
        local integer i = 0
        local integer i2 = 0
        local integer k = 0
        local real x = STATUS_LEFT_FIRST
        local real y = 0.00
        local real r = 0.1
        local real r1 = 0.1
        local real r2 = 0.1
        local real r3 = 0.1
        local real rkek = 1
        local real rkek2 = 0
        local real rkek3 = 0
        local real rkek4 = 0
        local framehandle border
        if StatusHeroUICreated then
            return
        endif
        set StatusHeroUICreated = true
        call LocalMp3Player_CreateUI()
        call HideStandardClock()
        set FrameClickHeroMain = CreateTrigger()
        set FrameEnterHeroMain = CreateTrigger()
        set FrameLeaveHeroMain = CreateTrigger()
        set FrameAltHeroMainOn = CreateTrigger()
        set FrameAltHeroMainOff = CreateTrigger()
        set FrameBoxCheck = CreateTrigger()
        set FrameSliderCheck = CreateTrigger()
        loop
            exitwhen i == bj_MAX_PLAYERS
            // -1 гарантирует первое срабатывание для любой иконки, включая игрока 0.
            set StatusHeroHovered[i] = -1
            set StatusHeroPendingReset[i] = -1
           // call BlzTriggerRegisterPlayerKeyEvent( FrameAltHeroMainOn, Player(i), OSKEY_F2 , 0, true)
           // call BlzTriggerRegisterPlayerKeyEvent( FrameAltHeroMainOff, Player(i), OSKEY_F2 , 0, false)
            set i = i + 1
        endloop
       // call TriggerAddAction( FrameAltHeroMainOn, function FrameAlt_Show_True )
       // call TriggerAddAction( FrameAltHeroMainOff, function FrameAlt_Show_False )
    // === Р вЂњР В»Р В°Р Р†Р Р…РЎвЂ№Р в„– Р С”Р С•Р Р…РЎвЂљР ВµР в„–Р Р…Р ВµРЎР‚ ===
        // Прозрачный контейнер: внешняя стандартная рамка больше не рисуется.
        set FRAME_StatusHeroMain = BlzCreateFrameByType("FRAME", "StatusHeroMain", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 0)
        call BlzFrameSetAbsPoint(FRAME_StatusHeroMain, FRAMEPOINT_CENTER, STATUS_BAR_CENTER_X, STATUS_BAR_CENTER_Y)
        call BlzFrameSetAlpha(FRAME_StatusHeroMain, 255)
        call BlzFrameSetSize(FRAME_StatusHeroMain, 0.410, 0.054)
        call BlzFrameSetLevel(FRAME_StatusHeroMain, 5)
        set FRAME_StatusHeroMain2 = BlzCreateFrame("EscMenuBackdrop", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        call BlzFrameSetAbsPoint(FRAME_StatusHeroMain2, FRAMEPOINT_CENTER, 0.3, 0.16)
        call BlzFrameSetAlpha(FRAME_StatusHeroMain2, 0)
        call BlzFrameSetSize(FRAME_StatusHeroMain2, 0.38, 0.06)
        set FRAME_StatusHeroMain3 = BlzCreateFrame("EscMenuBackdrop", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        call BlzFrameSetAbsPoint(FRAME_StatusHeroMain3, FRAMEPOINT_CENTER, STATUS_OPTIONS_CENTER_X, STATUS_OPTIONS_CENTER_Y)
        call BlzFrameSetAlpha(FRAME_StatusHeroMain3, 0)
        call BlzFrameSetSize(FRAME_StatusHeroMain3, 0.180, 0.028)
        set FRAME_TopCheckbox = BlzCreateFrame("QuestCheckBox2", FRAME_StatusHeroMain3, 0, 0)
        call BlzFrameSetSize(FRAME_TopCheckbox, 0.016, 0.016)
        call BlzFrameSetAlpha(FRAME_TopCheckbox, 255)
        call BlzFrameSetPoint(FRAME_TopCheckbox, FRAMEPOINT_CENTER, FRAME_StatusHeroMain3, FRAMEPOINT_CENTER, 0.000, 0.000)
        call BlzTriggerRegisterFrameEvent(FrameBoxCheck, FRAME_TopCheckbox, FRAMEEVENT_CHECKBOX_CHECKED)
        call BlzTriggerRegisterFrameEvent(FrameBoxCheck, FRAME_TopCheckbox, FRAMEEVENT_CHECKBOX_UNCHECKED)
        call TriggerAddAction(FrameBoxCheck, function CheckBoxCheck)
        set FRAME_TopCheckboxString = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHeroMain3, "", 0)
        call BlzFrameSetSize(FRAME_TopCheckboxString, 0.060, 0.009)
        call BlzFrameSetAlpha(FRAME_TopCheckboxString, 255)
        call BlzFrameSetPoint(FRAME_TopCheckboxString, FRAMEPOINT_CENTER, FRAME_StatusHeroMain3, FRAMEPOINT_CENTER, 0.038, 0.000)
        call BlzFrameSetScale(FRAME_TopCheckboxString, 0.82)
        call BlzFrameSetText(FRAME_TopCheckboxString, "|cffffff00Hide UI|r")
        set FRAME_StatusHeroMain4 = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        call BlzFrameSetPoint(FRAME_StatusHeroMain4, FRAMEPOINT_CENTER, BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), FRAMEPOINT_CENTER, -0.30, -0.2225)//0.39 - 0, 215
        call BlzFrameSetAlpha(FRAME_StatusHeroMain4, 0)
        call BlzFrameSetSize(FRAME_StatusHeroMain4, 0.29, 0.0225 )
        set FRAME_CamSlider = BlzCreateFrameByType("SLIDER", "CamSlider", FRAME_StatusHeroMain4, "QuestMainListScrollBar", 0)
        call BlzFrameClearAllPoints(FRAME_CamSlider)
        call BlzFrameSetPoint(FRAME_CamSlider, FRAMEPOINT_CENTER, BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), FRAMEPOINT_CENTER, -0.21, -0.25)// - 0.205, -0.2225
        call BlzFrameSetSize(FRAME_CamSlider, 0.0145, 0.1 )
        call BlzFrameSetMinMaxValue(FRAME_CamSlider, MinCam, MaxCam)
        call BlzFrameSetStepSize(FRAME_CamSlider, 50)
        call BlzFrameSetAlpha(FRAME_CamSlider, 255)
        call BlzFrameSetValue(FRAME_CamSlider, BaseCam)
        call BlzTriggerRegisterFrameEvent(FrameSliderCheck, FRAME_CamSlider, FRAMEEVENT_SLIDER_VALUE_CHANGED)
        call TriggerAddAction(FrameSliderCheck, function SliderCheck)
        set FRAME_CamSliderStringBack = BlzCreateFrameByType("BACKDROP", "MyStatusButtonIcon", FRAME_StatusHeroMain4, "", 0)
        call BlzFrameSetPoint(FRAME_CamSliderStringBack, FRAMEPOINT_CENTER, FRAME_StatusHeroMain4, FRAMEPOINT_CENTER, 0.0675, 0.0325 )// - 0.03 * i)
        call BlzFrameSetAlpha(FRAME_CamSliderStringBack, 225)
        call BlzFrameSetSize(FRAME_CamSliderStringBack, 0.0165, 0.0165)
        call BlzFrameSetTexture(FRAME_CamSliderStringBack, "Pick\\CameraIcon", 0, true)
        set i = 0
        set r = STATUS_HERO_STEP
       
        loop
            exitwhen i == 10
            set FRAME_StatusHeroStringPlayerShowBoolean[i] = false
            set FRAME_StatusHero[i] = BlzCreateFrameByType("BUTTON", "MyStatusButton", FRAME_StatusHeroMain, "ScoreScreenTabButtonTemplate", 0)
            set FRAME_StatusHeroBack[i] = BlzCreateFrameByType("BACKDROP", "MyStatusButtonIcon", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetAllPoints(FRAME_StatusHeroBack[i], FRAME_StatusHero[i])
            call BlzFrameSetPoint(FRAME_StatusHero[i], FRAMEPOINT_CENTER, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, x + r * k, y)
            call BlzFrameSetSize(FRAME_StatusHero[i], STATUS_HERO_SIZE, STATUS_HERO_SIZE)
            call BlzFrameSetLevel(FRAME_StatusHero[i], 10)
            call BlzFrameSetLevel(FRAME_StatusHeroBack[i], 10)
            call BlzFrameSetAlpha(FRAME_StatusHero[i], 255)
            call BlzFrameSetAlpha(FRAME_StatusHeroBack[i], 255)
            call BlzTriggerRegisterFrameEvent(FrameClickHeroMain, FRAME_StatusHero[i], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetTexture(FRAME_StatusHeroBack[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
            set FRAME_StatusHeroBack2[i] = BlzCreateFrameByType("BACKDROP", "MyStatusButtonIcon", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetSize(FRAME_StatusHeroBack2[i], 0.018, 0.018)
            call BlzFrameSetAlpha(FRAME_StatusHeroBack2[i], 0)
            call BlzFrameSetPoint(FRAME_StatusHeroBack2[i], FRAMEPOINT_CENTER, FRAME_StatusHero[i], FRAMEPOINT_CENTER, 0.000, -0.025)
            set FRAME_StatusHeroStringPlayerName[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerName[i], FRAMEPOINT_CENTER, FRAME_StatusHero[i], FRAMEPOINT_BOTTOM, 0.000, -0.006)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerName[i], "|c00FFFF00" + "" + "|r")
            call BlzFrameSetVisible(FRAME_StatusHeroStringPlayerName[i], false)

            // Простой ручной tooltip без системного обработчика, вызывавшего зависание клиента.
            set FRAME_StatusHeroTooltip[i] = BlzCreateFrameByType("BACKDROP", "StatusHeroNameTooltip", FRAME_StatusHeroMain, "", 3000 + i)
            call BlzFrameSetPoint(FRAME_StatusHeroTooltip[i], FRAMEPOINT_TOP, FRAME_StatusHero[i], FRAMEPOINT_BOTTOM, 0.000, -0.003)
            call BlzFrameSetSize(FRAME_StatusHeroTooltip[i], GetStatusHeroTooltipWidth(GetPlayerName(Player(i))), 0.020)
            call BlzFrameSetTexture(FRAME_StatusHeroTooltip[i], "Textures\\black32.blp", 0, true)
            call BlzFrameSetAlpha(FRAME_StatusHeroTooltip[i], 230)
            call BlzFrameSetLevel(FRAME_StatusHeroTooltip[i], 60)
            set FRAME_StatusHeroTooltipText[i] = BlzCreateFrameByType("TEXT", "StatusHeroNameTooltipText", FRAME_StatusHeroTooltip[i], "", 3100 + i)
            call BlzFrameSetAllPoints(FRAME_StatusHeroTooltipText[i], FRAME_StatusHeroTooltip[i])
            call BlzFrameSetTextAlignment(FRAME_StatusHeroTooltipText[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
            call BlzFrameSetScale(FRAME_StatusHeroTooltipText[i], 0.70)
            call BlzFrameSetText(FRAME_StatusHeroTooltipText[i], "|cffffffff" + GetPlayerName(Player(i)) + "|r")
            call BlzFrameSetLevel(FRAME_StatusHeroTooltipText[i], 61)
            call BlzFrameSetVisible(FRAME_StatusHeroTooltip[i], false)
            // Warcraft сам показывает и скрывает подсказку без ENTER/LEAVE.
            call BlzFrameSetTooltip(FRAME_StatusHero[i], FRAME_StatusHeroTooltip[i])

            set FRAME_StatusHeroStringPlayerKill[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)
            if k >= 5 then
            set rkek2 = 0//
            else
            set rkek2 =0// x*((1-rkek)*(1-rkek+1))
            endif
            set FRAME_SwapSprite[i] = BlzCreateFrameByType("SPRITE", "justAName", FRAME_StatusHeroBack[i], "WarCraftIIILogo", 0)
            call BlzFrameSetPoint(FRAME_SwapSprite[i], FRAMEPOINT_LEFT, FRAME_StatusHero[i], FRAMEPOINT_LEFT, 0.02, 0.5 )
        call BlzFrameSetSize(FRAME_SwapSprite[i], 1., 1.)
        call BlzFrameSetScale(FRAME_SwapSprite[i], 1.)
        call BlzFrameSetModel(FRAME_SwapSprite[i], "Pick\\selecter5.mdx", 0)
        call BlzFrameSetVisible(FRAME_SwapSprite[i], false)
            set FRAME_SwapSprite2[i] = BlzCreateFrameByType("SPRITE", "justAName", FRAME_StatusHeroBack[i], "WarCraftIIILogo", 0)
            call BlzFrameSetPoint(FRAME_SwapSprite2[i], FRAMEPOINT_LEFT, FRAME_StatusHero[i], FRAMEPOINT_LEFT, 0.02, 0.5 )
        call BlzFrameSetSize(FRAME_SwapSprite2[i], 1., 1.)
        call BlzFrameSetScale(FRAME_SwapSprite2[i], 1.)
        call BlzFrameSetModel(FRAME_SwapSprite2[i], "Pick\\selecter6.mdx", 0)
        call BlzFrameSetVisible(FRAME_SwapSprite2[i], false)
            set rkek3 = (1-rkek+1)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerKill[i], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, (x+rkek2) + r * k, y - 0.045*rkek3 )// - 0.03 * i)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[i], "|c00FFFF00" + "" + "|r")
            call BlzFrameSetScale(FRAME_StatusHeroStringPlayerKill[i],rkek)
            set FRAME_StatusHeroStringPlayerDeath[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDeath[i], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, (x+rkek2) + r * k, y - 0.055*rkek3 )// - 0.03 * i)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[i], "|c00FFFF00" + "" + "|r")
            call BlzFrameSetScale(FRAME_StatusHeroStringPlayerDeath[i],rkek)
            set FRAME_StatusHeroStringPlayerDamagePhys[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamagePhys[i], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, (x+rkek2) + r * k, y - 0.065*rkek3 )// - 0.03 * i)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "|c00FFFF00" + "" + "|r")
            call BlzFrameSetScale(FRAME_StatusHeroStringPlayerDamagePhys[i],rkek)
            set FRAME_StatusHeroStringPlayerDamageMag[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamageMag[i], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, (x+rkek2) + r * k, y - 0.075*rkek3 )// - 0.03 * i)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "|c00FFFF00" + "" + "|r")
            call BlzFrameSetScale(FRAME_StatusHeroStringPlayerDamageMag[i],rkek)
            set FRAME_StatusHeroStringPlayerHeal[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerHeal[i], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, (x+rkek2) + r * k, y - 0.085*rkek3 )// - 0.03 * i)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerHeal[i], "|c00FFFF00" + "" + "|r")
            call BlzFrameSetScale(FRAME_StatusHeroStringPlayerHeal[i],rkek)
            set FRAME_StatusHeroStringPlayerDamageTakenPhys[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamageTakenPhys[i], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, (x+rkek2) + r * k, y - 0.095*rkek3 )// - 0.03 * i)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageTakenPhys[i], "|c00FFFF00" + "" + "|r")
            call BlzFrameSetScale(FRAME_StatusHeroStringPlayerDamageTakenPhys[i],rkek)
            set FRAME_StatusHeroStringPlayerDamageTakenMag[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamageTakenMag[i], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, (x+rkek2) + r * k, y - 0.105*rkek3 )// - 0.03 * i)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageTakenMag[i], "|c00FFFF00" + "" + "|r")
            call BlzFrameSetScale(FRAME_StatusHeroStringPlayerDamageTakenMag[i],rkek)
            set k = k + 1
            if k == 5 then
                set x = x + STATUS_RIGHT_SHIFT
            endif
            set i = i + 1
        endloop
        set r2 = 0.012
        set r3 = 0.000
        set FRAME_StatusHero[10] = BlzCreateFrameByType("BUTTON", "MyStatusButton", FRAME_StatusHeroMain, "ScoreScreenTabButtonTemplate", 0)
            set FRAME_StatusHeroBack[10] = BlzCreateFrameByType("BACKDROP", "MyStatusButtonIcon", FRAME_StatusHero[10], "", 0)
            call BlzFrameSetAllPoints(FRAME_StatusHeroBack[10], FRAME_StatusHero[10])
            call BlzFrameSetPoint(FRAME_StatusHero[10], FRAMEPOINT_CENTER, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, r3, r2)
            call BlzFrameSetSize(FRAME_StatusHero[10], 0.024, 0.024)
            call BlzFrameSetLevel(FRAME_StatusHero[10], 10)
            call BlzFrameSetLevel(FRAME_StatusHeroBack[10], 10)
            call BlzFrameSetAlpha(FRAME_StatusHero[10], 255)
            call BlzFrameSetAlpha(FRAME_StatusHeroBack[10], 255)
            call BlzFrameSetTexture(FRAME_StatusHeroBack[10], "ReplaceableTextures\\CommandButtons\\BTNTrainButton", 0, true)
            set FRAME_StatusHeroStringPlayerKill[10] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[10], "", 0)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerKill[10], FRAMEPOINT_CENTER, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, 0.000, -0.002)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[10], "|cffffff00Kills:" + I2S(TrainKill) + "|r")
            call BlzFrameSetScale(FRAME_StatusHeroStringPlayerKill[10], 0.62)
            
    call BlzFrameSetEnable(FRAME_StatusHero[10],false)
    call BlzFrameSetEnable(FRAME_StatusHeroBack[10],false)
    call BlzFrameSetEnable(FRAME_StatusHeroStringPlayerKill[10],false)
        set k = 5
        set FRAME_StatusHeroStringPlayerTakenDamageMag = BlzCreateFrameByType("TEXT", "MyPlayerName1", FRAME_StatusHeroMain2, "", 0)
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerTakenDamageMag, FRAMEPOINT_LEFT, FRAME_StatusHeroMain2, FRAMEPOINT_CENTER, -0.065, -0.005 )// - 0.03 * i)
        call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF" + I2S(0) + "%Mag|r/|cffff0000" + I2S(0) + "%Phys|r")
        call BlzFrameSetScale(FRAME_StatusHeroStringPlayerTakenDamageMag, 1.3)
        call BlzFrameSetSize(FRAME_StatusHeroStringPlayerTakenDamageMag, 0.2, 0.005)
        call BlzFrameSetAlpha(FRAME_StatusHeroStringPlayerTakenDamageMag, 255)
        call BlzFrameSetVisible(FRAME_StatusHeroMain2, false)
        set FRAME_RoundCount = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHeroMain, "", 0)
        call BlzFrameSetPoint(FRAME_RoundCount, FRAMEPOINT_CENTER, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, 0.000, 0.000)
        call BlzFrameSetText(FRAME_RoundCount, "Round: |c00FFFF00" + I2S(CurrentRound) + "|r")
        call BlzFrameSetScale(FRAME_RoundCount, 0.75)
        call BlzFrameSetAlpha(FRAME_RoundCount, 255)
        call BlzFrameSetEnable(FRAME_RoundCount,false)
        call BlzFrameSetVisible(FRAME_RoundCount, false)
        set k = 7
        set FRAME_RoundTimer = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHeroMain, "", 0)
        call BlzFrameSetPoint(FRAME_RoundTimer, FRAMEPOINT_CENTER, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, STATUS_ROUND_TIMER_X, STATUS_ROUND_TIMER_Y)
        call BlzFrameSetText(FRAME_RoundTimer, "Round Start In: |c00FFFF00" + I2S(TimeRound / 60) + ":00|r")
        call BlzFrameSetScale(FRAME_RoundTimer, 0.84)
        call BlzFrameSetAlpha(FRAME_RoundTimer, 255)
        call BlzFrameSetEnable(FRAME_RoundTimer,false)
        call BlzFrameSetVisible(FRAME_RoundTimer, true)
        set k = 9
        set FRAME_GameTimer = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHeroMain, "", 0)
        call BlzFrameSetPoint(FRAME_GameTimer, FRAMEPOINT_CENTER, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, 0.000, -0.015)
        call BlzFrameSetText(FRAME_GameTimer, GetCompactGameTimerText())
        call BlzFrameSetAlpha(FRAME_GameTimer, 255)
        call BlzFrameSetScale(FRAME_GameTimer, 0.70)
        call BlzFrameSetEnable(FRAME_GameTimer,false)
        set FRAME_Team1Rounds = BlzCreateFrameByType("TEXT", "MyPlayerScore1", FRAME_StatusHeroMain, "", 0)
        call BlzFrameSetPoint(FRAME_Team1Rounds, FRAMEPOINT_CENTER, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, -0.012, 0.000)
        call BlzFrameSetSize(FRAME_Team1Rounds, 0.024, 0.024)
        call BlzFrameSetTextAlignment(FRAME_Team1Rounds, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetText(FRAME_Team1Rounds, "|cffff4040" + I2S(Team1Round) + "|r")
        call BlzFrameSetScale(FRAME_Team1Rounds, 2.40)
        call BlzFrameSetAlpha(FRAME_Team1Rounds, 255)
        call BlzFrameSetLevel(FRAME_Team1Rounds, 50)
        call BlzFrameSetVisible(FRAME_Team1Rounds, true)
        call BlzFrameSetEnable(FRAME_Team1Rounds,false)
        set FRAME_Team2Rounds = BlzCreateFrameByType("TEXT", "MyPlayerScore2", FRAME_StatusHeroMain, "", 0)
        call BlzFrameSetPoint(FRAME_Team2Rounds, FRAMEPOINT_CENTER, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, 0.012, 0.000)
        call BlzFrameSetSize(FRAME_Team2Rounds, 0.024, 0.024)
        call BlzFrameSetTextAlignment(FRAME_Team2Rounds, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetText(FRAME_Team2Rounds, "|cff4080ff" + I2S(Team2Round) + "|r")
        call BlzFrameSetScale(FRAME_Team2Rounds, 2.40)
        call BlzFrameSetAlpha(FRAME_Team2Rounds, 255)
        call BlzFrameSetLevel(FRAME_Team2Rounds, 50)
        call BlzFrameSetVisible(FRAME_Team2Rounds, true)
        call TriggerAddAction(FrameClickHeroMain, function OnClickStatusHero)
        call BlzFrameSetEnable(FRAME_Team2Rounds,false)
        call BlzFrameSetVisible(FRAME_StatusHeroMain, false)
        call BlzFrameSetVisible(FRAME_StatusHeroMain3, false)
        call BlzFrameSetVisible(FRAME_StatusHeroMain4, false)
        
      
        set y = -0.03
        set FRAME_StatsMain = BlzCreateFrame("EscMenuTextAreaTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        call BlzFrameSetAbsPoint(FRAME_StatsMain, FRAMEPOINT_CENTER, -0.0525, 0.3)
        call BlzFrameSetSize(FRAME_StatsMain, 0.15, 0.23)
        set FRAME_StatsCheckbox = BlzCreateFrame("QuestCheckBox2", FRAME_StatsMain, 0, 0)
        call BlzFrameSetSize(FRAME_StatsCheckbox, 0.02, 0.02)
        call BlzFrameSetAlpha(FRAME_StatsCheckbox, 255)
        call BlzFrameSetPoint(FRAME_StatsCheckbox, FRAMEPOINT_CENTER, FRAME_StatsMain, FRAMEPOINT_CENTER, 0.05, 0.0375)// - 0.03 * i)
        call BlzTriggerRegisterFrameEvent(FrameBoxCheck, FRAME_StatsCheckbox, FRAMEEVENT_CHECKBOX_CHECKED)
        call BlzTriggerRegisterFrameEvent(FrameBoxCheck, FRAME_StatsCheckbox, FRAMEEVENT_CHECKBOX_UNCHECKED)
        set FRAME_StatsCheckboxString = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetSize(FRAME_StatsCheckboxString, 0.06, 0.005)
        call BlzFrameSetAlpha(FRAME_StatsCheckboxString, 255)
        call BlzFrameSetPoint(FRAME_StatsCheckboxString, FRAMEPOINT_CENTER, FRAME_StatsMain, FRAMEPOINT_CENTER, 0.0625, 0.0525)// - 0.03 * i)
        call BlzFrameSetText(FRAME_StatsCheckboxString, "|c00FFFF00Pin UI|r")
        set FRAME_Stats1 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetPoint(FRAME_Stats1, FRAMEPOINT_BOTTOMLEFT, FRAME_StatsMain, FRAMEPOINT_CENTER, -0.015, y + 0.1025)
        call BlzFrameSetText(FRAME_Stats1, "|c00FFFF00" + "Stats:" + "|r")
        call BlzFrameSetScale(FRAME_Stats1, 1.25)
        set FRAME_Stats0 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetPoint(FRAME_Stats0, FRAMEPOINT_BOTTOMLEFT, FRAME_StatsMain, FRAMEPOINT_CENTER, -0.05, y + 0.09+0.0075)
        call BlzFrameSetText(FRAME_Stats0, "|c00FFFF00[" + "Name:" + "]|r")
        call BlzFrameSetScale(FRAME_Stats0, 1)
        set FRAME_Stats2 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetPoint(FRAME_Stats2, FRAMEPOINT_BOTTOMLEFT, FRAME_StatsMain, FRAMEPOINT_CENTER, -0.06, y + 0.075)
        call BlzFrameSetText(FRAME_Stats2, "|c0000FD00" + "Hp regen: 1.00" + "|r")
        set FRAME_Stats3 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetPoint(FRAME_Stats3, FRAMEPOINT_BOTTOMLEFT, FRAME_StatsMain, FRAMEPOINT_CENTER, -0.06, y + 0.06)
        call BlzFrameSetText(FRAME_Stats3, "|c004675FF" + "Mp regen: 1.00" + "|r")
        set FRAME_Stats4 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetPoint(FRAME_Stats4, FRAMEPOINT_BOTTOMLEFT, FRAME_StatsMain, FRAMEPOINT_CENTER, -0.06, y + 0.045)
        call BlzFrameSetText(FRAME_Stats4, "|cffff0000" + "Phys res: 25.00" + "%|r")
        set FRAME_Stats5 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetPoint(FRAME_Stats5, FRAMEPOINT_BOTTOMLEFT, FRAME_StatsMain, FRAMEPOINT_CENTER, -0.06, y + 0.03)
        call BlzFrameSetText(FRAME_Stats5, "|c000000B7" + "Mag res: 11.00" + "%|r")
        set FRAME_Stats6 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetPoint(FRAME_Stats6, FRAMEPOINT_BOTTOMLEFT, FRAME_StatsMain, FRAMEPOINT_CENTER, -0.06, y + 0.015)
        call BlzFrameSetText(FRAME_Stats6, "|c00FFFF00" + "Movespeed: 375.00" + "|r")
        set FRAME_Stats7 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetPoint(FRAME_Stats7, FRAMEPOINT_BOTTOMLEFT, FRAME_StatsMain, FRAMEPOINT_CENTER, -0.06, y + 0)
        call BlzFrameSetText(FRAME_Stats7, "|c00E2E2E2" + "Atk cd: 1.25" + "|r")
        set FRAME_Stats8 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetPoint(FRAME_Stats8, FRAMEPOINT_BOTTOMLEFT, FRAME_StatsMain, FRAMEPOINT_CENTER, -0.06, y - 0.015)
        call BlzFrameSetText(FRAME_Stats8, "|c00E2E2E2" + "Atk rng 125" + "|r")
        
        set FRAME_Stats9 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetPoint(FRAME_Stats9, FRAMEPOINT_BOTTOMLEFT, FRAME_StatsMain, FRAMEPOINT_CENTER, -0.06, y - 0.03)
        call BlzFrameSetText(FRAME_Stats9, "|cffff0000Str: " + I2S(33) + "+" + R2S(3.25) + "|r")
        set FRAME_Stats10 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetPoint(FRAME_Stats10, FRAMEPOINT_BOTTOMLEFT, FRAME_StatsMain, FRAMEPOINT_CENTER, -0.06, y + - 0.045)
        call BlzFrameSetText(FRAME_Stats10, "|cff289b1eAgi: " + I2S(33) + "+" + R2S(3.25) + "|r")
        set FRAME_Stats11 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetPoint(FRAME_Stats11, FRAMEPOINT_BOTTOMLEFT, FRAME_StatsMain, FRAMEPOINT_CENTER, -0.06, y + - 0.06)
        call BlzFrameSetText(FRAME_Stats11, "|cff3737ffInt: " + I2S(33) + "+" + R2S(3.25) + "|r")
        set FRAME_Stats12 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)
        call BlzFrameSetPoint(FRAME_Stats12, FRAMEPOINT_BOTTOMLEFT, FRAME_StatsMain, FRAMEPOINT_CENTER, -0.06, y + - 0.075)
        call BlzFrameSetText(FRAME_Stats12, "Camera range: 3600" + "|r")
        call BlzFrameSetVisible(FRAME_StatsMain, false)
        
        set FRAME_ShopButtonCheck = BlzCreateFrame("QuestCheckBox2", FRAME_StatusHeroMain3, 0, 0)
        call BlzFrameSetSize(FRAME_ShopButtonCheck, 0.016, 0.016)
        call BlzFrameSetAlpha(FRAME_ShopButtonCheck, 255)
        call BlzFrameSetPoint(FRAME_ShopButtonCheck, FRAMEPOINT_LEFT, FRAME_TopCheckboxString, FRAMEPOINT_RIGHT, -0.020, 0.000)
        call BlzTriggerRegisterFrameEvent(FrameBoxCheck, FRAME_ShopButtonCheck, FRAMEEVENT_CHECKBOX_CHECKED)
        call BlzTriggerRegisterFrameEvent(FrameBoxCheck, FRAME_ShopButtonCheck, FRAMEEVENT_CHECKBOX_UNCHECKED)
        set FRAME_ShopButtonText = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHeroMain3, "", 0)
        call BlzFrameSetSize(FRAME_ShopButtonText, 0.065, 0.009)
        call BlzFrameSetAlpha(FRAME_ShopButtonText, 255)
        call BlzFrameSetPoint(FRAME_ShopButtonText, FRAMEPOINT_LEFT, FRAME_ShopButtonCheck, FRAMEPOINT_RIGHT, 0.004, 0.000)
        call BlzFrameSetScale(FRAME_ShopButtonText, 0.82)
        call BlzFrameSetText(FRAME_ShopButtonText, "|cffffff00Shop Key|r")
        
        call BlzFrameSetEnable(FRAME_StatsMain,false)
        set x = 0.19
        set y = 0.1325
        
        set FrameLinkMain2 = CreateTrigger()
        set FRAME_LINK2 = BlzCreateFrameByType("BUTTON", "MyIconButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetTexture(FRAME_LINK2, "WOS\\DiscordIcon", 0, false)
        call BlzFrameSetAbsPoint(FRAME_LINK2,FRAMEPOINT_CENTER, x,y )// - 0.03 * i)
        call BlzFrameSetSize(FRAME_LINK2, 0.02, 0.02)
        set FRAME_LINK4 = BlzCreateFrameByType("BUTTON", "MyIconButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetTexture(FRAME_LINK4, "WOS\\DiscordIcon", 0, false)
        call BlzFrameSetAbsPoint(FRAME_LINK4,FRAMEPOINT_CENTER, x,y )// - 0.03 * i)
        call BlzFrameSetSize(FRAME_LINK4, 0.02, 0.02)
        call BlzFrameSetVisible(FRAME_LINK4,false)
        set FRAME_LINK3 = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_LINK2, "", 0)
        call BlzFrameSetTexture(FRAME_LINK3, "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, true)
        call BlzFrameSetAllPoints(FRAME_LINK3, FRAME_LINK2)
        call BlzFrameSetSize(FRAME_LINK3, 0.03, 0.03)
        call BlzFrameSetTexture(FRAME_LINK3, "WOS\\DiscordIcon", 0, true)
        set FRAME_LINK5 = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_LINK4, "", 0)
        call BlzFrameSetTexture(FRAME_LINK5, "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, true)
        call BlzFrameSetAllPoints(FRAME_LINK5, FRAME_LINK4)
        call BlzFrameSetSize(FRAME_LINK5, 0.03, 0.03)
        call BlzFrameSetTexture(FRAME_LINK5, "WOS\\DiscordIcon2", 0, true)
        call BlzTriggerRegisterFrameEvent(FrameLinkMain2, FRAME_LINK2, FRAMEEVENT_CONTROL_CLICK)
        call BlzTriggerRegisterFrameEvent(FrameLinkMain2, FRAME_LINK4, FRAMEEVENT_CONTROL_CLICK)
            call TriggerAddAction(FrameLinkMain2, function OnClickFrameLink)
     set FRAME_LINK = BlzCreateFrame("EscMenuEditBoxTemplate",  BlzGetFrameByName("ConsoleUIBackdrop", 0),0,0)
    call BlzFrameSetAbsPoint(FRAME_LINK, FRAMEPOINT_CENTER, 0.52, 0.1525) 
    call BlzFrameSetSize(FRAME_LINK, 0.15, 0.03) 
    call BlzFrameSetText(FRAME_LINK,"discord.gg/wos2")    
    call BlzFrameSetVisible(FRAME_LINK,false)
    call BlzFrameSetVisible(FRAME_LINK2,false)    
    call BlzFrameSetVisible(FRAME_LINK4,false)
    
        set FrameLinkMain = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(FrameLinkMain, FRAME_LINK, FRAMEEVENT_EDITBOX_ENTER)
    call TriggerAddAction(FrameLinkMain, function OnEditBoxFocus)
        set r2 = 0.0275
        set r3 = 0.11
        set x = -0.12
        set y = 0.0275
        set k = 210
        set r1 = y
        set FRAME_Chat0 = BlzCreateFrameByType("BACKDROP", "MyIconButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
        call BlzFrameSetAbsPoint(FRAME_Chat0,FRAMEPOINT_CENTER, 0.37,0.31 )// - 0.03 * i)
        call BlzFrameSetSize(FRAME_Chat0, 0.3, 0.15)
        call BlzFrameSetTexture(FRAME_Chat0,"war3mapimported\\border1.blp",0,true)
        call BlzFrameSetAlpha(FRAME_Chat0,145)
        set FRAME_Chat1 = BlzCreateFrameByType("GLUETEXTBUTTON", "MyHeroNameButton", FRAME_Chat0, "ScriptDialogButton", 0)
    call BlzFrameSetSize(FRAME_Chat1, r3, r2)
    call BlzFrameSetText(FRAME_Chat1, "Nah i'd win")
    call BlzFrameSetPoint(FRAME_Chat1,FRAMEPOINT_BOTTOMLEFT,FRAME_Chat0,FRAMEPOINT_CENTER, x, y)
    call BlzFrameSetAlpha(FRAME_Chat1,k)
        set y = y - 0.04
        set FRAME_Chat2 = BlzCreateFrameByType("GLUETEXTBUTTON", "MyHeroNameButton", FRAME_Chat0, "ScriptDialogButton", 0)
    call BlzFrameSetSize(FRAME_Chat2, r3, r2)
    call BlzFrameSetText(FRAME_Chat2, "Angry")
    call BlzFrameSetAlpha(FRAME_Chat2,k)
    call BlzFrameSetPoint(FRAME_Chat2,FRAMEPOINT_BOTTOMLEFT,FRAME_Chat0,FRAMEPOINT_CENTER, x, y)
    set y = y - 0.04
        set FRAME_Chat3 = BlzCreateFrameByType("GLUETEXTBUTTON", "MyHeroNameButton", FRAME_Chat0, "ScriptDialogButton", 0)
    call BlzFrameSetSize(FRAME_Chat3, r3, r2)
    call BlzFrameSetText(FRAME_Chat3, "Question")
    call BlzFrameSetAlpha(FRAME_Chat3,k)
    call BlzFrameSetPoint(FRAME_Chat3,FRAMEPOINT_BOTTOMLEFT,FRAME_Chat0,FRAMEPOINT_CENTER, x, y)
        set y = r1
        set x = x+ 0.1275
        set FRAME_Chat4 = BlzCreateFrameByType("GLUETEXTBUTTON", "MyHeroNameButton", FRAME_Chat0, "ScriptDialogButton", 0)
    call BlzFrameSetSize(FRAME_Chat4, r3, r2)
    call BlzFrameSetText(FRAME_Chat4, "Help")
    call BlzFrameSetAlpha(FRAME_Chat4,k)
    call BlzFrameSetPoint(FRAME_Chat4,FRAMEPOINT_BOTTOMLEFT,FRAME_Chat0,FRAMEPOINT_CENTER, x, y)
    set y = y - 0.04
    set FRAME_Chat5 = BlzCreateFrameByType("GLUETEXTBUTTON", "MyHeroNameButton", FRAME_Chat0, "ScriptDialogButton", 0)
    call BlzFrameSetSize(FRAME_Chat5, r3, r2)
    call BlzFrameSetText(FRAME_Chat5, "Cry")
    call BlzFrameSetAlpha(FRAME_Chat5,k)
    call BlzFrameSetPoint(FRAME_Chat5,FRAMEPOINT_BOTTOMLEFT,FRAME_Chat0,FRAMEPOINT_CENTER, x, y)
    set y = y - 0.04
    set FRAME_Chat6 = BlzCreateFrameByType("GLUETEXTBUTTON", "MyHeroNameButton", FRAME_Chat0, "ScriptDialogButton", 0)
    call BlzFrameSetSize(FRAME_Chat6, r3, r2)
    call BlzFrameSetText(FRAME_Chat6, "Heh")
    call BlzFrameSetAlpha(FRAME_Chat6,k)
    call BlzFrameSetPoint(FRAME_Chat6,FRAMEPOINT_BOTTOMLEFT,FRAME_Chat0,FRAMEPOINT_CENTER, x, y)
    
        call BlzTriggerRegisterFrameEvent(FrameLinkMain2, FRAME_Chat1, FRAMEEVENT_CONTROL_CLICK)
        call BlzTriggerRegisterFrameEvent(FrameLinkMain2, FRAME_Chat2, FRAMEEVENT_CONTROL_CLICK)
        call BlzTriggerRegisterFrameEvent(FrameLinkMain2, FRAME_Chat3, FRAMEEVENT_CONTROL_CLICK)
        call BlzTriggerRegisterFrameEvent(FrameLinkMain2, FRAME_Chat4, FRAMEEVENT_CONTROL_CLICK)
        call BlzTriggerRegisterFrameEvent(FrameLinkMain2, FRAME_Chat5, FRAMEEVENT_CONTROL_CLICK)        
        call BlzTriggerRegisterFrameEvent(FrameLinkMain2, FRAME_Chat6, FRAMEEVENT_CONTROL_CLICK)
    call BlzFrameSetVisible(FRAME_Chat0,false)   
        //call BlzFrameSetTexture(FRAME_StatsMain, "UI\\Console\\ConsoleBackground.blp", 0, true)
         /* set FRAME_TEST = BlzCreateFrame("EscMenuControlBackdropTemplate", FRAME_TEST4, 0, 0)
        call BlzFrameSetAbsPoint(FRAME_TEST, FRAMEPOINT_CENTER, 0.07, 0.185)
        call BlzFrameSetSize(FRAME_TEST, 0.1, 0.019)
        set FRAME_TEST2 = BlzCreateFrameByType("STATUSBAR", "", FRAME_TEST4, "", 0)
        call BlzFrameSetSize(FRAME_TEST2, 0.1, 0.035)
        call BlzFrameSetScale(FRAME_TEST2, 0.5)
        call BlzFrameSetModel(FRAME_TEST2, "ui/feedback/XpBar/XpBarConsole.mdx", 0)
        call BlzFrameSetAbsPoint(FRAME_TEST2, FRAMEPOINT_CENTER, 0.05, 0.175)
        call BlzFrameSetMinMaxValue(FRAME_TEST2, 0, 100)
        set Test_int = 100
        set Test_real = 11
        call BlzFrameSetValue(FRAME_TEST2, Test_int)
        call TimerStart(CreateTimer(), 0.1, true, function BarCheck)
        set FRAME_TEST3 = BlzCreateFrameByType("BACKDROP", "SS", FRAME_TEST4, "", 0)
        call BlzFrameSetAbsPoint(FRAME_TEST3, FRAMEPOINT_CENTER, 0.005, 0.18)
        call BlzFrameSetSize(FRAME_TEST3, 0.03, 0.03)
        call BlzFrameSetTexture(FRAME_TEST3, "ReplaceableTextures\\CommandButtons\\BTNHero_Tomioka_G", 0, false)
        set FRAME_TEST5 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_TEST4, "", 0)
        call BlzFrameSetAbsPoint(FRAME_TEST5, FRAMEPOINT_CENTER, 0.07, 0.185)
        call BlzFrameSetText(FRAME_TEST5, "|c00FFFF00" + "1 Stack" + "|r")
        call BlzFrameSetScale(FRAME_TEST5, 0.9)
        set FRAME_TEST6 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_TEST4, "", 0)
        call BlzFrameSetAbsPoint(FRAME_TEST6, FRAMEPOINT_CENTER, 0.07, 0.17)
        call BlzFrameSetText(FRAME_TEST6, "|c00FFFF00" + R2SW(Test_real, 0, 2) + "|r")
        call BlzFrameSetScale(FRAME_TEST6, 0.9) */ 
        set StatusHeroUpdateTimer = CreateTimer()
        call TimerStart(StatusHeroUpdateTimer, 1.00, true, function PlayerStatusHeroPeriodic)
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
