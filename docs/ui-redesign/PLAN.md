# UI redesign plan

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
| 9a. Z wheel | Existing TeamMapPings: no segment labels, center hover, release commits valid sector | P0 | IN_PROGRESS | Code compiled; 21 production tests pass including release-once; in-game key/frame behavior pending |
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
