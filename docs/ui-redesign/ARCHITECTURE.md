# Existing UI architecture

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

## Checkpoint 13 presentation contracts

- WUI_OrnateBorder is a passive normal FRAME with four square corners and four
  independently anchored rails. Reuses eight generated alpha TGA crops; no local
  allocation and no normal/native parent mixing. Windows retain their real owners.
- WOSHUD.fdf/TOC creates the opaque bottom surface as native SIMPLEFRAME; normal
  chassis/minimap/inventory frames contain only transparent ornaments. Commands
  and native inventory parent use level 2; chassis level 0. Never put an opaque
  normal backdrop across native buttons, since normal frames render above them.
- WUI_TextButton stores its own backdrop/label/selected presentation state, shares
  local hover trigger, preserves callers' click events. Shop tabs use this helper.
- Shop tree has 18 allocated passive lines, three per visible relation. Local
  CraftItemCheck shows a branch only when GetVisibleCraftRelation returns a real
  ID. Current recipe offsets, crafting cost/data and synchronized input unchanged.
- Systems1's HideBottomUI(false)/HideUIExceptTopMenu(false) calls
  WUI_RestoreCompactNative.evaluate after the stock restoration, so pick/draft
  cannot restore resources/hero/console bars over the compact UI.
- ShowCD accepts own selected heroes for seven passive placeholder slots. Learned
  own icons/cooldown overlays are hidden so native commands stay authoritative;
  missing/unlearned positions hide native occupants via WUI_ShowNativeAbilitySlot.
  Every slot keeps its hotkey. Enemy descriptions and no enemy cooldown reads are
  unchanged. Placeholder frames are disabled and never consume targeting clicks.

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
