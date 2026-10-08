# Resume UI redesign

## Checkpoint 14a — input and geometry source correction complete

Implemented WOSPassiveFrame FDF with IGNORETRACKEVENTS for root/decorations,
zero-area independent root with interactive ancestors enabled; mode text passive.
Root/decorative full rectangles were concrete mouse-control suspects (game input
confirmation still pending). Mode panel top trimmed; window ornament +10% corners
and outside-rail padding; button styling retained. Native commands/items resize
the complete wrapper subtree, not only the outer rectangle (stock art 0.039 base).
Six items: 0.022, 3 columns/2 rows, 0.025/0.027 spacing. Chassis uses native FDF
BACKGROUND texture explicitly initialized and restored visible after pick.
Seven empty SIMPLEFRAME cells below real commands; own unlearned/hidden/absent
ability overlays are completely hidden, learned commands remain native.
Pick baseline 7b3aca7 was read: F/G upper-right, QWERT below and difficulty centered
under preview/catalogue; restored these relationships using new compact bounds.
Hero-name uses actual styled TextButton and all existing caption updates retained.
Selected stat card width 0.096 (was 0.178), attributes and resist values vertical,
portrait remains real selected-unit icon. Gold gets ResourceGold.blp icon.
Shop categories integrated into bottom bar, search above, catalogue/pager spaced,
cost labels centered/passive, recipe branch graph/crafting data unchanged.
Menu drawer below openers. 81 regressions PASS; compile-only PASS (147695 lines).
Native MAIN NOT written yet. Next: guarded push, real MAIN build, packed-byte
verification and game launch/log inspection; do not play compile-only artifact.

## Checkpoint 14 — active correction from actual game screenshots

User screenshots confirm checkpoint 13 loads, but expose blocked mode/world clicks,
transparent HUD chassis, oversized native inventory art, missing gold icon, pick
layout regressions and crooked shop alignment. New steering SUPERSEDES DISBTN
placeholders: all seven own positions remain, unlearned/absent positions are EMPTY;
keep actual native learned buttons. Restore pick F/G upper row, QWERT lower row,
name button and centered difficulty using pre-redesign backup. STR/AGI/INT vertical,
selected stat card half-width; six native items uniform and bounded. Shop categories
move into lower shop interface; recipe relations stay functional. Passive frame
hit testing/root sizing is first priority, then matching background/border geometry
(+~10% outer frame), menu drawer below top openers. Latest extra screenshot confirms
native item icons overlap neighbors and gold has only number, no icon.

No checkpoint 14 changes integrated yet. Read WOSUI.j, Starts.j,
DefaultArmorChangeStable_Copy.j, ShowCD.j, WoS_Pick_Init.j, WoS_Shop_Init.j.
Compare 7b3aca7 pick creation coordinates and saved pre-redesign source backups.
Keep native family/normal family separate, deferred startup and enemy privacy.
Checkpoint 13 has compile/archive evidence, NOT successful input/visual acceptance.

Read PLAN.md, relevant PROGRESS.md/ARCHITECTURE.md and factual Git state first.
REQUEST.md is the full user specification; WORKFLOW.md is the required staged
workflow. Source and native map evidence take precedence over these notes.

## Current boundary and exact next action

Checkpoint 13 source changes and guarded MAIN integration are complete.
Latest user screenshots confirm checkpoint 12 game entry, hidden console and
working fills/icons. Remaining visual defects prompted this new checkpoint:
mode dim square removed; seven larger shop tabs in a horizontal top row; catalogue
leftward with 0.040 icons; actual recipe edges update on selection/scroll; selected
recipe/inventory borders follow actual handles; gold placeholder no longer covers
the item; score backdrop removed; menu/stats/link/music separated at Y .548.
Built-in imagegen produced transparent ornate gold/metal source, preserved at
assets/UI/WOS/source/ornate-frame.png. Eight cropped TGA slices are registered.
Native FDF/TOC chassis is SIMPLEFRAME (below real buttons); normal ornament frames
have empty centers, avoiding the FRAME-over-SIMPLEFRAME occlusion problem.
Stock BlzHideOriginFrames(false) restores old bars after pick/draft: Systems1 now
reapplies WUI_RestoreCompactNative on that transition, in game time only.
NEW USER STEERING: show all seven Q/W/E/R/T/F/G positions for own selected heroes
even before learning. ShowCD now supplies passive DISBTN/empty placeholders and
key labels, leaving learned native commands interactive; stock occupants of empty
positions (including learn button) move offscreen. Own cooldowns remain native;
enemy cooldown guard unchanged. 76 regression tests PASS, compile-only PASS
(147612 total pjass lines). World Editor/game were not running at last check.
Real MAIN build PASS: 148574 total pjass lines, 106 enabled + header, 3 disabled.
109 WTG/WCT identities/traversal PASS; 40 resources, 45 extracted entries match.
LATEST MAP: _build/WoS_Test_2.w3x (final checkpoint 13 uses second slot).
SHA256: 54d6a726d04a3b62997046b6f27dde145bca61d0eb66d2f6941012f476b83d15.
Native source backup: backups/trigger-sync/2026-10-08_222121_122659/map-before-push.
Compiled script backup: backups/main-map-build/20261008-222153-351.
Texture/frame backups: backups/ui-redesign/assets/20261008-221504-116775 and
backups/ui-redesign/frames/20261008-221504-126392. No WTG entries inserted.
Game launched 22:18:08 with configured -editor/-loadfile, PID 23100. Log ends in
catalogue scanning 22:18:11, responding: NO verified custom-map opening yet.
NEXT: actual checkpoint 13 game appearance/input, all seven own slots before/
after learning, mode background, shop tabs/search/recipe scrolling/crafting,
top opener separation and native chassis layering. UI automation helper remains
unavailable (kernel-assets OS error 3); no screenshot/input workaround permitted.
One-off source migration script was removed after its asserted edits completed.
Never launch compile-only empty-main artifact. Checkpoint evidence lives under
_build/ui-redesign/checkpoint13-{integration-verification.json,full-main-pjass.txt,
runtime.json}; archive/ contains actual checkpoint 13 packed bytes.

Own hidden/disabled ability fallback was added after the initial build. Game PID
23100 holds the earlier first slot; final hidden-ability correction is in second
slot and has not been launched. Never overwrite a slot held by a running game.

Historical checkpoint 12 integration evidence follows.

Checkpoint 12 visual/native correction is implemented and integrated in MAIN.
User screenshots confirm checkpoint 11 enters game, but stock console/blank bars/
help/uncompacted pick and broken shop required this correction. War3Log opened
previous MAIN at 20:56:10, ended normally 20:58:33; duplicate stock FDF warning.
Latest real MAIN compile PASS: 148290 total pjass lines, 106 enabled + header,
3 disabled; 109 WTG/WCT source identities/category traversal PASS. 30 resources
(13 UI textures + 16 pings + empty clock model), 35 packed entries byte-equal.
All 68 regression tests passed; final ordinary-unit layout changed afterwards
and all 28 HUD/startup/native/visual-fix tests passed again. No gameplay changes
except once-only shared four-mode transition keeping existing mode flags/start.

LATEST PACKED MAP: _build/WoS_Test_2.w3x (MAIN, NOT test_map).
SHA256: 55d9c13daa3a58bc382eae57041b73ec73ee12302cf0064599ebaf485ed9add0.
Original WoS_Test.w3x is earlier checkpoint 12 and locked by the game we launched
at 21:37:30, PID 24004, WITHOUT -editor. Final build used second slot rather than
interrupting the running game. Do not assume the first slot is latest.
Launch log ends at catalogue scanning 21:37:33: no new crash report, process
responding, but NO custom-map opening/Played evidence. This is NOT a verified
map load or UI appearance. User newer screenshots now confirm map entry: console hidden, filled bars/icons correct; additional style/layout problems reported.
EXACT NEXT ACTION: checkpoint 13 follows newest screenshots: remove huge mode dim square; horizontal shop tabs at top, leftward catalogue, real recipe connectors/background, remove score box, separate menu/music/Discord/stats buttons; match ornate concept. If user
entered first slot, main visual corrections are present but ordinary-unit card
spacing is older. Prefer latest second slot next launch. Do not kill active game
or rewrite locked slot. If new crash, inspect NEW Crash.txt/War3Log. If screenshots,
fix actual presentation/input; do not reimplement completed owner migration.

Native push guard FALSE; updated 6 sources at 21:35 and WOSUI at 21:41, no inserted
WTG entries. Backups: backups/trigger-sync/2026-10-08_213527_135120/map-before-push
and 2026-10-08_214136_001032/map-before-push; latest compiled script backup:
backups/main-map-build/20261008-214208-098. Console skin/model backup:
backups/ui-redesign/console/20261008-213544-474564. No pending editor closure request.

Changes: game-time detach CommandBarFrame, detail parent, upper system button bar
and native tooltip BEFORE hiding ConsoleTopBar/ConsoleBottomBar. Recache slots;
retry missing containers. Normal BACKDROP fills replace textureless STATUSBARs;
left anchor fixed, attribute paths str/agi/int corrected, larger fonts. Ordinary
12-button cards now lie below MP. Help uses five code TEXT pages + wheel/arrows,
separate collapse/scroll events; registered pick/shop/mode modals suppress help.
Pick/shop creation uses fresh synchronous WUI_OnReady component/layout threads.
Complete templates replace incomplete ByType buttons and recipe sliders. Mode
selector uses graphite frames feeding one host-only guarded WOS_SelectMode and
normal-mode timeout. Installer owns ten CustomSkin keys, preserves other settings,
imports classic v800 empty-clock.mdx (one Stand sequence, no geometry). No frame
native during loading-time library initialization.

Evidence: _build/ui-redesign/visual-fix-integration-verification.json,
visual-fix-full-main-pjass.txt, visual-fix-runtime.json, visual-fix-war3log.txt,
archive/. Re-run verify with --archive only after extracting LATEST second slot.

computer-use initialization attempted through deferred mcp__node_repl__js after
reading the skill. It fails "failed to write kernel assets ... (os error 3)";
reset/retry also failed. Direct UI inspection is blocked by helper startup, not
by user permission. No custom input/screenshot workaround. CLI game launch/log
monitoring can still be used; process survival does not verify UI appearance.

Native integration block 10a DONE. Other blocks remain IN_PROGRESS because
visual/input/multiplayer verification is outstanding. User's prior screenshots
establish checkpoint 11 game entry and the defects addressed in checkpoint 12.
Future native writes keep editor guard: open World Editor can overwrite WTG/WCT.
Build checks before source/import mutations and again before compiled-script push.
WOSUI id 0x03000071 inserted in checkpoint 10; no trigger insertions since.
Never play check_wos_ui.py's empty-main compilation artifact.
Native MAIN: C:/Users/Gear/Documents/Warcraft III/Maps/WoS/Anime_WOS2_0.32.w3x

## Implemented owners and contracts

- WOSUI.j provides independent normal FRAME root under an all-player service
  leaderboard (visible, zero-size; title empty/backdrop hidden). Native SIMPLEFRAMEs
  remain under cached ConsoleUI. GameUI and ConsoleUI stay visible.
- Compact existing selected HUD, native commands/items/buffs/minimap/menu, real
  gold/lumber, toolbar, TestMode-only five-page wheel/arrow/collapse help and camera.
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
- Shared assets: 13 RGBA TGA + empty clock MDX + 16 existing ping resources. Built-in imagegen source
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
Checkpoint 12 is latest integrated correction; identify its commit
with git log. Git clean between prior checkpoints. Preserve ignored backups
and unrelated edits. Five generated log/backup files were restored after saving
full build evidence separately; actual Main.vj and sync metadata must stay updated.
