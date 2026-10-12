# Progress

## Checkpoint 22b — round 2 corrections: source compiled, MAIN NOT rebuilt (2026-10-10, Claude)

Compile OK, UI regressions 171/171 (cp22 file: 20 tests). MAIN build was refused:
World Editor open. When it is closed (without saving): push triggers + build
-NoLaunch exactly as in checkpoint 22 (adds glyph-allycolor.tga, 32 cp22 TGAs).

- Mode selector: live countdown "Normal in Ns" (`WOS_ModeCountdownTick`, Starts.j).
- HUD: "INVENTORY" label fits (scale also shrinks the box: size/scale).
- Top-right panel compacted (.540-.600); Hide UI / Shop Key row .5495; Menu /
  Allies / Log = one dropdown under it (`WUI_SetMenuDrop`: native surface 9090,
  rows step .023, no own row edges, ornate rails outside, dividers), Menu icon
  gets an active glow while open.
- Portrait voice: `WOS_PlayHeroVoice` compares with the hero `*_ID` constants
  (the picker replaces a picked hero's Hero_IDx slot with 12 - root cause).
- Hotkeys reworked: custom-bound skills are drawn by AHUI (stock letter gone,
  new key shown on the icon) with a click target; key/mouse use
  `ForceUIKey(stock letter)` for skills, `BlzFrameClick` for items. Edit mode:
  big key label on every slot ("-" if none), pulsing outline on the slot being
  edited, chat prompts; success message 1 s; conflicts listed (stock keys,
  order/shop keys, ping/emote keys, other slots). The stock key itself cannot
  be disabled by any native (no hotkey field in common.j).
- Emote wheel: pages of 15 + arrows only if needed, hover glow instead of
  resizing (the "moving wheel"), VIP check = chat access level / nickname / Test
  Mode (`CustomChat_GetPlayerAccessLevel`). Chat emoji palette: 5x3 pages,
  access level falls back to the nickname VIP lists; Captain Draft now shows
  the chat emoji buttons with the hero.
- Shop: item-tree prices inside icons on plates (centre item too); close
  button .016 at the window corner; top panel no longer reaches the shop.
- FPS/Ping/APM: stock line found by text ("FPS") and re-anchored at
  (.178, .543) - VERIFY (frame name unknown; scan stops after 40 s).
- Ally-colour minimap button (stock index 2) kept, skinned (glyph-allycolor),
  docked under the camera slider (slider now .031-.118).

## Checkpoint 22 — screenshot round 3: source compiled, NOT built into MAIN (2026-10-10, Claude)

MAIN INTEGRATED 2026-10-10 12:18 (World Editor closed): trigger push 109 J,
1 WTG entry updated (backup backups/trigger-sync/2026-10-10_121723_780952);
build -NoLaunch BUILD OK, MAIN war3map.j updated (previous script backup
backups/main-map-build/20261010-121807-119), packed copy _build/WoS_Test.w3x;
all 31 cp22 TGAs present/byte-identical/imported; verify_wos_ui: source
identity + traversal + FDF PASS. Game not launched (user opens it in the editor).

Status: all items below are in the sources; full vJASS compile (JassHelper +
pjass, `.vscode/compile-vjass.ps1`) = COMPILE OK; UI regressions 170/170 OK
(18 new in `tools/test_wos_ui_checkpoint22.py`). MAIN build was NOT run because
World Editor was open (the build script refuses). No in-game verification yet.

Done (sources + assets):
- Pick: new gold franchise logos `pick-logo-*.tga` (from the user's PNGs in
  `Desktop/Новая папка (13)`, 512x128, 4:1, rebuilt after the user replaced them);
  gold bevel `icon-frame.tga` over every hero/player icon (`WUI_IconFrame`);
  round timer in its own framed plate top-left (`WOS_PickTimerPlate`, Captain
  Draft widens it to the title row); teams pushed to the window edges
  (x .120+.046i / .536+.046i) with a BANS row between them.
- Bans: library `WOSPickBans` (top of WoS_Pick_Init.j): 8 allocated slots,
  `WOS_PickBanLayout(count, showNames)`, `WOS_PickBanSet(i, hero, proposer)`,
  flash fx, tooltip. Normal / Player Pick Mode: every locked ban (roulette +
  captain guaranteed) goes to the next slot with the proposer's name below.
  Captain Draft: same slots, no names; its old floating BANS panel stays hidden
  and `CaptainDraftBanHighlight[i]` points at the shared fx.
- Player Pick Mode: `WOS_LayoutCaptainVote` rewritten — compact windows,
  rows aligned (vote 2x5; draft: 8 free players 2x4 + TEAM 1 / TEAM 2 rows with
  the captain first, crown glyph), vote counts as corner badges, gold icon
  frames; removed the extra SetPoint on Frame_Cap1_13/14 that made names drift.
- Shop: catalogue icons .046 with the price inside, centred above the bottom
  edge on a translucent plate sized to the digits (`ShopPlacePrice`,
  `price-plate.tga`; also the 6 inventory slots); close button (code 408) in the
  top rail, same state change as the shop key.
- HUD: whole portrait + level plate is one click/hover target
  (`UNITSTAT_PortraitHit`); learn strip spans pips -> icon bottom; items .033 and
  scaled by the stock .031 icon (`WUI_PlaceNativeItem`, top-left icon shift
  .004*scale — VERIFY in game); "I N V E N T O R Y" title with flourishes.
- Voice toggle (speaker, stats column right side): ON = portrait click plays
  the own hero's pick lines in turn, local (`WOS_PlayHeroVoice` /
  `WOS_PlayNextHeroVoice` extracted from OnClick and shared with the picker).
- Hotkeys (`WOSUI.j`): keyboard toggle under the voice toggle. Edit mode shows
  gold outlines over the 7 skills + 6 items, a hint plate, key badges; the
  skill row is drawn by AllyHeroAbilityUI while editing. Click a slot, press a
  key (Esc cancel, Backspace remove). Bound key (synced key event) ->
  `BlzFrameClick` of that native button for its owner. Reserved: QWERTFG,
  A S H M P (orders), B I (shop). Not persisted between games.
- Pick stage showed only E/R/T: `hook BlzHideOriginFrames` -> while the stock
  command card is hidden, learned skills are drawn by AHUI too.
- F2: fill = full window under flush ornate rails (both sizes), always opaque,
  opacity button hidden, gold-framed expand/close glyphs; big version: DAMAGE
  DEALT and DAMAGE TAKEN are single columns (total + coloured phys/mag line
  below); repick/swap parked off-screen while the big F2 is open.
- Wheels: `wheel-base`/`wheel-ring` without concentric rings, crossed swords
  for Attack, larger ping glyphs (emote wheel uses `wheel-ring`).
- Top-right: gold glyphs menu/stats/link/music; Discord toolbar icon =
  user's `discord icon.png` (circle-masked `discord.tga`).
- Menu/Allies/Log skins larger + opaque disabled fill; stock F10 menu / end-game
  window re-skinned by name (`WUI_StyleEscMenu`: background tile + ornate rails,
  button fills + gold hairline; unknown names skipped) — VERIFY in game.
- Restart button (top-left, `WUI_CreateRestart`): stock `RestartGame(false)`;
  created only when Player 1 is the only human player (synced check
  `WUI_RestartAllowed`), click re-checks. Switch: `WUI_SHOW_RESTART` in WOSUI.j.
- Tools: Pillow is not installed here; new `tools/png_tga.py` (PNG decode,
  resize, TGA) and `tools/raster.py` (SDF rasterizer) power
  `tools/build_wos_ui_textures_cp22.py`. test_cp21 now imports names from the
  installer (its builder needs Pillow).

Next: close World Editor (without saving), run "WOS: BUILD + RUN MAIN MAP"
(installs 31 new TGAs), then push sources to WTG/WCT as before. Check in game:
item icon centring/scale and item cooldown, escape-menu skin, hotkey edit mode
+ BlzFrameClick casting/targeting, ban row with names, Player Pick windows,
shop price plates, F2 big layout.

Checkpoint 21 and older sections below are history where they conflict.

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

## 2026-10-08 — session start

- Read both supplied requests; saved REQUEST.md and WORKFLOW.md locally.
- Baseline has uncommitted prior Crocodile/ally UI/ping/order repair changes.
  Preserve them; do not stage unrelated changes in checkpoint commits.
- MAIN native folder: `C:/Users/Gear/Documents/Warcraft III/Maps/WoS/Anime_WOS2_0.32.w3x`.
- Existing frame owners found across WOS_Start, Systems, Heroes. No project AGENTS.md exists.
- Key risk: many windows are children of ConsoleUIBackdrop; do not hide their parent before migration.
- Audit and implementation underway. No new redesign implementation or runtime verification yet.
- Next action: complete frame inventory and independent root, then Z interaction checkpoint.

## Checkpoint 1 — audit / foundation / Z interaction

- FRAME_INVENTORY.md generated by tools/audit_wos_ui.py: 45 production frame owners.
- WOSUI.j added: service leaderboard stays visible with hidden title/backdrop;
  independent normal FRAME root, shared compact coordinates and frame helpers.
- 13 sources migrated at normal FRAME creation sites; SIMPLEFRAME sources retain
  native parents. Backup: backups/ui-redesign/20261008-182408/root-migration.
- TeamMapPings.j no longer shows sector labels; center hover remains. Valid Z
  release commits once; click, Escape/right-click and no-choice paths retained.
- Built-in imagegen produced dark material, copied unchanged to
  assets/UI/WOS/source/graphite.png. Warcraft conversion/state builder produced
  panel/border/button/hover/pressed/selected/disabled/hp/mp/bar-back TGA resources.
- tools/install_wos_ui_assets.py reuses preserving importer; MAIN build installs
  shared textures. Existing ping imports preserved.
- `python tools/check_wos_ui.py`: full production tree compiles (146397 pjass lines).
- `python -m unittest discover -s tools -p test_team_map_pings.py`: 21 tests PASS.
- No new MAIN save yet (World Editor running). No visual/multiplayer verification.
- Console hiding and native HUD migration still pending; no global hide call added.
- Next exact action: implement scrollable TestMode help panel in Starts + WOSUI helper,
  then selected-unit HUD/native commands and top-panel visible-only HP/MP.

## Checkpoint 2 — native HUD / selected unit / test panel / top vitals

- Starts.j permanent instructions (test commands, elemental reference, F2/F3/F4,
  shop tutorial) replaced by WOSUI's scrollable, collapsible TestMode-only help.
- WOSUI caches native named command/item/system frames synchronously. Native
  inventory parent moves to native command SIMPLEFRAME parent; native unit-detail
  panel goes to a hidden SIMPLEFRAME. Normal UI is never made a SIMPLEFRAME child.
- Minimap retains 0.140 size. Console background/portrait/resources/hero bar/
  minimap buttons/dead zone hidden after layout at 0.20s. No global origin hide.
- Seven real origin slots [8,9,10,11,7,5,6] form QWERTFG row. Orders/Learn drawer
  keeps native slots 0..4 reachable; ordinary units retain all twelve slots.
- HeroUnitPanelStats existing library now draws compact selected icon/level,
  attack/resistance/attributes, HP/MP and regen above native ability row. Combat
  helpers retained; Avul/base exception retained. Gold uses actual gold and lumber.
- Stock damage text getter is InfoPanelIconValue, context 0, with GetAttack fallback;
  actual in-game damage formatting/availability needs verification.
- AllyHeroAbilityUI mouse hover coordinates updated to the seven-slot HUD row.
- Existing heroicon gains visible-only HP/MP, hidden enemy early return before
  type/death/vitals reads. Hide heroes now hides portrait subtree, preserving score.
- Compact native Menu/Allies/Log drawer implemented. F10/F11/F12 remain engine buttons.
- Full compile PASS (146578 pjass lines); ally ability tests 7 PASS; ping tests 21 PASS.
- In-game native items/learn cards/hierarchy/menu display NOT verified. Toolbar,
  shop/pick restyling and miscellaneous frames remain incomplete. MAIN not written.
- Next action: add production tests for native layout and hidden enemy reads, then
  wire toolbar to existing handlers and apply shared style to existing windows.

## Checkpoint 3 — toolbar / production regression tests

- Existing shop keyboard handler extracted into WOS_ToggleShop; toolbar uses its
  vJASS evaluate trampoline. Existing page, observer catalogue, readiness and
  debounce rules retained; no second shop/controller added.
- Emote toolbar calls EmojiStandalone's real menu owner. Its K key-up uses the
  same Emoji_ToggleMenu. Removed obsolete K key-down block touching null FRAME_Chat0.
- Existing Discord/chat emoji/ping controls relocated to compact 3x2 toolbar.
  Existing chat feed mute is now a small checked/unchecked control. Two alpha
  checkbox TGA resources added; shared importer now registers 12 textures.
- tools/test_wos_ui.py: 9 tests PASS, running actual command layout, hidden enemy
  guards, shop state/observer/debounce and preserving/idempotent imports.
- Existing ping 21, ally ability UI 7, trigger order 3, workflow 8 tests PASS.
- Full production compile PASS (146697 pjass lines). No game verification yet.
- MAIN save pending: World Editor still running.
- Next exact action: graphite/thin-gold skin on existing pick/shop windows, compact
  pick layout including Captain Draft positions; inspect aliases still under Console.

## Checkpoint 4 — existing pick/shop compact layouts and hierarchy repair

- WUI_Window and WUI_StyleButton use real graphite/alpha gold resources. Existing
  pick/shop/legacy captain windows lose EscMenuBackdrop stone frames.
- WOS_LayoutHeroPick relocates existing 30 grid buttons, all six logo categories,
  five actions, preview icon/stats/seven ability tooltips and ten player slots.
  Repick/swap and captions shrink; handlers/category data remain unchanged.
- CaptainDraft root fixed (variable alias was missed in initial migration). Ban
  strip moved beneath preview; all phase text now stays in header instead of
  overlapping buttons. Claim/vote/pick algorithms unchanged.
- WOS_LayoutShop keeps all seven sections, 35 catalogue slots, recipe relations,
  selected item, inventory/buy/sell, search/pages and Auto-buy; new compact geometry.
- UI_CAREER/MusicPlayer aliases now use independent normal root. Systems2 native
  SIMPLEFRAME counter uses native ConsoleUI. Native status/buff bar retained and
  moved outside hidden detail panel; visible only for readable selection.
- Service leaderboard now associates all players via CreateLeaderboardBJ and
  zero-sizes the native board root. This follows the primary Simpleframes example.
- Full compile PASS (146894 pjass lines); HUD tests 9 PASS before final layout (no
  handler changes since). Game display/drag/modal behavior remains UNVERIFIED.
- MAIN not written; World Editor currently open.
- Next exact action: shared skins for scoreboard/career/music/emote panels, then
  full regression checks and ask to close editor before saving/building MAIN.

## Checkpoint 5 — secondary surfaces / final pre-save checks

- Career/music/emote/chat-emoji/player-stat panels share graphite/thin gold. Career
  and music text buttons use common button states. Emote grid reduced to .042/.048
  while preserving effect IDs, VIP access, cooldowns and sync. Chat palette moved
  above the right toolbar. Scoreboard retains its existing opacity switch; root is
  transparent FRAME with gold border, opaque fill/tooltip use shared graphite.
- Camera slider moved to X=.150 beside minimap, icon at (.150,.140); native camera
  handler and range unchanged. Player statistics panel moved inside 4:3 bounds.
- Full production compile PASS (146899 pjass lines); all 48 regression tests PASS.
- Native MAIN audit: all 108 existing WCT sources match last extraction hashes; no
  unseen saved map edits detected. Sync check prepares 109 triggers, 17 source
  changes + one WOSUI entry; validates category traversal before any write.
- tools/verify_wos_ui.py prepared: derives identities directly from native WTG
  names/categories, checks every WCT source against its real project file, all 28
  UI/ping imports/assets, optional archive byte equality. Extraction name list
  ready at _build/ui-redesign/archive-names.json. Not run against old MAIN yet.
- Required user response pending: close World Editor WITHOUT saving. Guard still
  reports editor running. No native files overwritten.
- Next action on closure: guarded sync push, full MAIN -NoLaunch build, extract
  archive and verify all source identities/order/assets/script bytes, update docs.
- Remaining implementation: hero-specific bar/counter skins and shared primitive
  integration (45 owners), any remaining secondary windows; final top/menu/style
  polish and all runtime/multiplayer/resolution scenarios. Do not mark full task done.

## Checkpoint 6 — shared dynamic hero meters and unit buff timers

- User requested a common system that adds hero meters and moves them dynamically,
  including unit buffs. WOSUI now owns stable-key registration, owner-specific
  packing and smooth gap closure at .10s; settled coordinates stop updating.
- 45 active six-frame meter sites in 28 hero/system files attached without changing
  existing counters, min/max values, timing or visibility. An independent source
  fingerprint confirmed all non-presentation statements unchanged. Commented
  Milim/Mahoraga prototypes remain untouched; distinct special windows still pending.
- WOSHeroMeter.add/update/show constructor available for future owners. Existing
  owners retain their real frame references and game state. Recreated panels reuse
  their key and hide old visuals instead of growing the registry.
- MyFrame/MyFrameBuff unit icons + timer labels, Kenjaku barriers and Tsuna beam
  chips join the dynamic buff strip. Native SIMPLEFRAMEs use cached ConsoleUI;
  normal labels retain independent root and follow numeric coordinates. Charge
  badges remain on real native command slots, now .012 with shared graphite skin.
- Added real gold meter texture: 13 shared UI resources + 16 ping resources;
  extraction list regenerated for 33 archive entries. No MAIN write yet.
- Full production compile PASS: 146811 pjass lines / 107 enabled sources. HUD/dock
  production tests 13 PASS; pings 21, ally ability UI 7, trigger order 3, workflow 8
  PASS (52 total). Game/native interaction/multiplayer remain unverified.
- Four recovery files updated; prior commits 654b679/e64d873/bff70cb recorded.
  Editor guard still TRUE; earlier close-without-saving question remains pending.
- Next independent action: style/register Erza Second Origin two-icon meter;
  preserve Inori weapon selection and Kyoraku help controls while compacting them.
  On confirmed editor closure: guarded push/build/archive verification as checkpoint 5.

## Checkpoint 7 — exceptional hero panels

- Erza Second Origin's real two-icon meter uses the shared dock (46 meter sites).
  Both icons, original numeric range/values and switch rules retained; thin fill
  fits between icons. Selection sprite retained with compact scale.
- Inori weapon selection: graphite .360x.248 modal, same four controls and confirm
  gating. Real ability descriptions now native scrollable TEXTAREA; existing
  selector follows real weapon buttons after layout changes.
- Kyoraku public help panel and toggle moved into 4:3 bounds, real scroll and
  per-player collapse rules retained. Only local xxx/yyy UI coordinate assignments
  changed outside frame calls; their usage is limited to control coordinates.
- Full production compile PASS: 146833 pjass lines. Non-presentation fingerprints
  match for Inori/Erza; Kyoraku differs only in those two presentation coordinates.
  No new gameplay behavior or asset added; prior 52 tests remain last test evidence.
- Dynamic dock checkpoint committed as 3d92d32. All four recovery files current.
  MAIN still pending editor closure; no native changes or runtime verification.
- Next exact independent action: compact existing top score/train/timer styling,
  respecting RearrangeTeamUI positioning and its match-slot persistence.

## Checkpoint 8 — compact top scoreboard and controls

- Existing heroicon root moved to Y=.560, icons .028 and original .030 slot step
  retained; RearrangeTeamUI match slots and saved team ordering remain compatible.
- Thin graphite/gold central score surface, smaller scores at ±.027 and .018 train
  icon; real train kills/game clock/round timer continue using original counters.
- Existing Hide heroes / Shop key controls moved to Y=.590 with smaller .012
  checkboxes and separated labels. Damage summary moved to compact HUD row.
  Camera/options/summary use transparent FRAME roots instead of alpha-zero stone
  backdrops; existing manual hero-name tooltips share graphite surface.
- Full compile PASS: 146831 pjass lines. Production HUD/dock/privacy tests 13 PASS.
  No runtime evidence; MAIN save remains pending closed-editor response.
- Checkpoint 7 committed as a856a90. Four recovery files updated again.
- Next independent action: remaining mode/vote/tooltip skins from FRAME_INVENTORY;
  create explicit owner status list to distinguish implementation from runtime.

## Checkpoint 9 — ability overlay hierarchy, captain votes and owner coverage

- AllyHeroAbilityUI overlays previously anchored normal FRAME roots to native
  SIMPLEFRAME command buttons. All 168 actual overlays now use absolute HUD slot
  coordinates, independent normal root and matching compact text. Tooltip root no
  longer anchors hidden ConsoleUIBackdrop. Enemy cooldown privacy unchanged.
- Shared graphite/gold surfaces for ability tooltips, hero preview and draft bans.
  WOS_LayoutCaptainVote compacts the existing ten candidates, captain controls,
  team slots, names, instructions and real timers in both phases. No new duplicate
  controls, allocation or vote/team algorithms.
- Inventory regenerated with shared frame creation helpers included. OWNER_STATUS
  records all 45 active production owners and explicit pending game checks. Legacy
  Systems2 AllyCD initializer is commented and has no active external ShowAllyCD
  calls; retained instead of resurrecting a duplicate cooldown controller.
- Full production compile PASS: 146914 pjass lines / 107 enabled sources. All 53
  tests PASS: HUD/docks 13, pings 21, ally UI 8 (new real overlay placement test),
  WTG/WCT order 3, workflow 8. git diff --check PASS.
- Read-only native sync check PASS: 109 WTG triggers prepared, 46 source differences
  plus new WOSUI id 0x03000071, category traversal and identities preserved. Native
  MAIN remains untouched; World Editor process still running, required closure
  reply pending. Project CRLF normalization produces no semantic code differences.
- Checkpoint 8 committed as 66f2c6b. Recovery files updated; INTEGRATION.md contains
  exact guarded push/build/archive steps and the generated-log cleanup boundary.
- Next action: once user confirms closure and guard is false, integrate and build
  full MAIN, verify native WTG/WCT identities and all 29 resource imports, extract
  and compare all 33 archive entries. Actual game/native interactions remain pending.

## Checkpoint 10 — real MAIN integration and packed archive verification

- User confirmed editor closed. Process guard FALSE; guarded push wrote 109 native
  triggers (46 updated + new WOSUI) and refreshed manifest/settings/dependencies.
  Backup: backups/trigger-sync/2026-10-08_200834_844462/map-before-push.
- MAIN build PASS with original map initialization, 106 enabled triggers + header,
  3 disabled triggers, no unresolved required dependencies. Actual compiled main
  initializes WOSUI before GearSystems2/AllyHeroAbilityUI/selected HUD and original
  InitCustomTriggers/RunInitializationTriggers. pjass PASS: 147876 total lines.
- Installed 13 shared UI textures; 16 existing ping assets already matched. Asset
  backup: backups/ui-redesign/assets/20261008-200844-860447. Native compiled-script
  backup: backups/main-map-build/20261008-200916-304. Native scenario now contains
  updated WTG/WCT/imports/assets/compiled script; no object-data/gameplay edits here.
- Packed full MAIN: _build/WoS_Test.w3x, 6360 files. SHA256:
  a05ba35dffdc08205d81b6dbdf75b2bde7e21ec5115941eb449b7344c1e00ad6.
  Independent native verification PASS: all 109 WCT identities/order and 29 imports.
  All 33 extracted archive entries byte-match native MAIN; verification report at
  _build/ui-redesign/integration-verification.json; full compile log saved beside it.
- Fixed build guard ordering: open editor now blocks before MAIN source/import
  mutations. Mocked real PowerShell process check rejects with exit 1 and preserves
  hashes of WTG/WCT/imp/script/Main.vj. Existing late guard retained for compile race.
- Archive verifier initially exposed extraction skipping slash-separated nested
  paths. Extractor now normalizes SFmpq paths and rejects explicitly requested
  missing entries. Real 33-entry extraction PASS; deliberate missing-entry check
  correctly fails. No map rebuild needed for this extraction-only fix.
- Prior 53 tests PASS; trigger sync 3 + workflow 8 rerun after metadata integration
  also PASS. git diff --check PASS after restoring only five originally clean,
  owned generated log/backup files; actual map source and metadata retained.
- Checkpoint 9 committed as f89ef4d. All recovery/owner/asset docs updated again.
  No pending editor-closure question. Full game UI/runtime remains UNVERIFIED.
- Next action: test _build/WoS_Test.w3x in Warcraft using OWNER_STATUS runtime
  matrix; use real screenshots/interaction evidence to correct any native frame,
  hover/drag/learn/menu/selection/resolution issues. Do not redo completed migration
  or MAIN import work. Multiplayer/fog testing also remains required.

## Checkpoint 11 — load-crash correction (native integration complete)

- User reported an immediate critical error after checkpoint 10. Crash.txt at
  Documents/Warcraft III/Errors/2026-10-08 20.35.28 ba6e19b4 records Warcraft
  3.0.1.24342 ACCESS_VIOLATION read 0x18; War3Log reaches Played at 20:35:28.
  Engine stack does not identify a JASS native, so exact causality is unproven.
- Found WUI_Init creating leaderboard/root, reading and hiding native frames in
  loading-time initialization; four dependent owners also created UI immediately.
  Moved shared root/controls and all six UI owners to WUI_OnReady bootstrap at
  0.10s game time. Music TOC now loads through the same ready queue. Selected HUD
  retains a second 0.20s delay before native reparenting/hiding (0.30s total).
- Removed visibility calls on native buff label and leaderboard title strings;
  clear their text instead. Added child-count checks to button skins/Console
  deadzone, null/parent guards to native layout, reused cached deadzone in pick.
- Production compile PASS: 147003 pjass lines (compile-only empty main).
  HUD/startup/dock tests PASS: 17, including four new real-body startup regressions.
- computer-use skill was read/announced. mcp__node_repl__js initialization failed
  with "failed to write kernel assets: Системе не удается найти указанный путь.
  (os error 3)"; reset + retry also failed. Direct visual automation unavailable
  in this turn. Do not work around SDK via custom input/screenshot automation.
- At 20:49 editor guard FALSE. Guarded push PASS: 109 sources, 9 scripts updated,
  0 inserted. Backup: backups/trigger-sync/2026-10-08_205047_996178/map-before-push.
  Real MAIN build PASS: 147965 pjass lines; compiled script backup:
  backups/main-map-build/20261008-205131-201. All 57 regressions PASS; ping harness
  now verifies no frame allocation until its ready callback executes.
- Packed _build/WoS_Test.w3x: 6360 files; SHA256
  1a1d7c326f2852e2f2c7849b668e42ec46ca29109bc5427b4fd1f7a8ac48cafd.
  Independent native WTG/WCT identity/category and 29 imports PASS; 33 extracted
  archive entries byte-match native MAIN. Evidence: crash-fix-full-main-pjass.txt,
  crash-fix-integration-verification.json and archive/ under _build/ui-redesign.
  Saved compile evidence and restored ONLY five generated files clean at turn start.
- Launched actual packed MAIN at 20:52:30, PID 31052. It responds, with no new
  crash report as of 20:54. War3Log ends at 20:52:32 catalogue scanning, no custom
  map load/Played line, so this does NOT establish map-load success. Saved launch
  arguments/hash/status at _build/ui-redesign/crash-fix-runtime.json.
- Async user question is pending: map loaded, menu/login, or another critical.
  Next: obtain real screen state; if menu, examine launch flags (current -editor
  differs from World Editor's working command); if crash, inspect the new report.
  Direct visual/input/fog/resolution verification remains pending.

## Checkpoint 12 - native console, bars, pick/shop correction (2026-10-08)

- User screenshots establish checkpoint 11 game entry, but show stock stone chrome,
  missing fills, green icons, blank test help and uncompacted pick. Shop also reported.
- WOSUI: detach actual command/detail/system/tooltip containers BEFORE hiding 2+
  ConsoleTopBar/ConsoleBottomBar, recache slots and retry lazy containers. Native
  inventory/buffs/minimap/system menu preserved. Twelve-button cards below MP.
- Normal BACKDROP percentage fills replace model STATUSBAR for selected/top vitals
  and new hero meters. Fixed left anchors/clamping/caching. Corrected attribute
  str/agi/int textures and enlarged HUD fonts.
- Test help: five TEXT pages, wheel/arrows and independent collapse action; no
  lazy stock TEXTAREA. Modal registry suppresses help over pick/shop/mode selector.
- Pick/shop large builds dispatch components and layout in fresh synchronous JASS
  threads. Full button/slider templates, root bounds, readable prices, recipe
  scroll regions/controls. Existing catalogue/purchase/search/autobuy owners kept.
- Starts: styled four-mode frame selector; host-only once-only common mode action,
  all flags, music, map start, captain vote and 20s normal timeout preserved.
- Console installer: blank six textures + 2+ overlays + inventory cover; empty
  classic clock model. Only ten owned CustomSkin keys changed; imports and other
  settings/translations preserved/backed up. Verifier includes skin/model.
- All 68 production regression tests PASS. After final ordinary-card position fix,
  all 28 relevant HUD/startup/native/layout/packaging tests PASS again.
- Real MAIN compile PASS: 148290 pjass lines, 106 enabled + header, 3 disabled.
  Guarded pushes updated 6 then 1 sources, NO trigger insertions. All 109 native
  identities/category traversal, 30 resources, 35 extracted archive comparisons PASS.
- Latest packed MAIN _build/WoS_Test_2.w3x. SHA256:
  55d9c13daa3a58bc382eae57041b73ec73ee12302cf0064599ebaf485ed9add0.
- Backups: trigger-sync/2026-10-08_213527_135120/map-before-push;
  trigger-sync/2026-10-08_214136_001032/map-before-push;
  main-map-build/20261008-214208-098;
  ui-redesign/console/20261008-213544-474564 (all under backups/).
- Launched first slot 21:37:30 WITHOUT -editor, PID 24004. Responding/no new crash
  report, but log stops at catalogue scanning: NO confirmed custom-map opening or
  rendering. It locks first slot, final build used second slot. Direct window
  helper still unavailable (kernel assets OS error 3); no alternative input/helper.
- Evidence: _build/ui-redesign/visual-fix-{integration-verification.json,
  full-main-pjass.txt,runtime.json,war3log.txt}, archive/.
- Next exact action: user async reply (map/menu/error), then actual latest map
  visual/input verification. Do not claim game success from compile/process survival.

- New user screenshots received before checkpoint commit: console hidden, HP/MP
  fill and attribute icons render, game entry confirmed by images. Remaining style
  issues: 4:3-only mode dim square, small mismatched shop buttons, recipe tree/
  background/relations, vertical shop tabs consume left space, score backdrop,
  menu overlaps stats/music/link openers. User requests horizontal top shop menu,
  catalogue left, drawn recipe inheritance, closer ornate supplied concept.
- Next checkpoint 13 owns these changes. This supersedes pending map/menu question.

## Checkpoint 13 source completion - 2026-10-08

- Removed the 4:3-only mode shade and duplicate modal registration. Mode panel and
  all four buttons use the generated ornament; transitions remain host-only.
- Shop seven categories use code-owned skinned buttons, hover/selected states and
  one horizontal top row. Catalogue shifts left, icons return to .040, prices and
  item descriptions are enlarged. Search/paging/autobuy/inventory handlers kept.
- Selected item is the center tree node; actual upgrades above/components below.
  Eighteen passive edge segments update for actual visible recipes/scroll pages.
  Removed old-coordinate sprites and the gold placeholder masking the real icon.
- Built-in imagegen created alpha ornate-frame.png; eight independently anchored
  crops preserve corner proportions. Applied to mode, shop, hero pick and HUD.
  Opaque HUD surface uses a SIMPLEFRAME FDF beneath native commands/items; normal
  FRAME ornament centers are transparent, including minimap/inventory.
- Removed flat score box. Menu/career stats/link/music at .653/.691/.729/.767,
  common Y .548. Found stock BlzHideOriginFrames(false) restoration in hero pick;
  WUI_RestoreCompactNative now reapplies compact native chrome after returning.
- User steering: seven own QWERTFG slots always render, passive dark unlearned
  icons/empty slots with hotkeys. Learned own commands stay native and clickable;
  empty slot's old native occupant/learn button moves offscreen. Enemy cooldown
  reads remain guarded, own cooldowns rendered by engine.
- 75 regression tests PASS; full-source compile-only PASS, 147611 total lines.
  Alpha checked: generated source RGBA 1254x1254, transparent center; all eight
  crops RGBA. Native integration pending at this checkpoint boundary.

- Integration completed: guarded push updated ten sources, inserted zero WTG
  entries; source backup 2026-10-08_221446_959411. MAIN build PASS, 148573 pjass
  lines, 106 enabled + header, 3 disabled. Packed 6371 files into WoS_Test.w3x.
  All 109 source identities/traversal, 40 resources and 45 packed byte checks PASS.
  SHA256 faf77ee5c87e9715934677290d22616fa0093961d5e905781735e501a288efb8.
  Script backup backups/main-map-build/20261008-221535-456. Launched configured
  -editor/-loadfile test of actual MAIN at 22:18:08, PID 23100. Log ends in catalogue
  scanning 22:18:11, process responding; NO verified custom-map opening yet.
  Visual verification pending; native automation unavailable. One-off migration removed.

- Final own-hidden-ability fallback: hidden/disabled learned abilities also retain
  their DISBTN instead of exposing the native learn/utility occupant. All 76 tests
  PASS; affected ally/own/privacy tests (11) PASS after final test cleanup.
  Final MAIN build: 148574 pjass lines, latest _build/WoS_Test_2.w3x (first slot
  held by PID 23100), SHA256
  54d6a726d04a3b62997046b6f27dde145bca61d0eb66d2f6941012f476b83d15.
  109 identities/traversal, 40 resources and 45 latest packed byte checks PASS.
  Final source backup 2026-10-08_222121_122659, compiled script backup
  20261008-222153-351. The final hidden-ability change has not been launched;
  earlier first-slot game log still ends in catalogue scanning. Do not overwrite
  an occupied slot or claim visual success from a responding process.

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


## Checkpoint 14b — guarded MAIN integration and runtime boundary

- Source commit 4313fe3, preserving 72687b8 ornate checkpoint. Guard returned False.
- Push: 109 sources, 6 updated, zero WTG insertions. Backup
  backups/trigger-sync/2026-10-09_005611_586281/map-before-push.
- Full MAIN build PASS (148657 pjass lines); compiled script backup
  backups/main-map-build/20261009-005655-754. FDF/TOC backup
  backups/ui-redesign/frames/20261009-005624-240979.
- Latest map _build/WoS_Test.w3x, SHA256
  b69e7dccb27980bcae1fa6c8e06c6697acd41344f25f654ecdd71beb99d2ddcb.
- 109 native WTG/WCT identities/traversal, 40 resources/45 packed bytes PASS.
- Launched configured full MAIN at 00:58:18 +03:00, PID 8820 responds. Log so far
  ends at catalogue scanning 00:58:20; NO verified custom-map opening/UI input.
  GUI helper unavailable (kernel-assets OS error 3; recovery attempts exhausted).
  Asked user whether mode/world clicks work; answer pending, not approval.
- 81 tests PASS. Next: inspect fresh log and actual user game input/presentation,
  do not mark UI blocks DONE based on compilation or process survival.


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
Next: guard World Editor, push sources, full real MAIN build, archive validation,
launch configured game and inspect fresh logs/crash reports. Input/appearance
remain unverified unless actual independent runtime evidence is obtained.

USER SHUTDOWN REQUIREMENT: shutdown /s /t 60 ONLY as the final action after full
task completion, all files saved, build/check processes finished and no errors.
No extra confirmation. Do NOT run/schedule shutdown while input/visual acceptance
is still unresolved or tools prevent determining completion.


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

## Checkpoint 20b

- Map folder install: all checkpoint-20 TGA/FDF/TOC files and war3map.imp were copied into the map folder (green missing-texture boxes came from textures never reaching the map).
- `WUI_SHOW_ORDERS` (WOSUI.j globals) hides the Orders drawer button; set it to true to bring it back.
- Menu/Allies/Log: native SIMPLEFRAME skins (`WOSNativeMenuSkin` in WOSControls.fdf) dress the F10/F11/F12 buttons in the gold/fill style while the drawer is open.
- Level pips are drawn for all 7 slots (F and G appear once the ability has a level); Alt/learn overlays stay on the 5 learnable slots.
- Pick screen stat card moved below its text (level 0) so the hero stats are visible again.

## Checkpoint 21

- Ability row: every hero skill is previewed from level 1 (dimmed until learned). Pip count = the skill's real level count from object data (T shows 1, not 5). Green next pip and the learn glow appear only when a skill point can really be spent; a grey "Lv N" under the pips shows the hero level that unlocks the next level; hovering the pips lists all unlock levels. Learning = click the pip strip (Alt+click removed). Table: `tools/build_ability_level_table.py`.
- Pick screen: stats come from the dummy hero or, if it is missing, from an object-data table (`tools/build_pick_stat_table.py`) - fixes zeros and "everyone ranged". Drawn STR/AGI/INT medallions (pick + HUD), gold underline with charcoal glow under the primary attribute (replaces *), melee sword / ranged bow icon, difficulty plaque set into the portrait.
- HUD: compact tooltips (ability column 0.236 wide, stat tooltip sized to its text), portrait click pans the clicking player's camera, closed gold frame around hero passive meters; all hero overlays (meters, buffs, Kyoraku bankai, Kenjaku board, main_frame children) step aside while the shop is open and return when it closes.
- Shop: tabs use an FDF button whose hover is drawn by the engine (no network hover events, no cursor stutter); search row restyled (inset field + gold edge, gold X); item tree shows up to 5 items per row, shrinking icons as rows fill, prices above the top row / below the bottom row / right of the centre item; wider gold slider.
- Swap / Repick: docked at the left end of the team strip with disabled plates when unavailable; SWAP opens an ally menu (icon + name + close); the chosen ally gets a gold-pulsing Accept / Decline window; TestMode toggle switches between the old instant replace and the real flow.
- Menu drawer: Allies (and Menu/Log) skins turn grey when the stock button is disabled. Discord invite field restyled.
- Team pings: graphite/gold wheel textures. Emotes: hold-key wheel like the pings (release or click to send; toolbar click opens it centred). Ping and emote hotkeys can be rebound in game by clicking their key badge.

## Checkpoint 23

- Shop: smaller/tighter catalogue (icons .038, names under items, no hover tooltip); wider item tree (up to 7 per row, 14 slots) and centred description; BUY/SELL textures; small close X in the corner; shop overlaps the right frame. Autobuy left the shop: HUD toggle "AUTO ON/OFF" left of the INVENTORY title.
- HUD: portrait hover uses an engine tooltip (no synced mouse events -> no cursor stutter); portrait click plays the next hero line AND pans the camera; voice toggle lower, ON by default, voice cooldown = sound length - 0.5 s. Ability cooldown overlay 0.91 of the icon. New phys/mag damage-bonus widgets (icon-physdmg / icon-magdmg) right of the resist rows with a vertical divider. Gold tooltip narrower. Tooltips use the dedicated `WOSTooltipBox` (tooltip-edge.tga).
- Top right: History (career, glyph-history) and a new Stats button (opens F2). F2 has F3 (clear my numbers) and F4 (load full-game numbers) buttons with key badges. Hide UI / Shop Key smaller; third dropdown "Game Info" (elements, destructible decor, round-end train damage) under the Menu dropdown. TEST COMMANDS block sits right under the top-right block and moves down when the dropdown is open. Hotkey changing is switched off (`WUI_ENABLE_HOTKEYS = false`).
- Music player: camera-style sliders, inner frames fixed, shop close X; link field edge fixed. Discord: field above its button, icon turns into an X while open.
- Pick: pick/ban messages go to a top-left feed (`WUI_Feed`, 6 lines, fades) in every mode instead of chat. When the remaining ban proposals fit into the free ban slots they are all banned at once (no roulette). Ban slots use the full `ban-cover.tga`. Team rows tighter (step .040); more than 6 bans go into two rows so the bans never touch players 5/6. Pick page logos from folder 16. Repick glyph redrawn.
- Player Pick Mode: vote digit inside the icon corner, captain shine 0.80, horizontal divider between team rows, crowns on the captain icon corners.
- Captain Draft: styled "WHO PICKS FIRST?" frame window (TEAM 1 / TEAM 2, countdown, live votes) replaces the modal dialog that blocked the game menu; status plate 15% narrower; claim phase has no gold model - hovering a claimable hero shows an enlarged copy (engine tooltip), claiming plays a local click sound.
- Menu dropdown re-shows the stock Menu/Allies/Log buttons even while the pick hides origin frames (players can leave the lobby).
- Placeholder Game Info icons (replace at the same paths): UI\WOS\info-fire, info-water, info-lightning, info-firewater, info-firelightning, info-lightningwater, info-barrel, info-barrel-explosive, info-vending, info-car, info-train, info-hydrant, info-gold, info-building, info-roundend (.tga, assets/UI/WOS).
- Tests: tools/test_wos_ui_checkpoint23.py; full run 178 checks.

## Checkpoint 24

- Shop: window reaches down to just above the minimap. Item tree: 6 per row, 2 rows of upgrades + 2 rows of components (12 each, frames 36-41/43-60, SHOP_TREE_PAGE = 12); more pages via slider/wheel. Centre item .030, single rows .030, fuller rows .028. Catalogue grid moved up; styled page switch (glyph-prev/next on a graphite plate) under the grid, above the search. SELL button shows an iron trash can.
- HUD: resist | divider | damage bonus moved left; values use one decimal below 100 and whole numbers from 100 ("100%"), no "+" sign; hover shows the exact percent. New clearer bonus icons (weapon + green up arrow). STR/AGI/INT icons replaced with the author's gold art (folder 18).
- Stock tooltips (items, Menu/Allies/Log, troop colours...) are pinned every 0.02 s (local) to the compact column (.329-.565 at y .150); the engine used to re-anchor and stretch them. Our tooltips centre their text.
- Game Info: the Hide UI/Shop Key container (a FRAME .180 wide) covered the Game Info button outside Captain Draft; it now covers only its two buttons. Game Info has 5 pages x 4 rows with text centred on its icon.
- History: the career open button was positioned through the zoomed career-window transform (off screen); it now sits on the top bar.
- Discord field gets the caret on open (like the music link).
- F2 / F3 / F4 are rebindable hotkeys (WUI hotkey channels 2-4, key-up, badge on the Stats / clear / load buttons; letters, digits or F1-F9). F3/F4 buttons spaced apart.
- Captain Draft: status plate as wide as the hero grid and centred on it; BAN/PICK log plate in the window's top-left corner (CaptainDraft_Log); team rows moved inside the inner frame (.124 / .556, step .040).

## Checkpoint 24b

- Hero meters: all dock above the minimap and close gaps when one hides (Milim converted). STATUSBARs without a model never drew a fill; a purple BACKDROP fill (meter-fill.tga) follows their value via `hook BlzFrameSetValue / BlzFrameSetMinMaxValue`.
- Public meters (Kyoraku bankai, Kenjaku prison realm) hang right under Train kills: one centred, two side by side meeting under its middle.
- Right column (WUI_LayoutRightColumn): TEST COMMANDS, Game Info, then registered hero panels (`WUI_RegisterColumnPanel` / `WUI_ColumnShow`, collapsible header). Whatever does not fit above the HUD goes to a second column on the left; Game Info goes left whenever the test commands are open. Kyoraku's bankai stages are such a panel.
- /fps /ping: ResourceBarFrame stays visible (needed for the line) but is parked off screen with its children; the FPS line gets its own absolute spot.
- Stock tooltip box widened to .30 (text no longer spills). Stat tooltips sit just above the HUD top edge with centred text. "Invul" (red) replaces "Block".
- Ability row: the stock button is used for F/G only when it really sits in that command-card cell (Gojo F, Inori G were empty). Native cooldown sprite centred and smaller.
- Ping wheel 30% smaller and semi-transparent.
- Hover glow exactly the button size (WOSTextButtonTemplate highlight SetAllPoints; new WOSIconButtonTemplate replaces ScoreScreenTabButtonTemplate in WOS_Start).
- F2 badge moved off the Stats icon.
- Test shared control without advanced control (no stock "Team resources" board); stock hero bar/buttons kept hidden.
- Team strip: leavers keep their greyed hero icon with the ban cross (no leave1/leave2 art).
- Pick: page arrows hidden (there is never a second page); confirm / random / ban spread over the grid with new art (pick-*.tga: green check on red box, gold die, red ban; -off variants). Primary-attribute underline removed (HUD + pick). Timer / log plates and the BANS plate no longer touch the window frame.
- Shop: tree shows two levels each way (upgrades of upgrades, components of components; 6 per row, first level pages by 6). Fast buy / fast sell toggles under BUY / SELL: double click buys (list or tree) or sells (inventory).

## Checkpoint 25

- WUI_Border no longer draws border.tga (a 1px line stretched over big windows looked like a blurry yellow band); windows = fill + ornate rails.
- HUD 0.020 longer (WUI_COMMAND_X .347, WUI_ITEM_X .664, chassis right .818, toolbar .738): wider stats column with attack speed (gauntlet), move speed (boot) and attack range rows (icons from folder 16), tooltips with base/bonus; values never wrap (three-digit bonuses, "+40" attack bonus). Portrait lower, level plate under it, voice toggle above it, lock overlay (Icon_Paused) while the unit is paused. Darker HP/MP fills (hp-dark / mp-dark). Visible enemies are inspectable (portrait, stats, team strip icon).
- Stock tooltip: one bottom-right anchor + fixed width, no re-pinning timer (no jump).
- Hero meters: the time sits on the bar (offsets of scaled frames divided by the scale). Native cooldown sprite 0.76 of the icon.
- /fps: ResourceBarFrame shrunk to a dot at WUI_FPS_X/Y, resource texts and mouse listeners parked off screen.
- Right column: TEST COMMANDS block = Game Info height; side by side only while the Menu dropdown is open; opening the shop closes dropdown / Game Info / TEST COMMANDS, F2 closes the dropdown.
- Scoreboard compact view: separate K and D columns. F2 badge snug to the Stats icon; top tooltips open downwards.
- Shop: names under tree items; long descriptions scroll (wheel over the text or the slider).
- Music player: controls on graphite plates with gold hairlines; plain slider tracks (slider-clean-h/v, also the shop sliders).
- Pick confirm: gold square + green check (grey when disabled).
- Inori weapon window: descriptions were in a stock TextArea that never rendered - now TEXT frames; compact window, hover enlarges the icon, a click picks it, styled close X. Kyoraku bankai text larger.

## Checkpoint 25b

- Pick (not Captain Draft): hero grid as tall as the preview column (WOS_PickGridLayout); Captain Draft restores the short grid under its status plate.
- Shop tree: the selected (centre) item has its name too; component rows moved down for it.
- F2 compact view: KILLS / DEATHS headers; SVP = best player of the team without the MVP (silver label, same slot as MVP).
- HUD another 0.012 longer (command .359, items .676, chassis .830): left stat column .058 wide (three-digit + three-digit bonuses), one divider, right column = phys / mag damage bonus, attack speed, move speed, range.
- Timed GearSystems2 buffs dock in one row under the stock buff bar (stock bar moved up to .128), 0.018 icons, closing up when one ends.
- Engine hover glow on Menu / Stats / Link / Music; Menu / Allies / Log rows get a blue hover (local mouse test, no network events).
- /fps: per Tasyen the line hangs from the bar's TOPRIGHT at (-0.44, -0.03); the bar is moved accordingly, resource texts hidden, mouse listeners parked.
- Game Info: 4 pages with the map's own BTNElem_* / BTNDECOR_* icons; gold, buildings, Frozen Heart / Hungry Sin and the decor train removed.

## Checkpoint 25c

- Crash after loading: the resource bar work (SimpleFontString visibility, re-anchoring its unnamed children) is reverted; ResourceBarFrame is simply hidden again and the FPS docking timer is gone. /fps /ping stay hidden.

## Checkpoint 26

Round of 18 user notes (buff rows, test replace meters, F2 deaths header, tooltips, pick/draft layouts, shop tree frame, ban cross, minimal top buttons). Compile clean; 186 regression checks pass. In-game confirmation pending.

## Checkpoint 28 — Resource tooltips, 2026-10-11

`WOSUI.j` now caches the four documented ResourceBar mouse listeners in deferred
bootstrap and hides them during native layout/restore. Resource text is preserved;
FPS/Ping/APM source X is .360, leaving .005 clearance before the time box's left
border; Y remains .551. The .360 adjustment awaits a build with World Editor closed.
Four behavioral regressions added to `tools/test_wos_ui.py`.
JassHelper/pjass: 107 enabled production sources PASS. UI runner: 190 checks,
0 errors/failures, one pre-existing skip. MAIN check/save and build without launch
completed; extracted archive script matches MAIN's compiled script and contains
the listener fix and the previous X .365. User confirmed the unwanted tooltip is
gone; full in-game listener/pick-restoration acceptance remains pending. See `RESUME.md`.

## Checkpoint 29 — Multiplayer UI and stat help, 2026-10-11

Cache local presentation handles at bootstrap; remove lazy item cooldown child
enumeration. Host alone sees the mode selector; remove Test Mode activation chat.
Attribute tooltips now explain per-point benefits; gold shows green +lumber income,
attack tooltip shows damage only. FPS X .360 is integrated. Compile PASS; 198
regression checks, 0 errors/failures, one skip. MAIN sources saved and map rebuilt
without launching. Two-client engine acceptance is pending; details in `RESUME.md`.

## Checkpoint 30 — Follow-up controls and counters, 2026-10-11

MAIN integrated: static menu CustomSkin (no lazy frame allocation), metadata-only
ability-level reads, native portrait and focus-independent hover. Shop/tree labels
enlarged, inventory names added, tree double click preserves the original item.
Avul attachment removed; stock/Gear buffs x1.5. Tas counters for Tomioka/Starrk/
Inori/Raiden; shared meters for Starrk stacks, Kirito heal and Gojo domain R use
existing gameplay clocks. F2 preserves other controls and ends at minimap edge;
camera stays visible. Normal Mode chat removed; named elemental reactions.
Compile/build PASS; 212 checks, 0 errors/failures, one skip. 164 packed entries
verified against MAIN/assets, including menu keys and empty Avul art. Runtime
multiplayer/visual acceptance pending; implementation and backups in `RESUME.md`.

## Checkpoint 32 — Camera and minimap, 2026-10-11

MAIN rebuilt without launch: base units hold base-center camera, arena units use
arena bounds, no-hero observers follow round state. Hero/illusion/Kirito clone
portraits share native minimapicon presentation with fog/detection checks and
synchronized allocation/cleanup. Ping labels follow current bounds. Compile and
218 regressions PASS; final targeted camera/icon and ping checks PASS; 164 packed
entries match MAIN/assets. Native visual/multiplayer acceptance remains pending,
including alignment of the existing full-map background. Details in RESUME.md.
