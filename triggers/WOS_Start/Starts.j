globals
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
local real x 
local real y 
local real r = 200
local real r2 = 235
local real a = 270 *bj_DEGTORAD
local real fly = 300
local real scale = 20
if ModeSystemsInitialized then
return
endif
set ModeSystemsInitialized = true
set x = (GetRectCenterX(gg_rct_TestMode))
set y = (GetRectCenterY(gg_rct_TestMode))
call CreateTT_perm(x,y,fly,scale,"|c00FFFC01Arrow Left - create enemy on left side |r")
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01Arrow Right button - create hurt ally |r")
set r = r + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01Arrow Down button - self root for 2 sec |r")
set r = r + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01Arrow Up button - self stun 2 sec |r")
set r = r + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01ESC button - (fast press) restore cd, hp and mp (longpress 0.15sec+) give max lvl |r")
set r = r + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'-lvl X' pick your hero or enemy and write -lvl 35(for example)  |r")
set r = r + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'-X' to play animation of your hero( -0 to play first animation )  |r")
set r = r + r2 
set r = 0
set x = (GetRectCenterX(gg_rct_TestMode2))
set y = (GetRectCenterY(gg_rct_TestMode2))
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'-slow' take self slow 50% for 4 sec  |r")
set r = r + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'-silence' take self silence for 3 sec  |r")
set r = r + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'-sukuna' summon round ender sukuna on center instantly  |r")
set r = r + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'-killme' kill  your hero after few sec|r")
set r = r + r2 +50
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'-pr x'  pick your hero or enemy and write -pr 35(for example) to set 35% physical resistance|r")
set r = r + r2 +90
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'-mr x'  pick your hero or enemy and write -mr 35(for example) to set 35% magical resistance|r")
set r = r + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'-hp x'  pick your hero or enemy and write -hp 3500(for example) to set current life to this amount|r")
set r = r + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'-mp x'  pick your hero or enemy and write -mp 3500(for example) to set current mana to this amount|r")
set r = r + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01 You can pick enemy hero and open shop to buy any items to it |r")
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

    // Сначала стандартная музыка карты для всех клиентов.
    call StopMusic(false)
    call ClearMapMusic()
    call SetMapMusic("war3mapImported\\King Gnu - SPECIALZ.mp3", false, 0)
    call PlayMusic("war3mapImported\\King Gnu - SPECIALZ.mp3")

    set musicenabled = true
    set expired = null
endfunction
function CheckPickedMode takes nothing returns nothing
call DestroyTimer(GetExpiredTimer())
if PickedMode == 0 then 
call PlayersMsg("Normal Mode activated",1)
        set PickedMode = 1
        set TestMode = false
        call Map_Start()
    call DialogDisplay(Player(0), udg_ModeDialog, false)
    call DialogDestroy(udg_ModeDialog)
    if PlayersAmount <2 then
call TimerStart(CreateTimer(),1,false,function MusicInit)
    endif
endif
endfunction
function OnModeButton takes nothing returns nothing
    local button b = GetClickedButton()
    local integer k = 0
    if b == udg_TestButton then
        set PickedMode = 2
        set TestMode = true
        set CaptainMode = false
        set CaptainDraftMode = false
        set CaptainDraftPreRoundUnlimitedSwap = false
        call TestComm()
        call PlayersMsg("Test Mode activated",1)
    elseif b == udg_NormalButton then
        call PlayersMsg("Normal Mode activated",1)
        set PickedMode = 1
        set TestMode = false
        set CaptainMode = false
        set CaptainDraftMode = false
        set CaptainDraftPreRoundUnlimitedSwap = false
    elseif b == udg_CaptainButton then
        call PlayersMsg("Player Pick Mode activated",1)
        set PickedMode = 3
        set TestMode = false
        set CaptainMode = true
        set CaptainDraftMode = false
        set CaptainDraftPreRoundUnlimitedSwap = false
    elseif b == udg_CaptainDraftButton then
        call PlayersMsg("Captain Draft Mode activated",1)
        set PickedMode = 4
        set TestMode = false
        set CaptainMode = false
        set CaptainDraftMode = true
        set CaptainDraftPreRoundUnlimitedSwap = true
        call CaptainDraft_PlayConfiguredSound(CaptainDraftSoundModeStart)
    endif
    if PlayersAmount <2 then
call TimerStart(CreateTimer(),1,false,function MusicInit)
    endif
    call SetFloatGameState(GAME_STATE_TIME_OF_DAY, 8.00)
    call Map_Start()
    call DialogDisplay(Player(0), udg_ModeDialog, false)
    call DialogDestroy(udg_ModeDialog)
    if CaptainDraftMode then
        call CaptainDraft_StartFirstSideVote()
    endif
    set b = null
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
                set main_frame = BlzCreateFrameByType("BACKDROP", "SS", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 0)
             //   call BlzFrameSetAbsPoint(frame_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18)
            //    call BlzFrameSetSize(frame_pas1[k2], 0.135, 0.035)
set x = (GetRectCenterX(gg_rct_Evergreen)+700*Cos(180*bj_DEGTORAD)-115*Cos(90*bj_DEGTORAD))
set y = (GetRectCenterY(gg_rct_Evergreen)+700*Sin(180*bj_DEGTORAD)-115*Sin(90*bj_DEGTORAD))
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01Elemental debuffs + combo:|r")
set x = (GetRectCenterX(gg_rct_Evergreen)+1450*Cos(180*bj_DEGTORAD)-415*Cos(90*bj_DEGTORAD))
set y = (GetRectCenterY(gg_rct_Evergreen)+1450*Sin(180*bj_DEGTORAD)-415*Sin(90*bj_DEGTORAD))
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'Fire'- deal 40 magic dmg per sec, duration 5 sec|r")
set r = r + 110 + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'Water'- 100 dmg when apply, slow 10%, duration 5 sec|r")
set r = r + r2+60 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'Lightning'- duration 5 sec, after expires stun for 0.6 sec and burn 120 mana|r")
set x = (GetRectCenterX(gg_rct_Evergreen)+100*Cos(180*bj_DEGTORAD)-475*Cos(90*bj_DEGTORAD))
set y = (GetRectCenterY(gg_rct_Evergreen)+100*Sin(180*bj_DEGTORAD)-475*Sin(90*bj_DEGTORAD))
set r = 200
set r2 = 285
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'Fire'+'Water'- deal 1.5* Main stat dmg,duration 8 sec, increase taken physical damage by 10%|r")
set r = r + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'Fire'+'Lightning'- deal 1.5* Main stat dmg,stun 1.25, duration 2.5 sec(cant reapplied till exist)|r")
set r = r + r2 
call CreateTT_perm(x+r*Cos(a),y+r*Sin(a),fly,scale,"|c00FFFC01'Lightning + Water'- duration 5 sec, slow 10% and deal 0.4* Main stat dmg per sec|r")

    set i = 0
    set x = (GetRectCenterX(gg_rct_Chest)+300*Cos(180*bj_DEGTORAD)+150*Cos(270*bj_DEGTORAD))
    set y = (GetRectCenterY(gg_rct_Chest)+300*Sin(180*bj_DEGTORAD)+150*Sin(270*bj_DEGTORAD))
    call CreateTT_perm(x,y,650,20,"|c00FFFC01Press 'F2' to open/close statistics|r")
    set x = (GetRectCenterX(gg_rct_Evergreen)+210*Cos(180*bj_DEGTORAD)+150*Cos(90*bj_DEGTORAD))
    set y = (GetRectCenterY(gg_rct_Evergreen)+210*Sin(180*bj_DEGTORAD)+150*Sin(90*bj_DEGTORAD))
    call CreateTT_perm(x,y,650,20,"|c00FFFC01'F3'/'F4' clear/load dmg stat|r")
    set x = (GetRectCenterX(gg_rct_Evergreen)+1400*Cos(180*bj_DEGTORAD)-450*Cos(90*bj_DEGTORAD))
    set y = (GetRectCenterY(gg_rct_Evergreen)+1400*Sin(180*bj_DEGTORAD)-450*Sin(90*bj_DEGTORAD))
    set k2 = 2500
    
    set x = (GetRectCenterX(gg_rct_Shop)+150*Cos(180*bj_DEGTORAD)+45*Cos(270*bj_DEGTORAD))
    set y = (GetRectCenterY(gg_rct_Shop)+150*Sin(180*bj_DEGTORAD)+45*Sin(270*bj_DEGTORAD))
     set ShopInfo = CreateTextTag()
    call SetTextTagPos(ShopInfo, x,y, z) 
    
     call SetTextTagText(ShopInfo, "|c00FFFC01Press 'TAB' to open/close shop, USE AUTOBUY in shop if  you NEW|r", 0.02)
     call SetTextTagVisibility(ShopInfo,true)
     call SetTextTagPermanent(ShopInfo, true)
  // call SetTextTagLifespan(ShopInfo, 1)
    call SetTextTagVelocity(ShopInfo, 0, 0)
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
    set udg_ModeDialog = DialogCreate()
    set AAADestNoDecorCond = Condition(function NoDecor_Filter)
    call DialogSetMessage(udg_ModeDialog, "Pick Game Mode")
    set udg_NormalButton = DialogAddButton(udg_ModeDialog, "Normal Mode", 0)
    set udg_CaptainButton = DialogAddButton(udg_ModeDialog, "Player Pick Mode", 0)
    set udg_CaptainDraftButton = DialogAddButton(udg_ModeDialog, "Captain Draft Mode", 0)
    set udg_TestButton = DialogAddButton(udg_ModeDialog, "Test Mode", 0)
    call TriggerRegisterDialogEvent(t, udg_ModeDialog)
    call TriggerAddAction(t, function OnModeButton)
    call DialogDisplay(Player(0), udg_ModeDialog, true)
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
