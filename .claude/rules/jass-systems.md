---
paths:
  - "triggers/**/*.j"
  - "test_map/**/*.j"
  - "map_source/*.vj"
---
# vJASS: соглашения и игровые системы

Компилятор — JassHelper (vJASS) + pjass. API: `libs/common.j`, `libs/Blizzard.j` (Grep, не читать целиком).
Глобалы `gg_*` из редактора объявлены в сгенерированном `.vscode/build/wos_map_globals.j`.

## Соглашения
- Модуль = `library X initializer Init uses A, B`. Зависимость от необязательной library — через
  `static if LIBRARY_<Name> then … endif` (так системы вызывают код героев: `CastCheck.j`, `Death.j`, `DmgSys.j`).
- Общее состояние — `hashtable hs` (GearSystems2), ключи `GetHandleId(unit)` + `StringHash("...")`/константы `KEY_*`.
- Rawcode-константы — глобалы library: `<Hero>_ID = 'H02M'`, `<Hero><Slot>_ID = 'A0I7'` (слоты Q W E R T T2 F G).
- Периодика: не создавать таймер на экземпляр — подписка на общий тик
  `TriggerAddCondition(GearTimer03Listeners, Condition(function …))` (0.03 с, TriggerEvaluate; функция
  возвращает false; регистрировать лениво при появлении героя); `GearTimer03/05/10Acquire/Release`.
- Отложенная очистка/восстановление: `MyFlush`, `MyFlushReal`, `MyFlushBuff`, `MyAddMana` (Systems2).
- Утилиты: `SR2(c,td)` дистанция, `GAngle`, `Parabola`, `SpellBool(target)`/`SpellBoolCaster(c)` — проверки перед уроном.

## Урон (Systems2 / DmgSys / Systems1)
- Нанесение: `dmgmag` (ATTACK_TYPE_MAGIC → typedmg 1), `dmgphys` (NORMAL+FIRE → typedmg 2),
  `dmgatk` (атака, MELEE → typedmg 0), `spelldmg` (UNIVERSAL), `DmgPTime` — урон во времени.
- `DmgSys.j` ловит `EVENT_PLAYER_UNIT_DAMAGING`, классифицирует тип по attack/damage type, вызывает
  `DamageCheck(c,td,dmg,typedmg)` / `DamageBlock(...)` (Systems1) и хуки героев.
- Слушатели урона: `GearDamageListeners` через `GearDamageRun(c,td,amount,kind,phase)`;
  регистрация только `GearDamageAddListener(callback)` (не прямой `TriggerAddAction`),
  чтобы пустой путь пропускал dispatch. Аналогично `GearSpellAddListener(callback)`
  для `GearSpellListeners`; прямых подписчиков в текущем MAIN нет.
  phase: 0 атака, 1 предпросмотр исходящего (чистая, без побочных эффектов), 2 входящий, 3 применённый.
  Контекст: `GearDamageSource/Target/Amount/Type/Phase`; слушатель меняет `GearDamageAmount`.

## Контроль и баффы
- `StunUnit(c,u,time)` 0.1–3 с, `SilenceUnit` 0.5–5 с, `RootUnit` 0.5–5 с, `DoomUnit`,
  `SlowUnit(c,u,percent,time)` → `GetSlowAbilityLevel` (5–95 % шаг 5, 1–4 с). Реализованы через служебные
  способности-дамми с рангами (stun A1OA, slow A1OT, root APPP, silence A01V, doom A1QY): длительность = ранг,
  баффы своих рангов не имеют. Меняешь шкалу в коде — сверь ранги в `object-data/abilities.json`.
- `GearCCProtect/GearCCProtected` — счётчик иммунитета к контролю.

## Каст способностей
- `CastCheck.j`: общий обработчик каста → сначала `GearSpellDispatch()` (слушатели `GearSpellListeners`,
  выставляют `GearSpellHandled`), затем цепочка `if GetUnitTypeId(c) == <Hero>_ID … id == <Hero>Q_ID → <Hero>Q_Start(...)`.
- Кулдаун стартует в CastCheck через `BlzStartUnitAbilityCooldown`.
- ManaFix: снимок на SPELL_CAST, очередь разрешённого EFFECT и проверка на общем
  GearTimer03 через 0.03–0.06 с; ENDCAST только удаляет неиспользованный снимок.
  SetMpCurrent/MyAddMana учитывают scripted delta отдельно от native оплаты.
  Прямую асинхронную запись UNIT_STATE_MANA для ожидающего героя сопровождать
  `GearManaScriptChange(c, manaBefore)`, иначе её не отличить от оплаты движком.

## Подводные камни Warcraft III
- Хэндлы фреймов и любые асинхронные вещи: создание/первый поиск — синхронно, вне `GetLocalPlayer()`-блока (десинк).
- `local` хэндлы обнулять в конце функции (утечки ссылок).
- pjass строг: после правок всегда `python tools/check_wos_ui.py`.
