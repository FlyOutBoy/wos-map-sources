# Resume UI redesign

Read PLAN.md, PROGRESS.md and relevant ARCHITECTURE.md before editing. The user's
full requirements are REQUEST.md; mandatory staged workflow is WORKFLOW.md.
Source code and actual map state take precedence over these notes.

1. Active blocks: 2/3/4/5/6/7/8/9. Core/HUD/toolbar/pick/shop implementation compiled;
   secondary surfaces now implemented; MAIN integration waits for editor closure.
2. Existing baseline to preserve: Crocodile integration, AllyHeroAbilityUI enemy
   tooltips without cooldowns, five-sector TeamMapPings and WTG/WCT traversal repair.
3. Implemented: WOSUI independent service-board root + native commands/items/buffs/
   minimap/menu; compact existing selected HUD; TestMode scroll/collapse help; top
   visible-only HP/MP; real shop/K toolbar; emoji checkbox; Z release-once/center text.
   Existing pick/shop compact layouts and graphite skins are now written.
4. Latest full compile PASS: 146833 pjass lines. Production tests: HUD/docks 13, pings 21,
   ally ability UI 7, trigger sync 3, workflow 8 PASS. No actual game verification.
   MAIN still untouched by this task: World Editor running. Do not claim runtime PASS.
5. Open next: sync_war3_project.py guard, sync_war3_triggers.py, verify_wos_ui.py, then WOSUI.j and
   check_wos_ui.py/build script. FRAME_INVENTORY.md lists all 45 production owners.
6. Fixed alias roots: Captain_Draft/UI_CAREER/MusicPlayer; these must remain outside
   Console. Native SIMPLEFRAMEs stay in native hierarchy. Service board root stays
   visible with title/backdrop hidden, all players associated, native size zero.
7. Validate: python tools/check_wos_ui.py; python -m unittest discover -s tools -p
   test_wos_ui.py (13), test_team_map_pings.py (21), test_ally_hero_ability_ui.py (7),
   test_sync_war3_triggers.py (3), test_test_map_workflow.py (8). Full build:
   powershell .vscode/build-run-w3-map.ps1 -Target Main -NoLaunch (requires WE closed).
8. Native audit passed (108 baseline sources unchanged); check prepares 109 sources.
   Pending question already asks user to close WITHOUT saving. Do not ask it again.
   After closure, guarded push/build/extract/verify. Guard in
   tools/sync_war3_project.py prevents an open editor overwriting external triggers.
9. Do not repeat audit/root migration/command or shop controller implementation.
   WOS_ToggleShop is the shared real shop handler; .evaluate bridges plain map
   function ordering. K belongs to EmojiStandalone; no duplicate key-down handler.
10. Agreed style: graphite/thin gold/native logos/icons, no fake slots/stats. Core
    assets 13 RGBA TGA + unchanged built-in imagegen source, install_wos_ui_assets.
    Current compact pick/shop geometry is centralized in WOS_LayoutHeroPick and
    WOS_LayoutShop. Preserve handlers, rawcodes, recipes, selection and purchases.

Pending: in-game native item/learn card/buff/menu hierarchy, attack range formatting,
resolution changes, fog/multiplayer; final top-panel/menu styling; 45-owner
hero counters and remaining windows. PLAN statuses intentionally IN_PROGRESS.
Checkpoints: 654b679 shared core/assets/docs/tests; e64d873 traversal repair;
bff70cb compact HUD/toolbar/pick/shop/secondary surfaces; 3d92d32 dynamic docks.
Checkpoint 7 special windows is the current change until its commit is recorded.
Preserve source changes and ignored backups; do not redo completed migrations.
Native MAIN: C:/Users/Gear/Documents/Warcraft III/Maps/WoS/Anime_WOS2_0.32.w3x (Scenario Folder).
Build filename _build/WoS_Test.w3x is still the MAIN packed test output, not test_map.
No native computer UI automation is available. No subagents were requested.

Latest secondary skins: career/music/emotes/chat/player stats; scoreboard transparency
retained. Camera placement implemented. Current explicit pending user input: editor
closure; do not proceed with dependent native writes until reply and process check.
Archive extraction list _build/ui-redesign/archive-names.json (33 entries).
Verify command: python tools/verify_wos_ui.py --archive _build/ui-redesign/archive.
Use .vscode/test-map-archive.ps1 -Mode Extract with build MPQ and bundled SFmpq.dll.

Latest user addition: shared dynamic hero-meter and unit-buff placement. WOSUI
registers 45 existing active six-frame meters across 28 files. A native-only buff
strip handles GearSystems2 MyFrame/MyFrameBuff and Kenjaku/Tsuna small counters.
Native charge box stays attached to actual command buttons, now .012 size.
Open DYNAMIC_METERS.md for APIs and presentation-only boundaries. Registration
must remain synchronous; dock refresh never alters game state or visibility.
One-time tools/migrate_wos_ui_meters.py already applied; do not rerun it.
Erza Second Origin's two-icon meter now attaches to the same dock (46 total).
Inori weapon selection is compact with native scrollable real descriptions;
selector follows actual weapon buttons. Kyoraku help/control now fit 4:3 bounds.
Next independent work while editor closure is pending: compact top score styling,
then inspect remaining vote/options/tooltips from FRAME_INVENTORY without re-audit.
