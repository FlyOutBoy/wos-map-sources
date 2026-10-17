# Долговечные решения и известные исправления

Проверка указателей: 2026-10-11. Подробные разборы уже существуют; здесь только
маршрутизация. Их исторические результаты не доказывают состояние текущей карты.

| Когда читать | Сохранённое знание | Первичный материал и проверка |
| --- | --- | --- |
| TEST собирает старую систему/не того героя | shared-источники берутся из MAIN, TEST имеет свои overrides и замыкание зависимостей; перенос героя не переносит объекты/ассеты | [test_map/README](../../test_map/README.md), [hero workflow](../../.claude/skills/wos-new-hero/SKILL.md), `tools/test_test_map_workflow.py`, `test_hero_transfer.py` |
| Добавление триггера меняет чужой текст в редакторе | WTG traversal и WCT payload должны сохранять соответствие идентичностей и порядка; не склеивать их по случайному индексу | `tools/sync_war3_triggers.py`: `validate_editor_order`; `tools/test_sync_war3_triggers.py`: `test_main_push_inserts_new_start_trigger_before_later_categories` |
| Пропали уровни/описания Channel | явные поля каждого уровня и `Ncl5`; описания строятся из реальных TooltipBuilder/UniversalTooltips, а не независимой копии формул | [MAIN_ABILITY_LEVEL_REPAIR](../../MAIN_ABILITY_LEVEL_REPAIR.md), `tools/test_main_ability_levels.py` |
| Неправильная сила/длительность контроля | ранг принадлежит служебной способности, не buff; таблица рангов должна соответствовать формулам Systems1 | [CUSTOM_BUFF_LEVEL_AUDIT](../../CUSTOM_BUFF_LEVEL_AUDIT.md), `tools/test_custom_buff_levels.py` |
| Сейв не загрузился/статистика удвоилась/кеш Preloader | стартовая загрузка и локальный кеш, идемпотентность конца матча, нормализация ника, проверки целостности | [SaveLoad-разбор](../SAVELOAD_CHANGELOG_2026-10-09.md), `triggers/WOS_Start/SaveLoad.j`, `UI_CAREER.j`, `tools/test_saveload.py` |
| Неверные родители фреймов, bootstrap, TOC | общие владельцы через WOSUI; FRAME/SIMPLEFRAME и локальные операции имеют разные ограничения; байты TOC существенны | [UI-правила](../../.claude/rules/ui-frames.md), разделы владельцев/корней [UI architecture](../ui-redesign/ARCHITECTURE.md), `.gitattributes` |
| Десинк после кликов UI, пика или изменения выбранного предмета | Menu/HUD/restore используют bootstrap-cache; ленивые native cooldown/menu children нельзя обходить/создавать условно; меню оформляется CustomSkin, максимальный уровень способности берётся из метаданных без локального ability handle; точная причина задержанного десинка не подтверждена | [Multiplayer presentation contract](../ui-redesign/ARCHITECTURE.md), checkpoints 29–30 в [RESUME](../ui-redesign/RESUME.md), `tools/test_wos_ui_multiplayer.py`, `test_wos_ui_checkpoint30.py`; нужна проверка двумя клиентами |
| Десинк после первого пика в новом UNITSTAT | Удалена периодическая GroupEnumUnitsSelected(GetLocalPlayer) цепочка; per-player UI selection cache, multi-selection fallback и локальный Render. HUD вызывает read-only DamageCheckModifiers; боевой DamageCheck сохраняет GearDamageRun. Из OnClick исключены 8 ProbeMark и 1 ProbeDump | `DefaultArmorChangeStable_Copy.j`, `Systems1.j`, `WoS_Pick_Init.j`, `tools/test_wos_ui_selection.py`; пользователь подтвердил Q и полный MAIN R без десинка в своём мультиплеерном сценарии. Внутренний механизм native не доказан; FPS не оптимизирован |
| Прозрачные иконки ресурсов всё ещё показывают подсказки | отдельные ResourceBar mouse listeners 0..3; синхронный cache, точечное скрытие при layout/restore, без изменений SimpleFontStrings/FPS | [ResourceBar tooltip contract](../ui-redesign/ARCHITECTURE.md), `WUI_CacheResourceMouse` / `WUI_ParkResourceBar`, `tools/test_wos_ui.py::ResourceBarTooltips`; игровая проверка пока не выполнена |
| UI тормозит/возникает цикл событий слайдера | текущий пользовательский контракт: layout по действиям; programmatic SetValue может вызвать обработчик снова | [RESUME](../ui-redesign/RESUME.md), раздел `Checkpoint 27e`; искать текущие обработчики в WOSUI, не применять старые timer-repin инструкции из 27d |
| Механики Crocodile/его интеграция | существующие подробные отчёты, не общий шаблон для любого героя | [IMPLEMENTATION](../../CROCODILE_IMPLEMENTATION.md), [MAIN_INTEGRATION](../../CROCODILE_MAIN_INTEGRATION.md), [ENVIRONMENT_UPDATE](../../CROCODILE_ENVIRONMENT_UPDATE.md); соответствующие `tools/test_crocodile*.py` |

## Как обновлять

Сначала найти существующий раздел по системе/символу. Обновить его вместо
дубликата; здесь добавить указатель только если знание трудно найти.
Для нового долговечного факта достаточно: симптом/контракт, установленная причина,
решение и почему, путь/символ, выполненная проверка с датой, что ещё не проверено.
Гипотезу не записывать как факт. Не копировать код, полные логи и переписку.
При изменении реализации исправить старый контракт и ссылку в ту же задачу.
Прогресс редизайна остаётся в `docs/ui-redesign/`; в этот файл временные TODO не переносить.

## Что получает новая сессия

Корневой `AGENTS.md` — постоянные инструкции Codex для этого проекта.
Имена/описания Skills в `.agents/skills/` доступны для выбора; полный Skill
и связанные документы читаются по применимости. `docs/ai/` не подгружается
целиком автоматически. Механизм описан в официальных
[AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md) и
[Skills](https://learn.chatgpt.com/docs/build-skills).

Запускай новую сессию в этом проекте. Файлы должны оставаться в её checkout;
для другого компьютера/worktree их надо передать вместе с проектом.
Проверка расположения и frontmatter не равна наблюдению запуска новой сессии.
Если Skills ещё не появились, перезапусти сессию; локальные настройки могут
отключать Skills или переопределять AGENTS. Эти настройки здесь не изменялись.

Claude использует свой `CLAUDE.md`, правила и Auto Memory. Codex читает общие
проектные справочники по ссылкам; `.claude/rules` не считаются его автоматически
подгруженной памятью. Обновление этих файлов выполняет агент во время задач,
а не фоновый сервис. Точность зависит от сохранения и актуализации документов
и проверки затронутого кода; отсутствие сведений не следует заполнять догадкой.


### Save Keys / Quick Buy regression and partial deferred assembly (2026-10-14)

User confirms FIX2 Save Keys desync even without Hide UI, then confirms SAVE_KEYS_NOQB_TEST has no desync. The control deletes only ExecuteFunc("QB_SaveLocal") from SaveSystem_WriteSettingsFile; FIX4 keeps that Save Keys implementation byte-identical. This establishes the tested regression boundary, not the engine/ExecuteFunc/Preload mechanism; 8->10 is loader recognition of S/U, not proof of allocation changes. FIX4 removes obsolete QB1 persistence entirely: queue/AutoBuy never save, explicit Save Build stores current Recommended under WosHeroes by original hero id/player identity. Local file reads become four bounded REC sync chunks before atomic agreed application; current agreed ItemsPage0_ID drives AutoBuy. Source/report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261014-quickbuy-fix4/REPORT_QUICKBUY_FIX4.md; 298 mock/static checks, compile and MPQ audit passed, native two-client Save Build/input/file IO still require user test.

Removed recipe steps must defer only omitted portions, not the entire goal. Return omitted intrinsic costs recursively to nearest retained ancestor; stop propagation at scheduled steps to avoid double charge. Keep structural subtree bounds with reordered tokens and wait for queued retained descendants. Reserve owned duplicate copies for retained occurrences so a deleted duplicate cannot cause endless re-purchase. Existing actual remaining-cost helper handles final agreed payment/consumption. Evidence: FIX3 actual JASS/native-mock tests (nested, duplicate, full inventory, low gold, reordering) and MPQ audit; native engine behavior not tested. Source/report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261014-quickbuy-fix3/REPORT_QUICKBUY_FIX3.md. Main code remains prior version; only requested BTNPAS resource import made.

### Quick Buy preview input and full slots — latest boundary (2026-10-14)

FIX4 Save Keys was confirmed without desync by the user; FIX5 preserves the exact SaveSystem implementation. An ordinary high-level UI BUTTON is not sufficient evidence of priority over native inventory SIMPLEBUTTON input. FIX5 uses its own agreed-created SIMPLEBUTTON at each preview rim, with explicit disable+hide for non-preview slots and no native event replacement; accepted deletion validates owner/selection/free slot/version. QB item LMB lacked a control-click registration; it now sends a versioned inspection command and updates tree caches agreed. Native hover was changed to AUTOTRACK + passive event-owned tooltip; native jitter/hit testing are still unconfirmed. Full inventory may assemble remaining recipe directly only if an actual owned part is consumed to release a slot and full remaining cost is affordable; otherwise preserve inventory/queue/gold. Source/evidence/limits: external FIX5 report, 313 applicable mock/static checks + compiler + MPQ audit; old FIX2 persistence contract is intentionally superseded. MAIN not integrated.

### Quick Buy FIX6 — empty tree and safe preference/chat boundaries (2026-10-14)

Cause/solution: Fast Sell restored ItemsCurrentItem_ID_BACKUP even when zero/stale, generating an invalid tree. Clear all agreed selection/scroll/branch caches, then owner paint, and guard zero-id/delayed scroll; actual refund/gameplay remains unchanged. HUD icon covered minus near original rim: FIX6 makes preview .028 and moves own SIMPLEBUTTON below art to ItemY-.0190; engine input still unconfirmed.

User confirmed earlier NOQB/FIX4/FIX5 Save Keys no desync. FIX6 adds only packed F fast buy/sell flags to existing settings flow, never QB queue save; agreed sync is required because these modes affect actions. Old settings remain supported; new extension needs native two-player retest. P ability-chat commands likewise resolve identity/CD only after agreed sender/hero/sequence validation; local hit testing sends command slot, cached frame rectangle and held-edge guards avoid gameplay/handle allocations. Existing .05 timer fallback and mouse event are deduped; independent 10sec per-sender gate uses ShopClock. No new periodic process. Evidence: 349 mock/static checks, compile and MPQ/WCT audit; 4133 protected functions unchanged; MAIN/old maps preserved. Source/report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261014-quickbuy-fix6/REPORT_QUICKBUY_FIX6.md. Native hover/input/chat/preferences remain untested.

### FIX7 — catalogue reset, deferred price and model import paths (2026-10-15)

Repeated REC_Render from QB_RenderLocal set catalogue parents and REC minus visible on every refresh; FIX7 guards these writes by current cached-handle visibility, preserving native child/input state between transitions. Native flicker still needs user confirmation. HUD pill texture64x24 requires .014x.00525, centred in the .007 gap between .028 previews at .035 row step; ItemY-.0175 leaves space from both icon rows. Native SIMPLEBUTTON hover uses AUTOTRACK|HIGHLIGHTONMOUSEOVER and UseHighlight; actual engine priority remains untested.

Deferred recipe display previously always used full actual remaining price, even with retained components still scheduled. FIX7 uses current remaining price minus nearest retained descendant remaining operations for missing-part assemblies, identified by structural group/key bounds independent of drag order. Manual inventory purchases/sales update omitted-part discounts; debit logic unchanged. Tests cover3/4 omissions, manual purchase/sale, nested and reorder. Ability report strings English; send interval5sec does not change ability CD. SaveLoad unchanged from FIX6.

Custom user MDX TEXS contained doubled literal separators; normalize only those padded paths, preserve chunks/geometry/user source files. Register five MDX/six BLP exact imports in MAIN+TEST; native UI/MiniMap/ping6 needs no import. All scales1 for complete lifetime, removing previous help/danger x5 and sinusoidal size pulse. Manifest installer hashes/path validates, backs up and idempotently updates import list. MAIN changes only pings; UI stays external. Evidence:389 test runs (overlapping suites), JassHelper/pjass, both BUILD OK, MPQ/WCT/hash audit; 4145 TEST and4060 MAIN other executable functions unchanged. Native visual/input/network result not observed. Report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-quickbuy-fix7/REPORT_QUICKBUY_FIX7.md.

### FIX8 — hover events and recipe-step prices supersede FIX7 (2026-10-15)

User observes repeated item hover flicker/cursor warp despite FIX7 guarded visibility; added per-item ENTER/LEAVE subscriptions for recommendation drag and QB tooltip conflict with the existing native-hover-only shop policy (WOSControls CP21). FIX8 removes subscriptions AND obsolete branches/caches, attaches passive QB tooltip natively. Drag starts via global RMB down/up or existing .50 timer only while held; no extra timer or idle coordinate polling. Native result must be verified by user.

HUD SIMPLEBUTTON remained functional but art invisible under normal-frame HUD. FIX8 adds cached normal-frame face above art using same existing64x24 native states and code400+i; both families share agreed step/version/free-slot guards, invalid second duplicate delivery cannot remove next step. Minuses now overlap price-plate lower edge slightly (ItemY-.0140), hide/disable for real occupied items. Explicit UI pool745; no local handles/extra triggers.

FIX7 net pricing was wrongly conditional on StepMissing; initial Hirai displayed4500 while last queue operation is250. FIX8 computes current remaining minus closest retained descendant prices for every assembly. Cache structural parent indices on rebuild/reorder, refresh linearly, retain actual manual-inventory discounts and untouched debit/omission/full-slot gameplay. Tests demonstrate500/750/1000/2000/250 from initial add and parent refresh after reorder/manual purchase.386 test runs including overlapping suites, compile/build/MPQ audit passed;4143 other functions and MAIN source/map unchanged. New5 user MDX exact bytes in repo/test, scale1 unchanged. Report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-quickbuy-fix8/REPORT_QUICKBUY_FIX8.md; actual hover/input/network/model acceptance pending.

### Reset hotkeys safely without re-registering events (FIX9, 2026-10-15)

Native key events cannot be unregistered. Reset must retain used-key history to let existing channel filter suppress former custom keys; restoring bootstrap defaults requires only current key/name mapping changes. Capture actual defaults in RegisterHotkeyEx before file load, not from current labels. Clear13 slot aliases and end sender capture; default native/object keys resume. All binding writes occur in agreed sender sync; owner-only badge/pulse paint allocates no handles. Reuse existing WOS2SAVE/click triggers for reset R. Prevent late startup file H/K from overwriting a completed reset, while keeping direct editing/other fields available. No implicit file save; Save Keys/end-of-match writer unchanged.

Four-button row retains old outer edges using width.042025/gap.0035 and span.1786. Reset uses exact Save Keys native skin and cached responsive placement. Evidence:13 reset tests +101 QB +9 fast-settings +227 UI runs (overlap possible), JassHelper/pjass/build and real WCT/MPQ audit;4152 protected functions/resources and MAIN/FIX8 unchanged. Native multiplayer/key action/layout/compact resize untested. External report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-quickbuy-fix9/REPORT_RESET_KEYS_FIX9.md.

### Event-only custom-button focus cleanup (FIX10, 2026-10-15)

Symptom reported: Q/W/E/R and map hotkeys sometimes stop after button/F2/shop interactions until a world click. Audit found missing cleanup (including shop early-return paths and hero portraits), enabled toggles used as focus workarounds, and passive BUTTON hit areas with no click handler. WUI_ReleaseClickFocus now releases only the live event button on GetLocalPlayer()==GetTriggerPlayer(), after logic and early returns. 43 project handlers/78 exit sites in18 J files; external FIX10 has45/80 including QB and panel toggles. 26 enable-toggle pairs removed; visual toggle paint no longer manipulates focus. 15 passive BUTTON families use one idempotently registered shared trigger; all allocations remain on agreed creation paths.

Do not use this helper for EDITBOX/slider/listbox input or from delayed callbacks. Opening link buttons release first, then explicitly focus the editbox; Restart releases before handing off to the engine. No currently audited click path destroys frames/yields; future destruction requires release before deleting button/parent and reviewing the passive registry. No new timer, key capture or native-button replacement. F2 already maps to stats; no new F2 interception was added. Source comparison preserves business logic; compilation/project+candidate238 UI tests and QB101/Reset13/Fast9 passed. Historical QB/Crocodile suites still have baseline failures, documented separately. MPQ/WCT exact audit preserves resources/MAIN/FIX9; engine keyboard recovery/multiplayer untested. Evidence: docs/ui-redesign/FRAME_INVENTORY.md and C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-ui-focus-fix10/REPORT_UI_FOCUS_FIX10.md.

### FIX10 engine result / FIX11 focus transfer experiment (2026-10-15)

User game test of FIX10: F2, normal shop/QB/add-to-REC, Z/K, History and music close work; spoken portrait, ten top portraits, REC remove, Menu, open emoji palette/show-chat checkbox, Auto Buy, Game Info/Hide UI/Save/Reset, HUD columns/minimap/voice/width toggles, stats F3/F4 buttons still leave keyboard blocked. Discord interaction recovers it. Therefore the direct SetFocus(button,false) experiment is NOT a complete engine fix.

FIX11 adds an experimental second path WUI_ReleaseStuckClickFocus for reported failures only. It runs the original button cleanup, then locally shows a preallocated alpha0 offscreen private EDITBOX, focuses it true/false and hides it, in the same event callback. WUI_CreateFocusSink allocates exactly one frame on agreed bootstrap before UI owners; WOSEditBox preferred, bare EDITBOX fallback. No user editbox content is read/written, no input handlers, new triggers or timers, no enabled toggle. Explicit Discord/music link focus transfer and ordinary release helper unchanged. Toolbar uses this only for Emotes; QB uses it only for REC remove codes600..<600+REC_CAPACITY. Normal shop OnClickItem, F2 stats callback, Z/K/pings, music close and settings writer are byte-identical in the compiled map. Native effectiveness of this transfer remains untested; never describe it as proven. If engine reclaims focus after the callback, this experiment can still fail; do not silently reintroduce SetEnable or permanent timers.

Evidence is limited to user FIX10 feedback, exact source/compiled preservation checks and current242 UI /101 QB /13 Reset /9 Fast-settings mocks, compilation and MPQ build audit. A passing mock proves API call ownership/order, not Reforged keyboard recovery. Native EDITBOX focus/alpha behavior is described by Tasyen: https://www.hiveworkshop.com/threads/ui-editbox-text-input.316239/; using it as a button-focus bridge is an inference from Discord recovery, not a verified tutorial fix. Current report/source/diffs: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-ui-focus-fix11/REPORT_UI_FOCUS_FIX11.md. MAIN source updated, MAIN map not saved.

### FIX12 replaces failed FIX11 sink with authorized clicked-control toggle (2026-10-15)

User confirmed FIX11 sink also did not help. FIX12 explicitly authorizes direct enable false/true on the clicked interactive control. Remove sink/global/bootstrap and WUI_ReleaseStuckClickFocus entirely; do not delete real inputs. New WUI_ResetClickedButtonFocus accepts real click/check/uncheck events only, guarded by nonnull current event frame, event owner local client and post-business BlzFrameGetEnable(frame). Disabled controls stay disabled. No SetFocus or ordinary-release call inside this helper, no parent/icon substitution. No existing click path destroys/yields; future owners must release before destruction. Menu's extra direct old SetFocus removed; toolbar/QB mixed dispatch is mutually exclusive by frame/code (Emotes / REC removal only). Native key events do not toggle frames. Shop open/close/F2 key source and real Discord/music inputs preserved.

Discord and failed controls are both BUTTON; actual difference is hide/real-EDITBOX focus transfer, whereas many HUD controls stay enabled/visible. Engine reacquisition/ignored focus and sink ineffectiveness remain hypotheses, not proved causes. Evidence: user failures for FIX10/FIX11; source/compiled preservation and243 UI/101 QB/13 Reset/9 Fast-settings PASS for FIX12. This verifies owner/state/order and packaging, not native focus recovery. Report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261015-ui-focus-fix12/REPORT_UI_FOCUS_FIX12.md. Previous historical no-SetEnable rule is superseded only for this explicitly authorized, availability-preserving experiment; no automatic retries/polling.

### TEST-only ability range and colliding resource basenames (2026-10-15)

Do not overwrite war3mapImported/wos_tx-tsqyuanxing2.mdx or its BLP: Inori/Kenjaku
already reference that effect. Range resources live in war3mapImported/WOSRange/;
normalize only the supplied model into a static radius-512 plane and rewrite its
single texture dependency. Retain source bytes in assets/AbilityRange/original.
Keep MAIN changes limited to new resources and imports; pack without compiling it.
Verify every original MAIN payload hash except war3map.imp and reopen both archives.
The configured MAIN is a scenario directory despite its .w3x suffix; additionally
pack a separate WOS2_MAIN_RANGE_RESOURCES.w3x playable archive.

Range logic remains test_map/ability_range/AbilityRangePreview.j plus isolated
integration through tools/prepare_ability_range_test.py. Shared live cast-range getter
feeds the builder and circle, only for registered/learned abilities; no duplicated
range table. Existing AHUI .05 tick allocates/retire effects synchronously from
Hero[]/TestUnit/TestAllyUnit before local presentation. Deduplicate, retire all
old slots before creating replacements, keep alpha0 initially; never create/destroy
from hover. Owner-local reads/alpha/scale/position use one private preallocated ground
location; skip movement while hidden. Native learned and custom icon hover share
existing screen coordinates, with no frame events. Preserve FIX12 click handlers.
Evidence: tools/test_ability_range_preview.py; external 20261015-ability-range
verification-report.json/source.diff and reopened MPQ payloads. Engine alpha/terrain,
hover/focus and multiplayer acceptance are not established by mock tests or compilation.

Range2 extends this contract: infer instant Channel targeting from object metadata,
show damage/HP-heal Radius, not a default Channel cast distance; no area means no
circle. Resolve preview level tags without writing shared tooltip caches. Shared
read-only formulas cover current buffs/forms, including Starrk EQ +100, Harribel E
and Alucard reductions, and Inori R level-35 area. Preserve native live cast fields
for untouched skills (including Barragan W's existing setters). Audit recursively:
Erza armor sources are nested under Heroes/Erza. Current inventory is 40 files,
209 range/distance definitions, 37 explicit ability rules. Secondary movement,
passive proximity and unused globals must not become cast ranges.
Inline HeroRangeRules into AAUniversalTooltips in isolated TEST: a new late library
dependency changes vJASS ordering and breaks existing hero SetUnitForm callers.
Held preview uses existing WUI saved key channels and AHUI timer, not a new polling
timer. Source/components/tests: prepare_ability_range_hold_test.py,
test_ability_range_hold.py, test_hero_range_rules.py; diagnostics/20261015-ability-range2
contains compiled/extracted verification and a manual acceptance checklist.

Range3 supersedes Range2 instant filtering: use exported actual-level Channel
target mode; utility Radius (mana burn/restore/immunity) is valid too. Held state
comes from accepted key events; physical polling must not cancel that latch.
Description hover must not renew its own leave grace (10 existing .05 ticks).
Range audit covers 388 HUD abilities, 58 source cast formulas/12 aliases; retain
the explicit >2500 hide rule (Patriot T1 1400 visible, T2 4000 hidden).

Kyoraku third-act final ability A059/KyorakuT4 has G, replacing A0DY/Skip Stage;
mapping it to T hides the enabled real G and its initial CD. Register both variants
in G, retain gameplay availability hooks. Harribel's morph code still had six old
absolute anchors after WUI_HeroMeter; remove them so shared dock owns all children,
refresh on reuse too. Source transition/CD and layout contract regression tests:
tools/test_ability_range_fixes.py. These changes are installed in isolated TEST
only, alongside TEST -killme explicit timers, shop translation, repeat Swap,
Takeshi requirements, binding collision checks and F3/F4 trigger-source dispatch.
Validate restored bindings after the whole packet, not against temporary defaults
record by record. Native keyboard recovery/visuals/multiplayer remain unverified.

Range3 promotion (2026-10-15): user accepted this candidate and authorized MAIN,
but rejected Hold/V as nonworking. Production range preview is hover-only; remove
the whole latch/control/key registration and channel 6, not merely hide its badge.
Keep six existing channels, ignore legacy H,6 records, remove Hold from Save Keys.
Tests cover ignored legacy packets, no V registration and immediate hover leave.
All Range3/FIX12/QB fixes and their missing UI resources are now transferred to
the main project; retain independent Systems1 desync probe. QuickBuy textures must
be installed by install_wos_ui_assets on every build, not exist only in a candidate
scenario. Historical TEST-only restriction above is superseded by this approval.


### UI windows and spell progress — 2026-10-15

CP42 supersedes the local-close/deferred-state contract from CP35.
WUI_EnterExclusiveWindow(kind, viewer) must run on every client, outside local
guards, from agreed key/frame/unit/sync events. Registered callbacks use the
explicit WUI_WindowPlayer, close Shop_Active/IsOpen/lmpVisible/guide arrays on all
clients, and guard cached rendering only. Do not change shared flags locally
and reconcile them with a later packet: a replay of the CP41 baseline produces
IsOpen[0]=false/true on the two clients between those events. Local TriggerExecute
also executed the callback chain on only one peer. Its engine-internal desync
mechanism is not proven. Escape's local capture guard sends WUIWCLOSE -1; its
agreed handler dispatches the same transition. No separate state callbacks or
follow-up close packets. Frame/trigger registration stays shared at startup.
Initialize both CaptureChannel and SlotCapture to -1 in WUI_Init, even when the
optional hotkey editor is never created. JASS defaults them to0; the old Esc
guard then silently treated every player as capturing slot0. Register all16
modifier masks. Checkpoint35 runs actual initialization before testing Esc;
manually setting -1 in an input fixture misses this failure. Save Keys at the
top toolbar needs WUI_TooltipBelowSized, not the above-owner sized helper.

WUI_HeroProgress must be called synchronously with actual spell-loop remaining/
maximum values; its first call creates handles identically on all clients.
Do not drive it with owner-local file/profile/hover state. Presentation/freshness
is owner-only; .10 HUD refresh expires interrupted/dead/replaced panels. Fixed
WUI_HeroDuration windows are UI-only and may check a real buff/key/subject.
Crocodile natural T expiry clears channelActive, not channelFinished: use the
former to switch from cast to T2-window progress. Erza indefinite E shield and
Nakagami R show resources, not a fictitious time. Newcomer guide lives in AAINIT; CP40 removes its separate .help.txt/Chunk
read/write path. All guide handles are created at shared bootstrap; its local
open/tick now change cached presentation only, with a once-per-map flag.
Technical watchdogs are not visible durations: Patriot W ends on pulse count
before its15s cap; Harribel EW charge is MaxCastDuration+.12 before the dash;
Akainu T ends on fist count/.03 tick cadence; Inori W uses native Channel
FOLLOW_THROUGH_TIME (read once during shared start, currently7.5), not99s.
New progress titles use cleaned object ability tooltips; long-title geometry
is saved in MeterEdges real key6 and retained by WUI_RepinMeter.
CP38 removes bespoke hero FRAME meters (including Erza4 E in DecorDestroy).
WUI_HeroProgressText shares the same keyed panel for percentages and time+stacks;
WUI_HeroProgressCounter is only for event-driven resources with an explicit close.
Zero resources allocate synchronously and remain visible; ordinary loop meters
retain freshness expiry. WUI_HeroProgressPublic preserves public Kyoraku/Kenjaku
events and validates Hero[owner] when expiring on a different client. Direct
updates cancel any previous WUI_HeroDuration clock for the same key. Caption
geometry changes only when its text changes. Keep SIMPLEFRAME buff/charge badges
and Erza Second Origin's non-bar card outside this normal FRAME meter API.

Frieren T's clone used to run player-wide ability-slot cleanup when it expired,
so the real hero lost T2/TF/W2 before her independent timer ended. Only the real
hero's instance (b = FrierenCloneCheck(c)) may restore those player-wide slots.
Toji W's tether r clock advances only when its target is not IsUnitPaused, in
both attached/pulling states; the panel reads that clock and closes on dispel.
Takeshi Cambio accumulation/dummy creation must run independently of UI creation;
the old first-frame branch skipped the first damage update. The shared counter
now consumes the clamped gameplay total. Shiki and Rimuru boxes register in shared
activation callbacks; TasBox.GetValue reads real stacks/buffs and never reserves
handles in its local paint path. Removing Inori's E bar also requires removing
the cloned copy from Systems1.FixHeroPas.

Sukuna's shared location is chosen once at Time_Sukuna-15, cached for the public
15s minimap warning, and reused by SukunaEnd_Start. Reset the cache at round start;
direct summons without warning prepare it on demand. Do not reroll at summon.
CP38 production checks: tools/test_hero_progress.py and the UI runner. These are
script/native-mock checks; visual placement and Warcraft pause behavior still
require engine acceptance.

Guide arrows
anchor to published existing owner controls, so HUD shifts cannot point them
at the minimap slider. Checkpoint35 evidence:488 UI checks, compile/save/build,
6609 archive payloads/112 WCT sources, external20261016-ui-corrections report;
native appearance, input delivery and multiplayer still need engine testing.
Screenshot refinement (CP36): top guide targets must be Menu/Stats text handles,
not icon hit rectangles. Use both TOP/BOTTOM endpoints, one on the target and
one on the callout edge; fixed-height arrows leave visible gaps when callouts
move. Account for transparent image margins with small endpoint overlap.
Game Info round damage now snapshots only at WUI_GameInfoRoundStart from the
round-start branch (CondArena=1), not by polling CurrentRound in WUI_FeedTick.
Always check generated cursor alpha: a dim-looking opaque black disc obscures
terrain. The accepted TGA has clear interior alpha1, a small central cross/glow,
and roughly25% lower radial rim alpha; exact QA in20261016-help-polish.
Do not use technical CurrentRound directly for environment scaling in training:
TestMode's empty team1 arena check restarts phases and increments it even at0:0.
EnvironmentRoundRules in Map_Header.j provides GetEnvironmentRoundNumber (1 in
training, max(1,CurrentRound) in normal matches). Decor, train and the Game Info
round snapshot share this pure rule; do not reset the global counter to fix a
display, since it also drives rewards/round flow. CP37 verifies training counter3/
20 and normal rounds1/2/3 via production damage expressions and the real UI helper.

UI-only mouse hooks now capture one world point per Z press and destroy that
synced listener on all clients. Hero MouseOn/MouseOff is a different owner and
is unchanged. UI mouse button polling is limited to its active panels/hit areas.
Evidence: 450 UI tests, 5 real Crocodile T/T2 tests, compile/save/build and 6606
archive payloads verified. High-Hz ping/focus/visual/multiplayer acceptance is
still external; details in UI RESUME checkpoint33 and external diagnostics
20261015-ui-followup/REPORT_UI_FOLLOWUP.md. Legacy Crocodile E/F/G expectation
mismatches reproduce on the before-task backup, not caused by these UI hooks.


### Item range source and hover lifecycle — 2026-10-15

Item CD-only Channel abilities often carry a fake cast range900. Never infer
preview from the first item ability or its tooltip text. Explicit item->mechanic
rules in ItemsSpells are audited against all150 objects in
assets/AbilityRange/item-rules.json: real native cast/aura fields or script globals.
Grails/Frozen Heart use aura AREA_OF_EFFECT; projectile/movement globals override
stale object values. Cache BlzGetItemAbility synchronously in AR_Reconcile on
inventory changes; local hover only reads existing handles, validates occupancy
and reuses the hero's existing circle. No local allocations or new input events.
AHUI_HideTooltip also hides AR: calling it unconditionally on each item hover
would flicker the circle; hide a previous visible tooltip once, then request the
item without concealing each tick. 470 UI tests/compile/save/build/archive hashes
verify sources/lifecycle/packaging, not native rendering or multiplayer. See UI
checkpoint34 and external diagnostics/20261015-item-range/REPORT_ITEM_RANGE.md.


CP39 follow-up: Rimuru evolution removes base spells, so ability-level pips must
read the displayed AHUI_CurrentAbility. Q2/F3 dodge counts now belong to the
shared progress panel, driven until the actual buff disappears (with short native
application grace), rather than a fixed window or Tas badge. WUI_HeroProgressDual
uses a single keyed panel, .0375 height and two fill/value rows; docking sums
real heights instead of slot*.030. Repin both the bar and its cached real fill.
BuffUnit01 returns native duration for the applied rank and target type; Toji W
uses it and freezes its clock while the target is paused. Do not assume the old
5s constant equals object data, which may inherit native base-ability fields.

Votes: decide only inside WOSVOTE sync/shared ticks; keep local MV_View out of
membership/results. Snapshot active human voters; kick excludes target, FF uses
captain-aware IsInTeam1. Any NO/timeout/eligible departure rejects. Kick cleanup
must use GetGold(p), not GetTriggerPlayer(), because the sync sender can differ
from the removed target. WOS_HandlePlayerLeave is guarded by Leave to prevent
native leave after CustomDefeat from redistributing items/gold twice. FF queues
one team id and the round owner awards10 once before normal end-round cleanup.
Evidence: tools/test_match_votes.py, tools/test_ui_vote_followup.py and UI runner;
actual rendering, native buff expiry and two-client behavior need engine testing.


CP40 corrects CP39's invis assumption: querying IsUnitInvisible(unit, owner) and
Binv/BOwk missed permanent invisibility grants. Check Apiv (Toji R), A03W (Erza
water) and A0HZ (Evolved Cup of Tea), all object-data base Apiv. Test ability
presence with the native query false and no buff. Discord ghost drift came from
using RightDock while its real control used the moving HUD toolbar; share the
same WUI_PlaceToolbar placement and avoid two competing position caches.

A two-player kick cannot accept the initiator alone: enforce max(2, eligible
others) in evaluation and UI. Timeout must unconditionally finish an unresolved
vote, even with no pending eligible voter (1/2 quorum). Wheels have a dedicated
shared-registered local cancellation contract; key-held/repeat latches keep the
cancelled wheel from reopening or sending on release. Preserve the synchronized
owner of ping mouse-trigger activation (CP44 preallocates the handles). tools/test_startup_followup.py covers
both switch orders, repeated keydown, release and toolbar opens.

Reported newcomer-guide desync: removed its extra local Preloader/file marker
read/write and tooltip carrier, leaving a once-per-map local flag and existing
career-games check. Guide bootstrap still creates all handles synchronously.
The regression executes open/close/countdown for both local client IDs with
file, tooltip and handle-allocation natives forbidden. It does not confirm the
Warcraft engine root cause; two-client testing remains necessary.


CP41 supersedes CP40's once-per-map/zero-career guide decision. A dedicated
CustomMapData/Wos2/playedonce.txt decoded marker1 now suppresses auto-help.
Read once after shared UI startup with the existing Save Keys carrier; send
WOS2GUIDE N/P. Shared arrays per authenticated sender and a pid0..9 tick own
open/handled/remaining; GetLocalPlayer guards only cached rendering/local marker
writes. Manual help gets the same countdown (40s since CP49); closes synchronize C.
Do not call the exclusive-window callback chain when opening the guide. A
GetLocalPlayer read or local UI scalar alone is not proof of desync; trace shared
consumers and allocations. Mixed new/existing clients now have identical guide
arrays in the interpreter. Native two-client acceptance is still required.

Hero catalogue forms must read actual ability icons/tooltips. Rimuru R A0A0
points to BTNHero_Rimuru_T; T A09Z points to BTNHero_Rimuru_R, so constructing
icons from suffixes swaps them. WOS_PreviewTable covers32 kits, existing imported
portraits and local-only form tabs. Reset Toji Q1/Q2/Q3 labels on every base/hero
change. Never reuse these local preview values for gameplay picking.

Quick Buy grid drag must use both X and Y, with the same bounded destination on
preview and release. Keep the versioned M sync authority and create direction
pointers only in shared QB_CreateUI (pool753 frames,8 more). Reordering neither
purchases nor mutates inventory directly. UI settings bit4 persists collapsed
Kyoraku/hero-stage text without changing existing minimap/info bits; bit2 must
use modulo4 rather than flags>=2 after adding bit4. Evidence: test_guide_forms,
test_ui_followup, updated Quick Buy suites and the544-check UI runner.


### Picker local dispatch regression — CP43, 2026-10-16

User reports CP42 desync after a pick category click and moving the mouse.
CP41 forms inserted four ExecuteFunc("WOS_PreviewClear") calls, including inside
owner-local category/clear branches. CP42 audited windows but missed this path.
The prior category regression neither forbade ExecuteFunc nor enabled the new
preview. It could not detect this asymmetric dispatch. Enable PreviewReady,
execute actual OnClick for all six categories on both mocked clients, and forbid
ExecuteFunc/TriggerExecute/TriggerEvaluate/handle allocation. The saved CP42
source fails at WOS_PreviewClear; direct-call CP43 passes. Move Render/Select/Clear
before their first callers rather than adding a local forward-call wrapper.
Compiled traversal of Clear/Select/Render and slot-badge rendering finds no
thread dispatch, ability handles or allocation (9 reachable functions).

Also replace owner-local ExecuteFunc(SCOPE_PRIVATE+"WUI_RefreshSlotBadges") with
a direct call; place badge/key helpers before capture handlers. If optional
slot-overlay/hint frames do not exist, return without rendering. No focus or
new timer changes. Do not claim the native disconnect mechanism established by
this interpreter; a category click is the reproduced code-path regression,
not a Warcraft network execution. Native two-client acceptance remains required.

One-level Erza T/G1/G2 QWER were registered maxLv5 in UniversalTooltips, causing
ListCooldown/ListMana/ListRealField to read unused levels and append zeroes.
Set registration count1 from actual object data. Tsuna form Q/W/E/R metadata
also becomes1; Takeshi Cambio already has1 and is regression-checked. Do not
strip arbitrary slash-separated values: hero-level bonuses may legitimately
have lists. These changes affect tooltip metadata, not ability object levels.


### Runtime UI dispatch audit — CP44, 2026-10-16

User reported Z desync after previous window/picker changes. CP43 compiled
baseline still contains TMP_OnKey -> TMP_ShowWheel -> WUI_EnterWheel ->
TriggerExecute and Emoji_ShowMenu -> the same callback dispatcher. HUD expansion
also reaches WUI_SetHud -> TriggerExecute. Thus moving window callbacks to a
shared event in CP42 did not remove the separate owner-local wheel/HUD thread
paths. Native frame value hooks additionally compile into evaluate trampolines.
The precise Warcraft disconnect mechanism is not established by this evidence.

Replace runtime registries with direct cached frame setters/passive state in
WOSUI. Preserve Z/K cancellation/repeat/release semantics, preallocate ping mouse
triggers once, move dependent helpers before callers and remove native value
hooks in favor of explicit wrappers. Reuse existing shop/HUD timers for revision
consumption; drain shared hero requests before purchase/sync processing. Career
open now renders its already-loaded cache; bounded startup file parsing remains
separate. Shared startup UI allocation is intentionally retained.

Verification: check_wos_ui.py integrates tools/audit_wos_ui_dispatch.py, auditing
all31 enabled frame sources /387 compiled direct frame functions and27 critical
roots, including implicit JassHelper dispatch. Explicit GetLocalPlayer branches
are traced for allocation/dispatch too. The final packed script must pass the
same audit. Existing mock tests plus new direct setters/revision/queue/wheel and
asymmetric minimap/info/stat-mode tests exercise production functions. These
checks are not native multiplayer acceptance. Architecture contract and latest
checkpoint are in docs/ui-redesign/ARCHITECTURE.md and RESUME.md.


### Required mode startup and mouse subscriptions — CP45, 2026-10-16

CP44's initial slider sync became a direct call before scheduling the mode/pick
phase; optional native UI failure could abort the required startup thread.
CP48 adds a requested5s shared delay: InitTrig_ModeDialog schedules its one-shot
first; WOS_ModeDelayExpired destroys it and calls WOS_BeginModeSelection. The
20s choice countdown starts after the delay, preserving full response time.
WOS_BeginModeSelection schedules timeout/countdown and selector before optional
setup; initial slider sync moves to the existing camera tick. A failure-injection
regression confirms fallback launch survives. This is boundary evidence, not a
native reproduction of the user's stalled game.

CP54 supersedes the following CP45 input design: TeamMapPings has no MOVE registration at all. Do not restore either permanent or demand-created MOVE.
Historical CP45 rationale: do not register permanent EVENT_PLAYER_MOUSE_MOVE just to disable its trigger.
The user reports idle ping overhead with that CP44 design. Restore demand
registration/destruction in agreed Z events; first captured world point ends it.
Local close requests synchronize an epoch before destroying any handle. K has no
network mouse subscription; it stops ping tracking and uses local polling only
while its wheel is open. Preserve direct mutual wheel closing and cancelled-key
latches. The new narrow compiled-audit allocation exception applies only to
shared TMP_TrackMouse from TMP_OnKey; local-frame paths still reject allocation.


### Input lifecycle and initialization completion — CP46, 2026-10-16

QB_OnMouse is an inventory pickup/drop owner, not a world-RMB subscription.
RMB sampling was in QB_CheckDrag under the existing debounce callback. Requested
physical activation is now a separate disabled trigger per player, attached to
that same timer expiration; only agreed shop transitions enable it. Keep passive
revision work on the original callback so closing a disabled input still cancels
drag/render safely. No local trigger enable or Execute dispatch.

Missing F2 badge/click indicates registration may not have been reached, because
CP46 only moved row allocation; binding still followed shell, F3/F4 setup and
headers. User confirmed this did not restore F2. CP47 starts a finite agreed
17-tick builder from the ready callback: F2 binding first, shell, headers,
action controls, F3, F4, ten separate rows and final window binding. Ready gates
opening until completion. No runtime construction/Execute was added. Regression
now executes the real builders AND WUI hotkey helpers, mocking native boundaries
only, and verifies all60 item controls,3 badges and input entry points. This
removes remaining combined startup-budget exposure; the exact engine abort
cause has not been reproduced or proved. Do not call the earlier hypothesis a
confirmed cause. Native F2/click/multiplayer acceptance still requires game testing.

Placeholder docking: WUI_PlaceRight stores width for later viewport reflow.
A subsequent BlzFrameSetSize cannot fix a stale stored width: Hide UI was .056
in the dock but .042025 onscreen until the next viewport refresh. Register its
final WUI_TOP_ROW_W and offset directly, matching the final Hide UI control.

Dead native heroes can have nonzero corpse life after transformations: use death
status to render0 HP. Keep dead HP/MP bars; for hidden dead units retain cached
mana without reading hidden resources. Burner moves to common charge progress;
continuous display must remain separate from Tsuna's discrete gameplay check2.
Surrender must be permitted on base as explicitly requested: queue one result
and route base through the existing round-end owner instead of parallel scoring.

### Numeric damage attribution (CP50)

A shared damage event can run nested procs/reflection; a single mutable "current
spell" read after those procs misattributes the original hit. DamageSource(id)
in Systems2 sets a one-shot rawcode. Damage wrappers consume it before their
native call, restore the previous active source afterwards, and consume even
when a target is dead/null. DmgSys snapshots active source at event entry.
DmgPTime/NextDmg capture it on the instance and reapply before each deferred hit;
Erza elemental effects carry the creating ability/item, with fixed Kurikara and
Murasame item IDs. Generic AOE helpers capture once and reapply per target.

The optional DamageStats collector receives the final post-shield value at the
existing F2 hero-target boundary. Storage is numeric hashtables, no new per-hit
strings or handles. UI-only source names/icons and local sorting never feed
combat. F3/F4 preserve real Round/Game history and operate on Counter.
`tools/audit_damage_sources.py`, `test_damage_stats.py` and compiled UI dispatch
audit verify coverage, nested restoration, invalid targets, numeric totals,
reset/load, round snapshots, ranking, visibility and disabled compilation.
Native effects without a script tag are shown explicitly as Other/native;
ordinary controlled summon attacks map to the summoning ability. Modifiers added
to an existing attack stay within that attack's source; the collector does not
change combat to split multiplicative bonuses. Runtime multiplayer is untested.

CP51 presentation follow-up: DamageStats used SetScale followed by SetSize with
width/scale and height/scale, unlike the working Scoreboard text constructor.
User screenshots showed names, amounts and headings outside rows; the shared
source tooltip was also pinned to an unrelated screen coordinate. Physical
text bounds + F2 setter order, separate aligned header cells, owner-relative
source tooltip/AllPoints text replaced that path. CP52 supersedes the icon shades
and flat stripes after actual engine screenshots exposed white overlays.
Native bounds/constructor tests are in test_damage_stats_layout.py; screenshot
acceptance still requires Warcraft. Collector/round/reset/sort code is unchanged.


CP52 DamageStats: the compact view was still registered in the right-hand WUI
column. It now has an independent upper-left toggle under TopActionOwner, with
collapsed state preserved by Hide UI. The white number background used white.blp
and vertex tint; user engine screenshots showed an opaque white block over the
art. Removed it: full-square source artwork, separate dark textured number line
below, larger rounded k/m labels. No white-tint dependency remains in this owner.
Player rows are WUI_CreateFill/WUI_SetValue bars over bar-back.tga, with ten
precolored textured fills matching slot colors. Normalize to the leader, or to
player total in the source detail view. Names are on the bars; heroes use portraits.
Shared startup caches fixed icon paths for 268 scripted abilities from editable
objects, in addition to the 31 item entries. No per-hit strings/handles were added.
All 298 imported artworks decode; BTNBarrel is a stock-game path. Constructor
bounds/source/reset tests and compiled dispatch audit pass; native font/texture
appearance and multiplayer still need engine acceptance. Asset generator:
tools/build_damage_stats_assets.py; catalogue regeneration: audit_damage_sources.py
--write-icons. Source: triggers/WOS_Start/DamageStats.j and CP52 in RESUME.md.


CP53 DamageStats: engine screenshots still showed totals outside bars and hover
instability despite CP52 geometry passing. Runtime reanchoring/resizing + scaling
TEXT and competing BlzFrameSetTooltip/manual ownership were removed. Fixed font
height (BlzFrameSetFont, unit frame scale), value RIGHT-to-fixed-bar RIGHT anchor,
constructor-only row geometry and count-only window sizing replace that path.
One manual tooltip anchors on enter and hides on matching owner leave; source
artwork and digits share one hit rectangle. Hover pins displayed source slots
until leave, while recording and tooltip amounts continue; mouse leave only hides
the tooltip/marks dirty, and the .25s timer flushes pending rows. Click handlers use
one ResetClickedButtonFocus, never RegisterPassiveFocus plus another cleanup.
No mouse/focus setter runs in enter/leave. Native cursor behavior still needs
engine acceptance; these changes remove the conflicting paths, not prove a
physical cursor-warp cause.

Dealt pages0..3 and Taken pages4..7 share numeric storage, but collection never
reads local UI direction. DamageStatsRecordHit mirrors a final hero-target hit
to attacker/victim buckets. It uses F2 per-hit R2I precision before splitting,
so accumulated fractions cannot cross the display rounding threshold ahead of
F2. Source shares can remain fractional; the actual combat hit is untouched.
7038 ->7.0k,7051 ->7.1k,7501 ->7.5k. Compose decimal labels with integer digits,
not float R2SW again. F3/F4 and round snapshots operate on both directions.
Quincy Cross's existing flat addition captures its ratio before DamageCheck;
only the final statistic is proportionally split into I023 and the original
source after mitigation. No second damage event and no balance/HP logic change.
This attribution convention distributes later flat reductions proportionally.
Test_damage_stats covers mirrors, neutral attackers, F2 precision, Quincy shares,
reset/load, snapshots, sorting and no hit-time strings/handles.

### Idle UI stalls and frame-only Z input — CP54, 2026-10-17

Cause/evidence: Systems1's enabled desync probe was called by LearnHeroSpells,
which base regeneration repeats. Each active15s probe performs whole-map group
enumeration and repeated full Preload file rewrites; when a window finishes the
next base refresh starts another. Its1500-line cap never stopped the writes.
Disable via WOS_DESYNC_PROBE_ENABLED=false at all entry points and statically
exclude learning-call sites; do not enable diagnostics in normal builds. This
removes demonstrated work, but does not establish the engine FPS stall cause.

CP54 replaces both old MOVE listener variants with five fixed BUTTON events and
one terrain click. Shared precreated disabled click triggers are armed only by
agreed choice events; owner click/RMB/Esc/newZ/K/modal/timeout disable them.
Timer liveness depends on shared pending/cooldown/effect state only. No mouse
position/button polling in TeamMapPings. Keep Z/K mutual exclusion.

Other confirmed waste: AHUI hid and alpha-reset native placeholders repeatedly;
AR scanned14 heroes/inventories20Hz while the ownership cache needs4Hz; closed
F2 still had an always-running clock; shop formatted every open player's six
unchanged item cells. CP54 adds changed-only setters/metadata, slower data polls
and inactive F2/ping timers, preserving .05 hover and purchase/search behavior.
Production tests live in test_ui_performance.py, test_team_map_pings.py and
updated DamageStats geometry tests; compiled dispatch audit includes target
click. Operation counts prove removed calls/lifetime, not native FPS or network
acceptance. See RESUME CP54 and its diagnostics report for packed-build evidence.

### Native unit-message layout regression — CP55, 2026-10-17

Reported trigger: Patriot creates enemy/allied Raiden in Test Mode. Compare
recent changes before refactoring spawn: CP53 added generic frame layout calls
on ORIGIN_FRAME_UNIT_MSG, CP54 changed its size from .180 to .290. Both local
03:46/13:12 minidumps have the same native chain and a corrupted object vtable
(zero low DWORD); RDI/RCX object field+0x9c matches the respective assigned width.
The previous mock treated it as FRAME, which hid this native-type risk. This
is strong evidence for the introduced unsafe path, without symbols identifying
the exact setter or an engine reproduction proving the fix.

Remove that origin lookup/layout entirely. Move WUI_CreateFeed's custom TEXT
frames instead (+.240 X/-.020 Y from CP54). No spawn timer workaround or hero
gameplay changes. Test_damage_stats_layout guards against the native path and
executes the real custom-feed constructor at four aspect ratios. See RESUME
CP55 and diagnostics 20261017-native-message-crash/crash-evidence.json for
dump details and source provenance. Fresh game validation remains necessary.

### Missing environmental damage and repeated key forwarding — CP56

CP55 crash removal is user-confirmed. Keep the engine unit-message region alone.

Direct SetHpCurrent losses from train collision/explosion and end-round Sukuna
never enter DmgSys. RoundSpells.EnvironmentHpLoss observes actual before/after HP
around the same setter, then optionally records it. Do not replace these paths
with UnitDamageTarget: that would introduce resistances/procs/death-credit changes.
Car/barrel/transformer/hydrant explosion helpers and elemental reaction instances
now carry separate numeric source tags. Native unknown nonattacks use their unit
type instead of grouping every untagged event as Other/native.

Taken sources previously merged all attackers. DamageStatsTakenSource interns
numeric (source, owner, unit type) identities into precreated tables and stores
integer metadata. UI resolves names/icons on demand, including hero portraits for
attacks and owner tooltips/subtitles for spells. Snapshot/copy retains those IDs.
No per-hit strings or handle creation. Actual mitigation/combat hits are unchanged.

Custom slot forwarding previously accepted repeated downs and could reenter via
ForceUIKey. WUI_AcceptKeyDown runs as a condition before actions, latches until
key-up and caps synthetic alternating edges at10 Hz. Both edges are essential;
use one monotonic timer, never allocate or send sync for rejected repeats. A local
WUI_UseSlot guard prevents recursive synthetic forwarding. Existing test fixtures
need Condition/TriggerAddCondition boundaries; real gate lifetime/limits are
executed in test_ui_performance.py. These prove operation counts, not engine FPS.

See RESUME CP56 and diagnostics 20261017-damage-sources-input for source/map
backups, geometry previews and final build verification. Native source hover,
smartcast physical behavior and multiplayer need Warcraft testing.

### Resize drift and missing Saber G identity — CP57

DamageStats used an aspect-derived absolute point only in its constructor, so
it drifted after a Warcraft window resize. Cache WUI_ScreenRight and reanchor
compact/toggle on the existing .50 clock before checking whether views are open.
Feed reflows on its existing .25 clock, with its own TEXT-only positions. An
unchanged viewport must do no frame setters; do not restore native unit-message
layout or create resize polling triggers/timers. Shared Game Info environment
icons are now WUI_InfoSourceIcon; stats must not invent alternate generic art.

Saber G's charging loop was started only by EnterBase, while test creation is
outside base. LvlUpCheck now starts it as well. AlterSaberW_Start must remain
idempotent per unit, and cleanup must clear that marker. The charged autoattack
used a W2 damage tag A05F; replace only that proc's tag with A02F, not all W2 hits.
NextDmg route0/delay .06, raw damage and charge/cooldown remain unchanged. Tests
run the actual public guard/proc for original/test owners and all passive tiers;
native game acceptance still requires testing. See RESUME CP57 for build proof.
