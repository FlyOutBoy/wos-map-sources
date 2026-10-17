library HeroUnitPanelStats initializer HeroUnitPanelStats_Init requires heroicon
    globals
        private timer UNITSTAT_UpdateTimer = null
        private group UNITSTAT_SelectedGroup = null

        private framehandle UNITSTAT_GameUI = null
        private framehandle UNITSTAT_ArmorContainer = null
        
        private framehandle UNITSTAT_PhysRes = null
        private framehandle UNITSTAT_MagRes = null
        private framehandle UNITSTAT_HpRegen = null
        private framehandle UNITSTAT_MpRegen = null
        private framehandle UNITSTAT_MoveSpeed = null
        private framehandle UNITSTAT_AttackSpeed = null
        private framehandle UNITSTAT_Invulnerable = null

        private unit UNITSTAT_DummyHero = null

        private constant real UNITSTAT_UPDATE_PERIOD = 0.05
        private constant real UNITSTAT_TEXT_SCALE = 0.70
        private constant real UNITSTAT_ARMOR_OFFSCREEN_X = 0.400
        private constant real UNITSTAT_ARMOR_OFFSCREEN_Y = -0.180
        private constant real UNITSTAT_ARMOR_TINY_SIZE = 0.00001

        // All offsets are relative to the left side of the former armor slot.
        // X: positive = right. Y: positive = up.
        private constant real UNITSTAT_HP_REGEN_X = -0.005
        private constant real UNITSTAT_HP_REGEN_Y = 0.008
        private constant real UNITSTAT_MP_REGEN_X = -0.005
        private constant real UNITSTAT_MP_REGEN_Y = -0.008
        private constant real UNITSTAT_HP_REGEN_SCALE = 0.68
        private constant real UNITSTAT_MP_REGEN_SCALE = 0.68

        private constant real UNITSTAT_PHYS_RES_X = 0.045
        private constant real UNITSTAT_PHYS_RES_Y = 0.008
        private constant real UNITSTAT_MAG_RES_X = 0.045
        private constant real UNITSTAT_MAG_RES_Y = -0.008

        private constant real UNITSTAT_MOVE_SPEED_X = 0.145
        private constant real UNITSTAT_MOVE_SPEED_Y = 0.008
        private constant real UNITSTAT_ATTACK_SPEED_X = 0.145
        private constant real UNITSTAT_ATTACK_SPEED_Y = -0.008

        private constant real UNITSTAT_INVULNERABLE_X = 0.04
        private constant real UNITSTAT_INVULNERABLE_Y = 0.0

        // Used only if Warcraft has not exposed the armor container yet.
        private constant real UNITSTAT_FALLBACK_X = 0.405
        private constant real UNITSTAT_FALLBACK_Y = 0.108

        private constant integer UNITSTAT_INVUL_ABILITY = 'Avul'
    endglobals

    private function UNITSTAT_CreateText takes string frameName, integer context, real width returns framehandle
        local framehandle result = BlzCreateFrameByType("TEXT", frameName, UNITSTAT_GameUI, "", context)
        call BlzFrameSetSize(result, width, 0.012)
        call BlzFrameSetTextAlignment(result, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)
        call BlzFrameSetScale(result, UNITSTAT_TEXT_SCALE)
        call BlzFrameSetLevel(result, 25)
        return result
    endfunction

    private function UNITSTAT_Update takes nothing returns nothing
        local integer i = 0
        local unit selected = null
        
        local boolean showVitals
        local boolean showHero
        local boolean invulnerable
        
        local string hpRegenStr = ""
        local string mpRegenStr = ""
        local string physResStr = ""
        local string magResStr = ""
        local string msStr = ""
        local string asStr = ""

        local integer maxMp

        loop
            exitwhen i >= bj_MAX_PLAYER_SLOTS
            if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(i)) == MAP_CONTROL_USER then
                
                call GroupClear(UNITSTAT_SelectedGroup)
                call GroupEnumUnitsSelected(UNITSTAT_SelectedGroup, Player(i), null)
                set selected = FirstOfGroup(UNITSTAT_SelectedGroup)

                set showVitals = false
                set showHero = false
                set invulnerable = false
                set maxMp = 0

                if selected != null then
                    set showVitals = true
                    set showHero = true //IsUnitType(selected, UNIT_TYPE_HERO) or IsHeroUnitId(GetUnitTypeId(selected))
                    set invulnerable = GetUnitAbilityLevel(selected, UNITSTAT_INVUL_ABILITY) > 0 and CheckCoordsInRect(gg_rct_Base,GetUnitX(selected),GetUnitY(selected))== false 

                    set maxMp = BlzGetUnitMaxMana(selected)

                    set hpRegenStr = "|cff62ff62HP: +" + R2SW(GetHpRegen(selected), 0, 2) + "|r"
                    set mpRegenStr = "|cff6fa8ffMP: +" + R2SW(GetMpRegen(selected), 0, 2) + "|r"

                    if showHero then
                        set physResStr = "|cffff6b6bPhys Res: |r|cffffffff" + R2SW(GetPhysRes(selected), 0, 2) + "%|r"
                        set magResStr = "|cff6fa8ffMag Res: |r|cffffffff" + R2SW(GetMagRes(selected), 0, 2) + "%|r"
                        set msStr = "|cffffd36bMS: |r|cffffffff" + I2S(R2I(GetUnitMoveSpeed(selected))) + "|r"
                        set asStr = "|cffdededeAS: |r|cffffffff" + R2SW(GetAS(selected), 0, 2) + "s|r"
                    endif
                endif

                if GetLocalPlayer() == Player(i) then
                    if not showVitals then
                        call BlzFrameSetVisible(UNITSTAT_HpRegen, false)
                        call BlzFrameSetVisible(UNITSTAT_MpRegen, false)
                        call BlzFrameSetVisible(UNITSTAT_PhysRes, false)
                        call BlzFrameSetVisible(UNITSTAT_MagRes, false)
                        call BlzFrameSetVisible(UNITSTAT_MoveSpeed, false)
                        call BlzFrameSetVisible(UNITSTAT_AttackSpeed, false)
                        call BlzFrameSetVisible(UNITSTAT_Invulnerable, false)
                    else
                        call BlzFrameSetText(UNITSTAT_HpRegen, hpRegenStr)
                        call BlzFrameSetText(UNITSTAT_MpRegen, mpRegenStr)
                        
                        call BlzFrameSetVisible(UNITSTAT_HpRegen, true)

                        if maxMp <= 0 then
                            call BlzFrameSetVisible(UNITSTAT_MpRegen, false)
                        else
                            call BlzFrameSetVisible(UNITSTAT_MpRegen, true)
                        endif

                        if not showHero then
                            call BlzFrameSetVisible(UNITSTAT_PhysRes, false)
                            call BlzFrameSetVisible(UNITSTAT_MagRes, false)
                            call BlzFrameSetVisible(UNITSTAT_MoveSpeed, false)
                            call BlzFrameSetVisible(UNITSTAT_AttackSpeed, false)
                            call BlzFrameSetVisible(UNITSTAT_Invulnerable, false)
                           // call BJDebugMsg("not")
                        else
                           // call BJDebugMsg("true")
                            call BlzFrameSetText(UNITSTAT_PhysRes, physResStr)
                            call BlzFrameSetText(UNITSTAT_MagRes, magResStr)
                            call BlzFrameSetText(UNITSTAT_MoveSpeed, msStr)
                            call BlzFrameSetText(UNITSTAT_AttackSpeed, asStr)
                            
                            if invulnerable then
                                call BlzFrameSetVisible(UNITSTAT_PhysRes, false)
                                call BlzFrameSetVisible(UNITSTAT_MagRes, false)
                                call BlzFrameSetVisible(UNITSTAT_Invulnerable, true)
                            else
                                call BlzFrameSetVisible(UNITSTAT_PhysRes, true)
                                call BlzFrameSetVisible(UNITSTAT_MagRes, true)
                                call BlzFrameSetVisible(UNITSTAT_Invulnerable, false)
                            endif
                            
                            call BlzFrameSetVisible(UNITSTAT_MoveSpeed, true)
                            call BlzFrameSetVisible(UNITSTAT_AttackSpeed, true)
                        endif
                    endif
                endif
            endif
            set i = i + 1
        endloop

        set selected = null
    endfunction

    private function UNITSTAT_DelayedInit takes nothing returns nothing
        local timer initTimer = GetExpiredTimer()
        local framehandle armorBackdrop
        local framehandle heroContainer
        local framehandle heroIcon
        local framehandle heroText

        call DestroyTimer(initTimer)

        set armorBackdrop = BlzGetFrameByName("InfoPanelIconBackdrop", 2)
        if armorBackdrop != null then
            call BlzFrameClearAllPoints(armorBackdrop)
            call BlzFrameSetSize(armorBackdrop, UNITSTAT_ARMOR_TINY_SIZE, UNITSTAT_ARMOR_TINY_SIZE)
            call BlzFrameSetAbsPoint(armorBackdrop, FRAMEPOINT_BOTTOM, UNITSTAT_ARMOR_OFFSCREEN_X, UNITSTAT_ARMOR_OFFSCREEN_Y)
        endif

        set UNITSTAT_ArmorContainer = BlzGetFrameByName("SimpleInfoPanelIconArmor", 2)
        if UNITSTAT_ArmorContainer != null then
            call BlzFrameClearAllPoints(UNITSTAT_PhysRes)
            call BlzFrameClearAllPoints(UNITSTAT_MagRes)
            call BlzFrameClearAllPoints(UNITSTAT_MoveSpeed)
            call BlzFrameClearAllPoints(UNITSTAT_AttackSpeed)
            call BlzFrameClearAllPoints(UNITSTAT_Invulnerable)
            call BlzFrameClearAllPoints(UNITSTAT_HpRegen)
            call BlzFrameClearAllPoints(UNITSTAT_MpRegen)

            call BlzFrameSetPoint(UNITSTAT_HpRegen, FRAMEPOINT_LEFT, UNITSTAT_ArmorContainer, FRAMEPOINT_LEFT, UNITSTAT_HP_REGEN_X, UNITSTAT_HP_REGEN_Y)
            call BlzFrameSetPoint(UNITSTAT_MpRegen, FRAMEPOINT_LEFT, UNITSTAT_ArmorContainer, FRAMEPOINT_LEFT, UNITSTAT_MP_REGEN_X, UNITSTAT_MP_REGEN_Y)
            call BlzFrameSetPoint(UNITSTAT_PhysRes, FRAMEPOINT_LEFT, UNITSTAT_ArmorContainer, FRAMEPOINT_LEFT, UNITSTAT_PHYS_RES_X, UNITSTAT_PHYS_RES_Y)
            call BlzFrameSetPoint(UNITSTAT_MagRes, FRAMEPOINT_LEFT, UNITSTAT_ArmorContainer, FRAMEPOINT_LEFT, UNITSTAT_MAG_RES_X, UNITSTAT_MAG_RES_Y)
            call BlzFrameSetPoint(UNITSTAT_MoveSpeed, FRAMEPOINT_LEFT, UNITSTAT_ArmorContainer, FRAMEPOINT_LEFT, UNITSTAT_MOVE_SPEED_X, UNITSTAT_MOVE_SPEED_Y)
            call BlzFrameSetPoint(UNITSTAT_AttackSpeed, FRAMEPOINT_LEFT, UNITSTAT_ArmorContainer, FRAMEPOINT_LEFT, UNITSTAT_ATTACK_SPEED_X, UNITSTAT_ATTACK_SPEED_Y)
            call BlzFrameSetPoint(UNITSTAT_Invulnerable, FRAMEPOINT_LEFT, UNITSTAT_ArmorContainer, FRAMEPOINT_LEFT, UNITSTAT_INVULNERABLE_X, UNITSTAT_INVULNERABLE_Y)
        endif

        set heroContainer = BlzGetFrameByName("SimpleInfoPanelIconHero", 6)
        set heroIcon = BlzGetFrameByName("InfoPanelIconHeroIcon", 6)
        set heroText = BlzGetFrameByName("SimpleInfoPanelIconHeroText", 6)
        if heroContainer != null and heroIcon != null and heroText != null then
            call BlzFrameClearAllPoints(heroIcon)
            call BlzFrameSetPoint(heroIcon, FRAMEPOINT_TOPLEFT, heroContainer, FRAMEPOINT_TOPLEFT, 0.002, -0.003)

            call BlzFrameClearAllPoints(heroText)
            call BlzFrameSetPoint(heroText, FRAMEPOINT_LEFT, heroIcon, FRAMEPOINT_RIGHT, 0.006, 0.000)
            call BlzFrameSetPoint(heroText, FRAMEPOINT_RIGHT, heroContainer, FRAMEPOINT_RIGHT, 0.000, 0.000)
            call BlzFrameSetPoint(heroText, FRAMEPOINT_TOP, heroContainer, FRAMEPOINT_TOP, 0.000, 0.000)
            call BlzFrameSetPoint(heroText, FRAMEPOINT_BOTTOM, heroContainer, FRAMEPOINT_BOTTOM, 0.000, 0.000)
        endif

        call ClearSelection()
        call RemoveUnit(UNITSTAT_DummyHero)
        set UNITSTAT_DummyHero = null

        set UNITSTAT_UpdateTimer = CreateTimer()
        call TimerStart(UNITSTAT_UpdateTimer, UNITSTAT_UPDATE_PERIOD, true, function UNITSTAT_Update)
    endfunction

    private function UNITSTAT_CreateUI takes nothing returns nothing
        set UNITSTAT_GameUI = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
        set UNITSTAT_SelectedGroup = CreateGroup()

        set UNITSTAT_PhysRes = UNITSTAT_CreateText("HeroPanelPhysRes", 6100, 0.086)
        set UNITSTAT_MagRes = UNITSTAT_CreateText("HeroPanelMagRes", 6101, 0.086)
        set UNITSTAT_HpRegen = UNITSTAT_CreateText("HeroPanelHpRegen", 6104, 0.045)
        set UNITSTAT_MpRegen = UNITSTAT_CreateText("HeroPanelMpRegen", 6105, 0.045)
        set UNITSTAT_MoveSpeed = UNITSTAT_CreateText("HeroPanelMoveSpeed", 6106, 0.080)
        set UNITSTAT_AttackSpeed = UNITSTAT_CreateText("HeroPanelAttackSpeed", 6107, 0.080)
        set UNITSTAT_Invulnerable = UNITSTAT_CreateText("HeroPanelInvulnerable", 6108, 0.095)
        
        call BlzFrameSetScale(UNITSTAT_PhysRes, 0.78)
        call BlzFrameSetScale(UNITSTAT_MagRes, 0.78)
        call BlzFrameSetScale(UNITSTAT_HpRegen, UNITSTAT_HP_REGEN_SCALE)
        call BlzFrameSetScale(UNITSTAT_MpRegen, UNITSTAT_MP_REGEN_SCALE)
        call BlzFrameSetScale(UNITSTAT_Invulnerable, 0.90)
        call BlzFrameSetText(UNITSTAT_Invulnerable, "|cffff2020INVUL|r")

        call BlzFrameSetSize(UNITSTAT_HpRegen, 0.072, 0.012)
        call BlzFrameSetSize(UNITSTAT_MpRegen, 0.072, 0.012)
        call BlzFrameSetTextAlignment(UNITSTAT_HpRegen, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)
        call BlzFrameSetTextAlignment(UNITSTAT_MpRegen, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)

        // Visible fallback until the dummy Paladin exposes the armor container.
        call BlzFrameSetAbsPoint(UNITSTAT_HpRegen, FRAMEPOINT_LEFT, UNITSTAT_FALLBACK_X + UNITSTAT_HP_REGEN_X, UNITSTAT_FALLBACK_Y + UNITSTAT_HP_REGEN_Y)
        call BlzFrameSetAbsPoint(UNITSTAT_MpRegen, FRAMEPOINT_LEFT, UNITSTAT_FALLBACK_X + UNITSTAT_MP_REGEN_X, UNITSTAT_FALLBACK_Y + UNITSTAT_MP_REGEN_Y)
        call BlzFrameSetAbsPoint(UNITSTAT_PhysRes, FRAMEPOINT_LEFT, UNITSTAT_FALLBACK_X + UNITSTAT_PHYS_RES_X, UNITSTAT_FALLBACK_Y + UNITSTAT_PHYS_RES_Y)
        call BlzFrameSetAbsPoint(UNITSTAT_MagRes, FRAMEPOINT_LEFT, UNITSTAT_FALLBACK_X + UNITSTAT_MAG_RES_X, UNITSTAT_FALLBACK_Y + UNITSTAT_MAG_RES_Y)
        call BlzFrameSetAbsPoint(UNITSTAT_MoveSpeed, FRAMEPOINT_LEFT, UNITSTAT_FALLBACK_X + UNITSTAT_MOVE_SPEED_X, UNITSTAT_FALLBACK_Y + UNITSTAT_MOVE_SPEED_Y)
        call BlzFrameSetAbsPoint(UNITSTAT_AttackSpeed, FRAMEPOINT_LEFT, UNITSTAT_FALLBACK_X + UNITSTAT_ATTACK_SPEED_X, UNITSTAT_FALLBACK_Y + UNITSTAT_ATTACK_SPEED_Y)
        call BlzFrameSetAbsPoint(UNITSTAT_Invulnerable, FRAMEPOINT_LEFT, UNITSTAT_FALLBACK_X + UNITSTAT_INVULNERABLE_X, UNITSTAT_FALLBACK_Y + UNITSTAT_INVULNERABLE_Y)

        call BlzFrameSetVisible(UNITSTAT_PhysRes, false)
        call BlzFrameSetVisible(UNITSTAT_MagRes, false)
        call BlzFrameSetVisible(UNITSTAT_MoveSpeed, false)
        call BlzFrameSetVisible(UNITSTAT_AttackSpeed, false)
        call BlzFrameSetVisible(UNITSTAT_Invulnerable, false)
        call BlzFrameSetVisible(UNITSTAT_HpRegen, false)
        call BlzFrameSetVisible(UNITSTAT_MpRegen, false)
    endfunction

    private function HeroUnitPanelStats_Init takes nothing returns nothing
        local timer initTimer = CreateTimer()
        
        call UNITSTAT_CreateUI()
        
        set UNITSTAT_DummyHero = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'Hpal', 0, 0, 0)
        call BlzSetUnitRealField(UNITSTAT_DummyHero, UNIT_RF_SCALING_VALUE, 0.01)
        
        call SelectUnit(UNITSTAT_DummyHero, true)

        call TimerStart(initTimer, 0.10, false, function UNITSTAT_DelayedInit)
        set initTimer = null
    endfunction
endlibrary
