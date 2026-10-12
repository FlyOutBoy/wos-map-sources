---
paths:
  - "object-data/**"
  - ".object-data-raw/**"
  - "object-data*.json"
  - "tools/war3_object*.py"
  - "tools/sync_war3*.py"
  - "tools/test_*.py"
  - ".vscode/*.ps1"
  - ".vscode/*.json"
---
# Object Data, синхронизация, сборка

## Object Data
- `object-data/<type>.json`: объект по rawcode, `name`, `base_id`, поля вида `"cooldown level 1": 15.0`.
  Менять только значения; rawcode и `base_id` структурные. Файлы большие — Grep по `"A0I7"` или имени.
- `.object-data-raw/` — типы/rawcode полей/адреса для lossless записи. Вручную не править.
- Отображаются только реально переопределённые поля; стандартные значения Blizzard (SLK) отсутствуют в JSON.
- При `save` изменения World Editor и JSON сливаются; конфликт одного поля останавливает запись.
- Бэкапы перед записью: `object-data-backups/<дата>/`, триггеры — `backups/trigger-sync/`.

## Известные исправления (подробности — отчёты в корне, читать только при необходимости)
- `MAIN_ABILITY_LEVEL_REPAIR.md`: у Channel-способностей `Ncl5 = 0` записан явно на каждом уровне; поля
  уровней 4/5 восстановлены. Добавляя уровни — заполнять все поля каждого уровня явно.
- `CUSTOM_BUFF_LEVEL_AUDIT.md`: ранги служебных CC-способностей должны совпадать с формулами кода
  (`GetSlowAbilityLevel`, `RootUnit`, `DoomUnit`…); у баффов рангов нет.
- `docs/SAVELOAD_CHANGELOG_2026-10-09.md` — изменения SaveLoad/кодека.

## Конфиги
- `.vscode/wos-build.json` — локальный, в .gitignore (пути Warcraft, `mainMap`, `testHero`, `jassHelper`).
  Шаблон — `wos-build.example.json`. Не коммитить личные пути.
- `object-data.config.json` → MAIN; `object-data.test.config.json` → TEST-профиль (`test_profile`).

## Скрипты (точные команды — Skill `wos-sync`)
- `tools/sync_war3_project.py {export|check|save|check-save} --config <cfg>` — объекты + триггеры.
- `tools/war3_object_data.py --config object-data.config.json roundtrip` — побайтная проверка кодека, ничего не пишет.
- `.vscode/compile-vjass.ps1 -SourceRoot triggers` — компиляция (может открыть окно JassHelper при ошибке);
  безоконный вариант — `python tools/check_wos_ui.py`.
- `.vscode/build-run-w3-map.ps1 -Target {Test|Main} [-NoLaunch] [-PrepareOnly]` — сборка `.w3x`; логи pjass —
  `map_source/logs/pjass.txt` (MAIN).
- Тесты — `unittest` в `tools/test_*.py`, запуск из корня: `python -m unittest discover -s tools -p "test_<name>.py"`.
