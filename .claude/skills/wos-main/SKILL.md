---
name: wos-main
description: Работа с MAIN-картой War of Souls (mainMap из .vscode/wos-build.json) — полный бекап .w3x и файлов, карта → проект, правки triggers/ и object-data/, save, BUILD MAIN и копия в WOS2_MAIN_STABLE.w3x. Использовать, когда пользователь правит основную карту или просит собрать MAIN. Для тест-карты героя — skill wos-test.
argument-hint: "[receive|check|save|build]"
---
# MAIN: бекап → карта → проект → правка → save → build → STABLE

## 1. Проверки и бекап (полный)
1. `tasklist | grep -i "world editor"` — открыт → не продолжать, спросить пользователя.
2. Бекап в `backups/manual/<YYYY-MM-DD_HHMMSS>/` + `README.txt`: целиком MAIN `.w3x` (папочная, ~350 МБ,
   путь — `mainMap`) и все правимые `.j`/JSON. Ротация: не больше 10 папок, старые удалять без вопроса.

## 2. Карта новее проекта → сначала забрать
Время `.w3x` vs файлы проекта + `python tools/sync_war3_project.py --config object-data.config.json check`.
Отличия не от меня → `python tools/wos_map_workflow.py receive --target Main`, потом свои правки поверх.

## 3. Правка и проверка
Правки в `triggers/`, `object-data/`. Компиляция: `python tools/check_wos_ui.py`; check — см. skill `wos-sync`.

## 4. Save + сборка (после подтверждения пользователя)
```
python tools/sync_war3_project.py --config object-data.config.json save
powershell -NoProfile -ExecutionPolicy Bypass -File .vscode/build-run-w3-map.ps1 -Target Main -NoLaunch
```
`BUILD OK` → проверить число строк скрипта (пустой скрипт — память project-build-empty-script), затем
старую `Maps\WoS\WOS2_MAIN_STABLE.w3x` в `backups/stable-map/`, `_build\WoS_Test.w3x` → `WOS2_MAIN_STABLE.w3x`.

Итог — 2–4 строки: что изменено, путь бекапа, результат сборки/STABLE.
