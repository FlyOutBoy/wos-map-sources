globals
    integer LoanSendLimit            = 100000
    integer LoanSendLimitIncrease    = 100
    integer GoldReceiveHardCap       = 150
    integer GoldReceiveHardCapIncrease = 250
    boolean TransferClearMax         = false
endglobals
library EnvironmentRoundRules

// Training phase restarts are not completed match rounds.
// Shared by actual decor/train damage and its Game Info snapshot.
function GetEnvironmentRoundNumber takes nothing returns integer
    if TestMode then
        return 1
    endif
    return IMaxBJ(1, CurrentRound)
endfunction

endlibrary
