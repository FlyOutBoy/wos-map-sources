# Crocodile в MAIN — 7 октября 2026

Интеграция сохранена в MAIN: `C:\Users\Gear\Documents\Warcraft III\Maps\WoS\Anime_WOS2_0.32.w3x`.
Это папка сценария. Её `war3map.j` заменён кодом из успешно собранного архива.
Собранная MAIN-карта: `C:\Users\Gear\Desktop\WOS\VS WOS\_build\WoS_Test.w3x`.
Имя выходного файла сохранено из существующей настройки MAIN build.

## Проверенные ID

В MAIN уже существовали герой и восемь способностей. Используются именно они.
TEST-идентификаторы конфликтуют с существующими объектами MAIN. Промежуточный дубль
`Z00A` / `A100–A107` удалён; исходный MAIN-герой сохранён.

| Назначение | MAIN ID | Уровни |
| --- | --- | --- |
| Герой | H02M | — |
| Q | A0I7 | 5 |
| W | A0I8 | 5 |
| E | A0I9 | 5 |
| R | A0IA | 5 |
| T | A0IB | 1 |
| T2 | A0IC | 1 |
| F | A0ID | 1 |
| G | A0IE | 1 |
| Q: ability метки | A108 | 1 |
| Q: buff метки | B03D | — |
| G: ability скорости | A109 | 1 |
| G: buff скорости | B03E | — |

Все ID присутствуют в бинарных object-data основной карты. Placeholder ID нет.
H02M сохранил исходные MAIN характеристики: AGI, скорость 310, базовую дальность
атаки 120 и список hero abilities `A0I7,A0I8,A0I9,A0IA,A0IB`.

## Изменения в production

- `triggers/Heroes/Crocodile.j`: MAIN ID, независимые permanent F/G, регистрация
  настоящего героя один раз, механики Q/F/G/T и cleanup.
- `triggers/Systems/LvlUpCheck.j`: ранняя инициализация Crocodile.
- `triggers/WOS_Start/WoS_Pick_Init.j`: инициализация после создания героя в
  соответствующих путях выбора/создания.
- `triggers/Systems/CastCheck.j`: F получает стак только после принятого каста;
  T проверяет native order `ambush`, T2 — успешность запуска.
- `triggers/Systems/DmgSys.j`: единый бонус G до DamageCheck и финальное
  списание маны при положительном spell damage; защита активного T.
- `triggers/Systems/Systems2.j`: удалён второй обработчик Crocodile damage.
  Совместимый `Crocodile_Damage` возвращает исходный damage без повторного G.
- `triggers/WOS_Start/UniversalTooltips.j`: SpellData для Q/W/E/R/T/T2/F/G,
  HeroData базовой формы и extra T2; используется существующий CaptureDesc.
- MAIN object-data: Channel T на 5 секунд, order `ambush`, отдельные реальные
  ability/buff пары Q/G, описания Crocodile вместо оставшегося текста Saber.
  Gameplay-поля перенесены из Skin в основную запись соответствующей способности,
  чтобы merged object-data не содержали два разных значения Channel duration.
- `.vscode/test-map-archive.ps1`, `.vscode/build-run-w3-map.ps1`: существующая
  сборка поддерживает MAIN как папку сценария, упаковывает её через bundled SFmpq
  и после успешной компиляции сохраняет compiled J обратно с резервной копией.

Первая попытка упаковки передала сообщение упаковщика вместе с путём архива.
Его вывод теперь исключён из возвращаемого значения функции выбора файла.
Повторная сборка прошла успешно.

Сравнение с резервной копией подтвердило: объекты других героев не изменились.
TEST production-копии в рамках этой интеграции не редактировались.
Перенесены 35 отсутствовавших ресурсов и добавлены их записи в `war3map.imp`:
модель, звуки Crocodile и отсутствующие зависимости эффектов. Существующие
ресурсы MAIN сохранены.

## Параметры и поведение

- **Q:** physical spell damage AGI × (2 + 1 × (level−1)); дальность эффекта 1655,
  радиус 255, slow 30 на 5 секунд. В конце прохода остаются восемь равномерных
  базовых участков песка. Радиус участка 255; используется общий spacing.
  Метка длится по native buff 20 секунд. Трекер живёт до удаления buff, смерти
  либо удаления владельца/цели; повторный Q обновляет метку без второго трекера.
  Проверка каждые 0.15 секунды, минимальное перемещение 180, grace 0.30 секунды.
  Отдельный target VFX поверх buff не создаётся.
- **W:** радиус эффекта 600, 3 секунды, 6 hits × 0.75 AGI; slow 30.
  WQ сохраняет дополнительный physical damage 3 AGI и stun 1.5 секунды.
  Сохранено сочетание WR.
- **E:** 3 заряда, recharge/use cooldown 1 секунда; dash 750 за 0.24 секунды,
  physical damage AGI × (3 + 1 × (level−1)), пять contact hits, радиус 375.
  Сохранены отдельный Sand AoE 515 и текущие анимации.
- **R:** 2.5 секунды, скорость 750, радиус 200→400; шесть physical damage hits
  по 0.6 AGI. Сохранены pull, stun 1 секунда, orbit radius 0.2 и WR.
- **T:** native Channel 5 секунд; геометрия расширяется 3 секунды до радиуса
  1700. T2 доступна после 1 секунды. Mana drain 10% max MP раз в секунду;
  одна цель считается один раз в объединении песка. Для enum используется одна
  группа на экземпляр T. Защита от CC через GearCCProtect; incoming damage −20%
  только при активном channel. `hs / unit / StringHash("cast r")` устанавливается
  в 1 на начало и очищается в 0 на окончание; маркер `asta e` не используется.
  Окончание расширения сохраняет channel, aura и защиту. Окончание channel
  снимает защиту, освобождает группу и прекращает mana drain. Полный native finish
  сохраняет пятый mana pulse, даже если event пришёл перед shared timer update.
- **T2:** окно 10 секунд, задержка взрыва 0.5 секунды, physical damage 10 AGI
  по каждому противнику один раз. Сохранены группировка песка, krk и визуалы.
  Начало T2 завершает защиту/расход маны T до задержки взрыва.
- **F:** максимум 3 стака; готовность даёт дальность атаки 800 и +300% AS.
  Cooldown 2 секунды. Single бьёт только выбранную цель через `dmgatk` за 3 AGI.
  Triple запускает три blade, общий hit group даёт каждой цели один hit за 9 AGI.
  Скорость blade 2484, дальность 1700, spread angle 15, AoE 155.
  Собственный single hit пропускается через блокировку native attack; обычная
  атака в windup продолжает блокироваться. F не списывает ману как spell hit.
  Сохранены Abun, восстановление дальности/AS, pause и UI счётчик.
- **G:** каждый положительный финальный physical/magic spell hit забирает 1%
  max MP. Общий source damage получает +0.35% за каждый 1% отсутствующей маны
  цели, cap 15%, один раз. Max MP 0, союзники и illusions исключены.
  На песке +80 MS через BuffUnit01/bloodlust, refresh около 0.20 секунды,
  native duration 0.35 секунды. В object-data Blo2 = 80/310 для MAIN H02M.
  Дополнительный прямой AIms одновременно с buff не выдаётся.

Ground sand lifetime **20 секунд** взят из MAIN descriptions; прежнее TEST/global
значение 30 не использовано как приоритет. Для T сохранён существующий отсчёт
ground lifetime после расширения; T2 availability — отдельное окно 10 секунд.
Остальные текущие значения механик Q/W/E/R сохранены. Native selection/cursor
параметры MAIN остаются исходными; радиусы/дальность эффекта выше — JASS globals.

BuffUnit01 имеет аргументы `(caster, target, abilityId, order, level)`.
Последний аргумент **level=1**, duration берётся из object-data способности.
Q использует `slow` без дополнительного native slow/attack-speed штрафа;
G использует `bloodlust` без дополнительного attack-speed/size бонуса.

## Проверка

- Полная проверка production source tree: **COMPILE OK**, 105 источников,
  optional FrameLoader отсутствует, disabled triggers исключены.
- Существующий workflow `check-save`: **OK**, editor triggers и object-data
  сохранены в основную карту. Повторный check: 0 binary object differences.
- Реальная сборка `Main -NoLaunch`: **BUILD OK**. Архив содержит собственный
  заголовок MAIN HM3W и MPQ; имя карты взято из MAIN W3I/WTS.
- `tools/test_crocodile_main_integration.py`: **20 tests OK**. Проверены ID,
  уровни, независимость F/G, idempotent registration, illusions, расчёт G,
  финальный mana drain, native buff refresh/expiry, Q spacing/tracker/dispel/grace,
  single/triple F, accepted/rejected cast stacks, T до/после расширения,
  T2 unlock, смерть/MUI, T2 delay/union damage, native finish и пятый pulse,
  E contact hits/cleanup и R six hits/landing.
- ID сверены также в **собранном J**, а не только в исходнике. Сохранённый MAIN J
  побайтно совпадает с extracted compiled J успешной сборки.
- Бинарные MAIN units/abilities/buffs прошли lossless parse→encode roundtrip.

Автоматические проверки используют детерминированные native mocks. Игра не
запускалась. Полная ручная матрица из запроса, native buff casting, animation/VFX,
Tornado Wand во время T и взаимодействия с предметами в Warcraft ещё требуют
игрового прогона; эти проверки не обозначены как выполненные.

Предварительный запуск также захватил старые TEST-тесты через импорт класса;
часть их ожиданий/моков устарела. Новый MAIN suite изолирован от этих классов и
проходит. Весь исторический TEST suite не объявляется зелёным.

## Резервные копии

### Исправление паузы E, 2026-10-07

В MAIN воспроизведено ожидание полной дистанции при отказе `MoveUnit`
на границе `gg_rct_Arena` и при непроходимой земле. Старый код держал паузу
до аварийного предела 3 секунды. Бесконечная пауза на свободной земле в игре
не воспроизводилась автоматически; игровой прогон остаётся необходимым.

- E прекращает движение, если фактическое перемещение равно нулю. Если уже
  начались контактные удары, сначала завершаются все пять ударов.
- Общий `CrocodileE_Finish` снимает паузу и освобождает группу до создания
  песка в конце пустого рывка. Код состояния готов до вызова `StartSpellUnit2`.
- Аварийное завершение проверяется в начале E update, до UI и movement helpers.
  Предел вычисляется из длительности рывка и ударов (0.66 секунды при текущих
  настройках), на существующем GearTimer03. Отдельного таймера нет.
- MAIN suite расширен до 26 проверок: реальные тела MAIN movement/pause helpers,
  пустая земля и три заряда, непроходимая земля, граница арены, пять контактных
  ударов с остановкой у границы, прерванные movement updates и ошибка создания
  конечного песка после освобождения героя. Все проверки проходят.
- Копия исходника до этой правки: `backups/crocodile-e-pause-20261007-200241`.
- Сохранение триггеров: `backups/trigger-sync/2026-10-07_200602_115581/map-before-push`.
  Обнаруженные новые данные World Editor были сохранены через штатный rebase.

- До интеграции: `backups/crocodile-main-integration/20261007-184906`.
- Сохранение объектов: `object-data-backups/2026-10-07_191341_186185`.
- Последний push триггеров: `backups/trigger-sync/2026-10-07_192101_965589/map-before-push`.
- Предыдущий compiled MAIN J: `backups/main-map-build/20261007-192134-025/war3map.j`.
- Исходный `war3map.imp` и список добавленных ресурсов находятся в первой копии.

Формат заголовка сверялся с [War3Net MapInfoExtensions](https://github.com/Drake53/War3Net/blob/master/src/War3Net.Build.Core/Extensions/MapInfoExtensions.cs),
SFmpq API — с [объявлениями автора SFmpq](https://github.com/ShadowFlare/WinMPQ/blob/master/SFmpqapi.bas).
