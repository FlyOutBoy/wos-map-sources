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


## Checkpoint 33 — MAIN UI follow-up and ability progress (2026-10-15)

Supersedes the pre-follow-up MAIN_STABLE artifact above. User authorized the
stable MAIN branch; all changes below are saved into the editor scenario and
rebuilt playable `Maps/WoS/WOS2_MAIN_STABLE.w3x`. 450 UI regressions and 5 real
Crocodile T/T2 paths pass; full MAIN JassHelper/pjass/check/save/build PASS.
Final check: zero object/source differences. Reopened 6606 archive payloads and
112 WCT sources exactly match MAIN/project; added `UI/WOS/wos-app-link.tga` and
its import entry. Binary objects are unchanged. SHA256:
1f5843454ae987286db8ed5d764d6ea1cd607ee33e39efefc74ecebf27f62a3f.

WOSUI restores cached empty native cell visibility in its existing HUD tick
(respects Hide UI), expands Menu to Y=.600, centralizes exclusive shop/stats/music
and Esc close, and cancels both pending key-capture families before choosing a
new one. Real capture clicks use FIX12; keyboard events never reset a stale frame.
Shop local close does not mutate Shop_Active: immediate visual hide + one-shot
WUIWCLOSE sync reconciles shared flags, because shop validation/search reads them.
The same boundary reconciles stats/music flags; closed windows do not send repeat
Esc packets. Shop region/search/key entries all take part. Repick/Swap disabled
ghosts are hidden; available TestMode hero replacement remains.

Music is centered at .400; shop Buy/Sell/fast buttons enlarged and inventory
shifted right; Save Keys tooltip expanded. Generated WOS App TGA/PNG preserved,
caption WOS App and old URL retained. Hero pick has a matching top anime plaque,
33 mappings and source URLs in assets/UI/WOS/hero-anime.json; user confirmed
Genshin Impact for Raiden/Neuvillette. AAINIT owns the English beginner guide:
shared UI-ready allocation, owner-local marker/read/write, auto after hero pick
for 0 games/no marker, 20s countdown, Close/Esc, manual -help without timeout.
Marker is SettingsFilePath(pid)+.help.txt. Added -help to Test Commands.

WUI_HeroProgress has 45 call sites in 24 hero sources. Spell loops provide their
real phase clocks/counters; cache key is owner+ability, synchronous allocation,
owner-only presentation, stale/dead/replaced bars hide within .30. Fixed windows
use existing .10 HUD clock plus buff/key/subject guards, never gameplay setters.
Crocodile uses channelActive (channelFinished does not become true on natural
expiry) to switch to the actual 10s T2 window. Erza E-shield/Nakagami R are
indefinite resources, so show shield/mana instead of fabricated durations.
Rimuru R3 invul is separated from F2 FullDamageShield; dodge chat became Tas
remaining charges. Natsu enhanced-Q chat became a 5s meter, G shows G2 CD.
RMB pip hit-test now includes F/G/passives with native CDs. Ainz Knights caption
capitalized. All hero MouseOn/MouseOff call sequences preserved.

UI mouse down/up listeners were already removed in the preceding demand-driven
pass (test_ui_mouse_demand); Z world-move tracking now destroys its synced
listener after one valid point. Wheel sector/palette polling stays at existing
.05 cadence. This does not prove ping improvement on high-Hz hardware.

Requested hazard balance: barrel100/car250/vending300; train125+50*round,
wreck250+62.5*round; Sukuna1% target max HP +.5pp/s to15%, Game Info updated.
Full report, exact progress hooks, diffs, source/resource hashes and backup:
C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-ui-followup.
Full MAIN-before backup is in sibling 20261015-ui-mouse-demand/backup/MAIN-before.
Old playable is backup/deployed/WOS2_MAIN_STABLE.w3x. The old Range3 TEST was
already absent at its former Maps/WoS path; this task did not touch/restore it.
Additional legacy Crocodile E/F/G suite has 7 pre-existing expectation mismatches,
reproduced on the before-task backup; no new failures were introduced there.
Native rendering, focus recovery, high-Hz ping behavior and multiplayer require
in-game acceptance; no game launch performed for this build.


## Checkpoint 34 — item hover range in MAIN (2026-10-15)

MAIN scenario and WOS2_MAIN_STABLE.w3x rebuilt with item hover circles, sharing
AbilityRangePreview's precreated per-hero effect. Hover-only, previous (0,2500]
limit, owner hero only, same overlay/death/selection gates. No new mouse events,
keys, timer or frames; actual item mechanics/hotkeys unchanged. Runtime uses
ItemsSpells_GetPreviewAbility/GetItemPreviewRadius; full 150-item ability audit
is assets/AbilityRange/item-rules.json (27 explicit rules, never runtime JSON).
15 real native cast fields, 3 aura fields, 9 script globals. Holy Grail A09X=1200,
Dark Grail A0CY/A0CZ=1500, Frozen Heart A07M=1500. Script projectile/movement and
passive radii override stale editor ranges. CD-only Channel fake900/stat/self
buff/no independent caster-centred area items deliberately return zero. Sakura
native8000 remains hidden under the existing user-confirmed2500 cap.

AR_Reconcile caches item ability handles synchronously, only changed slots call
BlzGetItemAbility. Local hover/read/render never acquires an ability handle.
Render verifies the cached item still occupies the slot, so move/drop/sale can't
show a stale radius. WUI exposes visibility of already-cached native item buttons.
Inventory hit-test lives in the existing AHUI .05 pass. AHUI_HideTooltip also
conceals the ring: call it for item hover only when an old tooltip is visible,
otherwise a stationary hover would cycle alpha0/255 every tick (regression test).

JassHelper/pjass, check/save/build PASS; 470 UI regressions include20 item/range
checks and the prior lifecycle tests against MAIN. Final check0 differences.
Reopened6606 payloads/112 WCT sources exactly match MAIN/project. Only map J/WCT
changed; imports, all models/textures and binary objects match pre-task backup.
Playable SHA256:
1926a0b36eadfb0762799d078a07a31dc76611d9a8cb488681fc2d782d94a36a.
Reports/diff/verification/full MAIN + old playable backup:
C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-item-range.
Old isolated TEST templates unchanged. Native appearance and two-client input/
inventory lifecycle need in-game acceptance; no game launch performed.

## Checkpoint 35 — Esc, framed guide and live spell windows (2026-10-16)

MAIN scenario and WOS2_MAIN_STABLE.w3x updated. WUI_Init initializes both capture
sentinels to -1 for every player; previously SlotCapture stayed at JASS's zero
default until the optional editor was created, silently rejecting window Esc.
Esc registers all 16 modifier masks and calls the existing exclusive close
callbacks. Shop/scoreboard/music retain local immediate hide + synchronized
owner-state cleanup; guide remains local. Close buttons explain Close window /
Hotkey: ESC. Save Keys uses a sized tooltip anchored below the toolbar.

- Guide uses four separate gold callout frames and generated arrow textures,
  anchored to the actual Menu/F2/Stats Columns/Auto Buy controls. Owners publish
  existing handles with WUI_RegisterHelpTarget; showing the guide only changes
  points/visibility. Its 20-second first-game marker/manual -help behavior stays.
- Added meter captions use cleaned ability tooltips from object-data, including
  Uriel Protection (also corrected its native/research/tooltip proxy names).
  Adaptive caption size survives WUI_RepinMeter through MeterEdges real key6.
- Patriot W previews remaining .99-second pulses/cast gate instead of the 15s
  watchdog. Harribel EW previews its 3+.12s charge gate and stops refreshing on
  the dash. Akainu T follows first .21s / following .18s fist ticks and count.
  Inori W reads native FOLLOW_THROUGH_TIME once during shared start (7.5s),
  instead of showing the technical 99s cap. Spell mechanics unchanged.
- First-round decor bases barrel100/vending150/car250/hydrant0; all +25 per
  subsequent round. Train push100/explosion200, both +50 per subsequent round.
  Game Info uses matching formulas and refreshes on round change via its existing
  feed clock. Water/knockback preserved. Normal train60s, Sukuna phase30s;
  round start resets its interval. One shared RNG choice selects Sukuna centre
  or radius3000 at 45/135/215/315 degrees; all effects retain that shared origin.
- AutoBuy/limited opening purchase prioritize the I007 (Boots of Speed, Sonic
  icon) dependency branch and wait if it is unaffordable. Owned upgrades satisfy
  that branch. Manual recipes, saved Quick Buy occurrence order and queues stay.
- Skin PlacementCursor now uses UI/WOS/cast-range-red.tga. Existing hover model
  and texture unchanged; old WOS/AOE_AIM_Orc.blp retained. WOS App uses the user's
  monitor icon edited toward muted gold. Generated RGBA sources/prompts and
  original user art retained in assets/UI/WOS/source; TGA imports are build-owned.

JassHelper/pjass + 488 UI checks PASS, save/build/final check0 differences.
Independently reopened6609 archive payloads and112 WCT sources match MAIN/project;
only expected J/WCT/imports/skin/ability-name/UI textures changed. Previous range
models/textures verified byte-identical. Playable SHA256:
ef34b8f380e8b49e6ce443ab66c556cff9900526bfa0291179bd3c77e6ea45e3.
Full MAIN-before + previous playable, diff, caption audit, logs and verification:
C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-ui-corrections.
No game launch: native Esc delivery, typography, targeting texture and multiplayer
window state require in-game acceptance. No separate TEST map was changed.

## Checkpoint 36 — connected help arrows / round-start damage / softer cursor (2026-10-16)

Screenshot follow-up in MAIN. Help target0 is now MenuLabel, target1 is the
published Stats text; icon hit boxes were above the words and visually pointed
at Game Info. Each arrow uses TOP/BOTTOM endpoints attached to its real target
and callout edge; width only is fixed. Small end overlap compensates the artwork's
transparent padding. Upper callout right edges no longer cross the next arrow.
Bottom arrows similarly connect card edges to Stats Columns/Auto Buy controls.

Game Info's six flat damage entries end with a separate gold `(Current damage:
N)` line: barrel/vending/car/hydrant/train push/train wreck. The cached round is
updated only by WUI_GameInfoRoundStart at CondArena=1, once per new round;
WUI_FeedTick no longer checks/recalculates it. Opening/page changes render the
cached round. Gameplay damage formulas unchanged from CP35.

UI/WOS/cast-range-red.tga regenerated from the original hover disc reference:
thin softened red edge, faint inward fade, small central plus/glow. RGBA alpha
QA after512x512 TGA conversion: mean radial peak rim166.53 vs221.15 before
(about25% lower opacity), clear interior alpha1/255, centre marker114/255.
Hover MDX/BLP and help arrow textures unchanged. Source PNGs/exact prompts:
assets/UI/WOS/source/help-polish-20261016.json.

JassHelper/pjass,490 UI checks, targeted20 checks after final suffix formatting,
save/build/final check0 differences PASS. Reopened6609 archive payloads and112
WCT sources match MAIN/project; only J/WCT/cursor TGA payloads changed.
WOS2_MAIN_STABLE.w3x SHA256:
21b66cd8aca206a5b7ebe5f181cdc30a41c262b3f4b98be26aa9fcb064a496a6.
Backup/report/diff/texture QA/full verification:
C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-help-polish.
No game launch; final native arrow placement, cursor appearance and multiplayer
acceptance remain in-engine checks. Separate TEST map unchanged.

## Checkpoint 37 — environment bases and training round counter (2026-10-16)

Vending base100, car base200; barrel100/hydrant0 retained. Decor +25 starts
only on match round2. Screenshot showed barrel150 at0:0 because TestMode's
PrepareStart ends/restarts training phases when team1 has no arena hero; the
technical CurrentRound increments although team scores do not. Reading it
directly accidentally scaled training decor/train damage.

Pure EnvironmentRoundRules in Map_Header.j exposes GetEnvironmentRoundNumber:
training returns1; normal matches use max(1,CurrentRound). Actual four decor
damage sites, both train values and WUI_GameInfoRoundStart share it. Technical
round progression/rewards/hero replacement unchanged. Dependencies/index updated.
Normal rounds1/2/3: barrel100/125/150, vending100/125/150, car200/225/250,
hydrant0/25/50; train bases100/200 with existing +50 from round2. Training stays
at these first-round bases despite technical counter3/20. No texture changes.

Compile +492 UI checks (including production damage expressions, shared helper,
and Game Info under training counter3/20), save/build/final check0 PASS.
Reopened6609 payloads/112 WCT sources match MAIN/project; only J/WCT changed.
WOS2_MAIN_STABLE.w3x SHA256:
5b23e427111e29eded3f1649ba72714785738160dde6a2c28b63c155e9981603.
Backup/diff/logs/report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-environment-rounds.
No game launch; separate TEST archive unchanged.


## Checkpoint 38 — unified hero progress, live stacks and Sukuna warning (2026-10-16)

MAIN and WOS2_MAIN_STABLE.w3x integrated. All active large hero time/resource
FRAME bars now use WUI_HeroProgress's renderer, including Erza4 E in DecorDestroy.
Timers share one decimal + `s`; text/percent and event-counter wrappers reuse the
same keyed panel. Public Kyoraku/Prison Realm visibility and Kyoraku's stage guide
are retained. Zero counters allocate synchronously. Direct refresh cancels old
fixed clocks; persistent event resources close on form/death/hero replacement.
Old per-hero six-frame constructions and WUI_TrackedMeter are removed. Existing
SIMPLEFRAME buff/beam badges and Second Origin's text card retain their owners.

- Tsuna G2 has one Cambio panel (removed duplicate Morph Time Left); F uses the
  common custom percentage value, G combines remaining time and absorbed flame.
- Frieren clone expiry no longer resets the real player's T2/TF/W2 availability;
  the real hero's loop owns slot restoration and Height of Magic's timer.
- Shiki's attached counter model removed; F stacks use TasBox and the progress
  value (time + current stacks /4). Target mark/clock effects remain.
- Rimuru Q2/F3 register their TasBox keys on activation and reset spent dodges;
  the existing read-only buff/state getter supplies remaining dodges. Removed
  Counterattack begin chat. Evolution resources use shared event counters.
- Inori's E bar removed from both the real hero and Systems1.FixHeroPas clones;
  active hand crystal effects retained. Toji W shows the actual tether clock,
  paused with its target in attached/pulling states and closed on dispel/death.
- Takeshi Cambio resource accumulation/threshold dummy no longer depend on UI
  creation. Kirito keeps his native G cooldown; the disabled heal-meter poll is
  removed. First post-pick window extended by30s; later round preparation stays60.
- Sukuna's location is selected once at Time_Sukuna-15 for a public15s minimap
  ping, then reused by the actual spawn. Each new round resets the cache;
  direct summon without a warning resolves it on demand. No extra UI timer.

JassHelper/pjass +504 UI checks PASS. After save, focused81 checks PASS; final
clone-effect cleanup also passed the full504 runner. Final sync check:
111 WTG triggers,0 source differences,0 new J files. Independently reopened6609
archive payloads and112 WCT sources match MAIN/project; only war3map.j/WCT changed
from the pre-save MAIN snapshot. The stable playable is byte-identical to the
verified build. SHA256:
059da71faeccb454a6e6cbaacab9a38fc49aa7c210d27eb34e02f2b962ec5fc4.
Backup/changes/full logs/verification report:
C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-hero-progress.
No game launch. Actual UI placement, Warcraft pause/native buff timing and
multiplayer presentation require engine acceptance. Separate TEST map unchanged.


## Checkpoint 39 — match votes, invisibility and dual hero meters (2026-10-16)

MAIN and WOS2_MAIN_STABLE.w3x integrated. Previous working-tree changes preserved.
New WOSMatchVotes module provides button-only vote kick and team surrender to the
left of swap/repick. Kick requires all other active humans across both teams;
FF requires every active teammate. Initiator votes YES. Any NO, departure of a
voter or unanswered30s deadline rejects. Local buttons pulse gold until answered,
feed messages name initiator/YES/NO, and the panel opens only by click. Sync
packets validate actor, target, eligibility, duplicate answers and vote serial.
FF queues exactly one round result; the round owner awards10 wins to the enemy
and executes normal cleanup/end-match flow. Vote kick uses guarded target leave
cleanup then defeats only the target. No chat commands or automatic popups.

- Rimuru's evolution pips use the displayed replacement's real level. Q2/F3
  dodges use a remaining/max HeroProgress bar while the actual buff exists;
  removed the old Tas charge count. Pause extensions do not end the panel early.
- Tsuna G1 and Shiki F use one1.5-height panel each: red resource/stacks on top,
  purple time below. Docking sums true heights and compacts without overlap.
- Native selected-unit invisibility dims the portrait and shows generated INVIS
  inside its lower edge; restores on invis end/selection change. Cup of Tea
  Evolved, Toji R and Erza W are covered by their native invisibility state.
- Toji W uses the applied buff ability's native rank/target duration returned by
  BuffUnit01, including inherited object fields. Removed the separate5s constant
  and stale tooltip number; both tether states still freeze with a paused target.
- Tsuna E2 adds the missing point-blank damage sample and retains its far end.
  Crocodile Q extends the final damage pass by200, leaving flight/effect end alone;
  per-target hit groups still prevent duplicate damage.
- Generated alpha assets: INVIS, FF and kick; red upper fill. Menu hover retains
  its blue gradient and removes the bright horizontal stripe. Sources, prompt
  specifications and built-in image_gen provenance: assets/UI/WOS/source/
  votes-invis-20261016.json; conversion: tools/build_wos_vote_assets.py.

JassHelper/pjass,528 UI regressions and final10 focused checks PASS. Final sync:
112 WTG triggers,0 source differences,0 new J files. Independently reopened6613
archive payloads match MAIN and113 WCT sources match the project. Only expected
J/WCT/WTG/imports/hover and four new TGAs changed from the MAIN backup. Packed
war3map.j equals MAIN and the compiled output. Stable playable equals the build.
SHA256: 25daf02d524847efd6596d78483423cfd5c0451d42c23822166217d29694bad6.
Backup, exact changes, logs, asset QA and verification report:
C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-votes-invis.
No game launch. Native visuals, Warcraft buff/pause timing and multiplayer input
still require engine acceptance; this evidence is compile/archive/mock coverage.


## Checkpoint40 — startup ghost, invisibility, guide isolation and wheels (2026-10-16)

MAIN and WOS2_MAIN_STABLE.w3x integrated; previous changes retained.
Discord's passive startup ghost now uses the real button's HUD toolbar slot1/0,
not a second screen-edge docking cache. Settings applied / No saved settings yet
startup messages removed; loading and manual Settings saved feedback retained.
Shiki F badge is empty at zero stacks and shows digits only above zero.

Invis indicator now checks granted abilities Apiv (Toji R), A03W (Erza water),
A0HZ (Evolved Cup of Tea), confirmed from hero/item code and object base_id Apiv.
Native buffs/query remain fallbacks. This intentionally recognizes ability
presence even when IsUnitInvisible(unit, owner) is false. Actual grant/removal
restores portrait alpha/INVIS at the existing selected-unit refresh.

Kick requires max(2, eligible others), including in a two-human test lobby.
Proposals can still open there but one initiator cannot remove the opponent;
the target remains excluded. UI denominator matches the minimum. Deadline also
rejects impossible1/2 quorums rather than leaving them active indefinitely.

Ping and emote wheels register separate cancellation callbacks in WOSUI at shared
startup. Last opened closes the other for both toolbar and key opens, clears
its hover/commit state, and blocks old held-key repeats until release. Releasing
the cancelled wheel sends nothing. Ping mouse-trigger destruction stays in its
synchronized existing key/timeout owner, not the local cancellation callback.

Guide -help and auto-newcomer open no longer read/write a .help.txt Preloader
marker or mutate ability-tooltip carrier data. All frames/countdown timer are
still created synchronously at startup; show/close/countdown only update cached
presentation. Auto guide is once per current map for a zero-game local career;
manual -help remains repeatable. The extra local preload path was removed after
the reported desync, but the engine root cause is not proved without two clients.

JassHelper/pjass and535 UI checks PASS, including both wheel switch orders,
release/repeat/toolbar behavior, minimum2 kick votes, native-query-false invis
abilities and file/allocation-forbidden guide paths for both local client IDs.
Final sync:112 WTG triggers,0 source differences,0 new J files. Reopened6613
archive payloads match MAIN,113 WCT sources match the project, and war3map.j
matches MAIN plus final compilation. Only expected J/WCT payloads changed from
the backup. WOS2_MAIN_STABLE.w3x is byte-identical to the verified build.
SHA256: 4c6fd438ce9da9cec667fb22b258023a9a1517c3e70e222548f30d59d4ee628a.
Backup, exact source diff, logs and verification report:
C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-startup-invis.
No game launch; actual UI/invisibility and two-client desync acceptance pending.


## Checkpoint41 — synchronized guide, compact votes, catalogue forms and grid drag (2026-10-16)

MAIN and WOS2_MAIN_STABLE.w3x integrated, all earlier changes preserved.
First-visit guide no longer depends on career ss_LocalGames. Read the dedicated
Wos2/playedonce.txt decoded payload once after shared UI startup, and synchronize
N/P through WOS2GUIDE with actual sender identity. Per-player shared arrays and
pid0..9 ticks own open/handled/20-second remaining state. Manual -help uses the
same countdown; Close/Esc sends authenticated C. GetLocalPlayer branches paint
cached UI or write marker1 via the existing Save Keys writer; guide open does
not execute exclusive-window callbacks and is not registered as a modal. The
file is a Warcraft Preload script carrying1, under CustomMapData/Wos2. Career
counts/settings sync remain unchanged. Missing/invalid marker shows once after
hero selection; marker1 skips auto-help, manual -help remains available.

Vote window is.260 wide,.135-.210 high, with two-column compact player rows,
explicit solo empty state and always-present FF proposal/teammate list. Existing
quorum, serial, cooldown/timeout and authoritative round/leave logic retained.
All elements were constructed through the actual owner in regression tests for
solo, full lobby, FF and unanswered eligible ballots.

32 read-only catalogue kits across11 requested heroes use eight reusable styled
form buttons below the attack icon. Erza has Q/W/E/R/T/G1/G2 plus base; Rimuru
Form1/2/3; Takeshi Kit1/Kit2/Cambio; Tsuna Form2; Ainz T; Kenjaku Kit2/Summon
Abilities; Kyoraku W; Toji Q variants; Inori E/T2; Frieren T; Gojo R. Existing
alternate portrait imports are reused; unchanged-skin kits retain their real
portrait. Icons and native research tooltips read actual ability rawcodes.
Rimuru R/T filename suffixes are inverted in object data, so this fixes preview
order without changing gameplay abilities. Toji Q1/Q2/Q3 labels restore on every
base/other-hero selection. Anime captions grow up to the portrait border width
before scaling. Local catalogue state never selects/mutates a gameplay unit.

Quick Buy and recommended reorder now resolve bounded2D grid destinations;
preview and release share QB_GridDragTarget, existing versioned M sync applies
order. Four small gold passive arrows surround a target instead of a thin line;
eight frame handles allocate once at startup (pool753). No new runtime frame
allocation, idle mouse listener, timer or purchase path. Collapsed Kyoraku stage
text persists through Save Keys U bit4, preserving minimap/info bits1/2 and old
settings packets. Arrow generator: tools/build_wos_drag_arrows.py.

JassHelper/pjass and544 UI checks PASS, including mixed-marker two-client mock
state,20-second expiry, all32 kits' real objects/imports, Toji label reset,
Rimuru R/T, compact vote controls, grid directions and release-once. Final sync:
112 WTG triggers,0 source differences,0 new J files. Reopened6617 archive
payloads equal MAIN,113 WCT sources equal the project; war3map.j equals MAIN and
final compilation. Expected changed payloads are J/WCT/imports plus4 new arrow
TGAs. Stable playable is byte-identical to the verified build.
SHA256: 06cb5cd9bdc706b71d72961e33cd48a0ada3a9f9ff97edf9e4600452dfa4696a.
Backups, source diff, logs and verification report:
C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-guide-forms.
No game launch. Native appearance/input and the reported desync still require
acceptance in two Warcraft clients; mock equality is not engine verification.


## Checkpoint42 — agreed window dispatch and visible Quick Buy cues (2026-10-16)

User reports CP41 startup without desync, immediate disconnect on Tab shop open.
Inspected actual Tab/toolbar/region/career-item, F2, music and guide callback
paths, including compiled JASS and prior snapshots. Replaced owner-local
TriggerExecute chain + delayed state-close packets with agreed explicit-viewer
transitions. Shared close callbacks update every peer immediately; only cached
rendering/drag state is local. Escape requests authenticated WUIWCLOSE -1.
Removed three redundant state-registration triggers. Guide CP41 marker and
Save Keys loading/writing retained. A baseline replay proves old IsOpen[0]
false/true divergence when closing F2 into shop, and asymmetric callback counts;
it does not prove the engine cause of first Tab with F2 already closed.

QB four arrows now parent to QB_Panel level92 instead of root siblings level60;
Recommended four parent to catalogue panel. Form tabs narrow.041 ->.034,
right edge unchanged. All753 existing cached frames remain; no new assets.

547 regressions PASS, including actual Tab -> F2 -> music -> another player's
shop -> Escape on two mocked clients, identical shared state and callback order
without follow-up close packets; real QB_CreateUI parent/pool assertions,
malformed Escape packet rejection and no local-guarded window dispatch.
JassHelper/pjass PASS (110 enabled sources). MAIN check/save:112 WTG,8 expected
source changes,0 new J,0 object-binary changes. Build/archive results below.
Diagnostics/report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-window-desync.
No game launch; Warcraft multiplayer acceptance remains required.

CP42 build/verification complete: all6617 archive payloads equal MAIN,113 WCT
sources equal project, compiled war3map.j identical. Changed only J/WCT;
final sync0 differences/0 new sources. Stable copied from verified build.
SHA256: b549a3cdb46d5630550a9226e531a730cfebc1eb4aad1fc508e357f75173df5b.
Detailed Russian cause/evidence/limits report: external diagnostics REPORT.md.


## Checkpoint43 — picker direct calls and one-level form tips (2026-10-16)

User reports a category click on the hero picker, then mouse motion, desyncs in
CP42. CP42 window changes did not cover the four owner-local ExecuteFunc clears
inserted with CP41 form tabs. Moved preview globals/Data/Render/Select/Clear
before ReloadAfterPick and replaced all four calls with direct Clear(). Moved
slot-badge/key helpers before capture handlers and replaced the other local
ExecuteFunc with a direct call; guard absent optional slot-overlay/hint UI and
normalize empty key labels. No new handles/timers/focus operations.

Category regression now enables PreviewReady and forbids dispatch plus fresh
handles. Saved CP42 reproduces the forbidden WOS_PreviewClear call; CP43 passes
actual six-category OnClick for two clients. Added live preview select/clear/form
click and actual cached hover checks. Compiled traversal of four roots / nine
functions rejects ExecuteFunc/TriggerExecute/TriggerEvaluate/handle allocation.
This is code-path evidence; the exact Warcraft disconnect mechanism is unproven.

Form width.034 ->.030, centre.7165 ->.714, the midpoint between portrait ornate
right edge.695 and panel right edge.733. Existing styles, heights and gaps stay.
Erza T/G1/G2 QWER maxLv5 ->1 in tooltip registrations; Tsuna form Q/W/E/R likewise
5 ->1. All match actual object levels; Takeshi Cambio already1 and checked.
No object-data or gameplay ability-level changes, no blanket slash stripping.

Diagnostics/source backups/report:
C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-picker-desync.
Validation/build results appended after final artifact verification.

CP43 final validation:552 UI checks PASS (17 focused form/picker checks),
JassHelper/pjass PASS (110 enabled sources). MAIN final check112 WTG /0 source
differences /0 new sources. All6617 extracted payloads match MAIN,113 WCT
sources match project; packed war3map.j equals MAIN/final compiler output.
Compiled call-graph audit PASS on the packed script as well. Changed only
J/WCT. Stable copied from verified build; SHA256:
2842aee35d18c1b059743dc2dceaffef7b8234a5f8b456da0f2f86e4329f3c62.
No game launch; native multiplayer result remains unconfirmed.


## Checkpoint44 — frame call audit and direct wheel/window paths (2026-10-16)

Preserve the existing working tree and CP43 source/map backups. Audited generated
JASS as well as source: old Z/K reached owner-local WUI_EnterWheel TriggerExecute;
HUD shift had another callback chain. Frame minmax/value hooks and cross-library
forward calls generated evaluate trampolines. CP42 shared-window correction and
CP43 picker correction did not cover these separate paths.

Removed runtime wheel/window/top-close/HUD callback registries. WOSUI now owns
passive shared flags and cached panel handles; direct central wheel cancellation
preserves both switch orders, held-key cancellation, repeat and release behavior.
Ping mouse triggers allocate only at shared startup. Native frame setters use
direct fill-aware wrappers; guide, shop, voice and saved-setting refresh paths
avoid forward dispatch. Existing timers consume local presentation revisions;
shared hero requests drain before sync/purchase. No new timer. Career open reads
cache; startup parser's existing bounded chunk trigger is kept outside UI-open.

New compiled audit is part of check_wos_ui.py:31 enabled frame owners,387 compiled
frame functions,27 strict runtime roots; explicit local branches checked too.
Only shared startup construction and shared gameplay ability hooks remain as
reported frame-call-graph exceptions. See ARCHITECTURE checkpoint44 for contracts.
Diagnostics/backups/report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-ui-dispatch-audit.
Validation/build results appended after final artifact verification.
No game launch; Warcraft two-client acceptance remains required.

CP44 final validation:560 UI regressions PASS, including13 startup/wheel/direct-call
checks. JassHelper/pjass PASS (110 enabled production sources). Compiled audit PASS
on both check output and packed script:31 frame sources,387 frame functions,
27 strict roots;0 errors. MAIN check/save complete; final112 WTG /0 source
differences /0 new sources /0 object-binary changes. All6617 packed payloads equal
MAIN, all113 WCT sources equal project and war3map.j equals the final MAIN build.
Only J/WCT changed against CP43. Stable copied from verified build; SHA256:
8407b8072540304e38be640670a75924e17959584dc1e172848d3a7e36f9e55f.
No game launch. Native two-client/input/layout acceptance remains pending.


## Checkpoint45 — mode startup isolation and demanded mouse subscription (2026-10-16)

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

CP45 validation/build complete:563 UI checks PASS, including25 ping tests and14
startup/direct-call tests. Compile and packaged audit PASS (110 production sources,
31 frame sources,387 compiled frame functions,27 critical roots). Agreed mouse
subscription allocation is reported separately; local paths retain strict guards.
MAIN final sync112 WTG /0 source differences /0 new J /0 object-binary changes.
All6617 payloads and113 WCT sources verified; final war3map.j matches MAIN/build.
Only J/WCT changed. Stable updated; SHA256:e1cc022cb4180ab15955b3da5ff7d08f3a2a41b722647ed9cc831224020d4645.
No game launch; native appearance/startup and multiplayer remain unverified.


## Checkpoint46 — shop RMB, staged F2, dead vitals, Burner and base surrender (2026-10-16)

Shop RMB input now uses ten agreed preallocated triggers attached to expiration
of the existing .05s ShopSearchDebounceTimer. All start disabled; WUI_SetShopRmb
and agreed shop/window transitions enable only the relevant slot, like the hero
MouseOn/Off lifecycle. QB_OnRmbTick samples only its local owner. Closed shops
have no active input handler. The existing debounce callback processes passive
local revisions/search/hero requests only. No new world mouse registration,
Execute/Evaluate or input timer; pickup/drop QB_OnMouse remains inventory-only.
Close, Escape/window switch, repick/start reset and leaving shop disable the
input trigger. HUD hide preserves shared shop state but gates local reads.

User reports missing F2 badge and no click/key action. Stats hotkey/click binding
was after monolithic ten-row construction. CreateUI now constructs the shell,
hides it immediately and registers input before a finite shared .01s builder
creates one row per tick. Ready becomes true only after all10 rows; only then
does the .25s update begin. Runtime F2 allocates nothing. Regression executes
actual shell registration/build completion and both input entry points. This
addresses startup failure/operation-budget exposure, not a native reproduction.

Team-strip death status is public. Dead heroes always render0 HP despite corpse
life values, and retain HP/MP bars. For hidden dead enemies, mana remains cached;
no hidden life/mana/type query is added. Living hidden enemies remain private.

TsunaTKS removes its private SIMPLEFRAME buff tile. X-Burner uses the common
HeroProgress charge panel, updated by the existing .05s spell loop. Display is
continuous0->100, then100->125 for level35; gameplay check2/damage thresholds
unchanged. At actual125 charge the fill becomes red and text.66->.92. New casts
restore purple/default scale. Meter metadata key8 stores value scale so reflow
keeps the enlarged text centered; key7 remains dual-meter height.

Surrender is now allowed on base and arena in Normal/Test. Only the agreed vote
queues WOS_ForfeitTeam; PrepareStart bypasses preparation when queued and uses
the same ten-win scoring/end-round cleanup as arena surrender, once. FF player
rows are passive. FF/kick rows have cached right-edge check/cross marks, with
four-second result retention using the existing vote tick. No new assets.

Diagnostics/backups/report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-rmb-stats-burner.
Native rendering, event timing and multiplayer need Warcraft testing.

CP46 final validation:570 UI checks PASS (15 startup/direct-call,14 hero-progress,
18 voting,17 guide/form checks); compile110 enabled production sources PASS.
Compiled audit PASS on check and actual packed script:30 frame sources,388 frame
functions,28 strict roots. MAIN check/save:112 WTG /0 final source differences /
0 new J /0 object-binary changes. All6617 packed payloads equal MAIN,113 WCT
sources equal project; war3map.j equals MAIN/final build. Only J/WCT changed.
Stable updated; SHA256:1685a2cc285c3e5787ad69180f0bc9770fd7cc28faeaf1e67a2a15d59cc3ffe8.
No game launch. Native F2/input/visuals and multiplayer acceptance remain pending.

## Checkpoint47 — complete F2 startup, placeholders, learn glow and vote cooldown (2026-10-16)

CP46 did not fix F2 in the user test. Registration still followed shell,
headers and F3/F4 setup. It is now the first step of a finite shared17-tick
builder; all construction stays outside runtime key/click callbacks. Regression
runs real Scoreboard builders + WOSUI hotkey registration, replacing native
boundaries only. Exact native abort cause remains unproved; game acceptance is
pending.

Hide UI ghost now uses final stored dock width (viewport reflow previously
restored .056 after direct size shrink). Game Info page1 includes -help.
Kenjaku Curse count uses BTNHero_Kenjaku_F2 artwork without changing its F meter
key or Prison Realm. Learn clicks reset pressed state; five preallocated gold
SPRITEs use the Player Pick captain-control model. Mode text is larger.

FF top-level WOS_FF_ENABLED true shows/enables; false hides/closes/rejects FF
without changing kick. Reproposal cooldown30s after completion, per kick lobby /
FF team, enforced in shared begin and UI. Open window title shows remaining
seconds using existing vote tick. Reply timeout remains30s separately.

Diagnostics/backups: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-stats-pips-vote.

CP47 validation:577 UI checks PASS; compile110 sources PASS; compiled audit
30 sources/390 frame functions/28 roots PASS. MAIN check/save112 WTG with0
final source differences/0 new J/0 object binaries changed. All113 WCT sources
and6617 packed payloads verified; only J/WCT changed against CP46. Stable map
updated without game launch. SHA256:222517ce3205445a4772960b7bea78e60b2701fa29b2ed431bf87a4c0f1f3571.

## Checkpoint48 — vote model and selection timing (2026-10-16)

User clarified the requested captain model belongs on FF/votekick notifications,
not on ability learning. MatchVotes replaces its two diffuse BACKDROP glow-gold
plates with two preallocated SPRITEs using the exact captain-slot model/transform:
Pick/wos_IconShine1.mdx, size1/1, scale.72, LEFT anchor to same-size .026 button,
Y offset.48. No alpha pulse; the model animates. Both are passive. Visibility
still means an eligible local player has an unanswered active ballot; answering
hides the glow and disabled FF remains hidden. No runtime allocation/input change.
ShowCD was not changed in CP48.

InitTrig_ModeDialog schedules a5s one-shot before optional UI/camera setup.
Its callback starts the existing full20s mode selection/fallback and destroys
the delay timer. Required startup remains independent of optional frame failure.
Player Pick TimeToPickCaptain10->15 for each captain. Shared Normal/Player Pick
PrePickTime15->20 extends bans5s; the final5s handoff and3s ban lock are unchanged.
Captain Draft uses its separate timing owner; Test retains its bypass.

Focused regressions exercise delayed mode startup despite optional UI failure,
actual vote model type/transform and unanswered/answered notification state.
Diagnostics/backups: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-pick-timing-glow.

CP48 follow-up: -help has a fifth WOS App callout (global match statistics and
custom game music), with an upward arrow to the existing WOS App label registered
as help target4. Card uses a third staggered top position below Stats and stays
inside the toolbar right edge; endpoints share the same target/card X. Frames
are preallocated in the shared help builder. MusicPlayer's real app button gets
a matching hover tooltip. Guide timeout, playedonce and shared-state ownership
remain unchanged; no input subscription, runtime allocation or dispatch added.

CP48 final:577 UI checks PASS, compile110 sources PASS; packed audit30/390/28
PASS. All113 WCT sources/6617 MPQ payloads verified against MAIN; only J/WCT
changed from CP47. Stable map updated without game launch. SHA256:
23a8a75407520e824567e25cec65487d4c9b1a9ef1dd2679311900890bac5757.

## Checkpoint49 — compact names, UI actions, Burner and two hero kits (2026-10-16)

Compact scoreboard heroX.224/nameX.270, name width.082/scale.50. MVP gutter follows
left; expanded mode unchanged. Help automatic/manual timeout40s, countdown and
Game Info text updated. Restored old learning BACKDROP (no floating skill-point
SPRITEs); FF/kick captain-model notifications remain.

Shared bootstrap creates cached passive WOSTopActions FRAME. Repick/swap and
swap UI, vote controls/panel use it as ancestor; Hide UI preserves child state
while hiding the group. MV_Render gates on top visibility. Existing shared Esc
sync closes local MV_View and cached WindowPart11 (10 reserved for Career).
Click reset enabled for FF/kick, repick/swap and swap menu; no new input listener.

TsunaTKS real chargePct tracks UI's continuous curve. Every partial overcharge
above100 on level35 scales damage, not just125. Fire phase shows0.0/2.0s (duration
from TsunaT_Duration) instead of percent, with remaining-time fill. Existing
cleanup/charging sounds/full effect/cooldown threshold retained.

Natsu F Kit exposes FR/FT in R/T; Starrk T Kit includes active wolf abilities.
TQ/TW use their changed art and readonly form2 SpellData text because rawcodes
are reused. No live hero form or global ability icon is changed by preview.
Tests extend real preview metadata to36 forms across13 heroes; partial Burner
charge/damage/fire timer and owner-only Escape/focus paths are executed.
Diagnostics/backups: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261016-hud-burner-kits.

CP49 final validation:580 checks PASS; compile110 sources PASS; packed UI audit
30/391/28 PASS. MAIN0 final source differences /0 new J /0 object binaries.
All113 WCT sources and6617 packed payloads verified; only J/WCT changed.
Stable map updated; no game launch. SHA256:
98f14d2d02b12ea438f6c1223956a1ac692ca70a9986e95b0b76e4d65de83d44.

## Checkpoint50 — optional damage source leaderboard (2026-10-17)

`WOS_Start/DamageStats.j` is independently disabled with `DAMAGE_STATS_ENABLED`
or its trigger-settings entry. Both disabled configurations compile. Compact
DAMAGE STATS and TEST COMMANDS start collapsed. Restart is flush left of Vote
Kick (0.003 UI-unit gap); existing single-player availability is retained.

DamageSource(rawcode) is a one-shot numeric tag before a scripted hit/effect.
Systems2 damage wrappers consume it even for invalid targets, push/restore the
active source around UnitDamageTarget, and delayed/DOT instances capture their
own source. DmgSys snapshots the source at event entry before nested procs and
records the final damage after shields/modifiers at the same hero/nonillusion
target boundary as F2. Scripted attacks belong to their ability/item; controlled
summon attacks map to their summoning ability. Untagged native damage has an
explicit fallback. No per-hit strings, frames, timers or extra gameplay dispatch.
Existing damage amounts, native types and hit scheduling are preserved.

Four numeric buckets: Round, Game, Counter, Previous. Round rollover snapshots
Previous and clears Round; Game remains cumulative. F3 clears only the actor's
Counter, F4 copies Game into it. Both select Counter on that actor's UI; actual
round/game history is preserved. Zero buckets flush their source list.

UI: active slots only, descending totals, player colours and hero names. Ten
newest distinct source icons per player, amount overlay and hover name/share.
Open details provides a compact table; click a player for all sources sorted
by damage and paged by ten. Source sorting is O(n log n), recent selection O(10n),
only on dirty visible views, at most four updates/sec. Handles are built on the
shared ready path, one row per startup tick. Runtime hover/click/render only
uses cached frames. Large window is cached WindowPart12 and a child of the top
actions owner, so Escape/exclusive windows and Hide UI preserve visibility.
The generic column API now has an explicit remember flag: DamageStats collapse
never overwrites the saved Kyoraku guide preference.

`tools/audit_damage_sources.py` checks enabled damage call coverage and item
icons from object-data. `--write-icons` refreshes only the generated icon block.
Diagnostics/backups: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261017-damage-stats.
Validation: 601 regression checks, production compilation, 427 damage calls in
47 files, 32 strict UI roots; no in-game or multiplayer claim. Packed verification
and final map hash are recorded in that directory's verification-report.json.

CP50 final: MAIN compile111 sources;601 checks; damage audit427/47; packed UI
31/399/32 PASS. All114 WCT sources and6617 MPQ payloads match MAIN. Only
J/WCT/WTG changed. Stable SHA256: b323ea6d3ee746399d49c3bec7b16084ee0a87a4bf660aa67ca6948a11a8be1d.
No game launch.

## Checkpoint51 — DamageStats scoreboard layout correction (2026-10-17)

User screenshots exposed text/amount/header frames outside their owners and a
remote fixed-position source tooltip. DS_Text applied font scale before setting
inverse-scaled dimensions. Replaced with the working F2 order and physical bounds:
anchor, width/height, middle alignment, font scale. Runtime column resizing also
reapplies the final font scale, as Scoreboard.ResizeText does.

Player rows use transparent BUTTON hit areas and a separate white/low-alpha
stripe; text/icons retain full opacity. No beveled text-button background in rows.
Separate header cells align with player/hero, damage and recent icons. Values are
right-aligned; source numbers sit inside icon bottom bounds on a dark passive
shade. Compact rows reserve two font lines for player/hero. Open details sits at
the compact panel bottom. Main table width.500 (was.560), top.530, height
.082+.027*visible rows; source pagination uses its actual visible row count.
Source details widen the source-name/share columns; returning to Players restores
all column/icon positions. Header captions remain English.

Source tooltip follows the hovered cached icon: compact to its upper left,
large above its right edge. Text uses AllPoints and F2 alignment/scale; hide on
leave, vanished source or hidden view. No fixed screen-space tooltip location.
Restart width.042/height.013, center(.082,.556), beside Test: replace with.004 gap.
Damage collection, F3/F4, round buckets and source sorting functions unchanged.

`tools/test_damage_stats_layout.py` executes real constructors/render/hover,
checks physical bounds, header/column alignment, icon-number containment,
1/3/10-player and paged-source heights, two-line font budget, restoration of
player columns, passive focus and actor-only allocation-free hover/leave.
Geometry previews use those recorded calls and real panel/icon assets; they are
not Warcraft renders. Diagnostics/backups:
C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261017-damage-stats-layout.

CP51 final:612 regressions PASS (21 data +11 geometry); compile111 PASS; packed
UI audit31/401/32 PASS. All114 WCT sources and6617 MPQ payloads match MAIN.
Only J/WCT changed, no assets/objects. Stable SHA256:
d1a7371f0ffebb767dcdff3dfe60fb1218a557a064f2f88dac3d552ea1a918af. No game launch; native rendering unverified.


## Checkpoint52 — DamageStats upper-left colored bars and intact icons (2026-10-17)

User engine screenshots supersede CP51 geometry-only acceptance: compact stayed
in the right WUI column, labels were too small, grey stripes were not damage bars,
and white.blp/vertex-tinted number backings obscured the bottom of source art.

DamageStats.j now owns a separate upper-left toggle and transparent FRAME content,
anchored to aspect-correct left edge .809-WUI_ScreenRight(), toggle top.542,
content top.521. Both are children of TopActionOwner, so Hide UI preserves child
collapse state. Default collapsed; no WUI column registration or saved-guide state.
Rows use WUI_CreateFill + WUI_SetValue over bar-back.tga. Ten precolored textured
fills follow the Systems1 slot palette, with bright palettes darkened for readable
text. No STATUSBAR, white tint or runtime handle creation. Normalized to leader's
page damage; source detail bars show share of that player's total.

Compact width.228, step.039; detail width.620, top.535, step.038, height
.085+.038*visible rows. Up to ten players and ten source icons per row. Hero
portraits replace hero-name text. Nicknames sit on the bars; compact label1.00,
detail1.15, amounts1.10/1.15, headings1.10. Source numbers .90 in a separate dark
textured line UNDER each square art; no overlay on icon. Values round to nearest
whole/short k/m; real collected totals are unchanged. Tooltip keeps decimal damage.
Source pages widen name/share columns and restore player layout when returning.

DS_BuildIconCatalogue caches 268 ability paths from object-data during shared
startup. DS_SourceIcon uses those fixed paths plus the 31-item catalogue, matching
the scoreboard's non-blended art setter. Vorpal Strike A0D3 has an imported,
decodable BTNHero_Kirito_Q.blp. All298 imported source artworks decode; BTNBarrel
is a stock path. Regenerate both catalogues with audit_damage_sources.py --write-icons.
The ten fill textures are generated by tools/build_damage_stats_assets.py and
included through install_wos_ui_assets.py. No damage/core/sort/reset changes.

Tests execute production constructors/render/toggle/hover, verify 10x10 bounds,
number lines below icons, leader-relative width/color, portraits/nicknames,
source-page restoration, 1/3/10-player sizing, closed default, actor-only callbacks,
rounded labels, catalogue/object equality and reproducible opaque colored assets.
Diagnostics: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261017-damage-stats-bars.
Geometry previews are not Warcraft renders. No game launch; native appearance and
multiplayer remain unverified. Final compile/build/archive results appended below.


CP52 final:614 regressions PASS (23 data/catalogue +11 geometry/assets). Compile111
PASS; packed dispatch audit31/401/32,0 errors. All114 WCT sources and6627 MPQ
payloads match MAIN; source delta is DamageStats.j only. Against CP51, payload
changes are J/WCT/imports plus ten new fill textures; object binaries unchanged.
298 source artwork payloads match validated files. MAIN final check:113 WTG,
0 source differences,0 new J. Save first encountered a transient metadata replace
WinError5; a fresh check and retry passed. No game launch.

STABLE remains CP51 because Windows denies replacement while Warcraft is running
(two game processes observed; neither was stopped). The verified CP52 copy is:
C:/Users/Gear/Documents/Warcraft III/Maps/WoS/WOS2_MAIN_DAMAGE_CP52.w3x
SHA256:d62bbcfcc208f82d6e6c756f4f5786a41f5b68122dc069de59bf2e074912333b.
The locked STABLE hash still matches the pre-task backup. Use the new CP52 map;
STABLE replacement can be done after the game releases its file. Native visual
and multiplayer acceptance remain open. Verification report and source/task
backups are in the diagnostics folder above.


## Checkpoint53 — DamageStats dealt/taken, stable hover and two-row layout (2026-10-17)

CP52 engine screenshots showed mouse/hover instability and totals outside the
bar; user clarified the cursor-leave behavior and rounding threshold7051, not7501.
Only DamageStats.j, DmgSys.j and WOSUI.j change gameplay sources in this task.

Numeric contract: pages0..3 remain Dealt; pages4..7 are Taken, with their own
Round/Game/Counter/Previous buckets. DamageStatsRecordHit mirrors attacker/victim,
including neutral attackers for Taken. Use F2's per-hit integer precision before
splitting, correcting the earlier real-vs-integer total mismatch. Public primitive
recording still accepts real shares. Quincy Cross's existing bonus captures
bonus/(old hit+bonus); final post-mitigation statistic is proportionally split into
I023 and original source. Combat arithmetic/events/setters remain unchanged.
Later flat shields/reductions are distributed proportionally for attribution.
F3/F4 clear/load both directions; rollover snapshots both. Integer-composed labels:
7038 ->7.0k,7051 ->7.1k,7501 ->7.5k;9.95k shortens to10k to keep source
labels within four characters. No strings/handles on hit paths.

Presentation: compact width.190, top toggle.598 at .802-WUI_ScreenRight(); expanded
content top.540 leaves room for native timed messages at x.806-WUI_ScreenRight(),
top.574,width.180,height.027. Message origin retrieved once in shared native cache.
Detailed width.480,top.550. Both views use two rows: bar/name/right-aligned amount,
then up to ten source icon/value cells. Portrait spans both rows (.037/.042).
Compact step.039; detail step.044,height.093+.044*visible rows. Separate direction
tabs Dealt/Taken in both views; page selection is shared. Source breakdown uses
a large source icon and a second-line share caption; all bounds are fixed.

DamageStats TEXT uses explicit FRIZQT font height at frame scale1; no SetScale.
Value anchors to RIGHT of the fixed background with.003 padding, never to a
scaled TOPLEFT offset or the changing fill. No runtime point/scale setters in
RenderView; only fill widths and count-changed window heights can change.
Source cell hit bounds include art+digits. Only manual tooltip ownership remains:
anchor on enter, update text on ticks, hide on matching owner leave; remove
BlzFrameSetTooltip. Pin the displayed ordering while hovered; on leave only hide the tooltip and
mark dirty, then flush on the normal .25s timer. Hover never sets focus/enable. Source/row buttons have one click cleanup;
remove duplicate RegisterPassiveFocus from buttons already handled by DS_Click.
These remove conflicting paths; physical native cursor behavior is unverified.

WindowPart12/13/14 are details/compact/tooltip. WUI_OnWindowEscape hides these
immediately when no key capture is active, then uses the existing authenticated
sync to close shared modal state. Capturing a hotkey still consumes Escape.
Thin transparent outline TGA assets replace the large panel fill and source-number
plates: damage-row-edge256x64,damage-icon-edge64x64,damage-window-edge512x512.
Generated by build_damage_stats_assets.py; installer includes all three. Existing
ten player-fill textures unchanged. Dealt/Taken captions and all new UI are English.

Tests: production numeric hit split/mirrors/F2 precision/round/reset/load and
constructor/render/hover/click/direction/Escape/message-region paths. All10x10
cells contain art+numbers, portraits span both rows, totals remain inside bars,
repeat hits do not reanchor or resize controls, hover does no focus/alloc work,
source pages restore player state. Compiled strict audit adds WUI_OnWindowEscape.
Diagnostics/backups: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261017-damage-stats-dealt-taken.
Geometry previews are not Warcraft renders. Final build evidence appended below.

Final CP53 evidence: 626 regressions and46 focused checks PASS;111-source compile
PASS;31 owners/404 frame functions/33 strict roots/0 audit errors. MAIN check113
WTG,0 differences,0new J,0object binaries. Packed114 sources/6630 payloads
verified; only j/wct/imp changed and3 outlines added against CP52. Published
WOS2_MAIN_DAMAGE_CP53.w3x and STABLE, SHA256
440313e000e5ba59b567dfa7c5dd6d4d2aa0b472dc84deb73733c55ce1ecaf72.
No game launch; native FPS/input/multiplayer acceptance remains pending.

## Checkpoint54 — frame ping input, quiet idle UI and compact alignment (2026-10-17)

User reported permanent FPS loss after Z and recurring idle stalls with the new
UI. CP53 screenshots additionally show a reserved message gap and oversized
portraits. This checkpoint keeps CP53 numeric/statistics contracts and adjusts
input, scheduling and presentation. Source backups and final evidence:
C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261017-ping-frame-input.

Z: press toggles a fixed-centre frame panel; five fixed nonoverlapping BUTTON
hit areas select an order, then one native terrain click sends it. No MOVE
registration, screen-position reads or mouse-button polling in TeamMapPings.
Ten click triggers are created disabled at shared startup; agreed order clicks
enable only the sender's trigger. Left terrain click disables before delivery;
UI0/0 clicks keep waiting; RMB/Esc/new Z/K/another modal/8s timeout cancel.
WUI_StopPingTarget owns shared cancellation. K key and toolbar still close Z;
Z closes K. Key auto-repeat cannot reopen/cancel a selected order. Public WOSP
receiver remains compatible; native target clicks deliver directly from the
already-agreed event. No runtime ExecuteFunc/TriggerExecute/TriggerEvaluate.
One precreated ping timer starts for targeting or accepted pings, and pauses
after pending requests/cooldowns/marks expire. Effects/texttags still have the
same3s bounded cleanup, ally delivery, fog privacy and target snapshots.

A concrete heavy idle path was enabled in Systems1: WOS_ProbeStart from
LearnHeroSpells repeatedly opens15s windows, enumerates the whole map/uses RNG
and rewrites an accumulating Preload diagnostic file at.1s then1s intervals.
WOS_DESYNC_PROBE_ENABLED=false now gates all four probe entries, and static
guards remove its calls from LearnHeroSpells. When explicitly enabled, its
timer also pauses at window completion. This is source evidence of unnecessary
work, not proof of the reported five-second engine stall.

Scheduling: F2 timer is created inactive, starts once on shared opening/final
results, updates at.50s, and pauses when every shared open flag is false.
A closed local F2 does no rendering while someone else views it. DamageStats
refresh .50s, unchanged text/portraits/visibility cached. HUD stats .20s; range
inventory ownership .25s instead of.05s; ability kit/learn refresh .25s instead
of.15s while hover/range movement stays.05s. Already-hidden native command
placeholders avoid repeated visibility/alpha invalidation. Tooltip numeric/range
poll .50s; spell/item/level events retain the existing deferred immediate path.
Shop inventory shares the existing.50s autobuy timer; metadata/name/icon/price
strings are built only for changed local inventory cells. Search/drag .05s,
autobuy decisions and purchase transactions unchanged. WUI cover/docks use one
.10s core timer. Swap offer/emote/feed tick .10s with matching time deltas.
Music considers only the local viewer; programmatic seek/time setters only
while its panel is visible at.50s, playback elapsed/switching stay.10s. Startup
mode/pick countdowns and gameplay spell/shield/fog timers are unchanged.

Layout: WOS_SWAP_Y=.585 makes .026 action buttons' top=.598, matching the
DamageStats toggle. Restart/Test replace y=.560. CP55 REMOVES the native
unit-message layout introduced in CP53 and changed here: crash dump evidence
implicates that engine-owned object. Actual pick/ban text uses WUI_Feed.
Compact content top=.579 immediately
below toggle; no reserved gap. Portraits .0315/.034 (15–19% smaller), compact
row step.035/detail.038. First-line fill height.015 compact/.011 detailed; second-line source art
and numbers have separate nonoverlapping boxes within each row.

Tests execute production no-work probe, shared F2 timer lifetime, .05/.25
reconciliation cadence, repeated hidden-slot setters, music progress cadence,
changed-only shop metadata, Z event/cancel/lifetime cycles and updated two-row
geometry. Full compile/regression/packed-build results are appended below.
Engine FPS, physical cursor behavior and multiplayer still require game testing.

Final CP54:634 regressions PASS, including6 operation/lifetime tests. Compile
111 enabled sources PASS; strict audit31 owners/400 frame functions/34 roots,
0 errors. Source audit427 calls/47 files/0 errors. Final MAIN check113 WTG,
0source differences,0new J,0object binaries. Independently extracted packed
114 sources/6630 payloads match project/scenario; against CP53 only
war3map.j/war3map.wct changed (13 source files), no assets/objects changed.
Published WOS2_MAIN_UI_OPT_CP54.w3x and STABLE; SHA256
518b3a03643e4abe649e7c759b32e26027f44978263fc1727f6183731be10686.
Full report, task diff and pre-change backup are in the diagnostics folder above.
No game launch; actual idle/active FPS, physical input and multiplayer remain
engine verification. One transient manifest-write error was resolved by a normal
retry and final source/packed verification; no manual metadata override.

## Checkpoint55 — remove native message regression; move actual WUI feed (2026-10-17)

User reports Warcraft crashing when Patriot creates an enemy or allied Raiden
through the arrow-key test picker. Audit compared verified CP48..CP54 sources
and the local 03:46/13:12 minidumps, rather than changing the spawn transaction.
The same native return chain is present in both dumps. At the failing object's
address (RDI=RCX), the vtable's low DWORD is zero and field+0x9c is .180 in the
night dump and .290 in the later dump: exactly the sizes assigned to
ORIGIN_FRAME_UNIT_MSG by CP53 and CP54 respectively. CP53 introduced generic
ClearAllPoints/SetAbsPoint/SetSize on this engine-owned region. This is strong
native evidence against that recent path; there are no engine symbols proving
which individual setter performs the corrupting write.

Removed the whole native unit-message lookup/layout block. WUI_CreateFeed now
places its own TEXT frames at screen-left+.252, .540-i*.015, instead of
screen-left+.012, .560-i*.015: +.240 X (one feed width), -.020 Y. Text width,
font, aging and queue stay unchanged. Test spawn, selection, damage, hero data,
timers and CP54 optimizations are unchanged; no speculative deferred spawn.

The previous message geometry mock treated the native object as a generic FRAME
and could not catch memory corruption. Replaced it with a guard against that
native layout and actual WUI_CreateFeed constructor tests for six lines at four
aspect ratios. Native reproduction still requires a fresh game run.

Diagnostics: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261017-native-message-crash
contains source/map backups, both dump/log sets, crash-evidence.json and the
small CP54-to-CP55 source diff. Publish only WOS2_MAIN_STABLE.w3x; no CP55 sibling.
Compile: 111 enabled sources; dispatch audit: 31 owners/400 functions/34 strict
roots, zero errors. Full UI regression suite: 635 passed. Final packed-build
verification follows below. No game launch or claim of runtime confirmation.

Final CP55: MAIN save/build -NoLaunch PASS. Check:113 WTG,0 source differences,
0 new J/objects. Independently extracted114 sources/6630 payloads match project
and scenario. Against CP54 only war3map.j/war3map.wct changed, and the only
changed source is WOS_Start/WOSUI.j. Published ONLY WOS2_MAIN_STABLE.w3x.
SHA256 80d6e688467c95dae09585f53ab0fb55d259c5c08aa7aa2bec5e299471b503ac.
No engine run; recheck Patriot -> enemy/allied Raiden on a fresh launch.

## Checkpoint56 — owned damage sources, compact panels and key repeat gate (2026-10-17)

User confirms CP55 removed the Patriot -> Raiden crash. No native origin-message
layout is reintroduced. This follow-up changes six production sources; only
WOS2_MAIN_STABLE.w3x is to be published. Diagnostics/source/map backups:
C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261017-damage-sources-input.

Taken now keys hits by numeric (base source, owner, hero/unit type), so attacks
from different heroes use separate hero icons. DmgSys passes its actual source
unit to DamageStatsRecordHitFrom after final modifiers. Metadata snapshots only
integers in precreated tables; repeated hits reuse identities, with no strings,
frames, unit handles, timers or sorting allocated per hit. Owned dummy spells
use their player's hero identity. Source tooltips show owner and hero/unit name;
source-detail subtitles also show the owner. Dealt stays aggregated by ability
or item. Quincy bonus still splits only the statistic, not the actual hit.
Round/Game/Session/Previous and F3/F4 copy/clear both directions as before.

Counter is renamed Session, with a tooltip explaining F3 reset / F4 load Game.
Dealt attack art uses the HUD icon-attack.tga with alpha blending. Taken attacks
use the saved attacker hero's icon. Native untagged nonattacks fall back to their
actual unit type/name instead of one Other/native bucket. Explicit sources:
Fire/Water/Lightning debuffs, Vaporize, Overload, Electro-Charged, barrel/car
explosions, transformer and fire hydrant. Kurikara/Murasame keep item identities.
These labels describe the actual effect rather than the initiating ability.

Train impact/explosion and Sukuna's end-round aura used direct HP setters and
never generated a normal damage event. RoundSpells' EnvironmentHpLoss keeps the
same SetHpCurrent call and measures actual HP loss afterward. An optional
DamageStats call records that loss; it does not create another damage event or
change mitigation, death credit, train kills or HP arithmetic. F2's old totals
are unchanged; DamageStats now additionally includes those direct losses.
RoundSpells has optional DamageStats dependency so disabling that trigger keeps
the HP change. Ground fire has a dedicated native-unit identity as well.

UI: details width .480 -> .360; row steps .038 -> .031, compact .035 -> .028.
Portraits and source art shrink another20%; digits retain their own boxes below
art. Both panels have a passive alpha205 textured backdrop, separate from opaque
text/icons, plus existing thin outlines. Ten source icons remain in each row.
Source hover controls are GLUEBUTTONs with no registered click handler/focus
cleanup; one manual passive tooltip sits beside/below the panel, away from rows.
Hover never changes mouse position, focus or enable state. Native cursor
behavior remains an engine check; mock geometry cannot prove it.

heroicon owns hide/restore of its existing game-time/train-kill boxes. Its local
presentation pass reads the cached details visibility, including Esc/X/other
modal/HideUI close paths, while the actual clocks keep running.

Input: one precreated elapsed timer and per-trigger/player/key numeric gate.
The gate is a TriggerAddCondition, before slot-forwarding and Esc-sync actions:
key-up clears the latch; repeated key-down returns before action execution.
Even synthetic alternating edges are capped at10 Hz/key. WUI_UseSlot also guards
reentrant ForceUIKey forwarding. Both key edges are registered, including all
modifier combinations. No repeat-triggered timer, allocation or sync. Existing
key-up toggles and Z/J hold semantics are unchanged.

Invisibility: portrait alpha135 ->85 (~33% opacity), restored to255 on exit.
A separate passive black backing (alpha115) sits below the existing Invis
texture at the same bounds; lettering remains crisp, with the same visibility
predicate as the label. No raster asset or object edit is needed.

Tests execute numeric identity reuse, two attackers/hero art, ownership tooltip,
history/reset/load, direct HP clamping,2000 held events,1000 synthetic cycles,
recursive forwarding, status restoration and constructor geometry for10 players
and source pages. Geometry previews are diagnostic renders, not Warcraft shots.
Final compile/regression/packed-build results follow below.

Final CP56:643 regressions PASS. Compile111 enabled sources PASS; dispatch
audit31 owners/402 frame functions/34 strict roots,0 errors. Damage source audit
427 calls/47 files/0 errors. MAIN check113 WTG,0 source differences,0 new J/objects.
Independent MPQ extraction verifies114 source files and6630 payloads. Compared
with CP55, only war3map.j/war3map.wct change (six J sources); assets/objects stay
identical. ONLY WOS2_MAIN_STABLE.w3x published. SHA256
ceaf90afe32c18b81efd7cd82446ebd885799477765aacd7871ef50992b13163.
No game launch; native cursor/smartcast/FPS/multiplayer acceptance is pending.

## Checkpoint57 — responsive damage dock, shared guide icons and Saber G (2026-10-17)

User screenshots show the Damage Stats toggle remaining at the old screen edge
after resizing the Warcraft window, pick feed overlapping centre clocks/FPS,
and Saber G missing as a distinct source. Backups and final evidence:
C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261017-responsive-damage-saber.

DS_LayoutViewport caches WUI_ScreenRight and reanchors compact panel + toggle
only when the aspect ratio changes. It runs before the hidden-view early return
on the existing .50 timer, so a collapsed toggle still follows the screen edge.
No extra timer, frame creation or setters at an unchanged size. The expanded
panel stays centred. Compact portrait .0252 -> .026334 (+4.5%), X+.0015; bar/
source cells move right to preserve a gap. Expanded portrait stays unchanged.

WUI_LayoutFeed uses the existing .25 feed timer and the same changed-only cache.
Own TEXT frames now start at min(.560,screen-right-.250), Y=.540-i*.015: right
of centre clocks even on a very wide client, clamped on narrow windows. Before
the feed exists it returns without reading client geometry. Width/font/aging
remain unchanged. The native engine message region stays untouched (CP55).

WUI_InfoSourceIcon is the one presentation catalogue for Game Info and Damage
Stats: Fire/Water/Lightning/Vape/Overload/Electrized and Barrel/Vending/Car/
Hydrant/Train/Time limit. All existing Game Info row captions/descriptions stay;
the icon argument calls the catalogue instead of duplicating a literal path.
Taken attacker hero icons and Dealt HUD sword keep their existing meanings.
The old Transformer label is corrected to Vending machine, matching the guide.

Saber G: AlterSaberW_KS was started only from EnterBase. Test heroes created
outside base could reach level35 without starting its charging loop. The Saber
branch in LvlUpCheck now calls the same public starter; its per-unit active flag
prevents repeated levels/base entries from creating duplicate instances. Loop
cleanup clears the flag before releasing the unit. The extra autoattack magic
hit in AlterSaberW_PasTrigger was tagged A05F (W2); it now uses A02F (G), and the
fixed ability icon catalogue is regenerated from editable objects. Damage,
delay .06, magic route0, charge consumption and cooldown are unchanged. Main
and test owners use exactly the same path. This does not reclassify the separate
F current-mana addition or the Q combo as a new combat hit.

Production tests exercise G start idempotence and the charged magic proc for
owners0/6 and passive tiers1/2/3, separate source attribution/consumption, shared
guide art, changed-only viewport updates while collapsed, and feed resizing
at four client aspect ratios. No game launch; runtime visual/physical input
acceptance remains external. Final compile/regression/build evidence follows.

Final CP57:647 regressions PASS; compile111 enabled sources PASS. Dispatch
audit31 owners/404 frame functions/34 strict roots,0 errors. Source audit427
calls/47 files/0 errors. MAIN check113 WTG,0 source differences,0 new J/objects.
Independently verified114 WCT sources and6630 MPQ payloads. Only war3map.j and
war3map.wct differ from CP56 (four source files), no asset/object changes.
Published ONLY WOS2_MAIN_STABLE.w3x; SHA256
4b320526c19a7a7068494f518e761972578b7df669c050ba38c7c28b617c3892. No game launch.
