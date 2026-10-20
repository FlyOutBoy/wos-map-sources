library KyorakuSpells uses GearSystems
    globals
        private integer SH_KYORAKU_E4_CAGE = StringHash("kyoraku e4 cage")
        private integer SH_KYORAKU_E4_X = StringHash("kyoraku e4 x")
        private integer SH_KYORAKU_E4_Y = StringHash("kyoraku e4 y")
        // One hero tick replaces the per-ability 0.05 timers (runs only while any is active).
        private timer KyorakuTick05_Timer = CreateTimer()
        private boolean array KyorakuTick05_Active
        private integer KyorakuTick05_Users = 0
        private code KyorakuTick05_Callback = null
    endglobals

    private function KyorakuTick05_On takes integer k returns nothing
        if not KyorakuTick05_Active[k] then
            set KyorakuTick05_Active[k] = true
            set KyorakuTick05_Users = KyorakuTick05_Users + 1
            if KyorakuTick05_Users == 1 then
                call TimerStart(KyorakuTick05_Timer, 0.05, true, KyorakuTick05_Callback)
            endif
        endif
    endfunction

    private function KyorakuTick05_Off takes integer k returns nothing
        if KyorakuTick05_Active[k] then
            set KyorakuTick05_Active[k] = false
            set KyorakuTick05_Users = KyorakuTick05_Users - 1
            if KyorakuTick05_Users <= 0 then
                set KyorakuTick05_Users = 0
                call PauseTimer(KyorakuTick05_Timer)
            endif
        endif
    endfunction

    globals
        // One hero tick replaces the per-ability 0.03 timers (runs only while any is active).
        private timer KyorakuTick_Timer = CreateTimer()
        private boolean array KyorakuTick_Active
        private integer KyorakuTick_Users = 0
        private code KyorakuTick_Callback = null
    endglobals

    private function KyorakuTick_On takes integer k returns nothing
        if not KyorakuTick_Active[k] then
            set KyorakuTick_Active[k] = true
            set KyorakuTick_Users = KyorakuTick_Users + 1
            if KyorakuTick_Users == 1 then
                call TimerStart(KyorakuTick_Timer, 0.03, true, KyorakuTick_Callback)
            endif
        endif
    endfunction

    private function KyorakuTick_Off takes integer k returns nothing
        if KyorakuTick_Active[k] then
            set KyorakuTick_Active[k] = false
            set KyorakuTick_Users = KyorakuTick_Users - 1
            if KyorakuTick_Users <= 0 then
                set KyorakuTick_Users = 0
                call PauseTimer(KyorakuTick_Timer)
            endif
        endif
    endfunction

    globals
        // Hashed once at map load (was StringHash(...) on every call).
        private integer SH_BANKAI_1_ST_ACTIVATED = StringHash("bankai 1-st activated")
        private integer SH_BANKAI_END = StringHash("bankai end")
        private integer SH_CUR_MANA = StringHash("cur mana")
        private integer SH_DESC_T_OFF = StringHash("desc t off")
        private integer SH_INSTANT_END = StringHash("instant end")
        private integer SH_INSTANT_SKIP = StringHash("instant skip")
        private integer SH_KYORAKU_BANKAI = StringHash("kyoraku bankai")
        private integer SH_KYORAKU_ESC = StringHash("kyoraku esc")
        private integer SH_LAST_DAN = StringHash("last dan")
        private integer SH_SHADOW_AOE = StringHash("shadow aoe")
        private integer SH_SHADOW_EFF = StringHash("shadow eff")
        private integer SH_SHADOW_X = StringHash("shadow x")
        private integer SH_SHADOW_Y = StringHash("shadow y")
        private integer SH_W2_CAST = StringHash("w2 cast")
        private integer SH_WE_START = StringHash("we start")
        private integer SH_W_ACTIVE = StringHash("w active")
        private integer SH_W_START = StringHash("w start")
    endglobals
    globals
        integer Kyoraku_ID = 'H00U'
        unit array KyorDummy
        trigger Frame_clickKyoraku = CreateTrigger()
        framehandle array frame_KyorBankai7 [10]
        framehandle array frame_KyorBankai8 [10]
        framehandle array frame_KyorBankai9 [10]
        framehandle array frame_KyorBankai10 [10]
        framehandle array frame_KyorBankai11 [10]
        framehandle array frame_KyorBankai12 [10]
//---------------Q ability-----------------------------------------------------
        integer KyorakuQ_ID = 'A050'
        real KyorakuQ_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real KyorakuQ_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real KyorakuQ_Damage2StaticBase = 175 // base static damage for 1 level
        real KyorakuQ_Damage2StaticStep = 0 // additional static damage for each next level
        real KyorakuQ_DamageAoe = 500
//---------------Q2 ability-----------------------------------------------------
        integer KyorakuQ2_ID = 'A056'
        real KyorakuQ2_DamageAgiBase = 1.5 // base number x Agi damage for 1 level
        real KyorakuQ2_DamageAgiStep = 0.25 // additional number x Agi damage for each next level
//---------------W ability-----------------------------------------------------
        integer KyorakuW_ID = 'A051'
        integer KyorakuW_Dummy_ID = 'h00W'
        unit array KyorakuW_Dummy[10]
        real KyorakuW_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real KyorakuW_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real KyorakuW_Damage2StaticBase = 200 // base static damage for 1 level
        real KyorakuW_Damage2StaticStep = 0 // additional static damage for each next level
        real KyorakuW_DamageAoe = 500
        real KyorakuW_ShadowAoeBase = 600
        real KyorakuW_ShadowAoeStep = 110
        real KyorakuW_ShadowDuration = 6 // how long exist
//---------------W2 ability-----------------------------------------------------
        integer KyorakuW2_ID = 'A057'
        real KyorakuW2_Duration = 0.5 // time of moving
        real KyorakuW2_Speed = 3000 // per second
//---------------.e ability-----------------------------------------------------
        integer KyorakuE_ID = 'A052'
        integer KyorakuE2_ID = 'A058'
        real KyorakuE_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real KyorakuE_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real KyorakuE_Damage2StaticBase = 00 // base static damage for 1 level
        real KyorakuE_Damage2StaticStep = 0 // additional static damage for each next level
        real KyorakuE_DamageAoe = 625
        real KyorakuE_DurationBase =1.5
        real KyorakuE_DurationStep = 0 // add time per next level
//---------------WE ability-----------------------------------------------------
        real KyorakuE2_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real KyorakuE2_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real KyorakuE2_Damage2StaticBase = 0 // base static damage for 1 level
        real KyorakuE2_Damage2StaticStep = 0 // additional static damage for each next level
        real KyorakuE2_DamageAoe = 600 // better to make same value to W
        real KyorakuE2_DurationBase = 3
        real KyorakuE2_Stun = 1 // take stun main unit after end
        real KyorakuE2_Stun2 = 0.1 // take stun aroun unit while shadown jumping
        real KyorakuE2_FlyTime = 0.42 // whole shadow pass (was 0.6); keep multiples of 0.03
        real KyorakuE2_StrikeBeforeEnd = 0.15 // final strike this long before the end (was 0.21)
        real KyorakuE2_ShadowSpawnTime = 0.1 // shadows spawn during the first N sec
//---------------E2 (lv 25) Takaoni: fly through the E cage, two giant slashes---------
        integer KyorakuE4_ID = 'A114'
        integer KyorakuE4_Level = 25
        real KyorakuE4_DamageAgi = 2.5 // x Agi per slash
        integer KyorakuE4_Slashes = 2
        real KyorakuE4_MaxRange = 2000 // from the E cage
        real KyorakuE4_Speed = 2500 // per second
        real KyorakuE4_SlashScale = 3.2 // x Toji Q1 slash size
        real KyorakuE4_FlyPast = 650 // distance past the cage center
//---------------.r ability-----------------------------------------------------
        integer KyorakuR_ID = 'A053'
        integer KyorakuR_BuffId = 'B00G'
        real KyorakuR_DamageAgiBase = 4 // base number x Agi damage for 1 level .dmg per sec
        real KyorakuR_DamageAgiStep = 1 // additional number x Agi damage for each next level .dmg per sec
        real KyorakuR_Damage2StaticBase = 0 // base static damage for 1 level .dmg per sec
        real KyorakuR_Damage2StaticStep = 0 // additional static damage for each next level .dmg per sec
        real KyorakuR_Stun = 1
//---------------T ability-----------------------------------------------------
        integer KyorakuT_ID = 'A054'
        integer KyorakuT0_ID = 'A05D'
        integer KyorakuT1_ID = 'A05A'
        integer KyorakuT2_ID = 'A05B'
        integer KyorakuT3_ID = 'A05C'
        integer KyorakuT4_ID = 'A059'
        integer KyorakuT5_ID = 'A05E'
        integer KyorakuTSkip_ID = 'A0DY'
        integer KyorakuT_DummyID = 'h00V'
        integer KyorakuT_BankaiBuff = 'B00H'
        private integer array KyorakuBankaiStage
        boolean BankaiActive = false
        unit KyorakuBankaiCaster = null // only enemies of this hero can activate the bankai debuff
        real KyorakuT_BuffDelay = 0.5 // bankai debuff starts 0.5 sec after the cast
        real KyorakuT_Dan1_MinHp = 15 // hp cant go lower than this amount
        real KyorakuT_Dan1_Reverse = 0.7 // 1 = 100% reverse, 0.8 = 80%
        real KyorakuT_Dan2_KyorakuSelfHealEnter = 5 // % of max hp that kyoraku will restore for each main enemy hero that attacked someone while 1 - st dan, for example 3 heroes deal damage while 1 - st dan, when second activated kyoraku will restore instantly 3x10% = 30% of max hp
        real KyorakuT_Dan2_DamageAgi = 1.5 // base number x Agi damage per second
        real KyorakuT_Dan3_ManaBurn = 1.75 //% of max mana per second loose everyone
        real KyorakuT_Dan3_Dmg = 1.5 //Agi per second
        real KyorakuT_DanFinal_Dmg = 10 //Agi
        real KyorakuT_DanFinal_BaseCd = 9 // after gain last dan first cd 15 sec before use
        real KyorakuT_DanFinal_Stun = 1.5 // from 0.1 to 0.3
        real KyorakuT_Damage2StaticBase = 0 // base static damage
        real KyorakuT_DamageAoe = 2150
//---------------T ability-----------------------------------------------------
        integer KyorakuF_ID = 'A055'
        real KyorakuF_DamageAgiBase = 4 // base number x Agi damage
        real KyorakuF_DamageAoe = 775
        real KyorakuF_SilenceDuration = 1 // from 0.5 to 5 sec, 0.5...1...1.5..2....5
//--------------------------------------Kyoraku--------------------------------------------------------------
    endglobals    
// Stable public meter key; the current act supplies its caption and artwork.
private function KyorakuBankaiProgress takes unit c, integer stage, real remaining, real total returns nothing
    local integer pid = GetPlayerId(GetOwningPlayer(c))
    local integer art = KyorakuT0_ID
    local string title = "Bankai"
    if LoadInteger(hs, GetHandleId(c), SH_LAST_DAN) > 0 then
        set stage = 4
    endif
    if stage == 1 then
        set title = "1-st stage"
        set art = KyorakuT1_ID
    elseif stage == 2 then
        set title = "2-nd stage"
        set art = KyorakuT2_ID
    elseif stage == 3 then
        set title = "3-rd stage"
        set art = KyorakuT3_ID
    elseif stage == 4 then
        set title = "4-th stage"
        set art = KyorakuT4_ID
    endif
    call WUI_HeroProgressPublic(c, KyorakuT_ID, title, remaining, total)
    if KyorakuBankaiStage[pid] != stage + 1 then
        set KyorakuBankaiStage[pid] = stage + 1
        call WUI_HeroProgressIcon(c, KyorakuT_ID, BlzGetAbilityIcon(art))
    endif
endfunction

// Text height is presentation-only; every act can grow or shrink the same panel.
private function KyorakuBankaiHelp takes unit c, integer pid, integer abilityId returns nothing
    local ability a = BlzGetUnitAbility(c, abilityId)
    call BlzFrameSetSize(frame_KyorBankai7[pid], 0.164, 0.00)
    call BlzFrameSetText(frame_KyorBankai7[pid], BlzGetAbilityStringLevelField(a, ABILITY_SLF_TOOLTIP_NORMAL, 0) + "|n" + BlzGetAbilityStringLevelField(a, ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, 0))
    call WUI_ColumnHeight(frame_KyorBankai12[pid], RMaxBJ(0.035, BlzFrameGetHeight(frame_KyorBankai7[pid]) + 0.016))
    set a = null
endfunction

function KyorakuFrameClick takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local integer i = 0
    local integer i2 = 0
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local real x = 0.025
    local real y = -0.05  
    local integer k = 0
    loop
    exitwhen k == 10 
    if clicked == frame_KyorBankai8[k] then 
        if GetLocalPlayer() == p then
        call WUI_ColumnShow(frame_KyorBankai12[k], false)
        call BlzFrameSetVisible(frame_KyorBankai8[k],false)
        call BlzFrameSetVisible(frame_KyorBankai10[k],false)
        call BlzFrameSetVisible(frame_KyorBankai9[k],true)
        call BlzFrameSetVisible(frame_KyorBankai11[k],true)
        endif
        call SaveInteger(hs,GetHandleId(Player(pid)),SH_DESC_T_OFF,1)
    elseif clicked == frame_KyorBankai9[k] then
        if GetLocalPlayer() == p then    
        call WUI_ColumnShow(frame_KyorBankai12[k], true)
        call BlzFrameSetVisible(frame_KyorBankai8[k],true)
        call BlzFrameSetVisible(frame_KyorBankai10[k],true)
        call BlzFrameSetVisible(frame_KyorBankai9[k],false)
        call BlzFrameSetVisible(frame_KyorBankai11[k],false)
        endif 
        call SaveInteger(hs,GetHandleId(Player(pid)),SH_DESC_T_OFF,0)
    endif
    set k = k + 1
    endloop
    set clicked = null
    set p = null
    call WUI_ReleaseClickFocus()
endfunction

    function BuffUnitKyoraku takes unit c, unit u, integer level returns nothing
            local integer i = GetPlayerId(GetOwningPlayer(c))
            if KyorDummy[i] == null or GetWidgetLife(KyorDummy[i]) < 1 then
                set KyorDummy[i] = CreateUnit( Player( i ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
                call UnitAddAbility(KyorDummy[i], 'A09C')
            endif
            if level > 0 then
                if GetUnitAbilityLevel(KyorDummy[i], 'A09C') == 0 then
                    call UnitAddAbility(KyorDummy[i], 'A09C')
                endif
                call SetUnitAbilityLevel(KyorDummy[i], 'A09C', level)
                call SetUnitFacing(KyorDummy[i], GAngle(KyorDummy[i], u) * bj_RADTODEG)
                call IssueTargetOrder(KyorDummy[i], "curse", u)
            endif
    endfunction

    private struct KyorakuQ_KS
        private static integer array m_KyorakuQ
        private static integer MUI_KyorakuQ = -1
        unit c
        real x
        real y
        group g
        unit u
        real fly
        real dmg
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax
        static method Loop_KyorakuQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KyorakuQ
                set this = m_KyorakuQ[i]
                if SpellBoolCaster(.c) and .r <= .rmax then
                    set .r = .r + 0.03
                    set .r = RoundReal(.r, 3)
                    if false  then//GetHeroLevel(c)>= 35 then 
                    call DebugUnit(.c)
                    else
                    call DebugUnit2(.c)
                    endif
                    if .r <= 0.45 then
                        call MoveUnit(.c, .move, .a)
                        call SetFly(.c, GetUnitFlyHeight(.c) + .fly)
                    endif
                    if .r == 0.45 then
                        call MakeSound("war3mapimported\\Hero_Kyoraku_Q2")
                        set .fly = GetUnitFlyHeight(.c) / 5
                    endif
                    if .r >= 0.45 and .r <= 0.6 then
                        call SetFly(.c, GetUnitFlyHeight(.c) - .fly)
                    endif
                    if .r == 0.6 then
                        call SetFly(.c, 0)
                        call DestroyEffect(.e)
                        call DestroyEffect(.e2)
                        set .x = GetUnitX(.c)
                        set .y = GetUnitY(.c)
                        call DecorRemove(.c, .x, .y, .aoe, 40)
                        call VisionTimed(GetOwningPlayer(.c), .x, .y, .aoe , .rmax)
                        call GroupClear(.g)
                        call GroupEnumUnitsInRange(.g, .x, .y, .aoe, NoDecor_Cond)
                        loop
                            set .u = FirstOfGroup(.g)
                            exitwhen .u == null
                            if IsUnitEnemy(.u, GetOwningPlayer(.c)) and SpellBool(.u) then
                                call DamageSource('A050')
                                call dmgphys(.c, .u, .dmg)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_whiteakihared.mdx", GetUnitX(.u), GetUnitY(.u), GetRandomReal(0, 359), 0.85, 1, GetUnitFlyHeight(.u) + 50))
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", .u, "chest"))
                            endif
                            call GroupRemoveUnit(.g, .u)
                        endloop
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Effect_Order_DanGe_LiangYiShi_ZhiSiZhiMoYanZhanJi_purple.mdx", .x, .y, .a * bj_RADTODEG, 1.15, 3.5, 175))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_2.mdx", .x, .y, GetRandomReal(0, 359), 1.45, 4, 175, 255, 255, 255, 125))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_2.mdx", .x, .y, GetRandomReal(0, 359), 1.35, 5, 195, 255, 255, 255, 125))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_2.mdx", .x, .y, GetRandomReal(0, 359), 1.25, 6, 215, 255, 255, 255, 125))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_HakkeStart.mdx", .x, .y, GetRandomReal(0, 359), 1.5, 1.65, 3))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_acg_bbb.mdx", .x, .y, GetRandomReal(0, 359), 1.75, 2.35, 195, 255, 255, 255, 195))
                    endif
                else
                if false then//GetHeroLevel(c)>= 35 then 
                    call StopSpellUnit(.c)
                    else
                    call StopSpellUnit2(.c)
                    endif
                    
                    call DestroyGroup(.g)
                    call DestroyEffect(.e)
                    call DestroyEffect(.e2)
                    set .c = null
                    set .e = null
                    set .e2 = null
                    set .g = null
                    set .u = null
                    set m_KyorakuQ[i] = m_KyorakuQ[ MUI_KyorakuQ]
                    set MUI_KyorakuQ = MUI_KyorakuQ - 1
                    set i = i - 1 // revisit: the moved instance must not skip this tick
                    if MUI_KyorakuQ == -1 then
                        call KyorakuTick_Off(0)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KyorakuQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_KyorakuQ = MUI_KyorakuQ + 1
            set m_KyorakuQ[ MUI_KyorakuQ] = this
            set .c = NewC
            set .r = 0
            set .x = NewX
            set .y = NewY
            set .g = CreateGroup()
            if false then//GetHeroLevel(c)>= 35 then 
                    call StartSpellUnit(.c)
                    else
                    call StartSpellUnit2(.c)
                    endif
                    
            call MakeSound("war3mapimported\\Hero_Kyoraku_Q")
            set .a = GAngle2(.c, .x, .y)
            set .aoe = KyorakuQ_DamageAoe
            set .dmg = KyorakuQ_Damage2StaticBase + (KyorakuQ_Damage2StaticStep * (GetUnitAbilityLevel(.c, KyorakuQ_ID) - 1))
            set .dmg = .dmg + GetHeroAgi(.c, true) * (KyorakuQ_DamageAgiBase + (KyorakuQ_DamageAgiStep * (GetUnitAbilityLevel(.c, KyorakuQ_ID) - 1)))
            set .rmax = 0.6
            set .move = SR3(.c, .x, .y) / 15
            set .fly = 900 / 15
            call SetUnitTimeScale(.c, 0.6)
            call SetUnitAnimationByIndex(.c, 7)
            set .e = AddSpecialEffectTarget("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdx", .c, "hand right")
            set .e2 = AddSpecialEffectTarget("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdx", .c, "hand left")
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", GetUnitX(.c), GetUnitY(.c), GetRandomReal(0, 359), 0.8, 1, 0))
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", GetUnitX(.c), GetUnitY(.c), GetRandomReal(0, 359), 0.92, 1.25, 0))
            if MUI_KyorakuQ == 0 then
                call KyorakuTick_On(0)
            endif
        endmethod
    endstruct

    private struct KyorakuQ2_KS
        private static integer array m_KyorakuQ2
        private static integer MUI_KyorakuQ2 = -1
        unit c
        real x
        real y
        group g
        unit u
        real dmg
        real aoe
        real r
        real rmax
        static method Loop_KyorakuQ2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KyorakuQ2
                set this = m_KyorakuQ2[i]
                if SpellBoolCaster(.c) and .r <= .rmax then
                    set .r = .r + 0.03
                    set .r = RoundReal(.r, 3)
                    call DebugUnit2(.c)
                    if .r == .rmax then
                        call GroupClear(.g)
                        call GroupEnumUnitsInRange(.g, .x, .y, .aoe, NoDecor_Cond)
                        loop
                            set .u = FirstOfGroup(.g)
                            exitwhen .u == null
                            if IsUnitEnemy(.u, GetOwningPlayer(.c)) and SpellBool(.u) then
                                call DamageSource('A056')
                                call dmgphys(.c, .u, .dmg)
                                call DestroyEffect( AddSpecialEffectTarget("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", .u, "chest"))
                                call EffectSpawn2("war3mapimported\\wos_kageoni.mdx", GetUnitX(.u), GetUnitY(.u), GAngle2(.c, .x,.y), 1, 5, 1, 0.45)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", .u, "chest"))
                            endif
                            call GroupRemoveUnit(.g, .u)
                        endloop
                    endif
                else
                    call StopSpellUnit2(.c)
                    call DestroyGroup(.g)
                    set .c = null
                    set .g = null
                    set .u = null
                    set m_KyorakuQ2[i] = m_KyorakuQ2[ MUI_KyorakuQ2]
                    set MUI_KyorakuQ2 = MUI_KyorakuQ2 - 1
                    set i = i - 1 // revisit: the moved instance must not skip this tick
                    if MUI_KyorakuQ2 == -1 then
                        call KyorakuTick_Off(1)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KyorakuQ2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_KyorakuQ2 = MUI_KyorakuQ2 + 1
            set m_KyorakuQ2[ MUI_KyorakuQ2] = this
            set .c = NewC
            set .r = 0
            set .u = null 
            set .x = LoadReal(hs, GetHandleId(.c), SH_SHADOW_X)
            set .y = LoadReal(hs, GetHandleId(.c), SH_SHADOW_Y)
            set .aoe = LoadReal(hs, GetHandleId(.c), SH_SHADOW_AOE)
            set .g = CreateGroup()
            call StartSpellUnit2(.c)
            call MakeSound("war3mapimported\\Hero_Kyoraku_Q2")
            set .dmg = GetHeroAgi(.c, true) * (KyorakuQ2_DamageAgiBase + (KyorakuQ2_DamageAgiStep * (GetUnitAbilityLevel(.c, KyorakuQ2_ID) - 1)))
            set .rmax = 0.12
            call SetUnitAnimationByIndex(.c, 11)
            if MUI_KyorakuQ2 == 0 then
                call KyorakuTick_On(1)
            endif
        endmethod
    endstruct

    private struct KyorakuW_KS
        private static integer array m_KyorakuW
        private static integer MUI_KyorakuW = -1
        unit c
        real x
        real y
        integer k2
        real r5
        group g
        group g2
        unit u
        real dmg
        real aoe
        real aoe2
        real r
        effect e
        real rmax
        static method Loop_KyorakuW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KyorakuW
                set this = m_KyorakuW[i]
                if SpellBoolCaster(.c) and .r <= .rmax then
                    if LoadInteger(hs, GetHandleId(.c), SH_WE_START) == 0 then
                        set .r = .r + 0.03
                        set .r = RoundReal(.r, 3)
                    endif
                    if .r == 0.42 then
                        call SetUnitVertexColor(.c, 255, 255, 255, 0)
                    endif
                    if .r == 0.57 then
                        call SetUnitTimeScale( .c , 1.5)
                        call SetUnitAnimationByIndex( .c , 15)
                        call SetUnitVertexColor(.c, 255, 255, 255, 255)
                        set .r5 = GetUnitFacing(.c)
                        call MakeSound("war3mapimported\\Hero_Kyoraku_W3")
                        call PosUnit(.c, .x, .y)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_fangkuai2clear.mdl", .x, .y, 160, 2, 2.55, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_0305.mdx", .x, .y, 0, 0.75, 1.75, 55))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_0305.mdx", .x, .y, 0, 0.65, 2.35, 100))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_0305.mdx", .x, .y, 0, 0.55, 3.2, 125))
                    endif
                    if .r >= 0.57 then
                        if .r < 0.89 then
                            call SetFly(.c, GetUnitFlyHeight(.c) + 50)
                            set .r5 = .r5 + 15
                        endif
                        if .r == 0.57 or .r == 0.63 or .r == 0.69 or .r == 0.75 then
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_animeslashfinalanother.mdx", .x - 175 * Cos(.r5 * bj_DEGTORAD), .y - 175 * Sin(.r5 * bj_DEGTORAD), .r5, 0.4, 5.5, GetUnitFlyHeight(.c) + 175, 255, 255, 255, 205))
                        endif
                        if .r > 0.6 and .r < 0.75 then
                            call GroupClear(.g)
                            call DecorRemove(.c, .x, .y, .aoe, 40)
                            call GroupEnumUnitsInRange(.g, .x, .y, .aoe, NoDecor_Cond)
                            loop
                                set .u = FirstOfGroup(.g)
                                exitwhen .u == null
                                if IsUnitEnemy(.u, GetOwningPlayer(.c)) and SpellBool(.u) and IsUnitInGroup(.u, .g2) == false then
                                    call DamageSource('A051')
                                    call dmgphys(.c, .u, .dmg)
                                    call GroupAddUnit(.g2, .u)
                                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_whiteakihared.mdx", GetUnitX(.u), GetUnitY(.u), GetRandomReal(0, 359), 0.85, 1, GetUnitFlyHeight(.u) + 50))
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", .u, "chest"))
                                endif
                                call GroupRemoveUnit(.g, .u)
                            endloop
                        endif
                        if .r == 0.9 then
                            call SetFly(.c, 0)
                            call StopSpellUnit(.c)
                        endif
                    endif
                    if .r > 0.9 then
                        if .rmax - .r >= 0 then
                            call WUI_HeroProgress(.c, KyorakuW_ID, "Shadow Time Left", .rmax - .r, .rmax, true)
                        endif
                        set .x = GetEffX(.e)
                        set .y = GetEffY(.e)
                        if GetUnitAbilityLevel(.c, KyorakuW_ID) >= 3 then
                        if SR3(.c, .x, .y) <= .aoe2 then
                            call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuQ_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuW_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuE_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuQ2_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuW2_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuE2_ID, true)
                            if KyorakuW_Dummy[k2] == null then
                                set KyorakuW_Dummy[k2] = CreateUnit(GetOwningPlayer(.c), KyorakuW_Dummy_ID, .x, .y, 0)
                            endif
                        else
                            if KyorakuW_Dummy[k2] != null then
                                call RemoveUnit(KyorakuW_Dummy[k2])
                                set KyorakuW_Dummy[k2] = null
                            endif
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuQ_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuW_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuE_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuQ2_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuW2_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuE2_ID, false)
                        endif
                        endif
                    endif
                else
                    if .r < 1.12 then
                        call SetFly(.c, 0)
                        call StopSpellUnit(.c)
                    endif
                    if KyorakuW_Dummy[k2] != null then
                        call RemoveUnit(KyorakuW_Dummy[k2])
                        set KyorakuW_Dummy[k2] = null
                    endif
                    call RemoveSavedHandle(hs, GetHandleId(.c), SH_SHADOW_EFF)
                    call SaveReal(hs, GetHandleId(.c), SH_SHADOW_X, 0)
                    call SaveReal(hs, GetHandleId(.c), SH_SHADOW_Y, 0)
                    call SaveReal(hs, GetHandleId(.c), SH_SHADOW_AOE, 0)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuQ_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuW_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuE_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuQ2_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuW2_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuE2_ID, false)
                    if .r < 0.66 then
                        call SetUnitTimeScale( .c , 5)
                        call SetUnitAnimationByIndex( .c , 14)
                        call AnimDummy(.c, 0.3, 1)
                    endif
                        call WUI_HeroProgress(.c, KyorakuW_ID, "Shadow Time Left", 0.00, 0.00, true)
                    call SaveInteger(hs, GetHandleId(.c), SH_W_START, 0)
                   // call SetUnitPathing(.c, true)
                    call ColorEffDummy3(.e, 0, 255, 255, 255, 1.25)
                    call SetUnitVertexColor(.c, 255, 255, 255, 255)
                    call DestroyGroup(.g)
                    call DestroyGroup(.g2)
                    set .c = null
                    set .g = null
                    set .g2 = null
                    set .u = null
                    set m_KyorakuW[i] = m_KyorakuW[ MUI_KyorakuW]
                    set MUI_KyorakuW = MUI_KyorakuW - 1
                    set i = i - 1 // revisit: the moved instance must not skip this tick
                    if MUI_KyorakuW == -1 then
                        call KyorakuTick_Off(2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KyorakuW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_KyorakuW = MUI_KyorakuW + 1
            set m_KyorakuW[ MUI_KyorakuW] = this
            set .c = NewC
            set .x = NewX
            set .y = NewY
            set .r = 0
            set .g = CreateGroup()
            set .g2 = CreateGroup()
            set .k2 = GetPlayerId(GetOwningPlayer(.c))
            
            if false then 
                    call StartSpellUnit(.c)
                    else
                    call StartSpellUnit2(.c)
                    endif
            //call SetUnitPathing(.c, false)
            call MakeSound("war3mapimported\\Hero_Kyoraku_W1")
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_Kyoraku_W2")
            else
                call MakeSound("war3mapimported\\Hero_Kyoraku_W2 2")
            endif
            set .aoe = KyorakuW_DamageAoe
            set .dmg = KyorakuW_Damage2StaticBase + (KyorakuW_Damage2StaticStep * (GetUnitAbilityLevel(.c, KyorakuW_ID) - 1))
            set .dmg = .dmg + GetHeroAgi(.c, true) * (KyorakuW_DamageAgiBase + (KyorakuW_DamageAgiStep * (GetUnitAbilityLevel(.c, KyorakuW_ID) - 1)))
            set .rmax = 1.11
            call SetUnitAnimationByIndex( .c , 12)
            call SetUnitTimeScale( .c , 1)
            set .e = EffectSpawnColor("war3mapImported\\wos_hakkestart.mdx", .x, .y, GetRandomReal(0, 359), 1, 1.48 + 0.28 * ( (KyorakuW_ShadowAoeStep * (GetUnitAbilityLevel(.c, KyorakuW_ID) - 1)) / 200), 5, 255, 255, 255, 235)
            if GetUnitAbilityLevel(.c, KyorakuW_ID) >= 3 then
                set .rmax = KyorakuW_ShadowDuration
                set .rmax = .rmax + 1.12
                set .aoe2 = KyorakuW_ShadowAoeBase + (KyorakuW_ShadowAoeStep * (GetUnitAbilityLevel(.c, KyorakuW_ID) - 1))
                if GetUnitAbilityLevel(.c, KyorakuQ2_ID) == 0 then
                    call UnitAddAbility(.c, KyorakuQ2_ID)
                    call SetUnitAbilityLevel(.c, KyorakuQ2_ID, GetUnitAbilityLevel(.c, KyorakuW_ID))
                    call UnitAddAbility(.c, KyorakuW2_ID)
                    call SetUnitAbilityLevel(.c, KyorakuW2_ID, GetUnitAbilityLevel(.c, KyorakuW_ID))
                    call UnitAddAbility(.c, KyorakuE2_ID)
                    call SetUnitAbilityLevel(.c, KyorakuE2_ID, GetUnitAbilityLevel(.c, KyorakuE_ID))
                else
                    call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuQ2_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuW2_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuE2_ID, true)
                endif
                call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuQ_ID, false)
                call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuW_ID, false)
                call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuE_ID, false)
                if GetHeroLevel(.c) <= 25 then
                call OkarunEggCd(c,KyorakuE2_ID,BlzGetUnitAbilityCooldownRemaining(.c, KyorakuE_ID))
                endif
            endif
            call AnimDummyEff(.e, 0.25, 0)
            call SaveInteger(hs, GetHandleId(.c), SH_W_START, 1)
            call SaveEffectHandle(hs, GetHandleId(.c), SH_SHADOW_EFF, .e)
            call SaveReal(hs, GetHandleId(.c), SH_SHADOW_X, .x)
            call SaveReal(hs, GetHandleId(.c), SH_SHADOW_Y, .y)
            call SaveReal(hs, GetHandleId(.c), SH_SHADOW_AOE, .aoe2)
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_HakkeStart.mdx", GetUnitX(.c), GetUnitY(.c), GetRandomReal(0, 359), 1.25, 0.35, 3))
            if MUI_KyorakuW == 0 then
                call KyorakuTick_On(2)
            endif
        endmethod
    endstruct

    private struct KyorakuW2_KS
        private static integer array m_KyorakuW2
        private static integer MUI_KyorakuW2 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real aoe
        real move
        real r
        real a
        real rmax
        static method Loop_KyorakuW2 takes nothing returns nothing
            local integer this
            local real xx1 = 0
            local real yy1 = 0
            local integer i = 0
            loop
                exitwhen i > MUI_KyorakuW2
                set this = m_KyorakuW2[i]
                if SpellBoolCaster(.c) and .r <= .rmax and LoadInteger(hs, GetHandleId(.c), SH_W_START) == 1 and LoadInteger(hs, GetHandleId(GetOwningPlayer(.c)), SH_KYORAKU_ESC) == 0 then
                    set .r = .r + 0.03
                    call DebugUnit(.c)
                    set .r = RoundReal(.r, 3)
                    set .x1 = GetMouseX(GetOwningPlayer(c))
                    set .y1 = GetMouseY(GetOwningPlayer(c))
                    set .a = GAngle2(.c, .x1, .y1)
                    set xx1 = GetUnitX(.c) + .move * Cos(.a)
                    set yy1 = GetUnitY(.c) + .move * Sin(.a)
                    if SR0(xx1, yy1, .x, .y) < .aoe then
                        if SR3(.c, .x1, .y1) > .move then
                            call MoveUnit(.c, .move, .a)
                        elseif SR3(.c, .x1, .y1) > 10 then
                            call SetUnitX(.c, .x1)
                            call SetUnitY(.c, .y1)
                        endif
                    else
                    endif
                else
                    call StopSpellUnit(.c)                   
                    
                        call MouseOff(GetOwningPlayer(c))
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(.c)), SH_W_ACTIVE, 0)
                    call SetUnitTimeScale( .c , 5)
                    call SetUnitAnimationByIndex( .c , 14)
                    call AnimDummy(.c, 0.3, 1)
                    call SetUnitPathing(.c, true)
                    set .c = null
                    set m_KyorakuW2[i] = m_KyorakuW2[ MUI_KyorakuW2]
                    set MUI_KyorakuW2 = MUI_KyorakuW2 - 1
                    set i = i - 1 // revisit: the moved instance must not skip this tick
                    if MUI_KyorakuW2 == -1 then
                        call KyorakuTick_Off(3)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KyorakuW2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_KyorakuW2 = MUI_KyorakuW2 + 1
            set m_KyorakuW2[ MUI_KyorakuW2] = this
            set .c = NewC
            set .x = LoadReal(hs, GetHandleId(.c), SH_SHADOW_X)
            set .y = LoadReal(hs, GetHandleId(.c), SH_SHADOW_Y)
            set .aoe = LoadReal(hs, GetHandleId(.c), SH_SHADOW_AOE)
            set .r = 0
            set .a = 0
            
                        set MouseX[GetPlayerId(GetOwningPlayer(c))] = x 
                        set MouseY[GetPlayerId(GetOwningPlayer(c))] = y 
            call MouseOn(GetOwningPlayer(c))
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(.c)), SH_W_ACTIVE, 1)
            call StartSpellUnit(.c)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(.c)), SH_KYORAKU_ESC, 0)
            call SetUnitPathing(.c, false)
            set .rmax = KyorakuW2_Duration
            set .move = KyorakuW2_Speed / 30
            call SetUnitAnimationByIndex( .c , 12)
            call SetUnitTimeScale( .c , 2)
            if MUI_KyorakuW2 == 0 then
                call KyorakuTick_On(3)
            endif
        endmethod
    endstruct

    private struct KyorakuE_KS
        private static integer array m_KyorakuE
        private static integer MUI_KyorakuE = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real scale
        real r3
        group g
        unit u
        real dmg
        integer check
        real aoe
        real move
        real r
        effect e
        real a
        real rmax
        static method Loop_KyorakuE takes nothing returns nothing
            local integer this
            local integer i = 0
            local real .x1
            local real .y1
            loop
                exitwhen i > MUI_KyorakuE
                set this = m_KyorakuE[i]
                if SpellBoolCaster(.c) and .r <= .rmax then
                    set .r = .r + 0.03
                    set .r = RoundReal(.r, 3)
                    if .r == 0.33 then
                        call SetUnitAnimationByIndex(.c, 10)
                    endif
                    if .r == 0.45 then
                        call AnimDummy(.c, 0.25, 1)
                        set .e = EffectSpawn("war3mapimported\\wos_az_bujingdule03512.mdl", GetUnitX(.c) + 100 * Cos(.a), GetUnitY(.c) + 100 * Sin(.a) , .a * bj_RADTODEG, 1.45, 0.55, 10)
                        call BlzSetSpecialEffectAlpha(.e, 125)
                        set .scale = 0.55
                        call PauseUnit(.c, false)
                        call SetUnitTimeScale( .c , 1)
                        call UnitRemoveAbility(.c, 'Avul')
                    endif
                    if .r >= 0.45 then
                        set .x1 = GetEffX(.e)
                        set .y1 = GetEffY(.e)
                        if .scale < 3. then
                            set .scale = .scale + 0.15
                            call BlzSetSpecialEffectScale(.e, .scale)
                        endif
                        if .aoe < KyorakuE_DamageAoe then
                            set .aoe = .aoe + 50
                        endif
                        if .aoe > KyorakuE_DamageAoe then
                            set .aoe = KyorakuE_DamageAoe
                        endif
                        if SR5(.e, .x, .y) > .move then
                            set .a = GAngle5(.e, .x, .y)
                            call MoveEff(.e, .move, .a)
                        elseif .check == 0 then
                            set .rmax = .rmax + .r+0.06
                            call VisionTimed(GetOwningPlayer(.c), .x, .y, .aoe * 1.75, .rmax)
                            set .check = 1
                            call BlzSetSpecialEffectPosition(e,x,y,10)
                            call MakeSound("war3mapimported\\Hero_Kyoraku_E3")
                        endif
                        if .r3 > 0.12 then
                            set .r3 = 0
                            if .check == 1 then
                                call EffectSpawnColor2("war3mapimported\\wos_az_bujingdule03512.mdl", .x1, .y1, GetRandomReal(0, 359), 1, .scale - 1.35, 180, 0.12, 255, 255, 255, 125)
                                call EffectSpawn2("war3mapimported\\wos_xxxxuanfeng2.mdl", .x1, .y1, GetRandomReal(0, 359), 1, 2.5, 125, 0.5)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_white-qiquan-new.mdx", .x1, .y1, GetRandomReal(0, 359), 1, 2.65, 0))
                                call EffectSpawn2("war3mapimported\\wos_az_bujingdule03512.mdl", .x1, .y1, GetRandomReal(0, 359), 1, 1.5, 0, 0.15)
                            endif
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_3.mdx", .x1, .y1, GetRandomReal(0, 359), 0.85, 2.95, 0))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_3.mdx", .x1, .y1, GetRandomReal(0, 359), 0.65, 3.85, 0))
                        else
                            set .r3 = .r3 + 0.03
                        endif
                        if .check > 0 then
                            if .r2 > 0.21 then
                                set .r2 = 0
                                call DecorRemove(.c, .x, .y, .aoe, 30)
                                call GroupClear(.g)
                                call GroupEnumUnitsInRange(.g, .x1, .y1, .aoe, NoDecor_Cond)
                                loop
                                    set .u = FirstOfGroup(.g)
                                    exitwhen .u == null
                                    if IsUnitEnemy(.u, GetOwningPlayer(.c)) and SpellBool(.u) then
                                        call DamageSource('A052')
                                        call dmgmag(.c, .u, .dmg)
                                        call MUE(.u, 175, 0.21, GAngle2(.u, .x, .y))
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", .u, "chest"))
                                    endif
                                    call GroupRemoveUnit(.g, .u)
                                endloop
                            else
                                set .r2 = .r2 + 0.03
                            endif
                        endif
                    endif
                else
                    call DestroyEffect(.e)
                    if .r < 0.45 then
                    call StopSpellUnit2(.c)
                    endif
                    call SaveInteger(hs, GetHandleId(.c), SH_KYORAKU_E4_CAGE, 0)
                    // The real cage lifetime owns E2 availability, not a longer swap timer.
                    if LoadInteger(hs, GetHandleId(GetOwningPlayer(.c)), GearKey(GEAR_KEY_AHUI_SWAP, "AHUI swap ", KyorakuE_ID)) == KyorakuE4_ID then
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuE4_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuE_ID, true)
                        call SaveInteger(hs, GetHandleId(GetOwningPlayer(.c)), GearKey(GEAR_KEY_AHUI_SWAP, "AHUI swap ", KyorakuE_ID), 0)
                    endif
                    call DestroyGroup(.g)
                    set .c = null
                    set .g = null
                    set .e = null
                    set m_KyorakuE[i] = m_KyorakuE[ MUI_KyorakuE]
                    set MUI_KyorakuE = MUI_KyorakuE - 1
                    set i = i - 1 // revisit: the moved instance must not skip this tick
                    if MUI_KyorakuE == -1 then
                        call KyorakuTick_Off(4)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KyorakuE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_KyorakuE = MUI_KyorakuE + 1
            set m_KyorakuE[ MUI_KyorakuE] = this
            set .c = NewC
            set .r = 0
            set .check = 0
            set .x = NewX
            set .y = NewY
            set .g = CreateGroup()
            set .move = 125
            call PauseUnit( .c , true)
            call MakeSound("war3mapimported\\Hero_Kyoraku_E1")
            call MakeSound("war3mapimported\\Hero_Kyoraku_E2")
            set .aoe = KyorakuE_DamageAoe
            set .dmg = KyorakuE_Damage2StaticBase + (KyorakuE_Damage2StaticStep * (GetUnitAbilityLevel(.c, KyorakuE_ID) - 1))
            set .dmg = .dmg + GetHeroAgi(.c, true) * (KyorakuE_DamageAgiBase + (KyorakuE_DamageAgiStep * (GetUnitAbilityLevel(.c, KyorakuE_ID) - 1)))
            set .rmax = KyorakuE_DurationBase + (KyorakuE_DurationStep * (GetUnitAbilityLevel(.c, KyorakuE_ID) - 1)) 
            set .dmg = .dmg / (.rmax * 4)
            call SetUnitAnimationByIndex( .c , 8)
            call SetUnitTimeScale( .c , 2)
            call SaveInteger(hs, GetHandleId(.c), SH_KYORAKU_E4_CAGE, 1)
            call SaveReal(hs, GetHandleId(.c), SH_KYORAKU_E4_X, .x)
            call SaveReal(hs, GetHandleId(.c), SH_KYORAKU_E4_Y, .y)
            if GetHeroLevel(.c) >= KyorakuE4_Level then
                // cage travel (125 per 0.03 sec) + its duration
                call SwapAbility(.c, SR3(.c, .x, .y) / 4166.0 + 0.45 + .rmax + 0.2, KyorakuE4_ID, KyorakuE_ID)
            endif
            if MUI_KyorakuE == 0 then
                call KyorakuTick_On(4)
            endif
        endmethod
    endstruct

    // E2 (Takaoni): Kyoraku flies through the Bushogoma cage and slashes it twice.
    private struct KyorakuE4_KS
        private static integer array m_KyorakuE4
        private static integer MUI_KyorakuE4 = -1
        unit c
        real x
        real y
        real endX
        real endY
        real a
        real r
        real dmg
        integer slashes
        group g
        effect e

        private method slash takes nothing returns nothing
            local unit u
            local real side = 60
            if ModuloInteger(slashes, 2) == 1 then
                set side = -60
            endif
            call DestroyEffect(EffectSpawnColor3("war3mapImported\\wos_blue_circular.mdl", x, y, a * bj_RADTODEG + side, 1.25, 0.45 * KyorakuE4_SlashScale, 145, -30, 255, 255, 255, 195))
            call DestroyEffect(EffectSpawnColor3("war3mapImported\\wos_animeslashfinalanother.mdl", x, y, a * bj_RADTODEG + side, 1.0, 2.25 * KyorakuE4_SlashScale, 185, -35, 255, 255, 255, 125))
            if slashes == 0 then
                call MakeSound("war3mapimported\\Hero_Kyoraku_Q2")
            endif
            if slashes == 0 then
                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_zhanji-blue.mdl", x + 10 * Cos(a), y + 10 * Sin(a), a * bj_RADTODEG, 1, 1, 175, 45))
            else
                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_zhanji-blue.mdl", x + 10 * Cos(a), y + 10 * Sin(a), a * bj_RADTODEG, 1, 1, 175, -45))
            endif
            call GroupEnumUnitsInRange(g, x, y, KyorakuE_DamageAoe, NoDecor_Cond)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                call GroupRemoveUnit(g, u)
                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                    call DamageSource(KyorakuE4_ID)
                    call dmgphys(c, u, dmg)
                    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_bloodex-special-23.mdl", u, "chest"))
                endif
            endloop
            set slashes = slashes + 1
        endmethod

        static method Loop_KyorakuE4 takes nothing returns nothing
            local thistype this
            local integer i = 0
            local boolean done
            local real move = KyorakuE4_Speed * 0.03
            loop
                exitwhen i > MUI_KyorakuE4
                set this = m_KyorakuE4[i]
                set done = not SpellBoolCaster(c)
                if not done then
                    if SR3(c, endX, endY) > move then
                        call MoveUnit(c, move, a)
                    else
                        call SetUnitX(c, endX)
                        call SetUnitY(c, endY)
                        set done = true
                    endif
                    // Cross the cage: both hits happen in this tick, before the overshoot.
                    if slashes == 0 and (x - GetUnitX(c)) * Cos(a) + (y - GetUnitY(c)) * Sin(a) <= 100 then
                        loop
                            exitwhen slashes >= KyorakuE4_Slashes
                            call slash()
                        endloop
                    endif
                endif
                if done then
                    call DestroyEffect(e)
                    call StopSpellUnit2(c)
                    call SetUnitTimeScale(c, 1)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), KyorakuE4_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), KyorakuE_ID, true)
                    call DestroyGroup(g)
                    set e = null
                    set g = null
                    set c = null
                    set m_KyorakuE4[i] = m_KyorakuE4[MUI_KyorakuE4]
                    set MUI_KyorakuE4 = MUI_KyorakuE4 - 1
                    set i = i - 1
                    if MUI_KyorakuE4 == -1 then
                        call KyorakuTick_Off(10)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method KyorakuE4_Start takes unit NewC returns nothing
            local thistype this
            local real tx = LoadReal(hs, GetHandleId(NewC), SH_KYORAKU_E4_X)
            local real ty = LoadReal(hs, GetHandleId(NewC), SH_KYORAKU_E4_Y)
            if LoadInteger(hs, GetHandleId(NewC), SH_KYORAKU_E4_CAGE) == 0 then
                call DisplayTimedTextToPlayer(GetOwningPlayer(NewC), 0, 0, 2, "|cffff4040No Bushogoma cage to fly to.|r")
                return
            endif
            if SR3(NewC, tx, ty) > KyorakuE4_MaxRange then
                call DisplayTimedTextToPlayer(GetOwningPlayer(NewC), 0, 0, 2, "|cffff4040Too far from the cage (max " + I2S(R2I(KyorakuE4_MaxRange)) + ").|r")
                return
            endif
            set this = thistype.create()
            set MUI_KyorakuE4 = MUI_KyorakuE4 + 1
            set m_KyorakuE4[MUI_KyorakuE4] = this
            set c = NewC
            set x = tx
            set y = ty
            set a = GAngle2(c, x, y)
            if SR3(c, x, y) < 1 then
                set a = GetUnitFacing(c) * bj_DEGTORAD
            endif
            set endX = x + KyorakuE4_FlyPast * Cos(a)
            set endY = y + KyorakuE4_FlyPast * Sin(a)
            set slashes = 0
            set r = 0
            set g = CreateGroup()
            set dmg = GetHeroAgi(c, true) * KyorakuE4_DamageAgi
            call StartSpellUnit2(c)
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex(c, 15)
            call SetUnitTimeScale(c, 0.5)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_whiteauralance_white.mdl", c, "hand right")
            if MUI_KyorakuE4 == 0 then
                call KyorakuTick_On(10)
            endif
        endmethod
    endstruct

    private struct KyorakuE3_KS
        private static integer array m_KyorakuE3
        private static integer MUI_KyorakuE3 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r4
        real r5
        real fly
        real move
        real r
        effect e
        effect e2
        effect e3
        real sr
        real a
        real rmax
        static method Loop_KyorakuE3 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real .x1
            local real .y1
            loop
                exitwhen i > MUI_KyorakuE3
                set this = m_KyorakuE3[i]
                if SpellBoolCaster(.c) and .r <= .rmax then
                    set .r = .r + 0.03
                    set .r = RoundReal(.r, 3)
                    call MoveEff2(.e, .move, .a)
                    call MoveEff2(.e2, .move, .a)
                    call MoveEff2(.e3, .move, .a)
                    set .r2 = .r2 + ( .move)
                    call BlzSetSpecialEffectHeight(.e, Parabola(.fly, .sr, .r2))
                    call BlzSetSpecialEffectPitch(.e, (.r / .rmax) * 1.24)
                    call BlzSetSpecialEffectHeight(.e2, Parabola(.fly, .sr, .r2))
                    call BlzSetSpecialEffectHeight(.e3, Parabola(.fly, .sr, .r2))
                else
                    call ColorEffDummy3(.e, 0, 0, 0, 0, 0.25)
                    call ColorEffDummy3(.e2, 0, 0, 0, 0, 0.25)
                    call ColorEffDummy3(.e3, 0, 0, 0, 0, 0.25)
                    set .c = null
                    set .e = null
                    set .e2 = null
                    set .e3 = null
                    set m_KyorakuE3[i] = m_KyorakuE3[ MUI_KyorakuE3]
                    set MUI_KyorakuE3 = MUI_KyorakuE3 - 1
                    set i = i - 1 // revisit: the moved instance must not skip this tick
                    if MUI_KyorakuE3 == -1 then
                        call KyorakuTick_Off(5)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KyorakuE3_Start takes unit NewC, real NewX, real NewY, real NewRmax returns nothing
            local thistype this = thistype.create( )
            local real .x1
            local real .y1
            set MUI_KyorakuE3 = MUI_KyorakuE3 + 1
            set m_KyorakuE3[MUI_KyorakuE3] = this
            set .c = NewC
            set .r = 0
            set .x = NewX
            set .y = NewY
            set .r2 = 0
            set .fly = GetRandomReal(450, 800)
            set .r4 = GetRandomReal(675, 950)
            set .r5 = GetRandomReal(0, 359) * bj_DEGTORAD
            set .e = EffectSpawn("war3mapImported\\wos_Kyoraku.mdx", .x + .r4 * Cos(.r5), .y + .r4 * Sin(.r5), Atan2(.y - (.y + .r4 * Sin(.r5)), .x - (.x + .r4 * Cos(.r5))) * bj_RADTODEG, 1, BlzGetUnitRealField(.c, UNIT_RF_SCALING_VALUE), 0)
            set .e2 = EffectSpawn("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdx", .x + .r4 * Cos(.r5), .y + .r4 * Sin(.r5), Atan2(.y - (.y + .r4 * Sin(.r5)), .x - (.x + .r4 * Cos(.r5))) * bj_RADTODEG, 1, 1, 0)
            set .e3 = EffectSpawn("war3mapimported\\wos_whiteauralance.mdx", .x + .r4 * Cos(.r5), .y + .r4 * Sin(.r5), Atan2(.y - (.y + .r4 * Sin(.r5)), .x - (.x + .r4 * Cos(.r5))) * bj_RADTODEG, 1, 2, 0)
            call BlzSetSpecialEffectColor(.e, 0, 0, 0)
            call ColorEffDummy4(.e, 0, 0, 0, 0, 0.4)
            call BlzPlaySpecialEffect(.e, ANIM_TYPE_ATTACK)
            set .rmax = NewRmax
            set .a = GAngle5(.e, .x, .y)
            set .r4 = GetRandomReal(0, KyorakuE2_DamageAoe / 1.5)
            set .r5 = GetRandomReal(0, 359) * bj_DEGTORAD
            set .x1 = .x + .r4 * Cos(.r5)
            set .y1 = .y + .r4 * Sin(.r5)
            set .sr = SR5(.e, .x1, .y1)
            set .move = .sr / (.rmax * 33)
            if MUI_KyorakuE3 == 0 then
                call KyorakuTick_On(5)
            endif
        endmethod
    endstruct

    private struct KyorakuE2_KS
        private static integer array m_KyorakuE2
        private static integer MUI_KyorakuE2 = -1
        unit c
        unit td
        real x
        real y
        real r3
        group g
        real dmg
        real aoe
        real r
        real rmax
        static method Loop_KyorakuE2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real .x1
            local real .y1
            loop
                exitwhen i > MUI_KyorakuE2
                set this = m_KyorakuE2[i]
                if SpellBoolCaster(.c) and SpellBoolCaster(td) and .r <= .rmax then
                    set .r = .r + 0.03
                    call SetUnitX(.td, .x)
                    call SetUnitY(.td, .y)
                    set .r = RoundReal(.r, 3)
                    if .r < KyorakuE2_ShadowSpawnTime then
                        //if .r3 > 0.0 then
                          //  set .r3 = 0
                        call KyorakuE3_KS.KyorakuE3_Start(.c, .x, .y, rmax - .r)
                       // else
                        //    set .r3 = .r3 + 0.03
                       // endif
                    endif
                    if .r == rmax - KyorakuE2_StrikeBeforeEnd then
                        call MakeSound("war3mapimported\\Hero_Kyoraku_W3")
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_FantasyBattle (1517).mdx", .x, .y, GetRandomReal(0, 359), 1.25, 1.04, 3))
                        call SetUnitTimeScale( .c , 5)
                        call SetUnitAnimationByIndex( .c , 14)
                        call PosUnit(.c, .x, .y)
                        call SetUnitAnimation(.c, "attack")
                    endif
                else
                call StopSpellUnit(c)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-wsfx-2.mdl", GetUnitX(.td), GetUnitY(.td), GetRandomReal(0, 359), 0.5, 2, 145))
                    call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_bloodex-special-23.mdl", .td, "chest"), 1.5)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_Nanaya2Skill06Dred.mdl", GetUnitX(.td), GetUnitY(.td), 1.45, 1, 1.45, 125))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)4.mdl", GetUnitX(.td), GetUnitY(.td), 0, 2, 1, 1))
                    call StunUnit(.c, .td, KyorakuE2_Stun)
                    call DamageSource('A058')
                    call dmgphys(.c, .td, .dmg)
                    call SaveInteger(hs, GetHandleId(.c), SH_WE_START, 0)
                    call StopSpellUnit(.c)
                    call DestroyGroup(.g)
                    set .c = null
                    set .g = null
                    set m_KyorakuE2[i] = m_KyorakuE2[ MUI_KyorakuE2]
                    set MUI_KyorakuE2 = MUI_KyorakuE2 - 1
                    set i = i - 1 // revisit: the moved instance must not skip this tick
                    if MUI_KyorakuE2 == -1 then
                        call KyorakuTick_Off(6)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KyorakuE2_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_KyorakuE2 = MUI_KyorakuE2 + 1
            set m_KyorakuE2[ MUI_KyorakuE2] = this
            set .c = NewC
            set .td = NewTd
            set .r = 0
            set .r3 = 0
            set .x = GetUnitX(.td)
            set .y = GetUnitY(.td)
            set .g = CreateGroup()
            call PosUnit(.c, .x, .y)
            call StartSpellUnit(.c)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_Kyoraku_WE1")
            else
                call MakeSound("war3mapimported\\Hero_Kyoraku_WE2")
            endif
            if GetHeroLevel(.c) <= 25 then
            call OkarunEggCd(c,KyorakuE_ID,BlzGetUnitAbilityCooldown(.c, KyorakuE_ID, GetUnitAbilityLevel(.c, KyorakuE_ID) - 1))
            endif
            set .aoe = KyorakuE2_DamageAoe
            set .dmg = KyorakuE2_Damage2StaticBase + (KyorakuE2_Damage2StaticStep * (GetUnitAbilityLevel(.c, KyorakuE_ID) - 1))
            set .dmg = .dmg + GetHeroAgi(.c, true) * (KyorakuE2_DamageAgiBase + (KyorakuE2_DamageAgiStep * (GetUnitAbilityLevel(.c, KyorakuE_ID) - 1)))
            set .rmax = KyorakuE2_FlyTime
            call SaveInteger(hs, GetHandleId(.c), SH_WE_START, 1)
            call BlzSetSpecialEffectPosition(LoadEffectHandle(hs, GetHandleId(.c), SH_SHADOW_EFF), .x, .y, 3)
            call VisionTimed(GetOwningPlayer(.c), .x, .y, .aoe * 1.75, .rmax)
            call SetUnitAnimationByIndex( .c , 12)
            call SetUnitTimeScale( .c , 2)
            if MUI_KyorakuE2 == 0 then
                call KyorakuTick_On(6)
            endif
        endmethod
    endstruct

    private struct KyorakuR_KS
        private static integer array m_KyorakuR
        private static integer MUI_KyorakuR = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        real r6
        real dmg
        integer check
        integer check2
        real r
        effect e
        real sr
        real a
        real rmax
        static method Loop_KyorakuR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KyorakuR
                set this = m_KyorakuR[i]
                if SpellBoolCaster(.c)  and SpellBoolCaster(td) and .r <= .rmax then
                    set .r = .r + 0.05
                    set .r = RoundReal(.r, 3)
                    if .r == 0.05 then
                        call MakeSound("war3mapimported\\Hero_Kyoraku_RNEW")
                      //  call MakeSound("war3mapimported\\Hero_Kyoraku_R1")
                        call StartSpellUnit(.c)
                    endif
                    if .r < 2 then
                        call DebugUnit(.c)
                    endif
                    if .r2 > 0.1 then
                        set .r2 = 0
                        call VisionTimed(GetOwningPlayer(.c), GetUnitX(.td), GetUnitY(.td), 800, 1)
                    else
                        set .r2 = .r2 + 0.05
                    endif
                   if .r == 0.3 or .r == 0.6 or .r == 0.9 or .r == 1.2 or .r == 1.5  then
                        set check2 = check2 + 1
                        if .r < 5.3 then
                            // 1. Р‘РµСЂРµРј Р°РєС‚СѓР°Р»СЊРЅС‹Рµ РєРѕРѕСЂРґРёРЅР°С‚С‹ (РґРѕР±Р°РІРёР» С‚РѕС‡РєРё РґР»СЏ РЅР°РґРµР¶РЅРѕСЃС‚Рё vJASS)
                            set .x = GetUnitX(.td)
                            set .y = GetUnitY(.td) 
                            
                            // 2. РћР±РЅРѕРІР»СЏРµРј РґРёСЃС‚Р°РЅС†РёСЋ Рё Р“Р›РђР’РќРћР• вЂ” РѕР±РЅРѕРІР»СЏРµРј СѓРіРѕР» С‚СЂР°РµРєС‚РѕСЂРёРё
                            set sr = SR0(x1, y1, .x, .y)
                            set .a = Atan2(.y - y1, .x - x1) // <-- РўСЂР°РµРєС‚РѕСЂРёСЏ С‚РµРїРµСЂСЊ СЃР»РµРґСѓРµС‚ Р·Р° Р±Р»РёРЅРєРѕРј С†РµР»Рё
                            
                            // 3. Р’С‹СЃС‡РёС‚С‹РІР°РµРј Р·РёРіР·Р°Рі, РёСЃРїРѕР»СЊР·СѓСЏ Р°РєС‚СѓР°Р»СЊРЅС‹Р№ .a
                            if .check == 0 then
                                set .check = 1
                                call PosUnit(.c, (x1 + (check2*(sr/5)) * Cos(.a)) + r6 * Cos(.a + 90 * bj_DEGTORAD), (y1 + (check2*(sr/5)) * Sin(.a)) + r6 * Sin(.a + 90 * bj_DEGTORAD))
                            else
                                set .check = 0
                                call PosUnit(.c, (x1 + (check2*(sr/5)) * Cos(.a)) + r6 * Cos(.a - 90 * bj_DEGTORAD), (y1 + (check2*(sr/5)) * Sin(.a)) + r6 * Sin(.a - 90 * bj_DEGTORAD))
                            endif
                            
                            set r6 = r6 - 75
                            call VisionTimed(GetOwningPlayer(.c), GetUnitX(.c), GetUnitY(.c), 750, 2)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BDEF (208).mdx", GetUnitX(.c), GetUnitY(.c), GetRandomReal(0, 359), 0.5, 2, 15))
                            call EffectSpawn2("war3mapImported\\wos_yelshadowbuff3.mdx", GetUnitX(.c), GetUnitY(.c), GetRandomReal(0, 359), 2.5, 2, 1, 1.75)
                            
                            // 4. РРЎРџР РђР’Р›Р•РќРР• Р’РР—РЈРђР›Рђ: РЎРѕР·РґР°РµРј С‚РµРЅСЊ Рё РїРѕРІРѕСЂР°С‡РёРІР°РµРј РµС‘ РїСЂСЏРјРѕ РЅР° Р°РєС‚СѓР°Р»СЊРЅС‹Рµ РєРѕРѕСЂРґРёРЅР°С‚С‹ С†РµР»Рё
                            // Р’С‹СЃС‡РёС‚С‹РІР°РµРј СѓРіРѕР» РѕС‚ С‚РµРєСѓС‰РµР№ РїРѕР·РёС†РёРё РєР°СЃС‚РµСЂР° (.c) РґРѕ С‚РµРєСѓС‰РµР№ РїРѕР·РёС†РёРё С†РµР»Рё (.x, .y)
                            set .e = EffectSpawn("war3mapImported\\wos_Kyoraku.mdx", GetUnitX(.c), GetUnitY(.c), Atan2(.y - GetUnitY(.c), .x - GetUnitX(.c)) * bj_RADTODEG, 0.12, BlzGetUnitRealField(.c, UNIT_RF_SCALING_VALUE), 0)
                            
                            call ColorEffDummy3(.e, 1, 0, 0, 0, 0.9)
                            call ColorEffDummy4(.e, 0.1, 0, 0, 0, 0.5)
                            call BlzSetSpecialEffectAlpha(.e, 0)
                            call BlzPlaySpecialEffect(.e, ANIM_TYPE_WALK)
                            call BlzSetSpecialEffectTimeScale(.e, 1 + .r)
                            call AnimDummyEff(.e, 0.1, 0.05)
                            set .e = null                          
                            
                            // РЎР°РјРѕРіРѕ РіРµСЂРѕСЏ С‚РѕР¶Рµ СЂР°Р·РІРѕСЂР°С‡РёРІР°РµРј СЃРїРёРЅРѕР№/Р»РёС†РѕРј РѕС‚РЅРѕСЃРёС‚РµР»СЊРЅРѕ РЅРѕРІРѕРіРѕ СѓРіР»Р° С†РµР»Рё
                            call SetUnitFacing(.c, Atan2(.y - GetUnitY(.c), .x - GetUnitX(.c)) * bj_RADTODEG + 180)
                        endif
                        
                        if .r == 1.5 then
                            // Р—РґРµСЃСЊ С‚РѕР¶Рµ РёСЃРїСЂР°РІРёР» td РЅР° .td РґР»СЏ РЅР°РґРµР¶РЅРѕСЃС‚Рё РёРЅРєР°РїСЃСѓР»СЏС†РёРё СЃС‚СЂСѓРєС‚СѓСЂС‹
                            set .x = GetUnitX(.td)
                            set .y = GetUnitY(.td)
                            
                            // РџРѕСЃРєРѕР»СЊРєСѓ .a РѕР±РЅРѕРІРёР»СЃСЏ РІС‹С€Рµ, СѓРґР°СЂ С‚РѕР¶Рµ РїСЂРѕРёР·РѕР№РґРµС‚ СЃ РїСЂР°РІРёР»СЊРЅРѕР№ СЃС‚РѕСЂРѕРЅС‹!
                            call PosUnit(.c, .x + 135 * Cos(.a), .y + 135 * Sin(.a))
                            call SetUnitFacingTimed(.c, GAngle(.c, .td) * bj_RADTODEG, 0)
                            call EUTU2_3(EffectSpawn("war3mapImported\\wos_Satsu-WWSFX-1.mdx", .x, .y, .a * bj_RADTODEG, 0.75, 6., 75), 1.25, 75, .td)
                            call EUTU2_3(EffectSpawn("war3mapImported\\wos_acg_bbb.mdx", .x, .y, .a * bj_RADTODEG, 0.5, 2., 115), 1.46, 75, .td)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_HakkeStart.mdx", GetUnitX(.c), GetUnitY(.c), GetRandomReal(0, 359), 1.2, 0.25, 3))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BDEF (208).mdx", GetUnitX(.c), GetUnitY(.c), GetRandomReal(0, 359), 0.25, 2, 15))
                            
                            call ColorDummy4(.c, 0, 255, 255, 255, 0.3)
                            call SetUnitAnimationByIndex(.c, 16)
                            call SetUnitTimeScale(.c, 1.15)
                            set .e = AddSpecialEffectTarget("war3mapImported\\wos_supershinythingyhg25.mdx", .c, "hand left")
                            // call MakeSound("war3mapimported\\Hero_Kyoraku_R4")
                            
                            call StopSpellUnit(.c)
                            call DamageSource('A053')
                            call dmgphys(.c, .td, .dmg)
                            call SetUnitAnimation(.td, "death")
                            call StunUnit(.c, .td, KyorakuR_Stun)
                            call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_bloodex-special-23.mdl", .td, "chest"), 1.5)
                            set .r = 9999
                        endif
                    endif
                else
                    if .r < 3.9 then
                        call StopSpellUnit(.c)
                    endif
                    call DebuffClear(c)
                    call SetUnitVertexColor(.c, 255, 255, 255, 255)
                    call SetUnitTimeScale( .c , 1)
                    set .c = null
                    set .td = null
                    set .e = null
                    set m_KyorakuR[i] = m_KyorakuR[ MUI_KyorakuR]
                    set MUI_KyorakuR = MUI_KyorakuR - 1
                    set i = i - 1 // revisit: the moved instance must not skip this tick
                    if MUI_KyorakuR == -1 then
                        call KyorakuTick05_Off(0)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KyorakuR_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_KyorakuR = MUI_KyorakuR + 1
            set m_KyorakuR[ MUI_KyorakuR] = this
            set .c = NewC
            set .td = NewTd
            set .r = 0
            set .r2 = 0
            set .x = GetUnitX(.td)
            set .y = GetUnitY(.td)
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)
            set check2 = 0 
            set r6 = 500
            set .check = 0
            set .e = EffectSpawn("war3mapImported\\wos_Kyoraku.mdx", GetUnitX(.c), GetUnitY(.c), GetUnitFacing(.c), 0.12, BlzGetUnitRealField(.c, UNIT_RF_SCALING_VALUE), 0)
            call ColorEffDummy3(.e, 1, 255, 255, 255, 1)
            call BlzPlaySpecialEffect(.e, ANIM_TYPE_DEATH)
            set .e = null
            set .a = GAngle( .c , .td ) // Angle Between points
            if SR3(.c, .x, .y) < 600 then
                call PosUnit(.c, .x - 750 * Cos(.a), .y - 750 * Sin(.a))
            else
            endif
            set .x = GetUnitX(.c)
            set .y = GetUnitY(.c)
            call SetUnitVertexColor(.c, 0, 0, 0, 0)
            set .a = GAngle( .c , .td ) // Angle Between points
            set .dmg = GetHeroAgi( .c , true) * ( KyorakuR_DamageAgiBase + ( KyorakuR_DamageAgiStep * ( GetUnitAbilityLevel( .c , KyorakuR_ID) - 1 ) ) )
            set .rmax = 9.6
            call SetUnitAnimationByIndex( .c , 3)
            call SetUnitTimeScale( .c , 0.01)            
            call VisionTimed(GetOwningPlayer(.c), .x, .y, 750, 6)
            if MUI_KyorakuR == 0 then
                call KyorakuTick05_On(0)
            endif
        endmethod
    endstruct

    private struct KyorakuT4_KS
        private static integer array m_KyorakuT2
        private static integer MUI_KyorakuT2 = -1
        unit c
        unit td
        real x
        real y
        real dmg
        integer check
        real move
        real r
        effect e
        effect e2
        effect e3
        effect e4
        effect e5
        real a
        real rmax
        static method Loop_KyorakuT4 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KyorakuT2
                set this = m_KyorakuT2[i]
                if SpellBoolCaster(.c) and  SpellBoolCaster(.td) and  .r <= .rmax then
                    set .r = .r + 0.03
                    set .r = RoundReal(.r, 3)
                    if .r < 2.68 then
                        set .a = GAngle(.c, .td)
                        call SetUnitFacing(.c, .a * bj_RADTODEG)
                    endif
                    call DebugUnit(.c)
                    if .r >= 1.8 then
                        set .x = GetUnitX(.td)
                        set .y = GetUnitY(.td)
                        call DebugUnit(.td)
                    endif
                    if .r == 1.8 then
                        call MakeSound3("war3mapimported\\Hero_Kyoraku_T17")
                        call EMUE(EffectSpawn2("war3mapImported\\wos_whiteauralance.mdl", .x - 600 * Cos(0 * bj_DEGTORAD), .y - 600 * Sin(0 * bj_DEGTORAD), 0, 1, 2.5, 100, 1.25), 600, 1, 0 * bj_DEGTORAD)
                        call EMUE(EffectSpawn2("war3mapImported\\wos_whiteauralance.mdl", .x + 600 * Cos(0 * bj_DEGTORAD), .y + 600 * Sin(0 * bj_DEGTORAD), 0, 1, 2.5, 100, 1.25), 600, 1, 180 * bj_DEGTORAD)
                        set .e5 = EffectSpawn("war3mapimported\\wos_throatsilk.mdx", .x, .y, 1, 0.25, 3, 110)
                    endif
                    if .r == 2.7 then
                        call SetUnitAnimationByIndex( .c , 21)
                    call MakeSound3("war3mapimported\\Hero_Kyoraku_T16_3")
                    endif
                    if .r > 2.7 and .check == 0 then
                        call MoveUnit(.c, .move, .a)
                        if SR2(.c, .td) < 100 then
                            set .check = 1
                    call MakeSound3("war3mapimported\\Hero_Kyoraku_T16_5")
                            call MUE(.c, 700, 1.25, .a)
                            call DecorRemove(.c, .x, .y, 900, 100)
                    
                            set .e3 = AddSpecialEffectTarget("war3mapImported\\wos_whiteauralance_red.mdl", .c, "hand right")
                            set .e2 = EffectSpawnColor("war3mapImported\\wos_HakkeStartWhite.mdx", .x, .y, GetRandomReal(0, 359), 1, 2.5, 0, 255, 255, 255, 215)
                            call AnimDummyEff(.e2, 0.25, 0)
                            call ColorEffDummy3(.e2, 6.03 - .r, 255, 255, 255, 0.5)
                            set .x = .x - 15 * Cos(.a)
                            set .y = .y - 15 * Sin(.a)
                            set .e4 = EffectSpawnColor("war3mapImported\\wos_LXY_ZK_BM_flash_gai2red.mdl", .x - 00 * Cos(.a + bj_RADTODEG * 90), .y - 00 * Sin(.a + bj_RADTODEG * 90), .a * bj_RADTODEG, 0.5, 3.5, 120, 255, 15, 15, 255)
                            call AnimDummyEff(.e4, 1, 0)
                        endif
                    endif
                    if .r == 5.73 then
                    call MakeSound3("war3mapimported\\Hero_Kyoraku_T16_4")
                        call DestroyEffect(.e2)
                        if GetLocalPlayer() == GetOwningPlayer(.td) then
                            call CameraSetTargetNoise(30.0, 30.0)
                        endif
                        if GetLocalPlayer() == GetOwningPlayer(.c) then
                            call CameraSetTargetNoise(30.0, 30.0)
                        endif
                    endif
                    if .r == 6 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Satsu-WSFX-1_1.mdl", .x, .y, 0, 1, 1, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_Shockwave_b_red.mdl", .x, .y, 0, 1, 3, 110))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_bdef (124)2.mdl", .x, .y, 0, 1, 3, 110))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_a_[doft]hero_skeletonking_n2s_e_star.mdl", .x, .y, 0, 1, 3, 110))
                        call DecorRemove(.c, .x, .y, 900, 100)
                        call BlzSetSpecialEffectTimeScale(.e4, 2)
                        call DestroyEffect(.e4)
                        set r = rmax - 0.15
                    endif
                else
                    if GetLocalPlayer() == GetOwningPlayer(.td) then
                        call CameraSetTargetNoise(0.0, 0.0)
                    endif
                    if GetLocalPlayer() == GetOwningPlayer(.c) then
                        call CameraSetTargetNoise(0.0, 0.0)
                    endif
                    call StopSpellUnit(.c)
                    if .r > 1.8 then
                        call StopSpellUnit(.td)
                    endif
                    call DecorRemove(.c, .x, .y, 900, 100)
                    call MakeSound3("war3mapimported\\Hero_Kyoraku_T18")
                    call StunUnit(.c, .td, KyorakuT_DanFinal_Stun)
                    call DamageSource('A059')
                    call dmgphys(.c, .td, .dmg)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_fuxuan-21.mdl", .x, .y, 0, 1, 4.75, 150))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_order_dange_yueyun_3yellowlightclear.mdl", .x, .y, 0, 1, 1.75, 10))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_bloodex-special-23.mdl", .x, .y, 0, 1, 5, 10))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_1jinse_97.mdl", .x, .y, 0, 3.5, 3, 0))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_CrackWhitee.mdl", .x, .y, 0, 0.75, 1, 0))
                    call SaveInteger(hs, GetHandleId(.c), SH_LAST_DAN, 0)
                    call SaveInteger(hs, GetHandleId(.c), SH_BANKAI_END, 1)
                    call DestroyEffect(.e)
                    call DestroyEffect(.e2)
                    call DestroyEffect(.e3)
                    call DestroyEffect(.e5)
                    if .r < 14.25 then
                        call DestroyEffect(.e4)
                    endif
                    set .c = null
                    set .td = null
                    set .e = null
                    set .e2 = null
                    set .e3 = null
                    set .e4 = null
                    set .e5 = null
                    set m_KyorakuT2[i] = m_KyorakuT2[ MUI_KyorakuT2]
                    set MUI_KyorakuT2 = MUI_KyorakuT2 - 1
                    set i = i - 1 // revisit: the moved instance must not skip this tick
                    if MUI_KyorakuT2 == -1 then
                        call KyorakuTick_Off(7)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KyorakuT4_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_KyorakuT2 = MUI_KyorakuT2 + 1
            set m_KyorakuT2[ MUI_KyorakuT2] = this
            set .c = NewC
            set .td = NewTd
            set .r = 0
            set .x = GetUnitX(.td)
            set .y = GetUnitY(.td)
            set .check = 0
            set .move = 50
            call StartSpellUnit(.c)
            call StopSound(gg_snd_Hero_Kyoraku_T14__2, false, false)
            call MakeSound3("war3mapimported\\Hero_Kyoraku_T16_1")
            call MakeSound3("war3mapimported\\Hero_Kyoraku_T16_2")
            call SaveInteger(hs, GetHandleId(.c), SH_LAST_DAN, 1)
            set .e = AddSpecialEffectTarget("war3mapImported\\wos_whiteauralance_white.mdl", .c, "hand right")
            set .a = GAngle( .c , .td ) // Angle Between points
            set .dmg = GetHeroAgi( .c , true) * KyorakuT_DanFinal_Dmg
            set .rmax = 14.4
            call SetUnitAnimationByIndex( .c , 20)
            call SetUnitTimeScale( .c , 0.25)
            if MUI_KyorakuT2 == 0 then
                call KyorakuTick_On(7)
            endif
        endmethod
    endstruct

    private struct KyorakuT_KS
        private static integer array m_KyorakuT
        private static integer MUI_KyorakuT = -1
        unit c
        real x
        real y
        real r2
        integer k
        integer k2
        integer k3
        real r3
        real r4
        real r5
        real r7
        group g
        group g2
        unit u
        real dmg
        real dmg2
        integer check
        integer check3
        real aoe
        real r
        effect array ee[100]
        effect e
        effect e2
        effect e3
        effect e4
        effect e5
        effect e6
        effect e8
        real a
        real rmax
        static method Loop_KyorakuT takes nothing returns nothing
            local integer this
            local integer i = 0
            local real drain = 0
            local integer transparent = 85
            local real rand1 = 0
            local real rand2 = 0
            local real rand3 = 0
            local real rand4 = 0
            local real rr2
            local real xxx 
            local real yyy
            local real preparetime = 9.99
            local real ok = 0
            loop
                exitwhen i > MUI_KyorakuT
                set this = m_KyorakuT[i]
                if SpellBoolCaster(.c) and IsUnitType(c,UNIT_TYPE_DEAD)== false and .r <= .rmax and LoadInteger(hs, GetHandleId(.c), SH_INSTANT_END) == 0 and CheckCoordsInRect(gg_rct_Base,GetUnitX(c),GetUnitY(c)) == false then
                    if LoadInteger(hs, GetHandleId(.c), SH_LAST_DAN) == 0 then
                        set .r = .r + 0.03
                        set .r = RoundReal(.r, 3)
                    else
                        if .check3 == 0 then
                            set .check3 = 1
                            call ColorEffDummy3(.e8, 0, 255, 255, 255, 0.5)
                            call KyorakuBankaiHelp(.c, k2, KyorakuT4_ID)
                        endif
                    endif
                    if LoadInteger(hs, GetHandleId(.c), SH_BANKAI_END) == 1 then
                        call SaveInteger(hs, GetHandleId(.c), SH_BANKAI_END, 0)
                        set .r = .rmax - 0.1
                    endif
                    call SetTimeOfDay(0)
                    if .check > 0 or .r >= KyorakuT_BuffDelay then 
                    if r7>0.12 then 
                    set r7 = 0
                    call GroupClear(.g)
                             call GroupEnumUnitsInRange(.g,GetUnitX(c),GetUnitY(c),KyorakuT_DamageAoe, null)
                            loop
                                set .u = FirstOfGroup(.g)
                                exitwhen .u == null
                                if true then
                                call BuffUnitKyoraku(u,u,1)
                                endif
                                call GroupRemoveUnit(.g, .u)
                            endloop
                    else
                    set r7 = r7 + 0.03
                    endif
                    endif
                    if .check == 0 then
                        if .r > 3.75 then
                            if preparetime - .r >= 0 then
                                call KyorakuBankaiProgress(.c, .check, preparetime - .r, preparetime - 3.75)
                            endif
                        endif
                        if .r < 3.69 then
                            call DebugUnit(.c)
                        endif
                        if .r == 0.66 then
                            call MakeSound3("war3mapimported\\Hero_Kyoraku_T2")
                        elseif .r == 0.9 then
                            set .e3 = EffectSpawn("war3mapimported\\wos_KyorBanka.mdx", .x, .y, GetRandomReal(0, 359), 0.45, 5.5, 0)
                            call AnimDummyEff(.e3, 0.8, 0)
                            set .e4 = EffectSpawn("war3mapimported\\wos_BankaKupol.mdx", .x, .y, GetRandomReal(0, 359), 0.6, 13, 355)
                            call AnimDummyEff(.e4, 0.8, 0)
                            call ColorEffDummy32(.e3, 0.8, 255, 255, 255, 0.6)
                            call ColorEffDummy3(.e4, 0.8, 255, 255, 255, 0.6)
                        elseif .r == 1.5 then
                            call MakeSound3("war3mapimported\\Hero_Kyoraku_T3")
                        elseif .r == 1.59 then
                            set .e = EffectSpawn("war3mapImported\\wos_HakkeStart.mdx", .x, .y, GetRandomReal(0, 359), 1, 1.2, 3)
                            call BlzSetSpecialEffectAlpha(.e, 0)
                            call AnimDummyEff(.e, 0.25, 0)
                            call ColorEffDummy4(.e, 0, 255, 255, 255, 0.25)
                            call ColorEffDummy3(.e, 2.1, 255, 255, 255, 0.5)
                            set .e = null
                            set .e2 = EffectSpawnColor("war3mapImported\\wos_HakkeStartWhite.mdx", .x, .y, GetRandomReal(0, 359), 1, 5.1, 0, 255, 255, 255, 145)
                            call BlzSetSpecialEffectAlpha(.e2, 0)
                            call AnimDummyEff(.e2, 0.25, 0)
                            call ColorEffDummy4(.e2, 0, 255, 255, 255, 0.5)
                            call ColorEffDummy3(.e2, 1.5, 255, 255, 255, 0.5)
                            set .e8 = EffectSpawnColor("war3mapImported\\wos_cd (706).mdx", .x, .y, GetUnitFacing(.c), 0.15, 0.55, 35, 0, 0, 0, 255)
                            call ColorEffDummy4(.e8, 0, 0, 0, 0, 1.5)
                            call ColorEffDummy3(.e8, 2.5, 0, 0, 0, 2.5)
                        elseif .r == 2.1 then
                            set .e = EffectSpawnColor("war3mapImported\\wos_aban23.mdx", .x, .y, 90, 0.75, 3, 35, 0, 0, 0, 255)
                            set .e6 = EffectSpawn("war3mapImported\\wos_aban23.mdx", .x, .y, 90, 0.75, 2.8, 25)
                            call ColorEffDummy3(.e, 1.5, 0, 0, 0, 1.8)
                            call ColorEffDummy3(.e6, 1.5, 255, 255, 255, 1.8)
                            call MakeSound3("war3mapimported\\Hero_Kyoraku_T4")
                            set .k3 = 0
                        elseif .r == 3 then
                            call ColorEffDummy4(.e3, 0, 255, 255, 255, 0.5)
                            call ColorEffDummy3(.e3, 0.6, 255, 255, 255, 1.8)
                        endif
                        if .r == 3.75 then
                            call SaveInteger(hs, GetHandleId(.c), SH_KYORAKU_BANKAI, 1)
                            call StopSpellUnit(.c)
                            call MakeSound3("war3mapimported\\Hero_Kyoraku_T5")
                            if frame_KyorBankai12[k2] == null then
                                set frame_KyorBankai12[k2] = WUI_Window("WOSKyorakuHelp", main_frame, 0, 0)
                                // Checkpoint 24: right-column panel under the top-right menu,
                                // collapsible with its own header (like TEST COMMANDS).
                                call WUI_RegisterColumnPanel(frame_KyorBankai12[k2], "BANKAI STAGES", 0.035)
                                call WUI_ColumnShow(frame_KyorBankai12[k2], true)


                                call KyorakuBankaiProgress(.c, .check, preparetime - .r, preparetime - 3.75)

                                call WUI_RefreshDocks()
                                set frame_KyorBankai7[k2] = BlzCreateFrameByType("TEXT", "WOSKyorakuHelpText", frame_KyorBankai12[k2], "", 0)
                                call BlzFrameSetPoint(frame_KyorBankai7[k2], FRAMEPOINT_TOP, frame_KyorBankai12[k2], FRAMEPOINT_TOP, 0.000, -0.008)
                                call BlzFrameSetSize(frame_KyorBankai7[k2], 0.164, 0.00)
                                call BlzFrameSetFont(frame_KyorBankai7[k2], "Fonts\\FRIZQT__.TTF", 0.0105, 0)
                                call BlzFrameSetTextAlignment(frame_KyorBankai7[k2], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
                                call BlzFrameSetEnable(frame_KyorBankai7[k2], false)
                                // The old open/close icons are replaced by the column header.
                                set xxx = -1.00
                                set yyy = -1.00
        set frame_KyorBankai8[k2] = BlzCreateFrameByType("BUTTON", "MyIconButton", main_frame, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetAbsPoint(frame_KyorBankai8[k2],FRAMEPOINT_CENTER, xxx,yyy )// - 0.03 * i)
        call BlzFrameSetSize(frame_KyorBankai8[k2], 0.02, 0.02)
        set frame_KyorBankai9[k2] = BlzCreateFrameByType("BUTTON", "MyIconButton", main_frame, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetAbsPoint(frame_KyorBankai9[k2],FRAMEPOINT_CENTER, xxx,yyy )// - 0.03 * i)
        call BlzFrameSetSize(frame_KyorBankai9[k2], 0.02, 0.02)
        call BlzFrameSetVisible(frame_KyorBankai9[k2],false)
        set frame_KyorBankai10[k2] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", frame_KyorBankai8[k2], "", 0)
        call BlzFrameSetAllPoints(frame_KyorBankai10[k2], frame_KyorBankai8[k2])
        call BlzFrameSetSize(frame_KyorBankai10[k2], 0.03, 0.03)
        call BlzFrameSetTexture(frame_KyorBankai10[k2], "WOS\\DiscordIcon2", 0, true)
        set frame_KyorBankai11[k2] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", frame_KyorBankai9[k2], "", 0)
        call BlzFrameSetAllPoints(frame_KyorBankai11[k2], frame_KyorBankai9[k2])
        call BlzFrameSetVisible(frame_KyorBankai11[k2],false)
        call BlzFrameSetSize(frame_KyorBankai11[k2], 0.03, 0.03)
        call BlzFrameSetTexture(frame_KyorBankai11[k2], "WOS\\Scroll", 0, true)
        call BlzTriggerRegisterFrameEvent(Frame_clickKyoraku, frame_KyorBankai8[k2], FRAMEEVENT_CONTROL_CLICK)
        call BlzTriggerRegisterFrameEvent(Frame_clickKyoraku, frame_KyorBankai9[k2], FRAMEEVENT_CONTROL_CLICK)
                                call KyorakuBankaiHelp(.c, k2, KyorakuT0_ID)
                            else
                                call KyorakuBankaiHelp(.c, k2, KyorakuT0_ID)
                                set k = 0
                                loop
                                exitwhen k == 10                                        
                                if GetLocalPlayer() == Player(k) then 
                                endif
                                if LoadInteger(hs,GetHandleId(Player(k)),SH_DESC_T_OFF)== 0 then 
                                if GetLocalPlayer() == Player(k) then 
                                call WUI_ColumnShow(frame_KyorBankai12[k2], true)
                                call BlzFrameSetVisible(frame_KyorBankai8[k2],true)
                                call BlzFrameSetVisible(frame_KyorBankai10[k2],true)
                                call BlzFrameSetVisible(frame_KyorBankai9[k2],false)
                                call BlzFrameSetVisible(frame_KyorBankai11[k2],false)
                                endif
                                else
                                if GetLocalPlayer() == Player(k) then 
                                call WUI_ColumnShow(frame_KyorBankai12[k2], false)
                                call BlzFrameSetVisible(frame_KyorBankai8[k2],false)
                                call BlzFrameSetVisible(frame_KyorBankai10[k2],false)
                                call BlzFrameSetVisible(frame_KyorBankai9[k2],true)
                                call BlzFrameSetVisible(frame_KyorBankai11[k2],true)
                                endif
                                
                                endif
                                set k = k + 1
                                endloop
                                call KyorakuBankaiProgress(.c, .check, preparetime - .r, preparetime - 3.75)
                            endif
                        endif
                        if .r == 7.74 then
                            call StartSound(gg_snd_Hero_Kyoraku_T6)
                            call ColorEffDummy3(.e3, 0, 255, 255, 255, 8.8)
                        endif
                        if .r == preparetime then
                            set .check = 0
                            set .r = 999999999
                        endif
                        if .r == 3.69 then
                            call GroupClear(.g)
                            call GroupEnumUnitsInRect(.g, gg_rct_Arena, null)
                            loop
                                set .u = FirstOfGroup(.g)
                                exitwhen .u == null
                                if IsUnitEnemy(.u, GetOwningPlayer(.c)) and IsUnitInGroup(.u, .g2) == false and IsUnitIllusion(.u) == false and IsUnitType(.u, UNIT_TYPE_HERO) then
                                    call GroupAddUnit(.g2, .u)
                                endif
                                call GroupRemoveUnit(.g, .u)
                            endloop
                            call GroupClear(.g)
                            if FirstOfGroup(.g2) == null then
                                set .r = 99999
                            endif
                        endif
                    elseif .check == 1 then
                        if 5.49 - .r >= 0 then
                            call KyorakuBankaiProgress(.c, .check, 5.49 - .r, 5.49)
                        endif
                        if LoadInteger(hs, GetHandleId(.c), SH_INSTANT_SKIP) == 1 then 
                        call SaveInteger(hs, GetHandleId(.c), SH_INSTANT_SKIP,0)
                        set r = 5.49
                        endif
                        if .r == 5.49 then
                            set .r = 0
                            set .check = 2
                    //call SetPlayerAbilityAvailable(GetOwningPlayer(.c),KyorakuT2_ID,true)
                    //call SetPlayerAbilityAvailable(GetOwningPlayer(.c),KyorakuT1_ID,false)
                            call GroupClear(.g)
                            call GroupEnumUnitsInRect(.g, gg_rct_Arena, null)
                            loop
                                set .u = FirstOfGroup(.g)
                                exitwhen .u == null
                                if GetUnitAbilityLevel(u,KyorakuT_BankaiBuff)>0 then
                                    call UnitRemoveAbility(u,KyorakuT_BankaiBuff)
                                endif
                                call GroupRemoveUnit(.g, .u)
                            endloop
                            call GroupClear(.g)
                            call UnitRemoveAbility(c,KyorakuTSkip_ID)
                            call KyorakuBankaiHelp(.c, k2, KyorakuT2_ID)
                            call KyorakuBankaiProgress(.c, .check, 7.02 - .r, 7.02)
                            set .k3 = 0
                            call MakeSound3("war3mapimported\\Hero_Kyoraku_T9")
                            set .k = 0
                            loop
                                exitwhen .k > 10
                                if Hero[k] != null and LoadInteger(hs, GetHandleId(Hero[k]), SH_BANKAI_1_ST_ACTIVATED) > 0 then
                                    set .k3 = .k3 + 1
                                    call SaveEffectHandle(hs, GetHandleId(Hero[k]), GearKey(GEAR_KEY_2ND_DAN, "2-nd dan", .k2), AddSpecialEffectTarget("war3mapimported\\wos_dan2.mdx", Hero[k], "chest"))
                                endif
                                set .k = .k + 1
                            endloop
                            call SetHpCurrent2(c,c, GetUnitState(.c, UNIT_STATE_MAX_LIFE) * (.k3 * (KyorakuT_Dan2_KyorakuSelfHealEnter / 100)))
                        endif
                    elseif .check == 2 then
                    set rr2 = 6.99
                        if rr2 - .r >= 0 then
                            call KyorakuBankaiProgress(.c, .check, rr2 - .r, rr2)
                        endif
                        if LoadInteger(hs, GetHandleId(.c), SH_INSTANT_SKIP) == 1 then 
                        call SaveInteger(hs, GetHandleId(.c), SH_INSTANT_SKIP,0)
                        set r = rr2
                        endif
                        if .r == rr2 then
                            set .r = 0
                            set .check = 3
                            call KyorakuBankaiProgress(.c, .check, .rmax - .r, .rmax)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT4_ID, true)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(.c),KyorakuTSkip_ID,false)
                            call OkarunEggCd(c,KyorakuT4_ID,KyorakuT_DanFinal_BaseCd)
                    //call SetPlayerAbilityAvailable(GetOwningPlayer(.c),KyorakuT3_ID,true)
                            call KyorakuBankaiHelp(.c, k2, KyorakuT3_ID)
                    //        call SetPlayerAbilityAvailable(GetOwningPlayer(.c),KyorakuT2_ID,false)
                            //call MakeSound3("war3mapimported\\Hero_Kyoraku_T10")
                            call StartSound(gg_snd_Hero_Kyoraku_T14__2)
                            call MakeSound3("war3mapimported\\Hero_Kyoraku_T11")
                            set .k = 0
                            loop
                                exitwhen .k > 10
                                if Hero[k] != null then
                                    call CinematicFilterGenericBJ( 2, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100, 100, 100, 0, 100, 100, 100, 100 )
                                endif
                                set .k = .k + 1
                            endloop
                            set .k = 0
                            set .k3 = 58
                            loop
                                exitwhen .k > 9
                                set .ee[k] = EffectSpawnColor("war3mapimported\\wos_waterplane.mdx", GetRectCenterX(gg_rct_LL) + (.k * 1000) * Cos(0), GetRectCenterY(gg_rct_LL) + (.k * 1000) * Sin(0), 0, 1, 4, 1000, 255, 255, 255, .k3)
                                set .ee[.k + 10] = EffectSpawnColor("war3mapimported\\wos_waterplane.mdx", (GetRectCenterX(gg_rct_LL) + 1000 * Cos(90 * bj_DEGTORAD)) + (.k * 1000) * Cos(0), (GetRectCenterY(gg_rct_LL) + 1000 * Sin(90 * bj_DEGTORAD)) + (.k * 1000) * Sin(0), 0, 1, 4, 1000, 255, 255, 255, .k3)
                                set .ee[.k + 20] = EffectSpawnColor("war3mapimported\\wos_waterplane.mdx", (GetRectCenterX(gg_rct_LL) + 2000 * Cos(90 * bj_DEGTORAD)) + (.k * 1000) * Cos(0), (GetRectCenterY(gg_rct_LL) + 2000 * Sin(90 * bj_DEGTORAD)) + (.k * 1000) * Sin(0), 0, 1, 4, 1000, 255, 255, 255, .k3)
                                set .ee[.k + 30] = EffectSpawnColor("war3mapimported\\wos_waterplane.mdx", (GetRectCenterX(gg_rct_LL) + 3000 * Cos(90 * bj_DEGTORAD)) + (.k * 1000) * Cos(0), (GetRectCenterY(gg_rct_LL) + 3000 * Sin(90 * bj_DEGTORAD)) + (.k * 1000) * Sin(0), 0, 1, 4, 1000, 255, 255, 255, .k3)
                                set .ee[.k + 40] = EffectSpawnColor("war3mapimported\\wos_waterplane.mdx", (GetRectCenterX(gg_rct_LL) + 4000 * Cos(90 * bj_DEGTORAD)) + (.k * 1000) * Cos(0), (GetRectCenterY(gg_rct_LL) + 4000 * Sin(90 * bj_DEGTORAD)) + (.k * 1000) * Sin(0), 0, 1, 4, 1000, 255, 255, 255, .k3)
                                set .ee[.k + 50] = EffectSpawnColor("war3mapimported\\wos_waterplane.mdx", (GetRectCenterX(gg_rct_LL) + 5000 * Cos(90 * bj_DEGTORAD)) + (.k * 1000) * Cos(0), (GetRectCenterY(gg_rct_LL) + 5000 * Sin(90 * bj_DEGTORAD)) + (.k * 1000) * Sin(0), 0, 1, 4, 1000, 255, 255, 255, .k3)
                                set .ee[.k + 60] = EffectSpawnColor("war3mapimported\\wos_waterplane.mdx", (GetRectCenterX(gg_rct_LL) + 6000 * Cos(90 * bj_DEGTORAD)) + (.k * 1000) * Cos(0), (GetRectCenterY(gg_rct_LL) + 6000 * Sin(90 * bj_DEGTORAD)) + (.k * 1000) * Sin(0), 0, 1, 4, 1000, 255, 255, 255, .k3)
                                set .ee[.k + 70] = EffectSpawnColor("war3mapimported\\wos_waterplane.mdx", (GetRectCenterX(gg_rct_LL) + 7000 * Cos(90 * bj_DEGTORAD)) + (.k * 1000) * Cos(0), (GetRectCenterY(gg_rct_LL) + 7000 * Sin(90 * bj_DEGTORAD)) + (.k * 1000) * Sin(0), 0, 1, 4, 1000, 255, 255, 255, .k3)
                                set .ee[.k + 80] = EffectSpawnColor("war3mapimported\\wos_waterplane.mdx", (GetRectCenterX(gg_rct_LL) + 8000 * Cos(90 * bj_DEGTORAD)) + (.k * 1000) * Cos(0), (GetRectCenterY(gg_rct_LL) + 8000 * Sin(90 * bj_DEGTORAD)) + (.k * 1000) * Sin(0), 0, 1, 4, 1000, 255, 255, 255, .k3)
                                set .ee[.k + 90] = EffectSpawnColor("war3mapimported\\wos_waterplane.mdx", (GetRectCenterX(gg_rct_LL) + 9000 * Cos(90 * bj_DEGTORAD)) + (.k * 1000) * Cos(0), (GetRectCenterY(gg_rct_LL) + 9000 * Sin(90 * bj_DEGTORAD)) + (.k * 1000) * Sin(0), 0, 1, 4, 1000, 255, 255, 255, .k3)
                                set .k = .k + 1
                            endloop
                        endif
                    elseif .check == 3 then
                        if .rmax - .r >= 0 then
                            call KyorakuBankaiProgress(.c, .check, .rmax - .r, .rmax)
                        endif
                        if .r == 0.3 then
                            set .e8 = EffectSpawnColor("war3mapImported\\wos_cd (706).mdx", .x, .y, GetUnitFacing(.c), 1, 0.45, 42, 255, 255, 255, 255)
                            call AnimDummyEff(.e8, 3.5, 0)
                            set .k3 = 0
                            call BlzSetSpecialEffectAlpha(.e8, .k3)
                            call BlzPlaySpecialEffect(.e8, ANIM_TYPE_ATTACK)
                            call BlzSetSpecialEffectPitch(.e8, -330 * bj_DEGTORAD)
                        endif
                        if .r > 0.3 then
                            set .a = GetUnitFacing(.c) * bj_DEGTORAD
                            if .check3 == 0 then
                                if .k3 < 255 then
                                    set .k3 = .k3 + 3
                                    call BlzSetSpecialEffectAlpha(.e8, .k3)
                                endif
                                call BlzSetSpecialEffectPosition(.e8, (GetUnitX(.c) - 15 * Cos(.a + 90 * bj_DEGTORAD)) - 22 * Cos(.a), (GetUnitY(.c) - 15 * Sin(.a + 90 * bj_DEGTORAD)) - 22 * Sin(.a), BlzGetUnitZ(.c) + 42)
                                call BlzSetSpecialEffectYaw(.e8, .a)
                            endif
                        endif
                        set .k = 0
                        loop
                            exitwhen .k > 10
                            if Hero[k] != null and GetWidgetLife(Hero[k]) > 1 and SR2(Hero[k],c)<=KyorakuT_DamageAoe  then
                                set rand1 = LoadReal(hs, GetHandleId(Hero[k]), SH_CUR_MANA)
                                if rand1 == 0 then
                                    set rand1 = GetUnitState(Hero[k], UNIT_STATE_MANA)
                                endif
                                if GetUnitState(Hero[k], UNIT_STATE_MANA) > rand1 then
                                    call SetUnitState(Hero[k], UNIT_STATE_MANA, rand1)
                                else
                                    set rand1 = GetUnitState(Hero[k], UNIT_STATE_MANA)
                                endif
                                if rand1 < 1 then
                                    set rand1 = 1
                                endif
                                call SaveReal(hs, GetHandleId(Hero[k]), SH_CUR_MANA, rand1)
                            endif
                            set .k = .k + 1
                        endloop
                        if .r5 > 1.75 then
                            set .r5 = 0
                            set ok = 1 
                            if LoadInteger(hs, GetHandleId(.c), SH_LAST_DAN) == 1 then 
                            set ok = 1
                            endif
                            call GroupClear(.g)
                            call GroupEnumUnitsInRange(.g,GetUnitX(c),GetUnitY(c),KyorakuT_DamageAoe, null)
                            loop
                                set .u = FirstOfGroup(.g)
                                exitwhen .u == null
                                if IsUnitIllusion(.u) == false and IsUnitType(.u, UNIT_TYPE_HERO) then
                                    set drain = (KyorakuT_Dan3_ManaBurn / 100) * GetUnitState(.u, UNIT_STATE_MAX_MANA)
                                    if c == u then 
                                set drain = 1*drain
                                endif
                                call SetUnitState(.u, UNIT_STATE_MANA, GetUnitState(.u, UNIT_STATE_MANA) - drain)
                                    set ok = 0.5
                                    if (GetUnitState(.u, UNIT_STATE_MANA)/GetUnitState(.u, UNIT_STATE_MAX_MANA)) <= 0.5 then
                                        set ok = 1
                                    endif
                                     if IsUnitAlly(u,GetOwningPlayer(c)) then 
                                     set ok = ok*1
                                     endif
                                    call DamageSource('A054')
                                    call dmgmag(.c, .u, .dmg2*ok)
                                        
                                endif
                                call GroupRemoveUnit(.g, .u)
                            endloop
                        else
                            set .r5 = .r5 + 0.03
                        endif
                        if .r4 > 0.18 then
                            set .r4 = 0
                            set .k = 0
                            loop
                                exitwhen .k > 10
                                set rand1 = GetRandomReal(100, 800)
                                set rand2 = GetRandomReal(0, 359) * bj_DEGTORAD
                                if .r < .rmax - 1 and Hero[k] != null and GetUnitState(Hero[k], UNIT_STATE_LIFE) > 1 then
                                    set rand1 = GetRandomReal(150, 700)
                                    set rand2 = GetRandomReal(0, 359) * bj_DEGTORAD
                                    call EffectSpawn2("war3mapImported\\wos_Bubbles2.mdx", GetUnitX(Hero[k]) + rand1 * Cos(rand2) , GetUnitY(Hero[k]) + rand1 * Sin(rand2), GetRandomReal(0, 359), 1, 4, GetRandomReal(50, 150), 0.6)
                                    set rand1 = GetRandomReal(600, 1600)
                                    set rand2 = GetRandomReal(0, 359) * bj_DEGTORAD
                                    call EffectSpawn2("war3mapImported\\wos_Bubbles2.mdx", GetUnitX(Hero[k]) + rand1 * Cos(rand2) , GetUnitY(Hero[k]) + rand1 * Sin(rand2), GetRandomReal(0, 359), 1, 4, GetRandomReal(50, 150), 0.6)
                                endif
                                set .k = .k + 1
                            endloop
                        else
                            set .r4 = .r4 + 0.03
                        endif
                        if .r == 2.4 then
                         //   call MakeSound3("war3mapimported\\Hero_Kyoraku_T11")
                        endif
                        if .r == 2.91 then
                         //   call MakeSound3("war3mapimported\\Hero_Kyoraku_T12")
                        endif
                        if .r == 4.71 then
                         //   call MakeSound3("war3mapimported\\Hero_Kyoraku_T13")
                        endif
                        if .r == 12 then
                         //   call StartSound(gg_snd_Hero_Kyoraku_T14__2)
                        endif
                    endif
                    if .check >= 2 then
                        if .r3 >= 2.7 then
                        set ok = 1 
                            if LoadInteger(hs, GetHandleId(.c), SH_LAST_DAN) == 1 then 
                            //set ok = 0.5
                            endif
                            set .r3 = 0
                            set .k = 0
                            loop
                                exitwhen .k > 10
                                if Hero[k] != null and LoadInteger(hs, GetHandleId(Hero[k]), SH_BANKAI_1_ST_ACTIVATED) > 0 and SR2(c,Hero[k])<= KyorakuT_DamageAoe then
                                    if IsUnitAlly(u,GetOwningPlayer(c)) then 
                                     set ok = ok*1
                                     else
                                      set ok = 1
                                    endif
                                    call DamageSource('A054')
                                    call dmgphys(.c, Hero[k], .dmg*ok)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", Hero[k], "chest"))
                                endif
                                set .k = .k + 1
                            endloop
                        else
                            set .r3 = .r3 + 0.03
                        endif
                    endif
                    if (.r > 3.75 and .check == 0) or .check == 1 then
                        if .r2 > 0.45 then
                            set .r2 = 0
                            if .check == 0 then
                                set .k = 0
                                set .k3 = 0
                                loop
                                    exitwhen .k > 10
                                    if Hero[k] != null and LoadInteger(hs, GetHandleId(Hero[k]), SH_BANKAI_1_ST_ACTIVATED) > 0 then
                                        set .k3 = 1
                           // call BJDebugMsg(I2S(.k))
                                    endif
                                    set .k = .k + 1
                                endloop
                                if .k3 == 1 then
                                    set .k3 = 0
                                    set .check = 1
                                    set .r = 0
                            call SetPlayerAbilityAvailable(GetOwningPlayer(.c),KyorakuTSkip_ID,true)
                            call UnitAddAbility(c,KyorakuTSkip_ID)
                            //call SetPlayerAbilityAvailable(GetOwningPlayer(.c),KyorakuT0_ID,false)
                                    call KyorakuBankaiHelp(.c, k2, KyorakuT1_ID)
                                    call KyorakuBankaiProgress(.c, .check, 5.49 - .r, 5.49)
                                    call StopSound(gg_snd_Hero_Kyoraku_T6, false, false)
                                    call MakeSound3("war3mapimported\\Hero_Kyoraku_T7")
                                endif
                            endif
                            call GroupEnumUnitsInRange(.g,GetUnitX(c),GetUnitY(c),KyorakuT_DamageAoe, null)
                            loop
                                set .u = FirstOfGroup(.g)
                                exitwhen .u == null
                                if .check < 2 then
                                    call CurseUnit(.c, .u, 2)
                                endif
                                call GroupRemoveUnit(.g, .u)
                            endloop
                        else
                            set .r2 = .r2 + 0.03
                        endif
                    endif
                else
                    if GetUnitCurrentOrder(c) == OrderId("impale") then 
                    call IssueImmediateOrder(c,"stop")
                    endif
                    call SetTimeOfDay(12)
                    if .r < 3.75 then
                        call ColorEffDummy3(.e8, 0, 0, 0, 0, 0.6)
                    endif
                    call CinematicFilterGenericBJ( 2, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100, 100, 100, 0, 100, 100, 100, 100 )
                    set .k = 0
                    loop
                        exitwhen .k > 99
                        if .ee[k] != null then
                            call ColorEffDummy3(.ee[k], 0, 255, 255, 255, 0.5)
                            set .ee[k] = null
                        endif
                        set .k = .k + 1
                    endloop
                    set .k = 0
                    loop
                        exitwhen .k > 10
                        if Hero[k] != null then
                            call SaveReal(hs, GetHandleId(Hero[k]), SH_CUR_MANA, 0)
                            call DestroyEffect(LoadEffectHandle(hs, GetHandleId(Hero[k]), GearKey(GEAR_KEY_2ND_DAN, "2-nd dan", .k2)))
                            call RemoveSavedHandle(hs, GetHandleId(Hero[k]), GearKey(GEAR_KEY_2ND_DAN, "2-nd dan", .k2))
                            call SaveInteger(hs, GetHandleId(Hero[k]), SH_BANKAI_1_ST_ACTIVATED, 0)
                            call RemoveSavedInteger(hs, GetHandleId(Hero[k]), SH_BANKAI_1_ST_ACTIVATED)
                        endif
                        set .k = .k + 1
                    endloop                            
                    call KyorakuBankaiProgress(.c, .check, 0.00, 0.00)
                    call WUI_ColumnShow(frame_KyorBankai12[k2], false)
                    call BlzFrameSetVisible(frame_KyorBankai8[k2], false)
                    call BlzFrameSetVisible(frame_KyorBankai9[k2], false)
                    call BlzFrameSetVisible(frame_KyorBankai10[k2], false)
                    call BlzFrameSetVisible(frame_KyorBankai11[k2], false)
                    call StopSound(gg_snd_Hero_Kyoraku_T6, false, false)
                    if r <=16.1 then 
                    call StopSound(gg_snd_Hero_Kyoraku_T14__2, false, false)
                    endif
                    call SaveInteger(hs, GetHandleId(.c), SH_INSTANT_SKIP,0)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuTSkip_ID, false)
                    call UnitRemoveAbility(.c, KyorakuTSkip_ID)
                    set KyorakuBankaiStage[k2] = 0
                    call ColorEffDummy3(.e, 0, 255, 255, 255, 0.5)
                    call ColorEffDummy3(.e2, 0, 255, 255, 255, 0.5)
                    call ColorEffDummy3(.e3, 0, 255, 255, 255, 0.5)
                    call ColorEffDummy3(.e4, 0, 255, 255, 255, 0.5)
                    call ColorEffDummy3(.e5, 0, 255, 255, 255, 0.5)
                    call ColorEffDummy3(.e6, 0, 255, 255, 255, 0.5)
                    if .check < 3 then
                        call StopSpellUnit(.c)
                    else
                        call ColorEffDummy3(.e8, 0, 255, 255, 255, 0.5)
                    endif
                    call SaveInteger(hs, GetHandleId(.c), SH_LAST_DAN, 0)
                    call SaveInteger(hs, GetHandleId(.c), SH_BANKAI_END, 0)
                    call SaveInteger(hs, GetHandleId(.c), SH_INSTANT_END, 0)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT0_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT1_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT3_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT4_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT5_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT_ID, true)
                    call DestroyGroup(.g)
                    call DestroyGroup(.g2)
                    set BankaiActive = false
                    set .c = null
                    set .e = null
                    set .e2 = null
                    set .e3 = null
                    set .e4 = null
                    set .e5 = null
                    set .e6 = null
                    set .e8 = null
                    set .g = null
                    set .g2 = null
                    set m_KyorakuT[i] = m_KyorakuT[ MUI_KyorakuT]
                    set MUI_KyorakuT = MUI_KyorakuT - 1
                    set i = i - 1 // revisit: the moved instance must not skip this tick
                    if MUI_KyorakuT == -1 then
                        call KyorakuTick_Off(8)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KyorakuT_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_KyorakuT = MUI_KyorakuT + 1
            set m_KyorakuT[ MUI_KyorakuT] = this
            set .c = NewC
            set .r = 0
            set .r2 = 10
            set .r3 = 0
            set .r4 = 0
            set .check = 0
            set .check3 = 0
            set .x = GetUnitX(.c)
            set .k2 = GetPlayerId(GetOwningPlayer(.c))
            set .k = 0
            set .k3 = 0
            set .y = GetUnitY(.c)
            set .g = CreateGroup()
            set .g2 = CreateGroup()
            call StartSpellUnit(.c)
            call DebuffClear(c)
            call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuTSkip_ID, false)
            call UnitRemoveAbility(.c, KyorakuTSkip_ID)
            call SaveInteger(hs, GetHandleId(.c), SH_INSTANT_SKIP, 0)
            set BankaiActive = true
            set KyorakuBankaiCaster = .c
            call SetUnitFacing(.c, 270)
            call SaveInteger(hs, GetHandleId(.c), SH_BANKAI_END, 0)
                        call SaveInteger(hs, GetHandleId(.c), SH_LAST_DAN, 0)
                        call SaveInteger(hs, GetHandleId(.c), SH_INSTANT_END, 0)
            call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT5_ID, true)
            call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT0_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT1_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT2_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT3_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(.c), KyorakuT4_ID, false)
            call UnitAddAbility(.c, KyorakuT0_ID)
            call UnitAddAbility(.c, KyorakuT1_ID)
            call UnitAddAbility(.c, KyorakuT2_ID)
            call UnitAddAbility(.c, KyorakuT3_ID)
            call UnitAddAbility(.c, KyorakuT4_ID)
            call UnitAddAbility(.c, KyorakuT5_ID)
            call MakeSound3("war3mapimported\\Hero_Kyoraku_T1")
            set .a = GetUnitFacing(.c) * bj_DEGTORAD
            set .aoe = KyorakuT_DamageAoe
            set .dmg = GetHeroAgi(.c, true) * KyorakuT_Dan2_DamageAgi
            set .dmg2 = GetHeroAgi(.c, true) * KyorakuT_Dan3_Dmg
            set .rmax = 16.12
            set .k = 0
            loop
                exitwhen .k > 10
                if Hero[k] != null then
                    call SaveInteger(hs, GetHandleId(Hero[k]), SH_BANKAI_1_ST_ACTIVATED, 0)
                    call RemoveSavedInteger(hs,GetHandleId(Hero[k]), SH_BANKAI_1_ST_ACTIVATED)
                endif
                set .k = .k + 1
            endloop
            call VisionTimed(GetOwningPlayer(.c), .x, .y, .aoe * 1.75, 3.7)
            call SetUnitTimeScale(.c, 0.5)
            call SetUnitAnimationByIndex(.c, 18)
            if MUI_KyorakuT == 0 then
                call KyorakuTick_On(8)
            endif
        endmethod
    endstruct

    private struct KyorakuF_KS
        private static integer array m_KyorakuF
        private static integer MUI_KyorakuF = -1
        unit c
        real x
        real y
        real r2
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        real a
        real rmax
        static method Loop_KyorakuF takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KyorakuF
                set this = m_KyorakuF[i]
                if SpellBoolCaster(.c) and .r <= .rmax then
                    set .r = .r + 0.03
                    call DebugUnit2(.c)
                    set .r = RoundReal(.r, 3)
                    if .r2 > 0.12 then
                        set .r2 = 0
                        call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_0713.mdx", .c, "hand right"))
                        call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_0713.mdx", .c, "hand left"))
                    else
                        set .r2 = .r2 + 0.03
                    endif
                    if .r == 0.45 then                    
                    set .x = GetUnitX(.c)
                    set .y = GetUnitY(.c)
                        set .e = EffectSpawn("war3mapimported\\wos_1jinse_97.mdx", .x, .y, .a * bj_RADTODEG, 1.75, 2.65, 1)
                        call AnimDummyEff(.e, 0.4, 1)
                        call AnimDummyEff(.e, 1., 3)
                        call DestroyEffect(.e)
                        set .e = null
                        call MakeSound("war3mapimported\\Hero_Kyoraku_F 2")
                    endif
                    if .r == .rmax then
                        call DecorRemove(.c, .x, .y, .aoe+250, 100)
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_acg_bbb.mdx", .x, .y, GetRandomReal(0, 359), 1.75, 3.12, 195, 255, 255, 255, 195))
                        call MakeSound("war3mapimported\\Hero_Kyoraku_F 3")
                        call GroupClear(.g)
                        call GroupEnumUnitsInRange(.g, .x, .y, .aoe, NoDecor_Cond)
                        loop
                            set .u = FirstOfGroup(.g)
                            exitwhen .u == null
                            if IsUnitEnemy(.u, GetOwningPlayer(.c)) and SpellBool(.u) then
                                call DamageSource('A055')
                                call dmgmag(.c, .u, .dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", .u, "chest"))
                                call SilenceUnit(.c, .u, KyorakuF_SilenceDuration)
                            endif
                            call GroupRemoveUnit(.g, .u)
                        endloop
                    endif
                else
                    call StopSpellUnit2(.c)
                    call DestroyGroup(.g)
                    call DestroyEffect(.e)
                    set .c = null
                    set .e = null
                    set .u = null
                    set .g = null
                    set m_KyorakuF[i] = m_KyorakuF[ MUI_KyorakuF]
                    set MUI_KyorakuF = MUI_KyorakuF - 1
                    set i = i - 1 // revisit: the moved instance must not skip this tick
                    if MUI_KyorakuF == -1 then
                        call KyorakuTick_Off(9)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KyorakuF_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_KyorakuF = MUI_KyorakuF + 1
            set m_KyorakuF[ MUI_KyorakuF] = this
            set .c = NewC
            set .r = 0
            set .r2 = 0
            set .x = GetUnitX(.c)
            set .y = GetUnitY(.c)
            set .g = CreateGroup()
            call StartSpellUnit2(.c)
            call MakeSound("war3mapimported\\Hero_Kyoraku_F 1")
            set .a = GAngle2(.c, .x, .y)
            set .aoe = KyorakuF_DamageAoe
            set .dmg = GetHeroAgi(.c, true) * KyorakuF_DamageAgiBase
            set .rmax = 0.51
            call SetUnitAnimationByIndex(.c, 6)
            call SetUnitTimeScale(.c, 0.33)
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", GetUnitX(.c), GetUnitY(.c), GetRandomReal(0, 359), 0.8, 1, 0))
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", GetUnitX(.c), GetUnitY(.c), GetRandomReal(0, 359), 0.92, 1.25, 0))
            if MUI_KyorakuF == 0 then
                call KyorakuTick_On(9)
            endif
        endmethod
    endstruct

    
    //----------------------------Kyoraku-----------------------------------------------
     /* Animations index:
    Base:
    0 - Stand
    1 - stand ready
    2 - walk
    3 - walk fast
    4 - simple atk left
    5 - simple atk right
    6 - double atk sword zangerin .r
    7 - takaoni
    8 - bushogoma Agiike prepare
    8 - bushogoma Agiike stand
    10 - bushogoma Agiike end(
    11 - kageoni fast Agiike
    12 - kageoni w inside
    13 - Agiike from shadow with 1 sword
    14 - kageoni outside slow
    15 - kageoni outside atk
    16 - irooni Agiike
    19 - bankai cast
     */ 
    function KyorakuF_Start takes unit c returns nothing
        call KyorakuF_KS.KyorakuF_Start( c )
    endfunction
    function KyorakuQ_Start takes unit c, real x, real y returns nothing
        call KyorakuQ_KS.KyorakuQ_Start( c, x, y )
    endfunction
    function KyorakuQ2_Start takes unit c returns nothing
        call KyorakuQ2_KS.KyorakuQ2_Start( c )
    endfunction
    function KyorakuW_Start takes unit c, real x, real y returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        call KyorakuW_KS.KyorakuW_Start( c, x, y )
        call SaveInteger(hs, GetHandleId(Player(i)), SH_W2_CAST, 0)
    endfunction
    function KyorakuW2_Start takes unit c returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        call KyorakuW2_KS.KyorakuW2_Start( c )
    endfunction
    function KyorakuE4_Start takes unit c returns nothing
        call KyorakuE4_KS.KyorakuE4_Start(c)
    endfunction
    function KyorakuE_Start takes unit c, real x, real y returns nothing
        call KyorakuE_KS.KyorakuE_Start( c, x, y)
    endfunction
    function KyorakuWE_Start takes unit c, unit td returns nothing
        call KyorakuE2_KS.KyorakuE2_Start( c, td )
    endfunction
    function KyorakuR_Start takes unit c returns nothing
        call BuffUnit1(c, c, 2)
    endfunction
    function KyorakuRAct_Start takes unit c, unit td returns nothing
        call KyorakuR_KS.KyorakuR_Start( c, td )
    endfunction
    function KyorakuT_Start takes unit c returns nothing
        call KyorakuT_KS.KyorakuT_Start( c )
    endfunction
    function KyorakuT5_Start takes unit c returns nothing
        call SaveInteger(hs, GetHandleId(c), SH_INSTANT_END, 1)
    endfunction
    function KyorakuTSkip_Start takes unit c returns nothing
        if BankaiActive and KyorakuBankaiCaster == c and GetUnitAbilityLevel(c, KyorakuTSkip_ID) > 0 then
            call SaveInteger(hs, GetHandleId(c), SH_INSTANT_SKIP, 1)
        else
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), KyorakuTSkip_ID, false)
            call UnitRemoveAbility(c, KyorakuTSkip_ID)
        endif
    endfunction
    function KyorakuT4_Start takes unit c, unit td returns nothing
        call KyorakuT4_KS.KyorakuT4_Start( c, td )
    endfunction

    private struct KyorakuTick_Loop extends array
        static method Loop takes nothing returns nothing
            if KyorakuTick_Active[0] then
                call KyorakuQ_KS.Loop_KyorakuQ()
            endif
            if KyorakuTick_Active[1] then
                call KyorakuQ2_KS.Loop_KyorakuQ2()
            endif
            if KyorakuTick_Active[2] then
                call KyorakuW_KS.Loop_KyorakuW()
            endif
            if KyorakuTick_Active[3] then
                call KyorakuW2_KS.Loop_KyorakuW2()
            endif
            if KyorakuTick_Active[4] then
                call KyorakuE_KS.Loop_KyorakuE()
            endif
            if KyorakuTick_Active[5] then
                call KyorakuE3_KS.Loop_KyorakuE3()
            endif
            if KyorakuTick_Active[6] then
                call KyorakuE2_KS.Loop_KyorakuE2()
            endif
            if KyorakuTick_Active[7] then
                call KyorakuT4_KS.Loop_KyorakuT4()
            endif
            if KyorakuTick_Active[8] then
                call KyorakuT_KS.Loop_KyorakuT()
            endif
            if KyorakuTick_Active[9] then
                call KyorakuF_KS.Loop_KyorakuF()
            endif
            if KyorakuTick_Active[10] then
                call KyorakuE4_KS.Loop_KyorakuE4()
            endif
        endmethod

        private static method onInit takes nothing returns nothing
            set KyorakuTick_Callback = function thistype.Loop
        endmethod
    endstruct


    private struct KyorakuTick05_Loop extends array
        static method Loop takes nothing returns nothing
            if KyorakuTick05_Active[0] then
                call KyorakuR_KS.Loop_KyorakuR()
            endif
        endmethod

        private static method onInit takes nothing returns nothing
            set KyorakuTick05_Callback = function thistype.Loop
        endmethod
    endstruct

endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
