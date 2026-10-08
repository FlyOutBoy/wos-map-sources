# Resume UI redesign

Read PLAN.md, relevant PROGRESS.md/ARCHITECTURE.md and factual Git state first.
REQUEST.md is the full user specification; WORKFLOW.md is the required staged
workflow. Source and native map evidence take precedence over these notes.

## Current boundary and exact next action

Checkpoint 11 crash correction is implemented and integrated in native MAIN.
Read the latest PROGRESS.md entry before anything else. User reported immediate
load crash on Warcraft 3.0.1.24342, ACCESS_VIOLATION read 0x18 at 20:35:28.
WUI_Init now ONLY schedules a 0.10s timer; WUI_OnReady queues six frame owners
plus music TOC. Native selected layout waits another 0.20s. Buff label/leaderboard
title clear text instead of unsafe visibility; child/null-parent guards added.
Real MAIN compile PASS: 147965 pjass lines, 106 enabled triggers + header,
3 disabled. All 57 regression tests PASS: HUD/startup/docks 17, pings 21,
ally ability UI 8, trigger order 3, workflow 8. Independent native identity/order
and all 33 packed archive entries PASS. No object-data/gameplay edits here.
At 20:49 editor guard FALSE, guarded push updated 9 scripts (no insertions).
Packed map launched at 20:52:30, PID 31052, -launch -editor -loadfile ... -hd 0.
Process responds, no new crash report, but War3Log stops at map-catalogue scanning
(20:52:32) and has NO custom-map open/Played confirmation. Do not call this a
successful map load. An async question asks user what is visible (map/menu/crash).
Exact next action: use user reply to finish real load verification. If at menu,
compare launch flags with the successful World Editor command in prior Crash.txt
(that command has NO -editor flag). Do not kill/relaunch an unknown active game.
If crash, read NEW Crash.txt/War3Log and isolate the still-unsafe frame native.
Do not launch tools/check_wos_ui.py's empty-main artifact.

computer-use initialization attempted through deferred mcp__node_repl__js after
reading the skill. It fails "failed to write kernel assets ... (os error 3)";
reset/retry also failed. Direct UI inspection is blocked by helper startup, not
by user permission. No custom input/screenshot workaround. CLI game launch/log
monitoring can still be used; process survival does not verify UI appearance.

Native integration block 10a DONE. Other blocks remain IN_PROGRESS because
Warcraft interaction/visual/multiplayer verification is pending. User's previous
real run exposed the critical load error. Do not label runtime success from compile.

User confirmed closure; process guard FALSE before integration. No pending closure
question. Future native writes must retain the process guard: an open editor can
overwrite external WTG/WCT. Build now blocks before source/import mutations, with
a second compiled-script guard retained. INTEGRATION.md contains exact commands.

WOSUI id 0x03000071 was inserted in checkpoint 10; no new trigger in checkpoint 11.
Latest evidence: _build/ui-redesign/crash-fix-integration-verification.json,
crash-fix-full-main-pjass.txt, crash-fix-runtime.json and archive/.
Compiled main initializes WOSUI before dependent UI owners and original map init.

After the map loads, play _build/WoS_Test.w3x using OWNER_STATUS
runtime matrix; obtain actual gameplay/screenshots to fix visual/input issues.
Do not repeat completed migration. The crash correction justifies a new build.

Native MAIN Scenario Folder:
C:/Users/Gear/Documents/Warcraft III/Maps/WoS/Anime_WOS2_0.32.w3x
Packed _build/WoS_Test.w3x is the MAIN output, not test_map. check_wos_ui.py uses
an empty main for compilation only; NEVER package it as a playable map script.
Latest packed SHA256:
1a1d7c326f2852e2f2c7849b668e42ec46ca29109bc5427b4fd1f7a8ac48cafd.
Latest backups: backups/trigger-sync/2026-10-08_205047_996178/map-before-push;
backups/main-map-build/20261008-205131-201. Checkpoint 10 backups in PROGRESS.md.

## Implemented owners and contracts

- WOSUI.j provides independent normal FRAME root under an all-player service
  leaderboard (visible, zero-size; title empty/backdrop hidden). Native SIMPLEFRAMEs
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
Checkpoint 11 is the latest native crash-fix checkpoint; identify its commit
with git log. Git clean between prior checkpoints. Preserve ignored backups
and unrelated edits. Five generated log/backup files were restored after saving
full build evidence separately; actual Main.vj and sync metadata must stay updated.
