---
name: wos-sync
description: Синхронизация проекта War of Souls с картой Warcraft III — export (карта → JSON/J), check (компиляция vJASS + проверка JSON/WTG/WCT), save (JSON и J → карта). Использовать, когда пользователь просит экспортировать, проверить, сохранить в карту, «export → check → save», собрать TEST-карту.
argument-hint: "[export|check|save|all] [main|test]"
---
# export → check → save

Все команды — из корня проекта (Git Bash). Вывод обрезать (`| tail -n 30`), полный лог не показывать.
Цель по умолчанию — **MAIN** (`object-data.config.json`). TEST — если пользователь говорит о тестовой карте/герое:
`object-data.test.config.json` (профиль героя из `testHero` в `.vscode/wos-build.json`).
Аргумент не указан → выполнить `check`, затем спросить, сохранять ли (если пользователь сразу не просил save).

## 1. export (карта → редактируемые файлы)
```
python tools/sync_war3_project.py --config object-data.config.json export
```
- Перечитывает объекты карты в `object-data/*.json`. Несохранённые JSON-правки молча не затираются.
- TEST: тот же вызов с `object-data.test.config.json` — готовит профиль, печатает `TEST profile ready` и путь JSON.
- Импорт J-кода из сохранённой карты — это задачи VS Code «WOS Sources: Import…» / «TEST: Получить из карты…»
  (интерактивные PowerShell-скрипты); их запускает пользователь, не я.

## 2. check (без записи в карту)
Шаг A — компиляция vJASS всех включённых триггеров (безоконно, таймаут 30 с):
```
python tools/check_wos_ui.py
```
Успех: код выхода 0 и строка `UI compile: 0 enabled production sources: N`.
Ошибка: печатается хвост `utility/JassHelper/logs/compileerrors.txt` — найти файл/строку, исправить, повторить.
(Компилирует `triggers/` по `trigger-settings.json`; для TEST-кода компиляцию выполняет шаг save через сборку.)

Шаг B — проверка JSON объектов и соответствия J-файлов триггерам карты:
```
python tools/sync_war3_project.py --config object-data.config.json check
```
Успех (код 0), две строки:
`CHECK OK: all convenient files are valid; <K> binary files will change` и
`CHECK OK: <N> WTG triggers; <D> source differences; <A> new J files`, затем `MAP: <путь карты>`.
Ошибка: `ERROR: …` в stderr, код 1 — сообщить причину, не продолжать к save.
`new J files` > 0 — убедиться, что это ожидаемые новые триггеры. Карту check не меняет; единственная
возможная запись — `trigger-settings.json` при переименовании J-файлов (строки `SETTING old -> new`).

## 3. save (запись в карту)
Пишет бинарные файлы карты — выполнять только по явной просьбе пользователя и только после успешного check.
1. World Editor должен быть закрыт **без сохранения** (скрипт сам откажет, если он запущен).
2. MAIN:
   ```
   python tools/sync_war3_project.py --config object-data.config.json save
   ```
   TEST (сохранение + проверка + сборка без запуска игры):
   ```
   python tools/sync_war3_project.py --config object-data.test.config.json check-save
   ```
3. Проверка результата: код 0, нет `ERROR`/`BUILD FAILED`; для TEST — `BUILD OK`.
   Конфликт поля между World Editor и JSON — сохранение остановится и назовёт поле: показать пользователю.
4. Сообщить: что записано, где бэкапы (`object-data-backups/`, `backups/trigger-sync/`), что карту можно
   снова открыть в World Editor.

## Дополнительно (только по просьбе)
- Сборка MAIN `.w3x` без запуска игры:
  `powershell -NoProfile -ExecutionPolicy Bypass -File .vscode/build-run-w3-map.ps1 -Target Main -NoLaunch`
  → `BUILD OK`; при ошибке смотреть `map_source/logs/pjass.txt` (Grep по `error`, не читать целиком).
- Запуск игры (`-Target Test|Main` без `-NoLaunch`) — только если пользователь просит.
- Побайтная проверка кодека объектов: `python tools/war3_object_data.py --config object-data.config.json roundtrip`.
- Регрессии: `python tools/run_ui_regressions.py`.

Итог пользователю — 2–4 строки: какие шаги прошли, ключевые числа, что требует внимания.
