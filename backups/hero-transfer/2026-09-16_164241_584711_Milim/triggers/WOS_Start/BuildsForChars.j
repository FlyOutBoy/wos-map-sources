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
set MaxHeroes = MaxHeroes + 1
    set Hero_ID0[n] = Raiden_ID // Raiden EI
    set Hero_ID0_Dummy[n] = CreateUnit(Player(12), Hero_ID0[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID0_Dummy[n], false)
    call UnitAddAbility(Hero_ID0_Dummy[n], RaidenQ_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], RaidenW_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], RaidenE_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], RaidenR_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], RaidenT_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], RaidenF_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], RaidenG_ID)
    set n = 1
set MaxHeroes = MaxHeroes + 1
    set Hero_ID0[n] = Neuvillette_ID // Neuvillette 
    set Hero_ID0_Dummy[n] = CreateUnit(Player(12), Hero_ID0[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID0_Dummy[n], false)
    call UnitAddAbility(Hero_ID0_Dummy[n], NeuvilletteQ_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], NeuvilletteW_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], NeuvilletteE_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], NeuvilletteR_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], NeuvilletteT_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], NeuvilletteF_ID)
    set n = 2
set MaxHeroes = MaxHeroes + 1
    set Hero_ID0[n] = Patriot_ID // Patriot 
    set Hero_ID0_Dummy[n] = CreateUnit(Player(12), Hero_ID0[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID0_Dummy[n], false)
    call UnitAddAbility(Hero_ID0_Dummy[n], PatriotQ_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], PatriotW_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], PatriotE_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], PatriotR_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], PatriotT_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], PatriotF_ID)
    call UnitAddAbility(Hero_ID0_Dummy[n], PatriotG_ID)
//=========Bleach==============
    set n = 0
set MaxHeroes = MaxHeroes + 1
    set Hero_ID1[n] = Kyoraku_ID // Kyoraku
    set Hero_ID1_Dummy[n] = CreateUnit(Player(12), Hero_ID1[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID1_Dummy[n], false)
    call UnitAddAbility(Hero_ID1_Dummy[n], KyorakuQ_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], KyorakuW_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], KyorakuE_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], KyorakuR_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], KyorakuT_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], KyorakuF_ID)
     set n = 1
set MaxHeroes = MaxHeroes + 1
    set Hero_ID1[n] = BazzB_ID // BazzB
    set Hero_ID1_Dummy[n] = CreateUnit(Player(12), Hero_ID1[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID1_Dummy[n], false)
    call UnitAddAbility(Hero_ID1_Dummy[n], BazzBQ_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BazzBW_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BazzBE_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BazzBR_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BazzBT_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BazzBG_ID) 
    set n = 2
set MaxHeroes = MaxHeroes + 1
    set Hero_ID1[n] = Harribel_ID // Harribel
    set Hero_ID1_Dummy[n] = CreateUnit(Player(12), Hero_ID1[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID1_Dummy[n], false)
    call UnitAddAbility(Hero_ID1_Dummy[n], HarribelQ_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], HarribelW_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], HarribelE_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], HarribelR_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], HarribelT_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], HarribelG_ID)
    set n = 3
set MaxHeroes = MaxHeroes + 1
    set Hero_ID1[n] = Barragan_ID // Barragan
    set Hero_ID1_Dummy[n] = CreateUnit(Player(12), Hero_ID1[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID1_Dummy[n], false)
    call UnitAddAbility(Hero_ID1_Dummy[n], BarraganQ_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BarraganW_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BarraganE_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BarraganR_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BarraganT_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BarraganG_ID)
    set n = 4
set MaxHeroes = MaxHeroes + 1
    set Hero_ID1[n] = Starrk_ID // Starrk
    set Hero_ID1_Dummy[n] = CreateUnit(Player(12), Hero_ID1[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID1_Dummy[n], false)
    call UnitAddAbility(Hero_ID1_Dummy[n], StarrkQ_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], StarrkW_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], StarrkE_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], StarrkR_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], StarrkT_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], StarrkG_ID) 
    set n = 5
set MaxHeroes = MaxHeroes + 1
    set Hero_ID1[n] = Bambietta_ID // Bambietta
    set Hero_ID1_Dummy[n] = CreateUnit(Player(12), Hero_ID1[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID1_Dummy[n], false)
    call UnitAddAbility(Hero_ID1_Dummy[n], BambiettaQ_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BambiettaW_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BambiettaE_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BambiettaR_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BambiettaT_ID)
    call UnitAddAbility(Hero_ID1_Dummy[n], BambiettaG_ID) 
//=========Fairy Tail==============
    set n = 0
set MaxHeroes = MaxHeroes + 1
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
set MaxHeroes = MaxHeroes + 1
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
    set n = 2
set MaxHeroes = MaxHeroes + 1
    set Hero_ID2[n] = Brandish_ID // Brandish
    set Hero_ID2_Dummy[n] = CreateUnit(Player(12), Hero_ID2[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID2_Dummy[n], false)
    call UnitAddAbility(Hero_ID2_Dummy[n], BrandishQ_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], BrandishW_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], BrandishE_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], BrandishR_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], BrandishT_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], BrandishF_ID)
    set n = 3
set MaxHeroes = MaxHeroes + 1
    set Hero_ID2[n] = Laxus_ID // Laxus
    set Hero_ID2_Dummy[n] = CreateUnit(Player(12), Hero_ID2[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID2_Dummy[n], false)
    call UnitAddAbility(Hero_ID2_Dummy[n], LaxusQ_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], LaxusW_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], LaxusE_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], LaxusR_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], LaxusT_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], LaxusF_ID)
    call UnitAddAbility(Hero_ID2_Dummy[n], LaxusG_ID)
//=========One Piece==============
    set n = 0
set MaxHeroes = MaxHeroes + 1
    set Hero_ID3[n] = Akainu_ID // Akainu
    set Hero_ID3_Dummy[n] = CreateUnit(Player(12), Hero_ID3[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID3_Dummy[n], false)
    call UnitAddAbility(Hero_ID3_Dummy[n], AkainuQ_ID)
    call UnitAddAbility(Hero_ID3_Dummy[n], AkainuW_ID)
    call UnitAddAbility(Hero_ID3_Dummy[n], AkainuE_ID)
    call UnitAddAbility(Hero_ID3_Dummy[n], AkainuR_ID)
    call UnitAddAbility(Hero_ID3_Dummy[n], AkainuT_ID)
    call UnitAddAbility(Hero_ID3_Dummy[n], AkainuF_ID)
//=========Jujutsu Kaisen==============
    set n = 0
set MaxHeroes = MaxHeroes + 1
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
set MaxHeroes = MaxHeroes + 1
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
    set n = 2
    set MaxHeroes = MaxHeroes + 1
    set Hero_ID4[n] = Mahoraga_ID // Mahoraga
    set Hero_ID4_Dummy[n] = CreateUnit(Player(12), Hero_ID4[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID4_Dummy[n], false)
    call UnitAddAbility(Hero_ID4_Dummy[n], MahoragaQ_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], MahoragaW_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], MahoragaE_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], MahoragaR_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], MahoragaT_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], MahoragaF_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], MahoragaG_ID)
    set n = 3
    set MaxHeroes = MaxHeroes + 1
    set Hero_ID4[n] = Toji_ID // Toji
    set Hero_ID4_Dummy[n] = CreateUnit(Player(12), Hero_ID4[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID4_Dummy[n], false)
    call UnitAddAbility(Hero_ID4_Dummy[n], TojiQ_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], TojiW_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], TojiE_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], TojiR_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], TojiT_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], TojiF_ID)
    call UnitAddAbility(Hero_ID4_Dummy[n], TojiG_ID)
//=========Other Anime==============
    set n = 0
set MaxHeroes = MaxHeroes + 1
    set Hero_ID5[n] = Tomioka_ID // Tomioka
    set Hero_ID5_Dummy[n] = CreateUnit(Player(12), Hero_ID5[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID5_Dummy[n], false)
    call UnitAddAbility(Hero_ID5_Dummy[n], TomiokaQ_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TomiokaW_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TomiokaE_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TomiokaR_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TomiokaT_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TomiokaF_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TomiokaG_ID)
    set n = 1
set MaxHeroes = MaxHeroes + 1
    set Hero_ID5[n] = AlterSaber_ID // AlterSaber
    set Hero_ID5_Dummy[n] = CreateUnit(Player(12), Hero_ID5[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID5_Dummy[n], false)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlterSaberQ_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlterSaberW_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlterSaberE_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlterSaberR_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlterSaberT_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlterSaberF_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlterSaberG_ID)
    set n = 2
set MaxHeroes = MaxHeroes + 1
    set Hero_ID5[n] = Inori_ID // Inori
    set Hero_ID5_Dummy[n] = CreateUnit(Player(12), Hero_ID5[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID5_Dummy[n], false)
    call UnitAddAbility(Hero_ID5_Dummy[n], InoriQ_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], InoriW_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], InoriE_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], InoriR_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], InoriT_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], InoriF_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], InoriG_ID)
    set n = 3
set MaxHeroes = MaxHeroes + 1
    set Hero_ID5[n] = Okarun_ID // Okarun
    set Hero_ID5_Dummy[n] = CreateUnit(Player(12), Hero_ID5[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID5_Dummy[n], false)
    call UnitAddAbility(Hero_ID5_Dummy[n], OkarunQ_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], OkarunW_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], OkarunE_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], OkarunR_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], OkarunT_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], OkarunF_ID)
    set n = 4
set MaxHeroes = MaxHeroes + 1
    set Hero_ID5[n] = Tsuna_ID // Tsuna
    set Hero_ID5_Dummy[n] = CreateUnit(Player(12), Hero_ID5[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID5_Dummy[n], false)
    call UnitAddAbility(Hero_ID5_Dummy[n], TsunaQ_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TsunaW_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TsunaE_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TsunaR_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TsunaT_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TsunaF_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TsunaG_ID)
    set n = 5
set MaxHeroes = MaxHeroes + 1
    set Hero_ID5[n] = Takeshi_ID // Takeshi
    set Hero_ID5_Dummy[n] = CreateUnit(Player(12), Hero_ID5[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID5_Dummy[n], false)
    call UnitAddAbility(Hero_ID5_Dummy[n], TakeshiQ_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TakeshiW_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TakeshiE_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TakeshiR_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TakeshiT_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TakeshiF_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], TakeshiG_ID)
    set n = 6
set MaxHeroes = MaxHeroes + 1
    set Hero_ID5[n] = DarkShiki_ID // DarkShiki
    set Hero_ID5_Dummy[n] = CreateUnit(Player(12), Hero_ID5[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID5_Dummy[n], false)
    call UnitAddAbility(Hero_ID5_Dummy[n], DarkShikiQ_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], DarkShikiW_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], DarkShikiE_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], DarkShikiR_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], DarkShikiT_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], DarkShikiF_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], DarkShikiG_ID)
    set n = 7
    set MaxHeroes = MaxHeroes + 1
    set Hero_ID5[n] = Rimuru_ID // Rimuru
    set Hero_ID5_Dummy[n] = CreateUnit(Player(12), Hero_ID5[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID5_Dummy[n], false)
    call UnitAddAbility(Hero_ID5_Dummy[n], RimuruQ_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], RimuruW_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], RimuruE_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], RimuruR_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], RimuruT_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], RimuruF_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], RimuruG_ID)
    set n = 8
    set MaxHeroes = MaxHeroes + 1
    set Hero_ID5[n] = Alucard_ID // Alucard
    set Hero_ID5_Dummy[n] = CreateUnit(Player(12), Hero_ID5[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID5_Dummy[n], false)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlucardQ_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlucardW_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlucardE_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlucardR_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlucardT_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlucardF_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AlucardG_ID)
    set n = 9
    set MaxHeroes = MaxHeroes + 1
    set Hero_ID5[n] = Kirito_ID // Kirito
    set Hero_ID5_Dummy[n] = CreateUnit(Player(12), Hero_ID5[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID5_Dummy[n], false)
    call UnitAddAbility(Hero_ID5_Dummy[n], KiritoQ_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], KiritoW_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], KiritoE_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], KiritoR_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], KiritoT_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], KiritoF_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], KiritoG_ID)
    set n = 10
    set MaxHeroes = MaxHeroes + 1
    set Hero_ID5[n] = Asta_ID // Asta
    set Hero_ID5_Dummy[n] = CreateUnit(Player(12), Hero_ID5[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID5_Dummy[n], false)
    call UnitAddAbility(Hero_ID5_Dummy[n], AstaQ_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AstaW_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AstaE_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AstaR_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AstaT_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AstaF_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AstaG_ID)
    set n = 11
    set MaxHeroes = MaxHeroes + 1
    set Hero_ID5[n] = Ainz_ID // Ainz
    set Hero_ID5_Dummy[n] = CreateUnit(Player(12), Hero_ID5[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID5_Dummy[n], false)
    call UnitAddAbility(Hero_ID5_Dummy[n], AinzQ_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AinzW_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AinzE_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AinzR_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AinzT_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AinzF_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], AinzG_ID)
    set n = 12
    set MaxHeroes = MaxHeroes + 1
    set Hero_ID5[n] = Frieren_ID // Ainz
    set Hero_ID5_Dummy[n] = CreateUnit(Player(12), Hero_ID5[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)
    call ShowUnit(Hero_ID5_Dummy[n], false)
    call UnitAddAbility(Hero_ID5_Dummy[n], FrierenQ_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], FrierenW_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], FrierenE_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], FrierenR_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], FrierenT_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], FrierenF_ID)
    call UnitAddAbility(Hero_ID5_Dummy[n], FrierenG_ID)
//==============================

endfunction

function InitBuilds takes nothing returns nothing
    call MyHeroIdInit()
    call InitHeroShopRegistry()
endfunction

//===========================================================================
function InitTrig_BuildsForChars takes nothing returns nothing
    set gg_trg_BuildsForChars = CreateTrigger(  )
    call TriggerRegisterTimerEventSingle( gg_trg_BuildsForChars, 1 )
    call TriggerAddAction( gg_trg_BuildsForChars, function InitBuilds )
endfunction


