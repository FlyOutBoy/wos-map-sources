globals
    integer LoanSendLimit            = 100000
    integer LoanSendLimitIncrease    = 100
    integer GoldReceiveHardCap       = 150
    integer GoldReceiveHardCapIncrease = 250
    boolean TransferClearMax         = false
endglobals
library EnvironmentRoundRules
globals
    constant integer TRAIN_PUSH_BASE_DAMAGE = 275
    constant integer TRAIN_EXPLOSION_BASE_DAMAGE = 475
    constant integer TRAIN_DAMAGE_PER_ROUND = 125
endglobals

// Training phase restarts are not completed match rounds.
// Shared by actual decor/train damage and its Game Info snapshot.
function GetEnvironmentRoundNumber takes nothing returns integer
    if TestMode then
        return 1
    endif
    return IMaxBJ(1, CurrentRound)
endfunction

endlibrary
