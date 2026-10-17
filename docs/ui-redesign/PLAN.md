# UI redesign plan

Current follow-up: RESUME CP57 (responsive Damage Stats/feed, shared Game Info
icons and distinct Saber G proc initialization/attribution). CP56 remains the
base for owned sources and input repeat gating. User confirms CP55 crash is gone. DamageStats
adds numeric Taken ownership and explicit environmental/direct HP sources,
compact translucent panels, condition-level key repeat gating and clearer Invis.
Only STABLE is published. Cursor, smartcast/FPS and visual acceptance need game
verification; the previous native message layout must stay removed.

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

Checkpoint 14 integrated in MAIN after actual checkpoint 13 screenshots. Passive
mouse containers, native button subtree sizing, empty own ability cells, restored
pick two rows/centered difficulty, half-width vertical stats, gold icon, shop footer
and centered costs. 81 regressions PASS; full MAIN compile 148657 lines PASS;
109 source identities/order, 40 resources and 45 packed bytes PASS. Game launched
00:58:18 +03:00 but map entry/input/appearance NOT verified yet. Blocks remain
IN_PROGRESS; do not equate source tests or process survival with game acceptance.

| Block | Work / dependencies | Priority | Status | Completion criteria |
|---|---|---|---|---|
| 1. Audit | All frame owners, selection/data sources, roots, native frames, assets | P0 | DONE | Architecture/inventory saved; 45 production owners identified; detailed owners read as their blocks start |
| 2. Infrastructure | Independent root, synchronous frame allocation, shared layout/style; depends 1 | P0 | IN_PROGRESS | Load crash investigated; root/owners deferred to 0.10s, native layout to 0.30s; unsafe native text hiding removed; real MAIN compile and startup tests pass; user screenshots confirm map entry; checkpoint 12 console/fill corrections integrated and compiled; appearance pending |
| 3. Assets | Graphite surface, thin gold borders, button states, bars, resource icons; depends 1 | P1 | IN_PROGRESS | 21 UI textures plus passive/native FDF/TOC installed in MAIN, all 40 resources and packed bytes verified; in-game appearance pending |
| 4a. Selected unit HUD | Existing stat overlay + selection logic; portrait/icon/level, actual damage/resists/attributes | P0 | IN_PROGRESS | Compiled, privacy tests pass; runtime pending. No fabricated stats; Avul Block; null/ordinary/hidden selection handled; hover details |
| 4b. Native command/inventory | Move real QWERTFG slots and inventory; preserve learn/target/item interactions | P0 | IN_PROGRESS | Compiled, 7/12-slot tests pass; native correction after real screenshots integrated; interaction pending. No duplicate command system; native interactions and alternate command cards reachable |
| 4c. HP/MP, toolbar | Bars above abilities, regeneration; gold/lumber tooltip, shop/Discord/K/emoji/ping; depends 2,4a,4b | P1 | IN_PROGRESS | Existing shop/K handlers wired, gold/lumber and checkbox implemented; runtime pending. Compact functional controls, emoji checkbox, existing handlers retained |
| 5. Top panel | Existing heroicon, visible-only HP/MP, score/train/rounds; depends 2 | P0 | IN_PROGRESS | Compact score/train/options styling implemented; guard tests pass, runtime pending. Hidden enemy values never read; local caches only; hide portraits leaves score visible |
| 6. Hero selection | Existing categories/pages/preview/players, all normal/captain/draft modes; depends 2,3 | P1 | IN_PROGRESS | Compact 5x6 catalogue, preview, draft, captain vote/team selection and shared tooltip surfaces compiled; all phase transitions still need runtime verification. Real handlers retained |
| 7. Shops | Existing tabs/search/auto-buy/recipes/craft/item info; depends 2,3 | P1 | IN_PROGRESS | Existing seven tabs/search/recipes/inventory relaid and skinned; compile passed, runtime pending. All tabs and purchases preserved, consistent textures/spacing |
| 8. Other UI | Scoreboard/career/votes/hero bars/music/emotes/tooltips; depends 2,3 | P1 | IN_PROGRESS | Secondary surfaces, 46 hero meters, unit-buff docks, special hero windows, captain votes and ability overlays/tooltips compiled. OWNER_STATUS.md accounts for all 45 active owners; native/game verification pending |
| 9a. Z input | CP54 fixed frame buttons and one terrain click; no MOVE/polling; shared cancellation with K | P0 | IN_PROGRESS | Production lifetime/cancel tests and compile; in-game FPS/input still pending |
| 9b. Test panel | Replace permanent help texttags, right scrollable collapse panel | P1 | IN_PROGRESS | Code TEXT pages replace blank lazy-template panel; scroll/collapse runtime pending. TestMode-only; original commands documented, working commands unchanged |
| 9c. Menu/camera | Functional native system buttons in compact menu, existing camera slider | P1 | IN_PROGRESS | Native menu drawer and camera placement compiled; runtime pending. Critical menus/hotkeys stay reachable; local camera only |
| 10a. Native integration | MAIN push/build, native WTG/WCT identities/order, imports and packed bytes | P0 | DONE | Guarded MAIN push and full build PASS, 109 source identities/order verified, 40 resources registered and all 45 extracted archive entries byte-equal |
| 10b. Game verification | Native interactions, visuals, all modes, multiplayer/fog/resolution matrix | P0 | IN_PROGRESS | User reported load crash on 3.0.1.24342; checkpoint 11 addresses startup. User screenshots now confirm map entry, expose stock console/blank fills/help and broken shop; checkpoint 12 correction integrated; new launch still lacks map entry evidence. Native automation failed with kernel-assets OS error 3 even after reset; awaiting real screen state |

Do not write MAIN while World Editor runs. Preserve current dirty working tree.
Do not recreate HeroIcons/shop/pick/combat data systems. Complete coherent blocks
and update PLAN/PROGRESS/RESUME after each checkpoint.

User addition: hero meters and unit buff timers need one shared dynamic placement
system. WOSUI now provides registration, automatic compaction, smooth movement,
native SIMPLEFRAME-safe buff icons and a WOSHeroMeter constructor for new owners.
Runtime verification remains pending; implementation is checkpoint 6.

Checkpoint 28 (2026-10-11): resource-hover cleanup for block 4c is implemented in
WOSUI source and covered by compiler/UI regressions. The overall block and game
verification remain IN_PROGRESS; MAIN integration is complete (checkpoint 29).

Checkpoint 29: local frame acquisition risks removed from Menu/HUD/restoration;
host-only selector and stat-help changes integrated into MAIN. Two-player testing
of pick pages/random, Menu, Hide UI and item cooldown selection remains pending.

Checkpoint 30: stock menu skin moved to CustomSkin; local ability-handle getter
removed. Native portrait/stable hover, enlarged buffs/shop labels, inventory names,
tree fast buy, Tas passive counters and shared Starrk/Kirito/Gojo meters integrated.
F2 retains top/options/camera and reaches minimap edge. MAIN compile/build PASS,
212 regressions PASS, 164 packed entries match MAIN/assets. Visual/two-client
acceptance remains IN_PROGRESS; exact contracts and backups are in RESUME.md.

Checkpoint 32: per-player base centering/arena bounds, identical hero/clone native
minimap portraits and bounds-aware ping overlays integrated in MAIN. Compile,
218 regressions, four final targeted camera/icon checks and 23 ping checks PASS;
164 packed entries verified. Native rendering and terrain background alignment
remain game acceptance work; existing full-map image was not cropped.


Checkpoint39: two-row hero panels, buff-owned Rimuru dodges/evolution pips,
invisible portrait and button-only unanimous kick/FF implemented. Native assembly,
assets and regression evidence are recorded in RESUME.md; visual and multiplayer
engine acceptance remains open.


Checkpoint40 integrates startup Discord docking, silent automatic settings,
ability-based invis indication, positive-only Shiki badge, minimum2 kick quorum,
local guide without extra Preloader IO and mutually exclusive ping/emote wheels.
Compile/regression/archive evidence in RESUME; two-client engine acceptance of
-help, wheel input and invisibility remains open.


Checkpoint41: dedicated first-visit marker plus synchronized guide state/countdown,
compact populated votes,32 catalogue kits, bounded2D reorder with four-direction
pointers and persisted hero-stage collapse are integrated in MAIN. Compile,
544 regressions and full archive/source equality PASS. Native visuals and the
reported multiplayer desync remain an engine acceptance boundary in RESUME.


Checkpoint52: DamageStats upper-left independent toggle and transparent compact
owner; ten-player colored WUI bars, hero portraits, enlarged captions, ten source
icons per player with larger rounded values beneath. Detailed columns use gold
and blue role accents. Fixed object artwork catalogue and ten reproducible TGA
fills installed by the normal asset pipeline. Implementation complete; native
visual/multiplayer acceptance remains open. Evidence and build results: RESUME CP52.


Checkpoint53: DamageStats Dealt/Taken sources and F2-consistent hit precision;
Quincy Cross contributes its own source without changing the combat hit. Fixed
font/anchors, pinned hover, single tooltip/focus owner, narrow two-row layouts,
large portraits, transparent hairline outlines, immediate Escape and timed-message
dock implemented. Native appearance/cursor and multiplayer acceptance remain open;
verification and playable map details are in RESUME CP53.

CP54: replace CP45 demand-created MOVE with frame selection/one-shot click.
Remove diagnostic probe IO by default, quiet closed F2/pings, merge same-period
UI timers and cache repeated native setters/metadata. Align actions at.598,
remove compact gap and move messages below Restart. See RESUME CP54 for exact
periods and verification boundary; no game FPS claim from operation tests.
