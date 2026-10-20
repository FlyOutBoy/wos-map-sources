# Архитектура: карта поиска

Проверено по исходникам и конфигурации 2026-10-11. Это указатели, а не копия
полного каталога триггеров. Перед изменением проверяй выбранную реализацию.

## Владение исходниками и зависимости

MAIN: редактируемые `triggers/` → синхронизация WTG/WCT и подготовка
`map_source/Main.vj` → JassHelper → JASS/архив карты. Редакторские `gg_*`
нужны компиляции; `check_wos_ui.py` берёт их из `.vscode/build/wos_map_globals.j`.
Корневой `war3map.j` не заменяет внешние исходники триггеров.

Исключение, требующее восстановления, а не слепого импорта: в рабочей STABLE
2026-10-17 исполняемый `war3map.j` был новее вложенного WCT. Актуальные исходники
восстановлены из проектного backup и сверены с игровыми/UI-функциями исполняемого
скрипта. Импорт теперь предварительно перекомпилирует входящий WCT и сравнивает
его со скриптом карты; MAIN-сборка требует совпадения WCT с `triggers` и проверяет
скомпилированный результат. Причина и доказательства — KNOWLEDGE/RESUME CP59.

Граф объявлений уже сохранён в [dependency-manifest](../../triggers/dependency-manifest.json),
порядок и library — в [triggers/README](../../triggers/README.md).
Перед добавлением/сменой зависимостей сверяй также `library ... uses/requires/needs`
в текущем коде: метаданные могут отставать от несохранённых правок.

Подробная схема TEST, происхождение shared/test/testHero, разрешение замыкания
зависимостей и приоритет override — [test_map/README](../../test_map/README.md),
разделы `Source ownership and closure` / `TEST overrides`.
Не исправляй исторические shared-копии в TEST base вместо актуального MAIN.
Для импортированного героя используй подтверждённый выбранный путь
`test_map/heroes/<Hero>.j`; не угадывай его по старой копии профиля.

## Где искать

Все пути ниже относительны корню. Ищи символ через `rg -n`, читай его функцию
и вызывающие участки, а не весь файл.

| Задача | Файл/символ | Подробности только при работе с системой |
| --- | --- | --- |
| Общие таймеры, состояние, события | `triggers/Systems/Systems2.j`: `hs`, `GearTimer03Listeners`, `GearTimer03Acquire`, `GearSpellDispatch`, `GearDamageRun` | [vJASS и системы](../../.claude/rules/jass-systems.md) |
| Контроль, расчёт/блокировка урона | `triggers/Systems/Systems1.j`: `StunUnit`, `RootUnit`, `DoomUnit`, `GetSlowAbilityLevel`, `DamageCheck`, `DamageBlock` | тот же справочник; ранги объектов — [KNOWLEDGE](KNOWLEDGE.md) |
| События урона и каста | `triggers/Systems/DmgSys.j`, `CastCheck.j`; удержание каста — `CastingCheck.j` | `static if LIBRARY_<Hero>Spells`, слушатели из Systems2 |
| Герой и общая интеграция | `triggers/Heroes/<Hero>.j`, `Heroes/Erza/`; `tools/hero_transfer.py` | [герои](../../.claude/rules/heroes.md), Skill `wos-new-hero` |
| Предметы и магазин | `triggers/Items/Items.j`, `Systems/CastAItems.j`, `WOS_Start/WoS_Shop_Init.j`; общие функции в Systems1 | не искать несуществующий `CastItems.j` |
| Пик, старт, завершение раунда | `WOS_Start/Player_Pick_Mode.j`, `Captain_Draft.j`, `WoS_Pick_Init.j`, `Starts.j`, `BuildsForChars.j`; `Round_End/RoundEnd.j` в `triggers/` | порядок/зависимости в triggers/README |
| Общий UI и подключение владельца | `triggers/WOS_Start/WOSUI.j`: `WUI_Init`, `WUI_Bootstrap`, `WUI_OnReady` | [UI-правила](../../.claude/rules/ui-frames.md), [границы владельцев](../ui-redesign/ARCHITECTURE.md) |
| Кнопки/КД, заряды, подсказки | `triggers/WOS_Start/ShowCD.j`, `TooltipBuilder.j`, `UniversalTooltips.j`; `Systems/TasBox.j` | [инвентарь фреймов](../ui-redesign/FRAME_INVENTORY.md): искать владельца, не читать целиком |

CP65 common hot paths: register new shared event listeners through
`GearDamageAddListener` / `GearSpellAddListener`; empty dispatch returns before
trigger execution/context copying. Current MAIN has no external subscribers.
TooltipBuilder prints damage formulas only, never evaluated combat totals.
SPELL_EFFECT no longer requests full hero descriptions; the5-second poll and
item/level/skill/form events own updates. Native tooltip writes compare text
first. DamageStats retains immediate numeric collection; automatic presentation
is5-second, while open/page/roster changes bypass that gate.
| Карьера, локальный сейв, экспорт матча | `triggers/WOS_Start/SaveLoad.j`: `SaveSystem_Init`, `SaveSystem_InitLoad`, `SaveSystem_NormalizeNickname`; `Save2.j`; `UI_CAREER.j`: `WCS_UpdateHome` | [существующий разбор SaveLoad](../SAVELOAD_CHANGELOG_2026-10-09.md) |
| Музыка, счёт, пинги | `triggers/WOS_Start/MusicPlayer.j`, `Scoreboard.j`, `TeamMapPings.j` | UI-контракты и профильные `tools/test_*.py` |
| Объекты и обратная запись | `object-data/*.json`; `tools/war3_object_workspace.py`, `war3_object_data.py`, `sync_war3_project.py`, `sync_war3_triggers.py` | [OBJECT-DATA-README](../../OBJECT-DATA-README.md), [объекты/сборка](../../.claude/rules/object-data-build.md) |
| FDF/TOC/текстуры | `assets/UI/WOS/`; `tools/build_wos_ui_assets.py`, `install_wos_ui_assets.py` | [ASSETS](../ui-redesign/ASSETS.md); точные байтовые правила в `.gitattributes` |

## Инструменты

[utility/README](../../utility/README.md) описывает поставленный JassHelper/pjass,
MPQ DLL и лицензии. `libs/common.j` / `Blizzard.j` — используемые API.
Настройка диагностики — `jass.config.json`, задачи — `.vscode/tasks.json`,
реальная сборка — `.vscode/*.ps1`, общий resolver — `.vscode/jass-source-resolver.ps1`.
Зависимости/команды по конкретной проверке — [VALIDATION](VALIDATION.md).
