# Resume UI redesign

## Checkpoint 16 — authoritative current state (2026-10-09)

User screenshots 88a01576/ab276217 show intact golden ornaments over WHITE
rectangles. The earlier claim that zero vertex alpha makes a BACKDROP image
transparent was wrong on this Warcraft build. Graphite panel.tga is valid opaque
dark RGBA (channels max53, alpha255). User clarified the prior global Templates.toc
failure was a Warcraft bug; do not chase that as the current white-fill defect.

Implemented: WUI_Passive now uses real transparent pixels in UI/WOS/empty.tga
(32x32 RGBA, all alpha zero). No white.blp/vertex-alpha fallback and no alpha-zero
parents (which hide children). Installer/source/native verifier reject even one
opaque fallback pixel before accepting imports. WOSHUD.toc keeps correct no-BOM
CRLF plus complete empty ending line. Existing gold/graphite source art unchanged.

WUI_ORNAMENT_SCALE=1.15 enlarges all square corners and rail thickness by15%;
existing window and mouse-target bounds stay unchanged. Normal window/button
fills are existing graphite/button textures; native command/item/minimap surfaces
retain SIMPLEFRAME family, with transparent normal FRAME ornament overlays.
Do not replace native HUD backgrounds with opaque normal FRAME images.

Top actions share passive graphite panel .163x.050 at (.710,.541), ornate edge.
Menu/Stats/Link/Music labels at y.529; icons x.653/.691/.729/.767 at y.548.
Menu target .032x.041 includes caption; system drawer remains BELOW at .509,
then -.025 per row. Existing action handlers unchanged.

WUI_BindHeroIndicator runs from UNITSTAT_DelayedInit (.30 total game-time), never
library initialization. Stock indicator0 reparented/anchored BOTTOMLEFT to new
UNITSTAT_Widget[6] portrait (.038). Other six indicators hidden/offscreen.
WUI_ShowHeroIndicator refreshes every .10: only selected local Hero with skill
points; no hidden-enemy skill queries. Engine re-shows indicators on level-up:
https://www.hiveworkshop.com/threads/ui-originframes.316034/
Mode/pick/shop controllers, combat, fog/cooldown privacy and WTG identities preserved.

92 regression checks PASS (actual alpha bytes, rejected opaque fallback, panel
fit, recorded indicator anchors, existing controllers/privacy/order/native cells).
Production compile-only PASS:147754 total pjass lines,107 production inputs.
User confirmed editor CLOSED before MAIN integration. Native push already DONE:
109 sources,2 updated,0 added. Backup:
backups/trigger-sync/2026-10-09_111303_391267/map-before-push.
Only new texture empty.tga installed; backup:
backups/ui-redesign/assets/20261009-111304-065802.
Full MAIN build PASS:148716 total pjass lines (132889 actual script),
actual packed _build/WoS_Test.w3x has6372 files.
Compiled native MAIN script updated; previous script:
backups/main-map-build/20261009-111335-528.
41 resource imports and all46 compared archive entries match native MAIN bytes.
109 WTG/WCT identities/category traversal and source/native TOC+pixel guards PASS.
SHA256:975b11616ff1ac4d6ae52e3a655b66bc8f8ca8c4fdcb86ee61e085c5849087fd.
Evidence:_build/ui-redesign/checkpoint16-{full-main-pjass.txt,
integration-verification.json,map-sha256.txt,launch.json,runtime.json,war3log.txt}
and checkpoint16-archive/. Do not repeat build/push without inspecting state.

Supported Computer Use initialization retried: still fails before sky import
with kernel-assets OS error3. No custom automation helper workaround. User cannot
participate in click-test; do not ask again. CLI launch/log inspection is possible
but does not establish actual successful clicks/rendering.
Shutdown /s /t 60 authorized ONLY after FULL completion, saved files, finished
build/check processes and no errors; must be final action. NOT scheduled.
Configured game launched at11:17:14+03,PID24012 responding. Last log11:17:16
only scans installed map catalogue: no confirmed custom-map opening or actual
mode/world clicks. No new crash folder at inspection (last2026-10-08 20.35.28).
Build/check processes finished. Next: supported runtime inspection when available;
source/native integration and checkpoint evidence are already saved. Actual
click/visual acceptance remains unresolved; do not claim full task completion.

Older entries below are HISTORY and superseded wherever they conflict above.

## Checkpoint 15b — integrated MAIN, runtime verification boundary

Guard: World Editor not running. Push 109 sources, 5 updated, 0 added WTG entries.
Source backup: backups/trigger-sync/2026-10-09_014944_924627/map-before-push.
Frame resources backup: backups/ui-redesign/frames/20261009-014958-877878.
Full MAIN compile PASS: 148654 total pjass lines (132827 actual script).
Compiled-script backup: backups/main-map-build/20261009-015030-381.
Latest packed map: _build/WoS_Test.w3x (first slot, real MAIN).
SHA256 dcefc6acab76aba5fe0fe694b4609fe18f7726f1f57593f9656323e0517c33d1.
109 native WTG/WCT identities/traversal, TOC format, 40 resource imports and all
45 archive entries byte-equal PASS. 86 regression tests PASS.
Evidence: _build/ui-redesign/checkpoint15-{full-main-pjass.txt,
integration-verification.json,launch.json}, checkpoint15-archive/.
All build/check processes finished; no compilation or validation errors.
Configured game launched for log inspection. Actual click/visual verification
is still unavailable: Computer Use fails at initialization (kernel-assets error3).
Do NOT issue shutdown unless this unresolved completion condition is verified.


Runtime follow-up: launched at 01:51:25 +03:00, PID 26028 responding. At 01:52:27,
War3Log ends at catalogue scanning 01:51:28, NO confirmed custom-map opening.
No new crash directory (last 2026-10-08 20.35.28 ba6e19b4). This is NOT evidence
that mode/world input or the actual interface works. Game inspection is blocked
by Computer Use initialization, not user permission. User cannot participate in
click verification. Do not ask again and do not fabricate successful interaction.
Shutdown was NOT run or scheduled, because full completion is still unverified.
Runtime evidence: checkpoint15-runtime.json and checkpoint15-war3log.txt.

## Checkpoint 15 — resource parser and decoration correction

Latest user screenshot e245fa6b confirms checkpoint 14 actually loaded: gold icon
is visible, but mode clicks STILL fail and the native HUD chassis is transparent.
The user cannot help with runtime clicks; proceed with independent work and save
accurate evidence. Do NOT request the same manual runtime test again.

Concrete packaging defect: WOSHUD.toc was one line with a single LF terminator.
Warcraft TOC requires a complete ending line; the Tasyen TOC tutorial documents
failure without it and the CRLF/LF difference:
https://www.hiveworkshop.com/threads/ui-toc-files.315854/
This can skip WOSHUD.fdf, leaving no native chassis/empty cells and no passive
FRAME inheritance. It is a strongly supported explanation, not yet runtime proof.

Fixed: exact UTF-8 no-BOM CRLF + empty ending line; .gitattributes preserves bytes.
Installer validates before any map mutation, verifier checks source AND native
TOC, including registered FDF existence. WUI_Passive now uses BACKDROP with only
its own image alpha-zero vertex tint; never alpha-zero/disabled ancestors. Root,
mode/container/ornament input behavior no longer relies on custom FDF inheritance.
Normal BACKDROP containers are in normal family; native controls remain SIMPLEFRAME.
Six toolbar controls share WUI_PlaceToolbar 3x2 grid (.020 cells, .026/.028 step).
Z hover no longer expands the hit box; its hotkey sits at bottom-right like K.
Shop, Discord, emotes, ping, chat emoji and emoji mute handlers are unchanged.
Combat, WTG identities, cooldown privacy and pick/shop data remain preserved.
86 regressions PASS, including rejected old TOC bytes, no-TOC decoration fallback
and toolbar bounds/non-overlap. No claim that mocks simulate Warcraft hit tests.

Computer Use Initialize retried after latest user request: same kernel-assets
OS error 3, before sky can load. No app input/screenshot helper workaround.
Source/native integration is complete (see latest checkpoint 15b above).
Next: restore supported Computer Use availability, then verify actual mode/world
clicks, HUD/empty slots/items, pick rows and shop layout using the latest MAIN.
Input/appearance remain unverified; no further speculative owner migrations.

USER SHUTDOWN REQUIREMENT: shutdown /s /t 60 ONLY as the final action after full
task completion, all files saved, build/check processes finished and no errors.
No extra confirmation. Do NOT run/schedule shutdown while input/visual acceptance
is still unresolved or tools prevent determining completion.

## Previous integrated boundary (checkpoint 14)

## Current boundary — checkpoint 14 integrated, game input still pending

Read PLAN.md and ARCHITECTURE.md, then factual Git/native map state. Latest user
screenshots were checkpoint 13: blocked mode/world clicks, transparent chassis,
oversized native items, missing gold icon, wrong pick ability rows/difficulty,
horizontal wide stats. They are the acceptance targets for checkpoint 14.

IMPLEMENTED AND IN MAIN: WOSPassiveFrame FDF IGNORETRACKEVENTS, zero-area enabled
independent root; passive ornament containers/mode labels. Trimmed mode backdrop,
+10% window corner art/outside rail padding. Complete native command/item wrapper
scale (stock .039 base), six items .022 in 3x2 grid at .025/.027 spacing. Native
chassis BACKGROUND texture explicitly initialized, cached and shown after pick.
Seven EMPTY native SIMPLEFRAME ability cells behind real learned commands. Own
unlearned/hidden/absent overlays hidden completely; no fake DISBTN icons or key
labels. Enemy descriptions/cooldown privacy retained. Pick relationship recovered
from pre-redesign 7b3aca7: F/G above QWERT at right, centered bottom difficulty,
real textured hero-name TextButton with existing click/caption owners preserved.
Stats card width .096 (previous .178), STR/AGI/INT vertical, portrait retained.
Gold ResourceGold.blp icon. Shop category footer, search above, centered passive
prices, catalogue/pager spacing; actual recipe branches and craft data unchanged.
Native menu drawer below top openers. NO new WTG objects, no combat changes.

81 regression tests PASS. Full real MAIN JassHelper/pjass PASS: 148657 total lines,
106 enabled + header, 3 disabled. 109 WTG/WCT source identities/category traversal,
40 resources and all 45 extracted archive byte comparisons PASS.
LATEST PACKED MAP: _build/WoS_Test.w3x (MAIN, NOT test_map; first slot this time).
SHA256 b69e7dccb27980bcae1fa6c8e06c6697acd41344f25f654ecdd71beb99d2ddcb.
Native backup: backups/trigger-sync/2026-10-09_005611_586281/map-before-push.
Compiled script backup: backups/main-map-build/20261009-005655-754.
FDF/TOC backup: backups/ui-redesign/frames/20261009-005624-240979.
Source checkpoint commit: 4313fe3; preceding ornate checkpoint: 72687b8.

Game launched 2026-10-09 00:58:18 +03:00, PID 8820 using configured -editor,
-loadfile, ThunderGear profile. It responds; log so far ends in catalogue scanning
00:58:20, no confirmed Opening/Played of custom map. Native automation helper
failed kernel-assets OS error 3 even after reset/retry: do not improvise UI input
or screen-capture helpers. User text question pending: do mode buttons and world
clicks work in new build? Process survival does NOT establish loading/visual/input
success. Evidence: _build/ui-redesign/checkpoint14-{runtime.json,
integration-verification.json,full-main-pjass.txt}, archive/.

EXACT NEXT ACTION: inspect latest War3Log and user response/screenshot for actual
checkpoint 14 load/input. Verify mode click before 20s timeout, hero pick name /
F/G upper row / difficulty, world movement/casting after pick, empty unlearned
slots, six item icons/dragging/tooltips, opaque chassis/gold icon, footer shop /
search/pager/recipe scroll/craft. If defect persists, fix only implicated owner.
Do not repeat completed owner migration or reintroduce DISBTN placeholders.
Keep all redraw/handle creation client-symmetric and enemy information guards.
Root and ornateness input fix are source-based suspects until actual game proof.
If game still holds first slot, build second slot rather than kill or overwrite.
Compile-only tools/check_wos_ui.py has EMPTY main: NEVER play that artifact.
World Editor was NOT running at integration; check guard before every native write.
No pending editor closure approval. All four progress files must stay current.

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
