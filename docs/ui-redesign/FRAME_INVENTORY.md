# Production UI frame inventory

Generated from active source in triggers/. Commented prototypes are excluded.
FRAME roots can migrate to WOSUI; SIMPLEFRAME roots retain a native simple parent.

## triggers/Heroes/Ainz.j

12 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1294 | Loop_AinzW | `set frame1_pas1[check2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1299 | Loop_AinzW | `set frame1_pas2[check2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame1_pas1[check2], "", 0)` |
| 1301 | Loop_AinzW | `set frame1_pas3[check2] = BlzCreateFrameByType("STATUSBAR", "", frame1_pas1[check2], "", 0)` |
| 1304 | Loop_AinzW | `set frame1_pas4[check2] = BlzCreateFrameByType("BACKDROP", "SS", frame1_pas1[check2], "", 0)` |
| 1307 | Loop_AinzW | `set frame1_pas5[check2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1_pas1[check2], "", 0)` |
| 1309 | Loop_AinzW | `set frame1_pas6[check2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1_pas1[check2], "", 0)` |
| 2184 | AinzT_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 2189 | AinzT_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 2191 | AinzT_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 2194 | AinzT_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 2197 | AinzT_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 2199 | AinzT_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |

## triggers/Heroes/AlterSaber.j

6 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1108 | Loop_AlterSaberR | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1113 | Loop_AlterSaberR | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 1115 | Loop_AlterSaberR | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 1118 | Loop_AlterSaberR | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 1121 | Loop_AlterSaberR | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1123 | Loop_AlterSaberR | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |

## triggers/Heroes/Alucard.j

12 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1032 | AlucardW2_Start | `set frame2_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1037 | AlucardW2_Start | `set frame2_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame2_pas1[k2], "", 0)` |
| 1039 | AlucardW2_Start | `set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)` |
| 1042 | AlucardW2_Start | `set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)` |
| 1045 | AlucardW2_Start | `set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 1047 | AlucardW2_Start | `set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 1451 | Loop_AlucardR | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1456 | Loop_AlucardR | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 1458 | Loop_AlucardR | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 1461 | Loop_AlucardR | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 1464 | Loop_AlucardR | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1466 | Loop_AlucardR | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |

## triggers/Heroes/Asta.j

6 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1643 | AstaT_Start | `set frameAsta_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1648 | AstaT_Start | `set frameAsta_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frameAsta_pas1[k2], "", 0)` |
| 1650 | AstaT_Start | `set frameAsta_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frameAsta_pas1[k2], "", 0)` |
| 1653 | AstaT_Start | `set frameAsta_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frameAsta_pas1[k2], "", 0)` |
| 1656 | AstaT_Start | `set frameAsta_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameAsta_pas1[k2], "", 0)` |
| 1658 | AstaT_Start | `set frameAsta_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameAsta_pas1[k2], "", 0)` |

## triggers/Heroes/Bambietta.j

6 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1878 | Loop_BambiettaT | `set framebambietta_morph1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1883 | Loop_BambiettaT | `set framebambietta_morph2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", framebambietta_morph1[k2], "", 0)` |
| 1885 | Loop_BambiettaT | `set framebambietta_morph3[k2] = BlzCreateFrameByType("STATUSBAR", "", framebambietta_morph1[k2], "", 0)` |
| 1888 | Loop_BambiettaT | `set framebambietta_morph4[k2] = BlzCreateFrameByType("BACKDROP", "SS", framebambietta_morph1[k2], "", 0)` |
| 1891 | Loop_BambiettaT | `set framebambietta_morph5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", framebambietta_morph1[k2], "", 0)` |
| 1893 | Loop_BambiettaT | `set framebambietta_morph6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", framebambietta_morph1[k2], "", 0)` |

## triggers/Heroes/Barragan.j

12 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 835 | Loop_BarraganE | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 840 | Loop_BarraganE | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 842 | Loop_BarraganE | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 845 | Loop_BarraganE | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 848 | Loop_BarraganE | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 850 | Loop_BarraganE | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1399 | BarraganT_Start | `set frame2_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1404 | BarraganT_Start | `set frame2_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame2_pas1[k2], "", 0)` |
| 1406 | BarraganT_Start | `set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)` |
| 1409 | BarraganT_Start | `set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)` |
| 1412 | BarraganT_Start | `set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 1414 | BarraganT_Start | `set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |

## triggers/Heroes/DarkShiki.j

6 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 358 | Loop_DarkShikiQ | `set frame2_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 363 | Loop_DarkShikiQ | `set frame2_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame2_pas1[k2], "", 0)` |
| 365 | Loop_DarkShikiQ | `set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)` |
| 368 | Loop_DarkShikiQ | `set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)` |
| 371 | Loop_DarkShikiQ | `set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 373 | Loop_DarkShikiQ | `set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |

## triggers/Heroes/Erza/ErzaG2_Nakagami.j

6 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 840 | ErzaG_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 845 | ErzaG_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 847 | ErzaG_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 850 | ErzaG_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS",frame_pas1[k2], "", 0)` |
| 857 | ErzaG_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 859 | ErzaG_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |

## triggers/Heroes/Erza/ErzaR.j

12 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1018 | ErzaTT_Start | `set frame2_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1023 | ErzaTT_Start | `set frame2_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame2_pas1[k2], "", 0)` |
| 1025 | ErzaTT_Start | `set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)` |
| 1028 | ErzaTT_Start | `set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)` |
| 1031 | ErzaTT_Start | `set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 1033 | ErzaTT_Start | `set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 1348 | ErzaF_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1353 | ErzaF_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 1355 | ErzaF_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 1358 | ErzaF_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 1361 | ErzaF_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1363 | ErzaF_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |

## triggers/Heroes/Erza/ErzaT.j

6 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1589 | ErzaTT_Start | `set frame_pas1[check] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1594 | ErzaTT_Start | `set frame_pas2[check] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[check], "", 0)` |
| 1596 | ErzaTT_Start | `set frame_pas3[check] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[check], "", 0)` |
| 1599 | ErzaTT_Start | `set frame_pas4[check] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[check], "", 0)` |
| 1602 | ErzaTT_Start | `set frame_pas5[check] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[check], "", 0)` |
| 1604 | ErzaTT_Start | `set frame_pas6[check] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[check], "", 0)` |

## triggers/Heroes/Frieren.j

6 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1883 | FrierenT_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1888 | FrierenT_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 1890 | FrierenT_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 1893 | FrierenT_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 1896 | FrierenT_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1898 | FrierenT_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |

## triggers/Heroes/Gojo.j

12 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1313 | GojoE_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1318 | GojoE_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 1320 | GojoE_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 1328 | GojoE_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 1331 | GojoE_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1333 | GojoE_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 2183 | GojoT2_Start | `set frame2_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 2188 | GojoT2_Start | `set frame2_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame2_pas1[k2], "", 0)` |
| 2190 | GojoT2_Start | `set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)` |
| 2193 | GojoT2_Start | `set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)` |
| 2196 | GojoT2_Start | `set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 2198 | GojoT2_Start | `set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |

## triggers/Heroes/Harribel.j

12 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 567 | Loop_HarribelE | `set frame2_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 572 | Loop_HarribelE | `set frame2_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame2_pas1[k2], "", 0)` |
| 574 | Loop_HarribelE | `set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)` |
| 577 | Loop_HarribelE | `set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)` |
| 580 | Loop_HarribelE | `set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 582 | Loop_HarribelE | `set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 1335 | HarribelG_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1340 | HarribelG_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 1342 | HarribelG_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 1345 | HarribelG_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 1348 | HarribelG_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1350 | HarribelG_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |

## triggers/Heroes/Inori.j

26 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1123 | Loop_InoriE | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1128 | Loop_InoriE | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 1130 | Loop_InoriE | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 1133 | Loop_InoriE | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 1136 | Loop_InoriE | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1138 | Loop_InoriE | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 2027 | Loop_InoriT2 | `set frame2_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 2032 | Loop_InoriT2 | `set frame2_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame2_pas1[k2], "", 0)` |
| 2034 | Loop_InoriT2 | `set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)` |
| 2037 | Loop_InoriT2 | `set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)` |
| 2040 | Loop_InoriT2 | `set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 2042 | Loop_InoriT2 | `set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 2414 | InoriG_Start | `set inori_frame_pas1[k2] = WUI_Window("WOSInoriWeapons", main_frame, 0, 0)` |
| 2421 | InoriG_Start | `set inori_frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "Port", inori_frame_pas1[k2], "", 0)` |
| 2425 | InoriG_Start | `set inori_frame_pas3[k2] = BlzCreateFrameByType("BACKDROP", "Port", inori_frame_pas1[k2], "", 0)` |
| 2431 | InoriG_Start | `set inori_frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", inori_frame_pas1[k2], "", 0)` |
| 2435 | InoriG_Start | `set inori_frame_pas5[k2] = BlzCreateFrameByType("BUTTON", "MyIconButton", inori_frame_pas1[k2], "ScoreScreenTabButtonTemplate", 0)` |
| 2440 | InoriG_Start | `set inori_frame_pas6[k2] = BlzCreateFrameByType("BACKDROP", "SS", inori_frame_pas1[k2], "", 0)` |
| 2444 | InoriG_Start | `set inori_frame_pas7[k2] = BlzCreateFrameByType("BUTTON", "MyIconButton", inori_frame_pas1[k2], "ScoreScreenTabButtonTemplate", 0)` |
| 2447 | InoriG_Start | `set inori_frame_pas8[k2] = BlzCreateFrameByType("SPRITE", "justAName", inori_frame_pas1[k2], "WarCraftIIILogo", 0)` |
| 2455 | InoriG_Start | `set inori_frame_pas9[k2] = BlzCreateFrameByType("BACKDROP", "SS", inori_frame_pas1[k2], "", 0)` |
| 2459 | InoriG_Start | `set inori_frame_pas10[k2] = BlzCreateFrameByType("BUTTON", "MyIconButton", inori_frame_pas1[k2], "ScoreScreenTabButtonTemplate", 0)` |
| 2464 | InoriG_Start | `set inori_frame_pas11[k2] = BlzCreateFrameByType("BACKDROP", "SS", inori_frame_pas1[k2], "", 0)` |
| 2468 | InoriG_Start | `set inori_frame_pas12[k2] = BlzCreateFrameByType("BUTTON", "MyIconButton", inori_frame_pas1[k2], "ScoreScreenTabButtonTemplate", 0)` |
| 2473 | InoriG_Start | `set inori_frame_pas13[k2] = BlzCreateFrame("EscMenuTextAreaTemplate", inori_frame_pas1[k2], 0, 0)` |
| 2480 | InoriG_Start | `set inori_frame_pas14[k2] = BlzCreateFrame("EscMenuTextAreaTemplate", inori_frame_pas1[k2], 0, 0)` |

## triggers/Heroes/Kenjaku.j

16 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1061 | KenjakuR_Start | `set frame0_pas1[k2] = BlzCreateFrameByType("SIMPLEFRAME", "2Face", WUI_GetSimpleRoot(), "", 0)` |
| 1067 | KenjakuR_Start | `set frame0_pas2[k2] = BlzCreateFrameByType("SIMPLESTATUSBAR", "2FaceBackGround", frame0_pas1[k2], "", 0)` |
| 1068 | KenjakuR_Start | `set frame0_pas3[k2] = BlzCreateFrameByType("SIMPLESTATUSBAR", "2FaceForeGround", frame0_pas2[k2], "", 0)` |
| 1074 | KenjakuR_Start | `call WUI_SimpleBorder(frame0_pas1[k2])` |
| 1632 | KenjakuF_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1637 | KenjakuF_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 1639 | KenjakuF_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 1642 | KenjakuF_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 1645 | KenjakuF_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1647 | KenjakuF_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1781 | Loop_KenjakuF2 | `set frame2_pas1[ k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1783 | Loop_KenjakuF2 | `set frame2_pas2[ k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame2_pas1[ k2], "", 0)` |
| 1785 | Loop_KenjakuF2 | `set frame2_pas3[ k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[ k2], "", 0)` |
| 1788 | Loop_KenjakuF2 | `set frame2_pas4[ k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[ k2], "", 0)` |
| 1791 | Loop_KenjakuF2 | `set frame2_pas5[ k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[ k2], "", 0)` |
| 1793 | Loop_KenjakuF2 | `set frame2_pas6[ k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[ k2], "", 0)` |

## triggers/Heroes/Kirito.j

6 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 813 | KiritoR_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 818 | KiritoR_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 820 | KiritoR_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 823 | KiritoR_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 826 | KiritoR_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 828 | KiritoR_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |

## triggers/Heroes/Kyoraku.j

18 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 552 | KyorakuW_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 557 | KyorakuW_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 559 | KyorakuW_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 562 | KyorakuW_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 565 | KyorakuW_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 567 | KyorakuW_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1512 | Loop_KyorakuT | `set frame_KyorBankai1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1514 | Loop_KyorakuT | `set frame_KyorBankai12[k2] = WUI_Window("WOSKyorakuHelp", main_frame, 0, 0)` |
| 1517 | Loop_KyorakuT | `set frame_KyorBankai2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_KyorBankai1[k2], "", 0)` |
| 1519 | Loop_KyorakuT | `set frame_KyorBankai3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_KyorBankai1[k2], "", 0)` |
| 1522 | Loop_KyorakuT | `set frame_KyorBankai4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_KyorBankai1[k2], "", 0)` |
| 1525 | Loop_KyorakuT | `set frame_KyorBankai5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_KyorBankai1[k2], "", 0)` |
| 1527 | Loop_KyorakuT | `set frame_KyorBankai6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_KyorBankai1[k2], "", 0)` |
| 1533 | Loop_KyorakuT | `set frame_KyorBankai7[k2] = BlzCreateFrame("EscMenuTextAreaTemplate", frame_KyorBankai12[k2], 0, 0)` |
| 1539 | Loop_KyorakuT | `set frame_KyorBankai8[k2] = BlzCreateFrameByType("BUTTON", "MyIconButton", main_frame, "ScoreScreenTabButtonTemplate", 0)` |
| 1542 | Loop_KyorakuT | `set frame_KyorBankai9[k2] = BlzCreateFrameByType("BUTTON", "MyIconButton", main_frame, "ScoreScreenTabButtonTemplate", 0)` |
| 1546 | Loop_KyorakuT | `set frame_KyorBankai10[k2] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", frame_KyorBankai8[k2], "", 0)` |
| 1550 | Loop_KyorakuT | `set frame_KyorBankai11[k2] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", frame_KyorBankai9[k2], "", 0)` |

## triggers/Heroes/Laxus.j

6 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 2087 | LaxusG_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 2092 | LaxusG_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 2094 | LaxusG_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 2097 | LaxusG_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 2100 | LaxusG_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 2102 | LaxusG_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |

## triggers/Heroes/Natsu.j

12 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1275 | NatsuG2_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1280 | NatsuG2_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 1282 | NatsuG2_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 1285 | NatsuG2_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 1288 | NatsuG2_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1290 | NatsuG2_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1560 | NatsuPas_Start | `set frame2_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1565 | NatsuPas_Start | `set frame2_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame2_pas1[k2], "", 0)` |
| 1567 | NatsuPas_Start | `set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)` |
| 1570 | NatsuPas_Start | `set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)` |
| 1573 | NatsuPas_Start | `set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 1575 | NatsuPas_Start | `set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |

## triggers/Heroes/Okarun.j

6 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1057 | OkarunF_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1062 | OkarunF_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 1064 | OkarunF_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 1067 | OkarunF_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 1070 | OkarunF_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1072 | OkarunF_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |

## triggers/Heroes/Patriot.j

6 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 918 | PatriotE_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 923 | PatriotE_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 925 | PatriotE_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 928 | PatriotE_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 931 | PatriotE_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 933 | PatriotE_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |

## triggers/Heroes/Raiden.j

18 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 755 | RaidenW_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 760 | RaidenW_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 762 | RaidenW_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 765 | RaidenW_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 768 | RaidenW_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 770 | RaidenW_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1082 | RaidenTW_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1087 | RaidenTW_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 1089 | RaidenTW_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 1092 | RaidenTW_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 1095 | RaidenTW_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1097 | RaidenTW_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1816 | Loop_RaidenT | `set frame2_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1821 | Loop_RaidenT | `set frame2_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame2_pas1[k2], "", 0)` |
| 1823 | Loop_RaidenT | `set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)` |
| 1826 | Loop_RaidenT | `set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)` |
| 1829 | Loop_RaidenT | `set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 1831 | Loop_RaidenT | `set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |

## triggers/Heroes/Rimuru.j

12 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 3835 | RimuruEvol2_Start | `set frameRimuru2_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 3840 | RimuruEvol2_Start | `set frameRimuru2_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frameRimuru2_pas1[k2], "", 0)` |
| 3842 | RimuruEvol2_Start | `set frameRimuru2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frameRimuru2_pas1[k2], "", 0)` |
| 3845 | RimuruEvol2_Start | `set frameRimuru2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frameRimuru2_pas1[k2], "", 0)` |
| 3848 | RimuruEvol2_Start | `set frameRimuru2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameRimuru2_pas1[k2], "", 0)` |
| 3850 | RimuruEvol2_Start | `set frameRimuru2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameRimuru2_pas1[k2], "", 0)` |
| 3886 | RimuruEvol_Start | `set frameRimuru1_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 3891 | RimuruEvol_Start | `set frameRimuru1_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frameRimuru1_pas1[k2], "", 0)` |
| 3893 | RimuruEvol_Start | `set frameRimuru1_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frameRimuru1_pas1[k2], "", 0)` |
| 3896 | RimuruEvol_Start | `set frameRimuru1_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frameRimuru1_pas1[k2], "", 0)` |
| 3899 | RimuruEvol_Start | `set frameRimuru1_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameRimuru1_pas1[k2], "", 0)` |
| 3901 | RimuruEvol_Start | `set frameRimuru1_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameRimuru1_pas1[k2], "", 0)` |

## triggers/Heroes/Starrk.j

12 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1020 | Loop_StarrkE | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1025 | Loop_StarrkE | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 1027 | Loop_StarrkE | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 1030 | Loop_StarrkE | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 1033 | Loop_StarrkE | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1035 | Loop_StarrkE | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1992 | Loop_StarrkT | `set frame1_pas1[check2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1997 | Loop_StarrkT | `set frame1_pas2[check2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame1_pas1[check2], "", 0)` |
| 1999 | Loop_StarrkT | `set frame1_pas3[check2] = BlzCreateFrameByType("STATUSBAR", "", frame1_pas1[check2], "", 0)` |
| 2002 | Loop_StarrkT | `set frame1_pas4[check2] = BlzCreateFrameByType("BACKDROP", "SS", frame1_pas1[check2], "", 0)` |
| 2005 | Loop_StarrkT | `set frame1_pas5[check2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1_pas1[check2], "", 0)` |
| 2007 | Loop_StarrkT | `set frame1_pas6[check2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1_pas1[check2], "", 0)` |

## triggers/Heroes/Takeshi.j

12 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 133 | TakeshiGAdd_Start | `set frameTakeshi_pas1 [k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 138 | TakeshiGAdd_Start | `set frameTakeshi_pas2 [k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frameTakeshi_pas1[k2], "", 0)` |
| 140 | TakeshiGAdd_Start | `set frameTakeshi_pas3 [k2] = BlzCreateFrameByType("STATUSBAR", "", frameTakeshi_pas1[k2], "", 0)` |
| 143 | TakeshiGAdd_Start | `set frameTakeshi_pas4 [k2] = BlzCreateFrameByType("BACKDROP", "SS", frameTakeshi_pas1[k2], "", 0)` |
| 146 | TakeshiGAdd_Start | `set frameTakeshi_pas5 [k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameTakeshi_pas1[k2], "", 0)` |
| 148 | TakeshiGAdd_Start | `set frameTakeshi_pas6 [k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameTakeshi_pas1[k2], "", 0)` |
| 1692 | Loop_TakeshiG | `set frame2_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1697 | Loop_TakeshiG | `set frame2_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame2_pas1[k2], "", 0)` |
| 1699 | Loop_TakeshiG | `set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)` |
| 1702 | Loop_TakeshiG | `set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)` |
| 1705 | Loop_TakeshiG | `set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 1707 | Loop_TakeshiG | `set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |

## triggers/Heroes/Tomioka.j

6 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1106 | TomiokaG_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 1111 | TomiokaG_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 1113 | TomiokaG_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 1116 | TomiokaG_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS",frame_pas1[k2], "", 0)` |
| 1119 | TomiokaG_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 1121 | TomiokaG_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |

## triggers/Heroes/Tsuna.j

23 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 2047 | TsunaT_Start | `set frame0_pas1[k2] = BlzCreateFrameByType("SIMPLEFRAME", "2Face", WUI_GetSimpleRoot(), "", 0)` |
| 2053 | TsunaT_Start | `set frame0_pas2[k2] = BlzCreateFrameByType("SIMPLESTATUSBAR", "2FaceBackGround", frame0_pas1[k2], "", 0)` |
| 2054 | TsunaT_Start | `set frame0_pas3[k2] = BlzCreateFrameByType("SIMPLESTATUSBAR", "2FaceForeGround", frame0_pas2[k2], "", 0)` |
| 2060 | TsunaT_Start | `call WUI_SimpleBorder(frame0_pas1[k2])` |
| 2061 | TsunaT_Start | `set frame0_pas4[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", main_frame, "", 0)` |
| 2429 | TsunaF_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 2434 | TsunaF_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 2436 | TsunaF_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 2439 | TsunaF_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 2442 | TsunaF_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 2444 | TsunaF_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 2589 | TsunaG_Start | `set frame1_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 2594 | TsunaG_Start | `set frame1_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame1_pas1[k2], "", 0)` |
| 2596 | TsunaG_Start | `set frame1_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame1_pas1[k2], "", 0)` |
| 2599 | TsunaG_Start | `set frame1_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame1_pas1[k2], "", 0)` |
| 2602 | TsunaG_Start | `set frame1_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1_pas1[k2], "", 0)` |
| 2604 | TsunaG_Start | `set frame1_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1_pas1[k2], "", 0)` |
| 2714 | Loop_TsunaG2 | `set frame2_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 2719 | Loop_TsunaG2 | `set frame2_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame2_pas1[k2], "", 0)` |
| 2721 | Loop_TsunaG2 | `set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)` |
| 2724 | Loop_TsunaG2 | `set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)` |
| 2727 | Loop_TsunaG2 | `set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 2729 | Loop_TsunaG2 | `set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |

## triggers/Systems/DecorDestroy_and_Erza_Debuff.j

14 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 242 | ErzaBar_Start | `set frame2_pas1[k2] = WUI_Window("WOSErzaOrigin", main_frame, 0, 0)` |
| 247 | ErzaBar_Start | `set frame2_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSOriginBack", frame2_pas1[k2], "", 0)` |
| 250 | ErzaBar_Start | `set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)` |
| 256 | ErzaBar_Start | `set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)` |
| 260 | ErzaBar_Start | `set frame2_pas5[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)` |
| 264 | ErzaBar_Start | `set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 268 | ErzaBar_Start | `set frame2_pas7[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)` |
| 280 | ErzaBar_Start | `set frame2_pas8[k2] = BlzCreateFrameByType("SPRITE", "justAName", frame2_pas1[k2], "WarCraftIIILogo", 0)` |
| 341 | MyFlushStacks_Start | `set frame_pas1[k2] = WUI_Window("WOSHeroMeter", main_frame, 0, 0)` |
| 346 | MyFlushStacks_Start | `set frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", frame_pas1[k2], "", 0)` |
| 348 | MyFlushStacks_Start | `set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)` |
| 351 | MyFlushStacks_Start | `set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)` |
| 354 | MyFlushStacks_Start | `set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |
| 356 | MyFlushStacks_Start | `set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)` |

## triggers/Systems/Systems2.j

2 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 336 | CreateAllyCDFrame_Slot | `set FrameCD_Icon[ctx] = BlzCreateFrameByType("SIMPLEFRAME", "AllyIcon", origin, "2Face", 0)` |
| 342 | CreateAllyCDFrame_Slot | `set FrameCD_Cooldown[ctx] = BlzCreateFrameByType("SIMPLEFRAME", "AllyCD", origin, "2Cooldown", 0)` |

## triggers/Systems/TasBox.j

3 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 30 | CreatePortraitLabel | `local framehandle box = WUI_Panel("TasPortraitChargeBox", portrait, 0.015, 0.015)` |
| 31 | CreatePortraitLabel | `local framehandle text = BlzCreateFrameByType("TEXT", "TasPortraitChargeText", box, "", 0)` |
| 32 | CreatePortraitLabel | `local framehandle edge = WUI_Border("TasPortraitChargeEdge", box)` |

## triggers/WOS_Start/Captain_Draft.j

9 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 620 | CaptainDraft_CreateUI | `set CaptainDraftPanel = WUI_Window("WOSCaptainBans", parent, 0, 9500)` |
| 624 | CaptainDraft_CreateUI | `set CaptainDraftStatus = BlzCreateFrameByType("TEXT", "CaptainDraftStatus", CaptainDraftPanel, "", 9501)` |
| 631 | CaptainDraft_CreateUI | `set CaptainDraftBanLabel = BlzCreateFrameByType("TEXT", "CaptainDraftBanLabel", CaptainDraftPanel, "", 9502)` |
| 639 | CaptainDraft_CreateUI | `set CaptainDraftBanButton[i] = BlzCreateFrameByType("BUTTON", "CaptainDraftBanButton", CaptainDraftPanel, "ScoreScreenTabButtonTemplate", 9510 + i)` |
| 642 | CaptainDraft_CreateUI | `set CaptainDraftBanIcon[i] = BlzCreateFrameByType("BACKDROP", "CaptainDraftBanIcon", CaptainDraftBanButton[i], "", 9520 + i)` |
| 645 | CaptainDraft_CreateUI | `set tooltip = WUI_Window("CaptainDraftBanTooltip", CaptainDraftPanel, 0, 9550 + i)` |
| 650 | CaptainDraft_CreateUI | `set tooltipText = BlzCreateFrameByType("TEXT", "CaptainDraftBanTooltipText", tooltip, "", 9560 + i)` |
| 659 | CaptainDraft_CreateUI | `set CaptainDraftBanHighlight[i] = BlzCreateFrameByType("SPRITE", "CaptainDraftBanHighlight", CaptainDraftPanel, "WarCraftIIILogo", 9570 + i)` |
| 672 | CaptainDraft_CreateUI | `set CaptainDraftClaimHover[i] = BlzCreateFrameByType("SPRITE", "CaptainDraftClaimHover", FRAME_MAIN, "WarCraftIIILogo", 9590 + i)` |

## triggers/WOS_Start/ChatCommand.j

10 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 602 | CreateEmojiFeed | `set EmojiFeedName[i] = BlzCreateFrameByType("TEXT", "NativeEmojiFeedName", WUI_GetRoot(), "", 0)` |
| 609 | CreateEmojiFeed | `set EmojiFeedIcon[i] = BlzCreateFrameByType("BACKDROP", "NativeEmojiFeedIcon", WUI_GetRoot(), "", 0)` |
| 625 | CreateEmojiPalette | `set EmojiToggle = BlzCreateFrameByType("BUTTON", "NativeEmojiToggle", WUI_GetRoot(), "", 0)` |
| 628 | CreateEmojiPalette | `set EmojiToggleIcon = BlzCreateFrameByType("BACKDROP", "NativeEmojiToggleIcon", EmojiToggle, "", 0)` |
| 634 | CreateEmojiPalette | `set EmojiMuteButton = BlzCreateFrameByType("BUTTON", "NativeEmojiMuteButton", WUI_GetRoot(), "", 0)` |
| 636 | CreateEmojiPalette | `set EmojiMuteIcon = WUI_Panel("WOSChatMuteButtonBack", EmojiMuteButton, 0.023, 0.023)` |
| 640 | CreateEmojiPalette | `set EmojiMuteIcon = BlzCreateFrameByType("BACKDROP", "NativeEmojiMuteIcon", EmojiMuteButton, "", 0)` |
| 649 | CreateEmojiPalette | `set EmojiPanel = WUI_Window("WOSChatEmojiWindow", WUI_GetRoot(), 1, 0)` |
| 669 | CreateEmojiPalette | `set EmojiButton[i] = BlzCreateFrameByType("BUTTON", "NativeEmojiButton", WUI_GetRoot(), "ScoreScreenTabButtonTemplate", 0)` |
| 675 | CreateEmojiPalette | `set EmojiButtonIcon[i] = BlzCreateFrameByType("BACKDROP", "NativeEmojiButtonIcon", EmojiButton[i], "", 0)` |

## triggers/WOS_Start/DefaultArmorChangeStable_Copy.j

17 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 45 | UNITSTAT_CreateToolbar | `set UNITSTAT_Shop = BlzCreateFrameByType("BUTTON", "WOSShopToolbar", WUI_GetRoot(), "", 0)` |
| 47 | UNITSTAT_CreateToolbar | `set icon = BlzCreateFrameByType("BACKDROP", "WOSShopToolbarIcon", UNITSTAT_Shop, "", 0)` |
| 52 | UNITSTAT_CreateToolbar | `set UNITSTAT_Emotes = BlzCreateFrameByType("BUTTON", "WOSEmotesToolbar", WUI_GetRoot(), "", 0)` |
| 54 | UNITSTAT_CreateToolbar | `set icon = BlzCreateFrameByType("BACKDROP", "WOSEmotesToolbarIcon", UNITSTAT_Emotes, "", 0)` |
| 58 | UNITSTAT_CreateToolbar | `set text = BlzCreateFrameByType("TEXT", "WOSEmotesToolbarHotkey", UNITSTAT_Emotes, "", 0)` |
| 73 | UNITSTAT_Text | `local framehandle text = BlzCreateFrameByType("TEXT", name, parent, "", 0)` |
| 83 | UNITSTAT_WidgetCreate | `set UNITSTAT_Widget[index] = BlzCreateFrameByType("BUTTON", "WOSStatWidget", UNITSTAT_Root, "", index)` |
| 85 | UNITSTAT_WidgetCreate | `set icon = BlzCreateFrameByType("BACKDROP", "WOSStatIcon", UNITSTAT_Widget[index], "", index)` |
| 253 | UNITSTAT_CreateUI | `set back = WUI_Panel("WOSSelectedUnitBack", UNITSTAT_Root, 0.104, 0.088)` |
| 256 | UNITSTAT_CreateUI | `set UNITSTAT_Widget[6] = BlzCreateFrameByType("BUTTON", "WOSSelectedUnitIcon", UNITSTAT_Root, "", 0)` |
| 258 | UNITSTAT_CreateUI | `set UNITSTAT_Portrait = BlzCreateFrameByType("BACKDROP", "WOSSelectedUnitIconTexture", UNITSTAT_Widget[6], "", 0)` |
| 260 | UNITSTAT_CreateUI | `set back = WUI_Border("WOSSelectedUnitBorder", UNITSTAT_Widget[6])` |
| 272 | UNITSTAT_CreateUI | `set back = WUI_Panel("WOSVitalsBack", UNITSTAT_Root, 0.277, 0.009)` |
| 286 | UNITSTAT_CreateUI | `set UNITSTAT_Widget[7] = BlzCreateFrameByType("BUTTON", "WOSGoldHover", WUI_GetRoot(), "", 0)` |
| 288 | UNITSTAT_CreateUI | `set back = BlzCreateFrameByType("BACKDROP", "WOSGoldIcon", UNITSTAT_Widget[7], "", 0)` |
| 298 | UNITSTAT_CreateUI | `set UNITSTAT_Tooltip = WUI_Panel("WOSStatTooltip", WUI_GetRoot(), 0.225, 0.104)` |
| 300 | UNITSTAT_CreateUI | `set back = WUI_Border("WOSStatTooltipBorder", UNITSTAT_Tooltip)` |

## triggers/WOS_Start/EMOTES.j

6 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 467 | CreatePanel | `set EmojiPanel = WUI_Window("WOSEmoteWindow", WUI_GetRoot(), 1, 0)` |
| 477 | CreatePanel | `set EmojiCloseButton = BlzCreateFrameByType("BUTTON", "WosEmojiCloseButton", WUI_GetRoot(), "ScoreScreenTabButtonTemplate", 0)` |
| 483 | CreatePanel | `set EmojiCloseIcon = BlzCreateFrameByType("BACKDROP", "WosEmojiCloseIcon", EmojiCloseButton, "", 0)` |
| 489 | CreatePanel | `set EmojiCooldownText = BlzCreateFrameByType("TEXT", "WosEmojiCooldownText", WUI_GetRoot(), "", 0)` |
| 507 | CreatePanel | `set EmojiButton[i] = BlzCreateFrameByType("BUTTON", "WosEmojiButton", WUI_GetRoot(), "ScoreScreenTabButtonTemplate", 0)` |
| 513 | CreatePanel | `set EmojiButtonIcon[i] = BlzCreateFrameByType("BACKDROP", "WosEmojiButtonIcon", EmojiButton[i], "", 0)` |

## triggers/WOS_Start/MusicPlayer.j

16 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1079 | LMP_CreateIconButton | `local framehandle newFrame = BlzCreateFrameByType("BUTTON", "LMPIconButton", parent, "", context)` |
| 1089 | LMP_CreateIcon | `local framehandle icon = BlzCreateFrameByType("BACKDROP", "LMPIcon", iconParent, "", 0)` |
| 1100 | LMP_AttachNativeTooltip | `local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "LMPNativeTooltip", lmpPanel, "", context)` |
| 1101 | LMP_AttachNativeTooltip | `local framehandle tooltipText = BlzCreateFrameByType("TEXT", "LMPNativeTooltipText", tooltip, "", context)` |
| 1134 | LMP_CreateFrames | `set lmpLinkEdit = BlzCreateFrame("LMPLinkEditTemplate", consoleUI, 0, 0)` |
| 1135 | LMP_CreateFrames | `set lmpSeek = BlzCreateFrame("LMPHorizontalSliderTemplate", gameUI, 0, 0)` |
| 1136 | LMP_CreateFrames | `set lmpVolumeSlider = BlzCreateFrame("LMPHorizontalSliderTemplate", gameUI, 0, 1)` |
| 1187 | LMP_CreateFrames | `set lmpPanel = WUI_Window("WOSMusicWindow", consoleUI, 0, 0)` |
| 1194 | LMP_CreateFrames | `set title = BlzCreateFrameByType("TEXT", "LMPTitle", lmpPanel, "", 0)` |
| 1204 | LMP_CreateFrames | `set lmpNowPlaying = BlzCreateFrameByType("TEXT", "LMPNowPlaying", lmpPanel, "", 0)` |
| 1209 | LMP_CreateFrames | `set lmpEqualizer = BlzCreateFrameByType("TEXT", "LMPEqualizer", lmpPanel, "", 0)` |
| 1216 | LMP_CreateFrames | `set lmpTimeText = BlzCreateFrameByType("TEXT", "LMPTime", lmpPanel, "", 0)` |
| 1236 | LMP_CreateFrames | `set lmpSeekBlocker = BlzCreateFrameByType("BUTTON", "LMPProgressBlocker", gameUI, "", 600)` |
| 1245 | LMP_CreateFrames | `set lmpListBox = BlzCreateFrameByType("BACKDROP", "LMPListBox", lmpPanel, "", 0)` |
| 1261 | LMP_CreateFrames | `set lmpScroll = BlzCreateFrameByType("SLIDER", "LMPScroll", lmpPanel, "QuestMainListScrollBar", 0)` |
| 1299 | LMP_CreateFrames | `set lmpVolumeText = BlzCreateFrameByType("TEXT", "LMPVolumeText", lmpPanel, "", 0)` |

## triggers/WOS_Start/Player_Pick_Mode.j

43 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 747 | CreatePlayerPickUI | `set Frame_Cap2_MAIN = WUI_Window("WOSWindow", WUI_GetRoot(), 0, 0)` |
| 773 | CreatePlayerPickUI | `set Frame_Cap2_3[i] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap2_MAIN, "ScoreScreenTabButtonTemplate", 0)` |
| 777 | CreatePlayerPickUI | `set Frame_Cap2_4[i] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[i], "", 0)` |
| 784 | CreatePlayerPickUI | `set Frame_Cap2_9[i] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap2_MAIN, "WarCraftIIILogo", 0)` |
| 799 | CreatePlayerPickUI | `set Frame_Cap2_5[i] = BlzCreateFrameByType("TEXT", "MyIconTextAbi", Frame_Cap2_3[i], "", 0)` |
| 828 | CreatePlayerPickUI | `set Frame_Cap2_3[11] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap2_MAIN, "ScoreScreenTabButtonTemplate", 0)` |
| 833 | CreatePlayerPickUI | `set Frame_Cap2_4[11] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[11], "", 0)` |
| 843 | CreatePlayerPickUI | `set Frame_Cap2_9[11] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap2_MAIN, "WarCraftIIILogo", 0)` |
| 850 | CreatePlayerPickUI | `set Frame_Cap2_7[11] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[11], "", 0)` |
| 856 | CreatePlayerPickUI | `set Frame_Cap2_10 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap2_MAIN, "", 0)` |
| 861 | CreatePlayerPickUI | `set Frame_Cap2_13 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap2_MAIN, "", 0)` |
| 867 | CreatePlayerPickUI | `set Frame_Cap2_3[12] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap2_MAIN, "ScoreScreenTabButtonTemplate", 0)` |
| 872 | CreatePlayerPickUI | `set Frame_Cap2_4[12] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[12], "", 0)` |
| 882 | CreatePlayerPickUI | `set Frame_Cap2_9[12] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap2_MAIN, "WarCraftIIILogo", 0)` |
| 889 | CreatePlayerPickUI | `set Frame_Cap2_7[12] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[12], "", 0)` |
| 894 | CreatePlayerPickUI | `set Frame_Cap2_11 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap2_MAIN, "", 0)` |
| 900 | CreatePlayerPickUI | `set Frame_Cap2_14 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap2_MAIN, "", 0)` |
| 928 | CreatePlayerPickUI | `set Frame_Cap2_6 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap2_MAIN, "", 0)` |
| 933 | CreatePlayerPickUI | `set Frame_Cap2_8 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap2_MAIN, "", 0)` |
| 946 | CreatePlayerPickUI | `set Frame_Cap2_3[i] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap2_MAIN, "ScoreScreenTabButtonTemplate", 0)` |
| 952 | CreatePlayerPickUI | `set Frame_Cap2_4[i] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap2_3[i], "", 0)` |
| 958 | CreatePlayerPickUI | `set Frame_Cap2_9[i] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap2_MAIN, "WarCraftIIILogo", 0)` |
| 972 | CreatePlayerPickUI | `set Frame_Cap2_5[i] = BlzCreateFrameByType("TEXT", "MyIconTextAbi", Frame_Cap2_3[i], "", 0)` |
| 1317 | CreateCaptainUI | `set Frame_Cap1_MAIN = WUI_Window("WOSWindow", WUI_GetRoot(), 0, 0)` |
| 1343 | CreateCaptainUI | `set Frame_Cap1_3[i] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap1_MAIN, "ScoreScreenTabButtonTemplate", 0)` |
| 1347 | CreateCaptainUI | `set Frame_Cap1_4[i] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap1_3[i], "", 0)` |
| 1354 | CreateCaptainUI | `set Frame_Cap1_9[i] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap1_MAIN, "WarCraftIIILogo", 0)` |
| 1361 | CreateCaptainUI | `set Frame_Cap1_7[i] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap1_3[i], "", 0)` |
| 1369 | CreateCaptainUI | `set Frame_Cap1_5[i] = BlzCreateFrameByType("TEXT", "MyIconTextAbi", Frame_Cap1_3[i], "", 0)` |
| 1396 | CreateCaptainUI | `set Frame_Cap1_3[11] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap1_MAIN, "ScoreScreenTabButtonTemplate", 0)` |
| 1401 | CreateCaptainUI | `set Frame_Cap1_4[11] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap1_3[11], "", 0)` |
| 1407 | CreateCaptainUI | `set Frame_Cap1_9[11] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap1_MAIN, "WarCraftIIILogo", 0)` |
| 1414 | CreateCaptainUI | `set Frame_Cap1_7[11] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap1_3[11], "", 0)` |
| 1420 | CreateCaptainUI | `set Frame_Cap1_10 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap1_MAIN, "", 0)` |
| 1425 | CreateCaptainUI | `set Frame_Cap1_13 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap1_MAIN, "", 0)` |
| 1431 | CreateCaptainUI | `set Frame_Cap1_3[12] = BlzCreateFrameByType("BUTTON", "rrr", Frame_Cap1_MAIN, "ScoreScreenTabButtonTemplate", 0)` |
| 1436 | CreateCaptainUI | `set Frame_Cap1_4[12] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap1_3[12], "", 0)` |
| 1442 | CreateCaptainUI | `set Frame_Cap1_9[12] = BlzCreateFrameByType("SPRITE", "justAName", Frame_Cap1_MAIN, "WarCraftIIILogo", 0)` |
| 1449 | CreateCaptainUI | `set Frame_Cap1_7[12] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", Frame_Cap1_3[12], "", 0)` |
| 1454 | CreateCaptainUI | `set Frame_Cap1_11 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap1_MAIN, "", 0)` |
| 1460 | CreateCaptainUI | `set Frame_Cap1_14 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap1_MAIN, "", 0)` |
| 1466 | CreateCaptainUI | `set Frame_Cap1_6 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap1_MAIN, "", 0)` |
| 1471 | CreateCaptainUI | `set Frame_Cap1_8 = BlzCreateFrameByType("TEXT", "TextT", Frame_Cap1_MAIN, "", 0)` |

## triggers/WOS_Start/Scoreboard.j

22 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 409 | WOS_STATS_CreateText | `local framehandle textFrame = BlzCreateFrameByType("TEXT", "WosStatsText", parent, "", context)` |
| 420 | WOS_STATS_CreateBackdrop | `local framehandle back = BlzCreateFrameByType("BACKDROP", "WosStatsBackdrop", parent, "", context)` |
| 430 | WOS_STATS_CreateHoverArea | `local framehandle hover = BlzCreateFrameByType("BUTTON", "WosStatsHoverArea", parent, "", context)` |
| 475 | WOS_STATS_CreateItemTooltip | `local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "WosStatsItemTooltip", WOS_STATS_Main, "", 5000 + index)` |
| 476 | WOS_STATS_CreateItemTooltip | `local framehandle tooltipText = BlzCreateFrameByType("TEXT", "WosStatsItemTooltipText", tooltip, "", 5000 + index)` |
| 497 | WOS_STATS_CreateCombatTooltip | `local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "WosStatsCombatTooltip", WOS_STATS_Main, "", 5200 + index)` |
| 498 | WOS_STATS_CreateCombatTooltip | `local framehandle tooltipText = BlzCreateFrameByType("TEXT", "WosStatsCombatTooltipText", tooltip, "", 5200 + index)` |
| 564 | WOS_STATS_CreateSimpleTooltip | `local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "WosStatsSimpleTooltip", WOS_STATS_Main, "", context)` |
| 565 | WOS_STATS_CreateSimpleTooltip | `local framehandle tooltipText = BlzCreateFrameByType("TEXT", "WosStatsSimpleTooltipText", tooltip, "", context)` |
| 1537 | WOS_STATS_CreateRows | `set WOS_STATS_RowContent[row] = BlzCreateFrameByType("FRAME", "WosStatsRowContent", WOS_STATS_Inner, "", 650 + row)` |
| 1543 | WOS_STATS_CreateRows | `set WOS_STATS_HeroIcon[row] = BlzCreateFrameByType("BACKDROP", "WosStatsHeroIcon", WOS_STATS_RowContent[row], "", 700 + row)` |
| 1575 | WOS_STATS_CreateRows | `set WOS_STATS_ItemButton[itemIndex] = BlzCreateFrameByType("BUTTON", "WosStatsItemButton", WOS_STATS_RowContent[row], "ScoreScreenTabButtonTemplate", 1000 + itemIndex)` |
| 1580 | WOS_STATS_CreateRows | `set icon = BlzCreateFrameByType("BACKDROP", "WosStatsItemIcon", WOS_STATS_ItemButton[itemIndex], "", 1100 + itemIndex)` |
| 1610 | WOS_STATS_CreateUI | `set WOS_STATS_Main = BlzCreateFrameByType("FRAME", "WOSScoreboardWindow", gameUI, "", 4700)` |
| 1611 | WOS_STATS_CreateUI | `call WUI_Border("WOSScoreboardBorder", WOS_STATS_Main)` |
| 1619 | WOS_STATS_CreateUI | `set WOS_STATS_Inner = BlzCreateFrameByType("FRAME", "WosStatsInner", WOS_STATS_Main, "", 4701)` |
| 1632 | WOS_STATS_CreateUI | `set WOS_STATS_CloseButton = BlzCreateFrameByType("BUTTON", "WosStatsCloseButton", WOS_STATS_Main, "", 4704)` |
| 1636 | WOS_STATS_CreateUI | `set WOS_STATS_CloseIcon = BlzCreateFrameByType("BACKDROP", "WosStatsCloseIcon", WOS_STATS_CloseButton, "", 4705)` |
| 1642 | WOS_STATS_CreateUI | `set WOS_STATS_OpacityButton = BlzCreateFrameByType("BUTTON", "WosStatsOpacityButton", WOS_STATS_Main, "", 4710)` |
| 1646 | WOS_STATS_CreateUI | `set WOS_STATS_OpacityIcon = BlzCreateFrameByType("BACKDROP", "WosStatsOpacityIcon", WOS_STATS_OpacityButton, "", 4711)` |
| 1652 | WOS_STATS_CreateUI | `set WOS_STATS_ExpandButton = BlzCreateFrameByType("BUTTON", "WosStatsExpandButton", WOS_STATS_Main, "", 4712)` |
| 1656 | WOS_STATS_CreateUI | `set WOS_STATS_ExpandIcon = BlzCreateFrameByType("BACKDROP", "WosStatsExpandIcon", WOS_STATS_ExpandButton, "", 4713)` |

## triggers/WOS_Start/ShowCD.j

12 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 1260 | AHUI_CreateSlotFrames | `set AHUI_Root[index] = BlzCreateFrameByType("FRAME", "AHUIRoot", console, "WOSPassiveFrame", index)` |
| 1269 | AHUI_CreateSlotFrames | `set AHUI_Icon[index] = BlzCreateFrameByType("BACKDROP", "AHUIIcon", AHUI_Root[index], "", index)` |
| 1276 | AHUI_CreateSlotFrames | `set AHUI_CooldownFill[index] = BlzCreateFrameByType("BACKDROP", "AHUICooldownFill", AHUI_Root[index], "", index)` |
| 1284 | AHUI_CreateSlotFrames | `set AHUI_CooldownText[index] = BlzCreateFrameByType("TEXT", "AHUICooldownText", AHUI_Root[index], "", index)` |
| 1295 | AHUI_CreateSlotFrames | `set AHUI_KeyText[index] = BlzCreateFrameByType("TEXT", "AHUIKeyText", AHUI_Root[index], "", index)` |
| 1322 | AHUI_CreateTooltipFrames | `set AHUI_TooltipRoot[pid] = BlzCreateFrameByType("FRAME", "AHUITooltipRoot", AHUI_GameUI, "", pid)` |
| 1329 | AHUI_CreateTooltipFrames | `set AHUI_TooltipBackdrop[pid] = WUI_Window("WOSAbilityTooltip", AHUI_TooltipRoot[pid], 0, pid)` |
| 1336 | AHUI_CreateTooltipFrames | `set AHUI_TooltipTitle[pid] = BlzCreateFrameByType("TEXT", "AHUITooltipTitle", AHUI_TooltipRoot[pid], "", pid)` |
| 1346 | AHUI_CreateTooltipFrames | `set AHUI_TooltipManaIcon[pid] = BlzCreateFrameByType("BACKDROP", "AHUITooltipManaIcon", AHUI_TooltipRoot[pid], "", pid)` |
| 1355 | AHUI_CreateTooltipFrames | `set AHUI_TooltipManaText[pid] = BlzCreateFrameByType("TEXT", "AHUITooltipManaText", AHUI_TooltipRoot[pid], "", pid)` |
| 1364 | AHUI_CreateTooltipFrames | `set AHUI_TooltipSeparator[pid] = BlzCreateFrameByType("BACKDROP", "AHUITooltipSeparator", AHUI_TooltipRoot[pid], "", pid)` |
| 1373 | AHUI_CreateTooltipFrames | `set AHUI_TooltipText[pid] = BlzCreateFrameByType("TEXT", "AHUITooltipText", AHUI_TooltipRoot[pid], "", pid)` |

## triggers/WOS_Start/Starts.j

4 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 327 | WOS_CreateModeSelector | `set panel = WUI_Window("WOSModePanel", WOS_ModeRoot, 1, 0)` |
| 330 | WOS_CreateModeSelector | `set title = BlzCreateFrameByType("TEXT", "WOSModeTitle", panel, "", 0)` |
| 335 | WOS_CreateModeSelector | `set title = BlzCreateFrameByType("TEXT", "WOSModeHint", panel, "", 0)` |
| 522 | InitTrig_ModeDialog | `set main_frame = BlzCreateFrameByType("BACKDROP", "SS", WUI_GetRoot(), "", 0)` |

## triggers/WOS_Start/TeamMapPings.j

13 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 616 | TMP_StartUI | `set TMP_Panel = BlzCreateFrameByType("BACKDROP", "TeamPingPanel", ui, "", 0)` |
| 621 | TMP_StartUI | `set TMP_Wheel = BlzCreateFrameByType("BUTTON", "TeamPingWheel", TMP_Panel, "", 0)` |
| 625 | TMP_StartUI | `set TMP_Status = BlzCreateFrameByType("TEXT", "TeamPingStatus", TMP_Panel, "", 0)` |
| 634 | TMP_StartUI | `set TMP_Button[kind] = BlzCreateFrameByType("BACKDROP", "TeamPingSector", TMP_Wheel, "", kind)` |
| 639 | TMP_StartUI | `set TMP_Name[kind] = BlzCreateFrameByType("TEXT", "TeamPingLabel", TMP_Panel, "", kind)` |
| 653 | TMP_StartUI | `set TMP_Toggle = BlzCreateFrameByType("BUTTON", "TeamPingToggle", ui, "", 0)` |
| 655 | TMP_StartUI | `set TMP_ToggleIcon = BlzCreateFrameByType("BACKDROP", "TeamPingToggleIcon", TMP_Toggle, "", 0)` |
| 660 | TMP_StartUI | `set TMP_ToggleText = BlzCreateFrameByType("TEXT", "TeamPingToggleText", TMP_Toggle, "", 0)` |
| 668 | TMP_StartUI | `set TMP_Hint = BlzCreateFrameByType("TEXT", "TeamPingHint", ui, "", 0)` |
| 684 | TMP_StartUI | `set TMP_MiniIcon[pid] = BlzCreateFrameByType("BACKDROP", "TeamPingMinimapIcon", TMP_Minimap, "", pid)` |
| 690 | TMP_StartUI | `set TMP_MiniNameRoot[pid] = BlzCreateFrameByType("FRAME", "TeamPingMinimapNameRoot", TMP_Minimap, "", pid)` |
| 693 | TMP_StartUI | `set TMP_MiniNameBack[pid] = BlzCreateFrameByType("BACKDROP", "TeamPingMinimapNameBack", TMP_MiniNameRoot[pid], "", pid)` |
| 698 | TMP_StartUI | `set TMP_MiniName[pid] = BlzCreateFrameByType("TEXT", "TeamPingMinimapName", TMP_MiniNameRoot[pid], "", pid)` |

## triggers/WOS_Start/UI_CAREER.j

12 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 151 | WCS_CreateText | `local framehandle result = BlzCreateFrameByType("TEXT", "WcsText", parent, "", context)` |
| 161 | WCS_CreateBackdrop | `local framehandle result = BlzCreateFrameByType("BACKDROP", "WcsBackdrop", parent, "", context)` |
| 170 | WCS_CreateIconButton | `local framehandle result = BlzCreateFrameByType("BUTTON", "WcsIconButton", parent, "ScoreScreenTabButtonTemplate", context)` |
| 177 | WCS_CreateIcon | `local framehandle result = BlzCreateFrameByType("BACKDROP", "WcsIcon", buttonFrame, "", context)` |
| 184 | WCS_CreateTextButton | `local framehandle buttonFrame = BlzCreateFrame("ScriptDialogButton", parent, 0, context)` |
| 316 | WCS_CreateTooltip | `local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "WcsTooltip", WUI_GetRoot(), "", context)` |
| 317 | WCS_CreateTooltip | `local framehandle label = BlzCreateFrameByType("TEXT", "WcsTooltipText", tooltip, "", context)` |
| 913 | WCS_CreateDetailPage | `set WCS_DetailHeroIcon = BlzCreateFrameByType("BACKDROP", "WcsDetailHeroIcon", WCS_DetailPage, "", 8710)` |
| 986 | WCS_CreateUI | `set WCS_Main = WUI_Window("WOSCareerWindow", gameUI, 0, 8210)` |
| 997 | WCS_CreateUI | `set WCS_HomePage = BlzCreateFrameByType("FRAME", "WcsHomePage", WCS_Main, "", 8230)` |
| 998 | WCS_CreateUI | `set WCS_HeroesPage = BlzCreateFrameByType("FRAME", "WcsHeroesPage", WCS_Main, "", 8231)` |
| 999 | WCS_CreateUI | `set WCS_DetailPage = BlzCreateFrameByType("FRAME", "WcsDetailPage", WCS_Main, "", 8232)` |

## triggers/WOS_Start/WoS_Hero_Icons_Init.j

55 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 946 | WOS_CreateRoundCounters | `set FRAME_RoundCount = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHeroMain, "", 0)` |
| 955 | WOS_CreateRoundCounters | `set FRAME_RoundTimer = BlzCreateFrameByType("TEXT", "MyPlayerName", StatusRoundClockBox, "", 0)` |
| 964 | WOS_CreateRoundCounters | `set StatusGameTimeBox = WUI_Panel("WOSGameTimeBox", FRAME_StatusHeroMain, 0.090, 0.013)` |
| 968 | WOS_CreateRoundCounters | `set FRAME_GameTimer = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHeroMain, "", 0)` |
| 976 | WOS_CreateRoundCounters | `set StatusTeam1Box = WUI_Panel("WOSTeam1ScoreBox", FRAME_StatusHeroMain, 0.033, 0.035)` |
| 979 | WOS_CreateRoundCounters | `set FRAME_Team1Rounds = BlzCreateFrameByType("TEXT", "MyPlayerScore1", FRAME_StatusHeroMain, "", 0)` |
| 990 | WOS_CreateRoundCounters | `set StatusTeam2Box = WUI_Panel("WOSTeam2ScoreBox", FRAME_StatusHeroMain, 0.033, 0.035)` |
| 993 | WOS_CreateRoundCounters | `set FRAME_Team2Rounds = BlzCreateFrameByType("TEXT", "MyPlayerScore2", FRAME_StatusHeroMain, "", 0)` |
| 1184 | CreateStatusHeroUI | `set StatusPortraitRoot = BlzCreateFrameByType("FRAME", "WOSHeroPortraits", FRAME_StatusHeroMain, "", 0)` |
| 1187 | CreateStatusHeroUI | `set FRAME_StatusHeroMain2 = BlzCreateFrameByType("FRAME", "WOSDamageSummary", WUI_GetRoot(), "", 0)` |
| 1189 | CreateStatusHeroUI | `set FRAME_StatusHeroMain3 = BlzCreateFrameByType("FRAME", "WOSTopOptions", WUI_GetRoot(), "", 0)` |
| 1196 | CreateStatusHeroUI | `set FRAME_StatusHeroMain4 = BlzCreateFrameByType("FRAME", "WOSCameraControls", WUI_GetRoot(), "", 0)` |
| 1199 | CreateStatusHeroUI | `set FRAME_CamSlider = BlzCreateFrameByType("SLIDER", "CamSlider", FRAME_StatusHeroMain4, "QuestMainListScrollBar", 0)` |
| 1209 | CreateStatusHeroUI | `set FRAME_CamSliderStringBack = BlzCreateFrameByType("BACKDROP", "MyStatusButtonIcon", FRAME_StatusHeroMain4, "", 0)` |
| 1222 | CreateStatusHeroUI | `set FRAME_StatusHero[i] = BlzCreateFrameByType("BUTTON", "MyStatusButton", StatusPortraitRoot, "", 0)` |
| 1223 | CreateStatusHeroUI | `set FRAME_StatusHeroBack[i] = BlzCreateFrameByType("BACKDROP", "MyStatusButtonIcon", FRAME_StatusHero[i], "", 0)` |
| 1239 | CreateStatusHeroUI | `set FRAME_StatusHeroBack2[i] = BlzCreateFrameByType("BACKDROP", "MyStatusButtonIcon", FRAME_StatusHero[i], "", 0)` |
| 1243 | CreateStatusHeroUI | `set FRAME_StatusHeroStringPlayerName[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)` |
| 1249 | CreateStatusHeroUI | `set FRAME_StatusHeroTooltip[i] = WUI_Window("StatusHeroNameTooltip", StatusPortraitRoot, 0, 3000 + i)` |
| 1254 | CreateStatusHeroUI | `set FRAME_StatusHeroTooltipText[i] = BlzCreateFrameByType("TEXT", "StatusHeroNameTooltipText", FRAME_StatusHeroTooltip[i], "", 3100 + i)` |
| 1264 | CreateStatusHeroUI | `set FRAME_StatusHeroStringPlayerKill[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)` |
| 1270 | CreateStatusHeroUI | `set FRAME_SwapSprite[i] = BlzCreateFrameByType("SPRITE", "justAName", FRAME_StatusHeroBack[i], "WarCraftIIILogo", 0)` |
| 1276 | CreateStatusHeroUI | `set FRAME_SwapSprite2[i] = BlzCreateFrameByType("SPRITE", "justAName", FRAME_StatusHeroBack[i], "WarCraftIIILogo", 0)` |
| 1286 | CreateStatusHeroUI | `set FRAME_StatusHeroStringPlayerDeath[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)` |
| 1290 | CreateStatusHeroUI | `set FRAME_StatusHeroStringPlayerDamagePhys[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)` |
| 1294 | CreateStatusHeroUI | `set FRAME_StatusHeroStringPlayerDamageMag[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)` |
| 1298 | CreateStatusHeroUI | `set FRAME_StatusHeroStringPlayerHeal[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)` |
| 1302 | CreateStatusHeroUI | `set FRAME_StatusHeroStringPlayerDamageTakenPhys[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)` |
| 1306 | CreateStatusHeroUI | `set FRAME_StatusHeroStringPlayerDamageTakenMag[i] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[i], "", 0)` |
| 1318 | CreateStatusHeroUI | `set StatusTrainBox = WUI_Panel("WOSTrainKillsBox", FRAME_StatusHeroMain, 0.090, 0.017)` |
| 1322 | CreateStatusHeroUI | `set FRAME_StatusHero[10] = BlzCreateFrameByType("BUTTON", "MyStatusButton", StatusTrainBox, "", 0)` |
| 1323 | CreateStatusHeroUI | `set FRAME_StatusHeroBack[10] = BlzCreateFrameByType("BACKDROP", "MyStatusButtonIcon", FRAME_StatusHero[10], "", 0)` |
| 1332 | CreateStatusHeroUI | `set FRAME_StatusHeroStringPlayerKill[10] = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatusHero[10], "", 0)` |
| 1342 | CreateStatusHeroUI | `set FRAME_StatusHeroStringPlayerTakenDamageMag = BlzCreateFrameByType("TEXT", "MyPlayerName1", FRAME_StatusHeroMain2, "", 0)` |
| 1357 | CreateStatusHeroUI | `set FRAME_StatsMain = WUI_Window("WOSPlayerStats", WUI_GetRoot(), 0, 0)` |
| 1360 | CreateStatusHeroUI | `set FRAME_StatsCheckbox = BlzCreateFrame("QuestCheckBox2", FRAME_StatsMain, 0, 0)` |
| 1366 | CreateStatusHeroUI | `set FRAME_StatsCheckboxString = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1371 | CreateStatusHeroUI | `set FRAME_Stats1 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1375 | CreateStatusHeroUI | `set FRAME_Stats0 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1379 | CreateStatusHeroUI | `set FRAME_Stats2 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1382 | CreateStatusHeroUI | `set FRAME_Stats3 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1385 | CreateStatusHeroUI | `set FRAME_Stats4 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1388 | CreateStatusHeroUI | `set FRAME_Stats5 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1391 | CreateStatusHeroUI | `set FRAME_Stats6 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1394 | CreateStatusHeroUI | `set FRAME_Stats7 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1397 | CreateStatusHeroUI | `set FRAME_Stats8 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1401 | CreateStatusHeroUI | `set FRAME_Stats9 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1404 | CreateStatusHeroUI | `set FRAME_Stats10 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1407 | CreateStatusHeroUI | `set FRAME_Stats11 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1410 | CreateStatusHeroUI | `set FRAME_Stats12 = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_StatsMain, "", 0)` |
| 1423 | CreateStatusHeroUI | `set FRAME_LINK2 = BlzCreateFrameByType("BUTTON", "MyIconButton", WUI_GetRoot(), "ScoreScreenTabButtonTemplate", 0)` |
| 1426 | CreateStatusHeroUI | `set FRAME_LINK4 = BlzCreateFrameByType("BUTTON", "MyIconButton", WUI_GetRoot(), "ScoreScreenTabButtonTemplate", 0)` |
| 1430 | CreateStatusHeroUI | `set FRAME_LINK3 = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_LINK2, "", 0)` |
| 1435 | CreateStatusHeroUI | `set FRAME_LINK5 = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_LINK4, "", 0)` |
| 1443 | CreateStatusHeroUI | `set FRAME_LINK = BlzCreateFrame("LMPLinkEditTemplate",  WUI_GetRoot(),0,0)` |

## triggers/WOS_Start/WoS_Pick_Init.j

38 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 2830 | GuideCreateAbilityTooltip | `local framehandle tooltip = WUI_Window("AbilityNativeTooltip", FRAME_MAIN3, 0, 8000 + slot)` |
| 2831 | GuideCreateAbilityTooltip | `local framehandle tooltipText = BlzCreateFrameByType("TEXT", "AbilityNativeTooltipText", tooltip, "", 8100 + slot)` |
| 2956 | WOS_CreatePickShell | `set FRAME_MAIN = WUI_Window("WOSWindow", WUI_GetRoot(), 0, 0)` |
| 2959 | WOS_CreatePickShell | `set FRAME_MAIN2 = WUI_Window("WOSWindow", FRAME_MAIN, 1, 0)` |
| 2961 | WOS_CreatePickShell | `set FRAME_MAIN3 = WUI_Window("WOSWindow", FRAME_MAIN, 1, 0)` |
| 2971 | WOS_CreatePickShell | `set FRAME_PlayerPickDifficultText = BlzCreateFrameByType("TEXT", "MyHeroNameButton", FRAME_MAIN3, "ScriptDialogButton", 0)` |
| 2978 | WOS_CreatePickShell | `set FRAME_HeroModel = BlzCreateFrameByType("BACKDROP", "Port", FRAME_MAIN3, "", 0)` |
| 2985 | WOS_CreatePickShell | `set border = WUI_Window("WOSPickPortraitSurface", FRAME_MAIN3, 1, 0)` |
| 2988 | WOS_CreatePickShell | `set FRAME_HeroAttribute = BlzCreateFrameByType("BACKDROP", "attribute", FRAME_MAIN3, "", 0)` |
| 2994 | WOS_CreatePickShell | `set FRAME_HeroAttackType = BlzCreateFrameByType("BACKDROP", "atk", FRAME_MAIN3, "", 0)` |
| 3000 | WOS_CreatePickShell | `set FRAME_HeroStr = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)` |
| 3005 | WOS_CreatePickShell | `set FRAME_HeroAgi = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)` |
| 3010 | WOS_CreatePickShell | `set FRAME_HeroInt = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)` |
| 3015 | WOS_CreatePickShell | `set FRAME_HeroAtk = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)` |
| 3020 | WOS_CreatePickShell | `set FRAME_HeroArmor = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)` |
| 3025 | WOS_CreatePickShell | `set FRAME_HeroMS = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)` |
| 3030 | WOS_CreatePickShell | `set FRAME_HeroAS = BlzCreateFrameByType("TEXT", "MyHeroStatButton", FRAME_MAIN3, "ScriptDialogButton", 0)` |
| 3056 | WOS_CreatePickCatalogue | `set FRAME_Pick[k] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_MAIN2, "ScoreScreenTabButtonTemplate", 0)` |
| 3057 | WOS_CreatePickCatalogue | `set FRAME_ICON_Pick[k] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_Pick[k], "", 0)` |
| 3101 | WOS_CreatePickCatalogue | `set FRAME_ICON[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_MAIN2, "ScoreScreenTabButtonTemplate", 0)` |
| 3102 | WOS_CreatePickCatalogue | `set FRAME_ICON2[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ICON[i], "", 0)` |
| 3140 | WOS_CreatePickCategories | `set Frame_PageHeroList[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_MAIN2, "ScoreScreenTabButtonTemplate", 0)` |
| 3141 | WOS_CreatePickCategories | `set Frame_PageHeroListImage[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", Frame_PageHeroList[i], "", 0)` |
| 3170 | WOS_CreatePickCategories | `set FRAME_Repick[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", WUI_GetRoot(), "ScoreScreenTabButtonTemplate", 0)` |
| 3173 | WOS_CreatePickCategories | `set FRAME_RepickHover[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_Repick[i], "", 0)` |
| 3177 | WOS_CreatePickCategories | `set FRAME_RepickText[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_Repick[i], "", 0)` |
| 3183 | WOS_CreatePickCategories | `set FRAME_Swap[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", WUI_GetRoot(), "ScoreScreenTabButtonTemplate", 0)` |
| 3186 | WOS_CreatePickCategories | `set FRAME_SwapHover[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_Swap[i], "", 0)` |
| 3190 | WOS_CreatePickCategories | `set FRAME_SwapText[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_Swap[i], "", 0)` |
| 3214 | WOS_CreatePickAbilities | `set FRAME_ICON5[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_MAIN3, "ScoreScreenTabButtonTemplate", 0)` |
| 3215 | WOS_CreatePickAbilities | `set FRAME_ICON6[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ICON5[i], "", 0)` |
| 3224 | WOS_CreatePickAbilities | `set FRAME_AbiText[i] = BlzCreateFrameByType("TEXT", "MyIconTextAbi", FRAME_ICON5[i], "", 0)` |
| 3272 | WOS_CreatePickPlayers | `set FRAME_PlayerPick[i] = BlzCreateFrameByType("BUTTON", "MyPickTeamButton", FRAME_MAIN, "", 0)` |
| 3275 | WOS_CreatePickPlayers | `set FRAME_PlayerPickBack[i] = BlzCreateFrameByType("BACKDROP", "MyPickTeamButton", FRAME_PlayerPick[i], "", 0)` |
| 3286 | WOS_CreatePickPlayers | `set FRAME_PlayerPickText[i] = BlzCreateFrameByType("TEXT", "MyIconTextAbi", FRAME_PlayerPick[i], "", 0)` |
| 3305 | WOS_CreatePickPlayers | `set FRAME_BanSpinSprite = BlzCreateFrameByType("SPRITE", "justAName", FRAME_MAIN, "WarCraftIIILogo", 0)` |
| 3314 | WOS_CreatePickPlayers | `set FRAME_BanHighlight[i] = BlzCreateFrameByType("SPRITE", "justAName", FRAME_MAIN, "WarCraftIIILogo", 0)` |
| 3323 | WOS_CreatePickPlayers | `set FRAME_TimerToStart = BlzCreateFrameByType("TEXT", "TextT", FRAME_MAIN2, "", 0)` |

## triggers/WOS_Start/WoS_Shop_Init.j

38 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 231 | ShopCreateItemTooltip | `local framehandle tooltip = BlzCreateFrameByType("BACKDROP", "ShopNativeTooltip", FRAME_ShopMAIN, "", context)` |
| 232 | ShopCreateItemTooltip | `local framehandle tooltipText = BlzCreateFrameByType("TEXT", "ShopNativeTooltipText", tooltip, "", context)` |
| 2698 | WOS_CreateShopShell | `set FRAME_ShopMAIN = WUI_Window("WOSWindow", WUI_GetRoot(), 0, 0)` |
| 2701 | WOS_CreateShopShell | `set FRAME_ShopItemList = WUI_Window("WOSWindow", FRAME_ShopMAIN, 1, 0)` |
| 2706 | WOS_CreateShopShell | `set FRAME_ShopItemCraft = WUI_Window("WOSWindow", FRAME_ShopMAIN, 1, 0)` |
| 2715 | WOS_CreateShopShell | `set FRAME_ShopCraftUpgradeWheelArea = BlzCreateFrameByType("BUTTON", "ShopCraftUpgradeWheelArea", FRAME_ShopItemCraft, "", 5101)` |
| 2723 | WOS_CreateShopShell | `set FRAME_ShopCraftComponentWheelArea = BlzCreateFrameByType("BUTTON", "ShopCraftComponentWheelArea", FRAME_ShopItemCraft, "", 5102)` |
| 2731 | WOS_CreateShopShell | `set FRAME_ShopItemDescription = WUI_Window("WOSWindow", FRAME_ShopMAIN, 1, 0)` |
| 2736 | WOS_CreateShopShell | `set FRAME_ShopItemDescriptionName = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemDescription, "", 0)` |
| 2739 | WOS_CreateShopShell | `set FRAME_ShopItemDescriptionName2 = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemDescription, "", 0)` |
| 2743 | WOS_CreateShopShell | `set FRAME_ShopItemInventory = WUI_Window("WOSWindow", FRAME_ShopMAIN, 1, 0)` |
| 2748 | WOS_CreateShopShell | `set FRAME_ShopItemInventoryName = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemInventory, "", 0)` |
| 2751 | WOS_CreateShopShell | `set FRAME_ShopSearchLabel = BlzCreateFrameByType("TEXT", "ShopSearchLabel", FRAME_ShopMAIN, "", 0)` |
| 2757 | WOS_CreateShopShell | `set FRAME_ShopSearchEditBox = BlzCreateFrame("LMPLinkEditTemplate", FRAME_ShopMAIN, 0, 0)` |
| 2765 | WOS_CreateShopShell | `set FRAME_ShopSearchClear = BlzCreateFrameByType("BUTTON", "ShopSearchClear", FRAME_ShopMAIN, "ScoreScreenTabButtonTemplate", 0)` |
| 2768 | WOS_CreateShopShell | `set FRAME_ShopSearchClearIcon = BlzCreateFrameByType("BACKDROP", "ShopSearchClearIcon", FRAME_ShopSearchClear, "", 0)` |
| 2773 | WOS_CreateShopShell | `set FRAME_ShopSearchPrevious = BlzCreateFrameByType("BUTTON", "ShopSearchPrevious", FRAME_ShopMAIN, "ScoreScreenTabButtonTemplate", 0)` |
| 2776 | WOS_CreateShopShell | `set FRAME_ShopSearchPreviousIcon = BlzCreateFrameByType("BACKDROP", "ShopSearchPreviousIcon", FRAME_ShopSearchPrevious, "", 0)` |
| 2781 | WOS_CreateShopShell | `set FRAME_ShopSearchPageText = BlzCreateFrameByType("TEXT", "ShopSearchPageText", FRAME_ShopMAIN, "", 0)` |
| 2787 | WOS_CreateShopShell | `set FRAME_ShopSearchNext = BlzCreateFrameByType("BUTTON", "ShopSearchNext", FRAME_ShopMAIN, "ScoreScreenTabButtonTemplate", 0)` |
| 2790 | WOS_CreateShopShell | `set FRAME_ShopSearchNextIcon = BlzCreateFrameByType("BACKDROP", "ShopSearchNextIcon", FRAME_ShopSearchNext, "", 0)` |
| 2800 | WOS_CreateShopShell | `set FRAME_ShopItemCraftSprite = WUI_Border("ShopSelectedRecipe", FRAME_ShopItemCraft)` |
| 2803 | WOS_CreateShopShell | `set FRAME_ShopItemCraftSprite2 = WUI_Border("ShopSelectedInventory", FRAME_ShopItemInventory)` |
| 2812 | WOS_CreateShopShell | `set FRAME_ShopRecipeTitle = BlzCreateFrameByType("TEXT", "ShopRecipeTitle", FRAME_ShopItemCraft, "", 0)` |
| 2818 | WOS_CreateShopShell | `set FRAME_ShopRecipeLine[line] = BlzCreateFrameByType("BACKDROP", "ShopRecipeEdge", FRAME_ShopItemCraft, "", line)` |
| 2865 | WOS_CreateShopTabs | `set FRAME_AutoBuyCheckbox = BlzCreateFrame("QuestCheckBox2", FRAME_ShopMAIN, 0, 0)` |
| 2871 | WOS_CreateShopTabs | `set FRAME_AutoBuyText = BlzCreateFrameByType("TEXT", "MyPlayerName", FRAME_ShopMAIN, "", 0)` |
| 2892 | WOS_CreateShopCatalogue | `set FRAME_ShopItem[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_ShopItemList, "ScoreScreenTabButtonTemplate", 0)` |
| 2894 | WOS_CreateShopCatalogue | `set FRAME_ShopItemBack[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItem[i], "", 0)` |
| 2900 | WOS_CreateShopCatalogue | `set FRAME_ShopItemCost[i] = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItem[i], "", 0)` |
| 2934 | WOS_CreateShopRecipes | `set FRAME_ShopItem[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_ShopItemCraft, "ScoreScreenTabButtonTemplate", 0)` |
| 2936 | WOS_CreateShopRecipes | `set FRAME_ShopItemBack[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItem[i], "", 0)` |
| 2940 | WOS_CreateShopRecipes | `set FRAME_ShopItemCost[i] = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItem[i], "", 0)` |
| 2964 | WOS_CreateShopRecipes | `set FRAME_ShopCraftUpgradeScroll = BlzCreateFrame("QuestMainListScrollBar", FRAME_ShopItemCraft, 0, 9150)` |
| 2976 | WOS_CreateShopRecipes | `set FRAME_ShopCraftComponentScroll = BlzCreateFrame("QuestMainListScrollBar", FRAME_ShopItemCraft, 0, 9151)` |
| 3005 | WOS_CreateShopInventory | `set FRAME_ShopItemInventorySlot[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_ShopItemInventory, "ScoreScreenTabButtonTemplate", 0)` |
| 3007 | WOS_CreateShopInventory | `set FRAME_ShopItemInventorySlotBack[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItemInventorySlot[i], "", 0)` |
| 3016 | WOS_CreateShopInventory | `set FRAME_ShopItemInventorySlotCost[i] = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemInventorySlot[i], "", 0)` |

## triggers/WOS_Start/WOSUI.j

39 creation/TOC sites.

| Line | Function | Creation |
|---|---|---|
| 172 | WUI_Passive | `local framehandle container = BlzCreateFrameByType("BACKDROP", name, parent, "", 0)` |
| 272 | WUI_Panel | `local framehandle panel = BlzCreateFrameByType("BACKDROP", name, parent, "", 0)` |
| 281 | WUI_CreateFill | `local framehandle fill = BlzCreateFrameByType("BACKDROP", name, parent, "", 0)` |
| 294 | WUI_Border | `local framehandle edge = BlzCreateFrameByType("BACKDROP", name, owner, "", 0)` |
| 327 | WUI_OrnateBorder | `set piece = BlzCreateFrameByType("BACKDROP", name + texture, edge, "", i)` |
| 334 | WUI_OrnateBorder | `set piece = BlzCreateFrameByType("BACKDROP", name + "Top", edge, "", 0)` |
| 340 | WUI_OrnateBorder | `set piece = BlzCreateFrameByType("BACKDROP", name + "Bottom", edge, "", 0)` |
| 346 | WUI_OrnateBorder | `set piece = BlzCreateFrameByType("BACKDROP", name + "Left", edge, "", 0)` |
| 352 | WUI_OrnateBorder | `set piece = BlzCreateFrameByType("BACKDROP", name + "Right", edge, "", 0)` |
| 374 | WUI_Window | `local framehandle panel = BlzCreateFrameByType("BACKDROP", name, parent, "", context)` |
| 375 | WUI_Window | `local framehandle edge = WUI_Border(name + "Edge", panel)` |
| 448 | WUI_SimpleBorder | `local framehandle edge = BlzCreateFrameByType("SIMPLESTATUSBAR", "WOSBuffBorder", owner, "", 0)` |
| 578 | add | `set panel = WUI_Window("WOSHeroMeter", WUI_GetRoot(), 0, 0)` |
| 579 | add | `set back = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", panel, "", 0)` |
| 581 | add | `set icon = BlzCreateFrameByType("BACKDROP", "WOSMeterIcon", panel, "", 0)` |
| 582 | add | `set title = BlzCreateFrameByType("TEXT", "WOSMeterTitle", panel, "", 0)` |
| 583 | add | `set value = BlzCreateFrameByType("TEXT", "WOSMeterValue", panel, "", 0)` |
| 634 | WUI_Tooltip | `local framehandle box = WUI_Panel("WOSToolbarTooltip", WUI_Root, 0.170, 0.038)` |
| 635 | WUI_Tooltip | `local framehandle text = BlzCreateFrameByType("TEXT", "WOSToolbarTooltipText", box, "", 0)` |
| 636 | WUI_Tooltip | `local framehandle edge = WUI_Border("WOSToolbarTooltipBorder", box)` |
| 813 | WUI_InstallNativeLayout | `set WUI_HiddenDetails = BlzCreateFrameByType("SIMPLEFRAME", "WOSHiddenNativeDetails", WUI_SimpleRoot, "", 0)` |
| 924 | WUI_TextButton | `local framehandle control = BlzCreateFrameByType("BUTTON", name, parent, "", 0)` |
| 925 | WUI_TextButton | `local framehandle back = BlzCreateFrameByType("BACKDROP", name + "Back", control, "", 0)` |
| 926 | WUI_TextButton | `local framehandle text = BlzCreateFrameByType("TEXT", name + "Text", control, "", 0)` |
| 986 | WUI_CreateHUDChrome | `set panel = WUI_Panel("WOSToolbarSurface", WUI_Root, 0.104, 0.088)` |
| 1075 | WUI_CreateControls | `set back = WUI_Panel("WOSTopActionsPanel", WUI_Root, 0.180, 0.072)` |
| 1080 | WUI_CreateControls | `set WUI_Menu = BlzCreateFrameByType("BUTTON", "WOSCompactMenu", WUI_Root, "", 0)` |
| 1083 | WUI_CreateControls | `set text = BlzCreateFrameByType("TEXT", "WOSMenuGlyph", WUI_Menu, "", 0)` |
| 1092 | WUI_CreateControls | `set back = BlzCreateFrameByType("BACKDROP", "WOSMenuLine", WUI_Menu, "", i)` |
| 1101 | WUI_CreateControls | `set text = BlzCreateFrameByType("TEXT", "WOSTopActionLabel", WUI_Root, "", i)` |
| 1116 | WUI_CreateControls | `set WUI_Orders = BlzCreateFrameByType("BUTTON", "WOSOrderDrawer", WUI_Root, "", 0)` |
| 1118 | WUI_CreateControls | `set text = BlzCreateFrameByType("TEXT", "WOSOrderDrawerLabel", WUI_Orders, "", 0)` |
| 1173 | WUI_CreateTestHelp | `set WUI_TestPanel = BlzCreateFrameByType("BUTTON", "WOSTestHelpPanel", WUI_Root, "", 0)` |
| 1175 | WUI_CreateTestHelp | `set back = WUI_Panel("WOSTestHelpBack", WUI_TestPanel, 0.210, 0.260)` |
| 1178 | WUI_CreateTestHelp | `set back = WUI_Border("WOSTestHelpBorder", WUI_TestPanel)` |
| 1179 | WUI_CreateTestHelp | `set WUI_TestText = BlzCreateFrameByType("TEXT", "WOSTestHelpText", WUI_TestPanel, "", 0)` |
| 1185 | WUI_CreateTestHelp | `set WUI_TestPageLabel = BlzCreateFrameByType("TEXT", "WOSTestPageLabel", WUI_TestPanel, "", 0)` |
| 1217 | WUI_Bootstrap | `set WUI_FrameDefinitionsReady = BlzLoadTOCFile("UI\\WOS\\Templates.toc")` |
| 1224 | WUI_Bootstrap | `set WUI_ServiceBoard = CreateLeaderboardBJ(bj_FORCE_ALL_PLAYERS, "WOS UI")` |

## Button focus audit — FIX10 (2026-10-15)

Current source names supersede the old snapshot line numbers above. Scanned all project J create/register sites and FDF BUTTON/TEXTBUTTON/GLUEBUTTON/GLUETEXTBUTTON/SIMPLEBUTTON, checkbox and input controls; test_map contains no separate authored button callbacks. 43 business click handlers / 78 exit sites in 18 files; the external FIX10 (based on FIX9) additionally covers QB_ButtonEvent and WUI_OnPanelToggle (45 / 80). Shared live-event cleanup is WUI_ReleaseClickFocus; passive-only BUTTON registration is WUI_RegisterPassiveFocus (15 factory/creation sites, one idempotent trigger).

| Файл (`triggers/`) | Обработчики после основной логики |
| --- | --- |
| `Heroes/Inori.j` | `OnClickInori` |
| `Heroes/Kyoraku.j` | `KyorakuFrameClick` |
| `WOS_Start/Captain_Draft.j` | `CaptainDraft_OnFirstSideVote` |
| `WOS_Start/ChatCommand.j` | `OnEmojiFrameClick` |
| `WOS_Start/DefaultArmorChangeStable_Copy.j` | `UNITSTAT_ToolbarClick`, `UNITSTAT_OnPortraitClick`, `UNITSTAT_OnModeClick`, `UNITSTAT_OnVoiceToggle` |
| `WOS_Start/EMOTES.j` | `OnEmojiClick` |
| `WOS_Start/MusicPlayer.j` | `LMP_OnClick` |
| `WOS_Start/Player_Pick_Mode.j` | `CapOnPlayerClick`, `CapOnClick` |
| `WOS_Start/SaveLoad.j` | `SaveSystem_OnSaveButton` |
| `WOS_Start/Scoreboard.j` | `WOS_STATS_OnKey`, `WOS_STATS_OnClose`, `WOS_STATS_OnOpacity`, `WOS_STATS_OnExpand`, `WOS_STATS_OnData` |
| `WOS_Start/ShowCD.j` | `AHUI_OnLearnClick` |
| `WOS_Start/Starts.j` | `WOS_ModeFrameClick` |
| `WOS_Start/TeamMapPings.j` | `TMP_OnFrame` |
| `WOS_Start/UI_CAREER.j` | `WCS_OnOpen`, `WCS_OnClose`, `WCS_OnHome`, `WCS_OnHeroes`, `WCS_OnCategory`, `WCS_OnHero` |
| `WOS_Start/WoS_Hero_Icons_Init.j` | `WOS_SwapUIOnClick`, `OnClickStatusHero`, `CheckBoxCheck`, `OnClickFrameLink` |
| `WOS_Start/WoS_Pick_Init.j` | `OnClick` |
| `WOS_Start/WoS_Shop_Init.j` | `OnClickItem`, `FrameShopCheckboxCheck`, `ShopFastToggleClick` |
| `WOS_Start/WOSUI.j` | `WUI_OnHotkeyBadge`, `WUI_OnColumnToggle`, `WUI_ControlClick`, `WUI_OnSlotClick`, `WUI_RestartClick`, `WUI_TestClick`, `WUI_TestScroll`, `WUI_InfoClick` |

Passive-only coverage: CaptainDraftBanButton; UNITSTAT_Widget factory/gold; LMP seek blocker; scoreboard hover/item buttons; Test Help/Game Info panels; swap ghost plates; normal pick ban/main-stat/ability hit areas; shop description and two recipe wheel areas. Always-disabled captain labels/train portrait and slider-owned FDF thumb buttons retain native behavior. Native menu/command/item SIMPLEBUTTON handlers are not replaced; QB's existing SIMPLEBUTTON plus normal-frame face share the same cleanup in the external candidate. EDITBOX and sliders/listboxes retain intentional focus. F2 remains the existing stats binding, no added native hero interception.

Checks: tools/test_wos_ui_focus.py and run_ui_regressions.py; compile project/candidate; external MPQ/WCT exact audit. 238 UI tests PASS per version, 101 QB /13 Reset /9 Fast-settings PASS; engine/multiplayer not run. Detailed source/file/handler evidence: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-ui-focus-fix10/REPORT_UI_FOCUS_FIX10.md. MAIN map unchanged; source patch applied in project and candidate.

## Targeted focus transfer — FIX11 (2026-10-15)

Adds one internal EDITBOX WUI_FocusSink (WOSEditBox, context9199; bare EDITBOX fallback). Allocated once on bootstrap after root creation/before owners; alpha0, centre(.4,-.2), size(.001,.001), hidden except synchronous transfer, no events, never destroyed while clicks exist. User interactive frames/templates/geometry unchanged. Reported-failing callbacks now opt into WUI_ReleaseStuckClickFocus; working ordinary cleanup remains. Profiles/mappings: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-ui-focus-fix11/focus-profiles.json. Native result unconfirmed.

## Focus experiment FIX12 — service input removed (2026-10-15)

Removed the FIX11 private WUI_FocusSink/WOSEditBox context9199 and its creation path. User EDITBOXes unchanged. New WUI_ResetClickedButtonFocus operates on BlzGetTriggerFrame only for real click/check/uncheck events, owner-local and enabled after business logic. No new frame/event/trigger/timer; same visual controls and layout. Profiles now use this helper rather than WUI_ReleaseStuckClickFocus; root14 / latest candidate16 handlers. Exact list:

| Source under triggers/WOS_Start | Changed event handlers |
|---|---|
| `DefaultArmorChangeStable_Copy.j` | UNITSTAT_ToolbarClick (only Emotes), UNITSTAT_OnPortraitClick, UNITSTAT_OnModeClick, UNITSTAT_OnVoiceToggle |
| `WOSUI.j` | WUI_ControlClick, WUI_OnColumnToggle, WUI_InfoClick, WUI_OnPanelToggle (candidate only) |
| `WoS_Hero_Icons_Init.j` | OnClickStatusHero, CheckBoxCheck |
| `ChatCommand.j` | OnEmojiFrameClick |
| `EMOTES.j` | OnEmojiClick |
| `SaveLoad.j` | SaveSystem_OnSaveButton (Save + Reset in candidate) |
| `Scoreboard.j` | WOS_STATS_OnData (frame click/check only, keyboard path does not toggle) |
| `WoS_Shop_Init.j` | FrameShopCheckboxCheck, QB_ButtonEvent (candidate REC-remove branch only) |

Bootstrap only loses sink creation. Ordinary Shop/F2/Z/K/music input paths preserved. Full report/game-test boundary: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-ui-focus-fix12/REPORT_UI_FOCUS_FIX12.md.
