// TEST map lacks the sound handles referenced by the current MAIN hero family.
library TestKyorakuSounds initializer Init
globals
    sound gg_snd_Hero_Kyoraku_T6 = null
    sound gg_snd_Hero_Kyoraku_T14__2 = null
endglobals
private function Init takes nothing returns nothing
    set gg_snd_Hero_Kyoraku_T6 = CreateSound("war3mapImported/Hero_Kyoraku_T6.mp3", false, false, false, 1, 1, "SpellsEAX")
    call SetSoundDuration(gg_snd_Hero_Kyoraku_T6, 8832)
    call SetSoundChannel(gg_snd_Hero_Kyoraku_T6, 0)
    call SetSoundVolume(gg_snd_Hero_Kyoraku_T6, 127)
    call SetSoundPitch(gg_snd_Hero_Kyoraku_T6, 1.0)
    set gg_snd_Hero_Kyoraku_T14__2 = CreateSound("war3mapImported/Hero_Kyoraku_T14 _2.mp3", false, false, false, 0, 0, "DefaultEAXON")
    call SetSoundDuration(gg_snd_Hero_Kyoraku_T14__2, 19200)
    call SetSoundChannel(gg_snd_Hero_Kyoraku_T14__2, 0)
    call SetSoundVolume(gg_snd_Hero_Kyoraku_T14__2, 127)
    call SetSoundPitch(gg_snd_Hero_Kyoraku_T14__2, 1.0)
endfunction
endlibrary
