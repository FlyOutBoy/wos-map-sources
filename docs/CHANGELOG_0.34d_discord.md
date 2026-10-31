**War of Souls 2 — Update 0.34d** ⚔️

**🧙 Heroes**
• All heroes: **+200 base HP** (250 → 450)
• **Inori** — now a ranged hero: shoots Alucard's bullets; in E and T2 she shoots small crystals instead. From level 25, selecting T1 upgrades E to an automatic rank 6 (+10% physical and magic resistance). Selecting T2 restores rank 5; during T2 the allied aura is disabled and enemies within 1400 radius lose 10% physical and magic resistance
• **Okarun** — F speed builds up 15% slower. R: no invulnerability during the dash, only during the combo
• **Mahoraga** — R lasts 2 sec and heals every 0.5 sec (same total heal)
• **Ainz** — Ring of Mines (F → Q) places 5 mines, they live 30 sec. Mine damage −0.2x INT per level
• **Bazz B** — abilities apply Fire from level 12 (was 35)
• **Alter Saber** — R transformation 0.25 sec (was 0.75). R2 field 3.5 sec, root 2.5 sec
• **Crocodile** — Q+W combo: 0.7 sec stun and a weaker pull; full 1.5 sec stun and pull from level 25. T2 keeps the T damage resistance
• **Frostnova** — base move speed 275. Q mana 70/75/80/85/90. T song shield buff lasts 2 sec
• **Gojo** — lighter T effects (better FPS)

**✨ New items**
• **Elemental actives** — every stat now has Fire / Water / Lightning as a single-target and an AOE item (element zanpakuto + stat tome, 7500 gold, each with its own cooldown). Nothing hits instantly: projectiles, delayed blasts, pulses, burns and smooth pulls/knockbacks
  • STR: **Emberbreaker**, **Leviathan's Grasp**, **Leviathan's Anchor** (whirlpool), **Thunder Verdict**, **Thunder Bastion** (storm + counter charges)
  • AGI: **Cinder Fang** (ricochet), **Ashen Crossfire** (returning shuriken), **Mirror Tide** (wave + mirror), **Volt Thread**
  • INT: **Phoenix Seal**, **Crimson Scripture** (rune circle + burning ground), **Siren's Tear** (mana drain), **Constellation Coil** (lightning spiral + chain)
• **Bleach zanpakuto** (Universal, 5500 gold, +15 allstats):
  • **Zanka no Tachi** — your Fire burns 7 sec at 70/sec; each re-application +40/sec (up to 300) and restarts the 7 sec
  • **Kyoka Suigetsu** — your Fire or Water turns into Steam; Fire or Water on Steam refreshes it and deals 0.6x main stat; Steam +8% physical damage from you
  • **Koko Gonryo Rikyu** — your Lightning deals 0.2x main stat every second
  • **Tobiume** — Overload deals +100% damage and stuns 0.4 sec longer
  • **Suzumebachi** — Electrized deals +80% damage
• **Blood Pact Ring** (STR, 2500 gold) — sacrifice 400 HP for 400 mana, CD 12
• **Blood Pact Ring Evolved** (7500 gold, Ring + Pakkun) — +20 allstats; for 5 sec, refills mana to a 25% minimum and protects that minimum. Five Elements Seal overrides the effect; CD 12
• **Armament Haki** / **Evolved** — blocks the next debuff (Evolved: + 3 sec debuff immunity), CD 15
• **Naofumi Shield Evolved** — blocks 40 damage per hit (100 during the active)
• **Sukuna's Finger** (INT) — 7 sec: no HP restoration, 15% slow, can't be dispelled
• **Five Elements Seal** (AGI) — 7 sec mana seal + a lock: removing it or casting = 2 sec silence
• **Rokushiki: Tekkai** — blocks all basic attack damage for 4 sec
• **Samehada** — attacks restore 4% of your mana and drain 4% of the target's
• **Will of D.** (AGI) — lethal damage can't drop you below 1 HP for 3 sec, CD resets every round
• **Kairoseki Cuffs** — removes all positive buffs, target deals 18% less damage for 4 sec
• **Hyorinmaru Ice Coffin** — 2 sec frozen and invulnerable, CD 50. Own hotkey (default: its slot number), works even while stunned; rebind with the CHANGE button or `-coffin <key>`, saved with Save Keys
• **Return by Death** — returns you to your marked position after 4 sec while its positive buff remains; Kairoseki Cuffs and other positive-buff dispels cancel it
• **Evolved:** Fairy Tail Emblem, Ryujin Jakka, Nejibana, Gonryomaru, Mirror of Yata, Philosopher's Stone

**🛡️ Item balance**
• Naofumi Shield / Evolved: cooldown 24 → 27 sec
• Raijin's Wrath, Red Cup, Rhitta ×5.5; Red Flower, Shark Trail ×6. Built from Gonryomaru / Nejibana / Ryujin Jakka + Tome +20, 7500 gold, +10 main stat +15 allstats. New icons
• Sacred Gear Booster bonus 2.5x (was 3x)
• Active item cast range capped at 1600 (Shiki Knife Evolved 2100)
• Kusanagi cast range 1425; elemental Kusanagi can be swapped to another element in the shop for free
• Black Heart / Sword of Mihawk: +7 per stack
• Witch Sin 21% magic res, Emperor's Blue Armor 23% phys reduction, Jewel of Four Souls heals 500 + 3% max HP — all 6000 gold
• Lust Sin CD 7 · Wrath Sin CD 23 · Susanoo 105 mana · Quincy Cross +45
• Philosopher's Stone 18%, 5000 gold · Black Clover +1% damage reduction per stack
• Incursio +5 HP / +2.5 MP regen · Shiki Knife Evolved active CD 9 · Hashirama Cells active +20 STR
• Okarun Egg / Prison Realm: 5500 gold, +25 stat, 15 HP regen
• Mirror of Yata 6000 gold, 30% reflect · Mirror of Yata Evolved active 4 sec · Kairoseki 6000 · Armament Haki Evolved 7500
• Chogurt Evolved: aura +8 mana regen (1500 range)
• Bunshin Scroll and Turbo Neko can't be carried together

**🐛 Fixes**
• Silenced selected units show Silence on the portrait and chains over their skill buttons; both clear when silence ends
• Mirror of Yata cannot reflect damage back to an attacker protected by Naofumi Shield; reflection cannot feed offensive item proc loops
• Samehada works with Starrk E and Raiden magic basic attacks. Kirito R strikes count as basic attacks: 2 quick hits or 4 strong hits, keeping total damage
• Fixed lingering Gonryomaru Lightning effects after the debuff ends
• Elemental and poison damage no longer feed item proc loops. Ryujin Jakka cannot trigger itself from its explosion or Fire damage
• Non-Fire debuffs allow one refresh from item damage per application; ability damage can keep refreshing them. Fire has no refresh limit
• Movement skills cast while rooted no longer go on cooldown or cost mana
• Lust Sin now pierces the Laxus T / Mahoraga ult shields
• Jewel of Four Souls healed the enemy instead of you
• Evolved items can be upgraded from their base item again
• Evolved Ryujin / Nejibana / Gonryomaru apply their element on every strong hit, even while the explosion is on cooldown
• Evolved Philosopher's Stone and Mirror of Yata can be activated
• Elemental debuffs now apply to clones too
• Angel's Blessing shows its heal numbers again
• Universal shop tab gets a second page
• Several hero ultimate and item edge cases

**⚙️ Interface & performance**
• Periodic heals/regen no longer spam green numbers — shown as **+regen** on the HP/MP bar
• Lighter progress/buff bars and timed buff icons → fewer FPS drops on casts
• Lighter Fire debuff effect (fewer particles, narrower flames)
• **AUTOBUY** button: green when on, red when off
• Shift + RMB on a Quick Buy item (shop or HUD) or on the recipe tree tells allies: "I'm going to buy …"
• Range preview for items: red ring = where you can click, white ring = range + AoE
• Inventory: wider cells with a gap between the rows, longer dividers
• New ally color (Alt+A) button icons; hero portrait slightly lower
