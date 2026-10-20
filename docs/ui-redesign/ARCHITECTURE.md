# Existing UI architecture

## Checkpoint 20 — screenshot corrections, source ready, NOT yet built (2026-10-09, Claude)

Request (user screenshots + concept art): fix transparent voids, tiny items with a
huge item cooldown, small minimap frame, mode buttons whose frame is smaller than
the real button, restyle repick/swap, Test-help covering the Menu drawer, empty
unfilled top strip, small pick portrait / crooked stats / overflowing descriptions,
abilities not on one row, Dota-style Alt+Click learning with level indicators,
smaller train-kills docked to the time, STR/AGI/INT "with level" display, camera
slider look, remove the HUD "Dmg taken" line, remove empty space.

Implemented (sources + assets; World Editor/MAIN integration and game check pending):
- Ornaments: `WUI_OrnateBorder(Ex)` now puts the rail CENTRE on the owner edge
  (fractions measured from the corner art: rail .293c top/.307c bottom, .207c
  sides, thickness .125c). Window fills always reach the metal; no gaps. Rails
  rebuilt from corner exit pixels (old crops had stray red/yellow rows). Optional
  corner mask (1 tl, 2 tr, 4 bl, 8 br). `WUI_OrnateWindow` = flush border.
- Buttons: `WUI_TextButton` = gradient fill (fill-normal/hover/selected) + flush
  `WUI_GoldFrame` hairline + corner gems; frame == clickable rectangle.
  `WUI_SetButtonTextScale` added. Mode selector: no parent scale, .264x.040 buttons.
- Bottom HUD (4:3 units): minimap block 0-.160 x 0-.144 (native minimap .004-.140,
  camera slider strip .140-.160, filled by native surfaces 9051-9054 AROUND the
  minimap only). One chassis .160-.798 x 0-.094 (native surface 9050, mask 11)
  with dividers at .2285/.3035/.5910/.6970 (+ horizontal .7470 at y .0655).
  Portrait .050 at (.1945,.0595) + level plate (badge.tga) below; stats rows
  ATK/PHYS/MAG/STR/AGI/INT (icon + left text, "base +bonus", main stat gold);
  HP/MP .272 bars at y .0835/.0697; ONE ability row QWERTFG: X=.327+.040*slot,
  Y=.042, size .034; pips at Y=.0165; items .030 3x2 at X .612/.644/.676,
  Y .061/.028 (+ recessed empty cells 9070-9075); gold row y .0795; toolbar
  .025 cells at .718+.030c / .050-.030r. Orders = small tab (.556,.1015),
  drawer row y .137. Native/ally tooltips bottom-left (.307,.126).
- Item cooldown: `WUI_ResizeCooldown` scans ALL children >= .020 wide (item
  cooldown sprite is not child 0, so it previously stayed .039).
- Learning (ShowCD.j, AllyHeroAbilityUI): `AHUI_BaseAbility[slot]` = first rawcode
  (learnable hero skill). Pips (6 max) under QWERT: full/ready/empty textures.
  Clickable learn strip over the pips when `AHUI_CanLearn` (skill points, level <
  field 'alev' (fallback 5), next-level requirement when 'alsk' > 0). Alt overlays
  over icons exist only while synced Alt is down (16 meta combos, keyup or 4 s
  timeout) AND a level is learnable. Click handler (synced) learns for Hero[pid]
  via SelectHeroSkill on the base rawcode. Frames allocated once on all clients.
- Top strip .452x.046 at (.400,.577), translucent panel-soft fill + flush rails;
  icons y offset .006 (RearrangeTeamUI aligned: -.196/-.074, y .006); score boxes
  .030 gold frames; time .070x.0135 at .5465 with train kills .062x.0115 docked
  directly below (.534). FRAME_StatusHeroStringPlayerTakenDamageMag hidden.
- Camera: `WOSVerticalSlider` (new WOSControls.fdf, loaded LAST in Templates.toc;
  stock QuestMainListScrollBar fallback) at (.150,.066) .012x.104, glyph-camera.
- Test help: .188x.205 block below the Menu drawer (toggle .4385, panel .3245),
  panel-soft + gold frame; drawer rows (.509/.484/.459) are never covered.
- Pick: preview .240x.330 at (.613,.365); portrait .156 (+.164 frame); framed
  two-column stat card (STR/AGI/INT "value +gain / lvl", primary marked *;
  ATK/DEF/MS/AS); all 7 abilities in one row (.027, step .031, y .2515);
  description overlay .226x.232 with .009 inner margin, text scale .80.
  Repick/Swap: graphite fill + gold glyph + gold frame + caption (.020/.054, .568).
- Assets: tools/build_wos_ui_textures_cp20.py (deterministic, chained from
  build_wos_ui_assets.py). 27 new TGA + 4 rebuilt rails; installer CP20_NAMES.

Verification here: crude vJASS flattening + pjass type check of all edited files:
no errors on changed lines. Regression suite: 125 checks (14 new in
test_wos_ui_checkpoint20.py); obsolete geometry asserts of checkpoints 13-19
updated to the new contract. Only environment import failure test_test_map_workflow.
NOT verified: JassHelper compile, World Editor push, real Warcraft rendering/input,
whether the Reforged item cooldown child is now scaled, Alt meta behaviour.

Next: close World Editor, run task "WOS: BUILD + RUN MAIN MAP" (installs 55 UI
textures + WOSControls.fdf, compiles Main.vj); then push sources to native WTG/WCT
as in previous checkpoints; check in game: chassis/minimap fill, items+cooldown,
Alt+Click and learn strip, slider, pick preview, Test Mode Menu drawer.

Checkpoint 19 and older sections below are history where they conflict.

## Checkpoint 19 — integrated, engine verification pending (2026-10-09)

Latest reference: the original scenario folder
`C:/Users/Gear/Documents/Warcraft III/Maps/Anime_WOS2_0.32.w3x`, not MAIN.
Backup loads Templates.toc before frame creation and its charge definitions separately.
WUI now loads one Templates.toc at game-time .10: HUD, Music, Charges in dependency
order, before all queued owners. Stock engine FDF is already present and must not
be reloaded (previous ReplayPanelStringTemplate duplicate). Private EDITBOX remains;
the horizontal slider body/skin names now match the backup's LocalMp3Player.fdf.

Actual split-layout bug fixed: ShowCD still used .036 icons and one Y coordinate,
while native commands used .028 and two rows. Both now share WUI_ICON_SIZE=.036,
X=.274, step=.039, QWERT Y=.023, FG Y=.044. Existing native cooldown child models
are resized after lazy creation; no orders, animation values or charge labels replaced.
Main chassis is .608 x .090 at (.448,.045); equal side boxes .104 x .088;
all lower sections moved .018 left, vitals/stats/actions .008 down. Minimap is .140
square; camera moved exactly -.0175 X to .1335, height reduced .140 -> .126 (10%),
Y=.067; native/ally tooltip bottoms (.256,.106). Portrait keeps its larger border
and Tas level label. Mode parent-scale correction from18 retained.
Music header now says Choose a track when tracks exist but none was selected;
the previous No tracks imported header was false in that state. Local scan unchanged.
All14 Music BLPs match the original backup, decode as256x256 RGBA, and match archive.

Integration 13:52:00: 109 native source identities; 0 added, 6 updated;
backup `backups/trigger-sync/2026-10-09_135200_132860/map-before-push`.
Full MAIN build 13:52:33 succeeded; 6383 files; 133106 script lines /148933 total.
Archive SHA256 D394486164D7F951DD4E46822EE799BEE7F5F213DF07D232D831380157A97A16.
118 regression checks passed. Source/MAIN/archive:52 UI assets plus14 original
music icons byte-identical; native WTG/WCT identities and traversal PASS.
Evidence `_build/ui-redesign/checkpoint19-{tests.txt,integration-verification.json,
map-sha256.txt,full-main-pjass.txt,backup-comparison.json}`.

Owned game process16204 launched13:54:48 for startup inspection. The game ended13:56:22.
Saved log has0 FDF parser errors and38 model creation failures; see
`_build/ui-redesign/checkpoint19-runtime-inspection.json`. Computer Use
initialization still fails before import: kernel assets OS error3; no real click,
render, slider dragging or playback confirmation. Game log can be buffered; an alive
process and static checks are not engine verification. Earlier18 log has empty-name
model failures and SpellMarkerBlue/cupbubble failures (those assets equal backup).
Do not report complete success or shut down the computer while verification is
unresolved. No shutdown command issued. MAIN/artifact are saved for continued work.

Checkpoint18 was integrated13:14:39 with113 checks and hash B073625C...;
its geometry/three-load setup is superseded by19. Older sections below are history.

## Checkpoint 18 — active corrections (2026-10-09)

Latest steering supersedes17 geometry: shrink minimap frame, integrate full-height
camera slider in its right edge, dock all lower sections immediately beside it.
Also: actual mode/portrait frame scale; central timer-based dependency TOC load;
no partial Music window on creation failure; score text anchored to its own boxes;
separate gold train-kill caption; Hide UI hides top chrome except scores/round clock;
shop categories above, item rows aligned below tree header; tooltips above abilities;
translucent team backdrop preserves FPS/ping beneath. Do not alpha a text ancestor.

Runtime evidence: War3Log 12:36:25.192, Music.fdf line16 rejects JUSTIFYCENTER for
FontJustificationV and aborts parsing before slider. Correct token JUSTIFYMIDDLE.
Prior17 source was integrated12:32, SHA2568F6DBB61...,103 tests passed, but this
real FDF parser failure is not covered by those tests. New integration/checks pending.
Computer Use initialization OS error3 persists; real click/render verification not
available. Shutdown remains conditional on full completion, never while unresolved.

## Checkpoint 17 — authoritative current state (2026-10-09)

Latest request: fix recurring music TOC failure, unify lower boxes/actions, enlarge
mode/minimap rectangles, move vitals/abilities left, portrait level badge, flush
top scoreboard/action panel and right test-help block. Screenshot references:
40aaafc5, cd78d241, 82cdc068, 7b841409. These supersede checkpoint16 geometry.

War3Log at 11:18:34 reports escmenutemplates.fdf line437 duplicate
ReplayPanelStringTemplate. Reloading engine FDF globals aborts the original
Templates.toc and prevents Link/Music creation. Its LF/no-empty-ending bytes
were also malformed, but repairing that alone does not fix this actual error.
WUI_Bootstrap now loads only bundled WOSHUD.toc and Music.toc at game-time .10,
BEFORE queued owners; LMP reads WUI_HasMusicDefinitions, never reloads stock FDF.
Music.toc is no-BOM CRLF + empty line and lists ONLY UI\WOS\Music.fdf.
Music.fdf owns independent slider and EDITBOX LMPLinkEditTemplate, with direct
bundled graphite/gold textures, no Includes/inheritance/global StringList.
Music URL, community link and shop search all use that private EDITBOX.
First17 MAIN/artifact (12:12, hash E43E...) included stock Esc templates and is
SUPERSEDED: final root-cause correction and latest geometry must be pushed,
compiled and verified again before using the map.
Music icon buttons no longer inherit Glue templates. Track rows use custom
WUI_TextButton and WUI_SetButtonText updates their TEXT child, not the BUTTON.
Installer/verifier cover both private resources and reject malformed endings.
Primary format reference: https://www.hiveworkshop.com/threads/ui-toc-files.315854/
BlzLoadTOCFile false still reports an error; do not mask real resource failures.

Latest screenshots75cf72ae/842660b3: outer mode panel had enlarged but buttons
had not. Actual four BUTTONs are now .2645x.0444 (old .230x.037 times1.15/1.20),
centers .374-.054*i, with nonoverlapping hitboxes inside panel. Pick portrait
art .110square stays intact at(.608,.413); frame .1265square =1.15x with filled
WUI_Window graphite background/ornate gold edge bound to portrait center.
Its bottom .34975 clears stats top .3455; top .47625 clears name bottom .480.
HUD portrait border also enlarged .0437square around .038portrait (1.15x).
Mode full panel .3105x.3132 = old .270x.261 times1.15/1.20 (not just ornaments).
Minimap frame .1702 square = old.148 times1.15, center(.074,.074); native image
BL(-.0065,-.0065), TR(.1545,.1545). This uses wide-display margins; check4:3
rendering separately. Camera slider .014x.120 at(.174,.074), twice old width.
Three lower boxes all .104x.096: stats(.240,.050), inventory(.630,.050), actions
(.744,.050). Main chassis native/normal .608x.098 center(.492,.049), lower than16.
Native frame families unchanged; opaque normal FRAMEs must not cover native
SIMPLEFRAME commands/items. COMMAND_X=.318, STEP=.039, SIZE=.036, Y=.044.
Stats right=.292, ability left=.300, ability right=.570, inventory left=.578,
inventory right=.682, toolbar left=.692. Native items remain scaled wrappers,
3x2, .024 icons with .026 column/.031 row spacing. Never resize wrapper alone.
Vitals left=.301 (was.3365), width.275. Stats remain vertical. Hero level is
TasAbilityChargeBox_CreatePortraitLabel: normal-family counter attached BOTTOMLEFT
to portrait, using TasBox font .008 and gold/graphite style; moves with portrait.

Top team panel .450x.064 center(.400,.568), flushY=.600. Ten hero portraits
remain clickable. Scoreboxes separate center±.043 atY=.579, score font2.00.
Round timer has compact STARTS/ENDS title+time between scoreboxes; every active
timer writer updated, phase/remaining-time calculation unchanged. Thin elapsed
time box below at(.400,.551), .090x.013; kills caption retained below.
WUI_ScreenRight=.4+.3*clientWidth/clientHeight; presentation-only calculations.
Top actions .180x.072 center(right-.090,.564), flushTOP/RIGHT. Icon centers
right-.156+.044*i atY=.580; Menu caption/target are readable. Hide UI and Shop Key
are actual buttons below, preserving local portrait hiding and shop-key rebinding.
System drawer opens below; not over Music/Link. Test help .210x.260, flushRIGHT,
three denser pages, all Arrow names preserved, commands gold/explanations white.
Toolbar six targets .023 square atX=.717+.027*column,Y=.065-.031*row; six new
gold textures: shop/cart, community/chat, chat smile, emotes, ping, muted ping.
Chat mute uses same dark button material plus gold check state. Gameplay emotes,
ping target selection/fog safeguards/controllers are preserved.

Regression suite currently103 checks; rerun after root-cause/geometry changes. Previous100 checks PASS; production compile-only PASS147780 total lines before
the final cosmetic icon alignment (full MAIN build below is authoritative).
Evidence: _build/ui-redesign/checkpoint17-tests.txt. Tests exercise production
TOC bytes, successful load caching, dynamic track text child, actual emitted
anchors, viewport aspect ratios, portrait badge, inherited privacy/input guards.
Not evidence of Warcraft rendering or successful real clicks.

INTEGRATION STATUS: source/assets ready; MAIN push/full build/archive comparison
pending. Editor/game were not running at inspection. Recheck guard before push.
Run tools/run_ui_regressions.py for full suite; .vscode/build-run-w3-map.ps1
-Target Main -NoLaunch for guarded source/assets/main-script build. Verify all
resources with tools/verify_wos_ui.py and explicit archive extraction name list.
Keep checkpoints and WTG/WCT identities; never overwrite an open editor.

Computer Use retried: initialization fails before @oai/sky import with kernel
assets OS error3. No custom UI automation workaround, no user click assistance
available. Actual new-map render/click acceptance remains unresolved. Do not
claim task fully complete or shutdown. User authorized shutdown /s /t60 ONLY
after full completion, all saved/builds finished/no errors; must be LAST action.

Older checkpoint entries below are history and superseded where they conflict.

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
Native MAIN integration complete: 109 source identities, 40 resources/45 packed
entries PASS; full MAIN compile 148657 lines. Runtime input/appearance unverified.

## Checkpoint 14 — screenshot acceptance targets (supersedes checkpoint 13)

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

Checkpoint 14 sources are integrated. Read WOSUI.j, Starts.j,
DefaultArmorChangeStable_Copy.j, ShowCD.j, WoS_Pick_Init.j, WoS_Shop_Init.j.
Compare 7b3aca7 pick creation coordinates and saved pre-redesign source backups.
Keep native family/normal family separate, deferred startup and enemy privacy.
Checkpoint 13 has compile/archive evidence, NOT successful input/visual acceptance.

## Checkpoint 13 presentation contracts

- WUI_OrnateBorder is a passive normal FRAME with four square corners and four
  independently anchored rails. Reuses eight generated alpha TGA crops; no local
  allocation and no normal/native parent mixing. Windows retain their real owners.
- WOSHUD.fdf/TOC creates the opaque bottom surface as native SIMPLEFRAME; normal
  chassis/minimap/inventory frames contain only transparent ornaments. Commands
  and native inventory parent use level 2; chassis level 1. Never put an opaque
  normal backdrop across native buttons, since normal frames render above them.
- WUI_TextButton stores its own backdrop/label/selected presentation state, shares
  local hover trigger, preserves callers' click events. Shop tabs use this helper.
- Shop tree has 18 allocated passive lines, three per visible relation. Local
  CraftItemCheck shows a branch only when GetVisibleCraftRelation returns a real
  ID. Current recipe offsets, crafting cost/data and synchronized input unchanged.
- Systems1's HideBottomUI(false)/HideUIExceptTopMenu(false) calls
  WUI_RestoreCompactNative.evaluate after the stock restoration, so pick/draft
  cannot restore resources/hero/console bars over the compact UI.
- ShowCD accepts own selected heroes only to hide stock occupants of empty cells
  via WUI_ShowNativeAbilitySlot. All own normal overlays/keys are hidden, learned
  commands stay native. Seven passive native cells underneath supply empty borders.
  Foreign descriptions/cooldown privacy are unchanged. No fake own ability icons.

## Owners and integration boundaries

| Source | Responsibility / data |
|---|---|
| WOS_Start/WoS_Hero_Icons_Init.j (`heroicon`) | Existing ten-player HeroIcons, train/round scores/timers, camera slider, player statistics, Discord. `Hero[]`, Team1Round/Team2Round/TrainKill/CurrentRound. `UpdateStatusHeroSlotOptimized`, `PlayerStatusHeroPeriodic`, manual initialization from map start. |
| WOS_Start/DefaultArmorChangeStable_Copy.j (`HeroUnitPanelStats`) | Existing selected unit overlay now compact icon/stats/vitals/gold HUD. `GetHpRegen`, `GetMpRegen`, `GetPhysRes`, `GetMagRes`, Avul/base exception. Native damage text context 0; local visibility guard. |
| WOS_Start/ShowCD.j (`AllyHeroAbilityUI`) | Command-slot mapping QWERTFG, genuine origin commands for own selected unit, presentation overlays/tooltips for other units; enemies never expose cooldown. `AHUI_GetOriginSlot`, `AHUI_UpdateOriginState`, `AHUI_Periodic`. |
| WOS_Start/WoS_Pick_Init.j (`AAINIT`) | Actual category/page/hero preview/confirm/random/ban/repick/swap UI; normal/captain/draft bindings; map-start initialization. |
| WOS_Start/WoS_Shop_Init.j | Actual shop tabs/search, recipes/craft, auto-buy, inventory; existing input/event handlers. |
| WOS_Start/Scoreboard.j (`WosScoreboard`) | Graphite style reference; team/player stats, saved hero records; requires heroicon. |
| WOS_Start/DamageStats.j (`DamageStats`) | Optional numeric damage collector and independent upper-left collapsed colored-bar leaderboard; Dealt/Taken x Round/Game/Session/Previous plus paged per-source details. `DAMAGE_STATS_ENABLED`; local UI reads shared numeric buckets. Cached WindowPart12/13/14 (details/compact/tooltip), TopActionOwner parent, shared staged startup. |
| WOS_Start/Starts.j | TestMode and mode dialog, combat/system setup; mode handlers; TestComm now shows the scrollable help panel (permanent instructional tags removed). |
| WOS_Start/TeamMapPings.j | CP54 Z frame buttons + one-shot terrain click; no MOVE/screen polling. Shared disabled click listeners/timer lifetime, ally pings, snapshots/minimap/fog privacy unchanged. |
| WOS_Start/ChatCommand.j | Emoji palette, local enable/disable; frame toggles and sync commands. |
| WOS_Start/EMOTES.j | Existing emote palette/sync/effects; K key-up and toolbar share Emoji_ToggleMenu. Obsolete K key-down/null FRAME_Chat0 handler removed. |
| WOS_Start/Player_Pick_Mode.j, Captain_Draft.j | Mode-specific selection/vote interfaces and handlers. |
| WOS_Start/UI_CAREER.j, MusicPlayer.j, UniversalTooltips.j | Career UI/music controls/shared tooltips. |
| Systems/Systems2.j, TasBox.j | Hero ability/counter bars, charge box library; some SIMPLEFRAME children under native Console. |
| Heroes/*.j | Spell loops publish authoritative remaining time/resources through WUI_HeroProgress/Text/Counter; public spells use WUI_HeroProgressPublic. WUI_HeroProgressIcon updates public artwork for all viewers and private artwork only for its owner. Kyoraku supplies act captions/art and measures its description text for WUI_ColumnHeight (CP66). WOSUI owns keyed FRAME creation, captions, formatting, visibility and expiry. |

Paths above are relative to `triggers/`. Exhaustive inventory is saved in FRAME_INVENTORY.md; inspect only affected files in subsequent sessions.

## Root constraints

- CP59 provenance: playable STABLE's compiled script was newer than its WCT.
  Current source was recovered from the pre-import project backup and matched
  against2437 compiled gameplay/UI functions. Import/build parity is mandatory.
  Working feed X is min(.442,screen-right-.250), on the existing changed-only
  .25 clock. CP58's .560 and old DamageStats were regressions, not defaults.

- Selected-unit HUD: `UNITSTAT_Update` visits player slots; selection events maintain private UI-only per-player records, including remaining units after multi-deselect. `GetLocalPlayer` selects only `UNITSTAT_Render` for that client's existing frames. Selection records must never feed gameplay setters, RNG or handle allocation. Render uses shared read-only `DamageCheckModifiers`; combat `DamageCheck` retains `GearDamageRun` and listeners. Current listeners are empty; future amount-changing listeners require a pure-preview contract. Native portrait/attack text primary-unit agreement for multi-selection still needs engine testing. Full MAIN R was multiplayer-confirmed by the user; the engine-internal cause is not proved. CP54 user-requested performance pass uses .20 HUD refresh; selection ownership and pure outgoing preview stay unchanged.
- CP54 scheduling/input: see RESUME CP54. WUI_StopPingTarget is agreed-event-only; frame hover never enables/disables shared listeners. F2/ping timers stop from shared state; local visibility may gate rendering only. WOS_DESYNC_PROBE_ENABLED defaults false.
- TEXT geometry follows the working Scoreboard constructor: anchor and physical width/height first, alignment and font scale last. Do not set inverse-scaled dimensions after font scale. Cached tooltip text can use AllPoints like F2; anchor the box to its source. CP52 geometry tests catch outside-owner text and icon values, but cannot certify native font rasterization. DamageStats source digits sit BELOW the full-square art; never use white.blp + vertex tint for their backing. Its WUI_CreateFill bars use precolored textures and WUI_SetValue, not STATUSBAR or WUI_FrameSetValue. CP53 uses BlzFrameSetFont at unit frame scale for DamageStats, anchoring totals to the fixed bar RIGHT edge. Hover cells include art and digits; one manual tooltip owner, no engine tooltip binding or duplicate passive-focus cleanup.
- FRAME and SIMPLEFRAME have separate hierarchies. Native command/inventory
  SIMPLEFRAME parents must not be rebound to a normal leaderboard FRAME.
- Create/get frame handles synchronously; first-time native lookups inside a
  GetLocalPlayer block can cause different handle allocation across clients.
- A hidden parent hides descendants. A service leaderboard root must stay visible;
  clear its title text and hide its backdrop. New normal FRAME root lives there.
- WUI_Init only schedules WUI_Bootstrap for 0.10s game time. No frame lookup,
  creation, TOC load or visibility mutation belongs in a library initializer.
  WUI_OnReady registers one trigger per UI owner; bootstrap creates the root and
  controls first, then executes/destroys these triggers in registration order.
  Selected HUD, ally ability UI, emoji, pings, scoreboard, career and music TOC
  startup use this boundary. Selected HUD waits another 0.20s before native layout.
- Native SimpleFontStrings (buff label, leaderboard title) receive text setters
  only, never visibility/alpha setters. Child lookups require an index/count guard;
  native layout does not reparent absent command/item parents or hide null handles.
- Keep GameUI visible. Preserve stock command/item handlers and system menus.
- Avoid BlzHideOriginFrames(true) until each required stock surface is accounted for.
- Reforged moving commands/items uses named CommandButton_N / InventoryButton_N;
  keep origin handles for existing data/overlay mappings.

Primary references checked:
- https://www.hiveworkshop.com/threads/the-big-ui-frame-tutorial.335296/
- https://www.hiveworkshop.com/threads/ui-originframes.316034/
- https://www.hiveworkshop.com/threads/ui-positionate-frames.315860/

- https://www.hiveworkshop.com/threads/ui-simpleframes.320385/
- https://www.hiveworkshop.com/threads/ui-create-a-textbutton.315897/

## Implemented layout contract (compiled, not game verified)

- WOSUI.j normal root independent of Console. CreateLeaderboardBJ associates the service board with all players; board root size is zero, visible, title empty, backdrop hidden. All roots created synchronously after the startup timer.
- Native command/item SIMPLEFRAME tree retained; items share command parent. Native buff bar is also moved out of hidden unit-detail panel and retains engine status tooltips.
- Seven slots [8,9,10,11,7,5,6], centers X=0.354+slot*0.040, Y=0.044, size=0.036.
- Native slots 0..4 are in Orders/Learn drawer; ordinary unit fallback shows 12.
- Minimap corners (0.004,0.004)..(0.144,0.144); portrait (0.176,0.051), stats
  directly right (0.200..0.310), vitals center (0.474,0.093/0.079), items 3×2
  X=0.630/0.655/0.680, Y=0.060/0.035; gold center (0.742,0.091).
- Top portrait subtree is separately hideable; scores/train remain on original root.
- Top root center (.400,.560), icons .028 with original .030 step/positions retained
  for RearrangeTeamUI compatibility. Central score surface .084x.055; scores at
  ±.027, font 1.55, train .018. Options at (.650,.590) use .012 existing checkboxes.
  Camera/damage/options containers are transparent FRAMEs instead of alpha-zero
  EscMenuBackdrops; manual hero tooltips share graphite/thin-gold surface.
  Existing damage summary is compact at (.505,.117), .300x.016; its data unchanged.
- Test help only shown by original TestComm when TestMode is enabled.
- Toolbar: X=.718/.744/.770, Y=.060/.035, size=.020; emoji checkbox .012.
  WOS_ToggleShop in Systems/ButtonPressed.j owns real keyboard/toolbar open/close;
  toolbar uses vJASS .evaluate because it is a plain map function. Existing shop
  page, observer catalogue, readiness and debounce preserved.
- WUI_Window creates graphite BACKDROP + transparent thin gold child instead of
  EscMenuBackdrop. WUI_StyleButton skins documented ScriptDialogButton states.
- WOS_LayoutHeroPick at the end of CreateUI repositions actual catalogue/category/
  pick/preview/player handles. Main bounds X=.092..748, Y=.118..544; same 5x6 grid.
  Seven preview abilities remain real tooltip handles; logos remain imported originals.
- CaptainDraft root uses WUI_GetRoot; bans at (.600,.192), status at header Y=.526
  for all phases. Player claim controls retain original owners. WOS_LayoutCaptainVote
  repositions actual captain voting and team selection handles at their creation
  boundaries; candidate/captain/team indices and all vote/pick handlers retained.
  Vote modal .400x.258 at (.400,.345); team modal .444x.286 at (.400,.347).
- AllyHeroAbilityUI normal overlay roots use absolute command HUD coordinates
  (.354+slot*.040,.044), avoiding anchors across FRAME/SIMPLEFRAME hierarchies.
  Tooltips use the independent WUI root, graphite surface and bottom-right
  (.790,.152). Real ally cooldowns and enemy-description-only privacy retained.
  Hero preview and draft ban tooltips also share the graphite/gold surface.
- WOS_LayoutShop at the end of CreateItemUI moves existing seven tabs, 35 catalogue
  cells, six recipe relations + selected item, eight inventory/buy/sell handles,
  search/page navigation and Auto-buy. Main bounds X=.022..778, Y=.169..509.
  Selection/purchase/crafting/recipe/search algorithms were not rewritten.
- Secondary windows: career/music/emote/chat emoji/player stats share WUI_Window; scoreboard uses a transparent FRAME + WUI_Border so its existing opacity switch remains functional. Camera slider is at (.150,.070), .007x.112, beside minimap.
- WOSUI dynamic dock registry is presentation only. Synchronous registration uses
  stable owner/source keys so recreated frames replace old entries. Refresh reads
  local frame visibility, packs owner meters above minimap, buffs above HUD and
  existing public meters below the top bar; movement interpolates at 0.10s.
  It never reads units or changes buff duration, casting, charges or visibility.
  45 six-frame production meters reuse original handles/state via WUI_HeroMeter;
  Erza Second Origin's two-icon meter adds one adapted member (46 total).
  MyFrame/MyFrameBuff unit timers and Kenjaku/Tsuna chips retain native SIMPLEFRAME
  parents from WUI_GetSimpleRoot; independent labels follow numeric coordinates.
  WOSHeroMeter.add/update/show is the shared constructor API for future owners.
  Details and remaining exceptional owners: DYNAMIC_METERS.md.
- Inori's existing weapon selection keeps all four real click handlers; panel
  .360x.248 at (.400,.345), real ability descriptions use scrollable TEXTAREA.
  Existing selection sprite now follows actual weapon buttons. Kyoraku's public
  help panel is .194x.196 at (.689,.320), controls at (.775,.430), within 4:3 bounds.
- CaptainDraft/UI_CAREER/MusicPlayer variable aliases were missed by first direct
  parent migration and are now corrected. Normal roots use service root; native
  SIMPLEFRAME counter in Systems2 now uses ConsoleUI instead of ConsoleUIBackdrop.


### Validation boundary

Native JassHelper/pjass and production-handler tests are available. No native
Warcraft UI automation is available; visual, actual item drag, menu modal behavior,
resolution changes and live multiplayer must be recorded as unverified until played.

MAIN integration checkpoint 10: 109 native WCT sources independently matched to
WTG names/categories and project files; editor traversal retained. Full MAIN
JassHelper build passed (147876 pjass lines). All 29 UI/ping imports registered;
33 extracted archive entries match native map bytes. Compiled main initializes
WOSUI before GearSystems2, AllyHeroAbilityUI and selected HUD, then original map
initialization. This proves packaged integration, not actual engine UI behavior.
Build guard now rejects open World Editor before source/import mutations; late
script guard remains for an editor opened during compilation. Explicit archive
extraction normalizes path separators and fails on requested missing entries.

### Checkpoint 12 corrections (integrated; game rendering unverified)

Reforged 2+ ConsoleTopBar/ConsoleBottomBar contain stock textures and command/unit
containers. Move named CommandBarFrame, parent(SimpleInfoPanelUnitDetail), upper
system button bar and native tooltip to ConsoleUI SIMPLE root first, then hide
chrome; preserve inventory/buffs and do not infer a container from slot zero.
Native setup retries missing lazy containers; frame work stays in game-time timers.
CustomSkin console/overlay/inventory textures become blank, clock uses an empty
classic MDX. Installer edits only owned keys, backs up and preserves other sections.
Normal BACKDROP width fills remain in normal HUD family; left anchored, percentage
clamped/cached by WUI_SetValue. Legacy MDX meters keep native value API.
Big pick/shop factories dispatch components and final layout through WUI_OnReady
fresh synchronous threads. Full templates use BlzCreateFrame, not incomplete
ByType inheritance. Mode selector uses normal frames, same four gameplay modes,
host-only action, shared once-only timeout/click transition. Help uses five TEXT
pages + wheel/arrow events; collapse uses its own trigger and cannot eat scroll.

Help/modal registry: WUI_RegisterModal called synchronously for mode/pick/shop;
local dock refresh suppresses help while one is visible, retains collapse state.
Ordinary command cards use two rows at Y=.047/.016, size .028, below MP .079.
Latest MAIN compile/109 identity/30 import/35 archive checks pass. The first slot
is held by launched Warcraft; final packed artifact is WoS_Test_2.w3x.
Primary console skin reference: https://www.hiveworkshop.com/threads/customconsoleui.328354/

## ResourceBar tooltip contract — 2026-10-11

ResourceBarFrame children 0..3 are the gold/lumber/upkeep/food mouse listeners,
not the resource SimpleFontStrings/textures. The source reference is Tasyen's
[Access Frames by Child table and resource-bar description](https://www.hiveworkshop.com/pastebin/e23909d8468ff4942ccea268fbbcafd1.20598).
The guide excludes SimpleFrame String/Texture children from child enumeration and
specifically demonstrates hiding child 2 to disable the upkeep tooltip.

`WUI_CacheResourceMouse` reads only those four slots synchronously in the deferred
`WUI_CreateControls`; count checks precede each lookup, missing handles stay null.
`WUI_ParkResourceBar` hides only cached mouse-listener frames and retains the existing
visible parent/FPS offset. FPS X .360 leaves .005 clearance before
StatusGameTimeBox's left border (.400 center minus half .070 width = .365),
with Y .551; the gap prevents the final digit from being covered by the time box.
Initial native layout and origin-frame restoration reuse
this operation. No resource text visibility/alpha, child movement/reparenting,
unknown/FPS child traversal or periodic listener enforcement is performed.

This supersedes the historical blanket prohibition on ResourceBar child visibility
only for the four documented listeners. It does not prove that the previous loading
crash was caused by one specific native. Compiler and scripted regression checks
pass; startup/hover/FPS behavior still needs actual game verification.

## Multiplayer presentation contract — checkpoints 29–30

CP60: AllyHeroAbilityUI tracks native command ownership separately from custom
frame visibility (`AHUI_NativeCommandShown`). F/G keep a visible custom key badge
over the native command; that badge must never enable a second ability tooltip.
Both hover routing and tooltip refresh use this presentation state, before the
tooltip cache. Unlearned/locked previews, other heroes, actual custom command
replacements and the QWERT upgrade strip retain their own tooltip paths.
Tooltip initialization uses480 queued callbacks: one SpellData registration or
one HeroData form with its addExtra calls per callback. A single startup timer
executes one job through ExecuteFunc every0.01 sec, finishing in about4.8 sec and
destroying itself. All former Part1–6 groups are split, preserving source order.
WOS_UTB_Init_* names must remain callable as compiled ExecuteFunc string targets;
do not make them private without updating/validating the queued names. Never
merge the expensive ability registrations back into a shared execution budget.
CP67: MAIN ability ranges render through32768 instead of hiding above2500;
global-distance sentinels are rejected. Item previews retain their2500 cap.
TEST range template retains its historical cap. Frieren TW/T2 ranges resolve
the same code constants as the builder.

Local UI actions and polling must not first acquire frame handles. In addition
to frame creation, native getters can reserve IDs; see Tasyen's
[Frames and HandleId warning](https://www.hiveworkshop.com/threads/the-big-ui-frame-tutorial.335296/).
`WUI_CreateControls` synchronously caches the stock system bar, hero/minimap
buttons and each menu skin's fill/text. Local Menu, Hide UI and restoration use
these cached references. Never reintroduce runtime enumeration of lazy native
item cooldown children: their existence depends on each client's selection.
Scale the cached item wrapper instead. UI-only open/visible state may differ;
mode selection and pick/random game transitions remain synchronized.

Do not acquire ability handles in local HUD polling either. AHUI_MaxLevel reads
the generated ability-level table, with fallback 1. Stock escape-menu panels are
lazy engine frames; WUI_StyleEscMenu and its delayed retry are removed. The asset
installer supplies CustomSkin EscMenu background/button/border keys before first
open, avoiding conditional frame allocation. Skin-key/FDF reference:
[UI: Reading a FDF](https://www.hiveworkshop.com/threads/ui-reading-a-fdf.315850/).
These source corrections do not establish the exact cause of a reported desync.

The mode selector's frames/events exist for every client, with root visibility
restricted to Player(0). Reject non-host clicks before the shared transition.
Restart remains solo Player(0) only.

Stat help uses `war3mapMisc.txt` for HP/STR (35), MP/INT (10), move speed/AGI (1)
and armor/AGI (.1). The unused `agi_ms` global is not the engine move-speed gain.
Regen and attack speed descriptions use live `str_hpregen`, `int_mpregen`,
`agi_as`. Armor resistance gain is the difference of the DamageBlock armor
formula before/after one AGI, with current armor and ARMOR_EFFECTIVENESS_PERCENT;
it is not a constant percent or a description of additional hero passives.
Gold and next-round income use the local player's gold/lumber in one update.
Behavioral tests live in `test_wos_ui_multiplayer.py` and `test_wos_ui_stat_help.py`;
multiplayer acceptance and tooltip geometry still require a game run.

Selected HUD reparents the bootstrap-cached native PORTRAIT within the normal
FRAME family. Stat/portrait hover uses existing screen-coordinate conversion;
no synced enter/leave events or engine tooltip focus. Cache the tooltip layout
by stat index/line count and update text independently. Portrait click clears
focus. F2 preserves top/options/test/camera/swap controls; expanded bottom .148
is a physical coordinate converted through the configurable UI scale.

WUI_TrackedMeter caches one normal-frame meter per player/key, created only in
synchronized gameplay paths and registered with the shared minimap dock. Reuse
existing hero clocks: Kirito's healing timer, Gojo R's elapsed phase, and opt-in
GearWatchAbilityTime/GearAbilityTimeRemaining backed by KS_RemoveAbility. Starrk
presentation and Kirito polling subscribe to GearTimer03Listeners. TasBox derives
Tomioka/Starrk/Inori/Raiden values from existing synced state; selected-HUD/native
slot overlays consume these values read-only and hide empty counters. No extra
ability expiration or balance state belongs to the presentation layer.

ShopFastAction remembers the original item for a double click; a recentered tree
can change the item at the clicked node before the second event. Same original
item (including center) or same physical buy node within .4s triggers the existing
validated buy handler. Buy/sell side and per-player state remain separate.
Checkpoint 30 tests cover these contracts, live effect removal, and full F2 bounds;
compiled/package equivalence remains separate from visual/multiplayer acceptance.

Camera/minimap ownership (checkpoint 32): existing CamSetup .20s updates per-player
base/arena camera bounds through SetCameraBoundsToRectForPlayerBJ. Base viewers
hold the base center; entering arena pans once and retains free movement inside
the arena bounds. Observers without a hero follow CondArena. TeamMapPings uses
GetCameraBoundMin/Max for local projection, never full-map constants.

GearSystems registers hero/clone attached native minimapicons synchronously and
maintains a dense indexed cache. Source hero portrait/tint/fog state is identical
for originals and illusions; only native icon visibility differs locally after
alive/hidden/visible/detected checks. Use the SUMMON listener, LearnHeroSpells,
FixAura2 and Kirito E's two explicit clone paths. Removal destroys icons globally;
death hides rather than unregisters revivable heroes. No local icon allocation.
Tests: test_wos_ui_minimap.py and test_team_map_pings.py. Native minimap background
is still the existing full-map image: SetCameraBounds does not crop its pixels;
the distinction and texture native are described by
[Tasyen's minimap terrain guidance](https://www.hiveworkshop.com/threads/possible-to-zoom-into-minimap-via-trigger.320897/).


### Quick Buy FIX3 contracts (external only, 2026-10-14)

QB_DeferredCost returns omitted intrinsic/subtree charges to the nearest retained assembly; retained children remain separate purchases. QB_SubtreeStart travels with step tokens; QB_ReadyDeferred waits for retained descendant operations after reorder. Actual remaining price/UsedSlot come from unchanged CheckItemsReduceCostCraft, then QB_BuyWhole mirrors existing manual shop transaction without creating omitted intermediate items. Preview FRAME has passive icon/BTNPAS/price plate/TEXT children, an agreed-created minus, and hides when a real item occupies the slot; click validates selection owner, index/version and occupancy before D sync. Globals QB_AddSound/RemoveSound/ClearSound alias existing agreed sounds; no sound allocation. WUI_PlaceRight caches existing frame geometry in UI-only arrays/hashtable field 9100; WUI_RefreshViewport runs on existing dock timer and changes geometry only after aspect change, not gameplay. Save Keys no longer invokes QB_SaveLocal, while explicit Save Build remains. MAIN only imports BTNPAS asset; these contracts are not MAIN integration. Source, tests and limitations: external FIX3 report.

### Quick Buy FIX4 superseding persistence/input contract (external only, 2026-10-14)

QB queue and AutoBuy state never enter disk. Save Keys equals confirmed NOQB implementation; explicit Save Build writes current REC_Item[pid*28] only. REC_InitHero captures first six stock recommendations and initializes identity agreed; local file reads validate original hero id, format and allowed rawcodes, then send 4 contiguous versioned sequence chunks on REC_SYNC registered to existing QB sync trigger. Atomic REC_Apply updates all ItemsPage0_ID slots agreed and resets AutoBuy cursor. Source of AutoBuy is that current list, not a local file or stale preset. Explicit queue add preserves exclusions/order and appends distinct first-six recommendation goals up to capacity six. All local file/paint/input paths avoid handle allocation and gameplay mutations.

RMB drag uses global down/up, frame leave/enter/up and active-only existing scheduler fallback; no FRAMEEVENT_MOUSE_DOWN reliance or new timer. M contains agreed version/index after release. REC edits and QB edits use independent versions. Drag pause commands stop agreed AutoBuy/QB execution, and cancelled/invalid/released operations unlock; idle timer never samples coordinates. Shop remove siblings lie below items; HUD sibling minuses are below both native item rows. Display remaining price caches are agreed, separately from per-step debit; current inventory snapshots update open catalogue without local cost/helper execution. Actual native events/hit testing/filesystem and two-client Save Build await engine acceptance. Full report and exact diffs: external FIX4 report (RESUME pointer).

### Quick Buy FIX5 input and full-inventory contract (external only, 2026-10-14)

Supersedes FIX4 common HUD minus strip: each preview owns a separately cached SIMPLEBUTTON under WUI_GetSimpleRoot, matching native input family; no native item handler/parent changes. It is enabled+visible only with a valid free own selected-Hero slot preview, and disabled immediately on pickup/drop. Native click still validates step/version/occupancy/owner then sends D. Control has normal/pushed/disabled/highlight FDF textures, no normal focus/tooltip calls. Rec-add uses normal UI Button native state template and independent REC A validation/capacity/dedupe; no automatic disk write. QB icon click uses V and agreed QB_Inspect for tree caches, owner paint only afterward. Tooltip uses passive box/text with ENTER/LEAVE visibility; unchanged data refresh does not toggle hitboxes.

Full inventory path QB_TryFullAssembly scans current scheduled assembly steps, calculates actual remaining cost and requires UsedSlot consumption to free inventory space, then uses previous QB_BuyWhole once and confirms changed inventory before rebuild. Full/gold/ban/base/lock/owner guards remain agreed; no dropped items to fake space. Pending retained children may be folded into parent specifically for inventory exhaustion; ordinary free-slot sequential/deferred logic stays intact. No new timers/sounds/gameplay triggers or local handles. New art is eight TGA files plus expanded WOSControls FDF; native bootstrap parser, hit testing and multiplayer behavior still require engine acceptance. External FIX5 report is authoritative for current candidate, not MAIN integration.

### Quick Buy FIX6 superseding HUD/preferences/chat contract (external only, 2026-10-14)

Authoritative external candidate/report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261014-quickbuy-fix6/REPORT_QUICKBUY_FIX6.md. HUD preview .028/icon .026; per-slot SIMPLEBUTTON minus at ItemY-.0190 retains free-slot/owner/version guards. Sale uses agreed ShopClearItemTree and owner-only UI paint, with valid next inspection restoring controls. Empty tree rejects delayed WScU/WScC. Passive hints replace the space/base status label only.

SaveSystem settings append canonical F,0..3 (buy=1/sell=2); existing file/chunker and bounded settings sync unchanged. Agreed ShopFastBuy/Sell writes precede owner-only icon update, nullable before shop creation; ShopCreateFastToggles restores early flags. Queue and AutoBuy remain transient; explicit REC Save Build is unchanged. New fast-settings test covers all combinations, old/invalid records, packets and two mocked clients. Native desync testing remains pending for this extension.

AHUI_CooldownPingCommandAt/TooltipContains use cached local selection/frame geometry; RequestCooldownPing sends command slot and actual hero handle using existing QB_LocalSequence/QB_SYNC P envelope. QB_OnSync validates owner/original hero/sequence/current handle before QB_AnnounceHeroCooldown; P ignores queue version because chat is not a queue edit. Backend reads whitelist ability/name/CD agreed, throttles per sender using existing ShopClock at 10sec, displays native allied recipient1. No local ability handle/identity lookup, gameplay write or new allocations. Mouse handler plus existing AHUI .05 timer provide press/release deduplication; tooltip .4sec travel grace. ShowTextCD legacy J behaviour untouched. Native events/delivery/hit testing require game acceptance.

### Quick Buy FIX7 and user ping model contract (2026-10-15)

External FIX7 supersedes FIX6 geometry: per-slot HUD SIMPLEBUTTON minus .014x.00525 at ItemY-.0175, explicit AUTOTRACK|HIGHLIGHTONMOUSEOVER and existing native UseHighlight texture; no event replacement, extra timer or texture allocation. Catalogue and REC minus visibility is queried through existing cached frames and written only on actual transition; repeating parent visibility can disturb native child/input state. Recommended minus is inside the top-left and matches plus height. English synced ability-CD reports throttle5sec/owner via existing ShopClock; gameplay CD is untouched.

QB_PriceRemaining caches current agreed CheckItemsReduceCostCraft reads, QB_PriceQueued aggregates current remaining costs of nearest retained descendants by group/subtree keys. Only QB_StepMissing assemblies show Remaining-Queued; normal recipes retain total remaining display. Parent matching is skipped with no omissions. Price is refreshed agreed after M reorder. This changes display only; payment/exclusions/deferred readiness stay on prior validated gameplay path. Current inventory, including manually bought omitted parts, drives discounts. Native multiplayer/input pending.

MAIN and external TEST TeamMapPings now share requested five custom MDX import paths and six BLP dependencies. Model TEXS path separators normalized; native ping6 remains built-in. All scale1 throughout lifetime, no x5 or sinusoidal resize. Existing local visibility controls still use agreed identical effect/texttag allocations, no extra handles or vision. Installer install_models runs from existing team-ping assets CLI, checks manifest hashes/paths, backs up only changed resources/import table, supports idempotence. Only pings integrated into MAIN, remaining FIX7 UI external. See external FIX7 report/verification for actual MPQ and protected-function proof.

### Quick Buy FIX8 native hover and step-price contract (external, 2026-10-15)

Supersedes FIX5/7 event-owned QB hover: no item FRAMEEVENT_MOUSE_ENTER/LEAVE subscribers in Shop. QB tooltip is passive cached BACKDROP/TEXT attached through BlzFrameSetTooltip; native AUTOTRACK/HIGHLIGHTONMOUSEOVER provides art without script events. Hover-slot/index caches and cached-release branch removed. QB_BeginRightDrag handles agreed versioned B/M/U input through global down/up and existing .50 scheduler fallback on held RMB only; no new timer/polling coordinates on idle. Drag uses final X; current catalogue category gates REC reordering.

Six normal-frame HUD minus faces at ItemY-.0140, .014x.00525/level80 reuse existing wide HUD normal/hover/active/disabled TGA and share code400+i with SIMPLEBUTTON input. Both checked by owner/selected hero/free-slot/index/version and hidden/disabled on occupied slots/pickup/drop. QB_ShowPreviewRemove guards native state writes to retain hover. UI creation745 explicit handles, triggers unchanged4; no runtime allocations.

QB_DisplayCost subtracts nearest retained child remaining prices for ALL operations from initial rebuild, not only omitted-part assemblies. QB_CachePriceParents runs after structural rebuild/reorder; RefreshPrices linear, current inventory discount source remains agreed CheckItemsReduceCostCraft(...,false). QB_Cost/transaction/full-slot/omission gameplay path unchanged. Example Hirai total4500, step recipe250. Existing SaveLoad/ability chat5sec unchanged.

Latest user MDX replaces5 assets in repo + external FIX8, exact bytes/dependencies; MAIN map and sources not written this turn. Existing installer will apply updated repo assets on next authorized MAIN build. Native cursor/hit testing/model size/network not tested; external FIX8 audit/report is authoritative.

### Reset Keys / four-button row contract (external FIX9, 2026-10-15)

WUI_HotkeyDefaultKey/Name store owner-provided default metadata at RegisterHotkeyEx; never derive defaults from saved/current binding. WUI_ResetHotkeys runs after sender sync, restores6 channel mappings, clears13 custom skill/item aliases, disables sender captures and ends edit mode. Keep WUI_HotkeyUsed history: native old events cannot be unregistered and existing filter needs that history. Defaults already registered at bootstrap, so reset adds no events/handles. Only sender's client paints labels/slot badges and pauses cached pulse; other player state untouched.

Save/Reset share cached click trigger and registered WOS2SAVE prefix (1 saves, R resets); reset never calls settings writer. ss_HotkeysReset[pid] skips late file-sync H/K only, not direct key editing or other preference fields. Save Keys/end-of-match persists state through unchanged writer, no nested QB persistence. Four equal buttons width.042025 with.0035 gaps retain original span.1786 and old outer edges; centres from right.1582375/.1127125/.0671875/.0216625, y.5495, h.015/font.66. Same TextButton/Minimal skin, PlaceRight/RegisterTopControl. MAIN not integrated. External FIX9 report holds compile/MPQ proofs and native-test limits.

## Event-owned button focus — FIX10 (2026-10-15)

WUI_ReleaseClickFocus reads only the current live frame event. It calls BlzFrameSetFocus(false) only on the event player's client for click/check/uncheck/button mouse-up, after business logic and at all early returns. It never changes game state, creates handles, enables/disables controls or runs a timer. Native key handlers without a frame are ignored; F2 bindings remain unchanged. Release before RestartGame because it replaces the UI; intentional link EDITBOX focus is transferred after button cleanup. Do not call from delayed callbacks or after destroying the triggering frame/parent. Audited click call paths do not destroy frames/yield; startup edit/slider failure cleanup and meter destruction are separate paths.

WUI_RegisterPassiveFocus is an agreed-creation-only owner for BUTTONs with hover/wheel/blocking behavior and no business click handler. One shared trigger, registration cached by frame id; never also register the same button here and in a business click path. Current registered passive controls live for the map lifetime. Future destruction/recreation requires revisiting the registry/lifetime contract. SetToggleState paints only; no SetEnable(false/true) focus tricks. EDITBOX/slider/listbox events preserve their focus; opening a link explicitly transfers it last. Coverage and exclusions: FRAME_INVENTORY.md (Button focus audit), tests: test_wos_ui_focus.

## Targeted focus transfer experiment — FIX11 (2026-10-15)

FIX10 direct button SetFocus(false) was insufficient in user game test; see RESUME FIX11 for exact successes/failures. WUI_ReleaseStuckClickFocus is a separate opt-in path for these failures; ordinary cleanup stays byte-identical. One private WUI_FocusSink EDITBOX is allocated on agreed bootstrap, alpha0/offscreen/hidden, no event registrations and map-lifetime ownership. On the event owner's client only, after business logic: release clicked button, show sink, focus sink true/false, hide sink. This must never be invoked from hover/key/text/slider events or a periodic process. It never resets a user's EDITBOX. Intended link-field focus remains the final operation in its original handlers. No new timer/trigger, SetEnable workaround or native hotkey interception. Actual native keyboard recovery is experimental/unconfirmed.

## Current focus contract — FIX12 (2026-10-15)

User confirmed FIX11 sink also did not help. FIX12 explicitly authorizes direct enable false/true on the clicked interactive control. Remove sink/global/bootstrap and WUI_ReleaseStuckClickFocus entirely; do not delete real inputs. New WUI_ResetClickedButtonFocus accepts real click/check/uncheck events only, guarded by nonnull current event frame, event owner local client and post-business BlzFrameGetEnable(frame). Disabled controls stay disabled. No SetFocus or ordinary-release call inside this helper, no parent/icon substitution. No existing click path destroys/yields; future owners must release before destruction. Menu's extra direct old SetFocus removed; toolbar/QB mixed dispatch is mutually exclusive by frame/code (Emotes / REC removal only). Native key events do not toggle frames. Shop open/close/F2 key source and real Discord/music inputs preserved.

Only the central new helper owns the enabled toggle. Current caller must preserve live event context and invoke after business logic, before destruction; do not pass/capture decorative or parent handles. Reading availability is local and never feeds synchronized gameplay. Existing ordinary focus cleanup remains on separate, working button paths; genuine EDITBOX, sliders/listboxes retain their own behavior. FIX12 no longer allocates any service EDITBOX; source helper WUI_ReleaseStuckClickFocus is removed. Existing event/keyboard registrations and geometry are unchanged. Manual game acceptance pending.

### Experimental range ownership (TEST only, 2026-10-15)

MAIN enabled trigger tree has no AbilityRangePreview. Source lives under
[test_map](../../test_map/README.md); isolated FIX12 integration is applied by
prepare_ability_range_test.py. AAUniversalTooltips owns the cast-range accessor;
AllyHeroAbilityUI owns existing hover and .05 scheduling; AbilityRangePreview owns
synchronous hero/effect reconciliation and local-only rendering. WOSUI adds a
read-only covering-window registry in TEST, separate from gameplay/modal behavior.
Range2 adds one rebindable Hold badge through the existing WUI hotkey channel
registry; key down/up events are registered there. It uses existing AHUI and
tooltip timers, no new timer. Owner-local preview resolves pure tooltip tags and
current hero range formulas without writing synchronized caches. Focus cleanup
for the new badge uses FIX12; other click handlers keep their existing behavior.
Resource namespace
war3mapImported/WOSRange prevents overwriting existing hero effects; MAIN receives
only those resources and imports. See RESUME Ability Range for verified artifacts
and the engine/multiplayer acceptance boundary.

### Range3 approved MAIN boundary (2026-10-15)

User approved transferring the stable candidate into MAIN and removing Hold/V.
AbilityRangePreview is now an enabled production owner using the existing AHUI
tick and synchronous effect reconciliation; local hover only renders its ring.
No Hold control, key trigger, latch, channel 6 or saved Hold binding remains.
The six prior interface channels and genuine editboxes retain their behavior.
Old H,6 records are ignored; V is available for the player's other bindings.
Range3 UI fixes/resources now live in the project; only historical candidate
archives retain the superseded TEST-only experiment. QuickBuy resources install
through the standard MAIN asset installer. Independent Systems1 probe is retained.


## Hero progress ownership — checkpoint 38 (2026-10-16)

All active large hero time/resource bars use WUI_HeroProgress's renderer, including
Erza4 E's stack window in DecorDestroy_and_Erza_Debuff. Timers show one decimal
and `s`; percentages, time+stacks and event resources reuse that same panel.
WUI_HeroProgressText accepts custom value text from synchronized state. Use
WUI_HeroProgressCounter only for event resources which close explicitly on form
change; ordinary spell-loop counters retain the three-feed-tick freshness guard.
Zero-valued resources allocate on all clients and remain visible. Public Kyoraku
and Prison Realm meters allocate/register publicly and expire against their
actual owner, independent of the rendering client's player id. Direct refresh
cancels a previous fixed-duration clock. Dynamic captions retain dock geometry.
The obsolete WUI_TrackedMeter and disabled Kirito heal poll were removed; Kirito
retains his existing ability cooldown. SIMPLEFRAME buff/charge badges and the
Erza Second Origin text card retain their existing ownership.

Source-of-truth fixes: Frieren clone expiry cannot reset player-wide slots;
Toji W both tether states pause their clock with the target; Takeshi accumulation
and threshold dummy are independent of frame creation. TasBox's read-only live
state covers Shiki passive stacks and registered Rimuru Q2/F3 dodge windows.
Sukuna warning and summon consume one cached shared RNG location, reset each
round, with the minimap warning exactly15s before Time_Sukuna. No new UI timer
or local gameplay state was introduced. Engine rendering/pause acceptance is
outside the compile/static regression evidence.


## Match votes, invisibility and dual meters — checkpoint 39 (2026-10-16)

WOS_Start/MatchVotes.j owns synchronized unanimous vote state (WOSVOTE sync),
30-second deadlines, membership snapshots and the local open/closed vote view.
Buttons sit to the left of swap/repick. Recipients see a pulsing gold prompt and
feed notifications; dialogs open only on click and answer/timeout clears the
prompt. Kick excludes its target and requires every other active human across
both teams. Any NO, missing response or eligible departure rejects the vote.
WOSPlayerLeave centralizes idempotent leave cleanup; vote kick calls it with the
actual target, then defeats only that player. WOSTeamMembership exports existing
captain-mode-aware IsInTeam1. FF uses actual teammates, queues WOS_ForfeitTeam
once, and the existing round-end branch awards exactly10 wins to the enemy,
records one round result and executes normal cleanup/end-match logic. No chat
commands were added. Shared results never consume MV_View or local frame state.

WUI_HeroProgressDual reuses one keyed panel/dock entry. Height .0375 replaces
.025; red resource/stack row is above a purple duration row. MeterEdges real7
stores height, handle20/21/22 stores the upper back/fill/value. Dock accumulation
uses actual heights plus .005 gaps, including compaction and minimap changes.
Tsuna G1 and Shiki F supply their actual spell time and resource/stack values.
Rimuru Q2/F3 instead use normal count bars (remaining/max), driven by real buff
presence, not a fixed deadline; pause extension cannot expire the display early.
His evolution pips read AHUI_CurrentAbility instead of removed base abilities.

Selected readable unit invisibility uses Binv/BOwk or native IsUnitInvisible,
not merely possession of an ability. WOSUI sets portrait alpha135 and displays
the generated INVIS asset; selection/invis end restores255. Cup of Tea Evolved,
Toji R and Erza W use native invisibility abilities. All frame allocation remains
synchronous; selected-unit alpha/label changes are local presentation only.
BuffUnit01 now returns the applied ability's native duration at its actual rank
and target type (normal/hero). Existing callers may ignore it. Toji W consumes
that returned duration and pauses its clock with its target in both tether states;
its tooltip no longer advertises the obsolete independent5-second constant.


## Startup corrections and exclusive wheels — checkpoint40 (2026-10-16)

WUI_RegisterWheelClose registers two owner cancellation callbacks synchronously;
WUI_EnterWheel(0 ping /1 emote) invokes only the other local close callback.
It never commits a selection. Emoji_ShowMenu(false) clears EmojiHold/hover;
TMP_CancelForWheel closes the ping UI and blocks key repeats until release.
EmojiKeyHeld similarly prevents cancelled emotes reopening on repeated key-down.
Do not destroy TMP's shared mouse-tracking trigger from a local wheel callback;
its existing synchronized key-release/timeout owns destruction. These callbacks
are separate from exclusive shop/stats/music/help windows.

WUI_UnitHasInvisibility explicitly reads the granted Apiv, A03W and A0HZ abilities
(confirmed from Toji R, Erza2 W, Systems1 item callback and object base_id Apiv),
plus native buffs/query as fallback. Presence is the requested UI indicator even
when the engine query for the owner returns false. No changes to combat invis.
Discord's passive ghost uses WUI_PlaceToolbar(1,0), exactly like its real owner;
it is not registered with the screen-edge RightDock cache. Shiki F returns an
empty badge when target stacks are zero.

Kick quorum is max(2, eligible others); the target still cannot vote. A two-human
lobby may open the UI for testing but cannot pass with a single YES. Deadline
always rejects an unresolved proposal even if every actual voter answered YES
but the minimum quorum is impossible. The displayed denominator uses that quorum.
Automatic settings load/sync is silent; manual Save Settings feedback remains.

The guide's owner-local open/automatic tick no longer reads/writes a .help.txt
Preloader marker or mutates the tooltip carrier. All its frames and countdown
timer are created at shared startup; opening changes cached presentation only.
Automatic newcomer help is once per current map (ss_HelpChecked) while local
career games are zero; manual -help remains repeatable. Cross-game .help.txt
suppression is retired. This removes an unnecessary asynchronous preload path
from the reported desync trigger; static/native-mock evidence cannot prove the
specific engine desync root cause or substitute for two-client acceptance.


## Synchronized newcomer guide and catalogue kits — checkpoint41 (2026-10-16)

The guide no longer infers first visit from ss_LocalGames and no longer enters
WUI_EnterExclusiveWindow or registers as a modal. On its first shared.25 tick,
every client reads Wos2/playedonce.txt with the same local Chunk carrier used by
Save Keys, then sends authenticated WOS2GUIDE N (missing/not1) or P (marker1).
The handler uses GetTriggerPlayer, never a supplied pid. Only synchronized
ss_HelpEligible/Handled/Open/Left arrays decide whether a given player opens it.
HelpTick iterates pid0..9 on every client. Show and close update those arrays
outside GetLocalPlayer guards; owner-only branches paint cached frames and write
marker1. Manual -help is a shared chat event; button/escape close sends C. Every
opening, manual or automatic, gets the same20-second countdown, advanced by the
shared tick. All guide frames, sync trigger and timer allocate at shared startup.
No shop/stats/music callback is executed when opening the guide. Existing Save
Keys loading, settings packet and career statistics remain separate.

The marker is a Warcraft Preload script whose decoded payload is the single
string1, under CustomMapData/Wos2/playedonce.txt; it is not raw text. It is written
on first show using the existing Save Keys serializer. Missing/invalid markers
allow auto-help after a hero exists; marker1 skips it regardless of career games.
Shared file status and guide requests are UI metadata only, never combat data.
The audit found WUI_RangePreviewBlocked consumers in presentation paths; local
frame visibility itself does not prove the engine desync. Mixed-client mock
coverage validates identical guide state, not Warcraft network acceptance.

WOS_PreviewData/Init in WoS_Pick_Init own a read-only table of32 kits for11 heroes.
Eight reusable form buttons allocate in a separate WUI_OnReady callback. Local
form selection changes portrait, rawcode-derived icons, native research tooltip
text and QWERTFG labels only; it never changes PlayerFrameCurrent_ID, dummy units
or learned spells. Toji's Q variants use Q1/Q2/Q3 and restore normal labels on
base/other hero selection. Alternate portraits use existing map imports; kits
without an actual skin change retain the corresponding real portrait. Rimuru's
R/T icons come from object data (their filename suffixes are opposite), not
constructed _R/_T paths. Anime caption width expands from.112 to portrait.164
before text scaling. Erza has base plus Q/W/E/R/T/G1/G2, Rimuru three forms,
Takeshi Kit1/Kit2/Cambio; other requested kits are explicit table entries.

Votes keep the shared quorum/serial/deadline contract, with a local compact
.260-wide panel,.135-.210 high and two-column live player rows. Solo kick shows
an empty-state explanation; FF lists teammates and always has its proposal
control (disabled outside normal arena rounds). YES/NO appear only for pending
eligible voters. Tests construct the real owner and validate every control.

Quick Buy/recommended reorder computes independent grid columns/rows from RMB
start X/Y. QB_GridDragTarget is shared by preview/release, bounded to real steps;
only existing versioned M sync commands change order. Eight cached passive
pointers surround the insertion target, replacing the thin stripe; four small
RGBA TGAs are generated by tools/build_wos_drag_arrows.py. No idle mouse poll,
new drag timer or runtime frame allocation. WUI settings U gains bit4 for hidden
hero-stage text; bits1/2 keep minimap/info meaning and older0..3 packets work.


## Agreed window transitions — checkpoint42 (2026-10-16)

Shop Tab/toolbar/region/career-item, F2 and music open events dispatch
WUI_EnterExclusiveWindow(kind, viewer) before their local drawing branches.
The agreed dispatcher publishes/restores WUI_WindowPlayer around preallocated
callbacks. Callbacks update the explicit viewer's shared state on every peer;
only cached frame setters and local drag cancellation are owner-local. Guide
exclusive close clears shared Open/Left directly. Its manual close still uses
WOS2GUIDE C; automatic/manual guide opening retains the CP41 independent flow.
Escape checks local capture state and sends WUIWCLOSE -1. Only that exact payload
is accepted, using authenticated GetTriggerPlayer; it dispatches on every client.
The old WUI_RegisterExclusiveState/WUI_RequestExclusiveClose contract is removed.
Never execute this dispatcher from a GetLocalPlayer guard or local timer branch.

Baseline CP41 replay demonstrates a concrete transient shared IsOpen mismatch
when F2 is closed by the shop and asymmetric TriggerExecute calls. The first Tab
with all other windows closed does not exercise the flag-write example; the
precise Warcraft engine cause of the user's immediate disconnect remains
unconfirmed. Mock equality, source audit and compilation cannot establish it.

Quick Buy arrows must be children of QB_Panel (level92), not its shop-root
siblings at level60. Recommended arrows belong to FRAME_ShopItemList. Cached
passive children retain level60 within their own panels. Form tabs are.034 wide
(previous.041), centred at.7165 to preserve the old right edge and vertical gap.


## Picker direct presentation calls — checkpoint43 (2026-10-16)

WOS_PreviewRender/Select/Clear are defined before ReloadAfterPick and every other
caller. All four clears use direct calls; no owner-local ExecuteFunc, .evaluate
or .execute wrapper. The same ordering applies to WUI_RefreshSlotBadges and its
key helpers before capture cancellation. Optional slot UI must exist before
badge rendering. This preserves cached local rendering without dispatching new
JASS threads. Review generated JASS call graphs as well as source ordering.

The category regression executes actual OnClick with PreviewReady=true and
forbids dispatch/allocations. Saved CP42 fails at the newly introduced clear;
CP43 passes all six categories for two modeled clients. Actual hover runs the
cached WUI_ButtonHover/SetButtonSelected path only. This demonstrates the
removed asymmetric call path, not the Warcraft engine cause of a disconnect.

Form buttons now have width.030 and centre.714. Portrait ornate right edge
.695 and preview panel right edge.733 give that exact midpoint; the.002 button
edge leaves equal clearance on both sides. Native tooltip registrations for
requested one-level form abilities must agree with object-data levels.


## Direct runtime UI calls — checkpoint44 (2026-10-16)

Supersedes the runtime callback registries in checkpoints40/42. WUI_EnterWheel
is the common ping/emote cancellation path: direct cached setters and passive
flags only. It never executes an owner callback. Keep cancelled-key/repeat
latches; the old held key's release cannot commit the cancelled wheel. Ping
mouse triggers allocate once per slot at shared startup, then enable/disable
in agreed key/mouse paths. Local wheel cancellation never owns those handles.

WUI_EnterExclusiveWindow(kind, viewer) directly updates the explicit player's
shared Shop/Stats/Music/Help flags on all clients, then hides cached frames only
for viewer. WUI_RegisterWindowPart caches handles, not callbacks; F2 refreshes
the legacy panel cache because it may allocate after scoreboard bootstrap.
Career standalone tips use a passive cached list. Escape retains authenticated
WUIWCLOSE -1. WUI_CloseTopFor directly hides career/tips and requests local drag
cleanup; it does not execute registered functions.

Existing timers consume passive revisions: WUI_HudRevision invalidates AHUI
pip textures; WUI_SettingsRevision refreshes UNITSTAT; WUI_ShopCloseSerial and
WUI_ShopRenderSerial are consumed by direct QB_CheckDrag in the existing .05s
shop debounce timer. No new timer is introduced. Agreed hero assignment queues
WUI_ShopHeroRequest[pid]; QB_ApplyHeroRequests drains it before shop debounce,
purchase sync validation and AutoBuy. Gameplay never consumes local revisions.
Shop key/button handlers live beside their earlier-defined direct toggle helper.
Hero voice helpers live in WOSPickBans before the HUD caller, avoiding generated
forward-evaluate trampolines. Emoji registers its UI owner through WUI_OnReady.

Frame value/minmax hooks are removed. Every legacy statusbar/slider call uses
WUI_FrameSetValue/MinMaxValue; these directly update optional meter-fill metadata
and the native value. WUI_SetValue's legacy fallback uses the same wrapper.
Order helpers before callers: removing an explicit ExecuteFunc alone is not
enough when JassHelper synthesizes TriggerEvaluate for a forward dependency.

check_wos_ui.py now runs audit_wos_ui_dispatch.py on generated JASS. It inventories
all enabled frame sources and direct frame functions, traces27 runtime roots,
and checks explicit local frame branches transitively for dispatch/allocation.
It rejects new runtime ExecuteFunc/TriggerExecute/TriggerEvaluate, including
compiler wrappers. The complete frame-function inventory reports the remaining
shared startup allocation calls and shared gameplay ability-availability hook.
These exceptions are not local runtime UI dispatch. Career file chunk parsing
keeps its old operation-budget trigger outside frame-open paths; WCS_SetOpen
renders the startup-loaded cache rather than invoking the loader again.

Call-graph/static/interpreter checks do not simulate the engine event scheduler,
operation budget or native multiplayer. Two-client Z/K/Tab/F2/pick/resize tests
remain necessary; do not claim an engine desync reproduced or eliminated.


## Mode startup and wheel input — checkpoint45 (2026-10-16)

User reports CP44 mode selector and subsequent pick never appear, and idle mouse
movement affects ping. CP44 had inlined the initial camera slider setter before
mode UI/countdown scheduling in InitTrig_ModeDialog; optional native/UI failure
could therefore prevent both. WOS_BeginModeSelection now starts the authoritative
20s timeout and1s countdown first, idempotently, then registers the selector. The
initial camera-slider synchronization runs once in existing CamSetup periodic
work, outside the required mode-launch thread. Late selector creation hides it
if a mode is already selected. Actual native fault/operation-budget cause is
unconfirmed; a production-function regression injects a failing optional frame
native and verifies that Normal fallback still reaches Map_Start.

Supersedes CP44 ping preallocation. No EVENT_PLAYER_MOUSE_MOVE registration at
startup: TMP_TrackMouse creates its dedicated subscription only in agreed Z-down
processing, before any local-player branch. First valid world sample, key-up,
Escape or K activation destroys and nulls it on every client. Local right-click/
close/toolbar wheel switch sends authenticated WOSPMOUSE with a shared epoch;
stale cancellation cannot destroy a newer subscription. K blocks cancelled-Z
repeat tracking until release. Emotes retain local-only pixel/button polling,
strictly while open, with no network mouse subscription. Common WUI_EnterWheel
still owns direct mutual visual cancellation. No handle mutation inside local
presentation. Existing hero MouseOn/Off and mouse-down owner are unchanged.

The compiled audit explicitly records the agreed TMP_OnKey -> TMP_TrackMouse
CreateTrigger path, while continuing to forbid local allocation/dispatch across
all frame roots AND strict runtime roots. This narrow exception implements the
requested lifecycle rather than relaxing frame-render safety. Tests verify zero
startup MOVE registrations, destruction/recreation, stale epochs, matching
owner/other-client lifecycles, both wheel switch orders and optional-UI failure.


## Input activation, bounded stats and charge style — checkpoint46 (2026-10-16)

WUI_ShopRmbTrigger[pid] is a shared cached trigger handle. QB_CreateUI attaches
it to the existing search timer expiration, disables it, and restores agreed
Shop_Active. WUI_SetShopRmb is called only in agreed transitions; no local branch
may enable/disable it. The engine invokes QB_OnRmbTick; it paints/sends input for
the corresponding local client only. ShopSearchDebounceTick retains passive
revision consumption, not RMB sampling. Ordinary hero MouseOn/Off stays separate.

Stats creation has a finite shared row builder. Input registration precedes
row allocation; WOS_STATS_Ready gates opening and starts update only after10 rows.
Every client allocates identical rows, one per .01s tick; the builder destroys
its timer on completion. No creation path is reached from F2/click runtime.

Hero meter metadata key8 optionally holds value font scale (default.66); key7
is still panel height. WUI_HeroProgressCharge repins font geometry on style change,
updates native/fill textures and restores default style on reuse. Tsuna's charge
presentation does not change gameplay damage percentage or overcharge timing.

Top-strip hidden living vitals remain unread. Public death status permits0 HP
and cached MP to remain visible for dead hidden units; do not query their hidden
resource/type values. Surrender phase is not an eligibility condition: normal
and test base votes use the existing queued round owner, not local scoring.
Right-edge vote status marks are passive and survive outcome for4 seconds.

## Stats startup and vote settings — checkpoint47 (2026-10-16)

CP46 row-only staging did not restore F2 in the user test. CP47 moves all
remaining construction out of the ready callback into a finite shared .01s
builder. First tick binds F2/Stats, before shell or headers; subsequent ticks
build shell, headers, actions, F3, F4,10 rows and final window handlers. Ready
then permits opening. All gameplay/input callbacks remain direct and allocate
nothing. The regression uses actual Scoreboard builders and WOSUI key helpers;
its native stubs cannot prove the specific engine failure or game acceptance.

Hide UI ghost registers the same final width and offset as the real control;
viewport refresh no longer restores its older wider placeholder geometry.
Learn pip click uses WUI_ResetClickedButtonFocus on the actual event control.
Its five cached SPRITEs use Pick/wos_IconShine1.mdx from Player Pick captain
controls; no hover/click allocation. Kenjaku Curse count keeps its KenjakuF_ID
meter key but overrides cached icon with BTNHero_Kenjaku_F2; Prison Realm's F2
key remains separate. Game Info page1 adds -help. Mode title/hint/button scales
are1.45/1.05/1.35.

MatchVotes.j exposes WOS_FF_ENABLED=true at the top. False hides the FF toolbar
button/glow, closes its panel, rejects proposals/answers/forfeit bridge and
cancels active FF ballots on the existing agreed tick. Kick remains available.
Change this shared setting identically on all clients, never in a local block.
MV_COOLDOWN=30s starts after vote completion; MV_RetryLeft is per kick lobby / FF
team. Both UI enable state and shared proposal handler enforce it. The existing
.24s tick decrements it; open panel title shows READY IN Ns. The30s ballot
response deadline remains separate. No timer or input handler was added.

## Top actions, vote Escape and guide forms — checkpoint49 (2026-10-16)

WUI_GetTopActionOwner returns a cached passive FRAME created in shared bootstrap
under WUI_Root and registered as ONE top control. Repick/swap buttons, swap
menus/offers/test toggle and FF/kick controls/window use it. Hide UI hides the
ancestor; per-player child enabled/visible flags stay intact, so restoring UI
cannot show another player's buttons. MV_Render also gates on WUI_TopShown.
No native SIMPLEFRAME is reparented. No owner allocation from click/hover.

WUI_WindowPart[11] caches the vote panel (10 remains Career). MV_View is exposed
in the central declarations purely for local presentation; shared vote decisions
do not read it. Existing authenticated WUIWCLOSE/-1 Escape handler closes the
local vote view/panel directly, in addition to the existing MV_Escape key handler.
Only the triggering player's local view changes; vote serial/choices stay intact.
MV_Click, picker repick/swap and swap menu clicks use the existing event-scoped
ResetClickedButtonFocus; disabled controls stay disabled. No new key subscription.

Guide timeout is40s for automatic and manual help. Ability learning returns its
old passive BACKDROP learn-glow.tga; the vote captain SPRITEs remain unchanged.
Compact scoreboard shifts hero/name left, widens name. MVP text/hover shift with
it to preserve the gutter; expanded layout is unchanged.

Preview adds Natsu F Kit (R/T only) and Starrk T Kit. Starrk reuses Q/W rawcodes:
only the local preview substitutes TQ/TW art and GetFormGuide's readonly alt-form2
text. GetFormGuide reads existing SpellData fields and formats strings; it does
not allocate TooltipBuilder/struct/native handles or mutate live unit form.

Tsuna T stores real chargePct from the same DisplayCharge curve as UI. Lv35
partial overcharge1.5..4s now scales damage continuously100..125%; damage is
multiplied once on fire; below100 the legacy rounded damage is retained.
check2 keeps legacy availability/cooldown thresholds;
max-colour uses actual charge, not rounded check2. During fire the keyed panel
shows elapsed / configured duration seconds, retaining remaining-time fill and
normal interruption cleanup. No new timer/input. The previous125-only damage
jump is removed; ranges/targeting and full-charge effect threshold stay unchanged.

- CP55 message boundary: never lay out ORIGIN_FRAME_UNIT_MSG with generic frame
  setters. CP53/54 introduced that path; both local crash dumps contain a
  corrupted object's vtable and its matching .180/.290 size field. Pick/ban
  announcements belong to WUI_CreateFeed's own TEXT frames, with X relative to
  the real screen edge. Mock FRAME geometry cannot certify engine-owned types.
  Test hero creation/selection remains the existing shared transaction.

- CP56 damage attribution: DmgSys calls DamageStatsRecordHitFrom with the actual
  source unit after final modifiers. Taken uses numeric source/owner/type keys
  and saved integer metadata; Dealt stays aggregated. Never build strings,
  retain unit handles or allocate per-hit handles. Direct HP hazards are observed
  only by RoundSpells.EnvironmentHpLoss after the unchanged setter; optional
  DamageStats preserves the original gameplay path when disabled.
- CP56 input: WUI_AcceptKeyDown is a condition on slot-key and Esc-sync triggers.
  Both edges must be registered: key-up clears the per-trigger/player/key latch.
  Do not move the gate after ForceUIKey or BlzSendSyncData. Its elapsed clock has
  no periodic callback. WUI_UseSlot's local recursion guard never selects gameplay.
- CP56 source cells have hover events only (GLUEBUTTON), no click cleanup or
  engine tooltip binding; manual tooltips are outside the panel rows. Background
  alpha belongs to a passive child, not the parent/text. heroicon owns visibility
  of game-time/train-kill boxes; WOSUI exposes only cached details visibility.

- CP57 viewport boundary: DS_LayoutViewport reanchors the compact panel/toggle
  before the closed-view return, on the existing .50 timer. WUI_LayoutFeed uses
  its existing .25 timer. Both cache the screen edge and perform frame setters
  only after a change; neither creates handles or feeds gameplay decisions.
- WUI_InfoSourceIcon owns shared Game Info/Damage Stats environment artwork.
  Keep actual ability/item artwork in the generated DamageStats catalogue.
- Saber G charging starts from base entry and LvlUpCheck through the same
  idempotent AlterSaberW_Start; the unit flag is cleared in loop cleanup. Its
  autoattack proc is magic NextDmg route0 and numeric source A02F, not W2/A05F.
