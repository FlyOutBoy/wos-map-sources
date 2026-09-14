library TasAbilityChargeBox requires optional FrameLoader
   
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
      public hashtable Hash
      public string TocPath ="war3mapImported/TasAbilityChargeBox.toc" // no TocPath or TocPath = "" create it without fdf
      public framehandle array FrameBox
      public framehandle array FrameText
      public framehandle array FrameIcon
   endglobals
   
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
      return LoadStr(Hash, GetHandleId(u), spellCode)
   endfunction

   public function Clear takes unit u returns nothing
      call FlushChildHashtable(Hash, GetHandleId(u))
   endfunction

   public function Update takes nothing returns nothing
      local integer unitId = GetHandleId(Unit[GetPlayerId(GetLocalPlayer())])
      local integer i = 0
      local integer pos
      local integer spellCode
    
      loop
         exitwhen i > 11
         call BlzFrameSetVisible(FrameBox[i], false)
         set i = i + 1 
      endloop

      // One wants to display something specific?
      set i = LoadInteger(Hash, unitId, 0)
      loop
         exitwhen i <= 0
         set spellCode = LoadInteger(Hash, unitId, i)
         set pos = BlzGetAbilityPosX(spellCode)+ BlzGetAbilityPosY(spellCode)*4
         if pos >= 0 and i <= 11 then
            call BlzFrameSetVisible(FrameBox[pos], true)
            call BlzFrameSetText(FrameText[pos],  LoadStr(Hash, unitId, spellCode))
         endif
         set i = i - 1
      endloop
   endfunction

   private function Create takes nothing returns nothing
      local framehandle commandButton
      local integer i = 0
      local string font = "Fonts/FRIZQT__.TTF"
      if TocPath == null or TocPath == "" or not BlzLoadTOCFile(TocPath) then
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
            call BlzFrameSetPoint(FrameIcon[i], FRAMEPOINT_BOTTOMRIGHT, commandButton, FRAMEPOINT_BOTTOMRIGHT, 0.003, -0.003)
            call BlzFrameSetSize(FrameIcon[i], 0.02, 0.02)
            call BlzFrameSetTexture(FrameIcon[i], "UI/Widgets/Console/Human/CommandButton/human-button-lvls-overlay.blp", 0, true)

            call BlzFrameClearAllPoints(FrameText[i])
            call BlzFrameSetPoint(FrameText[i], FRAMEPOINT_BOTTOMRIGHT, commandButton, FRAMEPOINT_BOTTOMRIGHT, 0.003, -0.003)
            call BlzFrameSetSize(FrameText[i], 0.02, 0.02)
            call BlzFrameSetTextAlignment(FrameText[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
            call BlzFrameSetFont(FrameText[i], font, 0.011, 0)

            call BlzFrameSetVisible(FrameBox[i], false)
            set i = i + 1
         endloop
      else
         loop
            exitwhen i > 11
            set FrameBox[i] = BlzCreateSimpleFrame("TasAbilityChargeBox", BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, i), i)
            // reserve HandleId, used Async later
            set FrameText[i] =  BlzGetFrameByName("TasAbilityChargeBoxText", i)
            call BlzFrameSetVisible(FrameBox[i], false)
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

   public function Init takes nothing returns nothing
      local trigger trig
      call TimerStart(CreateTimer(), UpdateIntervale, true, function Update)
      call Create()
      static if LIBRARY_FrameLoader then
         call FrameLoaderAdd(function Create)
      endif
      set trig = CreateTrigger()
      call TriggerAddAction(trig, function Select)
      call TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SELECTED)
      set Hash = InitHashtable()
   endfunction
endlibrary
