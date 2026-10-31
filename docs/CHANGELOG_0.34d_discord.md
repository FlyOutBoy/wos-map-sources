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
• **Elemental actives** — every stat now has Fire / Water / Lightning as a single-target and an AOE item (element zanpakuto + stat tome, 7500 gold, shared cooldown per element; one active item per element). Nothing hits instantly: projectiles, delayed blasts, pulses, burns and smooth pulls/knockbacks
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
• **Naofumi Shield Evolved** — blocks 30 damage per hit (100 during the active)
• **Sukuna's Finger** (INT) — 7 sec: no HP restoration, 15% slow, can't be dispelled
• **Five Elements Seal** (AGI) — 7 sec mana seal + a lock: removing it or casting = 2 sec silence
• **Rokushiki: Tekkai** — blocks basic attack damage and on-hit effects for 4 sec
• **Samehada** — attacks restore 5% of your mana and drain 5% of the target's
• **Will of D.** (AGI) — lethal damage can't drop you below 1 HP for 3 sec, CD resets every round
• **Kairoseki Cuffs** — removes all positive buffs, target deals 18% less damage for 4 sec
• **Hyorinmaru Ice Coffin** — 2 sec frozen and invulnerable, CD 50. Own hotkey (default: its slot number), works even while stunned; rebind with the CHANGE button or `-coffin <key>`, saved with Save Keys
• **Return by Death** — returns you to your marked position after 4 sec while its positive buff remains; Kairoseki Cuffs and other positive-buff dispels cancel it
• **Evolved:** Fairy Tail Emblem, Ryujin Jakka, Nejibana, Gonryomaru, Mirror of Yata, Philosopher's Stone

**🛡️ Item balance**
• Naofumi Shield / Evolved: cooldown 24 → 27 sec
• Raijin's Wrath, Red Cup, Rhitta ×5.5; Red Flower, Shark Trail ×6. Built from Gonryomaru / Nejibana / Ryujin Jakka + Tome +20, 7500 gold, +10 main stat +15 allstats. New icons
• Sacred Gear Booster bonus 2.5x (was 3x)
• Damage-active item cast range is 1400 (including Shiki Knife Evolved)
• Kusanagi cast range 1400; elemental Kusanagi can be swapped to another element in the shop for free
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


**Item balance follow-up**

- Damage actives cost 125-175 mana; Shiki Knife Evolved costs 80 and Return by Death costs 125. Utility actives, Bunshin Scroll and Slime mode switches cost no mana.
- Fire, Water and Lightning actives share their element's cooldown; only one active item of each element can be purchased. New items now have crafting recipes.
- Damage-active cast range is 1600; Shiki Knife Evolved is 2100. Raijin's Wrath radius is 450. Most elemental actives deal up to 5x their stat per target before external bonuses; Shark Trail and Red Flower retain 6x and fly 25% faster. Crimson Scripture deals less impact damage and more lingering damage.
- Physical resistance gained from Agility and magic resistance gained from Intelligence increased by 25%.
- Samehada restores and drains 5% max mana; clones cannot trigger it or be drained. Starrk's triggering attack activates it once; Cero hits do not. Tekkai blocks attack on-hit effects during its active.
- Naofumi Shield Evolved blocks 30 damage passively and 100 during its active. Philosopher's Stone heals 50% less from creeps.
- Siren's Tear drains up to 20% max mana, capped at 2.5x Intelligence, with all eight drain ticks applied.
- Quincy Cross now amplifies elemental damage; reaction damage is recorded under the resolved reaction. Koko Gonryo Rikyu's Lightning damage can trigger Tachikaze.
- Leviathan's Anchor pulls more strongly and no longer creates a tornado. Return by Death's original visual effects are restored. Assigning Hyorinmaru's hotkey no longer casts the item immediately.

- Okarun Q cooldown increased by 2 sec at every rank.

- Frozen Heart and Fairy Tail Emblem Evolved mana recovery amplification reduced from 20% to 15%. Base mana regeneration per Intelligence reduced from 0.20 to 0.15.
- Core Drill now gains stacks from periodic non-attack damage, including Kurikara and Ashisogi Jizo.
- True Zangetsu and Nichirin resistance reduction lasts 10 sec. Inori's Mana Ascension aura cannot lower either resistance below 0%.
- Inori E can be learned later even while its alternate ability is displayed. Instant items and selected hero buttons preserve movement/attack orders.
- Blood Pact Ring Evolved costs 5000, grants +15 all stats and +250 mana, and has a 20 sec cooldown.
- Emberbreaker deals 4x STR on impact, 3x STR over 4 sec and up to 1x STR as retaliation (8x total). Leviathan's Grasp heals for 30% of damage dealt without a separate cap; Siren's Tear returns 30% of mana drained.
- Cinder Fang ricochets up to three times. Its 3 sec seal blocks HP/MP recovery and lets the caster's next attack or ability hit deal bonus damage.
- Mirror Tide marks wave targets for 3 sec. Attacks and abilities trigger a ricochet once per second; the next target may be a clone or an enemy outside the wave.
- Volt Thread lasts 5 sec: the target takes 0.3x AGI per second; other enemies near the thread take 0.9x AGI. Dispelling the mark breaks the thread.
- Conditional elemental effects and their separate burns end when dispelled. Conditional damage bonuses increased, with lower base damage where needed.
- Ashen Crossfire and Constellation Coil projectiles travel 1800. Constellation's collision width increased by 50. Removed the remaining Anchor whirl effect.
- Active items damage nearby scenery. Quincy Cross crafts through the maximum Pakkun upgrade.
- Five Elements Seal can silence invulnerable targets. Test rounds end after the main heroes remain dead for 3 sec, even if a test ally survives.
- Heroes embedded in buildings or blocked terrain are checked every 2 sec and moved to nearby clear ground. Other players' HUD size changes no longer reposition your gold.

- Purchases and FAST BUY are blocked during rounds outside Test Mode; Test Mode still permits purchases anywhere.
- Patriot no longer receives a second expiry kill after dying during his temporary revival.
- A hero surviving at 1 HP keeps a visible HP sliver in the top portrait and remains vulnerable to spells after survival protection expires.

- Will of D.: cooldown reduced from 600 to 180 sec. Dispelling its positive buff, including with Kairoseki Cuffs, ends its survival protection.

- Reduced tooltip initialization overhead before mode selection: descriptions are prepared once after their properties are configured, unchanged text is reused, and ability parameters use one shared probe instead of hundreds of temporary units.

- Fixed shop help text spilling across the screen during startup.
- Ally/enemy color Mode 3 is enabled by default; Alt+A still switches modes.

- Phoenix Seal drops onto its target after 0.3 sec, burns for 3 sec and deals 2x INT when the target casts a hero ability.
- Crimson Scripture erupts after 0.44 sec for 4x INT, then deals another 4x INT over six pulses in 1.2 sec.
- Leviathan's Anchor strikes three times every 0.6 sec for 2.25x STR each, with a -180-degree initial descent, alternating +/-90-degree tilt and shifting impact centres, a 40% slow, water and ground impacts, and a smooth final fade.
- Mirror Tide grows as it travels. Hits above 100 damage from any source trigger a ricochet toward the marked target's nearest ally, once/sec, up to three times.
- Constellation Coil pushes enemies slightly, then spins at max range for 2 sec, dealing 1x INT every 0.5 sec in a growing area.
- Ashen Crossfire projectiles travel 40% faster with fire trails and corrected facing; they return to the caster position captured at turnaround.
- Return by Death returns after 5 sec while preserving the hero's order. Restored Ice Coffin's custom visual.

- Suzumebachi: Electrized bonus damage increased from 80% to 125%; price increased to 6000 gold.
- Tobiume: Overload bonus damage increased from 100% to 175%. Zanka no Tachi: Fire reapplication damage cap reduced to 240/sec.
- Demon-Dweller Sword: buff lasts 4 sec. Koko Gonryo Rikyu: Lightning bonus increased to 0.5x main stat/sec. Tachikaze: damage increased to 1x main stat.
- Earth Power: damage increased to 2.5x main stat. Nichirin and True Zangetsu reduce their respective resistance by 18%.

- Improved control recovery after Ice Coffin. Restored normal spell windup animations and order resets.
- Ashen Crossfire weapons are raised by 60 while their fire trails keep their previous height. Phoenix Seal accelerates its animation before impact.
- Ranged heroes attack 0.3 sec slower at base, including their ranged forms. Inori's base attack damage reduced from 20 to 10 in both forms.

- Replacing the main hero during a Test Mode round immediately ends combat and returns remaining heroes through the normal round cleanup.

- Frostnova, Ainz and Frieren: base attack damage reduced from 20 to 10. Alucard keeps 20 in both forms.
- Leviathan's Anchor uses its original model with attached water, a scripted fall and two parabolic rebounds.

- Fixed missing or misplaced instant ability buttons, including Bambietta W and Laxus F/G, and removed inherited stock cast effects.
- Inori correctly shows the active E at four Instability stacks. Her crystal forms now use a 1.8 sec base attack interval and restore 2 sec on exit.
- Starrk: base attack interval increased by 0.3 sec.
- Spell cancellation with S responds on key press and remains available across hero forms.
- Removed the unintended Blood Mage Flame Strike sounds from Milim W2.
- Leviathan's Anchor uses direct terrain height and a single position update for its scripted fall and rebounds.
- Widened and moved the shop gold display left to prevent long totals from wrapping.

- Removed unintended native damage, regeneration and stat bonuses from instant utility buttons.
