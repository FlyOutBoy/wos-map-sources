# Production UI owner status

Implementation and native/game verification are distinct. Every row below is
implemented in project code and compiled. Latest MAIN integration checkpoint 14
PASS: 109 native sources, 40 resources, 45 packed entries; 81 regressions PASS.
Actual checkpoint 13 screenshots establish mode/world input blockers, oversized
native items, transparent chassis and pick/shop layout regressions. Checkpoint 14
corrects those source paths; native game input/appearance is still pending. Game
PID 8820 was launched at 00:58:18 +03:00; log only confirms catalogue scan so far.
No entire owner is marked runtime DONE. Next verification is recorded in RESUME.md.

| Owner | Implemented boundary / remaining verification |
|---|---|
| `triggers/Heroes/Ainz.j` | 2 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/AlterSaber.j` | 1 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Alucard.j` | 2 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Asta.j` | 1 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Bambietta.j` | 1 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Barragan.j` | 2 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/DarkShiki.j` | 1 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Erza/ErzaG2_Nakagami.j` | 1 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Erza/ErzaR.j` | 2 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Erza/ErzaT.j` | 1 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Frieren.j` | 1 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Gojo.j` | 2 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Harribel.j` | 2 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Inori.j` | 2 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. Existing weapon selection compacted; real descriptions scroll. |
| `triggers/Heroes/Kenjaku.j` | 2 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. Native barrier chip uses buff strip; public meter stays public. |
| `triggers/Heroes/Kirito.j` | 1 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Kyoraku.j` | 2 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. Existing public help panel/toggle compacted. |
| `triggers/Heroes/Laxus.j` | 1 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Natsu.j` | 2 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Okarun.j` | 1 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Patriot.j` | 1 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Raiden.j` | 3 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Rimuru.j` | 2 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Starrk.j` | 2 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Takeshi.j` | 2 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Tomioka.j` | 1 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. |
| `triggers/Heroes/Tsuna.j` | 3 existing meter site(s) attached to dynamic shared style; real values/timers/visibility retained. Native beam chip/timer also docked. |
| `triggers/Systems/DecorDestroy_and_Erza_Debuff.j` | Two-icon Second Origin + standard timer; shared dock; original switch rules. |
| `triggers/Systems/Systems2.j` | MyFrame/MyFrameBuff dynamic native icon strip. Legacy AllyCD helpers retained; initializer call is commented and no active external ShowAllyCD calls found. |
| `triggers/Systems/TasBox.j` | Actual native command-parented charge badges, shared compact surface; data unchanged. |
| `triggers/WOS_Start/Captain_Draft.j` | Independent root, compact ban strip/header and shared ban tooltips; claims/rules retained. |
| `triggers/WOS_Start/ChatCommand.j` | Compact toolbar/check control and graphite emoji palette; existing sync/feed rules. |
| `triggers/WOS_Start/DefaultArmorChangeStable_Copy.j` | Existing selected HUD, real combat helpers, native damage getter; damage fallback/range needs game verification. |
| `triggers/WOS_Start/EMOTES.j` | Real K owner + toolbar toggle, compact palette, existing VIP/effects/sync. |
| `triggers/WOS_Start/MusicPlayer.j` | Independent root, graphite panel/button states; seek/volume retained. |
| `triggers/WOS_Start/Player_Pick_Mode.j` | Existing captain vote + team selection compacted; team ordering/vote handlers retained. |
| `triggers/WOS_Start/Scoreboard.j` | Transparent main frame/gold border, graphite opacity layer; scoring/records retained. |
| `triggers/WOS_Start/ShowCD.j` | Independent normal overlays use absolute HUD coordinates; graphite tooltips; enemy cooldown privacy unchanged. |
| `triggers/WOS_Start/Starts.j` | Independent shared hero parent; permanent help tags replaced by real TestMode-only scroll panel; mode commands retained. |
| `triggers/WOS_Start/TeamMapPings.j` | Existing five-sector ally ping wheel, release once/center labels, toolbar; original sync/fog/mute rules. |
| `triggers/WOS_Start/UI_CAREER.j` | Independent root, graphite panel/button states; saves/records retained. |
| `triggers/WOS_Start/WoS_Hero_Icons_Init.j` | Existing top portraits/public score/train/timer, visible-only vitals; compact options/camera/player stats/Discord. |
| `triggers/WOS_Start/WoS_Pick_Init.j` | Actual six categories, 30-cell grid, seven previews/actions/players; compact layout + shared tooltip surfaces. |
| `triggers/WOS_Start/WoS_Shop_Init.j` | Actual seven tabs, 35 catalogue slots, recipes/inventory/search/autobuy and real handlers; compact layout. |
| `triggers/WOS_Start/WOSUI.j` | Shared roots/assets/native layout/menu/help/dynamic docks; synchronous allocation and local presentation. |

## Runtime matrix still required

- Native root visibility, menu/allies/log, buff row, portrait, damage text/attribute paths.
- Native item use/drag/hotkeys, hero learn/submenus and ordinary-unit 12-card fallback.
- All normal/captain/draft phases; all seven shop sections/search/autobuy/crafting/recipes.
- Hero meters/buff insertion/removal/smooth movement; multiple same-hero/public meters.
- Real hover/modal/scroll behavior, Z key-up/click/cancel, toolbar and TestMode panel.
- 4:3/16:9/21:9/resolution changes; multiplayer/local state and fog/detection privacy.

Commented Milim/Mahoraga UI prototypes are not active production owners and were
preserved. The actual enabled Crocodile charge display uses TasAbilityChargeBox.

Inventory is regenerated from active source (shared creation helpers included).
Do not infer runtime success from compilation or these rows.
