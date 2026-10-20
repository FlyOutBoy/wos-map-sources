# TEST: выбранный герой

## Standard Warcraft UI and current VS Code tasks (2026-10-20)

TEST defaults to `testNativeUI: true` in the local build configuration.
The generated TestHero adapter provides `WOSTestNativeUI`; shared WOSUI keeps
its input defaults and gameplay-facing APIs, then returns before starting the
custom HUD/menu bootstrap. The stock console, command grid, inventory and
tooltips keep their native layout. Charge values remain stored for hero logic,
while custom counters/bars are not rendered. This policy applies to existing
and newly selected TEST profiles and does not change MAIN UI behavior.
Set `testNativeUI: false` explicitly only when testing the custom UI itself.

Frostnova's TEST Q/W/E/R/T mana costs are zero at every rank. MAIN keeps its
25/80/100/120/150 costs. `stage_frostnova.py` preserves this distinction.
Both hero sources group IDs and tuning globals under COMMON/Q/W/E/R/T/F/G
headings; G is unassigned. Public spell entry points have matching section labels.

В меню **Terminal → Run Task** основные действия находятся под `TEST:` и `MAIN:`.
Для обоих профилей нумерация одинакова:

| Задача | Когда запускать | Результат |
| --- | --- | --- |
| `1. Карта → проект — получить ВСЁ из World Editor` | После Ctrl+S в World Editor | Импортирует J, WCT/WTG и все объекты в проект с бэкапом локальных файлов |
| `2. Проект → карта — сохранить ВСЁ, собрать и ЗАПУСТИТЬ` | После изменений J/JSON в VS Code | Проверяет и сохраняет объекты и код, собирает карту с ассетами и запускает Warcraft III |
| `3. Проект → карта — сохранить ВСЁ и собрать без запуска` | Нужна готовая карта без игры | Тот же полный процесс без запуска игры |

`Ctrl+Shift+B` запускает TEST: 3. TEST выбирается через `testHero` в локальном
`.vscode/wos-build.json`; MAIN — через `mainMap`. Импорт читает сохранённые
файлы на диске: несохранённые изменения из памяти World Editor недоступны.
Перед направлением проект → карта закройте World Editor без повторного сохранения.
После импорта из World Editor повторно импортировать перед сборкой не требуется.

`COMMON | ...` — вспомогательные задачи: импорт только кода/триггеров, только
объектов, выбор другой папки MAIN, проверки без записи, подготовка TEST-профиля,
Hero Transfer, копирование J и обслуживание импортов. Отдельный экспорт MAIN
дублировал импорт объектов и удалён из меню; прямой CLI `export` остаётся доступен.
Подготовка TEST-профиля создаёт отсутствующий профиль, а существующий не перечитывает.

`tools/wos_map_workflow.py` объединяет существующие импорт/синхронизацию/сборку.
При сборке TEST `--no-build` откладывает внутреннюю сборку `check-save`, после
чего общий build/run собирает ровно один раз. Ошибка проверки/сохранения блокирует
сборку и запуск. Основной импорт MAIN сначала проверяет оба набора данных,
включая compiled/source parity, затем сохраняет полный бэкап и применяет их;
ошибка применения восстанавливает весь выбранный набор файлов проекта.
Проектные JSON с выделенными ID сохраняются при импорте объектов.

MAIN Compile indexes live source roots instead of scanning project backups and
TEST snapshots. It validates library dependencies, then preserves the enabled
MAIN import order from trigger-settings.json, matching check_wos_ui.py. Legacy
plain JASS functions depend on this order without library declarations.
Compiler failures are bounded to 30 seconds instead of waiting indefinitely on
a hidden JassHelper error dialog. `test_vscode_tasks.py` audits task paths, CLI
entry points, MAIN/TEST routes, PowerShell syntax/parameters and source closure.

## Frostnova profile (2026-10-20)

The active local `testHero` is `Frostnova`. All three generic TEST tasks select
`Heroes/Frostnova.w3x`; the initial arena was copied from Crocodile without
changing Crocodile's archive. Its startup and editable objects are independent
under `test_map/profiles/Frostnova/`. Startup creates `H002`, equips A116-A11B
(Q/W/E/R/T/F), and calls `Frostnova_Register`. The model is a native Jaina
placeholder; replace the Frostnova unit's model field in the profile JSON when
the real model is ready.

`test_map/heroes/Frostnova.j` and `triggers/Heroes/Frostnova.j` currently match.
The selected TEST source is the former; transfer its changes into MAIN with
Hero Transfer. Shared CastCheck and Map Header now come from current MAIN.
The old Crocodile CastCheck override is obsolete: MAIN already contains its T
order/stack fixes, while the frozen override missed new hero dispatch and the
new DarkShiki T signature. MAIN's header now supplies EnvironmentRoundRules.
TEST startup provides only the missing shop/picker globals required by current
shared systems; it does not start the MAIN picker or shop.

Frostnova uses one lazy `GearTimer03Listeners` callback and balanced timer
acquire/release calls. Charges, missiles, debuffs and fields use active lists;
there is no private timer. Q capacities are 2/2/4/4/6 at **ability ranks** 1-5,
with one charge restored per 6 seconds. Cold caps at five 5% slow stacks for
4 seconds; Frostbite uses 8% per stack for 6 seconds and Int x 0.12 per stack
each second. Debuffs can be dispelled. E grants 0.6 seconds of invulnerability;
T lasts 12 seconds and fully restores Q. Enhanced R grows up to eight blocking
crystals, with occupied positions skipped; all are removed with the field.
Ground fields survive caster death, but end if the caster unit is removed.
The first balance has no damage amplification, damage reduction, crystal
immolation or HP drain.

Object staging is reproducible with `python tools/stage_frostnova.py` after
the COMMON TEST preparation task has created the Frostnova profile. Allocated IDs are recorded in
`object-data/frostnova-ids.json`; the lossless object API preserves other objects.
The stager also refreshes TEST's shared stun/slow/root/silence/doom ranks.

Seven icons use official PERISH IN FROST stills; crops and URLs are recorded in
`assets/frostnova_icons_src/sources.json`. Rebuild with a Python environment
containing Pillow:
`python tools/build_frostnova_icons.py --button-manager <installed-directory>`.
This runs the installed Button Manager Clear using a private configuration copy
and verifies all fourteen 64x64 BTN/DISBTN BLP outputs. The user's settings stay
untouched. TEST builds now install project assets and package their imports with
WTG/WCT, so TEST: 2 and TEST: 3 retain the icons after subsequent builds.

Verification: `test_frostnova.py` executes the JASS methods with the existing
deterministic harness. MAIN and TEST compilation, WCT/WTG parsing/order/counts,
object round trips, packed source/icon identity and repeated TEST saves are
checked separately. Native buff timing, projectile visuals, pathing and
multiplayer still require a Warcraft III playtest.

С 2026-10-15 пользователь одобрил перенос стабильной Range3 в MAIN.
Рабочий источник кругов — `triggers/WOS_Start/AbilityRangePreview.j` (включён).
Hold/V удалён целиком; остались круги при наведении. Шаблон в `ability_range/`
также обновлён, старые инструкции ниже описывают историю изолированной сборки.
MAIN теперь включает исправления магазина/фокуса/счётчиков/хоткеев Range3.

Индикатор дальности UI (изолированный полный FIX12-кандидат): исходник
`ability_range/AbilityRangePreview.j` не включён в MAIN. Интеграция в копию
полного проекта — `python tools/prepare_ability_range_test.py --workspace <TEST-workspace>`.
Скрипт отказывается работать в основном checkout и с профилем настоящей MAIN.
Он подключает источник Range билдера, существующий hover/tick AHUI и read-only
блокировку по окнам. Range2 также добавляет мгновенные AoE, удержание на V
(сменяемая сохраняемая клавиша), общие актуальные формулы дальности и UI-правки
Menu/Stats/Pick/Random. Источники пишет только в изолированную копию; новые четыре
Pick/Random TGA и их импорты записывает в её scenario с резервной копией.
Дальше применяются штатные check/save/build
через профиль изолированной копии. Ресурсы устанавливаются отдельно командой
`python tools/install_ability_range_assets.py --map <scenario-directory>` и затем
проверяются в собранном архиве. MAIN разрешено менять только ресурсы/war3map.imp.
Для Range2 см. `ability_range/HeroRangeRules.j`,
`tools/prepare_ability_range_hold_test.py`, `tools/prepare_range_ui_followup.py`
и последний раздел Ability Range в `docs/ui-redesign/RESUME.md`.
Range3 продолжает эту цепочку через `tools/prepare_ability_range_fixes_test.py`:
геометрия магазина/метров, Kyoraku G, повторный Swap, Pick focus, F3/F4,
конфликты хоткеев и `ability_range/KillmeProgress.j` остаются только в TEST.
Аудит каждой HUD-кнопки: `tools/audit_hero_range_sources.py --output <report.json>`.
Радиусы выше 2500 скрываются, включая Patriot T2; T1 показывается.

Чтобы сменить тестовую карту, измените только `testHero` в
`.vscode/wos-build.json`, например:

```json
"testHero": "Beluga"
```

Затем используйте основные `TEST: 1/2/3` из таблицы выше. После изменений
в World Editor запускайте TEST: 1; после изменений в VS Code — TEST: 2 или TEST: 3.
Раздельный импорт доступен в `COMMON | TEST: Карта → проект — только код и триггеры
(J, WCT/WTG)` и `COMMON | TEST: Карта → проект — только объекты (JSON)`.

Перед импортом сохраните карту в World Editor. Задачи читают архив на диске,
поэтому несохранённые изменения не импортируются. Перед заменой файлов сохраняются
резервные копии в `backups/test-map-import` и `backups/test-source-import`.
Обновление из карты намеренно заменяет локальные файлы выбранного типа.
Изменения общих триггеров сохраняются как TEST overrides; MAIN не перезаписывается.
После редактирования кода/JSON закройте редактор без повторного сохранения карты
и используйте TEST: 2 для сборки с запуском или TEST: 3 без запуска.

После импорта кода выбранный герой берётся из
`test_map/heroes/<Hero>.j`; задача выводит полный путь этого файла и подтверждает,
что он выбран для сборки. Он имеет приоритет перед MAIN-кодом в
`triggers/Heroes/<Hero>.j` и прежней копией в `profiles/<Hero>/imported-hero`.
Для переноса в MAIN откройте актуальный `test_map/heroes/<Hero>.j` и запустите
`COMMON | Герой: Перенести открытый J из TEST в MAIN (Hero Transfer)`. Задача покажет исходный файл и MAIN-путь, скопирует выбранный код
в `triggers/Heroes/<Hero>.j`, зарегистрирует героя и включит MAIN-триггер.
Старый MAIN-код и изменённые файлы сохраняются в `backups/hero-transfer`.
Повторный перенос обновляет код без дублирования регистрации. После переноса
задача MAIN: 2 или MAIN: 3 сохраняет его в WTG/WCT и собирает основную карту. Hero Transfer переносит J-код и регистрацию; данные объектов
и импортированные модели/звуки должны быть подготовлены отдельно в MAIN.
Импорт TEST без указанного пути каждый раз читает сохранённый архив `.w3x`,
а не старую папку `unpacked`. При отсутствии J выбранного героя в архиве задача
завершается ошибкой и сохраняет локальный код.
Тестовый ID создаваемого юнита редактируется
в `base/Init/Start.j` активного профиля (для текущего Crocodile —
`test_map/base/Init/Start.j`). Изменение `Crocodile_ID` само по себе не меняет
rawcode в вызове `CreateUnit`. TEST 2 переносит текущий `Start.j` как
в исполняемый код карты, так и в текст триггера для World Editor.


Сборка ищет `Heroes/Beluga.w3x` в `testMapsDir`. Если карта существует, используется
она. Если отсутствует — создаётся копия предыдущей выбранной карты. Для самого
первого запуска запасной архив задаёт `testMapTemplate`; его не нужно менять при
переключении героя. Порядок поиска кода: `triggers/Heroes/<Hero>.j`/папка героя,
затем `test_map/heroes`. Если кода нет, создаётся пустой
`test_map/heroes/Beluga.j`. Существующий файл не перезаписывается.

Каждый профиль хранит свои объекты, импортированные триггеры и карты под
`test_map/profiles/<Hero>`. При первом запуске текущий Crocodile использует
имеющиеся `test_map/base`, `test_map/unpacked` и JSON, сохраняя локальные правки.
Переключение обратно возвращает его данные. Общие системы всегда берутся из
актуальных `triggers`, а подготовленные файлы лежат в `_build/test-sources`.
Профиль и пути выбранного JSON записываются в `_build/test-profile.json`.

Новая карта наследует ландшафт, объекты и тестовый юнит предыдущей карты.
Пустой J — заготовка для реализации героя; его способности не генерируются.
Тестовый старт вызывает `<Hero>_Register(unit)`, если такая функция есть,
через автоматически создаваемый адаптер. При пустом файле адаптер ничего не вызывает.

Успешная сборка обновляет и `_build/<Hero>_Test.w3x`, и выбранный архив в
`Heroes`, предварительно сохранив резервную копию в `backups/test-maps/<Hero>`.
Если выходной слот занят игрой, используется `<Hero>_Test_2.w3x`.

Для запуска TEST 3 использует обновлённый архив Heroes и рабочую папку `_retail_`.
Параметр `testMapProfile` задаёт локальный профиль тестирования редактора; если
его нет, launcher читает последний `-testmapprofile` из War3Log. Данные входа
Battle.net не изменяются.

## Source ownership and closure

Previously TEST imported frozen base copies and the entire configured hero family,
and merely asserted declared dependencies. It did not synchronize MAIN Systems
or consume `test-source-manifest.json`.

Each build now follows:

`triggers -> manifest origins -> _build/test-sources -> dependency closure -> TestCurrent.vj -> JassHelper -> built map -> launcher`

After resolution, the complete closure is materialized into staging, including
shared roots and compatibility sources missing from the imported TEST WTG.
Validate + Save uses this same preparation. BUILD synchronizes the resolved set
into WTG/WCT in a dedicated `_build/test-editor-triggers` copy and inserts it into
the output archive. Thus opening the built map in World Editor has the same
enabled libraries as the command-line compile. Historical sources outside the
closure remain disabled. On successful TEST compilation, the selected Heroes archive is updated with a backup. The original unpacked folder remains the editable input.

Manifest format 2 records `shared`, `test`, and `testHero` origins per file.
Shared entries are copied from current MAIN `triggers`; local TEST definitions
retain priority. Historical shared copies in `base` are not compilation inputs.
Obsolete generated J files are removed only from the dedicated build staging
directory. `source-provenance.json` records source paths, origin kinds and hashes;
`test-resolution.json` records the actual closure. Staged trigger/dependency
metadata is refreshed from current declarations.

The resolver extracted from `compile-vjass.ps1` is shared by MAIN/editor and TEST.
Declared `requires/uses/needs` are followed transitively. Missing required
providers, ambiguous providers, cycles and unindexed seeds fail preparation.
Optional absent FrameLoader is allowed. Enabled TEST infrastructure supplies
seeds; trigger settings can further disable them. Disabled snapshot providers,
including `Systems_Copy.j`, cannot win selection.

The first matching hero source directory wins, allowing a TEST-only hero override.
`testCompanionSourceDirs` preserves the existing MAIN hero family because legacy
Systems call many hero functions/globals without declared library edges. This is
a directory-level compatibility requirement, not a maintained filename list.
The two existing tooltip roots remain in `sharedSources`; further declared
dependencies resolve from MAIN automatically. Crocodile currently resolves 71 files, including the selected hero registration adapter.

Changes to MAIN DmgSys, Systems1/2, CastCheck, CastAItems, Death, Items and other
shared origins enter the next TEST build automatically. Actual filenames are
`CastAItems.j` and `hpset.j`; this project has no `CastItems.j`.
`Systems/Items.j` maps to MAIN `Items/Items.j`; `ErzaDebuff_Copy.j` maps to current
`Systems/DecorDestroy_and_Erza_Debuff.j`, whose Murasame implementation is required
by the current damage system. The old TEST Death API patch is superseded by
current MAIN Death code in staging. Historical copies are retained safely.

## TEST overrides

Reasons and replaced MAIN paths are explicit in `test-source-manifest.json`:

- Empty `Map_Header.j`.
- `Systems/Starts_Copy.j`: TEST startup/keys, replacing MAIN `WOS_Start/Starts.j`.
- `Systems/ArrowUp.j`, `ArrowLeft.j`, `ArrowRight.j`: arena keys; MAIN versions
  invoke the full MAIN hero picker.
- `Systems/UnitEnter.j` and `Thunder_Gear/ARUP.j`: TEST entry/key-up handling.
- All six `Init/*.j`: TEST startup, arena loops, controls and health/level handling.
- `WOS_Start/TestUnit.j`: TEST selection helper, currently disabled.
- `Systems/Systems_Copy.j`: preserved disabled legacy combined systems snapshot.

Other disabled TEST-only gameplay snapshots are retained for WTG/WCT round-trip,
and excluded from the compilation provider pool. Minimal compatibility edits:
remove duplicate `ahk_delay` from TEST Start (current MAIN CastCheck owns it),
initialize `KEY_INVUL`/`KEY_SHIELD` in TEST startup, and provide two Kyoraku sound
handles in `compatibility/KyorakuSounds.j`. Those workflow compatibility edits
did not patch MAIN J files. The subsequent hero implementation adds generic
spell/damage/timer listeners and CC protection to shared Systems, plus the E/F
counter cleanup in TasBox; the implementation report lists those changes.

## Object data and Validate before Save

`object-data.test.config.json` selects the current hero through `test_profile`.
The old `object-data.crocodile.config.json` is a compatibility alias to the same
selection. JSON/raw metadata and unpacked archives are independent per profile;
object, trigger and packed-map backups are under `backups/test-*`.

Task 2 stages current sources, validates objects and triggers before either save,
saves the editable payload, then compiles and updates `Heroes/<testHero>.w3x`.
A compiler failure leaves the packed Heroes archive unchanged. Task 3 builds and
launches the selected map. Close World Editor before saving/updating its map.
MAIN synchronization arguments and paths retain their existing behavior.

Crocodile's WTG omits category-id-0's tombstone. Only the TEST config permits
reading stale allocation counts. Synchronization restores missing unreferenced
tombstones, preserving allocation counters/live ids; MAIN retains strict count
validation. GUI support and WCT byte/count checks are not relaxed.

## Milim references

No active config selects `Milim.w3x` or `map_source/Milim.vj` as TEST input.
Milim remains a real MAIN hero and required compatibility companion: shared
Systems reference its APIs. Original WTG handle names remain. The unused old
mapscript, backups, MAIN object data and match records retain meaningful history
or gameplay references.

## Files changed

Existing: `.gitignore`, `.vscode/tasks.json`, local `.vscode/wos-build.json`,
`.vscode/wos-build.example.json`, `.vscode/build-run-w3-map.ps1`,
`.vscode/compile-vjass.ps1`, `.vscode/import-triggers-and-code-from-map.ps1`,
`tools/create-main-mapscript.ps1`, `tools/extract_war3_triggers.py`,
`tools/sync_war3_project.py`, `tools/sync_war3_triggers.py`, TEST `Init/Start.j`,
`Systems/Starts_Copy.j`, `test-source-manifest.json`, `map_source/TestBase.vj`,
and this README.

New: `.vscode/jass-source-resolver.ps1`, `.vscode/prepare-test-map.ps1`,
`.vscode/test-map-archive.ps1`, `object-data.crocodile.config.json`,
`tools/test_map_sources.py`, `tools/test_test_map_workflow.py`,
`tools/test_jass_source_resolver.ps1`, TEST trigger/settings/dependency manifests,
`heroes/Crocodile.j`, `compatibility/KyorakuSounds.j`. Unpacked binaries, editable
TEST JSON and generated build files are local outputs. Old tracked compiler
logs/backup indexes were restored after verification.

## Verification

65 Python checks pass: 53 execute Crocodile logic, 8 cover synchronization,
and 4 cover map/profile selection, source preservation and returning to a prior
hero. Resolver checks cover transitive, missing, cyclic and unindexed sources.
Full compilation succeeded for Crocodile and, in an isolated project copy,
Beluga with an empty source and a second new map copied from Beluga. Returning
to the existing Beluga and its complete Check + Save also succeeded. TEST import
validation succeeded. Profile state survives clearing generated build JSON.

Full TEST build succeeded using the Windows PowerShell executable used by VS Code.
`-PrepareOnly` resolves/prepares without compiler/game; `-NoLaunch` builds without
Warcraft III or Battle.net. TEST task 3 was also launched after restoring the editor test profile; the user confirmed Crocodile opened. Gameplay visuals still require review in game.

## Same-path duplicate audit

These copies originated in extracted TEST WTG/WCT. Shared snapshots are retained,
but current MAIN files supply their staged replacements. The manifest also maps
renamed/moved files; filename matching alone does not determine ownership.

| TEST base path | Compared with MAIN | Role |
| --- | --- | --- |
| `Map_Header.j` | different | TEST override |
| `Systems/ArrowLeft.j` | different | TEST override |
| `Systems/ArrowRight.j` | different | TEST override |
| `Systems/ArrowUp.j` | different | TEST override |
| `Systems/CastAItems.j` | different | shared snapshot; MAIN used in staging |
| `Systems/CastCheck.j` | different | shared snapshot; MAIN used in staging |
| `Systems/Death.j` | different | shared snapshot; MAIN used in staging |
| `Systems/DmgSys.j` | different | shared snapshot; MAIN used in staging |
| `Systems/hpset.j` | different | shared snapshot; MAIN used in staging |
| `Systems/ItemEnter.j` | different | shared snapshot; MAIN used in staging |
| `Systems/MouseMove.j` | different | shared snapshot; MAIN used in staging |
| `Systems/Systems1.j` | different | shared snapshot; MAIN used in staging |
| `Systems/Systems2.j` | different | shared snapshot; MAIN used in staging |
| `Systems/TasBox.j` | different | shared snapshot; MAIN used in staging |
| `WOS_Start/Leave.j` | different | shared snapshot; MAIN used in staging |
| `WOS_Start/Starts.j` | different | shared snapshot; MAIN used in staging |
| `WOS_Start/TestUnit.j` | different | TEST override |
| `WOS_Start/WoS_Hero_Icons_Init.j` | different | shared snapshot; MAIN used in staging |
| `WOS_Start/WoS_Pick_Init.j` | different | shared snapshot; MAIN used in staging |
| `WOS_Start/WoS_Shop_Init.j` | different | shared snapshot; MAIN used in staging |

Импорт кода выбранного героя сохраняется в `test_map/profiles/<Hero>/imported-hero/<Hero>.j`.
TEST использует эту копию в приоритетном порядке; `triggers/Heroes` и данные MAIN импорт не изменяет.
