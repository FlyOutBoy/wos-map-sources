---
name: wos-test
description: Работа с TEST-картой героя (testHero из .vscode/wos-build.json, Maps\WoS\Heroes\<Hero>.w3x) — бекап только кода, карта → проект, правки test_map/heroes/<Hero>.j, сборка TEST. MAIN не трогать. Использовать, когда пользователь просит изменить героя в тест-карте / собрать тестовую карту.
argument-hint: "[receive|build]"
---
# TEST: бекап → карта → проект → правка → сборка

Цель — только TEST-профиль (`testHero`). **MAIN-карту не копировать, не сохранять и не собирать**
(требование пользователя 2026-11-08), если он сам отдельно не попросил MAIN.

## 1. Проверки и бекап (только код)
1. `tasklist | grep -i "world editor"` — открыт → не продолжать, спросить, сохранён ли WE.
2. Бекап в `backups/manual/<YYYY-MM-DD_HHMMSS>/` + `README.txt` (что и зачем):
   только правимые файлы кода — `test_map/heroes/<Hero>.j` (и JSON, если правлю объекты профиля).
   `.w3x` тестовой и MAIN не копировать (сборка сама кладёт `map-before-push` в `_build/test-editor-backups/`).
3. Ротация: в `backups/manual/` не больше 10 папок — лишние старые удалить без вопроса.

## 2. Карта новее проекта → сначала забрать
Сравнить время `Maps\WoS\Heroes\<Hero>.w3x` и `test_map/heroes/<Hero>.j`. Карта новее → (после бекапа):
```
python tools/wos_map_workflow.py receive --target Test 2>&1 | tail -15
```
Ждать `TEST All import OK`. Затем `diff` бекапа с новым `.j` — это правки пользователя из WE, свои накладывать поверх.
Если импорт падает на маркере "Warcraft III map script" — брать `.j` из `_build/test-source-import/<ts>/` вручную.

## 3. Правка
Только `test_map/heroes/<Hero>.j` (точечно: Grep → Read диапазона). Стиль — `.claude/rules/heroes.md` и память.

## 4. Сборка TEST (без игры)
```
python tools/wos_map_workflow.py build --target Test --no-launch > "$TEMP/test_build.log" 2>&1; echo EXIT $?
```
Успех: `BUILD OK`, `Heroes map updated: …`. Проверить `_build/logs/outputwar3map.j`: число строк (~120k, не пустой
скрипт) и Grep новых символов. Для Altair — объекты A166/B075 на месте (иначе `tools/stage_altair_fbuff.py`).
Запуск игры — только по просьбе (`build --target Test` без `--no-launch`).

Итог — 2–3 строки: что изменено, путь бекапа, результат сборки.
