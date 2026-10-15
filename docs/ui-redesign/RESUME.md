# Resume UI redesign

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

- Buffs: stock buff bar just above the chassis edge (.477, .107); GearSystems2 timed buffs in the same row starting above the portrait (.180 + col*.022, ten per row, timer text over the icon bottom).
- Replace hero / repick / test re-create: `WUI_ReleaseHeroMeters(pid)` hides the old hero's passive meters above the minimap.
- F2 compact: KILLS/DEATHS headers .046 wide. Top-right toolbar tooltips (Stats, hotkey badge, Game Info, Restart) open down-left (`WUI_TooltipBelowLeft`).
- Hide UI / Shop Key row is visible from the mode selector on (no longer hidden during the pick).
- Shop tree: graded step (.060 / .052 / .044 / .038 by row size), names as wide as the step; tree + description share one ornate frame with a horizontal divider.
- Portrait tooltip: taller box, more space above the name. Pip strip tooltip: "Click here to upgrade this ability (skill points: N)".
- Player Pick Mode: vote digit covers the whole icon; captain icons lower with the crown centred above; "guaranteed ban" note; captain glow scale .72; team-stage crowns centred above captains.
- Captain Draft: ban log, timer and hero name plates all at y .5245, .022 high; hero portrait raised; first-pick vote can be changed until the countdown ends.
- Ban cross (ban-cover.tga): no red wash, strokes half as thick. Top-right text buttons use `WUI_SetButtonMinimal` (soft divider lines, no gems).

## Checkpoint 26b

- Game Info decor: BTNDECOR_Barrel / BTNDECOR_Hydrant icons; vending machine applies Lightning, hydrant applies Water.
- Top actions panel: `WUI_MinimalEdge` (same soft divider lines as the text buttons) instead of the ornate border.
- `WUI_MinimapStub` (war3mapMap.blp) covers the minimap slot while BlzHideOriginFrames(true) is active (pick).
- Pip-strip tooltip title centred.

## Checkpoint 26c

- TEST COMMANDS / Game Info panels, their page buttons, hero column panels (Kyoraku BANKAI STAGES) and toggles: `WUI_MinimalEdge` / `WUI_SetButtonMinimal`.
- Hero meters: WUI_HeroMeter stores its parts; `hook BlzFrameSetAbsPoint` marks a meter dirty when hero code re-anchors a part with absolute points; `WUI_RefreshDocks` re-pins the parts to the panel (`WUI_RepinMeter`) and re-places the panel (all heroes).
- Shop: inner panels, tabs, close, search field and page buttons use the minimal edge (shop window keeps ornate). Tree .236-.483 (top level with inventory), description .155-.236 (4 lines, scroll). Rows .455/.4075/centre .359 (SHOP_TREE_CENTER_Y)/.3105/.262; rails lie between rows, level-1 rails get a stem to the centre item.
- Pip tooltip: own width (.200), height fitted to the text (min .042), title centred on the whole box.
- Object data: new unit h02N "Dummy Train Thomas" exported from the map.

## Checkpoint 26d

- Gojo T pips: the learnable hero skill is GojoT2 (A01X), now the first T entry in AllyHeroAbilityUI (the only base-ability mismatch vs Systems1).
- Leaver in the team strip: opaque DISBTN hero + ban cross, no HP/MP bars, for every viewer; the small Back2 icon is no longer shown (Leave.j).
- Native command cooldown model: WUI_ICON_SIZE * 0.67 (was 0.76).
- Portrait voice: last selected unit from synced (de)selection events; a selected hero with voice lines speaks, else the own hero.
- Game Info: train, train wreck and time limit marked [PURE] (pure damage).

## Checkpoint 26e

- CreateStatusHeroUI (team strip, Hide UI / Shop Key, Link, Music, Discord) runs from WUI_OnReady (library heroicon initializer); the call from initmapstart is a no-op. Chat-emoji / emoji-mute toolbar buttons and Link stay visible from startup.
- glyph-repick(-off).tga: cursor removed (cp23 builder derives the -off copy).
- Restart tooltip opens to the right again (top-left control).
- Cooldown: `tools/build_wos_cooldown_model.py` scales the stock UI-Cooldown-Indicator (assets/source, MDX 1800 from CASC) by 0.88 around its centre; installed as UI/Feedback/Cooldown/UI-Cooldown-Indicator.mdx (FRAME_RESOURCES). WUI_ResizeCooldown only centres (scale 1).

## Checkpoint 26f

- REVERTED the 26e early CreateStatusHeroUI (WUI_OnReady): in game Link / Music / Discord / Hide UI did not appear and the round timer stopped (the early call did not complete; root cause not found statically). CreateStatusHeroUI is again called only from initmapstart (0.1 s after the mode is chosen). Emoji / Link visibility changes of 26e kept.
- Restart tooltip: "Restart map."

## Checkpoint 26g

- Placeholder controls (WUI_CreateGhostControls in the bootstrap): passive Link / Music / Discord icons and Hide UI / Shop Key plates appear at UI startup; WUI_ReleaseGhost hides them when the real controls exist (LMP open/link shown, FRAME_LINK2 placed, Shop Key created). The real functionality keeps its old timing (CreateStatusHeroUI from initmapstart).

## Checkpoint 26h

- Cooldown model override REVERTED at the user's request (no visible size change in game): imported UI-Cooldown-Indicator removed from the map and war3map.imp (backup backups/ui-redesign/cooldown-revert/), installer entry, VS Code task, tool and stock source deleted. WUI_RefreshCooldownSizes back to WUI_ICON_SIZE * 0.76 (commands) and the wrapper scale (items).

## Checkpoint 27

- Hotkeys: WUI_HotkeyFilter (trigger condition) drops keys that were this channel's hotkey before a rebind (key events can not be unregistered); new channel WUI_HOTKEY_SHOP (TAB default) with a badge on the toolbar shop icon; Shop Key button and the Tab/I/B logic in ButtonPressed removed.
- Top row: Game Info (left) | Hide UI (right), .0875 wide each; while hidden the Hide UI button waits top-right; WUI_CollapseAllPanels folds menu / TEST COMMANDS / Game Info / hero columns on hide.
- TEST COMMANDS: elements page removed (Game Info has it), 2 pages switched only by < / >; wheel scrolls lines inside the page (estimated wrap WUI_TEST_CHARS), styled WOSVerticalSlider.
- Gojo: GojoG_ID -> GojoF_ID (and Gojo_F_ManaRestore*), Six Eyes on AHUI F slot, BlzSetAbilityPosX/Y(GojoF_ID, 1) at init (button X is not editable in object-data JSON); G shows GojoRCancel only while Gojo has it.
- Inori T (non-transform) tooltip: "Transforms to upgrade basic abilities" removed (code + object data, saved).
- Team strip: "FIRST TO <MaxRounds> WINS" under the round clock.
- Ping wheel opens on cooldown and shows the countdown in its centre (no chat line).
- Erza Second Origin: split bar (red phys share left / blue mag share right via ErzaDebuffs.SetSplit), bigger icons, pick gold glow (wos_IconShine1) on the dominating icon, texts centred.
- WUI_GoldFrame now draws the quiet divider-line edge everywhere (no corner gems).

## Checkpoint 27b

- Hotkeys: Tab in the capture table; key cap size follows the key name (WUI_SizeHotkeyBadge: 1 / 2 / 3+ chars); shop badge lower-right of the cart.
- Pick: normal/test hero panel back to .365/.330, name .5145 x .020 inside the top edge, attribute .5055 / attack .5095; Captain Draft re-lays its own row in CaptainDraft_PositionStatus.
- Gojo pick: variant F only (b = 4), F hover = GojoF_ID, F icon = BTNHero_Gojo_G.
- Ping wheel: idle sectors alpha 120, hovered 255.
- Saving (local4 only, bot export untouched): career buffer parsed in chunks via TriggerEvaluate (ss_ParseTrigger, operation limit); new settings file WOS2_local4set_<keyA>_<keyB>.txt (hotkeys H/K, camera C, last track M) written at match end after the career, read 1.5 s after start and synced once (WOS2SET) so all clients register the restored keys; camera slider starts from CameraSetup.
- Career files are keyed by the normalized nickname: the three existing files belong to "thundergear", "worldedit" (WE test) and one other name, each with 1 game - same nickname accumulates.

## Checkpoint 27c

- Stutter fix: removed `hook BlzFrameSetAbsPoint` (JassHelper compiles every hook into a TriggerEvaluate per call; 140 call sites, many per tick). Hero meters are re-pinned once per second in WUI_RefreshDocks instead. Do not hook frequently called natives.
- "R" box on every freshly learned R: WUI_RefreshCooldownSizes no longer resizes command-button children (it centred/enlarged the stock hotkey label); item cooldowns unchanged.
- Save files are still read once (career guarded by ss_LocalLoadFinished, settings by one timer).

## Checkpoint 27d - performance pass

- Game Info click: WOSTopOptions container shrunk to the Hide UI button (it covered Game Info).
- Scoreboard: text / texture / alpha caches (WOS_STATS_Text/Tex/Alpha), layout recomputed only when WOS_STATS_LayoutSignature changes, legacy UI hidden only if visible.
- AllyHeroAbilityUI: 0.05 s hover / 0.15 s refresh; tooltip rebuilt only on key change (slot, ability, level, skill points, pips) or every ~0.5 s; HideTooltip returns early when hidden.
- WOSUI: WUI_Show (visibility only on change) used by hero indicator, native buffs, HUD stats, swap ghosts; WUI_ShowNativeAbilitySlot caches its state (re-place on change or every ~2 s, cache reset in WUI_LayoutCommands); item cooldown children re-laid only when their count changes; meter re-pin is points-only once per second.
- TasBox: decide wanted boxes first, then toggle only changed ones; text only on change.
- Chat emoji feed: empty feed rendered once; ping toolbar text/alpha only on change; music seek slider / equalizer only while the player window is open; BarCheck demo timer removed.

## Checkpoint 27e

- Frame drops after clicking TEST COMMANDS: a programmatic slider SetValue fires a synced value-changed event; the handler rendered and set the value again (endless loop). Now the handler ignores unchanged offsets and the slider is set only when its value really changes (also for the shop description scroll).
- Rule from the user: re-layout frames only on actions (a frame shown / hidden), never on a timer. Dock re-pins meters only when a panel appears or moves; buff size only on placement.
- Team strip: the small Back2 icon is hidden for good (slot alpha re-showed it); an unseen enemy keeps a normal icon, only its HP/MP bars are hidden.
- Resource bar visible again for /fps /ping: only the bar itself is moved (TOPRIGHT = FPS + (0.44, 0.03), FPS at .215/.530 under the team strip); GoldIcon / LumberIcon / SupplyIcon / UpkeepIcon -> UI\WOS\empty.tga via war3mapSkin.txt; numbers blanked by text (WUI_BlankResourceTexts in the 0.1 s cover watcher). The blanket child-visibility restriction is superseded for the four documented mouse listeners only by checkpoint 28 below.

## Checkpoint 28 — Resource hover listeners (2026-10-11)

- `WOSUI.j`: transparent resource icons still triggered native tooltips; disabling
  the parent did not suppress their separate mouse listeners.
- `WUI_CacheResourceMouse` caches only ResourceBarFrame children 0..3 with
  count/null guards during the synchronous deferred bootstrap. `WUI_ParkResourceBar`
  hides those cached listeners on native-layout installation and restoration after pick.
  No lookup is performed in the presentation/restoration path; no new timer was added.
- ResourceBarFrame remains visible at its FPS/Ping anchor. Native resource
  strings still receive text setters only; unknown children/FPS, icon assets and
  child anchors are untouched. Do not restore the broad 25b child traversal/re-anchoring.
- Source contract and primary reference: `ARCHITECTURE.md`, section
  `ResourceBar tooltip contract`; tests: `tools/test_wos_ui.py::ResourceBarTooltips`.
- Verified: JassHelper/pjass compile, 107 enabled production sources; UI runner:
  190 checks, 0 errors/failures (one pre-existing skipped check). Four added tests
  execute listener suppression, missing handles, absent bar and pick restoration.
- Follow-up: the user's hover screenshot still showed the old FPS position; the
  configured MAIN compiled script lacked this fix. Move `WUI_FPS_X` from .306 to
  .365, the time box's left border (.400 center minus .070 / 2); keep Y .551.
- MAIN check/save and the existing Main build task with `-NoLaunch` completed.
  Only WOSUI differed in WCT; no object binaries changed. The extracted compiled
  script from `_build/WoS_Test.w3x` contains the cached-listener suppression and
  FPS X .365; its SHA256 matches the configured MAIN folder's `war3map.j`.
  Post-save check: 109 triggers, 0 source differences; UI runner: 190 checks PASS.
- User confirmed the rebuilt map no longer shows the unwanted resource tooltip.
  The FPS screenshot showed its last digit covered by the time box: source X is
  now .360, leaving .005 clearance before the .365 border; compile and 21 focused
  tests pass (one pre-existing skip). This adjustment is integrated by checkpoint
  29 below. TEST untouched; all-four-listener/pick-restoration
  runtime acceptance remains pending.

## Checkpoint 29 — Multiplayer frame access and stat help (2026-10-11)

- User reported disconnects while browsing pick categories, random picking,
  opening Menu and hiding UI. The source had first-time frame access in local
  presentation paths: the Menu fill was first fetched only while the local drawer
  was open; HUD polling enumerated lazily created item cooldown children. These
  can reserve different handle IDs between clients. This is a concrete source
  risk, not an engine reproduction or proof that every reported desync is fixed.
- `WOSUI`: Menu fill/text, stock system bar, hero buttons and minimap buttons are
  cached in the synchronous deferred controls bootstrap. Menu, HUD polling and
  pick restoration use the cached handles. Remove item cooldown-child traversal;
  keep native wrapper scaling. `Systems1` keeps the stock Menu visible through
  `WUI_ShowNativeMenu.evaluate`, without a local name lookup.
- `Starts`: allocate/register the mode selector on every client, then hide its
  root for every player except Player(0). Its existing host-only click guard
  remains authoritative. Remove the Test Mode activation chat message. Restart
  remains guarded to Player(0) in a solo game; no new gameplay sync channel.
- `DefaultArmorChangeStable_Copy`: attribute tooltips retain totals/base/bonus
  and show per-point benefits from actual MAIN Misc constants/live Systems1
  coefficients. Armor resistance gain is marginal at current armor, using the
  DamageBlock armor formula. Inline green +income and the gold tooltip both use
  the local player's lumber; attack tooltip contains damage only.
- FPS X .360/Y .551 is now integrated (the .005 gap requested after checkpoint
  28). Preserve the resource listener fix accepted by the user.
- Verification: compiler/pjass PASS, 107 enabled production sources; UI runner
  198 checks, 0 errors/failures, one pre-existing skip. New tests run asymmetric
  two-client Menu/HUD state, cached restoration, all six pick page callbacks and
  synced random dispatch; validate local income updates, live regen, diminishing
  armor returns and UI constants against the configured MAIN war3mapMisc.txt.
- MAIN check/save updated four trigger sources, no object binary changes. Built
  with the existing Main task and `-NoLaunch`; game not launched, TEST untouched.
  Next: two-human-player test of each reported action, host-only selector and
  stat tooltip layout, including different selected units/items and item cooldowns.

## Checkpoint 30 — Follow-up UI / hero counters (MAIN integrated, 2026-10-11)

- Removed delayed WUI_StyleEscMenu handle lookup/frame creation and its retry.
  Stock F10 menus now use installed CustomSkin EscMenu background/button/border
  keys before any client opens the menu. AHUI_MaxLevel uses generated metadata,
  with fallback 1; never acquire an ability handle from local HUD polling.
  These eliminate discovered risks; the reported delayed pick/random desync
  has not been reproduced or proven fixed in two real clients. Pick assets/TOCs
  are verified in the packaged map. Accepted resource listeners/FPS stay intact.
- Normal Mode activation chat removed. Shop/tree labels enlarged (.64/.56),
  six inventory slots have live item names. Tree fast buy follows the original
  item across re-centering, including a second click on the same physical node
  or its new center; existing buy/sell validation remains authoritative.
- Avul target_art cleared in war3mapSkin.w3a; attachment point preserved with no
  model. Stock buffs scaled x1.5, GearSystems2 icons .027 with seven per row.
  Selected HUD uses the cached native animated portrait. Own passive F/G keys
  match the existing enemy corner style; Tas values overlay actual ability slots.
- Stat/portrait hover is polled locally by screen coordinates, independent of
  native button focus. Portrait click clears focus; tooltip layout is cached,
  so changing numbers does not re-anchor the same box every update.
- Tas counters follow gameplay: Tomioka G damage bonus (combo/bonus chat removed),
  Starrk G actual active agility abilities (six independent 30s bonuses), Inori
  E's four stacks across all variants, Raiden G attacks until his blink is ready.
  Empty/consumed/expired counters hide. No passive balance values changed.
- WUI_TrackedMeter reuses the shared minimap dock: Starrk stack duration reads
  KS_RemoveAbility's watched clock, Kirito healing reads its existing 5s timer,
  Gojo R appears after 1.75s preparation and follows the domain's actual lifetime.
  New periodic presentation uses GearTimer03Listeners, not per-instance timers.
- F2 preserves top/options/test/camera and swap/repick controls; expanded physical
  bottom is .148 (minimap edge) after scale conversion. Ten-player layout fits
  below .565 top strip. Camera visible during pick/repick as well. Game Info names
  are Vape, Overload and Electrized, with their original element pairs.
- Verification: JassHelper/pjass PASS, 107 enabled production sources; UI runner
  212 checks, 0 errors/failures, one pre-existing skip. New production-path tests
  cover counter consumption, early ability removal, Kirito timer phase, sticky
  portrait hover, tooltip layout stability, tree double click and ten-player F2.
- MAIN objects/triggers saved. Combined save hit a Windows metadata write error
  after map writes; the same trigger push succeeded separately and final check
  reports 109 WTG triggers, 0 source differences, 0 object changes pending.
  Existing Main task built _build/WoS_Test.w3x with -NoLaunch. 164 extracted entries
  match MAIN; UI resources also match project assets. Menu skin keys and empty
  Avul art verified from packed data. Compiled MAIN/archive SHA256:
  14492722f2bde80c53117652816098004187fb4032b233f20ba8c1a326b64791.
- Backups: object-data-backups/2026-10-11_170152_801397;
  backups/trigger-sync/2026-10-11_170339_663223/map-before-push;
  backups/main-map-build/20261011-170431-817. Game not launched; TEST untouched.
  Next acceptance: two-client pick/random/menu, animated portrait and hover,
  buff/label geometry, each hero counter/timer, tree fast buy and F2/camera.

## Checkpoint 31 — UI session (parallel to checkpoint 30 of the other session)

- HUD: gold underline under the primary attribute (UNITSTAT_PrimaryMark shown by UNIT_IF_PRIMARY_ATTRIBUTE: 1 STR, 3 AGI, 2 INT).
- Tooltip boxes never take the mouse (WUI_TooltipBox: BlzFrameSetEnable false); Autobuy hit box .036 x .010.
- Game Info: [MAGIC] tags and "magic damage" from code (dmgmag / NextDmg type 0); Lightning and Hydrant marked "no damage".
- TEST COMMANDS: -s1 / -s2 (Rimuru forms); Evol2 now requires evol 1.
- Paused hero: own skills drawn by AllyHeroAbilityUI while IsUnitPaused, every slot (own / ally / enemy) shows "PAUSED".
- Pending user decisions: fake-CD rework (Agyb -> Aexh base swap needs a raw war3map.w3a edit) and the third stats column with a 3-state width toggle (dynamic HUD width).

## Checkpoint 32 — Base/arena camera and hero minimap icons (MAIN integrated, 2026-10-11)

- CamSetup's existing .20s loop calls WOS_UpdateArenaCamera for active players
  and observers. Bounds switch once on crossing base/arena; while the actual hero
  is in gg_rct_Base, hold its center. Outside base, use gg_rct_Arena and pan to
  the hero only on transition, retaining free camera movement within the arena.
  A viewer without a hero uses CondArena (base during preparation, arena in play).
  Keep the distance slider and FARZ settings. Never allocate rects locally.
- GearSystems owns WOS_RegisterHeroMinimap/WOS_UpdateHeroMinimap. Attached native
  minimapicons use the source hero's current BlzGetAbilityIcon, white tint and
  FOG_OF_WAR_VISIBLE; hero and clone have identical presentation. Hide stock
  hero/unit dots. Creation/replacement/destruction and array/cache changes run
  synchronously; local visibility additionally requires alive, not hidden,
  IsUnitVisible and IsUnitDetected. Dead hero icons hide and return on revival;
  removed units destroy icons and compact the indexed array.
- LearnHeroSpells and FixAura2 register heroes/clones; native illusion SUMMON
  event covers new illusions. Both Kirito E dummy creation paths explicitly
  register the clone against its source hero. Repeated registration is idempotent.
  CamSetup updates icon visibility; no new periodic timer or frame getter.
- TeamMapPings minimap overlays project against current camera bounds, so names
  and markers remain aligned when the visible coordinate area changes.
- Existing war3mapMapTrue.blp remains the full-map terrain picture; camera bounds
  change marker coordinates but do not crop that image. Terrain crop/replacement
  is separate from camera/marker implementation and is not visually verified.
- Compile PASS (107 production sources); UI runner 218 checks, 0 errors/failures,
  followed by four targeted checks after adding the arena transition pan. Ping
  suite 23 checks PASS. Native render size, hidden-dot fields, clone resemblance,
  multiplayer behavior and base/arena visual mapping require in-game acceptance.
- MAIN check reports 109 triggers, zero pending source/object changes. Combined
  save encountered the same metadata write error as checkpoint 30; separate
  standard trigger push succeeded. Build Main -NoLaunch PASS; 164 packed entries
  match MAIN and UI assets. Backups: trigger-sync/2026-10-11_180037_690499 and
  main-map-build/20261011-180111-833. Game not launched; TEST untouched.


## Quick Buy FIX3 — external candidate and Save Keys control (2026-10-14)

User reports Save Keys still desyncs on FIX2 without Hide UI. New SAVE_KEYS_NOQB_TEST removes ONLY ExecuteFunc("QB_SaveLocal") from SaveSystem_WriteSettingsFile; compiled diff exactly one function, all other source/resource bytes preserved. No engine result yet. FIX3 repeats this deletion and adds user BTNPAS TGA HUD border, darker price plate, .62 price text and versioned owner-only HUD minus; omitted part cost flows to nearest retained assembly, other components buy sequentially. Right-edge frame registry reflows existing top bar/dropdown on aspect changes via existing .10 WUI_DockTimer. Three global sound aliases reuse UpkeepRing/ReceiveGold/Transmute for accepted add/remove/clear. 315 mock/static checks, JassHelper/pjass and real MPQ/WCT/hash audit PASS; actual multiplayer/input/visual behavior pending. MAIN game code is unchanged; only requested BTNPAS PNG/TGA + map import added. Save Keys no longer writes QB profile; explicit Save Build does. Full code/report/diffs/control maps: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261014-quickbuy-fix3/REPORT_QUICKBUY_FIX3.md. Do not infer desync cause from compilation or parameter count 8->10.

## Quick Buy FIX4 — external build, recommendations contract (2026-10-14)

User confirmed WOS2_SAVE_KEYS_NOQB_TEST has no desync. FIX4 retains the exact Save Keys implementation without QB_SaveLocal; cause inside the engine remains unproven. Queue and AutoBuy state are no longer persisted. Explicit Save Build now writes only the current Recommended list per original hero id and player identity in WosHeroes, and four versioned bounded REC sync packets apply file loads atomically. Missing initial file uses the map's first six recommendations; invalid files preserve current list and reject overwrite. Recommended only: fifth row actions Reset/Load Build/Save Build/Add to QB, upper-left removal with compaction, horizontal one-item reorder. AutoBuy reads current agreed ItemsPage0_ID first six; Add to QB appends/deduplicates within six target limit, preserving current queue.

Latest user permits RMB instead of LMB: implemented RMB drag with frame leave/enter/up fallback and active-only checks on existing .50 scheduler; no new timer or MouseMove subscription. Shop QB minuses are sibling controls below icons, HUD minuses below both native inventory rows (two per column), plus is top-right, bolt centered/enlarged. DisplayCost is separate from charge; manual inventory changes refresh catalogue prices even with empty QB. Earlier omitted-component accounting remains unchanged. 298 mock/static checks + JassHelper/pjass + MPQ/WCT audit PASS. Only Shop source changed versus FIX3; 4087 protected compiled functions and all resources unchanged. MAIN code/map and previous maps preserved; native multiplayer, Save Build filesystem, drag/hit-testing and appearance await user test. Map/report/source exact diff: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261014-quickbuy-fix4/REPORT_QUICKBUY_FIX4.md. Deploy: Documents/Warcraft III/Maps/WoS/WOS2_QUICKBUY_FIX4_TEST.w3x.

## Quick Buy FIX5 — screenshot/input/full-inventory follow-up (2026-10-14)

User confirms FIX4 Save Keys no desync. FIX5 preserves SaveLoad and all previous maps/Main. New rec-add diskette (4 PNG/TGA states) on catalogue/tree sends agreed REC A to current Recommended; explicit Save Build remains separate. LMB QB icons now send versioned V and populate Item Tree after sync. QB item names are passive between icon and minus; row step .065, footer .126, shop/panel bottom .110. HUD minuses are own SIMPLEBUTTONs under cached simple root at each slot bottom rim (.014×.0035), using dedicated 64×24 states; hide+disable for occupied slots/other selection/no preview and on pickup/drop. Generic QB button now AUTOTRACK; tooltip owned by enter/leave, not automatic SetTooltip. Actual native cursor/hit testing awaits user acceptance.

QB_TryFullAssembly on full inventory folds missing parts into one assembly only when agreed UsedSlot proves an owned part frees a slot and gold covers remaining price; otherwise retains queue/gold/inventory. REC_RemoveSound=BattleNetTick, QB_AddSound=UpkeepRing, QB_RemoveSound=ReceiveGold, REC_AddSound=Swap, QB_ClearSound=Transmute; all reuse existing 2D handles and accepted-owner feedback. 313 applicable tests, compile, MPQ/WCT/hash audit PASS; only Shop J, expanded FDF and eight TGA imports changed. New functions QB_Inspect/QB_TryFullAssembly; 4101 compiled protected functions unchanged. Old full FIX2 suite expects obsolete persistence/geometry and is not current acceptance. Native multiplayer/new Save Build/hit-testing not run. Map/report/diffs: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261014-quickbuy-fix5/REPORT_QUICKBUY_FIX5.md; deployed WOS2_QUICKBUY_FIX5_TEST.w3x in Documents/Warcraft III/Maps/WoS.

## Quick Buy FIX6 — HUD/sale/preferences/ability chat (2026-10-14)

External-only candidate: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261014-quickbuy-fix6/REPORT_QUICKBUY_FIX6.md. FIX5 preserved; MAIN unchanged this turn. HUD QB preview reduced to .028 with .026 icon; individual minus moved to WUI_ItemY-.0190, .014x.0035, keeping occupied native inventory controls unchanged. ShopClearItemTree clears selected/back-up/bag/scroll/recipe/description caches agreed after sale, paints only owner, and zero-id/delayed-scroll guards prevent stale Default string restoration. Passive Recommended/QB drag hints; Need space/base label suppressed without changing purchase gates.

Save Keys gains canonical F,0..3 flags (bit1 Fast Buy, bit2 Fast Sell) in the existing settings file/packet flow. No queue/AutoBuy persistence or nested QB_SaveLocal. Settings sync applies both flags agreed and paints owner only, with initialization restoring flags loaded before shop controls exist. Older records keep defaults. Prior user no-desync confirmation covers FIX4/FIX5, not the new F field.

RMB on own Hero pips or cached custom tooltip sends bounded P command-slot request via existing QB sync trigger/sequence; sender/hero identity checks remain, chat has independent per-player 10sec gate. Ability identity/name/remaining native CD are resolved agreed only. Existing allied chat recipient=1 and ready/unlearned messages; legacy J chat source byte-identical. Existing mouse handler plus .05 AHUI timer fallback dedupe held presses; tooltip keeps .4sec travel grace. No new timer/trigger/sound handle. 349 applicable mock/static checks, JassHelper/pjass, check/save/build and real MPQ/WCT/hash audit PASS; only Shop/SaveLoad/ShowCD sources changed, 4133 protected compiled functions and all resources unchanged. Engine input, hover, team chat delivery and multiplayer preference load still require user test. Deployed WOS2_QUICKBUY_FIX6_TEST.w3x.

## Quick Buy FIX7 — native-state stability, prices and MAIN ping models (2026-10-15)

External candidate/report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-quickbuy-fix7/REPORT_QUICKBUY_FIX7.md. FIX6 preserved. Recommended minus now inside top-left (+.001/-.001), matching plus. HUD minus .014x.00525, centre ItemY-.0175, native SIMPLEBUTTON hover AUTOTRACK|HIGHLIGHTONMOUSEOVER + existing UseHighlight. REC_Render sets catalogue/REC minus visibility only on actual change to avoid periodic parent reset. No new frame/trigger/timer/sound. Ability messages English, per-player interval5sec; actual ability CD unchanged. ShowTextCD remains disabled and unchanged.

Deferred assembly display subtracts current remaining cost of nearest scheduled descendants from current actual remaining price, using structural keys despite reorder; manual purchase/sale of omitted parts updates the price. Normal recipes keep prior total display. Gameplay charge and sequential retained-child execution unchanged. 389 test runs including overlapping targeted/runner suites, compile/build and MPQ/WCT audit PASS; 4145 other executable functions protected; native appearance/input/network untested. Deployed WOS2_QUICKBUY_FIX7_TEST.w3x.

MAIN separately integrates only TeamMapPings source plus five user MDX and six BLP (assets/TeamPings/models); installer CLI validates/registers exact paths. Normalize doubled TEXS separators, user originals untouched; built-in UI/MiniMap/ping6 retained. All effects/rings scale1 at spawn and update; no Danger/Help x5 or size pulse. MAIN compile/build/assets/WCT audit PASS, 4060 other compiled functions unchanged. MAIN has no Quick Buy UI integration. Verified packed MAIN copy: external output/WOS2_PINGS_MAIN_BUILD.w3x. Report includes hashes, diffs, backup locations and native testing limits.

## Quick Buy FIX8 — remove native hover callbacks and immediate step prices (2026-10-15)

User reports FIX7 still flickers/warps cursor on catalogue/QB hover and HUD minus invisible. FIX8 removes ALL item FRAMEEVENT_MOUSE_ENTER/LEAVE registration/branches from Shop, restores engine-owned QB tooltip (same pattern as catalogue) and native button highlights. REC afforances retain click, no hover sync/focus/allocations. Right drag uses shared QB_BeginRightDrag global down/up plus existing .50 ShopAutoBuy fallback only while RMB held; no new timer/MouseMove, coordinate query only held edge/active drag. Swallowed down can require .5sec hold; native behavior unconfirmed.

HUD keeps SIMPLEBUTTON input, adds6 cached normal-frame faces using existing64x24 HUD state textures and same code/version/owner/free-slot guard. Centre ItemY-.0140 partially overlaps price-plate edge, size .014x.00525, level80; both families hidden+disabled on occupancy/selection/pickup. No native handlers/parents touched. QB_ShowPreviewRemove changes state only on transitions. Pool745, triggers4. QB_DisplayCost is net price of each operation from initial queue, not just after omissions; closest retained structural parents cache on rebuild/reorder, price refresh linear and respects actual manually owned components. Hirai4500 test shows500/750/1000/2000/250 immediately; debit/gameplay untouched.

Updated user5 MDX exact bytes installed in repo + test, same imports/scale1 and6 BLP; MAIN map and all MAIN sources unchanged this turn.386 overlapping test runs, JassHelper/pjass, BUILD OK, exact MPQ/WCT/hash audit PASS;4143 other compiled functions unchanged. Native hover/cursor/visible input/new model size still require game test. Deployed WOS2_QUICKBUY_FIX8_TEST.w3x. Report/source/diffs: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-quickbuy-fix8/REPORT_QUICKBUY_FIX8.md.

## Reset Keys FIX9 — external candidate (2026-10-15)

External FIX9 adds Reset Keys matching Save Keys skin in Game Info/Hide UI/Save Keys/Reset Keys row. All4 width.042025, height.015, gap.0035; edges exactly old3-row offsets.17925/.00065 and span.1786, font.66 unchanged. PlaceRight/RegisterTopControl preserve responsive/hide behavior.

RegisterHotkeyEx retains owner defaults, ResetHotkeys restores6 channels and clears13 slot aliases agreed for sender, preserving stale-key event history and current other preferences. Capture disabled only sender; owner UI paint/pulse pause. Reset local click sendsR on existing WOS2SAVE, same click/sync triggers; no handles/timers/registrations on reset. Late startup H/K cannot undo reset; direct edits unaffected. Reset does not write disk; Save Keys persists immediately, match-end save unchanged. MAIN/FIX8 preserved.350 overlapping test runs + JassHelper/pjass/build/MPQ/WCT/hash audit PASS;4152 other compiled functions unchanged, all resources byte-identical FIX8. Native layout/resize/hotkey/multiplayer pending. Deployed WOS2_QUICKBUY_FIX9_TEST.w3x; report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-quickbuy-fix9/REPORT_RESET_KEYS_FIX9.md.

## UI focus FIX10 — project source and external candidate (2026-10-15)

Source patch applied to18 J files without replacing earlier project edits: WUI_ReleaseClickFocus (local live button event, post-logic/early exits), 43 project handlers/78 sites,45/80 in FIX9-based test including QB/extra panel toggles.15 passive BUTTON families share one idempotent trigger.26 enabled-toggle focus workarounds removed; EDITBOX/link focus transfer, sliders/listboxes, native F2 and existing bindings preserved. No design/hierarchy change or new focus timer. Full file/handler list: FRAME_INVENTORY.md → Button focus audit.

Project/candidate compile PASS;238 UI tests each,101 QB /13 Reset /9 Fast-settings PASS. Historical test_quickbuy.py/test_crocodile.py failures reproduced against pre-audit code (see external report); no false all-suite PASS claim. BUILD OK/NoLaunch; extracted WCT matches all sources, only j/wct payload changed,4097 other compiled functions and resources preserved. MAIN map and FIX9 remain byte-identical; MAIN source focus patch is not saved to the MAIN map. Deployed WOS2_UI_FOCUS_FIX10_TEST.w3x; report/diffs/verification: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-ui-focus-fix10/REPORT_UI_FOCUS_FIX10.md. Engine focus recovery, interrupted clicks and two-client behavior require manual game acceptance.

## UI focus FIX11 — targeted input transfer experiment (2026-10-15)

User game test of FIX10: F2, normal shop/QB/add-to-REC, Z/K, History and music close work; spoken portrait, ten top portraits, REC remove, Menu, open emoji palette/show-chat checkbox, Auto Buy, Game Info/Hide UI/Save/Reset, HUD columns/minimap/voice/width toggles, stats F3/F4 buttons still leave keyboard blocked. Discord interaction recovers it. Therefore the direct SetFocus(button,false) experiment is NOT a complete engine fix.

FIX11 adds an experimental second path WUI_ReleaseStuckClickFocus for reported failures only. It runs the original button cleanup, then locally shows a preallocated alpha0 offscreen private EDITBOX, focuses it true/false and hides it, in the same event callback. WUI_CreateFocusSink allocates exactly one frame on agreed bootstrap before UI owners; WOSEditBox preferred, bare EDITBOX fallback. No user editbox content is read/written, no input handlers, new triggers or timers, no enabled toggle. Explicit Discord/music link focus transfer and ordinary release helper unchanged. Toolbar uses this only for Emotes; QB uses it only for REC remove codes600..<600+REC_CAPACITY. Normal shop OnClickItem, F2 stats callback, Z/K/pings, music close and settings writer are byte-identical in the compiled map. Native effectiveness of this transfer remains untested; never describe it as proven. If engine reclaims focus after the callback, this experiment can still fail; do not silently reintroduce SetEnable or permanent timers.

8 J source files changed in project/candidate;14 selected project callbacks,16 in latest candidate (extra panel toggles and REC-remove branch). Compile and242 UI tests per version PASS;101 QB /13 Reset /9 Fast-settings PASS. BUILD OK/NoLaunch; extracted WCT/source and compiler script match; only j/wct payload changed.4142 other compiled functions, resources, MAIN map and previous FIX10 preserved. New map WOS2_UI_FOCUS_FIX11_TEST.w3x deployed. Report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-ui-focus-fix11/REPORT_UI_FOCUS_FIX11.md. Need user game test first on spoken portrait, Menu and REC minus without closing shop/clicking Discord.

## UI focus FIX12 — direct button toggle candidate (2026-10-15)

User confirmed FIX11 sink also did not help. FIX12 explicitly authorizes direct enable false/true on the clicked interactive control. Remove sink/global/bootstrap and WUI_ReleaseStuckClickFocus entirely; do not delete real inputs. New WUI_ResetClickedButtonFocus accepts real click/check/uncheck events only, guarded by nonnull current event frame, event owner local client and post-business BlzFrameGetEnable(frame). Disabled controls stay disabled. No SetFocus or ordinary-release call inside this helper, no parent/icon substitution. No existing click path destroys/yields; future owners must release before destruction. Menu's extra direct old SetFocus removed; toolbar/QB mixed dispatch is mutually exclusive by frame/code (Emotes / REC removal only). Native key events do not toggle frames. Shop open/close/F2 key source and real Discord/music inputs preserved.

8 J files;14 project /16 latest candidate handlers.243 UI tests each,101 QB /13 Reset /9 Fast-settings PASS; compile/check/save/build PASS. Real extracted WCT/script match, only j/wct payload changed,4142 other functions/resources and MAIN/FIX11 preserved. No new timers/triggers/frames or SIMPLEBUTTON conversion. Map deployed WOS2_UI_FOCUS_FIX12_TEST.w3x. Engine result pending user game test. Complete handler list/comparison/facts vs hypotheses: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-ui-focus-fix12/REPORT_UI_FOCUS_FIX12.md.

## Ability Range — TEST-only integration and MAIN resources (2026-10-15)

User describes FIX12 as working; its handlers remain byte-for-byte unchanged.
New TEST derives from the complete external FIX12 workspace, not the older root
MAIN gameplay sources. Repo source: test_map/ability_range/AbilityRangePreview.j;
tools/prepare_ability_range_test.py installs its eight source hooks only into an
isolated full workspace. AAUniversalTooltips shares ReadCastRange with ListRealField
and GetDisplayedRange (live registered instance/level/form). AHUI existing .05 tick
reconciles synced Hero[]/TestUnit/TestAllyUnit before local hover/render; no new
events/timers. One deduplicated precreated effect per hero, no local allocation,
owner-only alpha/scale/position, terrain Z, radius/512, hide outside (0,2500].
Native/custom ability hover uses existing AHUI coordinates; old tooltip/chat grace
never retains the ring after leaving the ability. Five persistent covering windows
register only with a TEST presentation registry; shop/modal/menu/info/hotkey editing
also suppress the ring. No click changes.

User model basename already belongs to Inori/Kenjaku effects: preserve those original
MDX/BLP bytes. New static derivative is imported under war3mapImported/WOSRange/,
texture reference corrected to that namespace. Source backup: assets/AbilityRange/original;
runtime assets/manifest checked by install_ability_range_assets.py. It keeps the
radius-512 textured plane, removes birth/death/global alpha/scale pulse and duplicate
plane, preserves supplied BLP bytes; no particles/ribbons/lights.
MAIN scenario full backup and verification: diagnostics/20261015-ability-range.
MAIN changed only war3map.imp plus two new resources; 6550 other files preserved.
MAIN archive WOS2_MAIN_RANGE_RESOURCES.w3x and TEST WOS2_ABILITY_RANGE_TEST.w3x
are in Maps/WoS. Both archives reopened/extracted: 6552/6601 payloads; exact resource
SHA256/path/import entries verified. TEST WCT matches sources and compiled script.
Report and verification-report.json in external diagnostics. JassHelper/pjass,
check/save/build, 15 Range and existing UI/QB/Reset/Fast suites pass. Native visual
alpha, moving ring, tooltip overlap, hotkeys/focus and multiplayer still require game tests.

### Range2: instant AoE, held preview, live hero range and wide Pick/Random

Isolated candidate: diagnostics/20261015-ability-range2/workspace; output
WOS2_ABILITY_RANGE2_TEST.w3x. MAIN gameplay/source imports remain untouched.
`prepare_ability_range_hold_test.py` extends the Range1 installer; it inlines the
pure TEST component `test_map/ability_range/HeroRangeRules.j` into UniversalTooltips
to preserve its existing library ordering. A separate late rules-library dependency
breaks heroes calling SetUnitForm; do not reintroduce that dependency.

Actual Channel object metadata marks instant skills; damage/HP-heal with a real
mechanic Radius shows AoE. No area means no circle (Kenjaku Q, Mahoraga R); Inori R
shares its level-35 area bonus with the tooltip. Pure level-tag parsing avoids
writing the tooltip cache from owner-local rendering. Existing .25 tooltip polling
also invalidates radius-only changes. V is the default new saved/rebindable hold
channel, using existing WUI key registration and the existing AHUI render timer.
Leaving a skill retains the last preview only while held; another hover replaces
it, release clears the latch, modal/invalid hero boundaries cancel it.

Audit: 40 hero sources including nested Erza armor files, 209 range/distance
definitions, 37 explicit live ability
rules. Starrk EQ +100, Harribel E fixed reduced Q, Alucard reductions, Barragan/Tsuna
bonuses and current forms are included; untouched abilities fall back to the live
native cast field. Bambietta random projectiles use their maximum possible envelope
without invoking RNG; values over 2500 remain hidden. Audit and per-source evidence:
`tools/audit_hero_range_sources.py`, external range-audit-final.json.

`prepare_range_ui_followup.py` applies TEST-only Menu label scale compensation,
larger passive Menu glyph, smaller Stats/F2 and wide Pick/Random. New supplied art
uses four unique `UI/WOS/pick-{confirm,random}-wide[-off].tga` imports, RGBA 512x256;
old textures remain byte-identical. Two grid cells span .036+.041=.077; buttons align
columns 0-1 and 2-3, Ban stays column 4. Conversion: convert_pick_button_art.py;
source hashes/crops/output hashes: assets/UI/WOS/pick-wide-manifest.json.
Native visual alignment, held key persistence/rebinding, current-form radius,
focus and multiplayer safety still require testing in Warcraft III.

### Range3: follow-up candidate (2026-10-15)

Isolated full TEST `WOS2_ABILITY_RANGE3_TEST.w3x`; enabled MAIN sources/map logic
remain unchanged. `prepare_ability_range_fixes_test.py` extends the installer.
Channel targeting comes from exported real object levels (unused editor fields do
not count); utility Radius now includes mana burn/restore/immunity. Inori T uses
final 2000, Tsuna W2 final 675 including hit-query padding. Source audit inventories
all 388 HUD abilities across 40 hero files; 58 cast formulas and 12 form aliases,
209 range/distance definitions, zero missing object metadata. This is source
verification, not proof of every ability's native visual footprint. Patriot T1
1400 shows; T2 4000 stays hidden under the user-confirmed 2500 limit.

Held preview uses accepted key down/up, without an unreliable physical-key poll
overriding the latch; client deactivation cancels it. Tooltip is larger; unlearned
description leave grace is 10 existing .05 ticks, with no self-renewal on description
hover. Pick/Random width .0785 (+1.95%), height .034 equals Ban; their real click
exits use FIX12. TestMode repeat/random pick now re-enables Swap independently of
the first-pick-only Repick condition. Shop uses one common horizontal translation,
including canonical drag hit coordinates and cached resize placement.

Takeshi F/G HUD variants match their actual hotkeys; Cambio disabled art follows
the real 6000 damage requirement. Kyoraku third-act finisher KyorakuT4 belongs to G
after Skip Stage, not T; tests cover transition, initial CD, ready and return.
Harribel morph meter no longer overwrites the shared dock/child anchors with six
legacy absolute positions; refresh also runs on reuse. Hero gameplay is untouched.

TEST -killme uses per-player one-shot death timers (1s TestMode/10s match) and a
passive bar above HUD HP, cancels on base/death/replacement; no BTLF timed life.
Duplicate interface/slot bindings are rejected with Key taken. Saved bindings are
validated after the complete packet, allowing valid F3/F4 permutations. Scoreboard
key vs frame dispatch uses triggering-trigger identity, not stale trigger frame.
Attack help states +1 damage per primary attribute. 306 UI regression checks and
JassHelper/pjass pass. Final payload/source/resource evidence is in external
diagnostics/20261015-ability-range3. All native input, meter alignment, range shape,
Swap across both teams, -killme cancellation and multiplayer need game acceptance.

### Range3 promoted to MAIN; Hold retired (2026-10-15)

User accepted Range3 as stable and explicitly authorized transferring all changes
to the main project, with removal of the nonworking Hold/V button. MAIN now owns
`triggers/WOS_Start/AbilityRangePreview.j` and all Range3/FIX12/QB/HUD fixes above.
No Hold control, key trigger, latch or seventh hotkey channel remains. Hover-only
circles hide on leave; old H,6 settings are ignored by the six-channel loader.
Save Keys lists the remaining six UI channels and ability/item aliases/preferences.
The original Range3 archive is preserved for comparison, including its historical
Hold experiment. Isolated installer templates also now use the hover-only source.

Current project desync-probe additions in Systems1 were preserved. Transferred
the approved candidate's missing minimap/QuickBuy art, WOSControls.fdf, current
test fixtures and asset registration. Shared asset installer now installs the
QuickBuy TGA set automatically on MAIN builds; original Pick/Random art stays.
Full pre-transfer project/MAIN backup and reports:
external diagnostics/20261015-range-main. Recompile/check/save/build and archive
verification are required; engine acceptance is limited to the user's Range3
feedback, not a new automated Warcraft or multiplayer run.

Completed: MAIN JassHelper/pjass, check/save/build, 426 regression checks all pass;
final check has zero object/source differences. Reopened 6605 archive payloads and
112 WCT sources match MAIN/project; all ring/ping/Pick/QB resources verified.
Playable output `Maps/WoS/WOS2_MAIN_STABLE.w3x`, SHA256
f9eb57be0a2ff3f8b3adb557ec9e27275285bd71be9467285d0652bb211b75f0.
Original Range3 archive preserved. No Warcraft launch this promotion turn.
