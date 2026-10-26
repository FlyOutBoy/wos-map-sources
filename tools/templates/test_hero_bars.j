// Included inside the generated TEST WOSUI adapter. No initializer or timer.
// Style helpers are copied from current MAIN WOSUI by minimal_ui().
globals
    private hashtable WUI_TestBarKeys = null
    private integer WUI_TestBarCount = 0
    private integer array WUI_TestBarOwnerSlots
    private framehandle array WUI_TestBarPanel
    private framehandle array WUI_TestBarFill
    private framehandle array WUI_TestBarCaption
    private framehandle array WUI_TestBarValue
    private integer array WUI_TestBarTextKey
    private string array WUI_TestBarTitle
endglobals

private function WUI_TestHeroProgress takes unit hero, integer abilityId, string title, real remaining, real total, boolean seconds, string valueText returns nothing
    local integer pid
    local integer index
    local integer textKey
    local framehandle back = null
    local framehandle icon = null
    local framehandle edge = null
    local real fraction
    if hero == null then
        return
    endif
    set pid = GetPlayerId(GetOwningPlayer(hero))
    if pid >= 24 then
        return
    endif
    if WUI_TestBarKeys == null then
        if total <= 0.0 then
            return
        endif
        set WUI_TestBarKeys = InitHashtable()
    endif
    set index = LoadInteger(WUI_TestBarKeys, GetHandleId(hero), abilityId)
    if index == 0 and total > 0.0 and (remaining > 0.0 or not seconds) then
        set WUI_TestBarCount = WUI_TestBarCount + 1
        set index = WUI_TestBarCount
        call SaveInteger(WUI_TestBarKeys, GetHandleId(hero), abilityId, index)
        // All clients allocate the same handles before local presentation.
        set WUI_TestBarPanel[index] = WUI_TestPassive("WOSTestHeroBar", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0))
        call BlzFrameSetTexture(WUI_TestBarPanel[index], WUI_PANEL_TEXTURE, 0, true)
        call BlzFrameSetSize(WUI_TestBarPanel[index], 0.140, 0.025)
        call BlzFrameSetEnable(WUI_TestBarPanel[index], false)
        // Follow the stock minimap at any aspect ratio; do not float in screen centre.
        call BlzFrameSetPoint(WUI_TestBarPanel[index], FRAMEPOINT_BOTTOMLEFT, BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP, 0), FRAMEPOINT_TOPLEFT, 0.003, 0.006 + 0.030*WUI_TestBarOwnerSlots[pid])
        set WUI_TestBarOwnerSlots[pid] = WUI_TestBarOwnerSlots[pid] + 1
        set edge = WUI_TestGoldFrame("WOSTestHeroBarEdge", WUI_TestBarPanel[index], 0.0032, 0.0070)
        set back = WUI_TestPiece("WOSTestHeroBarBack", WUI_TestBarPanel[index], "UI\\WOS\\bar-back.tga")
        call WUI_TestPin(back, WUI_TestBarPanel[index], 0.012, -0.004, 0.104, 0.007)
        set WUI_TestBarFill[index] = WUI_TestPiece("WOSTestHeroBarFill", WUI_TestBarPanel[index], "UI\\WOS\\meter-fill.tga")
        call BlzFrameSetPoint(WUI_TestBarFill[index], FRAMEPOINT_LEFT, WUI_TestBarPanel[index], FRAMEPOINT_CENTER, -0.040, -0.004)
        set icon = WUI_TestPiece("WOSTestHeroBarIcon", WUI_TestBarPanel[index], BlzGetAbilityIcon(abilityId))
        call WUI_TestPin(icon, WUI_TestBarPanel[index], -0.055, 0.000, 0.019, 0.019)
        set WUI_TestBarCaption[index] = BlzCreateFrameByType("TEXT", "WOSTestHeroBarTitle", WUI_TestBarPanel[index], "", 0)
        call BlzFrameSetEnable(WUI_TestBarCaption[index], false)
        call BlzFrameSetFont(WUI_TestBarCaption[index], "Fonts\\FRIZQT__.TTF", 0.008, 0)
        call BlzFrameSetTextAlignment(WUI_TestBarCaption[index], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call WUI_TestPin(WUI_TestBarCaption[index], WUI_TestBarPanel[index], 0.012, 0.006, 0.104, 0.011)
        set WUI_TestBarValue[index] = BlzCreateFrameByType("TEXT", "WOSTestHeroBarValue", WUI_TestBarPanel[index], "", 0)
        call BlzFrameSetEnable(WUI_TestBarValue[index], false)
        call BlzFrameSetFont(WUI_TestBarValue[index], "Fonts\\FRIZQT__.TTF", 0.007, 0)
        call BlzFrameSetTextAlignment(WUI_TestBarValue[index], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call WUI_TestPin(WUI_TestBarValue[index], WUI_TestBarPanel[index], 0.012, -0.004, 0.104, 0.009)
        set WUI_TestBarTextKey[index] = -1
        call BlzFrameSetVisible(WUI_TestBarPanel[index], false)
    endif
    if index > 0 and GetLocalPlayer() == Player(pid) then
        if total <= 0.0 or (seconds and remaining <= 0.0) or IsUnitType(hero, UNIT_TYPE_DEAD) then
            call BlzFrameSetVisible(WUI_TestBarPanel[index], false)
        else
            set fraction = RMaxBJ(0.0, RMinBJ(1.0, remaining/total))
            call BlzFrameSetSize(WUI_TestBarFill[index], RMaxBJ(0.0002, 0.104*fraction), 0.006)
            if WUI_TestBarTitle[index] != title then
                set WUI_TestBarTitle[index] = title
                call BlzFrameSetText(WUI_TestBarCaption[index], "|cffffd36b"+title+"|r")
            endif
            set textKey = R2I(remaining*10.0 + 0.5)
            if valueText != "" then
                call BlzFrameSetText(WUI_TestBarValue[index], "|cffffff00"+valueText+"|r")
            elseif WUI_TestBarTextKey[index] != textKey then
                set WUI_TestBarTextKey[index] = textKey
                call BlzFrameSetText(WUI_TestBarValue[index], "|cffffff00"+R2SW(remaining, 1, 1)+"|r")
            endif
            call BlzFrameSetVisible(WUI_TestBarPanel[index], true)
        endif
    endif
    set back = null
    set icon = null
    set edge = null
endfunction
