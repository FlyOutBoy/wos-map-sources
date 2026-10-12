---
paths:
  - "triggers/Heroes/**"
  - "test_map/heroes/**"
  - "triggers/Systems/CastCheck.j"
  - "triggers/Systems/LvlUpCheck.j"
  - "triggers/Systems/Death.j"
  - "triggers/WOS_Start/BuildsForChars.j"
  - "triggers/WOS_Start/WoS_Pick_Init.j"
  - "tools/hero_transfer.py"
---
# Герои

## Структура файла героя (эталон — `triggers/Heroes/Crocodile.j`, самый новый и чистый)
- `library <Hero>Spells initializer Init<Hero>Spells uses GearSystems[, GearSystems2, …]`.
- Обязательные глобалы (их парсит `tools/hero_transfer.py`): `<Hero>_ID` (юнит) и `<Hero>Q/W/E/R/T_ID`;
  опционально `T2`, `F`, `G`. Числовые параметры способностей — тоже глобалы (на них ссылаются подсказки).
- Логика способности — `private struct <Hero><Slot>_KS` + публичная `<Hero><Slot>_Start(...)`.
- Периодика — через `GearTimer03Listeners`, а не собственные таймеры.

## Точки интеграции в общих системах
Делает `Hero Transfer` (`tools/hero_transfer.py`, маркеры `// HERO TRANSFER: <Hero> / <part>`, идемпотентно):
`BuildsForChars.j` (слот `Hero_ID<cat>[slot]`), `WoS_Pick_Init.j` (пик, звуки, подсказки гайда),
`Systems1.j` (регистр магазина, `LearnHeroSpells`, рекомендуемые предметы), `Death.j` (звук смерти),
`LvlUpCheck.j` (выдача F/G-способностей при наличии), запись в `trigger-settings.json`.
(`Crocodile_InitializeHero` в `LvlUpCheck.j` дописан вручную — Hero Transfer такой вызов не создаёт.)

Вручную (Hero Transfer этого НЕ делает):
- `Systems/CastCheck.j` — ветка `static if LIBRARY_<Hero>Spells` → `id == <Hero>Q_ID → <Hero>Q_Start(...)`.
  Альтернатива — слушатель `GearSpellListeners` (пока ни один герой его не использует).
- `WOS_Start/UniversalTooltips.j` — `SpellData.createSimple(<Hero>Q_ID, …)` для каждой способности (рядом с Crocodile).
- При необходимости: хуки в `Systems/DmgSys.j`, `Systems/Death.j` через `static if LIBRARY_<Hero>Spells`.
- Объекты (способности, юнит, баффы) — `object-data/*.json`; модели/звуки импортируются в карту отдельно.

## Процесс
Новый герой разрабатывается в TEST-профиле (`test_map/heroes/<Hero>.j`), затем переносится в MAIN.
Пошагово — Skill `wos-new-hero`.

Герой-специфичные факты (баланс, нестандартные механики) — в Auto Memory, не сюда.
Большие исторические отчёты по Crocodile — `CROCODILE_*.md` в корне (читать только при работе с Crocodile).
