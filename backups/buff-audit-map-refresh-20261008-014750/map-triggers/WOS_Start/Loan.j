library GoldLoanSystem initializer Init

globals
    integer LoanSendLimit            = 100
    integer LoanSendLimitIncrease    = 100
    integer GoldReceiveHardCap       = 150
    integer GoldReceiveHardCapIncrease = 250
    boolean TransferClearMax         = false
endglobals

globals
    private constant real POLL_INTERVAL = 0.05
    private integer array prevGold
    private integer array debt
    private boolean array collectNow
    private integer array ignoreGain
    private integer array ignoreLoss
    private integer array totalReceived
    private timer pollTimer = null
    
    // Temporary arrays for processing
    private integer array tempCurGold
    private integer array tempNetChange
endglobals

private function Idx takes integer a, integer b returns integer
    return a * 12 + b
endfunction

private function GoldStr takes integer amount returns string
    return "|cffffd700" + I2S(amount) + "|r"
endfunction

private function CapLeft takes integer pid returns string
    local integer left = GoldReceiveHardCap - totalReceived[pid]
    if left < 0 then
        set left = 0
    endif
    return "|cffffffff [Limit left: |r" + GoldStr(left) + "|cffffffff / |r" + GoldStr(GoldReceiveHardCap) + "|cffffffff]|r"
endfunction

function GoldLoan_IgnoreGain takes integer pid returns nothing
    set ignoreGain[pid] = 3
endfunction

function GoldLoan_IgnoreLoss takes integer pid returns nothing
    set ignoreLoss[pid] = 3
endfunction

function GoldLoan_SetCollect takes integer lender, integer borrower, boolean flag returns nothing
    set collectNow[Idx(lender, borrower)] = flag
endfunction

function GoldLoan_GetDebt takes integer lender, integer borrower returns integer
    return debt[Idx(lender, borrower)]
endfunction

function GoldLoan_GetTotalReceived takes integer pid returns integer
    return totalReceived[pid]
endfunction

// ============================================================
//  COLLECT DEBT
// ============================================================
function GoldLoan_Collect takes integer lender, integer borrower returns nothing
    local integer owed         = debt[Idx(lender, borrower)]
    local integer borrowerGold = GetPlayerState(Player(borrower), PLAYER_STATE_RESOURCE_GOLD)
    local integer lenderGold   = GetPlayerState(Player(lender),   PLAYER_STATE_RESOURCE_GOLD)
    local integer take

    if owed <= 0 then
        return
    endif

    set take = IMinBJ(owed, borrowerGold)

    call GoldLoan_IgnoreGain(lender)
    call GoldLoan_IgnoreLoss(borrower)

    call SetPlayerState(Player(borrower), PLAYER_STATE_RESOURCE_GOLD, borrowerGold - take)
    call SetPlayerState(Player(lender),   PLAYER_STATE_RESOURCE_GOLD, lenderGold + take)

    set debt[Idx(lender, borrower)] = owed - take
    set collectNow[Idx(lender, borrower)] = false

    call DisplayTimedTextToPlayer(Player(lender),   0, 0, 5, "|cffffffffDebt collected: |r" + GoldStr(take) + "|cffffffff gold.|r" )
    call DisplayTimedTextToPlayer(Player(borrower), 0, 0, 5, GoldStr(take) + "|cffffffff gold debt repaid.|r" )
endfunction

// ============================================================
//  POLL
// ============================================================
private function Poll takes nothing returns nothing
    local integer pid = 0
    local integer ally
    local integer excess
    local integer allowed
    local integer transferAmount
    local integer matchedAmount

    if TransferClearMax then
        set TransferClearMax = false
        set pid = 0
        loop
            exitwhen pid >= 12
            set totalReceived[pid] = 0
            set pid = pid + 1
        endloop
    endif

    // STAGE 1: Take resource snapshots for the current tick
    set pid = 0
    loop
        exitwhen pid >= 12
        if GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(pid)) == MAP_CONTROL_USER then
            set tempCurGold[pid]   = GetPlayerState(Player(pid), PLAYER_STATE_RESOURCE_GOLD)
            set tempNetChange[pid] = tempCurGold[pid] - prevGold[pid]
        else
            set tempNetChange[pid] = 0
        endif
        set pid = pid + 1
    endloop

    // STAGE 2: Safe, dynamic processing of player-to-player transfers
    set pid = 0
    loop
        exitwhen pid >= 12
        if tempNetChange[pid] < 0 and ignoreLoss[pid] == 0 then
            set transferAmount = -tempNetChange[pid]
            
            set ally = 0
            loop
                exitwhen ally >= 12 or transferAmount <= 0
                if ally != pid and GetPlayerSlotState(Player(ally)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(ally)) == MAP_CONTROL_USER then
                    if IsPlayerAlly(Player(pid), Player(ally)) and tempNetChange[ally] > 0 and ignoreGain[ally] == 0 then
                        
                        // Extract how much of sender's loss matches this ally's gain pool
                        set matchedAmount = IMinBJ(transferAmount, tempNetChange[ally])
                        
                        if matchedAmount > 0 then
                            // Process verified matched transaction
                            if totalReceived[ally] >= GoldReceiveHardCap then
                                // TOTAL BLOCK
                                call SetPlayerState(Player(pid),  PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(pid), PLAYER_STATE_RESOURCE_GOLD) + matchedAmount)
                                call SetPlayerState(Player(ally), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(ally), PLAYER_STATE_RESOURCE_GOLD) - matchedAmount)
                                call DisplayTimedTextToPlayer(Player(ally), 0, 0, 4, "|cffffffffTransfer blocked: receive cap reached.|r" + CapLeft(ally))
                                call DisplayTimedTextToPlayer(Player(pid),  0, 0, 4, "|cffffffffTransfer blocked: ally hit receive cap.|r" + CapLeft(ally))
                            else
                                set allowed = IMinBJ(matchedAmount, LoanSendLimit)
                                if totalReceived[ally] + allowed > GoldReceiveHardCap then
                                    set allowed = GoldReceiveHardCap - totalReceived[ally]
                                endif
                                set excess = matchedAmount - allowed
                                set debt[Idx(pid, ally)]  = debt[Idx(pid, ally)] + allowed
                                set totalReceived[ally]   = totalReceived[ally] + allowed
                                
                                if excess > 0 then
                                    // PARTIAL RETURN (CAP INTERFERENCE)
                                    call SetPlayerState(Player(pid),  PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(pid), PLAYER_STATE_RESOURCE_GOLD) + excess)
                                    call SetPlayerState(Player(ally), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(ally), PLAYER_STATE_RESOURCE_GOLD) - excess)
                                    call DisplayTimedTextToPlayer(Player(pid),  0, 0, 4, "|cffffffffTransfer limited: |r" + GoldStr(allowed) + "|cffffffff sent, |r" + GoldStr(excess) + "|cffffffff returned.|r" + CapLeft(ally))
                                    call DisplayTimedTextToPlayer(Player(ally), 0, 0, 4, "|cffffffffReceived |r" + GoldStr(allowed) + "|cffffffff (limit applied).|r" + CapLeft(ally))
                                else
                                    // SUCCESSFUL FULL TRANSFER
                                    call DisplayTimedTextToPlayer(Player(pid),  0, 0, 4, "|cffffffffTransferred |r" + GoldStr(allowed) + "|cffffffff to ally.|r" + CapLeft(ally))
                                    call DisplayTimedTextToPlayer(Player(ally), 0, 0, 4, "|cffffffffReceived |r" + GoldStr(allowed) + "|cffffffff from ally.|r" + CapLeft(ally))
                                endif
                            endif
                            
                            // Clean up pools based on matched resources
                            set tempNetChange[ally] = tempNetChange[ally] - matchedAmount
                            set transferAmount = transferAmount - matchedAmount
                        endif
                        
                    endif
                endif
                set ally = ally + 1
            endloop
            
            // Re-apply remaining negative changes if they weren't matched as player transfers (e.g. standard shop spending)
            set tempNetChange[pid] = -transferAmount
        endif
        set pid = pid + 1
    endloop

    // STAGE 3: Process natural game changes (upkeep, natural drains, buffs)
    set pid = 0
    loop
        exitwhen pid >= 12
        if tempNetChange[pid] < 0 then
            if ignoreLoss[pid] > 0 then
                set ignoreLoss[pid] = ignoreLoss[pid] - 1
            endif
        elseif tempNetChange[pid] > 0 then
            if ignoreGain[pid] > 0 then
                set ignoreGain[pid] = ignoreGain[pid] - 1
            endif
        endif
        set pid = pid + 1
    endloop

    // STAGE 4: Final global database synchronization
    set pid = 0
    loop
        exitwhen pid >= 12
        set prevGold[pid] = GetPlayerState(Player(pid), PLAYER_STATE_RESOURCE_GOLD)
        set pid = pid + 1
    endloop

    // STAGE 5: Check and trigger auto debt collection
    set pid = 0
    loop
        exitwhen pid >= 12
        if GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(pid)) == MAP_CONTROL_USER then
            set ally = 0
            loop
                exitwhen ally >= 12
                if ally != pid then
                    if collectNow[Idx(pid, ally)] then
                        call GoldLoan_Collect(pid, ally)
                    endif
                endif
                set ally = ally + 1
            endloop
        endif
        set pid = pid + 1
    endloop
       
endfunction

// ============================================================
//  INIT
// ============================================================
private function Init takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i >= 12
        set prevGold[i]      = GetPlayerState(Player(i), PLAYER_STATE_RESOURCE_GOLD)
        set ignoreGain[i]    = 0
        set ignoreLoss[i]    = 0
        set totalReceived[i] = 0
        set i = i + 1
    endloop

    set pollTimer = CreateTimer()
    call TimerStart(pollTimer, POLL_INTERVAL, true, function Poll)
endfunction

endlibrary