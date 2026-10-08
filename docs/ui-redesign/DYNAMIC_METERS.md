# Shared hero meter and unit buff docks

Owner: `triggers/WOS_Start/WOSUI.j`. Current implementation compiled; actual
Warcraft visibility, fonts and movement still need a game run.
Native MAIN and _build/WoS_Test.w3x now include this implementation (checkpoint 10);
full map build, source identities and packed UI resource bytes verified.

- `WUI_HeroMeter(panel, back, bar, icon, title, value)` styles six existing handles.
- `WUI_RegisterMeter(panel, playerId, stableKey)` attaches a private hero meter.
- `WUI_RegisterPublicMeter(panel, stableKey)` retains existing public meter visibility.
- `WUI_RegisterBuff(simpleIcon, normalTextOrNull, playerId, stableKey)` attaches a
  unit buff timer / small counter. SIMPLEFRAME remains under native ConsoleUI;
  normal text remains under independent root, numeric coordinates join them.
- `WOSHeroMeter.add(playerId, key, iconPath, caption, maximum)` creates a new meter
  using the same style/registry. Its `update(amount, text)` and `show(visible)`
  methods preserve the caller's real data and owner-only visibility. Destroy it
  synchronously to remove its registry handle safely.

Create/register synchronously, never inside GetLocalPlayer. Stable keys include
owner, source and semantic slot. Rebinding a recreated panel replaces and hides
the old visual without growing the registry. Current finite key space is under
the JASS 8192-entry array bound. Changes in local coordinates never drive gameplay.

Private panels: X=.075, first Y=.162, spacing .030. Unit buff chips: first X=.178,
Y=.144, spacing .026, wrap at 20; orders drawer moves strip up to Y=.181.
Public meters: two columns X=.325/.475, first Y=.490, row spacing .030.
Only locally visible registered frames occupy slots. Disappearing panels reclaim
space with 60% interpolation each .10s. Settled coordinates stop native rewrites.
Refresh does not grant vision or change any owner's visibility rules.

45 active six-frame meter sites in 28 hero/system files migrated once with
`tools/migrate_wos_ui_meters.py`; non-presentation source fingerprint matched.
Do not rerun the migration. Commented Milim/Mahoraga prototypes were preserved.
GearSystems2 MyFrame/MyFrameBuff timers support ordinary units as before; their
native icon + independent timer text now share the buff strip. Kenjaku barrier
and Tsuna beam chips use the same registry. TasAbilityChargeBox retains native
command parenting and actual charge data, with compact .012 badges.

Erza Second Origin's two-icon meter now adds a 46th registered meter, with both
icons, original progress range, switch conditions and selection sprite retained.
Inori weapon selection and Kyoraku public help drawer are compact graphite windows;
their original handlers and visibility rules remain. Inori long descriptions now
scroll instead of relying on a fixed plain-text box. All need actual game preview.
Production dock tests cover gap closure, smooth movement, idle update suppression,
buff-label attachment/orders avoidance, private ownership and stable key rebinding.
