globals
unit array lvl_6
integer lvl_6_id = 0//'h00T'
unit array lvl_12
integer lvl_12_id = 0//'h002'
unit array lvl_25
integer lvl_25_id = 0//'h00C'
unit array lvl_35
integer lvl_35_id = 0//'h011'
endglobals 
function Trig_LvlUpCheck_Actions takes nothing returns nothing
local integer i = GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
local integer k = GetHeroLevel(GetTriggerUnit())
local integer k2 = 0
local unit c = GetTriggerUnit()
local integer id = GetUnitTypeId(c)
local real hp = GetUnitState(GetTriggerUnit(),UNIT_STATE_LIFE)/GetUnitState(GetTriggerUnit(),UNIT_STATE_MAX_LIFE)
if (CheckAllow1(GetTriggerUnit()) or CheckAllow2(GetTriggerUnit()) ) and LoadInteger(hs,GetHandleId(GetOwningPlayer(GetTriggerUnit())),StringHash("cast allow"))== 0 and IsUnitIllusion(GetTriggerUnit())== false then 
    call SaveInteger(hs,GetHandleId(GetOwningPlayer(GetTriggerUnit())),StringHash("cast allow"),1)
    call TriggerRegisterPlayerUnitEvent(gg_trg_CastCheck, GetOwningPlayer(GetTriggerUnit()), EVENT_PLAYER_UNIT_SPELL_EFFECT, null)
    endif
    /*
    if k >= 6 and lvl_6[i] == null then 
    set lvl_6[i] = CreateUnit(Player(i),lvl_6_id,GetRectCenterX(gg_rct_Caster),GetRectCenterY(gg_rct_Caster),1)
    endif
    if k >= 12 and lvl_12[i] == null then 
    set lvl_12[i] = CreateUnit(Player(i),lvl_12_id,GetRectCenterX(gg_rct_Caster),GetRectCenterY(gg_rct_Caster),1)
    endif
    if k >= 25 and lvl_25[i] == null then 
    set lvl_25[i] = CreateUnit(Player(i),lvl_25_id,GetRectCenterX(gg_rct_Caster),GetRectCenterY(gg_rct_Caster),1)
    endif
    if k >= 35 and lvl_35[i] == null then 
    set lvl_35[i] = CreateUnit(Player(i),lvl_35_id,GetRectCenterX(gg_rct_Caster),GetRectCenterY(gg_rct_Caster),1)
    endif
    set k2 = k-level_id[i] 
    set level_id[i]  = k    
    if k <= 12 then 
    call BlzSetUnitMaxHP(GetTriggerUnit(),BlzGetUnitMaxHP(GetTriggerUnit())+55*k2)
    else 
    call BlzSetUnitMaxHP(GetTriggerUnit(),BlzGetUnitMaxHP(GetTriggerUnit())+280*k2)
    endif
    call BlzSetUnitMaxMana(GetTriggerUnit(),BlzGetUnitMaxMana(GetTriggerUnit())+7*k2)
    call SetUnitState(GetTriggerUnit(),UNIT_STATE_LIFE,hp*GetUnitState(GetTriggerUnit(),UNIT_STATE_MAX_LIFE))
    if Natsu_ID == id and GetUnitAbilityLevel(c,NatsuF_ID) == 0 then 
    call UnitAddAbility(c,NatsuF_ID)
    call UnitMakeAbilityPermanent(c,true,NatsuF_ID)
    endif
    if Natsu_ID == id and GetUnitAbilityLevel(c,NatsuG_ID) == 0 then 
    call UnitAddAbility(c,NatsuG_ID)
    call UnitMakeAbilityPermanent(c,true,NatsuG_ID)
    endif
    if Gojo_ID == id then 
    if GetUnitAbilityLevel(c,GojoG_ID) == 0 then 
    call UnitAddAbility(c,GojoG_ID)
    call UnitMakeAbilityPermanent(c,true,GojoG_ID)
    endif
    if GetHeroLevel(c)>=35 then 
    call BlzSetAbilityRealLevelField(BlzGetUnitAbility(c, GojoR_ID),ABILITY_RLF_AREA_OF_EFFECT, 4, 1250)
    endif
    endif
    if Tomioka_ID == id and GetUnitAbilityLevel(c,TomiokaG_ID) == 0 then 
    call UnitAddAbility(c,TomiokaG_ID)
    call UnitMakeAbilityPermanent(c,true,TomiokaG_ID)
    endif
    if Kenjaku_ID == id and GetUnitAbilityLevel(c,KenjakuG_ID) == 0 then 
    call UnitAddAbility(c,KenjakuG_ID)
    call UnitMakeAbilityPermanent(c,true,KenjakuG_ID)
    call UnitAddAbility(c,KenjakuF_ID)
    call UnitMakeAbilityPermanent(c,true,KenjakuF_ID)
    call KenjakuF2_Start(c)
    endif
    if Rimuru_ID == id and GetHeroLevel(c)>= 25 and  LoadInteger(hs,GetHandleId(c),StringHash("pas start")) ==0  then 
    call RimuruEvol_Start(c,true)
     call SaveInteger(hs,GetHandleId(c),StringHash("pas start"),1)
    endif
    if Inori_ID == id then 
    if k>= 6 and  LoadInteger(hs,GetHandleId(c),StringHash("pas start"))==0 then 
    call SaveInteger(hs,GetHandleId(c),StringHash("pas start"),1)
    call InoriE_Start(c)
    endif
    
    if GetUnitAbilityLevel(c,InoriG_ID) == 0 then 
    call UnitAddAbility(c,InoriG_ID)
    call UnitMakeAbilityPermanent(c,true,InoriG_ID)
    call UnitAddAbility(c,InoriF_ID)
    call UnitMakeAbilityPermanent(c,true,InoriF_ID)
    endif
    endif
    if Erza_ID == id and GetUnitAbilityLevel(c,ErzaF_ID) == 0 then 
    call UnitAddAbility(c,ErzaF_ID)
    call UnitMakeAbilityPermanent(c,true,ErzaF_ID)
    call UnitAddAbility(c,ErzaG_ID)
    call UnitMakeAbilityPermanent(c,true,ErzaG_ID)
    endif
    if Erza_ID == id and GetHeroLevel(c)>=35 and GetUnitAbilityLevel(c,ErzaG2_ID) == 0 then 
    call UnitAddAbility(c,ErzaG2_ID)
    call UnitMakeAbilityPermanent(c,true,ErzaG2_ID)
    if LoadInteger(hs, GetHandleId(c), StringHash("q armor active")) == 1 or LoadInteger(hs, GetHandleId(c), StringHash("w armor active")) == 1 or LoadInteger(hs, GetHandleId(c), StringHash("e armor active")) == 1 or LoadInteger(hs, GetHandleId(c), StringHash("r armor active")) == 1 or LoadInteger(hs, GetHandleId(c), StringHash("t armor active")) == 1 then
    call SetPlayerAbilityAvailable(GetOwningPlayer(c),ErzaG2_ID,false)
    else
    call SetPlayerAbilityAvailable(GetOwningPlayer(c),ErzaG_ID,false)
    endif
    call ErzaBar(c)
    endif
    if Tomioka_ID == id and GetUnitAbilityLevel(c,TomiokaF_ID) == 0 then 
    call UnitAddAbility(c,TomiokaF_ID)
    call UnitMakeAbilityPermanent(c,true,TomiokaF_ID)
    endif
    if Okarun_ID == id then 
    if  GetUnitAbilityLevel(c,OkarunF_ID) == 0 then 
    call UnitAddAbility(c,OkarunF_ID)
    call UnitMakeAbilityPermanent(c,true,OkarunF_ID)
    endif
    if LoadInteger(hs,GetHandleId(c),StringHash("pas start")) == 0 and GetHeroLevel(c)>= 6 then 
    call OkarunPassive_Start(c)
    call SaveInteger(hs,GetHandleId(c),StringHash("pas start"),1)
    endif
    endif
    if Kyoraku_ID == id and GetUnitAbilityLevel(c,KyorakuF_ID) == 0 then 
    call UnitAddAbility(c,KyorakuF_ID)
    call UnitMakeAbilityPermanent(c,true,KyorakuF_ID)
    endif
    if AlterSaber_ID == id then 
    if GetUnitAbilityLevel(c,AlterSaberF_ID) == 0 then 
    call UnitAddAbility(c,AlterSaberF_ID)
    call UnitMakeAbilityPermanent(c,true,AlterSaberF_ID)
    call UnitAddAbility(c,AlterSaberG_ID)
    call UnitMakeAbilityPermanent(c,true,AlterSaberG_ID)
    endif    
    if GetHeroLevel(c)>=35 then 
    call SetUnitAbilityLevel(c,AlterSaberG_ID,3)
    elseif GetHeroLevel(c)>=25 then 
    call SetUnitAbilityLevel(c,AlterSaberG_ID,2)
    endif
    endif
    if Tsuna_ID == id then 
    if GetUnitAbilityLevel(c,TsunaF_ID) == 0 then 
    call UnitAddAbility(c,TsunaF_ID)
    call UnitMakeAbilityPermanent(c,true,TsunaF_ID)
    call UnitAddAbility(c,TsunaG_ID)
    call UnitMakeAbilityPermanent(c,true,TsunaG_ID)
    endif
    if LoadInteger(hs,GetHandleId(c),StringHash("pas start")) == 0 and GetHeroLevel(c)>= 12 then 
    call TsunaF_Start(c)
    call SaveInteger(hs,GetHandleId(c),StringHash("pas start"),1)
    endif
    endif
     if BazzB_ID == id then 
    if GetUnitAbilityLevel(c,BazzBG_ID) == 0 then 
    call UnitAddAbility(c,BazzBG_ID)
    call UnitMakeAbilityPermanent(c,true,BazzBG_ID)
    endif
    endif
    if DarkShiki_ID == id then 
    if GetUnitAbilityLevel(c,DarkShikiF_ID) == 0 then 
    call UnitAddAbility(c,DarkShikiF_ID)
    call UnitMakeAbilityPermanent(c,true,DarkShikiF_ID)
    endif
    endif
    if Takeshi_ID == id then 
    if GetUnitAbilityLevel(c,TakeshiG_ID) == 0 then 
    call UnitAddAbility(c,TakeshiG_ID)
    call UnitMakeAbilityPermanent(c,true,TakeshiG_ID)
    call UnitAddAbility(c,TakeshiF_ID)
    call UnitMakeAbilityPermanent(c,true,TakeshiF_ID)
    endif
    endif
    if Akainu_ID == id and GetUnitAbilityLevel(c,AkainuF_ID) == 0 then 
    call UnitAddAbility(c,AkainuF_ID)
    call UnitMakeAbilityPermanent(c,true,AkainuF_ID)
    endif
    if Neuvillette_ID == id and GetUnitAbilityLevel(c,NeuvilletteF_ID) == 0 then 
    call UnitAddAbility(c,NeuvilletteF_ID)
    call UnitMakeAbilityPermanent(c,true,NeuvilletteF_ID)
    endif*/
    set c = null
endfunction

//===========================================================================
function InitTrig_LvlUpCheck takes nothing returns nothing
    set gg_trg_LvlUpCheck = CreateTrigger( )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_LvlUpCheck, EVENT_PLAYER_HERO_LEVEL )
    call TriggerAddAction( gg_trg_LvlUpCheck, function Trig_LvlUpCheck_Actions )
endfunction


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
