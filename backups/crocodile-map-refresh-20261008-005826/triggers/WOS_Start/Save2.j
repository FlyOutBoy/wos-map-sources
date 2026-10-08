library WOS2BotCodec

//==============================================================================
// Лёгкая защита экспорта статистики WOS2.
//
// Это намеренно небольшой код без SHA/HMAC: он обфусцирует строки и добавляет
// ключевой MAC-подобный тег. Цель — остановить ручную правку файлов, а не
// противостоять человеку, который распаковал карту и восстановил алгоритм.
//==============================================================================

globals
    private constant integer WBC_MOD1 = 1000003
    private constant integer WBC_MOD2 = 1000033
    private constant integer WBC_RADIX = 87

    // Фрагменты секрета. Перед релизом карты их желательно заменить одновременно
    // здесь и в wos2_bot_decoder.js. Не публикуйте серверный файл.
    private constant integer WBC_K0 = 731921
    private constant integer WBC_K1 = 284117
    private constant integer WBC_K2 = 619403
    private constant integer WBC_K3 = 93761
    private constant integer WBC_K4 = 508217
    private constant integer WBC_K5 = 346891

    // Алфавит шифротекста не содержит кавычку, обратный слеш, | и =, поэтому
    // результат безопасно помещается внутрь строки Preload без удвоения длины.
    private constant string WBC_PLAIN = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz _-.|=,:;!?/()[]{}+*@#%&'"
    private constant string WBC_CIPHER = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz _-.,:;!?/()[]{}+*@#%&'<>"
    private constant string WBC_BASE36 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    private string  wbc_MatchId = ""
    private integer wbc_Seq = 0
    private integer wbc_Context = 0
    private integer wbc_KeyA = 0
    private integer wbc_KeyB = 0
    private integer wbc_KeyC = 0
    private integer wbc_KeyD = 0
    private integer wbc_MacA = 0
    private integer wbc_MacB = 0
    private integer wbc_ChainA = 0
    private integer wbc_ChainB = 0
    private boolean wbc_Started = false
    private hashtable wbc_AlphabetIndex = null
    private boolean wbc_AlphabetIndexReady = false
endglobals

private function WBC_PosMod takes integer value, integer base returns integer
    local integer result = ModuloInteger(value, base)
    if result < 0 then
        set result = result + base
    endif
    return result
endfunction

private function WBC_InitAlphabetIndex takes nothing returns nothing
    local integer i = 0
    if wbc_AlphabetIndexReady then
        return
    endif
    set wbc_AlphabetIndex = InitHashtable()
    loop
        exitwhen i >= WBC_RADIX
        call SaveInteger(wbc_AlphabetIndex, 0, StringHash(SubString(WBC_PLAIN, i, i + 1)), i + 1)
        call SaveInteger(wbc_AlphabetIndex, 1, StringHash(SubString(WBC_CIPHER, i, i + 1)), i + 1)
        set i = i + 1
    endloop
    set wbc_AlphabetIndexReady = true
endfunction

private function WBC_PlainIndex takes string ch returns integer
    local integer index
    local integer i
    call WBC_InitAlphabetIndex()
    set index = LoadInteger(wbc_AlphabetIndex, 0, StringHash(ch)) - 1

    // StringHash in Warcraft III is case-insensitive. The lowercase entry is
    // therefore stored over the uppercase entry. Restore the exact index by
    // comparing the original character; this keeps the lookup constant-time
    // for the normal alphabet and preserves the original wire format.
    if index >= 0 and SubString(WBC_PLAIN, index, index + 1) == ch then
        return index
    endif
    set index = index - 26
    if index >= 0 and SubString(WBC_PLAIN, index, index + 1) == ch then
        return index
    endif

    // Collision-safe fallback for an unlikely non-case StringHash collision.
    set i = 0
    loop
        exitwhen i >= WBC_RADIX
        if SubString(WBC_PLAIN, i, i + 1) == ch then
            return i
        endif
        set i = i + 1
    endloop
    return -1
endfunction

private function WBC_CipherIndex takes string ch returns integer
    local integer index
    local integer i
    call WBC_InitAlphabetIndex()
    set index = LoadInteger(wbc_AlphabetIndex, 1, StringHash(ch)) - 1
    if index >= 0 and SubString(WBC_CIPHER, index, index + 1) == ch then
        return index
    endif
    set index = index - 26
    if index >= 0 and SubString(WBC_CIPHER, index, index + 1) == ch then
        return index
    endif
    set i = 0
    loop
        exitwhen i >= WBC_RADIX
        if SubString(WBC_CIPHER, i, i + 1) == ch then
            return i
        endif
        set i = i + 1
    endloop
    return -1
endfunction

private function WBC_Base36Digit takes integer value returns string
    return SubString(WBC_BASE36, value, value + 1)
endfunction

private function WBC_Base36Fixed4 takes integer value returns string
    local integer divisor = 46656
    local integer digit
    local string result = ""
    set value = WBC_PosMod(value, 1679616)
    loop
        exitwhen divisor <= 0
        set digit = value/divisor
        set result = result + WBC_Base36Digit(digit)
        set value = ModuloInteger(value, divisor)
        set divisor = divisor/36
    endloop
    return result
endfunction

private function WBC_MacFeed takes integer symbolValue returns nothing
    set wbc_MacA = WBC_PosMod(wbc_MacA*131 + symbolValue*17 + ModuloInteger(wbc_MacB, 997) + wbc_KeyC, WBC_MOD1)
    set wbc_MacB = WBC_PosMod(wbc_MacB*137 + symbolValue*29 + wbc_MacA + wbc_KeyD, WBC_MOD2)
endfunction

private function WBC_ComputeMac takes string cipher, integer seq returns nothing
    local integer i = 0
    local integer length
    local integer symbolValue
    set wbc_MacA = WBC_PosMod(wbc_KeyA + seq*97 + 1103, WBC_MOD1)
    set wbc_MacB = WBC_PosMod(wbc_KeyB + seq*193 + 2203, WBC_MOD2)

    set length = StringLength(wbc_MatchId)
    loop
        exitwhen i >= length
        set symbolValue = WBC_PlainIndex(SubString(wbc_MatchId, i, i + 1)) + 1
        if symbolValue <= 0 then
            set symbolValue = 1
        endif
        call WBC_MacFeed(symbolValue)
        set i = i + 1
    endloop

    // Отдельный код-разделитель не позволяет склеивать контекст и шифротекст.
    call WBC_MacFeed(127)
    set i = 0
    set length = StringLength(cipher)
    loop
        exitwhen i >= length
        set symbolValue = WBC_CipherIndex(SubString(cipher, i, i + 1)) + 1
        call WBC_MacFeed(symbolValue)
        set i = i + 1
    endloop
endfunction

private function WBC_UpdateChain takes integer seq returns nothing
    set wbc_ChainA = WBC_PosMod(wbc_ChainA*149 + wbc_MacA + seq*31 + wbc_KeyA, WBC_MOD1)
    set wbc_ChainB = WBC_PosMod(wbc_ChainB*151 + wbc_MacB + wbc_ChainA + seq*47 + wbc_KeyB, WBC_MOD2)
endfunction

private function WBC_Encrypt takes string plain, integer seq returns string
    local integer i = 0
    local integer length = StringLength(plain)
    local integer index
    local integer stream = WBC_PosMod(wbc_Context + wbc_KeyB + seq*389 + 71, WBC_MOD1)
    local integer shift
    local integer value
    local string result = ""
    loop
        exitwhen i >= length
        set index = WBC_PlainIndex(SubString(plain, i, i + 1))
        if index < 0 then
            // Неподдерживаемые символы имени заменяются подчёркиванием.
            set index = WBC_PlainIndex("_")
        endif
        set stream = WBC_PosMod(stream*109 + 1021 + i*17 + seq*13, WBC_MOD1)
        set shift = WBC_PosMod(stream + wbc_KeyD, WBC_RADIX)
        set value = WBC_PosMod(index + shift, WBC_RADIX)
        set result = result + SubString(WBC_CIPHER, value, value + 1)
        set i = i + 1
    endloop
    return result
endfunction

function WOS2BotCodec_Begin takes string matchId returns nothing
    local integer i = 0
    local integer length = StringLength(matchId)
    local integer symbolValue

    set wbc_MatchId = matchId
    set wbc_Seq = 0
    set wbc_KeyA = WBC_PosMod(WBC_K0 + WBC_K2*3 - WBC_K4 + 17041, WBC_MOD1)
    set wbc_KeyB = WBC_PosMod(WBC_K1 + WBC_K3*5 + WBC_K5 + 29011, WBC_MOD2)
    set wbc_KeyC = WBC_PosMod(WBC_K4 + WBC_K0*2 - WBC_K1 + 39019, WBC_MOD1)
    set wbc_KeyD = WBC_PosMod(WBC_K5 + WBC_K2*2 - WBC_K3 + 49009, WBC_MOD2)

    set wbc_Context = WBC_PosMod(WBC_K0 + WBC_K3 + 19081, WBC_MOD1)
    loop
        exitwhen i >= length
        set symbolValue = WBC_PlainIndex(SubString(matchId, i, i + 1)) + 1
        if symbolValue <= 0 then
            set symbolValue = 1
        endif
        set wbc_Context = WBC_PosMod(wbc_Context*127 + symbolValue*31 + WBC_K2, WBC_MOD1)
        set i = i + 1
    endloop

    set wbc_ChainA = WBC_PosMod(wbc_KeyC + wbc_Context + 3301, WBC_MOD1)
    set wbc_ChainB = WBC_PosMod(wbc_KeyD + wbc_Context + 4409, WBC_MOD2)
    set wbc_Started = true
endfunction

function WOS2BotCodec_Header takes nothing returns string
    if not wbc_Started then
        return ""
    endif
    return "WOS2E|v=1|id=" + wbc_MatchId + "|alg=R87M2"
endfunction

function WOS2BotCodec_SealLine takes string plain returns string
    local integer seq
    local string cipher
    local string tag
    if not wbc_Started then
        return ""
    endif
    set seq = wbc_Seq
    set cipher = WBC_Encrypt(plain, seq)
    call WBC_ComputeMac(cipher, seq)
    set tag = WBC_Base36Fixed4(wbc_MacA) + WBC_Base36Fixed4(wbc_MacB)
    call WBC_UpdateChain(seq)
    set wbc_Seq = wbc_Seq + 1
    return "D|s=" + I2S(seq) + "|c=" + cipher + "|t=" + tag
endfunction

function WOS2BotCodec_EndLine takes nothing returns string
    local integer finalA
    local integer finalB
    local string result
    if not wbc_Started then
        return ""
    endif
    set finalA = WBC_PosMod(wbc_ChainA*157 + wbc_Seq*53 + wbc_KeyC, WBC_MOD1)
    set finalB = WBC_PosMod(wbc_ChainB*163 + finalA + wbc_Seq*59 + wbc_KeyD, WBC_MOD2)
    set result = "Z|n=" + I2S(wbc_Seq) + "|t=" + WBC_Base36Fixed4(finalA) + WBC_Base36Fixed4(finalB)
    set wbc_Started = false
    return result
endfunction

endlibrary
