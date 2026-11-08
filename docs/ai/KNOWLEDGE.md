# Долговечные решения и известные исправления

Проверка указателей: 2026-10-11. Подробные разборы уже существуют; здесь только
маршрутизация. Их исторические результаты не доказывают состояние текущей карты.

| Когда читать | Сохранённое знание | Первичный материал и проверка |
| --- | --- | --- |
| TEST собирает старую систему/не того героя | shared-источники берутся из MAIN, TEST имеет свои overrides и замыкание зависимостей; перенос героя не переносит объекты/ассеты | [test_map/README](../../test_map/README.md), [hero workflow](../../.claude/skills/wos-new-hero/SKILL.md), `tools/test_test_map_workflow.py`, `test_hero_transfer.py` |
| Добавление триггера меняет чужой текст в редакторе | WTG traversal и WCT payload должны сохранять соответствие идентичностей и порядка; не склеивать их по случайному индексу | `tools/sync_war3_triggers.py`: `validate_editor_order`; `tools/test_sync_war3_triggers.py`: `test_main_push_inserts_new_start_trigger_before_later_categories` |
| Пропали поля рангов / двойное списание маны | `repair_main_ability_levels.py --levels-only` восстанавливает все ранги без перезапекания текста; ManaFix использует GearTimer03 и учитывает scripted delta SetMpCurrent/MyAddMana | [MAIN_ABILITY_LEVEL_REPAIR](../../MAIN_ABILITY_LEVEL_REPAIR.md), `tools/test_main_ability_levels.py`, `tools/test_cast_mana_fix.py` |
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

Cause/solution: Fast Sell restored ItemsCurrentItem_ID_BACKUP even when zero/stale, generating an invalid tree. Clear all agreed selection/scroll/branch caches, then owner paint, and guard zero-id/delayed scroll; CP70 sale uses ShopSellInventorySlot: price/refund lookup and removal refer to the same live slot handle; clear refund before removal and credit only once. Never price a sale from ItemsCurrentItem_ID (stale during pause). Full refunds now use six bounded item-handle/deadline records per unit (ShopRefundData), read by the price renderer, sale and component consumption. Slot-only marks lost identity on moves and reused MyFlush deadlines could expire a later purchase early. A new purchase gets its own 15 seconds; cleared/consumed records cannot transfer refund credit to replacements. See test_shop_refund_bans.py; native input remains unverified. HUD icon covered minus near original rim: FIX6 makes preview .028 and moves own SIMPLEBUTTON below art to ItemY-.0190; engine input still unconfirmed.

User confirmed earlier NOQB/FIX4/FIX5 Save Keys no desync. FIX6 adds only packed F fast buy/sell flags to existing settings flow, never QB queue save; agreed sync is required because these modes affect actions. Old settings remain supported; new extension needs native two-player retest. P ability-chat commands likewise resolve identity/CD only after agreed sender/hero/sequence validation; local hit testing sends command slot, cached frame rectangle and held-edge guards avoid gameplay/handle allocations. Existing .05 timer fallback and mouse event are deduped; independent 10sec per-sender gate uses ShopClock. No new periodic process. Evidence: 349 mock/static checks, compile and MPQ/WCT audit; 4133 protected functions unchanged; MAIN/old maps preserved. Source/report: C:/Users/Gear/Desktop/WOS_DIAGNOSTICS/20261014-quickbuy-fix6/REPORT_QUICKBUY_FIX6.md. Native hover/input/chat/preferences remain untested.

October24 test-unit sale: GetSelectedHeroForPlayer correctly returned TestUnit /
TestAllyUnit, but ShopSellInventorySlot rejected their combat owner. Its exception
now requires TestMode, the currently selected test hero and that hero's current
controller. Gold/refund go to the controller; combat ownership stays unchanged.
Normal and fast sell share this gate; unrelated foreign heroes remain forbidden.
Evidence: test_shop_refund_bans.py and the controlled-test-unit fast/button case
in test_quickbuy_fix6.py. Native multiplayer/frame input still needs game QA.

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

Kyoraku Takaoni (player-facing E2, code KyorakuE4_ID/A114) replaces E/A052 via
SwapAbility at hero level25; A058/KyorakuE2_ID is the separate shadow E.
A114 presentation is self-contained in base ability data, E cell(2,2), explicit
five tooltip levels, and BTNHero_Kyoraku_E2 (including disabled icon). Its own
queued callback481 avoids sharing callback333; Rimuru G-copy uses callback482.
CP62 supersedes the initial E2 timing: slash scale3.2, both damage cuts occur
on the same tick within100 of the cage center; flight continues650 beyond it
without a post-flight pause. Two extra blue effects use scale1/height175/pitch
±45. Cage expiry restores E immediately; the swap expiry retires harmlessly.
ShowCD has A114 metadata; Rimuru A113 is a one-level copied spell, uses native
G cell(2,1), and preserves maximum copied 2R damage in its single tooltip level.
stage_hero_packet_2026_10_18.apply_packet is idempotent and is called by the item
stager too. Registered F/G objects must use native F(1,1)/G(2,1); mismatches make
native cooldown overlays appear away from their relocated buttons. Fix objects,
without periodic UI rebuilding. Convenient ability JSON omits level fields above
actual alev; raw objects retain these fields for lossless roundtrip.
See RESUME CP61 and `_build/hero-packet-20261018/publication.json`.
Native rendering still needs Warcraft verification.

Central targeted debuffs (Systems1 BuffUnit01/02, Silence/Armor/Stun/Doom/Root/
Slow/Curse variants, BuffUnit1/2) and Erza debuff helpers select/create their
existing dummy from the TARGET owner's player index. Keep c as damage source.
No extra dummy pool, visibility timer or per-cast teleport is needed. Target-owned
Slow dummies require ally/self-capable filters in A1OT/A03U/A108; otherwise changing
the array index alone silently rejects their orders. Tests cover owners2/23 and
reuse. Crocodile channel resistance preview reads the shared scalar
SH_CROCODILE_T_CHANNEL; local UI getters must not use TriggerEvaluate/struct
dispatch or write synchronized state. Hashirama Cells uses TimedStr's existing
buff loop to restore charges15 once after Warcraft's post-SPELL_EFFECT debit,
then clears them on expiry; no new timer or repeated charge writes. Shun Shun
Rikka aura text is18%; Ashisogi poison .4AGI, physical spell damage only and
explicitly excludes native attack events (including physical-tagged attacks).

CP62 range geometry: UniversalTooltips.GetPreviewRadius and GetDisplayedRange
share ARules_GetImpactReach; RefreshSkill prints the same value in Range.
Fixed-flight rules include launch offsets, last damage sampling and collision
radius. DarkShiki T is140+2100+250=2490. Point-target fallback adds actual impact
radius; unit-target secondary search/jump/aura radii do not extend acquisition.
Bounded pure numeric helpers allocate nothing and change no game state. The
existing >2500 renderer limit remains. Audit MAIN rules, not TEST's older copy:
tools/audit_hero_range_sources.py; 390 HUD buttons have object metadata,28 fixed
flight examples have source-probe assertions in test_hero_impact_reach.py.

TestUnit_FastStartReady counts active humans plus each test hero once, using
current coordinates in gg_rct_Go. Test owners already have Hero[] entries;
counting both double-counts the RightArrow ally and blocks fast start. Native
shared vision follows both test heroes for their controller; sight radius1800.
Saber F uses permanent Channel pair A02C/A115, explicit player availability and
AHUI swap metadata, no swap timer. Off2.5% current MP free; on15% with equal raw
MP cost per attack. Initialize first grant to clear stale replacement state.
See RESUME CP62 and `_build/hero-refinement-20261018/publication.json`.

CP64 supersedes CP63's added attack-type icon: it is removed from the HUD and
the original number inset.0145 restored. WUI_AttackDamageColor reads live weapon0
UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE;4 means blue magical, all other current types
red physical, matching DmgSys native magic detection. WUI_AttackDamageText strips
embedded stock white/green codes before coloring the complete number, including
bonus/penalty. HUD and pick preview share this formatter, no extra timer or state
writes; missing pick dummy uses red (all current base hero objects use hero type).
Raiden/Starrk form weapon changes are reflected on the existing render clock.
Tomioka E is0.9 Attack per hit with base2/3/4/5/5; G bonus is deliberately added
AFTER the base cap, one hit per3 stacks. Keep runtime and object tooltips aligned
through TomiokaE_AtkCountMax and stage_hero_packet_2026_10_18.py.
Windows watchers may reject direct truncation or replacement of unchanged
metadata. war3_object_data.dump_text/dump_json skip byte-identical content and
replace a fully written sibling atomically; extract_war3_triggers uses this for
the dependency JSON and README too. Replace failure preserves the previous file
and removes the temporary sibling; test_war3_object_data covers this contract.

CP65 common performance (2026-10-19): ordinary casts no longer subscribe to
TooltipBuilder's whole-hero rebuild. Formula-only damage text removes all
DamageCheck calls and changing evaluated totals from UniversalTooltips, including
its poll. Poll5s; level/skill/item/form events remain explicit. applyToAbility,
Learn and Item compare final native text before writing. Milim threshold bonuses
modify the displayed coefficient, preserving their meaning without computed HP
damage. DamageStats collects every hit immediately, but redraws/hover values use
ten existing.5s ticks; opening/paging/roster bypass the gate. Source-kind lookup is
once per record rather than once per bucket. Empty shared event dispatch skips
context copying/TriggerExecute; new listeners MUST use GearDamageAddListener or
GearSpellAddListener. Active/nested callbacks retain previous context semantics.

HUD non-vital stats use five existing.2s ticks (user chose1s), while HP/MP stay
fast. Custom CD text uses integer seconds and reads ongoing cooldowns once per
four existing.25s refreshes; ready slots and ability/permission changes reset the
gate. Availability/Swap resolution retains.25s, hover.05s. Unit/type/column/hover
changes force a new stat read; a repeated F1
selection does not invalidate the timer. Selection handlers skip same-unit work;
TestUnit only reconfigures alliances when the controller actually changes.
Portrait camera resolves the currently selected portrait rather than Hero[pid].
CP69 moves custom camera/voice clicks to the level plate: the enabled native
portrait must remain free of BUTTON overlays for engine spell targeting. Bind
it to the passive owner for visibility/layering; CP71 replaces AllPoints with
explicit native BOTTOMLEFT/TOPRIGHT bounds and viewport conversion. Native portrait X spans
0..0.8 across the whole screen; normal frames use the centred4:3 region.
WUI_PinNativePortrait reads the registered owner geometry, scales X/width by
4*height/(3*width) around .4, and reasserts on each readable HUD paint, HUD shift
and native restore. Skip zero-size windows; use cached handles only.
Reason: user screenshots confirmed large/off-cell native portraits after CP69.
Level-only hover carries a one-line camera/voice hint; long voice tooltip removed.
Checks: test_ui_vote_followup projects five resolutions and three HUD shifts,
repeated repairs, minimized clients and no allocation; checkpoint30 hover bounds.
Engine acceptance remains pending. Coordinate reference (Tasyen):
https://www.hiveworkshop.com/threads/problem-with-re-positionating-the-unit-portrait.355103/
Tomioka lower +damage plate was a separate native TasBox frame, now removed along
with its creation/polling; corner stack count/gameplay remain. Dark Grail B01P
text now20 HP/sec (heroes),6 MP/sec,20% MS,1500 radius; B01Q30% less active healing.
Stationary range hover skips terrain/effect positioning until XY/visible effect
changes. There are no terrain-deformation writers in current MAIN. Native RNG
sequence, hit frequency and gameplay setters were preserved. Tests count skipped
operations, not Warcraft FPS; an A/B game profile is still needed to attribute
remaining action/cast drops. Evidence/report: `_build/performance-20261019/audit.md`
and RESUME CP65.

Custom ability tooltip presentation uses a fixed cache of seven slots x two
modes/player, not extra frames. Keys: unit/type, ability/level, hero level/skill
points, settings, TooltipTextRevision and a5s epoch for native writers outside
TooltipBuilder. Title/raw text/mana and decorated text are reused; same native
values do not rebuild or reset layout even on epoch/revision revalidation.
TooltipBuilder increments revision only after an actual ability/research text
write. Never let the cache bypass visibility/native-command/privacy checks.
Changing slots applies ready strings to the same existing tooltip frames.
Tests cover200 identical hovers (one metadata read), returning to a cached slot,
unchanged epoch no writes, changed native description and integer1s CD cadence.

Kyoraku third-act final ability A059/KyorakuT4 has G, replacing A0DY/Skip Stage;
mapping it to T hides the enabled real G and its initial CD. Register both variants
in G, retain gameplay availability hooks. Finisher motion now stays inside KyorakuT4_KS:
integer cinematic ticks (60/90/191/200, cleanup after205), bounded700-distance
pass-through over1.25 seconds after contact, no wall/CC-controlled external MUE.
Previous cleanup executed damage even on cancellation and skipped target release
at exactly1.8 seconds. Now release captured units before one10xAgi physical hit /
1.5s stun only on successful completion; cancellation/dead/invalid targets never
execute. Source/mock evidence: tools/test_pick_kyoraku_final.py (including movement
blocked, simultaneous casts and exact capture-tick cancellation). The user's
engine-level indefinite stall is not independently reproduced in Warcraft. Harribel's morph code still had six old
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
InoriW_GetHealTotal includes +2x INT at hero level35+ for the allied branch
before the existing29-pulse split; enemy and active-E branches stay separate.
Inori aura follow-up (2026-10-28): A09S remains five learnable levels; A061
is a non-hero six-level service aura. InoriE_UpdateAura (Systems1, before
LearnHeroSpells) selects rank 6 only at hero level25+, E rank5, T1/default
selected and outside T2. Ultimate confirmation, learning, hero levels and the
existing E tick keep it current. T2 choice restores rank5; active T2 calls
SetPlayerAbilityAvailable plus BlzUnitDisableAbility(true,true) on A061,
then restores both at cleanup. Do not dispatch this helper through evaluate
from LearnHeroSpells: pick/frame paths must stay direct.
stage_inori_aura.py assigns B064..B067 to ranks1..4, B00I to5, B068 to6.
Native Had1 is zero: DamageBlock applies exact 1..5% physical /5% magic
resistance, or10%/10% for rank6, using the highest present marker. This avoids
native armor-rating conversion or double-counting. No global caster/boost
flag may suppress another Inori aura. Instability checks accept all ranks
and exclude Inori owners currently in T2.
T2 A153/B062 has1400 radius (matching normal E) and10% physical+magic
vulnerability; A153 itself is hidden while E2 A06D describes the aura and
beams. UniversalTooltips registers E2 in its own staggered job491 and in
HeroData extras. test_inori_aura.py executes selection, levels, exact damage,
T2 start/cancel/restore, Instability exclusion and repeatable staging. Native
aura propagation/linger and multiplayer still need Warcraft verification.

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

DamageStats hard-off diagnostic (2026-10-31): DAMAGE_STATS_ENABLED in
triggers/WOS_Start/DamageStats.j is now false. It is a build-time master switch
for the L/Open Details/Previous Round panel, including TestMode. DS globals no
longer allocate handles; DS_Init allocates seven tables and two timers and
registers WUI_OnReady only in the true static branch. All external callers in
DmgSys, RoundEnd, Starts, picker and Scoreboard are statically gated, including
native source lookup before the final hit filter. False therefore has no
collector calls on combat paths, no hotkey/click registration, UI or polling.
True restores the existing feature after rebuild; this is not a live toggle.
Existing F2 scoreboard and shared DamageSource attribution remain independent.
Potential freeze contributor, not proved in engine: the previous DS_Tick folded
up to 20 pending buckets of 400 source keys into three histories in one 5-second
tick; DS_FoldSource may scan 12 retained rows per history. Overflow also used to
flush every player inside a damage callback. This is now a FIFO ring per bucket
with a shared budget of 16 distinct source folds per existing .50 s tick, rotating
across players/directions. Repeated hits still coalesce before processing.
Overflow drains one entry of only the full bucket. F3/F4 and round rollover
still drain all pending entries for exact boundary totals. New hits between
slices, consumed-key requeue, FIFO wrap and overflow are covered in tests.
Totals transfer once per touched bucket while source rows catch up by slices.
Hidden UI still collects and processes budgeted slices when enabled. Rendering itself is throttled to 5 s,
hover polling to .10 s. Compare the same high-DPS fight with false/true before
claiming this is the cause; no gameplay/performance watchdog was added.
Checks: test_damage_stats (disabled allocation/TestMode + enabled startup),
test_damage_stats_layout, both flag values compile, packed disabled call audit.

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


Item debuff lifecycle / proc cycles (2026-10-28): Loop_Elemental must branch on
`alive`, advance its per-second accumulator only while active, and destroy both
owned effects on buff loss or death. An unconditional outer branch previously
made cleanup unreachable. ErzaPas_Start deduplicates target + effect kind,
including the native dummy delivery window; initialize both effect handles and
itemRefreshes on every reused struct slot. Evolved zanpakuto must not remove the
buff to refresh it or apply it twice on a hit whose explosion is also ready.

Final refresh contract: Fire (including Zanka no Tachi) has no duration/refresh
cap. Other shared elemental/poison debuffs allow one item-driven refresh after
the initial application; ability damage may refresh indefinitely and does not
reset the spent item allowance. Pass the original damageSourceId to ErzaPassive
before its attribution is converted to the elemental/poison source; explicit
item casts already supply their item rawcode. AllowApplication owns the budget;
Kyoka's Steam refresh uses the Steam instance's budget as well. There is no
blanket 10-second cap. Native expiry/dispels end the instance and its budget.

ItemDamageCanProc in Systems2 rejects elemental/reaction tags -101..-111 and
Kurikara/Ashisogi/Murasame periodic item sources, plus Mirror of Yata
reflection I02H (so reflecting an elemental tick cannot restart the proc chain). DmgSys uses the snapshotted
source for offensive item follow-ups, including Tachikaze, zanpakuto, Earth
Power, Shiki Knife and Guts/Death Note. A zanpakuto explosion also rejects its
own source. This keeps a Ryujin explosion -> Kurikara application legal while
stopping burn/poison -> item -> burn/poison feedback. Never replace this with
only a synchronous guard: deferred hits retain numeric source attribution.
Blood Pact Ring Evolved (I073 / A154; stage_blood_pact_evolved.py) costs 7500,
uses Ring I06D (2500) + Pakkun I01J, and grants A00W (+20 allstats). Its 5-sec
25% mana floor uses GearManaFloorStart/Apply in Systems2, one lazily registered
GearTimer03 listener for all affected units, and expires on death/round change.
Apply also runs after SetMpCurrent and native ManaFix payment boundaries;
GearManaScriptChange tracks the refill separately from native spell payment.
Five Elements Seal blocks both the initial refill and subsequent floor refills.
No per-unit timer or mana-cost bypass is introduced.

Return by Death (I059 / A13E) is backed by positive Inner Fire buff A155 / B063
(stage_return_by_death_buff.py). ReturnStart records a four-second deadline on
HealRegenClock; ItemsAnimeEffect checks buff presence before the deadline branch.
Kairoseki UnitRemoveBuffs(true, false) or another positive-buff dispel cancels
the instance permanently. Finish removes the buff and both effects on success,
cancellation, death, unit removal or round change. MyFrameBuffSlot follows buff
loss. Native duration is 4.5 sec only to avoid racing native expiry; script
owns the four-second return and cleanup. test_return_by_death.py executes
deadline, Kairoseki, recast and cleanup paths; engine dispel rendering remains
an in-game check.

Samehada dispatch uses the native attack flag, independent of physical/magic
classification. The original Starrk E attack calls Samehada once before launching
Cero and zeroing native attack damage; piercing A0BJ hits no longer trigger it.
Samehada rejects both illusion attackers and illusion targets, allies and active
Tekkai targets. Tekkai rejects attack/native attack-type/A0BJ events at the start
of DmgSys before any hero/item on-hit dispatch, mana drain or delayed extra-hit
scheduling; ordinary spell damage continues normally. No item charges/cooldowns
are consumed by these rejected hits. Tests execute the actual early gate,
Starrk dispatch and Samehada implementation.
Tsuchikage Hat Evolved snapshots floor(GetAttack(c)/100) additional bounces on
cast, preserving its first hit, per-bounce damage falloff, slow and target search.
Item descriptions and staging now state these contracts (2026-10-28).
MAIN/STABLE publication passed: 5460-function parity, 7002 packed files, seven
extracted payloads match the scenario and contain the updated code/descriptions.
26 focused tests passed. Evidence: `_build/tekkai-samehada-main-build.log` and
`_build/tekkai-samehada-main-result.json`. Prior STABLE/root snapshots backed up;
final sync has zero binary/source differences. Game was not launched.
Kirito R quick/strong
packets use dmgphysattack: native attack=true, physical damage type retained,
with GearDamageAttackFollowup restored around nested damage. AttackCheck skips
KiritoR_Attack for those follow-ups, preventing recursive R packets. Quick:
2 hits at .05/.20; strong: 4 at .05/.30/.55/.80; divide each packet total by its
hit count. Strong start assigns NewDmg explicitly (never recycled struct dmg).
Blood Pact icons retain actual Button Manager PNG exports before BLP encoding;
its Evolved uses the existing project gold frame.

Evidence: test_blood_pact_ring.py covers mana-floor lifetime/seal precedence,
recipe/stats/prices, attack dispatch and actual Kirito tick counts/timing.
Evidence: test_item_debuff_cycles.py executes lifecycle, budget, unlimited Fire,
Evolved and source-gate paths with native mocks; test_ashisogi_poison.py and
MAIN JassHelper/pjass compile. Warcraft rendering/multiplayer remain untested.

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

### Hero mana costs and attack tooltip type — CP58

SetMpCurrent modifies negative as well as positive deltas under Inori's B00K.
Do not use it for an exact percentage-of-maximum-mana upkeep: Gojo E5 now uses
SetUnitState with the paid fraction of each .03 tick. The free window is2 sec
(user correction); after it,10% maximum mana/sec, no time cap,
and cancellation below100 current mana. Tests execute the production condition/
drain and confirm30% spent over3 paid seconds at different mana pool sizes.

TooltipBuilder damage type4 means Attack Damage; UniversalTooltips maps it to
DamageCheck kind0 (the same route as dmgatk). Attribute scaling is independent:
Tomioka E remains AGI-scaled but applies attack damage and attack effects.
Milim T2's level35 passive bonus is aggregate beam damage, divided by its tick
count; the charge label snapshots the same bonus as gameplay. Keep the tooltip
preview's threshold additions consistent. WUI_HeroProgressThresholds receives
the numeric damage thresholds and supports the dual meter's damage row.

See `tools/test_hero_balance_followup.py` and RESUME CP58/CP59. The35 errors seen
during CP58 came from restoring stale WCT implementations, not an acceptable
existing baseline. CP59 recovers working sources and the full regression suite
passes. Compilation still does not prove native rendering or multiplayer.

### Stale WCT inside a working STABLE — CP59 (2026-10-17)

The user-confirmed `STABLE/WOS2_MAIN_STABLE.w3x`, SHA256
`bdec96e8788f00f5b6282d6b3f99cf5af97a99162b59a68502de6c4a3b03362a`,
contains a newer playable script and an older embedded WCT. Importing that WCT
regressed75 source implementations: feed X=.560 instead of working.442, old
DamageStats contracts, lost cached SH_* keys and startup/ability hooks. Matching
a broken build to that same WCT and reproducing its failures did not validate it.

Actual source was recovered from
`backups/source-import/import-20261017-191315-821/triggers/`. Its independent
compile matches all2437 shared gameplay/UI functions and common global values
in the working script, normalizing JassHelper private names/code whitespace.
Regenerate native initialization from the working compiled script with
create-main-mapscript.ps1. All6630 reference payloads were compared; preserve
only requested ability differences and intentional pre-task Shiki/Milim edits.
Reference STABLE is read-only evidence, never a publication target.

Import now recompiles incoming WCT in a temporary workspace; the new
check_main_source_parity.py rejects disagreement with compiled code before
replacing project files. The supplied stale archive is confirmed rejected.
MAIN build requires WCT/source identity, compiles the full external source with
--scriptonly, independently verifies functions/globals, and only then packs that
exact script. It extracts the packed script and checks its SHA256. A trial legacy
map-mode invocation omitted imports despite exit0; parity blocked publication.
Do not rely on BUILD OK, a familiar archive name/date, or a failing old baseline.

Keep triggers, scenario WCT and root native snapshots synchronized after a
verified save/build. See RESUME CP59 for final tests/publication. Native visual,
physical input and multiplayer acceptance still need the user's Warcraft run.

## Chained ability swaps and late tooltip registration — CP60

An expired KS_SpellTimer must verify that its new ability still owns the
`AHUI swap <oldId>` marker before restoring availability or clearing the marker.
Otherwise an older Q2 window can expose Q1 during a newer Q3 window. Its timer
instance still retires/releases normally when superseded. Frieren's finisher
also clears the consumed-stage signal and explicitly uses Q3 object level1.
Production-body replay and expiry cases: `tools/test_hero_balance_followup.py`.

Missing previews for late heroes may be unregistered SpellData rather than a
bad radius formula. All builder startup groups now use480 small jobs, one ability
or one form per fresh ExecuteFunc budget, one job every0.01 sec (about4.8 sec
overall). Preserve global WOS_UTB_Init_* names used by queued strings; compiler
output must contain every target. This prevents an aggregate thread cutoff;
static tests cannot establish the actual engine cutoff or prove native rendering.
Keep F/G key-badge visibility separate from native tooltip ownership (ShowCD,
RESUME CP60); a visible badge does not mean a custom ability button is drawn.


## 0.33c instant cooldown and movement completion (2026-10-20)

KS_Cooldown/CD_Start only shortens a positive native cooldown; it cannot repair
an instant Channel cooldown cleared by a follow-up order. Brandish now requests
explicit CD_EnsureStart after shared CDR calculation. Its demanded05 timer alone
may restart a zero cooldown, subtracting elapsed delay; ordinary CD_Start keeps
its previous reduction-only contract. Production tests: test_followup_033c.py.

Laxus Q's final StopSpellUnit2 issued stop and set a .06s AHK gate; floating-point
subtraction could also defer impact completion. Q now completes with an epsilon
on total elapsed time, directly unpauses and restores the recorded order. Q2 releases the caster at lightning launch. Its casterReleased guard prevents
retraction/cleanup from re-pausing or unpausing a subsequent cast.

Alucard normal E now scans its launch area at the existing0.3s release before
moving the dog. Previously the first throttled scan happened after several100-unit
steps and skipped point-blank enemies. Launch/flight share Hit and g2, so a unit
cannot receive duplicate damage. RE's behavior is retained. Evidence:
test_hero_movement_followup.py covers close targets on both sides and distant hits.

Okarun F control was restored from the read-only 0.31c2 reference on 2026-10-24:
add only speed above native movement through MoveUnit along the current facing,
without interpreting knockbacks/native travel as missing forward movement.
Approach order retries use the reference .21s period and skip active casts.
Point moves do not follow saved unit targets. F caps total movement speed at
500/600/700/800/900 at hero levels6/12/18/25/35; the native T buff fixes total speed at1200
without decay. The normal cap is reapplied immediately when T expires, including
while stopped or paused. The imported MAIN T tackle/trail block remains unchanged:
per-target/per-caster .75s cooldown,450 knockback over.35s, no tackle while paused
(CP68). Source/VM evidence: Okarun.j, ClickEvent.j, test_followup_033c.py.
Engine pathing/turning/cast timing still require Warcraft; see RESUME CP67.

MAIN Crocodile R owns its hit clock/count per captured target: five hits within1s,
then pull only. Late contact no longer inherits a nearly finished global hit
clock; release/death cleanup retains the existing ownership list. W uses its800
radius in Q-contact/combo scans, with its pause snapshot halved at hero level35.
E recovery reads native cooldowns21/20/19/18/17. Evidence:
test_hero_movement_followup.py executes MAIN methods. The older
test_crocodile_balance suite has8 failures/1 error against both the imported map
baseline and this patch (older balance/native-field assumptions); do not restore
its previous mana drain, E/T or combo values over the saved map.


## Hell Blaze healing reduction (2026-10-20)

HellBlaze_HealCutPerStack=5.5 in Systems2 is the shared source for all seven
ranks (max38.5%). SetHpCurrent2 calls GetHellBlazeCut rather than maintaining
its own multiplier ladder; passive regeneration uses that same helper through
GetHealMultiplierNoBlock. This avoids drift between active heals and regen.
I02F text, A0E6 rank tooltips, B01S/B01T/B01U/B01V/B01W/B02E/B02F descriptions,
and the October18 staging generator match5.5%. Native rank text also reflects
the existing 10s duration. Full-stack mana burn is now 1.35% maximum mana per second.
The HP heal-amplification tooltip preserves one decimal place. Production VM
coverage in test_followup_033c.py tests0..7 stacks, active heal/regen agreement,
remaining lower-rank buff priority and object text.755 regressions PASS (5 skips)
and compile/parity PASS. Native gameplay remains an engine acceptance boundary.

## Frostnova and current TEST shared sources (2026-10-20)

2026-10-24 release supersedes older asset/balance notes below. Canonical packet:
`assets/FrostnovaRelease/manifest.json`; current balance is in test_map/README.md.
Saved TEST objects require WTS resolution and war3mapSkin merging. MAIN gets Ainz
spell mana while TEST remains zero; helper mana/cooldown must stay explicitly zero
in both. The old transfer stripped helper `amcs=0`, restoring native costs and
preventing dummy buff casts. Dedicated F/anti-heal casters belong to Frostnova's
owner and use the working common-helper target flags. Rawcodes are collision
checked. T's A1F2/B0F3 uses native Frost Armor (five-second normal/hero durations),
so it cannot replace E's Inner Fire marker. Starts owns MAIN Shielded art; TEST
uses native buff art. DmgSys consumes one positive enemy damage event under the
normal full-shield/piercing rules; actual T2/T3/T4 playback renews it.

MAIN-only shield follow-up: the shared FrostnovaDummy also receives Slow/E buff
orders, which can replace a queued native Frost Armor cast. FrostnovaState now
owns one dedicated shieldCaster, moves it to the hero, recreates the native spell,
disables autocast and resets its cooldown on renewal. Do not remove the existing
hero buff before recasting: a rejected/interrupted recast must not erase it.
The native five-second object duration remains authoritative; no extra timer or
forced Shielded graphic. Starts reads the real buff. The caster is freed when
its hero is removed. Tests simulate same-frame native order replacement for each
T2/T3/T4, renewal after consumption, preserved existing protection and Starts art
eligibility. Native engine playback still requires manual acceptance.
Frostnova maintenance now targets MAIN only; leave its old TEST snapshot and
Altair's active profile/files/archive unchanged. Growth: STR 1.20 / INT 2.25,
AGI unchanged. W_FOG_EMISSION_SCALE=.8 trims W fog density without texture edits.

Object rank skip is explicit (4), F requires `h002` / `12 lvl` and a level-12
guard, T uses the same button slot as Frieren. Native descriptions are brief;
TooltipBuilder owns damage/mechanics. Q recharge/range and R lifetime scale by
rank in both native objects and code. R's preview uses its actual radius, not
cast range plus radius. TQ uses mixed blue/black material only in flight; the white orbit remains intact.
TR's edge tracker roots each target once per field when it crosses from inside
into the 100-range outer band, retaining four trap crystals until expiry on the
existing 0.03 listener. Crossing within the field or blinking beyond the outer
band does not apply the exit root. Keep the negative target-handle marker until
field cleanup; a two-second rearm caused repeat roots. CastCheck must only gate
movement on the real BEer buff (with its existing CC-protection exceptions): the
removed Frostnova_TrapsMovement hook treated mere presence in TR as a permanent
root, suppressing blinks/dashes after the native root expired or was dispelled.
The start/exit RootUnit calls belong to FrostnovaR_KS, not the global cast gate.
Checks: test_frostnova.py executes DisableMoveRoot with both field variants,
root expiry/removal and outer-band crossings; engine timing still needs game QA.
Environment effects use ordinary DecorRemove (Natsu/Milim), not Crocodile's
DecorRemoveLine: real AoE, 0.12 sampling on Q/W and one-second R decor pulses.
VisionTimed uses 2x Q/W radius and 1.5x E/R radius. Burst E and field DPS are
separate formulas; R is 1x INT/sec, TF 0.15x INT/stack/sec, TE 0.75x INT/sec.
Orbiting ice stays white with separate mesh-free dark particles; TQ flight keeps
blue source textures and adds one translucent black-ice material layer.
polish_frostnova_effects.py changes only fog emitters in W, retaining ice records.
Shared tooltip notices now use red Iframe lines after description/bonuses and
before the blank stat separator. T_CastAuto/T_DurAuto/T_Invul keep their existing
gameplay metadata; false/zero invulnerability emits no notice. FilterIframe splits
those lines in all three generation paths (learn, initial learned, live refresh).
Winter's Scar bonuses always start on a new line. Tests execute real formatter
functions/TooltipBuilder and retain paragraph breaks, damage/stat sections.
Compile Frostnova with an explicit isolated profile when another hero is active;
never switch the user's .vscode/wos-build.json or profile state to build it.
No new timer or attachment scaling: TE's +20% is baked into dedicated art copies
by `resize_frostnova_te_model.py`, preserving alpha, UVs and particle lifetimes.
MDX MODL extent starts at byte 340 (name[80] + animationFile[260]), not 260;
writing at 260 corrupted the animation filename instead of fixing culling.
Both extent tools/tests now preserve that whole string region and check the
actual bounds. Layout reference: [MDLX parser](https://github.com/flowtsohg/mdx-m3-viewer/blob/master/src/parsers/mdlx/model.ts).
W's original emission and source-resolution textures are restored in isolated
imports after visible degradation from the initial optimization.

The Q shard's final geoset contained vertex group 1 with only one palette (index
0). The packet corrects GNDX alone, preserving all other mesh attributes. The new
supplied hero has a maximum 255-group palette and no particles; do not resplit or
blindly decimate its geometry. PRE2 emission optimization must scale animated
emission values AND interpolation tangents, never particle lifespan/alpha/UVs.
Keep standalone texture alpha through BLP conversion and lossless TGA encoding.
Model/texture remaps are explicit, deduplicate byte-identical MAIN wos_ imports,
and isolate conflicting shared filenames instead of replacing another hero's
effect. Asset preparation does not modify the user's source folders.

Verification: focused actual-code Q/W/E/R/T/F and shield tests, binary transform
tests, native object/asset preservation audit, independent TEST compile/pjass,
normal Hero Transfer MAIN build and packed source parity. Native rendering and
multiplayer still require Warcraft. Empty legacy pick-voice resolver branches
must be upgraded on repeat transfer once the clips have been imported.

Cause: new TEST profiles inherited the frozen Crocodile CastCheck override.
It lacked Frostnova dispatch and called the old DarkShiki T signature. Current
WOSUI also requires EnvironmentRoundRules and a few absent shop/picker globals.
The formerly empty TEST header collided with MAIN's required Map_Header source.

Solution: the recorded source policy now maps CastCheck and Map_Header directly
to MAIN. MAIN already contains the old Crocodile override's T order/stack fixes.
Keep arena startup/keys as TEST overrides and supply the missing UI globals in
TEST Start. Do not resolve this by disabling dependency or WTG/WCT validation.
Hero Transfer now recognizes WOS_HeroVoicePath after the picker voice refactor.

Frostnova is hidden from MAIN selection while WOS_EnableTestHero=false in
BuildsForChars.j (2026-10-21 user request). The guarded registration does not
add a catalog dummy, slot or MaxHeroes count, excluding random/captain pools.
Hero source, objects, dispatch and TEST are retained; re-enable the flag only
when the user wants MAIN availability. MyHeroIdInit VM verified both flag states.
On2026-10-22 the former hero-specific visibility switch was generalized to
WOS_EnableTestHero plus task-managed WOS_TestHeroId. Active TEST transfer guards
the selected catalog block; previous hero guards become visible when the selected
ID rotates. Existing false visibility is retained. New VS Code HERO task invokes
hero_transfer --active-test-hero --build-main: it reads the persisted selected
TEST source, remembers category/difficulty/items/buyer in local build config,
performs the transactional source/registration update, then calls ordinary MAIN
save/build without launch. Dry-run never writes or builds. MAIN JSON/imports
stay authoritative; brand-new objects/assets/custom dispatch hooks still need
initial preparation. Evidence: test_hero_transfer covers remembered no-prompt
repeats, active dry-run, single build invocation, and actual catalog guard in all
three visibility/rotation cases; test_vscode_tasks and MAIN compilation pass.
Frostnova's MAIN source is triggers/Heroes/Frostnova.j; the selected local TEST
copy is test_map/heroes/Frostnova.j. IDs and reproducible object staging live in
object-data/frostnova-ids.json and tools/stage_frostnova.py. Its single shared
0.03 callback uses active lists; Cold/Frostbite use dedicated reusable Slow
casters because DummyPlayer already owns another Slow with the same order ID.
Using that shared dummy would cast the wrong ability. Native debuff disappearance
clears stacks/DoT. The native Jaina model is an intentional placeholder.

TEST builds now extract the import table when needed, install prebuilt project
assets, and pack the import table plus staged asset files. Previously Update
only packed script/editor/object entries, silently omitting newly staged icons.
Button Manager Clear supports opening an image on its command line; AutoBorder,
AndSave and AutoCreateDis in a private settings copy generate paired BLP icons
without UI automation or changes to the user's installed settings.

Verification: test_frostnova.py executes production state methods; existing
hero-transfer, TEST-profile/workflow, trigger-sync and hero-progress suites pass.
Full MAIN and TEST builds and packed payload checks are separate from gameplay.
Native rendering, dispel timing, crystal collision and multiplayer remain manual
Warcraft III checks. See test_map/README.md for the profile and balance contract.

## Native TEST UI and task compiler audit (2026-10-20)

Cause: TEST's shared dependency closure now includes WOSUI, whose initializer
bootstrapped MAIN HUD/menu chrome in the arena. The user reported green panels
and requested stock Warcraft UI for TEST. The generated TestHero adapter now
provides WOSTestNativeUI by default (testNativeUI=true). WUI_Init sets its input
sentinels, then returns before bootstrap; gameplay APIs and charge storage remain
available. Custom frame owners never run. MAIN has no marker and retains its
existing behavior. Setting testNativeUI=false explicitly restores UI testing.
Frostnova TEST costs are zero at all ranks; MAIN costs stay unchanged.

The VS Code task audit also found that the old compile task indexed recovery
backups and unrelated TEST snapshots. Restrict provider discovery to live MAIN
and explicitly requested roots. Library-topological ordering alone then exposed
19 plain-JASS forward-reference errors (CaptainDraft/QB/picker/shop contracts).
After validating dependencies, use the same enabled MAIN import order as the
known-good check_wos_ui.py. Add a 30-second compiler timeout so an error dialog
cannot leave the task waiting indefinitely. MAIN Save now uses check-save;
all tasks set workspace cwd and distinguish their MAIN/TEST direction.

Evidence: full task compile passes112 sources; test_vscode_tasks.py audits task routes/arguments and
PowerShell scripts without executing imports or game launches. Native
TEST UI VM tests preserve capture sentinels and start no custom frames/timers.
The rebuilt packed TEST script returns before WUI bootstrap, Q/W/E/R/T object
costs are zero, and a repeated WCT/WTG save is byte-identical. MAIN WCT/source
identity and compiled/source parity remain PASS5284 functions. Visual acceptance
still requires restarting the TEST map in Warcraft III.

## Combined VS Code map workflows (2026-10-20)

Cause: TEST build/run packed previously saved objects, so editing JSON required
an easily missed separate save. MAIN imports required two separate tasks and
mixed labels obscured their direction. There are now six primary TEST/MAIN
tasks: receive everything, save/build/run, and save/build without launch.
COMMON holds individual code/object imports and distinct maintenance actions.
Ctrl+Shift+B builds the selected TEST profile without launching the game.

The shared wos_map_workflow.py calls check-save before build/run. TEST uses
--no-build to prevent recursive/double compilation; direct TEST check-save
keeps its original save/build behavior. MAIN receives from configured mainMap,
TEST from the selected saved hero archive. Other MAIN folders can be selected
once through a COMMON task. Imports cannot read unsaved editor memory.
Incoming MAIN code parity and object decoding must both pass before replacement;
a complete project backup restores code, native snapshots and object workspaces
if applying either importer fails. Project-only allocation JSON survives object
imports. Existing conflict/parity/editor-open guards remain in force.

Evidence: test_wos_map_workflow.py covers validation-before-write, rollback of a
partial import and absence restoration, save-before-build and launch blocking.
test_test_map_workflow.py covers deferred TEST compilation; test_vscode_tasks.py
checks unique command routes, six primary tasks, default build and script syntax.
Real MAIN/TEST import validation runs without replacing project files; game UI
and multiplayer behavior still require a Warcraft III playtest.

Full MAIN workflow validation also exposed an environment-dependent build failure:
Get-FileHash was unavailable in the task's inherited PowerShell module setup.
Packed-script identity now uses streaming .NET SHA256 with disposed handles;
the verification is retained. test_vscode_tasks.py tests actual digest values
for different payloads with PSModulePath cleared. Battle.net helper startup is
hidden. Real TEST and MAIN no-launch builds are verified separately from game
launch/UI acceptance; TEST compiles once in the combined workflow.

## Instant stat purchases and team awards (2026-10-20)
Scroll of Mastery bypasses inventory insertion through ShopDeliverPurchase;
ShopInstantStatPurchase permits full-slot purchase only for the owner hero.
Round gate remains CurrentRound>=15. Direct base-stat increments avoid native
pickup-event dependence during pause. ItemEnter keeps legacy ground pickup.
Quick Buy removes the consumed goal; RecommendedAutoBuyTick advances once on
confirmed payment, preventing repeat purchases without an inventory result.
MVP selects the best eligible player of the score-leading team, SVP the other
team; ties assign neither. Team membership uses IsInTeam1 (mixed draft slots).
Negative scores still select a team best. Runtime fixtures: quickbuy_fix6,
ui_vote_followup.TeamAwards; engine/multiplayer acceptance remains pending.

## Minimal TEST runtime and rotating Hero Transfer access (2026-10-21)

2026-10-22 native hang diagnosis (supersedes the earlier event/timer theories):
three live snapshots of nonresponsive Warcraft PID 31632 found the main thread
at executable RVAs 0x2cc64b / 0x2cc615 / 0x2cc5e8 with the same stack pointer.
The renderer's loop increments DL (8-bit) then compares it with R14D=0x100;
DL wraps before reaching 256. The earlier hang dump also stopped at 0x2cc615.
Saved hero model war3mapImported/arknights_sx01.mdx has exactly 256 MTGC matrix
groups in geoset 0, all distinct and used. Effects have smaller palettes.
This connects the hard hang to hero model skinning, rather than proving a
Q recharge, level-up, R, dummy or damage-system loop. Do not prune gameplay
initializers or replace shared charge logic again based on those timing clues.

tools/fix_frostnova_model.py splits MDX 800 triangle lists into palettes of at
most 255 groups, preserving triangle vertices/normals/UVs and exact bone groups.
For this asset, palettes become [255,9,19,1,1,9], with all 7613 triangles intact.
Original geoset indices remain stable, split parts are appended, their GEOA is
copied, and affected bone geoset bindings become Multiple; node animations,
sequences, materials, textures and other chunks remain unchanged. Prepared file
and source/fixed hashes are in assets/FrostnovaModel/; original model files are
not edited. Replace only the existing model payload under its original import
path; preserve war3map.imp and every unrelated archive payload. Ordinary builds
still preserve saved imports, rather than reinstalling this packet. Coverage:
test_fix_frostnova_model plus real before/after triangle-attribute comparison;
native captures and archive audit are under _build/frostnova-q-recharge.
Final engine acceptance still requires opening the corrected TEST model.

Cause: native HUD mode alone did not stop the shared universal-tooltip
initializer (484 queued jobs plus polling) or all companion hero/module startup.
Historical TEST startup still loaded a custom TOC, charge UI and foreign audio;
the native map template also created imported sounds and selected map music.
The user reported a hard hang after4-5 seconds and requested a minimal default.

Initial solution (historical; gameplay cuts withdrawn on 2026-10-22): every
profile defaults to testMinimalRuntime=true, forces native UI,
and supplies WOSTestMinimalRuntime. After dependency resolution, the TEST-only
runtime pass guards foreign hero/item auto-init, universal-tooltip startup,
noncombat editor initializers, transform preloads and native sound/music/TOC
startup. GearSystems/GearSystems2, cast/damage/death, keys/arena startup and the
selected hero stay active. StopMusic/ClearMapMusic run at minimal initialization.
Legacy companion declarations remain for plain shared calls but their startup
callbacks do no work. MAIN sources are untouched. The pass refreshes staged
WCT metadata; import removes the exact generated guards before origin matching,
preventing accidental frozen shared overrides. Explicit full UI testing needs
both testMinimalRuntime=false and testNativeUI=false.

2026-10-22 current policy correction (supersedes broad cuts above): the user
explicitly requested normal gameplay with only custom UI/UniversalTooltips/
TooltipBuilder disabled. Removed gameplay guards from CastCheck, Death, level-up,
item/unit/mouse events, regeneration and foreign hero/module initialization or
timer registration. Only named presentation owners, music/audio probing and the
old TEST Escape implementation remain guarded. The three original heavy UI
libraries stay excluded with inert API compatibility. The legacy
testMinimalRuntime name now controls presentation, not gameplay pruning.
CreateKeys still runs before TEST hero creation and hs is never replaced. TEST
has one direct all-player SPELL_EFFECT subscription; the full level-up handler
skips only its duplicate subscription to the same trigger. CastCheck/DmgSys/
Death/Systems1 preservation is covered by test_test_map_runtime. Runtime guards
are reversed before source import. Reports are under _build/frostnova-r-freeze.

The user isolated a native hard hang after ordinary R (without T). Its ordinary
field has no crystal branch. A deterministic integration executes actual packed
DmgSys, damage helpers and shared timer callbacks for a complete15-second R
scenario (11,497 script calls) without a script loop failure; native rendering
and native order execution remain mocked. This does not prove the native hang
resolved. Warcraft was already closed before a process stack could be captured.
Do not declare the dummy or model the root cause without runtime evidence;
experimental unused dummy staging was removed. Q now has actual circular motion
at1.4 rad/sec, with the same orbit formula used for the launch position.

2026-10-23 Frostnova cast/audio follow-up: W has 0.6-second right-hand preparation
with the existing StartSpellUnit2/StopSpellUnit2 pair and a travelling wave whose
visual scale and hit radius grow together from 80 to 220. E delays its burst by
0.75 seconds and leaves a seven-second field. R forms over 0.5 seconds, then
lives eight seconds with one-second pulses. These stages and per-hero voice locks
use the existing GearTimer03 listener; no new timers or UI owners were added.
Current audio policy (user correction): normal Q cycles Q1-Q5 on every cast,
normal W/E/R groups bypass the voice lock, and Q6/Q7 remain independent. T lasts
20 seconds and T1/T5 always play. Only T2/T3/T4 during T use mutual exclusion,
including T1's duration; only the primary R voice is silent during T. T2 lasts
4.049 seconds. ffmpeg silencedetect found initial silence in Q1-Q5 of
0.268/0.250/0.306/0.145/0.255 seconds; game copies trim 0.248/0.229/0.286/0.125/
0.235 seconds, leaving about 20ms before onset. Q6 has no initial silence.
Original MP3s and trim amounts are in assets/FrostnovaAudio/{source,manifest.json}.
The initial dark copy changed only Ice.blp, but Additive materials and six
unchanged PRE2 emitters kept it bright. tools/tune_frostnova_shards.py now reduces
particle scales 20% in both models. T uses dark semi-transparent particle colors,
Blend materials (enum2) and PRE2 Blend (enum0), remapping all textures to an ice
surface and four true-alpha sprites. Geometry, nodes, animation and global
sequences are unchanged. Inputs are explicit untuned MDX plus imagegen atlas;
do not feed the tuned output back into this size transform. Generated source
assets/FrostnovaEffects/dark-particles-source.png is a 2x2 dark-ice halo/star/
snowflake/ring atlas with transparent gaps and charcoal/glacial-blue fractures.
The tool slices it to four 256px RGBA TGA files. black-ice-source.png supplies the
surface. wos_aurapartblue.mdx remains the existing MAIN aura copied into TEST.
T rebuilds idle shards at mode boundaries, clears Q cooldown and normalizes its
duration to exact zero before cleanup to avoid retaining dark shards due to a
floating-point remainder. Start follows Loop in each Q/W/E/R/T struct.
The isolated TEST meter now anchors above ORIGIN_FRAME_MINIMAP instead of fixed
screen-centre coordinates, following stock HUD/aspect ratio without custom HUD.
Validation: 39 executable Frostnova tests, model/alpha/bar/runtime tests, MAIN
source compile and real TEST build. The archive audit allows only the two Q
models, Q1-Q5 and four new sprites in addition to native script/import changes;
the other 18 MP3 payloads, original IMP records and WTG remain intact.
The local TEST unpacked WTG root name was stale Crocodile.w3x; restoring the
saved Frostnova.w3x root prevents future builds from reverting the editor title.
No MAIN map write. Live audio/rendering still require in-game acceptance.

2026-10-23 saved-map preservation / F-only follow-up: the user edited Frostnova's
saved WCT (range/radius/push, models, animation calls and hit attachment), units,
effects and audio. Adopt the actual FrostnovaSpells WCT block before patching;
project J was older. The focused update compiled the new library then replaced
only matching Frostnova functions/globals in the saved compiled script. Private
JassHelper underscore spelling was mapped to the saved symbols, including shared
dependencies; pjass and the real TEST map compiler passed. Compiled parity
confirmed zero changed non-Frostnova functions/globals, preserving native unit
placement/config/sound initialization. WCT changed only block93; WTG stayed exact.
Do not run a broad object save or restore cached imports for a code-only request.
The same scoped operation applied the user's explicit F cleanup and 23 exact MP3
copies from folder (16), without trimming/re-encoding (supersedes prior trim).
Archive evidence is _build/frostnova-f-only/audit.json; every model/texture,
unit payload and import table stayed byte-identical to the user's saved map.

Q readiness formerly reacted only to an increase in observed charge count. A
late native cooldown write after that observation could leave a positive charge
blocked. FrostnovaState.qUsePause tracks only the shared .25s use pause (+one tick);
charge gains clear it. The existing hero tick then clears any positive Q cooldown
while charges exist outside that pause, including a late write on a later tick.
Regression executes the missed ordering explicitly. Zero charges retain recharge.
Q last-charge follow-up: a shared 0.05 callback could run before the deferred
0.03 cooldown callback after the last throw. Its zero-count/zero-CD fallback
returned a free charge; Q Start had the same optimistic auto-grant. This allowed
rapid repeats on the last charge. Q Start no longer grants charges from native
cooldown alone, and immediately seeds FrostnovaQ_Recharge when consumption leaves
zero charges. The existing deferred callback then installs the exact remaining
recharge time. Other heroes' shared fallback is unchanged. Two regressions force
the 0.05-before-0.03 order and repeated same-frame empty casts;42 tests pass.
The focused compiled patch changes only Q Start and one WCT block; every object,
audio/model/import payload and WTG is preserved (_build/frostnova-q-zero/audit.json).

2026-10-23 T voice / R traps (updated after queue correction): only primary
_W/_E/_R voices are muted in T. W2/W3, E2/E3/E4 and R2/R3 remain unconditional.
Only a successful Q/W/E/R cast can start the next T2/T3/T4 line. Casts while
another voice is active are skipped without advancing the cycle. The State
clock only decreases the voice lock; it never automatically starts a line.
Enhanced R places blocking crystals at synchronized random points, using a
bounded eight-attempt loop and 48-unit body clearance. Each is a one-use trap:
0.10-second scans use the existing field group, RootUnit(1s) plus F/crystal hit
damage consume one target and remove that handle. Other crystals remain armed;
all unused handles are removed at R end. Null consumed handles are skipped.
The old crystal pulse could damage targets but never rooted or consumed traps;
old 160-unit occupancy rejection also prevented spawns in crowded locations.
Fresh saved WCT was adopted again, retaining the user's new E visuals, -40 Q
trail offset, 650 E radius, 1200 R radius and model references. E recast now
also cleans the user's art2 handle before replacing it. Only runtime J and the
Frostnova WCT block changed; all object/import/audio/model payloads and WTG
remain byte-identical. Evidence:45 hero tests, source and actual TEST compile,
_build/frostnova-r-traps/audit.json. Actual engine rendering/root behavior needs QA.
October 23 field follow-up: the saved hero WCT was adopted before editing, so
its R radius 1050, file00005537_3.mdx, alpha, E effects and animations are retained.
E refreshes a 0.36-second native marker every 0.12 seconds: B0F0 gives the caster
30% all-damage resistance in its own stationary field; B0F1 reduces enemy health
restoration by 35%. DmgSys applies the reduction after DamageBlock; GetPhysRes /
GetMagRes compose the same factor, and GetHealMultiplierNoBlock handles the cut.
Helpers A1F0/A1F1 have no native armor, damage, attack-speed or movement modifiers.
TE attaches file00000883_1.mdl to origin after preparation and deals Int x 0.25
damage each second in radius 700 around the moving caster for the saved E duration;
the stationary field remains. Recasting and death release the attached effect.
TW uses StartSpellUnit / StopSpellUnit, preserving preexisting invulnerability.
W clips its push distance to the active Icefields that contained the victim.
TQ pierces with a per-flight hit group, one hit per target; normal Q still stops.
Its hit art is a separate wos_file00003436_2-dark.mdx copy using the existing
transparent dark particle textures. Its original 2x2 / 4x4 emitter UV sheets
are reset to single-sprite intervals. The opaque BlackIce surface must never be
assigned to a Blend particle: that caused the reported expanding square.
One geoset also retained 0..1/3 UVs and texture animation 0 from a 3x3 atlas.
The dark copy normalizes its UVs to 0..1 and disables atlas translation;
positions/bones/animation tracks stay intact. TQ scales only hit effects to 0.5.
E creates its eight-spike ring only once. EffectSpawn's sixth argument is scale,
not playback speed: the accidental scale 4 is now 1, with timescale 1.25.
The Splat model has a one-second looping Stand, so its burst handle is removed
at 0.75 seconds. Its fixed scale 1 is independent of gameplay AOE; the separate
snow field and TE aura retain the saved E duration and all damage pulses.
Build it with build_frostnova_impact.py
from assets/FrostnovaEffects/source/wos_file00003436_2.mdx; the original stays intact.
F rejects friendly targets, and its dedicated dummy explicitly disables Slow autocast.
October 24 revision supersedes the TR crystal/cage mechanic: there are no
spawned shards, collision objects, edge cages or radius increments. R retains
its fixed gameplay radius and only scales visually during initial formation.
The saved wos_emt-8.mdl effect at scale 2 and a two-second initial RootUnit pass
run only for TR. During its active lifetime TR adds a random radius-180
microburst every 0.25 seconds, each dealing Int x 0.25 extra magic damage plus F.
The old helper objects/imports remain untouched and simply are not instantiated.
E now deals its ordinary damage immediately alongside initial F/push, in addition
to periodic damage. The saved E radius 850, duration 10, model scale 3.25, spike
scale 4 and retained field art are user edits and must not be reset to older values.
TE additionally attaches the independent FrostnovaTE_Area.mdx placeholder to origin;
replace that import in World Editor to choose the final AOE art. Its model path
is a separate global; unit attachments inherit native scale, and recast/death/end clean it with the original aura.
TE visibility follow-up: the current saved model is wos_az_aachristmas_t1_700_1.mdx.
Its Stand opacity stays at 1, but the ring lies at Z~10 with ordinary depth testing;
the retained E splat can occlude it. MODL also has zero bounds despite valid
sequence extents. fix_frostnova_te_area.py enables NoDepthTest/NoDepthSet and
fills MODL from sequence bounds, preserving geometry, textures, alpha and tracks.
E explicitly plays Stand on its area/aura after attaching. No attached effect
receives BlzSetSpecialEffectScale; T's old attachment scale was removed too.
TQ retains its requested half-size hit as a short-lived world effect at the
victim's position/height, avoiding scaling the target's attachment transform.
Normal Q's hit now also uses world space at victim height+80 and MyRemoveEff(1s):
immediate DestroyEffect on its attachment could hide the one-second animation.
The imported hit model/textures remain unchanged; test_frostnova.py checks its lifetime.
October24 MAIN F follow-up: recover the visible count from all10 native tiers;
keep the previous Slow until the expected replacement appears, then clear every
other F/TF tier. A0.15s pending-order grace prevents the shared03 loop from
treating native cast latency as a dispel. Actual dispels still reset stacks.
At hero35 normal F also ticks0.15*INT*stacks; TF adds0.5*INT once per tick, not
per stack. Q/W snapshot+150 range at35; RefreshRange updates all native ability
ranks only on threshold changes. W gains20% speed at25, including all TW lanes.
MoveEff2 itself is unbounded: Q/W explicitly check PathableCheck before moving,
and terminate at the boundary without advancing collision/visual coordinates.
The saved A1F2 helper had4s adur/ahdu in gameplay but no corresponding Skin values.
Both native layers now explicitly use4s. FrostnovaState also caps its shield to4s
after the latest grant on the existing03 listener, including if native expiry
fails. Hero pause freezes both this cap and Winter's Scar duration, while actual
voice playback/readiness continues in real time. Damage/dispels never grant a shield; a later accepted verse resets its cap.
Winter's Scar uses one WUI_HeroProgressDualText panel keyed by FrostnovaT_ID:
main duration plus a red voiceRemaining/voiceDuration row with Shield Ready
once the voice ends. It does not itself grant a shield; the next accepted
Q/W/E/R verse does. Death/T expiry clear it. E field/TE aura/R publish small
MyFrameTimed icons in slots2/3/4 using KS_BuffTimer's existing10 clock. Recasts
reuse the unit/slot timed entry, E cleanup cancels both icons, and only the latest
R instance owns its icon. R icon starts after formation. TR checks the outer
100-range band and tracks prior occupants to observe long blinks without stale
exit markers; only exits landing in that band root. Damage/bursts retain their radii.
Evidence: test_frostnova.py and test_auto_select_policy.py.
Auto-select must gate on LIBRARY_WOSTestMinimalRuntime, not TestMode: MAIN's
sandbox also sets TestMode, so the old guard hid the button and rejected settings.
Both HUD mirror/tick and DmgSys now permit opted-in MAIN sandbox selection.
The saved W angle/visual-radius edits and TR model/rate/scale edits were adopted
before patching. Only the selected area model and hero source/runtime changed;
objects, other imports, WTG and import records stay byte-identical. Native
visibility in Warcraft still needs confirmation; deterministic checks establish
lifetime/attachment ownership and exact binary preservation, not rendered pixels.

Enhanced W's radius is at least StartAoe + travelled*sin(half lane angle), closing
the gaps between the three rays near and far. All three retain one shared hit set:
a victim receives W damage, F and push only once per cast.
The scoped TEST write changed only Frostnova plus four shared buff hooks in WCT /
compiled J, appended those five objects and one model import, and preserved every
existing object/import payload. WTG is byte-identical. Verification: 52 executed
hero tests, additive-object/model checks, MAIN/TEST compilation, pjass and packed
payload/source audits. Native rendering and buff timing still need a game test.

F has one ten-tier buff array:1-5 normal /6-10 enhanced. Q/W/E/R all call the same
F Apply. TEST reuses A11C and the ten existing buff IDs as F/TF tiers, keeping their
edited icons/effects and numerical slow properties; unused A11D is deleted.
No separate Cold/Frostbite state or extra native debuff ability remains in TEST.
T keeps normal shard art and adds a second existing dark model source, storing
idle handles at200+slot and transferring them to the projectile at launch. It
shares position/yaw, visibility and growth, and cleans up on hit/range/death/end.
No new effect imports, model edits or timers. Forty executable hero tests pass.

2026-10-22 low orbit / partial TEST bars: orbit base lowered from 180 to 25,
35-unit layers retained. Low charges rise and high charges descend to flight
height 150 with the same 0.30-second interpolation. Q speed is 2100 (+40%). T
now feeds WUI_HeroProgress at start, each gameplay tick and explicit zero on
end/death, matching AlterSaber R's real remaining-duration contract.
At the user's explicit request MinimalUI now enables only HeroProgress/Text.
It clones/renames the current MAIN Passive/Piece/Pin/GoldFrame style helpers into
private TEST helpers and includes tools/templates/test_hero_bars.j. Original
public helpers and all other heavy UI APIs remain inert; there is no HUD/TOC
bootstrap, UI timer, input callback or global frame allocation. Bars allocate
synchronously on first use and present only to their owner; caption/time strings
are cached. tools/test_hero_bar_assets.py is called on the built TEST archive
only in minimal mode. It adds six missing UI/WOS textures and import records,
using fresh listfile/IMP data; existing payloads/records always win. It does not
run the MAIN UI installer or change native skins. The normal-build preservation
rule now has this explicit six-texture exception, not general asset restoration.
Evidence: test_test_hero_bars, test_test_map_runtime, profile/workflow/task tests,
separate MAIN and TEST compilation. Live rendering remains to be checked.

2026-10-22 Q visual tuning: removed backward orbit offsets from both visual
and launch formulas so each opposite pair is centered on the hero XY. Orbit
scale is ModelScale/OrbitScaleDivisor (default 3). ScaleEffDummy restores flight
size over GrowTime (0.18 s). Height interpolates from the detached slot to 150
in 0.30 s, anchored to the launch ground Z; the secondary effect stays 25 lower.
Orbit base height is 180, with existing 35-unit layers and bobbing retained.
FrostnovaState caches previousCharges only to observe shared SpellStacks growth;
any positive gain clears Q cooldown on the shared 0.03 tick. Casting updates the
cache immediately after TryUse, so consumption is not mistaken for recovery.
No private timer or second gameplay charge tracker was added. Evidence:
test_frostnova orbit center/scale/flight path and early-charge cooldown cases.

2026-10-22 orbit model follow-up: the user selected ice_shard-7716D in saved
Frostnova WCT. Its code path had a duplicated .mdl.mdx suffix; the archive only
contains war3mapImported/ice_shard-7716D.mdx. Preserve the user's selection with
that exact saved import name. Remove the old Extra13-specific 1.0-second effect
seek from orbit and fallback projectile creation: this model's Stand interval
is 41-833 ms, so that seek falls outside it. BlzPlaySpecialEffect(STAND) selects
the model's own animation interval. Compare saved WCT with the project before
updating and use a fresh archive listfile for preservation audits: the user also
removed the old freezingsplinter model, which must not be restored by a build.

2026-10-22 Q/ESC correction: the user reproduced the hang after learning Q and
pressing Escape to refill charges. The earlier TEST pass replaced Start's reset
but still registered MAIN `InitTrig_ESC`, so the same key also executed legacy
`UnitResetCooldown`. TEST now guards that duplicate initializer and retains one
targeted reset owner. Frostnova's independent charge/capacity/recharge fields and
Q-specific CD_Start jobs were removed. It now uses actual KS_SpellStacks through
SpellStacksStart/TryUse, like TojiE; T/death use Fill and TEST uses
ResetForEscape. Rank capacities stay 2/2/4/4/6 and increasing max grants the
difference. The shared 0.25-second use pause and delayed native cooldown writes
are unchanged. Existing Toji/Ainz code and the shared tracker were not modified.
The hero tests now execute the real tracker, including its delayed callbacks,
and cover repeated learning -> cast -> Escape without duplicate instances.
Orbit alpha no longer depends on a neutral observer; Extra13 explicitly starts
its visible Stand at 1000 ms. Asset basenames/import payloads remain unchanged.
A local minidump was captured from a nonresponsive Warcraft process, but it did
not identify a symbolic JASS call chain; these changes still need engine replay
of the reported sequence. Reports: _build/frostnova-q-reset.

UI exclusion follow-up: guarding initializers still left TooltipBuilder,
UniversalTooltips and WOSUI enabled in the editor and included their heavy bodies
and global handle allocations. Minimal profiles now provide generated MinimalUI
compatibility: public MAIN API signatures with empty/default returns and public
WUI constants, with no handle allocation, callbacks, frames or timers. Resolver
candidates and seeds exclude all three original filenames, including explicit
sharedSources. include_resolved retains them as disabled WTG/WCT snapshots even
when an earlier closure introduced WOSUI outside the base manifest. Full mode
does not include the adapter or apply these exclusions. Native TasChargeBox stays
independent and active. Evidence: test_test_map_runtime, test_test_map_profile,
test_test_map_workflow; real packed TEST audit in _build/test-no-heavy-ui confirms
all three WTG enabled flags false, empty compatibility APIs, absent tooltip jobs
and WUI bootstrap, preserved cast subscription and39 unchanged protected entries.
Engine frame-rate/hang acceptance still requires a running game.

Historical follow-up (level-up initialization is now restored): the first
minimal policy also disabled InitTrig_LvlUpCheck, which
owned the SPELL_EFFECT subscription to gg_trg_CastCheck. Keeping CastCheck's
initializer was insufficient: casts never reached hero code. The generated
minimal initializer now registers SPELL_EFFECT directly, without enabling the
foreign level-up helper units. The generated Start suppresses its historical
hs reinitialization so library state survives arena startup. Generated Escape
calls TestHero_Reset instead of the legacy UnitResetCooldown path: native
HP/mana restoration, normal charge refill, optional <Hero>_ResetForTest, and
seven explicit cooldown endings. Frostnova's hook restores its own Q pool and
recharge progress without activating T. Combat hook markers are stripped before
import alongside the older guards; full runtime retains its original routes.
Evidence: test_test_map_runtime executes the real CastCheck initializer and
repeated Escape routing; test_test_map_profile exercises generated revive/reset;
test_frostnova exercises Q pool reset. Separate MAIN compilation and real TEST
build passed. Packed archive checks under _build/test-cast-escape confirm one
active cast subscription, targeted Escape and all39 protected payloads unchanged.
The exact engine cause of the reported Escape hang remains unconfirmed; these
checks establish the replacement path, not an in-game freeze reproduction.

TEST imports belong to the saved archive. The initial implementation incorrectly
reused a cached war3map.imp and installed project assets during builds: the user's
22 imports became150 and the model disappeared from the editor import list even
though all three payloads remained intact. Recovered the exact user manifest
from the pre-build archive. Default MPQ Update now touches only native objects
and triggers; TEST never runs the MAIN asset installer. Explicit NamesFile writes
are reserved for separately authorized asset operations. Deleted imports must
never be revived from unpacked caches. The copied source archive preserves all
custom payloads. Native objects/WTS refresh separately before lossless save so
fresh WE model/object edits are not overwritten from stale binary caches.

Frostnova's TEST model property (native umdl) points to arknights_sx01.mdx;
its two root BLP textures match the supplied files. The 2026-10-22 follow-up
replaces the stock effect placeholders with assets/FrostnovaEffects:17 MDX and
71 unique BLP payloads, preserving required texture paths. Models retain original
basenames under war3mapImported; the initial Frostnova/Effects aliases were
removed only after matching their saved payload hashes. Other saved payloads
and unrelated import records are preserved. Conflicting custom
textures, including two different Flare.blp files, receive independent paths
inside copied MDX TEXS records; supplied originals remain unchanged. The packet
manifest records hashes, remaps and validated native texture dependencies.
Three MDX exports used zero-duration global animation cycles for constant
transforms; copied GLBS periods are normalized to1ms without changing poses or
source files. Archive named payload I/O uses explicit UTF-8 byte buffers so the
original freezingsplinter体.mdx name is not corrupted by Windows ANSI marshaling.
The saved TEST had only64 MPQ hash slots, insufficient for88 new payloads.
Explicit Pack -NamesFile expands capacity using a fresh extraction of all53
saved payloads plus the packet, preserving opaque files too. The110-entry IMP
retains the original22 records byte-for-byte. Default native-only updates still
never restore assets from cached folders. test_test_map_imports covers explicit
pack preservation and exclusion of unlisted stale files.

Q now uses freezingsplinter体.mdx (old Extra13), with [skillm]als-tx (6).mdx
(old Extra14) added during flight only. W uses file00008417.mdx (NorthernWinds)
plus tx026.mdx (old Extra16). Q keeps charge shards beside the hero, follows position/facing with staggered
height, hides only their alpha locally during invisibility/fog, removes them on
death, and launches the selected existing effect from deterministic orbit XY/Z.
Every slot has a separate height; successive pairs have distinct side/back
offsets. Position updates use one native XYZ call. Q level changes are observed
on the shared clock; the former HERO_SKILL registration and repeated passive
ability writes during learning were removed. Walking/learning tests retain
existing effect handles and one clock user across rank1 ->2.
One registered hero state remains on the shared clock through death to detect
revival; removal releases it. Enhanced W shares one hit group among three waves
at -30/0/+30 degrees. Enhanced R crystals each add50 radius (800 ->1200) and
deal Int x0.25 damage per second in180 range. Native Slow A11C has ten levels:
Cold1-5 uses5/10/15/20/25%, Frostbite6-10 uses8/16/24/32/40%; ten separate
buffs carry F/T icons. A11D remains an unused historical object. Follow-up object
staging is tools/stage_frostnova_followup.py, not the initial hero stager.
Evidence:26 deterministic hero tests, effect packet/import tests, MAIN compile
and actual minimal TEST build. Final packed payload/hash checks live under
_build/frostnova-effects-import. Engine rendering and live hang behavior remain
unverified by these checks.

Frostnova E follow-up: the user reported a hard hang after repeated E casts.
The previous generic Field structure added an independent six-second field per
cast and spawned periodic FrostNova bursts. Refactored the one hero library into
shared state plus ordered F/Q/W/E/R/T structures, each owning Start/Loop; public
CastCheck entry functions remain grouped at the bottom. Q/W and E/R no longer
mix ability-specific branches inside generic missile/field structures. E keeps
one instance at the caster handle/key2: recast refreshes/moves it, reuses its
group and aura, replaces its birth burst, and owns burst/immunity cleanup in the
shared tick. No per-E MyRemoveEff jobs or periodic birth-effect accumulation.
T similarly refreshes one mode instance at key3; common state retains Q charges
and the shared mode flag only. F is the common debuff above Q. MAIN/TEST hero
sources match; imports and lightweight TEST policy are unchanged.
Evidence: test_frostnova executes100 rapid recasts, repeat cleanup cycles, two
casters and repeated enemy hits with bounded fields/groups/effects/dummies and
balanced shared clock users. MAIN112-source compilation and actual TEST build
pass; _build/frostnova-e-refactor verifies packed entry points, disabled heavy UI
and39 unchanged protected archive entries. This corrects the measured resource
growth; the exact engine hang and its resolution have not been reproduced live.

Native TEST now permits the small TasChargeBox using stock frame definitions,
background and font. SetValue/selection events refresh it without a private timer
or WOSUI bootstrap; unchanged values and reentrant refresh are suppressed.
Frostnova Q capacity is2/2/4/4/6 at ability ranks1-5, with no use cooldown while
charges remain. The empty pool waits for its next6-second charge restoration.
Evidence: test_native_charge_box, test_frostnova, test_test_map_imports and the
real packed-map audit under _build/test-import-preservation:39 protected archive
entries unchanged, exact22-entry manifest, native model binding and zero Q object
cooldown. Actual effects/counter rendering still require in-game acceptance.

Hero Transfer now requires the purchaser nickname (interactive prompt, or
--buyer-name with --yes), replaces only BanImmuneHero1 with <Hero>_ID, and rotates
the previous priority buyer to that name while retaining the correct ThunderGear
account. The priority condition uses <Hero>_ID directly rather than a stale hero
array slot. Existing transactional backups cover these edits and repeat runs
remain idempotent. The task update does not transfer an unspecified buyer into
MAIN on its own.

Evidence: focused runtime/profile/assets/transfer tests; real minimal Frostnova
build and import validation under _build/test-minimal/. Packed source checks
confirm disabled startup bodies, preserved cast/damage and Frostnova registration.
A live engine run is still needed to establish that the reported hang is gone.

## Item description parity (2026-10-23)

Item text had drifted from script constants, item enter/leave bonuses and merged
native ability fields. Editable ability JSON omits some native fields; use
war3_object_workspace.prepare_documents with the raw metadata rather than treating
missing convenient fields as zero. Fairy Tail Emblem's A0D2 inherits AI2m's
200 mana. Idef grants armor points; the itemMagRes pool is a resistance rating,
not a flat percentage reduction. Separate scripted multipliers still are percent
reductions. Cosmetic fire lifetime is not the Fire debuff duration.

tools/check_item_descriptions.py reviews all 158 item headers, regenerates selected
semantic descriptions and binds reviewed numeric claims to current MAIN values.
--fix changes only description/extended_tooltip, with a whole-document guard;
the default invocation checks without modifying the catalog. Run
python -B -m unittest discover -s tools -p test_item_descriptions.py for source
constant/native-field mutation checks and repeatability. Remaining free prose and
new gameplay branches still require manual semantic review; this is source parity,
not an engine or multiplayer test. The October audit corrected 35 item entries,
including Okarun Egg's 14% cooldown reduction and cumulative Susanoo damage.


### Patriot stance / Akainu attached-effect lifecycle — 2026-10-26

Patriot's level-35 Perseverance cleanup reset only `patriot e`, animation and
form, leaving offensive F/T availability, the E icon and the movement bonus.
The first E after revival therefore repeated the active ability set. All three
transitions (manual E, Perseverance entry/exit) now use `Patriot_SetStance` in
`triggers/Heroes/Patriot.j`. Reapplying a stance refreshes its full presentation
without adding/removing the A01C bonus twice or copying an inactive ultimate CD.
Cleanup returns to defense and transfers the current attacking ultimate CD.
`tools/test_patriot_stance.py` executes production transitions and death-loop
cleanup from both stances, including early interruption and switching during EE.

Akainu Q/R already destroyed their hand effects during timer cleanup. Their
new `Akainu_Death` hook in `Systems/Death.j` immediately hides/destroys/nulls the
attachment and expires matching Q/R instances, so revival before the next tick
cannot continue the old cast. `Akainu_ClearHandEffect` hides the model before
DestroyEffect on Q/W/E/R/T exits. T had a proven cleanup gap: its old r < 1.68
check missed death at 1.68–1.77 before the normal 1.80 removal; cleanup now
releases any remaining hand handles unconditionally. Native model persistence
on a corpse is not reproduced by mocks; its engine cause remains unconfirmed.
`tools/test_akainu_attachments.py` covers immediate Q/R cancellation, fast revive,
independent casters, timer fallbacks and the entire T windup. Both new suites,
20 `test_hero_balance_followup.py` tests and MAIN compile/dispatch audit passed.
MAIN WCT/source and compiled/source parity passed; packed J/WCT/WTG hashes
matched the saved scenario, and STABLE matched the verified build. Warcraft
visual/multiplayer validation remains required.


### BLP optimizer: gamma, alpha and compact limits (updated 2026-10-28)

The external wos_FULL_AUTO_ONE_FILE.cmd uses Atlas-v5: default maximum side
256, rare 512 exception, absolute maximum 512, proportional dimensions and no
upscaling. Examples: 1024x512 -> 256x128 normally or 512x256 exceptionally;
2048x4096 -> 128x256. Caller width/height cannot bypass the hard cap.
The old v2/v3 return-to-original and unrestricted escalation contracts are
superseded. A 512 exception requires >=50% solid alpha, substantial 256 detail
error, >=30% improvement at 512 and a result <=200 KiB. Sparse animated effects
stay at 256 except for the dense-frame atlas rule below. Compare codec errors against the properly resized reference,
separately from unavoidable resolution loss; never retain 2048/4096 as success.

blp-iio-plugin marks decoded samples as linear RGB; getRGB/drawImage previously
applied an unwanted sRGB transfer before raw BLP encoding. Read raw components
without gamma conversion. Filter premultiplied alpha and write straight RGBA.
Preserve fully hidden RGB separately: losing it previously inflated RGB error
and caused false escalation on water atlases. Validate all mip levels and use
high quality for tiny mips. JPEG 85/92/97 is round-tripped; adaptive BLP1 palette
with a separate exact 8-bit alpha plane is the bounded-size fallback and may
also beat JPEG size. Record forced palette colour warnings rather than silently
returning a large original. Standard Pillow's BLP1 decoder ignores separate
palette alpha; independent validation must read that plane explicitly.

The atlas-v5 state rechecks older outputs once; unchanged v5 outputs are skipped.
When reprocessing wos_, use a neighbouring original without the prefix if present.
Do not substitute an old database texture or remove input without verified backup.
The embedded JS remains consumable by tools/prepare_frostnova_release_assets.py.
Evidence: seven previous real textures plus three water atlases, alpha fixtures,
horizontal/vertical aspect and no-upscale checks, oversized caller request,
old-cache migration, independent BLP/JPEG decoding, verified backups, full CMD
cycle and repeat-run hashes. Water: 2048 square -> 256 square, 4520733 -> 175942
bytes; water1: 2048x4096 -> 128x256, 3408069 -> 88562 bytes. No engine validation.
Source references: tools/build_kusanagi_effects.py, blp-iio-plugin
JPEGMipmapProcessor/BLPWriter and the standalone script/report beside user files.
BLP2 remains unsupported by this Java plugin; damaged inputs need originals.

User refinement: dense animation sheets (e.g. water 8x8 = 64 frames) need 512,
even with sparse alpha. At 256 each frame is only 32 pixels. Detect regular
alpha islands along both axes: >=4 bands/axis, >=32 occupied cells, >=80%
occupancy, <=15% spacing error and frame size <48 at 256. Preserve aspect
(8x4 at 1024x512 -> 512x256); sparse/incomplete/small sheets remain 256. The
opaque-detail exception's 200 KiB budget does not apply to dense atlases.
Never upscale a small source to fake lost detail: match current outputHash
against a previous report and verify sourceHash before reading its original
from BLP_SOURCE_BACKUP. Read only scoped hash folders and input basenames.
Water v5: original 2048 square -> 512 square, 4520733 -> 577159 bytes; not an
upscale of v4's 256 result. Tests cover actual 8x8 and synthetic rectangular
grids, sparse/opaque false positives, no upscaling, original recovery and
repeat-run hashes. Other mip levels use >=92 quality, tiny ones >=97 so one
bad mip need not raise the main image's quality. No in-game verification.


### Classic MDX: inert PRE2 / Magos KP2R compatibility (2026-10-27)

The external wos_FIX_MDX_PARTICLES.cmd repairs MDX 800 without changing version
numbers. mr.war3_jdjj had one inert PRE2 node (91, parent 90), zero lifetime and
emission, and a KP2R key at frame -20 with value 0. KP2R is a variation track;
its presence or an old-editor error alone does not prove intentional protection.
Remove only inert emitters by default (including zero animated emission), and
preserve each removed emitter node as a HELP node with its ID, parent, transforms
and pivot unchanged; clear the PRE2 node-type bit. This avoids skin/parent ID
remapping and preserves child references. Geometry, materials, textures, sequences,
bone animation and PIVT remain byte-identical. The optional --all-particles mode
removes all PRE2 only; it intentionally removes live PRE2 effects too. Unknown
layouts and non-800 versions fail safely; do not fake downconversion by editing VERS.

Evidence: embedded tool checks and 8 isolated tests (live/animated emission,
child references, no HELP, malformed data, version 1800, idempotence and existing
output preservation). Magos War3 Model Editor v1.05 loaded the fixed model;
user independently confirmed opening. In-game behaviour was not tested.
Source: Retera ParticleEmitter2Chunk/ParticleEmitter2Variation and local model
binary. The standalone CMD and MDX_FIX_README are beside the supplied model;
the CMD also exists in Documents. Original model is left intact.

### Elemental item visual source drift (2026-10-28)

The configured scenario's compiled ItemsElements_Cast/update retained newer model
choices than root war3map.j and triggers/Items/Items.j (Ember summon3missle,
Leviathan G1, Ashen file00001323, storm longskill_point_10, Verdict leash
WTW-whitethunder-Zi, Anchor ZarakiWCrack1/obr08). Read those narrow compiled
functions to recover the affected visual choices; do not import stale WCT.
Items.j now preserves those choices, uses Leviathan G2 for Anchor and shares
Verdict's leash lightning with its three strikes. Anchor's single effect follows
0.60/1.10/1.60-second impacts with rebound/pitch in the existing item clock, then
is destroyed; the whirlpool still ends at 2.1 seconds. The actual-source lifecycle
test checks three landings, preserved total damage, rebound and cleanup.
This is source-only reconciliation, not a full compiled/source parity certificate
or proof of native animation. Main build parity remains mandatory.

Elemental follow-up (2026-10-28): Anchor initial drop/rebound peaks are now
1200/720 above ground, with BlzSetSpecialEffectPitch on every motion tick;
roll was the wrong requested axis. Targeted Grasp scale is 1 (half its previous
2). Ember's projectile height is 170 (another +60); Cinder uses Phoenix_Missile
at height 220 (+150), speeds 2400/2200 outbound/ricochet. Volt's projectile uses
the weapon attachment from Erza3 Q (`wos_obr08 (166).mdx`) at height150.
Crimson's eruption uses Frieren E `wos_yc_firebeam2.mdx`, scale.7/time scale2;
Phoenix Seal's projectile uses `wos_Windwalk Fire2.mdl`.

Volt's three-second mark pulses every second for.9x AGI magic damage to OTHER
enemies in a300-radius capsule around the live caster-target segment, using a
per-mark reusable group. The tethered target is explicitly excluded. The existing attack-charge reaction is preserved. Caster/target
death stops the thread. Constellation's cast now launches a straight1800-range
projectile (200 collision radius): one5.5x INT magic hit, Lightning and25% slow
for2 seconds per enemy. The old stationary spiral is no longer cast. Item text
and native targeting radius reflect the new mechanic.

Ashen's `file00001323` ribbon used a Blend material over an opaque black airflow
texture plus a near-black green tint. `build_ashen_crossfire_effect.py` makes the
item-only `wos_AshenCrossfire.mdx` copy: additive ribbon material and orange BGR
color; mesh, particles, sequences and textures are unchanged. The model is
installed by the existing assets/effects pipeline. Ashen projectile height220
is100 above its prior120. `test_elemental_item_followup.py` executes missile
height/scale, capsule geometry/live endpoints, thread pulse cadence, one-hit
lightning sweep, finite straight movement and binary material/color contracts.
`test_item_debuff_cycles.py` checks the three pitch-driven Anchor landings.
Native ribbon appearance and pitch rendering remain Warcraft QA.
MAIN/STABLE rebuilt: 5462-function compiled/source parity PASS, 7003 archive
files, 11 extracted script/object/model/import payloads match the scenario.
40 focused tests PASS; final sync: zero binary/source differences. Evidence:
`_build/elemental-visual-followup-main-build.log` and
`_build/elemental-visual-followup-main-result.json`. Prior STABLE/root snapshots
were backed up; the game was not launched.



### Elemental cooldown families, mana tiers and cast budgets (2026-10-28)

Current duration contract (2026-10-31): A03T elemental/reaction ranks1-8 last4s;
Fire's per-dummy duration override starts at4s and Zanka extends it to6s.
Kurikara A0DZ and Ashisogi A110 also last4s. Native and runtime overrides must agree.
Toji's Agility-item exception belongs to RefreshItemCache: enumerate every
ability on each Purchasable-class item and call BlzSetUnitAbilityManaCost for
that carrier only. Never edit the global ability object to make these free.
The item class is the canonical Agility catalogue class (stage_item_editor_classes).
Hero wave regression tests cover this, per-target TTW lightning deadlines,
continuous Burner charge, Inori's preserved five FQ hits, and barrier re-entry.
Current item follow-up: Mirror Tide marks last4s, hold4 charges and throttle
random-enemy water missiles to0.1s within800; the missile uses the stock Water
Elemental attack model at scale2. Anchor remembers first-contact victims in g2;
its shared per-target DISARM instance locks Aatk for2s and finish restores it,
including caster removal/death cleanup. Ashen uses separate outbound/return
hit sets without excluding outbound victims from return. Coil pulls its caught
group until0.3s after first contact, then switches to the four stationary ticks.
Tests: test_element_wave, test_fire_item_effects.

Frieren T2 now travels1800 units after0.54s preparation; effects reach full size
at0.84s. Only the two instances paired by the same cast can merge within360 units.
They converge to their shared midpoint over0.18s. The real-caster instance owns
four shared bursts, first after0.5s of smooth growth and then every0.4s; the
secondary only cleans up after convergence. Each burst spends one quarter of
the combined remaining budget and pulls within1.25 times its damage radius. The combined
budget is each source's (dmg2 + dmg*(6-damagePulses)) times its clone multiplier,
matching DmgSys before the real-caster bursts. Already-spent ticks are not
repeated. All detonations pull enemies inward. Partner links clear before
convergence/deallocation so recycled struct ids cannot detonate unrelated casts.
TW with a nearby clone creates one carrier, scales damage by the configured
clone percentage and doubles radius/lightning reach. Its visual orb scales1.7
instead of2, lightning scales0.8 instead of2, and ambient VFX spawn every0.21s
instead of0.12s, independently of gameplay radius. Clone damage percentages
in R/TW tooltips come from Frieren globals. Collision cash-out and TW radius/
damage are executed by test_element_wave; native effects still need game QA.

`tools/balance_active_items.py` owns54 active ability mana overrides (0/80/125/150/175)
and23 Fire/Water/Lightning item family assignments, including old barrels and
Kusanagi grades. Utility actives, Slime modes and Bunshin cost0. Damage actives
cost125-175, Shiki Knife Evolved costs80, Return by Death costs125. Susanoo's
passive shield proc retains105. Shop title mana and family classification are
generated pure functions in WoS_Shop_Init.j; --fix updates those functions too.
New overrides must be staged via configure/normal object APIs, never by adding
unsupported editable keys or hand-editing raw metadata. Item stage27/28/28b and
the evolved Blood Pact generator preserve this policy. Item audit adds only a
short `Shared CD: <element> items.` line, leaving the native mana display intact.

Each family uses ONLY the native item `cooldown_group` / icid field, pointing to
A145 (Fire), A146 (Water), or A148 (Lightning). The additional hero-owned hs
expiry introduced in the first implementation ignored native cooldown resets:
items looked ready after reset but CastCheck still rejected them. Removed that
expiry, all ItemsElements shared-CD helpers, the CastCheck rejection/commit hooks
and the pickup reapplication. Native cooldown/reset behavior is authoritative;
do not reintroduce a second cooldown clock for these families.

Own damage of the18 core elemental actives is at most5x stat per target per cast,
including every item follow-up; Shark Trail and Red Flower retain6x and fly25%
faster. Elemental reactions, hero modifiers and Sacred Gear remain external.
Ember3.5+1+.5; Grasp3.25+1.75; Verdict4.5+.5; Bastion4.25+3*.25; Cinder4+1;
Mirror/Volt4.5+.5; Phoenix3.25+1.25+.5; Crimson3+1.75+.25. Ashen's outbound and
return hit sets remain disjoint. Volt's other enemies can take3*.9, excluding
the primary target. Damage-active native cast distances are1600, except Shiki
Knife Evolved at2100; fixed projectile travel/preview globals follow them.
Raijin's blast/native area is450.
`test_elemental_item_balance.py` validates native family/mana parity and budgets,
absence of reset-blocking script state, plain axe spawns and orange ribbon nodes.

Projectile art is controlled by named constants next to MirrorTide globals in
`triggers/Items/Items.j`: MirrorTide_ProjectileModel/Scale use wos_file00012198
at0.66x for BOTH wave and counter-shot; AshenCrossfire_ProjectileModel uses the
wos_mx-yx-tsw-a-1_fire copy; ConstellationCoil_ProjectileModel uses wos_tx28 and
CP75 restores Constellation projectile travel to1800 and hit width to250; native click range remains1600. `build_elemental_projectile_assets.py` accepts a
source directory argument and stages the models plus required textures under
assets/effects. Axe diffuse is unchanged; only blue surrounding effect textures
-2/-3 are recolored red-orange with preserved alpha/brightness and separate paths.
Both RIBB nodes (and any KRCO animation keys/tangents) are explicitly orange.
Ashen axes use EffectSpawn, with no EffectSpawn3/pitch=-90 override; the previous
override pointed the axe models in the wrong direction.
This replaces the earlier file00001323 ribbon copy for Ashen. Project assets
installation registers these files; personal source paths are not persisted.

Publication evidence after the native-CD reset correction: compiled/source
parity5462 functions PASS; archive7016 files.11 extracted payloads match the
scenario; packed script has no custom family cooldown state, all three axe
spawns use EffectSpawn and Mirror scale is.66. Packed item data retains23 native
family icid assignments; both ribbon nodes in the packed axe are orange.
38 focused tests pass; final sync has zero binary/source differences. STABLE/root
snapshots were updated after backup. Evidence:
`_build/native-element-cooldown-fix-main-build.log` and
`_build/native-element-cooldown-fix-main-result.json`. Native reset behavior and
visuals still need Warcraft verification; the game was not launched.


### Item reactions, recipes and input follow-up (2026-10-29)

Inverted Spear of Heaven (2026-10-30): I074 / active A161 / curse A162 /
buff B074; objects and Bazz-B W/E/R cooldowns are staged by
tools/stage_inverted_spear.py. The Universal recipe is Pakkun +10 (I034) +
Pakkun +5 (I01J), with a 4500 combine cost (7500 total), +15 allstats,
20 sec active CD, 800 cast range. A timed ItemsAnimeEffect.KIND_SPEAR instance
owns a five-second target deadline. Dispel can remove the native icon only;
the deadline remains authoritative for damage and the shared 0.1s item ticker
restores the icon. Refresh reuses the instance; death/expiry clear it.
DamageBlock ignores 50% of positive total physical/magic resistance before
ApplyGearSystemFullShields. The pure helper factors Crocodile's channel and
Frostnova E reductions through their existing combat/HUD positions so combined
resistance is halved once; neither shield consumption nor invulnerability is
bypassed. Negative resistance is not amplified by this effect. Tests:
test_inverted_spear plus shared item lifetime/vision/range and resistance UI
suites. Anime-frame attribution/crop are kept beside the source image and in
build_item_icons.py. Warcraft visual/input acceptance remains separate.

Elemental ban checks exempt only inventory slots consumed by the incoming recipe
(2026-10-30, Funny Barrel -> Tusk Barrel). ShopPlanCraftSlots mirrors recursive
recipe selection, including duplicate-slot accounting, without pricing or item
removal: these checks also run in local shop rendering. Extra same-element items
still block buying. Executable coverage: test_item_shop_followup; refunds remain
covered by test_shop_refund_bans.

Hero re-entry follow-up (2026-10-30): Ainz W resets the old charge lifetime-pause
and W3-ready flags at each fresh summon and clears the pause on teardown. Its
first summon uses a one-shot state rather than r == 0.03, which could respawn
knights every tick when the timer was paused there. Original W cooldown upkeep
is preserved. Inori E reconciles the existing activation rawcode's availability,
unit disable and hidden state at four stacks, independently of the stack-change
marker; previously only adding a missing rawcode restored those properties.
Production-loop tests cover a stale Ainz charge pause and three Inori E cycles,
including an existing hidden/disabled activation button. These reproduce state
paths, not native game input or the user's exact match.

World Editor normalization on 2026-10-30 removed explicit empty/zero/default
overrides without changing surviving field values. A workflow rebase faithfully
imports these deletions too. Restore intentional stock-art/bonus/slot overrides
from the last verified packed objects via the object codec, checking all surviving
values before restoration; rerun neutral/presentation and editor-class checks.
Do not infer that a successful rebase preserved raw-only explicit overrides.

Reaction attribution previously used the input element before resolving Water +
Lightning, recording Electrized as Water/Lightning. ErzaPassive now assigns its
-100-level tag after reactions resolve. Quincy uses a dedicated same-hit-safe
predicate for all sources (2026-10-30: including Kurikara, Ashisogi Jizo,
other periodic item damage and reflections), with no minimum/maximum positive-hit
threshold or enemy-only gate; no new damage event is scheduled,
and the existing quincyShare statistics split remains authoritative. Offensive
proc exclusion remains intact except Tachikaze explicitly accepts Koko's -103
Lightning tick. Poison/reflection exclusions and explosion self-proc guards stay.
Raiden E still dispatches A002 (including TE/TTE) and applies Lightning; Nejibana
retains its200 final-damage threshold and2x main-stat proc. Reaction tests execute
Water + that Lightning, all five Electrized ticks, and dealt/taken Quincy totals.

Siren drains min(2.5 INT,20% target max mana) across8 ticks. Its .25-second timer
now preserves remainder on the .03-second update, fixing the missing eighth tick.
Samehada restores/drains5%; Naofumi Evolved blocks30 passively/100 actively;
Stone healing against nonhero targets is halved. Stat resistance coefficients
are .15 per AGI/INT (+25% versus .12); native armor per AGI remains .1.
Return by Death uses its original wos_hmr-guanghuan and wos_watchaura4 models.
Anchor no longer spawns the tornado and pulls at240/sec. Okarun Q cooldowns are
20/19/18/17/16. No hidden elemental cooldown clock has been introduced.

InitCraftRecipes includes all15 previously componentless new items. Every
purchase path rechecks CheckBanItems: one active from each native elemental
cooldown family, including auto-buy and whole assembly. Kusanagi element swaps
remain available when the resulting family is free. Shop headings show nonzero
mana before the item name. Hyorinmaru capture latches the assignment key in the
existing trigger-scoped WUI_InputState until key-up; capture itself cannot cast.

Evidence: test_item_shop_followup.py executes recipe affordability/cycles, all529
family pairs, purchase rejection without payment, reaction/Quincy attribution,
Koko/Tachikaze, eight Siren ticks, and assignment/release/next-press input. Existing
item balance, descriptions, range, debuff, Samehada, Return and damage-stat suites
also pass. Legacy test_quickbuy_fix4 has the same4 failures/10 errors against the
staged pre-change source and this source (missing old fixture natives and stale
expectations); evidence is _build/quickbuy-prechange-baseline.log. Native visuals,
input dispatch and multiplayer still require Warcraft III acceptance.

Publication: MAIN and WOS2_MAIN_STABLE.w3x rebuilt; parity5467 functions PASS,
7016 packed files. Twelve extracted script/object/model payloads match MAIN;
54 mana overrides,23 icid families,27 native damage cast distances verified.
All111 focused tests pass; final sync reports0 binary/source differences.
Previous STABLE/root snapshots were backed up before replacement. Evidence:
_build/items-shop-followup-main-{build.log,result.json},
_build/items-shop-followup-focused-tests.log and
_build/items-shop-followup-final-sync.log. Warcraft was not launched.

### Native item cast distance field types (2026-10-29)

The active-item balance staging mistakenly changed 27 native aran records from
unreal (binary type2) to real (type1). Editable JSON still showed1400 and old
value-only tests passed, while the user observed zero cast reach in Warcraft.
Raijin aare had the same type regression. Native distance/area overrides must
use unreal even though BlzGetAbilityRealLevelField is the runtime getter.
balance_active_items.configure now stages correct types and1600 cast distance,
except Shiki Knife Evolved at2100. Its checker also detects type regressions
with unchanged numeric values. Fixed travel distances, item ring fallbacks and
descriptions follow those values; passive Shiki reach remains650.

Point-directed skillshots A06Q/A09L/A09N/A0HY/A14B/A14C/A151 clear only the
Channel Targeting Image bit (Ncl3 & ~2). Actual hit widths/native areas and
other Channel flags remain intact; point-centred blasts keep their cursor discs.
The elemental balance suite serializes and reparses w3a, asserting native types,
distances, marker flags and Raijin area. Warcraft input/rendering still needs
in-game acceptance; binary checks alone do not establish live engine behavior.

Publication:48 focused tests and MAIN compile pass; compiled/source parity5467
functions and7016-file archive pass. Seven extracted native/script payloads
match MAIN; all27 packed aran records use unreal and the expected1600/2100
values, with no skin range overrides. STABLE and root snapshots updated after
backup. Evidence: _build/item-cast-range-fix-main-build.log and
_build/item-cast-range-fix-main-result.json. Game was not launched.

### Item marks, instant orders and recovery contracts (2026-10-29, CP75)

Conditional elemental effects previously lived only in ItemsElementsFx records,
so dispelling the visible element did not remove retaliation/thread/ricochet logic.
Their native mark buffs now own validity (HasMark and periodic removal detection).
Ember/Phoenix burns have separate dispellable buffs. Cinder stays for three seconds
after its one bonus hit; native regen is cancelled with additive offsets and
restored without overwriting stat changes acquired during the seal. Systems1's
HUD/regen amp and Systems2's restore/mana-floor paths also honor the Cinder buff.
Mark IDs are in elemental-marks-ids.json; the allocator must reserve TEST JSON/J
IDs as well as MAIN. Altair's A11E..A128 service IDs remain untouched.

Instant order references: Hive threads 292477 and 260836 distinguish truly instant
Berserk from queue-instant Battle Roar/Roar and confirm duplicate Berserk conflicts
on hero slots. stage_instant_foundations.py preserves generic metadata and every
rank while removing Channel-only fields. Do not rebase native Mirror Image items
or order-dependent/channelled hero actions blindly. Item abilities explicitly use
aite=1/aher=0, independently of hero order families. Bambietta's scripted pause
uses Start/StopSpellUnitQueued; Toji F relies on Berserk instead of a move replay.

Core Drill non-attack stacks are outside ItemDamageCanProc: that guard still blocks
offensive item recursion, but periodic item/element hits may grant Core stacks.
Inori T2 subtracts resistance points after Ainz's reduction and caps only its own
contribution at zero resistance. Both HUD and actual mitigation share this path.
Inori E service aura rank 6 is not a learnable sixth level; AHUI uses base A09S's
five-level schedule even while another E occupies its slot. AHUI resolves the
actual A061 aura rank for its readable icon (including E form), A06U at four
stacks, or A06D during T2. Disabled-visible and hidden abilities are distinct;
Harribel E2 remains a DISBTN during W and only an active candidate accepts input.
Native disable/hide functions are counters, not boolean setters: Harribel EW
locks E2 once at start, never each tick, and balances the lock on cleanup.
InoriE_SetBaseHidden writes only on transitions; readiness reconstructs a stale
EE button once per cycle instead of repeatedly enabling/unhiding it. Aura
initialization does not issue an unmatched enable. The displayed A061 tooltip
contains the full passive; its custom counter panel is level112 above the
level101 icon, with text113. Its size now uses the native TasBox BOX_SIZE
(0.0135); AHUI_AbilityCooldownRemaining reads the learned A09S timer for A061
and A09T so aura rank swaps retain the real E cooldown without changing the
native aura delivery base. Regression: test_merge_followup,
test_inori_aura and the actual TasBox-to-AHUI live-stack test. The allied E aura and
Instability are disabled while E remains unlearned.

Game Info/shop/tooltip layout, local gold ownership and native mouse preservation
are documented at RESUME CP75. Integer mana regen is not an object-data ability:
MAIN packaging must run install_gameplay_constants.py to keep Misc.IntRegenBonus
identical to Systems1.int_mpregen (0.15). Elemental skillshot cursor discs remain
off; Constellation has a 1600 click range, 1800 travel and 250 hit half-width.
Evidence: test_elemental_marks_followup.py, test_item_ui_resistance.py,
test_inori_aura.py, test_core_drill.py and test_damage_stats.py. Engine rendering,
manual order retention and multiplayer still need in-game verification.

Round purchase follow-up: ShopCanPurchase is the shared transaction gate for
manual purchases, FAST BUY, BuyAuto/BuyAutoLimited and QB_BuyWhole. Combat is
blocked in every normal mode; TestMode explicitly permits combat purchases and
Quick Buy outside base. Existing half-second scheduling disables the normal-mode
buy/FAST BUY controls. The opening forced purchase runs before CondArena becomes
1, while deferred acknowledgements cannot grant a combat purchase exception.
New-round initialization resets TestPrimaryDeadTicks.

Top portraits restore cached artwork on public death/revival changes even when
the enemy is unseen, without reading hidden type/vitals. Living HP fill has a 2%
visual minimum so Will of D.'s 1-HP survivor is distinguishable from a corpse;
actual HP is unchanged. Shared damage helpers accept life > 0.405, so spells can
damage a 1-HP survivor when protection expires. Patriot's revival cleanup only
announces/kills an existing living hero; an earlier death still clears stance,
VFX and timer ownership without a duplicate kill. Evidence:
test_round_purchase_survival.py and test_wos_ui.py (mocked native behavior).

CP75 MAIN/STABLE publication passed compiled/source parity (5485 functions),
packed/native field checks and 246 focused tests. The old Rimuru Black Flame
fixture is excluded, not repaired by this task. Archive/result pointers and
remaining Warcraft acceptance limits are recorded in RESUME CP75. Final project
sync reports no binary changes or source differences.

Will of D. follow-up (2026-10-29): cooldown is 180 sec in Items.j, native A138,
the staging generator and item text. Protection is bound to positive buff B05B;
the shared ItemsAnimeEffect clock owns its VFX and cancels the saved deadline
on dispel/expiry/death. A 0.20 sec initial grace permits native dummy application;
Kairoseki clears the deadline immediately even inside that window, so a late buff
cannot rearm protection. This ends the damage floor, without an artificial kill.
Round-end cooldown reset remains. Evidence: test_will_of_d.py (6 cases) and
test_return_by_death.py (5 regression cases); native behavior still needs game QA.

Will of D. follow-up published to MAIN/STABLE: 11 focused tests passed; native
180-sec cooldown and both packed item descriptions verified, including skin
overrides. Final sync: 0 binary changes / 0 source differences. Result:
_build/will-of-d-main-result.json; SHA-256 c3d56e669a619cdab3d08ce64546d0ccd589a5e846708e6eaaed4e3a88f6e0cb.

### Tooltip startup string-allocation regression (2026-10-29, CP76)

Cause: runtime cleanup rebuilt each description in six character-wise passes,
repeated it for every research rank, and chained SpellData setters rebuilt all
initial tips before final metadata was available. This magnified native string
allocation before WUI_StartupEnd. The optimized contract is one changed-span pass,
one normalization per builder content, one final render per registration job,
and one reused hidden native-field probe. Constant templates share their parsed
result across ranks; tagged templates keep distinct rank results. Existing native
tooltip write comparisons and dynamic hero/form updates remain.

WOS_UTB_FlushInitialTips must remain public because ExecuteFunc resolves its literal
compiled name. Alternate forms skip initial global-tip writes; runtime setters
refresh immediately. Evidence and mocked before/after measurements are in RESUME
CP76 and test_tooltip_startup_performance.py. Static checks do not confirm Warcraft
load time or reproduce the reported native freeze; verify the rebuilt map in game.

CP76 publication: MAIN/STABLE updated after compiled/source parity passed (5489
functions, 7016 archive files). All 491 registration job names remain; the public
flush resolves in compiled JASS and initial render creates no units. Packed code,
objects, effects and WTS match the scenario. Existing World Editor object changes
were safely rebased by the standard workflow and verified unchanged against the
pre-build scenario backup; performance edits did not discard them. Native item,
description and Will of D. tests also passed after that rebase (19 checks).
Final sync: 0 binary changes / 0 source differences. Result and backups:
_build/startup-hang-main-result.json. STABLE SHA-256: a2a02e0641f5238b404c0092a4b74b621f0c25ed22ae3fa33e6d19580cd7ba07.
No Warcraft startup wall-clock or native freeze reproduction was performed.

### Shop helper text spill and native tooltip styling (2026-10-29, CP77)

Cause/evidence: user video shows all helper labels, not chat. War3Log.txt at
19:46:32 identifies invalid ControlStyle on the WOSQBHUDRemove SIMPLEBUTTON,
which aborts shared FDF parsing. Subsequent map starts log duplicate definitions.
Solution: remove the regular-control property (keep UseHighlight/textures), validate
it before asset installation, and bind engine tooltips to an empty FRAME containing
all backdrop/text descendants. WUI_TooltipBox returns that normal FRAME already hidden before art allocation.
The stats inset explicitly shows its art; tooltip callers keep the hidden default.
Do not replace this gate with a BACKDROP directly: tooltips outside 4:3 can deform
without moving/hiding their children consistently. No hover event dispatch added.

Native appearance comes from ToolTipBackground/ToolTipBorder/MasterFont in retail
UI/war3skins.txt, not a stock tooltip layout copied from CommandBar.fdf (only buttons).
ShowCD FDF templates use those keys, blended background, left text and shadow.
User visual comparison exposed native SIMPLEFRAME scaling: custom normal-frame
geometry now uses WUI_CHASSIS_RIGHT + WUI_HudShift - .030,
WUI_CHASSIS_TOP + .070, width .286, body/title fonts .011/.011. DamageStats Game-tab
tooltips also inherit their hidden owner/window, preventing empty startup boxes. Wrapped title height and HUD revision invalidate layout;
text cache, level requirements and mana content remain. Default ally color Mode 3 is
native value 2, applied once; Alt+A must remain free to change it afterwards.

Source/checks: CP77, test_native_tooltip_ui.py, test_ally_hero_ability_ui.py,
install_wos_ui_assets.validate_frame_resources; 405 focused checks, MAIN compile
and no binary object changes. Existing unrelated fixture failures documented in CP77.
Visual acceptance remains in-game. Empty-root reference:
https://www.hiveworkshop.com/threads/ui-frames-and-tooltips.316665/ .

### Ground-hero unstuck probe (2026-10-29)

Systems/EnterRegion.j now scans only selectable living ground combat units in
gg_rct_Arena every 2 seconds (2026-10-31), using one reusable group. Locust, hidden,
unselectable units and buildings never enter the repair path. This includes
summons and clones as requested; off-arena heroes/TestUnits are excluded. No chat/range message is emitted. It repairs an invalid
current centre, not a lack of movement: playable-area bounds, walkability and one
reused hidden invulnerable item probe detect obstruction (item displacement >16).
Only a blocked centre triggers the bounded search: rings 64..1536 by 64, 16 rays per
ring. A destination must pass the centre plus four diagonal points at +/-24. First
valid point wins; SetUnitX/Y preserves orders. Null/removed/dead/hidden/paused/flying,
fly-height >50 and active spell-p units are skipped. The ordinary path needs only a
centre probe; no per-tick item/unit/group allocations. Source tests:
test_elemental_marks_followup.OrdersAndUnstuck and MAIN compiler/dispatch audit.

Base phasing (2026-10-31, corrected scope): BasePhaseApply gives native Ghost
(Visible), Aeth, only to eligible units inside gg_rct_Base, on base entry with
the existing 2s scan covering revives and late selectable state. All eligible
sides at base receive it so they can pass each other; arena units retain normal
collision. The same reusable group scans Base for phasing and Arena for unstuck.
No Wind Walk orders, SetUnitPathing(false), transparency, invisibility or combat
stat changes. Base exit and Arena entry remove Aeth even when copied by an illusion without
the marker. The Arena scan also clears inherited Aeth; Aeth is reserved for
base phasing (there are no preexisting native Aeth owners in object data). Permanent ability survives morphs; scan retries
if a form replacement removes it. Native collision/terrain/invisibility/cast
acceptance still needs Warcraft QA. Hive first-hand test reports Aeth makes a
unit passable to others, so both sides need it:
https://www.hiveworkshop.com/threads/ghost-spell-without-invisibility.250091/ .
Wind Walk negative transition was rejected here because interaction with Apiv
can prevent attacks and casts can interrupt the buff:
https://www.hiveworkshop.com/threads/passive-go-throught-units-like-wind-walk.354569/ .
DragCaught belongs to Constellation Coil's COILSHOT pull, not the unstuck repair.
No effect index optimization or damage/resistance/shield/heal changes included.

### Elemental item effect carriers and return snapshots (2026-10-29)

Items.j ItemsElementsFx.SEALCAST (12) owns Phoenix Seal's sword. It follows target
XY while pending, descends from +1500 at scale .5 / initial time scale .08, adds .03 speed each tick
and calls Arrive once at the first tick >=.30 sec. Invalid
pending targets cancel. Burn is spread over six .5-sec ticks; hero-cast reaction
is 2 INT. The shared .03 clock owns cleanup, including the extra Ashen trail handles.

Crimson preparation lasts .44 sec (AiSi_DaYanJieYanDi_2 at .5 speed, scale1.995),
then hits once for 4 INT and pulses six times at .20-sec intervals, 4 INT total.
The last pulse owns completion, avoiding a floating-point expiry dropping damage.
Firebeam time scale1.12 with proportionally stretched fade. Ember's firefly pair
uses existing EUTU2 ownership.

Ashen's three pitched EffectSpawn3 models use wos_file00000526_orange, scale2,
height160, pitch-90, facing+90, speed1540. Each has a Windwalk Fire2 trail. At the
outbound endpoint capture caster XY into tx/ty; return interpolates each outer tip
to that snapshot. Distinct hit groups preserve outbound/return damage rules.
Mirror grows from radius350 to525 by mid-flight, scale.66 to.99. Any applied hit
>100 can spend its dispellable mark's charge, regardless of source/caster. It
launches from the marked unit to its nearest ally valid as the item's enemy;
once/sec, max3, clones allowed. Enumeration uses the mark's own group so a nested
damage callback cannot clear the active AoE iteration's shared group.

Coil flies1800, pushes hits60, then stays at its endpoint for2sec. Its visual and
radius grow to2.5x with fading; four half-second pulses each deal1 INT, apply
Lightning/slow and break scenery. Random lightning effects spawn only on pulses,
not every frame. The krk trail is owned alongside the main model.

Anchor uses the item-only G2 NoSpray copy (tools/build_anchor_item_effect.py),
preserving the hero model. The old embedded emitter and Zaraki crack effect stay
removed; requested CrushingWave attachment plus Harribel214/blue-morph water are
separate. Three2.25 STR impacts share .60/1.20/1.80 deadlines. Smoothstep tilt
alternates pitch0->PI/2->-PI/2->PI/2, sin-squared rebound height gives zero landing slope.

Return by Death uses PosUnit (SetUnitX/Y via bounded pathable steps), preserving
orders; deadline5sec. Native A155 adur/ahdu are5.25sec, staged by
stage_return_buff_duration.py so the dispellable buff outlasts that deadline.
Ice Coffin uses the retained custom wos_icecoffin model.

The reported intermittent solo order/pathing issue concerns TakeshiF_Start (UI G,
style switch), not Cambio G. Its switch has no pause or periodic order replay;
Incursio's MUE only displaces for.3sec. Do not claim a reproduced root cause or
add a stop/reissue watchdog: those would themselves break order preservation.
Relevant first-hand reports: Hive threads302685 (frequent order/path scheduling),
270085 (item-slot orders),163683 (instant abilities). Engine acceptance remains
in-game; fixtures do not emulate native pathfinding or animation rendering.

Checks: test_fire_item_effects.py, elemental follow-up, debuff cycles, mark
fixtures, round-purchase and item-description checks; MAIN compile/dispatch.

Published MAIN/STABLE: _build/elemental-v2-main-result.json. MAIN compile and
compiled/source parity pass (5489 functions); 57 focused execution checks pass
(three previously documented stale fixtures excluded). Packed model payloads
match scenario inputs; native field audit allows exactly27 requested changes.
Final sync:0 binary changes /0 source differences. No in-game VFX/pathing claim.

2026-10-30 follow-up: Anchor landing Z is terrain+50; each pulse slows40%.
Thunderclap ground impacts accompany water. On the third impact ColorEffDummy3
owns the .5-sec fade; clear .e before carrier cleanup to avoid double destruction.
Demon-Dweller A0HX adur/ahdu are4sec at both ranks; Suzumebachi I072 costs6000.
Element passive texts in check_item_descriptions read source multipliers (bonus
percent = (multiplier-1)*100), not stale hardcoded values.

Published follow-up: _build/oct30-main-result.json. Crimson ground damage is
six .2-sec pulses (4 INT total over1.2sec); initial4 INT and .44sec preparation
remain. MAIN/STABLE packed parity and57 focused checks pass; native audit allows
35 requested fields only. Final sync0 binary/0 source differences; game visuals
were not exercised.

### Shared spell pause deferral and instant cast state (2026-10-30)

Observed report: input can remain blocked after an instant item/hero cast, including
Ice Coffin and Takeshi styles/abilities. All55 Absk/ANbr/Aroa native foundations
already have adur/ahdu .01 at every rank; shortening them again is not the fix.
A matching first-hand engine report describes PauseUnit inside Berserk's spell
event stranding control: https://www.hiveworkshop.com/threads/paused-unit-invisibility.352993/ .
The initial global deferral was rolled back after in-game animation regressions:
ordinary StartSpellUnit/2/2_2 now stop and pause synchronously before the caller
sets its animation. GearPauseSpellImmediate retains extended-pause ownership.
DebugUnit/2 again pause synchronously. Only Ice Coffin uses GearPauseSpellStart's
shared .01sec one-shot queue, outside player/unit CAST/CHANNEL/EFFECT events.
Legacy queued helper functions remain for compatibility, with no hero callers;
Bambietta W again uses ordinary Start/StopSpellUnit pairs on Channel.
GearCancelSpellPause removes pending work before it can strand a finished spell.
GearStopSpellPause releases only an actually applied extended pause owner, with
no native unpause after cancelled/dead pending starts and no extra decrements
from duplicate cleanup. Other engine stuns are not cleared. Ice Coffin shares the
same mechanism, guards its ownership with armed, cancels on round end and still
keeps its original2sec protection. Direct actor PauseUnit calls audited in other
hero start functions use Channel (Barragan/DarkShiki/Kyoraku/Milim/Starrk); dummy,
pick/death and tooltip-probe pauses retain their purpose. Do not add global
unpause loops or reset native stun counters to repair a single spell.

Source: Systems2 shared helpers, Systems1 DebugUnit, ItemsAnimeEffect/CoffinStart.
Execution checks: test_spell_pause_lifecycle.py (same-event cancellation, duplicate
keys, ordinary/extended ownership, expiry, external stuns, per-unit spell events).
This establishes the unsafe ordering was removed, not an in-engine reproduction.

Ashen weapon height220, separate trail height160. Anchor impact centres move0/-80/+80 along cast direction; the model starts at
-PI pitch, then lands at-PI/2,+PI/2,-PI/2, terrain+125 every.6sec.
Phoenix calls Arrive once, sets speed2 then DestroyEffect, nulls handle before
carrier finish. Tests verify no duplicate impact/destruction.

Ranged base intervals staged idempotently by tools/stage_ranged_attack_timing.py:
H002/H018/H01Z/H020/H02E/H02H=1.8sec, H017=2sec; Inori H017/H018 base damage10 in both forms.
These are the seven permanent ranged hero/form objects, excluding Hblm menu unit
and summons; temporary range extensions keep the hero's own attack timing.

Publication: _build/pause-main-result.json. MAIN compiled/source parity5493
functions,68 focused checks pass (three previously documented stale fixtures
excluded). Packed source/effects match scenario; exactly9 unit values change,
native types and all other object files are unchanged. Final sync0 binary/0
source differences. First pending request arms the shared timer; additional units
join that batch without postponing it. Engine reproduction remains unconfirmed.

### Test repick round completion (2026-10-30)

A removed primary Hero was excluded from TestUnit_PrimaryDefeated, leaving zero
primary participants while the test enemy remained in combat. Missing/removed
human primary heroes now count as immediately defeated; ordinary deaths keep
the existing four-check/three-full-second revival grace. TestUnit_EndRoundForRepick
runs after primary removal in both the test replace-picker branch and Repick.
In TestMode combat only, it sets TestRepickRoundEndPending and schedules a zero-delay tick of
IntroStart1, using the existing PrepareStart round-end teleport/reset/cleanup branch. The flag
forces that branch even if other primary heroes remain, and is cleared when the
round ends. No separate enemy teleport/round-reset implementation or extra timer.
The zero-delay callback restores IntroStart1 to its normal1sec periodic cadence
before running round cleanup. This avoids ExecuteFunc in the frame call graph.
Source/test: WoS_Pick_Init; TestRepickRound in test_elemental_marks_followup.py.

Anchor's initial model height is terrain+1325, pitch-PI. Smoothstep descent to125
and-PI/2 lasts.6sec; then rebounds to450 above terrain, centres80 back and80 forward, pitches
+PI/2 then-PI/2. Damage/drag and impact visuals share the moving centre. Existing
3x2.25STR,40% slow,water/ground impacts and final.5sec fade remain.

Published: _build/anchor-repick-main-result.json. MAIN/STABLE parity5494
functions,73 focused checks, UI dispatch0 errors. Native audit allows4 Anchor
text fields only; other objects and WTS unchanged. Final sync0 binary/0 source
differences. Wait for workflow process completion (MPQ Pack OK), not merely the
earlier JassHelper BUILD OK, before extracting/comparing the output archive.
In-game animation acceptance remains pending.

2026-10-30 ranged/anchor adjustment: repeat anchor arcs now peak at terrain+450
(125 landing plus325 sine-squared lift), preserving.6sec timing and tilt/centres.
Base damage: Frostnova/Ainz/Frieren10, Inori both forms10, Alucard both forms20
unchanged. stage_ranged_attack_timing.BASE_DAMAGE stores final values so restaging
cannot repeatedly subtract10. Existing attack intervals are retained.

Published ranged/anchor adjustment: _build/ranged-anchor-main-result.json.73
focused checks pass, including450 peak/125 landing. Native audit allows exactly
5 base-damage values and preserves native types/other objects. Packed MAIN/STABLE
parity passes; final sync0 binary/0 source differences.

### Paused Channel foundations and anchor pivot correction (2026-10-30)

Correction after user review: only a pause immediately on button activation
requires Channel. A later counterattack or triggered pause is a separate action
and must not rebase the activation button. The broad eight-button migration was
reverted for seven buttons to their exact previous native objects: Alter Saber E
A029 and Takeshi W2 A090 use their previous ANbr conflict fallbacks; Kyoraku R
A053, Tsuna W A083, Takeshi defensive Q A093, Rimuru2 Q A0A3 and Mahoraga E2 A0CI
use Absk. Only Bambietta W A0DF stays Channel (immediate scripted windup pause).
Takeshi Q2 A08Z was already Channel. Ice Coffin A13C remains Berserk with its
separate deferred pause/ownership guard. All seven native objects, including
ranks, mana, unlocks, icons and descriptions, were restored exactly from the
pre-migration packed map. Subsequent explicit exception: Erza F A030 (form exit)
uses Channel with spellshield order and an explicit stop in ErzaF_Start, because
continuing movement on exit caused gameplay bugs. PAUSED_CHANNELS contains A0DF
and A030; stock art, buffs and sound are empty and F remains at (1,1).
Regression checks distinguish these exceptions from delayed counterattacks.

Neuvillette R owns Avul only during preparation: StartSpellUnit at activation,
DebugUnit while check==0, remove Avul on beam launch, then DebugUnit2 and
StopSpellUnit2. Interrupted preparation uses StopSpellUnit to release Avul.
Charge and beam effects each go once to ColorEffDummy3 (fade plus destroy);
never DestroyEffect before handing the same effect to that fade owner. Hand
attachments are destroyed directly. test_combat_cast_followup executes launch,
death before/after launch, single effect cleanup and Frieren Q's 0.75s timing.

Anchor visual correction after in-game feedback: use the original, unmodified
war3mapImported/wos_EF_AZ_Leviathan_G2.mdx, including its attached PRE2 water
emitter. NoSpray is no longer referenced by gameplay; do not regenerate or patch
the original model. There is no second detached CrushingWave water effect.
All motion is trigger-only: first.6sec fall is250+1800*(1-t*t), starting2050;
subsequent.6sec rebounds are250+2600*t*(1-t), peaking900. Pitch interpolates
-PI to-PI/2, then-PI/2 to+PI/2, then back, with smoothstep; it adds no height
correction. Centres remain0/-80/+80 and ground/water impact bursts remain.
Keep three2.25STR hits,40% slow and final.5sec fade. Actual scaled mesh vertices
clear terrain by at least50 in execution checks. The original embedded water
moves/rotates with the model automatically; do not recreate a stationary puddle.
Tests validate three impacts, original water emitter, trajectory and cleanup.
Compilation/static execution do not establish visual acceptance in Warcraft.

### Instant button presentation and effect coordinate follow-up (2026-10-30)

Rebasing did not override base button coordinates and every stock presentation
field: inherited Berserk/Roar positions collided with other HUD cells, despite
the explicit AHUI logical slots being correct. stage_instant_foundations.py
--presentation-only clears native art, attachments, sounds, animation names,
buff/effect lists at every rank and sets normal/activated/research coordinates
from the existing AHUI slot table. Normal/custom icons and gameplay text remain.
Laxus F is explicitly placed beside G; Bambietta W remains Channel at(1,2).

Inori A06U uses Aroa, coexists with F Absk and G ANbr, and is mutually exclusive
with the T2 cancel A06E. At four stacks the added button is ranked, enabled and
unhidden; AHUI explicitly prioritizes it over still-live service aura candidates.
InoriAttackArt updates the native attack interval too: crystal1.8/base2.0, because
BlzSetUnitSkin alone does not apply the skin object's weapon gameplay values.
S cancellation latches are driven by active spell flags without a raw type gate;
both key-down and key-up are registered, with idempotent writes. No stop order is
required from a paused native command card to end the timed spell.

AnchorGround is one shared Location. Anchor startup samples terrain directly;
it never reads back a newly created effect's height and subtracts2050. The whole
X/Y/Z position is applied together every tick, after computing the trajectory.
Height does not depend on current rendering or individual X/Y setters. Original
G2 mesh and attached water remain unchanged. A regression test uses terrain432
and makes any same-thread effect-Z getter fail; startup must be2482.

Milim's wos_file00001145.mdx embeds EVTS SNDxAHFS and SNDxAHFT. The dedicated
wos_MilimW2_Silent.mdx copy removes only that EVTS chunk; every other chunk and
the shared original are preserved. Generator: build_milim_w2_effect.py.
Shop gold plate is.092 wide, shifted left.030; numeric text gains matching width.
Checks: test_instant_button_presentation, spell pause/fire/item tests, selected
AllyAbilityUI form/cooldown/learning checks and check_wos_ui compile/dispatch.
Visual/audio/input acceptance in Warcraft remains separate from these checks.

Instant native neutrality follow-up (2026-10-30): all55 custom Absk/ANbr/Aroa
buttons explicitly set atar=enemies and aare=0 at every rank in BOTH main and
skin objects. Native Absk bsk1/2/3 are zero. ANbr's damage is Nbr1, not Roa1:
zero Nbr1 and Roa2..7 on ANbr; zero Roa1..7 on Aroa. Roa2/5/6/7 are integers,
other bonuses are unreal. Inherited Nbr1 had survived the earlier Roa1-only fix.
configure_neutral is shared by regular and presentation staging; --neutral-only
applies just these fields without rebasing or changing text, levels, costs or CD.
test_instant_button_presentation validates all ranks in each native layer and
idempotence, including the distinct ANbr/Aroa damage field IDs.


Hero order / item vision follow-up (2026-10-30): hero_ability_orders.py audits
34 hero AHUI groups / 397 registered buttons (354 active,43 service/passive).
Channel Ncl6 is checked across every rank; fixed native orders are derived from
Absk/ANbr/Aroa, not editable order-string text. Cross-slot collisions fail, except
Inori A06U/A06E: EE is removed before cancel is added; cancel is disabled before
SH_MODE_T=0 permits EE again. Same-slot form replacements remain grouped.
Order rebase must preserve inherited native defaults too. Retail AbilityData.slk
has Absk cooldown30/mana0 versus Aroa cooldown0/mana100; ANbr is hero1/levels4,
cost50/CD25 by default. configure_order_bases retains effective main+skin values
without rebuilding level/cost metadata from missing convenient-view properties.
ItemActiveVision runs inside the real item-ability gate before both dispatchers:
750 minimum radius,1.5x native area if larger,2sec; unit target uses current position,
instant uses caster, Channel point(0,0) stays valid. No detection/order changes.
TooltipGoldMechanics colors plain property labels; unchanged text returns its
input. Range belongs to addRange (six extra manual copies removed). Combined
cast/active Iframe notices keep both phase values; Asta W alt has one Radius.
Frostnova R's static Winter's Scar is below the LoreOnly stats boundary, retaining
native fallback information while avoiding duplicate live bonuses.
Checks: test_hero_orders_vision_tooltips, test_instant_button_presentation,
test_spell_pause_lifecycle, test_tooltip_startup_performance and check_wos_ui.
Engine input, fog and visual acceptance still require Warcraft.


Item editor families (2026-10-30): stage_item_editor_classes.py derives classes
from ShopCatalogue_Define, retaining uncatalogued component classes and stat
tomes in Base. Existing family mapping: STR=Miscellaneous,AGI=Purchasable,
INT=Campaign,Universal=Permanent,Base=Charged,Defensive=Artifact,Attack=PowerUp.
Non-Base tabs win for cross-listed Katana. All196 items explicitly set icla in
main and skin;33 move between families. Only classification changes, not ipow,
prices, abilities or item stats. No production GetItemType/class logic was found.
Run this pass after item generators; test_item_editor_classes catches drift and
asserts every other native field survives a complete re-sort unchanged.

Reviewed command changes: A093 Yamamoto defensive Q, A03M Erza Samurai G and
A0DY Kyoraku skip use Aroa; their other instant slots keep separate foundations.
Channel Ncl6: A03L clusterrockets,A03O carrionswarm,A113 charm,A0FS grabtree,
A0A0 ancestralspirit. Native field IDs/costs survive in both object layers.
Publication passed50 focused tests, MAIN compile/dispatch,5499-function parity
and packed native/payload scope checks; MAIN/STABLE updated. Final sync is zero.

Active vision area follow-up (2026-10-30): all60 active primary ability IDs are
executed through the real ItemsCast gate in test_item_trail_vision_train. Cast
radius is max(750,1.5*native area), with Hashirama's script-only700 ally area
explicitly retained despite its zero-area instant foundation. No true sight.
ItemsElementsFx.Update refreshes visible projectile/ground areas every0.15sec
for0.30sec, using remaining lifetime modulo150ms; no per-effect timer added.
Each Ashen shuriken reveals its own outbound/return position; COILSHOT reveals
both flight and the whole growing2sec spin using its current Width*scale*1.5.
RUNE reveals preparation and ground phase. Anchor,wave,storm,target missiles and
seal follow their current positions. Pulse reveals max(750,1.5*radius) for0.6sec.
The two legacy moving-item vision sites use the same radius rule.
Train constants are owned by EnvironmentRoundRules in Map_Header.j and shared
by RoundEnd and Game Info: impact275,explosion475,+125 per next completed round.
This is the old formula plus75*effective round for BOTH hits; training stays R1.
Checks: test_item_trail_vision_train, fire/elemental/item/pause regressions,
the full60-item native gate audit and check_wos_ui. Engine fog/render acceptance
remains separate from mocks and compilation.

Erza order follow-up (2026-10-31): A03O acidbomb collided with the water-armor
selector A02W, so clicking the selector could invoke T-form W. Erza retains
armor abilities while unavailable, so different forms in the same logical slot
must have distinct orders too. A03O now uses carrionswarm in native data and
stage_instant_foundations.CHANNEL_ORDERS. hero_ability_orders rejects same-slot
collisions for Erza; all 45 command abilities and every Channel rank are covered
by test_hero_orders_vision_tooltips, including a regression restoring acidbomb.
Auxiliary passive/stat abilities retain their native foundations. No dispatch,
targeting, cost or cooldown changes. Engine form-switch acceptance is pending.
Grail Uau1 is explicit: A09X .10, A0CY .15; descriptions derive the percentage
from native data. Frostnova H002 umvs is 290 (was 275). The scoped codec staging
helper is tools/stage_erza_grail_followup.py; it backs up before writing and is
idempotent. Project AGENTS.md permanently authorizes MAIN/STABLE publication
after all changes, without launching the game.
