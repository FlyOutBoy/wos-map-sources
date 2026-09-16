# Extracted Warcraft III trigger sources

Sources are byte-for-byte copies of WCT payloads with only the binary null terminator removed.
Trigger names, category membership, and order come from WTG.
Machine-readable metadata is in `trigger-manifest.json`; the resolved vJASS graph is in `dependency-manifest.json`.
Regenerate with `python tools/extract_war3_triggers.py` from the project root.

| Order | Category | Trigger | Source | Libraries/scopes | Dependencies |
| ---: | --- | --- | --- | --- | --- |
| 000 | Map Header | Map Header | [Map_Header.j](Map_Header.j) | — | — |
| 001 | WOS Start | Loan | [WOS_Start/Loan.j](WOS_Start/Loan.j) | GoldLoanSystem | — |
| 002 | WOS Start | Loan Copy | [WOS_Start/Loan_Copy.j](WOS_Start/Loan_Copy.j) | GoldLoanSystem | — |
| 003 | WOS Start | ShowTextCD | [WOS_Start/ShowTextCD.j](WOS_Start/ShowTextCD.j) | AllyCooldownChatPing | GearSystems, AllyHeroAbilityUI |
| 004 | WOS Start | ShowCD | [WOS_Start/ShowCD.j](WOS_Start/ShowCD.j) | AllyHeroAbilityUI | GearSystems |
| 005 | WOS Start | TooltipBuilder | [WOS_Start/TooltipBuilder.j](WOS_Start/TooltipBuilder.j) | TooltipBuilder | — |
| 006 | WOS Start | UniversalTooltips | [WOS_Start/UniversalTooltips.j](WOS_Start/UniversalTooltips.j) | AAUniversalTooltips | GearSystems, TooltipBuilder |
| 007 | WOS Start | UI CAREER | [WOS_Start/UI_CAREER.j](WOS_Start/UI_CAREER.j) | WosCareerStats | AAINIT, heroicon |
| 008 | WOS Start | DefaultArmorChange | [WOS_Start/DefaultArmorChange.j](WOS_Start/DefaultArmorChange.j) | HeroUnitPanelStats | heroicon |
| 009 | WOS Start | DefaultArmorChangeStable Copy | [WOS_Start/DefaultArmorChangeStable_Copy.j](WOS_Start/DefaultArmorChangeStable_Copy.j) | HeroUnitPanelStats | heroicon |
| 010 | WOS Start | Save2 | [WOS_Start/Save2.j](WOS_Start/Save2.j) | WOS2BotCodec | — |
| 011 | WOS Start | SaveLoad | [WOS_Start/SaveLoad.j](WOS_Start/SaveLoad.j) | AAINIT | WOS2BotCodec |
| 012 | WOS Start | MusicPlayer | [WOS_Start/MusicPlayer.j](WOS_Start/MusicPlayer.j) | LocalMp3Player | — |
| 013 | WOS Start | Scoreboard | [WOS_Start/Scoreboard.j](WOS_Start/Scoreboard.j) | WosScoreboard | heroicon |
| 014 | WOS Start | ChatCommand | [WOS_Start/ChatCommand.j](WOS_Start/ChatCommand.j) | CustomImageChat | GearSystems |
| 015 | WOS Start | Player Pick Mode | [WOS_Start/Player_Pick_Mode.j](WOS_Start/Player_Pick_Mode.j) | — | — |
| 016 | WOS Start | WoS Shop Init | [WOS_Start/WoS_Shop_Init.j](WOS_Start/WoS_Shop_Init.j) | — | — |
| 017 | WOS Start | WoS Pick Init | [WOS_Start/WoS_Pick_Init.j](WOS_Start/WoS_Pick_Init.j) | — | — |
| 018 | WOS Start | WoS Pick Init Copy 2 | [WOS_Start/WoS_Pick_Init_Copy_2.j](WOS_Start/WoS_Pick_Init_Copy_2.j) | — | — |
| 019 | WOS Start | WoS Pick Init Copy | [WOS_Start/WoS_Pick_Init_Copy.j](WOS_Start/WoS_Pick_Init_Copy.j) | — | — |
| 020 | WOS Start | Starts | [WOS_Start/Starts.j](WOS_Start/Starts.j) | — | — |
| 021 | WOS Start | Starts Copy | [WOS_Start/Starts_Copy.j](WOS_Start/Starts_Copy.j) | — | — |
| 022 | WOS Start | BuildsForChars | [WOS_Start/BuildsForChars.j](WOS_Start/BuildsForChars.j) | — | — |
| 023 | WOS Start | WoS Shop Init Copy 2 | [WOS_Start/WoS_Shop_Init_Copy_2.j](WOS_Start/WoS_Shop_Init_Copy_2.j) | — | — |
| 024 | WOS Start | TestUnit | [WOS_Start/TestUnit.j](WOS_Start/TestUnit.j) | — | — |
| 025 | WOS Start | TestUnit Copy | [WOS_Start/TestUnit_Copy.j](WOS_Start/TestUnit_Copy.j) | — | — |
| 026 | WOS Start | WoS Hero Icons Init | [WOS_Start/WoS_Hero_Icons_Init.j](WOS_Start/WoS_Hero_Icons_Init.j) | heroicon | LocalMp3Player, AAINIT, GearSystems |
| 027 | WOS Start | WoS Hero Icons Init Copy 2 | [WOS_Start/WoS_Hero_Icons_Init_Copy_2.j](WOS_Start/WoS_Hero_Icons_Init_Copy_2.j) | heroicon | LocalMp3Player |
| 028 | WOS Start | Untitled Trigger 001 | [WOS_Start/Untitled_Trigger_001.j](WOS_Start/Untitled_Trigger_001.j) | heroicon | LocalMp3Player |
| 029 | WOS Start | WoS Hero Icons Init Copy | [WOS_Start/WoS_Hero_Icons_Init_Copy.j](WOS_Start/WoS_Hero_Icons_Init_Copy.j) | heroicon | — |
| 030 | WOS Start | Leave | [WOS_Start/Leave.j](WOS_Start/Leave.j) | — | — |
| 031 | Round End | RoundEnd | [Round_End/RoundEnd.j](Round_End/RoundEnd.j) | RoundSpells | GearSystems |
| 032 | Systems | CastAItems | [Systems/CastAItems.j](Systems/CastAItems.j) | — | — |
| 033 | Systems | TasBox | [Systems/TasBox.j](Systems/TasBox.j) | TasAbilityChargeBox | optional FrameLoader |
| 034 | Systems | CastCheck | [Systems/CastCheck.j](Systems/CastCheck.j) | — | — |
| 035 | Systems | CastCheck Copy | [Systems/CastCheck_Copy.j](Systems/CastCheck_Copy.j) | — | — |
| 036 | Systems | ClickEvent | [Systems/ClickEvent.j](Systems/ClickEvent.j) | — | — |
| 037 | Systems | DecorDestroy and Erza Debuff | [Systems/DecorDestroy_and_Erza_Debuff.j](Systems/DecorDestroy_and_Erza_Debuff.j) | AAADest | GearSystems |
| 038 | Systems | Systems1 | [Systems/Systems1.j](Systems/Systems1.j) | GearSystems | GearSystems2 |
| 039 | Systems | Systems2 | [Systems/Systems2.j](Systems/Systems2.j) | GearSystems2 | TasAbilityChargeBox |
| 040 | Systems | Systems Copy 2 | [Systems/Systems_Copy_2.j](Systems/Systems_Copy_2.j) | GearSystems | — |
| 041 | Systems | Systems Copy | [Systems/Systems_Copy.j](Systems/Systems_Copy.j) | GearSystems | — |
| 042 | Systems | DmgSys | [Systems/DmgSys.j](Systems/DmgSys.j) | — | — |
| 043 | Systems | AtkCancel | [Systems/AtkCancel.j](Systems/AtkCancel.j) | — | — |
| 044 | Systems | MouseMove | [Systems/MouseMove.j](Systems/MouseMove.j) | — | — |
| 045 | Systems | Death | [Systems/Death.j](Systems/Death.j) | — | — |
| 046 | Systems | silence | [Systems/silence.j](Systems/silence.j) | — | — |
| 047 | Systems | LvlUpCheck | [Systems/LvlUpCheck.j](Systems/LvlUpCheck.j) | — | — |
| 048 | Systems | LvlSelf | [Systems/LvlSelf.j](Systems/LvlSelf.j) | — | — |
| 049 | Systems | MagRes | [Systems/MagRes.j](Systems/MagRes.j) | — | — |
| 050 | Systems | PhysRes | [Systems/PhysRes.j](Systems/PhysRes.j) | — | — |
| 051 | Systems | slow | [Systems/slow.j](Systems/slow.j) | — | — |
| 052 | Systems | NeviSound | [Systems/NeviSound.j](Systems/NeviSound.j) | — | — |
| 053 | Systems | Evol1 | [Systems/Evol1.j](Systems/Evol1.j) | — | — |
| 054 | Systems | Evol2 | [Systems/Evol2.j](Systems/Evol2.j) | — | — |
| 055 | Systems | sukuna spawn | [Systems/sukuna_spawn.j](Systems/sukuna_spawn.j) | — | — |
| 056 | Systems | ESC | [Systems/ESC.j](Systems/ESC.j) | — | — |
| 057 | Systems | AllyDie | [Systems/AllyDie.j](Systems/AllyDie.j) | — | — |
| 058 | Systems | Killme | [Systems/Killme.j](Systems/Killme.j) | — | — |
| 059 | Systems | AnimCheck | [Systems/AnimCheck.j](Systems/AnimCheck.j) | — | — |
| 060 | Systems | hpset | [Systems/hpset.j](Systems/hpset.j) | — | — |
| 061 | Systems | mpset | [Systems/mpset.j](Systems/mpset.j) | — | — |
| 062 | Systems | ArrowLeft | [Systems/ArrowLeft.j](Systems/ArrowLeft.j) | — | — |
| 063 | Systems | ArrowUp | [Systems/ArrowUp.j](Systems/ArrowUp.j) | — | — |
| 064 | Systems | ArrowDown | [Systems/ArrowDown.j](Systems/ArrowDown.j) | — | — |
| 065 | Systems | ArrowRight | [Systems/ArrowRight.j](Systems/ArrowRight.j) | — | — |
| 066 | Systems | CastingCheck | [Systems/CastingCheck.j](Systems/CastingCheck.j) | — | — |
| 067 | Systems | ButtonPressed | [Systems/ButtonPressed.j](Systems/ButtonPressed.j) | — | — |
| 068 | Systems | ButtonPressed ESC | [Systems/ButtonPressed_ESC.j](Systems/ButtonPressed_ESC.j) | — | — |
| 069 | Systems | ButtonUnPressed_ESC | [Systems/ButtonUnPressed_ESC.j](Systems/ButtonUnPressed_ESC.j) | — | — |
| 070 | Systems | EnterBase | [Systems/EnterBase.j](Systems/EnterBase.j) | — | — |
| 071 | Systems | EnterRegion | [Systems/EnterRegion.j](Systems/EnterRegion.j) | — | — |
| 072 | Systems | LeavesBase | [Systems/LeavesBase.j](Systems/LeavesBase.j) | — | — |
| 073 | Systems | LeavesRegion | [Systems/LeavesRegion.j](Systems/LeavesRegion.j) | — | — |
| 074 | Systems | ItemCupOfTea | [Systems/ItemCupOfTea.j](Systems/ItemCupOfTea.j) | — | — |
| 075 | Systems | ItemEnter | [Systems/ItemEnter.j](Systems/ItemEnter.j) | — | — |
| 076 | Systems | ItemLeave | [Systems/ItemLeave.j](Systems/ItemLeave.j) | — | — |
| 077 | Items | Items | [Items/Items.j](Items/Items.j) | ItemsSpells | GearSystems |
| 078 | Heroes | Toji | [Heroes/Toji.j](Heroes/Toji.j) | TojiSpells | GearSystems |
| 079 | Heroes | Raiden | [Heroes/Raiden.j](Heroes/Raiden.j) | RaidenSpells | GearSystems |
| 080 | Heroes | Frieren | [Heroes/Frieren.j](Heroes/Frieren.j) | FrierenSpells | GearSystems |
| 081 | Heroes | Ainz | [Heroes/Ainz.j](Heroes/Ainz.j) | AinzSpells | GearSystems |
| 082 | Heroes | Laxus | [Heroes/Laxus.j](Heroes/Laxus.j) | LaxusSpells | GearSystems, NatsuSpells |
| 083 | Heroes | Brandish | [Heroes/Brandish.j](Heroes/Brandish.j) | BrandishSpells | GearSystems |
| 084 | Heroes | Patriot | [Heroes/Patriot.j](Heroes/Patriot.j) | PatriotSpells | GearSystems |
| 085 | Heroes | Asta | [Heroes/Asta.j](Heroes/Asta.j) | AstaSpells | GearSystems |
| 086 | Heroes | Gojo | [Heroes/Gojo.j](Heroes/Gojo.j) | GojoSpells | GearSystems |
| 087 | Heroes | Bambietta | [Heroes/Bambietta.j](Heroes/Bambietta.j) | BambiettaSpells | GearSystems |
| 088 | Heroes | Bambietta Копировать | [Heroes/Bambietta_Копировать.j](Heroes/Bambietta_Копировать.j) | BambiettaSpells | GearSystems |
| 089 | Heroes | Kirito | [Heroes/Kirito.j](Heroes/Kirito.j) | KiritoSpells | GearSystems |
| 090 | Heroes | Alucard | [Heroes/Alucard.j](Heroes/Alucard.j) | AlucardSpells | GearSystems |
| 091 | Heroes | Starrk | [Heroes/Starrk.j](Heroes/Starrk.j) | StarrkSpells | GearSystems |
| 092 | Heroes | Starrk Copy | [Heroes/Starrk_Copy.j](Heroes/Starrk_Copy.j) | StarrkSpells | GearSystems |
| 093 | Heroes | Takeshi | [Heroes/Takeshi.j](Heroes/Takeshi.j) | TakeshiSpells | GearSystems |
| 094 | Heroes | Barragan | [Heroes/Barragan.j](Heroes/Barragan.j) | BarraganSpells | GearSystems |
| 095 | Heroes | Mahoraga | [Heroes/Mahoraga.j](Heroes/Mahoraga.j) | MahoragaSpells | GearSystems |
| 096 | Heroes | Harribel | [Heroes/Harribel.j](Heroes/Harribel.j) | HarribelSpells | GearSystems |
| 097 | Heroes | Tsuna Copy | [Heroes/Tsuna_Copy.j](Heroes/Tsuna_Copy.j) | TsunaSpells | GearSystems |
| 098 | Heroes | Tsuna | [Heroes/Tsuna.j](Heroes/Tsuna.j) | TsunaSpells | GearSystems |
| 099 | Heroes | Tsuna Copy 2 | [Heroes/Tsuna_Copy_2.j](Heroes/Tsuna_Copy_2.j) | TsunaSpells | GearSystems |
| 100 | Heroes | Rimuru | [Heroes/Rimuru.j](Heroes/Rimuru.j) | RimuruSpells | GearSystems |
| 101 | Heroes | DarkShiki | [Heroes/DarkShiki.j](Heroes/DarkShiki.j) | DarkShikiSpells | GearSystems |
| 102 | Heroes | BazzB | [Heroes/BazzB.j](Heroes/BazzB.j) | BazzBSpells | GearSystems |
| 103 | Heroes | Neuvillette | [Heroes/Neuvillette.j](Heroes/Neuvillette.j) | NeuvilletteSpells | GearSystems |
| 104 | Heroes | Okarun | [Heroes/Okarun.j](Heroes/Okarun.j) | OkarunSpells | GearSystems |
| 105 | Heroes | Akainu | [Heroes/Akainu.j](Heroes/Akainu.j) | AkainuSpells | GearSystems |
| 106 | Heroes | Inori | [Heroes/Inori.j](Heroes/Inori.j) | InoriSpells | GearSystems |
| 107 | Heroes | Kenjaku | [Heroes/Kenjaku.j](Heroes/Kenjaku.j) | KenjakuSpells | GearSystems |
| 108 | Heroes | AlterSaber | [Heroes/AlterSaber.j](Heroes/AlterSaber.j) | AlterSaberSpells | GearSystems |
| 109 | Heroes | Natsu | [Heroes/Natsu.j](Heroes/Natsu.j) | NatsuSpells | GearSystems |
| 110 | Heroes | Kyoraku | [Heroes/Kyoraku.j](Heroes/Kyoraku.j) | KyorakuSpells | GearSystems |
| 111 | Heroes | Tomioka | [Heroes/Tomioka.j](Heroes/Tomioka.j) | TomiokaSpells | GearSystems |
| 112 | Erza | ErzaQ | [Erza/ErzaQ.j](Erza/ErzaQ.j) | ErzaQSpells | GearSystems, ErzaTSpells |
| 113 | Erza | ErzaW | [Erza/ErzaW.j](Erza/ErzaW.j) | ErzaWSpells | GearSystems, ErzaTSpells |
| 114 | Erza | ErzaE | [Erza/ErzaE.j](Erza/ErzaE.j) | ErzaESpells | GearSystems, ErzaTSpells |
| 115 | Erza | ErzaR | [Erza/ErzaR.j](Erza/ErzaR.j) | ErzaRSpells | GearSystems |
| 116 | Erza | ErzaT | [Erza/ErzaT.j](Erza/ErzaT.j) | ErzaTSpells | GearSystems |
| 117 | Erza | ErzaG2 Nakagami | [Erza/ErzaG2_Nakagami.j](Erza/ErzaG2_Nakagami.j) | ErzaG1Spells | GearSystems |
| 118 | Erza | ErzaG2 Fairy | [Erza/ErzaG2_Fairy.j](Erza/ErzaG2_Fairy.j) | ErzaG2Spells | GearSystems |
| 119 | Erza | ErzaBase | [Erza/ErzaBase.j](Erza/ErzaBase.j) | ErzaBase | GearSystems, ErzaQSpells |
