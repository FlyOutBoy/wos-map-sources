---
paths:
  - "triggers/WOS_Start/**"
  - "triggers/Systems/TasBox.j"
  - "assets/UI/**"
  - "docs/ui-redesign/**"
  - "tools/*wos_ui*.py"
  - "tools/*team_ping*.py"
---
# UI, фреймы, текстуры

Редизайн UI ведётся поэтапно (checkpoints). Состояние и следующий шаг — `docs/ui-redesign/RESUME.md`:
читать только секцию с наибольшим номером чекпоинта (`grep -n "^## " docs/ui-redesign/RESUME.md` — новые
секции с CP23 дописываются в конец, более старые стоят сверху). Владельцы фреймов и ограничения —
`docs/ui-redesign/ARCHITECTURE.md` → разделы «Owners and integration boundaries», «Root constraints».
Полный перечень фреймов — `FRAME_INVENTORY.md` (только Grep). Порядок работы — `WORKFLOW.md`.

## Ключевые ограничения (проверены в ARCHITECTURE.md)
- FRAME и SIMPLEFRAME — разные иерархии; нативные SIMPLEFRAME-родители команд/инвентаря нельзя
  перепривязывать к обычному FRAME.
- Создание/первый поиск хэндлов фреймов — синхронно, не внутри `GetLocalPlayer()`-блока.
- `WUI_Init` только планирует `WUI_Bootstrap` (0.10 с игрового времени). В инициализаторах library —
  никаких поисков/создания фреймов, загрузки TOC, изменения видимости; владельцы UI регистрируются через `WUI_OnReady`.
- Нативным SimpleFontString — только установка текста, без visibility/alpha. Скрытый родитель скрывает детей.
- GameUI оставлять видимым; `BlzHideOriginFrames(true)` не использовать.

## Ассеты
- `assets/UI/WOS/` — `.fdf`, `.toc`, `.tga`. **TOC требует CRLF и пустую последнюю строку** (зафиксировано в
  `.gitattributes`); при правке TOC сохранить байты окончаний строк.
- Генерация/установка: `tools/build_wos_ui_assets.py`, `tools/install_wos_ui_assets.py`
  (установка вызывается сборкой MAIN из `build-run-w3-map.ps1`).

## Проверка
- Компиляция: `python tools/check_wos_ui.py`.
- Регрессии UI и синхронизации: `python tools/run_ui_regressions.py` (отчёт в `_build/ui-redesign/`).
- Визуальный результат подтверждается только в игре — не утверждать, что UI работает, без проверки пользователем.
