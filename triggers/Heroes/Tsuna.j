library TsunaSpells uses GearSystems
    globals
//--------------------------------------Tsuna Core---------------------------------------------------------
        integer Tsuna_ID = 'H01D'
        integer Tsuna2_ID = 'H01F'

//---------------Q ability (Базовая: Shinuki no Dash)---------------------------
        integer TsunaQ_ID = 'A082'
        real TsunaQ_DamageAgiBase = 1.0
        real TsunaQ_DamageAgiStep = 1.0
        real TsunaQ_DamageStaticBase = 175.0
        real TsunaQ_DamageStaticStep = 0.0
        real TsunaQ_DamageAoe = 155.0
        real TsunaQ_Range = 1000.0
        real TsunaQ_DashSpeed = 90.0
        real TsunaWQ_AddRange = 200.0                // Бонус к дистанции при активном баффе W
        real TsunaQ_PushRange = 350.0
        real TsunaQ_PushDuration = 0.3
        real TsunaQ_DecorDamage = 20.0               // Урон по декорациям при рывке

//---------------Q2 ability (Vongola Gear: Mitena di Vongola Primo)------------
        integer TsunaQ2_ID = 'A08C'
        real TsunaQ2_DamageAgiBase = 5.0             // Урон первого удара (Agility x)
        real TsunaQ2_DamageAgiStep = 0.0
        real TsunaQ2_DamageStaticBase = 175.0
        real TsunaQ2_DamageStaticStep = 0.0
        real TsunaQ2_DamageAoe = 155.0
        real TsunaQ2_Range = 1350.0
        real TsunaQ2_DashSpeed = 125.0
        real TsunaQ2_PushRange = 525.0               // 350 * 1.5
        real TsunaQ2_PushDuration = 0.3
        real TsunaQ2_ExplosionAgiBase = 2.0          // Магический урон взрыва снаряда
        real TsunaQ2_ExplosionAoe = 235.0            // Начальный радиус летящего снаряда
        real TsunaQ2_ExplosionAoeFinal = 520.0       // Финальный радиус взрыва снаряда
        real TsunaQ2_MissileRange = 2200.0           // Максимальная дистанция полета шара
        real TsunaQ2_MissileSpeed = 100.0            // Скорость полета шара
        real TsunaQ2_DecorDamage = 20.0              // Урон по декорациям при рывке
        real TsunaQ2_MissileDecorDamage = 40.0       // Урон по декорациям в полете шара
        real TsunaQ2_ExplosionDecorDamage = 50.0     // Урон по декорациям при финальном взрыве

//---------------W ability (Zero Point Breakthrough)---------------------------
        integer TsunaW_ID = 'A083'
        integer TsunaW_Buff_ID = 'B00V'
        real TsunaW_DamageAgiBase = 0.4              // Доп. урон атак под W (Agility x)
        real TsunaW_DamageAgiStep = 0.2              // Прирост урона атак за уровень
        real TsunaW_Damage2StaticBase = 50.0         // Базовый статик урона атак под W
        real TsunaW_Damage2StaticStep = 0.0          // Прирост статика атак за уровень
        real TsunaW_BuffDuration = 8.0               // Длительность стойки / баффа W
        real TsunaW_Root = 0.25                      // Рут от первого каста стойки

//---------------W2 ability (Удар из стойки W)---------------------------------
        integer TsunaW2_ID = 'A084'
        real TsunaW2_DamageAgiBase = 1.0
        real TsunaW2_DamageAgiStep = 1.0
        real TsunaW2_Damage2StaticBase = 150.0
        real TsunaW2_Damage2StaticStep = 0.0
        real TsunaW2_Root = 1.0                      // Длительность обездвиживания врагов волной
        real TsunaW_DamageAoe = 325.0                // Начальный радиус волны
        real TsunaW_DamageAoeAdd = 110.0             // Прирост радиуса за каждую волну (5 волн)
        real TsunaW2_DecorDamage = 20.0              // Урон по декорациям от ударной волны

//---------------W3 ability (Vongola Gear: Double Axle)------------------------
        integer TsunaW3_ID = 'A08D'
        real TsunaW3_DamageAgiBase = 6.0
        real TsunaW3_Range = 2300.0                  // Дальность полета сфер
        real TsunaW3_Speed = 70.0                    // Скорость полета сфер
        real TsunaW3_DamageAoe = 200.0               // Радиус урона по пути полета
        real TsunaW3_DamageAoeFinal = 500.0          // Радиус финального взрыва
        real TsunaW3_CastTime = 0.45                 // Время подготовки до запуска сфер
        real TsunaW3_DecorDamage = 40.0              // Урон по декорациям в полете сфер
        real TsunaW3_ExplosionDecorDamage = 100.0    // Урон по декорациям при взрыве

//---------------E ability (Burning Axle)--------------------------------------
        integer TsunaE_ID = 'A085'
        real TsunaE_DamageAgiBase = 2.0
        real TsunaE_DamageAgiStep = 1.0
        real TsunaE_RangeBase = 1600.0
        real TsunaE_RangeAdd = 140.0
        real TsunaE_DamageAoe = 235.0                // Радиус летящей сферы
        real TsunaE_DamageAoeFinal = 520.0           // Радиус взрыва при столкновении
        real TsunaE_CastTime = 0.45                  // Время подготовки до выстрела
        real TsunaE_Speed = 80.0                     // Скорость снаряда
        real TsunaE_DecorDamage = 40.0               // Урон по декорациям в полете
        real TsunaE_ExplosionDecorDamage = 50.0      // Урон по декорациям при взрыве

//---------------E2 ability (Vongola Gear: Condensed Flame Cannon)--------------
        integer TsunaE2_ID = 'A08E'
        real TsunaE2_DamageAgiBase = 7.0
        real TsunaE2_Range = 2540.0                  // Полная длина луча
        real TsunaE2_DamageAoe = 200.0               // Ширина зоны поражения
        real TsunaE2_CastTime = 0.90                 // Задержка перед залпом
        real TsunaE2_StunDuration = 1.25             // Длительность оглушения
        real TsunaE2_DecorDamage = 100.0             // Урон по декорациям лучом

//---------------R ability (Flame Rush)----------------------------------------
        integer TsunaR_ID = 'A086'
        real TsunaR_DamageAgiBase = 4.0
        real TsunaR_DamageAgiStep = 1.0
        real TsunaR_DashMaxDuration = 2.4            // Максимальное время на сближение с целью
        real TsunaR_Duration = 1.2                   // Длительность атаки / вращения вокруг цели
        integer TsunaR_Ticks = 6                     // Делитель и количество тиков урона
        integer TsunaR_Slow = 65                     // Процент замедления
        integer TsunaR_SlowDuration = 2              // Длительность замедления
        real TsunaR_DashSpeed = 90.0                 // Скорость сближения с целью

//---------------R2 ability (Vongola Gear: Ultimate Rush)-----------------------
        integer TsunaR2_ID = 'A08F'
        real TsunaR2_DamageAgiBase = 9.0
        real TsunaR2_DashMaxDuration = 3.3           // Максимальное время на сближение с точкой
        real TsunaR2_Duration = 1.2                  // Длительность атаки / вращения вокруг точки
        integer TsunaR2_Ticks = 6                    // Делитель и количество тиков урона
        integer TsunaR2_Slow = 65
        integer TsunaR2_SlowDuration = 2
        real TsunaR2_Aoe = 650.0                     // Зона поражения вокруг точки
        real TsunaR2_DashSpeed = 90.0                // Скорость сближения
        real TsunaR2_PullRange = 45.0                // Дистанция притягивания врагов
        real TsunaR2_PullDuration = 0.3              // Длительность подтягивания

//---------------T ability (X-Burner)------------------------------------------
        integer TsunaT_ID = 'A087'
        integer TsunaT2_ID = 'A088'                  // Абилка-свап для досрочного запуска
        real TsunaT_DamageAgiBase = 12.0
        real TsunaT_Duration = 2.0
        integer TsunaT_Ticks = 8                    // Количество тиков урона
        real TsunaT_DamageAoe = 465.0
        integer TsunaT_Slow = 70
        integer TsunaT_SlowDuration = 2
        real TsunaT_Root = 0.0
        real TsunaT_SilenceDuration = 0.0
        real TsunaT_ChargeTimeFull = 1.20            // Полное время зарядки до 100% (сек)
        real TsunaT_OverchargeTime = 4.00            // Время удержания до перегрузки на Lv. 35 (сек)
        real TsunaT_OverchargeDmgPct = 125.0         // Процент урона при перегрузке на Lv. 35 (%)
        real TsunaT_TurnSpeed = 1.20                 // Скорость поворота луча мышкой (градусов/тик)
        real TsunaT_DecorDamage = 100.0              // Урон по декорациям лучом

//---------------T3 ability (Vongola Gear: XX-Burner)--------------------------
        integer TsunaT3_ID = 'A08G'
        real TsunaT2_DamageAgiBase = 14.0
        real TsunaT2_DamageAoe = 980.0
        real TsunaT2_Root = 0.0
        integer TsunaT2_Slow = 80
        integer TsunaT2_SlowDuration = 3
        real TsunaT2_SilenceDuration = 0.5

//---------------F ability (Hyper Intuition)-----------------------------------
        integer TsunaF_ID = 'A089'
        real TsunaF_Aoe = 650.0                      // Радиус проверки врагов для уклонения
        real TsunaF_Chance12 = 10.0                  // Базовый шанс уклонения на Lv. 1-24 (%)
        real TsunaF_Chance25 = 15.0                  // Базовый шанс уклонения на Lv. 25-34 (%)
        real TsunaF_Chance35 = 20.0                  // Базовый шанс уклонения на Lv. 35+ (%)
        real TsunaF_CD12 = 20.0                      // Кулдаун уклонения на Lv. 1-24
        real TsunaF_CD25 = 18.0                      // Кулдаун уклонения на Lv. 25-34
        real TsunaF_CD35 = 16.0                      // Кулдаун уклонения на Lv. 35+
        real TsunaF_SkillSuccessfulAtkBonusAdd = 10.0// Бонус к шансу за попадание скиллом (%)
        real TsunaF_StackDuration = 20.0             // Время жизни боевых зарядов F (сек)
        real TsunaF_DodgeDistance = 250.0            // Дистанция отскока при уклонении
        real TsunaF_DodgeDuration = 0.15             // Длительность отскока

//---------------G ability (Zero Point Breakthrough: First Edition)-------------
        integer TsunaG_ID = 'A08A'
        integer TsunaG_Stat_ID1 = 'A08I'
        integer TsunaG_Stat_ID2 = 'A08K'
        integer TsunaG_Stat_ID3 = 'A08J'
        real TsunaG_Duration = 3.0                   // Время поглощения урона
        real TsunaG_StatsRemoveSec = 10.0            // Время жизни полученных статов
        real TsunaG_DamagetoMana = 20.0              // Конвертация поглощенного урона в ману (%)
        real TsunaG_DamagetoStats1 = 1000.0          // Порог поглощения 1
        real TsunaG_DamagetoF_Chance1 = 10.0         // Добавочный шанс интуиции от порога 1
        real TsunaG_DamagetoStats2 = 2000.0          // Порог поглощения 2 (Lv. 25)
        real TsunaG_DamagetoF_Chance2 = 10.0         // Добавочный шанс интуиции от порога 2
        real TsunaG_DamagetoStats3 = 3250.0          // Порог поглощения 3 (Lv. 35) -> Открывает форму
        real TsunaG_DamagetoF_Chance3 = 10.0         // Добавочный шанс интуиции от порога 3

//---------------G2 ability (Vongola Gear: Awakening Form)---------------------
        integer TsunaG2_ID = 'A08B'
        real TsunaG2_Duration = 20.0                 // Длительность формы
        real TsunaG2_ReduceCD = 15.0                 // Снижение текущих кулдаунов при входе
        real TsunaG2_TimeToEnter = 10.0              // Окно времени для активации формы
        real TsunaG2_CastTime = 1.02                 // Время до получения контроля в форме (сек)
        real TsunaG2_TransformDecorAoe = 800.0       // Радиус разрушения декораций при трансформации
        real TsunaG2_TransformDecorDamage = 50.0     // Сила разрушения декораций

//---------------G3 ability (Oath Flame Barrier)-------------------------------
        integer TsunaG3_ID = 'A08H'
        integer TsunaG3_Unit_ID = 'h01E'
        integer TsunaG3_Buff_ID = 'B00W'
        real TsunaG3_DamageAoe = 550.0
        // Отдельный служебный юнит для каждого игрока: общий handle приводил
        // к взаимному удалению юнитов при нескольких Tsuna и к утечкам при повторном F.
        unit array TsunaG3_Unit
        real TsunaG3_Duration = 3.0                  // Длительность защитного купола
        real TsunaG3_StunDuration = 1.0              // Оглушение врагов при взрыве купола
        real TsunaG3_DecorDamage = 50.0              // Урон по декорациям при взрыве купола
    endglobals

    private function TsundaFStackAdd takes unit c, integer i returns nothing
        if i == 1 then
            if LoadInteger(hs, GetHandleId(c), StringHash("instinct q")) == 0 then
                call SaveInteger(hs, GetHandleId(c), StringHash("instinct q"), 1)
                call MyFlush2(c, StringHash("instinct q"), 0, TsunaF_StackDuration, false)
            endif
        elseif i == 2 then
            if LoadInteger(hs, GetHandleId(c), StringHash("instinct w")) == 0 then
                call SaveInteger(hs, GetHandleId(c), StringHash("instinct w"), 1)
                call MyFlush2(c, StringHash("instinct w"), 0, TsunaF_StackDuration, false)
            endif
        elseif i == 3 then
            if LoadInteger(hs, GetHandleId(c), StringHash("instinct e")) == 0 then
                call SaveInteger(hs, GetHandleId(c), StringHash("instinct e"), 1)
                call MyFlush2(c, StringHash("instinct e"), 0, TsunaF_StackDuration, false)
            endif
        elseif i == 4 then
            if LoadInteger(hs, GetHandleId(c), StringHash("instinct r")) == 0 then
                call SaveInteger(hs, GetHandleId(c), StringHash("instinct r"), 1)
                call MyFlush2(c, StringHash("instinct r"), 0, TsunaF_StackDuration, false)
            endif
        elseif i == 5 then
            if LoadInteger(hs, GetHandleId(c), StringHash("instinct t")) == 0 then
                call SaveInteger(hs, GetHandleId(c), StringHash("instinct t"), 1)
                call MyFlush2(c, StringHash("instinct t"), 0, TsunaF_StackDuration, false)
            endif
        elseif i == 6 then
            if LoadInteger(hs, GetHandleId(c), StringHash("instinct g1")) == 0 then
                call SaveInteger(hs, GetHandleId(c), StringHash("instinct g1"), 1)
                call MyFlush2(c, StringHash("instinct g1"), 0, TsunaF_StackDuration, false)
            endif
        elseif i == 7 then
            if LoadInteger(hs, GetHandleId(c), StringHash("instinct g2")) == 0 then
                call SaveInteger(hs, GetHandleId(c), StringHash("instinct g2"), 1)
                call MyFlush2(c, StringHash("instinct g2"), 0, TsunaF_StackDuration, false)
            endif
        elseif i == 8 then
            if LoadInteger(hs, GetHandleId(c), StringHash("instinct g3")) == 0 then
                call SaveInteger(hs, GetHandleId(c), StringHash("instinct g3"), 1)
                call MyFlush2(c, StringHash("instinct g3"), 0, TsunaF_StackDuration, false)
            endif
        elseif i == 9 then
            if LoadInteger(hs, GetHandleId(c), StringHash("instinct g4")) == 0 then
                call SaveInteger(hs, GetHandleId(c), StringHash("instinct g4"), 1)
                call MyFlush2(c, StringHash("instinct g4"), 0, TsunaF_StackDuration, false)
            endif
        endif
    endfunction

    private struct TsunaQKS
        private static timer t_TsunaQ = CreateTimer()
        private static integer array m_TsunaQ
        private static integer MUI_TsunaQ = -1
        unit c
        unit td
        real x
        real y
        real r2
        real r5
        real r7
        group g
        group g2
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real move
        real r
        real a
        real rmax
        
        private static method Loop_TsunaQ takes nothing returns nothing
            local integer this
            local integer i = 0
            local real r6 = 90
            loop
                exitwhen i > MUI_TsunaQ
                set this = m_TsunaQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    if check == 0 then
                        if r > 0.21 then
                            if r5 <= r7 then
                                set r5 = r5 + move
                                call MoveUnit(c, move, a)
                                call SetUnitFacing(c, a * bj_RADTODEG)
                                call GroupClear(g)
                                call DecorRemove(c, GetUnitX(c), GetUnitY(c), aoe, TsunaQ_DecorDamage)
                                
                                if GetUnitAbilityLevel(c, TsunaW_Buff_ID) > 0 then
                                    call GroupEnumUnitsInRange(g, GetUnitX(c), GetUnitY(c), aoe + 25, NoDecor_Cond)
                                    loop
                                        set u = FirstOfGroup(g)
                                        exitwhen u == null
                                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                            call GroupAddUnit(g2, u)
                                            call dmgatk(c, u, dmg)
                                            set check2 = check2 + 1
                                        endif
                                        call GroupRemoveUnit(g, u)
                                    endloop
                                else
                                    call GroupEnumUnitsInRange(g, GetUnitX(c), GetUnitY(c), aoe + 25, NoDecor_Cond)
                                    loop
                                        set u = FirstOfGroup(g)
                                        exitwhen u == null or check == 1
                                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                            set check = 1
                                            set td = u
                                            set r = 0
                                            call SetUnitPosition(td, GetUnitX(c) + 110 * Cos(a), GetUnitY(c) + 110 * Sin(a))
                                            call SetUnitAnimationByIndex(c, 3)
                                        endif
                                        call GroupRemoveUnit(g, u)
                                    endloop
                                endif
                                
                                call EffectSpawn2("war3mapImported\\wos_az_wsy_gather3.mdl", GetUnitX(c) + r6 * Cos(a + 90 * bj_DEGTORAD), GetUnitY(c) + r6 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG, 2, 1.25, 91, 0.09)
                                call EffectSpawn2("war3mapImported\\wos_az_wsy_gather3.mdl", GetUnitX(c) + r6 * Cos(a - 90 * bj_DEGTORAD), GetUnitY(c) + r6 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG, 2, 1.25, 91, 0.09)
                                call EffectSpawn2("war3mapImported\\wos_az_wsy_gather3.mdl", (GetUnitX(c) + r6 * Cos(a + 90 * bj_DEGTORAD)) + (move / 2) * Cos(a), (GetUnitY(c) + r6 * Sin(a + 90 * bj_DEGTORAD)) + (move / 2) * Sin(a), a * bj_RADTODEG, 2, 1.25, 91, 0.09)
                                call EffectSpawn2("war3mapImported\\wos_az_wsy_gather3.mdl", (GetUnitX(c) + r6 * Cos(a - 90 * bj_DEGTORAD)) + (move / 2) * Cos(a), (GetUnitY(c) + r6 * Sin(a - 90 * bj_DEGTORAD)) + (move / 2) * Sin(a), a * bj_RADTODEG, 2, 1.25, 91, 0.09)
                                
                                if r2 > 0.03 then
                                    set r2 = 0
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 87))
                                else
                                    set r2 = r2 + 0.03
                                endif
                            else
                                set r = 9999
                            endif
                        endif
                    elseif check == 1 then
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        if r == 0.03 then
                            call MakeSound("war3mapimported\\Hero_Tsuna_Q5")
                        endif
                        if r == 0.3 then
                            call dmgatk(c, td, dmg)
                            call TsundaFStackAdd(c, 1)
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x, y, a * bj_RADTODEG, 1, 2.25, 125))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BDEF (124)2.mdx", x, y, GetRandomReal(0, 359), 1, 2.5, 125))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_bbb.mdl", x, y, a * bj_RADTODEG, 1.5, 0.85, 125))
                            call EUTU2_3(EffectSpawn("war3mapimported\\wos_1daji_4.mdl", x, y, GetRandomReal(0, 359), 0.8, 3, 0), 1, 15, td)
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                            call MUE(td, TsunaQ_PushRange, TsunaQ_PushDuration, a)
                            set r = 9999
                        endif
                    endif
                else
                    if check2 > 0 then
                        call TsundaFStackAdd(c, 1)
                    endif
                    call StopSpellUnit2(c)
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set td = null
                    set u = null
                    set m_TsunaQ[i] = m_TsunaQ[MUI_TsunaQ]
                    set MUI_TsunaQ = MUI_TsunaQ - 1
                    if MUI_TsunaQ == -1 then
                        call PauseTimer(t_TsunaQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        
        public static method TsunaQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_TsunaQ = MUI_TsunaQ + 1
            set m_TsunaQ[MUI_TsunaQ] = this
            set c = NewC
            set td = null
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set r5 = 0
            set r7 = TsunaQ_Range
            if GetUnitAbilityLevel(c, TsunaW_Buff_ID) > 0 then
                set r7 = r7 + TsunaWQ_AddRange
            endif
            set check = 0
            set move = TsunaQ_DashSpeed
            set check2 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set a = GAngle2(c, x, y)
            set aoe = TsunaQ_DamageAoe
            set dmg = GetHeroAgi(c, true) * (TsunaQ_DamageAgiBase + (TsunaQ_DamageAgiStep * (GetUnitAbilityLevel(c, TsunaQ_ID) - 1)))
            set dmg = dmg + TsunaQ_DamageStaticBase + (TsunaQ_DamageStaticStep * (GetUnitAbilityLevel(c, TsunaQ_ID) - 1))
            set rmax = 2.1
            
            call SetUnitAnimationByIndex(c, 8)
            call MakeSound("war3mapimported\\Hero_Tsuna_Q")
            if GetRandomInt(1, 3) == 1 then
                call MakeSound("war3mapimported\\Hero_Tsuna_Q2 1")
            elseif GetRandomInt(1, 3) == 2 then
                call MakeSound("war3mapimported\\Hero_Tsuna_Q2 2")
            else
                call MakeSound("war3mapimported\\Hero_Tsuna_Q2 3")
            endif
            
            if MUI_TsunaQ == 0 then
                call TimerStart(t_TsunaQ, 0.03, true, function thistype.Loop_TsunaQ)
            endif
        endmethod
    endstruct
        
    private struct TsunaQ2KS
        private static timer t_TsunaQ2 = CreateTimer()
        private static integer array m_TsunaQ2
        private static integer MUI_TsunaQ2 = -1
        unit c
        unit td
        real x
        real y
        real r5
        real r7
        group g
        group g2
        unit u
        real dmg
        real dmg2
        real scale
        integer check
        integer check2
        real aoe
        real move
        real r
        real a
        real rmax
        effect e
        
        private static method Loop_TsunaQ2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real r6 = 90
            loop
                exitwhen i > MUI_TsunaQ2
                set this = m_TsunaQ2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if check == 0 then
                        if r > 0.21 then
                            if r5 <= r7 then
                                set r5 = r5 + move
                                call MoveUnit(c, move, a)
                                call SetUnitFacing(c, a * bj_RADTODEG)
                                call GroupClear(g)
                                call DecorRemove(c, GetUnitX(c), GetUnitY(c), aoe, TsunaQ2_DecorDamage)
                                
                                call GroupEnumUnitsInRange(g, GetUnitX(c), GetUnitY(c), aoe + 25, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null or check == 1
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                        set check = 1
                                        set td = u
                                        set r = 0
                                        call SetUnitPosition(td, GetUnitX(c) + 110 * Cos(a), GetUnitY(c) + 110 * Sin(a))
                                        call SetUnitTimeScale(c, 1)
                                        call SetUnitAnimationByIndex(c, 5)
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                
                                call EffectSpawn2("war3mapImported\\wos_az_wsy_gather4.mdl", GetUnitX(c) + r6 * Cos(a + 90 * bj_DEGTORAD), GetUnitY(c) + r6 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG, 2, 1.25, 91, 0.09)
                                call EffectSpawn2("war3mapImported\\wos_az_wsy_gather4.mdl", GetUnitX(c) + r6 * Cos(a - 90 * bj_DEGTORAD), GetUnitY(c) + r6 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG, 2, 1.25, 91, 0.09)
                                call EffectSpawn2("war3mapImported\\wos_az_wsy_gather4.mdl", (GetUnitX(c) + r6 * Cos(a + 90 * bj_DEGTORAD)) + (move / 2) * Cos(a), (GetUnitY(c) + r6 * Sin(a + 90 * bj_DEGTORAD)) + (move / 2) * Sin(a), a * bj_RADTODEG, 2, 1.25, 91, 0.09)
                                call EffectSpawn2("war3mapImported\\wos_az_wsy_gather4.mdl", (GetUnitX(c) + r6 * Cos(a - 90 * bj_DEGTORAD)) + (move / 2) * Cos(a), (GetUnitY(c) + r6 * Sin(a - 90 * bj_DEGTORAD)) + (move / 2) * Sin(a), a * bj_RADTODEG, 2, 1.25, 91, 0.09)
                            else
                                set r = 9999
                            endif
                        endif
                    elseif check == 1 then
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        if r == 0.03 then
                            set rmax = 2.4
                            call MakeSound("war3mapimported\\Hero_Tsuna_TQ 3")
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call BlinkEff(c)
                            call EUTU2(EffectSpawn("war3mapImported\\wos_az_wsy_gather3.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 2, 90), 0.3, 90, c)
                            call PosUnit(c, x + 150 * Cos(a), y + 150 * Sin(a))
                            set a = GAngle(c, td)
                        endif
                        
                        if r == 0.3 then
                            call dmgatk(c, td, dmg)
                            call TsundaFStackAdd(c, 1)
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x, y, a * bj_RADTODEG, 1, 2.25, 125))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BDEF (124)2.mdx", x, y, GetRandomReal(0, 359), 1, 2.5, 125))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_bbb.mdl", x, y, a * bj_RADTODEG, 1.5, 0.85, 125))
                            call EUTU2_3(EffectSpawn("war3mapimported\\wos_1daji_4.mdl", x, y, GetRandomReal(0, 359), 0.8, 3, 0), 1, 15, td)
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                            
                            call StartSpellUnit(c)
                            call SetUnitAnimationByIndex(c, 0)
                            set e = AddSpecialEffectTarget("war3mapImported\\wos_summon3missle.mdl", c, "hand left")
                            set check2 = 0
                            set r5 = 0
                            set move = TsunaQ2_MissileSpeed
                            set a = GAngle(c, td)
                            call MUE(td, TsunaQ2_PushRange, TsunaQ2_PushDuration, a)
                        endif
                        
                        if r == 0.75 then
                            call DestroyEffect(e)
                            set e = null
                            set a = GAngle(c, td)
                            set aoe = TsunaQ2_ExplosionAoe
                            call MakeSound("war3mapimported\\Hero_Tsuna_E2")
                            call StopSpellUnit(c)
                            set scale = 3
                            set e = EffectSpawn("war3mapImported\\wos_summon3missle.mdl", GetUnitX(c) + 110 * Cos(a), GetUnitY(c) + 110 * Sin(a), a * bj_RADTODEG, 1, scale, 100)
                        endif
                        
                        if r > 0.75 then
                            if r5 < TsunaQ2_MissileRange then
                                set r5 = r5 + move
                            else
                                set r = 1.5
                            endif
                            if scale < 7 then
                                set scale = scale + 0.36
                            endif
                            call MoveEff(e, move, a)
                            
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            call VisionTimed(GetOwningPlayer(c), x, y, aoe, 1)
                            call DecorRemove(c, x, y, aoe, TsunaQ2_MissileDecorDamage)
                            call BlzSetSpecialEffectScale(e, scale)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null or r == 1.5
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                    set r = 1.5
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            
                            if r == 1.5 then
                                set x = GetEffX(e)
                                set y = GetEffY(e)
                                set aoe = TsunaQ2_ExplosionAoeFinal
                                call VisionTimed(GetOwningPlayer(c), x, y, aoe, 1)
                                call DecorRemove(c, x, y, aoe, TsunaQ2_ExplosionDecorDamage)
                                call MakeSound("war3mapimported\\Hero_Tsuna_E3")
                                call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_1.mdl", x, y, GetRandomReal(0, 359), 1, 1.25, 1, 0.6)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl", x, y, GetRandomReal(0, 359), 1, 1.05, 1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdl", x, y, GetRandomReal(0, 359), 1, 1.85, 1))
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                        set check2 = check2 + 1
                                        call dmgmag(c, u, dmg2)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                call DestroyEffect(e)
                                set e = null
                                call SetUnitTimeScale(c, 1)
                                set r = 9999
                            endif
                        endif
                    endif
                else
                    if check == 0 then
                        call StopSpellUnit2(c)
                    elseif check == 1 and r < 0.75 then
                        call StopSpellUnit(c)
                    endif
                    call SetUnitTimeScale(c, 1)
                    if e != null then
                        call DestroyEffect(e)
                        set e = null
                    endif
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set td = null
                    set u = null
                    set m_TsunaQ2[i] = m_TsunaQ2[MUI_TsunaQ2]
                    set MUI_TsunaQ2 = MUI_TsunaQ2 - 1
                    if MUI_TsunaQ2 == -1 then
                        call PauseTimer(t_TsunaQ2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        
        public static method TsunaQ2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_TsunaQ2 = MUI_TsunaQ2 + 1
            set m_TsunaQ2[MUI_TsunaQ2] = this
            set c = NewC
            set td = null
            set x = NewX
            set y = NewY
            set r = 0
            set r5 = 0
            set r7 = TsunaQ2_Range
            set check = 0
            set move = TsunaQ2_DashSpeed
            set check2 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set a = GAngle2(c, x, y)
            set aoe = TsunaQ2_DamageAoe
            set dmg = GetHeroAgi(c, true) * (TsunaQ2_DamageAgiBase + (TsunaQ2_DamageAgiStep * (GetUnitAbilityLevel(c, TsunaQ2_ID) - 1)))
            set dmg = dmg + TsunaQ2_DamageStaticBase + (TsunaQ2_DamageStaticStep * (GetUnitAbilityLevel(c, TsunaQ2_ID) - 1))
            set dmg2 = TsunaQ2_ExplosionAgiBase * GetHeroAgi(c, true)
            set rmax = 2.1
            
            call SetUnitAnimationByIndex(c, 10)
            call SetUnitTimeScale(c, 0.01)
            call MakeSound("war3mapimported\\Hero_Tsuna_TQ")
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_Tsuna_TQ2 1")
            else
                call MakeSound("war3mapimported\\Hero_Tsuna_TQ2 2")
            endif
            
            if MUI_TsunaQ2 == 0 then
                call TimerStart(t_TsunaQ2, 0.03, true, function thistype.Loop_TsunaQ2)
            endif
        endmethod
    endstruct
        
    private struct TsunaWKS
        private static timer t_TsunaW = CreateTimer( )
        private static integer array m_TsunaW
        private static integer MUI_TsunaW = -1
        unit c
        real x
        real y
        real r2
        integer k
        integer k2
        real r3
        group g
        group g2
        unit u
        real dmg
        integer check2
        real aoe
        real r
        real a
        real rmax
        private static method Loop_TsunaW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TsunaW
                set this = m_TsunaW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if GetHeroLevel(c)>=35 then 
                        call DebugUnit(c)
                    else
                        call DebugUnit2(c)
                    endif
                    if r == 0.12 or r == 0.24 or r == 0.36 or r == 0.48 or r == 0.6 then
                        set aoe = aoe + TsunaW_DamageAoeAdd
                        call GroupClear(g)
                        call DecorRemove(c, x, y, aoe, TsunaW2_DecorDamage)
                        call GroupEnumUnitsInRange( g , x, y , aoe + 25, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                call GroupAddUnit(g2, u)
                                call RootUnit(c, u, TsunaW2_Root)
                                set check2 = check2 + 1
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                        set k = 0
                        set k2 = k2 + 1
                        set r2 = r2 + 0.55
                        set r3 = r3 + 105
                        loop
                            exitwhen k > k2
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_a (81).mdl", x + (r3) * Cos((k * (360 / k2)) * bj_DEGTORAD), y + (r3) * Sin((k * (360 / k2)) * bj_DEGTORAD) , k * (360 / k2), 1.25, r2, 0))
                            set k = k + 1
                        endloop
                    endif
                else
                    if check2 > 0 then
                        call TsundaFStackAdd(c, 2)
                    endif
                    if GetHeroLevel(c)>=35 then 
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set g = null
                    set g2 = null
                    set u = null
                    set m_TsunaW[i] = m_TsunaW[ MUI_TsunaW]
                    set MUI_TsunaW = MUI_TsunaW - 1
                    if MUI_TsunaW == -1 then
                        call PauseTimer( t_TsunaW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TsunaW_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_TsunaW = MUI_TsunaW + 1
            set m_TsunaW[ MUI_TsunaW] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 0.65
            set check2 = 0
            set r3 = 0
            set k2 = 6
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(TsunaW_ID)), 0)
            set aoe = TsunaW_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( TsunaW2_DamageAgiBase + ( TsunaW2_DamageAgiStep * ( GetUnitAbilityLevel( c , TsunaW_ID) - 1 ) ) )
            set dmg = dmg + TsunaW2_Damage2StaticBase + ( TsunaW2_Damage2StaticStep * ( GetUnitAbilityLevel( c , TsunaW_ID) - 1 ) )
            if GetHeroLevel(c)>=35 then 
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set g = CreateGroup()
            set g2 = CreateGroup()
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set rmax = 0.6
            call SetUnitTimeScale(c, 1.45)
            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_file00003436.mdl", c, "hand right"))
            call SetUnitAnimationByIndex(c, 4)
            call MakeSound("war3mapimported\\Hero_Tsuna_W2")
            if MUI_TsunaW == 0 then
                call TimerStart( t_TsunaW, 0.03, true, function thistype.Loop_TsunaW)
            endif
        endmethod
    endstruct

    private struct TsunaW2KS
        private static timer t_TsunaW2 = CreateTimer( )
        private static integer array m_TsunaW2
        private static integer MUI_TsunaW2 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real x2
        real y2
        real r2
        integer k
        real r5
        group g
        group g2
        unit u
        real dmg
        real scale
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real a2
        real rmax
        private static method Loop_TsunaW2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TsunaW2
                set this = m_TsunaW2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r < TsunaW3_CastTime then
                        call DebugUnit2(c)
                    endif
                    if r == TsunaW3_CastTime then
                        call MakeSound("war3mapimported\\Hero_Tsuna_E2")
                        call StopSpellUnit2(c)
                        call DestroyEffect(e)
                        set scale = 3
                        set x1 = GetUnitX(c) + 30 * Cos(a)
                        set y1 = GetUnitY(c) + 30 * Sin(a)
                        set a2 = a - 9 * bj_DEGTORAD
                        set a = a + 9 * bj_DEGTORAD
                        set e = EffectSpawn("war3mapImported\\wos_summon3missle.mdl", x1 + 90 * Cos(a + 90 * bj_DEGTORAD), y1 + 90 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG, 1, scale, 100)
                        set e2 = EffectSpawn("war3mapImported\\wos_summon3missle.mdl", x1 + 90 * Cos(a - 90 * bj_DEGTORAD), y1 + 90 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG, 1, scale, 100)
                    endif
                    if r > TsunaW3_CastTime then
                        if r5 < TsunaW3_Range and SR5(e, x2, y2) > 80 and SR5(e2, x2, y2) > 80 then
                            set r5 = r5 + move
                        else
                            set r = 9999
                        endif
                        if scale < 8 then
                            set scale = scale + 0.36
                        endif
                        set a = GAngle5(e, x2, y2)
                        set a2 = GAngle5(e2, x2, y2)
                        call MoveEff(e, move, a - 35 * bj_DEGTORAD)
                        call MoveEff(e2, move, a2 + 35 * bj_DEGTORAD)
                        set k = 0
                        loop
                            exitwhen k > 1
                            if k == 0 then
                                set x = GetEffX(e)
                                set y = GetEffY(e)
                            else
                                set x = GetEffX(e2)
                                set y = GetEffY(e2)
                            endif
                            call VisionTimed(GetOwningPlayer(c), x, y , aoe, 1)
                            call DecorRemove(c, x, y , aoe, TsunaW3_DecorDamage)
                            
                            call BlzSetSpecialEffectScale(e, scale)
                            call BlzSetSpecialEffectScale(e2, scale)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null or r == 999
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    set r = 999
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            set k = k + 1
                        endloop
                    endif
                else
                    if r < TsunaW3_CastTime then
                        call StopSpellUnit2(c)
                    else
                        call MakeSound("war3mapimported\\Hero_Tsuna_TW2")
                        set k = 0
                        set check2 = 0
                        loop
                            exitwhen k > 1
                            if k == 0 then
                                set x = GetEffX(e)
                                set y = GetEffY(e)
                            else
                                set x = GetEffX(e2)
                                set y = GetEffY(e2)
                            endif
                            set aoe = TsunaW3_DamageAoeFinal
                            call VisionTimed(GetOwningPlayer(c), x, y , aoe, 1)
                            call DecorRemove(c, x, y , aoe, TsunaW3_ExplosionDecorDamage)
                            call MakeSound("war3mapimported\\Hero_Tsuna_E3")
                            call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_1.mdl", x, y, GetRandomReal(0, 359), 1, 1.25, 1, 0.6)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl", x, y, GetRandomReal(0, 359), 1, 1.05, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdl", x, y, GetRandomReal(0, 359), 1, 1.85, 1))
                            call GroupClear(g)
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                    set check2 = check2 + 1
                                    call dmgmag(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            set k = k + 1
                        endloop
                        if check2 > 0 then
                            call TsundaFStackAdd(c, 2)
                        endif
                    endif
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup( g )
                    call DestroyGroup( g2 )
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_TsunaW2[i] = m_TsunaW2[ MUI_TsunaW2]
                    set MUI_TsunaW2 = MUI_TsunaW2 - 1
                    if MUI_TsunaW2 == -1 then
                        call PauseTimer( t_TsunaW2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TsunaW2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_TsunaW2 = MUI_TsunaW2 + 1
            set m_TsunaW2[ MUI_TsunaW2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set x2 = x
            set y2 = y
            set r = 0
            set r2 = 0
            set move = TsunaW3_Speed
            set r5 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y )
            set aoe = TsunaW3_DamageAoe
            set dmg = GetHeroAgi( c , true) *  TsunaW3_DamageAgiBase 
            set rmax = 2.4
            call SetUnitAnimationByIndex(c, 0)
            call SetUnitTimeScale(c, 0.95)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_summon3missle.mdl", c, "hand right")
            call MakeSound("war3mapimported\\Hero_Tsuna_TW")
            if MUI_TsunaW2 == 0 then
                call TimerStart( t_TsunaW2, 0.03, true, function thistype.Loop_TsunaW2)
            endif
        endmethod
    endstruct

    private struct TsunaEKS
        private static timer t_TsunaE = CreateTimer( )
        private static integer array m_TsunaE
        private static integer MUI_TsunaE = -1
        unit c
        real x
        real y
        real r2
        real r4
        real r5
        group g
        unit u
        real dmg
        real scale
        integer check2
        real aoe
        real move
        real r
        effect e
        real a
        real rmax
        private static method Loop_TsunaE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TsunaE
                set this = m_TsunaE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r < TsunaE_CastTime then
                        call DebugUnit2(c)
                    endif
                    if r == TsunaE_CastTime then
                        call MakeSound("war3mapimported\\Hero_Tsuna_E2")
                        call StopSpellUnit2(c)
                        call DestroyEffect(e)
                        set scale = 1.15
                        set e = EffectSpawn("war3mapImported\\wos_summon3missle.mdl", GetUnitX(c) + 110 * Cos(a), GetUnitY(c) + 110 * Sin(a), a * bj_RADTODEG, 1, scale, 100)
                    endif
                    if r > TsunaE_CastTime then
                        if r5 < r4 then
                            set r5 = r5 + move
                        else
                            set r = 9999
                        endif
                        if scale < 5 then
                            set scale = scale + 0.36
                        endif
                        call MoveEff(e, move, a)
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call VisionTimed(GetOwningPlayer(c), x, y , aoe, 1)
                        call DecorRemove(c, x, y , aoe, TsunaE_DecorDamage)
                        call BlzSetSpecialEffectScale(e, scale)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null or r == 999
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                set r = 999
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
                else
                    if r < TsunaE_CastTime then
                        call StopSpellUnit2(c)
                    else
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        set aoe = TsunaE_DamageAoeFinal
                        call VisionTimed(GetOwningPlayer(c), x, y , aoe, 1)
                        call DecorRemove(c, x, y , aoe, TsunaE_ExplosionDecorDamage)
                        call MakeSound("war3mapimported\\Hero_Tsuna_E3")
                        call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_1.mdl", x, y, GetRandomReal(0, 359), 1, 1.25, 1, 0.6)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl", x, y, GetRandomReal(0, 359), 1, 1.05, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdl", x, y, GetRandomReal(0, 359), 1, 1.85, 1))
                        call GroupClear(g)
                        set check2 = 0
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                set check2 = check2 + 1
                                call dmgmag(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                        if check2 > 0 then
                            call TsundaFStackAdd(c, 3)
                        endif
                    endif
                    call DestroyEffect(e)
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_TsunaE[i] = m_TsunaE[ MUI_TsunaE]
                    set MUI_TsunaE = MUI_TsunaE - 1
                    if MUI_TsunaE == -1 then
                        call PauseTimer( t_TsunaE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TsunaE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_TsunaE = MUI_TsunaE + 1
            set m_TsunaE[ MUI_TsunaE] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set move = TsunaE_Speed
            set r5 = 0
            set r4 = TsunaE_RangeBase + (TsunaE_RangeAdd*(GetUnitAbilityLevel(c,TsunaE_ID)-1))
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y )
            set aoe = TsunaE_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( TsunaE_DamageAgiBase + ( TsunaE_DamageAgiStep * ( GetUnitAbilityLevel( c , TsunaE_ID) - 1 ) ) )
            set rmax = 2.4
            call SetUnitAnimationByIndex(c, 2)
            call SetUnitTimeScale(c, 0.95)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_summon3missle.mdl", c, "hand right")
            call MakeSound("war3mapimported\\Hero_Tsuna_E")
            call MakeSound("war3mapimported\\Hero_Tsuna_E3")
            if MUI_TsunaE == 0 then
                call TimerStart( t_TsunaE, 0.03, true, function thistype.Loop_TsunaE)
            endif
        endmethod
    endstruct

    private struct TsunaE2KS
        private static timer t_TsunaE2 = CreateTimer( )
        private static integer array m_TsunaE2
        private static integer MUI_TsunaE2 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k2
        integer k3
        integer k4
        real r3
        real r5
        group g
        group g2
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real r
        effect e
        effect e2
        effect e3
        effect e5
        effect e6
        real a
        real rmax
        private static framehandle array frame0_pas3
        private static method Loop_TsunaE2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local integer kkk = 0
            loop
                exitwhen i > MUI_TsunaE2
                set this = m_TsunaE2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.05
                    call SetUnitX(c, x1)
                    call SetUnitY(c, y1)
                    if r == 0.15 then
                        set e3 = EffectSpawnColor("war3mapImported\\wos_ringaura_r31.mdl", GetUnitX(c) + 155 * Cos(a), GetUnitY(c) + 155 * Sin(a), a * bj_RADTODEG, 0.75, 2, 100, 255, 255, 255, 150)
                        call ScaleEffDummy(e3, 0.3, 2, 8)
                        set e = EffectSpawn("war3mapImported\\wos_burner1.mdl", GetUnitX(c) - 45 * Cos(a), GetUnitY(c) - 45 * Sin(a), a * bj_RADTODEG, 1, 1.35, 115)
                        set k = 0
                        set k4 = 6
                        set x = GetUnitX(c) - 50 * Cos(a)
                        set y = GetUnitY(c) - 50 * Sin(a)
                    endif
                    call BlzFrameSetValue(frame0_pas3[k2], r)
                    if r == 0.45 then
                        set check2 = 0
                        set e6 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "hand right")
                        set check2 = 0
                        call MakeSound("war3mapimported\\Hero_Tsuna_T4")
                        call SetUnitTimeScale(c, 2.25)
                        set x = GetUnitX(c) + 50 * Cos(a)
                        set y = GetUnitY(c) + 50 * Sin(a)
                    endif
                    if r == 0.7 then
                        call EMUE(EffectSpawn2("war3mapImported\\wos_summon3missle.mdl", GetUnitX(c) + 45 * Cos(a), GetUnitY(c) + 45 * Sin(a), a * bj_RADTODEG, 2, 4, 100, 0.21), 2100, 0.21, a)
                        call ScaleEffDummy(e3, 0.21, 8, 4)
                    endif
                    if r == 0.85 then
                        set e2 = EffectSpawn("war3mapImported\\wos_file00000491.mdl", GetUnitX(c) + 115 * Cos(a), GetUnitY(c) + 115 * Sin(a), a * bj_RADTODEG, 0.5, 2.25, 0)
                        set e5 = EffectSpawn("war3mapImported\\wos_file00000491.mdl", GetUnitX(c) + 115 * Cos(a), GetUnitY(c) + 115 * Sin(a), a * bj_RADTODEG, 0.4, 2.25, 0)
                        call MakeSound("war3mapimported\\Hero_Tsuna_TT4")
                    endif
                    if r == TsunaE2_CastTime then
                        set r = rmax - 0.1
                        set r3 = 350
                        set kkk = 6
                        set k = 0
                        loop
                            exitwhen k > kkk
                            call DecorRemove(c, x + r3 * Cos(a), y + r3 * Sin(a) , aoe, TsunaE2_DecorDamage)
                            call VisionTimed(GetOwningPlayer(c),x + r3 * Cos(a), y + r3 * Sin(a) , 900,2)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange( g , x + r3 * Cos(a), y + r3 * Sin(a), aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                    call dmgmag(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    set check2 = check2 + 1
                                    call StunUnit(c,u,TsunaE2_StunDuration)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            set k = k + 1
                            set r3 = r3 + 365
                        endloop
                        set k = 0
                        set r3 = 125
                        loop
                            exitwhen k == 23
                            call EffectSpawn2("war3mapImported\\wos_firefly-rq-sfx2.mdl", x + r3 * Cos(a), y + r3 * Sin(a), GetRandomReal(0, 359), 3, 0.3, 150, 0.3)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_cf2.mdl", x + r3 * Cos(a), y + r3 * Sin(a), a * bj_RADTODEG, GetRandomReal(0.25, 0.5), 0.7, 20))
                            set k = k + 1
                            set r3 = r3 + 125
                        endloop
                    endif
                else
                    call TsundaFStackAdd(c, 3)
                    call StopSpellUnit2(c)
                    call SetUnitAnimation(c, "stand")
                    call SetUnitTimeScale(c, 1)
                    call DestroyEffect(e)
                    // e2/e5 уничтожит ColorEffDummy3 после завершения затухания.
                    // Нельзя передавать туда уже уничтоженный handle эффекта.
                    call ColorEffDummy3(e2, 0, 255, 255, 255, 0.24)
                    call ColorEffDummy3(e3, 0, 255, 255, 255, 0.3)
                    call ColorEffDummy3(e5, 0, 255, 255, 255, 0.24)
                    call DestroyEffect(e6)
                    call SetFly(c, 0)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set u = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e5 = null
                    set e6 = null
                    set c = null
                    set m_TsunaE2[i] = m_TsunaE2[ MUI_TsunaE2]
                    set MUI_TsunaE2 = MUI_TsunaE2 - 1
                    if MUI_TsunaE2 == -1 then
                        call PauseTimer( t_TsunaE2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TsunaE2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_TsunaE2 = MUI_TsunaE2 + 1
            set m_TsunaE2[ MUI_TsunaE2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)
            set r = 0
            set k3 = 0
            set k4 = 0
            set r2 = 40
            set check = 0
            set check2 = 0
            set a = GAngle2( c , x , y )
            set aoe = TsunaE2_DamageAoe
            set dmg = GetHeroAgi( c , true) * TsunaE2_DamageAgiBase
            set rmax = 2
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            call SetUnitAnimationByIndex(c, 16)
            set r5 = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            call MakeSound("war3mapimported\\Hero_Tsuna_TE")
            if MUI_TsunaE2 == 0 then
                call TimerStart( t_TsunaE2, 0.05, true, function thistype.Loop_TsunaE2)
            endif
        endmethod
    endstruct

    private struct TsunaRKS
        private static timer t_TsunaR = CreateTimer( )
        private static integer array m_TsunaR
        private static integer MUI_TsunaR = -1
        unit c
        unit td
        real x
        real y
        real r2
        real r3
        real r5
        real dmg
        integer check
        integer check2
        real move
        real r
        effect e
        effect e2
        effect e3
        effect e4
        real a
        real rmax
        private static method Loop_TsunaR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TsunaR
                set this = m_TsunaR[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    if check == 0 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        set a = GAngle(c, td)
                        call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                        if r == 0.03 then
                            set r3 = 240
                        endif
                        if SR2(c, td) > r3 then
                            call EffectSpawn2("war3mapImported\\wos_az_wsy_gather3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 91, 0.13)
                            call MoveUnit(c, move, a)
                        else
                            set check = 1
                            set r = 0                                           
                            call SlowUnit(c, td, TsunaR_Slow, TsunaR_SlowDuration)
                            set rmax = TsunaR_Duration
                            set r5 = 0
                            set e3 = EffectSpawn("war3mapImported\\wos_buff_red_89_1_0.mdl", x, y, a * bj_RADTODEG, 2, 3.25, 8)
                            set e4 = EffectSpawn("war3mapImported\\wos_hakkestart.mdl", x, y, a * bj_RADTODEG, 1, 1, 4)
                            call AnimDummyEff(e4, 0.25, 0)
                            set a = a + 180 * bj_DEGTORAD
                        endif
                    else
                        call EffectSpawn2("war3mapImported\\wos_az_wsy_gather3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, r5, 0.22)
                        if r5 < 650 then
                            set r5 = r5 + 10
                        endif
                        if r3 > 75 then
                            set r3 = r3 - 3
                        endif
                        call SetFly(c, r5)
                        set a = a - 26 * bj_DEGTORAD
                        call BlzSetUnitFacingEx(c, a * bj_RADTODEG + 90)
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        call BlzSetSpecialEffectPosition(e3, x, y, 7)
                        call BlzSetSpecialEffectPosition(e4, x, y, 5)
                        call PosUnit(c, x + r3 * Cos(a), y + r3 * Sin(a))
                        if r2 > 0.15 then
                            set r2 = 0                                      
                            call dmgmag(c, td, dmg)
                            call SlowUnit(c, td, TsunaR_Slow, TsunaR_SlowDuration)
                            set check2 = check2 + 1
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call StopSpellUnit(c)
                    call HeightSet(c, 0.15, 0)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call ColorEffDummy3(e3, 0, 255, 255, 255, 0.3)
                    call ColorEffDummy3(e4, 0, 255, 255, 255, 0.3)
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set m_TsunaR[i] = m_TsunaR[ MUI_TsunaR]
                    set MUI_TsunaR = MUI_TsunaR - 1
                    if MUI_TsunaR == -1 then
                        call PauseTimer( t_TsunaR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TsunaR_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_TsunaR = MUI_TsunaR + 1
            set m_TsunaR[ MUI_TsunaR] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set r2 = 50
            set check = 0
            set check2 = 0
            set move = TsunaR_DashSpeed
            call TsundaFStackAdd(c, 4)
            call StartSpellUnit(c)
            set a = GAngle2( c , x , y )
            set dmg = GetHeroAgi( c , true) * ( TsunaR_DamageAgiBase + ( TsunaR_DamageAgiStep * ( GetUnitAbilityLevel( c , TsunaR_ID) - 1 ) ) )
            set dmg = dmg / TsunaR_Ticks
            set rmax = TsunaR_DashMaxDuration
            call SetUnitAnimationByIndex(c, 8)
            call SetUnitTimeScale(c, 1.25)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_summon3missle.mdl", c, "hand right")
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_summon3missle.mdl", c, "hand left")
            call MakeSound("war3mapimported\\Hero_Tsuna_R")
            if MUI_TsunaR == 0 then
                call TimerStart( t_TsunaR, 0.03, true, function thistype.Loop_TsunaR)
            endif
        endmethod
    endstruct

    private struct TsunaR2KS
        private static timer t_TsunaR2 = CreateTimer( )
        private static integer array m_TsunaR2
        private static integer MUI_TsunaR2 = -1
        unit c
        real x
        real y
        real r2
        real r3
        real r5
        real r6
        group g
        group g2
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        effect e3
        effect e4
        real a
        real rmax
        private static method Loop_TsunaR2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TsunaR2
                set this = m_TsunaR2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    if check == 0 then
                        set a = GAngle2(c, x, y)
                        call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                        if r == 0.03 then
                            set r3 = 640
                        endif
                        if SR3(c, x, y) > r3 then
                            call EffectSpawn2("war3mapImported\\wos_az_wsy_gather3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 91, 0.13)
                            call MoveUnit(c, move, a)
                        else
                            set check = 1
                            call MakeSound("war3mapimported\\Hero_Tsuna_R2")
                            set r = 0
                            set rmax = TsunaR2_Duration
                            set r5 = 0
                            set e3 = EffectSpawn("war3mapImported\\wos_buff_red_89_1_0.mdl", x, y, a * bj_RADTODEG, 2, 6.5, 8)
                            set e4 = EffectSpawn("war3mapImported\\wos_hakkestart.mdl", x, y, a * bj_RADTODEG, 1, 2, 4)
                            call AnimDummyEff(e4, 0.25, 0)
                            set a = a + 180 * bj_DEGTORAD
                        endif
                    else
                        if r5 < 950 then
                            set r5 = r5 + 15
                        endif
                        if r3 > 75 then
                            set r3 = r3 - 11
                        endif
                        call SetFly(c, r5)
                        set a = a - 26 * bj_DEGTORAD
                        call BlzSetUnitFacingEx(c, a * bj_RADTODEG + 90)
                        if rmax - r > 1 then
                            set r6 = 1
                        else
                            set r6 = rmax - r
                        endif
                        call PosUnit(c, x + r3 * Cos(a), y + r3 * Sin(a))
                        call EffectSpawn2("war3mapImported\\wos_az_wsy_gather3.mdl", x + r3 * Cos(a), y + r3 * Sin(a), a * bj_RADTODEG, 1, 1.25, r5, r6)
                        call EffectSpawn2("war3mapImported\\wos_az_wsy_gather3.mdl", x + r3 * Cos(a + 13 * bj_DEGTORAD), y + r3 * Sin(a + 13 * bj_DEGTORAD), a * bj_RADTODEG, 1, 1.25, r5, r6)
                        if r2 > 0.15 then
                            set r2 = 0
                            call GroupClear(g)
                            set check2 = 0
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    set check2 = check2 + 1
                                    call SlowUnit(c, u, TsunaR2_Slow, TsunaR2_SlowDuration)
                                    call dmgmag(c, u, dmg)
                                    call MUE(u, TsunaR2_PullRange, TsunaR2_PullDuration, GAngle2(u, x, y))
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set check2 = check2 + 1
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call StopSpellUnit(c)
                    call HeightSet(c, 0.15, 0)
                    call DestroyEffect(e)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    call DestroyEffect(e2)
                    call ColorEffDummy3(e3, 0, 255, 255, 255, 0.3)
                    call ColorEffDummy3(e4, 0, 255, 255, 255, 0.3)
                    set c = null
                    set g = null
                    set g2 = null
                    set u = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set m_TsunaR2[i] = m_TsunaR2[ MUI_TsunaR2]
                    set MUI_TsunaR2 = MUI_TsunaR2 - 1
                    if MUI_TsunaR2 == -1 then
                        call PauseTimer( t_TsunaR2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TsunaR2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_TsunaR2 = MUI_TsunaR2 + 1
            set m_TsunaR2[ MUI_TsunaR2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 50
            set check = 0
            set check2 = 0
            set g = CreateGroup()
            set g2 = CreateGroup()
            set move = TsunaR2_DashSpeed
            call TsundaFStackAdd(c, 4)
            call StartSpellUnit(c)
            set u = null
            set a = GAngle2( c , x , y )
            set dmg = GetHeroAgi( c , true) * TsunaR2_DamageAgiBase 
            set dmg = dmg / TsunaR2_Ticks
            set rmax = TsunaR2_DashMaxDuration
            set aoe = TsunaR2_Aoe
            call SetUnitAnimationByIndex(c, 8)
            call SetUnitTimeScale(c, 1.25)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_summon3missle.mdl", c, "hand right")
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_summon3missle.mdl", c, "hand left")
            call MakeSound("war3mapimported\\Hero_Tsuna_R")
            if MUI_TsunaR2 == 0 then
                call TimerStart( t_TsunaR2, 0.03, true, function thistype.Loop_TsunaR2)
            endif
        endmethod
    endstruct
    
    private struct TsunaTKS
        private static real TsunaT_Size = 1
        private static timer t_TsunaT = CreateTimer( )
        private static integer array m_TsunaT
        private static integer MUI_TsunaT = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k2
        integer k3
        integer k4
        real r3
        real r5
        group g
        group g2
        group g3
        unit u
        real dmg
        integer check
        integer check2
        integer check3
        real aoe
        real r
        effect e
        effect e2
        effect e3
        effect e5
        effect e6
        effect array ee [14]
        effect array beamLineFx [14]
        effect array beamFlameFx [14]
        effect array beamHuoFx [16]
        integer beamLineCount
        integer beamHuoCount
        real beamAnimTime
        real beamAnimTime2
        real beamAnimAngle
        real a
        real rmax
        // Интерфейс принадлежит игроку, а не отдельному экземпляру заклинания.
        private static framehandle array frame0_pas1
        private static framehandle array frame0_pas2
        private static framehandle array frame0_pas3
        private static framehandle array frame0_pas4
        private static method Loop_TsunaT takes nothing returns nothing
            local integer this
            local integer i = 0
            local integer kkk = 0
            local real rkk = TsunaT_ChargeTimeFull
            local real targetA
            local real step
            local real diff
            local real mouseX
            local real mouseY
            local real beamAngleDiff
            local real effectA
            local real visualX
            local real visualY
            local boolean replayBeamAnim
            local boolean replayBeamAnim2
            loop
                exitwhen i > MUI_TsunaT
                set this = m_TsunaT[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.05
                    call SetUnitX(c, x1)
                    call SetUnitY(c, y1)
                    if check == 0 then
                        if GetUnitCurrentOrder(c) != OrderId("awaken") then
                            set r = 9999
                        endif
                        if r == 0.35 then
                            call SetUnitTimeScale(c, 0)
                        endif
                        if r == 0.3 then
                            call MakeSound("war3mapimported\\Hero_Tsuna_T")
                            set e = EffectSpawn("war3mapImported\\wos_burner1.mdl", GetUnitX(c) - 45 * TsunaT_Size * Cos(a), GetUnitY(c) - 45 * TsunaT_Size * Sin(a), a * bj_RADTODEG, 1, 1.69 * TsunaT_Size, 115 * TsunaT_Size)
                            set k = 0
                            set k4 = 8
                            set x = GetUnitX(c) - 50 * TsunaT_Size * Cos(a)
                            set y = GetUnitY(c) - 50 * TsunaT_Size * Sin(a)
                            set r3 = 255 * TsunaT_Size
                            loop
                                exitwhen k == k4
                                if k == 0 then
                                    set ee[k] = EffectSpawn3("war3mapImported\\wos_1huo_92.mdl", x - r3 * Cos(a), y - r3 * Sin(a), a * bj_RADTODEG, 1, 2 * TsunaT_Size, 130 * TsunaT_Size, -90)
                                else
                                    set ee[k] = EffectSpawn3("war3mapImported\\wos_1huo_92.mdl", x - r3 * Cos(a), y - r3 * Sin(a), a * bj_RADTODEG, 1, 3 * TsunaT_Size, 130 * TsunaT_Size, -90)
                                endif
                                set k = k + 1
                                set r3 = r3 + 245 * TsunaT_Size
                            endloop
                        endif
                        call BlzFrameSetValue(frame0_pas3[k2], r)
                        if r == 0.3 then
                            set check2 = 0
                            call BlzSetSpecialEffectTimeScale(e3, 3.04* (1+(rkk/1.8)))
                            set e6 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "hand right")
                            call BlzSetSpecialEffectScale(e6, TsunaT_Size)
                        endif
                        if r >= 0.3 and r <= 1.5 then
                            set check2 = R2I((r - 0.3) / rkk * 100 + 0.5)
                            if check2 > 100 then
                                set check2 = 100
                            endif
                            if check2 >= 50 then
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaT2_ID, true)
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaT_ID, false)
                                call UnitAddAbility(c, TsunaT2_ID)
                            endif
                            call BlzFrameSetText(frame0_pas4[k2], "" + I2S(check2) + "%|r")
                        endif
                        if r == 1.5 then
                            call MakeSound("war3mapimported\\Hero_Tsuna_T3")
                        endif
                        if r == 2.5 then
                            call MakeSound("war3mapimported\\Hero_Tsuna_T4")
                        endif
                        if r == TsunaT_OverchargeTime and GetHeroLevel(c) >= 35 then
                            set check2 = R2I(TsunaT_OverchargeDmgPct)
                            call BlzFrameSetText(frame0_pas4[k2], "|c00FF0303" + I2S(check2) + "%|r")
                            call MakeSound("war3mapimported\\Hero_Tsuna_T7")
                            call MakeSound("war3mapimported\\Hero_Tsuna_T")
                            set k3 = 1
                            call ScaleEffDummy(e, 0.21, 1.69 * TsunaT_Size, 2.375 * TsunaT_Size)
                            set k = 0
                            set k4 = 12
                            set x = GetUnitX(c) - 50 * TsunaT_Size * Cos(a)
                            set y = GetUnitY(c) - 50 * TsunaT_Size * Sin(a)
                            set r3 = (255 + 245 * k) * TsunaT_Size
                            loop
                                exitwhen k == k4
                                if k >= 8 then
                                    set ee[k] = EffectSpawn3("war3mapImported\\wos_1huo_92.mdl", x - r3 * Cos(a), y - r3 * Sin(a), a * bj_RADTODEG, 1, 3.45 * TsunaT_Size, 130 * TsunaT_Size, -90)
                                endif
                                if GetRandomInt(1, 2) == 1 then
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_cf2.mdl", x - r3 * Cos(a), y - r3 * Sin(a), a * bj_RADTODEG, GetRandomReal(0.45, 1), 0.95 * TsunaT_Size, 20 * TsunaT_Size))
                                else
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_cf2.mdl", x - r3 * Cos(a), y - r3 * Sin(a), a * bj_RADTODEG + 180, GetRandomReal(0.45, 1), 0.95 * TsunaT_Size, 20 * TsunaT_Size))
                                endif
                                set k = k + 1
                                set r3 = r3 + 245 * TsunaT_Size
                            endloop
                        endif
                        if LoadInteger(hs, GetHandleId(c), StringHash("cast t")) == 1 then
                            call SaveInteger(hs, GetHandleId(c), StringHash("cast t"), 0)
                            set check = 1
                            set check3 = 0
                            set r = 0
                            set rmax = TsunaT_Duration + 0.15
                            set r2 = 0
                            if k3 == 1 then
                                set aoe = aoe + 45 * TsunaT_Size
                            endif
                            set dmg = dmg * (I2R(check2) / 100)
                            call StartSpellUnit(c)
                            set MouseX[GetPlayerId(GetOwningPlayer(c))] = GetUnitX(c) + 150 * TsunaT_Size * Cos(a)
                            set MouseY[GetPlayerId(GetOwningPlayer(c))] = GetUnitY(c) + 150 * TsunaT_Size * Sin(a)
                            call MouseOn(GetOwningPlayer(c))
                            call BlzSetSpecialEffectTimeScale(e3, 0)
                        endif
                    elseif check == 1 then
                        set mouseX = GetMouseX(GetOwningPlayer(c))
                        set mouseY = GetMouseY(GetOwningPlayer(c))
                        set targetA = GAngle2(c, mouseX, mouseY)
                        set step = TsunaT_TurnSpeed * bj_DEGTORAD
                        set diff = targetA - a
                        if diff > bj_PI then
                            set diff = diff - 2 * bj_PI
                        elseif diff < -bj_PI then
                            set diff = diff + 2 * bj_PI
                        endif
                        if diff > step then
                            set a = a + step
                            if diff > 2 * step then
                                set effectA = a + step
                            else
                                set effectA = targetA
                            endif
                        elseif diff < -step then
                            set a = a - step
                            if diff < -2 * step then
                                set effectA = a - step
                            else
                                set effectA = targetA
                            endif
                        else
                            set a = targetA
                            set effectA = targetA
                        endif
                        call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                        set visualX = GetUnitX(c) + 50 * TsunaT_Size * Cos(effectA)
                        set visualY = GetUnitY(c) + 50 * TsunaT_Size * Sin(effectA)

                        call BlzSetSpecialEffectPosition(e3, GetUnitX(c), GetUnitY(c), BlzGetLocalSpecialEffectZ(e3))
                        call BlzSetSpecialEffectYaw(e3, effectA + bj_PI)
                        call BlzSetSpecialEffectPosition(e, GetUnitX(c) - 45 * TsunaT_Size * Cos(effectA), GetUnitY(c) - 45 * TsunaT_Size * Sin(effectA), BlzGetLocalSpecialEffectZ(e))
                        call BlzSetSpecialEffectYaw(e, effectA)
                        if r >= 0.35 then
                            call BlzSetSpecialEffectPosition(e2, GetUnitX(c) + 45 * TsunaT_Size * Cos(effectA), GetUnitY(c) + 45 * TsunaT_Size * Sin(effectA), BlzGetLocalSpecialEffectZ(e2))
                            call BlzSetSpecialEffectYaw(e2, effectA + bj_PI)
                        endif
                        set k = 0
                        set r3 = 255 * TsunaT_Size
                        loop
                            exitwhen k == k4
                            call BlzSetSpecialEffectPosition(ee[k], GetUnitX(c) - (50 * TsunaT_Size + r3) * Cos(effectA), GetUnitY(c) - (50 * TsunaT_Size + r3) * Sin(effectA), BlzGetLocalSpecialEffectZ(ee[k]))
                            call BlzSetSpecialEffectYaw(ee[k], effectA)
                            set k = k + 1
                            set r3 = r3 + 245 * TsunaT_Size
                        endloop

                        set x = GetUnitX(c) + 50 * TsunaT_Size * Cos(a)
                        set y = GetUnitY(c) + 50 * TsunaT_Size * Sin(a)
                        call DebugUnit(c)
                        if r == 0.05 then
                            set check2 = 0
                            if k3 == 0 then
                                call MakeSound("war3mapimported\\Hero_Tsuna_T5")
                            else
                                call MakeSound("war3mapimported\\Hero_Tsuna_T8")
                            endif
                            call SetUnitAnimationByIndex(c, 5)
                            call SetUnitTimeScale(c, 2.25)
                            call ColorEffDummy3(e3, 0, 255, 255, 255, 0.6)
                            set x = GetUnitX(c) + 50 * TsunaT_Size * Cos(a)
                            set y = GetUnitY(c) + 50 * TsunaT_Size * Sin(a)
                        endif
                        if r == 0.35 then
                            if k3 == 0 then
                                call MakeSound("war3mapimported\\Hero_Tsuna_T6")
                                set e2 = EffectSpawn("war3mapImported\\wos_burner2.mdl", GetUnitX(c) + 45 * TsunaT_Size * Cos(a), GetUnitY(c) + 45 * TsunaT_Size * Sin(a), a * bj_RADTODEG + 180, 1, 1.69 * TsunaT_Size, 115 * TsunaT_Size)
                            else
                                set e2 = EffectSpawn("war3mapImported\\wos_burner2.mdl", GetUnitX(c) + 45 * TsunaT_Size * Cos(a), GetUnitY(c) + 45 * TsunaT_Size * Sin(a), a * bj_RADTODEG + 180, 1, 2.62 * TsunaT_Size, 115 * TsunaT_Size)
                                call MakeSound("war3mapimported\\Hero_Tsuna_T9")
                            endif
                        endif
                        if r >= 0.1 then
                            if k3 == 1 then
                                set kkk = 10
                                set beamHuoCount = 16
                            else
                                set kkk = 6
                                set beamHuoCount = 10
                            endif
                            set beamLineCount = kkk + 4
                            set beamAnimTime = beamAnimTime + 0.05
                            set beamAnimTime2 = beamAnimTime2 + 0.05
                            set beamAngleDiff = a - beamAnimAngle
                            if beamAngleDiff > bj_PI then
                                set beamAngleDiff = beamAngleDiff - 2 * bj_PI
                            elseif beamAngleDiff < -bj_PI then
                                set beamAngleDiff = beamAngleDiff + 2 * bj_PI
                            endif
                            set replayBeamAnim = beamAnimTime >= 0.12 or RAbsBJ(beamAngleDiff) >= 10.01 * bj_DEGTORAD
                            set replayBeamAnim2 = beamAnimTime2 >= 0.27
                            if replayBeamAnim then
                                set beamAnimTime = 0
                                set beamAnimAngle = a
                            endif
                            if replayBeamAnim2 then
                                set beamAnimTime2 = 0
                            endif
                            set k = 0
                            set r3 = 255 * TsunaT_Size
                            loop
                                exitwhen k == beamLineCount
                                if beamLineFx[k] == null then
                                    if k3 == 1 then
                                        set beamLineFx[k] = EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", visualX + r3 * Cos(effectA), visualY + r3 * Sin(effectA), GetRandomReal(0, 359), 3.5, (2 + k * 0.11) * TsunaT_Size, 120 * TsunaT_Size)
                                        if ModuloInteger(k, 2) == 0 then
                                            set beamFlameFx[k] = EffectSpawn("war3mapImported\\wos_cf2.mdl", visualX + r3 * Cos(effectA), visualY + r3 * Sin(effectA), effectA * bj_RADTODEG, GetRandomReal(0.9, 1.5), 2.5 * TsunaT_Size, 20 * TsunaT_Size)
                                        endif
                                    else
                                        set beamLineFx[k] = EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", visualX + r3 * Cos(effectA), visualY + r3 * Sin(effectA), GetRandomReal(0, 359), 3.5, (1 + k * 0.11) * TsunaT_Size, 120 * TsunaT_Size)
                                    endif
                                endif
                                call BlzSetSpecialEffectPosition(beamLineFx[k], visualX + r3 * Cos(effectA), visualY + r3 * Sin(effectA), BlzGetLocalSpecialEffectZ(beamLineFx[k]))
                                if k3 == 1 and beamFlameFx[k] != null then
                                    call BlzSetSpecialEffectPosition(beamFlameFx[k], visualX + r3 * Cos(effectA), visualY + r3 * Sin(effectA), BlzGetLocalSpecialEffectZ(beamFlameFx[k]))
                                    call BlzSetSpecialEffectYaw(beamFlameFx[k], effectA)
                                endif
                                if replayBeamAnim then
                                    call BlzPlaySpecialEffect(beamLineFx[k], ANIM_TYPE_STAND)
                                endif
                                if replayBeamAnim2 and k3 == 1 and beamFlameFx[k] != null then
                                    call BlzPlaySpecialEffect(beamFlameFx[k], ANIM_TYPE_BIRTH)
                                endif
                                set k = k + 1
                                set r3 = r3 + 245 * TsunaT_Size
                            endloop

                            set k = 0
                            set r3 = 255 * TsunaT_Size
                            loop
                                exitwhen k == beamHuoCount
                                if beamHuoFx[k] == null then
                                    if k == 0 then
                                        set beamHuoFx[k] = EffectSpawn3("war3mapImported\\wos_1huo_92.mdl", visualX + r3 * Cos(effectA), visualY + r3 * Sin(effectA), effectA * bj_RADTODEG + 180, 1, 2 * TsunaT_Size, 130 * TsunaT_Size, -90)
                                    elseif k3 == 1 and k >= 8 then
                                        set beamHuoFx[k] = EffectSpawn3("war3mapImported\\wos_1huo_92.mdl", visualX + r3 * Cos(effectA), visualY + r3 * Sin(effectA), effectA * bj_RADTODEG + 180, 1, 3.45 * TsunaT_Size, 130 * TsunaT_Size, -90)
                                    else
                                        set beamHuoFx[k] = EffectSpawn3("war3mapImported\\wos_1huo_92.mdl", visualX + r3 * Cos(effectA), visualY + r3 * Sin(effectA), effectA * bj_RADTODEG + 180, 1, 3 * TsunaT_Size, 130 * TsunaT_Size, -90)
                                    endif
                                endif
                                call BlzSetSpecialEffectPosition(beamHuoFx[k], visualX + r3 * Cos(effectA), visualY + r3 * Sin(effectA), BlzGetLocalSpecialEffectZ(beamHuoFx[k]))
                                call BlzSetSpecialEffectYaw(beamHuoFx[k], effectA + bj_PI)
                                if replayBeamAnim then
                                    call BlzPlaySpecialEffect(beamHuoFx[k], ANIM_TYPE_STAND)
                                endif
                                set k = k + 1
                                set r3 = r3 + 245 * TsunaT_Size
                            endloop
                            if r2 > 0.21 then
                                set r2 = 0.03
                                set check3 = check3 + 1
                                call GroupClear(g)
                                call GroupClear(g2)
                                set r3 = 350 * TsunaT_Size
                                if k3 == 1 then
                                    set kkk = 10
                                else
                                    set kkk = 6
                                endif
                                set k = 0
                                loop
                                    exitwhen k > kkk
                                    call DecorRemove(c, x + r3 * Cos(a), y + r3 * Sin(a) , aoe, TsunaT_DecorDamage)
                                    call GroupEnumUnitsInRange( g , x + r3 * Cos(a), y + r3 * Sin(a), aoe , NoDecor_Cond)
                                    loop
                                        set u = FirstOfGroup( g )
                                        exitwhen u == null
                                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                            call dmgmag(c, u, dmg)
                                            call GroupAddUnit(g2, u)
                                            if IsUnitInGroup(u, g3) == false then 
                                                call RootUnit(c,u,TsunaT_Root)
                                                call SilenceUnit(c, u, TsunaT_SilenceDuration)
                                                call GroupAddUnit(g3, u)
                                            endif
                                            set check2 = check2 + 1
                                            call SlowUnit(c, u, TsunaT_Slow, TsunaT_SlowDuration)
                                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                        endif
                                        call GroupRemoveUnit( g , u )
                                    endloop
                                    set u = null
                                    set k = k + 1
                                    set r3 = r3 + 365 * TsunaT_Size
                                endloop
                                if r < rmax - 0.41 then
                                    set k = 0
                                    set r3 = 255 * TsunaT_Size
                                    loop
                                        exitwhen k == kkk + 4
                                        call VisionTimed(GetOwningPlayer(c), x + r3 * Cos(a), y + r3 * Sin(a),aoe*1.5,1)
                                        set k = k + 1
                                        set r3 = r3 + 245 * TsunaT_Size
                                    endloop
                                endif
                            else
                                set r2 = r2 + 0.05
                            endif
                        endif
                    endif
                else
                    call StopSpellUnit(c)
                    if check == 1 then
                        if check2 > 0 then
                            call TsundaFStackAdd(c, 5)
                        endif
                    endif
                    call SetUnitTimeScale(c, 1)
                    if r >= 0.3 then
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaT2_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaT_ID, true)
                        // Эффект уничтожит ColorEffDummy3 после затухания.
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.24)
                        set k = 0
                        loop
                            exitwhen k == k4
                            call DestroyEffect(ee[k])
                            set ee[k] = null
                            set k = k + 1
                        endloop
                    endif
                    if r > 0.6 then
                        // Эффекты уничтожит ColorEffDummy3 после затухания.
                        call ColorEffDummy3(e2, 0, 255, 255, 255, 0.24)
                        call ColorEffDummy3(e5, 0, 255, 255, 255, 0.24)
                    endif
                    call DestroyEffect(e6)
                    set k = 0
                    loop
                        exitwhen k == beamLineCount
                        call DestroyEffect(beamLineFx[k])
                        call DestroyEffect(beamFlameFx[k])
                        set beamLineFx[k] = null
                        set beamFlameFx[k] = null
                        set k = k + 1
                    endloop
                    set k = 0
                    loop
                        exitwhen k == beamHuoCount
                        call DestroyEffect(beamHuoFx[k])
                        set beamHuoFx[k] = null
                        set k = k + 1
                    endloop
                    call MouseOff(GetOwningPlayer(c))
                    if check == 0 then
                        call ColorEffDummy3(e3, 0, 255, 255, 255, 0.15)
                    endif
                    if GetLocalPlayer() == Player(k2) then
                        call BlzFrameSetVisible(frame0_pas1[k2], false)
                        call BlzFrameSetVisible(frame0_pas4[k2], false)
                    endif
                    call SetFly(c, 0)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    call DestroyGroup(g3)
                    set g = null
                    set g2 = null
                    set g3 = null
                    set u = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e5 = null
                    set e6 = null
                    set c = null
                    set m_TsunaT[i] = m_TsunaT[ MUI_TsunaT]
                    set MUI_TsunaT = MUI_TsunaT - 1
                    if MUI_TsunaT == -1 then
                        call PauseTimer( t_TsunaT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TsunaT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            local real tmp_x = 0
            local real tmp_y = 0
            set MUI_TsunaT = MUI_TsunaT + 1
            set m_TsunaT[ MUI_TsunaT] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)
            set r = 0
            set k3 = 0
            set k4 = 0
            set r2 = 40
            set check = 0
            set check2 = 0
            set a = GAngle2( c , x , y )
            set aoe = TsunaT_DamageAoe * TsunaT_Size
            set dmg = GetHeroAgi( c , true) * TsunaT_DamageAgiBase
            set dmg = dmg / TsunaT_Ticks
            set rmax = 6.5
            set g = CreateGroup()
            set g2 = CreateGroup()
            set g3 = CreateGroup()
            call SetUnitAnimationByIndex(c, 5)
            set r5 = 0
            set beamLineCount = 0
            set beamHuoCount = 0
            set beamAnimTime = 0
            set beamAnimTime2 = 0
            set beamAnimAngle = a
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set tmp_x = 0.29875
            set tmp_y = 0.17
            if frame0_pas1[k2] == null then
                set frame0_pas1[k2] = BlzCreateFrameByType("SIMPLEFRAME", "2Face", main_frame, "", 0)
                call BlzFrameClearAllPoints(frame0_pas1[k2])
                call BlzFrameSetVisible(frame0_pas1[k2], false)
                if GetLocalPlayer() == Player(k2) then
                    call BlzFrameSetVisible(frame0_pas1[k2], true)
                endif
                set frame0_pas2[k2] = BlzCreateFrameByType("SIMPLESTATUSBAR", "2FaceBackGround", frame0_pas1[k2], "", 0)
                set frame0_pas3[k2] = BlzCreateFrameByType("SIMPLESTATUSBAR", "2FaceForeGround", frame0_pas2[k2], "", 0)
                call BlzFrameClearAllPoints(frame0_pas2[k2])
                call BlzFrameClearAllPoints(frame0_pas3[k2])
                call BlzFrameSetAllPoints(frame0_pas2[k2], frame0_pas1[k2])
                call BlzFrameSetAllPoints(frame0_pas3[k2], frame0_pas1[k2])
                call BlzFrameSetSize(frame0_pas1[k2], 0.025, 0.025)
                set frame0_pas4[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", main_frame, "", 0)
                call BlzFrameSetPoint(frame0_pas4[k2], FRAMEPOINT_BOTTOMLEFT, frame0_pas1[k2], FRAMEPOINT_BOTTOMLEFT, tmp_x - 0.295, tmp_y - 0.335)
                call BlzFrameSetText(frame0_pas4[k2], "" + I2S(0) + "%|r")
                call BlzFrameSetScale(frame0_pas4[k2], 1)
                call BlzFrameSetSize(frame0_pas4[k2], 0.2, 0.2)
                call BlzFrameSetVisible(frame0_pas4[k2], false)
                if GetLocalPlayer() == Player(k2) then
                    call BlzFrameSetVisible(frame0_pas4[k2], true)
                endif
            else
                if GetLocalPlayer() == Player(k2) then
                    call BlzFrameSetVisible(frame0_pas1[k2], true)
                    call BlzFrameSetVisible(frame0_pas4[k2], true)
                endif
            endif
            call BlzFrameSetMinMaxValue(frame0_pas3[k2], 0, rmax)
            call BlzFrameSetValue(frame0_pas2[k2], 100)
            call BlzFrameSetValue(frame0_pas3[k2], 0)
            call BlzFrameSetText(frame0_pas4[k2], "" + I2S(0) + "%|r")
            call BlzFrameSetAbsPoint(frame0_pas1[k2], FRAMEPOINT_CENTER, tmp_x, tmp_y)
            call BlzFrameSetTexture(frame0_pas2[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_T.blp", 0, false)
            call BlzFrameSetTexture(frame0_pas3[k2], "ReplaceableTextures\\CommandButtonsDisabled\\DISBTNHero_Tsuna_T.blp", 0, false)
            set r = 0
            set e3 = EffectSpawn("war3mapImported\\wos_operation_x.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG + 180, 0, 5 * TsunaT_Size, 15 * TsunaT_Size)
            call MakeSound("war3mapimported\\Hero_Tsuna_T2")
            if MUI_TsunaT == 0 then
                call TimerStart( t_TsunaT, 0.05, true, function thistype.Loop_TsunaT)
            endif
        endmethod
    endstruct

    private struct TsunaT2KS
        private static timer t_TsunaT2 = CreateTimer( )
        private static integer array m_TsunaT2
        private static integer MUI_TsunaT2 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k2
        integer k3
        real r3
        real r4
        real r5
        real r6
        group g
        group g3
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        effect e5
        effect e6
        effect e7
        effect e8
        real a
        real rmax
        private static method Loop_TsunaT2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local integer kkk = 0
            local real rk = 0
            loop
                exitwhen i > MUI_TsunaT2
                set this = m_TsunaT2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r<= 0.3 then 
                        set r6 = r6 + r5
                        call SetFly(c,r6)
                    endif
                    if r == 0.39 then
                        call MakeSound("war3mapimported\\Hero_Tsuna_TT2")
                    endif
                    if r == 0.45 then
                        set r5 = 1100
                        set x1 = GetUnitX(c) + 80 * Cos(a)
                        set y1 = GetUnitY(c) + 80 * Sin(a)
                        set e7 = EffectSpawn3("war3mapImported\\wos_burner1.mdl", GetUnitX(c) - 30 * Cos(a), GetUnitY(c) - 30 * Sin(a), a * bj_RADTODEG - 41, 0.33, 0.75, r5 + 150, 55)
                        set e8 = EffectSpawn3("war3mapImported\\wos_burner1.mdl", GetUnitX(c) - 30 * Cos(a), GetUnitY(c) - 30 * Sin(a), a * bj_RADTODEG + 41, 0.33, 0.75, r5 + 150, 55)
                        set e5 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "hand right")
                        set e6 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "hand left")
                    endif
                    if r == 0.6 then
                        call MakeSound("war3mapimported\\Hero_Tsuna_TT3")
                        set e = EffectSpawnScale("war3mapImported\\wos_nuts_burner04.mdl", GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), a * bj_RADTODEG, 1, 1.5, r5, 0.9, 0.81, 1.5)
                        set move = (SR5(e, x, y) - 165) / 8
                        set r6 = r5 / 8
                        call ColorEffDummy4(e, 0, 255, 255, 255, 0.5)
                    endif
                    if r == 0.75 then
                        call BlzSetSpecialEffectTimeScale(e7, 1)
                        call BlzSetSpecialEffectTimeScale(e8, 1)
                    endif
                    if r == 1.02 then
                        call BlzSetSpecialEffectTimeScale(e7, 1.15)
                        call BlzSetSpecialEffectTimeScale(e8, 1.15)
                    endif
                    if r > 0.6 and r <= 1.5 then
                        set rk = 2
                        if r4 > 0.03 then
                            set r4 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", GetEffX(e), GetEffY(e), GetRandomReal(0, 359), rk, 2.5, r5))
                        else
                            set r4 = r4 + 0.03
                        endif
                    endif
                    if r == 1.62 then
                        set e2 = EffectSpawn3("war3mapImported\\wos_burner2.mdl", GetUnitX(c) + 1 * Cos(a), GetUnitY(c) + 1 * Sin(a), a * bj_RADTODEG + 180, 1, 3.75, 1250, -50)
                    endif
                    if r == 2.32 then
                        call MakeSound("war3mapimported\\Hero_Tsuna_TT5")
                    endif
                    if r == 1.5 then
                        call MakeSound("war3mapimported\\Hero_Tsuna_TT4")
                        call ScaleEffDummy(e, 0.45, 2, 8)
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.45)
                        set r4 = 0
                        set r3 = 2
                        set r2 = 40
                    endif
                    if r >= 1.5 and r < 1.74 then
                        call MoveEff(e, move, a)
                        set r5 = r5 - r6
                        call BlzSetSpecialEffectHeight(e, r5)
                    endif
                    if r == 1.8 then
                        call MakeSound("war3mapimported\\Hero_Tsuna_T9")
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_fantasybattle (1654)1.mdl", x, y, 1, 1.45, 1.5, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_papsnaz (707).mdl", x, y, 1, 1, 1.75, 1))
                        call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_papsnaz (1050).mdl", x, y, GetRandomReal(0, 359), 1.85, 0.01, 0, 0.12, 0.01, 3 * 0.6), 0.3, 255, 255, 255, rmax + 0.3 - r)
                    endif
                    if r >= 1.5 then
                        if r4 > 0.4 and r < rmax - 0.5 then
                            set r4 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_papsnaz (707).mdl", x, y, GetRandomReal(0, 359), 1, 1.75, 1))
                            set k = 0
                            set rk = 75
                            loop
                                exitwhen k == 5
                                call EffectSpawn2("war3mapImported\\wos_firefly-rq-sfx2.mdl", x1 + rk * Cos(a), y1 + rk * Sin(a), GetRandomReal(0, 359), 1, 1.4 + k * 0.3, 1100 - k * 105, 0.3)
                                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_cf2.mdl", x1 + rk * Cos(a), y1 + rk * Sin(a), a * bj_RADTODEG, GetRandomReal(0.9, 1.5), 1.15, 1100 - k * 100, -45))
                                set k = k + 1
                                set rk = rk + 145
                            endloop
                        else
                            set r4 = r4 + 0.03
                        endif
                        if r3 > 0.45 then
                            set r3 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl", x, y, GetRandomReal(0, 359), 1, 1.7, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdl", x, y, GetRandomReal(0, 359), 1, 3.55, 1))
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r2 > 0.21 then
                            set r2 = 0.03
                            if r > 1.8 then
                                call GroupClear(g)
                                set check2 = check2 + 1
                                call DecorRemove(c, x, y , aoe, 100)
                                call GroupEnumUnitsInRange( g , x, y, aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                        call dmgmag(c, u, dmg)
                                        if IsUnitInGroup(u, g3) == false then 
                                            call RootUnit(c,u,TsunaT_Root)
                                            call GroupAddUnit(g3, u)
                                        endif
                                        call SlowUnit(c, u, TsunaT2_Slow, TsunaT2_SlowDuration)
                                        call SilenceUnit(c, u, TsunaT2_SilenceDuration)
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            endif
                        else
                            set r2 = r2 + 0.05
                        endif
                    endif
                else
                    call SetUnitAnimation(c, "stand")
                    call BlzSetSpecialEffectTimeScale(e7, 1.5)
                    call BlzSetSpecialEffectTimeScale(e8, 1.5)
                    call ColorEffDummy3(e2, 0, 255, 255, 255, 0.15)
                    call ColorEffDummy3(e7, 0, 255, 255, 255, 0.15)
                    call ColorEffDummy3(e8, 0, 255, 255, 255, 0.15)
                    call DestroyEffect(e5)
                    call DestroyEffect(e6)
                    call StopSpellUnit(c)
                    call HeightSet(c, 0.3, 0)
                    call DestroyGroup(g)
                    call DestroyGroup(g3)
                    set g = null
                    set g3 = null
                    set u = null
                    set e = null
                    set e2 = null
                    set e5 = null
                    set e6 = null
                    set e7 = null
                    set e8 = null
                    set c = null
                    set m_TsunaT2[i] = m_TsunaT2[ MUI_TsunaT2]
                    set MUI_TsunaT2 = MUI_TsunaT2 - 1
                    if MUI_TsunaT2 == -1 then
                        call PauseTimer( t_TsunaT2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TsunaT2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            local real tmp_x = 0
            local real tmp_y = 0
            set MUI_TsunaT2 = MUI_TsunaT2 + 1
            set m_TsunaT2[ MUI_TsunaT2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set k3 = 0
            set r2 = 40
            set check = 0
            call TsundaFStackAdd(c, 5)
            set check2 = 0
            set a = GAngle2( c , x , y )
            set aoe = TsunaT2_DamageAoe
            set dmg = GetHeroAgi( c , true) * TsunaT2_DamageAgiBase
            set dmg = dmg / 13
            set rmax = 3.62
            if SR3(c, x, y) < 900 then
                call MUE(c, 900 - SR3(c, x, y), 0.3, a + 180 * bj_DEGTORAD)
            endif
            if SR3(c, x, y) > 900 then
                call MUE(c, 900 - SR3(c, x, y), 0.3, a + 180 * bj_DEGTORAD)
            endif
            set r5 = 900/10
            set g = CreateGroup()
            set g3 = CreateGroup()
            call StartSpellUnit(c)
            call SetUnitAnimationByIndex(c, 15)
            call SetUnitTimeScale(c, 0.5)
            set k2 = GetPlayerId(GetOwningPlayer(c))
            call MakeSound("war3mapimported\\Hero_Tsuna_TT1")
            if MUI_TsunaT2 == 0 then
                call TimerStart( t_TsunaT2, 0.03, true, function thistype.Loop_TsunaT2)
            endif
        endmethod
    endstruct

    private struct TsunaFKS
        private static timer t_TsunaF = CreateTimer( )
        private static integer array m_TsunaF
        private static integer MUI_TsunaF = -1
        unit c
        real r2
        integer k2
        real r3
        real r4
        real r5
        group g2
        group g3
        integer check
        real r
        effect e
        private static framehandle array frame_pas1
        private static framehandle array frame_pas2
        private static framehandle array frame_pas3
        private static framehandle array frame_pas4
        private static framehandle array frame_pas5
        private static framehandle array frame_pas6
        private static method Loop_TsunaF takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TsunaF
                set this = m_TsunaF[i]
                if check == GetUnitTypeId(c) and Hero[k2] != null then
                    if GetHeroLevel(c) >= 35 then
                        set r4 = TsunaF_Chance35
                    elseif GetHeroLevel(c) >= 25 then
                        set r4 = TsunaF_Chance25
                    else
                        set r4 = TsunaF_Chance12
                    endif
                    set r4 = r4 / 100
                    set r5 = 0
                    if LoadInteger(hs, GetHandleId(c), StringHash("instinct q")) > 0 then
                        set r5 = r5 + TsunaF_SkillSuccessfulAtkBonusAdd + 0.005
                    endif
                    if LoadInteger(hs, GetHandleId(c), StringHash("instinct w")) > 0 then
                        set r5 = r5 + TsunaF_SkillSuccessfulAtkBonusAdd + 0.005
                    endif
                    if LoadInteger(hs, GetHandleId(c), StringHash("instinct e")) > 0 then
                        set r5 = r5 + TsunaF_SkillSuccessfulAtkBonusAdd + 0.005
                    endif
                    if LoadInteger(hs, GetHandleId(c), StringHash("instinct r")) > 0 then
                        set r5 = r5 + TsunaF_SkillSuccessfulAtkBonusAdd + 0.005
                    endif
                    if LoadInteger(hs, GetHandleId(c), StringHash("instinct t")) > 0 then
                        set r5 = r5 + TsunaF_SkillSuccessfulAtkBonusAdd + 0.005
                    endif
                    if LoadInteger(hs, GetHandleId(c), StringHash("instinct g1")) > 0 then
                        set r5 = r5 + TsunaG_DamagetoF_Chance1 + 0.005
                    endif
                    if LoadInteger(hs, GetHandleId(c), StringHash("instinct g2")) > 0 then
                        set r5 = r5 + TsunaG_DamagetoF_Chance2 + 0.005
                    endif
                    if LoadInteger(hs, GetHandleId(c), StringHash("instinct g3")) > 0 then
                        set r5 = r5 + TsunaG_DamagetoF_Chance3 + 0.005
                    endif
                    if LoadInteger(hs, GetHandleId(c), StringHash("instinct g4")) > 0 then
                        set r5 = r5 + TsunaF_SkillSuccessfulAtkBonusAdd + 0.005
                    endif
                    set r5 = r5 / 100
                    set r3 = r4 + r5
                    if r3 >= 1 then
                        set r3 = 1
                    endif
                    call SaveReal(hs, GetHandleId(c), StringHash("instinct"), r3)
                    call BlzFrameSetValue(frame_pas3[k2], r3 * 100)
                    call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + I2S(R2I(r3 * 100)) + "% to dodge|r")
                else
                    if GetLocalPlayer() == Player(k2) then
                        call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("tsuna f loop"), 0)
                    set c = null
                    set m_TsunaF[i] = m_TsunaF[MUI_TsunaF]
                    set MUI_TsunaF = MUI_TsunaF - 1
                    if MUI_TsunaF == -1 then
                        call PauseTimer(t_TsunaF)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TsunaF_Start takes unit NewC returns nothing
            local thistype this
            if NewC == null or LoadInteger(hs, GetHandleId(NewC), StringHash("tsuna f loop")) > 0 then
                return
            endif
            call SaveInteger(hs, GetHandleId(NewC), StringHash("tsuna f loop"), 1)
            set this = thistype.create()
            set MUI_TsunaF = MUI_TsunaF + 1
            set m_TsunaF[MUI_TsunaF] = this
            set c = NewC
            set check = GetUnitTypeId(c)
            set r = 0
            set r2 = 0
            set r3 = TsunaF_Chance12
            set k2 = GetPlayerId(GetOwningPlayer(c))
            if frame_pas1[k2] == null then
                set frame_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                call BlzFrameSetAbsPoint(frame_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18)
                call BlzFrameSetSize(frame_pas1[k2], 0.135, 0.035)
                call BlzFrameSetTexture(frame_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                call BlzFrameSetVisible(frame_pas1[k2], false)
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame_pas1[k2], true)
                endif
                set frame_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame_pas1[k2], 0, 0)
                call BlzFrameSetAbsPoint(frame_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                call BlzFrameSetSize(frame_pas2[k2], 0.1, 0.019)
                set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)
                call BlzFrameSetSize(frame_pas3[k2], 0.1, 0.035)
                call BlzFrameSetScale(frame_pas3[k2], 0.5)
                call BlzFrameSetModel(frame_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                call BlzFrameSetAbsPoint(frame_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175)
                call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, 100)
                call BlzFrameSetValue(frame_pas3[k2], 0)
                set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
                call BlzFrameSetSize(frame_pas4[k2], 0.03, 0.03)
                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_F", 0, false)
                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Hyperintuition:" + "|r")
                call BlzFrameSetScale(frame_pas5[k2], 0.9)
                set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
                call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                call BlzFrameSetScale(frame_pas6[k2], 0.9)
            else
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame_pas1[k2], true)
                endif
                call BlzFrameSetValue(frame_pas3[k2], 0)
            endif
            if MUI_TsunaF == 0 then
                call TimerStart(t_TsunaF, 0.1, true, function thistype.Loop_TsunaF)
            endif
        endmethod
    endstruct

    private struct TsunaGKS
        private static timer t_TsunaG = CreateTimer( )
        private static integer array m_TsunaG
        private static integer MUI_TsunaG = -1
        unit c
        real x
        real y
        real r2
        integer k2
        integer k3
        real r3
        real dmg
        real r
        real a
        real rmax
        private static framehandle array frame1_pas1
        private static framehandle array frame1_pas2
        private static framehandle array frame1_pas3
        private static framehandle array frame1_pas4
        private static framehandle array frame1_pas5
        private static framehandle array frame1_pas6
        private static method Loop_TsunaG takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TsunaG
                set this = m_TsunaG[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs,GetHandleId(GetOwningPlayer(c)),StringHash("tsuna esc")) == 0 then
                    set r = r + 0.1
                    set r3 = LoadReal(hs, GetHandleId(c), StringHash("zero kai dmg"))
                    if GetUnitAbilityLevel(c, TsunaG_Stat_ID1) == 0 and r3 >= TsunaG_DamagetoStats1 then
                        call TsundaFStackAdd(c, 6)
                        call UnitAddAbility(c, TsunaG_Stat_ID1)
                        call EUTU2_3(EffectSpawn("war3mapimported\\wos_1daji_4.mdl", x, y, GetRandomReal(0, 359), 0.5, 3, 0), 1, 0, c)
                    endif
                    if GetHeroLevel(c) >= 25 and GetUnitAbilityLevel(c, TsunaG_Stat_ID2) == 0 and r3 >= TsunaG_DamagetoStats2 then
                        call TsundaFStackAdd(c, 7)
                        call UnitAddAbility(c, TsunaG_Stat_ID2)
                        call EUTU2_3(EffectSpawn("war3mapimported\\wos_1daji_4.mdl", x, y, GetRandomReal(0, 359), 0.5, 3, 0), 1, 0, c)
                    endif
                    if GetHeroLevel(c) >= 35 and GetUnitAbilityLevel(c, TsunaG_Stat_ID3) == 0 and r3 >= TsunaG_DamagetoStats3 then
                        call TsundaFStackAdd(c, 8)
                        call UnitAddAbility(c, TsunaG_Stat_ID3)
                        call EUTU2_3(EffectSpawn("war3mapimported\\wos_1daji_4.mdl", x, y, GetRandomReal(0, 359), 0.5, 3, 0), 1, 0, c)
                    endif
                   
                    call DebugUnit2(c)
                    if r2 >= 0.35 then
                        set r2 = 0
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_chargeorange2.mdl", x, y, GetRandomReal(0, 359), 2, 6, 121, 255, 255, 255, 100))
                        call EffectSpawn2("war3mapImported\\wos_az_wsy_gather3.mdl", x, y, 1, 1.25, 3, 50, 0.3)
                    else
                        set r2 = r2 + 0.1
                    endif
                     if r3 > k3 then
                        set r3 = I2R(k3)
                    endif
                    call BlzFrameSetText(frame1_pas6[k2], "|c00FFFF00" + I2S(R2I(r3)) + "/" + I2S(k3) + "|r")
                    call BlzFrameSetValue(frame1_pas3[k2], r3)
                else
                    call DebuffClear(c)
                    if GetUnitAbilityLevel(c, TsunaG_Stat_ID1) > 0 then
                        call MyRemoveAbility(c, TsunaG_StatsRemoveSec, TsunaG_Stat_ID1, 1)
                    endif
                    if GetUnitAbilityLevel(c, TsunaG_Stat_ID2) > 0 then
                        call MyRemoveAbility(c, TsunaG_StatsRemoveSec, TsunaG_Stat_ID2, 1)
                    endif
                    if GetUnitAbilityLevel(c, TsunaG_Stat_ID3) > 0 then
                        call MyRemoveAbility(c, TsunaG_StatsRemoveSec, TsunaG_Stat_ID3, 1)
                    endif
                    if GetHeroLevel(c) >= 35 and r3 >= TsunaG_DamagetoStats3 then
                        call SwapAbility(c, TsunaG2_TimeToEnter, TsunaG2_ID, TsunaG_ID)
                    endif
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("zero kai"), 0)
                    if r3 > 0 then
                        call MakeSound("war3mapimported\\Hero_Tsuna_G4")
                        call MakeSound("war3mapimported\\Hero_Tsuna_G5")
                        call SetMpCurrent(c, r3 * (TsunaG_DamagetoMana / 100))
                    endif
                    call StopSpellUnit2(c)
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame1_pas1[k2], false)
                    endif
                    set c = null
                    set m_TsunaG[i] = m_TsunaG[ MUI_TsunaG]
                    set MUI_TsunaG = MUI_TsunaG - 1
                    if MUI_TsunaG == -1 then
                        call PauseTimer( t_TsunaG)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TsunaG_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            local real tmp_y = 0.0375
            set MUI_TsunaG = MUI_TsunaG + 1
            set m_TsunaG[ MUI_TsunaG] = this
            set c = NewC
            set r = 0
            set r2 = 0
            call StartSpellUnit2(c)
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set rmax = TsunaG_Duration
            call SaveInteger(hs,GetHandleId(GetOwningPlayer(c)),StringHash("tsuna esc"),0) 
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(TsunaG_ID)), 0)
            set k2 = GetPlayerId(GetOwningPlayer(c))
            if GetHeroLevel(c) >= 35 then
                set k3 = R2I(TsunaG_DamagetoStats3 )
            elseif GetHeroLevel(c) >= 25 then
                set k3 = R2I(TsunaG_DamagetoStats2 )
            else
                set k3 = R2I(TsunaG_DamagetoStats1 )
            endif
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("zero kai"), 1)
            call SetUnitAnimationByIndex(c, 1)
            call MakeSound("war3mapimported\\Hero_Tsuna_G")
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_Tsuna_G2")
            else
                call MakeSound("war3mapimported\\Hero_Tsuna_G3")
            endif
            if frame1_pas1[k2] == null then
                set frame1_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                call BlzFrameSetAbsPoint(frame1_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18 + tmp_y)
                call BlzFrameSetSize(frame1_pas1[k2], 0.135, 0.035)
                call BlzFrameSetTexture(frame1_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                call BlzFrameSetVisible(frame1_pas1[k2], false)
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame1_pas1[k2], true)
                endif
                set frame1_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame1_pas1[k2], 0, 0)
                call BlzFrameSetAbsPoint(frame1_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                call BlzFrameSetSize(frame1_pas2[k2], 0.1, 0.019)
                set frame1_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame1_pas1[k2], "", 0)
                call BlzFrameSetSize(frame1_pas3[k2], 0.1, 0.035)
                call BlzFrameSetScale(frame1_pas3[k2], 0.5)
                call BlzFrameSetModel(frame1_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                call BlzFrameSetAbsPoint(frame1_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175 + tmp_y)
                call BlzFrameSetMinMaxValue(frame1_pas3[k2], 0, I2R(k3))
                call BlzFrameSetValue(frame1_pas3[k2], 0)
                set frame1_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame1_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame1_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18 + tmp_y)
                call BlzFrameSetSize(frame1_pas4[k2], 0.03, 0.03)
                call BlzFrameSetTexture(frame1_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_G", 0, false)
                set frame1_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame1_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                call BlzFrameSetText(frame1_pas5[k2], "|c00FFFF00" + "Flame absorbed:|r")
                call BlzFrameSetScale(frame1_pas5[k2], 0.9)
                set frame1_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame1_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17 + tmp_y)
                call BlzFrameSetText(frame1_pas6[k2], "|c00FFFF00" + "0/" + I2S(k3) + "|r")
                call BlzFrameSetScale(frame1_pas6[k2], 0.9)
            else
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame1_pas1[k2], true)
                endif
                call BlzFrameSetText(frame1_pas6[k2], "|c00FFFF00" + "0/" + I2S(k3) + "|r")
                call BlzFrameSetMinMaxValue(frame1_pas3[k2], 0, I2R(k3+5))
                call BlzFrameSetValue(frame1_pas3[k2], 0)
                set r3 = LoadReal(hs, GetHandleId(c), StringHash("zero kai dmg"))
                if r3 > k3 then
                    set r3 = I2R(k3)
                endif
                call BlzFrameSetText(frame1_pas6[k2], "|c00FFFF00" + I2S(R2I(r3)) + "/" + I2S(k3) + "|r")
                call BlzFrameSetValue(frame1_pas3[k2], r3)
            endif
            if MUI_TsunaG == 0 then
                call TimerStart( t_TsunaG, 0.1, true, function thistype.Loop_TsunaG)
            endif
        endmethod
    endstruct

    private struct TsunaG2KS
        private static timer t_TsunaG2 = CreateTimer( )
        private static integer array m_TsunaG2
        private static integer MUI_TsunaG2 = -1
        unit c
        real x
        real y
        real r2
        integer k2
        group g
        real dmg
        integer check
        real r
        effect e
        effect e2
        effect e3
        real rmax
        private static framehandle array frame2_pas1
        private static framehandle array frame2_pas2
        private static framehandle array frame2_pas3
        private static framehandle array frame2_pas4
        private static framehandle array frame2_pas5
        private static framehandle array frame2_pas6
        private static method Loop_TsunaG2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real tmp_y = 0.035
            loop
                exitwhen i > MUI_TsunaG2
                set this = m_TsunaG2[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                    if check == 0 then
                        call DebugUnit(c)
                        set r = r + 0.03
                        set r = S2R( R2SW( r , 0, 3 ) )
                        if r == 0.81 then
                            call MakeSound("war3mapimported\\Hero_Tsuna_GS2")
                        endif
                        call BlzSetSpecialEffectPosition(e, GetUnitX(c), GetUnitY(c), 0)
                        if r == TsunaG2_CastTime then
                            call DestroyEffect(e)
                            call DestroyEffect(e2)
                            set e = null
                            set e2 = null
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_chargeorange2.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 8, 0))
                            call NextSound("war3mapimported\\Hero_Tsuna_GS3", 0.6)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaG_ID, false)
                            call UnitAddAbility(c, TsunaG3_ID)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaG3_ID, true)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaQ2_ID, true)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaW3_ID, true)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaE2_ID, true)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaR2_ID, true)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaT3_ID, true)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaQ_ID, false)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaW_ID, false)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaE_ID, false)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaR_ID, false)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaT_ID, false)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaT2_ID, false)
                            call UnitAddAbility(c, TsunaQ2_ID)
                            call UnitAddAbility(c, TsunaW3_ID)
                            call UnitAddAbility(c, TsunaE2_ID)
                            call UnitAddAbility(c, TsunaR2_ID)
                            call UnitAddAbility(c, TsunaT3_ID)
                            call OkarunEggCd(c,TsunaQ2_ID,BlzGetUnitAbilityCooldownRemaining(c, TsunaQ_ID) - TsunaG2_ReduceCD)
                            call OkarunEggCd(c,TsunaW3_ID,BlzGetUnitAbilityCooldownRemaining(c, TsunaW_ID) - TsunaG2_ReduceCD)
                            call OkarunEggCd(c,TsunaE2_ID,BlzGetUnitAbilityCooldownRemaining(c, TsunaE_ID) - TsunaG2_ReduceCD)
                            call OkarunEggCd(c,TsunaR2_ID,BlzGetUnitAbilityCooldownRemaining(c, TsunaR_ID) - TsunaG2_ReduceCD)
                            call OkarunEggCd(c,TsunaT3_ID,BlzGetUnitAbilityCooldownRemaining(c, TsunaT_ID) - TsunaG2_ReduceCD)
                            call SetUnitAbilityLevel(c, TsunaQ2_ID, GetUnitAbilityLevel(c, TsunaQ_ID))
                            call SetUnitAbilityLevel(c, TsunaW3_ID, GetUnitAbilityLevel(c, TsunaW_ID))
                            call SetUnitAbilityLevel(c, TsunaE2_ID, GetUnitAbilityLevel(c, TsunaE_ID))
                            call SetUnitAbilityLevel(c, TsunaR2_ID, GetUnitAbilityLevel(c, TsunaR_ID))
                            call BlzSetUnitSkin(c, Tsuna2_ID)
                            call AAUniversalTooltips_SetUnitForm(c, 1)
                            set e3 = AddSpecialEffectTarget("war3mapImported\\wos_tsunaaura.mdl", c, "origin")
                            call FixAura(c)
                            call DecorRemove(c, x, y, TsunaG2_TransformDecorAoe, TsunaG2_TransformDecorDamage)
                            call VisionTimed(GetOwningPlayer(c), x , y, 1500, 2)
                            set check = 1
                            call StopSpellUnit(c)
                            set r = 0
                            if frame2_pas1[k2] == null then
                                set frame2_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18 + tmp_y)
                                call BlzFrameSetSize(frame2_pas1[k2], 0.135, 0.035)
                                call BlzFrameSetTexture(frame2_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                                call BlzFrameSetVisible(frame2_pas1[k2], false)
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                                endif
                                set frame2_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame2_pas1[k2], 0, 0)
                                call BlzFrameSetAbsPoint(frame2_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                                call BlzFrameSetSize(frame2_pas2[k2], 0.1, 0.019)
                                set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)
                                call BlzFrameSetSize(frame2_pas3[k2], 0.1, 0.035)
                                call BlzFrameSetScale(frame2_pas3[k2], 0.5)
                                call BlzFrameSetModel(frame2_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                                call BlzFrameSetAbsPoint(frame2_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175 + tmp_y)
                                call BlzFrameSetMinMaxValue(frame2_pas3[k2], 0, rmax)
                                call BlzFrameSetValue(frame2_pas3[k2], rmax)
                                set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18 + tmp_y)
                                call BlzFrameSetSize(frame2_pas4[k2], 0.03, 0.03)
                                call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_G2", 0, false)
                                set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                                call BlzFrameSetText(frame2_pas5[k2], "|c00FFFF00" + "Morph Time Left:" + "|r")
                                call BlzFrameSetScale(frame2_pas5[k2], 0.9)
                                set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17 + tmp_y)
                                call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                                call BlzFrameSetScale(frame2_pas6[k2], 0.9)
                            else
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                                endif
                                call BlzFrameSetValue(frame2_pas3[k2], rmax)
                            endif
                        endif
                    elseif check == 1 then
                        if IsUnitPaused(c) == false and LoadInteger(hs,GetHandleId(c), StringHash("mode def")) == 0 then
                            set r = r + 0.03
                        endif
                        set r = S2R( R2SW( r , 0, 3 ) )
                        call BlzFrameSetValue(frame2_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                    endif
                else
                    call SaveInteger(hs, GetHandleId(c), StringHash("mode g"), 0)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaG3_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaQ2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaW3_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaE2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaR2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaT3_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaG_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaQ_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaW_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaE_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaR_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TsunaT_ID, true)
                    
                    call BlzStartUnitAbilityCooldown(c, TsunaQ2_ID, BlzGetUnitAbilityCooldownRemaining(c, TsunaQ2_ID))
                    call BlzStartUnitAbilityCooldown(c, TsunaW_ID, BlzGetUnitAbilityCooldownRemaining(c, TsunaW3_ID))
                    call BlzStartUnitAbilityCooldown(c, TsunaE_ID, BlzGetUnitAbilityCooldownRemaining(c, TsunaE2_ID))
                    call BlzStartUnitAbilityCooldown(c, TsunaR_ID, BlzGetUnitAbilityCooldownRemaining(c, TsunaR2_ID))
                    call BlzStartUnitAbilityCooldown(c, TsunaT_ID, BlzGetUnitAbilityCooldownRemaining(c, TsunaT3_ID))
                    call BlzSetUnitSkin(c, Tsuna_ID)
                    call AAUniversalTooltips_SetUnitForm(c, 0)
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame2_pas1[k2], false)
                    endif
                    if check == 0 then
                        call StopSpellUnit(c)
                    endif
                    call FixAura(c)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_TsunaG2[i] = m_TsunaG2[ MUI_TsunaG2]
                    set MUI_TsunaG2 = MUI_TsunaG2 - 1
                    if MUI_TsunaG2 == -1 then
                        call PauseTimer( t_TsunaG2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TsunaG2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_TsunaG2 = MUI_TsunaG2 + 1
            set m_TsunaG2[ MUI_TsunaG2] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            call StartSpellUnit(c)
            set check = 0
            set r = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set r2 = 10
            call SaveReal(hs, GetHandleId(c), StringHash("zero kai dmg"), 0)
            call UnitRemoveAbility(c, TsunaW_Buff_ID)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(TsunaG_ID)), 1)
            call SaveInteger(hs, GetHandleId(c), StringHash("mode g"), 1)
            set e = EffectSpawn("war3mapImported\\wos_huoqiang.mdl", x, y, 1, 1, 1.5, 0)
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_tsunaaura.mdl", c, "origin")
            set rmax = TsunaG2_Duration
            call MakeSound("war3mapimported\\Hero_Tsuna_GS1")
            if MUI_TsunaG2 == 0 then
                call TimerStart( t_TsunaG2, 0.03, true, function thistype.Loop_TsunaG2)
            endif
        endmethod
    endstruct

    private struct TsunaG3KS
        private static timer t_TsunaG3 = CreateTimer( )
        private static integer array m_TsunaG3
        private static integer MUI_TsunaG3 = -1
        unit c
        real x
        real y
        integer k
        group g
        unit u
        integer check2
        real aoe
        real r
        effect e
        real rmax
        private static method Loop_TsunaG3 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real tmp_y = 0.035
            loop
                exitwhen i > MUI_TsunaG3
                set this = m_TsunaG3[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false and LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 1 then
                    if IsUnitPaused(c) == false then
                        set r = r + 0.03
                        set r = S2R( R2SW( r , 0, 3 ) )
                    endif
                    if r == 1.32 then
                        call MakeSound("war3mapimported\\Hero_Tsuna_GG2")
                    endif
                else
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call GroupClear(g)
                    call DecorRemove(c, x, y , aoe, TsunaG3_DecorDamage)
                    call GroupEnumUnitsInRange( g , x, y, aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                            set check2 = check2 + 1
                            call StunUnit(c, u, TsunaG3_StunDuration)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                    if check2 > 0 then
                        call TsundaFStackAdd(c, 9)
                    endif
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_natsroar.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.75, 1, 1))
                    set k = 0
                    loop
                        exitwhen k == 5
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_gnaden_air.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.5, k, 1, 255, 150, 0, 255))
                        set k = k + 1
                    endloop
                    call UnitRemoveAbility(c, TsunaG3_Buff_ID)
                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_chargeorange2.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 12, 121, 255, 255, 255, 135))
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.21)
                    call SaveInteger(hs, GetHandleId(c), StringHash("mode def"), 0)
                    set k = GetPlayerId(GetOwningPlayer(c))
                    if TsunaG3_Unit[k] != null then
                        call RemoveUnit(TsunaG3_Unit[k])
                    endif
                    set TsunaG3_Unit[k] = CreateUnit(GetOwningPlayer(c), TsunaG3_Unit_ID, GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 1)
                    call DestroyGroup(g)
                    set c = null
                    set e = null
                    set g = null
                    set u = null
                    set m_TsunaG3[i] = m_TsunaG3[ MUI_TsunaG3]
                    set MUI_TsunaG3 = MUI_TsunaG3 - 1
                    if MUI_TsunaG3 == -1 then
                        call PauseTimer( t_TsunaG3)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TsunaG3_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_TsunaG3 = MUI_TsunaG3 + 1
            set m_TsunaG3[ MUI_TsunaG3] = this
            set c = NewC
            set r = 0
            set u = null
            set check2 = 0
            set g = CreateGroup()
            set aoe = TsunaG3_DamageAoe
            call SaveInteger(hs, GetHandleId(c), StringHash("mode def"), 1)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_sawada_def01.mdl", c, "chest")
            set rmax = TsunaG3_Duration
            call MakeSound("war3mapimported\\Hero_Tsuna_GG")
            call MyFrameBuffSlot(c, TsunaG3_Buff_ID, rmax, "BTNHero_Tsuna_TG", true, 1)
            if MUI_TsunaG3 == 0 then
                call TimerStart( t_TsunaG3, 0.03, true, function thistype.Loop_TsunaG3)
            endif
        endmethod
    endstruct

    function TsunaDodge takes unit c, unit td returns nothing
        local real cd = 0
        call EUTU2(EffectSpawn("war3mapImported\\wos_az_wsy_gather3.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 2, 90), TsunaF_DodgeDuration, 90, c)
        call MakeSound("war3mapimported\\Hero_Tsuna_F")
        if GetHeroLevel(c) >= 35 then
            set cd = TsunaF_CD35
        elseif GetHeroLevel(c) >= 25 then
            set cd = TsunaF_CD25
        else
            set cd = TsunaF_CD12
        endif
        if IsUnitPaused(c) == false then
            call MUE(c, TsunaF_DodgeDistance, TsunaF_DodgeDuration, GAngle(c, td) + GetRandomReal( -30, 30) * bj_DEGTORAD)
        endif
        call FakeCD_Start(c, TsunaF_ID, cd, 0, 0)
    endfunction
    function TsunaQ_Start takes unit c, real x, real y returns nothing
        call TsunaQKS.TsunaQ_Start(c, x, y)
    endfunction
    
    function TsunaQ2_Start takes unit c, real x, real y returns nothing
        if GetUnitAbilityLevel(c, TsunaG3_Buff_ID) > 0 then 
            call IssueImmediateOrder(c, "stop")
            call SetMpCurrent(c, BlzGetAbilityManaCost(TsunaQ2_ID, GetUnitAbilityLevel(c, TsunaQ2_ID) - 1))
        else
            call TsunaQ2KS.TsunaQ2_Start(c, x, y)
        endif
    endfunction
    function TsunaW_Start takes unit c returns nothing
        call BuffUnit1(c, c, 4)
        call MyEffBuff(c, TsunaW_Buff_ID, AddSpecialEffectTarget("war3mapImported\\wos_icefile00002579.mdl", c, "hand right"))
        call MyEffBuff(c, TsunaW_Buff_ID, AddSpecialEffectTarget("war3mapImported\\wos_icefile00002579.mdl", c, "hand left"))
        call SwapAbilityBuff(c, TsunaW2_ID, TsunaW_ID, TsunaW_Buff_ID)
        call SetUnitAbilityLevel(c,TsunaW2_ID,GetUnitAbilityLevel(c,TsunaW_ID))
        call MyFrameBuffSlot(c, TsunaW_Buff_ID, TsunaW_BuffDuration, "BTNHero_Tsuna_W", true, 2)
        call MakeSound("war3mapimported\\Hero_Tsuna_W")
    endfunction
    function TsunaW2_Start takes unit c, real x, real y returns nothing
        call TsunaWKS.TsunaW_Start( c )
    endfunction
    function TsunaW3_Start takes unit c, real x, real y returns nothing
        if GetUnitAbilityLevel(c,TsunaG3_Buff_ID)>0 then 
            call IssueImmediateOrder(c,"stop")
            call SetMpCurrent(c,BlzGetAbilityManaCost(TsunaW3_ID,GetUnitAbilityLevel(c,TsunaW3_ID)-1))
        else
            call TsunaW2KS.TsunaW2_Start( c, x, y )
        endif
    endfunction
    function TsunaE_Start takes unit c, real x, real y returns nothing
        call TsunaEKS.TsunaE_Start( c, x, y )
    endfunction
    function TsunaE2_Start takes unit c, real x, real y returns nothing
        if GetUnitAbilityLevel(c,TsunaG3_Buff_ID)>0 then 
            call IssueImmediateOrder(c,"stop")
            call SetMpCurrent(c,BlzGetAbilityManaCost(TsunaE2_ID,GetUnitAbilityLevel(c,TsunaE2_ID)-1))
        else
            call TsunaE2KS.TsunaE2_Start( c, x, y )
        endif
    endfunction
    function TsunaR_Start takes unit c, unit td returns nothing
        call TsunaRKS.TsunaR_Start( c, td )
    endfunction
    function TsunaR2_Start takes unit c, real x, real y returns nothing
        if GetUnitAbilityLevel(c,TsunaG3_Buff_ID)>0 then 
            call IssueImmediateOrder(c,"stop")
            call SetMpCurrent(c,BlzGetAbilityManaCost(TsunaR2_ID,GetUnitAbilityLevel(c,TsunaR2_ID)-1))
        else
            call TsunaR2KS.TsunaR2_Start( c, x, y )
        endif
    endfunction
    function TsunaT_Start takes unit c, real x, real y returns nothing
        call SaveInteger(hs, GetHandleId(c), StringHash("cast t"), 0)
        call TsunaTKS.TsunaT_Start( c, x, y)
    endfunction
    function TsunaT2_Start takes unit c returns nothing    
        call StartSpellUnit(c)
        call SaveInteger(hs, GetHandleId(c), StringHash("cast t"), 1)
    endfunction
    function TsunaT3_Start takes unit c, real x, real y returns nothing
        if GetUnitAbilityLevel(c,TsunaG3_Buff_ID)>0 then 
            call IssueImmediateOrder(c,"stop")
            call SetMpCurrent(c,BlzGetAbilityManaCost(TsunaT3_ID,GetUnitAbilityLevel(c,TsunaT3_ID)-1))
        else
            call TsunaT2KS.TsunaT2_Start( c, x, y)
        endif
    endfunction
    function TsunaF_Start takes unit c returns nothing
        local integer k = GetPlayerId(GetOwningPlayer(c))
        if LoadInteger(hs, GetHandleId(c), StringHash("tsuna f loop")) == 0 then
            call TsunaFKS.TsunaF_Start(c)
            if TsunaG3_Unit[k] != null then
                call RemoveUnit(TsunaG3_Unit[k])
            endif
            set TsunaG3_Unit[k] = CreateUnit(GetOwningPlayer(c), TsunaG3_Unit_ID, GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 1)
        endif
    endfunction
    function TsunaG_Start takes unit c returns nothing
        // Защита от двух параллельных экземпляров G для одного игрока.
        // Накопленный zero kai dmg намеренно не сбрасывается между применениями.
        if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("zero kai")) == 0 then
            call TsunaGKS.TsunaG_Start( c )
        endif
    endfunction
    function TsunaG2_Start takes unit c returns nothing
        if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 0 then
            call TsunaG2KS.TsunaG2_Start(c)
        endif
    endfunction
    function TsunaG3_Start takes unit c returns nothing
        local integer k = GetPlayerId(GetOwningPlayer(c))
        if LoadInteger(hs, GetHandleId(c), StringHash("mode def")) == 0 then
            if TsunaG3_Unit[k] != null then
                call RemoveUnit(TsunaG3_Unit[k])
                set TsunaG3_Unit[k] = null
            endif
            call BuffUnit1(c, c, 5)
            call TsunaG3KS.TsunaG3_Start(c)
        endif
    endfunction
endlibrary
