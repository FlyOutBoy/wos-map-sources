// Disable the complete feature here, or disable this trigger in trigger-settings.json.
library DamageStats initializer DS_Init requires WOSUI, GearSystems, heroicon
globals
    // MAIN SWITCH: false = damage stats window and per-hit recording are off in every mode
    // except Test (turned on by WOS_SelectMode when Test mode is picked). Mechanics are unaffected.
    constant boolean DAMAGE_STATS_ENABLED = true
    // Runtime state used by every recording/UI path (the constant only seeds it).
    boolean DamageStatsActive = DAMAGE_STATS_ENABLED
    // Pages 0..3 dealt, 4..7 taken: Round / Game (F3/F4 counter) / real game totals (hidden) / Previous.
    // Set by DmgSys right before DamageStatsRecordHitFrom: 1 magical, 2 physical/attack, 0 unknown.
    integer DamageStatsHitKind = 0
    private hashtable DS_Data = InitHashtable()
    // Shared numeric identities: Taken keeps (source, owner, unit type) distinct.
    private hashtable DS_Origins = InitHashtable()
    private hashtable DS_Actors = InitHashtable()
    private hashtable DS_TakenKeys = InitHashtable()
    private integer DS_ActorCount = 0
    private integer DS_OriginCount = 0
    private integer array DS_Count
    private real array DS_Total
    private integer DS_Sequence = 0
    private integer DS_Version = 0
    // All state below is local presentation. It never selects a damage path.
    private framehandle array DS_BarBack
    private integer array DS_RowSource
    private framehandle array DS_SourceRowIcon
    private framehandle array DS_SourceRowArt
    private framehandle array DS_SubLabel
    private framehandle array DS_DirTab
    // Source cells per row: compact uses DS_SMALL, details one line of DS_LINE (top sources only).
    private constant integer DS_CELLS = 12
    // Stored sources per bucket (Round / Game / Session / Previous, dealt and taken).
    private constant integer DS_MAX_SOURCES = 12
    private constant integer DS_LINE = 12
    // Compact Expand: 8 wide cells so 4-character amounts (1.1k) are never clipped.
    private constant integer DS_SMALL = 8
    private constant real DS_SMALL_PITCH = 0.020
    private constant real DS_PITCH = 0.0254
    private framehandle array DS_Sensor
    private framehandle array DS_RowSensor
    private integer array DS_RowLines
    private integer array DS_TabMode
    // Per bucket physical / magical share (bar colour in expanded views).
    private real array DS_Phys
    // Last known damage kind per source id (1 magical, 2 physical) for number colours.
    private hashtable DS_SourceKind = InitHashtable()
    private real array DS_Mag
    private string array DS_RowFillTex
    private framehandle array DS_GameTip
    private string DS_GameTipKeys = ""
    private boolean DS_Minimized = true
    // Hidden for the hero pick (pick chat uses the left column).
    private boolean DS_PickHidden = false
    private boolean DS_SmallBeforePick = false
    private boolean DS_HoverDetail = false
    private real DS_SmallPitch = 0.014
    private real DS_SmallGap = 0.002
    private real DS_SmallHeight = -1.0
    private real DS_LargeHeight = -1.0
    private trigger DS_KeyTrigger
    private timer DS_PollTimer = CreateTimer()
    private integer DS_Direction = 0
    private integer DS_TabPage = -1
    private integer DS_TabDirection = -1
    private framehandle DS_Toggle
    private framehandle array DS_Portrait
    private string array DS_PlayerTexture
    private framehandle array DS_Fill
    private framehandle DS_Small
    private framehandle DS_Large
    private framehandle DS_Footer
    private framehandle DS_Heading
    private framehandle DS_HeadingDamage
    private framehandle DS_HeadingRecent
    private framehandle DS_Details
    private framehandle DS_Back
    private framehandle DS_Previous
    private framehandle DS_Next
    private framehandle DS_Tooltip
    private framehandle DS_TooltipText
    private framehandle array DS_Row
    private framehandle array DS_Label
    private framehandle array DS_Value
    private framehandle array DS_Icon
    private framehandle array DS_Art
    private framehandle array DS_Number
    private framehandle array DS_Tab
    private string array DS_RowPortrait
    private integer array DS_RowPid
    private integer array DS_SlotSource
    private integer array DS_Order
    private integer array DS_SourceOrder
    private integer array DS_Recent
    private hashtable DS_Keys = InitHashtable()
    private trigger DS_ClickTrigger
    private timer DS_Timer = CreateTimer()
    private integer DS_BuildRow = 0
    private integer DS_Page = 0
    private integer DS_Selected = -1
    private integer DS_SourcePage = 0
    // Details player list: 5 players per page so the panel never covers the HUD.
    private integer DS_PlayerPage = 0
    private constant integer DS_PLAYERS_PER_PAGE = 5
    // Source view: row 0 is the player's summary bar, sources fill the other 9 rows.
    private constant integer DS_SOURCES_PER_PAGE = 9
    private string array DS_RowBackTex
    private integer DS_LastVersion = -1
    private real DS_ScreenRight = -1.0
    private integer array DS_LastHero
    private boolean array DS_LastActive
    private integer DS_HoverSlot = -1
    private boolean DS_Ready = false
    private boolean DS_WasSmall = false
    private boolean DS_WasLarge = false
    // Existing .50 clock: ten ticks between damage-only redraws. UI actions force refresh.
    private integer DS_DamageTicks = 0
    // Hit buffer: a hit adds to one pending sum per player and direction (pb 0..9 dealt,
    // 10..19 taken). Every 5 s (synced DS_Tick) the sums fold into Round/Game/Session.
    private constant integer DS_PEND_CAP = 400
    private hashtable DS_Pend = InitHashtable()
    private integer array DS_PendSrc
    private integer array DS_PendCount
    private real array DS_PendTotal
    private real array DS_PendMag
    private real array DS_PendPhys
    private integer array DS_PendList
    private integer DS_PendDirty = 0
    private integer DS_FlushTicks = 10
    // Sort keys copied out of the hashtable once per sort.
    private real array DS_SortValue
    // Last frame text colour per source cell (kind+1, 0 = never set).
    private integer array DS_SlotColor
endglobals

function DamageStatsTotal takes integer pid, integer page returns real
    return DS_Total[page*10+pid]
endfunction

// Native attacks by controlled summons still belong to their summoning ability.
function DamageStatsNativeSource takes unit source returns integer
    local integer unitId = GetUnitTypeId(source)
    if unitId == KenjakuQ2_Dummy_ID then
        return KenjakuQ2_ID
    elseif unitId == KenjakuW2_Dummy_ID then
        return KenjakuW2_ID
    elseif unitId == KenjakuE2_Dummy_ID then
        return KenjakuE2_ID
    elseif unitId == AinzW_Unit_ID then
        return AinzW_ID
    elseif unitId == StarrkWolf_ID then
        return StarrkW_ID
    elseif unitId == AlucardF_IdDummy then
        return AlucardF_ID
    elseif unitId == KiritoE_DummyId or unitId == KiritoE_DummyId2 then
        return KiritoE_ID
    endif
    if BlzGetEventIsAttack() then
        return -1
    endif
    if unitId == Fire_ID then
        return -10
    endif
    // An untagged native effect still identifies its actual unit type.
    if unitId != 0 then
        return -unitId
    endif
    return -4
endfunction

function DamageStatsTakenSource takes unit source, integer sourceId returns integer
    local integer pid
    local integer unitId
    local integer actor
    local integer key
    if source == null then
        return sourceId
    endif
    set pid = GetPlayerId(GetOwningPlayer(source))
    set unitId = GetUnitTypeId(source)
    // Player-owned dummy spells use that player's hero for the ownership portrait.
    if pid < 10 and Hero[pid] != null then
        set unitId = GetUnitTypeId(Hero[pid])
    endif
    set actor = LoadInteger(DS_Actors,unitId,pid)
    if actor == 0 then
        set DS_ActorCount = DS_ActorCount+1
        set actor = DS_ActorCount
        call SaveInteger(DS_Actors,unitId,pid,actor)
    endif
    set key = LoadInteger(DS_TakenKeys,sourceId,actor)
    if key == 0 then
        set DS_OriginCount = DS_OriginCount+1
        set key = -1000-DS_OriginCount
        call SaveInteger(DS_TakenKeys,sourceId,actor,key)
        call SaveInteger(DS_Origins,key,0,sourceId)
        call SaveInteger(DS_Origins,key,1,pid)
        call SaveInteger(DS_Origins,key,2,unitId)
    endif
    return key
endfunction

private function DS_BaseSource takes integer sourceId returns integer
    local integer base = LoadInteger(DS_Origins,sourceId,0)
    if base == 0 then
        set base = sourceId
    endif
    // Morph/combo instance (DamageSourceVariant): artwork and level of its ability.
    if HaveSavedInteger(GearDamageVariants,base,0) then
        return LoadInteger(GearDamageVariants,base,0)
    endif
    return base
endfunction

// Flush only: adds a folded per-source sum to one bucket (totals are added per pending bucket).
// A bucket keeps at most DS_MAX_SOURCES rows (one detailed line): a new source replaces
// the smallest one only when it is bigger; bucket totals always include every hit.
private function DS_FoldSource takes integer bucket, integer sourceId, real amount returns nothing
    local integer i
    local integer slot
    local integer old
    local real least
    if not HaveSavedReal(DS_Data,bucket,sourceId) then
        if DS_Count[bucket] < DS_MAX_SOURCES then
            set DS_Count[bucket] = DS_Count[bucket]+1
            call SaveInteger(DS_Data,bucket,DS_Count[bucket],sourceId)
        else
            set slot = 1
            set least = LoadReal(DS_Data,bucket,LoadInteger(DS_Data,bucket,1))
            set i = 2
            loop
                exitwhen i > DS_Count[bucket]
                if LoadReal(DS_Data,bucket,LoadInteger(DS_Data,bucket,i)) < least then
                    set slot = i
                    set least = LoadReal(DS_Data,bucket,LoadInteger(DS_Data,bucket,i))
                endif
                set i = i+1
            endloop
            if amount <= least then
                return
            endif
            set old = LoadInteger(DS_Data,bucket,slot)
            call RemoveSavedReal(DS_Data,bucket,old)
            call RemoveSavedInteger(DS_Data,bucket,old)
            call SaveInteger(DS_Data,bucket,slot,sourceId)
        endif
    endif
    call SaveReal(DS_Data,bucket,sourceId,LoadReal(DS_Data,bucket,sourceId)+amount)
    call SaveInteger(DS_Data,bucket,sourceId,DS_Sequence)
endfunction

private function DS_FoldTotals takes integer bucket, integer pb returns nothing
    set DS_Total[bucket] = DS_Total[bucket]+DS_PendTotal[pb]
    set DS_Mag[bucket] = DS_Mag[bucket]+DS_PendMag[pb]
    set DS_Phys[bucket] = DS_Phys[bucket]+DS_PendPhys[pb]
endfunction

// Synced: folds every pending sum into its Round / Game / Session buckets.
// Called by DS_Tick every 5 s and before any bucket is cleared, copied or rolled over.
function DamageStatsFlush takes nothing returns nothing
    local integer n = 0
    local integer pb
    local integer bucket
    local integer i
    local integer sourceId
    local real amount
    if DS_PendDirty == 0 then
        return
    endif
    loop
        exitwhen n >= DS_PendDirty
        set pb = DS_PendList[n]
        set bucket = pb
        if pb >= 10 then
            set bucket = pb+30
        endif
        set i = 0
        loop
            exitwhen i >= DS_PendCount[pb]
            set sourceId = DS_PendSrc[pb*DS_PEND_CAP+i]
            set amount = LoadReal(DS_Pend,pb,sourceId)
            set DS_Sequence = DS_Sequence+1
            call DS_FoldSource(bucket,sourceId,amount)
            call DS_FoldSource(bucket+10,sourceId,amount)
            call DS_FoldSource(bucket+20,sourceId,amount)
            set i = i+1
        endloop
        call DS_FoldTotals(bucket,pb)
        call DS_FoldTotals(bucket+10,pb)
        call DS_FoldTotals(bucket+20,pb)
        call FlushChildHashtable(DS_Pend,pb)
        set DS_PendCount[pb] = 0
        set DS_PendTotal[pb] = 0.0
        set DS_PendMag[pb] = 0.0
        set DS_PendPhys[pb] = 0.0
        set n = n+1
    endloop
    set DS_PendDirty = 0
    set DS_Version = DS_Version+1
endfunction

// Per hit: one read and one write of the pending sum; no strings, frames or handles.
private function DS_Pending takes integer pb, integer sourceId, real amount returns nothing
    local real old = LoadReal(DS_Pend,pb,sourceId)
    if old <= 0.0 then
        if DS_PendCount[pb] >= DS_PEND_CAP then
            call DamageStatsFlush()
        endif
        if DS_PendCount[pb] == 0 then
            set DS_PendList[DS_PendDirty] = pb
            set DS_PendDirty = DS_PendDirty+1
        endif
        set DS_PendSrc[pb*DS_PEND_CAP+DS_PendCount[pb]] = sourceId
        set DS_PendCount[pb] = DS_PendCount[pb]+1
        set old = 0.0
    endif
    call SaveReal(DS_Pend,pb,sourceId,old+amount)
    set DS_PendTotal[pb] = DS_PendTotal[pb]+amount
    if DamageStatsHitKind == 1 then
        set DS_PendMag[pb] = DS_PendMag[pb]+amount
    elseif DamageStatsHitKind == 2 then
        set DS_PendPhys[pb] = DS_PendPhys[pb]+amount
    endif
    if DamageStatsHitKind != 0 and LoadInteger(DS_SourceKind,sourceId,0) != DamageStatsHitKind then
        call SaveInteger(DS_SourceKind,sourceId,0,DamageStatsHitKind)
    endif
endfunction

// Shared damage path: numeric values only, no strings, frames or per-hit handles.
function DamageStatsRecord takes integer pid, integer sourceId, real amount returns nothing
    if not DamageStatsActive or pid < 0 or pid >= 10 or amount <= 0.0 then
        return
    endif
    if sourceId == 0 then
        set sourceId = -1 // ordinary attack / native untagged damage
    endif
    call DS_Pending(pid,sourceId,amount)
endfunction

// Incoming damage has independent buckets; neutral attackers can still hurt a player.
function DamageStatsRecordTaken takes integer pid, integer sourceId, real amount returns nothing
    if not DamageStatsActive or pid < 0 or pid >= 10 or amount <= 0.0 then
        return
    endif
    if sourceId == 0 then
        set sourceId = -1
    endif
    call DS_Pending(10+pid,sourceId,amount)
endfunction

// Attribute the already-applied hit. Never deal a second hit for an item bonus.
// Later mitigation/flat shields are shared proportionally by the mixed hit.
function DamageStatsRecordHitFrom takes unit source, integer attacker, integer victim, integer sourceId, real amount, real quincyShare returns nothing
    // Match F2's per-hit integer precision; only the statistic is quantized.
    local real tracked = I2R(R2I(amount))
    local real bonus = tracked*RMaxBJ(0.0,RMinBJ(1.0,quincyShare))
    local real base = tracked-bonus
    if not DamageStatsActive or tracked <= 0.0 then
        return
    endif
    if sourceId == 0 then
        set sourceId = -1
    endif
    call DamageStatsRecord(attacker,sourceId,base)
    if victim >= 0 and victim < 10 and base > 0.0 then
        call DamageStatsRecordTaken(victim,DamageStatsTakenSource(source,sourceId),base)
    endif
    if bonus > 0.0 then
        call DamageStatsRecord(attacker,'I023',bonus)
        if victim >= 0 and victim < 10 then
            call DamageStatsRecordTaken(victim,DamageStatsTakenSource(source,'I023'),bonus)
        endif
    endif
endfunction

// Compatibility for numeric callers; production damage passes the actual source.
function DamageStatsRecordHit takes integer attacker, integer victim, integer sourceId, real amount, real quincyShare returns nothing
    local unit source = null
    if attacker >= 0 and attacker < 10 then
        set source = Hero[attacker]
    endif
    call DamageStatsRecordHitFrom(source,attacker,victim,sourceId,amount,quincyShare)
    set source = null
endfunction

// Direct HP hazards bypass EVENT_PLAYER_UNIT_DAMAGED. Observe the actual HP loss.
function DamageStatsRecordDirect takes unit source, unit target, integer sourceId, real amount returns nothing
    local integer owner = 24
    if not DamageStatsActive or amount <= 0.0 or not IsUnitType(target,UNIT_TYPE_HERO) or IsUnitIllusion(target) then
        return
    endif
    if source != null then
        set owner = GetPlayerId(GetOwningPlayer(source))
    endif
    call DamageStatsRecordHitFrom(source,owner,GetPlayerId(GetOwningPlayer(target)),sourceId,amount,0.0)
endfunction

function DamageStatsClearBucket takes integer bucket returns nothing
    call FlushChildHashtable(DS_Data,bucket)
    set DS_Count[bucket] = 0
    set DS_Total[bucket] = 0.0
    set DS_Phys[bucket] = 0.0
    set DS_Mag[bucket] = 0.0
endfunction

function DamageStatsCopyBucket takes integer fromBucket, integer toBucket returns nothing
    local integer i = 1
    local integer sourceId
    call DamageStatsClearBucket(toBucket)
    set DS_Count[toBucket] = DS_Count[fromBucket]
    set DS_Total[toBucket] = DS_Total[fromBucket]
    set DS_Phys[toBucket] = DS_Phys[fromBucket]
    set DS_Mag[toBucket] = DS_Mag[fromBucket]
    loop
        exitwhen i > DS_Count[fromBucket]
        set sourceId = LoadInteger(DS_Data,fromBucket,i)
        call SaveInteger(DS_Data,toBucket,i,sourceId)
        call SaveReal(DS_Data,toBucket,sourceId,LoadReal(DS_Data,fromBucket,sourceId))
        call SaveInteger(DS_Data,toBucket,sourceId,LoadInteger(DS_Data,fromBucket,sourceId))
        set i = i+1
    endloop
endfunction

// F3 / F4 (rebindable Clear / Load keys), same as the F2 statistics: the Game page
// is the player's counter. Clear empties it; Load restores the real game totals
// that are always recorded in the hidden page 2. Round and Previous are untouched.
function DamageStatsClear takes integer pid returns nothing
    if DamageStatsActive and pid >= 0 and pid < 10 then
        call DamageStatsFlush()
        call DamageStatsClearBucket(10+pid)
        call DamageStatsClearBucket(50+pid)
        set DS_Version = DS_Version+1
        if GetLocalPlayer() == Player(pid) then
            set DS_Page = 1
            set DS_SourcePage = 0
            set DS_LastVersion = -1
        endif
    endif
endfunction

function DamageStatsLoad takes integer pid returns nothing
    if DamageStatsActive and pid >= 0 and pid < 10 then
        call DamageStatsFlush()
        call DamageStatsCopyBucket(20+pid,10+pid)
        call DamageStatsCopyBucket(60+pid,50+pid)
        set DS_Version = DS_Version+1
        if GetLocalPlayer() == Player(pid) then
            set DS_Page = 1
            set DS_SourcePage = 0
            set DS_LastVersion = -1
        endif
    endif
endfunction

function DamageStatsNextRound takes nothing returns nothing
    local integer pid = 0
    if not DamageStatsActive then
        return
    endif
    call DamageStatsFlush()
    loop
        exitwhen pid >= 10
        call DamageStatsCopyBucket(pid,30+pid)
        call DamageStatsClearBucket(pid)
        call DamageStatsCopyBucket(40+pid,70+pid)
        call DamageStatsClearBucket(40+pid)
        set pid = pid+1
    endloop
    set DS_Version = DS_Version+1
endfunction

// UI and cached metadata follow. Everything is constructed on the shared ready path.
private function DS_StripLevel takes string text returns string
    local integer n = StringLength(text)
    local integer i = 0
    loop
        exitwhen i+6 > n
        if SubString(text,i,i+6) == "[Level" then
            set text = SubString(text,0,i)
            loop
                set n = StringLength(text)
                exitwhen n == 0
                if SubString(text,n-1,n) == " " then
                    set text = SubString(text,0,n-1)
                elseif n >= 10 and (SubString(text,n-10,n-8) == "|c" or SubString(text,n-10,n-8) == "|C") then
                    set text = SubString(text,0,n-10)
                else
                    exitwhen true
                endif
            endloop
            return text
        endif
        set i = i+1
    endloop
    return text
endfunction

private function DS_BaseName takes integer sourceId returns string
    local string title
    set sourceId = DS_BaseSource(sourceId)
    if sourceId <= -1000000 then
        return GetObjectName(-sourceId)+" damage"
    elseif sourceId == -10 then
        return "Ground fire"
    elseif sourceId == -11 then
        return "Barrel explosion"
    elseif sourceId == -12 then
        return "Train impact"
    elseif sourceId == -13 then
        return "Train explosion"
    elseif sourceId == -14 then
        return "Sukuna: Malevolent Shrine"
    elseif sourceId == -15 then
        return "Car explosion"
    elseif sourceId == -16 then
        return "Vending machine"
    elseif sourceId == -17 then
        return "Fire hydrant"
    elseif sourceId <= -101 and sourceId >= -108 then
        if sourceId == -101 then
            return "Fire debuff"
        elseif sourceId == -102 then
            return "Water debuff"
        elseif sourceId == -103 then
            return "Lightning debuff"
        elseif sourceId == -104 then
            return "Vaporize"
        elseif sourceId == -105 then
            return "Overload"
        endif
        return "Electro-Charged"
    elseif sourceId == -1 then
        return "Attack"
    elseif sourceId == -2 then
        return "Elemental effect"
    elseif sourceId == -3 then
        return "Test setup"
    elseif sourceId == -4 then
        return "Unattributed damage"
    endif
    if sourceId >= 'I000' and sourceId <= 'Izzz' then
        return GetObjectName(sourceId)
    endif
    // The level-1 tooltip title carries "[Level 1]": strip it once and cache the name.
    if HaveSavedString(DS_Keys,sourceId,3) then
        return LoadStr(DS_Keys,sourceId,3)
    endif
    set title = DS_StripLevel(BlzGetAbilityTooltip(sourceId,0))
    if title == "" or title == null then
        set title = GetObjectName(sourceId)
    endif
    call SaveStr(DS_Keys,sourceId,3,title)
    return title
endfunction

// Morph/combo instances keep the ability name plus their caption (Cero [EQ]).
private function DS_SourceName takes integer sourceId returns string
    local integer variant = LoadInteger(DS_Origins,sourceId,0)
    if variant == 0 then
        set variant = sourceId
    endif
    if HaveSavedInteger(GearDamageVariants,variant,0) then
        return DS_BaseName(sourceId)+" ["+LoadStr(GearDamageVariants,variant,1)+"]"
    endif
    return DS_BaseName(sourceId)
endfunction

// Current level of the ability on the hero that owns the damage, "" for items/effects.
private function DS_LevelCaption takes integer sourceId, integer pid returns string
    local integer level
    set sourceId = DS_BaseSource(sourceId)
    if pid < 0 or pid >= 10 or Hero[pid] == null or sourceId <= 0 or (sourceId >= 'I000' and sourceId <= 'Izzz') then
        return ""
    endif
    set level = GetUnitAbilityLevel(Hero[pid],sourceId)
    if level <= 0 then
        return ""
    endif
    return " |cffffcc00[Level "+I2S(level)+"]|r"
endfunction

// Fixed object artwork, populated once on shared startup. Never resolve strings on a hit.
private function DS_BuildIconCatalogue takes nothing returns nothing
    local integer pid = 0
    // DS_ABILITY_ICONS_BEGIN
    call SaveStr(DS_Keys,'A000',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Raiden_Q.blp")
    call SaveStr(DS_Keys,'A001',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Raiden_W.blp")
    call SaveStr(DS_Keys,'A002',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Raiden_E.blp")
    call SaveStr(DS_Keys,'A003',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Raiden_R.blp")
    call SaveStr(DS_Keys,'A00E',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_Q.blp")
    call SaveStr(DS_Keys,'A00F',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_W.blp")
    call SaveStr(DS_Keys,'A00G',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_E.blp")
    call SaveStr(DS_Keys,'A00H',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_R.blp")
    call SaveStr(DS_Keys,'A00I',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_T.blp")
    call SaveStr(DS_Keys,'A00N',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_GGR.blp")
    call SaveStr(DS_Keys,'A00O',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_GGT.blp")
    call SaveStr(DS_Keys,'A01F',2,"ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_Q.blp")
    call SaveStr(DS_Keys,'A01J',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Gojo_Q.blp")
    call SaveStr(DS_Keys,'A01K',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Gojo_W.blp")
    call SaveStr(DS_Keys,'A01L',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Gojo_Q2.blp")
    call SaveStr(DS_Keys,'A01M',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Gojo_W2.blp")
    call SaveStr(DS_Keys,'A01P',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Gojo_R.blp")
    call SaveStr(DS_Keys,'A01T',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Gojo_T.blp")
    call SaveStr(DS_Keys,'A021',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tomioka_Q.blp")
    call SaveStr(DS_Keys,'A022',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tomioka_W.blp")
    call SaveStr(DS_Keys,'A023',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tomioka_E.blp")
    call SaveStr(DS_Keys,'A024',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tomioka_R.blp")
    call SaveStr(DS_Keys,'A025',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tomioka_T.blp")
    call SaveStr(DS_Keys,'A027',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tomioka_F.blp")
    call SaveStr(DS_Keys,'A028',2,"ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_RW.blp")
    call SaveStr(DS_Keys,'A029',2,"ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_E.blp")
    call SaveStr(DS_Keys,'A02B',2,"ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_T.blp")
    call SaveStr(DS_Keys,'A02D',2,"ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_RR.blp")
    call SaveStr(DS_Keys,'A02F',2,"ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_G.blp")
    call SaveStr(DS_Keys,'A02W',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza_W.blp")
    call SaveStr(DS_Keys,'A032',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza1_Q.blp")
    call SaveStr(DS_Keys,'A033',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza1_W.blp")
    call SaveStr(DS_Keys,'A034',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza1_E.blp")
    call SaveStr(DS_Keys,'A035',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza1_R.blp")
    call SaveStr(DS_Keys,'A036',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza1_T.blp")
    call SaveStr(DS_Keys,'A037',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza2_Q.blp")
    call SaveStr(DS_Keys,'A038',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza2_W.blp")
    call SaveStr(DS_Keys,'A039',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza2_E.blp")
    call SaveStr(DS_Keys,'A03A',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza2_R.blp")
    call SaveStr(DS_Keys,'A03B',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza2_T.blp")
    call SaveStr(DS_Keys,'A03C',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza3_Q.blp")
    call SaveStr(DS_Keys,'A03D',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza3_W.blp")
    call SaveStr(DS_Keys,'A03E',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza3_E.blp")
    call SaveStr(DS_Keys,'A03F',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza3_Q.blp")
    call SaveStr(DS_Keys,'A03G',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza3_T.blp")
    call SaveStr(DS_Keys,'A03H',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza4_Q.blp")
    call SaveStr(DS_Keys,'A03I',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza4_W2.blp")
    call SaveStr(DS_Keys,'A03J',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza4_E.blp")
    call SaveStr(DS_Keys,'A03K',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza4_R.blp")
    call SaveStr(DS_Keys,'A03L',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza4_T.blp")
    call SaveStr(DS_Keys,'A03N',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza5_Q.blp")
    call SaveStr(DS_Keys,'A03O',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza5_W.blp")
    call SaveStr(DS_Keys,'A03P',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza5_E.blp")
    call SaveStr(DS_Keys,'A03Q',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza5_R.blp")
    call SaveStr(DS_Keys,'A03R',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza5_T.blp")
    call SaveStr(DS_Keys,'A03S',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza5_F.blp")
    call SaveStr(DS_Keys,'A04A',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza6_Q.blp")
    call SaveStr(DS_Keys,'A04B',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza6_W.blp")
    call SaveStr(DS_Keys,'A04C',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza6_E.blp")
    call SaveStr(DS_Keys,'A04D',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza6_R.blp")
    call SaveStr(DS_Keys,'A04E',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza6_T.blp")
    call SaveStr(DS_Keys,'A04F',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza7_Q.blp")
    call SaveStr(DS_Keys,'A04G',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza7_W.blp")
    call SaveStr(DS_Keys,'A04H',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza7_E.blp")
    call SaveStr(DS_Keys,'A04I',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza7_R.blp")
    call SaveStr(DS_Keys,'A04J',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Erza7_T.blp")
    call SaveStr(DS_Keys,'A050',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kyoraku_Q.blp")
    call SaveStr(DS_Keys,'A051',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kyoraku_W.blp")
    call SaveStr(DS_Keys,'A052',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kyoraku_E.blp")
    call SaveStr(DS_Keys,'A053',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kyoraku_R.blp")
    call SaveStr(DS_Keys,'A054',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kyoraku_T.blp")
    call SaveStr(DS_Keys,'A055',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kyoraku_F.blp")
    call SaveStr(DS_Keys,'A056',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kyoraku_WQ.blp")
    call SaveStr(DS_Keys,'A058',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kyoraku_WE.blp")
    call SaveStr(DS_Keys,'A059',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kyoraku_T4.blp")
    call SaveStr(DS_Keys,'A05F',2,"ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_W.blp")
    call SaveStr(DS_Keys,'A05G',2,"ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_ECombo.blp")
    call SaveStr(DS_Keys,'A05J',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kenjaku_W.blp")
    call SaveStr(DS_Keys,'A05K',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kenjaku_E.blp")
    call SaveStr(DS_Keys,'A05M',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kenjaku_T.blp")
    call SaveStr(DS_Keys,'A05N',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kenjaku2_Q.blp")
    call SaveStr(DS_Keys,'A05P',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kenjaku2_W.blp")
    call SaveStr(DS_Keys,'A05R',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kenjaku2_E.blp")
    call SaveStr(DS_Keys,'A05T',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kenjaku2_R.blp")
    call SaveStr(DS_Keys,'A063',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Inori_T.blp")
    call SaveStr(DS_Keys,'A064',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Inori_T2.blp")
    call SaveStr(DS_Keys,'A06C',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Inori_TR.blp")
    call SaveStr(DS_Keys,'A06V',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Akainu_Q.blp")
    call SaveStr(DS_Keys,'A06W',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Akainu_W.blp")
    call SaveStr(DS_Keys,'A06X',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Akainu_E.blp")
    call SaveStr(DS_Keys,'A06Y',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Akainu_R.blp")
    call SaveStr(DS_Keys,'A06Z',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Akainu_T.blp")
    call SaveStr(DS_Keys,'A070',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Akainu_F.blp")
    call SaveStr(DS_Keys,'A077',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Okarun_Q.blp")
    call SaveStr(DS_Keys,'A078',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Okarun_W.blp")
    call SaveStr(DS_Keys,'A079',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Okarun_E.blp")
    call SaveStr(DS_Keys,'A07A',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Okarun_R.blp")
    call SaveStr(DS_Keys,'A07B',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Okarun_T.blp")
    call SaveStr(DS_Keys,'A07R',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Neuvillette_Q.blp")
    call SaveStr(DS_Keys,'A07S',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Neuvillette_W.blp")
    call SaveStr(DS_Keys,'A07T',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Neuvillette_E.blp")
    call SaveStr(DS_Keys,'A07U',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Neuvillette_R.blp")
    call SaveStr(DS_Keys,'A07V',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Neuvillette_T.blp")
    call SaveStr(DS_Keys,'A082',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_Q.blp")
    call SaveStr(DS_Keys,'A083',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_W.blp")
    call SaveStr(DS_Keys,'A084',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_W2.blp")
    call SaveStr(DS_Keys,'A085',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_E.blp")
    call SaveStr(DS_Keys,'A086',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_R.blp")
    call SaveStr(DS_Keys,'A087',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_T.blp")
    call SaveStr(DS_Keys,'A088',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_T2.blp")
    call SaveStr(DS_Keys,'A08C',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_TQ.blp")
    call SaveStr(DS_Keys,'A08E',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_TE.blp")
    call SaveStr(DS_Keys,'A08F',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Tsuna_TR.blp")
    call SaveStr(DS_Keys,'A08M',2,"ReplaceableTextures\\CommandButtons\\BTNHero_BazzB_Q.blp")
    call SaveStr(DS_Keys,'A08N',2,"ReplaceableTextures\\CommandButtons\\BTNHero_BazzB_W.blp")
    call SaveStr(DS_Keys,'A08O',2,"ReplaceableTextures\\CommandButtons\\BTNHero_BazzB_E.blp")
    call SaveStr(DS_Keys,'A08P',2,"ReplaceableTextures\\CommandButtons\\BTNHero_BazzB_R.blp")
    call SaveStr(DS_Keys,'A08Q',2,"ReplaceableTextures\\CommandButtons\\BTNHero_BazzB_T.blp")
    call SaveStr(DS_Keys,'A08S',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_Q.blp")
    call SaveStr(DS_Keys,'A08T',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_W.blp")
    call SaveStr(DS_Keys,'A08U',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_E.blp")
    call SaveStr(DS_Keys,'A08V',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_R.blp")
    call SaveStr(DS_Keys,'A08W',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_T.blp")
    call SaveStr(DS_Keys,'A08Z',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_Q2.blp")
    call SaveStr(DS_Keys,'A090',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_W2.blp")
    call SaveStr(DS_Keys,'A093',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_Q3.blp")
    call SaveStr(DS_Keys,'A095',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_GQ.blp")
    call SaveStr(DS_Keys,'A096',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_GW.blp")
    call SaveStr(DS_Keys,'A097',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_GE.blp")
    call SaveStr(DS_Keys,'A098',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_GR.blp")
    call SaveStr(DS_Keys,'A099',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_GF.blp")
    call SaveStr(DS_Keys,'A09D',2,"ReplaceableTextures\\CommandButtons\\BTNHero_DarkShiki_Q.blp")
    call SaveStr(DS_Keys,'A09F',2,"ReplaceableTextures\\CommandButtons\\BTNHero_DarkShiki_W.blp")
    call SaveStr(DS_Keys,'A09G',2,"ReplaceableTextures\\CommandButtons\\BTNHero_DarkShiki_E.blp")
    call SaveStr(DS_Keys,'A09H',2,"ReplaceableTextures\\CommandButtons\\BTNHero_DarkShiki_R.blp")
    call SaveStr(DS_Keys,'A09I',2,"ReplaceableTextures\\CommandButtons\\BTNHero_DarkShiki_T.blp")
    call SaveStr(DS_Keys,'A09J',2,"ReplaceableTextures\\CommandButtons\\BTNHero_DarkShiki_F.blp")
    call SaveStr(DS_Keys,'A09V',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru_Q.blp")
    call SaveStr(DS_Keys,'A09W',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru_W.blp")
    call SaveStr(DS_Keys,'A09Y',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru_E.blp")
    call SaveStr(DS_Keys,'A0A0',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru_T.blp")
    call SaveStr(DS_Keys,'A0A3',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru2_Q.blp")
    call SaveStr(DS_Keys,'A0A4',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru2_W.blp")
    call SaveStr(DS_Keys,'A0A5',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru2_E.blp")
    call SaveStr(DS_Keys,'A0A6',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru2_R.blp")
    call SaveStr(DS_Keys,'A0A7',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru2_T.blp")
    call SaveStr(DS_Keys,'A0A8',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru2_F.blp")
    call SaveStr(DS_Keys,'A0AA',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru3_Q.blp")
    call SaveStr(DS_Keys,'A0AC',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru3_E3.blp")
    call SaveStr(DS_Keys,'A0AD',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru3_E1.blp")
    call SaveStr(DS_Keys,'A0AE',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru3_E2.blp")
    call SaveStr(DS_Keys,'A0AF',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru3_R.blp")
    call SaveStr(DS_Keys,'A0AG',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru3_T.blp")
    call SaveStr(DS_Keys,'A0AM',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Harribel_Q.blp")
    call SaveStr(DS_Keys,'A0AN',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Harribel_W.blp")
    call SaveStr(DS_Keys,'A0AP',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Harribel_R.blp")
    call SaveStr(DS_Keys,'A0AQ',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Harribel_ER.blp")
    call SaveStr(DS_Keys,'A0AR',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Harribel_T.blp")
    call SaveStr(DS_Keys,'A0AT',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Harribel_E2.blp")
    call SaveStr(DS_Keys,'A0B1',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_Q.blp")
    call SaveStr(DS_Keys,'A0B2',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_W.blp")
    call SaveStr(DS_Keys,'A0B4',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_R.blp")
    call SaveStr(DS_Keys,'A0B5',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_T.blp")
    call SaveStr(DS_Keys,'A0B6',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_T2.blp")
    call SaveStr(DS_Keys,'A0B7',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_W2.blp")
    call SaveStr(DS_Keys,'A0B8',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_G.blp")
    call SaveStr(DS_Keys,'A0BG',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_EE.blp")
    call SaveStr(DS_Keys,'A0BH',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_Q.blp")
    call SaveStr(DS_Keys,'A0BI',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_W.blp")
    call SaveStr(DS_Keys,'A0BJ',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_E.blp")
    call SaveStr(DS_Keys,'A0BM',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_TT.blp")
    call SaveStr(DS_Keys,'A0BN',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_TR.blp")
    call SaveStr(DS_Keys,'A0BP',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_R.blp")
    call SaveStr(DS_Keys,'A0C0',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_Q.blp")
    call SaveStr(DS_Keys,'A0C1',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_Q2.blp")
    call SaveStr(DS_Keys,'A0C2',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_W.blp")
    call SaveStr(DS_Keys,'A0C3',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_RW.blp")
    call SaveStr(DS_Keys,'A0C4',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_E.blp")
    call SaveStr(DS_Keys,'A0C7',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_RT.blp")
    call SaveStr(DS_Keys,'A0CD',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Mahoraga_Q.blp")
    call SaveStr(DS_Keys,'A0CE',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Mahoraga_Q2.blp")
    call SaveStr(DS_Keys,'A0CF',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Mahoraga_W.blp")
    call SaveStr(DS_Keys,'A0CG',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Mahoraga_W2.blp")
    call SaveStr(DS_Keys,'A0CH',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Mahoraga_E.blp")
    call SaveStr(DS_Keys,'A0CI',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Mahoraga_E2.blp")
    call SaveStr(DS_Keys,'A0CJ',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Mahoraga_WE.blp")
    call SaveStr(DS_Keys,'A0CL',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Mahoraga_T.blp")
    call SaveStr(DS_Keys,'A0CM',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Mahoraga_F.blp")
    call SaveStr(DS_Keys,'A0CO',2,"ReplaceableTextures\\CommandButtons\\BTNHero_DarkShiki_G.blp")
    call SaveStr(DS_Keys,'A0D3',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kirito_Q.blp")
    call SaveStr(DS_Keys,'A0D4',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kirito_W.blp")
    call SaveStr(DS_Keys,'A0D5',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kirito_E.blp")
    call SaveStr(DS_Keys,'A0D7',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kirito_R2.blp")
    call SaveStr(DS_Keys,'A0D8',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kirito_T.blp")
    call SaveStr(DS_Keys,'A0D9',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Kirito_T2.blp")
    call SaveStr(DS_Keys,'A0DE',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_Q.blp")
    call SaveStr(DS_Keys,'A0DF',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_W.blp")
    call SaveStr(DS_Keys,'A0DG',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_E.blp")
    call SaveStr(DS_Keys,'A0DH',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_R.blp")
    call SaveStr(DS_Keys,'A0DJ',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_G.blp")
    call SaveStr(DS_Keys,'A0DK',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_TT.blp")
    call SaveStr(DS_Keys,'A0DL',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Asta_Q.blp")
    call SaveStr(DS_Keys,'A0DM',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Asta_W.blp")
    call SaveStr(DS_Keys,'A0DN',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Asta_E.blp")
    call SaveStr(DS_Keys,'A0DO',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Asta_R.blp")
    call SaveStr(DS_Keys,'A0DS',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Asta_Q2.blp")
    call SaveStr(DS_Keys,'A0DT',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Asta_W2.blp")
    call SaveStr(DS_Keys,'A0DU',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Asta_R2.blp")
    call SaveStr(DS_Keys,'A0DV',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Asta_T2.blp")
    call SaveStr(DS_Keys,'A0E2',2,"ReplaceableTextures\\CommandButtons\\BTNMove_Forward.blp")
    call SaveStr(DS_Keys,'A0E7',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Patriot_Q.blp")
    call SaveStr(DS_Keys,'A0E8',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Patriot_W.blp")
    call SaveStr(DS_Keys,'A0EA',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Patriot_R.blp")
    call SaveStr(DS_Keys,'A0EB',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Patriot_T.blp")
    call SaveStr(DS_Keys,'A0EC',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Patriot_T2.blp")
    call SaveStr(DS_Keys,'A0EF',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Patriot_G.blp")
    call SaveStr(DS_Keys,'A0EH',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Brandish_Q.blp")
    call SaveStr(DS_Keys,'A0EI',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Brandish_W.blp")
    call SaveStr(DS_Keys,'A0EK',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Brandish_R.blp")
    call SaveStr(DS_Keys,'A0EL',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Brandish_T.blp")
    call SaveStr(DS_Keys,'A0ES',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_Q.blp")
    call SaveStr(DS_Keys,'A0ET',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_W.blp")
    call SaveStr(DS_Keys,'A0EU',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_W2.blp")
    call SaveStr(DS_Keys,'A0EV',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_E.blp")
    call SaveStr(DS_Keys,'A0EW',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_R.blp")
    call SaveStr(DS_Keys,'A0EX',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_T.blp")
    call SaveStr(DS_Keys,'A0EY',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_F.blp")
    call SaveStr(DS_Keys,'A0F1',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_Q2.blp")
    call SaveStr(DS_Keys,'A0FJ',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Ainz_TQ.blp")
    call SaveStr(DS_Keys,'A0FL',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Ainz_W2.blp")
    call SaveStr(DS_Keys,'A0FM',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Ainz_W3.blp")
    call SaveStr(DS_Keys,'A0FN',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Ainz_TW.blp")
    call SaveStr(DS_Keys,'A0FO',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Ainz_E.blp")
    call SaveStr(DS_Keys,'A0FQ',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Ainz_TE.blp")
    call SaveStr(DS_Keys,'A0FR',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Ainz_R.blp")
    call SaveStr(DS_Keys,'A0FS',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Ainz_TR.blp")
    call SaveStr(DS_Keys,'A0FV',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Ainz_G.blp")
    call SaveStr(DS_Keys,'A0GD',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Raiden_G.blp")
    call SaveStr(DS_Keys,'A0GK',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_Q.blp")
    call SaveStr(DS_Keys,'A0GL',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_Q2.blp")
    call SaveStr(DS_Keys,'A0GN',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_W.blp")
    call SaveStr(DS_Keys,'A0GO',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_TW.blp")
    call SaveStr(DS_Keys,'A0GP',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_E.blp")
    call SaveStr(DS_Keys,'A0GQ',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_R.blp")
    call SaveStr(DS_Keys,'A0GR',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_T.blp")
    call SaveStr(DS_Keys,'A0GT',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_TT.blp")
    call SaveStr(DS_Keys,'A0GW',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_F.blp")
    call SaveStr(DS_Keys,'A0H1',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Toji_W.blp")
    call SaveStr(DS_Keys,'A0H3',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Toji_E.blp")
    call SaveStr(DS_Keys,'A0H4',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Toji_R.blp")
    call SaveStr(DS_Keys,'A0H5',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Toji_T.blp")
    call SaveStr(DS_Keys,'A0H7',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Toji_G.blp")
    call SaveStr(DS_Keys,'A0HG',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Milim_Q.blp")
    call SaveStr(DS_Keys,'A0HH',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Milim_W.blp")
    call SaveStr(DS_Keys,'A0HI',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Milim_W2.blp")
    call SaveStr(DS_Keys,'A0HJ',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Milim_E.blp")
    call SaveStr(DS_Keys,'A0HK',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Milim_R.blp")
    call SaveStr(DS_Keys,'A0HM',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Milim_T2.blp")
    call SaveStr(DS_Keys,'A0I7',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Crocodile_Q.blp")
    call SaveStr(DS_Keys,'A0I8',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Crocodile_W.blp")
    call SaveStr(DS_Keys,'A0I9',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Crocodile_E.blp")
    call SaveStr(DS_Keys,'A0IA',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Crocodile_R.blp")
    call SaveStr(DS_Keys,'A0IC',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Crocodile_T2.blp")
    call SaveStr(DS_Keys,'A0ID',2,"ReplaceableTextures\\CommandButtons\\BTNHero_Crocodile_F.blp")
    // DS_ABILITY_ICONS_END
    loop
        exitwhen pid >= 10
        set DS_PlayerTexture[pid] = "UI\\WOS\\damage-fill-"+I2S(pid)+".tga"
        set pid = pid+1
    endloop
endfunction

// Item and ability paths are generated from the editable object data.
// Morph/combo instance artwork: the button icon that form shows (BTNHero_<Hero>_<caption>).
// "" keeps the ability's own icon (Raiden has no separate T/TT button art).
private function DS_VariantIcon takes integer base, string caption returns string
    local string hero = ""
    if base == StarrkQ_ID or base == StarrkW_ID then
        set hero = "Starrk"
    elseif base == BarraganQ_ID or base == BarraganW_ID then
        set hero = "Barragan"
        if caption == "TQ" then
            set caption = "ETQ"
        endif
    elseif base == AlucardQ_ID or base == AlucardW_ID or base == AlucardE_ID then
        set hero = "Alucard"
    elseif base == HarribelQ_ID or base == HarribelW_ID then
        set hero = "Harribel"
    elseif base == BambiettaQ_ID or base == BambiettaW_ID or base == BambiettaE_ID or base == BambiettaR_ID then
        set hero = "Bambietta"
    endif
    if hero == "" then
        return ""
    endif
    return "ReplaceableTextures\\CommandButtons\\BTNHero_" + hero + "_" + caption + ".blp"
endfunction

private function DS_SourceIcon takes integer sourceId returns string
    local string icon
    local integer base = DS_BaseSource(sourceId)
    local integer unitId = LoadInteger(DS_Origins,sourceId,2)
    local integer variant = LoadInteger(DS_Origins,sourceId,0)
    if variant == 0 then
        set variant = sourceId
    endif
    if HaveSavedInteger(GearDamageVariants,variant,0) then
        if not HaveSavedString(DS_Keys,variant,2) then
            call SaveStr(DS_Keys,variant,2,DS_VariantIcon(base,LoadStr(GearDamageVariants,variant,1)))
        endif
        set icon = LoadStr(DS_Keys,variant,2)
        if icon != "" then
            return icon
        endif
    endif
    if base == -1 then
        if unitId != 0 then
            return BlzGetAbilityIcon(unitId)
        endif
        return "UI\\WOS\\icon-attack.tga"
    elseif base <= -1000000 then
        return BlzGetAbilityIcon(-base)
    endif
    set icon = WUI_InfoSourceIcon(base)
    if icon != "" then
        return icon
    elseif base < 0 then
        return "UI\\WOS\\icon-attack.tga"
    endif
    set sourceId = base
    if HaveSavedString(DS_Keys,sourceId,2) then
        return LoadStr(DS_Keys,sourceId,2)
    endif
    // DS_ITEM_ICONS_BEGIN
    if sourceId == 'I00G' then
        return "ReplaceableTextures\\CommandButtons\\BTNBarrel.blp"
    endif
    if sourceId == 'I00P' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_TsuchikageHut.blp"
    endif
    if sourceId == 'I00S' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_Govnyashka.blp"
    endif
    if sourceId == 'I00W' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_Kurikara.blp"
    endif
    if sourceId == 'I014' then
        return "ReplaceableTextures\\CommandButtons\\BTNItemRockLeeWeights.blp"
    endif
    if sourceId == 'I015' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_RaijinWrath.blp"
    endif
    if sourceId == 'I016' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_Shark.blp"
    endif
    if sourceId == 'I019' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_EarthPower.blp"
    endif
    if sourceId == 'I01N' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_Hiraishin.blp"
    endif
    if sourceId == 'I01P' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_SogyoNoKotowari.blp"
    endif
    if sourceId == 'I01Q' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_RyujinJakka.blp"
    endif
    if sourceId == 'I01S' then
        return "ReplaceableTextures\\CommandButtons\\BTNitem_RedCup.blp"
    endif
    if sourceId == 'I01U' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_RedFlower.blp"
    endif
    if sourceId == 'I01V' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_TuskBarrel.blp"
    endif
    if sourceId == 'I01X' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_Nejibana.blp"
    endif
    if sourceId == 'I01Y' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_Gonryomaru.blp"
    endif
    if sourceId == 'I023' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_QuicyCross.blp"
    endif
    if sourceId == 'I02C' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_TsuchikageHutEvolve.blp"
    endif
    if sourceId == 'I02G' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_MeraMera.blp"
    endif
    if sourceId == 'I02H' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_MirrorYata.blp"
    endif
    if sourceId == 'I02J' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_GutsArmor.blp"
    endif
    if sourceId == 'I02L' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_Rhitta.blp"
    endif
    if sourceId == 'I02P' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_ShikiKnife.blp"
    endif
    if sourceId == 'I02S' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_Tachikaze.blp"
    endif
    if sourceId == 'I02T' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_ElectroSlime.blp"
    endif
    if sourceId == 'I03E' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_FireSlime.blp"
    endif
    if sourceId == 'I03F' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_WaterSlime.blp"
    endif
    if sourceId == 'I03W' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_SakuraSesshou.blp"
    endif
    if sourceId == 'I03X' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_SwordLostvayne.blp"
    endif
    if sourceId == 'I03Y' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_Murasame.blp"
    endif
    if sourceId == 'I042' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_ShikiKnifeEvolved.blp"
    endif
    if sourceId == 'I044' then
        return "ReplaceableTextures\\CommandButtons\\BTNItem_DeathNote.blp"
    endif
    // DS_ITEM_ICONS_END
    return BlzGetAbilityIcon(sourceId)
endfunction

// Source amount colour: red physical, blue magical, gold when unknown (environment).
private function DS_KindColor takes integer sourceId returns string
    local integer kind = LoadInteger(DS_SourceKind,sourceId,0)
    if kind == 1 then
        return "|cff5fb4ff"
    elseif kind == 2 then
        return "|cffff5a4a"
    endif
    return "|cffffdc85"
endfunction

// Same colours as DS_KindColor, as a frame text colour.
private function DS_KindArgb takes integer kind returns integer
    if kind == 1 then
        return BlzConvertColor(255,95,180,255)
    elseif kind == 2 then
        return BlzConvertColor(255,255,90,74)
    endif
    return BlzConvertColor(255,255,220,133)
endfunction

private function DS_ModeName takes integer page returns string
    if page == 0 then
        return "Round"
    elseif page == 1 then
        return "Game"
    elseif page == 2 then
        return "Session"
    endif
    return "Previous"
endfunction

private function DS_AmountLabel takes real amount returns string
    local integer rounded
    local string suffix
    if amount > 0.0 and amount < 1.0 then
        return "<1"
    endif
    if amount < 999.5 then
        return I2S(R2I(amount+0.5))
    elseif amount < 999500.0 then
        set amount = amount/1000.0
        set suffix = "k"
    elseif amount < 999500000.0 then
        set amount = amount/1000000.0
        set suffix = "m"
    elseif amount < 999500000000.0 then
        set amount = amount/1000000000.0
        set suffix = "b"
    else
        set amount = amount/1000000000000.0
        set suffix = "t"
    endif
    // Four characters at most in normal game ranges, including 9.95k -> 10k.
    set rounded = R2I(amount*10.0+0.5)
    if rounded < 100 then
        return I2S(rounded/10)+"."+I2S(ModuloInteger(rounded,10))+suffix
    endif
    return I2S(R2I(amount+0.5))+suffix
endfunction

private function DS_Active takes integer pid returns boolean
    return GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING
endfunction

private function DS_HeroName takes integer pid returns string
    if Hero[pid] != null then
        return GetUnitName(Hero[pid])
    endif
    return "No hero"
endfunction

// Fixed ten-player insertion sort. Tie order is stable by player slot.
private function DS_RankPlayers takes nothing returns integer
    local integer pid = 0
    local integer count = 0
    local integer pos
    loop
        exitwhen pid >= 10
        if DS_Active(pid) then
            set pos = count
            loop
                exitwhen pos == 0
                exitwhen DamageStatsTotal(DS_Order[pos-1],DS_Page+DS_Direction*4) >= DamageStatsTotal(pid,DS_Page+DS_Direction*4)
                set DS_Order[pos] = DS_Order[pos-1]
                set pos = pos-1
            endloop
            set DS_Order[pos] = pid
            set count = count+1
        endif
        set pid = pid+1
    endloop
    return count
endfunction

// Keep only `limit` newest distinct positive sources. No sorting occurs on a hit.
private function DS_SelectRecent takes integer bucket, integer limit returns integer
    local integer i = 0
    local integer j
    local integer k
    local integer sourceId
    local integer stamp
    loop
        exitwhen i >= limit
        set DS_Recent[i] = 0
        set i = i+1
    endloop
    set i = 1
    loop
        exitwhen i > DS_Count[bucket]
        set sourceId = LoadInteger(DS_Data,bucket,i)
        if LoadReal(DS_Data,bucket,sourceId) > 0.0 then
            set stamp = LoadInteger(DS_Data,bucket,sourceId)
            set j = 0
            loop
                exitwhen j >= limit
                exitwhen DS_Recent[j] == 0 or LoadInteger(DS_Data,bucket,DS_Recent[j]) < stamp
                set j = j+1
            endloop
            if j < limit then
                set k = limit-1
                loop
                    exitwhen k <= j
                    set DS_Recent[k] = DS_Recent[k-1]
                    set k = k-1
                endloop
                set DS_Recent[j] = sourceId
            endif
        endif
        set i = i+1
    endloop
    set j = 0
    loop
        exitwhen j >= limit or DS_Recent[j] == 0
        set j = j+1
    endloop
    return j
endfunction

// Compares array copies (DS_SortValue), not hashtable reads.
private function DS_SiftSources takes integer bucket, integer root, integer count returns nothing
    local integer child = root*2+1
    local integer value = DS_SourceOrder[root]
    local real key = DS_SortValue[root]
    loop
        exitwhen child >= count
        if child+1 < count and DS_SortValue[child+1] < DS_SortValue[child] then
            set child = child+1
        endif
        exitwhen key <= DS_SortValue[child]
        set DS_SourceOrder[root] = DS_SourceOrder[child]
        set DS_SortValue[root] = DS_SortValue[child]
        set root = child
        set child = root*2+1
    endloop
    set DS_SourceOrder[root] = value
    set DS_SortValue[root] = key
endfunction

// Min-heap of `count` entries -> descending order (biggest first), in place.
private function DS_HeapSortDesc takes integer bucket, integer count returns nothing
    local integer j = count/2-1
    local integer swap
    local real swapValue
    loop
        exitwhen j < 0
        call DS_SiftSources(bucket,j,count)
        set j = j-1
    endloop
    set j = count-1
    loop
        exitwhen j <= 0
        set swap = DS_SourceOrder[j]
        set DS_SourceOrder[j] = DS_SourceOrder[0]
        set DS_SourceOrder[0] = swap
        set swapValue = DS_SortValue[j]
        set DS_SortValue[j] = DS_SortValue[0]
        set DS_SortValue[0] = swapValue
        call DS_SiftSources(bucket,0,j)
        set j = j-1
    endloop
endfunction

// In-place heap sort keeps long training sessions bounded at O(n log n).
private function DS_SortSources takes integer bucket returns integer
    local integer count = 0
    local integer i = 1
    local integer sourceId
    local real amount
    loop
        exitwhen i > DS_Count[bucket]
        set sourceId = LoadInteger(DS_Data,bucket,i)
        set amount = LoadReal(DS_Data,bucket,sourceId)
        if amount > 0.0 then
            set DS_SourceOrder[count] = sourceId
            set DS_SortValue[count] = amount
            set count = count+1
        endif
        set i = i+1
    endloop
    call DS_HeapSortDesc(bucket,count)
    return count
endfunction

// Biggest `limit` sources first (descending damage). A bounded min-heap keeps only
// the current top `limit`, so a row costs O(n log limit) instead of a full sort.
private function DS_SelectTop takes integer bucket, integer limit returns integer
    local integer count = 0
    local integer i = 1
    local integer j
    local integer sourceId
    local real amount
    loop
        exitwhen i > DS_Count[bucket]
        set sourceId = LoadInteger(DS_Data,bucket,i)
        set amount = LoadReal(DS_Data,bucket,sourceId)
        if amount > 0.0 then
            if count < limit then
                set DS_SourceOrder[count] = sourceId
                set DS_SortValue[count] = amount
                set count = count+1
                if count == limit then
                    set j = count/2-1
                    loop
                        exitwhen j < 0
                        call DS_SiftSources(bucket,j,count)
                        set j = j-1
                    endloop
                endif
            elseif amount > DS_SortValue[0] then
                set DS_SourceOrder[0] = sourceId
                set DS_SortValue[0] = amount
                call DS_SiftSources(bucket,0,count)
            endif
        endif
        set i = i+1
    endloop
    call DS_HeapSortDesc(bucket,count)
    set i = 0
    loop
        exitwhen i >= limit
        if i < count then
            set DS_Recent[i] = DS_SourceOrder[i]
        else
            set DS_Recent[i] = 0
        endif
        set i = i+1
    endloop
    return count
endfunction

// Cell geometry is applied only when a layout changes, never on a data tick.
private function DS_PlaceCell takes integer slot, framehandle row, real x, real y, real pitch, real cell, real size, real font returns nothing
    call BlzFrameClearAllPoints(DS_Icon[slot])
    call BlzFrameSetPoint(DS_Icon[slot],FRAMEPOINT_TOPLEFT,row,FRAMEPOINT_TOPLEFT,x,y)
    call BlzFrameSetSize(DS_Icon[slot],pitch,cell)
    call BlzFrameSetSize(DS_Art[slot],size,size)
    call BlzFrameClearAllPoints(DS_Number[slot])
    call BlzFrameSetPoint(DS_Number[slot],FRAMEPOINT_TOPLEFT,DS_Icon[slot],FRAMEPOINT_TOPLEFT,0.000,-size)
    call BlzFrameSetPoint(DS_Number[slot],FRAMEPOINT_BOTTOMRIGHT,DS_Icon[slot],FRAMEPOINT_BOTTOMRIGHT,0.000,0.000)
    call BlzFrameSetFont(DS_Number[slot],"Fonts\\FRIZQT__.TTF",font,0)
endfunction

// Details rows: 12 narrow cells per line, a second smaller line for 13-24 sources.
private function DS_SetRowLines takes integer r, integer lines returns nothing
    local integer j = 0
    local real cell = 0.020
    local real size = 0.0132
    local real font = 0.0065
    if DS_RowLines[r] == lines then
        return
    endif
    set DS_RowLines[r] = lines
    if lines > 1 then
        // Two lines: smaller art and digits so the second row stays inside the frame.
        set cell = 0.018
        set size = 0.0108
        set font = 0.0052
    endif
    call BlzFrameSetSize(DS_Row[r],0.336,0.010+I2R(lines)*cell)
    loop
        exitwhen j >= DS_CELLS
        call DS_PlaceCell(r*DS_CELLS+j,DS_Row[r],0.0312+I2R(ModuloInteger(j,DS_LINE))*DS_PITCH,-0.010-I2R(j/DS_LINE)*cell,DS_PITCH,cell,size,font)
        set j = j+1
    endloop
endfunction

private function DS_RowHeight takes integer r returns real
    if DS_RowLines[r] > 1 then
        return 0.046
    endif
    return 0.030
endfunction

// Compact panel: Expand shows portraits and sources, Minimize keeps only bars.
private function DS_LayoutSmall takes nothing returns nothing
    local integer r = 0
    local integer j
    local integer slot
    local real h = 0.0272
    local real gap = 0.0008
    local real bx = 0.029
    local real bw = 0.161
    if DS_Minimized then
        set h = 0.012
        set gap = 0.002
        set bx = 0.0015
        set bw = 0.1885
        call WUI_SetButtonCaption(DS_Tab[2],"Expand")
    else
        call WUI_SetButtonCaption(DS_Tab[2],"Minimize")
    endif
    loop
        exitwhen r >= 10
        call BlzFrameSetSize(DS_Row[r],0.190,h)
        call BlzFrameClearAllPoints(DS_Row[r])
        call BlzFrameSetPoint(DS_Row[r],FRAMEPOINT_TOPLEFT,DS_Small,FRAMEPOINT_TOPLEFT,0.000,-0.0385-I2R(r)*(h+gap))
        call BlzFrameClearAllPoints(DS_BarBack[r])
        call BlzFrameSetPoint(DS_BarBack[r],FRAMEPOINT_TOPLEFT,DS_Row[r],FRAMEPOINT_TOPLEFT,bx,0.000)
        call BlzFrameSetSize(DS_BarBack[r],bw,0.012)
        call BlzFrameSetSize(DS_Label[r],bw-0.050,0.012)
        call WUI_SetFillWidth(DS_Fill[r],bw)
        if DS_Minimized then
            // Hidden once here; minimized ticks never touch portraits or sources.
            call WUI_Show(DS_Portrait[r],false)
            set j = 0
            loop
                exitwhen j >= DS_SMALL
                set slot = r*DS_CELLS+j
                call WUI_Show(DS_Icon[slot],false)
                set DS_SlotSource[slot] = 0
                set j = j+1
            endloop
        endif
        set r = r+1
    endloop
    set DS_SmallPitch = h+gap
    set DS_SmallGap = gap
    set DS_SmallHeight = -1.0
endfunction

private function DS_ClearHover takes nothing returns nothing
    local integer slot = DS_HoverSlot
    if slot >= 0 then
        // Drop the engine flag too: a hidden panel must not report a stale hover.
        if DS_HoverDetail then
            call BlzFrameSetVisible(DS_RowSensor[slot/DS_CELLS],false)
        elseif DS_Sensor[slot] != null then
            call BlzFrameSetVisible(DS_Sensor[slot],false)
        endif
    endif
    set DS_HoverSlot = -1
    set DS_HoverDetail = false
    call BlzFrameSetVisible(DS_Tooltip,false)
endfunction

private function DS_UpdateTooltip takes nothing returns nothing
    local integer slot = DS_HoverSlot
    local integer bucket
    local integer sourceId
    local real amount
    local string direction = "dealt"
    local string owner = ""
    local integer actorPid
    local integer actorType
    local integer levelPid
    if slot < 0 or slot >= 20*DS_CELLS then
        return
    endif
    if DS_HoverDetail then
        set sourceId = DS_RowSource[slot/DS_CELLS]
    else
        set sourceId = DS_SlotSource[slot]
    endif
    set levelPid = DS_RowPid[slot/DS_CELLS]
    set bucket = DS_Direction*40+DS_Page*10+levelPid
    set amount = LoadReal(DS_Data,bucket,sourceId)
    if sourceId == 0 or amount <= 0.0 then
        call DS_ClearHover()
        return
    endif
    if DS_Direction == 1 then
        set direction = "taken"
        // Taken: the level belongs to the attacker's hero, unknown for environment.
        set levelPid = -1
        if LoadInteger(DS_Origins,sourceId,0) != 0 then
            set actorPid = LoadInteger(DS_Origins,sourceId,1)
            set actorType = LoadInteger(DS_Origins,sourceId,2)
            set levelPid = actorPid
            if actorPid < 10 then
                set owner = "|nFrom: "+GetPlayerColorString(Player(actorPid))+GetPlayerName(Player(actorPid))+"|r ("+GetObjectName(actorType)+")"
            else
                set owner = "|nFrom: Environment ("+GetObjectName(actorType)+")"
            endif
        endif
    endif
    // Only text changes on ticks. The hover poll anchors the box ONCE.
    call BlzFrameSetText(DS_TooltipText,"|cffd5b876"+DS_SourceName(sourceId)+"|r"+DS_LevelCaption(sourceId,levelPid)+"|n"+DS_ModeName(DS_Page)+": "+R2SW(amount,1,1)+" damage "+direction+"|n"+R2SW(amount/RMaxBJ(0.0001,DS_Total[bucket])*100.0,1,1)+"% of player damage"+owner)
endfunction

private function DS_OwnerCaption takes integer sourceId returns string
    local integer pid
    if LoadInteger(DS_Origins,sourceId,0) == 0 then
        return ""
    endif
    set pid = LoadInteger(DS_Origins,sourceId,1)
    if pid < 10 then
        return " | "+GetPlayerColorString(Player(pid))+GetPlayerName(Player(pid))+"|r"
    endif
    return " | Environment"
endfunction

private function DS_FitLarge takes real height returns nothing
    if DS_LargeHeight != height then
        call BlzFrameSetSize(DS_Large,0.360,height)
        set DS_LargeHeight = height
    endif
endfunction

private function DS_RenderView takes integer view, integer count returns nothing
    local integer row = 0
    local integer r
    local integer slot
    local integer j
    local integer pid
    local integer sourceId
    local integer bucket = 0
    local integer sourceCount = 0
    local integer sourceIndex
    local integer limit = DS_SMALL
    local boolean detail = view == 1 and DS_Selected >= 0
    local boolean cells = not (view == 0 and DS_Minimized)
    local boolean rowChanged
    local boolean shown
    local integer mode
    local integer rank = 0
    local real amount
    local real maximum = 1.00
    local real height = 0.0
    local string texture
    local string label
    if view == 1 then
        set limit = DS_CELLS
    endif
    if count > 0 then
        set maximum = RMaxBJ(0.0001,DamageStatsTotal(DS_Order[0],DS_Page+DS_Direction*4))
    endif
    if detail then
        set bucket = DS_Direction*40+DS_Page*10+DS_Selected
        set sourceCount = DS_SortSources(bucket)
        set DS_SourcePage = IMinBJ(DS_SourcePage,IMaxBJ(0,(sourceCount-1)/DS_SOURCES_PER_PAGE))
    elseif view == 1 then
        set DS_PlayerPage = IMinBJ(DS_PlayerPage,IMaxBJ(0,(count-1)/DS_PLAYERS_PER_PAGE))
    endif
    loop
        exitwhen row >= 10
        set r = view*10+row
        set pid = -1
        set rank = row
        if detail then
            if row == 0 then
                set pid = DS_Selected
                set DS_Recent[0] = 0
            else
                set sourceIndex = DS_SourcePage*DS_SOURCES_PER_PAGE+row-1
                if sourceIndex < sourceCount then
                    set pid = DS_Selected
                    set DS_Recent[0] = DS_SourceOrder[sourceIndex]
                endif
            endif
        elseif view == 1 then
            set rank = DS_PlayerPage*DS_PLAYERS_PER_PAGE+row
            if row < DS_PLAYERS_PER_PAGE and rank < count then
                set pid = DS_Order[rank]
            endif
        elseif row < count then
            set pid = DS_Order[row]
        endif
        set rowChanged = DS_RowPid[r] != pid
        set DS_RowPid[r] = pid
        if BlzFrameIsVisible(DS_Row[r]) != (pid >= 0) then
            call BlzFrameSetVisible(DS_Row[r],pid >= 0)
        endif
        if pid >= 0 then
            set bucket = DS_Direction*40+DS_Page*10+pid
            set texture = DS_PlayerTexture[pid]
            if cells and not detail then
                if DS_Mag[bucket] > DS_Phys[bucket] then
                    set texture = "UI\\WOS\\damage-fill-1.tga" // blue: magical
                elseif DS_Phys[bucket] > 0.0 then
                    set texture = "UI\\WOS\\damage-fill-0.tga" // red: physical
                endif
            endif
            if detail and row == 0 then
                // Summary bar: red physical part over a blue (magical) back.
                set texture = "UI\\WOS\\damage-fill-0.tga"
                set label = "UI\\WOS\\damage-fill-1.tga"
                if DS_Mag[bucket]+DS_Phys[bucket] <= 0.0 then
                    set label = "UI\\WOS\\bar-back.tga"
                endif
            else
                set label = "UI\\WOS\\bar-back.tga"
            endif
            if DS_RowBackTex[r] != label then
                call BlzFrameSetTexture(DS_BarBack[r],label,0,true)
                set DS_RowBackTex[r] = label
            endif
            if rowChanged or DS_RowFillTex[r] != texture then
                call BlzFrameSetTexture(DS_Fill[r],texture,0,true)
                set DS_RowFillTex[r] = texture
            endif
            call WUI_Show(DS_Portrait[r],(not detail and cells) or (detail and row == 0))
            call WUI_Show(DS_SourceRowIcon[r],detail and row > 0)
            call WUI_Show(DS_SubLabel[r],detail)
            if detail and row == 0 then
                call DS_SetRowLines(r,1)
                set amount = DS_Mag[bucket]+DS_Phys[bucket]
                set label = "|cfff3ead4"+GetPlayerName(Player(pid))+"|r  |cffd5b876"+DS_ModeName(DS_Page)+"|r"
                call WUI_SetValue(DS_Fill[r],DS_Phys[bucket]/RMaxBJ(0.0001,amount)*100.0)
                call WUI_SetText(DS_Value[r],"|cffffdc85"+DS_AmountLabel(DS_Total[bucket])+"|r")
                call WUI_SetText(DS_SubLabel[r],"|cffff6b6bPhysical "+R2SW(DS_Phys[bucket]/RMaxBJ(0.0001,amount)*100.0,1,1)+"%|r  |  |cff6bb0ffMagical "+R2SW(DS_Mag[bucket]/RMaxBJ(0.0001,amount)*100.0,1,1)+"%|r")
                set texture = "UI\\WOS\\slot-empty.tga"
                if Hero[pid] != null then
                    set texture = BlzGetAbilityIcon(GetUnitTypeId(Hero[pid]))
                endif
                if texture == null or texture == "" then
                    set texture = "UI\\WOS\\slot-empty.tga"
                endif
                if DS_RowPortrait[r] != texture then
                    call BlzFrameSetTexture(DS_Portrait[r],texture,0,false)
                    set DS_RowPortrait[r] = texture
                endif
                set DS_RowSource[r] = 0
            elseif detail then
                call DS_SetRowLines(r,1)
                set sourceId = DS_Recent[0]
                set amount = LoadReal(DS_Data,bucket,sourceId)
                set label = "|cfff3ead4"+DS_SourceName(sourceId)+"|r"
                call WUI_SetValue(DS_Fill[r],amount/RMaxBJ(0.0001,DS_Total[bucket])*100.0)
                if DS_RowSource[r] != sourceId then
                    call BlzFrameSetTexture(DS_SourceRowArt[r],DS_SourceIcon(sourceId),0,sourceId == -1)
                    set DS_RowSource[r] = sourceId
                endif
                call WUI_SetText(DS_Value[r],DS_KindColor(sourceId)+DS_AmountLabel(amount)+"|r")
                call WUI_SetText(DS_SubLabel[r],"|cff8bc5e8"+R2SW(amount/RMaxBJ(0.0001,DS_Total[bucket])*100.0,1,1)+"%|r"+DS_OwnerCaption(sourceId))
            else
                if cells then
                    set sourceCount = DS_SelectTop(bucket,limit)
                    if view == 1 then
                        call DS_SetRowLines(r,1)
                    endif
                endif
                set label = "|cfff3ead4"+I2S(rank+1)+". "+GetPlayerName(Player(pid))+"|r"
                call WUI_SetValue(DS_Fill[r],DS_Total[bucket]/maximum*100.0)
                call WUI_SetText(DS_Value[r],"|cffffdc85"+DS_AmountLabel(DS_Total[bucket])+"|r")
                if cells then
                    set texture = "UI\\WOS\\slot-empty.tga"
                    if Hero[pid] != null then
                        set texture = BlzGetAbilityIcon(GetUnitTypeId(Hero[pid]))
                    endif
                    if texture == null or texture == "" then
                        set texture = "UI\\WOS\\slot-empty.tga"
                    endif
                    if DS_RowPortrait[r] != texture then
                        call BlzFrameSetTexture(DS_Portrait[r],texture,0,false)
                        set DS_RowPortrait[r] = texture
                    endif
                endif
            endif
            call WUI_SetText(DS_Label[r],label)
            if view == 1 then
                set height = height+DS_RowHeight(r)+0.001
            endif
        endif
        // Minimized compact rows skip the whole source pass (hidden in DS_LayoutSmall).
        if cells and (pid >= 0 or rowChanged) then
            set j = 0
            loop
                exitwhen j >= limit
                set slot = r*DS_CELLS+j
                set sourceId = 0
                if pid >= 0 and not detail then
                    set sourceId = DS_Recent[j]
                endif
                // Newest sources are contiguous: the rest is already empty.
                exitwhen sourceId == 0 and DS_SlotSource[slot] == 0
                set shown = sourceId != 0
                // Hide always: IsVisible is false under a hidden row and would skip it.
                if not shown or not BlzFrameIsVisible(DS_Icon[slot]) then
                    call BlzFrameSetVisible(DS_Icon[slot],shown)
                endif
                if shown then
                    if DS_SlotSource[slot] != sourceId then
                        call BlzFrameSetTexture(DS_Art[slot],DS_SourceIcon(sourceId),0,sourceId == -1)
                    endif
                    // Colour through the frame, text is only the short label: no "|cff..1.2k|r"
                    // variants piling up in the string table every redraw.
                    set mode = LoadInteger(DS_SourceKind,sourceId,0)
                    if DS_SlotColor[slot] != mode+1 then
                        call BlzFrameSetTextColor(DS_Number[slot],DS_KindArgb(mode))
                        set DS_SlotColor[slot] = mode+1
                    endif
                    call WUI_SetText(DS_Number[slot],DS_AmountLabel(LoadReal(DS_Data,bucket,sourceId)))
                endif
                set DS_SlotSource[slot] = sourceId
                set j = j+1
            endloop
        endif
        set row = row+1
    endloop
    if view == 0 then
        set height = 0.0385+I2R(IMaxBJ(count,1))*DS_SmallPitch-DS_SmallGap+0.0205
        if DS_SmallHeight != height then
            call BlzFrameSetSize(DS_Small,0.190,height)
            set DS_SmallHeight = height
        endif
    else
        if height <= 0.0 then
            set height = 0.031
        endif
        call DS_FitLarge(0.090+height)
        if detail then
            call WUI_SetText(DS_Heading,"|cffd5b876SOURCE|r")
            call WUI_SetText(DS_HeadingRecent,"|cff8bc5e8DAMAGE SHARE|r")
            call WUI_SetText(DS_Footer,GetPlayerName(Player(DS_Selected))+"   Sources: "+I2S(DS_SourcePage+1)+" / "+I2S(IMaxBJ(1,(sourceCount+DS_SOURCES_PER_PAGE-1)/DS_SOURCES_PER_PAGE)))
        else
            call WUI_SetText(DS_Heading,"|cffd5b876PLAYER|r")
            call WUI_SetText(DS_HeadingRecent,"|cff8bc5e8TOP SOURCES|r")
            if DS_Page == 1 then
                call WUI_SetText(DS_Footer,"Game: |cffffcc00"+WUI_GetHotkeyName(WUI_HOTKEY_CLEAR,GetPlayerId(GetLocalPlayer()))+"|r resets your counter, |cffffcc00"+WUI_GetHotkeyName(WUI_HOTKEY_LOAD,GetPlayerId(GetLocalPlayer()))+"|r restores game totals.")
            else
                call WUI_SetText(DS_Footer,"Click a player for sources.   Players: "+I2S(DS_PlayerPage+1)+" / "+I2S(IMaxBJ(1,(count+DS_PLAYERS_PER_PAGE-1)/DS_PLAYERS_PER_PAGE)))
            endif
        endif
        call BlzFrameSetVisible(DS_Back,detail)
        if detail then
            call BlzFrameSetVisible(DS_Previous,DS_SourcePage > 0)
            call BlzFrameSetVisible(DS_Next,(DS_SourcePage+1)*DS_SOURCES_PER_PAGE < sourceCount)
        else
            call BlzFrameSetVisible(DS_Previous,DS_PlayerPage > 0)
            call BlzFrameSetVisible(DS_Next,(DS_PlayerPage+1)*DS_PLAYERS_PER_PAGE < count)
        endif
    endif
endfunction

// Game tab tooltip: the counter keys are rebindable, so the text shows the live names.
private function DS_RefreshGameTips takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    local string keys = WUI_GetHotkeyName(WUI_HOTKEY_CLEAR,pid)+"/"+WUI_GetHotkeyName(WUI_HOTKEY_LOAD,pid)
    local string text
    local integer i = 0
    if keys == DS_GameTipKeys then
        return
    endif
    set DS_GameTipKeys = keys
    set text = "|cffd5b876GAME|r|nYour counter for this game.|n|cffffcc00"+WUI_GetHotkeyName(WUI_HOTKEY_CLEAR,pid)+"|r: reset it to zero.|n|cffffcc00"+WUI_GetHotkeyName(WUI_HOTKEY_LOAD,pid)+"|r: restore the real game totals."
    loop
        exitwhen i >= 7
        if DS_GameTip[i] != null then
            call BlzFrameSetText(DS_GameTip[i],text)
        endif
        set i = i+1
    endloop
endfunction

private function DS_LayoutViewport takes nothing returns nothing
    local real right = WUI_ScreenRight()
    if DS_ScreenRight != right then
        set DS_ScreenRight = right
        call BlzFrameClearAllPoints(DS_Small)
        call BlzFrameSetAbsPoint(DS_Small,FRAMEPOINT_TOPLEFT,0.802-right,0.581)
        call BlzFrameClearAllPoints(DS_Toggle)
        call BlzFrameSetAbsPoint(DS_Toggle,FRAMEPOINT_TOPLEFT,0.802-right,0.598)
    endif
endfunction

private function DS_Tick takes nothing returns nothing
    local integer count
    local boolean rosterChanged = false
    local boolean active
    local integer heroId
    local integer pid = 0
    local integer i = 0
    local integer mode
    local boolean small
    local boolean large
    if not DS_Ready then
        return
    endif
    // Synced part: every client folds the hit buffer at the same tick, before any local check.
    set DS_FlushTicks = DS_FlushTicks - 1
    if DS_FlushTicks <= 0 then
        set DS_FlushTicks = 10
        call DamageStatsFlush()
    endif
    set DS_DamageTicks = IMaxBJ(0, DS_DamageTicks - 1)
    call DS_LayoutViewport()
    set small = WUI_TopShown() and BlzFrameIsVisible(DS_Small)
    set large = WUI_TopShown() and BlzFrameIsVisible(DS_Large)
    if (small and not DS_WasSmall) or (large and not DS_WasLarge) then
        set DS_LastVersion = -1
    endif
    set DS_WasSmall = small
    set DS_WasLarge = large
    if DS_HoverSlot >= 0 then
        if (DS_HoverSlot < 10*DS_CELLS and not small) or (DS_HoverSlot >= 10*DS_CELLS and not large) then
            call DS_ClearHover()
        else
            if DS_DamageTicks == 0 then
                call DS_UpdateTooltip()
                set DS_DamageTicks = 10
            endif
            // Keep the source under the mouse fixed until the poll sees it leave.
            if DS_HoverSlot >= 0 then
                return
            endif
        endif
    endif
    if not small and not large then
        return
    endif
    loop
        exitwhen pid >= 10
        set active = DS_Active(pid)
        set heroId = GetUnitTypeId(Hero[pid])
        if DS_LastHero[pid] != heroId or DS_LastActive[pid] != active then
            set rosterChanged = true
            set DS_LastHero[pid] = heroId
            set DS_LastActive[pid] = active
        endif
        set pid = pid+1
    endloop
    if DS_LastVersion == DS_Version and not rosterChanged then
        return
    endif
    // At most one damage-only redraw per5 seconds; opening/paging/roster stays immediate.
    if DS_DamageTicks > 0 and not rosterChanged and DS_LastVersion >= 0 then
        return
    endif
    set DS_DamageTicks = 10
    set DS_LastVersion = DS_Version
    if DS_Selected >= 0 and not DS_Active(DS_Selected) then
        set DS_Selected = -1
        set DS_SourcePage = 0
    endif
    set count = DS_RankPlayers()
    call DS_RefreshGameTips()
    if DS_TabPage != DS_Page then
        loop
            exitwhen i >= 7
            set mode = DS_TabMode[i]
            if mode == DS_Page then
                call WUI_SetButtonCaption(DS_Tab[i],"|cffd5b876"+DS_ModeName(mode)+"|r")
            elseif mode >= 0 then
                call WUI_SetButtonCaption(DS_Tab[i],DS_ModeName(mode))
            endif
            set i = i+1
        endloop
        set DS_TabPage = DS_Page
    endif
    if DS_TabDirection != DS_Direction then
        set i = 0
        loop
            exitwhen i >= 4
            if ModuloInteger(i,2) == 0 then
                call WUI_SetButtonCaption(DS_DirTab[i],"Dealt")
            else
                call WUI_SetButtonCaption(DS_DirTab[i],"Taken")
            endif
            call WUI_SetButtonSelected(DS_DirTab[i],ModuloInteger(i,2) == DS_Direction)
            set i = i+1
        endloop
        set DS_TabDirection = DS_Direction
    endif
    if small then
        call DS_RenderView(0,count)
    endif
    if large then
        call DS_RenderView(1,count)
    endif
endfunction

// Hover without frame mouse events: those are network-synced and made the cursor
// stutter. Each source control owns an empty engine tooltip ("sensor"); the engine
// shows it while the mouse is over the control; a 0.10 s local poll reads that flag.
private function DS_ScanView takes integer view returns integer
    local integer row = 0
    local integer r
    local integer j
    local integer slot
    local integer limit = DS_SMALL
    if view == 1 then
        set limit = DS_CELLS
    endif
    loop
        exitwhen row >= 10
        set r = view*10+row
        exitwhen DS_RowPid[r] < 0
        if view == 1 and DS_Selected >= 0 then
            if BlzFrameIsVisible(DS_RowSensor[r]) then
                set DS_HoverDetail = true
                return r*DS_CELLS
            endif
        else
            set j = 0
            loop
                exitwhen j >= limit
                set slot = r*DS_CELLS+j
                exitwhen DS_SlotSource[slot] == 0
                if BlzFrameIsVisible(DS_Sensor[slot]) then
                    set DS_HoverDetail = false
                    return slot
                endif
                set j = j+1
            endloop
        endif
        set row = row+1
    endloop
    return -1
endfunction

private function DS_Poll takes nothing returns nothing
    local integer slot = DS_HoverSlot
    local boolean small
    local boolean large
    if not DS_Ready then
        return
    endif
    set small = WUI_TopShown() and BlzFrameIsVisible(DS_Small) and not DS_Minimized
    set large = WUI_TopShown() and BlzFrameIsVisible(DS_Large)
    if slot >= 0 then
        if (slot < 10*DS_CELLS and small) or (slot >= 10*DS_CELLS and large) then
            if DS_HoverDetail then
                if BlzFrameIsVisible(DS_RowSensor[slot/DS_CELLS]) and BlzFrameIsVisible(DS_SourceRowIcon[slot/DS_CELLS]) then
                    return
                endif
            elseif BlzFrameIsVisible(DS_Sensor[slot]) and BlzFrameIsVisible(DS_Icon[slot]) then
                return
            endif
        endif
        call DS_ClearHover()
        set DS_LastVersion = -1
    endif
    if not small and not large then
        return
    endif
    set slot = -1
    if large then
        set slot = DS_ScanView(1)
    endif
    if slot < 0 and small then
        set slot = DS_ScanView(0)
    endif
    if slot >= 0 then
        set DS_HoverSlot = slot
        call BlzFrameClearAllPoints(DS_Tooltip)
        // Fixed panel-side tooltip: never overlaps its source/next row.
        if slot < 10*DS_CELLS then
            call BlzFrameSetPoint(DS_Tooltip,FRAMEPOINT_TOPLEFT,DS_Small,FRAMEPOINT_TOPRIGHT,0.004,0.000)
        else
            call BlzFrameSetPoint(DS_Tooltip,FRAMEPOINT_TOPLEFT,DS_Large,FRAMEPOINT_BOTTOMLEFT,0.000,-0.004)
        endif
        call DS_UpdateTooltip()
        call BlzFrameSetVisible(DS_Tooltip,DS_HoverSlot >= 0)
    endif
endfunction

// Local: show/hide the compact panel (toggle bar click and the rebindable hotkey).
private function DS_ToggleSmall takes nothing returns nothing
    if DS_PickHidden then
        return
    endif
    call DS_ClearHover()
    call BlzFrameSetVisible(DS_Small,not BlzFrameIsVisible(DS_Small))
    set DS_LastVersion = -1
    call DS_Tick()
endfunction

private function DS_OnKey takes nothing returns nothing
    local player p = GetTriggerPlayer()
    if DS_Ready and GetLocalPlayer() == p and BlzGetTriggerPlayerKey() == WUI_GetHotkey(WUI_HOTKEY_DAMAGE,GetPlayerId(p)) then
        call DS_ToggleSmall()
    endif
    set p = null
endfunction

private function DS_Click takes nothing returns nothing
    local integer action = LoadInteger(DS_Keys,GetHandleId(BlzGetTriggerFrame()),0)
    if action == 0 then
        // Source cells are not registered here. Clean unknown clicks.
        call WUI_ResetClickedButtonFocus()
        return
    endif
    if action == 10 or (action >= 20 and action < 40) then
        call WUI_EnterExclusiveWindow(-1,GetTriggerPlayer())
    endif
    if GetLocalPlayer() == GetTriggerPlayer() and DS_Ready then
        call DS_ClearHover()
        if action >= 1 and action <= 4 then
            set DS_Page = action-1
            set DS_SourcePage = 0
        elseif action == 15 then
            call BlzFrameSetVisible(DS_Small,not BlzFrameIsVisible(DS_Small))
        elseif action == 16 or action == 17 then
            set DS_Direction = action-16
            set DS_SourcePage = 0
        elseif action == 18 then
            set DS_Minimized = not DS_Minimized
            call DS_LayoutSmall()
        elseif action == 10 then
            set DS_Selected = -1
            call BlzFrameSetVisible(DS_Large,true)
        elseif action == 11 then
            call BlzFrameSetVisible(DS_Large,false)
        elseif action == 12 then
            set DS_Selected = -1
            set DS_SourcePage = 0
        elseif action == 13 then
            if DS_Selected >= 0 then
                set DS_SourcePage = IMaxBJ(0,DS_SourcePage-1)
            else
                set DS_PlayerPage = IMaxBJ(0,DS_PlayerPage-1)
            endif
        elseif action == 14 then
            if DS_Selected >= 0 then
                set DS_SourcePage = DS_SourcePage+1
            else
                set DS_PlayerPage = DS_PlayerPage+1
            endif
        elseif action >= 20 and action < 40 then
            set DS_Selected = DS_RowPid[action-20]
            set DS_SourcePage = 0
            call BlzFrameSetVisible(DS_Large,true)
        endif
        set DS_LastVersion = -1
        call DS_Tick()
    endif
    call WUI_ResetClickedButtonFocus()
endfunction

// Shared constructors only. Font size does not scale the frame's anchor/rectangle.
private function DS_Text takes framehandle parent, real x, real y, real width, real height, real font returns framehandle
    local framehandle f = BlzCreateFrameByType("TEXT","DamageStatsText",parent,"",0)
    call BlzFrameSetPoint(f,FRAMEPOINT_CENTER,parent,FRAMEPOINT_TOPLEFT,x,y)
    call BlzFrameSetSize(f,width,height)
    call BlzFrameSetTextAlignment(f,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_LEFT)
    call BlzFrameSetFont(f,"Fonts\\FRIZQT__.TTF",font,0)
    call BlzFrameSetLevel(f,10)
    call BlzFrameSetEnable(f,false)
    return f
endfunction

private function DS_Edge takes framehandle parent, string texture returns nothing
    local framehandle f = BlzCreateFrameByType("BACKDROP","DamageStatsOutline",parent,"",0)
    call BlzFrameSetAllPoints(f,parent)
    call BlzFrameSetTexture(f,texture,0,true)
    call BlzFrameSetLevel(f,12)
    call BlzFrameSetEnable(f,false)
    set f = null
endfunction

// Engine tooltip under a tab; returns its text frame (filled by DS_RefreshGameTips).
private function DS_CreateGameTip takes framehandle owner returns framehandle
    local framehandle box = WUI_TooltipBox(WUI_GetRoot(),0.170,0.052)
    local framehandle text = BlzCreateFrameByType("TEXT","DamageStatsGameTip",box,"",0)
    call BlzFrameSetPoint(box,FRAMEPOINT_TOPLEFT,owner,FRAMEPOINT_BOTTOMLEFT,0.000,-0.004)
    call BlzFrameSetAllPoints(text,box)
    call BlzFrameSetTextAlignment(text,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
    call BlzFrameSetFont(text,"Fonts\\FRIZQT__.TTF",0.0085,0)
    call BlzFrameSetEnable(text,false)
    call BlzFrameSetLevel(box,100)
    call BlzFrameSetTooltip(owner,box)
    call BlzFrameSetVisible(box,false)
    set box = null
    return text
endfunction

// Empty engine tooltip of `owner`: visible exactly while the mouse is over it.
private function DS_CreateSensor takes framehandle owner returns framehandle
    local framehandle f = BlzCreateFrameByType("FRAME","DamageStatsHoverSensor",owner,"",0)
    call BlzFrameSetPoint(f,FRAMEPOINT_CENTER,owner,FRAMEPOINT_CENTER,0.000,0.000)
    call BlzFrameSetSize(f,0.001,0.001)
    call BlzFrameSetTooltip(owner,f)
    call BlzFrameSetVisible(f,false)
    return f
endfunction

private function DS_Background takes framehandle parent returns nothing
    local framehandle fill = BlzCreateFrameByType("BACKDROP","DamageStatsBackground",parent,"",0)
    call BlzFrameSetAllPoints(fill,parent)
    call BlzFrameSetTexture(fill,WUI_PANEL_TEXTURE,0,true)
    call BlzFrameSetAlpha(fill,205)
    call BlzFrameSetLevel(fill,0)
    call BlzFrameSetEnable(fill,false)
    set fill = null
endfunction

private function DS_Button takes framehandle parent, string caption, real x, real y, real width, real height, integer action returns framehandle
    local framehandle f = WUI_TextButton("DamageStatsButton",parent,caption,width,height)
    call BlzFrameSetPoint(f,FRAMEPOINT_CENTER,parent,FRAMEPOINT_TOPLEFT,x,y)
    call WUI_SetButtonMinimal(f)
    call WUI_SetButtonTextScale(f,0.80)
    call SaveInteger(DS_Keys,GetHandleId(f),0,action)
    call BlzTriggerRegisterFrameEvent(DS_ClickTrigger,f,FRAMEEVENT_CONTROL_CLICK)
    return f
endfunction

private function DS_CreateRow takes integer r returns nothing
    local integer view = r/10
    local integer j = 0
    local integer slot
    local integer cells = DS_SMALL
    local real width = 0.190
    local real bx = 0.029
    local real bw = 0.161
    local real portrait = 0.026334
    local real portraitX = 0.0015
    local real nameWidth = 0.111
    local real numberWidth = 0.041
    local real font = 0.0080
    local real barHeight = 0.012
    local framehandle parent = DS_Small
    if view == 1 then
        set parent = DS_Large
        set cells = DS_CELLS
        set width = 0.336
        set bx = 0.0312
        set bw = 0.3048
        set portrait = 0.0272
        set portraitX = 0.000
        set nameWidth = 0.239
        set numberWidth = 0.056
        set font = 0.0095
        set barHeight = 0.010
    endif
    set DS_Row[r] = BlzCreateFrameByType("BUTTON","DamageStatsRow",parent,"",r)
    call BlzFrameSetSize(DS_Row[r],width,0.030)
    if view == 1 then
        // Chained rows: a two-line row pushes the following rows down by itself.
        if r == 10 then
            call BlzFrameSetPoint(DS_Row[r],FRAMEPOINT_TOPLEFT,parent,FRAMEPOINT_TOPLEFT,0.012,-0.065)
        else
            call BlzFrameSetPoint(DS_Row[r],FRAMEPOINT_TOPLEFT,DS_Row[r-1],FRAMEPOINT_BOTTOMLEFT,0.000,-0.001)
        endif
    endif
    call SaveInteger(DS_Keys,GetHandleId(DS_Row[r]),0,20+r)
    call BlzTriggerRegisterFrameEvent(DS_ClickTrigger,DS_Row[r],FRAMEEVENT_CONTROL_CLICK)
    call DS_Edge(DS_Row[r],"UI\\WOS\\damage-row-edge.tga")
    set DS_RowPid[r] = -1
    set DS_BarBack[r] = BlzCreateFrameByType("BACKDROP","DamageStatsBarBack",DS_Row[r],"",r)
    call BlzFrameSetPoint(DS_BarBack[r],FRAMEPOINT_TOPLEFT,DS_Row[r],FRAMEPOINT_TOPLEFT,bx,0.000)
    call BlzFrameSetSize(DS_BarBack[r],bw,barHeight)
    call BlzFrameSetTexture(DS_BarBack[r],"UI\\WOS\\bar-back.tga",0,true)
    call BlzFrameSetEnable(DS_BarBack[r],false)
    call BlzFrameSetLevel(DS_BarBack[r],1)
    set DS_Fill[r] = WUI_CreateFill("DamageStatsBarFill",DS_Row[r],bw,barHeight,100.0,"UI\\WOS\\damage-fill-0.tga")
    call BlzFrameSetPoint(DS_Fill[r],FRAMEPOINT_TOPLEFT,DS_BarBack[r],FRAMEPOINT_TOPLEFT,0.000,0.000)
    call BlzFrameSetLevel(DS_Fill[r],2)
    call WUI_SetValue(DS_Fill[r],0.00)
    set DS_Portrait[r] = BlzCreateFrameByType("BACKDROP","DamageStatsPortrait",DS_Row[r],"",r)
    call BlzFrameSetSize(DS_Portrait[r],portrait,portrait)
    call BlzFrameSetPoint(DS_Portrait[r],FRAMEPOINT_TOPLEFT,DS_Row[r],FRAMEPOINT_TOPLEFT,portraitX,0.000)
    call BlzFrameSetEnable(DS_Portrait[r],false)
    call DS_Edge(DS_Portrait[r],"UI\\WOS\\damage-icon-edge.tga")
    set DS_Label[r] = DS_Text(DS_Row[r],0.000,0.000,nameWidth,barHeight,font)
    call BlzFrameClearAllPoints(DS_Label[r])
    call BlzFrameSetPoint(DS_Label[r],FRAMEPOINT_LEFT,DS_BarBack[r],FRAMEPOINT_LEFT,0.003,0.000)
    set DS_Value[r] = DS_Text(DS_Row[r],0.000,0.000,numberWidth,barHeight,font)
    call BlzFrameClearAllPoints(DS_Value[r])
    call BlzFrameSetPoint(DS_Value[r],FRAMEPOINT_RIGHT,DS_BarBack[r],FRAMEPOINT_RIGHT,-0.003,0.000)
    call BlzFrameSetTextAlignment(DS_Value[r],TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_RIGHT)
    set DS_SubLabel[r] = DS_Text(DS_Row[r],bx+bw*0.5,-0.018,bw-0.006,0.014,0.0075)
    call BlzFrameSetVisible(DS_SubLabel[r],false)
    set DS_SourceRowIcon[r] = BlzCreateFrameByType("GLUEBUTTON","DamageStatsSourceRow",DS_Row[r],"",r)
    call BlzFrameSetSize(DS_SourceRowIcon[r],portrait,portrait)
    call BlzFrameSetPoint(DS_SourceRowIcon[r],FRAMEPOINT_TOPLEFT,DS_Row[r],FRAMEPOINT_TOPLEFT,portraitX,0.000)
    set DS_SourceRowArt[r] = BlzCreateFrameByType("BACKDROP","DamageStatsSourceRowArt",DS_SourceRowIcon[r],"",r)
    call BlzFrameSetAllPoints(DS_SourceRowArt[r],DS_SourceRowIcon[r])
    call BlzFrameSetEnable(DS_SourceRowArt[r],false)
    call DS_Edge(DS_SourceRowIcon[r],"UI\\WOS\\damage-icon-edge.tga")
    set DS_RowSensor[r] = DS_CreateSensor(DS_SourceRowIcon[r])
    call BlzFrameSetVisible(DS_SourceRowIcon[r],false)
    loop
        exitwhen j >= cells
        set slot = r*DS_CELLS+j
        // The hit area covers BOTH art and digits, with one stable thin outline.
        set DS_Icon[slot] = BlzCreateFrameByType("GLUEBUTTON","DamageStatsSourceCell",DS_Row[r],"",0)
        set DS_Art[slot] = BlzCreateFrameByType("BACKDROP","DamageStatsSourceArt",DS_Icon[slot],"",0)
        call BlzFrameSetPoint(DS_Art[slot],FRAMEPOINT_TOP,DS_Icon[slot],FRAMEPOINT_TOP,0.000,0.000)
        call BlzFrameSetEnable(DS_Art[slot],false)
        set DS_Number[slot] = BlzCreateFrameByType("TEXT","DamageStatsText",DS_Icon[slot],"",0)
        call BlzFrameSetTextAlignment(DS_Number[slot],TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
        call BlzFrameSetLevel(DS_Number[slot],10)
        call BlzFrameSetEnable(DS_Number[slot],false)
        call DS_Edge(DS_Icon[slot],"UI\\WOS\\damage-icon-edge.tga")
        // No frame mouse events here: hover is read from the engine tooltip flag.
        set DS_Sensor[slot] = DS_CreateSensor(DS_Icon[slot])
        if view == 0 then
            call DS_PlaceCell(slot,DS_Row[r],bx+I2R(j)*DS_SMALL_PITCH,-barHeight,DS_SMALL_PITCH,0.0152,0.0084,0.00585)
        endif
        call BlzFrameSetVisible(DS_Icon[slot],false)
        set j = j+1
    endloop
    if view == 1 then
        set DS_RowLines[r] = 0
        call DS_SetRowLines(r,1)
    endif
    call BlzFrameSetVisible(DS_Row[r],false)
    set parent = null
endfunction

private function DS_BuildStep takes nothing returns nothing
    // Re-armed first so a failing row cannot stop the chain; rows after all UI owners.
    call TimerStart(DS_Timer,0.03,false,function DS_BuildStep)
    if not WUI_OwnersDone() then
        return
    endif
    call DS_CreateRow(DS_BuildRow)
    set DS_BuildRow = DS_BuildRow+1
    if DS_BuildRow >= 20 then
        call DS_LayoutSmall()
        set DS_Ready = true
        call TimerStart(DS_Timer,0.50,true,function DS_Tick)
        call TimerStart(DS_PollTimer,0.10,true,function DS_Poll)
        call WUI_StartupEnd()
    endif
endfunction

private function DS_Build takes nothing returns nothing
    local framehandle root = WUI_GetRoot()
    local framehandle f
    local integer i = 0
    local integer mode
    local real width
    local real x
    if not DamageStatsActive then
        set root = null
        return
    endif
    set DS_ClickTrigger = CreateTrigger()
    set DS_KeyTrigger = CreateTrigger()
    call TriggerAddAction(DS_ClickTrigger,function DS_Click)
    call TriggerAddAction(DS_KeyTrigger,function DS_OnKey)
    call DS_BuildIconCatalogue()
    set DS_Small = BlzCreateFrameByType("FRAME","DamageStatsCompact",WUI_GetTopActionOwner(),"",0)
    call BlzFrameSetSize(DS_Small,0.190,0.103)
    call DS_Background(DS_Small)
    call DS_Edge(DS_Small,"UI\\WOS\\damage-window-edge.tga")
    call BlzFrameSetVisible(DS_Small,false)
    call WUI_RegisterWindowPart(13,DS_Small)
    set DS_Toggle = DS_Button(WUI_GetTopActionOwner(),"DAMAGE STATS  +/-",0.000,0.000,0.190,0.016,15)
    call BlzFrameClearAllPoints(DS_Toggle)
    call DS_LayoutViewport()
    if DS_PickHidden then
        call BlzFrameSetVisible(DS_Toggle,false)
    endif
    // Rebindable show/hide key (default L), saved with Save Keys like other hotkeys.
    call WUI_RegisterHotkeyEx(WUI_HOTKEY_DAMAGE,DS_KeyTrigger,OSKEY_L,"L",false,DS_Toggle,WUI_GetTopActionOwner(),true)
    if DS_PickHidden then
        call WUI_SetHotkeyBadgeShown(WUI_HOTKEY_DAMAGE,false)
    endif
    set DS_Large = BlzCreateFrameByType("FRAME","DamageStatsDetails",WUI_GetTopActionOwner(),"",0)
    call BlzFrameSetSize(DS_Large,0.360,0.120)
    call BlzFrameSetAbsPoint(DS_Large,FRAMEPOINT_TOP,0.400,0.550)
    call DS_Background(DS_Large)
    call DS_Edge(DS_Large,"UI\\WOS\\damage-window-edge.tga")
    call BlzFrameSetLevel(DS_Large,65)
    call WUI_RegisterModal(DS_Large)
    call WUI_RegisterWindowPart(12,DS_Large)
    call BlzFrameSetVisible(DS_Large,false)
    // Compact tabs: Round | Game | Minimize/Expand | Previous. Details: Round | Game | Previous.
    loop
        exitwhen i >= 7
        if i < 4 then
            set f = DS_Small
            set width = 0.045
            set x = 0.024+I2R(i)*0.0475
            set mode = i
            if i == 2 then
                set mode = -1
            endif
        else
            set f = DS_Large
            set width = 0.059
            set x = 0.040+I2R(i-4)*0.062
            set mode = i-4
            if i == 6 then
                set mode = 3
            endif
        endif
        set DS_TabMode[i] = mode
        if mode < 0 then
            set DS_Tab[i] = DS_Button(f,"Expand",x,-0.010,width,0.017,18)
            call WUI_TooltipBelow(DS_Tab[i],"MINIMIZE / EXPAND|nMinimize: names and damage bars only.|nExpand: hero portraits and latest damage sources.")
        else
            set DS_Tab[i] = DS_Button(f,DS_ModeName(mode),x,-0.010,width,0.017,mode+1)
            if mode == 1 then
                set DS_GameTip[i] = DS_CreateGameTip(DS_Tab[i])
            endif
        endif
        set i = i+1
    endloop
    set DS_DirTab[0] = DS_Button(DS_Small,"Dealt",0.0475,-0.030,0.089,0.016,16)
    set DS_DirTab[1] = DS_Button(DS_Small,"Taken",0.1425,-0.030,0.089,0.016,17)
    set DS_DirTab[2] = DS_Button(DS_Large,"Dealt",0.058,-0.036,0.092,0.016,16)
    set DS_DirTab[3] = DS_Button(DS_Large,"Taken",0.157,-0.036,0.092,0.016,17)
    set DS_Details = DS_Button(DS_Small,"Open details",0.095,-0.093,0.186,0.016,10)
    call BlzFrameClearAllPoints(DS_Details)
    call BlzFrameSetPoint(DS_Details,FRAMEPOINT_CENTER,DS_Small,FRAMEPOINT_BOTTOM,0.000,0.010)
    set f = DS_Button(DS_Large,"X",0.346,-0.012,0.022,0.020,11)
    set DS_Back = DS_Button(DS_Large,"Players",0.295,-0.012,0.072,0.020,12)
    call BlzFrameSetVisible(DS_Back,false)
    set DS_Heading = DS_Text(DS_Large,0.135,-0.058,0.180,0.014,0.009)
    set DS_HeadingDamage = DS_Text(DS_Large,0.309,-0.058,0.070,0.014,0.009)
    set DS_HeadingRecent = DS_Text(DS_Large,0.277,-0.036,0.140,0.014,0.008)
    call BlzFrameSetText(DS_HeadingDamage,"|cffffdc85DAMAGE|r")
    call BlzFrameSetTextAlignment(DS_HeadingDamage,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_RIGHT)
    call BlzFrameSetTextAlignment(DS_HeadingRecent,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_RIGHT)
    set DS_Footer = DS_Text(DS_Large,0.180,-0.120,0.300,0.016,0.008)
    call BlzFrameClearAllPoints(DS_Footer)
    call BlzFrameSetPoint(DS_Footer,FRAMEPOINT_CENTER,DS_Large,FRAMEPOINT_BOTTOM,0.000,0.012)
    set DS_Previous = DS_Button(DS_Large,"<",0.018,-0.120,0.020,0.018,13)
    set DS_Next = DS_Button(DS_Large,">",0.342,-0.120,0.020,0.018,14)
    call BlzFrameClearAllPoints(DS_Previous)
    call BlzFrameSetPoint(DS_Previous,FRAMEPOINT_CENTER,DS_Large,FRAMEPOINT_BOTTOMLEFT,0.016,0.012)
    call BlzFrameClearAllPoints(DS_Next)
    call BlzFrameSetPoint(DS_Next,FRAMEPOINT_CENTER,DS_Large,FRAMEPOINT_BOTTOMRIGHT,-0.016,0.012)
    call BlzFrameSetVisible(DS_Previous,false)
    call BlzFrameSetVisible(DS_Next,false)
    set DS_Tooltip = WUI_TooltipBox(root,0.220,0.068)
    call WUI_RegisterWindowPart(14,DS_Tooltip)
    set DS_TooltipText = BlzCreateFrameByType("TEXT","DamageStatsSourceTooltip",DS_Tooltip,"",0)
    call BlzFrameSetAllPoints(DS_TooltipText,DS_Tooltip)
    call BlzFrameSetTextAlignment(DS_TooltipText,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
    call BlzFrameSetFont(DS_TooltipText,"Fonts\\FRIZQT__.TTF",0.009,0)
    call BlzFrameSetEnable(DS_TooltipText,false)
    call BlzFrameSetLevel(DS_Tooltip,100)
    call BlzFrameSetVisible(DS_Tooltip,false)
    call WUI_StartupBegin()
    call TimerStart(DS_Timer,0.03,false,function DS_BuildStep)
    set f = null
    set root = null
endfunction

private function DS_Init takes nothing returns nothing
    if DamageStatsActive then
        call WUI_OnReady(function DS_Build)
    endif
endfunction

// Synced (WOS_SelectMode): Test mode keeps stats even when DAMAGE_STATS_ENABLED = false.
// Hero pick: the left column belongs to the pick chat, so the whole window and its
// toggle stay hidden until every hero is picked; the compact panel state comes back.
function DamageStatsSetPickHidden takes boolean hidden returns nothing
    if hidden == DS_PickHidden or DS_Toggle == null then
        set DS_PickHidden = hidden
        return
    endif
    set DS_PickHidden = hidden
    call DS_ClearHover()
    if hidden then
        set DS_SmallBeforePick = BlzFrameIsVisible(DS_Small)
        call BlzFrameSetVisible(DS_Toggle,false)
        call BlzFrameSetVisible(DS_Small,false)
        call BlzFrameSetVisible(DS_Large,false)
        call WUI_SetHotkeyBadgeShown(WUI_HOTKEY_DAMAGE,false)
    else
        call BlzFrameSetVisible(DS_Toggle,true)
        call WUI_SetHotkeyBadgeShown(WUI_HOTKEY_DAMAGE,true)
        call BlzFrameSetVisible(DS_Small,DS_SmallBeforePick)
        set DS_LastVersion = -1
    endif
endfunction

function DamageStatsEnableForTest takes nothing returns nothing
    if DamageStatsActive then
        return
    endif
    set DamageStatsActive = true
    call WUI_OnReady(function DS_Build)
endfunction
endlibrary
