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
| 008 | WOS Start | DefaultArmorChangeStable Copy | [WOS_Start/DefaultArmorChangeStable_Copy.j](WOS_Start/DefaultArmorChangeStable_Copy.j) | HeroUnitPanelStats | heroicon |
| 009 | WOS Start | Save2 | [WOS_Start/Save2.j](WOS_Start/Save2.j) | WOS2BotCodec | — |
| 010 | WOS Start | SaveLoad | [WOS_Start/SaveLoad.j](WOS_Start/SaveLoad.j) | AAINIT | WOS2BotCodec |
| 011 | WOS Start | MusicPlayer | [WOS_Start/MusicPlayer.j](WOS_Start/MusicPlayer.j) | LocalMp3Player | — |
| 012 | WOS Start | Scoreboard | [WOS_Start/Scoreboard.j](WOS_Start/Scoreboard.j) | WosScoreboard | heroicon |
| 013 | WOS Start | ChatCommand | [WOS_Start/ChatCommand.j](WOS_Start/ChatCommand.j) | CustomImageChat | GearSystems |
| 014 | WOS Start | Player Pick Mode | [WOS_Start/Player_Pick_Mode.j](WOS_Start/Player_Pick_Mode.j) | — | — |
| 015 | WOS Start | WoS Shop Init | [WOS_Start/WoS_Shop_Init.j](WOS_Start/WoS_Shop_Init.j) | — | — |
| 016 | WOS Start | WoS Pick Init | [WOS_Start/WoS_Pick_Init.j](WOS_Start/WoS_Pick_Init.j) | — | — |
| 017 | WOS Start | Starts | [WOS_Start/Starts.j](WOS_Start/Starts.j) | — | — |
| 018 | WOS Start | INITSS | [WOS_Start/INITSS.j](WOS_Start/INITSS.j) | — | — |
| 019 | WOS Start | BuildsForChars | [WOS_Start/BuildsForChars.j](WOS_Start/BuildsForChars.j) | — | — |
| 020 | WOS Start | TestUnit | [WOS_Start/TestUnit.j](WOS_Start/TestUnit.j) | — | — |
| 021 | WOS Start | WoS Hero Icons Init | [WOS_Start/WoS_Hero_Icons_Init.j](WOS_Start/WoS_Hero_Icons_Init.j) | heroicon | LocalMp3Player, AAINIT, GearSystems |
| 022 | WOS Start | Leave | [WOS_Start/Leave.j](WOS_Start/Leave.j) | — | — |
| 023 | Round End | RoundEnd | [Round_End/RoundEnd.j](Round_End/RoundEnd.j) | RoundSpells | GearSystems |
| 024 | Systems | CastAItems | [Systems/CastAItems.j](Systems/CastAItems.j) | — | — |
| 025 | Systems | TasBox | [Systems/TasBox.j](Systems/TasBox.j) | TasAbilityChargeBox | optional FrameLoader |
| 026 | Systems | CastCheck | [Systems/CastCheck.j](Systems/CastCheck.j) | — | — |
| 027 | Systems | ClickEvent | [Systems/ClickEvent.j](Systems/ClickEvent.j) | — | — |
| 028 | Systems | DecorDestroy and Erza Debuff | [Systems/DecorDestroy_and_Erza_Debuff.j](Systems/DecorDestroy_and_Erza_Debuff.j) | AAADest | GearSystems |
| 029 | Systems | Systems1 | [Systems/Systems1.j](Systems/Systems1.j) | GearSystems | GearSystems2 |
| 030 | Systems | Systems2 | [Systems/Systems2.j](Systems/Systems2.j) | GearSystems2 | TasAbilityChargeBox |
| 031 | Systems | DmgSys | [Systems/DmgSys.j](Systems/DmgSys.j) | — | — |
| 032 | Systems | AtkCancel | [Systems/AtkCancel.j](Systems/AtkCancel.j) | — | — |
| 033 | Systems | MouseMove | [Systems/MouseMove.j](Systems/MouseMove.j) | — | — |
| 034 | Systems | Death | [Systems/Death.j](Systems/Death.j) | — | — |
| 035 | Systems | silence | [Systems/silence.j](Systems/silence.j) | — | — |
| 036 | Systems | LvlUpCheck | [Systems/LvlUpCheck.j](Systems/LvlUpCheck.j) | — | — |
| 037 | Systems | LvlSelf | [Systems/LvlSelf.j](Systems/LvlSelf.j) | — | — |
| 038 | Systems | MagRes | [Systems/MagRes.j](Systems/MagRes.j) | — | — |
| 039 | Systems | PhysRes | [Systems/PhysRes.j](Systems/PhysRes.j) | — | — |
| 040 | Systems | slow | [Systems/slow.j](Systems/slow.j) | — | — |
| 041 | Systems | NeviSound | [Systems/NeviSound.j](Systems/NeviSound.j) | — | — |
| 042 | Systems | Evol1 | [Systems/Evol1.j](Systems/Evol1.j) | — | — |
| 043 | Systems | Evol2 | [Systems/Evol2.j](Systems/Evol2.j) | — | — |
| 044 | Systems | sukuna spawn | [Systems/sukuna_spawn.j](Systems/sukuna_spawn.j) | — | — |
| 045 | Systems | ESC | [Systems/ESC.j](Systems/ESC.j) | — | — |
| 046 | Systems | Killme | [Systems/Killme.j](Systems/Killme.j) | — | — |
| 047 | Systems | AnimCheck | [Systems/AnimCheck.j](Systems/AnimCheck.j) | — | — |
| 048 | Systems | hpset | [Systems/hpset.j](Systems/hpset.j) | — | — |
| 049 | Systems | mpset | [Systems/mpset.j](Systems/mpset.j) | — | — |
| 050 | Systems | ArrowLeft | [Systems/ArrowLeft.j](Systems/ArrowLeft.j) | — | — |
| 051 | Systems | ArrowUp | [Systems/ArrowUp.j](Systems/ArrowUp.j) | — | — |
| 052 | Systems | ArrowDown | [Systems/ArrowDown.j](Systems/ArrowDown.j) | — | — |
| 053 | Systems | ArrowRight | [Systems/ArrowRight.j](Systems/ArrowRight.j) | — | — |
| 054 | Systems | CastingCheck | [Systems/CastingCheck.j](Systems/CastingCheck.j) | — | — |
| 055 | Systems | ButtonPressed | [Systems/ButtonPressed.j](Systems/ButtonPressed.j) | — | — |
| 056 | Systems | ButtonPressed ESC | [Systems/ButtonPressed_ESC.j](Systems/ButtonPressed_ESC.j) | — | — |
| 057 | Systems | ButtonUnPressed_ESC | [Systems/ButtonUnPressed_ESC.j](Systems/ButtonUnPressed_ESC.j) | — | — |
| 058 | Systems | EnterBase | [Systems/EnterBase.j](Systems/EnterBase.j) | — | — |
| 059 | Systems | EnterRegion | [Systems/EnterRegion.j](Systems/EnterRegion.j) | — | — |
| 060 | Systems | LeavesBase | [Systems/LeavesBase.j](Systems/LeavesBase.j) | — | — |
| 061 | Systems | LeavesRegion | [Systems/LeavesRegion.j](Systems/LeavesRegion.j) | — | — |
| 062 | Systems | ItemCupOfTea | [Systems/ItemCupOfTea.j](Systems/ItemCupOfTea.j) | — | — |
| 063 | Systems | ItemEnter | [Systems/ItemEnter.j](Systems/ItemEnter.j) | — | — |
| 064 | Systems | ItemLeave | [Systems/ItemLeave.j](Systems/ItemLeave.j) | — | — |
| 065 | Items | Items | [Items/Items.j](Items/Items.j) | ItemsSpells | GearSystems |
| 066 | Heroes | Toji | [Heroes/Toji.j](Heroes/Toji.j) | TojiSpells | GearSystems |
| 067 | Heroes | Raiden | [Heroes/Raiden.j](Heroes/Raiden.j) | RaidenSpells | GearSystems |
| 068 | Heroes | Frieren | [Heroes/Frieren.j](Heroes/Frieren.j) | FrierenSpells | GearSystems |
| 069 | Heroes | Ainz | [Heroes/Ainz.j](Heroes/Ainz.j) | AinzSpells | GearSystems |
| 070 | Heroes | Laxus | [Heroes/Laxus.j](Heroes/Laxus.j) | LaxusSpells | GearSystems, NatsuSpells |
| 071 | Heroes | Brandish | [Heroes/Brandish.j](Heroes/Brandish.j) | BrandishSpells | GearSystems |
| 072 | Heroes | Patriot | [Heroes/Patriot.j](Heroes/Patriot.j) | PatriotSpells | GearSystems |
| 073 | Heroes | Asta | [Heroes/Asta.j](Heroes/Asta.j) | AstaSpells | GearSystems |
| 074 | Heroes | Gojo | [Heroes/Gojo.j](Heroes/Gojo.j) | GojoSpells | GearSystems |
| 075 | Heroes | Bambietta | [Heroes/Bambietta.j](Heroes/Bambietta.j) | BambiettaSpells | GearSystems |
| 076 | Heroes | Kirito | [Heroes/Kirito.j](Heroes/Kirito.j) | KiritoSpells | GearSystems |
| 077 | Heroes | Alucard | [Heroes/Alucard.j](Heroes/Alucard.j) | AlucardSpells | GearSystems |
| 078 | Heroes | Starrk | [Heroes/Starrk.j](Heroes/Starrk.j) | StarrkSpells | GearSystems |
| 079 | Heroes | Takeshi | [Heroes/Takeshi.j](Heroes/Takeshi.j) | TakeshiSpells | GearSystems |
| 080 | Heroes | Barragan | [Heroes/Barragan.j](Heroes/Barragan.j) | BarraganSpells | GearSystems |
| 081 | Heroes | Mahoraga | [Heroes/Mahoraga.j](Heroes/Mahoraga.j) | MahoragaSpells | GearSystems |
| 082 | Heroes | Harribel | [Heroes/Harribel.j](Heroes/Harribel.j) | HarribelSpells | GearSystems |
| 083 | Heroes | Tsuna | [Heroes/Tsuna.j](Heroes/Tsuna.j) | TsunaSpells | GearSystems |
| 084 | Heroes | Rimuru | [Heroes/Rimuru.j](Heroes/Rimuru.j) | RimuruSpells | GearSystems |
| 085 | Heroes | DarkShiki | [Heroes/DarkShiki.j](Heroes/DarkShiki.j) | DarkShikiSpells | GearSystems |
| 086 | Heroes | BazzB | [Heroes/BazzB.j](Heroes/BazzB.j) | BazzBSpells | GearSystems |
| 087 | Heroes | Neuvillette | [Heroes/Neuvillette.j](Heroes/Neuvillette.j) | NeuvilletteSpells | GearSystems |
| 088 | Heroes | Okarun | [Heroes/Okarun.j](Heroes/Okarun.j) | OkarunSpells | GearSystems |
| 089 | Heroes | Akainu | [Heroes/Akainu.j](Heroes/Akainu.j) | AkainuSpells | GearSystems |
| 090 | Heroes | Inori | [Heroes/Inori.j](Heroes/Inori.j) | InoriSpells | GearSystems |
| 091 | Heroes | Kenjaku | [Heroes/Kenjaku.j](Heroes/Kenjaku.j) | KenjakuSpells | GearSystems |
| 092 | Heroes | AlterSaber | [Heroes/AlterSaber.j](Heroes/AlterSaber.j) | AlterSaberSpells | GearSystems |
| 093 | Heroes | Natsu | [Heroes/Natsu.j](Heroes/Natsu.j) | NatsuSpells | GearSystems |
| 094 | Heroes | Kyoraku | [Heroes/Kyoraku.j](Heroes/Kyoraku.j) | KyorakuSpells | GearSystems |
| 095 | Heroes | Tomioka | [Heroes/Tomioka.j](Heroes/Tomioka.j) | TomiokaSpells | GearSystems |
| 096 | Erza | ErzaQ | [Heroes/Erza/ErzaQ.j](Heroes/Erza/ErzaQ.j) | ErzaQSpells | GearSystems, ErzaTSpells |
| 097 | Erza | ErzaW | [Heroes/Erza/ErzaW.j](Heroes/Erza/ErzaW.j) | ErzaWSpells | GearSystems, ErzaTSpells |
| 098 | Erza | ErzaE | [Heroes/Erza/ErzaE.j](Heroes/Erza/ErzaE.j) | ErzaESpells | GearSystems, ErzaTSpells |
| 099 | Erza | ErzaR | [Heroes/Erza/ErzaR.j](Heroes/Erza/ErzaR.j) | ErzaRSpells | GearSystems |
| 100 | Erza | ErzaT | [Heroes/Erza/ErzaT.j](Heroes/Erza/ErzaT.j) | ErzaTSpells | GearSystems |
| 101 | Erza | ErzaG2 Nakagami | [Heroes/Erza/ErzaG2_Nakagami.j](Heroes/Erza/ErzaG2_Nakagami.j) | ErzaG1Spells | GearSystems |
| 102 | Erza | ErzaG2 Fairy | [Heroes/Erza/ErzaG2_Fairy.j](Heroes/Erza/ErzaG2_Fairy.j) | ErzaG2Spells | GearSystems |
| 103 | Erza | ErzaBase | [Heroes/Erza/ErzaBase.j](Heroes/Erza/ErzaBase.j) | ErzaBase | GearSystems, ErzaQSpells |
| 104 | Heroes | Milim | [Heroes/Milim.j](Heroes/Milim.j) | MilimSpells | GearSystems |
