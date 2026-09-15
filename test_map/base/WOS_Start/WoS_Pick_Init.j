globals
    integer PlayerCountValue = 0
    unit array Hero
    unit array HeroChosen
    trigger FrameClick 
    trigger FrameGuideEnter 
    trigger FrameGuideLeave 
    oskeytype array PlayerShopButton
    texttag ShopInfo 
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
    framehandle array FRAME_AbiText
    framehandle array FRAME_PlayerPickText
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
    timer IntroStart1
    real TimeMove = 0
    real BaseCam = 3800
    real TimeRound = 120
    integer array PC_R
    integer array PC_G
    integer array PC_B
    fogmodifier array PlayerVision
    integer CondArena = 0 // 0 - prepare, 1 - arena
    integer RandomAllPlayers = 0  // эта переменная отвечает за одноразовое срабатывание рандома для всех по истечению таймера пика
    integer FirstTime = 0 // переменная для фикса первого долгого отсчета таймера, когда будет равна единице таймер будет считать по обычному
    real r_ping = 1
    real r_train = 1
endglobals
function MyHeroIdInit takes nothing returns nothing
    local integer page = 0 // 0 genshin, 1 ft, 2 bleach, 3 one piece, 4 other
    local integer i = 0
    local integer n = 0
    local integer current
    loop
        exitwhen i == bj_MAX_PLAYER_SLOTS
        set PlayerSoundCurrent[i] = 0
        set i = i + 1
    endloop
    set i = 0
//=========Genshin==============
set n = 0
    set Hero_ID0[n] = Raiden_ID // Raiden EI
    set Hero_ID0_Dummy[n] = CreateUnit(Player(12), Hero_ID0[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID0_Dummy[n], false)
    call UnitAddAbility(Hero_ID0_Dummy[n], RaidenQ_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], RaidenW_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], RaidenE_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], RaidenR_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], RaidenT_ID)
//=========Bleach==============
    set n = 0
    set Hero_ID1[n] = Kyoraku_ID // Kyoraku
    set Hero_ID1_Dummy[n] = CreateUnit(Player(12), Hero_ID1[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID1_Dummy[n], false)
    call UnitAddAbility(Hero_ID1_Dummy[n], KyorakuQ_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], KyorakuW_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], KyorakuE_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], KyorakuR_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], KyorakuT_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], KyorakuF_ID)
//=========Fairy Tail==============
    set n = 0
    set Hero_ID2[n] = Natsu_ID // Natsu
    set Hero_ID2_Dummy[n] = CreateUnit(Player(12), Hero_ID2[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID2_Dummy[n], false)
    call UnitAddAbility(Hero_ID2_Dummy[n], NatsuQ_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], NatsuW_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], NatsuE_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], NatsuR_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], NatsuT_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], NatsuF_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], NatsuG_ID)
    set n = 1
    set Hero_ID2[n] = Erza_ID // Erza
    set Hero_ID2_Dummy[n] = CreateUnit(Player(12), Hero_ID2[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID2_Dummy[n], false)
    call UnitAddAbility(Hero_ID2_Dummy[n], ErzaQ_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], ErzaW_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], ErzaE_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], ErzaR_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], ErzaT_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], ErzaF_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], ErzaG_ID)
//=========One Piece==============
  
//=========Other Anime==============
    set n = 0
    set Hero_ID4[n] = Gojo_ID // Gojo
    set Hero_ID4_Dummy[n] = CreateUnit(Player(12), Hero_ID4[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID4_Dummy[n], false)
    call UnitAddAbility(Hero_ID4_Dummy[n], GojoQ_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], GojoW_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], GojoE_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], GojoR_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], GojoT_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], GojoG_ID)
    set n = 1
    set Hero_ID4[n] = Tomioka_ID // Tomioka
    set Hero_ID4_Dummy[n] = CreateUnit(Player(12), Hero_ID4[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID4_Dummy[n], false)
    call UnitAddAbility(Hero_ID4_Dummy[n], TomiokaQ_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], TomiokaW_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], TomiokaE_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], TomiokaR_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], TomiokaT_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], TomiokaF_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], TomiokaG_ID)
    set n = 2
    set Hero_ID4[n] = AlterSaber_ID // AlterSaber
    set Hero_ID4_Dummy[n] = CreateUnit(Player(12), Hero_ID4[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID4_Dummy[n], false)
    call UnitAddAbility(Hero_ID4_Dummy[n], AlterSaberQ_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], AlterSaberW_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], AlterSaberE_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], AlterSaberR_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], AlterSaberT_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], AlterSaberF_ID)
    set n = 3
    set Hero_ID4[n] = Kenjaku_ID // Kenjaku
    set Hero_ID4_Dummy[n] = CreateUnit(Player(12), Hero_ID4[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID4_Dummy[n], false)
    call UnitAddAbility(Hero_ID4_Dummy[n], KenjakuQ_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], KenjakuW_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], KenjakuE_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], KenjakuR_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], KenjakuT_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], KenjakuF_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], KenjakuG_ID)
//==============================
endfunction
function ReloadHeroPage takes integer page, player p returns nothing
    local boolean b
    local boolean b2
    local integer i = 0
    local integer id = 0
    loop
        exitwhen i == 24
        if GetLocalPlayer() == p then
        call BlzFrameSetTexture(FRAME_ICON2[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        endif
        if page == 0 then
            set b = Hero_ID0[i] != 0
            set b2 = Hero_ID0[i] == 12
            set id = Hero_ID0[i]
        elseif page == 1 then
            set b = Hero_ID1[i] != 0
            set b2 = Hero_ID1[i] == 12
            set id = Hero_ID1[i]
        elseif page == 2 then
            set b = Hero_ID2[i] != 0
            set b2 = Hero_ID2[i] == 12
            set id = Hero_ID2[i]
        elseif page == 3 then
            set b = Hero_ID3[i] != 0
            set b2 = Hero_ID3[i] == 12
            set id = Hero_ID3[i]
        elseif page == 4 then
            set b = Hero_ID4[i] != 0
            set b2 = Hero_ID4[i] == 12
            set id = Hero_ID4[i]
        endif
        if b then
            if GetLocalPlayer() == p then
                if b2 == false then
                    call BlzFrameSetTexture(FRAME_ICON2[i], BlzGetAbilityIcon(id), 0, false)
                    call BlzFrameSetEnable(FRAME_ICON[i], true)
                else
                    call BlzFrameSetEnable(FRAME_ICON[i], false)
                    call BlzFrameSetTexture(FRAME_ICON2[i], "ReplaceableTextures\\CommandButtons\\BTNCancel", 0, false)
                endif
            endif
        else
            if GetLocalPlayer() == p then
                call BlzFrameSetEnable(FRAME_ICON[i], false)
               // call BlzFrameSetTexture(FRAME_ICON2[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
            endif
        endif
        set i = i + 1
    endloop
endfunction
function RandomPick takes player p returns nothing
    local integer i = 0
    local integer id = 0
    local integer k = R2I(GetRandomReal(0,6))
    local integer k2 = 0
    local integer k3 = 0
    local integer pid = GetPlayerId(p)
    local real BaseX = GetRectCenterX(gg_rct_Pick)
    local real BaseY = GetRectCenterY(gg_rct_Pick)
if Hero[pid] == null and GetPlayerSlotState( Player( pid ) ) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController( Player( pid ) ) == MAP_CONTROL_USER then
if k == 0 then 
set k2 = Hero_ID0[0]
set FRAME_PlayerPickString[pid] = "Raiden Ei"
call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro3",p)
elseif k == 1 then
set k2 = Hero_ID2[0]
call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick3",p)
set FRAME_PlayerPickString[pid] = "Natsu Dragneel"
set NatsuPicked = true
elseif k == 2 then
set k2 = Hero_ID4[0]
 call MakeSoundLocal("war3mapimported\\Hero_Gojo_E3",p)
set FRAME_PlayerPickString[pid] = "Satoru Gojo"
elseif k == 3 then
set k2 = Hero_ID4[1]
call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick2",p)
set FRAME_PlayerPickString[pid] = "Giyu Tomioka"
elseif k == 4 then
set k2 = Hero_ID4[2]
call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick5",p)
set FRAME_PlayerPickString[pid] = "Alter Saber"
elseif k == 5 then
set k2 = Hero_ID2[1]
call MakeSoundLocal("war3mapimported\\Hero_Erza_Start2",p)
set FRAME_PlayerPickString[pid] = "Erza Scarlet"
elseif k == 6 then
set k2 = Hero_ID4[3]
call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick1",p)
set FRAME_PlayerPickString[pid] = "Kenjaku"
elseif k == 7 then
set k2 = Hero_ID1[0]
call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick2",p)
set FRAME_PlayerPickString[pid] = "Kyoraku Shunsui"
endif
set PlayerFrameCurrent_ID[pid] = k2
        set Hero[pid] = CreateUnit(p, PlayerFrameCurrent_ID[pid], BaseX, BaseY, 270)
        
        // call BlzFrameSetEnable(FRAME_ICON[0], false)
       // call BlzFrameSetEnable(FRAME_ICON2[0], false)
        call BlzFrameSetTexture(FRAME_PlayerPickBack[pid], BlzGetAbilityIcon(PlayerFrameCurrent_ID[pid]), 0, false)
        set PlayerFrameCurrent_ID[pid] = 0
        call HideBottomUI(Player(pid),false)
       // set Hero_ID0[0] = 12
       // call BlzFrameSetTexture(FRAME_ICON2[0], "ReplaceableTextures\\CommandButtons\\BTNCancel", 0, false)
        if GetLocalPlayer() == p then
            call BlzFrameSetVisible(FRAME_MAIN, false)          
        call BlzFrameSetVisible(FRAME_StatusHeroMain,true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain2,true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain3,true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain4,true)
        call BlzFrameSetVisible(FRAME_LINK2,true)
        
            call PanCameraToTimed(BaseX, BaseY, 0.25)
            call SetCameraField( CAMERA_FIELD_TARGET_DISTANCE, 3500, 0.25 )
            call SelectUnit(Hero[pid], true)
        endif
        call PlayersMsg( GetPlayerColorString(p)+ GetPlayerName(p)+"|r randomed |c00FFFF00"+BlzGetUnitStringField(Hero[pid],UNIT_SF_NAME)+"|r",1 )
            call EUTU2_3(EffectSpawn("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", GetUnitX(Hero[pid]), GetUnitY(Hero[pid]), 270, 0.85, 1.45, 0), 2.5, 0, Hero[pid])
            call SetHeroLevel(Hero[pid], 2, false)
            call LearnHeroSpells(Hero[pid])
            endif
endfunction
function OnClick takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local integer i = 0
    local integer i2 = 0
    local string s
    local string s_name
    local integer id = 0
    local integer end = 0
    local integer k3 = 0
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local integer number_hero
    local real x = 0.025
    local real y = -0.05  
    local real BaseX 
    local integer b = 0 
    local real BaseY
    local unit d = null
    local integer k = 0
    if clicked == Frame_PageHeroList[0] or clicked == Frame_PageHeroList[1] or clicked == Frame_PageHeroList[2] or clicked == Frame_PageHeroList[3] or clicked == Frame_PageHeroList[4] then
        if GetLocalPlayer() == p then
            set PlayerFrameCurrent_ID[pid] = 0
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
            call BlzFrameSetVisible(FRAME_HeroInt, false)
            call BlzFrameSetVisible(FRAME_HeroAtk, false)
            call BlzFrameSetVisible(FRAME_HeroArmor, false)
            call BlzFrameSetVisible(FRAME_HeroMS, false)
            call BlzFrameSetVisible(FRAME_HeroAS, false)
            call BlzFrameSetText(FRAME_HeroName, "Hero Name")
        endif
        if clicked == Frame_PageHeroList[0] then
            set PlayerFrameCurrentPage_ID[pid] = 0
        elseif clicked == Frame_PageHeroList[1] then
            set PlayerFrameCurrentPage_ID[pid] = 1
        elseif clicked == Frame_PageHeroList[2] then
            set PlayerFrameCurrentPage_ID[pid] = 2
        elseif clicked == Frame_PageHeroList[3] then
            set PlayerFrameCurrentPage_ID[pid] = 3
        elseif clicked == Frame_PageHeroList[4] then
            set PlayerFrameCurrentPage_ID[pid] = 4
        endif
        call ReloadHeroPage(PlayerFrameCurrentPage_ID[pid], p)
    endif
    set k3 = 0
    loop
    exitwhen k3 == 4  
    if clicked == FRAME_ICON[k3] then
        if PlayerFrameCurrentPage_ID[pid] == 0 and Hero_ID0[k3] != 0 then
            if k3 == 0 then 
            set s = "Raiden"
            set s_name = "Raiden Ei"
            set b = 0
            endif
            set PlayerFrameCurrent_ID[pid] = Hero_ID0[k3]
            set d = Hero_ID0_Dummy[k3]
        elseif PlayerFrameCurrentPage_ID[pid] == 1 and Hero_ID1[k3] != 0 then 
            if k3 == 0 then 
            set b = 4
            set s = "Kyoraku"
            set s_name = "Kyoraku Shunsui"
            elseif k3 == 1 then 
            endif
            set PlayerFrameCurrent_ID[pid] = Hero_ID1[k3]   
            set d = Hero_ID1_Dummy[k3]
        elseif PlayerFrameCurrentPage_ID[pid] == 2 and Hero_ID2[k3] != 0 then 
            if k3 == 0 then 
            set b = 2
            set s = "Natsu"
            set s_name = "Natsu Dragneel"
            elseif k3 == 1 then 
            set b = 2
            set s = "Erza"
            set s_name = "Erza Scarlet"
            endif
            set PlayerFrameCurrent_ID[pid] = Hero_ID2[k3]   
            set d = Hero_ID2_Dummy[k3]    
        elseif PlayerFrameCurrentPage_ID[pid] == 4 and Hero_ID4[k3] != 0 then 
            if k3 == 0 then 
            set s = "Gojo"
            set b = 3
            set s_name = "Satoru Gojo"
            elseif k3 == 1 then 
            set s = "Tomioka"
            set b = 2
            set s_name = "Giyu Tomioka"
            elseif k3 == 2 then 
            set s = "AlterSaber"
            set b = 4
            set s_name = "Alter Saber"
            elseif k3 == 3 then 
            set s = "Kenjaku"
            set b = 2
            set s_name = "Kenjaku"
            endif
            set PlayerFrameCurrent_ID[pid] = Hero_ID4[k3]   
            set d = Hero_ID4_Dummy[k3]
        endif
        if GetLocalPlayer() == p then
            call BlzFrameSetTexture(FRAME_ICON6[0], "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_Q", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[1], "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_W", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[2], "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_E", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[3], "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_R", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[4], "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_T", 0, false)
            if b == 0 then 
            call BlzFrameSetTexture(FRAME_ICON6[5], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[6], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
            call BlzFrameSetEnable(FRAME_ICON5[5], false)
            call BlzFrameSetEnable(FRAME_ICON5[6], false)
            elseif b == 2 then 
            call BlzFrameSetTexture(FRAME_ICON6[5], "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_F", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[6], "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_G", 0, false)
            call BlzFrameSetEnable(FRAME_ICON5[5], true)
            call BlzFrameSetEnable(FRAME_ICON5[6], true)
            elseif b == 3 then 
            call BlzFrameSetTexture(FRAME_ICON6[5], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[6], "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_G", 0, false)
            call BlzFrameSetEnable(FRAME_ICON5[5], false)
            call BlzFrameSetEnable(FRAME_ICON5[6], true)
            elseif b == 4 then 
            call BlzFrameSetTexture(FRAME_ICON6[5], "ReplaceableTextures\\CommandButtons\\BTNHero_" + s + "_F", 0, false)
            call BlzFrameSetTexture(FRAME_ICON6[6], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
            call BlzFrameSetEnable(FRAME_ICON5[5], true)
            call BlzFrameSetEnable(FRAME_ICON5[6], false)
            endif
            call BlzFrameSetVisible(FRAME_HeroAttribute, true)
            call BlzFrameSetVisible(FRAME_HeroAttackType, true)
            call BlzFrameSetVisible(FRAME_HeroStr, true)
            call BlzFrameSetVisible(FRAME_HeroAgi, true)
            call BlzFrameSetVisible(FRAME_HeroInt, true)
            call BlzFrameSetVisible(FRAME_HeroAtk, true)
            call BlzFrameSetVisible(FRAME_HeroArmor, true)
            call BlzFrameSetVisible(FRAME_HeroMS, true)
            call BlzFrameSetVisible(FRAME_HeroAS, true)
            call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_" + s + "_port", 0, false)
            call BlzFrameSetText(FRAME_HeroName, s_name)
            call BlzFrameSetText(FRAME_HeroStr, "|cffff0000Str: " + I2S(BlzGetUnitIntegerField(d, UNIT_IF_STRENGTH)) + "+" + R2SW(BlzGetUnitRealField(d, UNIT_RF_STRENGTH_PER_LEVEL), 0, 2) + "|r")
            call BlzFrameSetText(FRAME_HeroAgi, "|cff289b1eAgi: " + I2S(BlzGetUnitIntegerField(d, UNIT_IF_AGILITY)) + "+" + R2SW(BlzGetUnitRealField(d, UNIT_RF_AGILITY_PER_LEVEL), 0, 2) + "|r")
            call BlzFrameSetText(FRAME_HeroInt, "|cff3737ffInt: " + I2S(BlzGetUnitIntegerField(d, UNIT_IF_INTELLIGENCE)) + "+" + R2SW(BlzGetUnitRealField(d, UNIT_RF_INTELLIGENCE_PER_LEVEL), 0, 2) + "|r")
            call BlzFrameSetText(FRAME_HeroAtk, "Atk: " + I2S(BlzGetUnitWeaponIntegerField(d, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0)))
            call BlzFrameSetText(FRAME_HeroArmor, "Def: " + R2SW(BlzGetUnitArmor(d), 0, 2))
            call BlzFrameSetText(FRAME_HeroMS, "MS: " + I2S(R2I(GetUnitDefaultMoveSpeed(d))))
            call BlzFrameSetText(FRAME_HeroAS, "AS: " + R2SW(BlzGetUnitWeaponRealField(d, UNIT_WEAPON_RF_ATTACK_BASE_COOLDOWN, 0), 0, 2))
            if IsUnitType(d, UNIT_TYPE_MELEE_ATTACKER) == true then
                call BlzFrameSetTexture(FRAME_HeroAttackType, "Pick\\PickButton_Attack_Normal", 0, true)
            else
                call BlzFrameSetTexture(FRAME_HeroAttackType, "Pick\\PickButton_Attack_Ranged", 0, true)
            endif
            if BlzGetUnitIntegerField(d, UNIT_IF_PRIMARY_ATTRIBUTE) == 1 then
                call BlzFrameSetTexture(FRAME_HeroAttribute, "UI\\Widgets\\Console\\Human\\infocard-heroattributes-str", 0, true)
            elseif BlzGetUnitIntegerField(d, UNIT_IF_PRIMARY_ATTRIBUTE) == 3 then
                call BlzFrameSetTexture(FRAME_HeroAttribute, "UI\\Widgets\\Console\\Human\\infocard-heroattributes-agi", 0, true)
            elseif BlzGetUnitIntegerField(d, UNIT_IF_PRIMARY_ATTRIBUTE) == 2 then
                call BlzFrameSetTexture(FRAME_HeroAttribute, "UI\\Widgets\\Console\\Human\\infocard-heroattributes-int", 0, true)
            endif
        endif  
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
                call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro1",p)
                elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro2",p)
                elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro3",p)
                elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro4",p)
                elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro5",p)
                endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[0] then
                if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick1",p)
                elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick2",p)
                elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick3",p)
                elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick4",p)
                elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick5",p)
                endif        
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID2[0] then
                if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick1",p)
                elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick2",p)
                elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick3",p)
                elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick4",p)
                elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick5",p)
                endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID2[1] then
                if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Erza_Start",p)
                elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Erza_Pick1",p)
                elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Erza_Start2",p)
                elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Erza_Pick3",p)
                elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Erza_Pick2",p)
                endif        
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[0] then
                if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Gojo_E3",p)
                elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Gojo_E1",p)
                elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Gojo_R1",p)
                elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Gojo_RE",p)
                elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Gojo_RW1",p)
                endif        
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[1] then
                if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick1",p)
                elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick2",p)
                elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick3",p)
                elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick4",p)
                elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick5",p)
                endif 
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[2] then
                if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick1",p)
                elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick2",p)
                elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick3",p)
                elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick4",p)
                elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick5",p)
                endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[3] then
                if i == 0 then
                call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick1",p)
                elseif i == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick2",p)
                elseif i == 2 then
                call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick3",p)
                elseif i == 3 then
                call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick4",p)
                elseif i == 4 then
                call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick5",p)
                endif        
        endif
    endif
    if clicked == FRAME_Pick[3] then 
    call RandomPick(p)
    endif
    if clicked == FRAME_Pick[2] and PlayerFrameCurrent_ID[pid] != 0 and PlayerFrameCurrent_ID[pid] != 12 then
    set BaseX = GetRectCenterX(gg_rct_Pick)
    set BaseY = GetRectCenterY(gg_rct_Pick)
    set id = PlayerFrameCurrent_ID[pid]
    set Hero[pid] = CreateUnit(p, PlayerFrameCurrent_ID[pid], BaseX, BaseY, 270)
       // call BlzFrameSetEnable(FRAME_ICON[0], false)
       // call BlzFrameSetEnable(FRAME_ICON2[0], false)
    call BlzFrameSetTexture(FRAME_PlayerPickBack[pid], BlzGetAbilityIcon(PlayerFrameCurrent_ID[pid]), 0, false)
        set PlayerFrameCurrent_ID[pid] = 0
        if id == Hero_ID0[0] then
        set FRAME_PlayerPickString[pid] = "Raiden Ei"
        call MakeSoundLocal("war3mapimported\\Hero_Raiden_Intro3",p)
        elseif id == Hero_ID1[0] then
        set Hero_ID1[0] = 12
        set FRAME_PlayerPickString[pid] = "Kyoraku"
        call BlzFrameSetTexture(FRAME_ICON2[0], "ReplaceableTextures\\CommandButtons\\BTNCancel", 0, false) 
        call MakeSoundLocal("war3mapimported\\Hero_Kyoraku_Pick2",p)
        elseif id == Hero_ID2[0] then
        set FRAME_PlayerPickString[pid] = "Natsu"
        set NatsuPicked = true
        call MakeSoundLocal("war3mapimported\\Hero_Natsu_Pick3",p)
        elseif id == Hero_ID2[1] then
        set FRAME_PlayerPickString[pid] = "Erza"
        call MakeSoundLocal("war3mapimported\\Hero_Erza_Start2",p)
        elseif id == Hero_ID4[0] then
        set FRAME_PlayerPickString[pid] = "Gojo"
        call MakeSoundLocal("war3mapimported\\Hero_Gojo_E3",p)
        elseif id == Hero_ID4[1] then
        set FRAME_PlayerPickString[pid] = "Giyu"
        call MakeSoundLocal("war3mapimported\\Hero_Tomioka_Pick2",p)
        elseif id == Hero_ID4[2] then
        set FRAME_PlayerPickString[pid] = "AlterSaber"
        call MakeSoundLocal("war3mapimported\\Hero_AlterSaber_Pick5",p)
        elseif id == Hero_ID4[3] then
        set FRAME_PlayerPickString[pid] = "Kenjaku"
        call MakeSoundLocal("war3mapimported\\Hero_Kenjaku_Pick1",p)
        endif
       // set Hero_ID0[0] = 12
       // call BlzFrameSetTexture(FRAME_ICON2[0], "ReplaceableTextures\\CommandButtons\\BTNCancel", 0, false) 
       call HideBottomUI(Player(pid),false)
       set PlayerVision[pid] = CreateFogModifierRadius(Player(pid), FOG_OF_WAR_VISIBLE, BaseX, BaseY, 1800, true, false)
        call FogModifierStart(PlayerVision[pid])
        if GetLocalPlayer() == p then
            call BlzFrameSetVisible(FRAME_MAIN, false)
            call PanCameraToTimed(BaseX, BaseY, 0.25)
            call SetCameraField( CAMERA_FIELD_TARGET_DISTANCE, 3500, 0.25 )
            call SelectUnit(Hero[pid], true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain,true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain2,true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain3,true)
        call BlzFrameSetVisible(FRAME_StatusHeroMain4,true)
        call BlzFrameSetVisible(FRAME_LINK2,true)
        endif
            call EUTU2_3(EffectSpawn("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", GetUnitX(Hero[pid]), GetUnitY(Hero[pid]), 270, 0.85, 1.45, 0), 2.5, 0, Hero[pid])
            call SetHeroLevel(Hero[pid], 2, false)
            call LearnHeroSpells(Hero[pid])
            call PlayersMsg( GetPlayerColorString(p)+ GetPlayerName(p)+"|r picked |c00FFFF00"+BlzGetUnitStringField(Hero[pid],UNIT_SF_NAME)+"|r",1 )
    endif
    set s = null
    set d = null
    set s_name = null
    set p = null
endfunction
function GuideEnter takes nothing returns nothing
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
    local unit d = null
    if clicked == FRAME_ICON5[0] or clicked == FRAME_ICON5[1] or clicked == FRAME_ICON5[2] or clicked == FRAME_ICON5[3] or clicked == FRAME_ICON5[4] or clicked == FRAME_ICON5[5] or clicked == FRAME_ICON5[6] then
        if GetLocalPlayer() == p then 
        call BlzFrameSetVisible(FRAME_SpellTooltipName, true)
        call BlzFrameSetVisible(FRAME_HeroModel, false)
        call BlzFrameSetText(FRAME_SpellTooltipName, "")
        endif
        if PlayerFrameCurrent_ID[pid] == Hero_ID0[0] then
            set i = 0
            set d = Hero_ID0_Dummy[i]
            if clicked == FRAME_ICON5[0] then 
            set id = RaidenQ_ID
            elseif clicked == FRAME_ICON5[1] then
            set id = RaidenW_ID
            elseif clicked == FRAME_ICON5[2] then
            set id = RaidenE_ID
            elseif clicked == FRAME_ICON5[3] then
            set id = RaidenR_ID
            elseif clicked == FRAME_ICON5[4] then
            set id = RaidenT_ID
            elseif clicked == FRAME_ICON5[5] then
            set id = 0
            elseif clicked == FRAME_ICON5[6] then
            set id = 0
            endif
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID1[0] then  
            set i = 0
            set d = Hero_ID1_Dummy[i]
            if clicked == FRAME_ICON5[0] then 
            set id = KyorakuQ_ID
            elseif clicked == FRAME_ICON5[1] then
            set id = KyorakuW_ID
            elseif clicked == FRAME_ICON5[2] then
            set id = KyorakuE_ID
            elseif clicked == FRAME_ICON5[3] then
            set id = KyorakuR_ID
            elseif clicked == FRAME_ICON5[4] then
            set id = KyorakuT_ID
            elseif clicked == FRAME_ICON5[5] then
            set id = KyorakuF_ID
            endif    
        elseif PlayerFrameCurrent_ID[pid] == Hero_ID2[0] then  
            set i = 0
            set d = Hero_ID2_Dummy[i]
            if clicked == FRAME_ICON5[0] then 
            set id = NatsuQ_ID
            elseif clicked == FRAME_ICON5[1] then
            set id = NatsuW_ID
            elseif clicked == FRAME_ICON5[2] then
            set id = NatsuE_ID
            elseif clicked == FRAME_ICON5[3] then
            set id = NatsuR_ID
            elseif clicked == FRAME_ICON5[4] then
            set id = NatsuT_ID
            elseif clicked == FRAME_ICON5[5] then
            set id = NatsuF_ID
            elseif clicked == FRAME_ICON5[6] then
            set id = NatsuG_ID
            endif
         elseif PlayerFrameCurrent_ID[pid] == Hero_ID2[1] then  
            set i = 1
            set d = Hero_ID2_Dummy[i]
            if clicked == FRAME_ICON5[0] then 
            set id = ErzaQ_ID
            if GetLocalPlayer() == p then 
            call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_ErzaQ_port", 0, false)
            endif
            elseif clicked == FRAME_ICON5[1] then
            set id = ErzaW_ID
            if GetLocalPlayer() == p then 
            call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_ErzaW_port", 0, false)
            endif
            elseif clicked == FRAME_ICON5[2] then
            set id = ErzaE_ID
            if GetLocalPlayer() == p then 
            call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_ErzaE_port", 0, false)
            endif
            elseif clicked == FRAME_ICON5[3] then
            set id = ErzaR_ID
            if GetLocalPlayer() == p then 
            call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_ErzaR_port", 0, false)
            endif
            elseif clicked == FRAME_ICON5[4] then
            set id = ErzaT_ID
            if GetLocalPlayer() == p then 
            call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_ErzaT_port", 0, false)
            endif
            elseif clicked == FRAME_ICON5[5] then
            set id = ErzaF_ID
            if GetLocalPlayer() == p then 
            call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_Erza_port", 0, false)
            endif
            elseif clicked == FRAME_ICON5[6] then
            set id = ErzaG_ID
            if GetLocalPlayer() == p then 
            call BlzFrameSetTexture(FRAME_HeroModel, "war3mapimported\\wos_Erza_port", 0, false)
            endif
            endif   
         elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[0] then  
            set i = 0
            set d = Hero_ID4_Dummy[i]
            if clicked == FRAME_ICON5[0] then 
            set id = GojoQ_ID
            elseif clicked == FRAME_ICON5[1] then
            set id = GojoW_ID
            elseif clicked == FRAME_ICON5[2] then
            set id = GojoE_ID
            elseif clicked == FRAME_ICON5[3] then
            set id = GojoR_ID
            elseif clicked == FRAME_ICON5[4] then
            set id = GojoT_ID
            elseif clicked == FRAME_ICON5[6] then
            set id = GojoG_ID
            endif   
          elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[1] then  
            set i = 1
            set d = Hero_ID4_Dummy[i]
            if clicked == FRAME_ICON5[0] then 
            set id = TomiokaQ_ID
            elseif clicked == FRAME_ICON5[1] then
            set id = TomiokaW_ID
            elseif clicked == FRAME_ICON5[2] then
            set id = TomiokaE_ID
            elseif clicked == FRAME_ICON5[3] then
            set id = TomiokaR_ID
            elseif clicked == FRAME_ICON5[4] then
            set id = TomiokaT_ID
            elseif clicked == FRAME_ICON5[5] then
            set id = TomiokaF_ID
            elseif clicked == FRAME_ICON5[6] then
            set id = TomiokaG_ID
            endif
            elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[2] then  
            set i = 2
            set d = Hero_ID4_Dummy[i]
            if clicked == FRAME_ICON5[0] then 
            set id = AlterSaberQ_ID
            elseif clicked == FRAME_ICON5[1] then
            set id = AlterSaberW_ID
            elseif clicked == FRAME_ICON5[2] then
            set id = AlterSaberE_ID
            elseif clicked == FRAME_ICON5[3] then
            set id = AlterSaberR_ID
            elseif clicked == FRAME_ICON5[4] then
            set id = AlterSaberT_ID
            elseif clicked == FRAME_ICON5[5] then
            set id = AlterSaberF_ID
            endif
            elseif PlayerFrameCurrent_ID[pid] == Hero_ID4[3] then  
            set i = 3
            set d = Hero_ID4_Dummy[i]
            if clicked == FRAME_ICON5[0] then 
            set id = KenjakuQ_ID
            elseif clicked == FRAME_ICON5[1] then
            set id = KenjakuW_ID
            elseif clicked == FRAME_ICON5[2] then
            set id = KenjakuE_ID
            elseif clicked == FRAME_ICON5[3] then
            set id = KenjakuR_ID
            elseif clicked == FRAME_ICON5[4] then
            set id = KenjakuT_ID
            elseif clicked == FRAME_ICON5[5] then
            set id = KenjakuF_ID
            elseif clicked == FRAME_ICON5[6] then
            set id = KenjakuG_ID
            endif
        endif    
        if id != 0 then 
            if BlzGetAbilityStringLevelField(BlzGetUnitAbility(d, id), ABILITY_SLF_TOOLTIP_LEARN, 1) != "Tool tip missing!" then 
            if GetLocalPlayer() == p then 
            call BlzFrameSetText(FRAME_SpellTooltipName, BlzGetAbilityStringLevelField(BlzGetUnitAbility(d, id), ABILITY_SLF_TOOLTIP_LEARN, 1) + "|n|n" + BlzGetAbilityStringLevelField(BlzGetUnitAbility(d, id), ABILITY_SLF_TOOLTIP_LEARN_EXTENDED, 0) )
            endif
            else
            if GetLocalPlayer() == p then 
            call BlzFrameSetText(FRAME_SpellTooltipName, BlzGetAbilityStringLevelField(BlzGetUnitAbility(d, id), ABILITY_SLF_TOOLTIP_NORMAL, 0) + "|n|n" + BlzGetAbilityStringLevelField(BlzGetUnitAbility(d, id), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, 0) )
            endif
            endif
        endif    
    endif
    set i = 0
    set d = null
    set p = null
endfunction
function GuideLeave takes nothing returns nothing
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
    if clicked == FRAME_ICON5[0] or clicked == FRAME_ICON5[1] or clicked == FRAME_ICON5[2] or clicked == FRAME_ICON5[3] or clicked == FRAME_ICON5[4] or clicked == FRAME_ICON5[5] or clicked == FRAME_ICON5[6] then
    if GetLocalPlayer() == p then
        call BlzFrameSetVisible(FRAME_SpellTooltipName, false)
        call BlzFrameSetScale(FRAME_SpellTooltipName, 1)
        call BlzFrameSetVisible(FRAME_HeroModel, true)
    endif    
    endif
    set p = null
endfunction
function CreateUI takes nothing returns nothing
    local integer i = 0
    local integer i2 = 0
    local integer k = 0
    local real x = 0.025
    local real y = -0.05
    local framehandle border
    set FrameClick = CreateTrigger()
    set FrameGuideEnter = CreateTrigger()
    set FrameGuideLeave = CreateTrigger()
    // === Главный контейнер ===
    set FRAME_MAIN = BlzCreateFrame("EscMenuBackdrop",BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
    call BlzFrameSetAbsPoint(FRAME_MAIN, FRAMEPOINT_CENTER, 0.40, 0.32)
    call BlzFrameSetSize(FRAME_MAIN, 0.92, 0.5)    
    set FRAME_MAIN2 = BlzCreateFrame("EscMenuBackdrop", FRAME_MAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_MAIN2, FRAMEPOINT_CENTER, 0.35, 0.35)
    call BlzFrameSetSize(FRAME_MAIN2, 0.25, 0.4)
    set FRAME_MAIN3 = BlzCreateFrame("EscMenuBackdrop", FRAME_MAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_MAIN3, FRAMEPOINT_CENTER, 0.625, 0.35)
    call BlzFrameSetSize(FRAME_MAIN3, 0.3, 0.4)
    set FRAME_HeroName = BlzCreateFrameByType("GLUETEXTBUTTON", "MyHeroNameButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroName, FRAMEPOINT_CENTER, 0.625, 0.51)
    call BlzFrameSetSize(FRAME_HeroName, 0.15, 0.03)
    call BlzFrameSetText(FRAME_HeroName, "Hero Name")
    call BlzTriggerRegisterFrameEvent(FrameClick, FRAME_HeroName, FRAMEEVENT_CONTROL_CLICK)
    set FRAME_SpellTooltipName = BlzCreateFrameByType("TEXT", "MyHeroNameButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_SpellTooltipName, FRAMEPOINT_CENTER, 0.625, 0.39)
    call BlzFrameSetSize(FRAME_SpellTooltipName, 0.19, 0.19)
    call BlzFrameSetText(FRAME_SpellTooltipName, "")
    call BlzFrameSetScale(FRAME_SpellTooltipName, 1)
    call BlzFrameSetVisible(FRAME_SpellTooltipName, false)
    call BlzFrameSetLevel(FRAME_SpellTooltipName, 4)
    set FRAME_HeroModel = BlzCreateFrameByType("BACKDROP", "Port", FRAME_MAIN3, "", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroModel, FRAMEPOINT_CENTER, 0.625, 0.39)
    call BlzFrameSetSize(FRAME_HeroModel, 0.19, 0.19)
    call BlzFrameSetTexture(FRAME_HeroModel, "Textures\\black32.blp", 0, false)
    call BlzFrameSetLevel(FRAME_HeroModel, 2) // поверх контейнера
    set border = BlzCreateFrameByType("BACKDROP", "ThinBorder", FRAME_MAIN3, "", 0)
    call BlzFrameSetAbsPoint(border, FRAMEPOINT_CENTER, 0.625, 0.39)
    call BlzFrameSetTexture(border, "Textures\\black32.blp", 0, true)
    call BlzFrameSetSize(border, 0.2, 0.2) // чуть больше контейнера, чтобы рамка видна
    call BlzFrameSetLevel(border, 0) // поверх контейнера
    set FRAME_HeroAttribute = BlzCreateFrameByType("BACKDROP", "attribute", FRAME_MAIN3, "", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroAttribute, FRAMEPOINT_CENTER, 0.52, 0.5075)
    call BlzFrameSetSize(FRAME_HeroAttribute, 0.0375, 0.0375)
    call BlzFrameSetTexture(FRAME_HeroAttribute, "Textures\\black32.blp", 0, true)
    call BlzFrameSetVisible(FRAME_HeroAttribute, false)
    call BlzFrameSetLevel(FRAME_HeroAttribute, 2) // поверх контейнера
    set FRAME_HeroAttackType = BlzCreateFrameByType("BACKDROP", "atk", FRAME_MAIN3, "", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroAttackType, FRAMEPOINT_CENTER, 0.735, 0.51)
    call BlzFrameSetSize(FRAME_HeroAttackType, 0.0315, 0.0315)
    call BlzFrameSetTexture(FRAME_HeroAttackType, "Textures\\black32.blp", 0, true)
    call BlzFrameSetVisible(FRAME_HeroAttackType, false)
    call BlzFrameSetLevel(FRAME_HeroAttackType, 2) // поверх контейнера   
    set FRAME_HeroStr = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroStr, FRAMEPOINT_CENTER, 0.5755, 0.245)
    call BlzFrameSetSize(FRAME_HeroStr, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroStr, false)
    call BlzFrameSetScale(FRAME_HeroStr, 1.4)
    set FRAME_HeroAgi = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroAgi, FRAMEPOINT_CENTER, 0.5755, 0.225)
    call BlzFrameSetSize(FRAME_HeroAgi, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroAgi, false)
    call BlzFrameSetScale(FRAME_HeroAgi, 1.4)
    set FRAME_HeroInt = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroInt, FRAMEPOINT_CENTER, 0.5755, 0.205)
    call BlzFrameSetSize(FRAME_HeroInt, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroInt, false)
    call BlzFrameSetScale(FRAME_HeroInt, 1.4)
    set FRAME_HeroAtk = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroAtk, FRAMEPOINT_CENTER, 0.645, 0.256)
    call BlzFrameSetSize(FRAME_HeroAtk, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroAtk, false)
    call BlzFrameSetScale(FRAME_HeroAtk, 1.1)
    set FRAME_HeroArmor = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroArmor, FRAMEPOINT_CENTER, 0.645, 0.241)
    call BlzFrameSetSize(FRAME_HeroArmor, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroArmor, false)
    call BlzFrameSetScale(FRAME_HeroArmor, 1.1)
    set FRAME_HeroMS = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroMS, FRAMEPOINT_CENTER, 0.645, 0.226)
    call BlzFrameSetSize(FRAME_HeroMS, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroMS, false)
    call BlzFrameSetScale(FRAME_HeroMS, 1.1)
    set FRAME_HeroAS = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)
    call BlzFrameSetAbsPoint(FRAME_HeroAS, FRAMEPOINT_CENTER, 0.645, 0.211)
    call BlzFrameSetSize(FRAME_HeroAS, 0.1, 0.05)
    call BlzFrameSetVisible(FRAME_HeroAS, false)
    call BlzFrameSetScale(FRAME_HeroAS, 1.1)
    set i = 0
    loop
        exitwhen i == bj_MAX_PLAYER_SLOTS
        set PlayerFrameCurrentPage_ID[i] = 0 // устанавливаем всех игроков на первый раздел геров (геншин)
        set i = i + 1
    endloop
    set i = 0
    set k = 0
    loop
        exitwhen k == 4
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
            call BlzFrameSetTexture(FRAME_ICON_Pick[k], "Pick\\PickButton_Pick_Manual", 0, true)
        elseif k == 3 then
            call BlzFrameSetTexture(FRAME_ICON_Pick[k], "Pick\\PickButton_Pick_Random", 0, true)
        endif
        if k == 1 or k == 0 then
            call BlzFrameSetEnable(FRAME_Pick[k], false)
            call BlzFrameSetEnable(FRAME_ICON_Pick[k], false)
        endif
        call BlzTriggerRegisterFrameEvent(FrameClick, FRAME_Pick[k], FRAMEEVENT_CONTROL_CLICK)
        set k = k + 1
    endloop
    set k = 0
    set i = 0
    loop
        exitwhen i == 24
        // Кликабельный фрейм (кнопка)
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
        // Клик
        set k = k + 1
        set i = i + 1
        if i == 4 or i == 8 or i == 12 or i == 16 or i == 20 or i == 24 then
            set k = 0
            set y = y - 0.05
        endif
    endloop   
    set i2 = 0
    set y = -0.06
    set x = 0.03
    set i = 0
    loop
        exitwhen i == 5
        // Кликабельный фрейм (кнопка)
        set Frame_PageHeroList[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_MAIN2, "ScoreScreenTabButtonTemplate", 0)
        set Frame_PageHeroListImage[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", Frame_PageHeroList[i], "", 0)
        call BlzFrameSetTexture(Frame_PageHeroList[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
        call BlzFrameSetAllPoints(Frame_PageHeroListImage[i], Frame_PageHeroList[i])
        call BlzFrameSetPoint(Frame_PageHeroList[i], FRAMEPOINT_LEFT, FRAME_MAIN, FRAMEPOINT_TOPLEFT, x, y )
        call BlzFrameSetSize(Frame_PageHeroList[i], 0.185, 0.05)
        if i == 0 then
            call BlzFrameSetTexture(Frame_PageHeroListImage[i], "Pick\\Pick_Genshin.blp", 0, true)
        elseif i == 1 then
            call BlzFrameSetTexture(Frame_PageHeroListImage[i], "Pick\\Pick_Bleach.blp", 0, true)
        elseif i == 2 then
            call BlzFrameSetTexture(Frame_PageHeroListImage[i], "Pick\\Pick_FairyTail.blp", 0, true)
        elseif i == 3 then
            call BlzFrameSetTexture(Frame_PageHeroListImage[i], "Pick\\Pick_OnePiece.blp", 0, true)
        elseif i == 4 then
            call BlzFrameSetTexture(Frame_PageHeroListImage[i], "Pick\\Pick_Other.blp", 0, true)
        else
            call BlzFrameSetTexture(Frame_PageHeroListImage[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, true)
        endif
       // call BlzFrameSetLevel(Frame_PageHeroListImage[i],10)
    // Клик
        call BlzTriggerRegisterFrameEvent(FrameClick, Frame_PageHeroList[i], FRAMEEVENT_CONTROL_CLICK)
        set i = i + 1
        set y = y - 0.065
    endloop
    set y = 0.05
    set x = 0.03
    set i = 0
    loop
        exitwhen i == 7
        // Кликабельный фрейм (кнопка)
        set FRAME_ICON5[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_MAIN3, "ScoreScreenTabButtonTemplate", 0)
        set FRAME_ICON6[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ICON5[i], "", 0)
        call BlzFrameSetTexture(FRAME_ICON5[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
        call BlzFrameSetAllPoints(FRAME_ICON6[i], FRAME_ICON5[i])
        call BlzFrameSetLevel(FRAME_ICON5[i], 5)
        call BlzFrameSetPoint(FRAME_ICON5[i], FRAMEPOINT_LEFT, FRAME_MAIN3, FRAMEPOINT_BOTTOMLEFT, x, y )// - 0.03 * i)
    //call BlzFrameSetAbsPoint(FRAME_ICON[i], FRAMEPOINT_CENTER, -0.11, 0.21)
        call BlzFrameSetSize(FRAME_ICON5[i], 0.035, 0.035)
        call BlzFrameSetTexture(FRAME_ICON6[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
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
        // Клик
        call BlzTriggerRegisterFrameEvent(FrameClick, FRAME_ICON5[i], FRAMEEVENT_CONTROL_CLICK)
        call BlzTriggerRegisterFrameEvent(FrameGuideEnter, FRAME_ICON5[i], FRAMEEVENT_MOUSE_ENTER)
        call BlzTriggerRegisterFrameEvent(FrameGuideLeave, FRAME_ICON5[i], FRAMEEVENT_MOUSE_LEAVE)
        set i = i + 1
        if i == 5 then
            set y = 0.1
            set x = 0.13
        endif
        set x = x + 0.05
    endloop
    set y = 0.06
    set x = 0.03
    set i = 0
    loop
        exitwhen i == 10
        // Кликабельный фрейм (кнопка)        
        set FRAME_PlayerPick[i] = BlzCreateFrameByType("BUTTON", "MyPickTeamButton", FRAME_MAIN, "", 0)
        call BlzFrameSetSize(FRAME_PlayerPick[i], 0.035, 0.035)
        call BlzFrameSetTexture(FRAME_PlayerPick[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
        set FRAME_PlayerPickBack[i] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", FRAME_PlayerPick[i], "", 0)
        call BlzFrameSetSize(FRAME_PlayerPickBack[i], 0.035, 0.035)
        call BlzFrameSetAllPoints(FRAME_PlayerPickBack[i], FRAME_PlayerPick[i])
        call BlzFrameSetLevel(FRAME_PlayerPick[i], 3)
        call BlzFrameSetLevel(FRAME_PlayerPickBack[i], 1)
        if i >= 5 then
            call BlzFrameSetPoint(FRAME_PlayerPick[i], FRAMEPOINT_LEFT, FRAME_MAIN, FRAMEPOINT_BOTTOMLEFT, x + 0.245, y )// - 0.03 * i)
        else
            call BlzFrameSetPoint(FRAME_PlayerPick[i], FRAMEPOINT_LEFT, FRAME_MAIN, FRAMEPOINT_BOTTOMLEFT, x, y )// - 0.03 * i)
        endif
        call BlzFrameSetTexture(FRAME_PlayerPickBack[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        set FRAME_PlayerPickText[i] = BlzCreateFrameByType("TEXT", "MyIconTextAbi", FRAME_PlayerPick[i], "", 0)
        if SplitNameCheck(GetPlayerName(Player(i))) then
            call BlzFrameSetPoint(FRAME_PlayerPickText[i], FRAMEPOINT_BOTTOM, FRAME_PlayerPick[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( 0.059 + 0.05 * I2R(i) ), (y - 0.0575) - 0.025 )// - 0.03 * i)
        else
            call BlzFrameSetPoint(FRAME_PlayerPickText[i], FRAMEPOINT_BOTTOM, FRAME_PlayerPick[i], FRAMEPOINT_BOTTOMLEFT, (x + 0.017 + 0.03) - ( 0.059 + 0.05 * I2R(i) ), (y - 0.0575) - 0.0165 )// - 0.03 * i)
        endif
        call BlzFrameSetTextAlignment(FRAME_PlayerPickText[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetSize(FRAME_PlayerPickText[i], 0.0, 0.0)       
        call BlzFrameSetText(FRAME_PlayerPickText[i], SplitName(GetPlayerName(Player(i))))        
        set i = i + 1
        set x = x + 0.05
    endloop
    set FRAME_TimerToStart = BlzCreateFrameByType("TEXT", "TextT", FRAME_MAIN2, "", 0)
        call BlzFrameSetPoint(FRAME_TimerToStart, FRAMEPOINT_BOTTOM, FRAME_MAIN2, FRAMEPOINT_BOTTOMLEFT, -0.085, 0.26 )// - 0.03 * i)
        call BlzFrameSetText(FRAME_TimerToStart, "|c00FFFF00Time Left: "+I2S(FRAME_RoundCountSecBasePrepare)+"|r")   
        call BlzFrameSetSize(FRAME_TimerToStart,0.1,0.005)
        call BlzFrameSetScale(FRAME_TimerToStart,1.5) 
    call TriggerAddAction(FrameClick, function OnClick)
    call TriggerAddAction(FrameGuideEnter, function GuideEnter)
    call TriggerAddAction(FrameGuideLeave, function GuideLeave)
endfunction
function InitTrig_UI takes nothing returns nothing
    call CreateUI()
endfunction
function PrepareStart takes nothing returns nothing
local timer t = GetExpiredTimer()
local integer i = 0
local integer i2 = 0
local integer k1 = 0
local integer k2 =0
local integer k =0
local real x1
local real y1
local real x2 
local real y2
local integer reward = 0
set TimeMove = TimeMove + 1
if CondArena == 0 then 
if TimeMove == FRAME_RoundCountSecBasePrepare and RandomAllPlayers == 0 then 
set RandomAllPlayers = 1
set i = 0
loop
exitwhen i == 10
call RandomPick(Player(i))
set i =i + 1
endloop

endif
set i = 0
loop
exitwhen i == 10
if GetUnitAbilityLevel(Hero[i],'Avul') == 0 then
call UnitAddAbility(Hero[i],'Avul')
endif
call SetFly(Hero[i],0)
if IsUnitType(Hero[i],UNIT_TYPE_DEAD) then
call ReviveHero(Hero[i],GetUnitX(Hero[i]),GetUnitY(Hero[i]),true)
endif
if CheckCoordsInRect(gg_rct_Base,GetUnitX(Hero[i]),GetUnitY(Hero[i])) == false then
call SetUnitPosition(Hero[i],GetRectCenterX(gg_rct_Pick),GetRectCenterY(gg_rct_Pick))
endif
set i =i + 1
endloop
if TimeMove == TimeRound then 
set CondArena = 1
set k1 = GetRandomInt(1,4)
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
set k1 = GetRandomInt(1,4)
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
set TimeMove = 0
if TestMode == false then
call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[6],false)
call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[7],false)
call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6],false)
call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7],false)
endif
set i = 0
loop
exitwhen i == 10
if Hero[i] != null then 
if i<5 then 
call SetUnitPosition(Hero[i],x1,y1)
else
call SetUnitPosition(Hero[i],x2,y2)
endif
call DestroyFogModifier(PlayerVision[i])
set PlayerVision[i] = CreateFogModifierRadius(Player(i), FOG_OF_WAR_VISIBLE, GetUnitX(Hero[i]), GetUnitY(Hero[i]), 1800, true, false)
call FogModifierStart(PlayerVision[i])
if GetLocalPlayer() == Player(i) then 
call ClearSelection()
call SelectUnit(Hero[i],true)
call PanCameraToTimed(GetUnitX(Hero[i]),GetUnitY(Hero[i]),0.25)
endif
endif
set i =i + 1
endloop
endif
else
if TestMode == false and r_ping >8 then 
set r_ping = 0
set i = 0
loop
exitwhen i == 10
if Hero[i] != null and IsUnitType(Hero[i],UNIT_TYPE_DEAD)== false then 
call PingMinimapEx(GetUnitX(Hero[i]),GetUnitY(Hero[i]),5,PC_R[i],PC_G[i],PC_B[i],false)
endif
set i = i + 1
endloop
else
set r_ping = r_ping + 1
endif
if TestMode == false and r_train >28 then 
set r_train = 0
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
if Hero[i] != null and (CheckCoordsInRect(gg_rct_Arena,GetUnitX(Hero[i]),GetUnitY(Hero[i])) or CheckCoordsInRect(gg_rct_Cage,GetUnitX(Hero[i]),GetUnitY(Hero[i]))) and IsUnitType(Hero[i],UNIT_TYPE_DEAD)== false then 
call DestroyFogModifier(PlayerVision[i])
set PlayerVision[i] = null
set PlayerVision[i] = CreateFogModifierRadius(Player(i), FOG_OF_WAR_VISIBLE, GetUnitX(Hero[i]), GetUnitY(Hero[i]), 1800, true, false)
call FogModifierStart(PlayerVision[i])
if i<5 then 
set k1 = k1 + 1
else
set k2 = k2 + 1
endif
elseif Hero[i] != null and IsUnitType(Hero[i],UNIT_TYPE_DEAD)== true then
if PlayerVision[i] != null then 
call DestroyFogModifier(PlayerVision[i])
set PlayerVision[i] = null
endif
endif
set i = i + 1
endloop
if TestMode == true then
if k1 == 0  then 
set k = 1
endif
else
if k2 == 0 and k1> 0 then 
set k = 1
set Team1Round = Team1Round + 1
call PlayersMsg(GetPlayerColorString(Player(0))+"Team 1|r win round",2)
endif
if k1 == 0 and k2> 0 then 
set k = 1
set Team2Round = Team2Round + 1
call PlayersMsg(GetPlayerColorString(Player(1))+"Team 2|r win round",2)
endif
if k1 == 0 and k2 == 0 then 
set k = 1
call PlayersMsg(GetPlayerColorString(Player(10))+"Draw",2)
endif
endif
if TestMode then 
set TimeMove = TimeMove-1
endif
if TimeMove == 180 then 
call SukunaEnd()
endif
if TimeMove == 300 or k == 1 then 
set CondArena = 0
set TimeMove = 0
if Team1Round >= MaxRounds or Team2Round >= MaxRounds then
set i = 0
set i2 = 0
loop
exitwhen i == 10
     set FRAME_StatusHeroStringPlayerShowBoolean[i] = true
        loop
            exitwhen i2 == 10
            if Hero[i2] != null then
                if GetLocalPlayer() == Player(i) then
        call BlzFrameSetText(FRAME_StatusHeroStringPlayerTakenDamageMag, "|c00FFFF00Dmg taken:|r |c004675FF"+R2SW(PlayerDamageTakenMagAll[i],0,2)+"Mag|r/|cffff0000"+R2SW(PlayerDamageTakenPhysAll[i],0,2)+"Phys|r")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerKill[i2], "|c00FFFF00Kills: |r" + I2S(PlayerKill[i2]) + "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDeath[i2], "|c00A74FFFDeaths: |r" + I2S(PlayerDeath[i2]) + "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamagePhys[i2], "|cffff0000Phys: |r" + I2S(PlayerDamagePhysAll[i2]) + "")
                    call BlzFrameSetText(FRAME_StatusHeroStringPlayerDamageMag[i2], "|c004675FFMag: |r" + I2S(PlayerDamageMagAll[i2]) + "")
                endif
            endif
            set i2 = i2 + 1
        endloop
        set i = i + 1
        endloop
endif
if Team1Round >= MaxRounds then 
set i = 0
set i2 = 0
loop
exitwhen i == 10
if i<5 then 
if GetLocalPlayer() == Player(i) then 
call SetMusicVolume(0)
call StartSound(gg_snd_Win)
endif
call CustomVictoryBJ(Player(i),true,true)
else
if GetLocalPlayer() == Player(i) then 
call SetMusicVolume(0)
call StartSound(gg_snd_Loose)
endif
call CustomDefeatBJ(Player(i),"GG")
endif
set i = i + 1
endloop
call PauseGame(true)
elseif Team2Round >= MaxRounds then
set i = 0
set i2 = 0
loop
exitwhen i == 10
if i>4 then 
if GetLocalPlayer() == Player(i) then 
call SetMusicVolume(0)
call StartSound(gg_snd_Win)
endif
call CustomVictoryBJ(Player(i),true,true)
else
if GetLocalPlayer() == Player(i) then 
call SetMusicVolume(0)
call StartSound(gg_snd_Loose)
endif
call CustomDefeatBJ(Player(i),"GG")
endif
set i = i + 1
endloop
call PauseGame(true)
endif 
call DecorRestore()
set CurrentRound = CurrentRound + 1
call BlzFrameSetText(FRAME_Team1Rounds, "|cffff0000" + I2S(Team1Round)+"/"+I2S(MaxRounds)+ "|r")
    call BlzFrameSetText(FRAME_Team2Rounds, "|c002F63FF" + I2S(Team2Round)+"/"+I2S(MaxRounds)+ "|r")
call BlzFrameSetText(FRAME_RoundCount, "Round: |c00FFFF00" + I2S(CurrentRound) + "|r")
set FRAME_RoundCountSec = 0
set FRAME_RoundCountMin = 0
call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[6],true)
call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[7],true)
call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6],true)
call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7],true)
set i = 0
set reward = 750 + CurrentRound*300
if reward > 6000 then 
set reward = 6000
endif
loop
exitwhen i == 10
if Hero[i] != null then 
call SetUnitPosition(Hero[i],GetRectCenterX(gg_rct_Pick),GetRectCenterY(gg_rct_Pick))
if GetUnitTypeId(Hero[i]) == Erza_ID then 
call ErzaF_Start(Hero[i])
endif
call AddGold(Player(i),reward,true)
call SetHeroLevel(Hero[i],GetHeroLevel(Hero[i])+5,true)
call LearnHeroSpells(Hero[i])
call SetFly(Hero[i],0)
if IsUnitType(Hero[i],UNIT_TYPE_DEAD) then
call ReviveHero(Hero[i],GetUnitX(Hero[i]),GetUnitY(Hero[i]),true)
endif
if GetLocalPlayer() == Player(i) then 
call ClearSelection()
call SelectUnit(Hero[i],true)
call PanCameraToTimed(GetRectCenterX(gg_rct_Pick),GetRectCenterY(gg_rct_Pick),0.25)
endif
endif
set i =i + 1
endloop
endif
endif
set t = null
endfunction
function initmapstart takes nothing returns nothing
 local integer i = 0 // 0 - красный игрок
    local integer i2 = 0
    loop
        exitwhen i == bj_MAX_PLAYER_SLOTS
        if GetPlayerSlotState( Player( i ) ) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController( Player( i ) ) == MAP_CONTROL_USER then
            set PlayerCountValue = PlayerCountValue + 1
        call AddGold(Player(i),1000,true)
        endif
        if GetLocalPlayer() == Player(i) then
        call SetCameraField( CAMERA_FIELD_TARGET_DISTANCE, BaseCam, 0 )
        endif
        set i = i + 1
    endloop
    call MyHeroIdInit()
    call InitTrig_UI()
    call CreateStatusHeroUI()
    set IntroStart1 = CreateTimer()
    call TimerStart(IntroStart1,1,true,function PrepareStart)
    //set Hero[6] =  CreateUnit(Player(6),'Hpal',GetRectCenterX(gg_rct_Arena),GetRectCenterY(gg_rct_Arena),1)
endfunction
function RemoveHashTag takes string s returns string
    local integer i = 0
    local integer len = StringLength(s)
    loop
        exitwhen i >= len
        if SubString(s, i, i+1) == "#" then
            // возвращаем строку ДО #
            return SubString(s, 0, i)
        endif
        set i = i + 1
    endloop
    return s
endfunction
function Map_Start takes nothing returns nothing
local integer i = 0
loop
exitwhen i == bj_MAX_PLAYER_SLOTS
call FogModifierStart(CreateFogModifierRect(Player(i),FOG_OF_WAR_VISIBLE,gg_rct_Base,true,false))
call FogModifierStart(CreateFogModifierRect(Player(i),FOG_OF_WAR_VISIBLE,gg_rct_Cage,true,false))
call FogModifierStart(CreateFogModifierRect(Player(i),FOG_OF_WAR_VISIBLE,gg_rct_Metro,true,false))
call SetPlayerName(Player(i),RemoveHashTag(GetPlayerName(Player(i))))
call HideBottomUI(Player(i),true)
set PlayerShopButton[i] = OSKEY_TAB
if TestMode == true and i < 10then
call AddGold(Player(i),99000,true)
endif
set i = i + 1
endloop
// 0 Red
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
    call TimerStart(CreateTimer(),1,false,function initmapstart)
endfunction



//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
