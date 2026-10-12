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
