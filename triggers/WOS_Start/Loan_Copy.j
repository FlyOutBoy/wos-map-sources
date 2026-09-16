library GoldLoanSystem initializer Init

globals
    integer LoanSendLimit            = 100000
    integer LoanSendLimitIncrease    = 100
    integer GoldReceiveHardCap       = 150
    integer GoldReceiveHardCapIncrease = 250
    boolean TransferClearMax         = false
endglobals

globals
    private constant real POLL_INTERVAL = 0.1
    private integer array prevGold
    private integer array debt
    private boolean array collectNow
    private integer array ignoreGain
    private integer array ignoreLoss
    private integer array totalReceived
    private timer pollTimer = null
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
    return "|cffffffff [receive cap left: |r" + GoldStr(left) + "|cffffffff / |r" + GoldStr(GoldReceiveHardCap) + "|cffffffff]|r"
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

    call DisplayTimedTextToPlayer(Player(lender),   0, 0, 1, "|cffffffffDebt collected: |r" + GoldStr(take) + "|cffffffff gold.|r" )
    call DisplayTimedTextToPlayer(Player(borrower), 0, 0, 1, GoldStr(take) + "|cffffffff gold debt repaid.|r" )
endfunction

// ============================================================
//  POLL
// ============================================================
private function Poll takes nothing returns nothing
    local integer pid = 0
    local integer ally
    local integer curGold
    local integer delta
    local integer allyGold
    local integer allyDelta
    local integer excess
    local integer allowed

    if TransferClearMax then
        set TransferClearMax = false
        set pid = 0
        loop
            exitwhen pid >= 12
            set totalReceived[pid] = 0
            set pid = pid + 1
        endloop
        set pid = 0
    endif

    loop
        exitwhen pid >= 12

       if GetPlayerSlotState( Player( pid ) ) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController( Player( pid ) ) == MAP_CONTROL_USER  then

            set curGold = GetPlayerState(Player(pid), PLAYER_STATE_RESOURCE_GOLD)
            set delta   = prevGold[pid] - curGold

            if delta > 0 then
                if ignoreLoss[pid] > 0 then
                    set ignoreLoss[pid] = ignoreLoss[pid] - 1
                else
                    set ally = 0
                    loop
                        exitwhen ally >= 12
                        if ally != pid and  GetPlayerSlotState( Player( ally ) ) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController( Player( ally ) ) == MAP_CONTROL_USER  then
                            if IsPlayerAlly(Player(pid), Player(ally)) then

                                set allyGold  = GetPlayerState(Player(ally), PLAYER_STATE_RESOURCE_GOLD)
                                set allyDelta = allyGold - prevGold[ally]

                                if allyDelta == delta then

                                    if totalReceived[ally] >= GoldReceiveHardCap then
                                        call GoldLoan_IgnoreGain(pid)
                                        call GoldLoan_IgnoreLoss(ally)
                                        call SetPlayerState(Player(pid),  PLAYER_STATE_RESOURCE_GOLD, curGold + delta)
                                        call SetPlayerState(Player(ally), PLAYER_STATE_RESOURCE_GOLD, allyGold - delta)
                                        set curGold  = curGold + delta
                                        set allyGold = allyGold - delta
                                        set prevGold[ally] = allyGold
                                        call DisplayTimedTextToPlayer(Player(ally), 0, 0, 1, "|cffffffffTransfer blocked: receive cap reached.|r" + CapLeft(ally))
                                        call DisplayTimedTextToPlayer(Player(pid),  0, 0, 1, "|cffffffffTransfer blocked: ally hit receive cap.|r" + CapLeft(ally))
                                    else
                                        set allowed = IMinBJ(delta, LoanSendLimit)

                                        if totalReceived[ally] + allowed > GoldReceiveHardCap then
                                            set allowed = GoldReceiveHardCap - totalReceived[ally]
                                        endif

                                        set excess = delta - allowed
                                        set debt[Idx(pid, ally)]  = debt[Idx(pid, ally)] + allowed
                                        set totalReceived[ally]   = totalReceived[ally] + allowed
                                        if excess > 0 then
                                            call GoldLoan_IgnoreGain(pid)
                                            call GoldLoan_IgnoreLoss(ally)
                                            call SetPlayerState(Player(pid),  PLAYER_STATE_RESOURCE_GOLD, curGold + excess)
                                            call SetPlayerState(Player(ally), PLAYER_STATE_RESOURCE_GOLD, allyGold - excess)
                                            set curGold  = curGold + excess
                                            set allyGold = allyGold - excess
                                            call DisplayTimedTextToPlayer(Player(pid),  0, 0, 1, "|cffffffffTransfer capped: |r" + GoldStr(allowed) + "|cffffffff sent, |r" + GoldStr(excess) + "|cffffffff returned.|r" + CapLeft(ally))
                                            call DisplayTimedTextToPlayer(Player(ally), 0, 0, 1, "|cffffffffReceived |r" + GoldStr(allowed) + "|cffffffff (capped).|r" + CapLeft(ally))
                                        else
                                            call DisplayTimedTextToPlayer(Player(pid),  0, 0, 1, "|cffffffffSent |r" + GoldStr(allowed) + "|cffffffff to ally.|r" + CapLeft(ally))
                                            call DisplayTimedTextToPlayer(Player(ally), 0, 0, 1, "|cffffffffReceived |r" + GoldStr(allowed) + "|cffffffff from ally.|r" + CapLeft(ally))
                                        endif
                                        set prevGold[ally]        = allyGold
                                        
                                    endif

                                endif
                            endif
                        endif
                        set ally = ally + 1
                    endloop
                endif

            elseif delta < 0 then
                if ignoreGain[pid] > 0 then
                    set ignoreGain[pid] = ignoreGain[pid] - 1
                endif
            endif

            set prevGold[pid] = curGold

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