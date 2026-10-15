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
