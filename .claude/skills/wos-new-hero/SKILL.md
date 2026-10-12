---
name: wos-new-hero
description: Пошаговый процесс создания нового героя War of Souls или переноса героя из TEST-карты в MAIN (Hero Transfer) с ручной интеграцией в CastCheck и подсказки. Использовать, когда пользователь просит сделать нового героя, перенести героя в основную карту или подключить способности героя к системам.
argument-hint: "<HeroName> [test|transfer]"
---
# Новый герой: TEST → MAIN

Правила структуры и точки интеграции — `.claude/rules/heroes.md` (загружается при открытии файлов героев).
Эталон кода — `triggers/Heroes/Crocodile.j`: читать по Grep-диапазонам (globals, один `_KS`, `Init…Spells`), не целиком.

## A. Разработка в TEST
1. Профиль: `testHero` в `.vscode/wos-build.json` (локальный файл) — попросить пользователя или изменить с его согласия.
2. Подготовка: `python tools/sync_war3_project.py --config object-data.test.config.json export`
   (печатает путь редактируемого JSON профиля). Код героя — `test_map/heroes/<Hero>.j`
   (при отсутствии сборка создаёт пустой файл; существующий не перезаписывается).
3. Код: `library <Hero>Spells initializer Init<Hero>Spells uses GearSystems`; объявить `<Hero>_ID` и
   `<Hero>Q/W/E/R/T_ID` (+ T2/F/G). Тестовый старт вызывает `<Hero>_Register(unit)`, если функция есть.
   Rawcode создаваемого юнита — в `test_map/base/Init/Start.j` (смена `<Hero>_ID` его не меняет).
4. Объекты — в JSON профиля; новые rawcode согласовать с пользователем (не выдумывать занятые ID — Grep по JSON).
5. Проверка/сборка без запуска игры: Skill `wos-sync` → TEST `check-save` (World Editor закрыт).
   Запуск игры (`build-run-w3-map.ps1 -Target Test`) — только по просьбе; поведение в игре проверяет пользователь.

## B. Перенос в MAIN
1. Предпросмотр без записи (скрипт интерактивный; в моей оболочке нет stdin, поэтому все ответы — флагами):
   `python tools/hero_transfer.py --hero-file test_map/heroes/<Hero>.j --category N --difficulty N --items default --dry-run --yes`
   Категории: 1 Gacha, 2 Bleach, 3 Fairy Tail, 4 One Piece, 5 Jujutsu Kaisen, 6 Other; сложность 1 Easy, 2 Normal, 3 Hard —
   значения взять у пользователя. `--yes` здесь нужен, т.к. вопрос «Apply?» задаётся до проверки `--dry-run`;
   с `--dry-run` файлы не пишутся.
2. Применение — та же команда без `--dry-run` с `--yes` только после подтверждения пользователя.
   Бэкап — `backups/hero-transfer`. Повторный запуск не дублирует код (маркеры `HERO TRANSFER`).
3. Ручная интеграция (Hero Transfer её не делает):
   - `triggers/Systems/CastCheck.j`: ветка `static if LIBRARY_<Hero>Spells` по образцу Crocodile (Grep `Crocodile_ID`).
   - `triggers/WOS_Start/UniversalTooltips.j`: `SpellData.createSimple(...)` на каждую способность (Grep `CrocodileQ_ID`).
   - По механикам: `DmgSys.j`, `Death.j`, `LvlUpCheck.j` (`<Hero>_InitializeHero`, если нужен).
4. Объекты, модели, звуки в MAIN — отдельно (Object Data MAIN + импорт в карте). Звук смерти
   `Hero_<Hero>_Death` подключается Hero Transfer, только если уже импортирован в карту.
5. Skill `wos-sync`: check (компиляция + проверка) → save по подтверждению.

## Итог
Короткий список: созданные/изменённые файлы, результат компиляции и check, что осталось сделать вручную
(объекты, ассеты, проверка в игре). Нетривиальные решения по герою — в Auto Memory.
