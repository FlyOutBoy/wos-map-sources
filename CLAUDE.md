# War of Souls 2 — Warcraft III карта (vJASS)

Отвечай пользователю по-русски. Windows; доступны PowerShell и Git Bash.

## Карта проекта
- `triggers/` — **источник правды** для кода карты (110 триггеров, vJASS). Порядок/категории: `triggers/README.md`
  (таблица library → зависимости), вкл/выкл: `triggers/trigger-settings.json`.
  - `Systems/` — ядро: `Systems1.j` (library `GearSystems`), `Systems2.j` (`GearSystems2`), `DmgSys.j`, `CastCheck.j`.
  - `Heroes/<Hero>.j` — один герой = одна library `<Hero>Spells uses GearSystems` (Erza — папка из нескольких).
  - `WOS_Start/` — инициализация, пик, магазин, UI (`WOSUI.j`), подсказки (`TooltipBuilder.j`, `UniversalTooltips.j`).
- `object-data/*.json` — редактируемые объекты (способности/юниты/баффы…) по rawcode; `.object-data-raw/` — служебное, не править.
- `test_map/` — TEST-профиль одного героя (`testHero` в `.vscode/wos-build.json`); `test_map/README.md` — процесс.
- `tools/*.py` — синхронизация, сборка, тесты (unittest); `.vscode/*.ps1` + `tasks.json` — задачи VS Code.
- `utility/JassHelper/` — jasshelper + pjass; `libs/common.j`, `libs/Blizzard.j` — стандартные API.
- `docs/ui-redesign/` — отдельная документация и журнал прогресса редизайна UI.

## Критические правила
- НЕ открывать целиком сгенерированные/огромные файлы: `war3map.j` (9.5 МБ), `war3map.wct/.wtg`,
  `test_map/unpacked/war3map.j`, `.vscode/build/*`, `map_source/logs/*`, `_build/`, `.build/`, `backups/`. Только Grep.
- Перед любой записью в карту (`save`, `check-save`, BUILD MAIN) World Editor должен быть закрыт без сохранения —
  иначе он перезапишет внешне изменённые WTG/WCT.
- Новый `.j` синхронизация подхватит сама (включённым), но `check_wos_ui.py` компилирует только файлы,
  перечисленные в `trigger-settings.json` со значением `true` — для нового файла добавь запись.
- Не перекодировать файлы массово и не «чинить» кракозябры в старых комментариях. Файлы UTF-8 без BOM.
- После правок `.j` — компиляция: `python tools/check_wos_ui.py` (без окна, печатает ошибки pjass/JassHelper).
- Синхронизация с картой — Skill `wos-sync`; новый герой — Skill `wos-new-hero`.

## Экономия контекста
- Сначала Grep по имени функции/struct/rawcode (`'A0I7'`), затем Read только нужного диапазона строк.
  Файлы систем/героев по 2–5 тыс. строк — читать целиком нельзя.
- Пользоваться памятью (`.claude/rules/*` подгружаются автоматически по путям) вместо повторного исследования.
- Не выводить длинные куски кода/логов: только релевантные строки и итог.
- Отчёт после задачи — коротко: что изменено, как проверено. Без отдельных md-отчётов, если не просили.
- Подагент (Explore) — только для широкого поиска по многим файлам, когда нужен лишь вывод.
- Узнал неочевидный факт о движке/проекте или исправил нетривиальный баг — сохрани в Auto Memory (кратко, без дублирования этого файла).
