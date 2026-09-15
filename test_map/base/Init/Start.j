globals
integer LLL = 0
real ahk_delay = 0
boolean udg_RK_KOTH_ENABLED = false
integer CapPickPhase = 0
unit array Hero
boolean HeroSelector_testing = false
integer Q_ID = 'A000'

integer W_ID = 'A001'

integer E_ID = 'A002'

integer R_ID = 'A003'
integer T_ID = 'A004'//UlquiorraT3_ID//'A01P'
integer G_ID = 'A01V'
integer F_ID = 'A01U'
unit array HeroChosen
integer array AutoBuyRecommendedIndex
integer array AutoBuyRecommendedUnitId
boolean array AutoBuyRecommendedDone
integer array PlayerDamagePhys
    integer array PlayerDamageMag
    real array PlayerDamageTakenPhys
    framehandle main_frame
    real array PlayerDamageTakenMag
integer array PlayerDamagePhysAll
    integer array PlayerDamageMagAll
    real array PlayerDamageTakenPhysAll
    real array PlayerDamageTakenMagAll
real udg_DamageTypePure =1
real udg_NextDamageType =1
timer AntiMh 
unit pricesell
framehandle lmpOpenButton
framehandle lmpLinkButton
integer array PlayerVisualSlot
//boolean QuincyCrossDamageActive
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
real Armor 
unit priceshop
real Test_real
integer array PlayerHeal
integer array PlayerHealAll
string array FramePlayerFirstName
integer CondArena = 1
integer array PlayerKill
integer array PlayerDeath
integer array ItemsPage0_ID
integer array ItemsFrameCurrentPage_ID
integer array ItemsCraftPlayerDebug_ID

boolean array FRAME_StatusHeroStringPlayerShowBoolean
endglobals

library AAAAAAA 

function FormatK takes integer c returns string
return ""
endfunction
endlibrary
function Trig_Start_Actions4 takes nothing returns nothing
local integer i = 0 // 0 - красный игрок
local integer i2 = 0
set ShowDmgTestText = true
set hs = InitHashtable()
loop
    exitwhen i2 == bj_MAX_PLAYERS 
    if GetLocalPlayer() == Player(i2) then
        if GetSoundFileDuration("war3mapImported\\11.mp3") > 0 then
        //    call BJDebugMsg("Player " + I2S(i2) + " has sound")
        else
     //      call BJDebugMsg("Player " + I2S(i2) + " does NOT have sound")
        endif
    endif
    set i2 = i2 + 1
endloop

if Hero[i] == null then 
set Hero[i] = CreateUnit(Player(0),'H00A',1,1,270)
//call MahoragaTInfo_Start(Hero[i],true)
//call BlzSetUnitSkin(Hero[i],Ulquiorra_Morph3_ID)
call SetHeroLevel(Hero[i],35,false)
endif
call BlzLoadTOCFile("war3mapImported\\Templates.TOC")
//call InoriE_Start(Hero[i])
//call TriggerRegisterPlayerUnitEvent(gg_trg_CastCheck, Player(i), EVENT_PLAYER_UNIT_SPELL_EFFECT, null)
//call SaveInteger(hs, GetHandleId(GetOwningPlayer(Hero[i])), StringHash("ulq tt"),1)
call SetHpCurrent(Hero[i],9999)
call SetMpCurrent(Hero[i],9999)
call FogEnable(false)
call FogMaskEnable(false)
call TasAbilityChargeBox_Init()
//call UnitAddAbility(Hero[i],G_ID)
call UnitAddAbility(Hero[i],F_ID)
call UnitAddAbility(Hero[i],Q_ID)
call UnitAddAbility(Hero[i],W_ID)
call UnitAddAbility(Hero[i],E_ID)
call UnitAddAbility(Hero[i],R_ID)
call UnitAddAbility(Hero[i],T_ID)
call UnitAddAbility(Hero[i],G_ID)
call UnitMakeAbilityPermanent(Hero[i],true,Q_ID)
call UnitMakeAbilityPermanent(Hero[i],true,W_ID)
call UnitMakeAbilityPermanent(Hero[i],true,E_ID)
call UnitMakeAbilityPermanent(Hero[i],true,R_ID)
call UnitMakeAbilityPermanent(Hero[i],true,T_ID)
call UnitMakeAbilityPermanent(Hero[i],true,G_ID)
call UnitMakeAbilityPermanent(Hero[i],true,F_ID)
//call SaveInteger(hs, GetHandleId(Hero[i]), StringHash("stack_count"), 6)
//call MySpellStacksForAbility(Hero[i], AinzQ_ID, 0, 6, 5.00)
//call TsunaF_Start(Hero[i])
//call TriggerAddAction(InoriFrameTrig1 , function OnClickInori)
//call BJDebugMsg(I2S(BlzGetLocalClientHeight()))
//call BJDebugMsg(I2S(BlzGetLocalClientWidth()))
//call UnitAddAbility(Hero[i],AstaSword_ID)
 set NoDecor_Cond=Condition(function NoDecor_Filter)
if GetLocalPlayer() == Player(i) then 
call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,4000,1)
call SelectUnit(Hero[i],true) // выбор ichigo 
call PanCameraToTimed(GetUnitX(Hero[i]),GetUnitY(Hero[i]),1)
endif 
endfunction
function Trig_Start_Actions3 takes nothing returns nothing
local integer i = 0 // 0 - красный игрок
call UnitResetCooldown(Hero[i])
call ClearTextMessages()
call SetHpCurrent(Hero[i],9999)
call SetMpCurrent(Hero[i],9999)
if GetUnitTypeId(Hero[i]) == Tomioka_ID then 
call SaveInteger(hs,GetHandleId(Hero[i]),StringHash("tomioka esc"),1)
endif
/*if LLL == 0 then 
set LLL = 1
call BJDebugMsg("1")
if GetLocalPlayer() == Player(0) then 
call EnableUserControl(false)
endif
else
call BJDebugMsg("2")
set LLL = 0
if GetLocalPlayer() == Player(0) then 
call EnableUserControl(true)
endif
endif*/
if IsUnitType(Hero[i],UNIT_TYPE_DEAD) then
call ReviveHero(Hero[i],GetUnitX(Hero[i]),GetUnitY(Hero[i]),false)
endif
if GetLocalPlayer() == Player(i) then 
call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,4000,1)
endif 
//call BlzSetUnitAbilityCooldown(Hero[i],'A000',0,2)
//call BJDebugMsg(R2S(BlzGetUnitAbilityCooldown(Hero[i],'A000',0)))
endfunction
function Trig_Start_Actions2 takes nothing returns nothing
local integer i = 0 // 0 - красный игрок
if GetLocalPlayer() == Player(i) then 
call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,4000,1)
call SelectUnit(Hero[i],true) // выбор ichigo 
call PanCameraToTimed(GetUnitX(Hero[i]),GetUnitY(Hero[i]),1)
endif 
endfunction

//===========================================================================
function InitTrig_Start takes nothing returns nothing
    local trigger trg = CreateTrigger()
    local trigger trg2 = CreateTrigger()
    set gg_trg_Start = CreateTrigger()
    call TriggerRegisterPlayerEvent(trg2, Player(0), EVENT_PLAYER_END_CINEMATIC)
    call TriggerAddAction( trg2, function Trig_Start_Actions3 )
    
    call TriggerRegisterTimerEvent(gg_trg_Start, 0.05, false)
    call TriggerAddAction( gg_trg_Start, function Trig_Start_Actions4 )
    
    call TriggerRegisterPlayerEvent(trg, Player(0), EVENT_PLAYER_ARROW_UP_DOWN)    
    call TriggerAddAction( trg, function Trig_Start_Actions2 )
    set trg = null
    set trg2 = null
endfunction

