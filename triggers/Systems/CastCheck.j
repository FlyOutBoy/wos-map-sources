globals 
real ahk_delay = 0.06
endglobals
function DisableMoveRoot takes unit c, integer id returns boolean 
local boolean b = true
local integer idc = GetUnitTypeId(c)
if GetUnitAbilityLevel(c,'BEer') >0 then
if id == 'A01B' or id == 'A076' or id == 'A00Y' or id == OkarunQ_ID or id == GojoRQ_ID or id == Erza4W_Start or id == Erza5E_ID or id == Erza7W_ID then 
 set b = false
endif
if id == KyorakuW_ID then 
if GetHeroLevel(c)<35 then
set b = false
endif
endif
if id == TomiokaW_ID or id == AlterSaberQ_ID or id == Erza1W_ID or id == Erza1Q_ID or id == Erza2E_ID or id == Erza2R_ID or id == KyorakuQ_ID  or id == InoriF_ID then 
 set b = false
endif
if id == TsunaQ_ID or id == TsunaQ2_ID or id == TakeshiQ_ID or id == TakeshiE_ID or id == TakeshiGQ_ID  or id == DarkShikiQ_ID or id == KiritoQ_ID or id == KiritoF_ID or id == KiritoR2_ID  then 
 set b = false
endif
if id == DarkShikiQ2_ID or id == Erza4W_ID or id == RimuruW2_ID or id == AstaW2_ID or id == AstaW_ID  or id == TojiE_ID or id == AstaE_ID or id == BarraganE2_ID or id == StarrkE2_ID  then 
 set b = false
endif
if (id == BambiettaW_ID and LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) > 0) then 
 set b = false
endif
if idc == Raiden_ID then 
if id == RaidenQ_ID  then 
set b = false
endif
          
endif


 endif
 return b 
endfunction
function SpellExtension takes unit c, integer id returns boolean
local integer check = 0
if GetUnitTypeId(c) == Kenjaku_ID and id == KenjakuG_ID then
set check = 1
endif
if GetUnitTypeId(c) == Patriot_ID and id == PatriotE_ID then
set check = 1
endif
if id == 'A0BZ' then
set check = 1
endif
if id == 'A0FD' or  id == 'A0G1' or  id == 'A0G0' then
set check = 1
endif
if GetUnitTypeId(c) == Inori_ID and id == InoriG_ID then
set check = 1
endif
if GetUnitTypeId(c) == Takeshi_ID and id == TakeshiF_ID then
set check = 1
endif
if GetUnitTypeId(c) == Rimuru_ID and id == RimuruG3_ID then
set check = 1
endif
return check == 1
endfunction
function CastHero_Conditions takes nothing returns boolean
    local integer check = 0
    local unit c = GetSpellAbilityUnit()
    local unit td = GetSpellTargetUnit()
    local real x = GetSpellTargetX()
    local real y = GetSpellTargetY()
    local integer id = GetSpellAbilityId()
    local real rr = 0
    local real cdReduce = 0
    local boolean b = DisableMoveRoot(c,id)
    local integer i2 = 0
    local integer i = GetPlayerId(GetOwningPlayer(c))
    local integer cd = LoadInteger(hs,GetHandleId(Player(i)),StringHash("ahk pidor"))    
if  IsUnitType(c,UNIT_TYPE_HERO) and b then //(cd == 0  ) and
//call SaveInteger(hs,GetHandleId(Player(i)),StringHash("ahk pidor"),1)
//call MyFlush(GetHandleId(Player(i)),StringHash("ahk pidor"),0,ahk_delay )
    if (CheckCoordsInRect(gg_rct_Base,GetUnitX(c),GetUnitY(c)) == false and CheckCoordsInRect(gg_rct_Cage,GetUnitX(c),GetUnitY(c)) == false) or SpellExtension(c,id) then 
    call ItemsCast(c,td,x,y,id)
    if GetUnitTypeId(c) == Raiden_ID then 
    if id == RaidenQ_ID then 
    call RaidenQ_Start(c,x,y)
    set check = 1
    elseif id == RaidenW_ID then 
    call RaidenW_Start(c)
    set check = 1
    elseif id == RaidenE_ID then 
    set check = 1
    call RaidenE_Start(c,x,y)
    elseif id == RaidenR_ID then 
    set check = 1
    call RaidenR_Start(c,x,y)
    elseif id == RaidenT_ID then 
    set check = 1
    call RaidenT_Start(c)
    elseif id == RaidenTT_ID then 
    set check = 1
    call RaidenTT_Start(c)
     elseif id == RaidenF_ID then 
    call RaidenF_Start(c,td)
    set check = 1
    endif
    endif
    if GetUnitTypeId(c) == Natsu_ID then 
    if id == NatsuQ_ID then
    set check = 1
    call NatsuQ_Start(c,x,y)
    elseif id == NatsuW_ID then  
    set check = 1
    call NatsuW_Start(c,td)
    elseif id == NatsuE_ID then  
    set check = 1
    call NatsuE_Start(c,x,y)
    elseif id == NatsuR_ID then  
    set check = 1
    call NatsuR_Start(c,td)
    elseif id == NatsuT_ID then  
    set check = 1
    call NatsuT_Start(c,x,y)
    elseif id == NatsuG_ID then  
    set check = 1
    call NatsuG_Start(c)
    elseif id == NatsuG2_ID then  
    set check = 1
    call NatsuG2_Start(c)
    elseif id == NatsuFT_ID then  
    set check = 1
    call NatsuFT_Start(c,td)
    elseif id == NatsuFR_ID then  
    set check = 1
    call NatsuFR_Start(c,td)
    endif
    endif
     if GetUnitTypeId(c) == Gojo_ID then 
    if id == GojoQ_ID then  
    set check = 1
    call GojoQ_Start(c,x,y)
    elseif id == GojoW_ID then  
    set check = 1
    call GojoW_Start(c,x,y)
    elseif id == GojoE_ID then  
    set check = 1
    call GojoE_Start(c)
    elseif id == GojoE2_ID then  
    set check = 1
    call GojoE2_Start(c)
    elseif id == GojoRCancel_ID then 
    call GojoR2_Start(c)
    elseif id == GojoR_ID then  
    set check = 1
    call GojoR_Start(c,x,y)
    elseif id == GojoT_ID then  
    set check = 1
    call GojoT_Start(c,x,y)
    elseif id == GojoT2_ID then  
    set check = 1
    call GojoT2_Start(c)
    elseif id == GojoQ2_ID then  
    set check = 1
    call GojoQ2_Start(c,x,y)
    elseif id == GojoW2_ID then  
    set check = 1
    call GojoW2_Start(c,x,y)
    elseif id == GojoRQ_ID then  
    set check = 1
    call GojoRQ_Start(c,x,y)
    elseif id == GojoRW_ID then  
    set check = 1
    call GojoRW_Start(c,td)
    elseif id == GojoRR_ID then  
    set check = 1
    call GojoRR_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Tomioka_ID then 
    if id == TomiokaQ_ID then 
    set check = 1
    call TomiokaQ_Start(c,td)
    elseif id == TomiokaW_ID then 
    set check = 1
    call TomiokaW_Start(c,x,y)
    elseif id == TomiokaE_ID then
    set check = 1
    call TomiokaE_Start(c,td)
    elseif id == TomiokaR_ID then 
    set check = 1
    call TomiokaR_Start(c)
    elseif id == TomiokaT_ID then
    set check = 1
    call TomiokaT_Start(c,td)
    elseif id == TomiokaF_ID then 
    set check = 1
    call TomiokaF_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == AlterSaber_ID then 
    if id == AlterSaberQ_ID then 
    set check = 1
    call AlterSaberQ_Start(c,x,y)
    elseif id == AlterSaberW2_ID then 
    set check = 1
    call AlterSaberW2_Start(c,x,y)
    elseif id == AlterSaberW_ID then 
    set check = 1
    call AlterSaberComboW_Start(c,td)
    elseif id == AlterSaberComboE_ID then 
    set check = 1
    call AlterSaberComboE_Start(c,td)
    elseif id == AlterSaberE_ID then 
    set check = 1
    call AlterSaberE_Start(c)
    elseif id == AlterSaberR_ID then 
    set check = 1
    call AlterSaberR_Start(c)
    elseif id == AlterSaberT_ID then 
    set check = 1
    call AlterSaberT_Start(c,x,y)
    elseif id == AlterSaberRR_ID then 
    set check = 1
    call AlterSaberRR_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Erza_ID then 
    if id == ErzaQ_ID then 
    call ErzaQ_Start(c)
    elseif id == ErzaW_ID then 
    call ErzaW_Start(c)
    elseif id == ErzaE_ID then 
    call ErzaE_Start(c)
    elseif id == ErzaR_ID then 
    call ErzaR_Start(c)
    elseif id == ErzaT_ID then 
    call ErzaT_Start(c)
    elseif id == ErzaF_ID then 
    call ErzaF_Start(c)
    elseif id == Erza1Q_ID then 
    set check = 1
    call Erza1Q_Start(c,x,y)
    elseif id == Erza1W_ID then 
    set check = 1
    call Erza1W_Start(c,x,y)
    elseif id == Erza1R_ID then 
    set check = 1
    call Erza1R_Start(c)
    elseif id == Erza1T_ID then 
    set check = 1
    call Erza1T_Start(c,td)
    elseif id == Erza2Q_ID then 
    set check = 1
    call Erza2Q_Start(c,td)
    elseif id == Erza2W_ID then 
    set check = 1
    call Erza2W_Start(c)
    elseif id == Erza2E_ID then 
    set check = 1
    call Erza2E_Start(c,x,y)
    elseif id == Erza2R_ID then 
    set check = 1
    call Erza2R_Start(c,x,y)
    elseif id == Erza2T_ID then 
    set check = 1
    call Erza2T_Start(c,td)
    elseif id == Erza3Q_ID then 
    set check = 1
    call Erza3Q_Start(c,x,y)
    elseif id == Erza3W_ID then 
    set check = 1
    call Erza3W_Start(c)
    elseif id == Erza3E_ID then 
    set check = 1
    call Erza3E_Start(c)
    elseif id == Erza3R_ID then 
    set check = 1
    call Erza3R_Start(c,x,y)
    elseif id == Erza3T_ID then 
    set check = 1
    call Erza3T_Start(c,x,y)
    elseif id == Erza4Q_ID then 
    set check = 1
    call Erza4Q_Start(c,td)
    elseif id == Erza4F_ID then 
    set check = 1
    call Erza4F_Start(c)
    elseif id == Erza4W_ID then 
    set check = 1
    call Erza4W_Start(c,x,y)
    elseif id == Erza4E_ID then 
    set check = 1
    call Erza4E_Start(c)
    elseif id == Erza4R_ID then 
    set check = 1
    call Erza4R_Start(c,td)
    elseif id == Erza4T_ID then 
    set check = 1
    call Erza4T_Start(c,td)
    elseif id == Erza5Q_ID then 
    set check = 1
    call Erza5Q_Start(c,td)
    elseif id == Erza5F_ID then 
    set check = 1
    call Erza5F_Start(c,x,y)
    elseif id == Erza5W_ID then 
    set check = 1
    call Erza5W_Start(c)
    elseif id == Erza5E_ID then 
    set check = 1
    call Erza5E_Start(c,x,y)
    elseif id == Erza5R_ID then 
    set check = 1
    call Erza5R_Start(c,x,y)
    elseif id == Erza5T_ID then 
    set check = 1
    call Erza5T_Start(c,td) 
    elseif id == ErzaG2_ID then 
    set check = 1
    call ErzaG2_Start(c)
    elseif id == Erza6Q_ID then 
    set check = 1
    call Erza6Q_Start(c,x,y)
    elseif id == Erza6W_ID then 
    set check = 1
    call Erza6W_Start(c)
    elseif id == Erza6E_ID then 
    set check = 1
    call Erza6E_Start(c,td)
    elseif id == Erza6R_ID then 
    set check = 1
    call Erza6R_Start(c)
    elseif id == Erza6T_ID then 
    set check = 1
    call Erza6T_Start(c,x,y)
    elseif id == Erza7Q_ID then 
    set check = 1
    call Erza7Q_Start(c,x,y)
    elseif id == Erza7W_ID then 
    set check = 1
    call Erza7W_Start(c,x,y)
    elseif id == Erza7E_ID then 
    set check = 1
    call Erza7E_Start(c,td)
    elseif id == Erza7R_ID then 
    set check = 1
    call Erza7R_Start(c)
    elseif id == Erza7T_ID then 
    set check = 1
    call Erza7T_Start(c,td)
    endif
    endif
    if GetUnitTypeId(c) == Kyoraku_ID then 
    if id == KyorakuQ_ID then 
    set check = 1
    call KyorakuQ_Start(c,x,y)
    elseif id == KyorakuQ2_ID then 
    set check = 1
    call KyorakuQ2_Start(c)
    elseif id == KyorakuW_ID then 
    set check = 1
    call KyorakuW_Start(c,x,y)
    elseif id == KyorakuW2_ID then 
    set check = 1
    call KyorakuW2_Start(c)
    elseif id == KyorakuE_ID then 
    set check = 1
    call KyorakuE_Start(c,x,y)
    elseif id == KyorakuE2_ID then 
    set check = 1
    call KyorakuWE_Start(c,td)
    elseif id == KyorakuR_ID then 
    set check = 1
    call KyorakuR_Start(c)
    elseif id == KyorakuT_ID then 
    set check = 1
    call KyorakuT_Start(c)
    elseif id == KyorakuT4_ID then 
    set check = 1
    call KyorakuT4_Start(c,td)
    elseif id == KyorakuT5_ID then 
    set check = 1
    call KyorakuT5_Start(c)
    elseif id == KyorakuTSkip_ID then 
    set check = 1
    call KyorakuTSkip_Start(c)    
    elseif id == KyorakuF_ID then 
    set check = 1
    call KyorakuF_Start(c)
    
    endif
    endif
    if GetUnitTypeId(c) == Kenjaku_ID then 
    if id == KenjakuQ_ID then 
    set check = 1
    call KenjakuQ_Start(c)
    elseif id == KenjakuQ2_ID then 
    set check = 1
    call KenjakuQ2_Start(c)
    elseif id == KenjakuQ3_ID then 
    set check = 1
    call KenjakuQ3_Start(c,x,y)
    elseif id == KenjakuW_ID then 
    set check = 1
    call KenjakuW_Start(c,td)
    elseif id == KenjakuW2_ID then 
    set check = 1
    call KenjakuW2_Start(c)
    elseif id == KenjakuW3_ID then 
    set check = 1
    call KenjakuW3_Start(c,x,y)
    elseif id == KenjakuE_ID then 
    set check = 1
    call KenjakuE_Start(c)
    elseif id == KenjakuE2_ID then 
    set check = 1
    call KenjakuE2_Start(c)
    elseif id == KenjakuE3_ID then 
    set check = 1
    call KenjakuE3_Start(c,x,y)
    elseif id == KenjakuR_ID then 
    set check = 1
    call KenjakuR_Start(c,x,y)
    elseif id == KenjakuR2_ID then 
    set check = 1
    call KenjakuR2_Start(c,x,y)
    elseif id == KenjakuT_ID then 
    set check = 1
    call KenjakuT_Start(c,x,y)
    elseif id == KenjakuF_ID then 
    set check = 1
    call KenjakuF_Start(c,td)
    elseif id == KenjakuF2_ID then 
    set check = 1
    call KenjakuF3_Start(c,td)
    elseif id == KenjakuG_ID then 
    call KenjakuG_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Inori_ID then 
    if id == InoriQ_ID then 
    call InoriQ_Start(c,x,y)
    set check = 1
    elseif id == InoriQ2_ID then 
    set check = 1
    call InoriQ2_Start(c,x,y)
    elseif id == InoriQ3_ID then 
    set check = 1
    call InoriQ3_Start(c,x,y)
    elseif id == InoriW_ID then 
    set check = 1
    call InoriW_Start(c,td)
    elseif id == InoriW2_ID then 
    set check = 1
    call InoriW2_Start(c,td)
    elseif id == InoriW3_ID then 
    set check = 1
    call InoriW3_Start(c,x,y)
    elseif id == InoriEE_ID then 
    set check = 1
    call InoriEE_Start(c)
    elseif id == InoriR_ID then 
    set check = 1
    call InoriR_Start(c,x,y)
    elseif id == InoriR2_ID then 
    set check = 1
    call InoriR2_Start(c,x,y)
    elseif id == InoriER_ID then 
    set check = 1
    call InoriER_Start(c,x,y)
    elseif id == InoriG_ID then 
    set check = 1
    call InoriG_Start(c)
    elseif id == InoriT_ID then 
    set check = 1
    call InoriT1_Start(c)
    elseif id == InoriT2_ID then 
    set check = 1
    call InoriT2_Start(c)
    elseif id == InoriT3_ID then 
    set check = 1
    call InoriT3_Start(c)
    elseif id == InoriF_ID then 
    set check = 1
    call InoriF_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Akainu_ID then 
    if id == AkainuQ_ID then 
    call AkainuQ_Start(c,td)
    set check = 1
    elseif id == AkainuW_ID then 
    set check = 1
    call AkainuW_Start(c,x,y)
    elseif id == AkainuE_ID then 
    set check = 1
    call AkainuE_Start(c,td)
    elseif id == AkainuR_ID then 
    set check = 1
    call AkainuR_Start(c,x,y)
    elseif id == AkainuT_ID then 
    set check = 1
    call AkainuT_Start(c,x,y)
    endif
    endif
    if GetUnitTypeId(c) == Okarun_ID then 
    if id == OkarunQ_ID then 
    call OkarunQ_Start(c,x,y)
    set check = 1
    elseif id == OkarunW_ID then 
    set check = 1
    call OkarunW_Start(c,td)
    elseif id == OkarunE_ID then 
    set check = 1
    call OkarunE_Start(c,td)
    elseif id == OkarunR_ID then 
    set check = 1
    call OkarunR_Start(c,x,y)
    elseif id == OkarunT_ID then 
    set check = 1
    call OkarunT_Start(c,x,y)
    endif
    endif
    if GetUnitTypeId(c) == Neuvillette_ID then 
    if id == NeuvilletteQ_ID then 
    call NeuvilletteQ_Start(c,x,y)
    set check = 1
    elseif id == NeuvilletteW_ID then 
    set check = 1
    call NeuvilletteW_Start(c,x,y)
    elseif id == NeuvilletteE_ID then 
    set check = 1
    call NeuvilletteE_Start(c,x,y)
    elseif id == NeuvilletteR_ID then 
    set check = 1
    call NeuvilletteR_Start(c,x,y)
    elseif id == NeuvilletteT_ID then 
    set check = 1
    call NeuvilletteT_Start(c)
    endif
    endif
     if GetUnitTypeId(c) == Tsuna_ID then 
    if id == TsunaQ_ID then 
    call TsunaQ_Start(c,x,y)
    set check = 1
    elseif id == TsunaW_ID then 
    call TsunaW_Start(c)
    set check = 1
    elseif id == TsunaE_ID then 
    call TsunaE_Start(c,x,y)
    set check = 1
    elseif id == TsunaR_ID then 
    call TsunaR_Start(c,td)
    set check = 1
    elseif id == TsunaT_ID then 
    call TsunaT_Start(c,x,y)
    set check = 1
    elseif id == TsunaT2_ID then 
    call TsunaT2_Start(c)
    set check = 1
    elseif id == TsunaQ2_ID then 
    call TsunaQ2_Start(c,x,y)
    set check = 1
    elseif id == TsunaW2_ID then 
    call TsunaW2_Start(c,x,y)
    set check = 1
    elseif id == TsunaW3_ID then 
    call TsunaW3_Start(c,x,y)
    set check = 1
    elseif id == TsunaE2_ID then 
    call TsunaE2_Start(c,x,y)
    set check = 1
    elseif id == TsunaR2_ID then 
    call TsunaR2_Start(c,x,y)
    set check = 1
    elseif id == TsunaT3_ID then 
    call TsunaT3_Start(c,x,y)
    set check = 1
    elseif id == TsunaG_ID then 
    call TsunaG_Start(c)
    set check = 1
    elseif id == TsunaG2_ID then 
    call TsunaG2_Start(c)
    set check = 1
    elseif id == TsunaG3_ID then 
    call TsunaG3_Start(c)
    set check = 1
    endif
    endif
    if GetUnitTypeId(c) == BazzB_ID then 
    if id == BazzBQ_ID then 
    call BazzBQ_Start(c,x,y)
    set check = 1
    elseif id == BazzBW_ID then 
    call BazzBW_Start(c,td)
    set check = 1
    elseif id == BazzBE_ID then 
    call BazzBE_Start(c)
    set check = 1
    elseif id == BazzBR_ID then 
    call BazzBR_Start(c,td)
    set check = 1
    elseif id == BazzBT_ID then 
    call BazzBT_Start(c,x,y)
    set check = 1
    endif
    endif
    if GetUnitTypeId(c) == Takeshi_ID then 
    if id == TakeshiQ_ID then 
    set check = 1
    call TakeshiQ_Start(c,x,y)
    elseif id == TakeshiQ2_ID then 
    set check = 1
    call TakeshiQ2_Start(c,x,y)
    elseif id == TakeshiQ3_ID then 
    set check = 1
    call TakeshiQ3_Start(c)
    elseif id == TakeshiW_ID then 
    set check = 1
    call TakeshiW_Start(c,x,y)
    elseif id == TakeshiW2_ID then 
    set check = 1
    call TakeshiW2_Start(c)
    elseif id == TakeshiE_ID then 
    set check = 1
    call TakeshiE_Start(c,x,y)
    elseif id == TakeshiE2_ID then 
    set check = 1
    call TakeshiE2_Start(c,td)
    elseif id == TakeshiR_ID then 
    set check = 1
    call TakeshiR_Start(c,td)
    elseif id == TakeshiR2_ID then 
    set check = 1
    call TakeshiR2_Start(c)
    elseif id == TakeshiT_ID then 
    set check = 1
    call TakeshiT_Start(c,x,y)
    elseif id == TakeshiGQ_ID then 
    set check = 1
    call TakeshiGQ_Start(c,x,y)
    elseif id == TakeshiGW_ID then 
    set check = 1
    call TakeshiGW_Start(c,td)
    elseif id == TakeshiGE_ID then 
    set check = 1
    call TakeshiGE_Start(c)
    elseif id == TakeshiGR_ID then 
    set check = 1
    call TakeshiGR_Start(c)
    elseif id == TakeshiGF_ID then 
    set check = 1
    call TakeshiGF_Start(c,td)
    elseif id == TakeshiG_ID then 
    set check = 1
    call TakeshiG_Start(c)
    elseif id == TakeshiF_ID then 
    call TakeshiF_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == DarkShiki_ID then 
    if id == DarkShikiQ_ID then 
    set check = 1
    call DarkShikiQ_Start(c,x,y)
    elseif id == DarkShikiQ2_ID then 
    set check = 1
    call DarkShikiQ2_Start(c)
    elseif id == DarkShikiW_ID then 
    set check = 1
    call DarkShikiW_Start(c,td)
    elseif id == DarkShikiE_ID then 
    set check = 1
    call DarkShikiE_Start(c,td)
    elseif id == DarkShikiR_ID then 
    set check = 1
    call DarkShikiR_Start(c,x,y)
    elseif id == DarkShikiT_ID then 
    set check = 1
    call DarkShikiT_Start(c,td)
    elseif id == DarkShikiG_ID then 
    set check = 1
    call DarkShikiG_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Rimuru_ID then 
    if id == RimuruQ_ID then 
    call RimuruQ_Start(c,x,y)
    set check = 1
    elseif id == RimuruW_ID then 
    set check = 1
    call RimuruW_Start(c,td)
    elseif id == RimuruE_ID then 
    set check = 1
    call RimuruE_Start(c,x,y)
    elseif id == RimuruR_ID then 
    set check = 1
    call RimuruR_Start(c,td)
    elseif id == RimuruT_ID then 
    set check = 1
    call RimuruT_Start(c,x,y)
    elseif id == RimuruQ2_ID then 
    set check = 1
    call Rimuru2Q_Start(c)
    elseif id == RimuruW2_ID then 
    set check = 1
    call Rimuru2W_Start(c,x,y)
    elseif id == RimuruE2_ID then 
    set check = 1
    call Rimuru2E_Start(c,x,y)
    elseif id == RimuruR2_ID then 
    set check = 1
    call Rimuru2R_Start(c,x,y)
    elseif id == RimuruT2_ID then 
    set check = 1
    call Rimuru2T_Start(c,x,y)
    elseif id == RimuruF2_ID then 
    set check = 1
    call Rimuru2F_Start(c,x,y)
    elseif id == RimuruQ3_ID then 
    set check = 1
    call Rimuru3Q_Start(c,td)
    elseif id == RimuruW3_ID then 
    set check = 1
    call Rimuru3W_Start(c,x,y)
    elseif id == RimuruE3_ID then 
    set check = 1
    call Rimuru3E_Start(c,x,y)
    elseif id == RimuruE4_ID then 
    set check = 1
    call Rimuru3E2_Start(c,x,y)
    elseif id == RimuruE5_ID then 
    set check = 1
    call Rimuru3E3_Start(c,x,y)
    elseif id == RimuruR3_ID then 
    set check = 1
    call Rimuru3R_Start(c,x,y)
    elseif id == RimuruT3_ID then 
    set check = 1
    call Rimuru3T_Start(c,x,y)
    elseif id == RimuruF3_ID then 
    set check = 1
    call Rimuru3F_Start(c)
    elseif id == RimuruG3_ID then 
    set check = 1
    call Rimuru3G_Start(c,x,y)
    endif
    endif    
     if GetUnitTypeId(c) == Harribel_ID then 
    if id == HarribelQ_ID then 
    set check = 1
    call HarribelQ_Start(c,x,y)
    elseif id == HarribelW_ID then 
    set check = 1
    call HarribelW_Start(c, td)
    elseif id == HarribelE_ID then 
    set check = 1
    call HarribelE_Start(c)
    elseif id == HarribelE2_ID then 
    set check = 1
    call HarribelE2_Start(c)
    elseif id == HarribelR_ID then 
    set check = 1
    call HarribelR_Start(c)
    elseif id == HarribelT_ID then 
    set check = 1
    call HarribelT_Start(c,x,y)
    elseif id == HarribelR2_ID then 
    set check = 1
    call HarribelR2_Start(c,x,y)
    endif
    endif
    if GetUnitTypeId(c) == Barragan_ID then 
    if id == BarraganQ_ID then 
    set check = 1
    call BarraganQ_Start(c,x,y)
    elseif id == BarraganW_ID then 
    set check = 1
    call BarraganW_Start(c, x,y)
    elseif id == BarraganW2_ID then 
    set check = 1
    call BarraganW2_Start(c)
    elseif id == BarraganE_ID then 
    set check = 1
    call BarraganE_Start(c)
    elseif id == BarraganE2_ID then 
    set check = 1
    call BarraganE2_Start(c, x,y)
    elseif id == BarraganR_ID then 
    set check = 1
    call BarraganR_Start(c)
    elseif id == BarraganT_ID then 
    set check = 1
    call BarraganT_Start(c)
    elseif id == BarraganT2_ID then 
    set check = 1
    call BarraganT2_Start(c,x,y)
    endif
    endif
    if GetUnitTypeId(c) == Starrk_ID then 
    if id == StarrkQ_ID then 
    set check = 1
    call StarrkQ_Start(c,x,y)
    elseif id == StarrkW_ID then 
    set check = 1
    call StarrkW_Start(c,td)
    elseif id == StarrkE_ID then 
    set check = 1
    call StarrkE_Start(c)
    elseif id == StarrkE2_ID then 
    set check = 1
    call StarrkE2_Start(c,x,y)
    elseif id == StarrkR_ID then 
    set check = 1
    call StarrkR_Start(c,td)
    elseif id == StarrkR2_ID then 
    set check = 1
    call StarrkR2_Start(c,x,y)
    elseif id == StarrkR3_ID then 
    set check = 1
    call StarrkR3_Start(c)
    elseif id == StarrkT_ID then 
    set check = 1
    call StarrkT_Start(c)
    elseif id == StarrkT2_ID then 
    set check = 1
    call StarrkT2_Start(c,x,y)
    elseif id == StarrkF_ID then 
    call StarrkF_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Alucard_ID then 
    if id == AlucardQ_ID then 
    set check = 1
    call AlucardQ_Start(c,x,y)
    elseif id == AlucardQ2_ID then 
    set check = 1
    call AlucardQ2_Start(c)
    elseif id == AlucardW_ID then 
    set check = 1
    call AlucardW_Start(c,td)
    elseif id == AlucardW2_ID then 
    set check = 1
    call AlucardW2_Start(c)
    elseif id == AlucardE_ID then 
    set check = 1
    call AlucardE_Start(c,x,y)
    elseif id == AlucardR_ID then 
    set check = 1
    call AlucardR_Start(c)
    elseif id == AlucardT_ID then 
    set check = 1
    call AlucardT_Start(c,td)
    elseif id == AlucardT2_ID then 
    set check = 1
    call AlucardT2_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Mahoraga_ID then 
    if id == MahoragaQ_ID then // Barragan T2 Ability
    set check = 1
    call MahoragaQ_Start(c,td)
    elseif id == MahoragaQ2_ID then // Barragan T2 Ability
    set check = 1
    call MahoragaQ2_Start(c)
    elseif id == MahoragaW_ID then // Barragan T2 Ability
    set check = 1
    call MahoragaW_Start(c)
    elseif id == MahoragaW2_ID then // Barragan T2 Ability
    set check = 1
    call MahoragaW2_Start(c,td)
    elseif id == MahoragaE_ID then // Barragan T2 Ability
    set check = 1
    call MahoragaE_Start(c,x,y)
    elseif id == MahoragaE2_ID then // Barragan T2 Ability
    set check = 1
    call MahoragaE2_Start(c)
    elseif id == MahoragaE3_ID then // Barragan T2 Ability
    set check = 1
    call MahoragaE3_Start(c)
    elseif id == MahoragaR_ID then // Barragan T2 Ability
    set check = 1
    call MahoragaR_Start(c)
    elseif id == MahoragaG_ID then // Barragan T2 Ability
    set check = 1
    call MahoragaG_Start(c,td)
    elseif id == MahoragaF_ID then // Barragan T2 Ability
    set check = 1
    call MahoragaF_Start(c,x,y)
    endif
    endif
    if GetUnitTypeId(c) == Kirito_ID then 
    if id == KiritoQ_ID then // Barragan T2 Ability
    set check = 1
    call KiritoQ_Start(c,x,y)
    elseif id == KiritoW_ID then // Barragan T2 Ability
    set check = 1
    call KiritoW_Start(c)
    elseif id == KiritoE_ID then // Barragan T2 Ability
    set check = 1
    call KiritoE_Start(c,x,y)    
    elseif id == KiritoE2_ID then // Barragan T2 Ability
    set check = 1
    call KiritoE2_Start(c,x,y)
    elseif id == KiritoR_ID then // Barragan T2 Ability
    set check = 1
    call KiritoR_Start(c)
    elseif id == KiritoR2_ID then // Barragan T2 Ability
    set check = 1
    call KiritoR2_Start(c,td)
    elseif id == KiritoT_ID then // Barragan T2 Ability
    set check = 1
    call KiritoT_Start(c,td)
    elseif id == KiritoT2_ID then // Barragan T2 Ability
    set check = 1
    call KiritoT2_Start(c,x,y)
    elseif id == KiritoF_ID then // Barragan T2 Ability
    set check = 1
    call KiritoF_Start(c,td)
    elseif id == KiritoG2_ID then // Barragan T2 Ability
    set check = 1
    call KiritoG2_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Bambietta_ID then 
    if id == BambiettaQ_ID then // Barragan T2 Ability
    set check = 1
    call BambiettaQ_Start(c,x,y)
    elseif id == BambiettaW_ID then // Barragan T2 Ability
    set check = 1
    call BambiettaW_Start(c)
    elseif id == BambiettaE_ID then // Barragan T2 Ability
    set check = 1
    call BambiettaE_Start(c,x,y)
    elseif id == BambiettaR_ID then // Barragan T2 Ability
    set check = 1
    call BambiettaR_Start(c)
    elseif id == BambiettaT_ID then // Barragan T2 Ability
    set check = 1
    call BambiettaT_Start(c)
    elseif id == BambiettaT2_ID then // Barragan T2 Ability
    set check = 1
    call BambiettaT2_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Asta_ID then 
    if id == AstaQ_ID then // Barragan T2 Ability
    set check = 1
    call AstaQ_Start(c,x,y)
    elseif id == AstaQ2_ID then // Barragan T2 Ability
    set check = 1
    call AstaQ2_Start(c,x,y)
    elseif id == AstaW_ID then // Barragan T2 Ability
    set check = 1
    call AstaW_Start(c,x,y)    
    elseif id == AstaW2_ID then // Barragan T2 Ability
    set check = 1
    call AstaW2_Start(c,td)
    elseif id == AstaE_ID then // Barragan T2 Ability
    set check = 1
    call AstaE_Start(c)
    elseif id == AstaR_ID then // Barragan T2 Ability
    set check = 1
    call AstaR_Start(c,td)
    elseif id == AstaR2_ID then // Barragan T2 Ability
    set check = 1
    call AstaR2_Start(c,td)
    elseif id == AstaT_ID then // Barragan T2 Ability
    set check = 1
    call AstaT_Start(c)
    elseif id == AstaT2_ID then // Barragan T2 Ability
    set check = 1
    call AstaT2_Start(c,x,y)
    elseif id == AstaF_ID then // Barragan T2 Ability
    set check = 1
    call AstaF_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Patriot_ID then 
    if id == PatriotQ_ID then // Barragan T2 Ability
    set check = 1
    call PatriotQ_Start(c,x,y)
    elseif id == PatriotW_ID then // Barragan T2 Ability
    set check = 1
    call PatriotW_Start(c,x,y)
    elseif id == PatriotE_ID then // Barragan T2 Ability
    set check = 1
    call PatriotE_Start(c)
    elseif id == PatriotR_ID then // Barragan T2 Ability
    set check = 1
    call PatriotR_Start(c,x,y)
    elseif id == PatriotT_ID then // Barragan T2 Ability
    set check = 1
    call PatriotT_Start(c,x,y)
    elseif id == PatriotT2_ID then // Barragan T2 Ability
    set check = 1
    call PatriotT2_Start(c,x,y)
    elseif id == PatriotF_ID then // Barragan T2 Ability
    set check = 1
    call PatriotF_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Brandish_ID then 
    if id == BrandishQ_ID then // Barragan T2 Ability
    set check = 1
    call BrandishQ_Start(c,x,y)
    elseif id == BrandishW_ID then // Barragan T2 Ability
    set check = 1
    call BrandishW_Start(c,x,y)
    elseif id == BrandishE_ID then // Barragan T2 Ability
    set check = 1
    call BrandishE_Start(c,td)
    elseif id == BrandishR_ID then // Barragan T2 Ability
    set check = 1
    call BrandishR_Start(c,x,y)
    elseif id == BrandishT_ID then // Barragan T2 Ability
    set check = 1
    call BrandishT_Start(c)
    elseif id == BrandishF_ID then // Barragan T2 Ability
    set check = 1
    call BrandishF_Start(c,td)
    endif
    endif
    
    if GetUnitTypeId(c) == Laxus_ID then 
    if id == LaxusQ_ID then // Barragan T2 Ability
    set check = 1
    call LaxusQ_Start(c,x,y)
    elseif id == LaxusQ2_ID then // Barragan T2 Ability
    set check = 1
    call LaxusQ2_Start(c,x,y)
    elseif id == LaxusW_ID then // Barragan T2 Ability
    set check = 1
    call LaxusW_Start(c,td)
    elseif id == LaxusW2_ID then // Barragan T2 Ability
    set check = 1
    call LaxusW2_Start(c,td)
    elseif id == LaxusE_ID then // Barragan T2 Ability
    set check = 1
    call LaxusE_Start(c)
    elseif id == LaxusR_ID then // Barragan T2 Ability
    set check = 1
    call LaxusR_Start(c,td)
    elseif id == LaxusT_ID then // Barragan T2 Ability
    set check = 1
    call LaxusT_Start(c)
    elseif id == LaxusF_ID then // Barragan T2 Ability
    set check = 1
    call LaxusF_Start(c,td)
    elseif id == LaxusG_ID then // Barragan T2 Ability
    set check = 1
    call LaxusG_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Ainz_ID then 
    if id == AinzQ_ID then // Barragan T2 Ability
    set check = 1
    call AinzQ_Start(c,x,y)
    elseif id == AinzQ2_ID then // Barragan T2 Ability
    set check = 1
    call AinzQ2_Start(c,x,y)
    elseif id == AinzW_ID then // Barragan T2 Ability
    set check = 1
    call AinzW_Start(c)
    elseif id == AinzW2_ID then // Barragan T2 Ability
    set check = 1
    call AinzW2_Start(c,td)
    elseif id == AinzW3_ID then // Barragan T2 Ability
    set check = 1
    call AinzW3_Start(c,x,y)
    elseif id == AinzE_ID then // Barragan T2 Ability
    set check = 1
    call AinzE_Start(c,x,y)
    elseif id == AinzE2_ID then // Barragan T2 Ability
    set check = 1
    call AinzE2_Start(c,td)
    elseif id == AinzR_ID then // Barragan T2 Ability
    set check = 1
    call AinzR_Start(c,x,y)
    elseif id == AinzT_ID then // Barragan T2 Ability
    set check = 1
    call AinzT_Start(c)
    elseif id == AinzF_ID then // Barragan T2 Ability
    set check = 1
    call AinzF_Start(c)
    elseif id == AinzG_ID then // Barragan T2 Ability
    set check = 1
    call AinzG_Start(c)
    elseif id == AinzQ3_ID then // Barragan T2 Ability
    set check = 1
    call AinzTQ_Start(c,td)
    elseif id == AinzW4_ID then // Barragan T2 Ability
    set check = 1
    call AinzTW_Start(c)
    elseif id == AinzE3_ID then // Barragan T2 Ability
    set check = 1
    call AinzTE_Start(c,x,y)
    elseif id == AinzR2_ID then // Barragan T2 Ability
    set check = 1
    call AinzTR_Start(c,x,y)
    endif
    endif
    if GetUnitTypeId(c) == Frieren_ID then 
    if id == FrierenQ_ID then // Barragan T2 Ability
    set check = 1
    call FrierenQ_Start(c,x,y)
    elseif id == FrierenQ2_ID then // Barragan T2 Ability
    set check = 1
    call FrierenQ2_Start(c)
    elseif id == FrierenQ3_ID then // Barragan T2 Ability
    set check = 1
    call FrierenQ3_Start(c,td)
    elseif id == FrierenW_ID then // Barragan T2 Ability
    set check = 1
    call FrierenW_Start(c,td)
    elseif id == FrierenW2_ID then // Barragan T2 Ability
    set check = 1
    call FrierenW2_Start(c,x,y)
    elseif id == FrierenE_ID then // Barragan T2 Ability
    set check = 1
    call FrierenE_Start(c)
    elseif id == FrierenR_ID then // Barragan T2 Ability
    set check = 1
    call FrierenR_Start(c,x,y)
    elseif id == FrierenT_ID then // Barragan T2 Ability
    set check = 1
    call FrierenT_Start(c)
    elseif id == FrierenTF_ID then // Barragan T2 Ability
    set check = 1
    call FrierenF_Start(c,td)
    elseif id == FrierenG_ID then // Barragan T2 Ability
    set check = 1
    call FrierenG_Start(c)
    elseif id == FrierenT2_ID then // Barragan T2 Ability
    set check = 1
    call FrierenT2_Start(c,x,y)
    endif
    endif
     if GetUnitTypeId(c) == Toji_ID then 
    if id == TojiQ_ID then // Barragan T2 Ability
    set check = 1
    call TojiQ_Start(c,td)
    elseif id == TojiQ2_ID then // Barragan T2 Ability
    set check = 1
    call TojiQ2_Start(c,td)
    elseif id == TojiQ3_ID then // Barragan T2 Ability
    set check = 1
    call TojiQ3_Start(c,td)
    elseif id == TojiW_ID then // Barragan T2 Ability
    set check = 1
    call TojiW_Start(c,x,y)
    elseif id == TojiW2_ID then // Barragan T2 Ability
    set check = 1
    call TojiW2_Start(c,x,y)
    elseif id == TojiE_ID then // Barragan T2 Ability
    set check = 1
    call TojiE_Start(c,x,y)
    elseif id == TojiR_ID then // Barragan T2 Ability
    set check = 1
    call TojiR_Start(c,x,y)
    elseif id == TojiT_ID then // Barragan T2 Ability
    set check = 1
    call TojiT_Start(c,x,y)
    elseif id == TojiF_ID then // Barragan T2 Ability
    set check = 1
    call TojiF_Start(c)
    elseif id == TojiG2_ID then // Barragan T2 Ability
    set check = 1
    call TojiG_Start(c,td)
    endif
    endif
    
     if GetUnitTypeId(c) == Milim_ID then 
    if id == MilimQ_ID then // Barragan T2 Ability
    set check = 1
    call MilimQ_Start(c,x,y)
    elseif id == MilimW_ID then // Barragan T2 Ability
    set check = 1
    call MilimW_Start(c,x,y)
    elseif id == MilimW2_ID then // Barragan T2 Ability
    set check = 1
    call MilimW2_Start(c)
    elseif id == MilimE_ID then // Barragan T2 Ability
    set check = 1
    call MilimE_Start(c,x,y)
    elseif id == MilimR_ID then // Barragan T2 Ability
    set check = 1
    call MilimR_Start(c,x,y)
    elseif id == MilimT_ID then // Barragan T2 Ability
    set check = 1
    call MilimT_Start(c)
    elseif id == MilimT2_ID then // Barragan T2 Ability
    set check = 1
    call MilimT2_Start(c,x,y)
    endif
    endif
    
    
    
    if GetUnitTypeId(c) == Starrk_ID and BlzGetUnitAbilityCooldown(c,id,GetUnitAbilityLevel(c,id)-1)>=3 then 
    call StarrkPas(c)
    endif
    if id != FrierenG_ID and check == 1 then
    call FrierenF_Stacks(c)
    endif
    // Собираем все подходящие источники CDR и запускаем изменение КД один раз.
    set i2 = 0
    set cdReduce = 0
    set rr = BlzGetUnitAbilityCooldown(c,id,GetUnitAbilityLevel(c,id)-1)
    if check == 1 and GetUnitTypeId(c) == Toji_ID and GetHeroLevel(c) >= 35 then
    set cdReduce = cdReduce + TojiG_CdReduce/100
    set i2 = 1
    endif
    if check == 1 and IsItemInInventory(c,'I011') > 0 and GetMainStatInt(c) then
    set cdReduce = cdReduce + OkarunEggReduceCD/100
    set i2 = 1
    endif
    if check == 1 and rr >= 3 and BlzGetUnitAbilityCooldownRemaining(c,'A0BZ') == 0 and GetMainStatAgi(c) and IsItemInInventory(c,'I024') > 0 then
    set cdReduce = cdReduce + PrisonRealmReduceCD/100
    set i2 = 1
    call BlzStartUnitAbilityCooldown(c,'A0BZ',PrisonRealmCD)
    endif
    if check == 1 and LoadInteger(hs,GetHandleId(c),StringHash("hari g 3")) == 1 then
    set cdReduce = cdReduce + 0.10
    set i2 = 1
    endif
    if cdReduce > 1 then
    set cdReduce = 1
    endif
    if check == 1 and i2 == 1 then
    call CD_Start(c,0.03,id,rr*(1-cdReduce))
    endif
    if check == 1 and IsItemInInventory(c,'I01K')>0  then
    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_ice.mdl",c,"chest"))
    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_a (396).mdl",c,"origin"))    
    call DecorRemove(c,GetUnitX(c),GetUnitY(c),650,50)
    endif
    
    endif
    elseif IsUnitType(c,UNIT_TYPE_HERO)  and BlzGetUnitAbilityCooldownRemaining(c,id)==0 then 
    call IssueImmediateOrder(c,"stop")
    set i2 = BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(c,id),ABILITY_ILF_MANA_COST,GetUnitAbilityLevel(c,id)-1)
    call MyAddMana(c,I2R(i2),0.03)
    if b == false and IntegerCd(c,"cancel tooltip",3) then 
    call DisplayTimedTextToPlayer(Player(i),0,0,0.01,"|c00FF0000Can't use this ability while rooted!|r")
    endif
    endif
    set c = null
    set td = null
    set x = 0
    set y = 0
    return false
endfunction
//===========================================================================
function InitTrig_CastCheck takes nothing returns nothing
    local integer index = 0
    set gg_trg_CastCheck = CreateTrigger()
    call TriggerAddCondition( gg_trg_CastCheck, Condition( function CastHero_Conditions ) )
endfunction
