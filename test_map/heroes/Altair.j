library AltairSpells initializer InitAltairSpells uses GearSystems, AAADest
    // =====================================================================================================
    // ALTAIR (Re:Creators), TEST-герой. Дизайн: Google Doc «Altair - Military Uniform Princess».
    // Две формы, переключаются G / SG (после смены 10 с нельзя переключиться обратно):
    //   Holopsicon      Q W E R T F G         — контроль поля, помощь и союзникам, и врагам.
    //   Sword Princess  SQ SW SE SR ST SF SG  — бой мечами, способности платят стаками мечей.
    //
    // КАК ЧИТАТЬ ФАЙЛ. Каждая способность = struct с понятным именем и двумя главными методами:
    //   AltairQ.AltairQ_Start  каст: заполняет экземпляр, ставит его в список, включает тик героя;
    //   AltairQ.AltairQ_Loop   тик 0.03 с: вся жизнь способности по времени (r == 0.15 — что-то случилось
    //                          на 0.15 с) и её конец (чистка + удаление из списка).
    // Цепочка вызова:  CastCheck.j -> функция AltairQ_Start (низ файла) -> AltairQ.AltairQ_Start
    //                  таймер героя 0.03 (AltairTick) -> AltairTick_Loop -> AltairQ.AltairQ_Loop
    // Если у способности несколько стадий (R), каждая стадия — отдельный метод StageN_<Что делает>.
    //
    // Как у Tomioka/Kyoraku: один таймер 0.03 на героя (AltairTick_On(k)/AltairTick_Off(k), k — номер способности),
    //   он идёт только пока хоть одна способность активна; список экземпляров m_<Имя>[0..MUI_<Имя>];
    //   удаление из середины — последний ставится на место удалённого, затем i = i - 1.
    //   Время r округляется RoundReal(r + 0.03, 2), поэтому сравнения r == 0.3 точные.
    // Поля: c = Altair, x/y = точка, r = прошло секунд, rmax = длительность, e = эффект, dmg = урон.
    // Движение: эффекты-снаряды — MoveEff2 (и конец, если следующая точка вне арены, PathableCheck);
    //   юниты — MoveUnit / MUE из GearSystems2. Эффекты создаются EffectSpawn / EffectSpawn3.
    // Справа от строк, где используются глобалы настроек, в комментарии написаны их значения.
    //
    // AltairTable (своя хеш-таблица) на герое: 0 AltairHero, 2 AltairR (запас копий), 3 AltairT, 4 AltairF,
    //   5 AltairSE, 6 AltairSR, 7 AltairST; на любом юните: 1 AltairWBlock, 8 номер залпа R, который его уже задел.
    // Тип урона (typedmg, как в DmgSys): 0 атака, 1 магический, 2 физический, остальное — чистый.
    // =====================================================================================================
    globals
        // ==================== ТИК ГЕРОЯ (как у Tomioka) ====================
        // Номера k: 0 AltairSword, 1 AltairQBullet, 2 AltairQ, 3 AltairW, 4 AltairWBlock, 5 AltairE, 6 AltairRVolley,
        //           7 AltairRCopy, 8 AltairR, 9 AltairT, 10 AltairF, 11 AltairFReflect, 12 AltairSQ, 13 AltairSE,
        //           14 AltairSR, 15 AltairSTSword, 16 AltairST, 17 AltairHero, 18 AltairVoice.
        private timer AltairTick_Timer = CreateTimer()
        private boolean array AltairTick_Active
        private integer AltairTick_Users = 0
        private code AltairTick_Callback = null // задаёт AltairTick_Loop.onInit

        // ==================== COMMON ====================
        integer Altair_ID = 'H004'
        private hashtable AltairTable = InitHashtable()
        private group AltairGroup = CreateGroup() // общая группа перебора: заполняется и сразу опустошается
        private rect AltairEnumRect = Rect(0.0, 0.0, 0.0, 0.0) // общий прямоугольник для перебора декора
        private location AltairLoc = Location(0.0, 0.0) // для чтения высоты земли (AltairGroundZ)
        // Параметры для Enum-callback'ов декора: callback не принимает аргументов, поэтому всё через глобалы.
        private real AltairEnumX = 0.0
        private real AltairEnumY = 0.0
        private real AltairEnumRadius = 0.0
        private integer AltairEnumMaxClass = 0 // R: декор какого класса максимум можно забрать
        private boolean AltairEnumTrain = false // R: можно ли забрать поезд
        private integer array AltairHoloAbility // слоты 0-6 = Q W E R T F G (Holopsicon)
        private integer array AltairSwordAbility // слоты 0-6 = SQ SW SE SR ST SF SG (Sword Princess)
        integer Altair_FormHolopsicon = 0
        integer Altair_FormSword = 1
        real Altair_SwitchLock = 10.0 // КД G и SG после смены формы

        // ==================== Q: PPSH Spray (Holopsicon) ====================
        integer AltairQ_ID = 'A11E'
        real AltairQ_DamageIntBase = 3.0 // урон: Int x (3/4/5/6/7) + 75/100/125/150/175 физ.
        real AltairQ_DamageIntStep = 1.0
        real AltairQ_DamageStatic = 75.0
        real AltairQ_DamageStaticStep = 25.0
        real AltairQ_Aoe = 300.0
        real AltairQ_Decor = 20.0 // урон по декору
        real AltairQ_Stun = 0.5
        real AltairQ_DamageAt = 0.15 // на этой секунде урон
        real AltairQ_SprayTime = 0.6 // сколько длится очередь (пуля каждый тик)
        real AltairQ_BulletSpeed = 2600.0

        // ==================== W: Third / Ninth Movement (Holopsicon) ====================
        integer AltairW_ID = 'A11F'
        real AltairW_Speed = 2000.0 // скорость рывка
        real AltairW_Decor = 20.0
        real AltairW_ContactRange = 90.0 // на этой дистанции до цели — прибытие
        real AltairW_MaxDashTime = 1.2 // рывок обрывается, если не догнал за это время
        real AltairW_Duration = 3.0 // блок союзника + лечение во времени: 3/4/5/6/7 с
        real AltairW_DurationStep = 1.0
        real AltairW_HealIntBase = 1.0 // лечение за всё время: Int x (1 + 0.25/ур.)
        real AltairW_HealIntStep = 0.25
        real AltairW_DamageIntBase = 2.0 // урон врагу: Int x (2 + 0.4/ур.) + 50 + 25/ур. маг.
        real AltairW_DamageIntStep = 0.4
        real AltairW_DamageStatic = 50.0
        real AltairW_DamageStaticStep = 25.0

        // ==================== E: Outline Origin (Holopsicon) ====================
        integer AltairE_ID = 'A120'
        real AltairE_Aoe = 650.0
        real AltairE_CooldownReduction = 5.0 // секунд снимается со всех КД всех юнитов в круге
        real AltairE_DamageIntBase = 1.5 // урон врагам: Int x (1.5 + 0.4/ур.) маг.
        real AltairE_DamageIntStep = 0.4
        real AltairE_StringTime = 0.3 // на этой секунде выстрел ауры (сфера e живёт до него)
        real AltairE_SphereScale = 1.3
        real AltairE_BlockerRadius = 400.0 // юниты в этом радиусе от декора убираются на миг, чтобы декор воскрес
        // Сломанный декор, найденный в круге E (заполняет AltairE.AltairE_CollectDeadDecor).
        private destructable array AltairEDead
        private integer AltairEDeadCount = 0
        // Юниты, временно убранные с места декора (и где они стояли).
        private unit array AltairEMovedUnit
        private real array AltairEMovedX
        private real array AltairEMovedY

        // ==================== R: Factor Mimic (Holopsicon) ====================
        integer AltairR_ID = 'A121'
        real AltairR_Aoe = 600.0 // радиус маркера 1-го каста
        real AltairR_Window = 30.0 // сколько ждёт 2-й каст
        real AltairR_Cooldown = 16.0 // КД после залпа (или если окно истекло с копиями)
        // Классы декора: 1 мелочь, 2 средний (машины, деревья), 3 небольшие здания, 4 большие здания, 5 поезд.
        integer array AltairR_MaxCopies // по уровню R (Init): 3/4/5/6/7 копий
        integer array AltairR_MaxClass // по уровню R (Init): 1/2/3/3/4 — до какого класса можно забрать
        integer AltairR_TrainHeroLevel = 35 // поезд можно поглотить только с этого уровня героя
        real AltairR_TrainRangeMult = 2.0 // копия поезда летит вдвое дальше (1600 -> 3200)
        real AltairR_TrainBlastAoe = 650.0 // взрыв копии поезда: чистый урон поезда RoundEnd в этом радиусе
        real array AltairR_ClassDamage // по классу 1..5 (Init): 100/200/200/400/600 + Int физ. — урон взрыва
        real array AltairR_ClassAoe // по классу (Init): 200/260/320/400/500 — радиус взрыва
        real array AltairR_ClassWidth // по классу (Init): 120/170/240/320/360 — ширина пути
        real array AltairR_ClassStun // по классу (Init): 0.3/0.4/0.5/0.7/1.0 — стан взрыва
        real AltairR_DamageInt = 1.0 // + Int x 1 к урону взрыва любой копии
        real array AltairR_ContactInt // по уровню R (Init): 2.5/3.0/3.5/4.0/4.5 x Int при касании в полёте
        integer AltairR_VolleySerial = 0 // номер залпа: AltairTable[враг][8] = последний залп, что его задел
        real AltairR_GateAt = 0.24 // R3: на этой секунде залпа появляется круг портала
        real AltairR_FirstShotAt = 0.3 // R3: первая копия...
        real AltairR_FireInterval = 0.06 // ...потом по одной каждые 0.06 с
        real AltairR_SpawnBack = 150.0 // R4: копия появляется за спиной Altair
        real AltairR_SpawnBackRandom = 60.0
        real AltairR_EmergeForward = 50.0 // R4: и выдвигается вперёд из портала
        real AltairR_EmergeTime = 0.15
        real AltairR_LaunchAt = 0.3 // R5: возраст копии, когда она вылетает
        real AltairR_LaunchRandom = 0.06
        real AltairR_MinHitArea = 400.0 // минимальная ширина пути и радиус взрыва любой копии
        real AltairR_LaneStep = 200.0 // промежуток между соседними копиями поперёк
        real AltairR_PairOffset = 60.0 // пара «перегруз» (бочка + автомат) летит в 60 друг от друга
        real AltairR_ArenaAoe = 900.0 // арена B00I: радиус взрыва
        real AltairR_ArenaWidth = 550.0 // арена B00I: ширина пути
        real AltairR_AccelTime = 0.15 // R6: разгон после вылета
        real AltairR_ThrowSpeed = 2600.0
        real AltairR_ThrowSpeedRandom = 200.0
        real AltairR_AngleRandom = 0.0 // градусы разброса направления (0 = все параллельно)
        real AltairR_FlightRange = 1600.0
        real AltairR_FlightRangeRandom = 150.0
        real AltairR_TreeSpin = 9.0 // вращение (рад/с): деревья вокруг ствола
        real AltairR_TreeTilt = 0.35
        real AltairR_SmallSpin = 7.0
        real AltairR_MediumSpin = 4.0
        real AltairR_DragStep = 14.0 // тяжёлые копии тащат врагов на N за тик
        real AltairR_DecorSmall = 20.0 // урон по декору классов 1-2
        real AltairR_DecorHeavy = 100.0 // урон по декору классов 3-5
        real AltairR_PortalHeight = 400.0
        real AltairR_TakenRingBig = 1.4 // кольцо YC_BRS для классов 3-5
        real AltairR_TakenRingSmall = 0.42 // кольцо YC_BRS для классов 1-2
        real AltairR_DirtBig = 1.5
        real AltairR_DirtSmall = 0.3
        integer AltairR_AbsorbAnim = 6 // анимация 1-го каста
        integer AltairR_VolleyAnim = 11 // анимация 2-го каста
        real AltairR_HeavyFlightScale = 0.95
        real AltairR_SealZOffset = -200.0
        real AltairR_SealScale = 2.94
        real AltairR_SplashZOffset = 75.0
        real AltairR_SplashScale = 1.0
        real AltairR_GateSpeed = 3.0 // TimeScale круга портала
        real AltairR_PortalBack = 240.0 // портал за спиной Altair
        real AltairR_PortalSideMin = -350.0 // где в портале могут появиться копии (поперёк)
        real AltairR_PortalSideMax = 450.0
        real AltairR_PortalMinHeight = 240.0 // и по высоте
        real AltairR_PortalMaxHeight = 560.0
        real AltairR_HeavyLiftMin = 150.0 // классы 3-5 появляются выше
        real AltairR_HeavyLiftMax = 200.0
        real AltairR_HitPush = 280.0 // R6: толчок MUE при касании в полёте
        real AltairR_HitPushTime = 0.3
        real AltairR_HeavyTilt = 0.12
        real AltairR_LaunchScale = 0.7 // размер копии в портале (x размер объекта)
        real AltairR_FlightScale = 1.1 // размер в полёте
        real AltairR_HeavySpin = 2.5 // здания: вращение вокруг длинной оси
        real AltairR_HeavyLay = 1.5708 // здания летят лёжа (+90 градусов)
        real AltairR_GrowTime = 0.3
        integer AltairR_TrainDecorID = 'B017' // невидимый блокер, который едет за поездом раунда
        integer AltairR_TrainMetroID = 'h00G'
        integer AltairR_TrainThomasID = 'h02N'
        real AltairR_TrainSearch = 900.0
        integer AltairR_KindMetro = -1 // вид копии: индекс таблицы декора >= 0, поезда < 0
        integer AltairR_KindThomas = -2
        integer AltairR_FireBarrelID = 'B00O' // красная бочка: взрыв копии накладывает огонь (элемент 1)
        integer AltairR_VendingID = 'B00S' // автомат: взрыв копии накладывает молнию (элемент 3); огонь + молния = перегруз
        // Таблица копируемого декора (заполняется в Init): тип, модель, средний размер, класс 1-4.
        private integer array AltairDecorId
        private string array AltairDecorModel
        private real array AltairDecorScale
        private integer array AltairDecorClass
        private integer AltairDecorCount = 0
        // Кандидаты 1-го каста (заполняет AltairR_CollectDecorInMarker).
        private destructable array AltairRCandidate
        private real array AltairRCandidateDistance
        private integer AltairRCandidateCount = 0
        // Декор, сломанный R, — его возвращает E (кольцо из 128 последних).
        private destructable array AltairRTaken
        private integer AltairRTakenNext = 0

        // ==================== T: Fate Reconstruction (Holopsicon) ====================
        integer AltairT_ID = 'A122'
        real AltairT_Aoe = 300.0 // радиус, из которого портал затягивает при открытии
        real AltairT_Decor = 50.0 // урон по декору в секунду вокруг открытого портала
        real AltairT_EnterRadius = 140.0 // подошёл к открытому порталу ближе — входит
        integer AltairT_MaxMembers = 4
        real AltairT_Duration = 20.0
        real AltairT_DurationLevel35 = 5.0 // с 35 уровня +5 с (итого 25)
        real AltairT_Cooldown = 60.0
        real AltairT_PullTime = 0.36 // сколько жертвы тянутся к порталу перед телепортом
        real AltairT_PullStep = 30.0 // на сколько тянутся за тик
        real AltairT_RealmSpread = 380.0 // разброс точек появления в реалме вокруг центра
        real AltairT_PortalScale = 3.2
        real AltairT_PortalHeight = 230.0
        // Иной мир: правый нижний угол арены TEST, обнесён непроходимой границей (строится в AltairT_BuildRealm).
        real AltairT_RealmMinX = 1920.0
        real AltairT_RealmMinY = -3392.0
        real AltairT_RealmMaxX = 3168.0
        real AltairT_RealmMaxY = -2240.0
        integer AltairT_RealmDecor = 14 // случайного декора внутри
        rect AltairT_Realm = null

        // ==================== F: The Vicissitudes of Fortune (Holopsicon) ====================
        integer AltairF_ID = 'A123'
        integer AltairF_BuffSpell_ID = 'A166' // способность-даммик (Bloodlust без бонусов): вешает бафф на Altair
        integer AltairF_Buff_ID = 'B075' // бафф F: пока он висит, F работает
        real AltairF_Duration = 6.0 // длительность баффа (задана в объекте A166; здесь для справки)
        real AltairF_MinDamage = 200.0 // срабатывает только на удар от 200 урона
        real AltairF_Reflect = 1.0 // доля урона, которую получают обратно (100%)
        real AltairF_ModelScale = 0.28
        integer AltairF_Swords = 5 // мечей в отражении
        real AltairF_SwordSpeed = 1800.0

        // ==================== G: Meta Change (Holopsicon -> Sword Princess) ====================
        integer AltairG_ID = 'A124'
        integer AltairG_BurstBlades = 12 // мечей разлетается при смене формы

        // ==================== SQ: Sword Rush ====================
        integer AltairSQ_ID = 'A125'
        integer AltairSQ_Cost = 3
        real AltairSQ_Range = 700.0
        real AltairSQ_Speed = 2400.0
        real AltairSQ_Width = 150.0
        real AltairSQ_Decor = 20.0
        real AltairSQ_DamageIntBase = 1.0 // урон: Int x (1 + 0.2/ур.) + атака x 1 (как атака)
        real AltairSQ_DamageIntStep = 0.2
        real AltairSQ_DamageAtk = 1.0

        // ==================== SW: Sword Storm ====================
        integer AltairSW_ID = 'A126'
        integer AltairSW_Cost = 6
        integer AltairSW_Swords = 9
        real AltairSW_Cone = 40.0 // градусы между крайними мечами
        real AltairSW_Range = 1000.0
        real AltairSW_Speed = 1800.0
        real AltairSW_Width = 110.0
        real AltairSW_Decor = 20.0
        real AltairSW_DamageIntBase = 1.2 // урон: Int x (1.2 + 0.3/ур.) + атака x 0.8 (как атака)
        real AltairSW_DamageIntStep = 0.3
        real AltairSW_DamageAtk = 0.8

        // ==================== SE: Spinning Swords ====================
        integer AltairSE_ID = 'A127'
        integer AltairSE_Cost = 2 // цена 2, каждый рекаст в окне +2, максимум 6
        integer AltairSE_CostStep = 2
        integer AltairSE_CostMax = 6
        real AltairSE_RecastWindow = 4.0 // окно, в котором рекаст дороже и сильнее
        real AltairSE_Duration = 1.5
        real AltairSE_Period = 0.25 // урон каждые N секунд
        real AltairSE_Aoe = 300.0
        real AltairSE_Decor = 30.0
        real AltairSE_Radius = 190.0 // радиус кольца мечей
        real AltairSE_Height = 60.0
        real AltairSE_SpinSpeed = 12.0 // рад/с
        integer AltairSE_Blades = 8 // мечей: 8 / 12 / 16 по рекасту
        integer AltairSE_BladesStep = 4
        real AltairSE_PowerStep = 0.5 // сила: x1 / x1.5 / x2 по рекасту
        real AltairSE_DamageIntBase = 0.3 // урон за удар: Int x (0.3 + 0.05/ур.) + атака x 0.15
        real AltairSE_DamageIntStep = 0.05
        real AltairSE_DamageAtk = 0.15

        // ==================== SR: Shield of Swords ====================
        integer AltairSR_ID = 'A128'
        integer AltairSR_Cost = 8
        real AltairSR_Duration = 3.0 // 3 + 0.5/ур.
        real AltairSR_DurationStep = 0.5
        real AltairSR_Arc = 120.0 // градусы закрытой дуги, по центру направление каста
        integer AltairSR_RingBlades = 16
        integer AltairSR_WallBlades = 6
        real AltairSR_Radius = 170.0
        real AltairSR_WallRadius = 120.0
        real AltairSR_SpinSpeed = 6.0
        real AltairSR_Period = 0.3
        real AltairSR_Decor = 20.0
        real AltairSR_DamageInt = 0.15 // урон кольца: Int x 0.15 + атака x 0.1
        real AltairSR_DamageAtk = 0.1

        // ==================== ST: Rain of Swords ====================
        integer AltairST_ID = 'A129'
        integer AltairST_Cost = 30
        real AltairST_Duration = 3.0
        real AltairST_Height = 450.0 // высота полёта Altair
        real AltairST_RiseTime = 0.4
        real AltairST_Aoe = 700.0
        real AltairST_SpawnPeriod = 0.06 // меч каждые N секунд
        real AltairST_DropHeight = 900.0
        real AltairST_DropSpeed = 2400.0
        real AltairST_ImpactAoe = 160.0
        real AltairST_Decor = 50.0 // в секунду по всей площади дождя
        real AltairST_DamageInt = 0.5 // урон меча: Int x 0.5 + атака x 0.3
        real AltairST_DamageAtk = 0.3

        // ==================== SF: Endless Swords ====================
        integer AltairSF_ID = 'A12A'
        integer AltairSF_StackBonus = 15 // максимум стаков = уровень героя + 15 (50 на 35 уровне)
        real AltairSF_StackPeriod = 4.0 // +1 стак каждые 4 с
        integer AltairSF_DeathStacks = 8 // +8 стаков за смерть любого героя
        real AltairSF_AttackTaken = 0.9 // тоггл: входящие атаки -10%...
        integer AltairSF_AttackCost = 2 // ...и каждая стоит 2 стака
        integer AltairSF_GuardBlades = 4
        real AltairSF_GuardRadius = 110.0

        // ==================== SG: Meta Change (Sword Princess -> Holopsicon) ====================
        integer AltairSG_ID = 'A12B'
    endglobals

    // ==================== ТИК ГЕРОЯ: включить / выключить способность k ====================
    // Таймер 0.03 запускается, когда активна первая способность, и встаёт, когда выключена последняя.
    private function AltairTick_On takes integer k returns nothing
        if not AltairTick_Active[k] then
            set AltairTick_Active[k] = true
            set AltairTick_Users = AltairTick_Users + 1
            if AltairTick_Users == 1 then
                call TimerStart(AltairTick_Timer, 0.03, true, AltairTick_Callback)
            endif
        endif
    endfunction

    private function AltairTick_Off takes integer k returns nothing
        if AltairTick_Active[k] then
            set AltairTick_Active[k] = false
            set AltairTick_Users = AltairTick_Users - 1
            if AltairTick_Users <= 0 then
                set AltairTick_Users = 0
                call PauseTimer(AltairTick_Timer)
            endif
        endif
    endfunction

    // ==================== COMMON: короткие помощники (только то, чего нет в GearSystems) ====================
    // Высота земли в точке (для эффектов, которые держат абсолютную высоту: копии R, мечи ST/F).
    private function AltairGroundZ takes real x, real y returns real
        call MoveLocation(AltairLoc, x, y)
        return GetLocationZ(AltairLoc)
    endfunction

    // Жив ли юнит. Мёртвый герой может держать жизнь выше 0.405, поэтому проверяем ещё UNIT_TYPE_DEAD.
    private function AltairAlive takes unit whichUnit returns boolean
        return GetUnitTypeId(whichUnit) != 0 and not IsUnitType(whichUnit, UNIT_TYPE_DEAD) and GetWidgetLife(whichUnit) > 0.405
    endfunction

    // Таблица копируемого декора R (вызывается только из Init).
    private function AltairDecor takes integer id, string model, real scale, integer decorClass returns nothing
        set AltairDecorId[AltairDecorCount] = id
        set AltairDecorModel[AltairDecorCount] = model
        set AltairDecorScale[AltairDecorCount] = scale
        set AltairDecorClass[AltairDecorCount] = decorClass
        set AltairDecorCount = AltairDecorCount + 1
    endfunction

    // Индекс декора в таблице (-1 = такой декор R не копирует).
    private function AltairDecorIndex takes integer id returns integer
        local integer index = 0
        loop
            exitwhen index >= AltairDecorCount
            if AltairDecorId[index] == id then
                return index
            endif
            set index = index + 1
        endloop
        return -1
    endfunction

    // ==================== COMMON: заклинание Holopsicon из трёх кусков ====================
    // Длинная реплика «Holopsicon — N-я глава — название» разрезана на 3 коротких файла <base>a / <base>b / <base>c
    // (паузы между словами вырезаны). AltairVoice_Start играет «a» сразу, «b» через t2 секунд, «c» через t3
    // (t2 = длительность a, t3 = a + b). Файлы: W1 (Third), W2 (Ninth), E1 (Thirteenth), R1 (Twentieth), T1 (Twenty-third).
    private struct AltairVoice
        private static integer array m_AltairVoice
        private static integer MUI_AltairVoice = -1
        string base // путь без буквы куска, например "war3mapImported\\Hero_Altair_W1"
        real r // прошло с начала
        real t2 // когда играть кусок b
        real t3 // когда играть кусок c
        boolean playedB

        static method AltairVoice_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_AltairVoice
                set this = m_AltairVoice[i]
                set r = RoundReal(r + 0.03, 2)
                if not playedB and r >= t2 then
                    // КУСОК b: номер главы.
                    set playedB = true
                    call MakeSound(base + "b")
                elseif playedB and r >= t3 then
                    // КУСОК c: название — и конец.
                    call MakeSound(base + "c")
                    set m_AltairVoice[i] = m_AltairVoice[MUI_AltairVoice]
                    set MUI_AltairVoice = MUI_AltairVoice - 1
                    set i = i - 1
                    if MUI_AltairVoice == -1 then
                        call AltairTick_Off(18)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
        endmethod

        static method AltairVoice_Start takes string NewBase, real NewT2, real NewT3 returns nothing
            local thistype this = thistype.create()
            set MUI_AltairVoice = MUI_AltairVoice + 1
            set m_AltairVoice[MUI_AltairVoice] = this
            set base = NewBase
            set r = 0.0
            set t2 = NewT2
            set t3 = NewT3
            set playedB = false
            call MakeSound(base + "a") // КУСОК a: «Holopsicon»
            if MUI_AltairVoice == 0 then
                call AltairTick_On(18)
            endif
        endmethod
    endstruct

    // ==================== COMMON: летящий меч (SW — веер с уроном, G — разлёт без урона) ====================
    // AltairSword_Throw  меч появляется (EffectSpawn) и летит по прямой.
    // AltairSword_Loop   MoveEff2 каждый тик; если dmg > 0 — бьёт врагов в полосе width по одному разу
    //                    (группа hits общая на весь каст, поэтому враг получает урон только от одного меча веера);
    //                    в конце дистанции или на краю арены — гаснет.
    // Меч wos_Erza_sword2 лежит плашмя вдоль X: yaw = направление острия.
    private struct AltairSword
        private static integer array m_AltairSword
        private static integer MUI_AltairSword = -1
        unit c
        effect e // меч
        real a // направление полёта (рад)
        real speed
        real d // пройдено
        real dmax // дальность
        real width // полуширина полосы урона
        real dmg // 0 = меч только визуальный
        group hits // общая на каст; число мечей, которые её держат, лежит в AltairTable[группа][0]

        static method AltairSword_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real step
            local integer users
            local unit u
            loop
                exitwhen i > MUI_AltairSword
                set this = m_AltairSword[i]
                set step = speed*0.03
                set d = d + step
                if d < dmax and PathableCheck(GetEffX(e) + step*Cos(a), GetEffY(e) + step*Sin(a)) then
                    // ПОЛЁТ: сдвинуть меч; если он боевой — ударить новых врагов в полосе и сломать декор.
                    call MoveEff2(e, step, a)
                    if dmg > 0.0 then
                        call GroupEnumUnitsInRange(AltairGroup, GetEffX(e), GetEffY(e), width, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(AltairGroup)
                            exitwhen u == null
                            call GroupRemoveUnit(AltairGroup, u)
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, hits) then
                                call GroupAddUnit(hits, u) // этого врага веер больше не бьёт
                                call DamageSource(AltairSW_ID)
                                call dmgatk(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_Opdef (571)2.mdl", GetUnitX(u), GetUnitY(u), 0.0, 1.0, 1.5, 76.0))
                            endif
                        endloop
                        call DecorRemove(c, GetEffX(e), GetEffY(e), width, AltairSW_Decor) // AltairSW_Decor = 20
                    endif
                else
                    // КОНЕЦ: долетел или край арены — меч гаснет; последний меч каста удаляет общую группу.
                    call ColorEffDummy3(e, 0.0, 255, 255, 255, 0.15)
                    if hits != null then
                        set users = LoadInteger(AltairTable, GetHandleId(hits), 0) - 1
                        if users <= 0 then
                            call RemoveSavedInteger(AltairTable, GetHandleId(hits), 0)
                            call DestroyGroup(hits)
                        else
                            call SaveInteger(AltairTable, GetHandleId(hits), 0, users)
                        endif
                    endif
                    set e = null
                    set hits = null
                    set c = null
                    set m_AltairSword[i] = m_AltairSword[MUI_AltairSword]
                    set MUI_AltairSword = MUI_AltairSword - 1
                    set i = i - 1
                    if MUI_AltairSword == -1 then
                        call AltairTick_Off(0)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        static method AltairSword_Throw takes unit NewC, real NewX, real NewY, real NewHeight, real NewAngle, real NewSpeed, real NewRange, real NewWidth, real NewDmg, group NewHits returns nothing
            local thistype this = thistype.create()
            set MUI_AltairSword = MUI_AltairSword + 1
            set m_AltairSword[MUI_AltairSword] = this
            set c = NewC
            set a = NewAngle
            set speed = NewSpeed
            set dmax = NewRange
            set width = NewWidth
            set dmg = NewDmg
            set d = 0.0
            set hits = NewHits
            if hits != null then
                // Ещё один меч держит общую группу.
                call SaveInteger(AltairTable, GetHandleId(hits), 0, LoadInteger(AltairTable, GetHandleId(hits), 0) + 1)
            endif
            set e = EffectSpawn("war3mapImported\\wos_Erza_sword2.mdx", NewX, NewY, a*bj_RADTODEG, 1.0, 0.45, NewHeight)
            if MUI_AltairSword == 0 then
                call AltairTick_On(0)
            endif
        endmethod
    endstruct

    // ==================== COMMON: состояние героя (форма, стаки мечей, кнопки) ====================
    // Один экземпляр на Altair, живёт всю игру (AltairTable[герой][0]).
    // AltairHero_Register  первый каст/спавн: выдаёт кнопки обеих форм, показывает Holopsicon.
    // AltairHero_Loop      тик: +1 стак каждые AltairSF_StackPeriod, окно рекаста SE, сброс КД отклонённого каста,
    //                      мечи-охранники SF, перерисовка кнопок Sword Princess раз в 0.09 с.
    // Сама смена формы (визуал, КД, разлёт мечей) — в функциях AltairG_Start / AltairSG_Start внизу файла.
    private struct AltairHero
        private static integer array m_AltairHero
        private static integer MUI_AltairHero = -1
        unit c
        integer form // Altair_FormHolopsicon = 0, Altair_FormSword = 1
        integer stacks // стаки мечей
        integer shownStacks // что написано на счётчике SF (-1 = перерисовать)
        real stackTimer // сколько накопилось до следующего стака
        boolean swordToggle // SF включён
        effect array guard[4] // мечи-охранники SF
        real guardAngle
        integer array holoLevel[7] // уровни Q..T на прошлой перерисовке (кнопки Sword Princess повторяют их)
        boolean array swordDisabled[7] // какие кнопки Sword Princess сейчас серые
        integer seCost // текущая цена SE: 2 -> 4 -> 6 при рекасте в окне
        real seWindow // сколько ещё длится окно рекаста SE
        integer refundAbility // снять КД этой способности на следующем тике (каст отклонён или G закрыл реалм)
        real refreshTimer

        static method AltairHero_Get takes unit u returns thistype
            return LoadInteger(AltairTable, GetHandleId(u), 0)
        endmethod

        method MaxStacks takes nothing returns integer
            return GetHeroLevel(c) + AltairSF_StackBonus // AltairSF_StackBonus = 15
        endmethod

        // Стаки всегда в пределах 0..уровень+15.
        method AddStacks takes integer amount returns nothing
            set stacks = IMinBJ(MaxStacks(), IMaxBJ(0, stacks + amount))
        endmethod

        // false = не хватает стаков (ничего не списано).
        method SpendStacks takes integer cost returns boolean
            if stacks < cost then
                return false
            endif
            set stacks = stacks - cost
            return true
        endmethod

        // Нативный КД встаёт уже после SPELL_EFFECT — поэтому снимаем его на следующем тике.
        method RefundCooldown takes integer abilityId returns nothing
            set refundAbility = abilityId
        endmethod

        // Каст отклонён: красное сообщение игроку и сброс КД.
        method RefuseCast takes integer abilityId, string reason returns nothing
            call RefundCooldown(abilityId)
            call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0.0, 0.0, 2.0, "|cffff6060" + reason + "|r")
        endmethod

        // SF включён: 4 меча кружат вокруг героя (двигает AltairHero_Loop). Выключен: мечи гаснут.
        method SetSwordGuard takes boolean enabled returns nothing
            local integer slot = 0
            set swordToggle = enabled
            loop
                exitwhen slot >= AltairSF_GuardBlades // AltairSF_GuardBlades = 4
                if enabled and guard[slot] == null then
                    set guard[slot] = EffectSpawn("war3mapImported\\wos_Erza_sword2.mdx", GetUnitX(c), GetUnitY(c), 0.0, 1.0, 0.3, 90.0)
                elseif not enabled and guard[slot] != null then
                    call ColorEffDummy3(guard[slot], 0.0, 255, 255, 255, 0.2)
                    set guard[slot] = null
                endif
                set slot = slot + 1
            endloop
        endmethod

        // Прячет кнопки одной формы и показывает кнопки другой (SetPlayerAbilityAvailable — на всего игрока).
        method ApplyForm takes integer newForm returns nothing
            local integer slot = 0
            local player owner = GetOwningPlayer(c)
            set form = newForm
            loop
                exitwhen slot > 6
                call SetPlayerAbilityAvailable(owner, AltairHoloAbility[slot], form == Altair_FormHolopsicon)
                call SetPlayerAbilityAvailable(owner, AltairSwordAbility[slot], form == Altair_FormSword)
                set slot = slot + 1
            endloop
            if form == Altair_FormHolopsicon then
                call SetSwordGuard(false) // SF живёт только в Sword Princess
            endif
            set shownStacks = -1
            set owner = null
        endmethod

        // Уровни SQ..SR повторяют изученные Q..R; кнопка серая, если слот не изучен или не хватает стаков.
        // Счётчик стаков рисуется на кнопке SF (TasAbilityChargeBox).
        method RefreshSwordButtons takes nothing returns nothing
            local integer slot = 0
            local integer level
            local integer cost
            local boolean disable
            loop
                exitwhen slot > 4
                set level = GetUnitAbilityLevel(c, AltairHoloAbility[slot])
                if level != holoLevel[slot] then
                    set holoLevel[slot] = level
                    if level > 0 and slot < 4 then
                        call SetUnitAbilityLevel(c, AltairSwordAbility[slot], level)
                    endif
                endif
                if slot == 0 then
                    set cost = AltairSQ_Cost // 3
                elseif slot == 1 then
                    set cost = AltairSW_Cost // 6
                elseif slot == 2 then
                    set cost = seCost // 2 -> 4 -> 6
                elseif slot == 3 then
                    set cost = AltairSR_Cost // 8
                else
                    set cost = AltairST_Cost // 30
                endif
                set disable = level == 0 or stacks < cost
                if disable != swordDisabled[slot] then // нативку зовём только при изменении
                    set swordDisabled[slot] = disable
                    call BlzUnitDisableAbility(c, AltairSwordAbility[slot], disable, false)
                endif
                set slot = slot + 1
            endloop
            if stacks != shownStacks then
                set shownStacks = stacks
                call TasAbilityChargeBox_SetValue(c, AltairSF_ID, I2S(stacks))
            endif
        endmethod

        static method AltairHero_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer slot
            local real angle
            local real z
            loop
                exitwhen i > MUI_AltairHero
                set this = m_AltairHero[i]
                if GetUnitTypeId(c) != 0 then
                    // СТАКИ ПО ВРЕМЕНИ: только пока жива.
                    if AltairAlive(c) then
                        set stackTimer = stackTimer + 0.03
                        if stackTimer >= AltairSF_StackPeriod then // AltairSF_StackPeriod = 4
                            set stackTimer = stackTimer - AltairSF_StackPeriod
                            call AddStacks(1)
                        endif
                    endif
                    // ОКНО РЕКАСТА SE: истекло — цена снова 2.
                    if seWindow > 0.0 then
                        set seWindow = seWindow - 0.03
                        if seWindow <= 0.0 then
                            set seCost = AltairSE_Cost // 2
                        endif
                    endif
                    // СБРОС КД, заказанный RefundCooldown/RefuseCast.
                    if refundAbility != 0 then
                        call BlzEndUnitAbilityCooldown(c, refundAbility)
                        set refundAbility = 0
                    endif
                    // SF выключается сам, если стаков не хватает на удар или Altair умерла.
                    if swordToggle and (stacks < AltairSF_AttackCost or not AltairAlive(c)) then // AltairSF_AttackCost = 2
                        call SetSwordGuard(false)
                    endif
                    // МЕЧИ-ОХРАННИКИ SF кружат вокруг героя (орбита, не снаряд — ставим позицию напрямую).
                    if swordToggle then
                        set z = BlzGetUnitZ(c)
                        set guardAngle = guardAngle + 0.06
                        set slot = 0
                        loop
                            exitwhen slot >= AltairSF_GuardBlades // 4
                            set angle = guardAngle + slot*2.0*bj_PI/AltairSF_GuardBlades
                            call BlzSetSpecialEffectPosition(guard[slot], GetUnitX(c) + AltairSF_GuardRadius*Cos(angle), GetUnitY(c) + AltairSF_GuardRadius*Sin(angle), z + 90.0) // AltairSF_GuardRadius = 110
                            call BlzSetSpecialEffectYaw(guard[slot], angle)
                            set slot = slot + 1
                        endloop
                    endif
                    // КНОПКИ раз в 0.09 с (не каждый тик — экономия нативов).
                    set refreshTimer = refreshTimer + 0.03
                    if refreshTimer >= 0.09 then
                        set refreshTimer = 0.0
                        call RefreshSwordButtons()
                    endif
                else
                    // КОНЕЦ: герой удалён из игры — убрать мечи SF и состояние.
                    call SetSwordGuard(false)
                    call RemoveSavedInteger(AltairTable, GetHandleId(c), 0)
                    set c = null
                    set m_AltairHero[i] = m_AltairHero[MUI_AltairHero]
                    set MUI_AltairHero = MUI_AltairHero - 1
                    set i = i - 1
                    if MUI_AltairHero == -1 then
                        call AltairTick_Off(17)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
        endmethod

        static method AltairHero_Register takes unit NewC returns thistype
            local thistype this = LoadInteger(AltairTable, GetHandleId(NewC), 0)
            local integer slot = 0
            if this != 0 then
                return this // уже зарегистрирована
            endif
            set this = thistype.create()
            set MUI_AltairHero = MUI_AltairHero + 1
            set m_AltairHero[MUI_AltairHero] = this
            set c = NewC
            set stacks = 0
            set shownStacks = -1
            set stackTimer = 0.0
            set swordToggle = false
            set guardAngle = 0.0
            set seCost = AltairSE_Cost // 2
            set seWindow = 0.0
            set refundAbility = 0
            set refreshTimer = 0.0
            loop
                exitwhen slot > 6
                set holoLevel[slot] = 0
                set swordDisabled[slot] = false
                if slot < 4 then
                    set guard[slot] = null
                endif
                // Q..T учит сам игрок; F и G, а также все кнопки Sword Princess выдаются здесь.
                if slot >= 5 then
                    call UnitAddAbility(c, AltairHoloAbility[slot])
                    call UnitMakeAbilityPermanent(c, true, AltairHoloAbility[slot])
                endif
                call UnitAddAbility(c, AltairSwordAbility[slot])
                call UnitMakeAbilityPermanent(c, true, AltairSwordAbility[slot])
                set slot = slot + 1
            endloop
            call SaveInteger(AltairTable, GetHandleId(c), 0, this)
            call ApplyForm(Altair_FormHolopsicon)
            if MUI_AltairHero == 0 then
                call AltairTick_On(17)
            endif
            return this
        endmethod

        // Death.j: смерть любого героя (кроме самой Altair) даёт каждой Altair стаки.
        static method AltairHero_OnHeroDeath takes unit dying returns nothing
            local integer i = 0
            local thistype this
            loop
                exitwhen i > MUI_AltairHero
                set this = m_AltairHero[i]
                if c != dying then
                    call AddStacks(AltairSF_DeathStacks) // AltairSF_DeathStacks = 8
                endif
                set i = i + 1
            endloop
        endmethod
    endstruct

    // ==================== Q: PPSH Spray ====================
    // КАК РАБОТАЕТ Q:
    //   AltairQ.AltairQ_Start  герой разворачивается к точке, круг на земле, звук, считается урон.
    //   AltairQ.AltairQ_Loop   каждый тик летит пуля (AltairQBullet — только визуал), раз в 0.12 с вспышка ствола;
    //                          r == AltairQ_DamageAt (0.15) — урон + стан всем врагам в AltairQ_Aoe;
    //                          r == AltairQ_SprayTime (0.6) или смерть героя — конец.

    // Одна пуля: летит (MoveEff2) от ствола к точке в круге, в конце вспышка попадания. Урона не наносит.
    private struct AltairQBullet
        private static integer array m_AltairQBullet
        private static integer MUI_AltairQBullet = -1
        effect e
        real d // сколько ещё лететь
        real a // направление

        static method AltairQBullet_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real step = AltairQ_BulletSpeed*0.03 // AltairQ_BulletSpeed = 2600
            loop
                exitwhen i > MUI_AltairQBullet
                set this = m_AltairQBullet[i]
                set d = d - step
                if d > 0.0 and PathableCheck(GetEffX(e) + step*Cos(a), GetEffY(e) + step*Sin(a)) then
                    call MoveEff2(e, step, a)
                else
                    // ПОПАДАНИЕ: пуля исчезает, вспышка и иногда пыль.
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_hit-juhuang1.mdl", GetEffX(e), GetEffY(e), GetRandomReal(0.0, 359.0), 1.5, 0.5, 5.0))
                    if GetRandomInt(1, 3) == 1 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_dustbrown.mdl", GetEffX(e), GetEffY(e), GetRandomReal(0.0, 359.0), 1.5, 0.4, 0.0))
                    endif
                    call DestroyEffect(e)
                    set e = null
                    set m_AltairQBullet[i] = m_AltairQBullet[MUI_AltairQBullet]
                    set MUI_AltairQBullet = MUI_AltairQBullet - 1
                    set i = i - 1
                    if MUI_AltairQBullet == -1 then
                        call AltairTick_Off(1)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
        endmethod

        static method AltairQBullet_Fire takes real fromX, real fromY, real toX, real toY returns nothing
            local thistype this = thistype.create()
            set MUI_AltairQBullet = MUI_AltairQBullet + 1
            set m_AltairQBullet[MUI_AltairQBullet] = this
            set a = Atan2(toY - fromY, toX - fromX)
            set d = SquareRoot((toX - fromX)*(toX - fromX) + (toY - fromY)*(toY - fromY))
            set e = EffectSpawn("war3mapImported\\wos_alucard bullet.mdl", fromX, fromY, a*bj_RADTODEG, 2.0, 0.8, 70.0)
            if MUI_AltairQBullet == 0 then
                call AltairTick_On(1)
            endif
        endmethod
    endstruct

    private struct AltairQ
        private static integer array m_AltairQ
        private static integer MUI_AltairQ = -1
        unit c
        real x // точка каста
        real y
        real r // прошло с каста
        real rmax // AltairQ_SprayTime
        integer flashCount // тики до следующей вспышки ствола
        real dmg

        static method AltairQ_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real distance
            local real a
            local real muzzleX
            local real muzzleY
            local unit u
            loop
                exitwhen i > MUI_AltairQ
                set this = m_AltairQ[i]
                if AltairAlive(c) and r < rmax then
                    set r = RoundReal(r + 0.03, 2)
                    // Ствол — в 75 перед героем в сторону точки.
                    set a = GAngle2(c, x, y)
                    set muzzleX = GetUnitX(c) + 75.0*Cos(a)
                    set muzzleY = GetUnitY(c) + 75.0*Sin(a)
                    // УРОН на AltairQ_DamageAt.
                    if r == AltairQ_DamageAt then // AltairQ_DamageAt = 0.15
                        call GroupEnumUnitsInRange(AltairGroup, x, y, AltairQ_Aoe, NoDecor_Cond) // AltairQ_Aoe = 300
                        loop
                            set u = FirstOfGroup(AltairGroup)
                            exitwhen u == null
                            call GroupRemoveUnit(AltairGroup, u)
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call DamageSource(AltairQ_ID)
                                call dmgphys(c, u, dmg)
                                call StunUnit(c, u, AltairQ_Stun) // AltairQ_Stun = 0.5
                                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_hit-juhuang1.mdl", u, "chest"))
                            endif
                        endloop
                        call DecorRemove(c, x, y, AltairQ_Aoe, AltairQ_Decor) // AltairQ_Aoe = 300, AltairQ_Decor = 20
                        call VisionTimed(GetOwningPlayer(c), x, y, AltairQ_Aoe*1.6, 2.0) // AltairQ_Aoe = 300
                    endif
                    // ПУЛЯ каждый тик в случайную точку круга (равномерно по площади — sqrt).
                    set distance = AltairQ_Aoe*SquareRoot(GetRandomReal(0.0, 1.0)) // AltairQ_Aoe = 300
                    set a = GetRandomReal(0.0, 2.0*bj_PI)
                    call AltairQBullet.AltairQBullet_Fire(muzzleX, muzzleY, x + distance*Cos(a), y + distance*Sin(a))
                    // ВСПЫШКА СТВОЛА каждые 4 тика (0.12 с).
                    set flashCount = flashCount - 1
                    if flashCount <= 0 then
                        set flashCount = 4
                        set a = GAngle2(c, x, y)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_huoqiang02_T1.mdx", muzzleX, muzzleY, a*bj_RADTODEG, 2.0, 0.35, 90.0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_alucard bulletfire.mdl", muzzleX, muzzleY, a*bj_RADTODEG, 1.5, 0.8, 90.0))
                    endif
                else
                    // КОНЕЦ очереди (время вышло или Altair умерла).
                    set c = null
                    set m_AltairQ[i] = m_AltairQ[MUI_AltairQ]
                    set MUI_AltairQ = MUI_AltairQ - 1
                    set i = i - 1
                    if MUI_AltairQ == -1 then
                        call AltairTick_Off(2)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        static method AltairQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer lvl = IMaxBJ(1, GetUnitAbilityLevel(NewC, AltairQ_ID))
            set MUI_AltairQ = MUI_AltairQ + 1
            set m_AltairQ[MUI_AltairQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set rmax = AltairQ_SprayTime // 0.6
            set flashCount = 0 // первая вспышка на первом тике
            set dmg = GetHeroInt(c, true)*(AltairQ_DamageIntBase + AltairQ_DamageIntStep*(lvl - 1)) + AltairQ_DamageStatic + AltairQ_DamageStaticStep*(lvl - 1) // Int x (3 + 1/ур.) + 75 + 25/ур.
            call SetUnitFacing(c, GAngle2(c, x, y)*bj_RADTODEG)
            call SetUnitAnimation(c, "attack")
            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_yc_bluemorphcircle3.mdl", x, y, 0.0, 2.0, AltairQ_Aoe/220.0, 5.0), 0.25, 255, 255, 255, 0.35) // AltairQ_Aoe = 300
            call MakeSound("war3mapImported\\Hero_Altair_Q" + I2S(GetRandomInt(1, 3))) // Q1 «Глупец», Q2 «Попробуй ещё раз», Q3 «Увы, жаль»
            if MUI_AltairQ == 0 then
                call AltairTick_On(2)
            endif
        endmethod
    endstruct

    // ==================== W: Third / Ninth Movement ====================
    // КАК РАБОТАЕТ W:
    //   AltairW.AltairW_Start  рывок к цели (союзник или враг), вспышка на старте, герой «в касте» (StartSpellUnit2).
    //   AltairW.AltairW_Loop   MoveUnit со скоростью AltairW_Speed, шлейф образов (белые к союзнику, чёрные к врагу);
    //                          в AltairW_ContactRange — ПРИБЫТИЕ:
    //                            союзник (Third Movement): снять дебаффы, блок одного удара (AltairWBlock), лечение во времени;
    //                            враг (Ninth Movement): снять все баффы и щиты, магический урон.
    //                          Конец: прибытие / AltairW_MaxDashTime / смерть одного из двоих.
    //   Блок съедается в Altair_IncomingDamage (AltairWBlock.AltairWBlock_Use); Lust Sin его пробивает.

    // Блок одного удара Third Movement на союзнике (AltairTable[unit][1]).
    private struct AltairWBlock
        private static integer array m_AltairWBlock
        private static integer MUI_AltairWBlock = -1
        unit u // кого защищает
        real rmax // сколько ещё живёт блок (0 = потрачен, убрать на следующем тике)
        effect e // щит над головой

        static method AltairWBlock_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_AltairWBlock
                set this = m_AltairWBlock[i]
                set rmax = rmax - 0.03
                if rmax <= 0.0 or not AltairAlive(u) then
                    // КОНЕЦ: время вышло или блок потрачен.
                    call DestroyEffect(e)
                    call RemoveSavedInteger(AltairTable, GetHandleId(u), 1)
                    set e = null
                    set u = null
                    set m_AltairWBlock[i] = m_AltairWBlock[MUI_AltairWBlock]
                    set MUI_AltairWBlock = MUI_AltairWBlock - 1
                    set i = i - 1
                    if MUI_AltairWBlock == -1 then
                        call AltairTick_Off(4)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
        endmethod

        // Выдать блок (если уже есть — продлить до большей длительности).
        static method AltairWBlock_Give takes unit NewU, real duration returns nothing
            local thistype this = LoadInteger(AltairTable, GetHandleId(NewU), 1)
            if this == 0 then
                set this = thistype.create()
                set MUI_AltairWBlock = MUI_AltairWBlock + 1
                set m_AltairWBlock[MUI_AltairWBlock] = this
                set u = NewU
                set rmax = 0.0
                set e = AddSpecialEffectTarget("war3mapImported\\wos_title_shielded.mdl", u, "overhead")
                call SaveInteger(AltairTable, GetHandleId(u), 1, this)
                if MUI_AltairWBlock == 0 then
                    call AltairTick_On(4)
                endif
            endif
            set rmax = RMaxBJ(rmax, duration)
        endmethod

        // true = удар заблокирован (блок тратится). Также зовётся Ninth Movement, чтобы стереть блок с врага.
        static method AltairWBlock_Use takes unit whichUnit returns boolean
            local thistype this = LoadInteger(AltairTable, GetHandleId(whichUnit), 1)
            if this == 0 or rmax <= 0.0 then
                return false
            endif
            set rmax = 0.0
            call ColorEffDummy3(AddSpecialEffectTarget("war3mapImported\\wos_whitering.mdx", u, "origin"), 0.25, 255, 255, 255, 0.35)
            return true
        endmethod
    endstruct

    private struct AltairW
        private static integer array m_AltairW
        private static integer MUI_AltairW = -1
        unit c
        unit td // цель рывка
        boolean ally // союзник (Third Movement) или враг (Ninth Movement)
        integer lvl
        real r // прошло с каста
        real rmax // AltairW_MaxDashTime
        integer trailCount // тики до следующего образа шлейфа

        static method AltairW_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real distance
            local real a
            local real duration
            local real x
            local real y
            loop
                exitwhen i > MUI_AltairW
                set this = m_AltairW[i]
                if AltairAlive(c) and AltairAlive(td) and r < rmax then
                    set r = RoundReal(r + 0.03, 2)
                    set distance = SR2(c, td)
                    set a = GAngle(c, td)
                    if distance > AltairW_ContactRange then // AltairW_ContactRange = 90
                        // РЫВОК: шаг не дальше, чем до половины дистанции контакта (не проскочить цель).
                        call MoveUnit(c, RMinBJ(AltairW_Speed*0.03, distance - AltairW_ContactRange*0.5), a) // AltairW_Speed = 2000
                        call DecorRemove(c, GetUnitX(c), GetUnitY(c), 120.0, AltairW_Decor) // AltairW_Decor = 20
                        call SetUnitFacing(c, a*bj_RADTODEG)
                        // Шлейф образов каждые 2 тика (0.06 с): белые к союзнику, чёрные к врагу.
                        set trailCount = trailCount - 1
                        if trailCount <= 0 then
                            set trailCount = 2
                            if ally then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_White.mdx", GetUnitX(c), GetUnitY(c), a*bj_RADTODEG, 1.5, 1.0, 0.0))
                            else
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), a*bj_RADTODEG, 1.5, 1.0, 0.0))
                            endif
                        endif
                    else
                        // ПРИБЫТИЕ.
                        set r = 9999.0 // на следующем тике — конец
                        set duration = AltairW_Duration + AltairW_DurationStep*(lvl - 1) // 3 + 1/ур.
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        if ally then
                            // Third Movement: сюжет переписан цветами — дебаффы сняты, блок, лечение во времени.
                            call UnitRemoveBuffs(td, false, true)
                            call AltairWBlock.AltairWBlock_Give(td, duration)
                            call HPS(c, td, GetHeroInt(c, true)*(AltairW_HealIntBase + AltairW_HealIntStep*(lvl - 1)), duration) // Int x (1 + 0.25/ур.)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_KyorakuPetals.mdx", x, y, GetRandomReal(0.0, 359.0), 1.0, 1.6, 0.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_KyorakuPetals.mdx", x, y, GetRandomReal(0.0, 359.0), 1.3, 1.1, 60.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Altair3.mdx", x, y, 0.0, 1.0, 0.8, 0.0))
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_HealBlue.mdl", td, "origin"))
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_yc_bluemorphcircle3.mdl", x, y, 0.0, 1.0, 0.8, 5.0), 0.25, 255, 255, 255, 0.35)
                        elseif SpellBool(td) and IsUnitEnemy(td, GetOwningPlayer(c)) then
                            // Ninth Movement: стираются все баффы, включая щиты (и блок W, если он был), затем урон.
                            call UnitRemoveBuffs(td, true, false)
                            call AltairWBlock.AltairWBlock_Use(td)
                            call SaveInteger(hs, GetHandleId(td), KEY_SHIELD, 0)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_mirrorzi_effect_ansekuosanbo.mdx", x, y, GetRandomReal(0.0, 359.0), 1.0, 1.3, 0.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", x, y, GetUnitFacing(td), 1.0, 1.3, 0.0))
                            call DamageSource(AltairW_ID)
                            call dmgmag(c, td, GetHeroInt(c, true)*(AltairW_DamageIntBase + AltairW_DamageIntStep*(lvl - 1)) + AltairW_DamageStatic + AltairW_DamageStaticStep*(lvl - 1)) // Int x (2 + 0.4/ур.) + 50 + 25/ур.
                        endif
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_jingzi_jiansheng01_e1_l2.mdl", x, y, GetUnitFacing(c), 1.5, 0.8, 60.0))
                        call DecorRemove(c, x, y, 200.0, AltairW_Decor) // AltairW_Decor = 20
                        call VisionTimed(GetOwningPlayer(c), x, y, 500.0, 2.0)
                    endif
                else
                    // КОНЕЦ: герой снова управляем.
                    call StopSpellUnit2(c)
                    set c = null
                    set td = null
                    set m_AltairW[i] = m_AltairW[MUI_AltairW]
                    set MUI_AltairW = MUI_AltairW - 1
                    set i = i - 1
                    if MUI_AltairW == -1 then
                        call AltairTick_Off(3)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
        endmethod

        // false = нет цели или цель — сама Altair (каст не засчитан).
        static method AltairW_Start takes unit NewC, unit NewTd returns boolean
            local thistype this
            if NewTd == null or NewTd == NewC then
                return false
            endif
            set this = thistype.create()
            set MUI_AltairW = MUI_AltairW + 1
            set m_AltairW[MUI_AltairW] = this
            set c = NewC
            set td = NewTd
            set ally = IsUnitAlly(td, GetOwningPlayer(c))
            set lvl = IMaxBJ(1, GetUnitAbilityLevel(c, AltairW_ID))
            set r = 0.0
            set rmax = AltairW_MaxDashTime // 1.2
            set trailCount = 0
            call StartSpellUnit2(c)
            call SetUnitAnimation(c, "spell")
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_blackblink.mdx", GetUnitX(c), GetUnitY(c), 0.0, 1.5, 0.8, 0.0))
            if ally then
                call AltairVoice.AltairVoice_Start("war3mapImported\\Hero_Altair_W1", 1.04, 2.28) // «Holopsicon, Third Movement: Representation Exposition» (W1a 1.04 с, W1b 1.24 с)
            else
                call AltairVoice.AltairVoice_Start("war3mapImported\\Hero_Altair_W2", 0.88, 2.23) // «Holopsicon, Ninth Movement: Fate Restoration» (W2a 0.88 с, W2b 1.35 с)
            endif
            if MUI_AltairW == 0 then
                call AltairTick_On(3)
            endif
            return true
        endmethod
    endstruct

    // ==================== E: Outline Origin ====================
    // КАК РАБОТАЕТ E:
    //   AltairE.AltairE_Start  анимация 6, звук, на Altair создаётся сфера e (SpaceLaceration).
    //   AltairE.AltairE_Loop   сфера e держится на Altair; r == AltairE_StringTime (0.3) — ВЫСТРЕЛ:
    //                            DestroyEffect(e);
    //                            всем юнитам в AltairE_Aoe (и союзникам, и врагам) -AltairE_CooldownReduction ко всем КД;
    //                            врагам ещё магический урон;
    //                            сломанный декор в круге и всё, что забрал R, воскрешается (AltairE_RestoreDecor).
    //                          Если Altair умерла до выстрела — сфера убирается, выстрела нет.
    //   AltairE_RestoreDecor идёт отдельным потоком (.execute): урон и КД ауры уже съели лимит операций,
    //   и в том же потоке воскрешение молча обрывалось. AltairE_CollectDeadDecor — callback перебора декора.
    //   Движок не воскрешает декор, пока на его месте стоят юниты: их на миг уносят в угол карты и возвращают.
    private struct AltairE
        private static integer array m_AltairE
        private static integer MUI_AltairE = -1
        unit c
        effect e // сфера на Altair: создаётся в AltairE_Start, DestroyEffect в момент выстрела
        real r // прошло с каста
        real rmax // AltairE_StringTime
        real dmg

        // Callback EnumDestructablesInRect: сломанный декор в круге (служебные B016/B017/B018 не трогаем).
        static method AltairE_CollectDeadDecor takes nothing returns nothing
            local destructable decor = GetEnumDestructable()
            local integer id = GetDestructableTypeId(decor)
            local real dx = GetDestructableX(decor) - AltairEnumX
            local real dy = GetDestructableY(decor) - AltairEnumY
            if AltairEDeadCount < 256 and GetDestructableLife(decor) <= 0.405 and id != 0 and id != AltairR_TrainDecorID and id != 'B016' and id != 'B018' and dx*dx + dy*dy <= AltairEnumRadius*AltairEnumRadius then
                set AltairEDead[AltairEDeadCount] = decor
                set AltairEDeadCount = AltairEDeadCount + 1
            endif
            set decor = null
        endmethod

        // Воскрешение декора в круге AltairEnumX/Y/Radius + всего, что забрал R (кольцо AltairRTaken).
        static method AltairE_RestoreDecor takes nothing returns nothing
            local integer index = 0
            local integer moved
            local integer k
            local destructable decor
            local real x
            local real y
            local real dx
            local real dy
            local integer id
            local unit u
            local real parkX = GetRectMinX(bj_mapInitialPlayableArea) + 64.0 // угол карты, куда на миг уносим юнитов
            local real parkY = GetRectMinY(bj_mapInitialPlayableArea) + 64.0
            // 1) Собрать сломанный декор в круге.
            set AltairEDeadCount = 0
            call SetRect(AltairEnumRect, AltairEnumX - AltairEnumRadius, AltairEnumY - AltairEnumRadius, AltairEnumX + AltairEnumRadius, AltairEnumY + AltairEnumRadius)
            call EnumDestructablesInRect(AltairEnumRect, null, function thistype.AltairE_CollectDeadDecor)
            // 2) Забранное R тоже возвращается (даже если перебор области его не нашёл).
            loop
                exitwhen index >= 128
                set decor = AltairRTaken[index]
                if decor != null and AltairEDeadCount < 256 and GetDestructableLife(decor) <= 0.405 then
                    set id = GetDestructableTypeId(decor)
                    set dx = GetDestructableX(decor) - AltairEnumX
                    set dy = GetDestructableY(decor) - AltairEnumY
                    if id != 0 and dx*dx + dy*dy <= AltairEnumRadius*AltairEnumRadius then
                        set AltairEDead[AltairEDeadCount] = decor
                        set AltairEDeadCount = AltairEDeadCount + 1
                    endif
                endif
                set index = index + 1
            endloop
            // 3) Воскресить каждый (дубликаты из шага 2 к этому моменту уже живы — пропускаются).
            set index = 0
            loop
                exitwhen index >= AltairEDeadCount
                set decor = AltairEDead[index]
                set AltairEDead[index] = null
                if GetDestructableLife(decor) <= 0.405 then
                    set x = GetDestructableX(decor)
                    set y = GetDestructableY(decor)
                    call DestructableRestoreLife(decor, GetDestructableMaxLife(decor), true)
                    if GetDestructableLife(decor) <= 0.405 then
                        // Не воскрес — на месте декора стоят юниты: унести их в угол карты, воскресить, вернуть.
                        set moved = 0
                        call GroupEnumUnitsInRange(AltairGroup, x, y, AltairE_BlockerRadius, null) // AltairE_BlockerRadius = 400
                        loop
                            set u = FirstOfGroup(AltairGroup)
                            exitwhen u == null
                            call GroupRemoveUnit(AltairGroup, u)
                            if moved < 64 and GetUnitAbilityLevel(u, 'Aloc') == 0 and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                                set AltairEMovedUnit[moved] = u
                                set AltairEMovedX[moved] = GetUnitX(u)
                                set AltairEMovedY[moved] = GetUnitY(u)
                                call SetUnitX(u, parkX)
                                call SetUnitY(u, parkY)
                                set moved = moved + 1
                            endif
                        endloop
                        call DestructableRestoreLife(decor, GetDestructableMaxLife(decor), true)
                        set k = 0
                        loop
                            exitwhen k >= moved
                            set u = AltairEMovedUnit[k]
                            set AltairEMovedUnit[k] = null
                            // Кто оказался внутри воскресшего декора — SetUnitPosition вытолкнет на свободное место.
                            if IsTerrainPathable(AltairEMovedX[k], AltairEMovedY[k], PATHING_TYPE_WALKABILITY) then
                                call SetUnitPosition(u, AltairEMovedX[k], AltairEMovedY[k])
                            else
                                call SetUnitX(u, AltairEMovedX[k])
                                call SetUnitY(u, AltairEMovedY[k])
                            endif
                            set k = k + 1
                        endloop
                    endif
                    // Метка восстановления: круг и часы над декором.
                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_yc_bluemorphcircle3.mdl", x, y, 0.0, 1.0, 0.6, 10.0), 0.25, 255, 255, 255, 0.35)
                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_clockwisetimer3.mdl", x, y, 0.0, 1.5, 0.8, 40.0), 0.25, 255, 255, 255, 0.35)
                endif
                set index = index + 1
            endloop
            set decor = null
            set u = null
        endmethod

        static method AltairE_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer k
            local real x
            local real y
            local ability spell
            local unit u
            loop
                exitwhen i > MUI_AltairE
                set this = m_AltairE[i]
                if AltairAlive(c) and r < rmax then
                    set r = RoundReal(r + 0.03, 2)
                    // НАТЯЖЕНИЕ: сфера держится на Altair.
                    call BlzSetSpecialEffectX(e, GetUnitX(c))
                    call BlzSetSpecialEffectY(e, GetUnitY(c))
                    if r == AltairE_StringTime then // AltairE_StringTime = 0.3
                        // ВЫСТРЕЛ: сфера исчезает, все в круге возвращаются к истоку.
                        call DestroyEffect(e)
                        set e = null
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call GroupEnumUnitsInRange(AltairGroup, x, y, AltairE_Aoe, NoDecor_Cond) // AltairE_Aoe = 650
                        loop
                            set u = FirstOfGroup(AltairGroup)
                            exitwhen u == null
                            call GroupRemoveUnit(AltairGroup, u)
                            if u != c and AltairAlive(u) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                                // Все КД юнита (союзник и враг) -AltairE_CooldownReduction: перебор всех его способностей.
                                set k = 0
                                set spell = BlzGetUnitAbilityByIndex(u, 0)
                                loop
                                    exitwhen spell == null
                                    call ReduceCooldown(u, BlzGetAbilityId(spell), AltairE_CooldownReduction) // AltairE_CooldownReduction = 5
                                    set k = k + 1
                                    set spell = BlzGetUnitAbilityByIndex(u, k)
                                endloop
                                call ColorEffDummy3(AddSpecialEffectTarget("war3mapImported\\wos_clockwisetimer3.mdl", u, "overhead"), 0.25, 255, 255, 255, 0.35)
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                    call DamageSource(AltairE_ID)
                                    call dmgmag(c, u, dmg)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                            endif
                        endloop
                        call VisionTimed(GetOwningPlayer(c), x, y, AltairE_Aoe*1.4, 2.0) // AltairE_Aoe = 650
                        // Восстановление декора — отдельным потоком (см. шапку).
                        set AltairEnumX = x
                        set AltairEnumY = y
                        set AltairEnumRadius = AltairE_Aoe // 650
                        call thistype.AltairE_RestoreDecor.execute()
                    endif
                else
                    // КОНЕЦ (после выстрела или если Altair умерла раньше — тогда сфера просто убирается).
                    if e != null then
                        call DestroyEffect(e)
                        set e = null
                    endif
                    set c = null
                    set m_AltairE[i] = m_AltairE[MUI_AltairE]
                    set MUI_AltairE = MUI_AltairE - 1
                    set i = i - 1
                    if MUI_AltairE == -1 then
                        call AltairTick_Off(5)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
            set spell = null
            set u = null
        endmethod

        static method AltairE_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            local integer lvl = IMaxBJ(1, GetUnitAbilityLevel(NewC, AltairE_ID))
            set MUI_AltairE = MUI_AltairE + 1
            set m_AltairE[MUI_AltairE] = this
            set c = NewC
            set r = 0.0
            set rmax = AltairE_StringTime // 0.3
            set dmg = GetHeroInt(c, true)*(AltairE_DamageIntBase + AltairE_DamageIntStep*(lvl - 1)) // Int x (1.5 + 0.4/ур.)
            call SetAnimIndex(c, 0.03, 6)
            set e = EffectSpawn("war3mapImported\\wos_Moon_texiao_SpaceLaceration_01 a.mdl", GetUnitX(c), GetUnitY(c), 0.0, 2.0, AltairE_SphereScale, 0.0) // AltairE_SphereScale = 1.3
            call AltairVoice.AltairVoice_Start("war3mapImported\\Hero_Altair_E1", 0.92, 2.34) // «Holopsicon, Thirteenth Movement: Outline Origin» (E1a 0.92 с, E1b 1.42 с)
            if MUI_AltairE == 0 then
                call AltairTick_On(5)
            endif
        endmethod
    endstruct

    // ==================== R: Factor Mimic ====================
    // СТАДИИ R (каждая — отдельный метод, читать сверху вниз):
    //   R1 ПОГЛОЩЕНИЕ     1-й каст. AltairR.AltairR_Start -> AltairR.Stage1_AbsorbDecor
    //                     Декор в круге AltairR_Aoe ломается (ближний первым) и запоминается как копии.
    //                     Лимит по уровню R: AltairR_MaxCopies 3/4/5/6/7, классы до AltairR_MaxClass 1/2/3/3/4.
    //                     Поезд можно поглотить с AltairR_TrainHeroLevel (35) уровня героя.
    //   R2 ОЖИДАНИЕ       AltairR.AltairR_Loop: копии ждут 2-й каст AltairR_Window (30 с).
    //   R3 ЗАЛП           2-й каст. AltairR.Stage3_FireVolley раскладывает копии по порталу
    //                     (пара «бочка + автомат» — рядом и подряд, ради перегруза) -> AltairRVolley:
    //                       r == AltairR_GateAt   Stage3_OpenPortalCircle — круг портала за спиной;
    //                       с AltairR_FirstShotAt  Stage3_ReleaseCopy каждые AltairR_FireInterval — следующая копия;
    //                       конец залпа            последняя копия выпущена — пауза героя снимается.
    //   R4 В ПОРТАЛЕ      AltairRCopy.Stage4_EmergeInPortal: копия выдвигается из портала и проявляется.
    //   R5 ВЫЛЕТ          AltairRCopy.Stage5_Launch: вспышка; последняя копия закрывает круг портала.
    //   R6 ПОЛЁТ          AltairRCopy.Stage6_Fly (MoveEff2) + Stage6_HitEnemiesOnPath: разгон, вращение, рост;
    //                     каждого врага на пути — урон касанием раз за залп + толчок; тяжёлые тащат.
    //   R7 ВЗРЫВ          AltairRCopy.Stage7_Explode (конец пути или край арены): урон класса копии вокруг, стан,
    //                     родной эффект ломания; бочка — огонь, автомат — молния (вместе = перегруз);
    //                     поезд ещё бьёт чистым уроном поезда RoundEnd в AltairR_TrainBlastAoe.

    // R1: callback EnumDestructablesInRect — разрешённые уровнем кандидаты в круге (максимум 64).
    private function AltairR_CollectDecorInMarker takes nothing returns nothing
        local destructable decor = GetEnumDestructable()
        local real dx = GetDestructableX(decor) - AltairEnumX
        local real dy = GetDestructableY(decor) - AltairEnumY
        local integer id = GetDestructableTypeId(decor)
        local integer index
        if AltairRCandidateCount < 64 and GetDestructableLife(decor) > 0.405 and dx*dx + dy*dy <= AltairEnumRadius*AltairEnumRadius then
            set index = AltairDecorIndex(id)
            if (index >= 0 and AltairDecorClass[index] <= AltairEnumMaxClass) or (id == AltairR_TrainDecorID and AltairEnumTrain) then
                set AltairRCandidate[AltairRCandidateCount] = decor
                set AltairRCandidateDistance[AltairRCandidateCount] = dx*dx + dy*dy
                set AltairRCandidateCount = AltairRCandidateCount + 1
            endif
        endif
        set decor = null
    endfunction

    // R7: родной эффект ломания декора (как decordestroy, без урона/огня). Поезд — как взрыв поезда в RoundEnd.
    private function AltairR_NativeBreak takes integer id, real x, real y returns nothing
        local integer k = 0
        local integer count
        local real height
        local real top
        if id == AltairR_TrainDecorID then
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl", x, y, GetRandomReal(0, 359), 1, 1.33, 1))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdl", x, y, GetRandomReal(0, 359), 1, 2.85, 1))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_yuzhiboyou_unusual_fenshendabaopo_2.mdl", x, y, GetRandomReal(0, 359), 1, 2, 1))
            return
        endif
        if id == 'B01A' or id == 'B019' then // кристаллы Inori
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_FantasyBattle (1644).mdx", x, y, 1, 1, 2, 30))
        endif
        if id == 'B00O' then // взрывная бочка
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_GZ_jntxn (11)_R1-200.mdl", x, y, 1, 1, 0.65, 1))
        endif
        if id == 'B00P' then // обычная бочка
            call DestroyEffect(EffectSpawn("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", x, y, 1, 1, 1, 1))
        endif
        if id == 'B007' or id == 'B009' then // листва
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Razor_leaf-A392F3.mdl", x, y, 1, 1, 2, 95))
        endif
        if id == 'B001' or id == 'B002' or id == 'B00G' or id == 'B00H' or id == 'B00P' or id == 'B000' or id == 'B007' or id == 'B009' or id == 'B00F' or id == 'B00U' or id == 'B00V' or id == 'B00W' or id == 'B00X' then // пыль
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_dustbrown.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1))
        endif
        if id == 'B013' then // мешки золота
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_item_goldcredit.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_item_goldcredit.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1))
        endif
        if id == 'B01B' or id == 'B00N' then
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_item_goldcredit.mdl", x + 180 * Cos(120 * bj_DEGTORAD), y + 180 * Sin(120 * bj_DEGTORAD), 120 + GetRandomReal(0, 359), 1, 6, 25))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_item_goldcredit.mdl", x + 180 * Cos(240 * bj_DEGTORAD), y + 180 * Sin(240 * bj_DEGTORAD), 240 + GetRandomReal(0, 359), 1, 6, 25))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_item_goldcredit.mdl", x + 180 * Cos(360 * bj_DEGTORAD), y + 180 * Sin(360 * bj_DEGTORAD), 360 + GetRandomReal(0, 359), 1, 6, 25))
        endif
        if id == 'B00A' then // понеглиф
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_darkdustgroundeffect.mdl", x, y, GetRandomReal(0, 359), 1, 1, 151))
        endif
        if id == 'B00Q' or id == 'B00R' then // песчаные башни
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_dizhen-qiquan.mdl", x, y, GetRandomReal(0, 359), 1, 1, 125))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_dizhen-qiquan.mdl", x, y, GetRandomReal(0, 359), 1, 1, 415))
            if id == 'B00Q' then
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_dizhen-qiquan.mdl", x, y, GetRandomReal(0, 359), 1, 1, 595))
            endif
        endif
        if id == 'B003' or id == 'B004' or id == 'B00Y' or id == 'B00S' then // металл
            if id == 'B00Y' or id == 'B00S' then
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_hit-juhuang1.mdl", x, y, GetRandomReal(0, 359), 1, 1.25, 45))
            endif
            if id == 'B00S' then
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (431232).mdl", x, y, 1, 1, 0.7, 1))
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, 1, 1, 1.5, 55))
            endif
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_solaire_lightning_impact.mdl", x, y, GetRandomReal(0, 359), 0.4, 2.15, 51))
        endif
        if id == 'B014' then // машина
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (431232).mdl", x, y, 1, 1, 0.7, 1))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, 1, 1, 1.5, 55))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_yuzhiboyou_unusual_fenshendabaopo_2.mdl", x, y, GetRandomReal(0, 359), 1, 2, 1))
        endif
        if id == 'B00T' then // гидрант
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (171).mdl", x, y, GetRandomReal(0, 359), 0.75, 1.25, 1))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_LD2209 (129).mdl", x, y, GetRandomReal(0, 359), 0.4, 0.8, 1))
        endif
        if id == 'B00J' or id == 'B00K' or id == 'B00L' or id == 'B00N' or id == 'B00M' or id == 'B01B' then // большие здания
            set count = 3
            set top = 800
            if id == 'B00K' then
                set count = 4
                set top = 1100
            endif
            if id == 'B00M' then
                set count = 5
                set top = 1600
            endif
            loop
                exitwhen k == count
                set height = GetRandomReal(150, top)
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_hit wave white.mdl", x, y, GetRandomReal(0, 359), 0.65, 2, height))
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_Effect Pieces.mdl", x, y, GetRandomReal(0, 359), 1, 3.25, height - 110))
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_Effect Pieces.mdl", x, y, GetRandomReal(0, 359), 1, 3.25, height - 110))
                set k = k + 1
            endloop
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_shachen1.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1))
        endif
    endfunction

    // ---------- R4-R7: одна КОПИЯ — в портале, вылет, полёт, взрыв ----------
    private struct AltairRCopy
        private static integer array m_AltairRCopy
        private static integer MUI_AltairRCopy = -1
        unit c
        effect e // модель копии
        effect seal // у последней копии залпа: круг портала, закрывается, когда она вылетает
        integer kind // индекс таблицы декора, или AltairR_KindMetro = -1 / AltairR_KindThomas = -2
        integer decorId
        integer decorClass // 1..5
        real baseScale // средний размер объекта
        real r // возраст копии
        real launchAt // когда вылетает: AltairR_LaunchAt +- AltairR_LaunchRandom
        boolean launched
        real fromX // где появилась (в портале)
        real fromY
        real holdX // куда выдвинулась перед вылетом
        real holdY
        real x // текущая позиция
        real y
        real z
        real prevX // позиция на прошлом тике (начало отрезка проверки пути)
        real prevY
        real startZ // высота в портале
        real endZ // высота земли в конце пути (копия плавно снижается к ней)
        real a // направление полёта
        real yaw // поворот модели (Metro смотрит задом)
        real spin // наклон / кувырок
        real spinSpeed
        real twist // деревья: вокруг ствола
        real twistSpeed
        real roll // здания: вокруг длинной оси
        real rollSpeed
        real stepPerTick // полная скорость за тик
        real d // пройдено
        real dmax // дальность (поезд x2)
        real dmg // урон взрыва
        real contactDmg // урон касанием (один раз на врага за залп)
        real decorDamage // урон по декору на пути и при взрыве
        integer smashCount // декор на пути ломается раз в 6 проверок
        integer volleyId // номер залпа (для «один раз на врага»)

        // ---------- R4 В ПОРТАЛЕ: выдвигается вперёд на AltairR_EmergeForward и проявляется (ease-out) ----------
        method Stage4_EmergeInPortal takes nothing returns nothing
            local real progress = RMinBJ(1.0, r/AltairR_EmergeTime) // AltairR_EmergeTime = 0.15
            call BlzSetSpecialEffectAlpha(e, R2I(255.0*progress))
            set progress = 1.0 - (1.0 - progress)*(1.0 - progress) // быстро выходит и мягко тормозит
            set x = fromX + (holdX - fromX)*progress
            set y = fromY + (holdY - fromY)*progress
            call BlzSetSpecialEffectPosition(e, x, y, startZ)
        endmethod

        // ---------- R5 ВЫЛЕТ: вспышка на месте копии; последняя копия залпа закрывает круг портала ----------
        method Stage5_Launch takes nothing returns nothing
            set launched = true
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_blackblink.mdx", x, y, 0.0, 1.5, 0.7, startZ - AltairGroundZ(x, y)))
            if seal != null then
                call BlzSetSpecialEffectTimeScale(seal, AltairR_GateSpeed) // AltairR_GateSpeed = 3
                call DestroyEffect(seal)
                set seal = null
            endif
        endmethod

        // ---------- R6 ПУТЬ: удары по врагам на отрезке «позиция прошлого тика -> текущая» ----------
        // Проверка ЛИНИЕЙ (капсула шириной width), чтобы быстрая копия не «перепрыгивала» врагов между тиками.
        // Каждого врага один раз за залп (AltairTable[враг][8] = volleyId): Int x ContactInt и толчок MUE вперёд;
        // тяжёлые (классы 3-5, в т.ч. поезд) ещё тащат за собой (MoveUnit). Декор на пути ломается каждую 6-ю проверку.
        // Вызывается .execute — свой поток на каждую копию (лимит операций).
        method Stage6_HitEnemiesOnPath takes nothing returns nothing
            local real width = RMaxBJ(AltairR_MinHitArea, AltairR_ClassWidth[decorClass]) // AltairR_MinHitArea = 400, AltairR_ClassWidth[1..5] = 120/170/240/320/360
            local real segX = x - prevX
            local real segY = y - prevY
            local real segLen2 = segX*segX + segY*segY
            local real t
            local real dx
            local real dy
            local real push
            local unit u
            if decorId == 'B00I' then
                set width = RMaxBJ(width, AltairR_ArenaWidth) // AltairR_ArenaWidth = 550
            endif
            if smashCount == 0 then
                call DecorRemove(c, x, y, width, decorDamage)
            endif
            set smashCount = smashCount + 1
            if smashCount >= 6 then
                set smashCount = 0
            endif
            call GroupEnumUnitsInRange(AltairGroup, (prevX + x)*0.5, (prevY + y)*0.5, width + SquareRoot(segLen2)*0.5 + 64.0, NoDecor_Cond)
            loop
                set u = FirstOfGroup(AltairGroup)
                exitwhen u == null
                call GroupRemoveUnit(AltairGroup, u)
                // Ближайшая к цели точка отрезка prev -> текущая позиция (t = 0..1 вдоль отрезка).
                set t = 0.0
                if segLen2 > 1.0 then
                    set t = RMaxBJ(0.0, RMinBJ(1.0, ((GetUnitX(u) - prevX)*segX + (GetUnitY(u) - prevY)*segY)/segLen2))
                endif
                set dx = GetUnitX(u) - (prevX + segX*t)
                set dy = GetUnitY(u) - (prevY + segY*t)
                if dx*dx + dy*dy <= width*width and SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                    if LoadInteger(AltairTable, GetHandleId(u), 8) != volleyId then
                        // Первое касание этим залпом: урон касанием и толчок.
                        call SaveInteger(AltairTable, GetHandleId(u), 8, volleyId)
                        call DamageSource(AltairR_ID)
                        call dmgphys(c, u, contactDmg)
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_Opdef (571)2.mdl", u, "chest"))
                        // Толчок не дальше точки взрыва (остаток пути копии).
                        set push = RMinBJ(AltairR_HitPush, dmax - d) // AltairR_HitPush = 280
                        if push >= 10.0 then
                            call MUE(u, push, AltairR_HitPushTime*push/AltairR_HitPush, a) // AltairR_HitPushTime = 0.3, AltairR_HitPush = 280
                        endif
                    endif
                    if decorClass >= 3 and dmax - d > AltairR_DragStep then // AltairR_DragStep = 14
                        call MoveUnit(u, AltairR_DragStep, a) // тяжёлая копия тащит врага
                    endif
                endif
            endloop
            set u = null
        endmethod

        // ---------- R6 ПОЛЁТ: MoveEff2 + рост, снижение к земле, вращение ----------
        // true = долетела до конца пути или следующая точка за краем арены (тогда взрыв на месте).
        method Stage6_Fly takes real growTo returns boolean
            local real step = stepPerTick*RMinBJ(1.0, (r - launchAt + 0.03)/AltairR_AccelTime) // разгон за AltairR_AccelTime = 0.15
            local real progress
            if not PathableCheck(x + step*Cos(a), y + step*Sin(a)) then
                return true // край арены
            endif
            set d = d + step
            set prevX = x
            set prevY = y
            call MoveEff2(e, step, a)
            set x = GetEffX(e)
            set y = GetEffY(e)
            // Рост при вылете: AltairR_LaunchScale -> growTo за AltairR_GrowTime.
            if r - launchAt < AltairR_GrowTime + 0.03 then // AltairR_GrowTime = 0.3
                set progress = RMinBJ(1.0, (r - launchAt + 0.03)/AltairR_GrowTime)
                call BlzSetSpecialEffectScale(e, baseScale*(AltairR_LaunchScale + (growTo - AltairR_LaunchScale)*progress)) // AltairR_LaunchScale = 0.7
            endif
            // Высота: от портала к земле в конце пути.
            set progress = RMinBJ(1.0, d/dmax)
            set z = startZ + (endZ - startZ)*progress
            call BlzSetSpecialEffectZ(e, z)
            set spin = spin + spinSpeed*0.03
            set twist = twist + twistSpeed*0.03
            set roll = roll + rollSpeed*0.03
            call BlzSetSpecialEffectOrientation(e, yaw + twist, spin, roll)
            call this.Stage6_HitEnemiesOnPath.execute()
            return progress >= 1.0
        endmethod

        // ---------- R7 ВЗРЫВ в конце пути ----------
        // Урон копии (база класса + Int) всем врагам в радиусе её класса, стан, родной эффект ломания.
        // Бочка B00O накладывает огонь (элемент 1), автомат B00S — молнию (элемент 3): если оба задели
        // одного врага, система элементов (AAADest, ErzaPassive) делает перегруз.
        // Поезд: ещё чистый урон поезда RoundEnd (475 + 125 за раунд после первого) в AltairR_TrainBlastAoe.
        // Вызывается .execute — свой поток (лимит операций).
        method Stage7_Explode takes nothing returns nothing
            local real aoe = RMaxBJ(AltairR_MinHitArea, AltairR_ClassAoe[decorClass]) // AltairR_MinHitArea = 400, AltairR_ClassAoe[1..5] = 200/260/320/400/500
            local real hitDamage = dmg
            local real trainDamage = TRAIN_EXPLOSION_BASE_DAMAGE + IMaxBJ(0, GetEnvironmentRoundNumber() - 1)*TRAIN_DAMAGE_PER_ROUND // 475 + 125 x (раунд - 1), как RoundEnd
            local unit u
            if decorId == 'B00I' then // арена: огромный взрыв
                set aoe = RMaxBJ(aoe, AltairR_ArenaAoe) // AltairR_ArenaAoe = 900
            endif
            if decorId == AltairR_FireBarrelID then // взрывная бочка бьёт сильнее и шире
                set aoe = aoe + 80.0
                set hitDamage = hitDamage*1.5
            endif
            // Визуал: родной эффект ломания + грязь + кольцо YC_BRS (размер по классу) + пыль.
            call AltairR_NativeBreak(decorId, x, y)
            if decorClass >= 3 then
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_newdirtexnofire.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, AltairR_DirtBig, 1.0)) // AltairR_DirtBig = 1.5
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_BRS.mdl", x, y, 0.0, 1.0, AltairR_TakenRingBig, 0.0)) // AltairR_TakenRingBig = 1.4
            else
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_newdirtexnofire.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, AltairR_DirtSmall, 1.0)) // AltairR_DirtSmall = 0.3
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_BRS.mdl", x, y, 0.0, 1.0, AltairR_TakenRingSmall, 0.0)) // AltairR_TakenRingSmall = 0.42
            endif
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_dustbrown.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 0.6 + 0.2*decorClass, 1.0))
            // Урон взрыва, стан и элементы.
            call GroupEnumUnitsInRange(AltairGroup, x, y, aoe, NoDecor_Cond)
            loop
                set u = FirstOfGroup(AltairGroup)
                exitwhen u == null
                call GroupRemoveUnit(AltairGroup, u)
                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                    call DamageSource(AltairR_ID)
                    call dmgphys(c, u, hitDamage)
                    call StunUnit(c, u, AltairR_ClassStun[decorClass]) // AltairR_ClassStun[1..5] = 0.3/0.4/0.5/0.7/1.0
                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                    if decorId == AltairR_FireBarrelID then
                        call DamageSource(AltairR_ID)
                        call ErzaPassive(c, u, 1) // огонь
                    elseif decorId == AltairR_VendingID then
                        call DamageSource(AltairR_ID)
                        call ErzaPassive(c, u, 3) // молния
                    endif
                endif
            endloop
            // Поезд: дополнительный чистый урон, как если бы взорвали сам поезд.
            if decorClass == 5 then
                call GroupEnumUnitsInRange(AltairGroup, x, y, AltairR_TrainBlastAoe, NoDecor_Cond) // AltairR_TrainBlastAoe = 650
                loop
                    set u = FirstOfGroup(AltairGroup)
                    exitwhen u == null
                    call GroupRemoveUnit(AltairGroup, u)
                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                        call DamageSource(AltairR_ID)
                        call spelldmg(c, u, trainDamage)
                    endif
                endloop
            endif
            call DecorRemove(c, x, y, aoe, decorDamage)
            call VisionTimed(GetOwningPlayer(c), x, y, aoe*1.6, 2.0)
            set u = null
        endmethod

        static method AltairRCopy_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real growTo
            local boolean finished
            loop
                exitwhen i > MUI_AltairRCopy
                set this = m_AltairRCopy[i]
                set r = RoundReal(r + 0.03, 2)
                set finished = false
                if not launched then
                    call Stage4_EmergeInPortal()
                    if r + 0.03 >= launchAt then
                        call Stage5_Launch() // со следующего тика копия летит
                    endif
                else
                    set growTo = AltairR_FlightScale // 1.1
                    if decorClass >= 3 then
                        set growTo = AltairR_HeavyFlightScale // 0.95: здания и поезд почти в натуральную величину
                    endif
                    if Stage6_Fly(growTo) then
                        call this.Stage7_Explode.execute()
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.51) // модель проигрывает свою смерть и гаснет
                        set finished = true
                    endif
                endif
                if finished then
                    // КОНЕЦ копии.
                    if seal != null then
                        call DestroyEffect(seal)
                        set seal = null
                    endif
                    set e = null
                    set c = null
                    set m_AltairRCopy[i] = m_AltairRCopy[MUI_AltairRCopy]
                    set MUI_AltairRCopy = MUI_AltairRCopy - 1
                    set i = i - 1
                    if MUI_AltairRCopy == -1 then
                        call AltairTick_Off(7)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
        endmethod

        // Копия появляется невидимой за спиной Altair (в портале) и потом летит прямо по направлению каста.
        // NewSide — полоса поперёк портала, NewHeight — высота над землёй, NewRange — дальность (< 0 = случайная);
        // всё это раскладывает Stage3_FireVolley.
        static method AltairRCopy_Start takes unit NewC, integer NewKind, real NewAngle, real NewSide, real NewHeight, real NewRange, effect NewSeal returns nothing
            local thistype this = thistype.create()
            local real back = AltairR_SpawnBack + GetRandomReal(-AltairR_SpawnBackRandom, AltairR_SpawnBackRandom) // 150 +- 60
            local string model
            set MUI_AltairRCopy = MUI_AltairRCopy + 1
            set m_AltairRCopy[MUI_AltairRCopy] = this
            set c = NewC
            set kind = NewKind
            set seal = NewSeal
            // Что за объект: поезд (Metro / Thomas) или декор из таблицы.
            if kind == AltairR_KindMetro then
                set decorId = AltairR_TrainDecorID // 'B017'
                set decorClass = 5
                set baseScale = 1.0
                set model = "land_wos\\Train Metro.mdl"
            elseif kind == AltairR_KindThomas then
                set decorId = AltairR_TrainDecorID // 'B017'
                set decorClass = 5
                set baseScale = 3.15
                set model = "war3mapImported\\wos_Model Thomas.mdl"
            else
                set decorId = AltairDecorId[kind]
                set decorClass = AltairDecorClass[kind]
                set baseScale = AltairDecorScale[kind]
                set model = AltairDecorModel[kind]
            endif
            // Время и место в портале.
            set r = 0.0
            set launched = false
            set launchAt = AltairR_LaunchAt + GetRandomReal(-AltairR_LaunchRandom, AltairR_LaunchRandom) // 0.3 +- 0.06: взрывы разных копий не в один тик
            set fromX = GetUnitX(c) - back*Cos(NewAngle) + NewSide*Cos(NewAngle + bj_PI/2.0)
            set fromY = GetUnitY(c) - back*Sin(NewAngle) + NewSide*Sin(NewAngle + bj_PI/2.0)
            set holdX = fromX + AltairR_EmergeForward*Cos(NewAngle) // AltairR_EmergeForward = 50
            set holdY = fromY + AltairR_EmergeForward*Sin(NewAngle)
            set x = fromX
            set y = fromY
            set prevX = fromX
            set prevY = fromY
            set startZ = AltairGroundZ(fromX, fromY) + NewHeight
            if decorClass >= 3 then
                set startZ = startZ + GetRandomReal(AltairR_HeavyLiftMin, AltairR_HeavyLiftMax) // 150..200: здания и поезд выше
            endif
            set z = startZ
            // Полёт.
            set a = NewAngle + GetRandomReal(-AltairR_AngleRandom, AltairR_AngleRandom)*bj_DEGTORAD // AltairR_AngleRandom = 0
            if NewRange > 0.0 then
                set dmax = NewRange
            else
                set dmax = RMaxBJ(1.0, AltairR_FlightRange + GetRandomReal(-AltairR_FlightRangeRandom, AltairR_FlightRangeRandom)) // 1600 +- 150
            endif
            if decorClass == 5 then
                set dmax = dmax*AltairR_TrainRangeMult // поезд летит x2
            endif
            set stepPerTick = (AltairR_ThrowSpeed + GetRandomReal(-AltairR_ThrowSpeedRandom, AltairR_ThrowSpeedRandom))*0.03 // 2600 +- 200
            set d = 0.0
            set endZ = AltairGroundZ(holdX + dmax*Cos(a), holdY + dmax*Sin(a))
            // Урон.
            set dmg = AltairR_ClassDamage[decorClass] + AltairR_DamageInt*GetHeroInt(c, true) // AltairR_ClassDamage[1..5] = 100/200/200/400/600, AltairR_DamageInt = 1
            set volleyId = AltairR_VolleySerial
            set contactDmg = GetHeroInt(c, true)*AltairR_ContactInt[IMinBJ(5, IMaxBJ(1, GetUnitAbilityLevel(c, AltairR_ID)))] // AltairR_ContactInt[1..5] = 2.5/3/3.5/4/4.5
            set smashCount = GetRandomInt(0, 5) // копии ломают декор в разные тики
            set decorDamage = AltairR_DecorSmall // 20
            if decorClass >= 3 then
                set decorDamage = AltairR_DecorHeavy // 100
            endif
            // Поворот модели и вращение: деревья вокруг ствола, мелкие кувыркаются, средние медленнее,
            // поезд летит ровно с наклоном носом вниз, здания — лёжа, крутясь вокруг длинной оси.
            set yaw = a
            if kind == AltairR_KindMetro then
                set yaw = yaw + bj_PI // модель Metro смотрит назад
            endif
            set spin = 0.0
            set spinSpeed = 0.0
            set twist = 0.0
            set twistSpeed = 0.0
            set roll = 0.0
            set rollSpeed = 0.0
            if decorId == 'B000' or decorId == 'B007' or decorId == 'B009' or decorId == 'B00F' then
                set spin = AltairR_TreeTilt // 0.35
                set twistSpeed = AltairR_TreeSpin*(GetRandomInt(0, 1)*2 - 1) // 9, в случайную сторону
            elseif decorClass == 1 then
                set spinSpeed = AltairR_SmallSpin // 7
            elseif decorClass == 2 then
                set spinSpeed = AltairR_MediumSpin // 4
            endif
            if decorClass == 5 then
                set spin = AltairR_HeavyTilt // 0.12
                if kind == AltairR_KindMetro then
                    set spin = -AltairR_HeavyTilt
                endif
            elseif decorClass >= 3 then
                set spin = AltairR_HeavyLay // 1.5708
                set rollSpeed = AltairR_HeavySpin*(GetRandomInt(0, 1)*2 - 1) // 2.5
            endif
            // Модель: маленькая и прозрачная, проявится в Stage4.
            set e = EffectSpawn(model, fromX, fromY, yaw*bj_RADTODEG, 1.0, baseScale*AltairR_LaunchScale, 0.0) // AltairR_LaunchScale = 0.7
            call BlzSetSpecialEffectOrientation(e, yaw, spin, 0.0)
            call BlzSetSpecialEffectZ(e, startZ)
            call BlzSetSpecialEffectAlpha(e, 0)
            if MUI_AltairRCopy == 0 then
                call AltairTick_On(7)
            endif
        endmethod
    endstruct

    // ---------- R3: ЗАЛП — держит героя на паузе, открывает круг портала, выпускает копии по одной ----------
    private struct AltairRVolley
        private static integer array m_AltairRVolley
        private static integer MUI_AltairRVolley = -1
        unit c
        effect seal // круг портала (YC_BlackHole), закрывает последняя копия
        integer array kind[15] // копии по порядку выпуска
        real array side[15] // полоса поперёк портала для копии N
        real array height[15] // высота копии N
        real array range[15] // дальность копии N (< 0 = случайная)
        integer total
        integer fired // сколько уже выпущено
        real r // время залпа
        real shotTimer // до следующей копии
        real a // направление залпа
        real gateX // центр портала за спиной
        real gateY

        // R3: круг портала раскрывается своей Birth, ускоренно.
        method Stage3_OpenPortalCircle takes nothing returns nothing
            set seal = EffectSpawn("war3mapImported\\wos_YC_BlackHole.mdx", gateX, gateY, a*bj_RADTODEG, AltairR_GateSpeed, AltairR_SealScale, AltairR_PortalHeight + AltairR_SealZOffset - 265.0) // AltairR_GateSpeed = 3, AltairR_SealScale = 2.94, AltairR_PortalHeight = 400, AltairR_SealZOffset = -200
            call BlzPlaySpecialEffect(seal, ANIM_TYPE_BIRTH)
        endmethod

        // R3: следующая копия выходит в портал. Последняя забирает круг портала и закроет его на вылете.
        method Stage3_ReleaseCopy takes nothing returns nothing
            local effect closeSeal = null
            if fired == total - 1 then
                set closeSeal = seal
                set seal = null
            endif
            call AltairRCopy.AltairRCopy_Start(c, kind[fired], a, side[fired], height[fired], range[fired], closeSeal)
            set fired = fired + 1
            set closeSeal = null
        endmethod

        static method AltairRVolley_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_AltairRVolley
                set this = m_AltairRVolley[i]
                if AltairAlive(c) and fired < total then
                    set r = RoundReal(r + 0.03, 2)
                    call DebugUnit2(c) // пауза могла слететь (развеивание и т.п.) — накладываем снова
                    if r == AltairR_GateAt then // AltairR_GateAt = 0.24
                        call Stage3_OpenPortalCircle()
                    endif
                    if r >= AltairR_FirstShotAt then // AltairR_FirstShotAt = 0.3
                        set shotTimer = shotTimer - 0.03
                        if shotTimer <= 0.001 then
                            set shotTimer = AltairR_FireInterval // 0.06
                            call Stage3_ReleaseCopy()
                        endif
                    endif
                else
                    // КОНЕЦ ЗАЛПА: все копии выпущены (или герой умер) — пауза снимается.
                    if seal != null then
                        call BlzSetSpecialEffectTimeScale(seal, AltairR_GateSpeed) // 3
                        call DestroyEffect(seal)
                        set seal = null
                    endif
                    call GearStopSpellPause(c, false)
                    set c = null
                    set m_AltairRVolley[i] = m_AltairRVolley[MUI_AltairRVolley]
                    set MUI_AltairRVolley = MUI_AltairRVolley - 1
                    set i = i - 1
                    if MUI_AltairRVolley == -1 then
                        call AltairTick_Off(6)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
        endmethod

        // Вспышка-линия на месте портала; герой разворачивается к цели и встаёт на паузу.
        // Копии (kind/side/height/range/total) заполняет Stage3_FireVolley сразу после вызова.
        static method AltairRVolley_Start takes unit NewC, real NewAngle returns thistype
            local thistype this = thistype.create()
            set MUI_AltairRVolley = MUI_AltairRVolley + 1
            set m_AltairRVolley[MUI_AltairRVolley] = this
            set c = NewC
            set a = NewAngle
            set total = 0
            set fired = 0
            set r = 0.0
            set shotTimer = 0.0
            set seal = null
            set gateX = GetUnitX(c) - AltairR_PortalBack*Cos(a) // AltairR_PortalBack = 240
            set gateY = GetUnitY(c) - AltairR_PortalBack*Sin(a)
            // У вспышки есть только Death: DestroyEffect сразу проигрывает её один раз.
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Moon_texiao_shumazhan_01.mdx", gateX, gateY, a*bj_RADTODEG, 1.25, AltairR_SplashScale, AltairR_PortalHeight + AltairR_SplashZOffset)) // AltairR_SplashScale = 1, AltairR_PortalHeight = 400, AltairR_SplashZOffset = 75
            call SetUnitFacing(c, a*bj_RADTODEG)
            call SetAnimIndex(c, 0.03, AltairR_VolleyAnim) // AltairR_VolleyAnim = 11
            call GearPauseSpellStart(c, false)
            if MUI_AltairRVolley == 0 then
                call AltairTick_On(6)
            endif
            return this
        endmethod
    endstruct

    // ---------- R1-R3: ЗАПАС КОПИЙ героя между 1-м и 2-м кастом (AltairTable[hero][2]) ----------
    private struct AltairR
        private static integer array m_AltairR
        private static integer MUI_AltairR = -1
        unit c
        integer stored // сколько копий в запасе
        integer array kind[15] // какие (индекс таблицы декора или поезд < 0)
        real r // сколько ещё ждёт 2-й каст

        // ---------- R1 ПОГЛОЩЕНИЕ (1-й каст) ----------
        // Ломает разрешённый уровнем декор в круге — ближний первым — и запоминает копии. false = копировать нечего.
        static method Stage1_AbsorbDecor takes unit NewC, real NewX, real NewY returns boolean
            local thistype this
            local integer lvl = IMinBJ(5, IMaxBJ(1, GetUnitAbilityLevel(NewC, AltairR_ID)))
            local integer maxCopies = IMinBJ(15, AltairR_MaxCopies[lvl]) // по уровню R: 3/4/5/6/7
            local integer best
            local integer slot
            local integer id
            local integer decorClass
            local boolean trainTaken = false
            local destructable decor
            local real decorX
            local real decorY
            local unit train
            local real trainBest
            local real dx
            local real dy
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Bronya_1.mdl", NewX, NewY, 0.0, 2.5, AltairR_Aoe/620.0, 5.0)) // AltairR_Aoe = 600
            // 1) Собрать кандидатов в круге (callback AltairR_CollectDecorInMarker).
            set AltairEnumX = NewX
            set AltairEnumY = NewY
            set AltairEnumRadius = AltairR_Aoe // 600
            set AltairEnumMaxClass = AltairR_MaxClass[lvl] // по уровню R: 1/2/3/3/4
            set AltairEnumTrain = GetHeroLevel(NewC) >= AltairR_TrainHeroLevel // поезд — с 35 уровня героя
            set AltairRCandidateCount = 0
            call SetRect(AltairEnumRect, NewX - AltairR_Aoe, NewY - AltairR_Aoe, NewX + AltairR_Aoe, NewY + AltairR_Aoe) // AltairR_Aoe = 600
            call EnumDestructablesInRect(AltairEnumRect, null, function AltairR_CollectDecorInMarker)
            if AltairRCandidateCount == 0 then
                return false
            endif
            set this = thistype.create()
            set MUI_AltairR = MUI_AltairR + 1
            set m_AltairR[MUI_AltairR] = this
            set c = NewC
            set stored = 0
            set r = AltairR_Window // 30
            call SetAnimIndex(c, 0.03, AltairR_AbsorbAnim) // AltairR_AbsorbAnim = 6
            // 2) Забирать ближайших, пока есть место. Поезд — не больше одного.
            loop
                exitwhen stored >= maxCopies or AltairRCandidateCount == 0
                set best = 0
                set slot = 1
                loop
                    exitwhen slot >= AltairRCandidateCount
                    if AltairRCandidateDistance[slot] < AltairRCandidateDistance[best] then
                        set best = slot
                    endif
                    set slot = slot + 1
                endloop
                set decor = AltairRCandidate[best]
                set id = GetDestructableTypeId(decor)
                if id != AltairR_TrainDecorID or not trainTaken then
                    set decorX = GetDestructableX(decor)
                    set decorY = GetDestructableY(decor)
                    if id == AltairR_TrainDecorID then
                        // Поезд: скин ближайшего поезда (Metro / Thomas). У поездов Locust — ищем по игроку, не по радиусу.
                        set trainTaken = true
                        set kind[stored] = AltairR_KindMetro
                        set decorClass = 5
                        set trainBest = AltairR_TrainSearch*AltairR_TrainSearch // AltairR_TrainSearch = 900
                        call GroupEnumUnitsOfPlayer(AltairGroup, Player(PLAYER_NEUTRAL_PASSIVE), null)
                        loop
                            set train = FirstOfGroup(AltairGroup)
                            exitwhen train == null
                            call GroupRemoveUnit(AltairGroup, train)
                            if GetUnitTypeId(train) == AltairR_TrainMetroID or GetUnitTypeId(train) == AltairR_TrainThomasID then // 'h00G' / 'h02N'
                                set dx = GetUnitX(train) - decorX
                                set dy = GetUnitY(train) - decorY
                                if dx*dx + dy*dy <= trainBest then
                                    set trainBest = dx*dx + dy*dy
                                    if GetUnitTypeId(train) == AltairR_TrainThomasID then
                                        set kind[stored] = AltairR_KindThomas
                                    else
                                        set kind[stored] = AltairR_KindMetro
                                    endif
                                endif
                            endif
                        endloop
                    else
                        set kind[stored] = AltairDecorIndex(id)
                        set decorClass = AltairDecorClass[kind[stored]]
                    endif
                    // Кольцо на месте забранного декора, оригинал ломается (вернёт сброс раунда или E).
                    if decorClass >= 3 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_BRS.mdl", decorX, decorY, 0.0, 1.0, AltairR_TakenRingBig, 0.0)) // AltairR_TakenRingBig = 1.4
                    else
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_BRS.mdl", decorX, decorY, 0.0, 1.0, AltairR_TakenRingSmall, 0.0)) // AltairR_TakenRingSmall = 0.42
                    endif
                    call KillDestructable(decor)
                    if id != AltairR_TrainDecorID then
                        set AltairRTaken[AltairRTakenNext] = decor // E сможет вернуть
                        set AltairRTakenNext = ModuloInteger(AltairRTakenNext + 1, 128)
                    endif
                    set stored = stored + 1
                endif
                // Убрать кандидата из списка (последний — на его место).
                set AltairRCandidateCount = AltairRCandidateCount - 1
                set AltairRCandidate[best] = AltairRCandidate[AltairRCandidateCount]
                set AltairRCandidateDistance[best] = AltairRCandidateDistance[AltairRCandidateCount]
                set AltairRCandidate[AltairRCandidateCount] = null
            endloop
            loop
                exitwhen AltairRCandidateCount == 0
                set AltairRCandidateCount = AltairRCandidateCount - 1
                set AltairRCandidate[AltairRCandidateCount] = null
            endloop
            set decor = null
            set train = null
            call SaveInteger(AltairTable, GetHandleId(c), 2, this)
            call AltairVoice.AltairVoice_Start("war3mapImported\\Hero_Altair_R1", 0.81, 2.42) // «Holopsicon, Twentieth Movement: Factor Mimic» (R1a 0.81 с, R1b 1.61 с)
            if MUI_AltairR == 0 then
                call AltairTick_On(8)
            endif
            return true
        endmethod

        // ---------- R3 ЗАЛП (2-й каст): разложить копии по порталу и передать их в AltairRVolley ----------
        method Stage3_FireVolley takes real NewX, real NewY returns nothing
            local integer slot = 0
            local real a = GAngle2(c, NewX, NewY)
            local AltairRVolley volley = AltairRVolley.AltairRVolley_Start(c, a)
            local real volleyTime = AltairR_FirstShotAt + (stored - 1)*AltairR_FireInterval + AltairR_LaunchAt // 0.3 + (N-1) x 0.06 + 0.3
            // Полосы поперёк: шаг AltairR_LaneStep вокруг линии прицела, но не шире портала.
            local real spread = RMinBJ(AltairR_PortalSideMax - AltairR_PortalSideMin, (stored - 1)*AltairR_LaneStep) // ширина портала 800, шаг 200
            local real laneCenter = RMaxBJ(AltairR_PortalSideMin + spread*0.5, RMinBJ(AltairR_PortalSideMax - spread*0.5, 0.0))
            local real laneWidth = 0.0
            local real bandHeight = (AltairR_PortalMaxHeight - AltairR_PortalMinHeight)/stored // (560 - 240) / N
            local integer other
            local integer fireSlot = -1
            local integer boltSlot = -1
            local integer swapKind
            local real swap
            // 1) ПАРА «ПЕРЕГРУЗ»: красная бочка (огонь) и автомат (молния) — подряд, автомат сразу за бочкой.
            loop
                exitwhen slot >= stored
                if kind[slot] >= 0 then
                    if fireSlot < 0 and AltairDecorId[kind[slot]] == AltairR_FireBarrelID then
                        set fireSlot = slot
                    elseif boltSlot < 0 and AltairDecorId[kind[slot]] == AltairR_VendingID then
                        set boltSlot = slot
                    endif
                endif
                set slot = slot + 1
            endloop
            if fireSlot >= 0 and boltSlot >= 0 then
                if fireSlot == stored - 1 then
                    // Бочка последняя: поменять бочку и автомат местами, чтобы за бочкой было место.
                    set swapKind = kind[fireSlot]
                    set kind[fireSlot] = kind[boltSlot]
                    set kind[boltSlot] = swapKind
                    set other = fireSlot
                    set fireSlot = boltSlot
                    set boltSlot = other
                endif
                if boltSlot != fireSlot + 1 then
                    // Поставить автомат сразу за бочкой (тот, кто там стоял, встаёт на место автомата).
                    set swapKind = kind[fireSlot + 1]
                    set kind[fireSlot + 1] = kind[boltSlot]
                    set kind[boltSlot] = swapKind
                    set boltSlot = fireSlot + 1
                endif
            else
                set fireSlot = -1 // пары нет
            endif
            // 2) Полосы и высоты: N полос по ширине и N по высоте, с небольшим разбросом.
            if stored > 1 then
                set laneWidth = spread/(stored - 1)
            endif
            set slot = 0
            loop
                exitwhen slot >= stored
                set volley.kind[slot] = kind[slot]
                set volley.side[slot] = laneCenter + (slot - (stored - 1)*0.5 + GetRandomReal(-0.2, 0.2))*laneWidth
                set volley.height[slot] = AltairR_PortalMinHeight + (slot + 0.5 + GetRandomReal(-0.3, 0.3))*bandHeight // 240 + ...
                set volley.range[slot] = -1.0 // случайная дальность
                set slot = slot + 1
            endloop
            // 3) Перемешать полосы и высоты, чтобы соседние по времени копии не шли подряд.
            set slot = stored - 1
            loop
                exitwhen slot <= 0
                set other = GetRandomInt(0, slot)
                set swap = volley.side[slot]
                set volley.side[slot] = volley.side[other]
                set volley.side[other] = swap
                set other = GetRandomInt(0, slot)
                set swap = volley.height[slot]
                set volley.height[slot] = volley.height[other]
                set volley.height[other] = swap
                set slot = slot - 1
            endloop
            // 4) Пара «перегруз» летит рядом (AltairR_PairOffset), на одной высоте и на одну дальность —
            //    взрывы почти в одной точке, огонь и молния ложатся на одних и тех же врагов.
            if fireSlot >= 0 then
                set volley.side[boltSlot] = RMaxBJ(AltairR_PortalSideMin, RMinBJ(AltairR_PortalSideMax, volley.side[fireSlot] + AltairR_PairOffset)) // AltairR_PairOffset = 60
                set volley.height[boltSlot] = volley.height[fireSlot]
                set volley.range[fireSlot] = AltairR_FlightRange // 1600
                set volley.range[boltSlot] = AltairR_FlightRange
            endif
            set volley.total = stored
            set AltairR_VolleySerial = AltairR_VolleySerial + 1 // новый залп: каждого врага снова можно задеть один раз
            call MakeSound("war3mapImported\\Hero_Altair_R" + I2S(GetRandomInt(2, 3))) // R2 «Это оружие — твои же копии», R3 «Раз есть врата, есть и выход»
            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + AltairR_FlightRange*0.5*Cos(a), GetUnitY(c) + AltairR_FlightRange*0.5*Sin(a), AltairR_FlightRange*0.6 + 300.0, 2.0 + volleyTime) // AltairR_FlightRange = 1600
            call BlzStartUnitAbilityCooldown(c, AltairR_ID, AltairR_Cooldown) // AltairR_Cooldown = 16
            // Запас пустеет: AltairR_Loop закроет его на следующем тике.
            set stored = 0
            call RemoveSavedInteger(AltairTable, GetHandleId(c), 2)
        endmethod

        // ---------- R2 ОЖИДАНИЕ: окно 2-го каста ----------
        // Истекло / копий нет / герой умер -> запас закрывается (с КД, если копии так и не выпустили).
        static method AltairR_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_AltairR
                set this = m_AltairR[i]
                set r = r - 0.03
                if stored == 0 or r <= 0.0 or not AltairAlive(c) then
                    if stored > 0 then
                        call BlzStartUnitAbilityCooldown(c, AltairR_ID, AltairR_Cooldown) // AltairR_Cooldown = 16
                    endif
                    set stored = 0
                    if LoadInteger(AltairTable, GetHandleId(c), 2) == this then
                        call RemoveSavedInteger(AltairTable, GetHandleId(c), 2)
                    endif
                    set c = null
                    set m_AltairR[i] = m_AltairR[MUI_AltairR]
                    set MUI_AltairR = MUI_AltairR - 1
                    set i = i - 1
                    if MUI_AltairR == -1 then
                        call AltairTick_Off(8)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
        endmethod

        // Вход каста: есть копии в запасе -> R3 залп, иначе -> R1 поглощение. false = копировать нечего.
        static method AltairR_Start takes unit NewC, real NewX, real NewY returns boolean
            local thistype this = LoadInteger(AltairTable, GetHandleId(NewC), 2)
            if this != 0 and stored > 0 then
                call Stage3_FireVolley(NewX, NewY)
                return true
            endif
            return Stage1_AbsorbDecor(NewC, NewX, NewY)
        endmethod
    endstruct

    // ==================== T: Fate Reconstruction ====================
    // КАК РАБОТАЕТ T:
    //   Реалм     AltairT_BuildRealm (из Init): правый нижний угол арены AltairT_RealmMin/Max, по краю — деревья
    //             и непроходимые блокеры YTfb (их не ломает DecorRemove), внутри — случайный декор. Выйти пешком нельзя.
    //             При активной тюрьме Kenjaku реалмом служит gg_rct_Cage.
    //   1-й каст  AltairT.AltairT_Start: портал в точке, зеркальные врата в реалме. Ближайшие юниты (союзники, враги
    //             и сама Altair; до AltairT_MaxMembers) втягиваются MoveUnit и через AltairT_PullTime оказываются в реалме.
    //   2-й каст  AltairT.AltairT_Start: один раз переносит портал; дальше кнопка T на КД до конца реалма.
    //   Тик       AltairT.AltairT_Loop: участники не выходят за рамки реалма; кто дошёл до открытого портала
    //             (включая Altair) — входит, пока есть места; декор у портала ломается раз в 1 с.
    //   Конец     AltairT_Close (время вышло / смерть Altair / G): всех вернуть к порталу, КД AltairT_Cooldown.
    //   Пока реалм открыт, G только закрывает его (форма не меняется) — см. функцию AltairG_Start.

    // Строит реалм один раз при загрузке карты: граница-деревья + блокеры, случайный декор внутри.
    private function AltairT_BuildRealm takes nothing returns nothing
        local real position = 0.0
        local integer placed = 0
        local integer index
        local real x
        local real y
        local real cx = (AltairT_RealmMinX + AltairT_RealmMaxX)*0.5
        local real cy = (AltairT_RealmMinY + AltairT_RealmMaxY)*0.5
        set AltairT_Realm = Rect(AltairT_RealmMinX, AltairT_RealmMinY, AltairT_RealmMaxX, AltairT_RealmMaxY) // 1920, -3392, 3168, -2240
        // Граница: непроходимые блокеры YTfb через каждые 32 по всему периметру (сплошная стена в обе стороны).
        loop
            exitwhen position > AltairT_RealmMaxX - AltairT_RealmMinX
            call CreateDestructable('YTfb', AltairT_RealmMinX + position, AltairT_RealmMinY, 0.0, 1.0, 0)
            call CreateDestructable('YTfb', AltairT_RealmMinX + position, AltairT_RealmMaxY, 0.0, 1.0, 0)
            set position = position + 32.0
        endloop
        set position = 0.0
        loop
            exitwhen position > AltairT_RealmMaxY - AltairT_RealmMinY
            call CreateDestructable('YTfb', AltairT_RealmMinX, AltairT_RealmMinY + position, 0.0, 1.0, 0)
            call CreateDestructable('YTfb', AltairT_RealmMaxX, AltairT_RealmMinY + position, 0.0, 1.0, 0)
            set position = position + 32.0
        endloop
        // Видимая граница: деревья через каждые 224 (могут ломаться — стену держат блокеры).
        set position = 0.0
        loop
            exitwhen position > AltairT_RealmMaxX - AltairT_RealmMinX
            call CreateDestructable('B007', AltairT_RealmMinX + position, AltairT_RealmMinY, GetRandomReal(0.0, 359.0), 3.0, 0)
            call CreateDestructable('B009', AltairT_RealmMinX + position, AltairT_RealmMaxY, GetRandomReal(0.0, 359.0), 3.0, 0)
            set position = position + 224.0
        endloop
        set position = 224.0
        loop
            exitwhen position >= AltairT_RealmMaxY - AltairT_RealmMinY
            call CreateDestructable('B000', AltairT_RealmMinX, AltairT_RealmMinY + position, GetRandomReal(0.0, 359.0), 3.0, 0)
            call CreateDestructable('B00F', AltairT_RealmMaxX, AltairT_RealmMinY + position, GetRandomReal(0.0, 359.0), 3.0, 0)
            set position = position + 224.0
        endloop
        // Внутри: случайный мелкий и средний декор (классы 1-2), не ближе 200 к краю и не в центре (там появляются юниты).
        loop
            exitwhen placed >= AltairT_RealmDecor // 14
            set x = GetRandomReal(AltairT_RealmMinX + 200.0, AltairT_RealmMaxX - 200.0)
            set y = GetRandomReal(AltairT_RealmMinY + 200.0, AltairT_RealmMaxY - 200.0)
            if (x - cx)*(x - cx) + (y - cy)*(y - cy) > (AltairT_RealmSpread + 120.0)*(AltairT_RealmSpread + 120.0) then // AltairT_RealmSpread = 380
                set index = GetRandomInt(0, AltairDecorCount - 1)
                if AltairDecorClass[index] <= 2 then
                    call CreateDestructable(AltairDecorId[index], x, y, GetRandomReal(0.0, 359.0), AltairDecorScale[index], 0)
                    set placed = placed + 1
                endif
            endif
        endloop
    endfunction

    private struct AltairT
        private static integer array m_AltairT
        private static integer MUI_AltairT = -1
        unit c
        rect realm
        real x // портал
        real y
        effect portal
        effect ground
        effect gate // зеркальные врата в реалме
        real r // сколько ещё открыт
        real rmax
        real pullTime // сколько ещё длится втягивание
        boolean relocated // портал уже переносили
        group members // кто в реалме
        group pulling // кого сейчас втягивает
        integer memberCount // участники + втягиваемые
        real decorTimer

        // Кто может войти: живой юнит (союзник, враг или сама Altair), не здание, не локуст,
        // ещё не в реалме и не втягивается.
        method CanEnter takes unit u returns boolean
            return AltairAlive(u) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) and GetUnitAbilityLevel(u, 'Aloc') == 0 and not IsUnitInGroup(u, members) and not IsUnitInGroup(u, pulling) and not CheckCoordsInRect(realm, GetUnitX(u), GetUnitY(u))
        endmethod

        // Перенести юнита в случайную точку реалма, камеру его игрока — туда же.
        method TeleportIntoRealm takes unit u returns nothing
            local real angle = GetRandomReal(0.0, 2.0*bj_PI)
            local real distance = GetRandomReal(0.0, AltairT_RealmSpread) // AltairT_RealmSpread = 380
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_blackblink.mdx", GetUnitX(u), GetUnitY(u), 0.0, 1.0, 1.0, 0.0))
            call GroupAddUnit(members, u)
            call SetUnitPosition(u, GetRectCenterX(realm) + distance*Cos(angle), GetRectCenterY(realm) + distance*Sin(angle))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_blackblink.mdx", GetUnitX(u), GetUnitY(u), 0.0, 1.0, 1.0, 0.0))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_White.mdx", GetUnitX(u), GetUnitY(u), GetUnitFacing(u), 1.0, 1.2, 0.0))
            if GetLocalPlayer() == GetOwningPlayer(u) then
                call PanCameraToTimed(GetUnitX(u), GetUnitY(u), 0.0)
            endif
        endmethod

        // Поставить портал: разлом VoidRift (горизонтальный диск, pitch -90 = стоймя, смотрит на Altair) и круг на земле.
        method PlacePortal takes real NewX, real NewY returns nothing
            set x = NewX
            set y = NewY
            set portal = EffectSpawn3("war3mapImported\\wos_effect_mythic_VoidRiftPurple.mdx", x, y, (GAngle2(c, x, y) + bj_PI)*bj_RADTODEG, 1.0, AltairT_PortalScale, AltairT_PortalHeight, -90.0) // AltairT_PortalScale = 3.2, AltairT_PortalHeight = 230
            call BlzSetSpecialEffectColor(portal, 255, 225, 150)
            call BlzPlaySpecialEffect(portal, ANIM_TYPE_BIRTH)
            set ground = EffectSpawn("war3mapImported\\wos_yc_bluemorphcircle2.mdl", x, y, 0.0, 1.0, 2.2, 5.0)
            call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_whitering.mdx", x, y, 0.0, 1.0, 0.5, 10.0, 0.35, 0.5, 4.0), 0.25, 255, 255, 255, 0.35)
        endmethod

        // Закрыть реалм: всех участников — к порталу (по кругу 130), эффекты гаснут, КД T.
        method AltairT_Close takes nothing returns nothing
            local integer slot = 0
            local unit u
            loop
                set u = FirstOfGroup(pulling)
                exitwhen u == null
                call GroupRemoveUnit(pulling, u)
            endloop
            loop
                set u = FirstOfGroup(members)
                exitwhen u == null
                call GroupRemoveUnit(members, u)
                if GetUnitTypeId(u) != 0 then
                    call SetUnitPosition(u, x + 130.0*Cos(slot*bj_PI/2.0), y + 130.0*Sin(slot*bj_PI/2.0))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_blackblink.mdx", GetUnitX(u), GetUnitY(u), 0.0, 1.0, 1.0, 0.0))
                    if GetLocalPlayer() == GetOwningPlayer(u) then
                        call PanCameraToTimed(GetUnitX(u), GetUnitY(u), 0.0)
                    endif
                endif
                set slot = slot + 1
            endloop
            set memberCount = 0
            set r = 0.0
            call ColorEffDummy3(portal, 0.0, 255, 255, 255, 0.4)
            call ColorEffDummy3(ground, 0.0, 255, 255, 255, 0.4)
            call ColorEffDummy3(gate, 0.0, 255, 255, 255, 0.4)
            call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_whitering.mdx", x, y, 0.0, 1.0, 0.5, 10.0, 0.35, 0.5, 4.0), 0.25, 255, 255, 255, 0.35)
            set portal = null
            set ground = null
            set gate = null
            call WUI_HeroProgress(c, AltairT_ID, "Fate Reconstruction", 0.0, 0.0, true)
            call MakeSound("war3mapImported\\Hero_Altair_T5") // «Наслаждайтесь послевкусием»
            call BlzStartUnitAbilityCooldown(c, AltairT_ID, AltairT_Cooldown) // AltairT_Cooldown = 60
            call RemoveSavedInteger(AltairTable, GetHandleId(c), 3)
            set u = null
        endmethod

        // Открыт ли реалм этой Altair (для G).
        static method AltairT_IsOpen takes unit whichUnit returns boolean
            local thistype this = LoadInteger(AltairTable, GetHandleId(whichUnit), 3)
            return this != 0 and r > 0.0
        endmethod

        // G и смерть Altair закрывают реалм досрочно.
        static method AltairT_CloseFor takes unit whichUnit returns nothing
            local thistype this = LoadInteger(AltairTable, GetHandleId(whichUnit), 3)
            if this != 0 and r > 0.0 then
                call AltairT_Close()
            endif
        endmethod

        static method AltairT_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer slot
            local unit u
            local real minX
            local real minY
            local real maxX
            local real maxY
            loop
                exitwhen i > MUI_AltairT
                set this = m_AltairT[i]
                if r > 0.0 then
                    set r = r - 0.03
                    if r <= 0.0 or not AltairAlive(c) then
                        call AltairT_Close()
                    else
                        // ВТЯГИВАНИЕ: жертвы тянутся к порталу (MoveUnit AltairT_PullStep за тик), потом исчезают в реалме.
                        if pullTime > 0.0 then
                            set pullTime = RoundReal(pullTime - 0.03, 2)
                            set slot = 0
                            loop
                                exitwhen slot >= BlzGroupGetSize(pulling)
                                set u = BlzGroupUnitAt(pulling, slot)
                                if SR3(u, x, y) > AltairT_PullStep then // AltairT_PullStep = 30
                                    call MoveUnit(u, AltairT_PullStep, Atan2(y - GetUnitY(u), x - GetUnitX(u)))
                                endif
                                set slot = slot + 1
                            endloop
                            if pullTime <= 0.0 then
                                if BlzGroupGetSize(pulling) > 0 then
                                    call MakeSound("war3mapImported\\Hero_Altair_T" + I2S(GetRandomInt(2, 4))) // T2 «Добро пожаловать в мир богов», T3 «Я же говорила: это мир богов», T4 «Это не твоя история»
                                endif
                                loop
                                    set u = FirstOfGroup(pulling)
                                    exitwhen u == null
                                    call GroupRemoveUnit(pulling, u)
                                    if AltairAlive(u) then
                                        call TeleportIntoRealm(u)
                                    endif
                                endloop
                            endif
                        endif
                        // УДЕРЖАНИЕ: участники не выходят за рамки реалма (48 от края) — даже рывками.
                        set minX = GetRectMinX(realm) + 48.0
                        set minY = GetRectMinY(realm) + 48.0
                        set maxX = GetRectMaxX(realm) - 48.0
                        set maxY = GetRectMaxY(realm) - 48.0
                        set slot = 0
                        loop
                            exitwhen slot >= BlzGroupGetSize(members)
                            set u = BlzGroupUnitAt(members, slot)
                            if AltairAlive(u) and (GetUnitX(u) < minX or GetUnitX(u) > maxX or GetUnitY(u) < minY or GetUnitY(u) > maxY) then
                                call SetUnitX(u, RMaxBJ(minX, RMinBJ(maxX, GetUnitX(u))))
                                call SetUnitY(u, RMaxBJ(minY, RMinBJ(maxY, GetUnitY(u))))
                            endif
                            set slot = slot + 1
                        endloop
                        // НОВИЧКИ: юнит (или сама Altair) зашёл в открытый портал — входит, пока есть места.
                        if memberCount < AltairT_MaxMembers then // AltairT_MaxMembers = 4
                            call GroupEnumUnitsInRange(AltairGroup, x, y, AltairT_EnterRadius, NoDecor_Cond) // AltairT_EnterRadius = 140
                            loop
                                set u = FirstOfGroup(AltairGroup)
                                exitwhen u == null
                                call GroupRemoveUnit(AltairGroup, u)
                                if memberCount < AltairT_MaxMembers and CanEnter(u) then
                                    set memberCount = memberCount + 1
                                    call TeleportIntoRealm(u)
                                endif
                            endloop
                        endif
                        // КНОПКА T: до переноса — без КД (чтобы перенести), после — на КД до конца реалма.
                        if not relocated and BlzGetUnitAbilityCooldownRemaining(c, AltairT_ID) > 0.0 then
                            call BlzEndUnitAbilityCooldown(c, AltairT_ID)
                        elseif relocated and BlzGetUnitAbilityCooldownRemaining(c, AltairT_ID) < r then
                            call BlzStartUnitAbilityCooldown(c, AltairT_ID, r + 0.1)
                        endif
                        // ДЕКОР у портала раз в 1 с.
                        set decorTimer = decorTimer + 0.03
                        if decorTimer >= 1.0 then
                            set decorTimer = decorTimer - 1.0
                            call DecorRemove(c, x, y, AltairT_Aoe, AltairT_Decor) // AltairT_Aoe = 300, AltairT_Decor = 50
                            call VisionTimed(GetOwningPlayer(c), x, y, AltairT_Aoe*2.0, 1.2) // AltairT_Aoe = 300
                        endif
                        call WUI_HeroProgress(c, AltairT_ID, "Fate Reconstruction", r, rmax, true)
                    endif
                endif
                if r <= 0.0 then
                    // КОНЕЦ.
                    call DestroyGroup(members)
                    call DestroyGroup(pulling)
                    set members = null
                    set pulling = null
                    set realm = null
                    set c = null
                    set m_AltairT[i] = m_AltairT[MUI_AltairT]
                    set MUI_AltairT = MUI_AltairT - 1
                    set i = i - 1
                    if MUI_AltairT == -1 then
                        call AltairTick_Off(9)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        // false = портал уже переносили (каст не засчитывается).
        static method AltairT_Start takes unit NewC, real NewX, real NewY returns boolean
            local thistype this = LoadInteger(AltairTable, GetHandleId(NewC), 3)
            local unit u
            local unit nearest
            local real best
            local real distance
            if this != 0 then
                // 2-й КАСТ: перенос портала (один раз).
                if relocated then
                    return false
                endif
                set relocated = true
                call ColorEffDummy3(portal, 0.0, 255, 255, 255, 0.3)
                call ColorEffDummy3(ground, 0.0, 255, 255, 255, 0.3)
                call PlacePortal(NewX, NewY)
                return true
            endif
            // 1-й КАСТ.
            set this = thistype.create()
            set MUI_AltairT = MUI_AltairT + 1
            set m_AltairT[MUI_AltairT] = this
            set c = NewC
            set realm = AltairT_Realm
            // Kenjaku: при активной Prison Realm иной мир — сама тюрьма (её жертвы могут присоединиться).
            static if LIBRARY_KenjakuSpells then
                call GroupEnumUnitsInRect(AltairGroup, gg_rct_Cage, null)
                loop
                    set u = FirstOfGroup(AltairGroup)
                    exitwhen u == null
                    call GroupRemoveUnit(AltairGroup, u)
                    if GetUnitAbilityLevel(u, KenjakuF2_Prison_Abi_ID) > 0 and AltairAlive(u) then
                        set realm = gg_rct_Cage
                    endif
                endloop
            endif
            set relocated = false
            set memberCount = 0
            set pullTime = AltairT_PullTime // 0.36
            set decorTimer = 1.0 // декор ломается на первом тике
            set members = CreateGroup()
            set pulling = CreateGroup()
            set rmax = AltairT_Duration // 20
            if GetHeroLevel(c) >= 35 then
                set rmax = rmax + AltairT_DurationLevel35 // +5
            endif
            set r = rmax
            call PlacePortal(NewX, NewY)
            call AltairVoice.AltairVoice_Start("war3mapImported\\Hero_Altair_T1", 0.97, 2.52) // «Holopsicon, Twenty-third Movement: Fate Reconstruction» (T1a 0.97 с, T1b 1.55 с)
            // Зеркальные врата в центре реалма (тот же разлом, поменьше).
            set gate = EffectSpawn3("war3mapImported\\wos_effect_mythic_VoidRiftPurple.mdx", GetRectCenterX(realm), GetRectCenterY(realm), 0.0, 1.0, AltairT_PortalScale*0.6, AltairT_PortalHeight, -90.0) // 3.2 x 0.6, 230
            call BlzSetSpecialEffectColor(gate, 255, 225, 150)
            call BlzPlaySpecialEffect(gate, ANIM_TYPE_BIRTH)
            call SetUnitAnimation(c, "spell")
            // Ближайшие юниты первыми, до лимита участников.
            loop
                exitwhen memberCount >= AltairT_MaxMembers // 4
                set nearest = null
                set best = 999999999.0
                call GroupEnumUnitsInRange(AltairGroup, x, y, AltairT_Aoe, NoDecor_Cond) // AltairT_Aoe = 300
                loop
                    set u = FirstOfGroup(AltairGroup)
                    exitwhen u == null
                    call GroupRemoveUnit(AltairGroup, u)
                    if CanEnter(u) then
                        set distance = SR3(u, x, y)
                        if distance < best then
                            set best = distance
                            set nearest = u
                        endif
                    endif
                endloop
                exitwhen nearest == null
                call GroupAddUnit(pulling, nearest)
                set memberCount = memberCount + 1
                call ColorEffDummy3(AddSpecialEffectTarget("war3mapImported\\wos_whitering.mdx", nearest, "origin"), 0.25, 255, 255, 255, 0.35)
            endloop
            call SaveInteger(AltairTable, GetHandleId(c), 3, this)
            if MUI_AltairT == 0 then
                call AltairTick_On(9)
            endif
            set u = null
            set nearest = null
            return true
        endmethod
    endstruct

    // ==================== F: The Vicissitudes of Fortune ====================
    // КАК РАБОТАЕТ F:
    //   AltairF.AltairF_Start  даммик кастует на Altair способность A166 -> бафф B075 (6 с); вокруг Altair сфера.
    //   Altair_IncomingDamage  пока бафф висит, первый вражеский удар от AltairF_MinDamage (200) урона:
    //                            удар блокируется (Lust Sin пробивает), бафф снимается,
    //                            AltairFReflect выпускает мечи в атакующего с тем же уроном и тем же типом урона.
    //   AltairF.AltairF_Loop   сфера следует за Altair; бафф пропал (время / сработал / развеяли) или смерть — конец.
    //   AltairFReflect_Loop    мечи летят в цель самонаведением (MoveEff2 + высота); первый долетевший наносит урон.

    // Мечи отражения: летят от Altair в атакующего, урон — когда долетели.
    private struct AltairFReflect
        private static integer array m_AltairFReflect
        private static integer MUI_AltairFReflect = -1
        unit c // Altair
        unit td // кому вернуть урон
        real dmg
        integer dtype // тип урона как у полученного удара (0 атака, 1 маг., 2 физ., иначе чистый)
        real r // прошло
        real rmax // обрыв через 3 с, если цель недостижима
        integer swords
        effect array blade[8]
        real array bz[8] // высота мечей (x/y хранит сам эффект)

        static method AltairFReflect_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer k
            local real tz
            local real dx
            local real dy
            local real dz
            local real flat
            local real dist
            local real step = AltairF_SwordSpeed*0.03 // AltairF_SwordSpeed = 1800
            local boolean arrived
            loop
                exitwhen i > MUI_AltairFReflect
                set this = m_AltairFReflect[i]
                set arrived = false
                if AltairAlive(td) and r < rmax then
                    set r = RoundReal(r + 0.03, 2)
                    // ПОЛЁТ: каждый меч летит в грудь цели и смотрит на неё остриём.
                    set tz = BlzGetUnitZ(td) + 60.0
                    set k = 0
                    loop
                        exitwhen k >= swords
                        set dx = GetUnitX(td) - GetEffX(blade[k])
                        set dy = GetUnitY(td) - GetEffY(blade[k])
                        set dz = tz - bz[k]
                        set flat = SquareRoot(dx*dx + dy*dy)
                        set dist = SquareRoot(flat*flat + dz*dz)
                        if dist <= step + 40.0 then
                            set arrived = true
                        else
                            call MoveEff2(blade[k], step*flat/dist, Atan2(dy, dx))
                            set bz[k] = bz[k] + step*dz/dist
                            call BlzSetSpecialEffectZ(blade[k], bz[k])
                            call BlzSetSpecialEffectOrientation(blade[k], Atan2(dy, dx), Atan2(-dz, flat), 0.0)
                        endif
                        set k = k + 1
                    endloop
                    if arrived then
                        // ПОПАДАНИЕ: урон тем же типом, эффекты удара; на следующем тике — конец.
                        set r = rmax
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_mirrorzi_effect_ansekuosanbo.mdx", td, "chest"))
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_daoguang_blue_hitsword.mdx", td, "chest"))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_effect_fate_jiujian_chongjibo.mdx", GetUnitX(td), GetUnitY(td), GAngle(c, td)*bj_RADTODEG, 1.0, 1.0, 80.0))
                        if SpellBool(td) and IsUnitEnemy(td, GetOwningPlayer(c)) then
                            call DamageSource(AltairF_ID)
                            if dtype == 0 then
                                call dmgatk(c, td, dmg)
                            elseif dtype == 1 then
                                call dmgmag(c, td, dmg)
                            elseif dtype == 2 then
                                call dmgphys(c, td, dmg)
                            else
                                call spelldmg(c, td, dmg)
                            endif
                        endif
                    endif
                else
                    // КОНЕЦ: попали, цель пропала или вышло время — мечи гаснут.
                    set k = 0
                    loop
                        exitwhen k >= swords
                        call ColorEffDummy3(blade[k], 0.0, 255, 255, 255, 0.15)
                        set blade[k] = null
                        set k = k + 1
                    endloop
                    set c = null
                    set td = null
                    set m_AltairFReflect[i] = m_AltairFReflect[MUI_AltairFReflect]
                    set MUI_AltairFReflect = MUI_AltairFReflect - 1
                    set i = i - 1
                    if MUI_AltairFReflect == -1 then
                        call AltairTick_Off(11)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
        endmethod

        // Мечи появляются веером за спиной Altair (радиус 90, высота 90..150) и сразу летят в цель.
        // Зовётся из события урона: здесь только эффекты, сам урон — позже, в Loop.
        static method AltairFReflect_Start takes unit NewC, unit NewTd, real NewDmg, integer NewType returns nothing
            local thistype this = thistype.create()
            local integer k = 0
            local real facing = GAngle(NewC, NewTd)
            local real angle
            set MUI_AltairFReflect = MUI_AltairFReflect + 1
            set m_AltairFReflect[MUI_AltairFReflect] = this
            set c = NewC
            set td = NewTd
            set dmg = NewDmg
            set dtype = NewType
            set r = 0.0
            set rmax = 3.0
            set swords = IMinBJ(8, AltairF_Swords) // AltairF_Swords = 5
            loop
                exitwhen k >= swords
                set angle = facing + bj_PI + (k - (swords - 1)*0.5)*0.5 // за спиной, веером
                set blade[k] = EffectSpawn("war3mapImported\\wos_Erza_sword2.mdx", GetUnitX(c) + 90.0*Cos(angle), GetUnitY(c) + 90.0*Sin(angle), facing*bj_RADTODEG, 1.0, 0.3, 90.0 + 15.0*k)
                set bz[k] = BlzGetLocalSpecialEffectZ(blade[k])
                set k = k + 1
            endloop
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_effect_fate_jiujian_chongjibo.mdx", GetUnitX(c), GetUnitY(c), facing*bj_RADTODEG, 1.0, 1.0, 80.0))
            if MUI_AltairFReflect == 0 then
                call AltairTick_On(11)
            endif
        endmethod
    endstruct

    // Сфера F на Altair: живёт, пока висит бафф.
    private struct AltairF
        private static integer array m_AltairF
        private static integer MUI_AltairF = -1
        unit c
        effect e // сфера AsNodtSphere
        real r // прошло с последнего каста (даммику нужен миг, чтобы повесить бафф)

        static method AltairF_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_AltairF
                set this = m_AltairF[i]
                set r = RoundReal(r + 0.03, 2)
                if AltairAlive(c) and (r <= 0.3 or GetUnitAbilityLevel(c, AltairF_Buff_ID) > 0) then
                    call BlzSetSpecialEffectPosition(e, GetUnitX(c), GetUnitY(c), BlzGetUnitZ(c))
                else
                    // КОНЕЦ: бафф пропал или Altair умерла — сфера гаснет.
                    call UnitRemoveAbility(c, AltairF_Buff_ID)
                    call ColorEffDummy3(e, 0.0, 255, 255, 255, 0.25)
                    call RemoveSavedInteger(AltairTable, GetHandleId(c), 4)
                    set e = null
                    set c = null
                    set m_AltairF[i] = m_AltairF[MUI_AltairF]
                    set MUI_AltairF = MUI_AltairF - 1
                    set i = i - 1
                    if MUI_AltairF == -1 then
                        call AltairTick_Off(10)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
        endmethod

        // Из Altair_IncomingDamage: true = удар заблокирован, мечи уже летят в атакующего.
        static method AltairF_Block takes unit target, unit source, real amount, integer damageType returns boolean
            if amount < AltairF_MinDamage or GetUnitAbilityLevel(target, AltairF_Buff_ID) == 0 then // AltairF_MinDamage = 200
                return false
            endif
            call UnitRemoveAbility(target, AltairF_Buff_ID) // F срабатывает один раз
            call AltairFReflect.AltairFReflect_Start(target, source, amount*AltairF_Reflect, damageType) // AltairF_Reflect = 1.0
            call MakeSound("war3mapImported\\Hero_Altair_F" + I2S(GetRandomInt(2, 3))) // F2 «Но я изменила причину и следствие», F3 «Как жестоко»
            return true
        endmethod

        // Смерть Altair: бафф снимается, сфера гаснет на следующем тике.
        static method AltairF_Stop takes unit whichUnit returns nothing
            call UnitRemoveAbility(whichUnit, AltairF_Buff_ID)
        endmethod

        static method AltairF_Start takes unit NewC returns nothing
            local thistype this = LoadInteger(AltairTable, GetHandleId(NewC), 4)
            call BuffUnit01(NewC, NewC, AltairF_BuffSpell_ID, "bloodlust", 1) // бафф B075 на AltairF_Duration = 6 с
            call MakeSound("war3mapImported\\Hero_Altair_F1") // «Рассказать, что произошло?»
            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_yc_bluemorphcircle3.mdl", GetUnitX(NewC), GetUnitY(NewC), 0.0, 1.0, 0.9, 5.0), 0.25, 255, 255, 255, 0.35)
            call SetUnitAnimation(NewC, "spell")
            if this != 0 then
                set r = 0.0 // сфера уже есть; бафф обновлён кастом
                return
            endif
            set this = thistype.create()
            set MUI_AltairF = MUI_AltairF + 1
            set m_AltairF[MUI_AltairF] = this
            set c = NewC
            set r = 0.0
            set e = EffectSpawn("war3mapImported\\wos_AsNodtSphere.mdx", GetUnitX(c), GetUnitY(c), 0.0, 1.0, AltairF_ModelScale, 0.0) // AltairF_ModelScale = 0.28
            call BlzPlaySpecialEffect(e, ANIM_TYPE_BIRTH)
            call SaveInteger(AltairTable, GetHandleId(c), 4, this)
            if MUI_AltairF == 0 then
                call AltairTick_On(10)
            endif
        endmethod
    endstruct

    // ==================== SQ: Sword Rush ====================
    // КАК РАБОТАЕТ SQ:
    //   AltairSQ.AltairSQ_Start  платит AltairSQ_Cost стаков, два меча по бокам, рывок на AltairSQ_Range.
    //   AltairSQ.AltairSQ_Loop   MoveUnit героя, бьёт врагов в AltairSQ_Width по разу (как атака, on-hit предметы);
    //                            в конце пути / на краю арены / при смерти — финальный взмах.
    private struct AltairSQ
        private static integer array m_AltairSQ
        private static integer MUI_AltairSQ = -1
        unit c
        real a // направление рывка
        real d // сколько ещё бежать
        real dmg
        integer trailCount // тики до следующего образа шлейфа
        group hits // кого рывок уже ударил
        effect left // мечи по бокам
        effect right

        static method AltairSQ_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real step = AltairSQ_Speed*0.03 // AltairSQ_Speed = 2400
            local real x
            local real y
            local unit u
            loop
                exitwhen i > MUI_AltairSQ
                set this = m_AltairSQ[i]
                if d > 0.0 and AltairAlive(c) and PathableCheck(GetUnitX(c) + step*Cos(a), GetUnitY(c) + step*Sin(a)) then
                    // РЫВОК: шаг, мечи по бокам (70 в стороны), шлейф образов раз в 2 тика.
                    set d = d - step
                    call MoveUnit(c, step, a)
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call BlzSetSpecialEffectPosition(left, x + 70.0*Cos(a + bj_PI/2.0), y + 70.0*Sin(a + bj_PI/2.0), BlzGetUnitZ(c) + 70.0)
                    call BlzSetSpecialEffectPosition(right, x + 70.0*Cos(a - bj_PI/2.0), y + 70.0*Sin(a - bj_PI/2.0), BlzGetUnitZ(c) + 70.0)
                    set trailCount = trailCount - 1
                    if trailCount <= 0 then
                        set trailCount = 2
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_White.mdx", x, y, a*bj_RADTODEG, 1.5, 1.0, 0.0))
                    endif
                    // УРОН: каждого врага на пути один раз.
                    call GroupEnumUnitsInRange(AltairGroup, x, y, AltairSQ_Width, NoDecor_Cond) // AltairSQ_Width = 150
                    loop
                        set u = FirstOfGroup(AltairGroup)
                        exitwhen u == null
                        call GroupRemoveUnit(AltairGroup, u)
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, hits) then
                            call GroupAddUnit(hits, u)
                            call DamageSource(AltairSQ_ID)
                            call dmgatk(c, u, dmg)
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_daoguang_blue_hitsword.mdx", u, "chest"))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Opdef (571)2.mdl", GetUnitX(u), GetUnitY(u), 0.0, 1.0, 1.5, 76.0))
                        endif
                    endloop
                    call DecorRemove(c, x, y, AltairSQ_Width, AltairSQ_Decor) // AltairSQ_Width = 150, AltairSQ_Decor = 20
                else
                    // КОНЕЦ: финальный взмах, мечи гаснут, герой снова управляем.
                    call StopSpellUnit2(c)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_jingzi_jiansheng01_e1_l2.mdl", GetUnitX(c), GetUnitY(c), a*bj_RADTODEG, 1.5, 1.2, 60.0))
                    call ColorEffDummy3(left, 0.0, 255, 255, 255, 0.15)
                    call ColorEffDummy3(right, 0.0, 255, 255, 255, 0.15)
                    call DestroyGroup(hits)
                    set left = null
                    set right = null
                    set hits = null
                    set c = null
                    set m_AltairSQ[i] = m_AltairSQ[MUI_AltairSQ]
                    set MUI_AltairSQ = MUI_AltairSQ - 1
                    set i = i - 1
                    if MUI_AltairSQ == -1 then
                        call AltairTick_Off(12)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        // false = не хватает стаков.
        static method AltairSQ_Start takes unit NewC, real NewX, real NewY returns boolean
            local AltairHero h = AltairHero.AltairHero_Get(NewC)
            local thistype this
            local integer lvl = IMaxBJ(1, GetUnitAbilityLevel(NewC, AltairSQ_ID))
            if not h.SpendStacks(AltairSQ_Cost) then // AltairSQ_Cost = 3
                call h.RefuseCast(AltairSQ_ID, "Not enough sword stacks")
                return false
            endif
            set this = thistype.create()
            set MUI_AltairSQ = MUI_AltairSQ + 1
            set m_AltairSQ[MUI_AltairSQ] = this
            set c = NewC
            set a = GAngle2(c, NewX, NewY)
            set d = AltairSQ_Range // 700
            set trailCount = 0
            set dmg = GetHeroInt(c, true)*(AltairSQ_DamageIntBase + AltairSQ_DamageIntStep*(lvl - 1)) + GetAttack(c)*AltairSQ_DamageAtk // Int x (1 + 0.2/ур.) + атака x 1
            set hits = CreateGroup()
            set left = EffectSpawn("war3mapImported\\wos_Erza_sword2.mdx", GetUnitX(c), GetUnitY(c), a*bj_RADTODEG, 1.0, 0.4, 70.0)
            set right = EffectSpawn("war3mapImported\\wos_Erza_sword2.mdx", GetUnitX(c), GetUnitY(c), a*bj_RADTODEG, 1.0, 0.4, 70.0)
            call StartSpellUnit2(c)
            call SetUnitFacing(c, a*bj_RADTODEG)
            call SetUnitAnimation(c, "attack")
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_LXY-ZK_BM_The might of a sword_LAN-2.mdx", GetUnitX(c) + 150.0*Cos(a), GetUnitY(c) + 150.0*Sin(a), a*bj_RADTODEG, 1.5, 1.0, 60.0))
            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + AltairSQ_Range*0.5*Cos(a), GetUnitY(c) + AltairSQ_Range*0.5*Sin(a), AltairSQ_Range*0.7, 1.5) // AltairSQ_Range = 700
            call MakeSound("war3mapImported\\Hero_Altair_GQ" + I2S(GetRandomInt(1, 3)))
            if MUI_AltairSQ == 0 then
                call AltairTick_On(12)
            endif
            return true
        endmethod
    endstruct

    // ==================== SW: Sword Storm ====================
    // КАК РАБОТАЕТ SW:
    //   AltairSW.AltairSW_Start  платит AltairSW_Cost стаков и сразу бросает веер из AltairSW_Swords мечей
    //                            в конусе AltairSW_Cone. Своего тика нет: полёт и урон — AltairSword.AltairSword_Loop
    //                            (MoveEff2; общая группа hits: каждый враг получает урон один раз за веер).
    private struct AltairSW
        static method AltairSW_Start takes unit NewC, real NewX, real NewY returns boolean
            local AltairHero h = AltairHero.AltairHero_Get(NewC)
            local integer sword = 0
            local integer lvl = IMaxBJ(1, GetUnitAbilityLevel(NewC, AltairSW_ID))
            local real center
            local real dmg
            local real angle
            local group hits
            if not h.SpendStacks(AltairSW_Cost) then // AltairSW_Cost = 6
                call h.RefuseCast(AltairSW_ID, "Not enough sword stacks")
                return false
            endif
            set center = GAngle2(NewC, NewX, NewY)
            set dmg = GetHeroInt(NewC, true)*(AltairSW_DamageIntBase + AltairSW_DamageIntStep*(lvl - 1)) + GetAttack(NewC)*AltairSW_DamageAtk // Int x (1.2 + 0.3/ур.) + атака x 0.8
            set hits = CreateGroup()
            call SetUnitFacing(NewC, center*bj_RADTODEG)
            call SetUnitAnimation(NewC, "spell")
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_effect_fate_jiujian_galibang_qixuan.mdx", GetUnitX(NewC), GetUnitY(NewC), center*bj_RADTODEG, 1.0, 1.4, 90.0))
            call VisionTimed(GetOwningPlayer(NewC), GetUnitX(NewC) + AltairSW_Range*0.5*Cos(center), GetUnitY(NewC) + AltairSW_Range*0.5*Sin(center), AltairSW_Range*0.7, 2.0) // AltairSW_Range = 1000
            // Мечи равномерно по конусу, стартуют чуть позади героя, высота и скорость слегка разные.
            loop
                exitwhen sword >= AltairSW_Swords // 9
                set angle = center + (sword - (AltairSW_Swords - 1)*0.5)*AltairSW_Cone*bj_DEGTORAD/(AltairSW_Swords - 1) // AltairSW_Cone = 40
                call AltairSword.AltairSword_Throw(NewC, GetUnitX(NewC) - 40.0*Cos(angle), GetUnitY(NewC) - 40.0*Sin(angle), 80.0 + GetRandomReal(0.0, 60.0), angle, AltairSW_Speed + GetRandomReal(-150.0, 150.0), AltairSW_Range, AltairSW_Width, dmg, hits) // AltairSW_Speed = 1800, AltairSW_Range = 1000, AltairSW_Width = 110
                set sword = sword + 1
            endloop
            call MakeSound("war3mapImported\\Hero_Altair_GW" + I2S(GetRandomInt(1, 2)))
            set hits = null
            return true
        endmethod
    endstruct

    // ==================== SE: Spinning Swords ====================
    // КАК РАБОТАЕТ SE:
    //   AltairSE.AltairSE_Start  платит seCost стаков (2 -> 4 -> 6 при рекасте в окне AltairSE_RecastWindow);
    //                            кольцо мечей вокруг героя — новое или усиленное (+мечи, +сила, срок заново).
    //   AltairSE.AltairSE_Loop   вращение (орбита вокруг героя), каждые AltairSE_Period урон по AltairSE_Aoe;
    //                            конец через AltairSE_Duration. Мечи лежат горизонтально остриём наружу.
    private struct AltairSE
        private static integer array m_AltairSE
        private static integer MUI_AltairSE = -1
        unit c
        real r // сколько ещё крутится
        real power // 1 / 1.5 / 2 по рекасту
        real dmg
        real a // угол кольца
        real tickTimer
        integer blades
        effect array blade[24]

        static method AltairSE_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer slot
            local real bladeAngle
            local real z
            local unit u
            loop
                exitwhen i > MUI_AltairSE
                set this = m_AltairSE[i]
                set r = r - 0.03
                if r > 0.0 and AltairAlive(c) then
                    // ВРАЩЕНИЕ: сильнее рекаст — быстрее крутится.
                    set a = a + AltairSE_SpinSpeed*0.03*(0.75 + 0.25*power) // AltairSE_SpinSpeed = 12
                    set z = BlzGetUnitZ(c) + AltairSE_Height // AltairSE_Height = 60
                    set slot = 0
                    loop
                        exitwhen slot >= blades
                        set bladeAngle = a + slot*2.0*bj_PI/blades
                        call BlzSetSpecialEffectPosition(blade[slot], GetUnitX(c) + AltairSE_Radius*Cos(bladeAngle), GetUnitY(c) + AltairSE_Radius*Sin(bladeAngle), z) // AltairSE_Radius = 190
                        call BlzSetSpecialEffectYaw(blade[slot], bladeAngle)
                        set slot = slot + 1
                    endloop
                    // УРОН каждые AltairSE_Period.
                    set tickTimer = tickTimer + 0.03
                    if tickTimer >= AltairSE_Period then // AltairSE_Period = 0.25
                        set tickTimer = tickTimer - AltairSE_Period
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_erdaoliujianqi.mdx", GetUnitX(c), GetUnitY(c), a*bj_RADTODEG, 2.0, 0.8, 30.0))
                        call GroupEnumUnitsInRange(AltairGroup, GetUnitX(c), GetUnitY(c), AltairSE_Aoe, NoDecor_Cond) // AltairSE_Aoe = 300
                        loop
                            set u = FirstOfGroup(AltairGroup)
                            exitwhen u == null
                            call GroupRemoveUnit(AltairGroup, u)
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call DamageSource(AltairSE_ID)
                                call dmgatk(c, u, dmg*power)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_daoguang_blue_hitsword.mdx", u, "chest"))
                            endif
                        endloop
                        call DecorRemove(c, GetUnitX(c), GetUnitY(c), AltairSE_Aoe, AltairSE_Decor) // AltairSE_Aoe = 300, AltairSE_Decor = 30
                        call VisionTimed(GetOwningPlayer(c), GetUnitX(c), GetUnitY(c), AltairSE_Aoe*1.6, 0.5)
                    endif
                else
                    // КОНЕЦ: мечи гаснут.
                    set slot = 0
                    loop
                        exitwhen slot >= blades
                        call ColorEffDummy3(blade[slot], 0.0, 255, 255, 255, 0.12)
                        set blade[slot] = null
                        set slot = slot + 1
                    endloop
                    call RemoveSavedInteger(AltairTable, GetHandleId(c), 5)
                    set c = null
                    set m_AltairSE[i] = m_AltairSE[MUI_AltairSE]
                    set MUI_AltairSE = MUI_AltairSE - 1
                    set i = i - 1
                    if MUI_AltairSE == -1 then
                        call AltairTick_Off(13)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        // false = не хватает стаков.
        static method AltairSE_Start takes unit NewC returns boolean
            local AltairHero h = AltairHero.AltairHero_Get(NewC)
            local thistype this = LoadInteger(AltairTable, GetHandleId(NewC), 5)
            local integer lvl = IMaxBJ(1, GetUnitAbilityLevel(NewC, AltairSE_ID))
            local integer cost = h.seCost // 2 -> 4 -> 6
            local integer recast = (cost - AltairSE_Cost)/AltairSE_CostStep // 0, 1, 2 (AltairSE_Cost = 2, AltairSE_CostStep = 2)
            local integer wanted
            if not h.SpendStacks(cost) then
                call h.RefuseCast(AltairSE_ID, "Not enough sword stacks")
                return false
            endif
            if this == 0 then
                // Первый каст в окне: новое кольцо.
                set this = thistype.create()
                set MUI_AltairSE = MUI_AltairSE + 1
                set m_AltairSE[MUI_AltairSE] = this
                set c = NewC
                set blades = 0
                set a = GetUnitFacing(c)*bj_DEGTORAD
                set tickTimer = AltairSE_Period // 0.25: первый удар сразу
                call SaveInteger(AltairTable, GetHandleId(c), 5, this)
                if MUI_AltairSE == 0 then
                    call AltairTick_On(13)
                endif
            endif
            set power = 1.0 + AltairSE_PowerStep*recast // AltairSE_PowerStep = 0.5
            set dmg = GetHeroInt(c, true)*(AltairSE_DamageIntBase + AltairSE_DamageIntStep*(lvl - 1)) + GetAttack(c)*AltairSE_DamageAtk // Int x (0.3 + 0.05/ур.) + атака x 0.15
            set r = AltairSE_Duration // 1.5
            // Добавить мечи до 8 / 12 / 16 (AltairSE_Blades = 8, AltairSE_BladesStep = 4).
            set wanted = IMinBJ(24, AltairSE_Blades + AltairSE_BladesStep*recast)
            loop
                exitwhen blades >= wanted
                set blade[blades] = EffectSpawn("war3mapImported\\wos_Erza_sword2.mdx", GetUnitX(c), GetUnitY(c), 0.0, 1.0, 0.3, AltairSE_Height) // AltairSE_Height = 60
                set blades = blades + 1
            endloop
            call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_whitering.mdx", GetUnitX(c), GetUnitY(c), 0.0, 1.0, 0.5, 10.0, 0.2, 0.5, AltairSE_Aoe/110.0), 0.25, 255, 255, 255, 0.35) // AltairSE_Aoe = 300
            call SetUnitAnimation(c, "spell")
            call MakeSound("war3mapImported\\Hero_Altair_GE" + I2S(GetRandomInt(1, 2)))
            // Следующий рекаст в окне дороже.
            set h.seCost = IMinBJ(AltairSE_CostMax, cost + AltairSE_CostStep) // AltairSE_CostMax = 6, AltairSE_CostStep = 2
            set h.seWindow = AltairSE_RecastWindow // 4
            return true
        endmethod
    endstruct

    // ==================== SR: Shield of Swords ====================
    // КАК РАБОТАЕТ SR:
    //   AltairSR.AltairSR_Start  платит AltairSR_Cost стаков: кольцо мечей + стена мечей в сторону каста.
    //   AltairSR.AltairSR_Loop   вращение кольца, каждые AltairSR_Period урон вокруг; конец по времени / смерти.
    //   Сам блок урона с направления (дуга AltairSR_Arc) — в Altair_IncomingDamage (AltairSR.AltairSR_Blocks).
    private struct AltairSR
        private static integer array m_AltairSR
        private static integer MUI_AltairSR = -1
        unit c
        real r // сколько ещё держится
        real blockAngle // направление щита
        real a // угол кольца
        real tickTimer
        real dmg
        effect array blade[24] // 0..15 кольцо, 16..21 стена

        static method AltairSR_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer slot
            local real bladeAngle
            local real z
            local unit u
            loop
                exitwhen i > MUI_AltairSR
                set this = m_AltairSR[i]
                set r = r - 0.03
                if r > 0.0 and AltairAlive(c) then
                    set a = a + AltairSR_SpinSpeed*0.03 // AltairSR_SpinSpeed = 6
                    set z = BlzGetUnitZ(c)
                    // Кольцо вращается.
                    set slot = 0
                    loop
                        exitwhen slot >= AltairSR_RingBlades // 16
                        set bladeAngle = a + slot*2.0*bj_PI/AltairSR_RingBlades
                        call BlzSetSpecialEffectPosition(blade[slot], GetUnitX(c) + AltairSR_Radius*Cos(bladeAngle), GetUnitY(c) + AltairSR_Radius*Sin(bladeAngle), z + 60.0) // AltairSR_Radius = 170
                        call BlzSetSpecialEffectYaw(blade[slot], bladeAngle)
                        set slot = slot + 1
                    endloop
                    // Неподвижная стена мечей показывает закрытое направление (два ряда по высоте).
                    loop
                        exitwhen slot >= AltairSR_RingBlades + AltairSR_WallBlades // 16 + 6
                        set bladeAngle = blockAngle + (slot - AltairSR_RingBlades - (AltairSR_WallBlades - 1)*0.5)*AltairSR_Arc*bj_DEGTORAD/AltairSR_WallBlades // AltairSR_Arc = 120
                        call BlzSetSpecialEffectPosition(blade[slot], GetUnitX(c) + AltairSR_WallRadius*Cos(bladeAngle), GetUnitY(c) + AltairSR_WallRadius*Sin(bladeAngle), z + 40.0 + 45.0*ModuloInteger(slot, 2)) // AltairSR_WallRadius = 120
                        call BlzSetSpecialEffectYaw(blade[slot], bladeAngle)
                        set slot = slot + 1
                    endloop
                    // УРОН кольцом каждые AltairSR_Period.
                    set tickTimer = tickTimer + 0.03
                    if tickTimer >= AltairSR_Period then // AltairSR_Period = 0.3
                        set tickTimer = tickTimer - AltairSR_Period
                        call DecorRemove(c, GetUnitX(c), GetUnitY(c), AltairSR_Radius + 60.0, AltairSR_Decor) // AltairSR_Radius = 170, AltairSR_Decor = 20
                        call VisionTimed(GetOwningPlayer(c), GetUnitX(c), GetUnitY(c), 600.0, 0.5)
                        call GroupEnumUnitsInRange(AltairGroup, GetUnitX(c), GetUnitY(c), AltairSR_Radius + 60.0, NoDecor_Cond) // AltairSR_Radius = 170
                        loop
                            set u = FirstOfGroup(AltairGroup)
                            exitwhen u == null
                            call GroupRemoveUnit(AltairGroup, u)
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call DamageSource(AltairSR_ID)
                                call dmgatk(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_daoguang_blue_hitsword.mdx", u, "chest"))
                            endif
                        endloop
                    endif
                else
                    // КОНЕЦ: мечи гаснут, блок пропадает вместе с экземпляром.
                    set slot = 0
                    loop
                        exitwhen slot >= AltairSR_RingBlades + AltairSR_WallBlades // 16 + 6
                        call ColorEffDummy3(blade[slot], 0.0, 255, 255, 255, 0.2)
                        set blade[slot] = null
                        set slot = slot + 1
                    endloop
                    call RemoveSavedInteger(AltairTable, GetHandleId(c), 6)
                    set c = null
                    set m_AltairSR[i] = m_AltairSR[MUI_AltairSR]
                    set MUI_AltairSR = MUI_AltairSR - 1
                    set i = i - 1
                    if MUI_AltairSR == -1 then
                        call AltairTick_Off(14)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        // Из Altair_IncomingDamage: true = удар пришёл из закрытой щитом дуги.
        static method AltairSR_Blocks takes unit target, unit source returns boolean
            local thistype this = LoadInteger(AltairTable, GetHandleId(target), 6)
            if this == 0 or r <= 0.0 then
                return false
            endif
            // Угол между направлением на атакующего и направлением щита меньше половины дуги.
            if Cos(GAngle(target, source) - blockAngle) >= Cos(AltairSR_Arc*0.5*bj_DEGTORAD) then // AltairSR_Arc = 120
                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_daoguang_blue_hitsword.mdx", target, "chest"))
                return true
            endif
            return false
        endmethod

        // false = не хватает стаков. Повторный каст во время щита — новый срок и новое направление.
        static method AltairSR_Start takes unit NewC, real NewX, real NewY returns boolean
            local AltairHero h = AltairHero.AltairHero_Get(NewC)
            local thistype this = LoadInteger(AltairTable, GetHandleId(NewC), 6)
            local integer lvl = IMaxBJ(1, GetUnitAbilityLevel(NewC, AltairSR_ID))
            local integer slot = 0
            if not h.SpendStacks(AltairSR_Cost) then // AltairSR_Cost = 8
                call h.RefuseCast(AltairSR_ID, "Not enough sword stacks")
                return false
            endif
            if this == 0 then
                set this = thistype.create()
                set MUI_AltairSR = MUI_AltairSR + 1
                set m_AltairSR[MUI_AltairSR] = this
                set c = NewC
                set a = 0.0
                set tickTimer = 0.0
                loop
                    exitwhen slot >= AltairSR_RingBlades + AltairSR_WallBlades // 16 + 6
                    set blade[slot] = EffectSpawn("war3mapImported\\wos_Erza_sword2.mdx", GetUnitX(c), GetUnitY(c), 0.0, 1.0, 0.25, 60.0)
                    set slot = slot + 1
                endloop
                call SaveInteger(AltairTable, GetHandleId(c), 6, this)
                if MUI_AltairSR == 0 then
                    call AltairTick_On(14)
                endif
            endif
            set blockAngle = GAngle2(c, NewX, NewY)
            set r = AltairSR_Duration + AltairSR_DurationStep*(lvl - 1) // 3 + 0.5/ур.
            set dmg = GetHeroInt(c, true)*AltairSR_DamageInt + GetAttack(c)*AltairSR_DamageAtk // Int x 0.15 + атака x 0.1
            call SetUnitFacing(c, blockAngle*bj_RADTODEG)
            call SetUnitAnimation(c, "spell")
            call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_whitering.mdx", GetUnitX(c), GetUnitY(c), 0.0, 1.0, 0.5, 10.0, 0.2, 0.5, 2.0), 0.25, 255, 255, 255, 0.35)
            call MakeSound("war3mapImported\\Hero_Altair_GR" + I2S(GetRandomInt(1, 2)))
            return true
        endmethod
    endstruct

    // ==================== ST: Rain of Swords ====================
    // КАК РАБОТАЕТ ST:
    //   AltairST.AltairST_Start  платит AltairST_Cost стаков, Altair неуязвима (StartSpellUnit) и взлетает (SetFly).
    //   AltairST.AltairST_Loop   каждые AltairST_SpawnPeriod роняет меч (AltairSTSword) в случайную точку круга;
    //                            раз в 1 с ломает декор; r == AltairST_Duration (или смерть) — посадка.
    //   AltairSTSword.AltairSTSword_Loop  меч падает вертикально, на земле урон по AltairST_ImpactAoe.

    // Один падающий меч ST.
    private struct AltairSTSword
        private static integer array m_AltairSTSword
        private static integer MUI_AltairSTSword = -1
        unit c
        effect e
        real height // над землёй
        real dmg

        static method AltairSTSword_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real x
            local real y
            local unit u
            loop
                exitwhen i > MUI_AltairSTSword
                set this = m_AltairSTSword[i]
                set height = height - AltairST_DropSpeed*0.03 // AltairST_DropSpeed = 2400
                set x = GetEffX(e)
                set y = GetEffY(e)
                if height > 0.0 then
                    call BlzSetSpecialEffectZ(e, AltairGroundZ(x, y) + height)
                else
                    // УДАР О ЗЕМЛЮ: меч гаснет, урон вокруг.
                    call ColorEffDummy3(e, 0.25, 255, 255, 255, 0.2)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_jingzi_jiansheng01_e1_l2.mdl", x, y, GetRandomReal(0.0, 359.0), 1.5, 0.6, 5.0))
                    if GetRandomInt(1, 3) == 1 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_dustbrown.mdl", x, y, GetRandomReal(0.0, 359.0), 1.5, 0.6, 0.0))
                    endif
                    call GroupEnumUnitsInRange(AltairGroup, x, y, AltairST_ImpactAoe, NoDecor_Cond) // AltairST_ImpactAoe = 160
                    loop
                        set u = FirstOfGroup(AltairGroup)
                        exitwhen u == null
                        call GroupRemoveUnit(AltairGroup, u)
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                            call DamageSource(AltairST_ID)
                            call dmgatk(c, u, dmg)
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                        endif
                    endloop
                    set e = null
                    set c = null
                    set m_AltairSTSword[i] = m_AltairSTSword[MUI_AltairSTSword]
                    set MUI_AltairSTSword = MUI_AltairSTSword - 1
                    set i = i - 1
                    if MUI_AltairSTSword == -1 then
                        call AltairTick_Off(15)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        // Меч появляется на AltairST_DropHeight над случайной точкой круга (равномерно по площади) остриём вниз.
        static method AltairSTSword_Drop takes unit NewC, real centerX, real centerY returns nothing
            local thistype this = thistype.create()
            local real distance = AltairST_Aoe*SquareRoot(GetRandomReal(0.0, 1.0)) // AltairST_Aoe = 700
            local real angle = GetRandomReal(0.0, 2.0*bj_PI)
            set MUI_AltairSTSword = MUI_AltairSTSword + 1
            set m_AltairSTSword[MUI_AltairSTSword] = this
            set c = NewC
            set height = AltairST_DropHeight // 900
            set dmg = GetHeroInt(c, true)*AltairST_DamageInt + GetAttack(c)*AltairST_DamageAtk // Int x 0.5 + атака x 0.3
            set e = EffectSpawn3("war3mapImported\\wos_Erza_sword2.mdx", centerX + distance*Cos(angle), centerY + distance*Sin(angle), angle*bj_RADTODEG, 1.0, 0.45, height, 90.0) // лезвие вдоль X: pitch 90 = остриём вниз
            if MUI_AltairSTSword == 0 then
                call AltairTick_On(15)
            endif
        endmethod
    endstruct

    private struct AltairST
        private static integer array m_AltairST
        private static integer MUI_AltairST = -1
        unit c
        real x // центр дождя (где Altair взлетела)
        real y
        real r // прошло с каста
        real rmax // AltairST_Duration
        real spawnTimer // накопитель до следующего меча
        real decorTimer
        effect e // круг на земле

        static method AltairST_Loop takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_AltairST
                set this = m_AltairST[i]
                if AltairAlive(c) and r < rmax then
                    set r = RoundReal(r + 0.03, 2)
                    // ПОДЪЁМ за AltairST_RiseTime, потом держится на высоте.
                    call SetFly(c, AltairST_Height*RMinBJ(1.0, r/AltairST_RiseTime)) // AltairST_Height = 450, AltairST_RiseTime = 0.4
                    // ДЕКОР раз в 1 с по всему кругу.
                    set decorTimer = decorTimer + 0.03
                    if decorTimer >= 1.0 then
                        set decorTimer = decorTimer - 1.0
                        call DecorRemove(c, x, y, AltairST_Aoe, AltairST_Decor) // AltairST_Aoe = 700, AltairST_Decor = 50
                        call VisionTimed(GetOwningPlayer(c), x, y, AltairST_Aoe*1.4, 1.2)
                    endif
                    // МЕЧИ каждые AltairST_SpawnPeriod.
                    set spawnTimer = spawnTimer + 0.03
                    loop
                        exitwhen spawnTimer < AltairST_SpawnPeriod // AltairST_SpawnPeriod = 0.06
                        set spawnTimer = spawnTimer - AltairST_SpawnPeriod
                        call AltairSTSword.AltairSTSword_Drop(c, x, y)
                    endloop
                    call WUI_HeroProgress(c, AltairST_ID, "Rain of Swords", rmax - r, rmax, true)
                else
                    // КОНЕЦ: посадка, неуязвимость снимается.
                    call SetFly(c, 0.0)
                    call StopSpellUnit(c)
                    call ColorEffDummy3(e, 0.0, 255, 255, 255, 0.3)
                    set e = null
                    call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_whitering.mdx", GetUnitX(c), GetUnitY(c), 0.0, 1.0, 0.5, 10.0, 0.3, 0.5, AltairST_Aoe/100.0), 0.25, 255, 255, 255, 0.35) // AltairST_Aoe = 700
                    call WUI_HeroProgress(c, AltairST_ID, "Rain of Swords", 0.0, 0.0, true)
                    call RemoveSavedInteger(AltairTable, GetHandleId(c), 7)
                    set c = null
                    set m_AltairST[i] = m_AltairST[MUI_AltairST]
                    set MUI_AltairST = MUI_AltairST - 1
                    set i = i - 1
                    if MUI_AltairST == -1 then
                        call AltairTick_Off(16)
                    endif
                    call this.destroy()
                endif
                set i = i + 1
            endloop
        endmethod

        // false = не хватает стаков. Повторный каст во время дождя: стаки списаны, новый дождь не начинается.
        static method AltairST_Start takes unit NewC returns boolean
            local AltairHero h = AltairHero.AltairHero_Get(NewC)
            local thistype this = LoadInteger(AltairTable, GetHandleId(NewC), 7)
            if not h.SpendStacks(AltairST_Cost) then // AltairST_Cost = 30
                call h.RefuseCast(AltairST_ID, "Not enough sword stacks")
                return false
            endif
            call MakeSound("war3mapImported\\Hero_Altair_GT" + I2S(GetRandomInt(1, 2)))
            if this != 0 then
                return true
            endif
            set this = thistype.create()
            set MUI_AltairST = MUI_AltairST + 1
            set m_AltairST[MUI_AltairST] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0.0
            set rmax = AltairST_Duration // 3
            set spawnTimer = 0.0
            set decorTimer = 1.0 // декор ломается на первом тике
            set e = EffectSpawn("war3mapImported\\wos_yc_bluemorphcircle2.mdl", x, y, 0.0, 1.0, AltairST_Aoe/150.0, 5.0) // AltairST_Aoe = 700
            call StartSpellUnit(c) // неуязвимость на время дождя
            call SetUnitAnimation(c, "spell")
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_blackblink.mdx", x, y, 0.0, 1.0, 1.2, 0.0))
            call EffectSpawn2("war3mapImported\\wos_Altair4.mdx", x, y, 0.0, 1.0, AltairST_Aoe/550.0, 0.0, 2.5) // AltairST_Aoe = 700
            call SaveInteger(AltairTable, GetHandleId(c), 7, this)
            if MUI_AltairST == 0 then
                call AltairTick_On(16)
            endif
            return true
        endmethod
    endstruct

    // ==================== SF: Endless Swords ====================
    // КАК РАБОТАЕТ SF:
    //   AltairSF.AltairSF_Start  тоггл 4 мечей-охранников (AltairHero.SetSwordGuard, вращает AltairHero_Loop).
    //   Пока включён: входящие атаки x AltairSF_AttackTaken, каждая стоит AltairSF_AttackCost стаков (Altair_IncomingDamage).
    //   Пассив: +1 стак раз в AltairSF_StackPeriod (AltairHero_Loop), +AltairSF_DeathStacks за смерть любого героя.
    private struct AltairSF
        static method AltairSF_Start takes unit NewC returns nothing
            local AltairHero h = AltairHero.AltairHero_Get(NewC)
            if not h.swordToggle and h.stacks < AltairSF_AttackCost then // AltairSF_AttackCost = 2
                call h.RefuseCast(AltairSF_ID, "Not enough sword stacks")
                return
            endif
            call h.SetSwordGuard(not h.swordToggle)
            if h.swordToggle then
                call MakeSound("war3mapImported\\Hero_Altair_GF1")
            endif
        endmethod
    endstruct

    // ==================== ТИК ГЕРОЯ: что выполняется каждые 0.03 с ====================
    // Каждая способность — только пока она активна (AltairTick_Active[k]).
    private struct AltairTick_Loop extends array
        static method Loop takes nothing returns nothing
            if AltairTick_Active[0] then
                call AltairSword.AltairSword_Loop()
            endif
            if AltairTick_Active[1] then
                call AltairQBullet.AltairQBullet_Loop()
            endif
            if AltairTick_Active[2] then
                call AltairQ.AltairQ_Loop()
            endif
            if AltairTick_Active[3] then
                call AltairW.AltairW_Loop()
            endif
            if AltairTick_Active[4] then
                call AltairWBlock.AltairWBlock_Loop()
            endif
            if AltairTick_Active[5] then
                call AltairE.AltairE_Loop()
            endif
            if AltairTick_Active[6] then
                call AltairRVolley.AltairRVolley_Loop()
            endif
            if AltairTick_Active[7] then
                call AltairRCopy.AltairRCopy_Loop()
            endif
            if AltairTick_Active[8] then
                call AltairR.AltairR_Loop()
            endif
            if AltairTick_Active[9] then
                call AltairT.AltairT_Loop()
            endif
            if AltairTick_Active[10] then
                call AltairF.AltairF_Loop()
            endif
            if AltairTick_Active[11] then
                call AltairFReflect.AltairFReflect_Loop()
            endif
            if AltairTick_Active[12] then
                call AltairSQ.AltairSQ_Loop()
            endif
            if AltairTick_Active[13] then
                call AltairSE.AltairSE_Loop()
            endif
            if AltairTick_Active[14] then
                call AltairSR.AltairSR_Loop()
            endif
            if AltairTick_Active[15] then
                call AltairSTSword.AltairSTSword_Loop()
            endif
            if AltairTick_Active[16] then
                call AltairST.AltairST_Loop()
            endif
            if AltairTick_Active[17] then
                call AltairHero.AltairHero_Loop()
            endif
            if AltairTick_Active[18] then
                call AltairVoice.AltairVoice_Loop()
            endif
        endmethod

        private static method onInit takes nothing returns nothing
            set AltairTick_Callback = function thistype.Loop
        endmethod
    endstruct

    // Первый каст (и TestHero.j): состояние героя создаётся один раз.
    function Altair_Register takes unit hero returns nothing
        if GetUnitTypeId(hero) != Altair_ID or IsUnitIllusion(hero) then
            return
        endif
        call AltairHero.AltairHero_Register(hero)
    endfunction

    // TEST (Escape): полные стаки и сброс цены SE.
    function Altair_ResetForTest takes unit hero returns nothing
        local AltairHero h
        call Altair_Register(hero)
        set h = AltairHero.AltairHero_Get(hero)
        if h != 0 then
            set h.stacks = h.MaxStacks()
            set h.seCost = AltairSE_Cost // 2
        endif
    endfunction

    // Death.j: смерть Altair закрывает её реалм, гасит F и SF; смерть любого героя даёт стаки.
    function Altair_Death takes unit dying returns nothing
        local AltairHero h
        if GetUnitTypeId(dying) == Altair_ID then
            call AltairT.AltairT_CloseFor(dying)
            call AltairF.AltairF_Stop(dying)
            set h = AltairHero.AltairHero_Get(dying)
            if h != 0 then
                call h.SetSwordGuard(false)
            endif
        endif
        if IsUnitType(dying, UNIT_TYPE_HERO) and not IsUnitIllusion(dying) then
            call AltairHero.AltairHero_OnHeroDeath(dying)
        endif
    endfunction

    // DmgSys, входящий урон (до DamageCheck). Порядок проверок:
    //   1) блок W на любом союзнике; 2) F (удар от 200 — блок и отражение); 3) щит SR с направления;
    //   4) SF-тоггл (атаки -10%, 2 стака за удар). LustSin = блок, который Lust Sin пробивает.
    function Altair_IncomingDamage takes unit source, unit target, real damage, integer damageType returns real
        local AltairHero h
        local boolean enemy
        if damage <= 0.0 or source == null or target == null then
            return damage
        endif
        set enemy = IsUnitEnemy(source, GetOwningPlayer(target))
        if enemy and AltairWBlock.AltairWBlock_Use(target) then
            return LustSin(source, target, damage, damage)
        endif
        if GetUnitTypeId(target) != Altair_ID then
            return damage
        endif
        set h = AltairHero.AltairHero_Get(target)
        if h == 0 then
            return damage
        endif
        if enemy and AltairF.AltairF_Block(target, source, damage, damageType) then
            return LustSin(source, target, damage, damage)
        endif
        if enemy and AltairSR.AltairSR_Blocks(target, source) then
            return LustSin(source, target, damage, damage)
        endif
        if h.swordToggle and damageType == 0 then
            set damage = damage*AltairSF_AttackTaken // AltairSF_AttackTaken = 0.9
            call h.AddStacks(-AltairSF_AttackCost) // AltairSF_AttackCost = 2
        endif
        return damage
    endfunction

    // ==================== ВХОДЫ ИЗ CastCheck.j ====================
    // Каждая функция: Altair_Register (состояние героя) -> <Способность>.<Способность>_Start.
    // false у SQ/SW/SE/SR/ST/R/T/W = каст не засчитан.
    function AltairQ_Start takes unit hero, real x, real y returns nothing
        call Altair_Register(hero)
        call AltairQ.AltairQ_Start(hero, x, y)
    endfunction

    function AltairW_Start takes unit hero, unit target returns boolean
        call Altair_Register(hero)
        return AltairW.AltairW_Start(hero, target)
    endfunction

    function AltairE_Start takes unit hero returns nothing
        call Altair_Register(hero)
        call AltairE.AltairE_Start(hero)
    endfunction

    function AltairR_Start takes unit hero, real x, real y returns boolean
        call Altair_Register(hero)
        if AltairR.AltairR_Start(hero, x, y) then
            return true
        endif
        call AltairHero.AltairHero_Get(hero).RefuseCast(AltairR_ID, "Factor Mimic: no decorations to copy here")
        return false
    endfunction

    function AltairT_Start takes unit hero, real x, real y returns boolean
        call Altair_Register(hero)
        return AltairT.AltairT_Start(hero, x, y)
    endfunction

    function AltairF_Start takes unit hero returns nothing
        call Altair_Register(hero)
        call AltairF.AltairF_Start(hero)
    endfunction

    // ---------- G: Meta Change (Holopsicon -> Sword Princess) ----------
    // Пока реалм T открыт — G только закрывает его: форма не меняется, КД G снимается, чтобы следующим
    // нажатием сменить форму. Иначе — смена формы:
    //   кнопки Sword Princess вместо Holopsicon (ApplyForm), КД G и SG = Altair_SwitchLock,
    //   вспышка + образ + белое кольцо, 12 мечей разлетаются кругом (AltairSword без урона), звук.
    function AltairG_Start takes unit hero returns nothing
        local AltairHero h
        local integer slot = 0
        local real x = GetUnitX(hero)
        local real y = GetUnitY(hero)
        call Altair_Register(hero)
        set h = AltairHero.AltairHero_Get(hero)
        if AltairT.AltairT_IsOpen(hero) then
            call AltairT.AltairT_CloseFor(hero)
            call h.RefundCooldown(AltairG_ID)
            return
        endif
        call h.ApplyForm(Altair_FormSword)
        call BlzStartUnitAbilityCooldown(hero, AltairG_ID, Altair_SwitchLock) // Altair_SwitchLock = 10
        call BlzStartUnitAbilityCooldown(hero, AltairSG_ID, Altair_SwitchLock) // Altair_SwitchLock = 10
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_blackblink.mdx", x, y, GetUnitFacing(hero), 1.0, 1.2, 0.0))
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_White.mdx", x, y, GetUnitFacing(hero), 1.0, 1.4, 0.0))
        call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_whitering.mdx", x, y, 0.0, 1.0, 0.5, 10.0, 0.3, 0.5, 2.5), 0.25, 255, 255, 255, 0.35)
        loop
            exitwhen slot >= AltairG_BurstBlades // AltairG_BurstBlades = 12
            call AltairSword.AltairSword_Throw(hero, x, y, 90.0, slot*2.0*bj_PI/AltairG_BurstBlades, 1200.0, 260.0, 0.0, 0.0, null)
            set slot = slot + 1
        endloop
        call SetUnitAnimation(hero, "spell")
        call MakeSound("war3mapImported\\Hero_Altair_G1")
    endfunction

    function AltairSQ_Start takes unit hero, real x, real y returns boolean
        call Altair_Register(hero)
        return AltairSQ.AltairSQ_Start(hero, x, y)
    endfunction

    function AltairSW_Start takes unit hero, real x, real y returns boolean
        call Altair_Register(hero)
        return AltairSW.AltairSW_Start(hero, x, y)
    endfunction

    function AltairSE_Start takes unit hero returns boolean
        call Altair_Register(hero)
        return AltairSE.AltairSE_Start(hero)
    endfunction

    function AltairSR_Start takes unit hero, real x, real y returns boolean
        call Altair_Register(hero)
        return AltairSR.AltairSR_Start(hero, x, y)
    endfunction

    function AltairST_Start takes unit hero returns boolean
        call Altair_Register(hero)
        return AltairST.AltairST_Start(hero)
    endfunction

    function AltairSF_Start takes unit hero returns nothing
        call Altair_Register(hero)
        call AltairSF.AltairSF_Start(hero)
    endfunction

    // ---------- SG: Meta Change (Sword Princess -> Holopsicon) ----------
    // Кнопки Holopsicon вместо Sword Princess (ApplyForm гасит и SF), КД G и SG = Altair_SwitchLock,
    // вспышка + образ + белое кольцо + круг на земле, звук.
    function AltairSG_Start takes unit hero returns nothing
        local AltairHero h
        local real x = GetUnitX(hero)
        local real y = GetUnitY(hero)
        call Altair_Register(hero)
        set h = AltairHero.AltairHero_Get(hero)
        call h.ApplyForm(Altair_FormHolopsicon)
        call BlzStartUnitAbilityCooldown(hero, AltairG_ID, Altair_SwitchLock) // Altair_SwitchLock = 10
        call BlzStartUnitAbilityCooldown(hero, AltairSG_ID, Altair_SwitchLock) // Altair_SwitchLock = 10
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_blackblink.mdx", x, y, GetUnitFacing(hero), 1.0, 1.2, 0.0))
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_White.mdx", x, y, GetUnitFacing(hero), 1.0, 1.4, 0.0))
        call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_whitering.mdx", x, y, 0.0, 1.0, 0.5, 10.0, 0.3, 0.5, 2.5), 0.25, 255, 255, 255, 0.35)
        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_yc_bluemorphcircle3.mdl", x, y, 0.0, 1.0, 1.2, 5.0), 0.25, 255, 255, 255, 0.35)
        call SetUnitAnimation(hero, "spell")
        call MakeSound("war3mapImported\\Hero_Altair_GG1")
    endfunction

    private function InitAltairSpells takes nothing returns nothing
        set AltairHoloAbility[0] = AltairQ_ID
        set AltairHoloAbility[1] = AltairW_ID
        set AltairHoloAbility[2] = AltairE_ID
        set AltairHoloAbility[3] = AltairR_ID
        set AltairHoloAbility[4] = AltairT_ID
        set AltairHoloAbility[5] = AltairF_ID
        set AltairHoloAbility[6] = AltairG_ID
        set AltairSwordAbility[0] = AltairSQ_ID
        set AltairSwordAbility[1] = AltairSW_ID
        set AltairSwordAbility[2] = AltairSE_ID
        set AltairSwordAbility[3] = AltairSR_ID
        set AltairSwordAbility[4] = AltairST_ID
        set AltairSwordAbility[5] = AltairSF_ID
        set AltairSwordAbility[6] = AltairSG_ID
        // R по уровню: сколько копий / до какого класса (1 мелочь, 2 машины/деревья, 3 небольшие здания, 4 всё).
        set AltairR_MaxCopies[1] = 3
        set AltairR_MaxCopies[2] = 4
        set AltairR_MaxCopies[3] = 5
        set AltairR_MaxCopies[4] = 6
        set AltairR_MaxCopies[5] = 7
        set AltairR_MaxClass[1] = 1
        set AltairR_MaxClass[2] = 2
        set AltairR_MaxClass[3] = 3
        set AltairR_MaxClass[4] = 3
        set AltairR_MaxClass[5] = 4
        // R по уровню: урон касанием x Int.
        set AltairR_ContactInt[1] = 2.5
        set AltairR_ContactInt[2] = 3.0
        set AltairR_ContactInt[3] = 3.5
        set AltairR_ContactInt[4] = 4.0
        set AltairR_ContactInt[5] = 4.5
        // R по классу декора 1..5: урон взрыва (+ Int), радиус взрыва, ширина пути, стан.
        set AltairR_ClassDamage[1] = 100.0
        set AltairR_ClassDamage[2] = 200.0
        set AltairR_ClassDamage[3] = 200.0
        set AltairR_ClassDamage[4] = 400.0
        set AltairR_ClassDamage[5] = 600.0
        set AltairR_ClassAoe[1] = 200.0
        set AltairR_ClassAoe[2] = 260.0
        set AltairR_ClassAoe[3] = 320.0
        set AltairR_ClassAoe[4] = 400.0
        set AltairR_ClassAoe[5] = 500.0
        set AltairR_ClassWidth[1] = 120.0
        set AltairR_ClassWidth[2] = 170.0
        set AltairR_ClassWidth[3] = 240.0
        set AltairR_ClassWidth[4] = 320.0
        set AltairR_ClassWidth[5] = 360.0
        set AltairR_ClassStun[1] = 0.3
        set AltairR_ClassStun[2] = 0.4
        set AltairR_ClassStun[3] = 0.5
        set AltairR_ClassStun[4] = 0.7
        set AltairR_ClassStun[5] = 1.0
        // Копируемый декор (модели/размеры как в object-data; B016/B017/B018 исключены), класс 1-4.
        call AltairDecor('B000', "land_wos\\000_Trees1.mdl", 3.0, 2)
        call AltairDecor('B001', "land_wos\\Wood Fence 1.mdl", 3.2, 1)
        call AltairDecor('B002', "land_wos\\Wood Fence 2.mdl", 3.2, 1)
        call AltairDecor('B003', "land_wos\\ironfencec1_2.mdl", 1.25, 1)
        call AltairDecor('B004', "land_wos\\ironfencec1_1.mdl", 1.25, 1)
        call AltairDecor('B005', "land_wos\\naruto_house1-1.mdl", 1.25, 3)
        call AltairDecor('B006', "land_wos\\ironfencec.mdl", 2.0, 1)
        call AltairDecor('B007', "land_wos\\000_Trees2.mdl", 3.0, 2)
        call AltairDecor('B008', "land_wos\\Pack Targets 1.mdl", 0.8, 1)
        call AltairDecor('B009', "land_wos\\000_Trees3.mdl", 3.0, 2)
        call AltairDecor('B00A', "land_wos\\Poneglyph.mdl", 0.85, 2)
        call AltairDecor('B00B', "land_wos\\naruto_house2.mdl", 1.25, 3)
        call AltairDecor('B00C', "land_wos\\naruto_house3.mdl", 1.25, 3)
        call AltairDecor('B00D', "land_wos\\naruto_house5-1.mdl", 1.5, 4)
        call AltairDecor('B00E', "land_wos\\naruto_house5-2.mdl", 1.5, 4)
        call AltairDecor('B00F', "land_wos\\000_Trees0.mdl", 3.0, 2)
        call AltairDecor('B00G', "land_wos\\Wood Fence 4.mdl", 3.2, 1)
        call AltairDecor('B00H', "land_wos\\Wood Fence 3.mdl", 3.2, 1)
        call AltairDecor('B00I', "land_wos\\biwutai.mdl", 3.0, 3)
        call AltairDecor('B00J', "land_wos\\city_abandonedbuilding_11.mdl", 5.0, 4)
        call AltairDecor('B00K', "land_wos\\city_abandonedbuilding_13.mdl", 5.0, 4)
        call AltairDecor('B00L', "land_wos\\city_abandonedbuilding_15.mdl", 4.5, 4)
        call AltairDecor('B00M', "land_wos\\city_abandonedbuilding_17.mdl", 9.0, 4)
        call AltairDecor('B00N', "land_wos\\city_abandonedbuilding_15_01.mdl", 4.5, 4)
        call AltairDecor('B00O', "land_wos\\Barrel Explosive.mdl", 2.0, 1)
        call AltairDecor('B00P', "land_wos\\Barrel.mdl", 2.0, 1)
        call AltairDecor('B00Q', "land_wos\\Opdef17 (450).mdl", 2.4, 3)
        call AltairDecor('B00R', "land_wos\\Pirate island house.mdl", 0.75, 3)
        call AltairDecor('B00S', "land_wos\\ZS-798.mdl", 1.0, 1)
        call AltairDecor('B00T', "land_wos\\ZS-804.mdl", 1.5, 1)
        call AltairDecor('B00U', "land_wos\\DBObox2.mdl", 0.5, 1)
        call AltairDecor('B00V', "land_wos\\DBORRbox.mdl", 0.8, 1)
        call AltairDecor('B00W', "land_wos\\ArcheryRange.mdl", 2.0, 1)
        call AltairDecor('B00X', "land_wos\\ZS-797.mdl", 1.25, 1)
        call AltairDecor('B00Y', "land_wos\\ZS-796.mdl", 1.25, 1)
        call AltairDecor('B00Z', "land_wos\\plastic table.mdl", 1.0, 1)
        call AltairDecor('B010', "land_wos\\plastic chair.mdl", 0.95, 1)
        call AltairDecor('B011', "land_wos\\huachi1.mdl", 1.25, 1)
        call AltairDecor('B012', "land_wos\\huachi4.mdl", 1.1, 1)
        call AltairDecor('B013', "land_wos\\File00006677.mdl", 1.5, 1)
        call AltairDecor('B014', "land_wos\\ZS-129.mdl", 1.5, 2)
        call AltairDecor('B015', "war3mapImported\\wos_Model Thomas.mdl", 1.0, 4)
        call AltairDecor('B019', "war3mapImported\\wos_jiejin.mdl", 0.55, 1)
        call AltairDecor('B01A', "war3mapImported\\Wos_InoriCrystall.mdl", 0.55, 1)
        call AltairDecor('B01B', "land_wos\\city_abandonedbuilding_15_02.mdl", 4.5, 4)
        // Реалм T строится после таблицы декора (берёт из неё случайный мелкий декор).
        call AltairT_BuildRealm()
    endfunction
endlibrary
