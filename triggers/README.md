# Extracted Warcraft III trigger sources

Sources are byte-for-byte copies of WCT payloads with only the binary null terminator removed.
Trigger names, category membership, and order come from WTG.
Machine-readable metadata is in `trigger-manifest.json`; the resolved vJASS graph is in `dependency-manifest.json`.
Regenerate with `python tools/extract_war3_triggers.py` from the project root.

| Order | Category | Trigger | Source | Libraries/scopes | Dependencies |
| ---: | --- | --- | --- | --- | --- |
| 000 | Map Header | Map Header | [Map_Header.j](Map_Header.j) | EnvironmentRoundRules | — |
| 001 | WOS Start | Loan | [WOS_Start/Loan.j](WOS_Start/Loan.j) | GoldLoanSystem | — |
| 002 | WOS Start | Loan Copy | [WOS_Start/Loan_Copy.j](WOS_Start/Loan_Copy.j) | GoldLoanSystem | — |
| 003 | WOS Start | ShowTextCD | [WOS_Start/ShowTextCD.j](WOS_Start/ShowTextCD.j) | AllyCooldownChatPing | GearSystems, AllyHeroAbilityUI |
| 004 | WOS Start | ShowCD | [WOS_Start/ShowCD.j](WOS_Start/ShowCD.j) | AllyHeroAbilityUI | GearSystems, WOSUI, TasAbilityChargeBox, AbilityRangePreview |
| 005 | WOS Start | TooltipBuilder | [WOS_Start/TooltipBuilder.j](WOS_Start/TooltipBuilder.j) | TooltipBuilder | — |
| 006 | WOS Start | UniversalTooltips | [WOS_Start/UniversalTooltips.j](WOS_Start/UniversalTooltips.j) | AAUniversalTooltips | GearSystems, TooltipBuilder, WOSUI |
| 007 | WOS Start | UI CAREER | [WOS_Start/UI_CAREER.j](WOS_Start/UI_CAREER.j) | WosCareerStats | AAINIT, heroicon, WOSUI |
| 008 | WOS Start | DefaultArmorChangeStable Copy | [WOS_Start/DefaultArmorChangeStable_Copy.j](WOS_Start/DefaultArmorChangeStable_Copy.j) | HeroUnitPanelStats | WOSPickBans, heroicon, WOSUI, TasAbilityChargeBox, EmojiStandalone |
| 009 | WOS Start | Save2 | [WOS_Start/Save2.j](WOS_Start/Save2.j) | WOS2BotCodec | — |
| 010 | WOS Start | SaveLoad | [WOS_Start/SaveLoad.j](WOS_Start/SaveLoad.j) | AAINIT | WOS2BotCodec, WOSUI, LocalMp3Player |
| 011 | WOS Start | MusicPlayer | [WOS_Start/MusicPlayer.j](WOS_Start/MusicPlayer.j) | LocalMp3Player | WOSUI |
| 012 | WOS Start | Scoreboard | [WOS_Start/Scoreboard.j](WOS_Start/Scoreboard.j) | WosScoreboard | heroicon, WOSUI, WOSTeamMembership |
| 013 | WOS Start | ChatCommand | [WOS_Start/ChatCommand.j](WOS_Start/ChatCommand.j) | CustomImageChat | GearSystems, WOSUI |
| 014 | WOS Start | EMOTES | [WOS_Start/EMOTES.j](WOS_Start/EMOTES.j) | EmojiStandalone | GearSystems, WOSUI, CustomImageChat |
| 015 | WOS Start | Player Pick Mode | [WOS_Start/Player_Pick_Mode.j](WOS_Start/Player_Pick_Mode.j) | WOSTeamMembership | — |
| 016 | WOS Start | Captain Draft | [WOS_Start/Captain_Draft.j](WOS_Start/Captain_Draft.j) | — | — |
| 017 | WOS Start | WoS Shop Init | [WOS_Start/WoS_Shop_Init.j](WOS_Start/WoS_Shop_Init.j) | — | — |
| 018 | WOS Start | WoS Pick Init | [WOS_Start/WoS_Pick_Init.j](WOS_Start/WoS_Pick_Init.j) | WOSPickBans | GearSystems, WOSUI |
| 019 | WOS Start | Starts | [WOS_Start/Starts.j](WOS_Start/Starts.j) | — | — |
| 020 | WOS Start | INITSS | [WOS_Start/INITSS.j](WOS_Start/INITSS.j) | — | — |
| 021 | WOS Start | BuildsForChars | [WOS_Start/BuildsForChars.j](WOS_Start/BuildsForChars.j) | — | — |
| 022 | WOS Start | TestUnit | [WOS_Start/TestUnit.j](WOS_Start/TestUnit.j) | — | — |
| 023 | WOS Start | WoS Hero Icons Init | [WOS_Start/WoS_Hero_Icons_Init.j](WOS_Start/WoS_Hero_Icons_Init.j) | heroicon | LocalMp3Player, AAINIT, GearSystems, WOSUI |
| 024 | WOS Start | Leave | [WOS_Start/Leave.j](WOS_Start/Leave.j) | WOSPlayerLeave | AAINIT, heroicon, GearSystems |
| 025 | WOS Start | TeamMapPings | [WOS_Start/TeamMapPings.j](WOS_Start/TeamMapPings.j) | TeamMapPings | GearSystems, WOSUI |
| 026 | WOS Start | WOSUI | [WOS_Start/WOSUI.j](WOS_Start/WOSUI.j) | WOSUI | EnvironmentRoundRules |
| 027 | WOS Start | ArenaMinimap | [WOS_Start/ArenaMinimap.j](WOS_Start/ArenaMinimap.j) | ArenaMinimap | WOSUI |
| 028 | WOS Start | AbilityRangePreview | [WOS_Start/AbilityRangePreview.j](WOS_Start/AbilityRangePreview.j) | AbilityRangePreview | AAUniversalTooltips, WOSUI, ItemsSpells |
| 029 | WOS Start | MatchVotes | [WOS_Start/MatchVotes.j](WOS_Start/MatchVotes.j) | WOSMatchVotes | heroicon, AAINIT, WOSUI, WOSPlayerLeave, WOSTeamMembership |
| 030 | WOS Start | DamageStats | [WOS_Start/DamageStats.j](WOS_Start/DamageStats.j) | DamageStats | WOSUI, GearSystems, heroicon |
| 031 | Round End | RoundEnd | [Round_End/RoundEnd.j](Round_End/RoundEnd.j) | RoundSpells | GearSystems, EnvironmentRoundRules, optional DamageStats |
| 032 | Systems | CastAItems | [Systems/CastAItems.j](Systems/CastAItems.j) | — | — |
| 033 | Systems | TasBox | [Systems/TasBox.j](Systems/TasBox.j) | TasAbilityChargeBox | WOSUI, optional FrameLoader |
| 034 | Systems | CastCheck | [Systems/CastCheck.j](Systems/CastCheck.j) | — | — |
| 035 | Systems | CastingCheck | [Systems/CastingCheck.j](Systems/CastingCheck.j) | — | — |
| 036 | Systems | ClickEvent | [Systems/ClickEvent.j](Systems/ClickEvent.j) | — | — |
| 037 | Systems | DecorDestroy and Erza Debuff | [Systems/DecorDestroy_and_Erza_Debuff.j](Systems/DecorDestroy_and_Erza_Debuff.j) | AAADest | GearSystems, EnvironmentRoundRules |
| 038 | Systems | Systems1 | [Systems/Systems1.j](Systems/Systems1.j) | GearSystems | GearSystems2 |
| 039 | Systems | Systems2 | [Systems/Systems2.j](Systems/Systems2.j) | GearSystems2 | TasAbilityChargeBox, WOSUI |
| 040 | Systems | DmgSys | [Systems/DmgSys.j](Systems/DmgSys.j) | — | — |
| 041 | Systems | AtkCancel | [Systems/AtkCancel.j](Systems/AtkCancel.j) | — | — |
| 042 | Systems | MouseMove | [Systems/MouseMove.j](Systems/MouseMove.j) | — | — |
| 043 | Systems | Death | [Systems/Death.j](Systems/Death.j) | — | — |
| 044 | Systems | silence | [Systems/silence.j](Systems/silence.j) | — | — |
| 045 | Systems | LvlUpCheck | [Systems/LvlUpCheck.j](Systems/LvlUpCheck.j) | — | — |
| 046 | Systems | LvlSelf | [Systems/LvlSelf.j](Systems/LvlSelf.j) | — | — |
| 047 | Systems | MagRes | [Systems/MagRes.j](Systems/MagRes.j) | — | — |
| 048 | Systems | PhysRes | [Systems/PhysRes.j](Systems/PhysRes.j) | — | — |
| 049 | Systems | slow | [Systems/slow.j](Systems/slow.j) | — | — |
| 050 | Systems | NeviSound | [Systems/NeviSound.j](Systems/NeviSound.j) | — | — |
| 051 | Systems | Evol1 | [Systems/Evol1.j](Systems/Evol1.j) | — | — |
| 052 | Systems | Evol2 | [Systems/Evol2.j](Systems/Evol2.j) | — | — |
| 053 | Systems | sukuna spawn | [Systems/sukuna_spawn.j](Systems/sukuna_spawn.j) | — | — |
| 054 | Systems | ESC | [Systems/ESC.j](Systems/ESC.j) | — | — |
| 055 | Systems | Killme | [Systems/Killme.j](Systems/Killme.j) | KillmeProgress | GearSystems, WOSUI |
| 056 | Systems | AnimCheck | [Systems/AnimCheck.j](Systems/AnimCheck.j) | — | — |
| 057 | Systems | hpset | [Systems/hpset.j](Systems/hpset.j) | — | — |
| 058 | Systems | mpset | [Systems/mpset.j](Systems/mpset.j) | — | — |
| 059 | Systems | ArrowLeft | [Systems/ArrowLeft.j](Systems/ArrowLeft.j) | — | — |
| 060 | Systems | ArrowUp | [Systems/ArrowUp.j](Systems/ArrowUp.j) | — | — |
| 061 | Systems | ArrowDown | [Systems/ArrowDown.j](Systems/ArrowDown.j) | — | — |
| 062 | Systems | ArrowRight | [Systems/ArrowRight.j](Systems/ArrowRight.j) | — | — |
| 063 | Systems | ButtonPressed | [Systems/ButtonPressed.j](Systems/ButtonPressed.j) | — | — |
| 064 | Systems | ButtonPressed ESC | [Systems/ButtonPressed_ESC.j](Systems/ButtonPressed_ESC.j) | — | — |
| 065 | Systems | ButtonUnPressed_ESC | [Systems/ButtonUnPressed_ESC.j](Systems/ButtonUnPressed_ESC.j) | — | — |
| 066 | Systems | EnterBase | [Systems/EnterBase.j](Systems/EnterBase.j) | — | — |
| 067 | Systems | EnterRegion | [Systems/EnterRegion.j](Systems/EnterRegion.j) | — | — |
| 068 | Systems | LeavesBase | [Systems/LeavesBase.j](Systems/LeavesBase.j) | — | — |
| 069 | Systems | LeavesRegion | [Systems/LeavesRegion.j](Systems/LeavesRegion.j) | — | — |
| 070 | Systems | ItemCupOfTea | [Systems/ItemCupOfTea.j](Systems/ItemCupOfTea.j) | — | — |
| 071 | Systems | ItemEnter | [Systems/ItemEnter.j](Systems/ItemEnter.j) | — | — |
| 072 | Systems | ItemLeave | [Systems/ItemLeave.j](Systems/ItemLeave.j) | — | — |
| 073 | Items | Items | [Items/Items.j](Items/Items.j) | ItemsSpells | GearSystems |
| 074 | Heroes | Toji | [Heroes/Toji.j](Heroes/Toji.j) | TojiSpells | GearSystems |
| 075 | Heroes | Raiden | [Heroes/Raiden.j](Heroes/Raiden.j) | RaidenSpells | GearSystems |
| 076 | Heroes | Frieren | [Heroes/Frieren.j](Heroes/Frieren.j) | FrierenSpells | GearSystems |
| 077 | Heroes | Ainz | [Heroes/Ainz.j](Heroes/Ainz.j) | AinzSpells | GearSystems |
| 078 | Heroes | Laxus | [Heroes/Laxus.j](Heroes/Laxus.j) | LaxusSpells | GearSystems, NatsuSpells |
| 079 | Heroes | Brandish | [Heroes/Brandish.j](Heroes/Brandish.j) | BrandishSpells | GearSystems |
| 080 | Heroes | Patriot | [Heroes/Patriot.j](Heroes/Patriot.j) | PatriotSpells | GearSystems |
| 081 | Heroes | Asta | [Heroes/Asta.j](Heroes/Asta.j) | AstaSpells | GearSystems |
| 082 | Heroes | Gojo | [Heroes/Gojo.j](Heroes/Gojo.j) | GojoSpells | GearSystems |
| 083 | Heroes | Bambietta | [Heroes/Bambietta.j](Heroes/Bambietta.j) | BambiettaSpells | GearSystems |
| 084 | Heroes | Kirito | [Heroes/Kirito.j](Heroes/Kirito.j) | KiritoSpells | GearSystems |
| 085 | Heroes | Alucard | [Heroes/Alucard.j](Heroes/Alucard.j) | AlucardSpells | GearSystems |
| 086 | Heroes | Starrk | [Heroes/Starrk.j](Heroes/Starrk.j) | StarrkSpells | GearSystems |
| 087 | Heroes | Takeshi | [Heroes/Takeshi.j](Heroes/Takeshi.j) | TakeshiSpells | GearSystems |
| 088 | Heroes | Barragan | [Heroes/Barragan.j](Heroes/Barragan.j) | BarraganSpells | GearSystems |
| 089 | Heroes | Mahoraga | [Heroes/Mahoraga.j](Heroes/Mahoraga.j) | MahoragaSpells | GearSystems |
| 090 | Heroes | Harribel | [Heroes/Harribel.j](Heroes/Harribel.j) | HarribelSpells | GearSystems |
| 091 | Heroes | Tsuna | [Heroes/Tsuna.j](Heroes/Tsuna.j) | TsunaSpells | GearSystems |
| 092 | Heroes | Rimuru | [Heroes/Rimuru.j](Heroes/Rimuru.j) | RimuruSpells | GearSystems |
| 093 | Heroes | DarkShiki | [Heroes/DarkShiki.j](Heroes/DarkShiki.j) | DarkShikiSpells | GearSystems |
| 094 | Heroes | BazzB | [Heroes/BazzB.j](Heroes/BazzB.j) | BazzBSpells | GearSystems |
| 095 | Heroes | Neuvillette | [Heroes/Neuvillette.j](Heroes/Neuvillette.j) | NeuvilletteSpells | GearSystems |
| 096 | Heroes | Okarun | [Heroes/Okarun.j](Heroes/Okarun.j) | OkarunSpells | GearSystems |
| 097 | Heroes | Akainu | [Heroes/Akainu.j](Heroes/Akainu.j) | AkainuSpells | GearSystems |
| 098 | Heroes | Inori | [Heroes/Inori.j](Heroes/Inori.j) | InoriSpells | GearSystems |
| 099 | Heroes | Kenjaku | [Heroes/Kenjaku.j](Heroes/Kenjaku.j) | KenjakuSpells | GearSystems |
| 100 | Heroes | AlterSaber | [Heroes/AlterSaber.j](Heroes/AlterSaber.j) | AlterSaberSpells | GearSystems |
| 101 | Heroes | Natsu | [Heroes/Natsu.j](Heroes/Natsu.j) | NatsuSpells | GearSystems |
| 102 | Heroes | Kyoraku | [Heroes/Kyoraku.j](Heroes/Kyoraku.j) | KyorakuSpells | GearSystems |
| 103 | Heroes | Tomioka | [Heroes/Tomioka.j](Heroes/Tomioka.j) | TomiokaSpells | GearSystems |
| 104 | Erza | ErzaQ | [Heroes/Erza/ErzaQ.j](Heroes/Erza/ErzaQ.j) | ErzaQSpells | GearSystems, ErzaTSpells |
| 105 | Erza | ErzaW | [Heroes/Erza/ErzaW.j](Heroes/Erza/ErzaW.j) | ErzaWSpells | GearSystems, ErzaTSpells |
| 106 | Erza | ErzaE | [Heroes/Erza/ErzaE.j](Heroes/Erza/ErzaE.j) | ErzaESpells | GearSystems, ErzaTSpells |
| 107 | Erza | ErzaR | [Heroes/Erza/ErzaR.j](Heroes/Erza/ErzaR.j) | ErzaRSpells | GearSystems |
| 108 | Erza | ErzaT | [Heroes/Erza/ErzaT.j](Heroes/Erza/ErzaT.j) | ErzaTSpells | GearSystems |
| 109 | Erza | ErzaG2 Nakagami | [Heroes/Erza/ErzaG2_Nakagami.j](Heroes/Erza/ErzaG2_Nakagami.j) | ErzaG1Spells | GearSystems |
| 110 | Erza | ErzaG2 Fairy | [Heroes/Erza/ErzaG2_Fairy.j](Heroes/Erza/ErzaG2_Fairy.j) | ErzaG2Spells | GearSystems |
| 111 | Erza | ErzaBase | [Heroes/Erza/ErzaBase.j](Heroes/Erza/ErzaBase.j) | ErzaBase | GearSystems, ErzaQSpells |
| 112 | Heroes | Milim | [Heroes/Milim.j](Heroes/Milim.j) | MilimSpells | GearSystems, WOSUI |
| 113 | Heroes | Crocodile | [Heroes/Crocodile.j](Heroes/Crocodile.j) | CrocodileSpells | GearSystems, GearSystems2, AAADest, TasAbilityChargeBox |
| 114 | Heroes | Frostnova | [Heroes/Frostnova.j](Heroes/Frostnova.j) | FrostnovaSpells | GearSystems |
