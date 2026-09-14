library MilimSpells uses GearSystems
    globals
//--------------------------------------Milim--------------------------------------------------------------
        integer Milim_ID = 'H00A'
        integer Milim2_ID = 'H00H'
//---------------Q ability-----------------------------------------------------
        integer MilimQ_ID = 'A000'
        real MilimQ_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real MilimQ_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real MilimQ_Damage2StaticBase = 50 // base static damage for 1 level
        real MilimQ_Damage2StaticStep = 25 // additional static damage for each next level
        real MilimQ_DamageAoe = 155
        real MilimQ_DamageAoe2 = 350
        real MilimQ_Range = 1255
        real MilimQ_PushRange = 450 // slow time 2, 3, 4 sec only
        real MilimQ_PushDuration = 0.3 // slow time 2, 3, 4 sec only
//---------------W ability-----------------------------------------------------
        integer MilimW_ID = 'A001'
        integer MilimW2_ID = 'A00S'
        real MilimW_DamageAgiBase = 0.5 // base number x Agi damage for 1 level
        real MilimW_DamageAgiStep = 0.25 // additional number x Agi damage for each next level
        real MilimW_Damage2StaticBase = 25 // base static damage for 1 level
        real MilimW_Damage2StaticStep = 25 // additional static damage for each next level
        real MilimW2_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real MilimW2_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real MilimW2_Damage2StaticBase = 100 // base static damage for 1 level
        real MilimW2_Damage2StaticStep = 25 // additional static damage for each next level
        real MilimW_TimetoSwapAbi = 2
        real MilimW_DamageAoe = 600
        real MilimW_PushRange = 300
        real MilimW_PushTime = 0.24
        real MilimW2_DamageAoe = 900
        integer MilimW2_Slow = 50
        integer MilimW2_SlowDuration = 2
        real MilimW2_TightRange = 50
        real MilimW2_TightDuration = 0.15
//---------------E ability-----------------------------------------------------
        integer MilimE_ID = 'A002'
        real MilimE_DamageAgiBase = 3 // base number x Agi damage for 1 level
        real MilimE_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real MilimE_RangeBase = 1200.00
        real MilimE_RangeStep = 100.00
        real MilimE_DamageAoe = 235
        real MilimE_DamageAoeFinal = 520
//---------------R ability-----------------------------------------------------
        integer MilimR_ID = 'A003'
        real MilimR_DamageAgiBase = 5 // base number x Agi damage for 1 level
        real MilimR_DamageAgiStep = 1 // additional number x Agi damage for each next level
        integer MilimR_Slow = 65
        real MilimR_DamageAoe = 700.00
        integer MilimR_SlowDuration = 2
//---------------T ability-----------------------------------------------------
        integer MilimT_ID = 'A004' //
        real MilimT_DamageAgiBase = 18 // overall for all 3 sec
        real MilimT_DamageAoe = 465 
        integer MilimT_Slow = 50 // Caused slow %
        integer MilimT_SlowDuration = 2 // slow time 2, 3, 4 sec only
        real MilimT_Root = 0 
        real MilimT_Duration = 20
        real MilimT_SilenceDuration = 1 // 
//---------------T2 ability-----------------------------------------------------
        integer MilimT2_ID = 'A015' //
        real MilimT2_DamageAgiBase = 17 // overall
        real MilimT2_DamageAoe = 980 // 
        real MilimT2_Root = 0
        integer MilimT2_Slow = 80 // Caused slow %
        integer MilimT2_SlowDuration = 3 // slow time 2, 3, 4 sec only
        real MilimT2_SilenceDuration = 0.5 // 
        real MilimT2_ChargeTime = 2.00
    real MilimT2_BeamDuration = 1.50
    real MilimT2_BeamRange = 3000.00
    real MilimT2_BeamScanStep = 300.00
    real MilimT2_DamagePeriod = 0.15
    integer MilimT2_DamageTicks = 6
//---------------F ability-----------------------------------------------------
        integer MilimF_ID = 'A01V'
        real MilimF_Aoe = 650 // aoe where passive works
//---------------G ability-----------------------------------------------------
        integer MilimG_ID = 'A01U'
        integer MilimG_Stat_ID1 = 'A08I'
        integer MilimG_Stat_ID2 = 'A08K'
        integer MilimG_Stat_ID3 = 'A08J'
        real MilimG_Duration = 3 
        real MilimG_StatsRemoveSec = 10 //after X sec remove stats after ability end
        real MilimG_DamagetoMana = 20 //% damage converted to mana
        real MilimG_DamagetoStats1 = 1250 //when absorbdamage
        real MilimG_DamagetoF_Chance1 = 10 //how much chance add first damage counter
        real MilimG_DamagetoStats2 = 2500 //when absorbdamage
        real MilimG_DamagetoF_Chance2 = 10 //how much chance add second damage counter
        real MilimG_DamagetoStats3 = 3750 //when absorbdamage
        real MilimG_DamagetoF_Chance3 = 10 //how much chance add third damage counter
    endglobals
       
    private struct MilimQKS
        private static timer t_MilimQ = CreateTimer( )
        private static integer array m_MilimQ
        private static integer MUI_MilimQ = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k
        integer k3
        real r5
        real r6
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
        effect e
        effect e2
        effect e3
        real a
        real rmax
        private static method Loop_MilimQ takes nothing returns nothing
            local integer this
            local integer i = 0
            
            loop
                exitwhen i > MUI_MilimQ
                set this = m_MilimQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                        call DebugUnit2(c)
                        if check == 0 then 
                        if r == 0.3 then 
                        call SetUnitAnimationByIndex(c, 3)
                        
                call SetUnitTimeScale(c,1.25)
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_bdef (383).mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.25, 1, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_DustWindFaster3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.25, 1, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_cf1.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.25, 1, 1))
                        endif
                        if r == 0.54 then 
                        call SetUnitTimeScale(c,0)
                
                        endif
                        if r > 0.3 then
                            if r5 <= r7 then //SR3(c, x, y) > 120 then
                                set r5 = r5 + move
                                call MoveUnit(c, move, a)
                                call SetUnitFacing(c, a * bj_RADTODEG)
                                call GroupClear(g)
                                call DecorRemove(c, GetUnitX(c), GetUnitY(c), aoe, 20)
                                
                                    call GroupEnumUnitsInRange( g , GetUnitX(c), GetUnitY(c) , aoe + 25, NoDecor_Cond)
                                    loop
                                        set u = FirstOfGroup( g )
                                        exitwhen u == null or check == 1
                                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                            set check = 1
                                            call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdx", c, "hand right"),0.18)
                        call SetUnitTimeScale(c,1.5)
                                            set td = u
                                            set r = 0
                                            call SetUnitPosition(td, GetUnitX(c) + 110 * Cos(a), GetUnitY(c) + 110 * Sin(a))
                                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_HakkeStart.mdx", GetUnitX(c) + 110 * Cos(a), GetUnitY(c) + 110 * Sin(a), 0,1.75, 0.75, 5))
                                        endif
                                        call GroupRemoveUnit( g , u )
                                    endloop
                                    set u = null
                            
                                set r6 = 90
                                if r2 > 0.03 then
                                    set r2 = 0
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
                call MakeSound("war3mapimported\\Hero_Milim_Q 2")
                        endif
                        if r == 0.3 then
                            call dmgphys(c, td, dmg)
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x , y , a * bj_RADTODEG, 0.5, 4.25, 125))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BDEF (124)2.mdx", x, y, GetRandomReal(0, 359), 1, 2.5, 125))
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 2.45, 2, 255, 255, 255, 255))
                        call DestroyEffect(EffectSpawn("war3mapImported\\senji-wind-impact-2.mdx", x+190*Cos(a), y+190*Sin(a), a*bj_RADTODEG, 2, 1.15, 85))
                        call DestroyEffect(EffectSpawn("war3mapImported\\senji-wind-impact-2.mdx", x+290*Cos(a), y+290*Sin(a), a*bj_RADTODEG, 1.9, 1.35, 85))
                        call DestroyEffect(EffectSpawn("war3mapImported\\senji-wind-impact-2.mdx", x+390*Cos(a), y+390*Sin(a), a*bj_RADTODEG, 1.8, 1.55, 85))
                        call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1, 0.8, 0, 1)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_bloodex-special-23.mdl", GetUnitX(td), GetUnitY(td), GetRandomReal(0, 359), 2.5, 2, 80))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x + 25 * Cos(a), y + 25 * Sin(a) , a * bj_RADTODEG, 1, 2.25, 125))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_cf2.mdx", x + 125 * Cos(a), y + 125 * Sin(a) , a * bj_RADTODEG, 0.6, 1.45, 15))
                          call DecorRemove(c,x,y,MilimQ_DamageAoe2,25)
                                set r = 99999
                                call GroupEnumUnitsInRange(g, x, y, MilimQ_DamageAoe2, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgphys(c, u, dmg)
                                call MUE(u, MilimQ_PushRange, MilimQ_PushDuration, a)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                           endif
                           endif
                else
                    
                        call StopSpellUnit2(c)
                    call SetUnitTimeScale( c , 1)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    call DestroyGroup( g )
                    call DestroyGroup( g2 )
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set u = null
                    set m_MilimQ[i] = m_MilimQ[ MUI_MilimQ]
                    set MUI_MilimQ = MUI_MilimQ - 1
                    if MUI_MilimQ == -1 then
                        call PauseTimer( t_MilimQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method MilimQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_MilimQ = MUI_MilimQ + 1
            set m_MilimQ[ MUI_MilimQ] = this
            set c = NewC
            set td = null
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set r5 = 0
            set k3 = 0
            set r7 = MilimQ_Range
            set check = 0
            set move = 120
            set check2 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = MilimQ_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( MilimQ_DamageAgiBase + ( MilimQ_DamageAgiStep * ( GetUnitAbilityLevel( c , MilimQ_ID) - 1 ) ) )
            set dmg = dmg + MilimQ_Damage2StaticBase + ( MilimQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , MilimQ_ID) - 1 ) )
            set rmax = 2.1
            set e = AddSpecialEffectTarget("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdx", c, "hand right")
            set e2 = AddSpecialEffectTarget("war3mapImported\\file00001662.mdl", c, "hand right")
            set e3 = AddSpecialEffectTarget("war3mapimported\\wos_SlidingDustWithRocks.mdx", c, "origin")
                call SetUnitAnimationByIndex(c, 7)
                call SetUnitTimeScale(c,1.5)
                call MakeSound("war3mapimported\\Hero_Milim_Q 1")
            if MUI_MilimQ == 0 then
                call TimerStart( t_MilimQ, 0.03, true, function thistype.Loop_MilimQ)
            endif
        endmethod
    endstruct
   
private struct MilimWKS
    private static constant real TIMER_PERIOD    = 0.03
    private static constant real JUMP_DELAY      = 0.30
    private static constant real JUMP_DURATION   = 0.60
    private static constant real JUMP_HEIGHT     = 4000.00
    private static constant real EFFECT_Z_OFFSET = 240.00

    private static timer t_MilimW = CreateTimer()
    private static integer array m_MilimW
    private static integer MUI_MilimW = -1

    unit c
    real x
    real y
    real startX
    real startY
    real delayElapsed
    real r
    real f
    real progress
    real effectProgress
    integer k
    effect e
    effect e2
    group g
    unit u
    real dmg
    real aoe
    real a

    // h — максимальная высота, d — длительность, x — прошедшее время.
    private static method Parabola takes real h, real d, real x returns real
        return (4.00 * h / d) * (d - x) * (x / d)
    endmethod

    private static method Loop_MilimW takes nothing returns nothing
        local integer this
        local integer i = 0
        local real currentX
        local real currentY

        loop
            exitwhen i > MUI_MilimW
            set this = m_MilimW[i]

            if SpellBoolCaster(c) and r < JUMP_DURATION then
                call DebugUnit2(c)
               // call BlzSetSpecialEffectYaw(e, a-180*bj_DEGTORAD)

                if delayElapsed < JUMP_DELAY then
                    set delayElapsed = delayElapsed + TIMER_PERIOD
                    if delayElapsed > JUMP_DELAY then
                        set delayElapsed = JUMP_DELAY
                    endif
                    if delayElapsed == 0.03 then 
                    
        set e = EffectSpawn("war3mapImported\\tx-liuying03_pink3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2.7, 0.4, 150+EFFECT_Z_OFFSET)
        call BlzSetSpecialEffectPitch(e, -180.00 * bj_DEGTORAD)
        call BlzSetSpecialEffectYaw(e, a)
      //  set delayElapsed = 999
                    endif
                    // До начала прыжка эффект остаётся на кастере.
                    //call BlzSetSpecialEffectPitch(e, -180.00 * bj_DEGTORAD)
                else
                    set r = r + TIMER_PERIOD
                    if r > JUMP_DURATION then
                        set r = JUMP_DURATION
                    endif

                    set progress = r / JUMP_DURATION
                    set currentX = startX + (x - startX) * progress
                    set currentY = startY + (y - startY) * progress
                    set f = Parabola(JUMP_HEIGHT, JUMP_DURATION, r)

                    call SetUnitX(c, currentX)
                    call SetUnitY(c, currentY)
                    call SetFly(c, f)
                    if r == JUMP_DURATION/2 then 
                    call DestroyEffect(e)
                    set e = null
        set e = EffectSpawn("war3mapImported\\tx-liuying03_pink3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.5, 0.5, f+ EFFECT_Z_OFFSET)
                    endif
                    // Плавный pitch от -180 градусов до 0.
                    set effectProgress = progress //* progress * (3.00 - 2.00 * progress)
                // call BlzSetSpecialEffectPitch(e, (-180.00 * (1.00 - effectProgress)) * bj_DEGTORAD)

                    // На подъёме эффект находится над кастером, на спуске — под ним.
                    if progress <= 0.50 then
                     //   call BlzSetSpecialEffectPitch(e, (-180.00) * bj_DEGTORAD)
                       // call BJDebugMsg("1")
                        call BlzSetSpecialEffectPosition(e, currentX, currentY, f + EFFECT_Z_OFFSET)
                    else
                       // call BJDebugMsg("2")
                        call BlzSetSpecialEffectPosition(e, currentX, currentY, f - EFFECT_Z_OFFSET)
                    endif

                    if r >= JUMP_DURATION then
                        // Гарантируем точное приземление в точку нажатия.
                        call PosUnit(c, x, y)
                        call SetFly(c, 0.00)
                     //   call BlzSetSpecialEffectPitch(e, 0.00)
                       // call BlzSetSpecialEffectYaw(e, a)
                        call BlzSetSpecialEffectPosition(e, x, y, 0)
                        
                        call ScaleEffDummy(e,0.21,0.5,1.1)
                        call MakeSound("war3mapimported\\Hero_Milim_W 2")
                        call GroupClear(g)
                        call DecorRemove(c, x, y, aoe, 40)
                        call MakeSound("war3mapimported\\Hero_Barragan_W2")
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack1.mdx", x, y, GetRandomReal(0, 359), 1, 2, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack2.mdx", x, y, GetRandomReal(0, 359), 1, 2, 0))

                        set k = 0
                        loop
                            exitwhen k > 4
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1 - k * 0.2, 1 + k * 0.5, 0))
                            call EffectSpawn2("war3mapimported\\wos_kamni.mdx", x, y, GetRandomReal(0, 359), 1.25 - k * 0.1, 0.8 + k * 0.45, 0, 0.25)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 1.0 - k * 0.1, 1.9 + k * 0.42, 0))
                            set k = k + 1
                        endloop
                        set k = 0
                        loop
                        exitwhen k == 6 
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_bdef (383).mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0,359), 1.1, 0.3*k+0.85, 15))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_DustWindFaster3.mdl", GetUnitX(c)+215*Cos(k*60*bj_DEGTORAD), GetUnitY(c)+215*Sin(k*60*bj_DEGTORAD), k*60+180, 2, 1.354, 155))
                            set k = k + 1 
                        endloop
                        call GroupEnumUnitsInRange(g, x, y, aoe + 25, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgphys(c, u, dmg)
                                call MUE(u,MilimW_PushRange,MilimW_PushTime,GAngle(c,u))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        if GetHeroLevel(c)>=25 then 
                        call SwapAbility(c,MilimW_TimetoSwapAbi,MilimW2_ID,MilimW_ID)
                        call MyFrame(c,MilimW_TimetoSwapAbi,"BTNHero_Milim_W2",false,0)
                        
                        endif
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_NewDirtEXNofireNoDust.mdl", x, y, GetRandomReal(0, 359), 1, 3.25, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_NewDirtEXNofireNoDust.mdl", x, y, GetRandomReal(0, 359), 0.75, 3.25, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_NewDirtEXNofireNoDust.mdl", x, y, GetRandomReal(0, 359), 0.5, 3.25, 0))
                        set u = null
                    endif
                endif
            else
                // Также возвращаем героя на землю, если заклинание было прервано.
                call SetFly(c, 0.00)
                call DestroyEffect(e)
                call DestroyEffect(e2)
                call StopSpellUnit2(c)
                call DestroyGroup(g)
                set e = null
                set e2 = null
                set c = null
                set g = null
                set u = null

                set m_MilimW[i] = m_MilimW[MUI_MilimW]
                set MUI_MilimW = MUI_MilimW - 1
                if MUI_MilimW == -1 then
                    call PauseTimer(t_MilimW)
                endif
                call deallocate(this)

                // На эту позицию поставлен последний активный элемент массива.
                set i = i - 1
            endif

            set i = i + 1
        endloop

        set currentX = 0.00
        set currentY = 0.00
    endmethod

    public static method MilimW_Start takes unit NewC, real NewX, real NewY returns nothing
        local thistype this = thistype.create()

        set MUI_MilimW = MUI_MilimW + 1
        set m_MilimW[MUI_MilimW] = this
        set c = NewC
        set x = NewX
        set y = NewY
        set startX = GetUnitX(c)
        set startY = GetUnitY(c)
        set delayElapsed = 0.00
        set r = 0.00
        set f = 0.00
        set progress = 0.00
        set effectProgress = 0.00

        call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(MilimW_ID)), 0)
        set aoe = MilimW_DamageAoe
        set dmg = GetHeroAgi(c, true) * (MilimW2_DamageAgiBase + (MilimW2_DamageAgiStep * (GetUnitAbilityLevel(c, MilimW_ID) - 1)))
        set dmg = dmg + MilimW2_Damage2StaticBase + (MilimW2_Damage2StaticStep * (GetUnitAbilityLevel(c, MilimW_ID) - 1))

        call StartSpellUnit2(c)
        set g = CreateGroup()
        // Фиксируем угол способности от кастера к точке нажатия.
        set a = Atan2(y - startY, x - startX)
        call SetUnitTimeScale(c, 0.5)
        set e2 = AddSpecialEffectTarget("war3mapImported\\file00001662.mdl", c, "hand right")
        call SetUnitAnimationByIndex(c, 8)
        call MakeSound("war3mapimported\\Hero_Milim_W 1")

        if MUI_MilimW == 0 then
            call TimerStart(t_MilimW, TIMER_PERIOD, true, function thistype.Loop_MilimW)
        endif
    endmethod
endstruct

 private struct MilimW2KS
        private static timer t_MilimW2 = CreateTimer()
        private static integer array m_MilimW2
        private static integer MUI_MilimW2 = -1
        unit c
        real x
        real y
        real r2
        effect array ee [15]
        integer k
        real scale
        real r3
        real r4
        real r5
        group g
        group g2
        unit u
        real dmg
        integer check
        real aoe
        real r
        effect e
        effect e2
        effect e3
        real a
        real rmax

        private static method Loop_MilimW2 takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_MilimW2
                set this = m_MilimW2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.05
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call DebugUnit(c)
                    if r == 1.2 and check == 0 then
                        call SetUnitTimeScale(c, 0)
                    endif
                    call BlzSetSpecialEffectPosition(e,x,y,0)
                    call BlzSetSpecialEffectPosition(e2,x,y,0)
                    call BlzSetSpecialEffectPosition(e3,x,y,0)
                    if r == 0.6 then 
                    set e = EffectSpawn("war3mapImported\\file00001145.mdl",GetUnitX(c),GetUnitY(c),GetRandomReal(0,359),1,2,1)
                set e2 = EffectSpawn("war3mapImported\\file00001145.mdl",GetUnitX(c),GetUnitY(c),GetRandomReal(0,359),1,2,1)
                set e3 = EffectSpawn("war3mapImported\\file00001145.mdl",GetUnitX(c),GetUnitY(c),GetRandomReal(0,359),1,2,1)
                call MakeSound("war3mapimported\\Hero_Milim_W2 2")
                elseif r == 0.75 then
                call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_Zi.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 9, 70, 2)
                call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_Zi.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 9, 70, 2)
                call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_Zi.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 9, 70, 2)
                    endif
                    if r> 0.66 then 
                    if r2 >= 0.21 then
                        set r2 = 0.05
                        call DecorRemove(c, x, y, aoe + 200, 35)
                        call GroupEnumUnitsInRange(g, x, y, aoe, null)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgmag(c, u, dmg)
                                    call SlowUnit(c, u, MilimW2_Slow , MilimW2_SlowDuration )
                                    call MUE(u,MilimW2_TightRange,MilimW2_TightDuration,GAngle(u,c))
                                endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    else
                        set r2 = r2 + 0.05
                    endif
                        if r3 >= 0.4 then
                            set r3 = 0.05
                            
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_NewDirtEXNofireNoDust.mdl", x, y, GetRandomReal(0, 359), 1, 4.25, 0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (513)purple.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.5, 1.15, 0))
                        else
                            set r3 = r3 + 0.05
                        endif
                        if r5 >= 0.5 then
                            set r5 = 0.05
                            set k = 0
                            loop
                                exitwhen k >3
                                if check == 0 then
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_bdef (383).mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.8, 2.75 + 0.6 * k, 0, 225, 125, 125, 45))
                                endif
                                set k = k + 1
                            endloop
                        else
                            set r5 = r5 + 0.05
                        endif
                        endif
                else
                    
                    call ColorEffDummy3(e,0,255,255,255,0.3)
                    call ColorEffDummy3(e2,0,255,255,255,0.3)
                    call ColorEffDummy3(e3,0,255,255,255,0.3)
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    if g2 != null then
                        call DestroyGroup(g2)
                    endif
                    set c = null
                    set g = null
                    set g2 = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set u = null
                    set m_MilimW2[i] = m_MilimW2[MUI_MilimW2]
                    set MUI_MilimW2 = MUI_MilimW2 - 1
                    if MUI_MilimW2 == -1 then
                        call PauseTimer( t_MilimW2 )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MilimW2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_MilimW2 = MUI_MilimW2 + 1
            set m_MilimW2[MUI_MilimW2] = this
            set c = NewC
            set r = 0
            set r2 = 0
            set r3 = 0
            set r4 = 0
            set r5 = 0
            call PauseUnit(c, true)
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set g = CreateGroup()
            set rmax =3
                set check = 0
                set aoe = MilimW2_DamageAoe
                set dmg = GetHeroInt(c, true) * (MilimW2_DamageAgiBase + (MilimW2_DamageAgiStep * (GetUnitAbilityLevel(c, MilimW_ID) - 1)))
                set dmg = dmg / 4
                call SetUnitTimeScale(c, 0.85)
                call SetUnitAnimationByIndex(c, 9)
                call MakeSound("war3mapimported\\Hero_Milim_W2 1")
                //call MakeSound("war3mapimported\\Hero_Barragan_R2")
                
            call VisionTimed(GetOwningPlayer(c), GetUnitX(c), GetUnitY(c), 2000, rmax)
            if MUI_MilimW2 == 0 then
                call TimerStart( t_MilimW2, 0.05, true, function thistype.Loop_MilimW2 )
            endif
        endmethod

    endstruct


    private struct MilimEKS
        private static timer t_MilimE = CreateTimer( )
        private static integer array m_MilimE
        private static integer MUI_MilimE = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        real r4
        real r5
        real r6
        real r7
        real r8
        real r9
        group g
        group g2
        real fly
        real fly2
        real fly3
        unit u
        real dmg
        real scale
        integer check
        integer check2
        real aoe
        real move
        real r
        effect e
        real a
        real rmax
        private static method Loop_MilimE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_MilimE
                set this = m_MilimE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r < 0.45 then
                        call DebugUnit2(c)
                    endif
                    if r3 > 0.12 then 
                    set r3= 0
                        call DestroyEffect(EffectSpawn("war3mapImported\\13684996917731847118.mdl", GetUnitX(c)+50*Cos(a), GetUnitY(c)+50*Cos(a), GetRandomReal(0, 359), GetRandomReal(1.5,2), 1.55, GetUnitFlyHeight(c)+GetRandomReal(50,155)))
                    else
                    set r3 = r3 + 0.03 
                    endif
                    if r == 0.45 then
                        call MakeSound("war3mapimported\\Hero_Milim_E2")
                        //call StopSpellUnit2(c)
                        set r5 = 300
                        set r4 = 2100+r5
                        set r9 = r4-r5
                        set check = 0
                        set move = r9/20
                        set r7 = 0.1*0.75 // scale
                        set r8 = 50 // move
                        set scale = 0.45
                        set fly = 550
                        set fly2 =7
                        set fly3 = 31*0.75
            set e = EffectSpawn3("war3mapImported\\file00005542.mdl", GetUnitX(c)+(450)*Cos(a), GetUnitY(c)+(450)*Sin(a),a*bj_RADTODEG,1,scale,fly,-60)
            call BlzPlaySpecialEffect(e,ANIM_TYPE_STAND)
            set r9 = -50
                    endif
                    if check == 20 then 
                    set check = 21
                    call ColorEffDummy3(e,0,255,255,255,0.35)
                    endif
                    if r > 0.45 and check < 20 then
                        if r5 < r4 then
                            set r5 = r5 + move
                        else
                            set r = 9999
                        endif
                        set check = check + 1
                        set r9 = r9 - 3*0.75
                        call BlzSetSpecialEffectPitch(e,r9*bj_DEGTORAD)
                        set scale = scale + r7
                        call BlzSetSpecialEffectScale(e, scale)
                        call MoveEff(e, r8+(check*(3*0.75)), a)
                        if check  < 9 then 
                        set fly = fly - (fly2+check*5)
                        else
                        if check >=15 then 
                        set fly = fly + (fly3+(check*3.5))
                        else
                        set fly = fly + fly3
                        endif
                        endif
                        if fly<= 0 then 
                       set fly = 0.01 
                        endif
                        call BlzSetSpecialEffectHeight(e,fly)
                        set x = x1+r5*Cos(a)
                        set y = y1+r5*Sin(a)
                        if r2>0.06 then 
                        set r2 = 0
                        call VisionTimed(GetOwningPlayer(c), x, y , aoe, 1)
                        call DestroyEffect(EffectSpawn("war3mapImported\\13684996917731847118.mdl", x, y, GetRandomReal(0, 359), GetRandomReal(1.5,2), 5.25, GetRandomReal(240,365)))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_NewDirtEXNofireNoDust.mdl", x, y, GetRandomReal(0, 359), 1, 1.5, 0))
                        call DecorRemove(c, x, y , aoe, 40)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null or r == 999
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u,g2)==false then
                            call GroupAddUnit(g2,u)
                            call dmgmag(c,u,dmg)
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                        else
                        set r2 = r2 + 0.03
                        endif
                    endif
                else
                      call StopSpellUnit2(c)
                    call BlinkEff(c)
                    call SetFly(c,0)
                    
                     //   call BlzSetSpecialEffectPitch(e,-120*bj_DEGTORAD)
                    //call BlzPlaySpecialEffect(e,ANIM_TYPE_DEATH)
                    if check< 20 then 
                    call ColorEffDummy3(e,0,255,255,255,0.35)
                    endif
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup( g )
                    call DestroyGroup( g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set u = null
                    set m_MilimE[i] = m_MilimE[ MUI_MilimE]
                    set MUI_MilimE = MUI_MilimE - 1
                    if MUI_MilimE == -1 then
                        call PauseTimer( t_MilimE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method MilimE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_MilimE = MUI_MilimE + 1
            set m_MilimE[ MUI_MilimE] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)
            set r = 0
            set r2 = 0
            set move = 80
            set r5 = 0
            
            set r4 = MilimE_RangeBase + (MilimE_RangeStep*(GetUnitAbilityLevel(c,MilimE_ID)-1))
            call StartSpellUnit2(c)
            call BlinkEff(c)
            call SetFly(c,700)
            set scale = 0.5
            set r5 = 600
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = MilimE_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( MilimE_DamageAgiBase + ( MilimE_DamageAgiStep * ( GetUnitAbilityLevel( c , MilimE_ID) - 1 ) ) )
            set rmax = 1.11
            call SetUnitAnimationByIndex(c,7)
            call SetUnitTimeScale(c, 0.95)
            call MakeSound("war3mapimported\\Hero_Milim_E")
            if MUI_MilimE == 0 then
                call TimerStart( t_MilimE, 0.03, true, function thistype.Loop_MilimE)
            endif
        endmethod
    endstruct
   
    // Этот блок можно объединить с существующим globals библиотеки MilimSpells.


// Полностью отвечает за полёт одного снаряда, задержку и взрыв.
private struct MilimRProjectileKS
    private static timer t_MilimRProjectile = CreateTimer()
    private static integer array m_MilimRProjectile
    private static integer MUI_MilimRProjectile = -1

    unit c
    unit u
    effect e
    effect e2
    effect e3
    group g
    group g2
    real startX
    real startY
    real targetX
    real targetY
    real currentX
    real currentY
    real a
    real arcSide
    real arcSize
    real fly
    real dmg
    real r
    real rmax
    integer check
    boolean showExplosionFx

    private static method Loop_MilimRProjectile takes nothing returns nothing
        local integer this
        local integer i = 0
        local real progress
        local real ellipseProgress
        local real ellipseOffset
        local real oldX
        local real oldY
        local real x 
        local real y
        local integer sharedGroupId
        local integer remainingProjectiles

        loop
            exitwhen i > MUI_MilimRProjectile
            set this = m_MilimRProjectile[i]

            if check == 0 then
                set r = r + 0.03
                if r > rmax then
                    set r = rmax
                endif

                set progress = r / rmax

                // Половина эллипса: старт и финиш совпадают с заданными точками,
                // а arcSide выбирает закругление на +90 или -90 градусов.
                set ellipseProgress = 0.50 - 0.50 * Cos(bj_PI * progress)
                set ellipseOffset = Sin(bj_PI * progress) * arcSize * arcSide
                set oldX = currentX
                set oldY = currentY
                set currentX = startX + (targetX - startX) * ellipseProgress + ellipseOffset * Cos(a + 90.00 * bj_DEGTORAD)
                set currentY = startY + (targetY - startY) * ellipseProgress + ellipseOffset * Sin(a + 90.00 * bj_DEGTORAD)

                call BlzSetSpecialEffectPosition(e, currentX, currentY, fly)
                call BlzSetSpecialEffectYaw(e, Atan2(currentY - oldY, currentX - oldX))
                call BlzSetSpecialEffectPosition(e2, currentX, currentY, fly)
                call BlzSetSpecialEffectYaw(e2, Atan2(currentY - oldY, currentX - oldX))

                if r >= rmax then
                    call BlzSetSpecialEffectScale(e,0.001)
                    call DestroyEffect(e)
                    set e = null
                    call DestroyEffect(e2)
                    set e2 = null
                    set currentX = targetX
                    set currentY = targetY

                    // ЗАТЫЧКА: эффект в точке приземления снаряда.
                    set e3 = EffectSpawn("war3mapImported\\file00000417.mdl", targetX, targetY, GetRandomReal(0, 359), 1.00, GetRandomReal(1.8,3.25), GetRandomReal(125,400))
                    set check = 1
                    set r = 0.00
                endif
            else
                set r = r + 0.03
                if r == 0.15 and IntegerCd(c,"cd exp",2) then 
                call MakeSound("war3mapimported\\Hero_Milim_R 4")
                endif
                if r >= 0.30 then
                    call DestroyEffect(e3)
                    set e3 = null
                    set x = targetX
                    set y = targetY

                    // Визуальный взрыв создают только пространственно разнесённые снаряды.
                    // Проверка урона ниже выполняется у всех снарядов без исключения.
                    if showExplosionFx then
                        call DestroyEffect(EffectSpawn("war3mapimported\\by_wood_eff_sel_elp_qiuxingbaozha.mdl", x, y, GetRandomReal(0, 359), GetRandomReal(1, 1.35), GetRandomReal(4.00, 6.50), 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_afb (2080).mdl", x, y, a * bj_RADTODEG, 0.85, 1.9, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl", x + 25 * Cos(a), y + 25 * Sin(a), 0, 0.5, 2.94, GetRandomReal(200, 450)))
                    endif

                    call DecorRemove(c, targetX, targetY, MilimR_DamageAoe, 40)
                    call GroupEnumUnitsInRange(g, targetX, targetY, MilimR_DamageAoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                            call GroupAddUnit(g2, u)
                            call dmgmag(c, u, dmg)
                            call SlowUnit(c, u, MilimR_Slow, MilimR_SlowDuration)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop

                    // Общая группа живёт, пока не взорвётся последний снаряд каста.
                    set sharedGroupId = GetHandleId(g2)
                    set remainingProjectiles = LoadInteger(hs, sharedGroupId, StringHash("MilimR projectiles left")) - 1
                    if remainingProjectiles <= 0 then
                        call FlushChildHashtable(hs, sharedGroupId)
                        call DestroyGroup(g2)
                    else
                        call SaveInteger(hs, sharedGroupId, StringHash("MilimR projectiles left"), remainingProjectiles)
                    endif

                    call DestroyGroup(g)
                    set g = null
                    set g2 = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set u = null
                    set c = null

                    set m_MilimRProjectile[i] = m_MilimRProjectile[MUI_MilimRProjectile]
                    set MUI_MilimRProjectile = MUI_MilimRProjectile - 1
                    if MUI_MilimRProjectile == -1 then
                        call PauseTimer(t_MilimRProjectile)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
            endif

            set i = i + 1
        endloop
    endmethod

    public static method MilimRProjectile_Start takes unit NewC, real NewStartX, real NewStartY, real NewTargetX, real NewTargetY, real NewArcSide, real NewArcSize, real NewFly, real NewDuration, real NewDamage, group NewDamagedGroup, boolean NewShowExplosionFx returns nothing
        local thistype this = thistype.create()

        set MUI_MilimRProjectile = MUI_MilimRProjectile + 1
        set m_MilimRProjectile[MUI_MilimRProjectile] = this
        set c = NewC
        set startX = NewStartX
        set startY = NewStartY
        set targetX = NewTargetX
        set targetY = NewTargetY
        set currentX = startX
        set currentY = startY
        set a = Atan2(targetY - startY, targetX - startX)
        set arcSide = NewArcSide
        set arcSize = NewArcSize
        set fly = NewFly
        set r = 0.00
        set rmax = NewDuration
        set dmg = NewDamage
        set check = 0
        set g = CreateGroup()
        set g2 = NewDamagedGroup
        set showExplosionFx = NewShowExplosionFx

        // ЗАТЫЧКА: модель летящего снаряда. war3mapImported\.mdl
        set e = EffectSpawn("war3mapImported\\wos_summon3missle_blue2.mdl", startX, startY, (a + arcSide * 90.00 * bj_DEGTORAD) * bj_RADTODEG, 1.00, 0.5, fly)
        set e2 = EffectSpawn("war3mapImported\\file00004263.mdl", startX, startY, (a + arcSide * 90.00 * bj_DEGTORAD) * bj_RADTODEG, 1.00, 2.75, fly)

        if MUI_MilimRProjectile == 0 then
            call TimerStart(t_MilimRProjectile, 0.03, true, function thistype.Loop_MilimRProjectile)
        endif
    endmethod
endstruct

// Основная структура: каст, неуязвимость, пауза и выпуск всех снарядов.
private struct MilimRKS
    private static constant integer MISSILE_COUNT = 10
    private static constant real CAST_DELAY = 1.50
    private static constant real MISSILE_RELEASE_WINDOW = 1.02
    private static constant real MISSILE_MIN_FLIGHT_TIME = 0.21
    private static constant real RECT_WIDTH = 1200.00
    private static constant real RECT_DEPTH = 650.00
    private static constant real ARC_MIN = 220.00
    private static constant real ARC_MAX = 520.00

    private static timer t_MilimR = CreateTimer()
    private static integer array m_MilimR
    private static integer MUI_MilimR = -1

    unit c
    effect e
    effect e2
    effect e3
    group g
    real x
    real y
    real a
    real r
    real dmg
    integer launched

    private static method Loop_MilimR takes nothing returns nothing
        local integer this
        local integer i = 0
        local integer slotIndex
        local real releaseInterval
        local real releaseOffset
        local real slotWidth
        local real lateralOffset
        local real forwardOffset
        local real targetX
        local real targetY
        local real arcSide
        local real add = 90
        local real flightTime
        local boolean createExplosionFx

        loop
            exitwhen i > MUI_MilimR
            set this = m_MilimR[i]

            if SpellBoolCaster(c) and launched < MISSILE_COUNT then
                set r = r + 0.03
                call DebugUnit(c)
                if r == 0.3 then                 
        set e = EffectSpawnScale("war3mapImported\\file00000739.mdl", GetUnitX(c)+add*Cos(a), GetUnitY(c)+add*Sin(a), a * bj_RADTODEG, 1.00, 1, 100.00,0.75,1,3.45)
        call BlzSetSpecialEffectAlpha(e,150)
        set e2 = EffectSpawnScale("war3mapImported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdl", GetUnitX(c)+90*Cos(a), GetUnitY(c)+90*Sin(a), a * bj_RADTODEG, 1.00, 1, 100.00,0.75,1,2.5)
        set e3 = EffectSpawnScale("war3mapImported\\wos_xtyball2.mdx", GetUnitX(c)+add*Cos(a), GetUnitY(c)+add*Sin(a), a * bj_RADTODEG, 1.00, 1, 0.00,0.75,1,1.85)
        
                endif
                if r> 0.3 then 
                call BlzSetSpecialEffectPosition(e, GetUnitX(c)+add*Cos(a), GetUnitY(c)+add*Sin(a), 0.00)
                call BlzSetSpecialEffectPosition(e2, GetUnitX(c)+add*Cos(a), GetUnitY(c)+add*Sin(a), 165.00)
                endif
                set releaseInterval = MISSILE_RELEASE_WINDOW / I2R(MISSILE_COUNT - 1)
                set releaseOffset = I2R(launched) * releaseInterval
                if r == CAST_DELAY + releaseOffset then
                if IntegerCd(c,"cd start",1.5) then 
        call MakeSound("war3mapimported\\Hero_Milim_R 3")
        endif
        endif
                if r >= CAST_DELAY + releaseOffset then
                    // Очерёдность 0, 5, 1, 4, 2, 3: снаряды чередуются слева и справа.
                    if ModuloInteger(launched, 2) == 0 then
                        set slotIndex = launched / 2
                        set arcSide = 1.00
                    else
                        set slotIndex = MISSILE_COUNT - 1 - launched / 2
                        set arcSide = -1.00
                    endif

                    // Эффекты распределены по всей ширине прямоугольника:
                    // оба края, примерно 1/3 и 2/3 области. Для 10 снарядов это
                    // слоты 0, 3, 6 и 9 — они максимально удалены друг от друга.
                    set createExplosionFx = slotIndex == 0 or slotIndex == (MISSILE_COUNT - 1) / 3 or slotIndex == (MISSILE_COUNT - 1) * 2 / 3 or slotIndex == MISSILE_COUNT - 1

                    // По одной случайной точке в каждой полосе прямоугольника RECT_WIDTH.
                    set slotWidth = RECT_WIDTH / I2R(MISSILE_COUNT)
                    set lateralOffset = -RECT_WIDTH * 0.50 + slotWidth * I2R(slotIndex) + GetRandomReal(0.00, slotWidth)
                    set forwardOffset = GetRandomReal(-RECT_DEPTH * 0.50, RECT_DEPTH * 0.50)
                    set targetX = x + forwardOffset * Cos(a) + lateralOffset * Cos(a + 90.00 * bj_DEGTORAD)
                    set targetY = y + forwardOffset * Sin(a) + lateralOffset * Sin(a + 90.00 * bj_DEGTORAD)

                    // Чем позже вылетел снаряд, тем меньше время полёта.
                    // Все шесть прилетают примерно в один момент.
                    set flightTime = MISSILE_MIN_FLIGHT_TIME + MISSILE_RELEASE_WINDOW - releaseOffset

                    // ЗАТЫЧКА: короткий эффект при выпуске каждого снаряда.
                    call DestroyEffect(EffectSpawn("war3mapImported\\effect lvse-magic-shousuo blue.mdl", GetUnitX(c)+add*Cos(a), GetUnitY(c)+add*Sin(a), GetRandomReal(0, 359), 1.00, 2.00, 120.00))
                    call SaveInteger(hs, GetHandleId(g), StringHash("MilimR projectiles left"), LoadInteger(hs, GetHandleId(g), StringHash("MilimR projectiles left")) + 1)
                    call MilimRProjectileKS.MilimRProjectile_Start(c, GetUnitX(c)+add*Cos(a), GetUnitY(c)+add*Sin(a), targetX, targetY, arcSide, GetRandomReal(ARC_MIN, ARC_MAX), GetUnitFlyHeight(c) + GetRandomReal(110.00, 230.00), flightTime, dmg, g, createExplosionFx)
                    set launched = launched + 1
                endif
            else
                call PauseUnit(c, false)
                call StopSpellUnit(c)
                call SetUnitTimeScale(c, 1.00)
                call DestroyEffect(e)
                call DestroyEffect(e2)
                call DestroyEffect(e3)
                if LoadInteger(hs, GetHandleId(g), StringHash("MilimR projectiles left")) <= 0 then
                    call FlushChildHashtable(hs, GetHandleId(g))
                    call DestroyGroup(g)
                endif
                set e = null
                set e2 = null
                set e3 = null
                set g = null
                set c = null

                set m_MilimR[i] = m_MilimR[MUI_MilimR]
                set MUI_MilimR = MUI_MilimR - 1
                if MUI_MilimR == -1 then
                    call PauseTimer(t_MilimR)
                endif
                call deallocate(this)
                set i = i - 1
            endif

            set i = i + 1
        endloop
    endmethod

    public static method MilimR_Start takes unit NewC, real NewX, real NewY returns nothing
        local thistype this = thistype.create()

        set MUI_MilimR = MUI_MilimR + 1
        set m_MilimR[MUI_MilimR] = this
        set c = NewC
        set x = NewX
        set y = NewY
        set a = GAngle2(c, x, y)
        set r = 0.00
        set launched = 0

        // Любой юнит получает этот полный урон только от первого попавшего снаряда.
        set dmg = GetHeroAgi(c, true) * (MilimR_DamageAgiBase + MilimR_DamageAgiStep * (GetUnitAbilityLevel(c, MilimR_ID) - 1))

        set g = CreateGroup()
        call SaveInteger(hs, GetHandleId(g), StringHash("MilimR projectiles left"), 0)

        call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(MilimR_ID)), 0)
        call StartSpellUnit(c)
        call SetUnitAnimationByIndex(c, 7)
        call MakeSound("war3mapimported\\Hero_Milim_R 1")
        call MakeSound("war3mapimported\\Hero_Milim_R 2")
        // ЗАТЫЧКА: эффект подготовки к выпуску снарядов.

        if MUI_MilimR == 0 then
            call TimerStart(t_MilimR, 0.03, true, function thistype.Loop_MilimR)
        endif
    endmethod
endstruct



private struct MilimTKS
        private static timer t_MilimT = CreateTimer( )
        private static integer array m_MilimT
        private static integer MUI_MilimT = -1
        unit c
        real x
        real y
        framehandle array frame_pas1 [10]
        framehandle array frame_pas2 [10]
        framehandle array frame_pas3 [10]
        framehandle array frame_pas4 [10]
        framehandle array frame_pas5 [10]
        framehandle array frame_pas6 [10]
        integer k2
        integer check
        real r
        real r2
        effect e
        effect e2
        effect e3
        real rmax
        private static method Loop_MilimT takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_MilimT
                set this = m_MilimT[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                    if check == 0 then
                        call DebugUnit2(c)
                        set r = r + 0.03
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        set r = S2R( R2SW( r , 0, 3 ) )
                        call BlzSetSpecialEffectPosition(e,x,y,0)
                        if r2> 0.15 then
                        set r2 = 0
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Opdef17 (282).mdl", x, y, GetRandomReal(0, 359), 1.15, 1.55, 1))
                        else
                        set r2 = r2 + 0.03
                        endif
                        if r == 0.51 then
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), MilimT_ID, false)
                            call UnitAddAbility(c, MilimT2_ID)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), MilimT2_ID, true)
                            call DecorRemove(c, x, y, 800, 50)
                            call VisionTimed(GetOwningPlayer(c), x , y, 1500, 2)
                            call BlzSetUnitSkin(c, Milim2_ID)
                            //call FixAura(c)
                            call ScaleEffDummy(e, 0.5, 3, 6)
                            call ScaleEffDummy(e2, 0.5, 1, 2.5)
                            call ColorEffDummy3(e, 0, 255, 255, 255, 0.6)
                            call ColorEffDummy3(e2, 0, 255, 255, 255, 0.35)
                            call StopSpellUnit2(c)
                            set e3 = AddSpecialEffectTarget("war3mapImported\\wos_aurafbred.mdx", c, "origin")
                            set check = 1
                            set r = 0
                            
                            if frame_pas1[k2] == null then
                                set frame_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 0)
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
                                call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax)
                                call BlzFrameSetValue(frame_pas3[k2], rmax)
                                set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
                                call BlzFrameSetSize(frame_pas4[k2], 0.03, 0.03)
                                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Milim_T", 0, false)
                                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Morph Time Left:" + "|r")
                                call BlzFrameSetScale(frame_pas5[k2], 0.9)
                                set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
                                call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                                call BlzFrameSetScale(frame_pas6[k2], 0.9)
                            else
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame_pas1[k2], true)
                                endif
                                call BlzFrameSetValue(frame_pas3[k2], rmax)
                            endif
                            call DestroyEffect(EffectSpawn3("war3mapImported\\wos_mei-qqsfx-5.mdl", GetUnitX(c), GetUnitY(c), 1, 0.85, 4, 1, -90))
                        endif
                    elseif check == 1 then
                        if IsUnitPaused(c) == false then
                            set r = r + 0.03
                        endif
                        set r = S2R( R2SW( r , 0, 3 ) )
                        call BlzFrameSetValue(frame_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                    endif
                else
                    call BlzSetUnitSkin(c, Milim_ID)
                    //call FixAura(c)
                    call BlzSetAbilityIcon(Milim_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Milim_Icon.blp")
                    call SaveInteger(hs, GetHandleId(c), StringHash("mode t"), 0)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), MilimT_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), MilimT2_ID, false)
                    if check == 0 then
                        call StopSpellUnit2(c)
                        call DestroyEffect(e2)
                    else
                        call DestroyEffect(e3)
                    endif
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_MilimT[i] = m_MilimT[ MUI_MilimT]
                    set MUI_MilimT = MUI_MilimT - 1
                    if MUI_MilimT == -1 then
                        call PauseTimer( t_MilimT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method MilimT_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_MilimT = MUI_MilimT + 1
            set m_MilimT[ MUI_MilimT] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            call StartSpellUnit2(c)
            set check = 0
            set r2 = 0
            set r = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            call SaveInteger(hs, GetHandleId(c), StringHash("mode t"), 1)
            set rmax = MilimT_Duration
            call MakeSound("war3mapimported\\Hero_Milim_T 1")
            call MakeSound("war3mapimported\\Hero_Milim_T 2")
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_HakkeStart.mdx", x, y, GetRandomReal(0, 359), 1, 1.25, 5))
            set e = EffectSpawn("war3mapImported\\wos_ZK-SM_XL8.mdl", GetUnitX(c), GetUnitY(c), 1, 1.25, 2, 0)
            call BlzSetAbilityIcon(Milim_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Milim_T.blp")          
            if MUI_MilimT == 0 then
                call TimerStart( t_MilimT, 0.03, true, function thistype.Loop_MilimT)
            endif
        endmethod
    endstruct
    // Эти параметры добавить в существующий globals библиотеки MilimSpells.

private struct MilimT2KS
    private static constant real AIM_TURN_SPEED = 90.00 // градусов в секунду
    private static constant real AIM_TURN_LIMIT = 120.00 // предел от угла точки нажатия в каждую сторону
    private static constant real AOE_START_FACTOR = 0.20 // 20% базового AOE возле кастера
    private static constant real AOE_END_FACTOR = 0.65 // 65% базового AOE в конце луча

    private static timer t_MilimT2 = CreateTimer()
    private static integer array m_MilimT2
    private static integer MUI_MilimT2 = -1

    unit c
    unit u
    effect e
    effect e2
    effect e3
    group g
    group g2
    group g3
    real x
    real y
    real x1
    real y1
    real a
    real baseA
    real r
    real r2
    real r3
    real r4
    real move
    real dmg
    real aoe
    integer check

    private static method Loop_MilimT2 takes nothing returns nothing
        local integer this
        local integer i = 0
        local integer damageCount
        local real add = -35
        local real targetA
        local real angleDiff
        local real maxTurn = AIM_TURN_SPEED * bj_DEGTORAD * 0.03
        local real turnLimit = AIM_TURN_LIMIT * bj_DEGTORAD

        loop
            exitwhen i > MUI_MilimT2
            set this = m_MilimT2[i]

            if SpellBoolCaster(c) and check < 2 then
                call DebugUnit(c)
                    if r3>0.12 then 
                    set r3 = 0
                     call DestroyEffect(EffectSpawn("war3mapImported\\effect lvse-magic-shousuo blue.mdl", GetUnitX(c)+add*Cos(a), GetUnitY(c)+add*Sin(a), GetRandomReal(0, 359), 1.00, 4.00, 120.00))
                     call DestroyEffect(EffectSpawn("war3mapImported\\file00000417.mdl", GetUnitX(c)+add*Cos(a), GetUnitY(c)+add*Sin(a), GetRandomReal(0, 359), 1.00, 4.00, 120.00))
                    else
                    set r3 = r3 + 0.03
                    endif
                if check == 0 then
                    set r = r + 0.03

                    // Желаемый угол мыши сначала ограничивается сектором
                    // baseA - 120 градусов ... baseA + 120 градусов.
                    set targetA = GAngle2(c, GetMouseX(GetOwningPlayer(c)), GetMouseY(GetOwningPlayer(c)))
                    set angleDiff = targetA - baseA
                    if angleDiff > bj_PI then
                        set angleDiff = angleDiff - 2.00 * bj_PI
                    elseif angleDiff < -bj_PI then
                        set angleDiff = angleDiff + 2.00 * bj_PI
                    endif

                    if angleDiff > turnLimit then
                        set targetA = baseA + turnLimit
                    elseif angleDiff < -turnLimit then
                        set targetA = baseA - turnLimit
                    else
                        set targetA = baseA + angleDiff
                    endif
                    
                    // Герой и эффект плавно идут к разрешённому углу.
                    set angleDiff = targetA - a
                    if angleDiff > bj_PI then
                        set angleDiff = angleDiff - 2.00 * bj_PI
                    elseif angleDiff < -bj_PI then
                        set angleDiff = angleDiff + 2.00 * bj_PI
                    endif

                    if angleDiff > maxTurn then
                        set a = a + maxTurn
                    elseif angleDiff < -maxTurn then
                        set a = a - maxTurn
                    else
                        set a = targetA
                    endif

                    call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                    call BlzSetSpecialEffectPosition(e, GetUnitX(c), GetUnitY(c), 0.00)
                    call BlzSetSpecialEffectYaw(e, a)

                    if r == 1.5 then
                        call MakeSound("war3mapimported\\Hero_Milim_T2 2")
                        call MakeSound("war3mapimported\\Hero_Milim_T2 3")
                    endif

                    if r >= MilimT2_ChargeTime then
                        set check = 1
                        set r = 0.00
                        set r2 = 0.00
                        set move = 0.00
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)

                        call MakeSound("war3mapimported\\Hero_Milim_T2 4")
                        call MouseOff(GetOwningPlayer(c))
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.20)
                        call DestroyEffect(e2)
                        set e = null
                        set e2 = null

                        call SetUnitAnimationByIndex(c, 15)
                        call SetUnitTimeScale(c, 1.00)
                        call MakeSound("war3mapimported\\Hero_Milim_TT4")

                        set e3 = EffectSpawn3("war3mapImported\\file00000806_1.mdl", x + 3200.00 * Cos(a), y + 3200.00 * Sin(a), a * bj_RADTODEG+0, 1.00, 2.0, 100.00,-90)
                    endif
                else
                    set r = r + 0.03
                    set r2 = r2 + 0.03

                    // Коническое AOE: от 20% возле кастера до 65% в конце луча.
                    // Радиус меняется плавно относительно пройденной длины.
                    set aoe = MilimT2_DamageAoe * (AOE_START_FACTOR + (AOE_END_FACTOR - AOE_START_FACTOR) * move / MilimT2_BeamRange)
                    set x1 = x + move * Cos(a)
                    set y1 = y + move * Sin(a)
                    call DecorRemove(c, x1, y1, aoe, 50)
                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, x1, y1, aoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                            call GroupAddUnit(g2, u)
                            call SaveInteger(hs, GetHandleId(g2), GetHandleId(u), 0)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop

                    set move = move + MilimT2_BeamScanStep
                    if move > MilimT2_BeamRange then
                        set move = 0.00
                    endif

                    if r2 + 0.001 >= MilimT2_DamagePeriod then
                        set r2 = 0.00
                        call GroupClear(g3)

                        loop
                            set u = FirstOfGroup(g2)
                            exitwhen u == null
                            call GroupRemoveUnit(g2, u)
                            set damageCount = LoadInteger(hs, GetHandleId(g2), GetHandleId(u))

                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                if damageCount < MilimT2_DamageTicks then
                                    call dmgmag(c, u, dmg)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))

                                    if damageCount == 0 then
                                        call RootUnit(c, u, MilimT2_Root)
                                    endif
                                    call SlowUnit(c, u, MilimT2_Slow, MilimT2_SlowDuration)
                                    call SilenceUnit(c, u, MilimT2_SilenceDuration)

                                    set damageCount = damageCount + 1
                                    call SaveInteger(hs, GetHandleId(g2), GetHandleId(u), damageCount)
                                endif
                                call GroupAddUnit(g3, u)
                            endif
                        endloop

                        loop
                            set u = FirstOfGroup(g3)
                            exitwhen u == null
                            call GroupRemoveUnit(g3, u)
                            call GroupAddUnit(g2, u)
                        endloop
                    endif

                    if r >= MilimT2_BeamDuration then
                        set check = 2
                    endif
                endif
            else
                call MouseOff(GetOwningPlayer(c))
                call StopSpellUnit2(c)
                call SetUnitAnimation(c, "stand")
                call SetUnitTimeScale(c, 1.00)

                if e != null then
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.20)
                endif
                call DestroyEffect(e2)
                if e3 != null then
                    call ColorEffDummy3(e3, 0, 255, 255, 255, 0.20)
                endif

                call FlushChildHashtable(hs, GetHandleId(g2))
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
                set c = null

                set m_MilimT2[i] = m_MilimT2[MUI_MilimT2]
                set MUI_MilimT2 = MUI_MilimT2 - 1
                if MUI_MilimT2 == -1 then
                    call PauseTimer(t_MilimT2)
                endif
                call deallocate(this)
                set i = i - 1
            endif

            set i = i + 1
        endloop
    endmethod

    public static method MilimT2_Start takes unit NewC, real NewX, real NewY returns nothing
        local thistype this = thistype.create()

        set MUI_MilimT2 = MUI_MilimT2 + 1
        set m_MilimT2[MUI_MilimT2] = this
        set c = NewC
        set x = NewX
        set y = NewY
        set baseA = GAngle2(c, x, y)
        set a = baseA
        set r = 0.00
        set r2 = 0.00
        set move = 0.00
        set check = 0
        set aoe = MilimT2_DamageAoe * AOE_START_FACTOR
        set dmg = GetHeroAgi(c, true) * MilimT2_DamageAgiBase / I2R(MilimT2_DamageTicks)

        set g = CreateGroup()
        set g2 = CreateGroup()
        set g3 = CreateGroup()

        call DebuffClear(c)
        call StartSpellUnit(c)
        call SetUnitAnimationByIndex(c, 0)
        call SetUnitTimeScale(c, 1.50)
        call MouseOn(GetOwningPlayer(c))
        set MouseX[GetPlayerId(GetOwningPlayer(c))] = x
        set MouseY[GetPlayerId(GetOwningPlayer(c))] = y
        call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
        call MakeSound("war3mapimported\\Hero_Milim_T2 1")
        call SetUnitAnimationByIndex(c, 7)

        set e = EffectSpawn("war3mapImported\\Gear_mr.war3_sxxq3.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.50, 4.00, 0.00)
        set e2 = AddSpecialEffectTarget("war3mapImported\\Gear_papsnaz (971)24.mdx", c, "weapon")

        if MUI_MilimT2 == 0 then
            call TimerStart(t_MilimT2, 0.03, true, function thistype.Loop_MilimT2)
        endif
    endmethod
endstruct


// Заменить старую обёртку запуска T2 на эту.


    
    //----------------------------Milim-----------------------------------------------
     /* Animations index:
    
    0 - stand 
    1 - move
    2 - stand 2
    3 - hit hand right
    4 - hit foot
    6 - hit hand left
    7 - stand ready, w start 
    8 - W land
    9 - w2
    10 - foot punch from air
    
     */ 
     
    function MilimDodge takes unit c, unit td returns nothing
        local real cd = 0
        local real time = 0.15
        local real push = 250
        call EUTU2(EffectSpawn("war3mapImported\\wos_az_wsy_gather3.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 2, 90), time, 90, c)
        call MakeSound("war3mapimported\\Hero_Milim_F")
        if GetHeroLevel(c) >= 35 then
            set cd = MilimF_CD35
        elseif GetHeroLevel(c) >= 25 then
            set cd = MilimF_CD25
        else
            set cd = MilimF_CD12
        endif
        if IsUnitPaused(c) == false then
            call MUE(c, push, time, GAngle(c, td) + GetRandomReal( -30, 30) * bj_DEGTORAD)
        endif
        call FakeCD_Start(c, MilimF_ID, cd, 0, 0)
    endfunction
    function MilimQ_Start takes unit c, real x, real y returns nothing
        call MilimQKS.MilimQ_Start( c, x, y )
    endfunction
    function MilimW_Start takes unit c,real x,real y returns nothing
        call MilimWKS.MilimW_Start( c,x,y )
    endfunction
    function MilimW2_Start takes unit c returns nothing
        call MilimW2KS.MilimW2_Start( c )
    endfunction
    function MilimE_Start takes unit c, real x, real y returns nothing
       call MilimEKS.MilimE_Start( c, x, y )
    endfunction
    function MilimR_Start takes unit c, real x, real y returns nothing
        call MilimRKS.MilimR_Start(c, x, y)
    endfunction
    function MilimT_Start takes unit c returns nothing
        call MilimTKS.MilimT_Start( c )
    endfunction
    function MilimT2_Start takes unit c, real x, real y returns nothing
    call MilimT2KS.MilimT2_Start(c, x, y)
endfunction
    function MilimF_Start takes unit c returns nothing
    endfunction
    function MilimG_Start takes unit c returns nothing
    //    call MilimGKS.MilimG_Start( c )
    endfunction
   
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
