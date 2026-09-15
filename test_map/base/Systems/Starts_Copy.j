globals
    dialog udg_ModeDialog
    button udg_TestButton
    button udg_NormalButton
    button udg_CaptainButton
    boolean TestMode = false
    boolean CaptainMode = false
    integer PickedMode = 0
    real array poscamx 
    real array poscamy 
    texttag  ShopInfo 
    string array PlayerShopBut
    integer PlayersAmount = 0
endglobals
globals
integer KEY_PHYS_RES
integer KEY_MAG_RES
integer KEY_PATRIOT_E
integer KEY_ALUCARD_G2
integer KEY_ALUCARD_G3
integer KEY_MODE_G
integer KEY_HARI_G2
integer KEY_BLUE_EMPEROR_RES
integer KEY_ERZA_G2_TYPE
integer KEY_ERZA_G2_ACTIVE
integer KEY_T_ARMOR_ACTIVE
integer KEY_TOMIOKA_F_INVUL
integer KEY_TOMIOKA_F_DMG_ACT
integer KEY_ZERO_KAI
integer KEY_RT
    integer KEY_DEF_T
    integer KEY_IMM_F
endglobals
function CreateKeys takes nothing returns nothing 
set KEY_PHYS_RES         = StringHash("phys res")
set KEY_MAG_RES          = StringHash("mag res")
set KEY_PATRIOT_E        = StringHash("patriot e")
set KEY_ALUCARD_G2 = StringHash("alucard g2")
set KEY_ALUCARD_G3 = StringHash("alucard g3")
set KEY_MODE_G           = StringHash("mode g")
set KEY_HARI_G2          = StringHash("hari g 2")
set KEY_BLUE_EMPEROR_RES = StringHash("blue emperor res")
set KEY_ERZA_G2_TYPE     = StringHash("erza g2 type")
set KEY_ERZA_G2_ACTIVE   = StringHash("erza g2 active")
set KEY_T_ARMOR_ACTIVE      = StringHash("t armor active")
set KEY_TOMIOKA_F_INVUL     = StringHash("tomioka f invul")
set KEY_TOMIOKA_F_DMG_ACT   = StringHash("tomioka f dmg act")
set KEY_ZERO_KAI            = StringHash("zero kai")
set KEY_RT    = StringHash("rt")
set KEY_DEF_T = StringHash("def t")
set KEY_IMM_F = StringHash("imm f")
endfunction 
function InitTrig_ModeDialog takes nothing returns nothing

     set NoDecor_Cond = Condition(function NoDecor_Filter)
     call CreateKeys()
     call InitCloneVisualCleanup()
endfunction
//===========================================================================
function InitTrig_Starts_Copy takes nothing returns nothing
    set gg_trg_Starts_Copy = CreateTrigger(  )
    call TriggerRegisterTimerEvent(gg_trg_Starts_Copy, 0.5, false)
    call TriggerAddAction( gg_trg_Starts_Copy, function InitTrig_ModeDialog )
endfunction

