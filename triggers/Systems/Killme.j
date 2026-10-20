// Explicit death countdown. Death state stays synchronized;
// the passive countdown above the HUD health bar is rendered only by its owner.
library KillmeProgress initializer KM_Init requires GearSystems, WOSUI
globals
    private unit array KM_Hero
    private timer array KM_DeathTimer
    private real array KM_Duration
    private integer KM_Count = 0
    private timer KM_RenderTimer = null
    private framehandle KM_Panel = null
    private framehandle KM_Fill = null
    private framehandle KM_Text = null
endglobals

function KM_Cancel takes unit hero returns nothing
    local integer pid = 0
    if hero == null then
        return
    endif
    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        if KM_Hero[pid] == hero then
            call PauseTimer(KM_DeathTimer[pid])
            set KM_Hero[pid] = null
            set KM_Count = KM_Count - 1
            if GetLocalPlayer() == Player(pid) and KM_Panel != null then
                call BlzFrameSetVisible(KM_Panel, false)
            endif
        endif
        set pid = pid + 1
    endloop
    if KM_Count == 0 and KM_RenderTimer != null then
        call PauseTimer(KM_RenderTimer)
    endif
endfunction

private function KM_Expire takes nothing returns nothing
    local integer pid = 0
    local unit hero = null
    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        if KM_DeathTimer[pid] == GetExpiredTimer() then
            set hero = KM_Hero[pid]
            call KM_Cancel(hero)
            if hero != null and Hero[pid] == hero and GetUnitTypeId(hero) != 0 and not IsUnitType(hero, UNIT_TYPE_DEAD) and GetOwningPlayer(hero) == Player(pid) and not CheckCoordsInRect(gg_rct_Base, GetUnitX(hero), GetUnitY(hero)) then
                call KillUnit(hero)
            endif
            exitwhen true
        endif
        set pid = pid + 1
    endloop
    set hero = null
endfunction

private function KM_Render takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local real remaining
    local boolean shown
    if KM_Panel == null then
        return
    endif
    set shown = KM_Hero[pid] != null
    if shown then
        set shown = IsUnitSelected(KM_Hero[pid], GetLocalPlayer()) and not WUI_RangePreviewBlocked()
    endif
    call BlzFrameSetVisible(KM_Panel, shown)
    if shown then
        set remaining = TimerGetRemaining(KM_DeathTimer[pid])
        call BlzFrameSetSize(KM_Fill, RMaxBJ(0.0001, 0.216 * remaining / KM_Duration[pid]), 0.010)
        call BlzFrameSetText(KM_Text, "|cffffcc00-killme: " + R2SW(remaining, 1, 1) + " sec|r")
    endif
endfunction

private function KM_Tick takes nothing returns nothing
    local integer pid = 0
    local unit hero
    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        set hero = KM_Hero[pid]
        if hero != null then
            if GetUnitTypeId(hero) == 0 or Hero[pid] != hero or GetOwningPlayer(hero) != Player(pid) or IsUnitType(hero, UNIT_TYPE_DEAD) then
                call KM_Cancel(hero)
            elseif CheckCoordsInRect(gg_rct_Base, GetUnitX(hero), GetUnitY(hero)) then
                call KM_Cancel(hero)
            endif
        endif
        set pid = pid + 1
    endloop
    // UI-only function; no frame/handle allocation or game-state writes.
    call KM_Render()
    set hero = null
endfunction

function Trig_Killme_Actions takes nothing returns nothing
    local integer pid = GetPlayerId(GetTriggerPlayer())
    local unit hero = Hero[pid]
    local real duration = 10.0
    if hero != null and KM_Hero[pid] == null and not IsUnitType(hero, UNIT_TYPE_DEAD) and GetUnitAbilityLevel(hero, 'BTLF') == 0 and not CheckCoordsInRect(gg_rct_Base, GetUnitX(hero), GetUnitY(hero)) then
        if TestMode then
            set duration = 1.0
        endif
        if KM_DeathTimer[pid] == null then
            set KM_DeathTimer[pid] = CreateTimer()
        endif
        call PauseUnit(hero, false)
        if not TestMode then
            call SilenceUnit(hero, hero, duration)
        endif
        set KM_Hero[pid] = hero
        set KM_Duration[pid] = duration
        set KM_Count = KM_Count + 1
        call TimerStart(KM_DeathTimer[pid], duration, false, function KM_Expire)
        if KM_RenderTimer == null then
            set KM_RenderTimer = CreateTimer()
        endif
        if KM_Count == 1 then
            call TimerStart(KM_RenderTimer, 0.05, true, function KM_Tick)
        endif
        call KM_Render()
    endif
    set hero = null
endfunction

function InitTrig_Killme takes nothing returns nothing
    local integer pid = 0
    set gg_trg_Killme = CreateTrigger()
    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        call TriggerRegisterPlayerChatEvent(gg_trg_Killme, Player(pid), "-killme", true)
        set pid = pid + 1
    endloop
    call TriggerAddAction(gg_trg_Killme, function Trig_Killme_Actions)
endfunction

private function KM_CreateBar takes nothing returns nothing
    set KM_Panel = BlzCreateFrameByType("BACKDROP", "WOSKillmeProgress", WUI_GetRoot(), "", 0)
    call WUI_PlaceShift(KM_Panel, 0.479, WUI_CHASSIS_TOP + 0.030, 0.220, 0.014)
    call BlzFrameSetTexture(KM_Panel, "UI\\WOS\\bar-back.tga", 0, true)
    call BlzFrameSetEnable(KM_Panel, false)
    call BlzFrameSetLevel(KM_Panel, 50)
    set KM_Fill = BlzCreateFrameByType("BACKDROP", "WOSKillmeFill", KM_Panel, "", 0)
    call BlzFrameSetPoint(KM_Fill, FRAMEPOINT_LEFT, KM_Panel, FRAMEPOINT_LEFT, 0.002, 0.000)
    call BlzFrameSetTexture(KM_Fill, "UI\\WOS\\hp.tga", 0, true)
    call BlzFrameSetVertexColor(KM_Fill, BlzConvertColor(255, 240, 110, 50))
    call BlzFrameSetEnable(KM_Fill, false)
    set KM_Text = BlzCreateFrameByType("TEXT", "WOSKillmeTime", KM_Panel, "", 0)
    call BlzFrameSetAllPoints(KM_Text, KM_Panel)
    call BlzFrameSetScale(KM_Text, 0.72)
    call BlzFrameSetTextAlignment(KM_Text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetEnable(KM_Text, false)
    call BlzFrameSetVisible(KM_Panel, false)
endfunction

private function KM_Init takes nothing returns nothing
    call WUI_OnReady(function KM_CreateBar)
endfunction
endlibrary
