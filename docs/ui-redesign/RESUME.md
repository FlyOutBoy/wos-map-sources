# Resume UI redesign

Read PLAN.md, relevant PROGRESS.md/ARCHITECTURE.md and factual Git state first.
REQUEST.md is the full user specification; WORKFLOW.md is the required staged
workflow. Source and native map evidence take precedence over these notes.

## Current boundary and exact next action

Implementation checkpoints 1..10 are saved; real MAIN is now updated and built.
Native integration block 10a DONE. Other blocks remain IN_PROGRESS because
Warcraft interaction/visual/multiplayer verification is pending. Full real MAIN
compile PASS: 147876 pjass lines, 106 enabled triggers + header (3 disabled). All 53
tests PASS: HUD/docks 13, pings 21, ally ability UI 8, trigger order 3, workflow 8.
No game run has verified this redesign. Do not label runtime success from compile.

User confirmed closure; process guard FALSE before integration. No pending closure
question. Future native writes must retain the process guard: an open editor can
overwrite external WTG/WCT. Build now blocks before source/import mutations, with
a second compiled-script guard retained. INTEGRATION.md contains exact commands.

Guarded push/full MAIN build PASS: 109 native sources, 46 changes + WOSUI insertion
id 0x03000071. Independent WTG/WCT identity/category traversal check PASS, all 29
resource imports verified and 33 extracted archive entries byte-match native MAIN.
_build/ui-redesign/integration-verification.json and full-main-pjass.txt save evidence.
Compiled main initializes WOSUI before dependent UI owners and original map init.

Exact next action: play _build/WoS_Test.w3x using OWNER_STATUS runtime matrix. No
native Warcraft UI automation is available; obtain actual gameplay/screenshots to
fix visual/input issues. Do not repeat imports/migration/build without new changes.

Native MAIN Scenario Folder:
C:/Users/Gear/Documents/Warcraft III/Maps/WoS/Anime_WOS2_0.32.w3x
Packed _build/WoS_Test.w3x is the MAIN output, not test_map. check_wos_ui.py uses
an empty main for compilation only; NEVER package it as a playable map script.
Packed SHA256: a05ba35dffdc08205d81b6dbdf75b2bde7e21ec5115941eb449b7344c1e00ad6.
Backups: backups/trigger-sync/2026-10-08_200834_844462/map-before-push;
backups/ui-redesign/assets/20261008-200844-860447;
backups/main-map-build/20261008-200916-304. No new object-data/gameplay edits.

## Implemented owners and contracts

- WOSUI.j provides independent normal FRAME root under an all-player service
  leaderboard (visible, zero-size; title/backdrop hidden). Native SIMPLEFRAMEs
  remain under cached ConsoleUI. GameUI and ConsoleUI stay visible.
- Compact existing selected HUD, native commands/items/buffs/minimap/menu, real
  gold/lumber, toolbar, native TestMode-only scroll/collapse help and camera.
  Native slots [8,9,10,11,7,5,6], centers .354+slot*.040/.044, size .036.
- Existing top hero portraits/public score/train/timer retained, visible+detected
  enemy HP/MP guard; portrait hiding leaves public score. Original .030 hero step
  matches RearrangeTeamUI; root Y=.560, icons .028, options Y=.590.
- Existing six-category/30-cell hero pick, preview/actions/players, draft, captain
  vote/team selection compacted. Existing seven shop tabs/catalogue/recipes/
  inventory/search/autobuy retained. WOS_LayoutHeroPick, WOS_LayoutShop and
  WOS_LayoutCaptainVote reposition actual handles; handlers/data unchanged.
- AllyHeroAbilityUI normal overlays now absolute HUD coordinates, never anchored
  to native SIMPLEFRAMEs. Independent graphite tooltips at (.790,.152). Enemy
  descriptions remain accessible without querying/displaying their cooldowns.
- Secondary career/music/emote/chat/player stats/scoreboard surfaces share style.
  Scoreboard opacity layer preserved; no alpha-zero parent containers.
- Z wheel retains five ally-only ping kinds, fog-safe target snapshots, mutes and
  2.5s cooldown. Release commits a valid sector once; click closes, Esc/RMB cancel.
  Only hovered name in center; no default sector labels.
- WOS_ToggleShop is the real shared shop handler (.evaluate bridges plain function
  ordering). K belongs to EmojiStandalone. Never recreate these controllers.
- Latest user addition: shared dynamic hero meters + unit buff docks. 45 six-frame
  sites across 28 files + Erza Second Origin (46 total) registered; real counters,
  timers and visibility retained. GearSystems2 MyFrame/MyFrameBuff, Kenjaku/Tsuna
  chips use native buff strip. WOSHeroMeter constructor for future owners.
  Registration synchronous; local .10s packing/interpolation never changes game
  state or visibility. Open DYNAMIC_METERS.md for APIs. One-time meter migration
  already applied; DO NOT rerun it. Inori/Kyoraku special panels also compacted.
- Shared assets: 13 RGBA TGA + 16 existing ping resources. Built-in imagegen source
  preserved; importer backs up/preserves old import entries. ASSETS.md records paths.

## Open files / outstanding evidence

Open INTEGRATION.md, sync_war3_project.py, sync_war3_triggers.py, verify_wos_ui.py,
then WOSUI.j/check_wos_ui.py/build script. FRAME_INVENTORY.md lists 45 active owners;
OWNER_STATUS.md records exact implemented coverage and pending runtime matrix.
Do not redo audit, root migration, meter migration, shop/pick/controller creation.
Preserve Crocodile integration, enemy cooldown privacy and WTG/WCT traversal repair.

Pending game evidence: native root visibility; item drag/use/hotkeys; learn/submenus;
buff row; native damage min/max formatting/fallback and attribute paths; real hover,
scroll/modal/menu behavior; all captain/draft/pick/shop phases; dynamic meter/buff
movement; Z release/click; multiplayer/fog/privacy; 4:3/16:9/21:9/resolution changes.
No native Warcraft UI automation is available. No subagents were requested.

Checkpoints: 654b679 core/assets/docs; e64d873 WTG/WCT order; bff70cb HUD/pick/shop/
secondary surfaces; 3d92d32 dynamic docks; a856a90 exceptional hero windows;
66f2c6b top score/controls; f89ef4d overlay/captain/owner coverage.
Checkpoint 10 is the latest native integration checkpoint; identify its commit
with git log. Git clean between prior checkpoints. Preserve ignored backups
and unrelated edits. Five generated log/backup files were restored after saving
full build evidence separately; actual Main.vj and sync metadata must stay updated.
