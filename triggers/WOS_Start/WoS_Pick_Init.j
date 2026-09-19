// WoS Hero Pick — основной код с вынесенным Captain Mode.
// Требуется отдельный CaptainMode_Module.j, подключённый перед этим кодом.
// Все ветки GetLocalPlayer содержат только прямые операции BlzFrame*.

globals
    integer array BanCandidateHero
endglobals
globals
    
    integer BanLockTime = 3
boolean BanSelectionLocked = false
endglobals

globals
    integer MaxHeroBans = 4          // Р РЋР С“Р В РЎвЂќР В РЎвЂўР В Р’В»Р РЋР Р‰Р В РЎвЂќР В РЎвЂў Р В РЎвЂ“Р В Р’ВµР РЋР вЂљР В РЎвЂўР В Р’ВµР В Р вЂ  Р В Р’В±Р В Р’В°Р В Р вЂ¦Р В РЎвЂР РЋРІР‚С™Р РЋР С“Р РЋР РЏ Р В Р’В·Р В Р’В° Р В РЎвЂР В РЎвЂ“Р РЋР вЂљР РЋРЎвЂњ Р Р†Р вЂљРІР‚Сњ Р В РЎВР В Р’ВµР В Р вЂ¦Р РЋР РЏР В РІвЂћвЂ“ Р РЋРІР‚С™Р РЋРЎвЂњР РЋРІР‚С™
    // =========================================================================
    // BAN IMMUNITY: put the three protected hero rawcodes here.
    // Example: integer BanImmuneHero1 = 'H00A'
    // Leave a slot equal to 0 when it is not used.
    integer BanImmuneHero1 = Milim_ID
    integer BanImmuneHero2 = 0
    integer BanImmuneHero3 = 0
    // =========================================================================
    integer CanPickRandom = 0
    integer array BanProposalHero    // pid -> Р В РЎвЂ”Р РЋР вЂљР В Р’ВµР В РўвЂР В Р’В»Р В РЎвЂўР В Р’В¶Р В Р’ВµР В Р вЂ¦Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р В Р вЂ¦Р В Р’В° Р В Р’В±Р В Р’В°Р В Р вЂ¦ hero type id (0 = Р В Р вЂ¦Р В Р’ВµР РЋРІР‚С™ Р В РЎвЂ”Р РЋР вЂљР В Р’ВµР В РўвЂР В Р’В»Р В РЎвЂўР В Р’В¶Р В Р’ВµР В Р вЂ¦Р В РЎвЂР РЋР РЏ)
    integer array BanCandidatePid    // Р В Р вЂ Р РЋР вЂљР В Р’ВµР В РЎВР В Р’ВµР В Р вЂ¦Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р РЋР С“Р В РЎвЂ”Р В РЎвЂР РЋР С“Р В РЎвЂўР В РЎвЂќ pid Р РЋР С“ Р В Р’В°Р В РЎвЂќР РЋРІР‚С™Р В РЎвЂР В Р вЂ Р В Р вЂ¦Р РЋРІР‚в„–Р В РЎВ Р В РЎвЂ”Р РЋР вЂљР В Р’ВµР В РўвЂР В Р’В»Р В РЎвЂўР В Р’В¶Р В Р’ВµР В Р вЂ¦Р В РЎвЂР В Р’ВµР В РЎВ
    integer BanCandidateCount = 0
    integer array BannedHeroType
    // Keeps the original hero type for a slot after SetHeroId replaces it with 12.
    // Without this array ReloadHeroPage only sees 12 and cannot build the DISBTN path.
    integer array BanLockedHeroTypeBySlot
    integer BannedHeroCount = 0
    boolean BanPhaseActive = false   // Р В РЎвЂР В РўвЂР РЋРІР‚ВР РЋРІР‚С™ Р В Р’В°Р В Р вЂ¦Р В РЎвЂР В РЎВР В Р’В°Р РЋРІР‚В Р В РЎвЂР РЋР РЏ/Р РЋР вЂљР В РЎвЂўР В Р’В·Р РЋРІР‚в„–Р В РЎвЂ“Р РЋР вЂљР РЋРІР‚в„–Р РЋРІвЂљВ¬ Р В Р’В±Р В Р’В°Р В Р вЂ¦Р В Р’В° Р В РЎвЂ”Р РЋР вЂљР РЋР РЏР В РЎВР В РЎвЂў Р РЋР С“Р В Р’ВµР В РІвЂћвЂ“Р РЋРІР‚РЋР В Р’В°Р РЋР С“
    boolean BanPhaseTriggered = false // Р РЋРІР‚С›Р В Р’В°Р В Р’В·Р В Р’В° Р В Р’В±Р В Р’В°Р В Р вЂ¦Р В Р’В° Р РЋРЎвЂњР В Р’В¶Р В Р’Вµ Р В Р’В±Р РЋРІР‚в„–Р В Р’В»Р В Р’В° Р В Р’В·Р В Р’В°Р В РЎвЂ”Р РЋРЎвЂњР РЋРІР‚В°Р В Р’ВµР В Р вЂ¦Р В Р’В° Р В РЎвЂўР В РўвЂР В РЎвЂР В Р вЂ¦ Р РЋР вЂљР В Р’В°Р В Р’В·
    integer BanRevealIndex = 0
    integer BanRevealStep = 0
    integer BanRevealTotalSteps = 0
    integer BanPhaseStage = 0        // 0 = Р В Р вЂ Р РЋР вЂљР В Р’В°Р РЋРІР‚В°Р В Р’ВµР В Р вЂ¦Р В РЎвЂР В Р’Вµ, 1 = Р В РЎвЂ”Р В Р’В°Р РЋРЎвЂњР В Р’В·Р В Р’В° Р В РЎвЂ”Р В РЎвЂўР РЋР С“Р В Р’В»Р В Р’Вµ Р В РЎвЂ”Р В РЎвЂўР В РЎвЂќР В Р’В°Р В Р’В·Р В Р’В° Р РЋР вЂљР В Р’ВµР В Р’В·Р РЋРЎвЂњР В Р’В»Р РЋР Р‰Р РЋРІР‚С™Р В Р’В°Р РЋРІР‚С™Р В Р’В°
    integer BanLastBannedPid = -1
    framehandle FRAME_BanSpinSprite
    framehandle array FRAME_BanHighlight
endglobals
globals
integer RoundJustStarted = 0
integer PrepJustStarted = 0
    integer PlayerCountValue = 0
    integer Round1Started = 0
    unit array Hero
    unit array HeroChosen


    integer Time_Sukuna = 120
    integer Time_RoundEnd = 270
    integer array PickedOnce
    integer AddRandom = 500
    trigger FrameClick
    trigger FrameGuideRefresh
    oskeytype array PlayerShopButton
    integer firstroundinit = 0
    integer ComebackStat1 = 'A0CS'
    integer ComebackStat2 = 'A0CT'
    integer ComebackStat3 = 'A0CU'
    integer ComebackStat4 = 'A0CV'
    integer ComebackStat5 = 'A0CW'
    framehandle array FRAME_Repick
    framehandle array FRAME_RepickHover
    framehandle array FRAME_RepickText
    framehandle array FRAME_Swap
    framehandle array FRAME_SwapSprite
    framehandle array FRAME_SwapSprite2
    integer array FRAME_SwapActive
    integer array SwapRequests
    framehandle array FRAME_SwapHover
    framehandle array FRAME_SwapText
    framehandle FRAME_MAIN
    framehandle FRAME_MAIN2
    framehandle FRAME_MAIN3
    framehandle FRAME_HeroAttribute
    framehandle FRAME_HeroAttackType
    framehandle FRAME_HeroStr
    framehandle FRAME_HeroAgi
    framehandle FRAME_HeroInt
    framehandle FRAME_HeroAtk
    framehandle FRAME_HeroArmor
    framehandle FRAME_HeroMS
    framehandle FRAME_HeroAS
    framehandle FRAME_HeroName
    framehandle FRAME_HeroNameBack
    framehandle FRAME_TimerToStart
    framehandle FRAME_SpellTooltip
    framehandle FRAME_SpellTooltipName
    framehandle FRAME_SpellTooltipBack
    framehandle FRAME_HeroModel
    framehandle FRAME_HeroModel2
    framehandle array FRAME_Pick
    framehandle array FRAME_ICON_Pick
    framehandle array FRAME_ICON
    framehandle array FRAME_ICON2
    framehandle array Frame_PageHeroList
    framehandle array Frame_PageHeroListImage
    framehandle array FRAME_ICON5
    framehandle array FRAME_ICON6
    // Нативные tooltip-фреймы Q/W/E/R/T/F/G. Движок сам показывает и скрывает их.
    framehandle array FRAME_AbilityTooltip
    framehandle array FRAME_AbilityTooltipText
    // Служебное состояние для предварительного заполнения tooltip при выборе героя.
    // На события мыши эта логика больше не подписана.
    integer GuideTooltipRefreshSlot = -1
    player GuideTooltipRefreshPlayer = null
    framehandle array FRAME_AbiText
    framehandle array FRAME_PlayerPickText
    framehandle FRAME_PlayerPickDifficultText
    framehandle array FRAME_PlayerPickTextUpperBack
    framehandle array FRAME_PlayerPickTextUpper
    framehandle array FRAME_PlayerPick
    string array FRAME_PlayerPickString
    framehandle array FRAME_PlayerPickBack
    integer array PlayerSoundCurrent
    integer array PlayerFrameCurrent_ID
    framehandle array PlayerFrameCurrentFrame_ID
    integer array PlayerFrameCurrentPage_ID
    sound array PlayerSoundIntro_ID
    integer array Hero_ID0
    unit array Hero_ID0_Dummy
    integer array Hero_ID1
    unit array Hero_ID1_Dummy
    integer array Hero_ID2
    unit array Hero_ID2_Dummy
    integer array Hero_ID3
    unit array Hero_ID3_Dummy
    integer array Hero_ID4
    unit array Hero_ID4_Dummy
    integer array Hero_ID5
    unit array Hero_ID5_Dummy
    timer IntroStart1
    timer TojiZeroManaTimer = null
    integer TimeMove = 0
    integer PrePickTime = 15 // countdown before pick opens
    boolean PickPhaseActive = false
    real BaseCam = 3800
    integer TimeRound = 120
    integer array PC_R
    integer array PC_G
    integer array PC_B
    integer END1 = 0
    integer END2 = 0
    integer END3 = 0
    boolean BotStatsNineWinCheckDone = false
    boolean BotStatsNineWinEligible = false
    integer BotStatsPlayersAtNineWins = 0
    integer MaxHeroes = 0
    fogmodifier array PlayerVision
    integer CondArena = 0 // 0 - prepare, 1 - arena
    string array FramePlayerFirstNameBase
    string array FramePlayerFirstName
    integer RandomAllPlayers = 0 // Р РЋР РЉР РЋРІР‚С™Р В Р’В° Р В РЎвЂ”Р В Р’ВµР РЋР вЂљР В Р’ВµР В РЎВР В Р’ВµР В Р вЂ¦Р В Р вЂ¦Р В Р’В°Р РЋР РЏ Р В РЎвЂўР РЋРІР‚С™Р В Р вЂ Р В Р’ВµР РЋРІР‚РЋР В Р’В°Р В Р’ВµР РЋРІР‚С™ Р В Р’В·Р В Р’В° Р В РЎвЂўР В РўвЂР В Р вЂ¦Р В РЎвЂўР РЋР вЂљР В Р’В°Р В Р’В·Р В РЎвЂўР В Р вЂ Р В РЎвЂўР В Р’Вµ Р РЋР С“Р РЋР вЂљР В Р’В°Р В Р’В±Р В Р’В°Р РЋРІР‚С™Р РЋРІР‚в„–Р В Р вЂ Р В Р’В°Р В Р вЂ¦Р В РЎвЂР В Р’Вµ Р РЋР вЂљР В Р’В°Р В Р вЂ¦Р В РўвЂР В РЎвЂўР В РЎВР В Р’В° Р В РўвЂР В Р’В»Р РЋР РЏ Р В Р вЂ Р РЋР С“Р В Р’ВµР РЋРІР‚В¦ Р В РЎвЂ”Р В РЎвЂў Р В РЎвЂР РЋР С“Р РЋРІР‚С™Р В Р’ВµР РЋРІР‚РЋР В Р’ВµР В Р вЂ¦Р В РЎвЂР РЋР вЂ№ Р РЋРІР‚С™Р В Р’В°Р В РІвЂћвЂ“Р В РЎВР В Р’ВµР РЋР вЂљР В Р’В° Р В РЎвЂ”Р В РЎвЂР В РЎвЂќР В Р’В°
    integer FirstTime = 0 // Р В РЎвЂ”Р В Р’ВµР РЋР вЂљР В Р’ВµР В РЎВР В Р’ВµР В Р вЂ¦Р В Р вЂ¦Р В Р’В°Р РЋР РЏ Р В РўвЂР В Р’В»Р РЋР РЏ Р РЋРІР‚С›Р В РЎвЂР В РЎвЂќР РЋР С“Р В Р’В° Р В РЎвЂ”Р В Р’ВµР РЋР вЂљР В Р вЂ Р В РЎвЂўР В РЎвЂ“Р В РЎвЂў Р В РўвЂР В РЎвЂўР В Р’В»Р В РЎвЂ“Р В РЎвЂўР В РЎвЂ“Р В РЎвЂў Р В РЎвЂўР РЋРІР‚С™Р РЋР С“Р РЋРІР‚РЋР В Р’ВµР РЋРІР‚С™Р В Р’В° Р РЋРІР‚С™Р В Р’В°Р В РІвЂћвЂ“Р В РЎВР В Р’ВµР РЋР вЂљР В Р’В°, Р В РЎвЂќР В РЎвЂўР В РЎвЂ“Р В РўвЂР В Р’В° Р В Р’В±Р РЋРЎвЂњР В РўвЂР В Р’ВµР РЋРІР‚С™ Р РЋР вЂљР В Р’В°Р В Р вЂ Р В Р вЂ¦Р В Р’В° Р В Р’ВµР В РўвЂР В РЎвЂР В Р вЂ¦Р В РЎвЂР РЋРІР‚В Р В Р’Вµ Р РЋРІР‚С™Р В Р’В°Р В РІвЂћвЂ“Р В РЎВР В Р’ВµР РЋР вЂљ Р В Р’В±Р РЋРЎвЂњР В РўвЂР В Р’ВµР РЋРІР‚С™ Р РЋР С“Р РЋРІР‚РЋР В РЎвЂР РЋРІР‚С™Р В Р’В°Р РЋРІР‚С™Р РЋР Р‰ Р В РЎвЂ”Р В РЎвЂў Р В РЎвЂўР В Р’В±Р РЋРІР‚в„–Р РЋРІР‚РЋР В Р вЂ¦Р В РЎвЂўР В РЎВР РЋРЎвЂњ
    real r_ping = 1
    real r_train = 1
endglobals
// Captain Mode: функция SetPlayerVisualPosition перенесена в CaptainMode_Module.j

// Captain Mode: функция MarkStatusPlayerLeft перенесена в CaptainMode_Module.j

// Captain Mode: функция RearrangeTeamUI перенесена в CaptainMode_Module.j
// Captain Mode: функция SetTeamAlliances перенесена в CaptainMode_Module.j

// Captain Mode: функция GetCurrentCaptainPid перенесена в CaptainMode_Module.j

// Captain Mode: функция UpdatePickText перенесена в CaptainMode_Module.j

// Captain Mode: функция AddPlayerToTeam перенесена в CaptainMode_Module.j

// Captain Mode: функция RandomPickRemaining перенесена в CaptainMode_Module.j

// CapPickPlayerTime Р В РЎвЂўР В Р’В±Р РЋР вЂ°Р РЋР РЏР В Р вЂ Р В Р’В»Р В Р’ВµР В Р вЂ¦Р В Р’В° Р В РЎСџР В РІР‚СћР В Р’В Р В РІР‚в„ўР В РЎвЂєР В РІвЂћСћ Р Р†Р вЂљРІР‚Сњ Р В Р вЂ Р В Р вЂ¦Р РЋРЎвЂњР РЋРІР‚С™Р РЋР вЂљР В РЎвЂ Р В РЎвЂР В Р вЂ¦Р В Р’В»Р В Р’В°Р В РІвЂћвЂ“Р В Р вЂ¦ Р В Р’В»Р В РЎвЂўР В РЎвЂ“Р В РЎвЂР В РЎвЂќР В Р’В° Р В РЎвЂ”Р В Р’ВµР РЋР вЂљР В Р’ВµР РЋРІР‚В¦Р В РЎвЂўР В РўвЂР В Р’В° Р РЋРІР‚В¦Р В РЎвЂўР В РўвЂР В Р’В°
// Captain Mode: функция CapPickPlayerTime перенесена в CaptainMode_Module.j

// NextPickTurn Р В РЎвЂўР В Р’В±Р РЋР вЂ°Р РЋР РЏР В Р вЂ Р В Р’В»Р В Р’ВµР В Р вЂ¦Р В Р’В° Р В РЎСџР В РЎвЂєР В Р Р‹Р В РІР‚С”Р В РІР‚Сћ Р Р†Р вЂљРІР‚Сњ Р В Р вЂ Р РЋРІР‚в„–Р В Р’В·Р РЋРІР‚в„–Р В Р вЂ Р В Р’В°Р В Р’ВµР РЋРІР‚С™Р РЋР С“Р РЋР РЏ Р РЋРІР‚С™Р В РЎвЂўР В Р’В»Р РЋР Р‰Р В РЎвЂќР В РЎвЂў Р В РЎвЂР В Р’В· CapOnPlayerClick
// Captain Mode: функция NextPickTurn перенесена в CaptainMode_Module.j
// Captain Mode: функция CapOnPlayerClick перенесена в CaptainMode_Module.j
// Captain Mode: функция PlayerUpdateIcon перенесена в CaptainMode_Module.j
// Captain Mode: функция CreatePlayerPickUI перенесена в CaptainMode_Module.j
// ============================================================================
// Р В Р’В Р Р†Р вЂљРЎС›Р В Р’В Р СћРІР‚ВР В Р’В Р РЋРІР‚ВР В Р’В Р В РІР‚В¦Р В Р Р‹Р Р†Р вЂљРІвЂћвЂ“Р В Р’В Р Р†РІР‚С›РІР‚вЂњ Р В Р’В Р СћРІР‚ВР В Р’В Р РЋРІР‚СћР В Р Р‹Р В РЎвЂњР В Р Р‹Р Р†Р вЂљРЎв„ўР В Р Р‹Р РЋРІР‚СљР В Р’В Р РЋРІР‚вЂќ Р В Р’В Р РЋРІР‚Сњ Р В Р Р‹Р Р†Р вЂљРЎв„ўР В Р’В Р вЂ™Р’В°Р В Р’В Р вЂ™Р’В±Р В Р’В Р вЂ™Р’В»Р В Р’В Р РЋРІР‚ВР В Р Р‹Р Р†Р вЂљР’В Р В Р’В Р вЂ™Р’В°Р В Р’В Р РЋР’В Р В Р’В Р РЋРІР‚вЂњР В Р’В Р вЂ™Р’ВµР В Р Р‹Р В РІР‚С™Р В Р’В Р РЋРІР‚СћР В Р’В Р вЂ™Р’ВµР В Р’В Р В РІР‚В .
// Р В Р’В Р РЋРЎС™Р В Р’В Р РЋРІР‚СћР В Р’В Р В РІР‚В Р В Р Р‹Р Р†Р вЂљРІвЂћвЂ“Р В Р’В Р Р†РІР‚С›РІР‚вЂњ Р В Р’В Р РЋРІР‚вЂњР В Р’В Р вЂ™Р’ВµР В Р Р‹Р В РІР‚С™Р В Р’В Р РЋРІР‚СћР В Р’В Р Р†РІР‚С›РІР‚вЂњ Р В Р’В Р СћРІР‚ВР В Р’В Р РЋРІР‚СћР В Р’В Р вЂ™Р’В±Р В Р’В Р вЂ™Р’В°Р В Р’В Р В РІР‚В Р В Р’В Р вЂ™Р’В»Р В Р Р‹Р В Р РЏР В Р’В Р вЂ™Р’ВµР В Р Р‹Р Р†Р вЂљРЎв„ўР В Р Р‹Р В РЎвЂњР В Р Р‹Р В Р РЏ Р В Р’В Р В РІР‚В  Hero_IDX[slot] Р В Р’В Р РЋРІР‚СњР В Р’В Р вЂ™Р’В°Р В Р’В Р РЋРІР‚Сњ Р В Р Р‹Р В РІР‚С™Р В Р’В Р вЂ™Р’В°Р В Р’В Р В РІР‚В¦Р В Р Р‹Р В Р вЂ°Р В Р Р‹Р Р†РІР‚С™Р’В¬Р В Р’В Р вЂ™Р’Вµ, Р В Р’В Р В РІР‚В¦Р В Р’В Р РЋРІР‚Сћ Р В Р’В Р В РІР‚В Р В Р Р‹Р В РЎвЂњР В Р’В Р вЂ™Р’Вµ Р В Р’В Р РЋРІР‚СћР В Р’В Р вЂ™Р’В±Р В Р Р‹Р Р†Р вЂљР’В°Р В Р’В Р РЋРІР‚ВР В Р’В Р вЂ™Р’Вµ Р В Р Р‹Р В РЎвЂњР В Р’В Р РЋРІР‚ВР В Р Р‹Р В РЎвЂњР В Р Р‹Р Р†Р вЂљРЎв„ўР В Р’В Р вЂ™Р’ВµР В Р’В Р РЋР’ВР В Р Р‹Р Р†Р вЂљРІвЂћвЂ“
// (Р В Р Р‹Р В РЎвЂњР В Р Р‹Р Р†Р вЂљРЎв„ўР В Р Р‹Р В РІР‚С™Р В Р’В Р вЂ™Р’В°Р В Р’В Р В РІР‚В¦Р В Р’В Р РЋРІР‚ВР В Р Р‹Р Р†Р вЂљР’В Р В Р Р‹Р Р†Р вЂљРІвЂћвЂ“, Р В Р Р‹Р В РІР‚С™Р В Р’В Р вЂ™Р’В°Р В Р’В Р В РІР‚В¦Р В Р’В Р СћРІР‚ВР В Р’В Р РЋРІР‚СћР В Р’В Р РЋР’В, Р В Р’В Р РЋРІР‚вЂќР В Р’В Р РЋРІР‚ВР В Р’В Р РЋРІР‚Сњ Р В Р’В Р РЋРІР‚В Р В Р’В Р вЂ™Р’В±Р В Р’В Р вЂ™Р’В°Р В Р’В Р В РІР‚В¦) Р В Р Р‹Р Р†Р вЂљРЎв„ўР В Р’В Р вЂ™Р’ВµР В Р’В Р РЋРІР‚вЂќР В Р’В Р вЂ™Р’ВµР В Р Р‹Р В РІР‚С™Р В Р Р‹Р В Р вЂ° Р В Р’В Р В РІР‚В¦Р В Р’В Р вЂ™Р’В°Р В Р Р‹Р Р†Р вЂљР’В¦Р В Р’В Р РЋРІР‚СћР В Р’В Р СћРІР‚ВР В Р Р‹Р В Р РЏР В Р Р‹Р Р†Р вЂљРЎв„ў Р В Р’В Р вЂ™Р’ВµР В Р’В Р РЋРІР‚вЂњР В Р’В Р РЋРІР‚Сћ Р В Р’В Р вЂ™Р’В°Р В Р’В Р В РІР‚В Р В Р Р‹Р Р†Р вЂљРЎв„ўР В Р’В Р РЋРІР‚СћР В Р’В Р РЋР’ВР В Р’В Р вЂ™Р’В°Р В Р Р‹Р Р†Р вЂљРЎв„ўР В Р’В Р РЋРІР‚ВР В Р Р‹Р Р†Р вЂљР Р‹Р В Р’В Р вЂ™Р’ВµР В Р Р‹Р В РЎвЂњР В Р’В Р РЋРІР‚СњР В Р’В Р РЋРІР‚В.
function GetHeroId takes integer page, integer slot returns integer
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


function GetHeroDummy takes integer page, integer slot returns unit
    if page == 1 then
        return Hero_ID0_Dummy[slot]
    elseif page == 2 then
        return Hero_ID1_Dummy[slot]
    elseif page == 3 then
        return Hero_ID2_Dummy[slot]
    elseif page == 4 then
        return Hero_ID3_Dummy[slot]
    elseif page == 5 then
        return Hero_ID4_Dummy[slot]
    elseif page == 6 then
        return Hero_ID5_Dummy[slot]
    endif
    return null
endfunction

function FindHeroPage takes integer heroId returns integer
    local integer page = 1
    local integer slot
    loop
        exitwhen page > 6
        set slot = 0
        loop
            exitwhen slot == 30
            if GetHeroId(page, slot) == heroId then
                return page
            endif
            set slot = slot + 1
        endloop
        set page = page + 1
    endloop
    return 0
endfunction

function IsHeroAvailableForPick takes integer heroId returns boolean
    local integer page = 1
    local integer slot = 0
    if heroId == 0 or heroId == 12 then
        return false
    endif
    loop
        exitwhen page > 6
        set slot = 0
        loop
            exitwhen slot == 30
            if GetHeroId(page, slot) == heroId then
                return true
            endif
            set slot = slot + 1
        endloop
        set page = page + 1
    endloop
    return false
endfunction
function IsHeroIdBanProposed takes integer heroId, integer excludePid returns boolean
    local integer i = 0
    loop
        exitwhen i == 10
        if i != excludePid and BanProposalHero[i] == heroId then
            return true
        endif
        set i = i + 1
    endloop
    return false
endfunction

function IsCaptainPlayer takes integer pid returns boolean
    return CaptainMode and pid >= 0 and pid < 10 and (pid == CaptainPid1 or pid == CaptainPid2)
endfunction

function IsHeroTypeBanned takes integer heroId returns boolean
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

function IsHeroBanImmune takes integer heroId returns boolean
    if heroId == 0 or heroId == 12 then
        return false
    endif
    return heroId == BanImmuneHero1 or heroId == BanImmuneHero2 or heroId == BanImmuneHero3
endfunction

function GetBanLockedHeroType takes integer page, integer slot returns integer
    return BanLockedHeroTypeBySlot[(page - 1) * 30 + slot]
endfunction


function ReloadHeroPage takes integer page, player p returns nothing
    local integer i = 0
    local integer id
    local integer pid = GetPlayerId(p)
    local integer lockedHeroId
    local boolean isProposed
    local boolean isImmuneLocked
    local boolean frameEnabled
    local string iconPath
    loop
        exitwhen i == 30
        set id = GetHeroId(page, i)
        set lockedHeroId = 0
        set isProposed = false
        set isImmuneLocked = false
        set frameEnabled = false
        set iconPath = "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder"

        if id != 0 and id != 12 then
            set isProposed = BanProposalHero[pid] == id or IsHeroIdBanProposed(id, pid)
            set isImmuneLocked = not TestMode and IsHeroBanImmune(id) and (not BanPhaseTriggered or BanPhaseActive)
            set iconPath = BlzGetAbilityIcon(id)
            if isProposed or isImmuneLocked then
                set iconPath = ConvertBTNtoDISBTN(iconPath)
            else
                set frameEnabled = true
            endif
        elseif id == 12 then
            set lockedHeroId = GetBanLockedHeroType(page, i)
            if lockedHeroId != 0 then
                set iconPath = ConvertBTNtoDISBTN(BlzGetAbilityIcon(lockedHeroId))
            else
                set iconPath = "ReplaceableTextures\\CommandButtons\\BTNCancel"
            endif
        endif

        if GetLocalPlayer() == p then
            call BlzFrameSetTexture(FRAME_ICON2[i], iconPath, 0, false)
            call BlzFrameSetEnable(FRAME_ICON[i], frameEnabled)
        endif
        set i = i + 1
    endloop
endfunction
function RefreshAllPlayersHeroPage takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i == 10
        if GetPlayerSlotState( Player( i ) ) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController( Player( i ) ) == MAP_CONTROL_USER then
        call ReloadHeroPage(PlayerFrameCurrentPage_ID[i], Player(i))
        endif
        set i = i + 1
    endloop
endfunction

function ReloadAfterPick takes player p returns nothing
    local integer k = 0
    local integer k3 = 0
    local integer k2 = 0
    local integer pid = GetPlayerId(p)
    local integer result = -1
    set k = 1
    loop
        exitwhen k > 6 or result != -1
        set k3 = 0
        loop
            exitwhen k3 == 30 or result != -1
            if PlayerFrameCurrent_ID[pid] == GetHeroId(k, k3) then
                set result = k3
                call SetHeroId(k, k3, 12)
            endif
            set k3 = k3 + 1
        endloop
        set k = k + 1
    endloop
    if result != -1 then
        set k2 = 0
        loop
            exitwhen k2 == 10
            if PlayerFrameCurrentPage_ID[pid] == PlayerFrameCurrentPage_ID[k2] then
                if GetLocalPlayer() == Player(k2) then
                    call BlzFrameSetTexture(FRAME_ICON2[result], "ReplaceableTextures\\CommandButtons\\BTNCancel", 0, false)
                    call BlzFrameSetEnable(FRAME_ICON[result], false)
                endif
            endif
            set k2 = k2 + 1
        endloop
    endif
    set k = 0
    loop
        exitwhen k == 10
        if k != pid then
            if PlayerFrameCurrent_ID[pid] == PlayerFrameCurrent_ID[k] then
                set PlayerFrameCurrent_ID[k] = 0
                if GetLocalPlayer() == Player(k) then
                    call BlzFrameSetTexture(FRAME_ICON6[0], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
                    call BlzFrameSetTexture(FRAME_ICON6[1], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
                    call BlzFrameSetTexture(FRAME_ICON6[2], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
                    call BlzFrameSetTexture(FRAME_ICON6[3], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
                    call BlzFrameSetTexture(FRAME_ICON6[4], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
                    call BlzFrameSetTexture(FRAME_ICON6[5], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
                    call BlzFrameSetTexture(FRAME_ICON6[6], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
                    call BlzFrameSetVisible(FRAME_ICON5[5], true)
                    call BlzFrameSetVisible(FRAME_ICON5[6], true)
                    call BlzFrameSetVisible(FRAME_PlayerPickDifficultText, false)
                    call BlzFrameSetVisible(FRAME_ICON6[5], true)
                    call BlzFrameSetVisible(FRAME_ICON6[6], true)
                    call BlzFrameSetEnable(FRAME_ICON5[5], true)
                    call BlzFrameSetEnable(FRAME_ICON5[6], true)
                    call BlzFrameSetTexture(FRAME_HeroModel, "Textures\\black32.blp", 0, false)
                    call BlzFrameSetVisible(FRAME_HeroAttribute, false)
                    call BlzFrameSetVisible(FRAME_HeroAttackType, false)
                    call BlzFrameSetVisible(FRAME_HeroStr, false)
                    call BlzFrameSetVisible(FRAME_HeroAgi, false)
                    call BlzFrameSetVisible(FRAME_HeroInt, false)
                    call BlzFrameSetVisible(FRAME_HeroAtk, false)
                    call BlzFrameSetVisible(FRAME_HeroArmor, false)
                    call BlzFrameSetVisible(FRAME_HeroMS, false)
                    call BlzFrameSetVisible(FRAME_HeroAS, false)
                    call BlzFrameSetText(FRAME_HeroName, "Hero Name")
                endif
//call ReloadHeroPage(PlayerFrameCurrentPage_ID[k], Player(k))
            endif

        endif
        set k = k + 1
    endloop
   
endfunction

// Тоджи не использует ману. Один общий таймер обслуживает все игровые слоты,
// поэтому повторный выбор и смена владельца не создают новые таймеры.
function TojiZeroManaPeriodic takes nothing returns nothing
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

function TojiStartZeroMana takes unit u returns nothing
    if u == null or GetUnitTypeId(u) != Toji_ID then
        return
    endif

    // Обнуляем сразу при создании, не ожидая первого тика.
    call BlzSetUnitMaxMana(u, 0)
    call SetUnitState(u, UNIT_STATE_MANA, 0.0)

    if TojiZeroManaTimer == null then
        set TojiZeroManaTimer = CreateTimer()
        call TimerStart(TojiZeroManaTimer, 0.10, true, function TojiZeroManaPeriodic)
    endif
endfunction


// Закрывает существующий экран выбора, не удаляя основного героя игрока.
function TestUnit_CloseHeroPicker takes player p returns nothing
    local integer pid = GetPlayerId(p)
    local integer mode = TestUnitPickMode[pid]
    local unit selected = null

    if mode == TestUnitPickAlly then
        set selected = TestAllyUnit
    else
        set selected = TestUnit
    endif

    set TestUnitPickMode[pid] = 0
    set PlayerFrameCurrent_ID[pid] = 0
    call HideBottomUI(p, false)

    if GetLocalPlayer() == p then
        call BlzFrameSetVisible(FRAME_MAIN, false)
        call BlzFrameSetVisible(FRAME_StatusHeroMain, true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain2, true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain3, true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain4, true)
        call BlzFrameSetVisible(FRAME_LINK2, true)
        call BlzFrameSetEnable(FRAME_Pick[3], true)
    endif

    if selected != null then
        set HeroChosen[pid] = selected
        call RecommenedItems(p)
        call SelectUnitForPlayerSingle(selected, p)
    endif

    set selected = null
endfunction

function TestUnit_OpenHeroPicker takes player p, integer mode returns nothing
    local integer pid = GetPlayerId(p)

    if TestMode == false or Hero[pid] == null then
        return
    endif

    // Эти два слота используются как владельцы тестовых героев.
    if pid == TestUnitPlayerId or pid == TestAllyUnitPlayerId then
        call DisplayTimedTextToPlayer(p, 0, 0, 3, "Players 2 and 7 are reserved for test heroes")
        return
    endif

    set TestUnitPickMode[pid] = mode
    set PlayerFrameCurrent_ID[pid] = 0
    if PlayerFrameCurrentPage_ID[pid] < 1 or PlayerFrameCurrentPage_ID[pid] > 6 then
        set PlayerFrameCurrentPage_ID[pid] = 1
    endif

    // В тестовом режиме разрешаем использовать для теста тип своего героя.
    call GetMainId(GetUnitTypeId(Hero[pid]))
    call HideBottomUI(p, true)
    set Shop_Active[pid] = false

    if GetLocalPlayer() == p then
        call BlzFrameSetVisible(FRAME_ShopMAIN, false)
        call BlzFrameSetVisible(FRAME_MAIN, true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain, false)
        call BlzFrameSetVisible(FRAME_StatusHeroMain2, false)
        call BlzFrameSetVisible(FRAME_StatusHeroMain3, false)
        call BlzFrameSetVisible(FRAME_StatusHeroMain4, false)
        call BlzFrameSetVisible(FRAME_LINK2, false)
        call BlzFrameSetEnable(FRAME_Pick[2], true)
        call BlzFrameSetEnable(FRAME_Pick[3], false)
        call BlzFrameSetEnable(FRAME_Pick[4], false)
    endif

    call ReloadHeroPage(PlayerFrameCurrentPage_ID[pid], p)
endfunction

function TestUnit_ToggleHeroPicker takes player p, integer mode returns nothing
    local integer pid = GetPlayerId(p)

    if TestUnitPickMode[pid] == mode then
        call TestUnit_CloseHeroPicker(p)
    else
        call TestUnit_OpenHeroPicker(p, mode)
    endif
endfunction

// Настраивает отношение владельца тестового героя к управляющему игроку.
function TestUnit_ConfigureControl takes player controller, integer ownerId, boolean allied returns nothing
    local player owner = Player(ownerId)
    local player previousController = null

    if ownerId == TestAllyUnitPlayerId then
        set previousController = TestAllyUnitController
    else
        set previousController = TestUnitController
    endif

    if previousController != null and previousController != controller then
        call SetPlayerAlliance(owner, previousController, ALLIANCE_SHARED_CONTROL, false)
        call SetPlayerAlliance(owner, previousController, ALLIANCE_SHARED_ADVANCED_CONTROL, false)
    endif

    call SetPlayerAlliance(owner, controller, ALLIANCE_PASSIVE, allied)
    call SetPlayerAlliance(controller, owner, ALLIANCE_PASSIVE, allied)
    call SetPlayerAlliance(owner, controller, ALLIANCE_SHARED_CONTROL, true)
    call SetPlayerAlliance(owner, controller, ALLIANCE_SHARED_ADVANCED_CONTROL, true)

    if ownerId == TestAllyUnitPlayerId then
        set TestAllyUnitController = controller
    else
        set TestUnitController = controller
    endif

    set previousController = null
    set owner = null
endfunction

// Пересоздание по rawcode переносит модель и способности выбранного героя.
function TestUnit_CreateSelectedHero takes player controller, integer heroId, integer mode returns nothing
    local integer pid = GetPlayerId(controller)
    local integer ownerId = TestUnitPlayerId
    local boolean allied = false
    local unit oldUnit = TestUnit
    local unit created
    local real offset = 700.0
    local real x = GetRectCenterX(gg_rct_Pick)
    local real y = GetRectCenterY(gg_rct_Pick)
    local real facing = 0.0

    if mode == TestUnitPickAlly then
        set ownerId = TestAllyUnitPlayerId
        set allied = true
        set oldUnit = TestAllyUnit
        set offset = 300.0
    endif

    if Hero[pid] != null then
        set x = GetUnitX(Hero[pid]) - offset
        set y = GetUnitY(Hero[pid])
    endif

    // При смене типа сохраняем позицию и направление соответствующего тестового героя.
    if oldUnit != null then
        set x = GetUnitX(oldUnit)
        set y = GetUnitY(oldUnit)
        set facing = GetUnitFacing(oldUnit)
        if GetUnitTypeId(oldUnit) == Erza_ID then
            call ErzaF_Start(oldUnit)
        endif
        call RemoveUnit(oldUnit)
    elseif Hero[ownerId] != null then
        call RemoveUnit(Hero[ownerId])
    endif

    set Hero[ownerId] = null
    set level_id[ownerId] = 0
    if allied then
        set TestAllyUnit = null
    else
        set TestUnit = null
    endif

    set created = CreateUnit(Player(ownerId), heroId, x, y, facing)
    set Hero[ownerId] = created
    if allied then
        set TestAllyUnit = created
    else
        set TestUnit = created
    endif

    // 35-й уровень даёт LearnHeroSpells достаточно очков для всех навыков.
    call SetHeroLevel(created, 35, false)
    call SetFlyInit(created)
    call LearnHeroSpells(created)
    call TojiStartZeroMana(created)
    call BlzSetUnitMaxHP(created, 100000)
    if heroId != Toji_ID then
        call BlzSetUnitMaxMana(created, 1000)
        call SetMpCurrent(created, 9999)
    endif
    call SetHpCurrent(created, 99999999)
    call TestUnit_ConfigureControl(controller, ownerId, allied)

    // Сохраняем прежнее поведение союзной Erza и оставляем союзного тестового
    // героя с половиной здоровья для проверки лечения и защитных способностей.
    if allied then
        if heroId == Erza_ID then
            call IssueImmediateOrder(created, "acidbomb")
        endif
        call dmgmag(Hero[pid], created, GetUnitState(created, UNIT_STATE_MAX_LIFE) * 0.5)
    endif

    set HeroChosen[pid] = created
    call EUTU2_3(EffectSpawn("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", x, y, facing, 0.85, 1.45, 0), 2.5, 0, created)

    set created = null
    set oldUnit = null
endfunction
function RandomPick takes player p returns nothing
    local integer i = 0
    local integer id = 0
    local integer k = GetRandomInt(0, 9)
    local integer k2 = 0
    local integer k3 = 0
    local integer pid = GetPlayerId(p)
    local real BaseX = GetRectCenterX(gg_rct_Pick)
    local real BaseY = GetRectCenterY(gg_rct_Pick)
    local boolean canShowSwap = IsAllyExist(p) or TestMode == true
    if Hero[pid] == null and GetPlayerSlotState( Player( pid ) ) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController( Player( pid ) ) == MAP_CONTROL_USER then
        // Reservoir sampling: Р В Р Р‹Р В РІР‚С™Р В Р’В Р вЂ™Р’В°Р В Р’В Р В РІР‚В Р В Р’В Р В РІР‚В¦Р В Р’В Р РЋРІР‚СћР В Р’В Р РЋР’ВР В Р’В Р вЂ™Р’ВµР В Р Р‹Р В РІР‚С™Р В Р’В Р В РІР‚В¦Р В Р’В Р РЋРІР‚Сћ Р В Р’В Р В РІР‚В Р В Р Р‹Р Р†Р вЂљРІвЂћвЂ“Р В Р’В Р вЂ™Р’В±Р В Р’В Р РЋРІР‚ВР В Р Р‹Р В РІР‚С™Р В Р’В Р вЂ™Р’В°Р В Р’В Р вЂ™Р’ВµР В Р Р‹Р Р†Р вЂљРЎв„ў Р В Р’В Р вЂ™Р’В»Р В Р Р‹Р В РІР‚в„–Р В Р’В Р вЂ™Р’В±Р В Р’В Р РЋРІР‚СћР В Р’В Р РЋРІР‚вЂњР В Р’В Р РЋРІР‚Сћ Р В Р’В Р СћРІР‚ВР В Р’В Р РЋРІР‚СћР В Р Р‹Р В РЎвЂњР В Р Р‹Р Р†Р вЂљРЎв„ўР В Р Р‹Р РЋРІР‚СљР В Р’В Р РЋРІР‚вЂќР В Р’В Р В РІР‚В¦Р В Р’В Р РЋРІР‚СћР В Р’В Р РЋРІР‚вЂњР В Р’В Р РЋРІР‚Сћ Р В Р’В Р РЋРІР‚вЂњР В Р’В Р вЂ™Р’ВµР В Р Р‹Р В РІР‚С™Р В Р’В Р РЋРІР‚СћР В Р Р‹Р В Р РЏ.
        // MaxHeroes Р В Р’В Р РЋРІР‚В Р В Р Р‹Р В РІР‚С™Р В Р Р‹Р РЋРІР‚СљР В Р Р‹Р Р†Р вЂљР Р‹Р В Р’В Р В РІР‚В¦Р В Р’В Р вЂ™Р’В°Р В Р Р‹Р В Р РЏ Р В Р Р‹Р Р†Р вЂљР’В Р В Р’В Р вЂ™Р’ВµР В Р’В Р РЋРІР‚вЂќР В Р’В Р РЋРІР‚СћР В Р Р‹Р Р†Р вЂљР Р‹Р В Р’В Р РЋРІР‚СњР В Р’В Р вЂ™Р’В° k == 0 ... k == 26 Р В Р’В Р вЂ™Р’В±Р В Р’В Р РЋРІР‚СћР В Р’В Р вЂ™Р’В»Р В Р Р‹Р В Р вЂ°Р В Р Р‹Р Р†РІР‚С™Р’В¬Р В Р’В Р вЂ™Р’Вµ Р В Р’В Р В РІР‚В¦Р В Р’В Р вЂ™Р’Вµ Р В Р’В Р В РІР‚В¦Р В Р Р‹Р РЋРІР‚СљР В Р’В Р вЂ™Р’В¶Р В Р’В Р В РІР‚В¦Р В Р Р‹Р Р†Р вЂљРІвЂћвЂ“.
        set i = 1
        set k = 0
        loop
            exitwhen i > 6
            set k3 = 0
            loop
                exitwhen k3 == 30
                set id = GetHeroId(i, k3)
                if id != 0 and id != 12 then
                    set k = k + 1
                    if GetRandomInt(1, k) == 1 then
                        set k2 = id
                    endif
                endif
                set k3 = k3 + 1
            endloop
            set i = i + 1
        endloop
        if k2 == 0 then
            call DisplayTimedTextToPlayer(p, 0, 0, 2, "No heroes available for random pick")
            return
        endif
        if not IsHeroAvailableForPick(k2) then
            call RandomPick(p)
            return
        endif
        set PlayerFrameCurrentPage_ID[pid] = FindHeroPage(k2)
        if k2 == Hero_ID0[0] then
            set FRAME_PlayerPickString[pid] = "Raiden Ei"
            call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro3", p)
        elseif k2 == Hero_ID0[1] then
            call MakeSoundLocal("war3mapimported\\Hero_Neuvillette_Pick2", p)
            set FRAME_PlayerPickString[pid] = "Neuvillette"
        elseif k2 == Hero_ID0[2] then
            call MakeSoundLocal("war3mapimported\\Hero_Patriot_Pick5", p)
            set FRAME_PlayerPickString[pid] = "Patriot"
        elseif k2 == Hero_ID1[0] then
            call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick2", p)
            set FRAME_PlayerPickString[pid] = "Kyoraku Shunsui"
        elseif k2 == Hero_ID1[1] then
            call MakeSoundLocal("war3mapimported\\Hero_BazzB_Pick2", p)
            set FRAME_PlayerPickString[pid] = "BazzB"
        elseif k2 == Hero_ID1[2] then
            call MakeSoundLocal("war3mapimported\\Hero_Harribel_Pick1", p)
            set FRAME_PlayerPickString[pid] = "Harribel"
        elseif k2 == Hero_ID1[3] then
            call MakeSoundLocal("war3mapimported\\Hero_Barragan_Pick1", p)
            set FRAME_PlayerPickString[pid] = "Barragan"
        elseif k2 == Hero_ID1[4] then
            call MakeSoundLocal("war3mapimported\\Hero_Starrk_Pick3", p)
            set FRAME_PlayerPickString[pid] = "Starrk"
        elseif k2 == Hero_ID1[5] then
            call MakeSoundLocal("war3mapimported\\Hero_Bambietta_TT", p)
            set FRAME_PlayerPickString[pid] = "Bambietta"
        elseif k2 == Hero_ID2[0] then
            set k2 = Hero_ID2[0]
            call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick3", p)
            set FRAME_PlayerPickString[pid] = "Natsu Dragneel"
            set NatsuPicked = true
        elseif k2 == Hero_ID2[1] then
            call MakeSoundLocal("war3mapimported\\Hero_Erza_Start2", p)
            set FRAME_PlayerPickString[pid] = "Erza Scarlet"
        elseif k2 == Hero_ID2[2] then
            call MakeSoundLocal("war3mapimported\\Hero_Brandish_Pick2", p)
            set FRAME_PlayerPickString[pid] = "Brandish"
        elseif k2 == Hero_ID2[3] then
            call MakeSoundLocal("war3mapimported\\Hero_Laxus_Pick2", p)
            set FRAME_PlayerPickString[pid] = "Laxus"
            set LaxusPicked = true
        elseif k2 == Hero_ID3[0] then
            call MakeSoundLocal("war3mapimported\\Hero_Akainu_Pick5", p)
            set FRAME_PlayerPickString[pid] = "Sakazuki Akainu"
        elseif k2 == Hero_ID4[0] then
            call MakeSoundLocal("war3mapimported\\Hero_Gojo_E3", p)
            set FRAME_PlayerPickString[pid] = "Satoru Gojo"
        elseif k2 == Hero_ID5[0] then
            call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick2", p)
            set FRAME_PlayerPickString[pid] = "Giyu Tomioka"
        elseif k2 == Hero_ID5[1] then
            call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick5", p)
            set FRAME_PlayerPickString[pid] = "Alter Saber"
        elseif k2 == Hero_ID4[1] then
            call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick1", p)
            set FRAME_PlayerPickString[pid] = "Kenjaku"
        elseif k2 == Hero_ID5[2] then
            call MakeSoundLocal("war3mapimported\\Hero_Inori_Pick4", p)
            set FRAME_PlayerPickString[pid] = "Yuzuriha Inori"
        elseif k2 == Hero_ID5[3] then
            call MakeSoundLocal("war3mapimported\\Hero_Okarun_Pick2", p)
            set FRAME_PlayerPickString[pid] = "Okarun"
        elseif k2 == Hero_ID5[4] then
            call MakeSoundLocal("war3mapimported\\Hero_Tsuna_Pick5", p)
            set FRAME_PlayerPickString[pid] = "Tsuna"
        elseif k2 == Hero_ID5[5] then
            call MakeSoundLocal("war3mapimported\\Hero_Takeshi_Pick1", p)
            set FRAME_PlayerPickString[pid] = "Takeshi"
        elseif k2 == Hero_ID5[6] then
            call MakeSoundLocal("war3mapimported\\Hero_DarkShiki_R01", p)
            set FRAME_PlayerPickString[pid] = "DarkShiki"
        elseif k2 == Hero_ID5[7] then
            call MakeSoundLocal("war3mapimported\\Hero_Rimuru_Pick2", p)
            set FRAME_PlayerPickString[pid] = "Rimuru"
        elseif k2 == Hero_ID5[8] then
            call MakeSoundLocal("war3mapimported\\Hero_Alucard_Pick", p)
            set FRAME_PlayerPickString[pid] = "Alucard"
        elseif k2 == Hero_ID4[2] then
            call MakeSoundLocal("war3mapimported\\Hero_Mahoraga_Pick5", p)
            set FRAME_PlayerPickString[pid] = "Mahoraga"
        elseif k2 == Hero_ID4[2] then
            call MakeSoundLocal("war3mapimported\\Hero_Toji_Pick5", p)
            set FRAME_PlayerPickString[pid] = "Toji"
        elseif k2 == Hero_ID5[9] then
            call MakeSoundLocal("war3mapimported\\Hero_Kirito_Pick2", p)
            set FRAME_PlayerPickString[pid] = "Kirito"
        elseif k2 == Hero_ID5[10] then
            call MakeSoundLocal("war3mapimported\\Hero_Asta_Pick2", p)
            set FRAME_PlayerPickString[pid] = "Asta"
        elseif k2 == Hero_ID5[11] then
            call MakeSoundLocal("war3mapimported\\Hero_Ainz_Pick1", p)
            set FRAME_PlayerPickString[pid] = "Ainz"
        elseif k2 == Hero_ID5[12] then
            call MakeSoundLocal("war3mapimported\\Hero_Frieren_Pick1", p)
            set FRAME_PlayerPickString[pid] = "Frieren"
        // HERO TRANSFER: Milim / RandomPick
        elseif k2 == Hero_ID5[13] then
            set FRAME_PlayerPickString[pid] = "Milim"
            call MakeSoundLocal("war3mapimported\\Hero_Milim_Pick1", p)
        endif
        call MakeSoundLocal("Pick\\PickPick2",p)
        set PickedOnce[pid] = PickedOnce[pid] + 1
        set PlayerFrameCurrent_ID[pid] = k2
        if GetLocalPlayer() == p then
    call BlzFrameSetVisible(EmojiMuteButton, true)
call BlzFrameSetVisible(EmojiToggle, true)
    endif
       
        set Hero[pid] = CreateUnit(p, PlayerFrameCurrent_ID[pid], BaseX, BaseY, 270)
        call SetHeroLevel(Hero[pid], 2, false)
        call SetFlyInit(Hero[pid])
        call LearnHeroSpells(Hero[pid])
        call TojiStartZeroMana(Hero[pid])
        call BlzFrameSetTexture(FRAME_PlayerPickBack[pid], BlzGetAbilityIcon(PlayerFrameCurrent_ID[pid]), 0, false)
       
        call HideBottomUI(Player(pid), false)
        call PanCameraToTimedForPlayer(p, BaseX, BaseY, 0.25)
        call SetCameraFieldForPlayer(p, CAMERA_FIELD_TARGET_DISTANCE, 3500, 0.25)
        call SelectUnitForPlayerSingle(Hero[pid], p)
        if GetLocalPlayer() == p then
            call BlzFrameSetVisible(FRAME_MAIN, false)
            call BlzFrameSetVisible(FRAME_StatusHeroMain, true)
            call BlzFrameSetVisible(FRAME_StatusHeroMain2, true)
            call BlzFrameSetVisible(FRAME_StatusHeroMain3, true)
            call BlzFrameSetVisible(FRAME_StatusHeroMain4, true)
            call BlzFrameSetVisible(FRAME_LINK2, true)
            if PickedOnce[pid] == 1 then
                call BlzFrameSetEnable(FRAME_Repick[pid], true)
                call BlzFrameSetVisible(FRAME_Repick[pid], true)
                if canShowSwap then
                    call BlzFrameSetEnable(FRAME_Swap[pid], true)
                    call BlzFrameSetVisible(FRAME_Swap[pid], true)
                endif
            endif
        endif
        call RecommenedItems(p)
        
        call SaveSystem_SetCurrentHero(p, Hero[pid])
         call ReloadAfterPick(p)
          set PlayerFrameCurrent_ID[pid] = 0
        if PickedOnce[pid] == 1 then
            call AddGold(p, AddRandom, true)
            call PlayersMsg( GetPlayerColorString(p) + GetPlayerName(p) + "|r randomed |c00FFFF00" + BlzGetUnitStringField(Hero[pid], UNIT_SF_NAME) + " and gain +1000 gold|r", 1 )
        else
            call PlayersMsg( GetPlayerColorString(p) + GetPlayerName(p) + "|r repicked |c00FFFF00" + BlzGetUnitStringField(Hero[pid], UNIT_SF_NAME) + " and lost -500 gold|r", 1 )
        endif
        call EUTU2_3(EffectSpawn("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", GetUnitX(Hero[pid]), GetUnitY(Hero[pid]), 270, 0.85, 1.45, 0), 2.5, 0, Hero[pid])
        
    endif
endfunction
function Repick takes player p returns nothing
    local integer i = 0
    local integer k = GetRandomInt(0, 9)
    local integer k2 = 0
    local integer pid = GetPlayerId(p)
    local item array savedItems
    local integer savedCount = 0
    local item it
    local integer slot = 0
    local integer id = GetUnitTypeId(Hero[pid])
    call BlzFrameSetEnable(FRAME_Repick[pid], false)
    call BlzFrameSetVisible(FRAME_Repick[pid], false)
    // Save and drop all items from hero
    loop
        exitwhen slot >= 6
        set it = UnitItemInSlot(Hero[pid], slot)
        if it != null then
            set savedItems[savedCount] = it
            set savedCount = savedCount + 1
            call UnitRemoveItem(Hero[pid], it)
        endif
        set slot = slot + 1
    endloop
    if GetUnitTypeId(Hero[pid]) == Erza_ID then
        call ErzaF_Start(Hero[pid])
    endif
    call RemoveUnit(Hero[pid])
    set Hero[pid] = null
    set level_id[pid] = 0
    call AddGold(p, R2I(AddRandom / 2), false)
    call RandomPick(p)
    call GetMainId(id)
    // Restore saved items to new hero
    set i = 0
    loop
        exitwhen i >= savedCount
        call UnitAddItem(Hero[pid], savedItems[i])
        set savedItems[i] = null
        set i = i + 1
    endloop
endfunction
function UpdateBanProposalSlot takes integer pid returns nothing
local integer heroId = BanProposalHero[pid]

if heroId == 0 then
call BlzFrameSetTexture(FRAME_PlayerPickBack[pid],"ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder",0,false)
elseif IsHeroTypeBanned(heroId) then
call BlzFrameSetTexture(FRAME_PlayerPickBack[pid],ConvertBTNtoDISBTN(BlzGetAbilityIcon(heroId)),0,false)
else
call BlzFrameSetTexture(FRAME_PlayerPickBack[pid],BlzGetAbilityIcon(heroId),0,false)
endif
endfunction

function OnClick takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local integer i = 0
    local integer i2 = 0
    local string s
    local string s_name
    local string iconQ
    local string iconW
    local string iconE
    local string iconR
    local string iconT
    local string iconF
    local string iconG
    local string heroModelPath
    local string heroStrText
    local string heroAgiText
    local string heroIntText
    local string heroAtkText
    local string heroArmorText
    local string heroMoveSpeedText
    local string heroAttackSpeedText
    local boolean frameFEnabled
    local boolean frameGEnabled
    local boolean heroIsMelee
    local integer heroPrimaryAttribute
    local integer id = 0
    local integer end = 0
    local integer k3 = 0
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local boolean canShowSwap = IsAllyExist(p) or TestMode == true
    local boolean testUnitPickHandled = false
    local integer number_hero
    local real x = 0.025
    local real y = -0.05
    local real BaseX
    local integer b = 0
    local real BaseY
    local unit d = null
    local integer k = 0
    if clicked == FRAME_Repick[pid] then
        call Repick(p)
    endif
    if clicked == FRAME_Swap[pid] then
        if TestMode == false then
            if FRAME_SwapActive[pid] == 0 then
                set FRAME_SwapActive[pid] = 1
                set k = 0
                loop
                    exitwhen k == 10
                    if IsPlayerAlly(Player(k), p) and Player(k) != p and IsPlaying3(Player(k)) then
                        if GetLocalPlayer() == p then
                            call BlzFrameSetVisible(FRAME_SwapSprite[k], true)
                            call BlzFrameSetVisible(FRAME_SwapSprite2[k], false)
                        endif
                    endif
                    set k = k + 1
                endloop
            else
                set k = 0
                loop
                    exitwhen k == 10
                    if GetLocalPlayer() == p then
                        call BlzFrameSetVisible(FRAME_SwapSprite[k], false)
                        call BlzFrameSetVisible(FRAME_SwapSprite2[k], false)
                    endif
                    set k = k + 1
                endloop
                set SwapRequests[pid] = -1
                set FRAME_SwapActive[pid] = 0
            endif
        else
        // TestMode: return player to pick screen
            if Hero[pid] != null then
                if GetUnitTypeId(Hero[pid]) == Rimuru_ID then
                    if GetLocalPlayer() == p then
                        call BlzFrameSetVisible(frameRimuru1_pas1[pid], false)
                        call BlzFrameSetVisible(frameRimuru2_pas1[pid], false)
                    endif
                endif
                if GetUnitTypeId(Hero[pid]) == Takeshi_ID and GetHeroLevel(Hero[pid]) >= 35 then
                    if GetLocalPlayer() == p then
                        call BlzFrameSetVisible(frameTakeshi_pas1[pid], false)
                    endif
                endif
                if GetUnitTypeId(Hero[pid]) == Erza_ID then
                    call ErzaF_Start(Hero[pid])
                endif
                call RemoveUnit(Hero[pid])
                set Hero[pid] = null
                set level_id[pid] = 0
            endif
            if GetLocalPlayer() == Player(pid) then
                call BlzFrameSetVisible(FRAME_MAIN, true)
                call BlzFrameSetVisible(FRAME_StatusHeroMain, false)
                call BlzFrameSetVisible(FRAME_StatusHeroMain2, false)
                call BlzFrameSetVisible(FRAME_StatusHeroMain3, false)
                call BlzFrameSetVisible(FRAME_StatusHeroMain4, false)
                call BlzFrameSetVisible(FRAME_LINK2, false)
            endif
            call HideBottomUI(Player(pid), true)
            set Shop_Active[pid] = false
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(FRAME_ShopMAIN, false)
            endif
            call BlzFrameSetEnable(FRAME_Repick[pid], false)
            call BlzFrameSetVisible(FRAME_Repick[pid], false)
            call BlzFrameSetEnable(FRAME_Swap[pid], false)
            call BlzFrameSetVisible(FRAME_Swap[pid], false)
        // Restore hero slots on the pick page so player can re-pick
            set PlayerFrameCurrent_ID[pid] = 0
            call ReloadHeroPage(PlayerFrameCurrentPage_ID[pid], Player(pid))
        endif
    endif
    set k = 0
    if clicked == Frame_PageHeroList[0] or clicked == Frame_PageHeroList[1] or clicked == Frame_PageHeroList[2] or clicked == Frame_PageHeroList[3] or clicked == Frame_PageHeroList[4] or clicked == Frame_PageHeroList[5] then
        set PlayerFrameCurrent_ID[pid] = 0
        call MakeSoundLocal("Pick\\PickCount5",p)
        if GetLocalPlayer() == p then
            call BlzFrameSetTexture(FRAME_ICON6[0], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[1], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[2], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[3], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[4], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[5], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[6], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
            call BlzFrameSetVisible(FRAME_ICON5[5], true)
            call BlzFrameSetVisible(FRAME_ICON5[6], true)
            call BlzFrameSetVisible(FRAME_ICON6[5], true)
            call BlzFrameSetVisible(FRAME_ICON6[6], true)
            call BlzFrameSetEnable(FRAME_ICON5[5], true)
            call BlzFrameSetEnable(FRAME_ICON5[6], true)
            call BlzFrameSetTexture(FRAME_HeroModel, "Textures\\black32.blp", 0, false)
            call BlzFrameSetVisible(FRAME_HeroAttribute, false)
            call BlzFrameSetVisible(FRAME_HeroAttackType, false)
            call BlzFrameSetVisible(FRAME_HeroStr, false)
            call BlzFrameSetVisible(FRAME_HeroAgi, false)
            call BlzFrameSetVisible(FRAME_PlayerPickDifficultText, false)
            call BlzFrameSetVisible(FRAME_HeroInt, false)
            call BlzFrameSetVisible(FRAME_HeroAtk, false)
            call BlzFrameSetVisible(FRAME_HeroArmor, false)
            call BlzFrameSetVisible(FRAME_HeroMS, false)
            call BlzFrameSetVisible(FRAME_HeroAS, false)
            call BlzFrameSetText(FRAME_HeroName, "Hero Name")
        endif
        if clicked == Frame_PageHeroList[0] then
            set PlayerFrameCurrentPage_ID[pid] = 1
        elseif clicked == Frame_PageHeroList[1] then
            set PlayerFrameCurrentPage_ID[pid] = 2
        elseif clicked == Frame_PageHeroList[2] then
            set PlayerFrameCurrentPage_ID[pid] = 3
        elseif clicked == Frame_PageHeroList[3] then
            set PlayerFrameCurrentPage_ID[pid] = 4
        elseif clicked == Frame_PageHeroList[4] then
            set PlayerFrameCurrentPage_ID[pid] = 5
        elseif clicked == Frame_PageHeroList[5] then
            set PlayerFrameCurrentPage_ID[pid] = 6
        endif
        call ReloadHeroPage(PlayerFrameCurrentPage_ID[pid], p)
    endif
  
 
if clicked == FRAME_Pick[4] then
    if not PickPhaseActive and not BanPhaseActive and not BanPhaseTriggered and PlayerFrameCurrent_ID[pid] != 0 and PlayerFrameCurrent_ID[pid] != 12 and not IsHeroBanImmune(PlayerFrameCurrent_ID[pid]) then
        set id = PlayerFrameCurrent_ID[pid]

        // После отсечки нельзя ни добавить, ни снять, ни заменить предложение.
        if not BanSelectionLocked or BanProposalHero[pid] == 0 then
            if BanProposalHero[pid] == id  then
                set BanProposalHero[pid] = 0
                call MakeSoundLocal("Pick\\PickCount5", p)
                call UpdateBanProposalSlot(pid)
                call RefreshAllPlayersHeroPage()
            elseif not IsHeroIdBanProposed(id, pid) then
                // Замена происходит одним присваиванием: старый герой сразу
                // освобождается при общем обновлении страниц выбора.
                set BanProposalHero[pid] = id
                call MakeSoundLocal("Pick\\PickCount3", p)
                call UpdateBanProposalSlot(pid)
                call RefreshAllPlayersHeroPage()
            endif
        endif
    endif
endif

    set k3 = 0
    loop
        exitwhen k3 == 30
        if clicked == FRAME_ICON[k3] then
        call MakeSoundLocal("Pick\\PickCount6",p)
            if PlayerFrameCurrentPage_ID[pid] == 1 and Hero_ID0[k3] != 0 and Hero_ID0[k3] != 12 then
                if k3 == 0 then
                    set s = "Raiden"
                    set s_name = "Raiden Ei"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                    set b = 2
                elseif k3 == 1 then
                    set b = 4
                    set s = "Neuvillette"
                    set s_name = "Neuvillette"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                 elseif k3 == 2 then
                    set b = 2
                    set s = "Patriot"
                    set s_name = "Patriot"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF0303Hard|r")
                    endif
                endif
                set PlayerFrameCurrent_ID[pid] = Hero_ID0[k3]
                set d = Hero_ID0_Dummy[k3]
            elseif PlayerFrameCurrentPage_ID[pid] == 2 and Hero_ID1[k3] != 0 then
                if k3 == 0 then
                    set b = 4
                    set s = "Kyoraku"
                    set s_name = "Kyoraku Shunsui"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF0303Hard|r")
                    endif
                elseif k3 == 1 then
                    set b = 3
                    set s = "BazzB"
                    set s_name = "BazzB"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                elseif k3 == 2 then
                    set b = 3
                    set s = "Harribel"
                    set s_name = "Harribel"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                elseif k3 == 3 then
                    set b = 3
                    set s = "Barragan"
                    set s_name = "Barragan"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                elseif k3 == 4 then
                    set b = 3
                    set s = "Starrk"
                    set s_name = "Starrk"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF9428Normal|r")
                    endif
                elseif k3 == 5 then
                    set b = 3
                    set s = "Bambietta"
                    set s_name = "Bambietta"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                endif
                set PlayerFrameCurrent_ID[pid] = Hero_ID1[k3]
                set d = Hero_ID1_Dummy[k3]
            elseif PlayerFrameCurrentPage_ID[pid] == 3 and Hero_ID2[k3] != 0 then
                if k3 == 0 then
                    set b = 2
                    set s = "Natsu"
                    set s_name = "Natsu Dragneel"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                elseif k3 == 1 then
                    set b = 2
                    set s = "Erza"
                    set s_name = "Erza Scarlet"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF0303Hard|r")
                    endif
                elseif k3 == 2 then
                    set b = 4
                    set s = "Brandish"
                    set s_name = "Brandish"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                elseif k3 == 3 then
                    set b = 2
                    set s = "Laxus"
                    set s_name = "Laxus"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                endif
                set PlayerFrameCurrent_ID[pid] = Hero_ID2[k3]
                set d = Hero_ID2_Dummy[k3]
            elseif PlayerFrameCurrentPage_ID[pid] == 4 and Hero_ID3[k3] != 0 then
                if k3 == 0 then
                    set b = 4
                    set s = "Akainu"
                    set s_name = "Sakazuki Akainu"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                endif
                set PlayerFrameCurrent_ID[pid] = Hero_ID3[k3]
                set d = Hero_ID3_Dummy[k3]
            elseif (PlayerFrameCurrentPage_ID[pid] == 5 and Hero_ID4[k3] != 0) or (PlayerFrameCurrentPage_ID[pid] == 6 and Hero_ID5[k3] != 0) then
                if GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Gojo_ID then
                    set s = "Gojo"
                    set b = 3
                    set s_name = "Satoru Gojo"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF9428Normal|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Tomioka_ID then
                    set s = "Tomioka"
                    set b = 2
                    set s_name = "Giyu Tomioka"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == AlterSaber_ID then
                    set s = "AlterSaber"
                    set b = 2
                    set s_name = "Alter Saber"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Kenjaku_ID then
                    set s = "Kenjaku"
                    set b = 2
                    set s_name = "Kenjaku"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF0303Hard|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Inori_ID then
                    set s = "Inori"
                    set b = 2
                    set s_name = "Inori"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF9428Normal|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Okarun_ID then
                    set s = "Okarun"
                    set b = 4
                    set s_name = "Okarun"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF9428Normal|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Tsuna_ID then
                    set s = "Tsuna"
                    set b = 2
                    set s_name = "Tsuna"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF9428Normal|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Takeshi_ID then
                    set s = "Takeshi"
                    set b = 2
                    set s_name = "Takeshi"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF0303Hard|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == DarkShiki_ID then
                    set s = "DarkShiki"
                    set b = 2
                    set s_name = "DarkShiki"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Rimuru_ID then
                    set s = "Rimuru"
                    set b = 2
                    set s_name = "Rimuru"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF0303Hard|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Alucard_ID then
                    set s = "Alucard"
                    set b = 2
                    set s_name = "Alucard"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF9428Normal|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Mahoraga_ID then
                    set s = "Mahoraga"
                    set b = 2
                    set s_name = "Mahoraga"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Toji_ID then
                    set s = "Toji"
                    set b = 2
                    set s_name = "Toji"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF9428Normal|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Kirito_ID then
                    set s = "Kirito"
                    set b = 2
                    set s_name = "Kirito"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF0303Hard|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Asta_ID then
                    set s = "Asta"
                    set b = 2
                    set s_name = "Asta"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF9428Normal|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Ainz_ID then
                    set s = "Ainz"
                    set b = 2
                    set s_name = "Ainz"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c00FF9428Normal|r")
                    endif
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Frieren_ID then
                    set s = "Frieren"
                    set b = 2
                    set s_name = "Frieren"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                
                
                // HERO TRANSFER: Milim / OnClick details
                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == Milim_ID then
                    set s = "Milim"
                    set b = 2
                    set s_name = "Milim"
                    if GetLocalPlayer() == p then
                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, "|c00FFFC01Difficulty: " + "|c0028E800Easy|r")
                    endif
                endif
                set PlayerFrameCurrent_ID[pid] = GetHeroId(PlayerFrameCurrentPage_ID[pid], k3)
                set d = GetHeroDummy(PlayerFrameCurrentPage_ID[pid], k3)
            endif
            set iconQ = "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_Q"
            set iconW = "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_W"
            set iconE = "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_E"
            set iconR = "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_R"
            set iconT = "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_T"
            set iconF = "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder"
            set iconG = "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder"
            set frameFEnabled = false
            set frameGEnabled = false
            if b == 2 then
                set iconF = "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_F"
                set iconG = "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_G"
                set frameFEnabled = true
                set frameGEnabled = true
            elseif b == 3 then
                set iconG = "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_G"
                set frameGEnabled = true
            elseif b == 4 then
                set iconF = "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_F"
                set frameFEnabled = true
            endif
            set heroModelPath = "war3mapimported\\wos_" + s + "_port"
            set heroStrText = "|cffff0000Str: " + I2S(BlzGetUnitIntegerField(d, UNIT_IF_STRENGTH)) + "+" + R2SW(BlzGetUnitRealField(d, UNIT_RF_STRENGTH_PER_LEVEL), 0, 2) + "|r"
            set heroAgiText = "|cff289b1eAgi: " + I2S(BlzGetUnitIntegerField(d, UNIT_IF_AGILITY)) + "+" + R2SW(BlzGetUnitRealField(d, UNIT_RF_AGILITY_PER_LEVEL), 0, 2) + "|r"
            set heroIntText = "|cff3737ffInt: " + I2S(BlzGetUnitIntegerField(d, UNIT_IF_INTELLIGENCE)) + "+" + R2SW(BlzGetUnitRealField(d, UNIT_RF_INTELLIGENCE_PER_LEVEL), 0, 2) + "|r"
            set heroAtkText = "Atk: " + I2S(BlzGetUnitWeaponIntegerField(d, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0))
            set heroArmorText = "Def: " + R2SW(BlzGetUnitArmor(d), 0, 2)
            set heroMoveSpeedText = "MS: " + I2S(R2I(GetUnitDefaultMoveSpeed(d)))
            set heroAttackSpeedText = "AS: " + R2SW(BlzGetUnitWeaponRealField(d, UNIT_WEAPON_RF_ATTACK_BASE_COOLDOWN, 0), 0, 2)
            set heroIsMelee = IsUnitType(d, UNIT_TYPE_MELEE_ATTACKER)
            set heroPrimaryAttribute = BlzGetUnitIntegerField(d, UNIT_IF_PRIMARY_ATTRIBUTE)
            if GetLocalPlayer() == p then
                call BlzFrameSetTexture(FRAME_ICON6[0], iconQ, 0, false)
                call BlzFrameSetTexture(FRAME_ICON6[1], iconW, 0, false)
                call BlzFrameSetTexture(FRAME_ICON6[2], iconE, 0, false)
                call BlzFrameSetTexture(FRAME_ICON6[3], iconR, 0, false)
                call BlzFrameSetTexture(FRAME_ICON6[4], iconT, 0, false)
                call BlzFrameSetTexture(FRAME_ICON6[5], iconF, 0, false)
                call BlzFrameSetTexture(FRAME_ICON6[6], iconG, 0, false)
                call BlzFrameSetEnable(FRAME_ICON5[5], frameFEnabled)
                call BlzFrameSetEnable(FRAME_ICON5[6], frameGEnabled)
                call BlzFrameSetVisible(FRAME_PlayerPickDifficultText, true)
                call BlzFrameSetVisible(FRAME_HeroAttribute, true)
                call BlzFrameSetVisible(FRAME_HeroAttackType, true)
                call BlzFrameSetVisible(FRAME_HeroStr, true)
                call BlzFrameSetVisible(FRAME_HeroAgi, true)
                call BlzFrameSetVisible(FRAME_HeroInt, true)
                call BlzFrameSetVisible(FRAME_HeroAtk, true)
                call BlzFrameSetVisible(FRAME_HeroArmor, true)
                call BlzFrameSetVisible(FRAME_HeroMS, true)
                call BlzFrameSetVisible(FRAME_HeroAS, true)
                call BlzFrameSetTexture(FRAME_HeroModel, heroModelPath, 0, false)
                call BlzFrameSetText(FRAME_HeroName, s_name)
                call BlzFrameSetText(FRAME_HeroStr, heroStrText)
                call BlzFrameSetText(FRAME_HeroAgi, heroAgiText)
                call BlzFrameSetText(FRAME_HeroInt, heroIntText)
                call BlzFrameSetText(FRAME_HeroAtk, heroAtkText)
                call BlzFrameSetText(FRAME_HeroArmor, heroArmorText)
                call BlzFrameSetText(FRAME_HeroMS, heroMoveSpeedText)
                call BlzFrameSetText(FRAME_HeroAS, heroAttackSpeedText)
                if heroIsMelee then
                    call BlzFrameSetTexture(FRAME_HeroAttackType, "Pick\\PickButton_Attack_Normal", 0, true)
                else
                    call BlzFrameSetTexture(FRAME_HeroAttackType, "Pick\\PickButton_Attack_Ranged", 0, true)
                endif
                if heroPrimaryAttribute == 1 then
                    call BlzFrameSetTexture(FRAME_HeroAttribute, "UI\\Widgets\\Console\\Human\\infocard-heroattributes-str", 0, true)
                elseif heroPrimaryAttribute == 3 then
                    call BlzFrameSetTexture(FRAME_HeroAttribute, "UI\\Widgets\\Console\\Human\\infocard-heroattributes-agi", 0, true)
                elseif heroPrimaryAttribute == 2 then
                    call BlzFrameSetTexture(FRAME_HeroAttribute, "UI\\Widgets\\Console\\Human\\infocard-heroattributes-int", 0, true)
                endif
            endif

            // Заполняем все семь нативных подсказок один раз при выборе героя.
            // Во время последующего наведения пользовательский код не выполняется.
            set GuideTooltipRefreshPlayer = p
            set GuideTooltipRefreshSlot = 0
            loop
                exitwhen GuideTooltipRefreshSlot == 7
                call TriggerExecute(FrameGuideRefresh)
                set GuideTooltipRefreshSlot = GuideTooltipRefreshSlot + 1
            endloop
            set GuideTooltipRefreshSlot = -1
            set GuideTooltipRefreshPlayer = null
        endif
        set k3 = k3 + 1
    endloop
    if clicked == FRAME_HeroName then
        set i = PlayerSoundCurrent[pid]
        set PlayerSoundCurrent[pid] = PlayerSoundCurrent[pid] + 1
        if PlayerSoundCurrent[pid] > 4 then
            set PlayerSoundCurrent[pid] = 0
        endif
        if PlayerFrameCurrent_ID[pid] == Hero_ID0[0] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID0[1] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Neuvillette_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Neuvillette_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Neuvillette_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Neuvillette_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Neuvillette_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID0[2] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Patriot_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Patriot_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Patriot_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Patriot_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Patriot_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[0] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[1] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_BazzB_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_BazzB_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_BazzB_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_BazzB_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_BazzB_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[2] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Harribel_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Harribel_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Harribel_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Harribel_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Harribel_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[3] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Barragan_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Barragan_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Barragan_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Barragan_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Barragan_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[4] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Starrk_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Starrk_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Starrk_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Starrk_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Starrk_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[5] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Bambietta_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Bambietta_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Bambietta_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Bambietta_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Bambietta_TT", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID2[0] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID2[1] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Erza_Start", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Erza_Pick1", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Erza_Start2", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Erza_Pick3", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Erza_Pick2", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID2[2] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Brandish_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Brandish_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Brandish_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Brandish_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Brandish_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID2[3] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Laxus_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Laxus_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Laxus_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Laxus_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Laxus_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID3[0] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Akainu_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Akainu_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Akainu_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Akainu_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Akainu_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[0] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Gojo_E3", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Gojo_E1", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Gojo_R1", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Gojo_RE", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Gojo_RW1", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[0] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[1] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[1] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[2] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Inori_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Inori_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Inori_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Inori_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Inori_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[3] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Okarun_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Okarun_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Okarun_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Okarun_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Okarun_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[4] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Tsuna_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Tsuna_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Tsuna_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Tsuna_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Tsuna_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[5] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Takeshi_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Takeshi_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Takeshi_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Takeshi_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Takeshi_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[6] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_DarkShiki_R01", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_DarkShiki_T", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_DarkShiki_W03", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_DarkShiki_E01", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_DarkShiki_R02", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[7] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Rimuru_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Rimuru_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Rimuru_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Rimuru_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Rimuru_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[8] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Alucard_Pick", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Alucard_E2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Alucard_Q05", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Alucard_W01", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Alucard_Q2 01", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[2] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Mahoraga_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Mahoraga_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Mahoraga_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Mahoraga_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Mahoraga_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[3] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Toji_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Toji_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Toji_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Toji_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Toji_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[9] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Kirito_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Kirito_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Kirito_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Kirito_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Kirito_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[10] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Asta_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Asta_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Asta_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Asta_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Asta_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[11] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Ainz_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Ainz_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Ainz_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Ainz_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Ainz_Pick5", p)
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[12] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Frieren_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Frieren_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Frieren_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Frieren_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Frieren_Pick5", p)
            endif
        
        // HERO TRANSFER: Milim / OnClick sounds
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[13] then
            if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Milim_Pick1", p)
            elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Milim_Pick2", p)
            elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Milim_Pick3", p)
            elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Milim_Pick4", p)
            elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Milim_Pick5", p)
            endif
        endif
    endif
    if clicked == FRAME_Pick[3] then
        if TestUnitPickMode[pid] != 0 then
            call DisplayTimedTextToPlayer(p, 0, 0, 2, "Choose the TestUnit hero manually")
        else
            call RandomPick(p)
        endif
    endif

    // В тестовом режиме кнопка Pick создаёт выбранного тестового героя, не заменяя Hero[pid].
    if clicked == FRAME_Pick[2] and TestUnitPickMode[pid] != 0 and PlayerFrameCurrent_ID[pid] != 0 and PlayerFrameCurrent_ID[pid] != 12 then
        set id = PlayerFrameCurrent_ID[pid]
        call MakeSoundLocal("Pick\\PickPick1", p)
        call TestUnit_CreateSelectedHero(p, id, TestUnitPickMode[pid])
        call TestUnit_CloseHeroPicker(p)
        set testUnitPickHandled = true
    endif

    if clicked == FRAME_Pick[2] and testUnitPickHandled == false and PlayerFrameCurrent_ID[pid] != 0 and PlayerFrameCurrent_ID[pid] != 12 then
        set id = PlayerFrameCurrent_ID[pid]
        if not IsHeroAvailableForPick(id) then
            set PlayerFrameCurrent_ID[pid] = 0
            call ReloadHeroPage(PlayerFrameCurrentPage_ID[pid], p)
            call DisplayTimedTextToPlayer(p, 0, 0, 2, "This hero has already been picked")
            return
        endif
        set BaseX = GetRectCenterX(gg_rct_Pick)
        set BaseY = GetRectCenterY(gg_rct_Pick)
        call MakeSoundLocal("Pick\\PickPick1",p)
        set Hero[pid] = CreateUnit(p, id, BaseX, BaseY, 270)
        call SetFlyInit(Hero[pid])
        //
       // call BlzFrameSetEnable(FRAME_ICON[0], false)
       // call BlzFrameSetEnable(FRAME_ICON2[0], false)
        call BlzFrameSetTexture(FRAME_PlayerPickBack[pid], BlzGetAbilityIcon(id), 0, false)
        if id == Hero_ID0[0] then
            set FRAME_PlayerPickString[pid] = "Raiden Ei"
            call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro3", p)
        elseif id == Hero_ID0[1] then
            set FRAME_PlayerPickString[pid] = "Neuvillette"
            call MakeSoundLocal("war3mapimported\\Hero_Neuvillette_Pick2", p)
        elseif id == Hero_ID0[2] then
            set FRAME_PlayerPickString[pid] = "Patriot"
            call MakeSoundLocal("war3mapimported\\Hero_Patriot_Pick2", p)
        elseif id == Hero_ID1[0] then
            set FRAME_PlayerPickString[pid] = "Kyoraku"
            call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick2", p)
        elseif id == Hero_ID1[1] then
            set FRAME_PlayerPickString[pid] = "BazzB"
            call MakeSoundLocal("war3mapimported\\Hero_BazzB_Pick2", p)
        elseif id == Hero_ID1[2] then
            set FRAME_PlayerPickString[pid] = "Harribel"
            call MakeSoundLocal("war3mapimported\\Hero_Harribel_Pick1", p)
        elseif id == Hero_ID1[3] then
            set FRAME_PlayerPickString[pid] = "Barragan"
            call MakeSoundLocal("war3mapimported\\Hero_Barragan_Pick1", p)
        elseif id == Hero_ID1[4] then
            set FRAME_PlayerPickString[pid] = "Starrk"
            call MakeSoundLocal("war3mapimported\\Hero_Starrk_Pick3", p)
        elseif id == Hero_ID1[5] then
            set FRAME_PlayerPickString[pid] = "Bambietta"
            call MakeSoundLocal("war3mapimported\\Hero_Bambietta_Pick3", p)
        elseif id == Hero_ID2[0] then
            set FRAME_PlayerPickString[pid] = "Natsu"
            set NatsuPicked = true
            call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick3", p)
        elseif id == Hero_ID2[1] then
            set FRAME_PlayerPickString[pid] = "Erza"
            call MakeSoundLocal("war3mapimported\\Hero_Erza_Start2", p)
        elseif id == Hero_ID2[2] then
            set FRAME_PlayerPickString[pid] = "Brandish"
            call MakeSoundLocal("war3mapimported\\Hero_Brandish_Pick3", p)
        elseif id == Hero_ID2[3] then
            set FRAME_PlayerPickString[pid] = "Laxus"
            set LaxusPicked = true
            call MakeSoundLocal("war3mapimported\\Hero_Laxus_Pick3", p)
        elseif id == Hero_ID3[0] then
            set FRAME_PlayerPickString[pid] = "Akainu"
            call MakeSoundLocal("war3mapimported\\Hero_Akainu_Pick5", p)
        elseif id == Hero_ID4[0] then
            set FRAME_PlayerPickString[pid] = "Gojo"
            call MakeSoundLocal("war3mapimported\\Hero_Gojo_E3", p)
        elseif id == Hero_ID5[0] then
            set FRAME_PlayerPickString[pid] = "Giyu"
            call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick2", p)
        elseif id == Hero_ID5[1] then
            set FRAME_PlayerPickString[pid] = "AlterSaber"
            call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick5", p)
        elseif id == Hero_ID4[1] then
            set FRAME_PlayerPickString[pid] = "Kenjaku"
            call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick1", p)
        elseif id == Hero_ID5[2] then
            set FRAME_PlayerPickString[pid] = "Inori"
            call MakeSoundLocal("war3mapimported\\Hero_Inori_Pick4", p)
        elseif id == Hero_ID5[3] then
            set FRAME_PlayerPickString[pid] = "Okarun"
            call MakeSoundLocal("war3mapimported\\Hero_Okarun_Pick2", p)
        elseif id == Hero_ID5[4] then
            set FRAME_PlayerPickString[pid] = "Tsuna"
            call MakeSoundLocal("war3mapimported\\Hero_Tsuna_Pick5", p)
        elseif id == Hero_ID5[5] then
            set FRAME_PlayerPickString[pid] = "Takeshi"
            call MakeSoundLocal("war3mapimported\\Hero_Takeshi_Pick2", p)
        elseif id == Hero_ID5[6] then
            set FRAME_PlayerPickString[pid] = "DarkShiki"
            call MakeSoundLocal("war3mapimported\\Hero_DarkShiki_R01", p)
        elseif id == Hero_ID5[7] then
            set FRAME_PlayerPickString[pid] = "Rimuru"
            call MakeSoundLocal("war3mapimported\\Hero_Rimuru_Pick2", p)
        elseif id == Hero_ID5[8] then
            set FRAME_PlayerPickString[pid] = "Alucard"
            call MakeSoundLocal("war3mapimported\\Hero_Alucard_Pick", p)
        elseif id == Hero_ID4[2] then
            set FRAME_PlayerPickString[pid] = "Mahoraga"
            call MakeSoundLocal("war3mapimported\\Hero_Mahoraga_Pick5", p)
        elseif id == Hero_ID4[3] then
            set FRAME_PlayerPickString[pid] = "Toji"
            call MakeSoundLocal("war3mapimported\\Hero_Toji_Pick5", p)
        elseif id == Hero_ID5[9] then
            set FRAME_PlayerPickString[pid] = "Kirito"
            call MakeSoundLocal("war3mapimported\\Hero_Kirito_Pick1", p)
        elseif id == Hero_ID5[10] then
            set FRAME_PlayerPickString[pid] = "Asta"
            call MakeSoundLocal("war3mapimported\\Hero_Asta_Pick1", p)
        elseif id == Hero_ID5[11] then
            set FRAME_PlayerPickString[pid] = "Ainz"
            call MakeSoundLocal("war3mapimported\\Hero_Ainz_Pick2", p)
        elseif id == Hero_ID5[12] then
            set FRAME_PlayerPickString[pid] = "Frieren"
            call MakeSoundLocal("war3mapimported\\Hero_Frieren_Pick2", p)
        // HERO TRANSFER: Milim / OnClick confirm
        elseif id == Hero_ID5[13] then
            set FRAME_PlayerPickString[pid] = "Milim"
            call MakeSoundLocal("war3mapimported\\Hero_Milim_Pick2", p)
        endif
       // set Hero_ID0[0] = 12
       // call BlzFrameSetTexture(FRAME_ICON2[0], "ReplaceableTextures\\CommandButtons\\BTNCancel", 0, false) 
        if GetLocalPlayer() == p then
    call BlzFrameSetVisible(EmojiMuteButton, true)
call BlzFrameSetVisible(EmojiToggle, true)
    endif
        
        call HideBottomUI(Player(pid), false)
        set PlayerVision[pid] = CreateFogModifierRadius(Player(pid), FOG_OF_WAR_VISIBLE, BaseX, BaseY, 1800, true, false)
        call FogModifierStart(PlayerVision[pid])
        call PanCameraToTimedForPlayer(p, BaseX, BaseY, 0.25)
        call SetCameraFieldForPlayer(p, CAMERA_FIELD_TARGET_DISTANCE, 3500, 0.25)
        call SelectUnitForPlayerSingle(Hero[pid], p)
        if GetLocalPlayer() == p then
            if canShowSwap then
                call BlzFrameSetEnable(FRAME_Swap[pid], true)
                call BlzFrameSetVisible(FRAME_Swap[pid], true)
            endif
            call BlzFrameSetVisible(FRAME_MAIN, false)
            call BlzFrameSetVisible(FRAME_StatusHeroMain, true)
            call BlzFrameSetVisible(FRAME_StatusHeroMain2, true)
            call BlzFrameSetVisible(FRAME_StatusHeroMain3, true)
            call BlzFrameSetVisible(FRAME_StatusHeroMain4, true)
            call BlzFrameSetVisible(FRAME_LINK2, true)
        endif
        call RecommenedItems(p)
        call SaveSystem_SetCurrentHero(p, Hero[pid])
        call EUTU2_3(EffectSpawn("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", GetUnitX(Hero[pid]), GetUnitY(Hero[pid]), 270, 0.85, 1.45, 0), 2.5, 0, Hero[pid])
        call SetHeroLevel(Hero[pid], 2, false)
        call LearnHeroSpells(Hero[pid])
        call TojiStartZeroMana(Hero[pid])
        
        call ReloadAfterPick(p)
        
        set PlayerFrameCurrent_ID[pid] = 0
        call PlayersMsg( GetPlayerColorString(p) + GetPlayerName(p) + "|r picked |c00FFFF00" + BlzGetUnitStringField(Hero[pid], UNIT_SF_NAME) + "|r", 1 )
    endif
    set s = null
    set d = null
    set s_name = null
    set p = null
endfunction
function GuideRefreshAbilityTooltip takes nothing returns nothing
    local integer i = 0
    local integer i2 = 0
    local string s
    local string s_name
    local string tooltipTitle = ""
    local string tooltipExtended = ""
    local string tooltipText = ""
    local integer id = 0
    local integer end = 0
    local player p = GuideTooltipRefreshPlayer
    local integer pid = 0
    local integer hoverSlot = GuideTooltipRefreshSlot
    local integer number_hero
    local real x = 0.025
    local real y = -0.05
    local integer k = 0
    local unit d = null

    // Функция вызывается только программно после выбора героя.
    if p == null or hoverSlot < 0 or hoverSlot >= 7 then
        set p = null
        return
    endif
    set pid = GetPlayerId(p)

    if hoverSlot < 7 then
        if GetLocalPlayer() == p then
            call BlzFrameSetText(FRAME_AbilityTooltipText[hoverSlot], "")
        endif
        if PlayerFrameCurrent_ID[pid] == Hero_ID0[0] then
            set i = 0
            set d = Hero_ID0_Dummy[i]
            if hoverSlot == 0 then
                set id = RaidenQ_ID
            elseif hoverSlot == 1 then
                set id = RaidenW_ID
            elseif hoverSlot == 2 then
                set id = RaidenE_ID
            elseif hoverSlot == 3 then
                set id = RaidenR_ID
            elseif hoverSlot == 4 then
                set id = RaidenT_ID
            elseif hoverSlot == 5 then
                set id = RaidenF_ID
            elseif hoverSlot == 6 then
                set id = RaidenG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID0[1] then
            set i = 1
            set d = Hero_ID0_Dummy[i]
            if hoverSlot == 0 then
                set id = NeuvilletteQ_ID
            elseif hoverSlot == 1 then
                set id = NeuvilletteW_ID
            elseif hoverSlot == 2 then
                set id = NeuvilletteE_ID
            elseif hoverSlot == 3 then
                set id = NeuvilletteR_ID
            elseif hoverSlot == 4 then
                set id = NeuvilletteT_ID
            elseif hoverSlot == 5 then
                set id = NeuvilletteF_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID0[2] then
            set i = 2
            set d = Hero_ID0_Dummy[i]
            if hoverSlot == 0 then
                set id = PatriotQ_ID
            elseif hoverSlot == 1 then
                set id = PatriotW_ID
            elseif hoverSlot == 2 then
                set id = PatriotE_ID
            elseif hoverSlot == 3 then
                set id = PatriotR_ID
            elseif hoverSlot == 4 then
                set id = PatriotT_ID
            elseif hoverSlot == 5 then
                set id = PatriotF_ID
            elseif hoverSlot == 6 then
                set id = PatriotG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[0] then
            set i = 0
            set d = Hero_ID1_Dummy[i]
            if hoverSlot == 0 then
                set id = KyorakuQ_ID
            elseif hoverSlot == 1 then
                set id = KyorakuW_ID
            elseif hoverSlot == 2 then
                set id = KyorakuE_ID
            elseif hoverSlot == 3 then
                set id = KyorakuR_ID
            elseif hoverSlot == 4 then
                set id = KyorakuT_ID
            elseif hoverSlot == 5 then
                set id = KyorakuF_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[1] then
            set i = 1
            set d = Hero_ID1_Dummy[i]
            if hoverSlot == 0 then
                set id = BazzBQ_ID
            elseif hoverSlot == 1 then
                set id = BazzBW_ID
            elseif hoverSlot == 2 then
                set id = BazzBE_ID
            elseif hoverSlot == 3 then
                set id = BazzBR_ID
            elseif hoverSlot == 4 then
                set id = BazzBT_ID
            elseif hoverSlot == 6 then
                set id = BazzBG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[2] then
            set i = 2
            set d = Hero_ID1_Dummy[i]
            if hoverSlot == 0 then
                set id = HarribelQ_ID
            elseif hoverSlot == 1 then
                set id = HarribelW_ID
            elseif hoverSlot == 2 then
                set id = HarribelE_ID
            elseif hoverSlot == 3 then
                set id = HarribelR_ID
            elseif hoverSlot == 4 then
                set id = HarribelT_ID
            elseif hoverSlot == 6 then
                set id = HarribelG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[3] then
            set i = 3
            set d = Hero_ID1_Dummy[i]
            if hoverSlot == 0 then
                set id = BarraganQ_ID
            elseif hoverSlot == 1 then
                set id = BarraganW_ID
            elseif hoverSlot == 2 then
                set id = BarraganE_ID
            elseif hoverSlot == 3 then
                set id = BarraganR_ID
            elseif hoverSlot == 4 then
                set id = BarraganT_ID
            elseif hoverSlot == 6 then
                set id = BarraganG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[4] then
            set i = 4
            set d = Hero_ID1_Dummy[i]
            if hoverSlot == 0 then
                set id = StarrkQ_ID
            elseif hoverSlot == 1 then
                set id = StarrkW_ID
            elseif hoverSlot == 2 then
                set id = StarrkE_ID
            elseif hoverSlot == 3 then
                set id = StarrkR_ID
            elseif hoverSlot == 4 then
                set id = StarrkT_ID
            elseif hoverSlot == 6 then
                set id = StarrkG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[5] then
            set i = 5
            set d = Hero_ID1_Dummy[i]
            if hoverSlot == 0 then
                set id = BambiettaQ_ID
            elseif hoverSlot == 1 then
                set id = BambiettaW_ID
            elseif hoverSlot == 2 then
                set id = BambiettaE_ID
            elseif hoverSlot == 3 then
                set id = BambiettaR_ID
            elseif hoverSlot == 4 then
                set id = BambiettaT_ID
            elseif hoverSlot == 6 then
                set id = BambiettaG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID2[0] then
            set i = 0
            set d = Hero_ID2_Dummy[i]
            if hoverSlot == 0 then
                set id = NatsuQ_ID
            elseif hoverSlot == 1 then
                set id = NatsuW_ID
            elseif hoverSlot == 2 then
                set id = NatsuE_ID
            elseif hoverSlot == 3 then
                set id = NatsuR_ID
            elseif hoverSlot == 4 then
                set id = NatsuT_ID
            elseif hoverSlot == 5 then
                set id = NatsuF_ID
            elseif hoverSlot == 6 then
                set id = NatsuG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID2[1] then
            set i = 1
            set d = Hero_ID2_Dummy[i]
            if hoverSlot == 0 then
                set id = ErzaQ_ID
                if GetLocalPlayer() == p then
                    call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_ErzaQ_port", 0, false)
                endif
            elseif hoverSlot == 1 then
                set id = ErzaW_ID
                if GetLocalPlayer() == p then
                    call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_ErzaW_port", 0, false)
                endif
            elseif hoverSlot == 2 then
                set id = ErzaE_ID
                if GetLocalPlayer() == p then
                    call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_ErzaE_port", 0, false)
                endif
            elseif hoverSlot == 3 then
                set id = ErzaR_ID
                if GetLocalPlayer() == p then
                    call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_ErzaR_port", 0, false)
                endif
            elseif hoverSlot == 4 then
                set id = ErzaT_ID
                if GetLocalPlayer() == p then
                    call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_ErzaT_port", 0, false)
                endif
            elseif hoverSlot == 5 then
                set id = ErzaF_ID
                if GetLocalPlayer() == p then
                    call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_Erza_port", 0, false)
                endif
            elseif hoverSlot == 6 then
                set id = ErzaG_ID
                if GetLocalPlayer() == p then
                    call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_Erza_port", 0, false)
                endif
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID2[2] then
            set i = 2
            set d = Hero_ID2_Dummy[i]
            if hoverSlot == 0 then
                set id = BrandishQ_ID
            elseif hoverSlot == 1 then
                set id = BrandishW_ID
            elseif hoverSlot == 2 then
                set id = BrandishE_ID
            elseif hoverSlot == 3 then
                set id = BrandishR_ID
            elseif hoverSlot == 4 then
                set id = BrandishT_ID
            elseif hoverSlot == 5 then
                set id = BrandishF_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID2[3] then
            set i = 3
            set d = Hero_ID2_Dummy[i]
            if hoverSlot == 0 then
                set id = LaxusQ_ID
            elseif hoverSlot == 1 then
                set id = LaxusW_ID
            elseif hoverSlot == 2 then
                set id = LaxusE_ID
            elseif hoverSlot == 3 then
                set id = LaxusR_ID
            elseif hoverSlot == 4 then
                set id = LaxusT_ID
            elseif hoverSlot == 5 then
                set id = LaxusF_ID
            elseif hoverSlot == 6 then
                set id = LaxusG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID3[0] then
            set i = 0
            set d = Hero_ID3_Dummy[i]
            if hoverSlot == 0 then
                set id = AkainuQ_ID
            elseif hoverSlot == 1 then
                set id = AkainuW_ID
            elseif hoverSlot == 2 then
                set id = AkainuE_ID
            elseif hoverSlot == 3 then
                set id = AkainuR_ID
            elseif hoverSlot == 4 then
                set id = AkainuT_ID
            elseif hoverSlot == 5 then
                set id = AkainuF_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[0] then
            set i = 0
            set d = Hero_ID4_Dummy[i]
            if hoverSlot == 0 then
                set id = GojoQ_ID
            elseif hoverSlot == 1 then
                set id = GojoW_ID
            elseif hoverSlot == 2 then
                set id = GojoE_ID
            elseif hoverSlot == 3 then
                set id = GojoR_ID
            elseif hoverSlot == 4 then
                set id = GojoT_ID
            elseif hoverSlot == 6 then
                set id = GojoG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[0] then
            set i = 0
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = TomiokaQ_ID
            elseif hoverSlot == 1 then
                set id = TomiokaW_ID
            elseif hoverSlot == 2 then
                set id = TomiokaE_ID
            elseif hoverSlot == 3 then
                set id = TomiokaR_ID
            elseif hoverSlot == 4 then
                set id = TomiokaT_ID
            elseif hoverSlot == 5 then
                set id = TomiokaF_ID
            elseif hoverSlot == 6 then
                set id = TomiokaG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[1] then
            set i = 1
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = AlterSaberQ_ID
            elseif hoverSlot == 1 then
                set id = AlterSaberW_ID
            elseif hoverSlot == 2 then
                set id = AlterSaberE_ID
            elseif hoverSlot == 3 then
                set id = AlterSaberR_ID
            elseif hoverSlot == 4 then
                set id = AlterSaberT_ID
            elseif hoverSlot == 5 then
                set id = AlterSaberF_ID
            elseif hoverSlot == 6 then
                set id = AlterSaberG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[1] then
            set i = 1
            set d = Hero_ID4_Dummy[i]
            if hoverSlot == 0 then
                set id = KenjakuQ_ID
            elseif hoverSlot == 1 then
                set id = KenjakuW_ID
            elseif hoverSlot == 2 then
                set id = KenjakuE_ID
            elseif hoverSlot == 3 then
                set id = KenjakuR_ID
            elseif hoverSlot == 4 then
                set id = KenjakuT_ID
            elseif hoverSlot == 5 then
                set id = KenjakuF_ID
            elseif hoverSlot == 6 then
                set id = KenjakuG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[2] then
            set i = 2
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = InoriQ_ID
            elseif hoverSlot == 1 then
                set id = InoriW_ID
            elseif hoverSlot == 2 then
                set id = InoriE_ID
            elseif hoverSlot == 3 then
                set id = InoriR_ID
            elseif hoverSlot == 4 then
                set id = InoriT_ID
            elseif hoverSlot == 5 then
                set id = InoriF_ID
            elseif hoverSlot == 6 then
                set id = InoriG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[3] then
            set i = 3
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = OkarunQ_ID
            elseif hoverSlot == 1 then
                set id = OkarunW_ID
            elseif hoverSlot == 2 then
                set id = OkarunE_ID
            elseif hoverSlot == 3 then
                set id = OkarunR_ID
            elseif hoverSlot == 4 then
                set id = OkarunT_ID
            elseif hoverSlot == 5 then
                set id = OkarunF_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[4] then
            set i = 4
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = TsunaQ_ID
            elseif hoverSlot == 1 then
                set id = TsunaW_ID
            elseif hoverSlot == 2 then
                set id = TsunaE_ID
            elseif hoverSlot == 3 then
                set id = TsunaR_ID
            elseif hoverSlot == 4 then
                set id = TsunaT_ID
            elseif hoverSlot == 5 then
                set id = TsunaF_ID
            elseif hoverSlot == 6 then
                set id = TsunaG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[5] then
            set i = 5
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = TakeshiQ_ID
            elseif hoverSlot == 1 then
                set id = TakeshiW_ID
            elseif hoverSlot == 2 then
                set id = TakeshiE_ID
            elseif hoverSlot == 3 then
                set id = TakeshiR_ID
            elseif hoverSlot == 4 then
                set id = TakeshiT_ID
            elseif hoverSlot == 5 then
                set id = TakeshiF_ID
            elseif hoverSlot == 6 then
                set id = TakeshiG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[6] then
            set i = 6
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = DarkShikiQ_ID
            elseif hoverSlot == 1 then
                set id = DarkShikiW_ID
            elseif hoverSlot == 2 then
                set id = DarkShikiE_ID
            elseif hoverSlot == 3 then
                set id = DarkShikiR_ID
            elseif hoverSlot == 4 then
                set id = DarkShikiT_ID
            elseif hoverSlot == 5 then
                set id = DarkShikiF_ID
            elseif hoverSlot == 6 then
                set id = DarkShikiG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[7] then
            set i = 7
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = RimuruQ_ID
            elseif hoverSlot == 1 then
                set id = RimuruW_ID
            elseif hoverSlot == 2 then
                set id = RimuruE_ID
            elseif hoverSlot == 3 then
                set id = RimuruR_ID
            elseif hoverSlot == 4 then
                set id = RimuruT_ID
            elseif hoverSlot == 5 then
                set id = RimuruF_ID
            elseif hoverSlot == 6 then
                set id = RimuruG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[8] then
            set i = 8
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = AlucardQ_ID
            elseif hoverSlot == 1 then
                set id = AlucardW_ID
            elseif hoverSlot == 2 then
                set id = AlucardE_ID
            elseif hoverSlot == 3 then
                set id = AlucardR_ID
            elseif hoverSlot == 4 then
                set id = AlucardT_ID
            elseif hoverSlot == 5 then
                set id = AlucardF_ID
            elseif hoverSlot == 6 then
                set id = AlucardG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[2] then
            set i = 2
            set d = Hero_ID4_Dummy[i]
            if hoverSlot == 0 then
                set id = MahoragaQ_ID
            elseif hoverSlot == 1 then
                set id = MahoragaW_ID
            elseif hoverSlot == 2 then
                set id = MahoragaE_ID
            elseif hoverSlot == 3 then
                set id = MahoragaR_ID
            elseif hoverSlot == 4 then
                set id = MahoragaT_ID
            elseif hoverSlot == 5 then
                set id = MahoragaF_ID
            elseif hoverSlot == 6 then
                set id = MahoragaG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[3] then
            set i = 3
            set d = Hero_ID4_Dummy[i]
            if hoverSlot == 0 then
                set id = TojiQ_ID
            elseif hoverSlot == 1 then
                set id = TojiW_ID
            elseif hoverSlot == 2 then
                set id = TojiE_ID
            elseif hoverSlot == 3 then
                set id = TojiR_ID
            elseif hoverSlot == 4 then
                set id = TojiT_ID
            elseif hoverSlot == 5 then
                set id = TojiF_ID
            elseif hoverSlot == 6 then
                set id = TojiG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[9] then
            set i = 9
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = KiritoQ_ID
            elseif hoverSlot == 1 then
                set id = KiritoW_ID
            elseif hoverSlot == 2 then
                set id = KiritoE_ID
            elseif hoverSlot == 3 then
                set id = KiritoR_ID
            elseif hoverSlot == 4 then
                set id = KiritoT_ID
            elseif hoverSlot == 5 then
                set id = KiritoF_ID
            elseif hoverSlot == 6 then
                set id = KiritoG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[10] then
            set i = 10
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = AstaQ_ID
            elseif hoverSlot == 1 then
                set id = AstaW_ID
            elseif hoverSlot == 2 then
                set id = AstaE_ID
            elseif hoverSlot == 3 then
                set id = AstaR_ID
            elseif hoverSlot == 4 then
                set id = AstaT_ID
            elseif hoverSlot == 5 then
                set id = AstaF_ID
            elseif hoverSlot == 6 then
                set id = AstaG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[11] then
            set i = 11
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = AinzQ_ID
            elseif hoverSlot == 1 then
                set id = AinzW_ID
            elseif hoverSlot == 2 then
                set id = AinzE_ID
            elseif hoverSlot == 3 then
                set id = AinzR_ID
            elseif hoverSlot == 4 then
                set id = AinzT_ID
            elseif hoverSlot == 5 then
                set id = AinzF_ID
            elseif hoverSlot == 6 then
                set id = AinzG_ID
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[12] then
            set i = 12
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = FrierenQ_ID
            elseif hoverSlot == 1 then
                set id = FrierenW_ID
            elseif hoverSlot == 2 then
                set id = FrierenE_ID
            elseif hoverSlot == 3 then
                set id = FrierenR_ID
            elseif hoverSlot == 4 then
                set id = FrierenT_ID
            elseif hoverSlot == 5 then
                set id = FrierenF_ID
            elseif hoverSlot == 6 then
                set id = FrierenG_ID
            endif
        // HERO TRANSFER: Milim / GuideRefreshAbilityTooltip
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID5[13] then
            set i = 13
            set d = Hero_ID5_Dummy[i]
            if hoverSlot == 0 then
                set id = MilimQ_ID
            elseif hoverSlot == 1 then
                set id = MilimW_ID
            elseif hoverSlot == 2 then
                set id = MilimE_ID
            elseif hoverSlot == 3 then
                set id = MilimR_ID
            elseif hoverSlot == 4 then
                set id = MilimT_ID
            elseif hoverSlot == 5 then
                set id = MilimF_ID
            elseif hoverSlot == 6 then
                set id = MilimG_ID
            endif
        endif
        if id != 0 then
            set tooltipTitle = BlzGetAbilityStringLevelField(BlzGetUnitAbility(d, id), ABILITY_SLF_TOOLTIP_LEARN, 1)
            if tooltipTitle != "Tool tip missing!" then
                set tooltipExtended = BlzGetAbilityStringLevelField(BlzGetUnitAbility(d, id), ABILITY_SLF_TOOLTIP_LEARN_EXTENDED, 0)
            else
                set tooltipTitle = BlzGetAbilityStringLevelField(BlzGetUnitAbility(d, id), ABILITY_SLF_TOOLTIP_NORMAL, 0)
                set tooltipExtended = BlzGetAbilityStringLevelField(BlzGetUnitAbility(d, id), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, 0)
            endif
            set tooltipText = tooltipTitle + "|n|n" + tooltipExtended
            if GetLocalPlayer() == p then
                call BlzFrameSetText(FRAME_AbilityTooltipText[hoverSlot], tooltipText)
            endif
        endif
    endif
    set i = 0
    set d = null
    set p = null
endfunction
// Создаёт постоянную нативную подсказку для одной кнопки способности.
// BlzFrameSetTooltip сам отслеживает реальный вход и выход курсора.
function GuideCreateAbilityTooltip takes integer slot returns nothing
    local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "AbilityNativeTooltip", FRAME_MAIN3, "", 8000 + slot)
    local framehandle tooltipText = BlzCreateFrameByType("TEXT", "AbilityNativeTooltipText", tooltip, "", 8100 + slot)

    call BlzFrameSetAbsPoint(tooltip, FRAMEPOINT_CENTER, 0.645, 0.39)
    call BlzFrameSetSize(tooltip, 0.19, 0.19)
    call BlzFrameSetTexture(tooltip, "Textures\\black32.blp", 0, true)
    call BlzFrameSetAlpha(tooltip, 235)
    call BlzFrameSetLevel(tooltip, 50)

    call BlzFrameSetAllPoints(tooltipText, tooltip)
    call BlzFrameSetTextAlignment(tooltipText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
    call BlzFrameSetScale(tooltipText, 1.00)
    call BlzFrameSetText(tooltipText, "")

    call BlzFrameSetVisible(tooltip, false)
    call BlzFrameSetTooltip(FRAME_ICON5[slot], tooltip)

    set FRAME_AbilityTooltip[slot] = tooltip
    set FRAME_AbilityTooltipText[slot] = tooltipText
    set tooltipText = null
    set tooltip = null
endfunction

function CreateUI takes nothing returns nothing
    local integer i = 0
    local integer i2 = 0
    local integer k = 0
    local real x = 0.025
    local real y = -0.05
    local framehandle border
    set FrameClick = CreateTrigger()
    set FrameGuideRefresh = CreateTrigger()
    // === Р В РІР‚СљР В Р’В»Р В Р’В°Р В Р вЂ Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р В РЎвЂќР В РЎвЂўР В Р вЂ¦Р РЋРІР‚С™Р В Р’ВµР В РІвЂћвЂ“Р В Р вЂ¦Р В Р’ВµР РЋР вЂљ ===
    set FRAME_MAIN = BlzCreateFrame("EscMenuBackdrop", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
    call BlzFrameSetAbsPoint(FRAME_MAIN, FRAMEPOINT_CENTER, 0.4, 0.32)
    call BlzFrameSetSize(FRAME_MAIN, 0.85, 0.5)
    set FRAME_MAIN2 = BlzCreateFrame("EscMenuBackdrop", FRAME_MAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_MAIN2, FRAMEPOINT_CENTER, 0.35, 0.35)
    call BlzFrameSetSize(FRAME_MAIN2, 0.3, 0.4)
    set FRAME_MAIN3 = BlzCreateFrame("EscMenuBackdrop", FRAME_MAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_MAIN3, FRAMEPOINT_CENTER, 0.645, 0.35)
    call BlzFrameSetSize(FRAME_MAIN3, 0.3, 0.4)
    set FRAME_HeroName = BlzCreateFrameByType("GLUETEXTBUTTON", "MyHeroNameButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroName, FRAMEPOINT_CENTER, 0.645, 0.51)
    call BlzFrameSetSize(FRAME_HeroName, 0.15, 0.03)
    call BlzFrameSetText(FRAME_HeroName, "Hero Name")
    call BlzTriggerRegisterFrameEvent(FrameClick, FRAME_HeroName, FRAMEEVENT_CONTROL_CLICK)
    set FRAME_PlayerPickDifficultText = BlzCreateFrameByType("TEXT", "MyHeroNameButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_PlayerPickDifficultText, FRAMEPOINT_CENTER, 0.395, 0.0675)
    call BlzFrameSetSize(FRAME_PlayerPickDifficultText, 0.095, 0.055)
    call BlzFrameSetText(FRAME_PlayerPickDifficultText, "")
    call BlzFrameSetScale(FRAME_PlayerPickDifficultText, 2.4)
    call BlzFrameSetVisible(FRAME_PlayerPickDifficultText, false)
    call BlzFrameSetLevel(FRAME_PlayerPickDifficultText, 4)
    set FRAME_HeroModel = BlzCreateFrameByType("BACKDROP", "Port", FRAME_MAIN3, "", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroModel, FRAMEPOINT_CENTER, 0.645, 0.39)
    call BlzFrameSetSize(FRAME_HeroModel, 0.19, 0.19)
    call BlzFrameSetTexture(FRAME_HeroModel, "Textures\\black32.blp", 0, false)
    // Модель также остается прозрачной для событий мыши.
    call BlzFrameSetEnable(FRAME_HeroModel, false)
    call BlzFrameSetLevel(FRAME_HeroModel, 2) // Р В РЎвЂ”Р В РЎвЂўР В Р вЂ Р В Р’ВµР РЋР вЂљР РЋРІР‚В¦ Р В РЎвЂќР В РЎвЂўР В Р вЂ¦Р РЋРІР‚С™Р В Р’ВµР В РІвЂћвЂ“Р В Р вЂ¦Р В Р’ВµР РЋР вЂљР В Р’В°
    set border = BlzCreateFrameByType("BACKDROP", "ThinBorder", FRAME_MAIN3, "", 0)
    call BlzFrameSetAbsPoint(border, FRAMEPOINT_CENTER, 0.645, 0.39)
    call BlzFrameSetTexture(border, "Textures\\black32.blp", 0, true)
    call BlzFrameSetSize(border, 0.2, 0.2) // Р РЋРІР‚РЋР РЋРЎвЂњР РЋРІР‚С™Р РЋР Р‰ Р В Р’В±Р В РЎвЂўР В Р’В»Р РЋР Р‰Р РЋРІвЂљВ¬Р В Р’Вµ Р В РЎвЂќР В РЎвЂўР В Р вЂ¦Р РЋРІР‚С™Р В Р’ВµР В РІвЂћвЂ“Р В Р вЂ¦Р В Р’ВµР РЋР вЂљР В Р’В°, Р РЋРІР‚РЋР РЋРІР‚С™Р В РЎвЂўР В Р’В±Р РЋРІР‚в„– Р РЋР вЂљР В Р’В°Р В РЎВР В РЎвЂќР В Р’В° Р В Р вЂ Р В РЎвЂР В РўвЂР В Р вЂ¦Р В Р’В°
    call BlzFrameSetLevel(border, 0) // Р В РЎвЂ”Р В РЎвЂўР В Р вЂ Р В Р’ВµР РЋР вЂљР РЋРІР‚В¦ Р В РЎвЂќР В РЎвЂўР В Р вЂ¦Р РЋРІР‚С™Р В Р’ВµР В РІвЂћвЂ“Р В Р вЂ¦Р В Р’ВµР РЋР вЂљР В Р’В°
    set FRAME_HeroAttribute = BlzCreateFrameByType("BACKDROP", "attribute", FRAME_MAIN3, "", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroAttribute, FRAMEPOINT_CENTER, 0.54, 0.5075)
    call BlzFrameSetSize(FRAME_HeroAttribute, 0.0375, 0.0375)
    call BlzFrameSetTexture(FRAME_HeroAttribute, "Textures\\black32.blp", 0, true)
    call BlzFrameSetVisible(FRAME_HeroAttribute, false)
    call BlzFrameSetLevel(FRAME_HeroAttribute, 2) // Р В РЎвЂ”Р В РЎвЂўР В Р вЂ Р В Р’ВµР РЋР вЂљР РЋРІР‚В¦ Р В РЎвЂќР В РЎвЂўР В Р вЂ¦Р РЋРІР‚С™Р В Р’ВµР В РІвЂћвЂ“Р В Р вЂ¦Р В Р’ВµР РЋР вЂљР В Р’В°
    set FRAME_HeroAttackType = BlzCreateFrameByType("BACKDROP", "atk", FRAME_MAIN3, "", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroAttackType, FRAMEPOINT_CENTER, 0.755, 0.51)
    call BlzFrameSetSize(FRAME_HeroAttackType, 0.0315, 0.0315)
    call BlzFrameSetTexture(FRAME_HeroAttackType, "Textures\\black32.blp", 0, true)
    call BlzFrameSetVisible(FRAME_HeroAttackType, false)
    call BlzFrameSetLevel(FRAME_HeroAttackType, 2) // Р В РЎвЂ”Р В РЎвЂўР В Р вЂ Р В Р’ВµР РЋР вЂљР РЋРІР‚В¦ Р В РЎвЂќР В РЎвЂўР В Р вЂ¦Р РЋРІР‚С™Р В Р’ВµР В РІвЂћвЂ“Р В Р вЂ¦Р В Р’ВµР РЋР вЂљР В Р’В°
    set FRAME_HeroStr = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroStr, FRAMEPOINT_CENTER, 0.5955, 0.245)
    call BlzFrameSetSize(FRAME_HeroStr, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroStr, false)
    call BlzFrameSetScale(FRAME_HeroStr, 1.4)
    set FRAME_HeroAgi = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroAgi, FRAMEPOINT_CENTER, 0.5955, 0.225)
    call BlzFrameSetSize(FRAME_HeroAgi, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroAgi, false)
    call BlzFrameSetScale(FRAME_HeroAgi, 1.4)
    set FRAME_HeroInt = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroInt, FRAMEPOINT_CENTER, 0.5955, 0.205)
    call BlzFrameSetSize(FRAME_HeroInt, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroInt, false)
    call BlzFrameSetScale(FRAME_HeroInt, 1.4)
    set FRAME_HeroAtk = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroAtk, FRAMEPOINT_CENTER, 0.665, 0.256)
    call BlzFrameSetSize(FRAME_HeroAtk, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroAtk, false)
    call BlzFrameSetScale(FRAME_HeroAtk, 1.1)
    set FRAME_HeroArmor = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroArmor, FRAMEPOINT_CENTER, 0.665, 0.241)
    call BlzFrameSetSize(FRAME_HeroArmor, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroArmor, false)
    call BlzFrameSetScale(FRAME_HeroArmor, 1.1)
    set FRAME_HeroMS = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroMS, FRAMEPOINT_CENTER, 0.665, 0.226)
    call BlzFrameSetSize(FRAME_HeroMS, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroMS, false)
    call BlzFrameSetScale(FRAME_HeroMS, 1.1)
    set FRAME_HeroAS = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroAS, FRAMEPOINT_CENTER, 0.665, 0.211)
    call BlzFrameSetSize(FRAME_HeroAS, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroAS, false)
    call BlzFrameSetScale(FRAME_HeroAS, 1.1)
    set i = 0
    loop
        exitwhen i == bj_MAX_PLAYERS
        set PlayerFrameCurrentPage_ID[i] = 0 // Р РЋРЎвЂњР РЋР С“Р РЋРІР‚С™Р В Р’В°Р В Р вЂ¦Р В Р’В°Р В Р вЂ Р В Р’В»Р В РЎвЂР В Р вЂ Р В Р’В°Р В Р’ВµР В РЎВ Р В Р вЂ Р РЋР С“Р В Р’ВµР РЋРІР‚В¦ Р В РЎвЂР В РЎвЂ“Р РЋР вЂљР В РЎвЂўР В РЎвЂќР В РЎвЂўР В Р вЂ  Р В Р вЂ¦Р В Р’В° 0 Р РЋР вЂљР В Р’В°Р В Р’В·Р В РўвЂР В Р’ВµР В Р’В» Р В РЎвЂ“Р В Р’ВµР РЋР вЂљР В РЎвЂўР В Р вЂ 
        set i = i + 1
    endloop
    set i = 0
    set k = 0
    loop
        exitwhen k == 5
        set FRAME_Pick[k] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_MAIN2, "ScoreScreenTabButtonTemplate", 0)
        set FRAME_ICON_Pick[k] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_Pick[k], "", 0)
        call BlzFrameSetAllPoints(FRAME_ICON_Pick[k], FRAME_Pick[k])
        call BlzFrameSetPoint(FRAME_Pick[k], FRAMEPOINT_LEFT, FRAME_MAIN2, FRAMEPOINT_TOPLEFT, x + 0.05 * k, -0.3525 )// - 0.03 * i)
        call BlzFrameSetSize(FRAME_Pick[k], 0.05, 0.05)
        if k == 0 then
            call BlzFrameSetTexture(FRAME_ICON_Pick[k], "Pick\\PickButton_Page_Left", 0, true)
            call BlzFrameSetSize(FRAME_Pick[k], 0.037, 0.037)
        elseif k == 1 then
            call BlzFrameSetTexture(FRAME_ICON_Pick[k], "Pick\\PickButton_Page_Right", 0, true)
            call BlzFrameSetSize(FRAME_Pick[k], 0.037, 0.037)
        elseif k == 2 then
            call BlzFrameSetTexture(FRAME_ICON_Pick[k], "Pick\\PickButton_Pick_Manual2", 0, true)
        elseif k == 3 then
            call BlzFrameSetTexture(FRAME_ICON_Pick[k], "Pick\\PickButton_Pick_Random2", 0, true)
        elseif k == 4 then
            call BlzFrameSetTexture(FRAME_ICON_Pick[k], "Pick\\PickButton_Pick_Ban", 0, true)
            call BlzFrameSetSize(FRAME_Pick[k], 0.05, 0.05)
        endif
        // disable ALL pick buttons initially, enable after pre-pick
        if k == 1 or k == 0 then
            call BlzFrameSetEnable(FRAME_Pick[k], false)
            call BlzFrameSetEnable(FRAME_ICON_Pick[k], false)
        endif
        if k == 2 then // manual pick - disabled until pre - pick ends
            call BlzFrameSetEnable(FRAME_Pick[k], false)
        endif
        if k == 3 then // random - disabled until 1 sec before pre - pick ends
            call BlzFrameSetEnable(FRAME_Pick[k], false)
        endif
        if k == 4 then
            call BlzFrameSetEnable(FRAME_Pick[k], true)
        endif
        call BlzTriggerRegisterFrameEvent(FrameClick, FRAME_Pick[k], FRAMEEVENT_CONTROL_CLICK)
        set k = k + 1
    endloop
    set k = 0
    set i = 0
    loop
        exitwhen i == 30
        // Р В РЎв„ўР В Р’В»Р В РЎвЂР В РЎвЂќР В Р’В°Р В Р’В±Р В Р’ВµР В Р’В»Р РЋР Р‰Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р РЋРІР‚С›Р РЋР вЂљР В Р’ВµР В РІвЂћвЂ“Р В РЎВ (Р В РЎвЂќР В Р вЂ¦Р В РЎвЂўР В РЎвЂ”Р В РЎвЂќР В Р’В°)
        set FRAME_ICON[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_MAIN2, "ScoreScreenTabButtonTemplate", 0)
        set FRAME_ICON2[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ICON[i], "", 0)
        call BlzFrameSetTexture(FRAME_ICON[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
        call BlzFrameSetAllPoints(FRAME_ICON2[i], FRAME_ICON[i])
        call BlzFrameSetPoint(FRAME_ICON[i], FRAMEPOINT_LEFT, FRAME_MAIN2, FRAMEPOINT_TOPLEFT, x + 0.05 * k, y )// - 0.03 * i)
    //call BlzFrameSetAbsPoint(FRAME_ICON[i], FRAMEPOINT_CENTER, -0.11, 0.21)
        call BlzFrameSetSize(FRAME_ICON[i], 0.05, 0.05)
        if true then//Hero_ID0[i] != 0 then
            call BlzFrameSetTexture(FRAME_ICON2[i], BlzGetAbilityIcon(Hero_ID0[i]), 0, false)
            call BlzTriggerRegisterFrameEvent(FrameClick, FRAME_ICON[i], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetTexture(FRAME_ICON2[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
            call BlzFrameSetEnable(FRAME_ICON2[i], false)
            call BlzFrameSetEnable(FRAME_ICON[i], false)
        endif
        // Р В РЎв„ўР В Р’В»Р В РЎвЂР В РЎвЂќ
        set k = k + 1
        set i = i + 1
        if i == 5 or i == 10 or i == 15 or i == 20 or i == 25 or i == 30 then
            set k = 0
            set y = y - 0.05
        endif
    endloop
    set i2 = 0
    set y = -0.06
    set x = 0.03
    set i = 0
    loop
        exitwhen i == 6
        // Р В РЎв„ўР В Р’В»Р В РЎвЂР В РЎвЂќР В Р’В°Р В Р’В±Р В Р’ВµР В Р’В»Р РЋР Р‰Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р РЋРІР‚С›Р РЋР вЂљР В Р’ВµР В РІвЂћвЂ“Р В РЎВ (Р В РЎвЂќР В Р вЂ¦Р В РЎвЂўР В РЎвЂ”Р В РЎвЂќР В Р’В°)
        set Frame_PageHeroList[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_MAIN2, "ScoreScreenTabButtonTemplate", 0)
        set Frame_PageHeroListImage[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", Frame_PageHeroList[i], "", 0)
        call BlzFrameSetTexture(Frame_PageHeroList[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
        call BlzFrameSetAllPoints(Frame_PageHeroListImage[i], Frame_PageHeroList[i])
        call BlzFrameSetPoint(Frame_PageHeroList[i], FRAMEPOINT_LEFT, FRAME_MAIN, FRAMEPOINT_TOPLEFT, x, y )
        call BlzFrameSetSize(Frame_PageHeroList[i], 0.185, 0.05)
        if i == 0 then
            call BlzFrameSetTexture(Frame_PageHeroListImage[i], "Pick\\Pick_Gacha.blp", 0, true)
        elseif i == 1 then
            call BlzFrameSetTexture(Frame_PageHeroListImage[i], "Pick\\Pick_Bleach.blp", 0, true)
        elseif i == 2 then
            call BlzFrameSetTexture(Frame_PageHeroListImage[i], "Pick\\Pick_FairyTail.blp", 0, true)
        elseif i == 3 then
            call BlzFrameSetTexture(Frame_PageHeroListImage[i], "Pick\\Pick_OnePiece.blp", 0, true)
        elseif i == 4 then
            call BlzFrameSetTexture(Frame_PageHeroListImage[i], "Pick\\Pick_JujutsuKaisen.blp", 0, true)
        elseif i == 5 then
            call BlzFrameSetTexture(Frame_PageHeroListImage[i], "Pick\\Pick_Other.blp", 0, true)
        else
            call BlzFrameSetTexture(Frame_PageHeroListImage[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, true)
        endif
       // call BlzFrameSetLevel(Frame_PageHeroListImage[i],10)
    // Р В РЎв„ўР В Р’В»Р В РЎвЂР В РЎвЂќ
        call BlzTriggerRegisterFrameEvent(FrameClick, Frame_PageHeroList[i], FRAMEEVENT_CONTROL_CLICK)
        set i = i + 1
        set y = y - 0.065
    endloop
    set i = 0
    loop
        exitwhen i == 10
        set FRAME_Repick[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", BlzGetFrameByName("ConsoleUIBackdrop", 0), "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize(FRAME_Repick[i], 0.05, 0.05)
        call BlzTriggerRegisterFrameEvent(FrameClick, FRAME_Repick[i], FRAMEEVENT_CONTROL_CLICK)
        set FRAME_RepickHover[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_Repick[i], "", 0)
        call BlzFrameSetTexture(FRAME_RepickHover[i], "Pick\\RepickButton", 0, true)
        call BlzFrameSetAllPoints(FRAME_RepickHover[i], FRAME_Repick[i])
        call BlzFrameSetAbsPoint(FRAME_Repick[i], FRAMEPOINT_CENTER, -0.1085, 0.43 )//0.5
        set FRAME_RepickText[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_Repick[i], "", 0)
        call BlzFrameSetTexture(FRAME_RepickText[i], "Pick\\RepickButtonText", 0, true)
        call BlzFrameSetSize(FRAME_RepickText[i], 0.06, 0.02)
        call BlzFrameSetPoint(FRAME_RepickText[i], FRAMEPOINT_LEFT, FRAME_Repick[i], FRAMEPOINT_TOPLEFT, 0., -0.0575 )
        call BlzFrameSetEnable(FRAME_Repick[i], false)
        call BlzFrameSetVisible(FRAME_Repick[i], false)
        set FRAME_Swap[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", BlzGetFrameByName("ConsoleUIBackdrop", 0), "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize(FRAME_Swap[i], 0.04, 0.04)
        call BlzTriggerRegisterFrameEvent(FrameClick, FRAME_Swap[i], FRAMEEVENT_CONTROL_CLICK)
        set FRAME_SwapHover[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_Swap[i], "", 0)
        call BlzFrameSetTexture(FRAME_SwapHover[i], "Pick\\SwapButton", 0, true)
        call BlzFrameSetAllPoints(FRAME_SwapHover[i], FRAME_Swap[i])
        call BlzFrameSetAbsPoint(FRAME_Swap[i], FRAMEPOINT_CENTER, -0.1085, 0.5 )// 0.435
        set FRAME_SwapText[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_Swap[i], "", 0)
        call BlzFrameSetTexture(FRAME_SwapText[i], "Pick\\SwapButtonText", 0, true)
        call BlzFrameSetSize(FRAME_SwapText[i], 0.055, 0.0175)
        call BlzFrameSetPoint(FRAME_SwapText[i], FRAMEPOINT_LEFT, FRAME_Swap[i], FRAMEPOINT_TOPLEFT, -0.005, -0.0525 )
        call BlzFrameSetEnable(FRAME_Swap[i], false)
        call BlzFrameSetVisible(FRAME_Swap[i], false)
        set i = i + 1
    endloop
    set y = 0.05
    set x = 0.03
    set i = 0
    loop
        exitwhen i == 7
        // Р В РЎв„ўР В Р’В»Р В РЎвЂР В РЎвЂќР В Р’В°Р В Р’В±Р В Р’ВµР В Р’В»Р РЋР Р‰Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р РЋРІР‚С›Р РЋР вЂљР В Р’ВµР В РІвЂћвЂ“Р В РЎВ (Р В РЎвЂќР В Р вЂ¦Р В РЎвЂўР В РЎвЂ”Р В РЎвЂќР В Р’В°)
        set FRAME_ICON5[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_MAIN3, "ScoreScreenTabButtonTemplate", 0)
        set FRAME_ICON6[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ICON5[i], "", 0)
        call BlzFrameSetTexture(FRAME_ICON5[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
        call BlzFrameSetAllPoints(FRAME_ICON6[i], FRAME_ICON5[i])
        call BlzFrameSetLevel(FRAME_ICON5[i], 5)
        call BlzFrameSetPoint(FRAME_ICON5[i], FRAMEPOINT_LEFT, FRAME_MAIN3, FRAMEPOINT_BOTTOMLEFT, x, y )// - 0.03 * i)
    //call BlzFrameSetAbsPoint(FRAME_ICON[i], FRAMEPOINT_CENTER, -0.11, 0.21)
        call BlzFrameSetSize(FRAME_ICON5[i], 0.035, 0.035)
        call BlzFrameSetTexture(FRAME_ICON6[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
        call GuideCreateAbilityTooltip(i)
        set FRAME_AbiText[i] = BlzCreateFrameByType("TEXT", "MyIconTextAbi", FRAME_ICON5[i], "", 0)
        if i < 5 then
            call BlzFrameSetPoint(FRAME_AbiText[i], FRAMEPOINT_BOTTOM, FRAME_ICON5[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( 0.059 + 0.05 * I2R(i) ), (y - 0.055) - 0.0065 )// - 0.03 * i)
        else
            call BlzFrameSetPoint(FRAME_AbiText[i], FRAMEPOINT_BOTTOM, FRAME_ICON5[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( -0.04 + 0.05 * I2R(i) ), (y - 0.055) - 0.0575 )// - 0.03 * i)
        endif
        call BlzFrameSetTextAlignment(FRAME_AbiText[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetSize(FRAME_AbiText[i], 0.01, 0.01)
        if i == 0 then
            call BlzFrameSetText(FRAME_AbiText[i], "Q")
        elseif i == 1 then
            call BlzFrameSetText(FRAME_AbiText[i], "W")
        elseif i == 2 then
            call BlzFrameSetText(FRAME_AbiText[i], "E")
        elseif i == 3 then
            call BlzFrameSetText(FRAME_AbiText[i], "R")
        elseif i == 4 then
            call BlzFrameSetText(FRAME_AbiText[i], "T")
        elseif i == 5 then
            call BlzFrameSetText(FRAME_AbiText[i], "F")
        elseif i == 6 then
            call BlzFrameSetText(FRAME_AbiText[i], "G")
        endif
        // Q/W/E/R/T/F/G используются только для нативного hover-tooltip.
        // CONTROL_CLICK намеренно не регистрируется: нажатие не вызывает OnClick.
        set i = i + 1
        if i == 5 then
            set y = 0.1
            set x = 0.13
        endif
        set x = x + 0.05
    endloop
    set y = 0.06
    set x = 0.04
    set i = 0
    loop
        exitwhen i == 10
        // Р В РЎв„ўР В Р’В»Р В РЎвЂР В РЎвЂќР В Р’В°Р В Р’В±Р В Р’ВµР В Р’В»Р РЋР Р‰Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р РЋРІР‚С›Р РЋР вЂљР В Р’ВµР В РІвЂћвЂ“Р В РЎВ (Р В РЎвЂќР В Р вЂ¦Р В РЎвЂўР В РЎвЂ”Р В РЎвЂќР В Р’В°)        
        set FRAME_PlayerPick[i] = BlzCreateFrameByType("BUTTON", "MyPickTeamButton", FRAME_MAIN, "", 0)
        call BlzFrameSetSize(FRAME_PlayerPick[i], 0.035, 0.035)
        call BlzFrameSetTexture(FRAME_PlayerPick[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
        set FRAME_PlayerPickBack[i] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", FRAME_PlayerPick[i], "", 0)
        call BlzFrameSetSize(FRAME_PlayerPickBack[i], 0.035, 0.035)
        call BlzFrameSetAllPoints(FRAME_PlayerPickBack[i], FRAME_PlayerPick[i])
        call BlzFrameSetLevel(FRAME_PlayerPick[i], 3)
        call BlzFrameSetLevel(FRAME_PlayerPickBack[i], 1)
        if i >= 5 then
            call BlzFrameSetPoint(FRAME_PlayerPick[i], FRAMEPOINT_LEFT, FRAME_MAIN, FRAMEPOINT_BOTTOMLEFT, x + 0.275, y )// - 0.03 * i)
        else
            call BlzFrameSetPoint(FRAME_PlayerPick[i], FRAMEPOINT_LEFT, FRAME_MAIN, FRAMEPOINT_BOTTOMLEFT, x, y )// - 0.03 * i)
        endif
        call BlzFrameSetTexture(FRAME_PlayerPickBack[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        set FRAME_PlayerPickText[i] = BlzCreateFrameByType("TEXT", "MyIconTextAbi", FRAME_PlayerPick[i], "", 0)
        if SplitNameCheck(GetPlayerName(Player(i))) then
            call BlzFrameSetPoint(FRAME_PlayerPickText[i], FRAMEPOINT_BOTTOM, FRAME_PlayerPick[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( 0.069 + 0.05 * I2R(i) ), (y - 0.0575) - 0.025 )// - 0.03 * i)
        else
            call BlzFrameSetPoint(FRAME_PlayerPickText[i], FRAMEPOINT_BOTTOM, FRAME_PlayerPick[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( 0.069 + 0.05 * I2R(i) ), (y - 0.0575) - 0.0165 )// - 0.03 * i)
        endif
        call BlzFrameSetTextAlignment(FRAME_PlayerPickText[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetSize(FRAME_PlayerPickText[i], 0.0, 0.0)
        call BlzFrameSetText(FRAME_PlayerPickText[i], SplitName(GetPlayerName(Player(i))))
        set i = i + 1
        set x = x + 0.05
    endloop
    
    set FRAME_BanSpinSprite = BlzCreateFrameByType("SPRITE", "justAName", FRAME_MAIN, "WarCraftIIILogo", 0)
    call BlzFrameSetSize(FRAME_BanSpinSprite, 1., 1.)
    call BlzFrameSetScale(FRAME_BanSpinSprite, 1)
    call BlzFrameSetModel(FRAME_BanSpinSprite, "Pick\\wos_IconShine2.mdx", 0)
    call BlzFrameSetVisible(FRAME_BanSpinSprite, false)

    set i = 0
    loop
        exitwhen i == 10
        set FRAME_BanHighlight[i] = BlzCreateFrameByType("SPRITE", "justAName", FRAME_MAIN, "WarCraftIIILogo", 0)
        call BlzFrameSetPoint(FRAME_BanHighlight[i], FRAMEPOINT_CENTER, FRAME_PlayerPick[i], FRAMEPOINT_CENTER, 0, 0)
        call BlzFrameSetSize(FRAME_BanHighlight[i], 0.01, 0.01)
        call BlzFrameSetLevel(FRAME_BanHighlight[i],10)
        call BlzFrameSetScale(FRAME_BanHighlight[i], 0.001)
        call BlzFrameSetModel(FRAME_BanHighlight[i], "war3mapImported\\wos_az_ui_baoji.mdl", 0)
        call BlzFrameSetVisible(FRAME_BanHighlight[i], true)
        set i = i + 1
    endloop
    set FRAME_TimerToStart = BlzCreateFrameByType("TEXT", "TextT", FRAME_MAIN2, "", 0)
    call BlzFrameSetPoint(FRAME_TimerToStart, FRAMEPOINT_BOTTOM, FRAME_MAIN2, FRAMEPOINT_BOTTOMLEFT, -0.055, 0.26 )// - 0.03 * i)
    if TestMode == true then
        call BlzFrameSetText(FRAME_TimerToStart, "|c00FFFF00Choose a hero|r")
    else
        call BlzFrameSetText(FRAME_TimerToStart, "|c00FF0303Time to ban: "+I2S(PrePickTime)+"|r")
    endif
    call BlzFrameSetSize(FRAME_TimerToStart, 0.1, 0.005)
    call BlzFrameSetScale(FRAME_TimerToStart, 1.5)
    call BlzFrameSetEnable(FRAME_TimerToStart,false)
    call TriggerAddAction(FrameClick, function OnClick)
    call TriggerAddAction(FrameGuideRefresh, function GuideRefreshAbilityTooltip)
endfunction
// Captain Mode: функция SetVoteStackTexture перенесена в CaptainMode_Module.j
// Captain Mode: функция ResetCapVotes перенесена в CaptainMode_Module.j
// Captain Mode: функция PrepareNormalPick перенесена в CaptainMode_Module.j
// Captain Mode: функция DetermineCaptain2 перенесена в CaptainMode_Module.j
// Captain Mode: функция CapPickTime2 перенесена в CaptainMode_Module.j
// Captain Mode: функция DetermineCaptain перенесена в CaptainMode_Module.j
// Captain Mode: функция CapPickTime перенесена в CaptainMode_Module.j
// Captain Mode: функция CapOnClick перенесена в CaptainMode_Module.j
// Captain Mode: функция CreateCaptainUI перенесена в CaptainMode_Module.j
function InitTrig_UI takes nothing returns nothing
    if CaptainMode == true then
        call CreateCaptainUI()
    else
        call CreateUI()
    endif
endfunction
// Captain Mode: функция IsInTeam1 перенесена в CaptainMode_Module.j

// Считает игроков по тем же командам и состояниям, которые использует сама
// карта. Это не зависит от того, успел ли внутренний реестр сейва обновиться.
function CountBotMatchTeamPlayers takes integer whichTeam returns integer
    local integer pid = 0
    local integer result = 0

    loop
        exitwhen pid >= 10
        if GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(pid)) == MAP_CONTROL_USER then
            if Hero[pid] != null and Leave[pid] == 0 then
                if whichTeam == 1 and IsInTeam1(pid) then
                    set result = result + 1
                elseif whichTeam == 2 and not IsInTeam1(pid) then
                    set result = result + 1
                endif
            endif
        endif
        set pid = pid + 1
    endloop

    return result
endfunction

// После контрольной отметки результат больше не зависит от выходов игроков
// во время последнего раунда.
function CanSaveBotMatchStats takes nothing returns boolean
    return BotStatsNineWinCheckDone and BotStatsNineWinEligible
endfunction

// Как только любая команда набрала девять побед по раундам, запоминает число
// оставшихся игроков. В нормальном матче это начало потенциально последнего
// раунда. Повторно значение не пересчитывается.
function CheckBotStatsEligibilityAtNineWins takes nothing returns nothing
    if BotStatsNineWinCheckDone then
        return
    endif
    if Team1Round >= 9 or Team2Round >= 9 then
        set BotStatsNineWinCheckDone = true
        set BotStatsPlayersAtNineWins = CountBotMatchTeamPlayers(1) + CountBotMatchTeamPlayers(2)
        set BotStatsNineWinEligible = BotStatsPlayersAtNineWins >= 8
    endif
endfunction

// Повторно передаёт актуальных героев системе сохранений перед финальным
// снимком. Вызов идемпотентный и не добавляет матч или победу сам по себе.
function RefreshBotMatchParticipants takes nothing returns nothing
    local integer pid = 0

    call SaveSystem_RegisterLobbyParticipants()
    loop
        exitwhen pid >= 10
        if Hero[pid] != null then
            call SaveSystem_SetCurrentHero(Player(pid), Hero[pid])
        endif
        set pid = pid + 1
    endloop
endfunction

// Фиксирует результат и всех доигравших героев лобби для личных matchup/team
// строк. Вызывается синхронно; локальный файл внутри AAINIT пишет только владелец.
function SaveCareerMatchResult takes integer pid, boolean isWin returns nothing
    local integer otherPid = 0
    local integer team = 0
    local boolean isTeammate
    local unit savedHero
    local unit otherHero

    if pid < 0 or pid >= 10 or not SaveSystem_IsMatchParticipant(pid) then
        return
    endif

    set team = SaveSystem_GetMatchTeam(pid)
    set savedHero = SaveSystem_GetMatchHero(pid)
    loop
        exitwhen otherPid >= 10
        if otherPid != pid and SaveSystem_IsMatchParticipant(otherPid) then
            set otherHero = SaveSystem_GetMatchHero(otherPid)
            if savedHero != null and otherHero != null then
                set isTeammate = team > 0 and team == SaveSystem_GetMatchTeam(otherPid)
                call SaveSystem_RecordHeroRelation(Player(pid), savedHero, otherHero, isTeammate, isWin)
            endif
        endif
        set otherHero = null
        set otherPid = otherPid + 1
    endloop

    call SaveSystem_OnGameEndDetailed(Player(pid), savedHero, isWin, PlayerKill[pid], PlayerDeath[pid])
    call SaveSystem_BotExportAddPlayer(Player(pid), SaveSystem_GetMatchStableName(pid), savedHero, team, isWin, PlayerKill[pid], PlayerDeath[pid], PlayerDamagePhysAll[pid], PlayerDamageMagAll[pid], PlayerHealAll[pid], R2I(PlayerDamageTakenPhysAll[pid]), R2I(PlayerDamageTakenMagAll[pid]))

    set savedHero = null
    set otherHero = null
endfunction

function LockBannedHero takes integer heroId returns nothing
    local integer page = 1
    local integer slot
    local boolean found = false
    if heroId == 0 or heroId == 12 or IsHeroTypeBanned(heroId) then
        return
    endif
    loop
        exitwhen page > 6
        set slot = 0
        loop
            exitwhen slot == 30
            if GetHeroId(page, slot) == heroId then
                set BanLockedHeroTypeBySlot[(page - 1) * 30 + slot] = heroId
                call SetHeroId(page, slot, 12)
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

function LockCaptainBanProposal takes integer pid returns nothing
    local integer heroId = 0
    if pid < 0 or pid >= 10 then
        return
    endif
    if not IsCaptainPlayer(pid) or BannedHeroCount >= MaxHeroBans then
        return
    endif
    set heroId = BanProposalHero[pid]
    if heroId != 0 and not IsHeroBanImmune(heroId) and IsHeroAvailableForPick(heroId) then
        call LockBannedHero(heroId)
        call UpdateBanProposalSlot(pid)
        call PlayersMsg("|c00FF0303Captain guaranteed ban:|r " + GetObjectName(heroId), 1)
    endif
endfunction

function LockCaptainBanProposals takes nothing returns nothing
    if not CaptainMode then
        return
    endif
    call LockCaptainBanProposal(CaptainPid1)
    if CaptainPid2 != CaptainPid1 then
        call LockCaptainBanProposal(CaptainPid2)
    endif
endfunction

function BuildBanCandidateList takes nothing returns nothing
local integer pid = 0
set BanCandidateCount = 0
loop
exitwhen pid >= 10
// В Captain Mode капитаны уже получили гарантированные баны и в рулетку не входят.
if not IsCaptainPlayer(pid) and GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(pid)) == MAP_CONTROL_USER and BanProposalHero[pid] != 0 and not IsHeroBanImmune(BanProposalHero[pid]) and IsHeroAvailableForPick(BanProposalHero[pid]) then
set BanCandidatePid[BanCandidateCount] = pid
set BanCandidateHero[BanCandidateCount] = BanProposalHero[pid]
set BanCandidateCount = BanCandidateCount + 1
endif
set pid = pid + 1
endloop
endfunction


function ShowBanSpriteOnSlot takes integer pid returns nothing
    call BlzFrameClearAllPoints(FRAME_BanSpinSprite)
    
    call BlzFrameSetPoint(FRAME_BanSpinSprite, FRAMEPOINT_LEFT, FRAME_PlayerPick[pid], FRAMEPOINT_LEFT, -0.0012, 0.48 )
    call BlzFrameSetLevel(FRAME_BanSpinSprite, 10)
    call BlzFrameSetVisible(FRAME_BanSpinSprite, true)
    call BlzFrameSetText(FRAME_TimerToStart, "|c00FF0303Banning heroes...|r")
endfunction
function EndBanPhase takes nothing returns nothing
    local integer i = 0
    local integer time = 0
    set BanPhaseActive = false
    set TimeMove = PrePickTime - 5
    set time = PrePickTime -TimeMove
    call StartSound(gg_snd_BattleNetTick)
    call BlzFrameSetText(FRAME_TimerToStart, "|c00FFFF00Time to pick: " + I2S(time) + "|r")
    set CanPickRandom = 1
    call BlzFrameSetVisible(FRAME_BanSpinSprite, false)

    // First clear every proposal. ReloadHeroPage checks the complete
    // BanProposalHero array, so refreshing inside this loop would leave
    // proposals from players with greater indices temporarily locked.
    loop
        exitwhen i == 10
        set BanProposalHero[i] = 0
        set i = i + 1
    endloop

    // Now no rejected proposal can disable an icon. Heroes selected by the
    // random ban remain locked because LockBannedHero replaced their IDs with 12.
    set i = 0
    loop
        exitwhen i == 10
        call BlzFrameSetTexture(FRAME_PlayerPickBack[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        call ReloadHeroPage(PlayerFrameCurrentPage_ID[i], Player(i))
        set i = i + 1
    endloop
    call BlzFrameSetTexture(FRAME_ICON_Pick[4], "Pick\\PickButton_Pick_Ban2", 0, true)
    call BlzFrameSetEnable(FRAME_Pick[4], false)
    call BlzFrameSetEnable(FRAME_ICON_Pick[4], false)
endfunction
function MusicBan takes nothing returns nothing
local integer i  = GetRandomInt(1,7)
if i == 1 then 
call MakeSound("war3mapimported\\Ban_1")
elseif i == 2 then 
call MakeSound("war3mapimported\\Ban_2")
elseif i == 3 then 
call MakeSound("war3mapimported\\Ban_3")
elseif i == 4 then 
call MakeSound("war3mapimported\\Ban_4")
elseif i == 5 then 
call MakeSound("war3mapimported\\Ban_5")
elseif i == 6 then 
call MakeSound("war3mapimported\\Ban_6")
elseif i == 7 then 
call MakeSound("war3mapimported\\Ban_7")
endif
endfunction 
// Р В РІР‚СћР В РўвЂР В РЎвЂР В Р вЂ¦Р В Р’В°Р РЋР РЏ Р РЋР С“Р В Р’В°Р В РЎВР В РЎвЂўР В РЎвЂ”Р В Р’В»Р В Р’В°Р В Р вЂ¦Р В РЎвЂР РЋР вЂљР РЋРЎвЂњР РЋР вЂ№Р РЋРІР‚В°Р В Р’В°Р РЋР РЏ Р РЋРІР‚С›Р РЋРЎвЂњР В Р вЂ¦Р В РЎвЂќР РЋРІР‚В Р В РЎвЂР РЋР РЏ Р Р†Р вЂљРІР‚Сњ Р В РЎвЂќР РЋР вЂљР РЋРЎвЂњР РЋРІР‚С™Р В РЎвЂР РЋРІР‚С™ Р РЋР С“Р В РЎвЂ”Р РЋР вЂљР В Р’В°Р В РІвЂћвЂ“Р РЋРІР‚С™, Р В РЎвЂ”Р В РЎвЂўР РЋРІР‚С™Р В РЎвЂўР В РЎВ "Р В РЎвЂ”Р РЋР вЂљР В РЎвЂР В Р’В·Р В Р’ВµР В РЎВР В Р’В»Р РЋР РЏР В Р’ВµР РЋРІР‚С™",
// Р В РўвЂР В Р’ВµР РЋР вЂљР В Р’В¶Р В РЎвЂР РЋРІР‚С™ Р В РЎвЂ”Р В Р’В°Р РЋРЎвЂњР В Р’В·Р РЋРЎвЂњ 3 Р РЋР С“Р В Р’ВµР В РЎвЂќ, Р В РЎвЂ”Р В РЎвЂўР РЋРІР‚С™Р В РЎвЂўР В РЎВ Р В Р’В»Р В РЎвЂР В Р’В±Р В РЎвЂў Р В Р’В·Р В Р’В°Р В РЎвЂ”Р РЋРЎвЂњР РЋР С“Р В РЎвЂќР В Р’В°Р В Р’ВµР РЋРІР‚С™ Р РЋР С“Р В Р’В»Р В Р’ВµР В РўвЂР РЋРЎвЂњР РЋР вЂ№Р РЋРІР‚В°Р В РЎвЂР В РІвЂћвЂ“ Р В Р’В±Р В Р’В°Р В Р вЂ¦, Р В Р’В»Р В РЎвЂР В Р’В±Р В РЎвЂў Р В Р’В·Р В Р’В°Р В Р вЂ Р В Р’ВµР РЋР вЂљР РЋРІвЂљВ¬Р В Р’В°Р В Р’ВµР РЋРІР‚С™ Р РЋРІР‚С›Р В Р’В°Р В Р’В·Р РЋРЎвЂњ.
function BanPhaseTick takes nothing returns nothing
local timer t = GetExpiredTimer()
local integer pid = 0
local integer heroId = 0
local integer i = 0
local real delay = 0.0
call PauseTimer(t)
call DestroyTimer(t)
if BanPhaseStage == 0 then
set BanRevealIndex = BanRevealIndex + 1
if BanRevealIndex >= BanCandidateCount then
set BanRevealIndex = 0
endif
call ShowBanSpriteOnSlot(BanCandidatePid[BanRevealIndex])
set BanRevealStep = BanRevealStep + 1
call MakeSound("Pick\\PickCount2")
if BanRevealStep >= BanRevealTotalSteps then
set pid = BanCandidatePid[BanRevealIndex]
set heroId = BanCandidateHero[BanRevealIndex]
set BanLastBannedPid = pid
call BlzFrameSetVisible(FRAME_BanSpinSprite,false)
call BlzFrameSetVisible(FRAME_BanHighlight[pid],true)
call BlzFrameSetSpriteAnimate(FRAME_BanHighlight[pid],0,0)
call LockBannedHero(heroId)
call UpdateBanProposalSlot(pid)
call RefreshAllPlayersHeroPage()
call MusicBan()
call PlayersMsg("|c00FF0303Banned hero:|r "+GetObjectName(heroId),1)
set BanPhaseStage = 1
call BlzFrameSetText(FRAME_TimerToStart,"|c00FF0303Banned: "+GetObjectName(heroId)+"|r")
call TimerStart(CreateTimer(),2.0,false,function BanPhaseTick)
else
set delay = 0.10+(I2R(BanRevealStep)/I2R(BanRevealTotalSteps))*0.30
call TimerStart(CreateTimer(),delay,false,function BanPhaseTick)
endif
else
if BanLastBannedPid >= 0 then
call BlzFrameSetVisible(FRAME_BanHighlight[BanLastBannedPid],false)
endif
loop
exitwhen i >= 10
if BanProposalHero[i] == BannedHeroType[BannedHeroCount-1] then
set BanProposalHero[i] = 0
endif
set i = i + 1
endloop
call BuildBanCandidateList()
if BannedHeroCount >= MaxHeroBans or BanCandidateCount == 0 then
call EndBanPhase()
else
set BanRevealIndex = GetRandomInt(0,BanCandidateCount-1)
set BanRevealStep = 0
set BanRevealTotalSteps = 14+GetRandomInt(0,6)
set BanPhaseStage = 0
call ShowBanSpriteOnSlot(BanCandidatePid[BanRevealIndex])
call TimerStart(CreateTimer(),0.12,false,function BanPhaseTick)
endif
endif
set t = null
endfunction


function StartBanPhase takes nothing returns nothing
    // Сначала фиксируются капитанские предложения. Рулетка разыгрывает только
    // оставшиеся места до общего лимита MaxHeroBans.
    set BannedHeroCount = 0
    call LockCaptainBanProposals()
    call BuildBanCandidateList()
    call RefreshAllPlayersHeroPage()
    if BannedHeroCount >= MaxHeroBans or BanCandidateCount == 0 or MaxHeroBans <= 0 then
        call EndBanPhase()
        return
    endif
    set BanPhaseActive = true
    set BanRevealIndex = GetRandomInt(0, BanCandidateCount - 1)
    set BanRevealStep = 0
    set BanRevealTotalSteps = 14 + GetRandomInt(0, 6)
    set BanPhaseStage = 0
    call PlayerMsg("|c00FFFF00Hero ban phase starting!|r", 2)
    call ShowBanSpriteOnSlot(BanCandidatePid[BanRevealIndex])
    call TimerStart(CreateTimer(), 0.12, false, function BanPhaseTick)
endfunction
function PrepareStart takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer i = 0
    local integer i2 = 0
    local integer i3 = 0
    local integer i4 = 0
    local integer k1 = 0
    local integer k2 = 0
    local integer k3 = 0
    local integer k = 0
    local real x1
    local integer check2 = 0
    local real y1
    local real x2
    local real y2
    local integer lender = 0
    local integer borrower
    local integer timeLeft
    local integer reward = 0
    if ((CapPickPhase == 2 or CapPickPhase == 4) and CaptainMode == true) or CaptainMode == false then
        if BanPhaseActive == false then
            set TimeMove = TimeMove + 1
        endif
    endif
    if END1 == 0 then
        if CondArena == 0 then
            if TestMode == true and PickPhaseActive == false then
                set TimeMove = PrePickTime
            endif
// Pre-pick phase: first 10 seconds
if PickPhaseActive == false then
    if BanPhaseActive then
        return   // Р В Р вЂ Р РЋР С“Р РЋРІР‚В Р В Р’В·Р В Р’В°Р В РЎВР В РЎвЂўР РЋР вЂљР В РЎвЂўР В Р’В¶Р В Р’ВµР В Р вЂ¦Р В РЎвЂў, Р В РЎвЂ”Р В РЎвЂўР В РЎвЂќР В Р’В° Р В РЎвЂќР РЋР вЂљР РЋРЎвЂњР РЋРІР‚С™Р В РЎвЂР РЋРІР‚С™Р РЋР С“Р РЋР РЏ/Р В РЎвЂ”Р В РЎвЂўР В РЎвЂќР В Р’В°Р В Р’В·Р РЋРІР‚в„–Р В Р вЂ Р В Р’В°Р В Р’ВµР РЋРІР‚С™Р РЋР С“Р РЋР РЏ Р В Р’В±Р В Р’В°Р В Р вЂ¦
    endif
    set timeLeft = PrePickTime - TimeMove
    if timeLeft > 0 then
    if CanPickRandom == 0 then 
        call BlzFrameSetText(FRAME_TimerToStart, "|c00FF0303Time to ban: " + I2S(timeLeft) + "|r")
        else
    call StartSound(gg_snd_BattleNetTick)
        call BlzFrameSetText(FRAME_TimerToStart, "|c00FFFF00Time to pick: " + I2S(timeLeft) + "|r")
        endif
        if CanPickRandom == 0 and timeLeft <= BanLockTime and not BanSelectionLocked then
    set BanSelectionLocked = true
    set i = 0

    loop
        exitwhen i == 10
        if BanProposalHero[i] != 0 then 
        // Кнопка блокируется для всех, даже если игрок не успел предложить героя.
        if GetLocalPlayer() == Player(i) then
            call BlzFrameSetEnable(FRAME_Pick[4], false)
            call BlzFrameSetEnable(FRAME_ICON_Pick[4], false)
            call BlzFrameSetTexture(FRAME_ICON_Pick[4], "Pick\\PickButton_Pick_Ban2", 0, true)
        endif
        endif
        set i = i + 1
    endloop
endif
        if timeLeft == 1 and CanPickRandom == 1 then
            set i = 0
            loop
                exitwhen i == 10
                if GetLocalPlayer() == Player(i) then
                    call BlzFrameSetTexture(FRAME_ICON_Pick[3], "Pick\\PickButton_Pick_Random", 0, true)
                    call BlzFrameSetEnable(FRAME_Pick[3], true)
                  
                    if (FramePlayerFirstName[i] == "C130" or FramePlayerFirstName[i] == "ThunderGear") and (PlayerFrameCurrent_ID[i] == Hero_ID5[13]) then
                        call BlzFrameSetTexture(FRAME_ICON_Pick[2], "Pick\\PickButton_Pick_Manual", 0, true)
                        call BlzFrameSetEnable(FRAME_Pick[2], true)
                    endif
                endif
                set i = i + 1
            endloop
        endif
    endif
    if TimeMove >= PrePickTime then
        if BanPhaseTriggered == false and TestMode == false then
            set BanPhaseTriggered = true
            set i = 0
            loop
                exitwhen i == 10
                if GetLocalPlayer() == Player(i) then
                    call BlzFrameSetEnable(FRAME_Pick[4], false)
                    call BlzFrameSetEnable(FRAME_ICON_Pick[4], false)                    
                call BlzFrameSetTexture(FRAME_ICON_Pick[4], "Pick\\PickButton_Pick_Ban2", 0, true)
                endif
                set i = i + 1
            endloop
            call StartBanPhase()
            return
        endif
        set PickPhaseActive = true
        call BlzFrameSetText(FRAME_TimerToStart, "|c00FFFF00Time Left: " + I2S(R2I(FRAME_RoundCountSecBasePrepare) - R2I(TimeMove) + PrePickTime) + "|r")
        set i = 0
        loop
            exitwhen i == 10
            if GetLocalPlayer() == Player(i) then
                call BlzFrameSetEnable(FRAME_Pick[2], true)
                call BlzFrameSetTexture(FRAME_ICON_Pick[2], "Pick\\PickButton_Pick_Manual", 0, true)
                call BlzFrameSetTexture(FRAME_ICON_Pick[3], "Pick\\PickButton_Pick_Random", 0, true)
                call BlzFrameSetTexture(FRAME_ICON_Pick[4], "Pick\\PickButton_Pick_Ban2", 0, true)
                call BlzFrameSetEnable(FRAME_Pick[3], true)
            endif
            if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(i)) == MAP_CONTROL_USER then
                call ReloadHeroPage(PlayerFrameCurrentPage_ID[i], Player(i))
            endif
            set i = i + 1
        endloop
    endif
    return
endif
           
// Normal pick phase timer update
            if TestMode == true then
                call BlzFrameSetText(FRAME_TimerToStart, "|c00FFFF00Choose a hero|r")
            else
                call BlzFrameSetText(FRAME_TimerToStart, "|c00FFFF00Time Left: " + I2S(R2I(FRAME_RoundCountSecBasePrepare) - R2I(TimeMove) + PrePickTime) + "|r")
            endif
            if CaptainMode == true and TimeMove <= FRAME_RoundCountSecBasePrepare + PrePickTime and RandomAllPlayers == 0 then
                set i = 0
                set i2 = 0
                set i3 = 0
                loop
                    exitwhen i == 10
                    if GetPlayerSlotState( Player( i ) ) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController( Player( i ) ) == MAP_CONTROL_USER then
                        set i3 = i3 + 1
                        if Hero[i] != null then
                            set i2 = i2 + 1
                        endif
                    endif
                    set i = i + 1
                endloop
                set i = 0
                if i2 == i3 then
                    call CreatePlayerPickUI()
                    set check2 = 1
                    set TimeMove = FRAME_RoundCountSecBasePrepare + PrePickTime
                endif
            endif
            if TimeMove == FRAME_RoundCountSecBasePrepare + PrePickTime and RandomAllPlayers == 0 then
                set RandomAllPlayers = 1
                set i = 0
                loop
                    exitwhen i == 10
                    call RandomPick(Player(i))
                    set i = i + 1
                endloop
                set i = 10
                loop
                    exitwhen i == bj_MAX_PLAYERS
                    if GetLocalPlayer() == Player(i) then
            call BlzFrameSetVisible(FRAME_MAIN, false)
            call BlzFrameSetVisible(FRAME_StatusHeroMain, true)
            call BlzFrameSetVisible(FRAME_StatusHeroMain2, true)
            call BlzFrameSetVisible(FRAME_StatusHeroMain3, true)
            call BlzFrameSetVisible(FRAME_StatusHeroMain4, true)
            call BlzFrameSetVisible(FRAME_LINK2, true)
        endif
                    call HideBottomUI(Player(i), false)
                    call SetCameraFieldForPlayer(Player(i), CAMERA_FIELD_TARGET_DISTANCE, 3500, 0.25)
                    set i = i + 1
                endloop
                
                if CaptainMode == true and check2 == 0 then
                    call CreatePlayerPickUI()
                    set check2 = 1
                endif
            endif
            set i = 0
            loop
                exitwhen i == 10
                if Hero[i] != null and Leave[i] == 0 then
                    if GetUnitAbilityLevel(Hero[i], 'Avul') == 0 then
                        call UnitAddAbility(Hero[i], 'Avul')
                    endif
                    call SetFly(Hero[i], 0)
                    if IsUnitType(Hero[i], UNIT_TYPE_DEAD) then
                        call ReviveHero(Hero[i], GetUnitX(Hero[i]), GetUnitY(Hero[i]), true)
                        call SetScale(Hero[i],1)
                    endif
                    if CheckCoordsInRect(gg_rct_Base, GetUnitX(Hero[i]), GetUnitY(Hero[i])) == false then
                        call SetUnitPosition(Hero[i], GetRectCenterX(gg_rct_Pick), GetRectCenterY(gg_rct_Pick))
                    endif
                endif
                set i = i + 1
            endloop
            if TimeMove == TimeRound then
                set RoundJustStarted = 1
                set CondArena = 1
                set inststart = 0
                set firstroundinit = firstroundinit + 1
                if firstroundinit == 1 then
                    set Round1Started = 1
call ShopForceFirstRoundAutoBuy()
                    call PauseTimer(FrameCapTimer2)
                endif
                if (Time_RoundEnd - (Time_RoundEnd/60)*60) < 10 then
    call BlzFrameSetText(FRAME_RoundTimer, "Round Ends: |c00FFFF00" + I2S(Time_RoundEnd/60) + ":0" + I2S(Time_RoundEnd - (Time_RoundEnd/60)*60))
else
    call BlzFrameSetText(FRAME_RoundTimer, "Round Ends: |c00FFFF00" + I2S(Time_RoundEnd/60) + ":" + I2S(Time_RoundEnd - (Time_RoundEnd/60)*60))
endif
                set k1 = GetRandomInt(1, 4)
                if k1 == 1 then
                    set x1 = GetRectCenterX(gg_rct_Spawn1)
                    set y1 = GetRectCenterY(gg_rct_Spawn1)
                elseif k1 == 2 then
                    set x1 = GetRectCenterX(gg_rct_Spawn2)
                    set y1 = GetRectCenterY(gg_rct_Spawn2)
                elseif k1 == 3 then
                    set x1 = GetRectCenterX(gg_rct_Spawn3)
                    set y1 = GetRectCenterY(gg_rct_Spawn3)
                elseif k1 == 4 then
                    set x1 = GetRectCenterX(gg_rct_Spawn4)
                    set y1 = GetRectCenterY(gg_rct_Spawn4)
                endif
                loop
                    set k1 = GetRandomInt(1, 4)
                    if k1 == 1 then
                        set x2 = GetRectCenterX(gg_rct_Spawn1)
                        set y2 = GetRectCenterY(gg_rct_Spawn1)
                    elseif k1 == 2 then
                        set x2 = GetRectCenterX(gg_rct_Spawn2)
                        set y2 = GetRectCenterY(gg_rct_Spawn2)
                    elseif k1 == 3 then
                        set x2 = GetRectCenterX(gg_rct_Spawn3)
                        set y2 = GetRectCenterY(gg_rct_Spawn3)
                    elseif k1 == 4 then
                        set x2 = GetRectCenterX(gg_rct_Spawn4)
                        set y2 = GetRectCenterY(gg_rct_Spawn4)
                    endif
                    exitwhen x2 != x1
                endloop
                set FRAME_RoundCountSecBasePrepare = 60
                    set TimeRound = FRAME_RoundCountSecBasePrepare

                set FirstTime = 1
                set FRAME_RoundCountSec = 0
                set FRAME_RoundCountMin = 0
    call BlzFrameSetText(FRAME_RoundTimer, "|c00FFFF00Round Starts now!")
                set TimeMove = 1
                if TestMode == false then
                    call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[6], false)
                    call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[7], false)
                    call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], false)
                    call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], false)
                endif
                call DecorRestore()
                set i = 0
                loop
                    exitwhen i == 10
                    if firstroundinit == 1 then
                        if GetUnitTypeId(Hero[i]) == Kenjaku_ID then
                            call KenjakuF2_Start(Hero[i])
                        endif
                        call BlzFrameSetEnable(FRAME_Repick[i], false)
                        call BlzFrameSetVisible(FRAME_Repick[i], false)
                        call BlzFrameSetVisible(FRAME_SwapSprite[i], false)
                        call BlzFrameSetVisible(FRAME_SwapSprite2[i], false)
                        if TestMode == false then
                            call BlzFrameSetEnable(FRAME_Swap[i], false)
                            call BlzFrameSetVisible(FRAME_Swap[i], false)
                        endif
                    endif
                    if Hero[i] != null and Leave[i] == 0 then
                        if TestMode == false then 
                        if IsInTeam1(i) then
                            call SetUnitPosition(Hero[i], x1, y1)
                        else
                            call SetUnitPosition(Hero[i], x2, y2)
                        endif
                        else
                            call SetUnitPosition(Hero[i], x1, y1)
                        endif
                        if GetUnitTypeId(Hero[i]) == Takeshi_ID then
                            call TakeshiGOff_Start(Hero[i])
                        endif
                        if GetUnitTypeId(Hero[i]) == Milim_ID or GetUnitTypeId(Hero[i]) == Milim2_ID then
                            call MilimGOff_Start(Hero[i])
                        endif
                        call SaveReal(hs, GetHandleId(Hero[i]), StringHash("zero kai dmg"), 0)
                        if GetUnitTypeId(Hero[i]) == Inori_ID then
                            call SaveInteger(hs, GetHandleId(Hero[i]), StringHash("Inori E"), 0)
                            if inori_frame_pas1[i] != null then
                                if GetLocalPlayer() == Player(i) then
                                    call BlzFrameSetVisible(inori_frame_pas1[i], false)
                                endif
                            endif
                        endif
                        call DestroyFogModifier(PlayerVision[i])
                        set PlayerVision[i] = CreateFogModifierRadius(Player(i), FOG_OF_WAR_VISIBLE, GetUnitX(Hero[i]), GetUnitY(Hero[i]), 1800, true, false)
                        call FogModifierStart(PlayerVision[i])
                        call SelectUnitForPlayerSingle(Hero[i], Player(i))
                        call PanCameraToTimedForPlayer(Player(i), GetUnitX(Hero[i]), GetUnitY(Hero[i]), 0.25)
                    endif
                    set i = i + 1
                endloop
            endif
        else
            if TestMode == false and r_ping > 9 then
                set r_ping = 1
                set i = 0
                loop
                    exitwhen i == 10
                    if Hero[i] != null and Leave[i] == 0 and IsUnitType(Hero[i], UNIT_TYPE_DEAD) == false then
                        call PingMinimapEx(GetUnitX(Hero[i]), GetUnitY(Hero[i]), 5, PC_R[i], PC_G[i], PC_B[i], false)
                    endif
                    set i = i + 1
                endloop
            else
                set r_ping = r_ping + 1
            endif
            if TestMode == false and r_train > 29 then
                set r_train = 1
                set i = 0
                call TrainStart()
            else
                set r_train = r_train + 1
            endif
            set i = 0
            set k1 = 0
            set k2 = 0
            loop
                exitwhen i == 10
                if Hero[i] != null and Leave[i] == 0 and (CheckCoordsInRect(gg_rct_Arena, GetUnitX(Hero[i]), GetUnitY(Hero[i])) or CheckCoordsInRect(gg_rct_Cage, GetUnitX(Hero[i]), GetUnitY(Hero[i]))) and IsUnitType(Hero[i], UNIT_TYPE_DEAD) == false then
                    if IsInTeam1(i) then
                        set k1 = k1 + 1
                    else
                        set k2 = k2 + 1
                    endif
                endif
                set i = i + 1
            endloop
            if TestMode == true then
                if k1 == 0 then
                    set k = 1
                endif
            else
                if k2 == 0 and k1 > 0 then
                    set k = 1
                    set Team1Round = Team1Round + 1
                    set k3 = 0
                    loop
                        exitwhen k3 == 10
                        if IsInTeam1(k3) then
                            call SaveSystem_OnRoundEnd(Player(k3), true)
                        else
                            call SaveSystem_OnRoundEnd(Player(k3), false)
                        endif
                        set k3 = k3 + 1
                    endloop
                    call PlayersMsg(GetPlayerColorString(Player(0)) + "Team 1|r win round", 1)
                endif
                if k1 == 0 and k2 > 0 then
                    set k = 1
                    set Team2Round = Team2Round + 1
                    set k3 = 0
                    loop
                        exitwhen k3 == 10
                        if IsInTeam1(k3) then
                            call SaveSystem_OnRoundEnd(Player(k3), false)
                        else
                            call SaveSystem_OnRoundEnd(Player(k3), true)
                        endif
                        set k3 = k3 + 1
                    endloop
                    call PlayersMsg(GetPlayerColorString(Player(1)) + "Team 2|r win round", 1)
                endif
                if k1 == 0 and k2 == 0 then
                    set k = 1
                    call PlayersMsg(GetPlayerColorString(Player(10)) + "Draw", 2)
                    set Team2Round = Team2Round + 1
                    set Team1Round = Team1Round + 1
                    set k3 = 0
                    loop
                        exitwhen k3 == 10
                        call SaveSystem_OnRoundEnd(Player(k3), true)
                        set k3 = k3 + 1
                    endloop
                endif
            endif
            call CheckBotStatsEligibilityAtNineWins()
            if TestMode then
                set TimeMove = TimeMove - 1
            endif
            if TimeMove == Time_Sukuna then
                call SukunaEnd()
            endif
            if TimeMove == Time_RoundEnd or k == 1 then
                set PrepJustStarted = 1
                set CondArena = 0
                set TimeMove = 1
                if Team1Round >= MaxRounds or Team2Round >= MaxRounds then
                    set i = 0
                    set i2 = 0
                    set END1 = 1
                    loop
                        exitwhen i == 10
                        if GetPlayerSlotState( Player( i ) ) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController( Player( i ) ) == MAP_CONTROL_USER then
                            set i2 = i2 + 1
                        endif
                        set i = i + 1
                    endloop
                    set i = 0
                    // Ограничение относится только к файлу статистики бота.
                    // Личная локальная карьера ниже продолжает сохраняться.
                    call RefreshBotMatchParticipants()
                   // if CanSaveBotMatchStats() then
                        call SaveSystem_BotExportBegin(Team1Round, Team2Round)
                        call SaveSystem_BotExportSetTrainKills(TrainKill)
                   // else
                      //  call PlayersMsg("|cffffcc00Bot stats not recorded: fewer than 8 players at the 9-win checkpoint (" + I2S(BotStatsPlayersAtNineWins) + ").|r", 10)
                    //endif
                  set i = 0
loop
    exitwhen i == 10
    set FRAME_StatusHeroStringPlayerShowBoolean[i] = true

    if SaveSystem_IsMatchParticipant(i) then
        if Team1Round >= MaxRounds then
            call SaveCareerMatchResult(i, SaveSystem_GetMatchTeam(i) == 1)
        elseif Team2Round >= MaxRounds then
            call SaveCareerMatchResult(i, SaveSystem_GetMatchTeam(i) == 2)
        endif
    endif

    set i = i + 1
endloop
                  set x1 = (GetRectCenterX(gg_rct_Chest) - 500 * Cos(180 * bj_DEGTORAD) + 1150 * Cos(270 * bj_DEGTORAD))
                    set y1 = (GetRectCenterY(gg_rct_Chest) - 500 * Sin(180 * bj_DEGTORAD) + 1150 * Sin(270 * bj_DEGTORAD))
                    if Team1Round >= MaxRounds then
                        call CreateTT_perm(x1, y1, 1050, 50, "|c00FFFC01First team|r |c00FF0303win |r")
                        call PlayerMsg("|c00FFFF00First team|r " + "|c00FF0303win the game|r", 1)
                    elseif Team2Round >= MaxRounds then
                        call CreateTT_perm(x1, y1, 1050, 50, "|c00FFFC01Second team|r |c00FF0303win |r")
                        call PlayerMsg("|c00FFFF00Second team|r " + "|c00FF0303win the game|r", 1)
                    endif
                    // Финал: скрываем обычный интерфейс и показываем подробное табло.
                    set i = 0
                    loop
                        exitwhen i == 10
                       // call HideBottomUI(Player(i), true)
                        set i = i + 1
                    endloop
                    call BlzFrameSetVisible(main_frame,false)
                    call WOS_STATS_ShowFinal()
                    // Один последовательный таймер: сначала полностью закрывает
                    // личный сейв, на следующем тике отдельно пишет бот-файл.
                    call SaveSystem_ScheduleDeferredWrites()
                endif
                call DecorRestore()
                set CurrentRound = CurrentRound + 1
                set r_ping = 1
                set r_train   = 1
                if CurrentRound == 4 then // 14
                    call PlayerMsg("|c00FFFF00All heroes gain additional|r |c004675FF5%|r |c00FFFF00magic resistance |r ", 2)
                elseif CurrentRound == 7 then // 26
                    call PlayerMsg("|c00FFFF00All heroes gain additional|r |c004675FF5%|r |c00FFFF00magic resistance |r ", 2)
                elseif CurrentRound == 9 then // 35
                    call PlayerMsg("|c00FFFF00All heroes gain additional|r |c004675FF5%|r |c00FFFF00magic resistance |r ", 2)
                endif
                //call BlzFrameSetText(FRAME_Team1Rounds, "|cffff0000" + I2S(Team1Round) + "/" + I2S(MaxRounds) + "|r")
               // call BlzFrameSetText(FRAME_Team2Rounds, "|c002F63FF" + I2S(Team2Round) + "/" + I2S(MaxRounds) + "|r")
                call BlzFrameSetText(FRAME_RoundCount, "Round: |c00FFFF00" + I2S(CurrentRound) + "|r")
                set FRAME_RoundCountSec = 0
                set FRAME_RoundCountMin = 0
                call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[6], true)
                call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[7], true)
                call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], true)
                call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], true)
                set i = 0
                set k2 = 2500
                //set reward = 2500
                set reward = 2000 + CurrentRound * 250
                set GoldReceiveHardCap = GoldReceiveHardCap + GoldReceiveHardCapIncrease
                set LoanSendLimit = LoanSendLimit + LoanSendLimitIncrease
                if reward > 5000 then
                    set reward = 5000
                endif
                set k2 = reward+250
               //set reward = 2500
                //set k2 = 750 + (CurrentRound + 1) * 300
                if k2 > 5000 then
                    set k2 = 5000
                endif
                 /* 
                if (Team2Round - Team1Round) > 4 then
                    set k3 = (Team2Round - Team1Round)
                    if k3 > 8 then
                        set k3 = 9
                    endif
                    set k3 = (k3 - 4) * 10
                    call PlayerMsg(GetPlayerColorString(Player(0)) + "Team 1|r loose too much and gain some help +|c00FFFC01" + I2S(k3) + "|r all stats|r", 10)
                elseif (Team1Round - Team2Round) > 4 then
                    set k3 = (Team1Round - Team2Round)
                    set k3 = (k3 - 4) * 10
                    call PlayerMsg(GetPlayerColorString(Player(1)) + "Team 2|r loose too much and gain some help +|c00FFFC01" + I2S(k3) + "|r all stats|r", 10)
                endif */ 
                loop
                    exitwhen i == 10
                    if Hero[i] != null and Leave[i] == 0 then
                        call SetPlayerState(Player(i), PLAYER_STATE_RESOURCE_LUMBER, k2)
                        if GetUnitTypeId(Hero[i]) == Inori_ID then
                            call SaveInteger(hs, GetHandleId(Hero[i]), StringHash("Inori E"), 0)
                        endif
                        if HasCachedItem(Hero[i],SusanooShield_Item_ID) > 0 then
                        call SetItemCharges(UnitItemInSlot(Hero[i], IsItemInInventory3(Hero[i], SusanooShield_Item_ID)), 0)
                        endif
                        call SetUnitPosition(Hero[i], GetRectCenterX(gg_rct_Pick), GetRectCenterY(gg_rct_Pick))
                        if GetUnitTypeId(Hero[i]) == Erza_ID then
                            call ErzaF_Start(Hero[i])
                        endif
                        if GetUnitTypeId(Hero[i]) == Takeshi_ID then
                            call TakeshiGOff_Start(Hero[i])
                        endif
                        if GetUnitTypeId(Hero[i]) == Milim_ID or GetUnitTypeId(Hero[i]) == Milim2_ID then
                            call MilimGOff_Start(Hero[i])
                        endif
                        call SaveReal(hs, GetHandleId(Hero[i]), StringHash("zero kai dmg"), 0)
                        call AddGold(Player(i), reward, true)
                        if GetHeroLevel(Hero[i]) >= 30 then
                            call SetHeroLevel(Hero[i], GetHeroLevel(Hero[i]) + 5, true)
                        else
                            call SetHeroLevel(Hero[i], GetHeroLevel(Hero[i]) + 4, true)
                        endif
                        call SetFly(Hero[i], 0)
                        if IsUnitType(Hero[i], UNIT_TYPE_DEAD) then
                            call ReviveHero(Hero[i], GetUnitX(Hero[i]), GetUnitY(Hero[i]), true)
                            
                        endif
                        call SetScale(Hero[i],1)
                        call SaveReal(hs, GetHandleId(Hero[i]), StringHash("TMult"),1)
                        call SaveReal(hs, GetHandleId(Hero[i]), StringHash("FMult"),1)
                         /* 
                        if i < 5 then
                            set k3 = Team2Round - Team1Round
                        else
                            set k3 = Team1Round - Team2Round
                        endif
                        if k3 > 4 then
                            call UnitAddAbility(Hero[i], ComebackStat1)
                        else
                            call UnitRemoveAbility(Hero[i], ComebackStat1)
                        endif
                        if k3 > 5 then
                            call UnitAddAbility(Hero[i], ComebackStat2)
                        else
                            call UnitRemoveAbility(Hero[i], ComebackStat2)
                        endif
                        if k3 > 6 then
                            call UnitAddAbility(Hero[i], ComebackStat3)
                        else
                            call UnitRemoveAbility(Hero[i], ComebackStat3)
                        endif
                        if k3 > 7 then
                            call UnitAddAbility(Hero[i], ComebackStat4)
                        else
                            call UnitRemoveAbility(Hero[i], ComebackStat4)
                        endif
                        if k3 > 8 then
                            call UnitAddAbility(Hero[i], ComebackStat5)
                        else
                            call UnitRemoveAbility(Hero[i], ComebackStat5)
                        endif */ 
                        
                        call SelectUnitForPlayerSingle(Hero[i], Player(i))
                        call PanCameraToTimedForPlayer(Player(i), GetRectCenterX(gg_rct_Pick), GetRectCenterY(gg_rct_Pick), 0.25)
                    endif
                    set i = i + 1
                endloop
                set lender = 0
                set borrower = 0
                loop
                    exitwhen lender >= 12
                    set borrower = 0
                    loop
                        exitwhen borrower >= 12
                        if borrower != lender then
          // call GoldLoan_Collect(lender, borrower)
                        endif
                        set borrower = borrower + 1
                    endloop
                    set lender = lender + 1
                endloop
                set TransferClearMax = true
            endif
        endif
    else
        set END2 = END2 + 1
        if END2 == 20 then
            if Team1Round >= MaxRounds then
                set i = 0
                set i2 = 0
                loop
                    exitwhen i == 10
                    if IsInTeam1(i) then
                        call StartSoundForPlayerBJ(Player(i), gg_snd_Win)
                        call CustomVictoryBJ(Player(i), true, true)
                    else
                        call StartSoundForPlayerBJ(Player(i), gg_snd_Loose)
                        call CustomDefeatBJ(Player(i), "GG")
                    endif
                    set i = i + 1
                endloop
            elseif Team2Round >= MaxRounds then
                set i = 0
                set i2 = 0
                loop
                    exitwhen i == 10
                    if IsInTeam1(i) then
                        call StartSoundForPlayerBJ(Player(i), gg_snd_Loose)
                        call CustomDefeatBJ(Player(i), "GG")
                    else
                        call StartSoundForPlayerBJ(Player(i), gg_snd_Win)
                        call CustomVictoryBJ(Player(i), true, true)
                    endif
                    set i = i + 1
                endloop
            endif
        endif
    endif
    set t = null
endfunction


function initmapstart takes nothing returns nothing
    local integer i = 0 // 0 - Р В РЎвЂќР РЋР вЂљР В Р’В°Р РЋР С“Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р В РЎвЂР В РЎвЂ“Р РЋР вЂљР В РЎвЂўР В РЎвЂќ
    local integer i2 = 0
    local timer initTimer = GetExpiredTimer()
    call PauseTimer(initTimer)
    call DestroyTimer(initTimer)
    set initTimer = null
    loop
        exitwhen i == bj_MAX_PLAYERS
        if GetPlayerSlotState( Player( i ) ) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController( Player( i ) ) == MAP_CONTROL_USER then
            set PlayerCountValue = PlayerCountValue + 1
            call AddGold(Player(i), 2500, true)
        endif
        call SetCameraFieldForPlayer(Player(i), CAMERA_FIELD_TARGET_DISTANCE, BaseCam, 0)
        set i = i + 1
    endloop
   // call InitAllyCDTimer()
    set i = 0
    loop
        exitwhen i == bj_MAX_PLAYERS
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_R, 0, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_T, 0, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_F, 0, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_K, 0, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_S, 0, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_F1, 0, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_F3, 0, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_F4, 0, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_B, 0, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_TAB, 0, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_0, 0, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_I, 0, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_1, 2, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_2, 2, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_3, 2, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_4, 2, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_5, 2, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed, Player(i), OSKEY_6, 2, false )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonPressed_ESC, Player(i), OSKEY_ESCAPE, 0, true )
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_ButtonUnPressed_ESC, Player(i), OSKEY_ESCAPE, 0, false )
        set i = i + 1
    endloop
    //call MyHeroIdInit()
    call InitTrig_UI()
    call CreateStatusHeroUI()
    set IntroStart1 = CreateTimer()
    call TimerStart(IntroStart1, 1, true, function PrepareStart)
    //set Hero[6] =  CreateUnit(Player(6),'Hpal',GetRectCenterX(gg_rct_Arena),GetRectCenterY(gg_rct_Arena),1)
endfunction
function RemoveHashTag takes string s returns string
    local integer i = 0
    local integer len = StringLength(s)
    loop
        exitwhen i >= len
        if SubString(s, i, i + 1) == "#" then
            // Р В Р вЂ Р В РЎвЂўР В Р’В·Р В Р вЂ Р РЋР вЂљР В Р’В°Р РЋРІР‚В°Р В Р’В°Р В Р’ВµР В РЎВ Р РЋР С“Р РЋРІР‚С™Р РЋР вЂљР В РЎвЂўР В РЎвЂќР РЋРЎвЂњ Р В РІР‚СњР В РЎвЂє #
            return SubString(s, 0, i)
        endif
        set i = i + 1
    endloop
    return s
endfunction
function Map_Start takes nothing returns nothing
    local integer i = 0
    set PlayerColor[0] = "|cffff0303"
    set PlayerColor[1] = "|cff0042ff"
    set PlayerColor[2] = "|cff1be7ba"
    set PlayerColor[3] = "|cff550081"
    set PlayerColor[4] = "|cfffefc00"
    set PlayerColor[5] = "|cfffe890d"
    set PlayerColor[6] = "|cff21bf00"
    set PlayerColor[7] = "|cffe45caf"
    set PlayerColor[8] = "|cff939596"
    set PlayerColor[9] = "|cff7ebff1"
    call TriggerAddAction(Frame_clickKyoraku, function KyorakuFrameClick)
    loop
        exitwhen i == bj_MAX_PLAYERS
        set FRAME_SwapActive[i] = 0
        set EffectActive[i] = false
        call FogModifierStart(CreateFogModifierRect(Player(i), FOG_OF_WAR_VISIBLE, gg_rct_Base, true, false))
        call FogModifierStart(CreateFogModifierRect(Player(i), FOG_OF_WAR_VISIBLE, gg_rct_Cage, true, false))
        call FogModifierStart(CreateFogModifierRect(Player(i), FOG_OF_WAR_VISIBLE, gg_rct_Metro, true, false))
        if i>9 then 
        call FogModifierStart(CreateFogModifierRect(Player(i), FOG_OF_WAR_VISIBLE, gg_rct_Arena, true, false))
        endif
        set FramePlayerFirstNameBase[i] = GetPlayerName(Player(i))
        call SaveSystem_SetIdentity(Player(i), FramePlayerFirstNameBase[i])

        call SetPlayerName(Player(i), RemoveHashTag(GetPlayerName(Player(i))))
        set FramePlayerFirstName[i] = GetPlayerName(Player(i))
        if VIPCheckLvl3(FramePlayerFirstName[i]) then
    call CustomChat_SetPlayerAccessLevel(Player(i), 3)
elseif VIPCheckLvl2(FramePlayerFirstName[i]) then
    call CustomChat_SetPlayerAccessLevel(Player(i), 2)
elseif VIPCheckLvl1(FramePlayerFirstName[i]) then
    call CustomChat_SetPlayerAccessLevel(Player(i), 1)
else
    call CustomChat_SetPlayerAccessLevel(Player(i), 0)
endif
        call HideBottomUI(Player(i), true)
        set PlayerShopButton[i] = OSKEY_TAB
        if TestMode == true and i < 10 then
            call AddGold(Player(i), 98750, true)
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i == 10
        set SwapRequests[i] = -1
        if i < 10 then
            if VIPCheckLvl3(FramePlayerFirstName[i]) then
                if FramePlayerFirstName[i] == "Uriska" then
                    call SetPlayerName(Player(i), FramePlayerFirstName[i] + "|cffe45caf[VIP]|r")
                elseif FramePlayerFirstName[i] == "Zesu" then
                    call SetPlayerName(Player(i), FramePlayerFirstName[i] + "|c009428FF[VIP]|r")
                else
                    call SetPlayerName(Player(i), FramePlayerFirstName[i] + "|c00FFFF00[VIP]|r")
                endif
            endif
        endif
        set i = i + 1
    endloop
    call BlzChangeMinimapTerrainTex("war3mapImported\\war3mapMapTrue.blp")
// 0 Red

    call SaveSystem_Init()
    call SaveSystem_RegisterChat()
    set PC_R[0] = 255
    set PC_G[0] = 0
    set PC_B[0] = 0
    // 1 Blue
    set PC_R[1] = 0
    set PC_G[1] = 0
    set PC_B[1] = 255
    // 2 Teal
    set PC_R[2] = 0
    set PC_G[2] = 255
    set PC_B[2] = 255
    // 3 Purple
    set PC_R[3] = 128
    set PC_G[3] = 0
    set PC_B[3] = 128
    // 4 Yellow
    set PC_R[4] = 255
    set PC_G[4] = 255
    set PC_B[4] = 0
    // 5 Orange
    set PC_R[5] = 255
    set PC_G[5] = 128
    set PC_B[5] = 0
    // 6 Green
    set PC_R[6] = 0
    set PC_G[6] = 255
    set PC_B[6] = 0
    // 7 Pink
    set PC_R[7] = 255
    set PC_G[7] = 0
    set PC_B[7] = 255
    // 8 Gray
    set PC_R[8] = 128
    set PC_G[8] = 128
    set PC_B[8] = 128
    // 9 Light Blue
    set PC_R[9] = 0
    set PC_G[9] = 191
    set PC_B[9] = 255
    // 10 Dark Green
    set PC_R[10] = 0
    set PC_G[10] = 128
    set PC_B[10] = 0
    call TimerStart(CreateTimer(), 0.1, false, function initmapstart)
endfunction


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
