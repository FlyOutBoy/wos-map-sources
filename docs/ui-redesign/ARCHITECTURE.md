# Existing UI architecture

## Checkpoint 17 — authoritative current state (2026-10-09)

Latest request: fix recurring music TOC failure, unify lower boxes/actions, enlarge
mode/minimap rectangles, move vitals/abilities left, portrait level badge, flush
top scoreboard/action panel and right test-help block. Screenshot references:
40aaafc5, cd78d241, 82cdc068, 7b841409. These supersede checkpoint16 geometry.

Actual native war3mapImported/Templates.toc bytes end in SINGLE LF, without an
empty final line. Failure aborts LocalMp3Player_CreateUI and hides Link/Music.
Music now loads versioned UI/WOS/Music.toc once in WUI_OnReady game-time (.10),
with no-BOM CRLF + empty ending. Includes only engine escmenutemplates.fdf and
bundled Music.fdf. Private horizontal slider uses bundled graphite/gold textures.
Music icon buttons no longer inherit Glue templates. Track rows use custom
WUI_TextButton and WUI_SetButtonText updates their TEXT child, not the BUTTON.
Installer/verifier cover both private resources and reject malformed endings.
Primary format reference: https://www.hiveworkshop.com/threads/ui-toc-files.315854/
BlzLoadTOCFile false still reports an error; do not mask real resource failures.

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

100 regression checks PASS; production compile-only PASS147780 total lines before
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
| WOS_Start/Starts.j | TestMode and mode dialog, combat/system setup; mode handlers; TestComm now shows the scrollable help panel (permanent instructional tags removed). |
| WOS_Start/TeamMapPings.j | Physical Z and synced ally pings, target snapshots, minimap projection, no fog modifiers. Local wheel/mute state. |
| WOS_Start/ChatCommand.j | Emoji palette, local enable/disable; frame toggles and sync commands. |
| WOS_Start/EMOTES.j | Existing emote palette/sync/effects; K key-up and toolbar share Emoji_ToggleMenu. Obsolete K key-down/null FRAME_Chat0 handler removed. |
| WOS_Start/Player_Pick_Mode.j, Captain_Draft.j | Mode-specific selection/vote interfaces and handlers. |
| WOS_Start/UI_CAREER.j, MusicPlayer.j, UniversalTooltips.j | Career UI/music controls/shared tooltips. |
| Systems/Systems2.j, TasBox.j | Hero ability/counter bars, charge box library; some SIMPLEFRAME children under native Console. |
| Heroes/*.j | Hero-specific state bars; retain mechanics and refresh paths, migrate normal FRAME parents only. |

Paths above are relative to `triggers/`. Exhaustive inventory is saved in FRAME_INVENTORY.md; inspect only affected files in subsequent sessions.

## Root constraints

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
