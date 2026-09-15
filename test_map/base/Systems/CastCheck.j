function CastHero_Conditions takes nothing returns boolean
    local integer check = 0
    local unit c = GetSpellAbilityUnit()
    local unit td = GetSpellTargetUnit()
    local real x = GetSpellTargetX()
    local real y = GetSpellTargetY()
    local integer id = GetSpellAbilityId()
    if CheckCoordsInRect(gg_rct_Base,GetUnitX(c),GetUnitY(c)) == false then 
    /*if GetUnitTypeId(c) == Raiden_ID then 
    if id == RaidenQ_ID then // Barragan T2 Ability
    call RaidenQ_Start(c,x,y)
    elseif id == RaidenW_ID then // Barragan T2 Ability
    call RaidenW_Start(c)
    elseif id == RaidenE_ID then // Barragan T2 Ability
    call RaidenE_Start(c,x,y)
    elseif id == RaidenR_ID then // Barragan T2 Ability
    call RaidenR_Start(c,x,y)
    elseif id == RaidenT_ID then // Barragan T2 Ability
    call RaidenT_Start(c)
    elseif id == RaidenTT_ID then // Barragan T2 Ability
    call RaidenTT_Start(c)
    endif
    endif
    /*if GetUnitTypeId(c) == Natsu_ID then 
    if id == NatsuQ_ID then // Barragan T2 Ability
    call NatsuQ_Start(c,x,y)
    elseif id == NatsuW_ID then // Barragan T2 Ability
    call NatsuW_Start(c,td)
    elseif id == NatsuE_ID then // Barragan T2 Ability
    call NatsuE_Start(c,x,y)
    elseif id == NatsuR_ID then // Barragan T2 Ability
    call NatsuR_Start(c,td)
    elseif id == NatsuT_ID then // Barragan T2 Ability
    call NatsuT_Start(c,x,y)
    elseif id == NatsuG_ID then // Barragan T2 Ability
    call NatsuG_Start(c)
    elseif id == NatsuG2_ID then // Barragan T2 Ability
    call NatsuG2_Start(c)
    elseif id == NatsuFT_ID then // Barragan T2 Ability
    call NatsuFT_Start(c,td)
    elseif id == NatsuFR_ID then // Barragan T2 Ability
    call NatsuFR_Start(c,td)
    endif
    endif*/
    if GetUnitTypeId(c) == AlterSaber_ID then 
    if id == AlterSaberQ_ID then // Barragan T2 Ability
    call AlterSaberQ_Start(c,x,y)
    elseif id == AlterSaberW_ID then // Barragan T2 Ability
    call AlterSaberW2_Start(c,x,y)
    elseif id == AlterSaberE_ID then // Barragan T2 Ability
    call AlterSaberE_Start(c)
    elseif id == AlterSaberR_ID then // Barragan T2 Ability
    call AlterSaberR_Start(c)
    elseif id == AlterSaberT_ID then // Barragan T2 Ability
    call AlterSaberT_Start(c,x,y)
    elseif id == AlterSaberRR_ID then // Barragan T2 Ability
    call AlterSaberRR_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Erza_ID then 
    if id == ErzaG2_ID then // Barragan T2 Ability
    call ErzaG2_Start(c)
    elseif id == ErzaF_ID then // Barragan T2 Ability
    call ErzaF_Start(c)
    elseif id == Erza6Q_ID then // Barragan T2 Ability
    call Erza6Q_Start(c,x,y)
    elseif id == Erza6W_ID then // Barragan T2 Ability
    call Erza6W_Start(c)
    elseif id == Erza6E_ID then // Barragan T2 Ability
    call Erza6E_Start(c,td)
    elseif id == Erza6R_ID then // Barragan T2 Ability
    call Erza6R_Start(c)
    elseif id == Erza6T_ID then // Barragan T2 Ability
    call Erza6T_Start(c,x,y)
    elseif id == Erza7Q_ID then // Barragan T2 Ability
    call Erza7Q_Start(c,x,y)
    elseif id == Erza7W_ID then // Barragan T2 Ability
    call Erza7W_Start(c,x,y)
    elseif id == Erza7E_ID then // Barragan T2 Ability
    call Erza7E_Start(c,td)
    elseif id == Erza7R_ID then // Barragan T2 Ability
    call Erza7R_Start(c)
    elseif id == Erza7T_ID then // Barragan T2 Ability
    call Erza7T_Start(c,td)
    
    endif
    endif
    if GetUnitTypeId(c) == Kenjaku_ID then 
    if id == KenjakuQ_ID then // Barragan T2 Ability
    call KenjakuQ_Start(c)
    elseif id == KenjakuQ2_ID then // Barragan T2 Ability
    call KenjakuQ2_Start(c)
    elseif id == KenjakuQ3_ID then // Barragan T2 Ability
    call KenjakuQ3_Start(c,x,y)
    elseif id == KenjakuW_ID then // Barragan T2 Ability
    call KenjakuW_Start(c,td)
    elseif id == KenjakuW2_ID then // Barragan T2 Ability
    call KenjakuW2_Start(c)
    elseif id == KenjakuW3_ID then // Barragan T2 Ability
    call KenjakuW3_Start(c,x,y)
    elseif id == KenjakuE_ID then // Barragan T2 Ability
    call KenjakuE_Start(c)
    elseif id == KenjakuE2_ID then // Barragan T2 Ability
    call KenjakuE2_Start(c)
    elseif id == KenjakuE3_ID then // Barragan T2 Ability
    call KenjakuE3_Start(c,x,y)
    elseif id == KenjakuR_ID then // Barragan T2 Ability
    call KenjakuR_Start(c,x,y)
    elseif id == KenjakuR2_ID then // Barragan T2 Ability
    call KenjakuR2_Start(c,x,y)
    elseif id == KenjakuT_ID then // Barragan T2 Ability
    call KenjakuT_Start(c,x,y)
    elseif id == KenjakuF_ID then // Barragan T2 Ability
    call KenjakuF_Start(c,td)
    elseif id == KenjakuF2_ID then // Barragan T2 Ability
    call KenjakuF3_Start(c,td)
    elseif id == KenjakuG_ID then // Barragan T2 Ability
    call KenjakuG_Start(c)
    endif
    endif
    
    if GetUnitTypeId(c) == Inori_ID then 
    if id == InoriQ_ID then // Barragan T2 Ability
    call InoriQ_Start(c,x,y)
    elseif id == InoriQ2_ID then // Barragan T2 Ability
    call InoriQ2_Start(c,x,y)
    elseif id == InoriQ3_ID then // Barragan T2 Ability
    call InoriQ3_Start(c,x,y)
    elseif id == InoriW_ID then // Barragan T2 Ability
    call InoriW_Start(c,td)
    elseif id == InoriW2_ID then // Barragan T2 Ability
    call InoriW2_Start(c,td)
    elseif id == InoriW3_ID then // Barragan T2 Ability
    call InoriW3_Start(c,x,y)
    elseif id == InoriR_ID then // Barragan T2 Ability
    call InoriR_Start(c,x,y)
    elseif id == InoriR2_ID then // Barragan T2 Ability
    call InoriR2_Start(c,x,y)
    elseif id == InoriER_ID then // Barragan T2 Ability
    call InoriER_Start(c,x,y)
    elseif id == InoriG_ID then // Barragan T2 Ability
    call InoriG_Start(c)
    elseif id == InoriT_ID then // Barragan T2 Ability
    call InoriT1_Start(c)
    elseif id == InoriT2_ID then // Barragan T2 Ability
    call InoriT2_Start(c)
    elseif id == InoriT3_ID then // Barragan T2 Ability
    call InoriT3_Start(c)
    elseif id == InoriF_ID then // Barragan T2 Ability
    call InoriF_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Akainu_ID then 
    if id == AkainuQ_ID then // Barragan T2 Ability
    call AkainuQ_Start(c,td)
    elseif id == AkainuW_ID then // Barragan T2 Ability
    call AkainuW_Start(c,x,y)
    elseif id == AkainuE_ID then // Barragan T2 Ability
    call AkainuE_Start(c,td)
    elseif id == AkainuR_ID then // Barragan T2 Ability
    call AkainuR_Start(c,x,y)
    elseif id == AkainuT_ID then // Barragan T2 Ability
    call AkainuT_Start(c,x,y)
    endif
    endif
    if GetUnitTypeId(c) == Okarun_ID then 
    if id == OkarunQ_ID then // Barragan T2 Ability
    call OkarunQ_Start(c,x,y)
    elseif id == OkarunW_ID then // Barragan T2 Ability
    call OkarunW_Start(c,td)
    elseif id == OkarunE_ID then // Barragan T2 Ability
    call OkarunE_Start(c,td)
    elseif id == OkarunR_ID then // Barragan T2 Ability
    call OkarunR_Start(c,td)
    elseif id == OkarunT_ID then // Barragan T2 Ability
    call OkarunT_Start(c,x,y)
    endif
    endif
    if GetUnitTypeId(c) == Neuvillette_ID then 
    if id == NeuvilletteQ_ID then // Barragan T2 Ability
    call NeuvilletteQ_Start(c,x,y)
    elseif id == NeuvilletteW_ID then // Barragan T2 Ability
    call NeuvilletteW_Start(c,td)
    elseif id == NeuvilletteE_ID then // Barragan T2 Ability
    call NeuvilletteE_Start(c,x,y)
    elseif id == NeuvilletteR_ID then // Barragan T2 Ability
    call NeuvilletteR_Start(c,x,y)
    elseif id == NeuvilletteT_ID then // Barragan T2 Ability
    call NeuvilletteT_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Tsuna_ID then 
    if id == TsunaQ_ID then // Barragan T2 Ability
    call TsunaQ_Start(c,x,y)
    elseif id == TsunaW_ID then // Barragan T2 Ability
    call TsunaW_Start(c)
    elseif id == TsunaE_ID then // Barragan T2 Ability
    call TsunaE_Start(c,x,y)
    elseif id == TsunaR_ID then // Barragan T2 Ability
    call TsunaR_Start(c,td)
    elseif id == TsunaT_ID then // Barragan T2 Ability
    call TsunaT_Start(c,x,y)
    elseif id == TsunaT2_ID then // Barragan T2 Ability
    call TsunaT2_Start(c)
    elseif id == TsunaQ2_ID then // Barragan T2 Ability
    call TsunaQ2_Start(c,x,y)
    elseif id == TsunaW2_ID then // Barragan T2 Ability
    call TsunaW2_Start(c,x,y)
    elseif id == TsunaW3_ID then // Barragan T2 Ability
    call TsunaW3_Start(c,x,y)
    elseif id == TsunaE2_ID then // Barragan T2 Ability
    call TsunaE2_Start(c,x,y)
    elseif id == TsunaR2_ID then // Barragan T2 Ability
    call TsunaR2_Start(c,x,y)
    elseif id == TsunaT3_ID then // Barragan T2 Ability
    call TsunaT3_Start(c,x,y)
    elseif id == TsunaG_ID then // Barragan T2 Ability
    call TsunaG_Start(c)
    elseif id == TsunaG2_ID then // Barragan T2 Ability
    call TsunaG2_Start(c)
    elseif id == TsunaG3_ID then // Barragan T2 Ability
    call TsunaG3_Start(c)
    endif
    endif    
    if GetUnitTypeId(c) == Takeshi_ID then 
    if id == TakeshiQ_ID then // Barragan T2 Ability
    call TakeshiQ_Start(c,x,y)
    elseif id == TakeshiQ2_ID then // Barragan T2 Ability
    call TakeshiQ2_Start(c,x,y)
    elseif id == TakeshiQ3_ID then // Barragan T2 Ability
    call TakeshiQ3_Start(c)
    elseif id == TakeshiW_ID then // Barragan T2 Ability
    call TakeshiW_Start(c,x,y)
    elseif id == TakeshiW2_ID then // Barragan T2 Ability
    call TakeshiW2_Start(c)
    elseif id == TakeshiE_ID then // Barragan T2 Ability
    call TakeshiE_Start(c,x,y)
    elseif id == TakeshiE2_ID then // Barragan T2 Ability
    call TakeshiE2_Start(c,td)
    elseif id == TakeshiR_ID then // Barragan T2 Ability
    call TakeshiR_Start(c,td)
    elseif id == TakeshiR2_ID then // Barragan T2 Ability
    call TakeshiR2_Start(c)
    elseif id == TakeshiT_ID then // Barragan T2 Ability
    call TakeshiT_Start(c,x,y)
    elseif id == TakeshiGQ_ID then // Barragan T2 Ability
    call TakeshiGQ_Start(c,x,y)
    elseif id == TakeshiGW_ID then // Barragan T2 Ability
    call TakeshiGW_Start(c,td)
    elseif id == TakeshiGE_ID then // Barragan T2 Ability
    call TakeshiGE_Start(c)
    elseif id == TakeshiGR_ID then // Barragan T2 Ability
    call TakeshiGR_Start(c)
    elseif id == TakeshiGF_ID then // Barragan T2 Ability
    call TakeshiGF_Start(c,td)
    elseif id == TakeshiG_ID then // Barragan T2 Ability
    call TakeshiG_Start(c)
    elseif id == TakeshiF_ID then // Barragan T2 Ability
    call TakeshiF_Start(c)
    endif
    endif
    if GetUnitTypeId(c) == Rimuru_ID then 
    if id == RimuruQ_ID then // Barragan T2 Ability
    call RimuruQ_Start(c,x,y)
    elseif id == RimuruW_ID then // Barragan T2 Ability
    call RimuruW_Start(c,td)
    elseif id == RimuruE_ID then // Barragan T2 Ability
    call RimuruE_Start(c,x,y)
    elseif id == RimuruR_ID then // Barragan T2 Ability
    call RimuruR_Start(c,x,y)
    elseif id == RimuruT_ID then // Barragan T2 Ability
    call RimuruT_Start(c,td)
    elseif id == RimuruQ2_ID then // Barragan T2 Ability
    call Rimuru2Q_Start(c)
    elseif id == RimuruW2_ID then // Barragan T2 Ability
    call Rimuru2W_Start(c,x,y)
    elseif id == RimuruE2_ID then // Barragan T2 Ability
    call Rimuru2E_Start(c,x,y)
    elseif id == RimuruR2_ID then // Barragan T2 Ability
    call Rimuru2R_Start(c,x,y)
    elseif id == RimuruT2_ID then // Barragan T2 Ability
    call Rimuru2T_Start(c,x,y)
    elseif id == RimuruF2_ID then // Barragan T2 Ability
    call Rimuru2F_Start(c,x,y)
    elseif id == RimuruQ3_ID then // Barragan T2 Ability
    call Rimuru3Q_Start(c,td)
    elseif id == RimuruW3_ID then // Barragan T2 Ability
    call Rimuru3W_Start(c,x,y)
    elseif id == RimuruE3_ID then // Barragan T2 Ability
    call Rimuru3E_Start(c,x,y)
    elseif id == RimuruE4_ID then // Barragan T2 Ability
    call Rimuru3E2_Start(c,x,y)
    elseif id == RimuruE5_ID then // Barragan T2 Ability
    call Rimuru3E3_Start(c,x,y)
    elseif id == RimuruR3_ID then // Barragan T2 Ability
    call Rimuru3R_Start(c,x,y)
    elseif id == RimuruT3_ID then // Barragan T2 Ability
    call Rimuru3T_Start(c,x,y)
    elseif id == RimuruF3_ID then // Barragan T2 Ability
    call Rimuru3F_Start(c)
    elseif id == RimuruG3_ID then // Barragan T2 Ability
    call Rimuru3G_Start(c,x,y)
    endif
    endif*/
    
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
    if GetUnitTypeId(c) == Laxus_ID then 
    if id == LaxusQ_ID then // Barragan T2 Ability
    set check = 1
    call LaxusQ_Start(c,x,y)
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
    
    endif
    if id != FrierenG_ID  then
    call FrierenF_Stacks(c)
    endif
    if id == 'A012' then
    call TsuchikageHat_Start(c,td )
    endif
    return false
endfunction
//===========================================================================
function InitTrig_CastCheck takes nothing returns nothing
    local integer index = 0
    set gg_trg_CastCheck = CreateTrigger()
    call TriggerAddCondition( gg_trg_CastCheck, Condition( function CastHero_Conditions ) )
endfunction
