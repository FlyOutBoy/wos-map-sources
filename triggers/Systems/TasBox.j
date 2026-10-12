library TasAbilityChargeBox requires WOSUI, optional FrameLoader
   
//Adds a custom ChargeBox over Command Buttons to display a xx Text
//requires loading a fdf/toc containing "TasAbilityChargeBox"
//incorrect display when commandbutton Positions colide or in Group selection

//function TasAbilityChargeBox_SetValue takes unit u, integer spellCode, string value returns nothing
   //enforce a wanted Value for that spellCode for unit
//function TasAbilityChargeBox_GetValue takes unit u, integer spellCode returns string
//function TasAbilityChargeBox_Clear(unit u)
//function TasAbilityChargeBox_Init()

   globals
      public constant boolean REFORGED = false // have nativ SkinManagerGetLocalPath
      public unit array Unit
      public real UpdateIntervale = 0.2
      public hashtable Hash = InitHashtable()
      private timer UpdateTimer = null
      private boolean Initialized = false
      public string TocPath ="UI\\WOS\\Charges.toc" // Loaded once by WOSUI before this owner creates frames.
      public framehandle array FrameBox
      public framehandle array FrameText
      public framehandle array FrameIcon
      private boolean array Wanted
      private boolean array Shown
      // Second line under a command button (shop price-plate look), e.g.
      // Tomioka G "+damage" while the stack count sits in the top-right box.
      public framehandle array PlateBox
      public framehandle array PlateText
      public framehandle array PlateIcon
      private boolean array PlateShown
      // Counters are 12% larger than the original 0.012 box / 0.008 font.
      public constant real BOX_SIZE = 0.0135
      public constant real FONT_SIZE = 0.009
   endglobals

   // Normal FRAME counterpart of the library's native command charge counter.
   // A portrait is not a SIMPLEFRAME: keep the same font/material without
   // reparenting a native texture across the two frame families.
   public function CreatePortraitLabel takes framehandle portrait returns framehandle
      local framehandle box = WUI_Panel("TasPortraitChargeBox", portrait, 0.0168, 0.0168)
      local framehandle text = BlzCreateFrameByType("TEXT", "TasPortraitChargeText", box, "", 0)
      local framehandle edge = WUI_Border("TasPortraitChargeEdge", box)
      call BlzFrameSetEnable(box, false)
      call BlzFrameSetEnable(edge, false)
      call BlzFrameSetTexture(box, "UI\\WOS\\button.tga", 0, true)
      call BlzFrameSetPoint(box, FRAMEPOINT_TOPRIGHT, portrait, FRAMEPOINT_TOPRIGHT, 0.001, 0.001)
      call BlzFrameSetAllPoints(text, box)
      call BlzFrameSetFont(text, "Fonts/FRIZQT__.TTF", FONT_SIZE, 0)
      call BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
      call BlzFrameSetEnable(text, false)
      set edge = null
      set box = null
      return text
   endfunction
   
   public function GetUnitSpellCodeKey takes integer unitId, integer spellCode returns integer
      local integer count = LoadInteger(Hash, unitId, 0)
      local integer loopA = 0
      loop
         set loopA = loopA + 1
         exitwhen loopA > count
         if LoadInteger(Hash, unitId, loopA) == spellCode then
            return loopA
         endif
      endloop
      set count = count + 1
      call SaveInteger(Hash, unitId, 0, count)
      call SaveInteger(Hash, unitId, count, spellCode)
      return count
   endfunction

   public function SetValue takes unit u, integer spellCode, string value returns nothing
      local integer unitId = GetHandleId(u)
      call GetUnitSpellCodeKey(unitId, spellCode)
      call SaveStr(Hash, unitId, spellCode, value)
   endfunction

   public function GetValue takes unit u, integer spellCode returns string
      local integer stacks = 0
      local integer hid = GetHandleId(u)
      // Read gameplay state without creating handles or saving local UI state.
      // The same value is used by native boxes and the custom ability row.
      static if LIBRARY_TomiokaSpells then
         if spellCode == TomiokaG_ID then
            set stacks = LoadInteger(hs, hid, StringHash("tomioka add dmg"))
            if stacks > 0 then
               return I2S(stacks)
            endif
            return ""
         endif
      endif
      static if LIBRARY_StarrkSpells then
         if spellCode == StarrkG_ID then
            if GetUnitAbilityLevel(u, Starrk_Pas1ID) > 0 then
               set stacks = stacks + 1
            endif
            if GetUnitAbilityLevel(u, Starrk_Pas2ID) > 0 then
               set stacks = stacks + 1
            endif
            if GetUnitAbilityLevel(u, Starrk_Pas3ID) > 0 then
               set stacks = stacks + 1
            endif
            if GetUnitAbilityLevel(u, Starrk_Pas4ID) > 0 then
               set stacks = stacks + 1
            endif
            if GetUnitAbilityLevel(u, Starrk_Pas5ID) > 0 then
               set stacks = stacks + 1
            endif
            if GetUnitAbilityLevel(u, Starrk_Pas6ID) > 0 then
               set stacks = stacks + 1
            endif
            if stacks > 0 then
               return I2S(stacks)
            endif
            return ""
         endif
      endif
      static if LIBRARY_InoriSpells then
         if spellCode == InoriE_ID or spellCode == InoriEAlt_ID or spellCode == InoriEAlt2_ID or spellCode == InoriEE_ID or spellCode == InoriE2_ID then
            set stacks = LoadInteger(hs, hid, StringHash("Inori E"))
            if stacks > 0 and LoadInteger(hs, hid, StringHash("Inori E Active")) == 0 then
               return I2S(stacks)
            endif
            return ""
         endif
      endif
      static if LIBRARY_RaidenSpells then
         if spellCode == RaidenG_ID then
            if Raiden_F_Dummy == null or GetOwningPlayer(Raiden_F_Dummy) != GetOwningPlayer(u) then
               return I2S(LoadInteger(hs, hid, StringHash("atk count")))
            endif
            return ""
         endif
      endif
      return LoadStr(Hash, GetHandleId(u), spellCode)
   endfunction

   // Plate text under the button ("" = no plate). Read-only, no handles.
   public function GetSubValue takes unit u, integer spellCode returns string
      local integer stacks = 0
      static if LIBRARY_TomiokaSpells then
         if spellCode == TomiokaG_ID then
            set stacks = LoadInteger(hs, GetHandleId(u), StringHash("tomioka add dmg"))
            if stacks > 0 then
               return "|cff7cd67c+" + I2S(R2I(GetHeroAgi(u, true) * (Tomioka_G_AddDamageBase + Tomioka_G_AddDamageStep * (stacks - 1)) + 0.5)) + " dmg|r"
            endif
         endif
      endif
      return ""
   endfunction

   public function Clear takes unit u returns nothing
      call FlushChildHashtable(Hash, GetHandleId(u))
   endfunction

   // Register synchronously when a hero is learned; values remain read-only.
   public function RegisterHeroCounters takes unit u returns nothing
      local integer id = GetUnitTypeId(u)
      static if LIBRARY_TomiokaSpells then
         if id == Tomioka_ID then
            call SetValue(u, TomiokaG_ID, "")
         endif
      endif
      static if LIBRARY_StarrkSpells then
         if id == Starrk_ID or id == Starrk_Morph_ID then
            call SetValue(u, StarrkG_ID, "")
         endif
      endif
      static if LIBRARY_InoriSpells then
         if id == Inori_ID then
            call SetValue(u, InoriE_ID, "")
            call SetValue(u, InoriEAlt_ID, "")
            call SetValue(u, InoriEAlt2_ID, "")
            call SetValue(u, InoriEE_ID, "")
            call SetValue(u, InoriE2_ID, "")
         endif
      endif
      static if LIBRARY_RaidenSpells then
         if id == Raiden_ID or id == Raiden_Morph_ID then
            call SetValue(u, RaidenG_ID, "")
         endif
      endif
   endfunction

   // Remove one counter without clearing other abilities/items on the unit.
   public function ClearValue takes unit u, integer spellCode returns nothing
      local integer unitId = GetHandleId(u)
      local integer count = LoadInteger(Hash, unitId, 0)
      local integer i = 1
      loop
         exitwhen i > count
         if LoadInteger(Hash, unitId, i) == spellCode then
            call SaveInteger(Hash, unitId, i, LoadInteger(Hash, unitId, count))
            call RemoveSavedInteger(Hash, unitId, count)
            call SaveInteger(Hash, unitId, 0, count - 1)
            call RemoveSavedString(Hash, unitId, spellCode)
            return
         endif
         set i = i + 1
      endloop
   endfunction

   public function Update takes nothing returns nothing
      local unit display = Unit[GetPlayerId(GetLocalPlayer())]
      local integer unitId = GetHandleId(display)
      local integer i = 0
      local integer pos
      local integer spellCode
      local string value
    
      // Checkpoint 27d: decide first, then touch only boxes whose state
      // changed (hiding and re-showing all 12 every tick was costly).
      loop
         exitwhen i > 11
         set Wanted[i] = false
         set i = i + 1
      endloop
      set i = LoadInteger(Hash, unitId, 0)
      loop
         exitwhen i <= 0
         set spellCode = LoadInteger(Hash, unitId, i)
         set pos = BlzGetAbilityPosX(spellCode)+ BlzGetAbilityPosY(spellCode)*4
         set value = GetValue(display, spellCode)
         if pos >= 0 and pos <= 11 and GetUnitAbilityLevel(display, spellCode) > 0 and value != "" and value != null then
            set Wanted[pos] = true
            if BlzFrameGetText(FrameText[pos]) != value then
               call BlzFrameSetText(FrameText[pos], value)
            endif
         endif
         if pos >= 0 and pos <= 11 and PlateBox[pos] != null then
            set value = ""
            if GetUnitAbilityLevel(display, spellCode) > 0 then
               set value = GetSubValue(display, spellCode)
            endif
            if value != "" and BlzFrameGetText(PlateText[pos]) != value then
               call BlzFrameSetText(PlateText[pos], value)
            endif
            if PlateShown[pos] != (value != "") then
               set PlateShown[pos] = value != ""
               call BlzFrameSetVisible(PlateBox[pos], PlateShown[pos])
            endif
         endif
         set i = i - 1
      endloop
      set i = 0
      loop
         exitwhen i > 11
         if Shown[i] != Wanted[i] then
            set Shown[i] = Wanted[i]
            call BlzFrameSetVisible(FrameBox[i], Wanted[i])
         endif
         set i = i + 1
      endloop
      set display = null
   endfunction

   private function Create takes nothing returns nothing
      local framehandle commandButton
      local integer i = 0
      local string font = "Fonts/FRIZQT__.TTF"
      if not WUI_HasChargeDefinitions() then
         static if REFORGED then
            set font = SkinManagerGetLocalPath("InfoPanelTextFont")
         endif
         loop
            exitwhen i > 11
            set commandButton = BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, i)          
            set FrameBox[i] = BlzCreateSimpleFrame("SimpleInfoPanelIconDamage", commandButton, 21)
            set FrameIcon[i] = BlzGetFrameByName("InfoPanelIconBackdrop", 21)
            set FrameText[i] = BlzGetFrameByName("InfoPanelIconValue", 21)
            call BlzFrameSetText(BlzGetFrameByName("InfoPanelIconLevel", 21), "")
            call BlzFrameSetText(BlzGetFrameByName("InfoPanelIconLabel", 21), "")

            call BlzFrameClearAllPoints(FrameIcon[i])
            call BlzFrameSetPoint(FrameIcon[i], FRAMEPOINT_TOPRIGHT, commandButton, FRAMEPOINT_TOPRIGHT, 0.001, 0.001)
            call BlzFrameSetSize(FrameIcon[i], BOX_SIZE, BOX_SIZE)
            call BlzFrameSetTexture(FrameIcon[i], "UI\\WOS\\button.tga", 0, true)

            call BlzFrameClearAllPoints(FrameText[i])
            call BlzFrameSetPoint(FrameText[i], FRAMEPOINT_TOPRIGHT, commandButton, FRAMEPOINT_TOPRIGHT, 0.001, 0.001)
            call BlzFrameSetSize(FrameText[i], BOX_SIZE, BOX_SIZE)
            call BlzFrameSetTextAlignment(FrameText[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
            call BlzFrameSetFont(FrameText[i], font, FONT_SIZE, 0)

            call BlzFrameSetVisible(FrameBox[i], false)
            set i = i + 1
         endloop
      else
         loop
            exitwhen i > 11
            set FrameBox[i] = BlzCreateSimpleFrame("TasAbilityChargeBox", BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, i), i)
            // reserve HandleId, used Async later
            set FrameText[i] =  BlzGetFrameByName("TasAbilityChargeBoxText", i)
            set FrameIcon[i] = BlzGetFrameByName("TasAbilityChargeBoxTexture", i)
            set commandButton = BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, i)
            call BlzFrameClearAllPoints(FrameIcon[i])
            call BlzFrameSetPoint(FrameIcon[i], FRAMEPOINT_TOPRIGHT, commandButton, FRAMEPOINT_TOPRIGHT, 0.001, 0.001)
            call BlzFrameSetSize(FrameIcon[i], BOX_SIZE, BOX_SIZE)
            call BlzFrameSetTexture(FrameIcon[i], "UI\\WOS\\button.tga", 0, true)
            call BlzFrameClearAllPoints(FrameText[i])
            call BlzFrameSetPoint(FrameText[i], FRAMEPOINT_TOPRIGHT, commandButton, FRAMEPOINT_TOPRIGHT, 0.001, 0.001)
            call BlzFrameSetSize(FrameText[i], BOX_SIZE, BOX_SIZE)
            call BlzFrameSetFont(FrameText[i], font, FONT_SIZE, 0)
            call BlzFrameSetVisible(FrameBox[i], false)
            // Plate under the button (same native template, own context).
            set PlateBox[i] = BlzCreateSimpleFrame("TasAbilityChargeBox", commandButton, 100 + i)
            set PlateText[i] = BlzGetFrameByName("TasAbilityChargeBoxText", 100 + i)
            set PlateIcon[i] = BlzGetFrameByName("TasAbilityChargeBoxTexture", 100 + i)
            call BlzFrameClearAllPoints(PlateIcon[i])
            call BlzFrameSetPoint(PlateIcon[i], FRAMEPOINT_CENTER, commandButton, FRAMEPOINT_BOTTOM, 0.000, 0.000)
            call BlzFrameSetSize(PlateIcon[i], 0.034, 0.0105)
            call BlzFrameSetTexture(PlateIcon[i], "UI\\WOS\\price-plate.tga", 0, true)
            call BlzFrameClearAllPoints(PlateText[i])
            call BlzFrameSetAllPoints(PlateText[i], PlateIcon[i])
            call BlzFrameSetFont(PlateText[i], font, 0.0078, 0)
            call BlzFrameSetVisible(PlateBox[i], false)
            set i = i + 1
         endloop
         if GetHandleId(FrameBox[1]) == 0 then
            call BJDebugMsg(" Error Creating Frames")
         endif
      endif
   endfunction

   public function Select takes nothing returns nothing
      set Unit[GetPlayerId(GetTriggerPlayer())] = GetTriggerUnit()
   endfunction

   private function StartFrames takes nothing returns nothing
      call Create()
      call TimerStart(UpdateTimer, UpdateIntervale, true, function Update)
   endfunction

   public function Init takes nothing returns nothing
      local trigger trig
      if Initialized then
         return
      endif
      set Initialized = true
      set UpdateTimer = CreateTimer()
      call WUI_OnReady(function StartFrames)
      set trig = CreateTrigger()
      call TriggerAddAction(trig, function Select)
      call TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SELECTED)
      set trig = null
   endfunction
endlibrary
