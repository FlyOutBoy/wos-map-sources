library heroicon
    globals
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
        real MaxCam = 5400
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
        framehandle array FRAME_StatusHeroStringPlayerDamagePhys
        framehandle array FRAME_StatusHeroStringPlayerDamageMag
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
        integer FRAME_RoundCountSec = 0
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
        integer array PlayerDeath
        integer array PlayerDamagePhys
        integer array PlayerDamageMag
        integer array PlayerDamagePhysAll
        integer array PlayerDamageMagAll
        real array PlayerDamageTakenPhys
        real array PlayerDamageTakenMag
        real array PlayerDamageTakenPhysAll
        real array PlayerDamageTakenMagAll
        real array CameraSetup
    endglobals
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
            if clicked == FRAME_StatusHero[i] and IsUnitVisible(Hero[i], p) then
                if GetLocalPlayer() == p then
                    call ClearSelection()
                    call SelectUnit(Hero[i], true)
                    call PanCameraToTimed(GetUnitX(Hero[i]), GetUnitY(Hero[i]), 0.25)
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
    // до 100k — показываем одну цифру после точки
        if value < 100000 then
            return I2S(thousands) + "." + I2S(remainder / 100) + "k"
        endif
    // 100k и выше — без дробей
        return I2S(thousands) + "k"
    endfunction
    function StatusHeroEnterItem takes nothing returns nothing
        local framehandle clicked = BlzGetTriggerFrame()
        local integer i = 0
        local integer i2 = 0
        local string s
        local string s_name
        local integer id = 0
        local integer end = 0
        local player p = GetTriggerPlayer()
        local integer pid = GetPlayerId(p)
        local real x = 0.025
        local real y = -0.05
        local integer k = 0
        loop
            exitwhen i == 10
            if clicked == FRAME_StatusHero[i] and Hero[i] != null then
                if GetLocalPlayer() == p then
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[i], "|c00FFFF00Kills: |r" + I2S(PlayerKill[i]) + "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[i], "|c00A74FFFDeaths: |r" + I2S(PlayerDeath[i]) + "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "|cffff0000Phys: |r" + FormatK(PlayerDamagePhys[i]) + "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "|c004675FFMag: |r" + FormatK(PlayerDamageMag[i]) + "")
                endif
            endif
            set i = i + 1
        endloop
        set i = 0
        set p = null
    endfunction
    function StatusHeroLeaveItem takes nothing returns nothing
        local framehandle clicked = BlzGetTriggerFrame()
        local integer i = 0
        local integer i2 = 0
        local string s
        local string s_name
        local integer id = 0
        local integer end = 0
        local player p = GetTriggerPlayer()
        local integer pid = GetPlayerId(p)
        local integer number_hero
        local real x = 0.025
        local real y = -0.05
        local integer k = 0
        loop
            exitwhen i == 10
            if clicked == FRAME_StatusHero[i] then
                if GetLocalPlayer() == p then
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[i], "|c00FFFF00" + "" + "|r")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[i], "|c00FFFF00" + "" + "|r")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "|c00FFFF00" + "" + "|r")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "|c00FFFF00" + "" + "|r")
                endif
            endif
            set i = i + 1
        endloop
        set i = 0
        set p = null
    endfunction
    function ConvertBTNtoDISBTN takes string path returns string
        local integer len = StringLength(path)
        local integer i = len - 1
        local string name = ""
    // Находим последний слэш '\'
        loop
            exitwhen i < 0 or SubString(path, i, i + 1) == "\\"
            set i = i - 1
        endloop
        if i >= 0 then
            set name = SubString(path, i + 1, len) // имя файла (например "BTNAttack" или "DISBTNAttack")
        else
            set name = path
        endif
    // Если имя уже начинается с "DIS", не добавляем второй раз
        if StringLength(name) >= 3 and SubString(name, 0, 3) == "DIS" then
            return "ReplaceableTextures\\CommandButtonsDisabled\\" + name
        endif
        return "ReplaceableTextures\\CommandButtonsDisabled\\DIS" + name
    endfunction
    function PlayerStatusHeroPeriodic takes nothing returns nothing
        local integer i = 0
        local integer id = 0
        local integer k = 0
        local integer k2 = 0
        local real rr1 = 0
        local real rr2 = 0
        local integer min
        local integer time = 0
        local integer sec
        local unit d 
        loop
            exitwhen i == 10
            if Hero[i] != null then
                set rr1 = GetPlayerTakenMag(Player(i))
                set rr2 = GetPlayerTakenPhys(Player(i))
      //  call BJDebugMsg(I2S(k)+ " "+I2S(k2))      
                if GetLocalPlayer() == Player(i) then
                    if FRAME_StatusHeroStringPlayerShowBoolean[i] == false then
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF" + R2SW(rr1, 0, 2) + "%Mag|r/|cffff0000" + R2SW(rr2, 0, 2) + "%Phys|r")
                    else
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF" + R2SW(PlayerDamageTakenMag[i], 0, 2) + "Mag|r/|cffff0000" + R2SW(PlayerDamageTakenPhys[i], 0, 2) + "Phys|r")
                    endif
                    if FRAME_StatusHeroStringPlayerShowBoolean[i] == true then
                    set k2 = 0
                    loop
                    exitwhen k2 == 10
                    if Hero[k2] != null then 
                        if GetLocalPlayer() == Player(i) then 
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[k2], "|c00FFFF00Kills: |r" + I2S(PlayerKill[k2]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[k2], "|c00A74FFFDeaths: |r" + I2S(PlayerDeath[k2]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[k2], "|cffff0000Phys: |r" + FormatK(PlayerDamagePhys[k2]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[k2], "|c004675FFMag: |r" + FormatK(PlayerDamageMag[k2]) + "")
                        endif
                    endif
                    set k2 = k2 + 1
                        endloop
                        else
                         set k2 = 0
                    loop
                    exitwhen k2 == 10
                    if Hero[k2] != null then 
                        if GetLocalPlayer() == Player(i) then 
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[k2], "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[k2], "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[k2], "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[k2], "")
                        endif
                    endif
                    set k2 = k2 + 1
                        endloop
                    endif
                    if HeroChosen[i] == null then 
                    set d = Hero[i]
                    else
                    set d = HeroChosen[i]
                    endif
                    call BlzFrameSetText(FRAME_Stats0, "[|c00FFFC01" + SplitName2(GetUnitName(d)) + "|r]")
                    call BlzFrameSetText(FRAME_Stats2, "|c0000FD00" + "Hp regen: " + R2SW(GetHpRegen(d), 0, 2) + "|r")
                    call BlzFrameSetText(FRAME_Stats3, "|c004675FF" + "Mp regen: " + R2SW(GetMpRegen(d), 0, 2) + "|r")
                    call BlzFrameSetText(FRAME_Stats4, "|cffff0000" + "Phys res: " + R2SW(GetPhysRes(d), 0, 2) + "%|r")
                    call BlzFrameSetText(FRAME_Stats5, "|c005959FF" + "Mag res: " + R2SW(GetMagRes(d), 0, 2) + "%|r")
                    call BlzFrameSetText(FRAME_Stats6, "|c00FFFF00" + "Movespeed: " + I2S(R2I(GetUnitMoveSpeed(d))) + "|r")
                    call BlzFrameSetText(FRAME_Stats7, "|c00E2E2E2" + "Atk cd: " + R2SW(GetAS(d), 0, 2) + "|r")
                    call BlzFrameSetText(FRAME_Stats8, "|c002DFF00" + "Atk range: " + R2SW(BlzGetUnitWeaponRealField(d,UNIT_WEAPON_RF_ATTACK_RANGE,0), 0, 2) + "|r")
                    if IsUnitType(d,UNIT_TYPE_HERO) == true then 
                    call BlzFrameSetText(FRAME_Stats9, "|cffff0000Str: " + I2S(BlzGetUnitIntegerField(d, UNIT_IF_STRENGTH)) + "+" + R2SW(BlzGetUnitRealField(d, UNIT_RF_STRENGTH_PER_LEVEL), 0, 2) + "|r")
                    call BlzFrameSetText(FRAME_Stats10, "|cff289b1eAgi: " + I2S(BlzGetUnitIntegerField(d, UNIT_IF_AGILITY)) + "+" + R2SW(BlzGetUnitRealField(d, UNIT_RF_AGILITY_PER_LEVEL), 0, 2) + "|r")
                    call BlzFrameSetText(FRAME_Stats11, "|cff3737ffInt: " + I2S(BlzGetUnitIntegerField(d, UNIT_IF_INTELLIGENCE)) + "+" + R2SW(BlzGetUnitRealField(d, UNIT_RF_INTELLIGENCE_PER_LEVEL), 0, 2) + "|r")
                    else
                    call BlzFrameSetText(FRAME_Stats9, "|cffff0000Str: 0|r")
                    call BlzFrameSetText(FRAME_Stats10, "|cff289b1eAgi: 0|r")
                    call BlzFrameSetText(FRAME_Stats11, "|cff3737ffInt: 0|r")
                    endif
                    call BlzFrameSetText(FRAME_Stats12, "Camera range: " + I2S(R2I(CameraSetup[i])) + "|r")
                endif
                if BlzFrameGetEnable(FRAME_StatusHero[i]) == false then
                    if GetLocalPlayer() == Player(i) then
                        call BlzFrameSetEnable(FRAME_StatusHero[i], true)
                    endif
                endif
            else
                if BlzFrameGetEnable(FRAME_StatusHero[i]) == true then
                    if GetLocalPlayer() == Player(i) then
                        call BlzFrameSetEnable(FRAME_StatusHero[i], false)
                    endif
                endif
            endif
            if Hero[i] != null then
                if FRAME_StatusHeroStringIcon[i] != BlzGetAbilityIcon(GetUnitTypeId(Hero[i])) then
                    set FRAME_StatusHeroStringIcon[i] = BlzGetAbilityIcon(GetUnitTypeId(Hero[i]))
                    call BlzFrameSetTexture(FRAME_StatusHeroBack[i], FRAME_StatusHeroStringIcon[i], 0, false)
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerName[i], SplitName(GetPlayerName(Player(i))))
                endif
                if IsUnitType(Hero[i], UNIT_TYPE_DEAD) then
                    call BlzFrameSetTexture(FRAME_StatusHeroBack[i], ConvertBTNtoDISBTN(FRAME_StatusHeroStringIcon[i]), 0, false)
                else
                    call BlzFrameSetTexture(FRAME_StatusHeroBack[i], FRAME_StatusHeroStringIcon[i], 0, false)
                endif
            endif
            set i = i + 1
        endloop
        call BlzFrameSetText(FRAME_Team1Rounds, "|cffff0000" + I2S(Team1Round) + "/" + I2S(MaxRounds) + "|r")
        call BlzFrameSetText(FRAME_Team2Rounds, "|c002F63FF" + I2S(Team2Round) + "/" + I2S(MaxRounds) + "|r")
        if CondArena == 1 then
            set FRAME_RoundCountSec = FRAME_RoundCountSec + 1
            if FRAME_RoundCountSec > 59 then
                set FRAME_RoundCountSec = 0
                set FRAME_RoundCountMin = FRAME_RoundCountMin + 1
                if FRAME_RoundCountMin > 59 then
                    set FRAME_RoundCountMin = 0
                endif
            endif
            if TimeMove == 299 then
                call BlzFrameSetText(FRAME_RoundTimer, "|c00FF0303Round Ends now!")
            else
                if FRAME_RoundCountSec > 49 then
                    call BlzFrameSetText(FRAME_RoundTimer, "Round Ends: |c00FFFF00" + I2S(FRAME_RoundCountMinBase - FRAME_RoundCountMin) + ":0" + I2S(FRAME_RoundCountSecBase - FRAME_RoundCountSec))
                else
                    call BlzFrameSetText(FRAME_RoundTimer, "Round Ends: |c00FFFF00" + I2S(FRAME_RoundCountMinBase - FRAME_RoundCountMin) + ":" + I2S(FRAME_RoundCountSecBase - FRAME_RoundCountSec))
                endif
            endif
        else
            set FRAME_RoundCountSec = FRAME_RoundCountSec + 1
            if FRAME_GameTimerMin < 3 then
                call BlzFrameSetText(FRAME_TimerToStart, "|c00FFFF00Time Left: " + I2S((FRAME_RoundCountSecBasePrepare - 1) - R2I(TimeMove)) + "|r")
            endif
            if FirstTime == 0 then
                if FRAME_RoundCountSec > 59 then
                    set FRAME_RoundCountSec = 0
                    if FRAME_RoundCountSec > 119 then
                        set FRAME_RoundCountMin = FRAME_RoundCountMin + 2
                    else
                        set FRAME_RoundCountMin = FRAME_RoundCountMin + 1
                    endif
                endif
                set time = R2I(59)
    //set time = time - 60
            else
                set time = FRAME_RoundCountSecBasePrepare
            endif
            if TimeMove == TimeRound - 1 then
                call BlzFrameSetText(FRAME_RoundTimer, "|c00FFFF00Round Starts now!")
            else
                if time >= 59 and FirstTime == 0 then
                    if FRAME_RoundCountSec > 49 then
                        call BlzFrameSetText(FRAME_RoundTimer, "Round Starts: |c00FFFF00" + I2S(1 - FRAME_RoundCountMin ) + ":0" + I2S(time - FRAME_RoundCountSec))
                    else
                        call BlzFrameSetText(FRAME_RoundTimer, "Round Starts: |c00FFFF00" + I2S(1 - FRAME_RoundCountMin) + ":" + I2S(time - FRAME_RoundCountSec))
                    endif
                else
                    if FRAME_RoundCountSec > 50 then
                        call BlzFrameSetText(FRAME_RoundTimer, "Round Starts: |c00FFFF00" + "0" + I2S(time - FRAME_RoundCountSec))
                    else
                        call BlzFrameSetText(FRAME_RoundTimer, "Round Starts: |c00FFFF00" + I2S(time - FRAME_RoundCountSec))
                    endif
                endif
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
        if FRAME_GameTimerMin == 2 then
            set i = 0
            loop
                exitwhen i > 20
                if Hero_ID0_Dummy[i] != null then
                    call RemoveUnit(Hero_ID0_Dummy[i])
                endif
                if Hero_ID1_Dummy[i] != null then
                    call RemoveUnit(Hero_ID1_Dummy[i])
                endif
                if Hero_ID2_Dummy[i] != null then
                    call RemoveUnit(Hero_ID2_Dummy[i])
                endif
                if Hero_ID3_Dummy[i] != null then
                    call RemoveUnit(Hero_ID3_Dummy[i])
                endif
                if Hero_ID4_Dummy[i] != null then
                    call RemoveUnit(Hero_ID4_Dummy[i])
                endif
                set i = i + 1
            endloop
        endif
        if FRAME_GameTimerHour == 0 then
            if FRAME_GameTimerMin < 10 then
                if FRAME_GameTimerSec < 10 then
                    call BlzFrameSetText(FRAME_GameTimer, "Game Timer: |c00FFFF00" + "0" + I2S(FRAME_GameTimerMin) + ":0" + I2S(FRAME_GameTimerSec))
                else
                    call BlzFrameSetText(FRAME_GameTimer, "Game Timer: |c00FFFF00" + "0" + I2S(FRAME_GameTimerMin) + ":" + I2S(FRAME_GameTimerSec))
                endif
            else
                if FRAME_GameTimerSec < 10 then
                    call BlzFrameSetText(FRAME_GameTimer, "Game Timer: |c00FFFF00" + I2S(FRAME_GameTimerMin) + ":0" + I2S(FRAME_GameTimerSec))
                else
                    call BlzFrameSetText(FRAME_GameTimer, "Game Timer: |c00FFFF00" + I2S(FRAME_GameTimerMin) + ":" + I2S(FRAME_GameTimerSec))
                endif
            endif
        else
            if FRAME_GameTimerMin < 10 then
                if FRAME_GameTimerSec < 10 then
                    call BlzFrameSetText(FRAME_GameTimer, "Game Timer: |c00FFFF00" + I2S(FRAME_GameTimerHour) + ":0" + I2S(FRAME_GameTimerMin) + ":0" + I2S(FRAME_GameTimerSec))
                else
                    call BlzFrameSetText(FRAME_GameTimer, "Game Timer: |c00FFFF00" + I2S(FRAME_GameTimerHour) + ":0" + I2S(FRAME_GameTimerMin) + ":" + I2S(FRAME_GameTimerSec))
                endif
            else
                if FRAME_GameTimerSec < 10 then
                    call BlzFrameSetText(FRAME_GameTimer, "Game Timer: |c00FFFF00" + I2S(FRAME_GameTimerHour) + ":" + I2S(FRAME_GameTimerMin) + ":0" + I2S(FRAME_GameTimerSec))
                else
                    call BlzFrameSetText(FRAME_GameTimer, "Game Timer: |c00FFFF00" + I2S(FRAME_GameTimerHour) + ":" + I2S(FRAME_GameTimerMin) + ":" + I2S(FRAME_GameTimerSec))
                endif
            endif
        endif
        set d = null
    endfunction
    function FrameAlt_Show_True takes nothing returns nothing
        local integer i = 0
        local player p = GetTriggerPlayer()
        local integer id = GetPlayerId(p)
        if FRAME_StatusHeroStringPlayerShowBoolean[id] == false then
            set FRAME_StatusHeroStringPlayerShowBoolean[id] = true
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(FRAME_StatsMain , true)
                call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF" + R2SW(PlayerDamageTakenMag[id], 0, 2) + "Mag|r/|cffff0000" + R2SW(PlayerDamageTakenPhys[id], 0, 2) + "Phys|r")
            endif
            loop
                exitwhen i == 10
                if Hero[i] != null then
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[i], "|c00FFFF00Kills: |r" + I2S(PlayerKill[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[i], "|c00A74FFFDeaths: |r" + I2S(PlayerDeath[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "|cffff0000Phys: |r" + FormatK(PlayerDamagePhys[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "|c004675FFMag: |r" + FormatK(PlayerDamageMag[i]) + "")
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
        local integer check = LoadInteger(hs, GetHandleId(Player(id)), StringHash("stats left"))
        
         if FRAME_StatusHeroStringPlayerShowBoolean[id] == false then
            set FRAME_StatusHeroStringPlayerShowBoolean[id] = true
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(FRAME_StatsMain , true)
                call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF" + R2SW(PlayerDamageTakenMag[id], 0, 2) + "Mag|r/|cffff0000" + R2SW(PlayerDamageTakenPhys[id], 0, 2) + "Phys|r")
            endif
            loop
                exitwhen i == 10
                if Hero[i] != null then
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[i], "|c00FFFF00Kills: |r" + I2S(PlayerKill[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[i], "|c00A74FFFDeaths: |r" + I2S(PlayerDeath[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "|cffff0000Phys: |r" + FormatK(PlayerDamagePhys[i]) + "")
                        call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "|c004675FFMag: |r" + FormatK(PlayerDamageMag[i]) + "")
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
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF" + R2SW(GetPlayerTakenMag(p), 0, 2) + "%Mag|r/|cffff0000" + R2SW(GetPlayerTakenPhys(p), 0, 2) + "%Phys|r")
        endif
        loop
            exitwhen i == 10
            if Hero[i] != null then
                if GetLocalPlayer() == p then
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[i], "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[i], "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "")
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
        if clicked == FRAME_ShopButtonCheck then
            if BlzGetTriggerFrameEvent() == FRAMEEVENT_CHECKBOX_CHECKED then
                set PlayerShopButton[i] = null
                call DisplayTextToPlayer(Player(i), 0, 0, "Press |c00FFFC01'Tab'|r or |c00FFFC01'I'|r or |c00FFFC01'B'|r or |c00FFFC01'0'|r to change Shop hotkey")
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
    call BlzFrameSetText(f, "")   // очистить
    call BlzFrameSetText(f,"discord.gg/WpDnAQKayS")    // вернуть -> выделится
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
        call BlzFrameSetText(FRAME_LINK,"discord.gg/WpDnAQKayS")
        endif
    endif
    if clicked == FRAME_LINK4 then 
    if GetLocalPlayer() == p then
        call BlzFrameSetText(FRAME_LINK,"discord.gg/WpDnAQKayS")
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
        local real x = -0.395
        local real y = 0.005
        local real r = 0.1
        local framehandle border
        local timer t = CreateTimer()
        set FrameClickHeroMain = CreateTrigger()
        set FrameEnterHeroMain = CreateTrigger()
        set FrameLeaveHeroMain = CreateTrigger()
        set FrameAltHeroMainOn = CreateTrigger()
        set FrameAltHeroMainOff = CreateTrigger()
        set FrameBoxCheck = CreateTrigger()
        set FrameSliderCheck = CreateTrigger()
        loop
            exitwhen i == bj_MAX_PLAYER_SLOTS
            call BlzTriggerRegisterPlayerKeyEvent( FrameAltHeroMainOn, Player(i), OSKEY_F2 , 0, true)
            call BlzTriggerRegisterPlayerKeyEvent( FrameAltHeroMainOff, Player(i), OSKEY_F2 , 0, false)
            set i = i + 1
        endloop
       // call TriggerAddAction( FrameAltHeroMainOn, function FrameAlt_Show_True )
        call TriggerAddAction( FrameAltHeroMainOff, function FrameAlt_Show_False )
    // === Главный контейнер ===
        set FRAME_StatusHeroMain = BlzCreateFrame("EscMenuBackdrop", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        call BlzFrameSetAbsPoint(FRAME_StatusHeroMain, FRAMEPOINT_CENTER, 0.36, 0.53)
        call BlzFrameSetAlpha(FRAME_StatusHeroMain, 0)
        call BlzFrameSetSize(FRAME_StatusHeroMain, 0.95, 0.12)
        set FRAME_StatusHeroMain2 = BlzCreateFrame("EscMenuBackdrop", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        call BlzFrameSetAbsPoint(FRAME_StatusHeroMain2, FRAMEPOINT_CENTER, 0.3, 0.16)
        call BlzFrameSetAlpha(FRAME_StatusHeroMain2, 0)
        call BlzFrameSetSize(FRAME_StatusHeroMain2, 0.38, 0.06)
        set FRAME_StatusHeroMain3 = BlzCreateFrame("EscMenuBackdrop", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        call BlzFrameSetAbsPoint(FRAME_StatusHeroMain3, FRAMEPOINT_CENTER, 0.445, 0.5375)
        call BlzFrameSetAlpha(FRAME_StatusHeroMain3, 0)
        call BlzFrameSetSize(FRAME_StatusHeroMain3, 0.06, 0.025)
        set FRAME_TopCheckbox = BlzCreateFrame("QuestCheckBox2", FRAME_StatusHeroMain3, 0, 0)
        call BlzFrameSetSize(FRAME_TopCheckbox, 0.02, 0.02)
        call BlzFrameSetAlpha(FRAME_TopCheckbox, 255)
        call BlzFrameSetPoint(FRAME_TopCheckbox, FRAMEPOINT_CENTER, FRAME_StatusHeroMain3, FRAMEPOINT_CENTER, 0, 0.0235)// - 0.03 * i)
        call BlzTriggerRegisterFrameEvent(FrameBoxCheck, FRAME_TopCheckbox, FRAMEEVENT_CHECKBOX_CHECKED)
        call BlzTriggerRegisterFrameEvent(FrameBoxCheck, FRAME_TopCheckbox, FRAMEEVENT_CHECKBOX_UNCHECKED)
        call TriggerAddAction(FrameBoxCheck, function CheckBoxCheck)
        set FRAME_TopCheckboxString = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHeroMain3, "", 0)
        call BlzFrameSetSize(FRAME_TopCheckboxString, 0.06, 0.005)
        call BlzFrameSetAlpha(FRAME_TopCheckboxString, 255)
        call BlzFrameSetPoint(FRAME_TopCheckboxString, FRAMEPOINT_CENTER, FRAME_StatusHeroMain3, FRAMEPOINT_CENTER, 0.04, 0.0255)// - 0.03 * i)
        call BlzFrameSetText(FRAME_TopCheckboxString, "|c00FFFF00Hide UI|r")
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
        set r = 0.057
        loop
            exitwhen i == 10
            set FRAME_StatusHeroStringPlayerShowBoolean[i] = false
            set FRAME_StatusHero[i] = BlzCreateFrameByType("BUTTON", "MyStatusButton", FRAME_StatusHeroMain, "ScoreScreenTabButtonTemplate", 0)
            set FRAME_StatusHeroBack[i] = BlzCreateFrameByType("BACKDROP", "MyStatusButtonIcon", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetAllPoints(FRAME_StatusHeroBack[i], FRAME_StatusHero[i])
            call BlzFrameSetPoint(FRAME_StatusHero[i], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, x + r * k, y )// - 0.03 * i)
            call BlzFrameSetSize(FRAME_StatusHero[i], 0.04, 0.04)
            call BlzFrameSetLevel(FRAME_StatusHero[i], 10)
            call BlzFrameSetLevel(FRAME_StatusHeroBack[i], 10)
            call BlzFrameSetAlpha(FRAME_StatusHero[i], 255)
            call BlzFrameSetAlpha(FRAME_StatusHeroBack[i], 255)
            call BlzTriggerRegisterFrameEvent(FrameClickHeroMain, FRAME_StatusHero[i], FRAMEEVENT_CONTROL_CLICK)
            call BlzTriggerRegisterFrameEvent(FrameEnterHeroMain, FRAME_StatusHero[i], FRAMEEVENT_MOUSE_ENTER)
            call BlzTriggerRegisterFrameEvent(FrameLeaveHeroMain, FRAME_StatusHero[i], FRAMEEVENT_MOUSE_LEAVE)
            call BlzFrameSetTexture(FRAME_StatusHeroBack[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
            set FRAME_StatusHeroStringPlayerName[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerName[i], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, x + r * k, y - 0.03 )// - 0.03 * i)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerName[i], "|c00FFFF00" + "" + "|r")
            set FRAME_StatusHeroStringPlayerKill[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerKill[i], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, x + r * k, y - 0.045 )// - 0.03 * i)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[i], "|c00FFFF00" + "" + "|r")
            set FRAME_StatusHeroStringPlayerDeath[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDeath[i], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, x + r * k, y - 0.055 )// - 0.03 * i)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[i], "|c00FFFF00" + "" + "|r")
            set FRAME_StatusHeroStringPlayerDamagePhys[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamagePhys[i], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, x + r * k, y - 0.065 )// - 0.03 * i)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i], "|c00FFFF00" + "" + "|r")
            set FRAME_StatusHeroStringPlayerDamageMag[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)
            call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerDamageMag[i], FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, x + r * k, y - 0.075 )// - 0.03 * i)
            call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i], "|c00FFFF00" + "" + "|r")
            set k = k + 1
            if k == 5 then
                set x = x + 0.3425
            endif
            set i = i + 1
        endloop
        set x = x - 0.36
        set k = 5
        set FRAME_StatusHeroStringPlayerTakenDamageMag = BlzCreateFrameByType("TEXT", "MyPlayerName1", FRAME_StatusHeroMain2, "", 0)
        call BlzFrameSetPoint(FRAME_StatusHeroStringPlayerTakenDamageMag, FRAMEPOINT_LEFT, FRAME_StatusHeroMain2, FRAMEPOINT_CENTER, -0.065, -0.005 )// - 0.03 * i)
        call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF" + I2S(0) + "%Mag|r/|cffff0000" + I2S(0) + "%Phys|r")
        call BlzFrameSetScale(FRAME_StatusHeroStringPlayerTakenDamageMag, 1.3)
        call BlzFrameSetSize(FRAME_StatusHeroStringPlayerTakenDamageMag, 0.2, 0.005)
        call BlzFrameSetAlpha(FRAME_StatusHeroStringPlayerTakenDamageMag, 255)
        call BlzFrameSetVisible(FRAME_StatusHeroMain2, false)
        set FRAME_RoundCount = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHeroMain, "", 0)
        call BlzFrameSetPoint(FRAME_RoundCount, FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, x + 0.055 + r * k, y - 0.01 )// - 0.03 * i)
        call BlzFrameSetText(FRAME_RoundCount, "Round: |c00FFFF00" + I2S(CurrentRound) + "|r")
        call BlzFrameSetScale(FRAME_RoundCount, 1.4)
        call BlzFrameSetAlpha(FRAME_RoundCount, 255)
        set k = 7
        set FRAME_RoundTimer = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHeroMain, "", 0)
        call BlzFrameSetPoint(FRAME_RoundTimer, FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, x + r * k, y - 0.0125 )// - 0.03 * i)
        call BlzFrameSetText(FRAME_RoundTimer, "Round Ends: |c00FFFF00" + I2S(CurrentRound) + "|r")
        call BlzFrameSetScale(FRAME_RoundTimer, 1.2)
        call BlzFrameSetAlpha(FRAME_RoundTimer, 255)
        set k = 9
        set FRAME_GameTimer = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHeroMain, "", 0)
        call BlzFrameSetPoint(FRAME_GameTimer, FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, x + r * k, y - 0.0125 )// - 0.03 * i)
        call BlzFrameSetText(FRAME_GameTimer, "Game Time: |c00FFFF00" + I2S(CurrentRound) + "|r")
        call BlzFrameSetAlpha(FRAME_GameTimer, 255)
        call BlzFrameSetScale(FRAME_RoundTimer, 1.1)
        set k = 6
        set x = -0.418
        set FRAME_Team1Rounds = BlzCreateFrameByType("TEXT", "MyPlayerScore1", FRAME_StatusHeroMain, "", 0)
        call BlzFrameSetPoint(FRAME_Team1Rounds, FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, x + 0.01 + r * k, y + 0.0025 )// - 0.03 * i)
        call BlzFrameSetText(FRAME_Team1Rounds, "|cffff0000" + I2S(Team1Round) + "/" + I2S(MaxRounds ) + "|r")
        call BlzFrameSetScale(FRAME_Team1Rounds, 1.65)
        call BlzFrameSetAlpha(FRAME_Team1Rounds, 255)
        set x = x + 0.3475
        set k = 3
        set FRAME_Team2Rounds = BlzCreateFrameByType("TEXT", "MyPlayerScore2", FRAME_StatusHeroMain, "", 0)
        call BlzFrameSetPoint(FRAME_Team2Rounds, FRAMEPOINT_LEFT, FRAME_StatusHeroMain, FRAMEPOINT_CENTER, x + 0.01 + r * k, y + 0.0025 )// - 0.03 * i)
        call BlzFrameSetText(FRAME_Team2Rounds, "|c002F63FF" + I2S(Team2Round) + "/" + I2S(MaxRounds ) + "|r")
        call BlzFrameSetScale(FRAME_Team2Rounds, 1.65)
        call BlzFrameSetAlpha(FRAME_Team2Rounds, 255)
        call TriggerAddAction(FrameClickHeroMain, function OnClickStatusHero)
        call TriggerAddAction(FrameEnterHeroMain, function StatusHeroEnterItem)
        call TriggerAddAction(FrameLeaveHeroMain, function StatusHeroLeaveItem)
        call TimerStart(t, 1, true, function PlayerStatusHeroPeriodic)
        call BlzFrameSetVisible(FRAME_StatusHeroMain, false)
        call BlzFrameSetVisible(FRAME_StatusHeroMain3, false)
        call BlzFrameSetVisible(FRAME_StatusHeroMain4, false)
        call BlzLoadTOCFile("war3mapImported\\Templates.toc")
        
         /* 
        set FRAME_TEST = BlzCreateFrameByType("TEXT", "MyPlayerName1", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 0)
        call BlzFrameSetPoint(FRAME_TEST, FRAMEPOINT_CENTER, BlzGetFrameByName("ConsoleUIBackdrop", 0), FRAMEPOINT_CENTER, -0.295, 0.25 )// - 0.03 * i)
        call BlzFrameSetText(FRAME_TEST, "|c00FFFF00AA112s|r")
        call BlzFrameSetScale(FRAME_TEST, 1.3)
        call BlzFrameSetSize(FRAME_TEST, 0.2, 0.005)
        call BlzFrameSetAlpha(FRAME_TEST, 255)
        call BlzFrameSetVisible(FRAME_TEST, true)
         */ 
         /* call BlzLoadTOCFile("war3mapImported\\Templates.toc")
        set FRAME_TEST4 = BlzCreateFrameByType("BACKDROP", "SS", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 0)
        call BlzFrameSetAbsPoint(FRAME_TEST4, FRAMEPOINT_CENTER, 0.055, 0.18)
        call BlzFrameSetSize(FRAME_TEST4, 0.135, 0.035)
        call BlzFrameSetTexture(FRAME_TEST4, "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
        set FRAME_TEST = BlzCreateFrame("EscMenuControlBackdropTemplate", FRAME_TEST4, 0, 0)
        call BlzFrameSetAbsPoint(FRAME_TEST, FRAMEPOINT_CENTER, 0.07, 0.185)
        call BlzFrameSetSize(FRAME_TEST, 0.1, 0.019)
        set FRAME_TEST2 = BlzCreateFrameByType("STATUSBAR", "", FRAME_TEST4, "", 0)
        call BlzFrameSetSize(FRAME_TEST2, 0.1, 0.035)
        call BlzFrameSetScale(FRAME_TEST2, 0.5)
        call BlzFrameSetModel(FRAME_TEST2, "ui/feedback/XpBar/XpBarConsole.mdx", 0)
        call BlzFrameSetAbsPoint(FRAME_TEST2, FRAMEPOINT_CENTER, 0.05, 0.175)
        //call BlzFrameSetTexture(FRAME_TEST2, "ui\\feedback\\xpbar\\human-bigbar-fill", 0, true)
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
        set y = -0.03
        set FRAME_StatsMain = BlzCreateFrame("EscMenuTextAreaTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        call BlzFrameSetAbsPoint(FRAME_StatsMain, FRAMEPOINT_CENTER, -0.0525, 0.34)
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
        call BlzFrameSetSize(FRAME_ShopButtonCheck, 0.02, 0.02)
        call BlzFrameSetAlpha(FRAME_ShopButtonCheck, 255)
        call BlzFrameSetPoint(FRAME_ShopButtonCheck, FRAMEPOINT_CENTER, FRAME_StatusHeroMain3, FRAMEPOINT_CENTER, 0.07, 0.0235)
        call BlzTriggerRegisterFrameEvent(FrameBoxCheck, FRAME_ShopButtonCheck, FRAMEEVENT_CHECKBOX_CHECKED)
        call BlzTriggerRegisterFrameEvent(FrameBoxCheck, FRAME_ShopButtonCheck, FRAMEEVENT_CHECKBOX_UNCHECKED)
        set FRAME_ShopButtonText = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHeroMain3, "", 0)
        call BlzFrameSetSize(FRAME_ShopButtonText, 0.1, 0.01)
        call BlzFrameSetAlpha(FRAME_ShopButtonText, 255)
        call BlzFrameSetPoint(FRAME_ShopButtonText, FRAMEPOINT_CENTER, FRAME_StatusHeroMain3, FRAMEPOINT_CENTER, 0.1325, 0.0235)
        call BlzFrameSetText(FRAME_ShopButtonText, "|c00FFFF00Shop Key|r")
        
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
    call BlzFrameSetText(FRAME_LINK,"discord.gg/WpDnAQKayS")    
    call BlzFrameSetVisible(FRAME_LINK,false)
    call BlzFrameSetVisible(FRAME_LINK2,false)    
    call BlzFrameSetVisible(FRAME_LINK4,false)
    
        set FrameLinkMain = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(FrameLinkMain, FRAME_LINK, FRAMEEVENT_EDITBOX_ENTER)
    call TriggerAddAction(FrameLinkMain, function OnEditBoxFocus)
    
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
        set t = null
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
