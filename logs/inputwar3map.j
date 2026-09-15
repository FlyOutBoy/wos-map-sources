// Milim.vj - complete external-source map script
// World Editor initialization copied from Milim.w3x/war3map.j.
// Source archive SHA-256: c47ec2b04adff8144405f2f692e758589d6e5004b3deb8b8571e84cf8f0fb2dd
// Trigger implementations live only in ../triggers/*.j and are imported below.

globals
rect gg_rct_Caster= null
rect gg_rct_Base= null
rect gg_rct_Arena= null
rect gg_rct_LL= null
rect gg_rct_Cage= null
sound gg_snd_Hero_Raiden_W_1= null
sound gg_snd_Hero_Raiden_T_Atk1= null
sound gg_snd_Hero_Raiden_T_Atk2= null
sound gg_snd_Hero_Raiden_T_Atk3= null
sound gg_snd_Hero_Natsu_G= null
sound gg_snd_Hero_Natsu_GQ0= null
sound gg_snd_Hero_Erza6_G1= null
sound gg_snd_Hero_Erza7_G2= null
sound gg_snd_Hero_Inori_W_2= null
sound gg_snd_Hero_Inori_R= null
sound gg_snd_Hero_Laxus_T= null
sound gg_snd_TornadoLoop= null
sound gg_snd_Hero_Ainz_F= null
trigger gg_trg_WoS_Pick_Init= null
trigger gg_trg_Starts= null
trigger gg_trg_WoS_Shop_Init= null
trigger gg_trg_TestUnit= null
trigger gg_trg_WoS_Hero_Icons_Init= null
trigger gg_trg_WoS_Hero_Icons_Init_Copy= null
trigger gg_trg_Leave= null
trigger gg_trg_TasBox= null
trigger gg_trg_Starts_Copy= null
trigger gg_trg_ItemEnter= null
trigger gg_trg_CastAItems= null
trigger gg_trg_ArrowUp= null
trigger gg_trg_hpset= null
trigger gg_trg_Items= null
trigger gg_trg_CastCheck= null
trigger gg_trg_ErzaDebuff_Copy= null
trigger gg_trg_Systems1= null
trigger gg_trg_Systems2= null
trigger gg_trg_Systems_Copy= null
trigger gg_trg_DmgSys= null
trigger gg_trg_MouseMove= null
trigger gg_trg_UnitEnter= null
trigger gg_trg_Death= null
trigger gg_trg_ArrowLeft= null
trigger gg_trg_ArrowRight= null
trigger gg_trg_Milim= null
trigger gg_trg_Milim_Copy_2= null
trigger gg_trg_Milim_Copy= null
trigger gg_trg_Toji= null
trigger gg_trg_Toji_Copy= null
trigger gg_trg_Frieren= null
trigger gg_trg_Frieren_Copy_5= null
trigger gg_trg_Frieren_Copy_4= null
trigger gg_trg_Die= null
trigger gg_trg_Frieren_Copy_3= null
trigger gg_trg_Frieren_Copy_2= null
trigger gg_trg_Frieren_Copy= null
trigger gg_trg_Ainz= null
trigger gg_trg_Ainz_Copy_3= null
trigger gg_trg_Ainz_Copy_2= null
trigger gg_trg_Ainz_Copy= null
trigger gg_trg_Laxus= null
trigger gg_trg_Brandish= null
trigger gg_trg_Patriot= null
trigger gg_trg_Asta= null
trigger gg_trg_Gojo= null
trigger gg_trg_Bambietta= null
trigger gg_trg_Kirito= null
trigger gg_trg_Alucard= null
trigger gg_trg_Starrk= null
trigger gg_trg_Takeshi= null
trigger gg_trg_Barragan= null
trigger gg_trg_Mahoraga= null
trigger gg_trg_Harribel= null
trigger gg_trg_Tsuna= null
trigger gg_trg_Rimuru= null
trigger gg_trg_DarkShiki= null
trigger gg_trg_BazzB= null
trigger gg_trg_Neuvillette= null
trigger gg_trg_Okarun= null
trigger gg_trg_Akainu= null
trigger gg_trg_Inori= null
trigger gg_trg_Kenjaku= null
trigger gg_trg_AlterSaber= null
trigger gg_trg_Raiden= null
trigger gg_trg_Natsu= null
trigger gg_trg_Kyoraku= null
trigger gg_trg_Tomioka= null
trigger gg_trg_ErzaQ= null
trigger gg_trg_ErzaW= null
trigger gg_trg_ErzaE= null
trigger gg_trg_ErzaR= null
trigger gg_trg_ErzaT= null
trigger gg_trg_ErzaG2_Nakagami= null
trigger gg_trg_ErzaG2_Fairy= null
trigger gg_trg_ErzaBase= null
trigger gg_trg_LvlUpCheck= null
trigger gg_trg_ESC= null
trigger gg_trg_ARUP= null
trigger gg_trg_Start= null
trigger gg_trg_KOTH_Loop= null
trigger gg_trg_StoneThrowStun= null
trigger gg_trg_AnimCheck= null
trigger gg_trg_MaxHPSET= null
trigger gg_trg_LvlSelf= null
unit gg_unit_hpea_0011= null
boolean udg_RK_KOTH_ENABLED= false
real udg_DamageTypePure=1
real udg_NextDamageType=1

    // Handles required by the external trigger tree but absent from this older test-map WTG.
rect gg_rct_Chest= null
rect gg_rct_Evergreen= null
rect gg_rct_Go= null
rect gg_rct_Go2= null
rect gg_rct_Metro= null
rect gg_rct_Pick= null
rect gg_rct_Shop= null
rect gg_rct_Spawn1= null
rect gg_rct_Spawn2= null
rect gg_rct_Spawn3= null
rect gg_rct_Spawn4= null
rect gg_rct_SpeedBottom1= null
rect gg_rct_SpeedBottom2= null
rect gg_rct_SpeedLeft1= null
rect gg_rct_SpeedLeft2= null
rect gg_rct_SpeedRight1= null
rect gg_rct_SpeedRight2= null
rect gg_rct_SpeedTop1= null
rect gg_rct_SpeedTop2= null
rect gg_rct_Test= null
rect gg_rct_TestMode= null
rect gg_rct_TestMode2= null
rect gg_rct_TrainLeftBottom= null
rect gg_rct_TrainLeftUp= null
rect gg_rct_TrainRightBottom= null
rect gg_rct_TrainRightUp= null
sound gg_snd_AlchemistTransmuteDeath1= null
sound gg_snd_BattleNetTick= null
sound gg_snd_Error= null
sound gg_snd_Hero_Kyoraku_T14__2= null
sound gg_snd_Hero_Kyoraku_T6= null
sound gg_snd_Loose= null
sound gg_snd_ReceiveGold= null
sound gg_snd_Round_Sukuna= null
sound gg_snd_SadTrombone= null
sound gg_snd_Swap= null
sound gg_snd_UpkeepRing= null
sound gg_snd_Win= null
sound gg_snd_wos_shopenter= null
trigger gg_trg_ArrowDown= null
trigger gg_trg_AtkCancel= null
trigger gg_trg_BuildsForChars= null
trigger gg_trg_ButtonPressed= null
trigger gg_trg_ButtonPressed_ESC= null
trigger gg_trg_ButtonUnPressed_ESC= null
trigger gg_trg_CastingCheck= null
trigger gg_trg_ClickEvent= null
trigger gg_trg_EnterBase= null
trigger gg_trg_EnterRegion= null
trigger gg_trg_ItemLeave= null
trigger gg_trg_Killme= null
trigger gg_trg_LeavesBase= null
trigger gg_trg_LeavesRegion= null
endglobals

//! import "../triggers/Map_Header.j"
//! import "../triggers/Systems/TasBox.j"
//! import "../triggers/Systems/Systems2.j"
//! import "../triggers/Systems/Systems1.j"
//! import "../triggers/WOS_Start/ShowCD.j"
//! import "../triggers/WOS_Start/TooltipBuilder.j"
//! import "../triggers/WOS_Start/UniversalTooltips.j"
//! import "../triggers/WOS_Start/Save2.j"
//! import "../triggers/WOS_Start/SaveLoad.j"
//! import "../triggers/WOS_Start/MusicPlayer.j"
//! import "../triggers/WOS_Start/WoS_Hero_Icons_Init.j"
//! import "../triggers/WOS_Start/UI_CAREER.j"
//! import "../triggers/WOS_Start/DefaultArmorChangeStable_Copy.j"
//! import "../triggers/WOS_Start/Scoreboard.j"
//! import "../triggers/WOS_Start/ChatCommand.j"
//! import "../triggers/WOS_Start/Player_Pick_Mode.j"
//! import "../triggers/WOS_Start/WoS_Shop_Init.j"
//! import "../triggers/WOS_Start/WoS_Pick_Init.j"
//! import "../triggers/WOS_Start/Starts.j"
//! import "../triggers/WOS_Start/BuildsForChars.j"
//! import "../triggers/WOS_Start/TestUnit.j"
//! import "../triggers/WOS_Start/Leave.j"
//! import "../triggers/Round_End/RoundEnd.j"
//! import "../triggers/Systems/CastAItems.j"
//! import "../triggers/Systems/CastCheck.j"
//! import "../triggers/Systems/ClickEvent.j"
//! import "../triggers/Systems/DecorDestroy_and_Erza_Debuff.j"
//! import "../triggers/Systems/DmgSys.j"
//! import "../triggers/Systems/AtkCancel.j"
//! import "../triggers/Systems/MouseMove.j"
//! import "../triggers/Systems/Death.j"
//! import "../triggers/Systems/silence.j"
//! import "../triggers/Systems/LvlUpCheck.j"
//! import "../triggers/Systems/LvlSelf.j"
//! import "../triggers/Systems/MagRes.j"
//! import "../triggers/Systems/PhysRes.j"
//! import "../triggers/Systems/slow.j"
//! import "../triggers/Systems/NeviSound.j"
//! import "../triggers/Systems/Evol1.j"
//! import "../triggers/Systems/Evol2.j"
//! import "../triggers/Systems/sukuna_spawn.j"
//! import "../triggers/Systems/ESC.j"
//! import "../triggers/Systems/Killme.j"
//! import "../triggers/Systems/AnimCheck.j"
//! import "../triggers/Systems/hpset.j"
//! import "../triggers/Systems/mpset.j"
//! import "../triggers/Systems/ArrowLeft.j"
//! import "../triggers/Systems/ArrowUp.j"
//! import "../triggers/Systems/ArrowDown.j"
//! import "../triggers/Systems/ArrowRight.j"
//! import "../triggers/Systems/CastingCheck.j"
//! import "../triggers/Systems/ButtonPressed.j"
//! import "../triggers/Systems/ButtonPressed_ESC.j"
//! import "../triggers/Systems/ButtonUnPressed_ESC.j"
//! import "../triggers/Systems/EnterBase.j"
//! import "../triggers/Systems/EnterRegion.j"
//! import "../triggers/Systems/LeavesBase.j"
//! import "../triggers/Systems/LeavesRegion.j"
//! import "../triggers/Systems/ItemCupOfTea.j"
//! import "../triggers/Systems/ItemEnter.j"
//! import "../triggers/Systems/ItemLeave.j"
//! import "../triggers/Items/Items.j"
//! import "../triggers/Heroes/Toji.j"
//! import "../triggers/Heroes/Raiden.j"
//! import "../triggers/Heroes/Frieren.j"
//! import "../triggers/Heroes/Ainz.j"
//! import "../triggers/Heroes/Natsu.j"
//! import "../triggers/Heroes/Laxus.j"
//! import "../triggers/Heroes/Brandish.j"
//! import "../triggers/Heroes/Patriot.j"
//! import "../triggers/Heroes/Asta.j"
//! import "../triggers/Heroes/Gojo.j"
//! import "../triggers/Heroes/Bambietta.j"
//! import "../triggers/Heroes/Kirito.j"
//! import "../triggers/Heroes/Alucard.j"
//! import "../triggers/Heroes/Starrk.j"
//! import "../triggers/Heroes/Takeshi.j"
//! import "../triggers/Heroes/Barragan.j"
//! import "../triggers/Heroes/Mahoraga.j"
//! import "../triggers/Heroes/Harribel.j"
//! import "../triggers/Heroes/Tsuna.j"
//! import "../triggers/Heroes/Rimuru.j"
//! import "../triggers/Heroes/DarkShiki.j"
//! import "../triggers/Heroes/BazzB.j"
//! import "../triggers/Heroes/Neuvillette.j"
//! import "../triggers/Heroes/Okarun.j"
//! import "../triggers/Heroes/Akainu.j"
//! import "../triggers/Heroes/Inori.j"
//! import "../triggers/Heroes/Kenjaku.j"
//! import "../triggers/Heroes/AlterSaber.j"
//! import "../triggers/Heroes/Kyoraku.j"
//! import "../triggers/Heroes/Tomioka.j"
//! import "../triggers/Erza/ErzaT.j"
//! import "../triggers/Erza/ErzaQ.j"
//! import "../triggers/Erza/ErzaW.j"
//! import "../triggers/Erza/ErzaE.j"
//! import "../triggers/Erza/ErzaR.j"
//! import "../triggers/Erza/ErzaG2_Nakagami.j"
//! import "../triggers/Erza/ErzaG2_Fairy.j"
//! import "../triggers/Erza/ErzaBase.j"
//! import "../triggers/Heroes/Milim.j"

//===========================================================================
// 
// Milim
// 
//   Warcraft III map script
//   Generated by the Warcraft III World Editor
//   Map Author: Неизвестно
// 
//===========================================================================

//***************************************************************************
//*
//*  Global Variables
//*
//***************************************************************************


function InitGlobals takes nothing returns nothing
endfunction

//***************************************************************************
//*
//*  Custom Script Code
//*
//***************************************************************************

//***************************************************************************
//*
//*  Sound Assets
//*
//***************************************************************************

function InitSounds takes nothing returns nothing
    set gg_snd_Hero_Raiden_W_1=CreateSound("war3mapImported/Hero_Raiden_W_1.mp3", false, false, false, 0, 0, "DefaultEAXON")
    call SetSoundDuration(gg_snd_Hero_Raiden_W_1, 1728)
    call SetSoundChannel(gg_snd_Hero_Raiden_W_1, 0)
    call SetSoundVolume(gg_snd_Hero_Raiden_W_1, 127)
    call SetSoundPitch(gg_snd_Hero_Raiden_W_1, 1.0)
    set gg_snd_Hero_Raiden_T_Atk1=CreateSound("war3mapImported/Hero_Raiden_T_Atk1.mp3", false, false, true, 1, 1, "SpellsEAX")
    call SetSoundDuration(gg_snd_Hero_Raiden_T_Atk1, 1200)
    call SetSoundChannel(gg_snd_Hero_Raiden_T_Atk1, 0)
    call SetSoundVolume(gg_snd_Hero_Raiden_T_Atk1, 127)
    call SetSoundPitch(gg_snd_Hero_Raiden_T_Atk1, 1.0)
    set gg_snd_Hero_Raiden_T_Atk2=CreateSound("war3mapImported/Hero_Raiden_T_Atk2.mp3", false, false, true, 1, 1, "SpellsEAX")
    call SetSoundDuration(gg_snd_Hero_Raiden_T_Atk2, 1680)
    call SetSoundChannel(gg_snd_Hero_Raiden_T_Atk2, 0)
    call SetSoundVolume(gg_snd_Hero_Raiden_T_Atk2, 127)
    call SetSoundPitch(gg_snd_Hero_Raiden_T_Atk2, 1.0)
    set gg_snd_Hero_Raiden_T_Atk3=CreateSound("war3mapImported/Hero_Raiden_T_Atk3.mp3", false, false, true, 1, 1, "SpellsEAX")
    call SetSoundDuration(gg_snd_Hero_Raiden_T_Atk3, 1008)
    call SetSoundChannel(gg_snd_Hero_Raiden_T_Atk3, 0)
    call SetSoundVolume(gg_snd_Hero_Raiden_T_Atk3, 127)
    call SetSoundPitch(gg_snd_Hero_Raiden_T_Atk3, 1.0)
    set gg_snd_Hero_Natsu_G=CreateSound("war3mapImported/Hero_Natsu_G.mp3", false, false, false, 0, 0, "DefaultEAXON")
    call SetSoundDuration(gg_snd_Hero_Natsu_G, 3672)
    call SetSoundChannel(gg_snd_Hero_Natsu_G, 0)
    call SetSoundVolume(gg_snd_Hero_Natsu_G, 127)
    call SetSoundPitch(gg_snd_Hero_Natsu_G, 1.0)
    set gg_snd_Hero_Natsu_GQ0=CreateSound("war3mapImported/Hero_Natsu_GQ0.mp3", false, false, false, 0, 0, "DefaultEAXON")
    call SetSoundDuration(gg_snd_Hero_Natsu_GQ0, 2832)
    call SetSoundChannel(gg_snd_Hero_Natsu_GQ0, 0)
    call SetSoundVolume(gg_snd_Hero_Natsu_GQ0, 127)
    call SetSoundPitch(gg_snd_Hero_Natsu_GQ0, 1.0)
    set gg_snd_Hero_Erza6_G1=CreateSound("war3mapImported/Hero_Erza6_G1.mp3", false, false, false, 0, 0, "DefaultEAXON")
    call SetSoundDuration(gg_snd_Hero_Erza6_G1, 1896)
    call SetSoundChannel(gg_snd_Hero_Erza6_G1, 0)
    call SetSoundVolume(gg_snd_Hero_Erza6_G1, 127)
    call SetSoundPitch(gg_snd_Hero_Erza6_G1, 1.0)
    set gg_snd_Hero_Erza7_G2=CreateSound("war3mapImported/Hero_Erza7_G2.mp3", false, false, false, 0, 0, "DefaultEAXON")
    call SetSoundDuration(gg_snd_Hero_Erza7_G2, 2016)
    call SetSoundChannel(gg_snd_Hero_Erza7_G2, 0)
    call SetSoundVolume(gg_snd_Hero_Erza7_G2, 127)
    call SetSoundPitch(gg_snd_Hero_Erza7_G2, 1.0)
    set gg_snd_Hero_Inori_W_2=CreateSound("war3mapImported/Hero_Inori_W 2.mp3", false, false, false, 0, 0, "DefaultEAXON")
    call SetSoundDuration(gg_snd_Hero_Inori_W_2, 7416)
    call SetSoundChannel(gg_snd_Hero_Inori_W_2, 0)
    call SetSoundVolume(gg_snd_Hero_Inori_W_2, 127)
    call SetSoundPitch(gg_snd_Hero_Inori_W_2, 1.0)
    set gg_snd_Hero_Inori_R=CreateSound("war3mapImported/Hero_Inori_R.mp3", false, false, false, 0, 0, "DefaultEAXON")
    call SetSoundDuration(gg_snd_Hero_Inori_R, 21792)
    call SetSoundChannel(gg_snd_Hero_Inori_R, 0)
    call SetSoundVolume(gg_snd_Hero_Inori_R, 127)
    call SetSoundPitch(gg_snd_Hero_Inori_R, 1.0)
    set gg_snd_Hero_Laxus_T=CreateSound("war3mapImported/Hero_Laxus_T.mp3", false, false, false, 0, 0, "DefaultEAXON")
    call SetSoundDuration(gg_snd_Hero_Laxus_T, 4824)
    call SetSoundChannel(gg_snd_Hero_Laxus_T, 0)
    call SetSoundVolume(gg_snd_Hero_Laxus_T, 127)
    call SetSoundPitch(gg_snd_Hero_Laxus_T, 1.0)
    set gg_snd_TornadoLoop=CreateSound("Units/Undead/Abomination/AbominationDeath1.flac", false, true, true, 1, 1, "DefaultEAXON")
    call SetSoundParamsFromLabel(gg_snd_TornadoLoop, "AbominationDeath")
    call SetSoundDuration(gg_snd_TornadoLoop, 2455)
    call SetSoundVolume(gg_snd_TornadoLoop, 127)
    set gg_snd_Hero_Ainz_F=CreateSound("war3mapImported/Hero_Ainz_F.mp3", false, false, false, 0, 0, "DefaultEAXON")
    call SetSoundDuration(gg_snd_Hero_Ainz_F, 9432)
    call SetSoundChannel(gg_snd_Hero_Ainz_F, 0)
    call SetSoundVolume(gg_snd_Hero_Ainz_F, 127)
    call SetSoundPitch(gg_snd_Hero_Ainz_F, 1.0)
endfunction

//***************************************************************************
//*
//*  Unit Creation
//*
//***************************************************************************

//===========================================================================
function CreateUnitsForPlayer0 takes nothing returns nothing
    local player p= Player(0)
    local unit u
    local integer unitID
    local trigger t
    local real life

    set u=BlzCreateUnitWithSkin(p, 'h00L', - 890.1, - 1356.9, 305.803, 'h00L')
endfunction

//===========================================================================
function CreateNeutralHostile takes nothing returns nothing
    local player p= Player(PLAYER_NEUTRAL_AGGRESSIVE)
    local unit u
    local integer unitID
    local trigger t
    local real life

    set u=BlzCreateUnitWithSkin(p, 'hspt', 2532.5, - 3153.3, 162.130, 'hspt')
    set u=BlzCreateUnitWithSkin(p, 'hpea', - 2526.2, 258.9, 140.959, 'hpea')
    set u=BlzCreateUnitWithSkin(p, 'hpea', - 1719.9, 277.4, 287.710, 'hpea')
    set u=BlzCreateUnitWithSkin(p, 'hmtm', - 3254.7, 2864.8, 261.810, 'hmtm')
    set u=BlzCreateUnitWithSkin(p, 'hpea', - 2175.2, 728.3, 10.500, 'hpea')
    set u=BlzCreateUnitWithSkin(p, 'hpea', - 1130.0, 1375.2, 151.462, 'hpea')
    set u=BlzCreateUnitWithSkin(p, 'Hblm', 574.7, 2878.8, 85.927, 'Hblm')
    set u=BlzCreateUnitWithSkin(p, 'hkni', 2628.5, - 402.0, 328.520, 'hkni')
    set u=BlzCreateUnitWithSkin(p, 'hpea', - 1967.7, 1223.5, 140.959, 'hpea')
    set u=BlzCreateUnitWithSkin(p, 'hpea', - 2141.3, 1758.0, 140.959, 'hpea')
    set gg_unit_hpea_0011=BlzCreateUnitWithSkin(p, 'hpea', 721.6, 86.6, 140.959, 'hpea')
    set u=BlzCreateUnitWithSkin(p, 'Hblm', - 1706.4, - 825.8, 218.514, 'Hblm')
    set u=BlzCreateUnitWithSkin(p, 'hpea', - 2754.9, 1322.7, 310.177, 'hpea')
    set u=BlzCreateUnitWithSkin(p, 'Hblm', - 908.0, 2839.8, 226.072, 'Hblm')
    set u=BlzCreateUnitWithSkin(p, 'hpea', - 2865.9, 854.9, 140.959, 'hpea')
    set u=BlzCreateUnitWithSkin(p, 'hpea', - 1440.9, 892.1, 140.959, 'hpea')
    set u=BlzCreateUnitWithSkin(p, 'Hblm', - 2939.3, - 1778.8, 229.310, 'Hblm')
    set u=BlzCreateUnitWithSkin(p, 'hpea', 2757.1, - 830.7, 140.959, 'hpea')
    set u=BlzCreateUnitWithSkin(p, 'hpea', 112.2, - 2160.0, 140.959, 'hpea')
    set u=BlzCreateUnitWithSkin(p, 'hpea', - 209.4, - 2454.3, 140.959, 'hpea')
    set u=BlzCreateUnitWithSkin(p, 'Hblm', - 413.1, 2523.3, 226.072, 'Hblm')
    set u=BlzCreateUnitWithSkin(p, 'Hblm', - 244.9, 2120.5, 226.072, 'Hblm')
endfunction

//===========================================================================
function CreatePlayerBuildings takes nothing returns nothing
endfunction

//===========================================================================
function CreatePlayerUnits takes nothing returns nothing
    call CreateUnitsForPlayer0()
endfunction

//===========================================================================
function CreateAllUnits takes nothing returns nothing
    call CreatePlayerBuildings()
    call CreateNeutralHostile()
    call CreateUnitsForPlayer0() // INLINED!!
endfunction

//***************************************************************************
//*
//*  Regions
//*
//***************************************************************************

function CreateRegions takes nothing returns nothing
    local weathereffect we

    set gg_rct_Caster=Rect(- 2976.0, 2400.0, - 2528.0, 2752.0)
    set gg_rct_Base=Rect(1344.0, 1088.0, 3264.0, 2976.0)
    set gg_rct_Arena=Rect(- 3328.0, - 3584.0, 3296.0, 3072.0)
    set gg_rct_LL=Rect(2112.0, 2016.0, 2336.0, 2304.0)
    set gg_rct_Cage=Rect(2144.0, 2080.0, 2656.0, 2784.0)
endfunction

//***************************************************************************
//*
//*  Triggers
//*
//***************************************************************************
function InitCustomTriggers takes nothing returns nothing
    //Function not found: call InitTrig_TooltipBuilder()
    //Function not found: call InitTrig_UniversalTooltips()
    //Function not found: call InitTrig_UI_CAREER()
    //Function not found: call InitTrig_DefaultArmorChangeStable_Copy()
    //Function not found: call InitTrig_Save2()
    //Function not found: call InitTrig_SaveLoad()
    //Function not found: call InitTrig_MusicPlayer()
    //Function not found: call InitTrig_Scoreboard()
    //Function not found: call InitTrig_ChatCommand()
    //Function not found: call InitTrig_Player_Pick_Mode()
    call InitTrig_WoS_Shop_Init()
    //Function not found: call InitTrig_WoS_Pick_Init()
    call InitTrig_Starts()
    call InitTrig_BuildsForChars()
    call InitTrig_TestUnit()
    //Function not found: call InitTrig_WoS_Hero_Icons_Init()
    call InitTrig_Leave()
    //Function not found: call InitTrig_RoundEnd()
    //Function not found: call InitTrig_CastAItems()
    //Function not found: call InitTrig_TasBox()
    call InitTrig_CastCheck()
    call InitTrig_ClickEvent()
    //Function not found: call InitTrig_DecorDestroy_and_Erza_Debuff()
    //Function not found: call InitTrig_Systems1()
    //Function not found: call InitTrig_Systems2()
    call InitTrig_DmgSys()
    call InitTrig_AtkCancel()
    call InitTrig_MouseMove()
    call InitTrig_Death()
    call InitTrig_silence()
    call InitTrig_LvlUpCheck()
    call InitTrig_LvlSelf()
    call InitTrig_MagRes()
    call InitTrig_PhysRes()
    call InitTrig_slow()
    call InitTrig_NeviSound()
    call InitTrig_Evol1()
    call InitTrig_Evol2()
    call InitTrig_sukuna_spawn()
    call InitTrig_ESC()
    call InitTrig_Killme()
    call InitTrig_AnimCheck()
    call InitTrig_hpset()
    call InitTrig_mpset()
    call InitTrig_ArrowLeft()
    call InitTrig_ArrowUp()
    call InitTrig_ArrowDown()
    call InitTrig_ArrowRight()
    call InitTrig_CastingCheck()
    call InitTrig_ButtonPressed()
    call InitTrig_ButtonPressed_ESC()
    call InitTrig_ButtonUnPressed_ESC()
    call InitTrig_EnterBase()
    call InitTrig_EnterRegion()
    call InitTrig_LeavesBase()
    call InitTrig_LeavesRegion()
    call InitTrig_ItemCupOfTea()
    call InitTrig_ItemEnter()
    call InitTrig_ItemLeave()
    //Function not found: call InitTrig_Items()
    //Function not found: call InitTrig_Toji()
    //Function not found: call InitTrig_Raiden()
    //Function not found: call InitTrig_Frieren()
    //Function not found: call InitTrig_Ainz()
    //Function not found: call InitTrig_Laxus()
    //Function not found: call InitTrig_Brandish()
    //Function not found: call InitTrig_Patriot()
    //Function not found: call InitTrig_Asta()
    //Function not found: call InitTrig_Gojo()
    //Function not found: call InitTrig_Bambietta()
    //Function not found: call InitTrig_Kirito()
    //Function not found: call InitTrig_Alucard()
    //Function not found: call InitTrig_Starrk()
    //Function not found: call InitTrig_Takeshi()
    //Function not found: call InitTrig_Barragan()
    //Function not found: call InitTrig_Mahoraga()
    //Function not found: call InitTrig_Harribel()
    //Function not found: call InitTrig_Tsuna()
    //Function not found: call InitTrig_Rimuru()
    //Function not found: call InitTrig_DarkShiki()
    //Function not found: call InitTrig_BazzB()
    //Function not found: call InitTrig_Neuvillette()
    //Function not found: call InitTrig_Okarun()
    //Function not found: call InitTrig_Akainu()
    //Function not found: call InitTrig_Inori()
    //Function not found: call InitTrig_Kenjaku()
    //Function not found: call InitTrig_AlterSaber()
    //Function not found: call InitTrig_Natsu()
    //Function not found: call InitTrig_Kyoraku()
    //Function not found: call InitTrig_Tomioka()
    //Function not found: call InitTrig_ErzaQ()
    //Function not found: call InitTrig_ErzaW()
    //Function not found: call InitTrig_ErzaE()
    //Function not found: call InitTrig_ErzaR()
    //Function not found: call InitTrig_ErzaT()
    //Function not found: call InitTrig_ErzaG2_Nakagami()
    //Function not found: call InitTrig_ErzaG2_Fairy()
    //Function not found: call InitTrig_ErzaBase()
endfunction

//===========================================================================
function RunInitializationTriggers takes nothing returns nothing
    call ConditionalTriggerExecute(gg_trg_Systems1)
    call ConditionalTriggerExecute(gg_trg_Systems2)
endfunction

//***************************************************************************
//*
//*  Players
//*
//***************************************************************************

function InitCustomPlayerSlots takes nothing returns nothing

    // Player 0
    call SetPlayerStartLocation(Player(0), 0)
    call SetPlayerColor(Player(0), ConvertPlayerColor(0))
    call SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
    call SetPlayerRaceSkin(Player(0), RACE_PREF_USER_SELECTABLE)
    call SetPlayerRaceSelectable(Player(0), true)
    call SetPlayerController(Player(0), MAP_CONTROL_USER)

    // Player 1
    call SetPlayerStartLocation(Player(1), 1)
    call SetPlayerColor(Player(1), ConvertPlayerColor(1))
    call SetPlayerRacePreference(Player(1), RACE_PREF_ORC)
    call SetPlayerRaceSkin(Player(1), RACE_PREF_USER_SELECTABLE)
    call SetPlayerRaceSelectable(Player(1), true)
    call SetPlayerController(Player(1), MAP_CONTROL_COMPUTER)

endfunction

function InitCustomTeams takes nothing returns nothing
    // Force: TRIGSTR_002
    call SetPlayerTeam(Player(0), 0)
    call SetPlayerState(Player(0), PLAYER_STATE_ALLIED_VICTORY, 1)
    call SetPlayerTeam(Player(1), 0)
    call SetPlayerState(Player(1), PLAYER_STATE_ALLIED_VICTORY, 1)

    //   Allied
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(0), true)

endfunction

function InitAllyPriorities takes nothing returns nothing

    call SetStartLocPrioCount(1, 2)
    call SetStartLocPrio(1, 0, 0, MAP_LOC_PRIO_LOW)

    call SetEnemyStartLocPrioCount(1, 2)
    call SetEnemyStartLocPrio(1, 0, 0, MAP_LOC_PRIO_LOW)
endfunction

//***************************************************************************
//*
//*  Main Initialization
//*
//***************************************************************************

//===========================================================================
function main takes nothing returns nothing
    call SetCameraBounds(- 3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), - 3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), - 3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), - 3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call SetHDWaterParamsEx(0, 0, 0, false, 20, 0, 100, 10, 0, 50, 100, 100)
    call NewSoundEnvironment("Default")
    call SetAmbientDaySound("LordaeronSummerDay")
    call SetAmbientNightSound("LordaeronSummerNight")
    call SetMapMusic("Music", true, 0)
    call InitSounds()
    call CreateRegions()
    call CreateAllUnits()
    call InitBlizzard()
    call InitGlobals()
    call InitCustomTriggers()
    call RunInitializationTriggers()

endfunction

//***************************************************************************
//*
//*  Map Configuration
//*
//***************************************************************************

function config takes nothing returns nothing
    call SetMapName("TRIGSTR_020")
    call SetMapDescription("TRIGSTR_022")
    call SetPlayers(2)
    call SetTeams(2)
    call SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)

    call DefineStartLocation(0, - 2624.0, - 1408.0)
    call DefineStartLocation(1, 3200.0, - 1472.0)

    // Player setup
    call InitCustomPlayerSlots()
    call InitCustomTeams()
    call InitAllyPriorities()
endfunction
