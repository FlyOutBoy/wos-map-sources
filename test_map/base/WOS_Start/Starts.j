globals
    dialog udg_ModeDialog
    button udg_TestButton
    button udg_NormalButton
    boolean TestMode = false
    integer PickedMode = 0
endglobals
function CheckPickedMode takes nothing returns nothing
call DestroyTimer(GetExpiredTimer())
if PickedMode == 0 then 
call PlayersMsg("Normal Mode activated",1)
        set PickedMode = 1
        set TestMode = false
        call Map_Start()
    call DialogDisplay(Player(0), udg_ModeDialog, false)
    call DialogDestroy(udg_ModeDialog)
endif
endfunction
function OnModeButton takes nothing returns nothing
    local button b = GetClickedButton()
    local integer k = 0
    if b == udg_TestButton then
        set PickedMode = 2
        set TestMode = true
        call PlayersMsg("Test Mode activated",1)
    elseif b == udg_NormalButton then
        call PlayersMsg("Normal Mode activated",1)
        set PickedMode = 1
        set TestMode = false
    endif
    call SetFloatGameState(GAME_STATE_TIME_OF_DAY, 8.00)
    call Map_Start()
    call DialogDisplay(Player(0), udg_ModeDialog, false)
    call DialogDestroy(udg_ModeDialog)
    set b = null
endfunction
function CamSetup takes nothing returns nothing
local integer i = 0
loop
exitwhen i == bj_MAX_PLAYER_SLOTS
if Hero[i] != null then 
if CondArena == 0 then 
if CheckCoordsInRect(gg_rct_Base,GetUnitX(Hero[i]),GetUnitY(Hero[i]))==false then 
call SetUnitPosition(Hero[i],GetRectCenterX(gg_rct_Pick),GetRectCenterY(gg_rct_Pick))
endif
call LearnHeroSpells(Hero[i])
if GetUnitAbilityLevel(Hero[i],'Avul') == 0 then 
call UnitAddAbility(Hero[i],'Avul')
endif
endif
endif
if GetLocalPlayer() == Player(i) then
call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, CameraSetup[i], 0)
call SetCameraField(CAMERA_FIELD_FARZ, 50000, 0)
//call SetCameraField(CAMERA_FIELD_ZOFFSET, 1000, 0)
//call SetCameraField( CAMERA_FIELD_, 100000, 0 )
endif
set i = i + 1
endloop
endfunction
function InitTrig_ModeDialog takes nothing returns nothing
    local trigger t = CreateTrigger()
    local real x  
    local real y 
    local real z  = 650
    local integer i = 0
    set x = (GetRectCenterX(gg_rct_Shop)+150*Cos(180*bj_DEGTORAD)+45*Cos(270*bj_DEGTORAD))
    set y = (GetRectCenterY(gg_rct_Shop)+150*Sin(180*bj_DEGTORAD)+45*Sin(270*bj_DEGTORAD))
    set ShopInfo = CreateTextTag()
    call SetTextTagPos(ShopInfo, x,y, z) 
    call SetTextTagText(ShopInfo, "|c00FFFC01Press 'TAB' to open/close shop|r", 0.02)
    call SetTextTagPermanent(ShopInfo, true) 
    call SetTextTagVisibility(ShopInfo,true)
    set hs = InitHashtable()
    set x = (GetRectCenterX(gg_rct_Chest)+300*Cos(180*bj_DEGTORAD)+150*Cos(270*bj_DEGTORAD))
    set y = (GetRectCenterY(gg_rct_Chest)+300*Sin(180*bj_DEGTORAD)+150*Sin(270*bj_DEGTORAD))
    call CreateTT_perm(x,y,650,20,"|c00FFFC01Press 'F2' to open/close statistics|r")
    set x = (GetRectCenterX(gg_rct_Evergreen)+210*Cos(180*bj_DEGTORAD)+150*Cos(90*bj_DEGTORAD))
    set y = (GetRectCenterY(gg_rct_Evergreen)+210*Sin(180*bj_DEGTORAD)+150*Sin(90*bj_DEGTORAD))
    call CreateTT_perm(x,y,650,20,"|c00FFFC01'F3'/'F4' clear/load dmg stat|r")
loop
exitwhen i == bj_MAX_PLAYER_SLOTS
set CameraSetup[i] = BaseCam
set Shop_Active[i] = false
set Hero[i] = null
if GetLocalPlayer() == Player(i) then
call SetCameraField( CAMERA_FIELD_TARGET_DISTANCE, CameraSetup[i], 0 )
endif
set i = i + 1
endloop
    set udg_ModeDialog = DialogCreate()
    call DialogSetMessage(udg_ModeDialog, "Pick Game Mode")
    set udg_NormalButton = DialogAddButton(udg_ModeDialog, "Normal Mode", 0)
    set udg_TestButton = DialogAddButton(udg_ModeDialog, "Test Mode", 0)
    call TriggerRegisterDialogEvent(t, udg_ModeDialog)
    call TriggerAddAction(t, function OnModeButton)
    call DialogDisplay(Player(0), udg_ModeDialog, true)
    call TimerStart(CreateTimer(),20,false,function CheckPickedMode )
    call TimerStart(CreateTimer(),0.25,true,function CamSetup )
    call FogMaskEnable(false)
   /* call StopMusic(true)
call ClearMapMusic()
call StopMusic(false)
call SetMapMusic("war3mapImported\\King Gnu - SPECIALZ.mp3",false,0)
call PlayMusic("war3mapImported\\King Gnu - SPECIALZ.mp3")*/
endfunction
//===========================================================================
function InitTrig_Starts takes nothing returns nothing
    set gg_trg_Starts = CreateTrigger(  )
    call TriggerRegisterTimerEvent(gg_trg_Starts, 3, false)
    call TriggerAddAction( gg_trg_Starts, function InitTrig_ModeDialog )
endfunction

