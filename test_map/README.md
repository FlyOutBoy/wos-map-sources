# TEST: выбранный герой

Чтобы сменить тестовую карту, измените только `testHero` в
`.vscode/wos-build.json`, например:

```json
"testHero": "Beluga"
```

Затем запустите одну из задач:

1. `TEST: 1. Подготовить карту и JSON выбранного героя` — выбирает/создаёт карту и подготавливает редактируемые данные.
2. `TEST: 2. Проверить, сохранить и собрать выбранную карту` — сохраняет JSON и текущие J, собирает карту без запуска игры.
3. `TEST: 3. Собрать и запустить выбранную карту` — собирает текущий код и запускает Warcraft III.

Для чтения текущей сохранённой карты из `Heroes/<testHero>.w3x` есть три задачи:

- `TEST: Получить из карты код и данные` — обновляет TEST-код, код выбранного героя и JSON объектов.
- `TEST: Получить из карты только код` — обновляет триггеры, Start.j и код выбранного героя; JSON объектов сохраняется.
- `TEST: Получить из карты только данные` — обновляет JSON объектов и их метаданные; J-код сохраняется.

Перед импортом сохраните карту в World Editor. Задачи читают архив на диске,
поэтому несохранённые изменения не импортируются. Перед заменой файлов сохраняются
резервные копии в `backups/test-map-import` и `backups/test-source-import`.
Обновление из карты намеренно заменяет локальные файлы выбранного типа.
Изменения общих триггеров сохраняются как TEST overrides; MAIN не перезаписывается.
После редактирования кода/JSON закройте редактор без повторного сохранения карты
и используйте TEST 2 для сборки проекта обратно в карту.

После импорта кода выбранный герой берётся из
`test_map/heroes/<Hero>.j`; задача выводит полный путь этого файла и подтверждает,
что он выбран для сборки. Он имеет приоритет перед MAIN-кодом в
`triggers/Heroes/<Hero>.j` и прежней копией в `profiles/<Hero>/imported-hero`.
Для переноса в MAIN откройте актуальный `test_map/heroes/<Hero>.j` и запустите
`Hero Transfer`. Задача покажет исходный файл и MAIN-путь, скопирует выбранный код
в `triggers/Heroes/<Hero>.j`, зарегистрирует героя и включит MAIN-триггер.
Старый MAIN-код и изменённые файлы сохраняются в `backups/hero-transfer`.
Повторный перенос обновляет код без дублирования регистрации. После переноса
задача `WOS Objects: 3. Save JSON and J into map folder` сохраняет его в WTG/WCT
основной карты. Hero Transfer переносит J-код и регистрацию; данные объектов
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
