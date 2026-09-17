globals
unit array lvl_6
integer lvl_6_id = 'h00T'
unit array lvl_10
integer lvl_10_id = 'h029'
unit array lvl_12
integer lvl_12_id = 'h002'
unit array lvl_25
integer lvl_25_id = 'h00C'
unit array lvl_35
integer lvl_35_id = 'h011'
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
    if k >= 6 and lvl_6[i] == null then 
    set lvl_6[i] = CreateUnit(Player(i),lvl_6_id,GetRectCenterX(gg_rct_Caster),GetRectCenterY(gg_rct_Caster),1)
    endif
    if k >= 10 and lvl_10[i] == null then 
    set lvl_10[i] = CreateUnit(Player(i),lvl_10_id,GetRectCenterX(gg_rct_Caster),GetRectCenterY(gg_rct_Caster),1)
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
    set k2 = k - level_id[i]
    set level_id[i] = k
    // Формула: старт 20 HP на 1-м уровне, шаг +7.227 HP за каждый следующий уровень
   if k >= 3 then
    call BlzSetUnitMaxHP(GetTriggerUnit(), BlzGetUnitMaxHP(GetTriggerUnit()) + R2I(85.0 + (7 * (k - 1)) * k2))
endif
  //  call BlzSetUnitMaxHP(GetTriggerUnit(), BlzGetUnitMaxHP(GetTriggerUnit()) + R2I((150.0 - 3.0 * (k - 1)) * k2))
  //  call BlzSetUnitMaxMana(GetTriggerUnit(), BlzGetUnitMaxMana(GetTriggerUnit()) + 5 * k2)
    call SetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE, hp * GetUnitState(GetTriggerUnit(), UNIT_STATE_MAX_LIFE))
    if Natsu_ID == id and GetUnitAbilityLevel(c,NatsuF_ID) == 0 then 
    call UnitAddAbility(c,NatsuF_ID)
    call UnitMakeAbilityPermanent(c,true,NatsuF_ID)
    endif
    if Natsu_ID == id and GetUnitAbilityLevel(c,NatsuG_ID) == 0 then 
    call UnitAddAbility(c,NatsuG_ID)
    call UnitMakeAbilityPermanent(c,true,NatsuG_ID)
    endif
    if Frieren_ID == id and GetUnitAbilityLevel(c,FrierenG_ID) == 0 then 
    call UnitAddAbility(c,FrierenF_ID)
    call UnitMakeAbilityPermanent(c,true,FrierenF_ID)
    call UnitAddAbility(c,FrierenG_ID)
    call UnitMakeAbilityPermanent(c,true,FrierenG_ID)
    endif
    if Starrk_ID == id and GetUnitAbilityLevel(c,StarrkG_ID) == 0 then 
    call UnitAddAbility(c,StarrkG_ID)
    call UnitMakeAbilityPermanent(c,true,StarrkG_ID)
    endif
    if Mahoraga_ID == id then 
    if GetUnitAbilityLevel(c,MahoragaG_ID) == 0 then 
    call UnitAddAbility(c,MahoragaF_ID)
    call UnitMakeAbilityPermanent(c,true,MahoragaF_ID)
    call UnitAddAbility(c,MahoragaG_ID)
    call UnitMakeAbilityPermanent(c,true,MahoragaG_ID)
    endif
    if LoadInteger(hs,GetHandleId(c),StringHash("pas start"))==0 and GetHeroLevel(c)>=25 then 
    call SaveInteger(hs,GetHandleId(c),StringHash("pas start"),1)
    call MahoragaTInfo_Start(c,true)
    endif
    endif
    if Toji_ID == id then 
    if GetUnitAbilityLevel(c,TojiG_ID) == 0 then 
    call UnitAddAbility(c,TojiF_ID)
    call UnitMakeAbilityPermanent(c,true,TojiF_ID)
    call UnitAddAbility(c,TojiG_ID)
    call UnitMakeAbilityPermanent(c,true,TojiG_ID)
    endif
    if GetHeroLevel(c)>= 12 and GetUnitAbilityLevel(c,TojiG2_ID) == 0 then 
    call UnitAddAbility(c,TojiG2_ID)
    call UnitMakeAbilityPermanent(c,true,TojiG2_ID)
    call SetPlayerAbilityAvailable(GetOwningPlayer(c),TojiG_ID,false)
    endif
    endif

if Laxus_ID == id then 
    if GetUnitAbilityLevel(c,LaxusG_ID) == 0 then 
    call UnitAddAbility(c,LaxusF_ID)
    call UnitMakeAbilityPermanent(c,true,LaxusF_ID)
    call UnitAddAbility(c,LaxusG_ID)
    call UnitMakeAbilityPermanent(c,true,LaxusG_ID)
    endif
    if GetHeroLevel(c)>= 35 then 
    call SetUnitAbilityLevel(c,LaxusG_ID,2)
     call BlzSetAbilityIcon(LaxusG_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_G2.blp")
    call SaveInteger(hs,GetHandleId(c),StringHash("lvl5"),1)
    endif
    endif
    if Kirito_ID == id then 
    if GetUnitAbilityLevel(c,KiritoG_ID) == 0 then 
    call UnitAddAbility(c,KiritoF_ID)
    call UnitMakeAbilityPermanent(c,true,KiritoF_ID)
    call UnitAddAbility(c,KiritoG_ID)
    call UnitMakeAbilityPermanent(c,true,KiritoG_ID)
    endif
    if LoadInteger(hs,GetHandleId(c),StringHash("pas start"))==0 and GetHeroLevel(c)>=25 then 
    call SaveInteger(hs,GetHandleId(c),StringHash("pas start"),1)
    call KiritoPas(c)
    endif
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
    if Bambietta_ID == id then 
    if GetUnitAbilityLevel(c,BambiettaG_ID) == 0 then 
    call UnitAddAbility(c,BambiettaG_ID)
    call UnitMakeAbilityPermanent(c,true,BambiettaG_ID)
    endif
    endif
    if Ainz_ID == id then
    if GetHeroLevel(c)>= 2 and LoadInteger(hs,GetHandleId(c),StringHash("pas start1"))==0 then 
    call SaveInteger(hs,GetHandleId(c),StringHash("pas start1"),1)
    call SaveInteger(hs, GetHandleId(c), StringHash("stack_count"), 2)
    call MySpellStacksForAbility(c, AinzQ_ID, 0, 2, 13.00)
    endif
    if GetHeroLevel(c)>= 5 and LoadInteger(hs,GetHandleId(c),StringHash("pas start2"))==0 then 
    call SaveInteger(hs,GetHandleId(c),StringHash("pas start2"),1)
    call SpellStacksSetMax(c, 3, true)
    endif
    if GetHeroLevel(c)>= 8 and LoadInteger(hs,GetHandleId(c),StringHash("pas start3"))==0 then 
    call SaveInteger(hs,GetHandleId(c),StringHash("pas start3"),1)
    call SpellStacksSetMax(c, 3, true)
    endif
    if GetHeroLevel(c)>= 11 and LoadInteger(hs,GetHandleId(c),StringHash("pas start4"))==0 then 
    call SaveInteger(hs,GetHandleId(c),StringHash("pas start4"),1)
    call SpellStacksSetMax(c, 4, true)
    endif
    if GetHeroLevel(c)>= 14 and LoadInteger(hs,GetHandleId(c),StringHash("pas start5"))==0 then 
    call SaveInteger(hs,GetHandleId(c),StringHash("pas start5"),1)
    call SpellStacksSetMax(c, 4, true)
    endif
    if GetUnitAbilityLevel(c,AinzG_ID) == 0 then 
    call UnitAddAbility(c,AinzF_ID)
    call UnitMakeAbilityPermanent(c,true,AinzF_ID)
    call UnitAddAbility(c,AinzG_ID)
    call UnitMakeAbilityPermanent(c,true,AinzG_ID)
    endif
    endif
    if Brandish_ID == id then 
    if GetUnitAbilityLevel(c,BrandishF_ID) == 0 then 
    call UnitAddAbility(c,BrandishF_ID)
    call UnitMakeAbilityPermanent(c,true,BrandishF_ID)
    endif
    endif
    if Tomioka_ID == id and GetUnitAbilityLevel(c,TomiokaG_ID) == 0 then 
    call UnitAddAbility(c,TomiokaG_ID)
    call UnitMakeAbilityPermanent(c,true,TomiokaG_ID)
    endif
    if Asta_ID == id then 
    if GetUnitAbilityLevel(c,AstaG_ID) == 0 then 
    call UnitAddAbility(c,AstaG_ID)
    call UnitMakeAbilityPermanent(c,true,AstaG_ID)
    call UnitAddAbility(c,AstaSword_ID)
    endif
    if GetUnitAbilityLevel(c,AstaF_ID) == 0 then 
    call UnitAddAbility(c,AstaF_ID)
    call UnitMakeAbilityPermanent(c,true,AstaF_ID)
    endif
    endif
    if Harribel_ID == id then 
    if GetUnitAbilityLevel(c,HarribelG_ID) == 0 then 
    call UnitAddAbility(c,HarribelG_ID)
    call UnitMakeAbilityPermanent(c,true,HarribelG_ID)
    endif
    if GetHeroLevel(c)>=12 and LoadInteger(hs,GetHandleId(c),StringHash("pas start"))==0 then 
    call SaveInteger(hs,GetHandleId(c),StringHash("pas start"),1)
    call HarribelG_Start(c)
    endif
    endif
    if Kenjaku_ID == id and GetUnitAbilityLevel(c,KenjakuG_ID) == 0 then 
    call UnitAddAbility(c,KenjakuG_ID)
    call UnitMakeAbilityPermanent(c,true,KenjakuG_ID)
    call UnitAddAbility(c,KenjakuF_ID)
    call UnitMakeAbilityPermanent(c,true,KenjakuF_ID)    
    endif
    if Alucard_ID == id then 
    if GetUnitAbilityLevel(c,AlucardG_ID) == 0 then 
    call UnitAddAbility(c,AlucardG_ID)
    call UnitMakeAbilityPermanent(c,true,AlucardG_ID)
    call UnitAddAbility(c,AlucardF_ID)
    call UnitMakeAbilityPermanent(c,true,AlucardF_ID)
    endif
    if GetHeroLevel(c)>=12 and  LoadInteger(hs,GetHandleId(c),StringHash("pas start"))==0 then 
    call SaveInteger(hs,GetHandleId(c),StringHash("pas start"),1)
    call AlucardG_Start(c)
    endif
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
    if Barragan_ID == id then 
    if GetUnitAbilityLevel(c,BarraganG_ID) == 0 then 
    call UnitAddAbility(c,BarraganG_ID)
    call UnitMakeAbilityPermanent(c,true,BarraganG_ID)
    endif
    if GetHeroLevel(c)>=12 and GetUnitAbilityLevel(c,BarraganG_ID) == 1  then 
    call SetUnitAbilityLevel(c,BarraganG_ID,2)
 //   call UnitAddAbility(c,BarraganG2_ID)
  //  call UnitMakeAbilityPermanent(c,true,BarraganG2_ID)
   // call SetPlayerAbilityAvailable(GetOwningPlayer(c),BarraganG2_ID,false)
    endif
    if GetHeroLevel(c)>=25 and GetUnitAbilityLevel(c,BarraganG_ID) == 2  then 
    call SetUnitAbilityLevel(c,BarraganG_ID,3)
    //call UnitAddAbility(c,BarraganG3_ID)
   // call UnitMakeAbilityPermanent(c,true,BarraganG3_ID)
    //call SetPlayerAbilityAvailable(GetOwningPlayer(c),BarraganG3_ID,false)
    endif
    if GetHeroLevel(c)>=35 and GetUnitAbilityLevel(c,BarraganG_ID) == 3  then
    call SetUnitAbilityLevel(c,BarraganG_ID,4)
  //  call UnitAddAbility(c,BarraganG4_ID)
   // call UnitMakeAbilityPermanent(c,true,BarraganG4_ID)
    //call SetPlayerAbilityAvailable(GetOwningPlayer(c),BarraganG4_ID,false)
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
    if Patriot_ID == id then 
    if GetUnitAbilityLevel(c,PatriotG_ID) == 0 then 
    call UnitAddAbility(c,PatriotG_ID)
    call UnitMakeAbilityPermanent(c,true,PatriotG_ID)
    call UnitAddAbility(c,PatriotF_ID)
    call UnitMakeAbilityPermanent(c,true,PatriotF_ID)
    endif
    endif
    if Raiden_ID == id then 
    if GetUnitAbilityLevel(c,RaidenG_ID) == 0 then 
    call UnitAddAbility(c,RaidenG_ID)
    call UnitMakeAbilityPermanent(c,true,RaidenG_ID)
    call UnitAddAbility(c,RaidenF_ID)
    call UnitMakeAbilityPermanent(c,true,RaidenF_ID)
    endif
    endif
    if DarkShiki_ID == id then 
    if GetUnitAbilityLevel(c,DarkShikiF_ID) == 0 then 
    call UnitAddAbility(c,DarkShikiF_ID)
    call UnitMakeAbilityPermanent(c,true,DarkShikiF_ID)
    call UnitAddAbility(c,DarkShikiG_ID)
    call UnitMakeAbilityPermanent(c,true,DarkShikiG_ID)
    endif
    endif
    if Takeshi_ID == id then 
    if GetUnitAbilityLevel(c,TakeshiG_ID) == 0 then 
    call UnitAddAbility(c,TakeshiG_ID)
    call UnitMakeAbilityPermanent(c,true,TakeshiG_ID)
    call UnitAddAbility(c,TakeshiF_ID)
    call UnitMakeAbilityPermanent(c,true,TakeshiF_ID)
    endif
    if GetHeroLevel(c)>=35 then 
    call TakeshiGAdd_Start(c,0)
    endif
    endif
    if Inori_ID == id then 
    if GetHeroLevel(c)>=6 then 
    if GetUnitAbilityLevel(c,InoriEAlt_ID) == 0 then
    call UnitAddAbility(c,InoriEAlt_ID)
    call UnitMakeAbilityPermanent(c,true,InoriEAlt_ID)
    call SetPlayerAbilityAvailable(GetOwningPlayer(c),InoriEAlt_ID,false)
    endif
    endif
    endif
    if Akainu_ID == id and GetUnitAbilityLevel(c,AkainuF_ID) == 0 then 
    call UnitAddAbility(c,AkainuF_ID)
    call UnitMakeAbilityPermanent(c,true,AkainuF_ID)
    endif
    if Rimuru_ID == id then 
    if LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 1")) == 0 and GetHeroLevel(c)>= 12 then 
    call RimuruEvol_Start(c,true)
    endif
    if LoadInteger(hs,GetHandleId(c),StringHash("s1")) == 0  then 
    call UnitAddAbility(c,RimuruG_ID)
    call UnitMakeAbilityPermanent(c,true,RimuruG_ID)
    call UnitAddAbility(c,RimuruF_ID)
    call UnitMakeAbilityPermanent(c,true,RimuruF_ID)
    call SaveInteger(hs,GetHandleId(c),StringHash("s1"),1)
    endif
    endif
    if Neuvillette_ID == id and GetUnitAbilityLevel(c,NeuvilletteF_ID) == 0 then 
    call UnitAddAbility(c,NeuvilletteF_ID)
    call UnitMakeAbilityPermanent(c,true,NeuvilletteF_ID)
    endif
    // HERO TRANSFER: Milim / LvlUpCheck
    if Milim_ID == id and GetUnitAbilityLevel(c,MilimG_ID) == 0 then
    call UnitAddAbility(c,MilimF_ID)
    call UnitMakeAbilityPermanent(c,true,MilimF_ID)
    call UnitAddAbility(c,MilimG_ID)
    call UnitMakeAbilityPermanent(c,true,MilimG_ID)
    endif
    if Milim_ID == id and GetHeroLevel(c) >= 12 then
    call MilimG_Start(c)
    endif
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
