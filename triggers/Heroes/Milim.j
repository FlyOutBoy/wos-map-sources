// @ignore-file-errors
// VS Code jass.jass 1.9.21 incorrectly reports valid vJASS `local thistype this`
// declarations as keyword conflicts. JassHelper remains the source of truth.
library MilimSpells uses GearSystems
    globals
//--------------------------------------Milim--------------------------------------------------------------
        integer Milim_ID = 'H02K'
        integer Milim2_ID = 'H02L'
//---------------Q ability-----------------------------------------------------
        integer MilimQ_ID = 'A0HG'
        real MilimQ_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real MilimQ_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real MilimQ_Damage2StaticBase = 175 // base static damage for 1 level
        real MilimQ_Damage2StaticStep = 0 // additional static damage for each next level
        real MilimQ_DamageAoe = 155
        real MilimQ_DamageAoe2 = 350
        real MilimQ_Range = 1255
        real MilimQ_PushRange = 450 // slow time 2, 3, 4 sec only
        real MilimQ_PushDuration = 0.3 // slow time 2, 3, 4 sec only
//---------------W ability-----------------------------------------------------
        integer MilimW_ID = 'A0HH'
        integer MilimW2_ID = 'A0HI'
        real MilimW_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real MilimW_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real MilimW_Damage2StaticBase = 150 // base static damage for 1 level
        real MilimW_Damage2StaticStep = 0 // additional static damage for each next level
        real MilimW2_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real MilimW2_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real MilimW2_Damage2StaticBase = 150 // base static damage for 1 level
        real MilimW2_Damage2StaticStep = 0 // additional static damage for each next level
        real MilimW_TimetoSwapAbi = 2
        real MilimW_DamageAoe = 600
        real MilimW_PushRange = 300
        real MilimW_PushTime = 0.24
        real MilimW2_DamageAoe = 900
        integer MilimW2_Slow = 40
        integer MilimW2_SlowDuration = 2
        real MilimW2_TightRange = 50
        real MilimW2_TightDuration = 0.15
//---------------E ability-----------------------------------------------------
        integer MilimE_ID = 'A0HJ'
        real MilimE_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real MilimE_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real MilimE_RangeBase = 1200.00
        real MilimE_RangeStep = 100.00
        real MilimE_DamageAoe = 275
//---------------R ability-----------------------------------------------------
        integer MilimR_ID = 'A0HK'
        real MilimR_DamageAgiBase = 4 // base number x Agi damage for 1 level
        real MilimR_DamageAgiStep = 1 // additional number x Agi damage for each next level
        integer MilimR_Slow = 45
        real MilimR_DamageAoe = 700.00
        integer MilimR_SlowDuration = 2
        real MilimR_CarryAoe = 180.00
        real MilimR_CarryScanPeriod = 0.06
        real MilimR_VisionPeriod = 0.15
//---------------T ability-----------------------------------------------------
        integer MilimT_ID = 'A0HL' //
        real MilimT_Duration = 20
        integer MilimT_MaxHpBonus = 1500
        real MilimT_HpRegenAbi_Amount = 30
        integer MilimT_HpRegenAbi = 'A0HS'
//---------------T2 ability-----------------------------------------------------
        integer MilimT2_ID = 'A0HM' //
        real MilimT2_DamageAgiBase = 10 // overall
        real MilimT2_DamageAoe = 500 // 
        integer MilimT2_Slow = 40 // Caused slow %
        integer MilimT2_SlowDuration = 2 // slow time 2, 3, 4 sec only
        real MilimT2_ChargeTime = 2.00
    real MilimT2_BeamDuration = 1.50
    real MilimT2_BeamRange = 2700.00
    real MilimT2_BeamScanStep = 300.00
    real MilimT2_DamagePeriod = 0.18
    integer MilimT2_DamageTicks = 6
//---------------F ability-----------------------------------------------------
        integer MilimF_ID = 'A0HN'
        
//---------------G ability-----------------------------------------------------
        integer MilimG_ID = 'A0HO'
        integer MilimG_Stat_ID1 = 'A0HP'
        integer MilimG_Stat_ID2 = 'A0HR'
        integer MilimG_Stat_ID3 = 'A0HQ'
        real MilimG_DamagetoStats1 = 4000 //when absorbdamage
        real MilimG_DamagetoStats2 = 8000 //when absorbdamage
        real MilimG_DamagetoStats3 = 12000 //when absorbdamage
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
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_senji-wind-impact-2.mdx", x+190*Cos(a), y+190*Sin(a), a*bj_RADTODEG, 2, 1.15, 85))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_senji-wind-impact-2.mdx", x+290*Cos(a), y+290*Sin(a), a*bj_RADTODEG, 1.9, 1.35, 85))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_senji-wind-impact-2.mdx", x+390*Cos(a), y+390*Sin(a), a*bj_RADTODEG, 1.8, 1.55, 85))
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
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_file00001662.mdl", c, "hand right")
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

    // h — ìàêñèìàëüíàÿ âûñîòà, d — äëèòåëüíîñòü, x — ïðîøåäøåå âðåìÿ.
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
                    
        set e = EffectSpawn("war3mapImported\\wos_tx-liuying03_pink3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2.7, 0.4, 150+EFFECT_Z_OFFSET)
        call BlzSetSpecialEffectPitch(e, -180.00 * bj_DEGTORAD)
        call BlzSetSpecialEffectYaw(e, a)
      //  set delayElapsed = 999
                    endif
                    // Äî íà÷àëà ïðûæêà ýôôåêò îñòà¸òñÿ íà êàñòåðå.
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
        set e = EffectSpawn("war3mapImported\\wos_tx-liuying03_pink3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.5, 0.5, f+ EFFECT_Z_OFFSET)
                    endif
                    // Ïëàâíûé pitch îò -180 ãðàäóñîâ äî 0.
                    set effectProgress = progress //* progress * (3.00 - 2.00 * progress)
                // call BlzSetSpecialEffectPitch(e, (-180.00 * (1.00 - effectProgress)) * bj_DEGTORAD)

                    // Íà ïîäú¸ìå ýôôåêò íàõîäèòñÿ íàä êàñòåðîì, íà ñïóñêå — ïîä íèì.
                    if progress <= 0.50 then
                     //   call BlzSetSpecialEffectPitch(e, (-180.00) * bj_DEGTORAD)
                       // call BJDebugMsg("1")
                        call BlzSetSpecialEffectPosition(e, currentX, currentY, f + EFFECT_Z_OFFSET)
                    else
                       // call BJDebugMsg("2")
                        call BlzSetSpecialEffectPosition(e, currentX, currentY, f - EFFECT_Z_OFFSET)
                    endif

                    if r >= JUMP_DURATION then
                        // Ãàðàíòèðóåì òî÷íîå ïðèçåìëåíèå â òî÷êó íàæàòèÿ.
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
                // Òàêæå âîçâðàùàåì ãåðîÿ íà çåìëþ, åñëè çàêëèíàíèå áûëî ïðåðâàíî.
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

                // Íà ýòó ïîçèöèþ ïîñòàâëåí ïîñëåäíèé àêòèâíûé ýëåìåíò ìàññèâà.
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
        // Ôèêñèðóåì óãîë ñïîñîáíîñòè îò êàñòåðà ê òî÷êå íàæàòèÿ.
        set a = Atan2(y - startY, x - startX)
        call SetUnitTimeScale(c, 0.5)
        set e2 = AddSpecialEffectTarget("war3mapImported\\wos_file00001662.mdl", c, "hand right")
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
                    call DebugUnit2(c)
                    if r == 1.2 and check == 0 then
                        call SetUnitTimeScale(c, 0)
                    endif
                    call BlzSetSpecialEffectPosition(e,x,y,0)
                    call BlzSetSpecialEffectPosition(e2,x,y,0)
                    call BlzSetSpecialEffectPosition(e3,x,y,0)
                    if r == 0.6 then 
                    set e = EffectSpawn("war3mapImported\\wos_file00001145.mdl",GetUnitX(c),GetUnitY(c),GetRandomReal(0,359),1,2,1)
                set e2 = EffectSpawn("war3mapImported\\wos_file00001145.mdl",GetUnitX(c),GetUnitY(c),GetRandomReal(0,359),1,2,1)
                set e3 = EffectSpawn("war3mapImported\\wos_file00001145.mdl",GetUnitX(c),GetUnitY(c),GetRandomReal(0,359),1,2,1)
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
                    call StopSpellUnit2(c)
                call SaveInteger(hs,GetHandleId(c),StringHash("invul"),0)
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
            set rmax =1.5
                set check = 0
                set aoe = MilimW2_DamageAoe
                set dmg = GetHeroInt(c, true) * (MilimW2_DamageAgiBase + (MilimW2_DamageAgiStep * (GetUnitAbilityLevel(c, MilimW_ID) - 1)))
                set dmg = dmg / 4
                call SetUnitTimeScale(c, 0.85)
                call SetUnitAnimationByIndex(c, 9)
                call MakeSound("war3mapimported\\Hero_Milim_W2 1")
                //call MakeSound("war3mapimported\\Hero_Barragan_R2")
                call StartSpellUnit2(c)
                call SaveInteger(hs,GetHandleId(c),StringHash("invul"),1)
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
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_13684996917731847118.mdl", GetUnitX(c)+50*Cos(a), GetUnitY(c)+50*Cos(a), GetRandomReal(0, 359), GetRandomReal(1.5,2), 1.55, GetUnitFlyHeight(c)+GetRandomReal(50,155)))
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
            set e = EffectSpawn3("war3mapImported\\wos_file00005542.mdl", GetUnitX(c)+(450)*Cos(a), GetUnitY(c)+(450)*Sin(a),a*bj_RADTODEG,1,scale,fly,-60)
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
                        call VisionTimed(GetOwningPlayer(c), x, y, aoe * 2.00, 1.00)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_13684996917731847118.mdl", x, y, GetRandomReal(0, 359), GetRandomReal(1.5,2), 5.25, GetRandomReal(240,365)))
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
   
    // Ýòîò áëîê ìîæíî îáúåäèíèòü ñ ñóùåñòâóþùèì globals áèáëèîòåêè MilimSpells.


// Ïîëíîñòüþ îòâå÷àåò çà ïîë¸ò îäíîãî ñíàðÿäà, çàäåðæêó è âçðûâ.
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
    group g3
    group g4
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
    real r2
    real visionTick
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
        local real moveDistance
        local real moveAngle
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

                // Ïîëîâèíà ýëëèïñà: ñòàðò è ôèíèø ñîâïàäàþò ñ çàäàííûìè òî÷êàìè,
                // à arcSide âûáèðàåò çàêðóãëåíèå íà +90 èëè -90 ãðàäóñîâ.
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
                set moveDistance = SquareRoot((currentX - oldX) * (currentX - oldX) + (currentY - oldY) * (currentY - oldY))
                set moveAngle = Atan2(currentY - oldY, currentX - oldX)

                if r2 >= MilimR_CarryScanPeriod then
                    set r2 = 0.00
                    call GroupEnumUnitsInRange(g, currentX, currentY, MilimR_CarryAoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g4) then
                            call GroupAddUnit(g3, u)
                            call GroupAddUnit(g4, u)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                else
                    set r2 = r2 + 0.03
                endif

                call GroupClear(g)
                loop
                    set u = FirstOfGroup(g3)
                    exitwhen u == null
                    call GroupRemoveUnit(g3, u)
                    if SpellBool(u) then
                        call MoveUnit(u, moveDistance, moveAngle)
                        call GroupAddUnit(g, u)
                    else
                        call GroupRemoveUnit(g4, u)
                    endif
                endloop
                loop
                    set u = FirstOfGroup(g)
                    exitwhen u == null
                    call GroupRemoveUnit(g, u)
                    call GroupAddUnit(g3, u)
                endloop

                if visionTick >= MilimR_VisionPeriod then
                    set visionTick = 0.00
                    call VisionTimed(GetOwningPlayer(c), currentX, currentY, MilimR_DamageAoe * 2.00, MilimR_VisionPeriod * 2.00)
                else
                    set visionTick = visionTick + 0.03
                endif
                if r >= rmax then
                    call BlzSetSpecialEffectScale(e,0.001)
                    call DestroyEffect(e)
                    set e = null
                    call DestroyEffect(e2)
                    set e2 = null
                    set currentX = targetX
                    set currentY = targetY

                    // ÇÀÒÛ×ÊÀ: ýôôåêò â òî÷êå ïðèçåìëåíèÿ ñíàðÿäà.
                    set e3 = EffectSpawn("war3mapImported\\wos_file00000417.mdl", targetX, targetY, GetRandomReal(0, 359), 1.00, GetRandomReal(1.8,3.25), GetRandomReal(125,400))
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

                    // Âèçóàëüíûé âçðûâ ñîçäàþò òîëüêî ïðîñòðàíñòâåííî ðàçíåñ¸ííûå ñíàðÿäû.
                    // Ïðîâåðêà óðîíà íèæå âûïîëíÿåòñÿ ó âñåõ ñíàðÿäîâ áåç èñêëþ÷åíèÿ.
                    if showExplosionFx then
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_by_wood_eff_sel_elp_qiuxingbaozha.mdl", x, y, GetRandomReal(0, 359), GetRandomReal(1, 1.35), GetRandomReal(4.00, 6.50), 0))
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

                    // Îáùàÿ ãðóïïà æèâ¸ò, ïîêà íå âçîðâ¸òñÿ ïîñëåäíèé ñíàðÿä êàñòà.
                    set sharedGroupId = GetHandleId(g2)
                    set remainingProjectiles = LoadInteger(hs, sharedGroupId, StringHash("MilimR projectiles left")) - 1
                    if remainingProjectiles <= 0 then
                        call FlushChildHashtable(hs, sharedGroupId)
                        call DestroyGroup(g2)
                        call DestroyGroup(g4)
                    else
                        call SaveInteger(hs, sharedGroupId, StringHash("MilimR projectiles left"), remainingProjectiles)
                    endif

                    call DestroyGroup(g)
                    call DestroyGroup(g3)
                    set g = null
                    set g2 = null
                    set g3 = null
                    set g4 = null
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

    public static method MilimRProjectile_Start takes unit NewC, real NewStartX, real NewStartY, real NewTargetX, real NewTargetY, real NewArcSide, real NewArcSize, real NewFly, real NewDuration, real NewDamage, group NewDamagedGroup, group NewPushedGroup, boolean NewShowExplosionFx returns nothing
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
        set r2 = 0.00
        set visionTick = 0.00
        set rmax = NewDuration
        set dmg = NewDamage
        set check = 0
        set g = CreateGroup()
        set g2 = NewDamagedGroup
        set g3 = CreateGroup()
        set g4 = NewPushedGroup
        set showExplosionFx = NewShowExplosionFx

        // ÇÀÒÛ×ÊÀ: ìîäåëü ëåòÿùåãî ñíàðÿäà. war3mapImported\.mdl
        set e = EffectSpawn("war3mapImported\\wos_summon3missle_blue2.mdl", startX, startY, (a + arcSide * 90.00 * bj_DEGTORAD) * bj_RADTODEG, 1.00, 0.5, fly)
        set e2 = EffectSpawn("war3mapImported\\wos_file00004263.mdl", startX, startY, (a + arcSide * 90.00 * bj_DEGTORAD) * bj_RADTODEG, 1.00, 2.75, fly)

        if MUI_MilimRProjectile == 0 then
            call TimerStart(t_MilimRProjectile, 0.03, true, function thistype.Loop_MilimRProjectile)
        endif
    endmethod
endstruct

// Îñíîâíàÿ ñòðóêòóðà: êàñò, íåóÿçâèìîñòü, ïàóçà è âûïóñê âñåõ ñíàðÿäîâ.
private struct MilimRKS
    private static constant integer MISSILE_COUNT = 12
    private static constant real CAST_DELAY = 1.50
    private static constant real MISSILE_RELEASE_WINDOW = 0.75
    private static constant real MISSILE_MIN_FLIGHT_TIME = 0.15
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
    group g2
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
        set e = EffectSpawnScale("war3mapImported\\wos_file00000739.mdl", GetUnitX(c)+add*Cos(a), GetUnitY(c)+add*Sin(a), a * bj_RADTODEG, 1.00, 1.5, 100.00,0.75,1,3.45)
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
                    // Î÷åð¸äíîñòü 0, 5, 1, 4, 2, 3: ñíàðÿäû ÷åðåäóþòñÿ ñëåâà è ñïðàâà.
                    if ModuloInteger(launched, 2) == 0 then
                        set slotIndex = launched / 2
                        set arcSide = 1.00
                    else
                        set slotIndex = MISSILE_COUNT - 1 - launched / 2
                        set arcSide = -1.00
                    endif

                    // Ýôôåêòû ðàñïðåäåëåíû ïî âñåé øèðèíå ïðÿìîóãîëüíèêà:
                    // îáà êðàÿ, ïðèìåðíî 1/3 è 2/3 îáëàñòè. Äëÿ 10 ñíàðÿäîâ ýòî
                    // ñëîòû 0, 3, 6 è 9 — îíè ìàêñèìàëüíî óäàëåíû äðóã îò äðóãà.
                    set createExplosionFx = slotIndex == 0 or slotIndex == (MISSILE_COUNT - 1) / 3 or slotIndex == (MISSILE_COUNT - 1) * 2 / 3 or slotIndex == MISSILE_COUNT - 1

                    // Ïî îäíîé ñëó÷àéíîé òî÷êå â êàæäîé ïîëîñå ïðÿìîóãîëüíèêà RECT_WIDTH.
                    set slotWidth = RECT_WIDTH / I2R(MISSILE_COUNT)
                    set lateralOffset = -RECT_WIDTH * 0.50 + slotWidth * I2R(slotIndex) + GetRandomReal(0.00, slotWidth)
                    set forwardOffset = GetRandomReal(-RECT_DEPTH * 0.50, RECT_DEPTH * 0.50)
                    set targetX = x + forwardOffset * Cos(a) + lateralOffset * Cos(a + 90.00 * bj_DEGTORAD)
                    set targetY = y + forwardOffset * Sin(a) + lateralOffset * Sin(a + 90.00 * bj_DEGTORAD)

                    // ×åì ïîçæå âûëåòåë ñíàðÿä, òåì ìåíüøå âðåìÿ ïîë¸òà.
                    // Âñå øåñòü ïðèëåòàþò ïðèìåðíî â îäèí ìîìåíò.
                    set flightTime = MISSILE_MIN_FLIGHT_TIME + MISSILE_RELEASE_WINDOW - releaseOffset

                    // ÇÀÒÛ×ÊÀ: êîðîòêèé ýôôåêò ïðè âûïóñêå êàæäîãî ñíàðÿäà.
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_effect lvse-magic-shousuo blue.mdl", GetUnitX(c)+add*Cos(a), GetUnitY(c)+add*Sin(a), GetRandomReal(0, 359), 1.00, 2.00, 120.00))
                    call SaveInteger(hs, GetHandleId(g), StringHash("MilimR projectiles left"), LoadInteger(hs, GetHandleId(g), StringHash("MilimR projectiles left")) + 1)
                    call MilimRProjectileKS.MilimRProjectile_Start(c, GetUnitX(c)+add*Cos(a), GetUnitY(c)+add*Sin(a), targetX, targetY, arcSide, GetRandomReal(ARC_MIN, ARC_MAX), GetUnitFlyHeight(c) + GetRandomReal(110.00, 230.00), flightTime, dmg, g, g2, createExplosionFx)
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
                    call DestroyGroup(g2)
                endif
                set e = null
                set e2 = null
                set e3 = null
                set g = null
                set g2 = null
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

        // Ëþáîé þíèò ïîëó÷àåò ýòîò ïîëíûé óðîí òîëüêî îò ïåðâîãî ïîïàâøåãî ñíàðÿäà.
        set dmg = GetHeroAgi(c, true) * (MilimR_DamageAgiBase + MilimR_DamageAgiStep * (GetUnitAbilityLevel(c, MilimR_ID) - 1))

        set g = CreateGroup()
        set g2 = CreateGroup()
        call SaveInteger(hs, GetHandleId(g), StringHash("MilimR projectiles left"), 0)

        call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(MilimR_ID)), 0)
        call StartSpellUnit(c)
        call SetUnitAnimationByIndex(c, 7)
        call MakeSound("war3mapimported\\Hero_Milim_R 1")
        call MakeSound("war3mapimported\\Hero_Milim_R 2")
        // ÇÀÒÛ×ÊÀ: ýôôåêò ïîäãîòîâêè ê âûïóñêó ñíàðÿäîâ.

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
            local real hp
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
                    set hp = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
                    call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) - MilimT_MaxHpBonus)
                    call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
                    call UnitRemoveAbility(c, MilimT_HpRegenAbi)
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
            local real hp
            set MUI_MilimT = MUI_MilimT + 1
            set m_MilimT[ MUI_MilimT] = this
            set c = NewC
            set hp = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
            call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) + MilimT_MaxHpBonus)
            call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
            call UnitAddAbility(c, MilimT_HpRegenAbi)
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
    // Ýòè ïàðàìåòðû äîáàâèòü â ñóùåñòâóþùèé globals áèáëèîòåêè MilimSpells.

private struct MilimT2KS
    private static constant real AIM_TURN_SPEED = 90.00 // ãðàäóñîâ â ñåêóíäó
    private static constant real AIM_TURN_LIMIT = 120.00 // ïðåäåë îò óãëà òî÷êè íàæàòèÿ â êàæäóþ ñòîðîíó
    private static constant real AOE_START_FACTOR = 0.50 // 20% áàçîâîãî AOE âîçëå êàñòåðà
    private static constant real AOE_END_FACTOR = 0.65 // 65% áàçîâîãî AOE â êîíöå ëó÷à

    private static timer t_MilimT2 = CreateTimer()
    private static integer array m_MilimT2
    private static integer MUI_MilimT2 = -1

    unit c
    unit u
    effect e
    effect e2
    effect e3
    effect e4
    effect e5
    effect castFrontFx
    effect castFrontGlowFx
    effect castFrontBallFx
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
    real beamFxMove
    real beamFxScale
    real beamRingScale
    real beamRingTimer
    real move
    real dmg
    real aoe
    integer check

    private static method Loop_MilimT2 takes nothing returns nothing
        local integer this
        local integer i = 0
        local integer damageCount
        local real add = -1
        local real targetA
        local real angleDiff
        local real maxTurn = AIM_TURN_SPEED * bj_DEGTORAD * 0.03
        local real turnLimit = AIM_TURN_LIMIT * bj_DEGTORAD
        local real beamEffectLife
        local effect beamEffect
        local integer beamSegment

        loop
            exitwhen i > MUI_MilimT2
            set this = m_MilimT2[i]

            if SpellBoolCaster(c) and check < 2 then
                call DebugUnit(c)
                    if r3>0.22 then 
                    set r3 = 0
                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_13684996917731847118.mdl", GetUnitX(c)+add*Cos(a), GetUnitY(c)+add*Sin(a), GetRandomReal(0, 359), 1.50, 2.00, 255.00,255,255,255,165))
                    else
                    set r3 = r3 + 0.03
                    endif
                if check == 0 then
                    set r = r + 0.03

                    // Æåëàåìûé óãîë ìûøè ñíà÷àëà îãðàíè÷èâàåòñÿ ñåêòîðîì
                    // baseA - 120 ãðàäóñîâ ... baseA + 120 ãðàäóñîâ.
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
                    
                    // Ãåðîé è ýôôåêò ïëàâíî èäóò ê ðàçðåø¸ííîìó óãëó.
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
                    call BlzSetSpecialEffectYaw(e4, a)

                    // Keep the additional R-style charge effects in front of Milim
                    // while she turns towards the mouse cursor.
                    if r == 0.30 then
                        set castFrontFx = EffectSpawnScale("war3mapImported\\wos_file00000739.mdl", GetUnitX(c)+90.00*Cos(a), GetUnitY(c)+90.00*Sin(a), a*bj_RADTODEG, 1.00, 1, 100.00, 0.75, 1, 3.45)
                        call BlzSetSpecialEffectAlpha(castFrontFx, 150)
                        set castFrontGlowFx = EffectSpawnScale("war3mapImported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdl", GetUnitX(c)+90.00*Cos(a), GetUnitY(c)+90.00*Sin(a), a*bj_RADTODEG, 1.00, 1, 100.00, 0.75, 1, 2.50)
                        set castFrontBallFx = EffectSpawnScale("war3mapImported\\wos_xtyball2.mdx", GetUnitX(c)+90.00*Cos(a), GetUnitY(c)+90.00*Sin(a), a*bj_RADTODEG, 1.00, 1, 0.00, 0.75, 1, 1.85)
                    endif
                    if castFrontFx != null then
                        call BlzSetSpecialEffectPosition(castFrontFx, GetUnitX(c)+90.00*Cos(a), GetUnitY(c)+90.00*Sin(a), 100.00)
                        call BlzSetSpecialEffectYaw(castFrontFx, a)
                        call BlzSetSpecialEffectPosition(castFrontGlowFx, GetUnitX(c)+90.00*Cos(a), GetUnitY(c)+90.00*Sin(a), 165.00)
                        call BlzSetSpecialEffectYaw(castFrontGlowFx, a)
                        call BlzSetSpecialEffectPosition(castFrontBallFx, GetUnitX(c)+90.00*Cos(a), GetUnitY(c)+90.00*Sin(a), 0.00)
                        call BlzSetSpecialEffectYaw(castFrontBallFx, a)
                    endif

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
                        call ColorEffDummy3(e, 0, 255, 1, 1, 0.20)
                        call DestroyEffect(e2)
                        call DestroyEffect(castFrontFx)
                        call DestroyEffect(castFrontGlowFx)
                        call DestroyEffect(castFrontBallFx)
                        set e = null
                        set e2 = null
                        set castFrontFx = null
                        set castFrontGlowFx = null
                        set castFrontBallFx = null
                        call ColorEffDummy3(EffectSpawn3("war3mapImported\\wos_file00005542_21.mdl",x+2800*Cos(a),y+2800*Sin(a),a*bj_RADTODEG,1.00,2.7,110.00,-90),MilimT2_BeamDuration,255,255,255,0.25)
                        call SetUnitAnimationByIndex(c, 15)
                        call SetUnitTimeScale(c, 1.00)
                        call MakeSound("war3mapimported\\Hero_Milim_TT4")
                        call VisionTimed(GetOwningPlayer(c),x+800*Cos(a),y+800*Sin(a),1200,4)
                        call VisionTimed(GetOwningPlayer(c),x+1600*Cos(a),y+1600*Sin(a),1200,4)
                        call VisionTimed(GetOwningPlayer(c),x+2400*Cos(a),y+2400*Sin(a),1200,4)

                        // Beam parameters copied from Starrk Q (k2 == 1).
                        // Every spawned segment is removed only after the damage phase ends.
                        set beamFxMove = 175.00
                        set beamFxScale = 6.20
                        set beamRingScale = 1.25
                        set beamRingTimer = 0.00
                    endif
                else
                    set r = r + 0.03
                    set r2 = r2 + 0.03
                    if r> 0.3 then 
                    set beamEffectLife = MilimT2_BeamDuration - r + 0.0
                    set beamSegment = 0
                    loop
                        exitwhen beamSegment > 3 or beamFxMove >= MilimT2_BeamRange - 150.00
                        if r < 0.09 then
                            set beamFxMove = beamFxMove + 9.00 + beamFxScale * 8.00
                        else
                            set beamFxMove = beamFxMove + 18.00 + beamFxScale * 9.00
                        endif
                        if beamFxMove > MilimT2_BeamRange  then
                            set beamFxMove = MilimT2_BeamRange 
                        endif

                        set x1 = x + (150.00 + beamFxMove) * Cos(a)
                        set y1 = y + (150.00 + beamFxMove) * Sin(a)
                       
                        call ColorEffDummy3(EffectSpawnColor("war3mapimported\\wos_ulqashar.mdx", x1, y1, a * bj_RADTODEG, 1.00, beamFxScale, 180.00 + r * 80.00, 25, 125, 255, 65),beamEffectLife,25,125,255,0.3)
                      //  call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx", x1, y1, a * bj_RADTODEG, 1.00, beamFxScale * 0.70, 180.00 + r * 80.00, beamEffectLife, 225, 225, 225, 205)
                        set beamFxScale = beamFxScale + 0.005
                        set beamSegment = beamSegment + 1
                    endloop

                    if beamRingTimer > 0.00 and beamFxMove < MilimT2_BeamRange  then
                        set beamRingTimer = 0.00
                        set beamRingScale = beamRingScale + 0.005
                        set beamEffect = EffectSpawn("war3mapImported\\wos_krk (1849)6.mdl", x1+450*Cos(a+90*bj_DEGTORAD), y1+450*Sin(a+90*bj_DEGTORAD), a * bj_RADTODEG+15, 1.75, beamRingScale, 125.00)
                        call MyRemoveEff(beamEffect, beamEffectLife)
                        set beamEffect = EffectSpawn("war3mapImported\\wos_krk (1849)6.mdl", x1+450*Cos(a-90*bj_DEGTORAD), y1+450*Sin(a-90*bj_DEGTORAD), a * bj_RADTODEG-15, 1.75, beamRingScale, 125.00)
                        call MyRemoveEff(beamEffect, beamEffectLife)
                        set beamEffect = null
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Eat_DiBanZhaKai2.mdx", x1, y1, GetRandomReal(0, 359), 2, 1.85, 0))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", x1, y1, a * bj_RADTODEG , 1, 1.5, 1, 255, 255, 255, 115))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1baozha_90.mdl", x1, y1, 1, 0.5,2.5, 1))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_cf2.mdx", x1, y1 , a * bj_RADTODEG, 1, 1.8, 15, 255, 255, 255, 125))
                    else
                        set beamRingTimer = beamRingTimer + 0.03
                    endif
                    endif
                    // Êîíè÷åñêîå AOE: îò 20% âîçëå êàñòåðà äî 65% â êîíöå ëó÷à.
                    // Ðàäèóñ ìåíÿåòñÿ ïëàâíî îòíîñèòåëüíî ïðîéäåííîé äëèíû.
                    set aoe = MilimT2_DamageAoe * (AOE_START_FACTOR + (AOE_END_FACTOR - AOE_START_FACTOR) * move / MilimT2_BeamRange)
                    set x1 = x + move * Cos(a)
                    set y1 = y + move * Sin(a)
                    call DecorRemove(c, x1, y1, MilimT2_DamageAoe, 100)
                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, x1, y1, MilimT2_DamageAoe, NoDecor_Cond)
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

                                    call SlowUnit(c, u, MilimT2_Slow, MilimT2_SlowDuration)

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
                call StopSpellUnit(c)
                call SetUnitAnimation(c, "stand")
                call SetUnitTimeScale(c, 1.00)

                if e != null then
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.20)
                endif
                call DestroyEffect(e2)

                call SetFly(c,0)
                call FlushChildHashtable(hs, GetHandleId(g2))
                call DestroyGroup(g)
                call DestroyGroup(g2)
                call DestroyGroup(g3)
                call DestroyEffect(e)   
                call DestroyEffect(e2)
                call DestroyEffect(e4)
                call DestroyEffect(castFrontFx)
                call DestroyEffect(castFrontGlowFx)
                call DestroyEffect(castFrontBallFx)
                set g = null
                set g2 = null
                set g3 = null
                set u = null
                set e = null
                set e2 = null
                set e4 = null
                set castFrontFx = null
                set castFrontGlowFx = null
                set castFrontBallFx = null
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
        set r3 = 0.00
        set r4 = 0.00
        set beamFxMove = 0.00
        set beamFxScale = 1.20
        set beamRingScale = 1.25
        set beamRingTimer = 0.00
        set move = 0.00
        set check = 0
        set castFrontFx = null
        set castFrontGlowFx = null
        set castFrontBallFx = null
        set aoe = MilimT2_DamageAoe * AOE_START_FACTOR
        set dmg = GetHeroAgi(c, true) * MilimT2_DamageAgiBase / I2R(MilimT2_DamageTicks)
        call SetFly(c,150)
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

        set e = EffectSpawnColor("war3mapImported\\wos_mr_war3_sxxq3.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.50, 7.00, 0.00,255,1,1,255)
        set e2 = AddSpecialEffectTarget("war3mapImported\\wos_ly-r-sg.mdx", c, "chest")
        set e4 = EffectSpawn("war3mapImported\\wos_4xpinkpillar_3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.50, 4.50, 255.00)

        if MUI_MilimT2 == 0 then
            call TimerStart(t_MilimT2, 0.03, true, function thistype.Loop_MilimT2)
        endif
    endmethod
endstruct

private struct MilimGKS
    private static framehandle array frame1
    private static framehandle array frame2
    private static framehandle array frame3
    private static framehandle array frame4
    private static framehandle array frame5
    private static framehandle array frame6

    private static method GetMaxDamage takes unit c returns real
        if GetHeroLevel(c) >= 35 then
            return MilimG_DamagetoStats3
        elseif GetHeroLevel(c) >= 25 then
            return MilimG_DamagetoStats2
        endif
        return MilimG_DamagetoStats1
    endmethod

    private static method UpdateFrame takes unit c returns nothing
        local integer pid = GetPlayerId(GetOwningPlayer(c))
        local real maxDamage = thistype.GetMaxDamage(c)
        local real damage = LoadReal(hs, GetHandleId(c), StringHash("milim g dmg"))

        if damage > maxDamage then
            set damage = maxDamage
            call SaveReal(hs, GetHandleId(c), StringHash("milim g dmg"), damage)
        endif
        if frame1[pid] != null then
            call BlzFrameSetMinMaxValue(frame3[pid], 0.00, maxDamage)
            call BlzFrameSetValue(frame3[pid], damage)
            call BlzFrameSetText(frame6[pid], "|c00FFFF00" + I2S(R2I(damage)) + "/" + I2S(R2I(maxDamage)) + "|r")
        endif
    endmethod

    public static method Start takes unit c returns nothing
        local integer pid
        local real tmpY = 0.0375
        local real maxDamage

        if c == null or GetHeroLevel(c) < 12 then
            return
        endif

        set pid = GetPlayerId(GetOwningPlayer(c))
        set maxDamage = thistype.GetMaxDamage(c)
        if frame1[pid] == null then
            set frame1[pid] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
            call BlzFrameSetAbsPoint(frame1[pid], FRAMEPOINT_CENTER, 0.055, 0.18 + tmpY)
            call BlzFrameSetSize(frame1[pid], 0.135, 0.035)
            call BlzFrameSetTexture(frame1[pid], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
            call BlzFrameSetVisible(frame1[pid], false)

            set frame2[pid] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame1[pid], 0, 0)
            call BlzFrameSetAbsPoint(frame2[pid], FRAMEPOINT_CENTER, 0.07, 0.185 + tmpY)
            call BlzFrameSetSize(frame2[pid], 0.1, 0.019)

            set frame3[pid] = BlzCreateFrameByType("STATUSBAR", "", frame1[pid], "", 0)
            call BlzFrameSetSize(frame3[pid], 0.1, 0.035)
            call BlzFrameSetScale(frame3[pid], 0.5)
            call BlzFrameSetModel(frame3[pid], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
            call BlzFrameSetAbsPoint(frame3[pid], FRAMEPOINT_CENTER, 0.05, 0.175 + tmpY)
            call BlzFrameSetMinMaxValue(frame3[pid], 0.00, maxDamage+10)
            call BlzFrameSetValue(frame3[pid], 0.00)

            set frame4[pid] = BlzCreateFrameByType("BACKDROP", "SS", frame1[pid], "", 0)
            call BlzFrameSetAbsPoint(frame4[pid], FRAMEPOINT_CENTER, 0.005, 0.18 + tmpY)
            call BlzFrameSetSize(frame4[pid], 0.03, 0.03)
            call BlzFrameSetTexture(frame4[pid], "ReplaceableTextures\\CommandButtons\\BTNHero_Milim_G.blp", 0, false)

            set frame5[pid] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1[pid], "", 0)
            call BlzFrameSetAbsPoint(frame5[pid], FRAMEPOINT_CENTER, 0.07, 0.185 + tmpY)
            call BlzFrameSetText(frame5[pid], "|c00FFFF00Damage received:|r")
            call BlzFrameSetScale(frame5[pid], 0.9)

            set frame6[pid] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1[pid], "", 0)
            call BlzFrameSetAbsPoint(frame6[pid], FRAMEPOINT_CENTER, 0.07, 0.17 + tmpY)
            call BlzFrameSetScale(frame6[pid], 0.9)
        endif

        if GetLocalPlayer() == GetOwningPlayer(c) then
            call BlzFrameSetVisible(frame1[pid], true)
        endif
        call thistype.UpdateFrame(c)
    endmethod

    public static method AddDamage takes unit c, real amount returns nothing
        local real oldDamage
        local real newDamage
        local real maxDamage

        if c == null or amount <= 0.00 or GetHeroLevel(c) < 12 then
            return
        endif

        set oldDamage = LoadReal(hs, GetHandleId(c), StringHash("milim g dmg"))
        set maxDamage = thistype.GetMaxDamage(c)
        set newDamage = oldDamage + amount
        if newDamage > maxDamage then
            set newDamage = maxDamage
        endif
        call SaveReal(hs, GetHandleId(c), StringHash("milim g dmg"), newDamage)

        if oldDamage < MilimG_DamagetoStats1 and newDamage >= MilimG_DamagetoStats1 then
            if GetUnitAbilityLevel(c, MilimG_Stat_ID1) == 0 then
                call UnitAddAbility(c, MilimG_Stat_ID1)
                call UnitMakeAbilityPermanent(c, true, MilimG_Stat_ID1)
            endif
            call MakeSound("war3mapimported\\Hero_Milim_G1")
        endif
        if GetHeroLevel(c) >= 25 and oldDamage < MilimG_DamagetoStats2 and newDamage >= MilimG_DamagetoStats2 then
            if GetUnitAbilityLevel(c, MilimG_Stat_ID2) == 0 then
                call UnitAddAbility(c, MilimG_Stat_ID2)
                call UnitMakeAbilityPermanent(c, true, MilimG_Stat_ID2)
            endif
            call MakeSound("war3mapimported\\Hero_Milim_G2")
        endif
        if GetHeroLevel(c) >= 35 and oldDamage < MilimG_DamagetoStats3 and newDamage >= MilimG_DamagetoStats3 then
            if GetUnitAbilityLevel(c, MilimG_Stat_ID3) == 0 then
                call UnitAddAbility(c, MilimG_Stat_ID3)
                call UnitMakeAbilityPermanent(c, true, MilimG_Stat_ID3)
            endif
            call MakeSound("war3mapimported\\Hero_Milim_G3")
        endif

        call thistype.Start(c)
    endmethod

    public static method Reset takes unit c returns nothing
        if c == null then
            return
        endif
        call UnitRemoveAbility(c, MilimG_Stat_ID1)
        call UnitRemoveAbility(c, MilimG_Stat_ID2)
        call UnitRemoveAbility(c, MilimG_Stat_ID3)
        call SaveReal(hs, GetHandleId(c), StringHash("milim g dmg"), 0.00)
        if GetHeroLevel(c) >= 12 then
            call thistype.Start(c)
        endif
    endmethod
endstruct




    
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
        call MilimGKS.Start(c)
    endfunction
    function MilimGAddDmg takes unit c, real amount returns nothing
    call SetMpCurrent(c,amount*0.05)
        call MilimGKS.AddDamage(c, amount)
    endfunction
    function MilimGOff_Start takes unit c returns nothing
        call MilimGKS.Reset(c)
    endfunction
   
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
