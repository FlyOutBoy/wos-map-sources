globals
    framehandle WOS_ModeRoot = null
    framehandle array WOS_ModeButton
    dialog udg_ModeDialog
    button udg_TestButton
    button udg_NormalButton
    button udg_CaptainButton
    button udg_CaptainDraftButton
    boolean TestMode = false
    boolean CaptainMode = false
    boolean CaptainDraftMode = false
    integer PickedMode = 0
    real array poscamx 
    real array poscamy 
    texttag  ShopInfo 
    string array PlayerShopBut
    integer PlayersAmount = 0
    boolean musicenabled = false
    boolean ModeSystemsInitialized = false
    group MeraMeraEnumGroup = null
    timer CamSetupTimer = null
    framehandle main_frame 
    timer RegenTimer = null
    timer FullShieldEffectTimer = null
    effect array ShieldEff
    unit array ShieldEffTarget
    string FullShieldEffectModel = "war3mapimported\\wos_title_shielded.mdl"
    effect array OutsideBaseInvulEff
    unit array OutsideBaseInvulEffTarget
    string OutsideBaseInvulEffectModel = "war3mapimported\\wos_title_invul.mdl"
integer KEY_PHYS_RES
integer KEY_MAG_RES
integer KEY_PATRIOT_E
integer KEY_ALUCARD_G2
integer KEY_ALUCARD_G3
integer KEY_MODE_G
integer KEY_HARI_G2
integer KEY_BLUE_EMPEROR_RES
integer KEY_ERZA_G2_TYPE
integer KEY_ERZA_G2_ACTIVE
integer KEY_T_ARMOR_ACTIVE
integer KEY_TOMIOKA_F_INVUL
integer KEY_TOMIOKA_F_DMG_ACT
integer KEY_ZERO_KAI
integer KEY_INVUL
integer KEY_SHIELD
integer KEY_GOJO_E
integer KEY_YAMAMOTO_FR
integer KEY_PATRIOT_EE
integer KEY_E_ARMOR_ACTIVE
integer KEY_DMG_B_E
integer KEY_MODE_DEF
integer KEY_INSTINCT
integer KEY_RIMURU_F
integer KEY_RT
    integer KEY_DEF_T
    integer KEY_IMM_F
endglobals
function CreateKeys takes nothing returns nothing 
set KEY_PHYS_RES         = StringHash("phys res")
set KEY_MAG_RES          = StringHash("mag res")
set KEY_PATRIOT_E        = StringHash("patriot e")
set KEY_ALUCARD_G2 = StringHash("alucard g2")
set KEY_ALUCARD_G3 = StringHash("alucard g3")
set KEY_MODE_G           = StringHash("mode g")
set KEY_HARI_G2          = StringHash("hari g 2")
set KEY_BLUE_EMPEROR_RES = StringHash("blue emperor res")
set KEY_ERZA_G2_TYPE     = StringHash("erza g2 type")
set KEY_ERZA_G2_ACTIVE   = StringHash("erza g2 active")
set KEY_T_ARMOR_ACTIVE      = StringHash("t armor active")
set KEY_TOMIOKA_F_INVUL     = StringHash("tomioka f invul")
set KEY_TOMIOKA_F_DMG_ACT   = StringHash("tomioka f dmg act")
set KEY_ZERO_KAI            = StringHash("zero kai")
set KEY_INVUL               = StringHash("invul")
set KEY_SHIELD              = StringHash("shield")
set KEY_GOJO_E              = StringHash("gojo e")
set KEY_YAMAMOTO_FR         = StringHash("yamamoto fr")
set KEY_PATRIOT_EE          = StringHash("patriot ee")
set KEY_E_ARMOR_ACTIVE      = StringHash("e armor active")
set KEY_DMG_B_E             = StringHash("dmg b e")
set KEY_MODE_DEF            = StringHash("mode def")
set KEY_INSTINCT            = StringHash("instinct")
set KEY_RIMURU_F            = StringHash("rimuru f")
set KEY_RT    = StringHash("rt")
set KEY_DEF_T = StringHash("def t")
set KEY_IMM_F = StringHash("imm f")
endfunction 

function HasFullShieldVisual takes unit u returns boolean
    local integer unitHid
    local integer playerHid
    local integer unitId

    if u == null or GetUnitTypeId(u) == 0 then
        return false
    endif

    set unitHid = GetHandleId(u)
    set playerHid = GetHandleId(GetOwningPlayer(u))
    set unitId = GetUnitTypeId(u)

    // Unit states are stored under the hero handle.
    if LoadInteger(hs, unitHid, KEY_INVUL) == 1 or LoadInteger(hs, unitHid, KEY_SHIELD) == 1 then
        return true
    endif

    // These two states are explicitly stored under the owning-player handle.
    if LoadInteger(hs, playerHid, KEY_TOMIOKA_F_INVUL) == 1 then
        return true
    endif
    if GetUnitAbilityLevel(u, 'B02G') > 0 or GetUnitAbilityLevel(u, TurboNeko_Invul_ID) > 0 then
        return true
    endif

    // Full blocks represented by buffs/abilities on the damaged unit.
    if GetUnitAbilityLevel(u, AinzF_Buff0_ID) > 0 /*
    */ or GetUnitAbilityLevel(u, AlterSaberEBuff_ID) > 0 /*
    */ or GetUnitAbilityLevel(u, KyorakuR_BuffId) > 0 /*
    */ or GetUnitAbilityLevel(u, Erza3E_DamageImmune_ID) > 0 or GetUnitAbilityLevel(u, Erza3E_DamageImmune_ID) > 0 or GetUnitAbilityLevel(u, FrierenG_BuffID1) > 0 or GetUnitAbilityLevel(u, FrierenG_BuffID2) > 0 or GetUnitAbilityLevel(u, FrierenG_BuffID3) > 0 then
        return true
    endif

    if LoadInteger(hs, unitHid, KEY_PATRIOT_EE) == 1 then
        return true
    endif

    // Erza mana shield. It blocks while the channel/order and stored shield pool exist.
    if GetUnitCurrentOrder(u) == OrderId("autoharvestlumber") /*
    */ and LoadInteger(hs, unitHid, KEY_E_ARMOR_ACTIVE) == 1 /*
    */ and LoadReal(hs, unitHid, KEY_DMG_B_E) > 0.0 then
        return true
    endif

    if unitId == Gojo_ID and LoadInteger(hs, unitHid, KEY_GOJO_E) == 1 then
        return true
    endif

    if unitId == Takeshi_ID then
        if GetUnitAbilityLevel(u, TakeshiQ3_Buff_ID) > 0 /*
        */ or LoadInteger(hs, playerHid, KEY_YAMAMOTO_FR) == 1 /*
        */ or LoadInteger(hs, unitHid, KEY_DEF_T) == 1 then
            return true
        endif
    endif

    if unitId == Tsuna_ID then
        if LoadInteger(hs, unitHid, KEY_MODE_DEF) == 1 then
            return true
        endif
        /*if LoadReal(hs, unitHid, KEY_INSTINCT) > 0.0 /*
        */ and BlzGetUnitAbilityCooldownRemaining(u, FakeAbi_ID) <= 0.0 then
            return true
        endif*/
    endif

    if unitId == Rimuru_ID then
        if LoadInteger(hs, unitHid, KEY_RIMURU_F) == 1 /*
        */ or GetUnitAbilityLevel(u, RimuruQ2_Buff_ID) > 0 /*
        */ or GetUnitAbilityLevel(u, RimuruF3_Buff_ID) > 0 then
            return true
        endif
    endif

    // Cup of Tea is a full shield only while its shared cooldown is ready.
    if BlzGetUnitAbilityCooldownRemaining(u, 'A01W') <= 0.0 then
        return HasCachedItem(u, 'I00M') > 0 or HasCachedItem(u, 'I043') > 0
    endif

    return false
endfunction

function UpdateFullShieldEffects takes nothing returns nothing
    local integer i = 0
    local unit u

    loop
        exitwhen i == 10
        set u = Hero[i]

        // Hero[i] can be replaced; never leave the old effect attached to the old unit.
        if ShieldEff[i] != null and ShieldEffTarget[i] != u then
            call DestroyEffect(ShieldEff[i])
            set ShieldEff[i] = null
            set ShieldEffTarget[i] = null
        endif

        if u != null and HasFullShieldVisual(u) then
            if ShieldEff[i] == null then
                set ShieldEff[i] = AddSpecialEffectTarget(FullShieldEffectModel, u, "origin")
                set ShieldEffTarget[i] = u
            endif
        elseif ShieldEff[i] != null then
            call DestroyEffect(ShieldEff[i])
            set ShieldEff[i] = null
            set ShieldEffTarget[i] = null
        endif

        // Show a separate invulnerability effect only while Avul exists outside the base.
        if OutsideBaseInvulEff[i] != null and OutsideBaseInvulEffTarget[i] != u then
            call DestroyEffect(OutsideBaseInvulEff[i])
            set OutsideBaseInvulEff[i] = null
            set OutsideBaseInvulEffTarget[i] = null
        endif

        if u != null /*
        */ and GetUnitAbilityLevel(u, 'Avul') > 0 /*
        */ and not CheckCoordsInRect(gg_rct_Base, GetUnitX(u), GetUnitY(u)) then
            if OutsideBaseInvulEff[i] == null then
                set OutsideBaseInvulEff[i] = AddSpecialEffectTarget(OutsideBaseInvulEffectModel, u, "origin")
                set OutsideBaseInvulEffTarget[i] = u
            endif
        elseif OutsideBaseInvulEff[i] != null then
            call DestroyEffect(OutsideBaseInvulEff[i])
            set OutsideBaseInvulEff[i] = null
            set OutsideBaseInvulEffTarget[i] = null
        endif

        set i = i + 1
    endloop

    set u = null
endfunction

function TestComm takes nothing returns nothing
    if ModeSystemsInitialized then
        return
    endif
    set ModeSystemsInitialized = true
    call WUI_ShowTestHelp(TestMode)
endfunction

function MusicInit takes nothing returns nothing
    local timer expired = GetExpiredTimer()
    if expired != null then
        call DestroyTimer(expired)
    endif
    if musicenabled then
        set expired = null
        return
    endif

    // РЎРЅР°С‡Р°Р»Р° СЃС‚Р°РЅРґР°СЂС‚РЅР°СЏ РјСѓР·С‹РєР° РєР°СЂС‚С‹ РґР»СЏ РІСЃРµС… РєР»РёРµРЅС‚РѕРІ.
    call StopMusic(false)
    call ClearMapMusic()
    call SetMapMusic("war3mapImported\\King Gnu - SPECIALZ.mp3", false, 0)
    call PlayMusic("war3mapImported\\King Gnu - SPECIALZ.mp3")

    set musicenabled = true
    set expired = null
endfunction
// The frame selector and timeout use one authoritative mode transition.
function WOS_SelectMode takes integer mode returns nothing
    if PickedMode != 0 or mode < 1 or mode > 4 then
        return
    endif
    set PickedMode = mode
    set TestMode = mode == 2
    set CaptainMode = mode == 3
    set CaptainDraftMode = mode == 4
    set CaptainDraftPreRoundUnlimitedSwap = CaptainDraftMode
    if TestMode then
        call TestComm()
        call PlayersMsg("Test Mode activated", 1)
    elseif CaptainMode then
        call PlayersMsg("Player Pick Mode activated", 1)
    elseif CaptainDraftMode then
        call PlayersMsg("Captain Draft Mode activated", 1)
        call CaptainDraft_PlayConfiguredSound(CaptainDraftSoundModeStart)
    else
        call PlayersMsg("Normal Mode activated", 1)
    endif
    if WOS_ModeRoot != null then
        call BlzFrameSetVisible(WOS_ModeRoot, false)
    endif
    if PlayersAmount < 2 then
        call TimerStart(CreateTimer(), 1.00, false, function MusicInit)
    endif
    call SetFloatGameState(GAME_STATE_TIME_OF_DAY, 8.00)
    call Map_Start()
    if CaptainDraftMode then
        call CaptainDraft_StartFirstSideVote()
    endif
endfunction

function CheckPickedMode takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    call WOS_SelectMode(1)
endfunction

function WOS_ModeFrameClick takes nothing returns nothing
    local integer i = 0
    if GetTriggerPlayer() != Player(0) then
        return
    endif
    loop
        exitwhen i >= 4
        if BlzGetTriggerFrame() == WOS_ModeButton[i] then
            if i == 0 then
                call WOS_SelectMode(1)
            elseif i == 1 then
                call WOS_SelectMode(3)
            elseif i == 2 then
                call WOS_SelectMode(4)
            else
                call WOS_SelectMode(2)
            endif
            return
        endif
        set i = i + 1
    endloop
endfunction

function WOS_CreateModeSelector takes nothing returns nothing
    local integer i = 0
    local string caption
    local framehandle panel
    local framehandle title
    local trigger events = CreateTrigger()
    set WOS_ModeRoot = BlzCreateFrameByType("FRAME", "WOSModeSelector", WUI_GetRoot(), "", 0)
    call WUI_RegisterModal(WOS_ModeRoot)
    call BlzFrameSetLevel(WOS_ModeRoot, 30)
    set panel = WUI_Window("WOSModePanel", WOS_ModeRoot, 1, 0)
    call WUI_Place(panel, 0.400, 0.330, 0.270, 0.275)
    set title = WUI_OrnateBorder("WOSModeMetal", panel, 0.032)
    set title = BlzCreateFrameByType("TEXT", "WOSModeTitle", panel, "", 0)
    call WUI_Place(title, 0.400, 0.439, 0.240, 0.021)
    call BlzFrameSetTextAlignment(title, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetText(title, WUI_GOLD + "CHOOSE GAME MODE|r")
    set title = BlzCreateFrameByType("TEXT", "WOSModeHint", panel, "", 0)
    call WUI_Place(title, 0.400, 0.410, 0.240, 0.018)
    call BlzFrameSetScale(title, 0.78)
    call BlzFrameSetTextAlignment(title, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetText(title, "Host selects a mode - Normal after 20s")
    loop
        exitwhen i >= 4
        if i == 0 then
            set caption = "Normal Mode"
        elseif i == 1 then
            set caption = "Player Pick Mode"
        elseif i == 2 then
            set caption = "Captain Draft Mode"
        else
            set caption = "Test Mode"
        endif
        set WOS_ModeButton[i] = WUI_TextButton("WOSModeButton" + I2S(i), panel, caption, 0.230, 0.037)
        call WUI_Place(WOS_ModeButton[i], 0.400, 0.374 - I2R(i) * 0.047, 0.230, 0.037)
        call BlzTriggerRegisterFrameEvent(events, WOS_ModeButton[i], FRAMEEVENT_CONTROL_CLICK)
        if GetLocalPlayer() != Player(0) then
            call BlzFrameSetEnable(WOS_ModeButton[i], false)
        endif
        set i = i + 1
    endloop
    call TriggerAddAction(events, function WOS_ModeFrameClick)
    set panel = null
    set title = null
    set events = null
endfunction

function MeraMeraNoMi takes unit hero returns nothing
local unit target = null
local player owner = null
local real dmg = MeraMera_Damage + (GetUnitState(hero,UNIT_STATE_MAX_LIFE)*(MeraMera_MaxHpDamage/100))
local integer id = GetPlayerId(GetOwningPlayer(hero))
if dmg> MeraMera_MaxDamage then 
set dmg = MeraMera_MaxDamage
endif
if MeraMeraDummy[id] == null then 
set MeraMeraDummy[id] = CreateUnit( Player( id ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
call UnitAddAbility(MeraMeraDummy[id], 'A0GG')
call SetUnitAbilityLevel(MeraMeraDummy[id], 'A0GG', 1)
endif
if hero == null or GetWidgetLife(hero) <= 2 or IsUnitType(hero,UNIT_TYPE_DEAD) then
return
endif
set owner = GetOwningPlayer(hero)
if MeraMeraEnumGroup == null then
set MeraMeraEnumGroup = CreateGroup()
else
call GroupClear(MeraMeraEnumGroup)
endif
call GroupEnumUnitsInRange(MeraMeraEnumGroup,GetUnitX(hero),GetUnitY(hero),MeraMera_Aoe,null)
loop
set target = FirstOfGroup(MeraMeraEnumGroup)
exitwhen target == null
call GroupRemoveUnit(MeraMeraEnumGroup,target)
if IsUnitEnemy(target,owner) and GetWidgetLife(target) > 0.405 and not IsUnitType(target,UNIT_TYPE_DEAD) and GetUnitAbilityLevel(target,'Avul') == 0 and GetUnitAbilityLevel(target,'B02T')<1 then
call dmgmag(hero,target,dmg)
call SetUnitFacing(MeraMeraDummy[id], GAngle(MeraMeraDummy[id], target) * bj_RADTODEG)
call IssueTargetOrder(MeraMeraDummy[id], "curse", target)        
call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_t_immolationreddamage.mdl",target,"origin"))
endif
endloop
set owner = null
set target = null
endfunction

function Regen takes nothing returns nothing
    local integer i = 0
    local unit u
    local real x
    local real y
     local real z  = 650
    
    loop
        exitwhen i == 10
        if IsActivePlayerSlot(i) then
        set u = Hero[i]        
        if u != null and Leave[i] == 0 then
            set x = GetUnitX(u)
            set y = GetUnitY(u)
            if GetUnitTypeId(u) == Toji_ID then
                call TojiStartZeroMana(u)
            endif
        //    if GetUnitTypeId(u)== Toji_ID and GetHeroInt(u,true)>0 then 
        //call SetHeroInt(u,GetHeroInt(u,true)-GetHeroInt(u,true),true)
       // endif
       // if GetUnitTypeId(u)== Toji_ID and GetUnitState(u,UNIT_STATE_MAX_MANA)>0 then 
       // call BlzSetUnitMaxMana(u,1)
       // call SetUnitState(u,UNIT_STATE_MANA,999)
        //call UnitAddAbility(u,'A0HF')
       // endif
       // call FixModel(u)
       if CondArena == 0 then
                if not CheckCoordsInRect(gg_rct_Base, x, y) then
                    call SetUnitPosition(u, GetRectCenterX(gg_rct_Pick), GetRectCenterY(gg_rct_Pick))
                endif
                call LearnHeroSpells(u)
               // call DebuffClear(u)
                if GetUnitAbilityLevel(u, 'Avul') == 0 then
                    call UnitAddAbility(u, 'Avul')
                endif
                else
                if GetUnitAbilityLevel(u,'B02F')>0 then 
                call SetMpCurrent(u,-15)
                endif
       if HasCachedItem(u,'I02G') > 0 then
        call MeraMeraNoMi(u)
       endif
          if AinzF_HasHpRegenBuff(u) then
            call SetHpCurrent2(u,u,15)
        endif
        
       if GetUnitAbilityLevel(u,'A0F9')>0 and BlzGetUnitAbilityCooldownRemaining(u,'A0F9')==0 then 
        call SetHpCurrent2(u,u,ElixirOfLife_HpRegen)
       endif
       if GetUnitAbilityLevel(u,'B01P')> 0 then 
        call SetHpCurrent2(u,u,DarkHolyGrail_HpRegen)
        call SetMpCurrent(u,DarkHolyGrail_MpRegen)
        elseif GetUnitAbilityLevel(u,'B013')> 0 then 
        call SetHpCurrent2(u,u,HolyGrail_HpRegen)
        call SetMpCurrent(u,HolyGrail_MpRegen)
        endif
        endif
        
        endif
        endif
        set i = i + 1
    endloop
   
   
    set u = null
endfunction
function CamSetup takes nothing returns nothing
    local integer i = 0
    local unit u
    local real x
    local real y
    loop
        exitwhen i == 15
        if IsActivePlayerSlot(i) or IsActiveObserverSlot(i) then
            set u = Hero[i]
            if u != null and Leave[i] == 0 and CondArena != 0 and not IsUnitType(u, UNIT_TYPE_DEAD) then
                set x = GetUnitX(u)
                set y = GetUnitY(u)
                if CheckCoordsInRect(gg_rct_Arena, x, y) or CheckCoordsInRect(gg_rct_Cage, x, y) then
                    if SR3(u, poscamx[i], poscamy[i]) > 75 then
                        set poscamx[i] = x
                        set poscamy[i] = y
                        if PlayerVision[i] != null then
                            call DestroyFogModifier(PlayerVision[i])
                        endif
                        set PlayerVision[i] = CreateFogModifierRadius(Player(i), FOG_OF_WAR_VISIBLE, x, y, 1800, true, false)
                        call FogModifierStart(PlayerVision[i])
                    endif
                elseif PlayerVision[i] != null then
                    call DestroyFogModifier(PlayerVision[i])
                    set PlayerVision[i] = null
                endif
            elseif PlayerVision[i] != null then
                call DestroyFogModifier(PlayerVision[i])
                set PlayerVision[i] = null
            endif
            call SetCameraFieldForPlayer(Player(i), CAMERA_FIELD_TARGET_DISTANCE, CameraSetup[i], 0)
            call SetCameraFieldForPlayer(Player(i), CAMERA_FIELD_FARZ, 50000, 0)
        elseif PlayerVision[i] != null then
            call DestroyFogModifier(PlayerVision[i])
            set PlayerVision[i] = null
        endif
        set i = i + 1
    endloop
    set u = null
endfunction
function InitTrig_ModeDialog takes nothing returns nothing
    local trigger t = CreateTrigger()
    local real x  
    local real y 
    local real z  = 650
    local integer i = 0
    local integer k2 = 0
    local real r = 200
local real r2 = 265
local real a = 270 *bj_DEGTORAD
local real fly = 300
local real scale = 20
                set main_frame = BlzCreateFrameByType("BACKDROP", "SS", WUI_GetRoot(), "", 0)
             //   call BlzFrameSetAbsPoint(frame_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18)
            //    call BlzFrameSetSize(frame_pas1[k2], 0.135, 0.035)
// Permanent instruction texttags are now in the scrollable TestMode panel.
set i = 0
loop
exitwhen i == 15
set CameraSetup[i] = BaseCam
set Shop_Active[i] = false
set PlayerShopBut[i] = "TAB"
set Hero[i] = null
  if IsActivePlayerSlot(i) then
//call SaveSystem_PrintStats(Player(i))
set PlayersAmount = PlayersAmount + 1
call SetPlayerState(Player(i),PLAYER_STATE_RESOURCE_LUMBER,k2)
endif
call SetCameraFieldForPlayer(Player(i), CAMERA_FIELD_TARGET_DISTANCE, CameraSetup[i], 0)
call SetCameraFieldForPlayer(Player(i), CAMERA_FIELD_FARZ, 50000, 0)
call PanCameraToTimedForPlayer(Player(i),GetRectCenterX(gg_rct_Base),GetRectCenterY(gg_rct_Base),0)
set i = i + 1
endloop
    call TasAbilityChargeBox_Init()
    if PlayersAmount >1 then 
    call MusicInit()
    endif
    set AAADestNoDecorCond = Condition(function NoDecor_Filter)
    call WUI_OnReady(function WOS_CreateModeSelector)
    call TimerStart(CreateTimer(),20,false,function CheckPickedMode )
    set CamSetupTimer = CreateTimer()
    set RegenTimer = CreateTimer()
    call TimerStart(CamSetupTimer,0.20,true,function CamSetup )
    call TimerStart(RegenTimer,1.00,true,function Regen )
    call FogMaskEnable(false)
     set NoDecor_Cond = Condition(function NoDecor_Filter)
     set DecorAliveCond = Condition(function DecorAlive_Filter)
     call CreateKeys()
     call Preload(FullShieldEffectModel)
     call Preload(OutsideBaseInvulEffectModel)
     set FullShieldEffectTimer = CreateTimer()
     call TimerStart(FullShieldEffectTimer, 0.10, true, function UpdateFullShieldEffects)
     call InitCloneVisualCleanup()
     call InitTransformVisualOptimization()
     set t = null
endfunction
//===========================================================================
function InitTrig_Starts takes nothing returns nothing
    set gg_trg_Starts = CreateTrigger(  )
    call TriggerRegisterTimerEvent(gg_trg_Starts, 10, false)
    call TriggerAddAction( gg_trg_Starts, function InitTrig_ModeDialog )
endfunction
