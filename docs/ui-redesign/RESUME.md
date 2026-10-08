# Resume UI redesign

Read PLAN.md and PROGRESS.md before touching UI. Full user requirements are saved
in REQUEST.md; workflow in WORKFLOW.md. Source code takes precedence over notes.

1. Active blocks: 2/3/9; root/HUD/toolbar implemented; pick/shop style and mode layout next.
2. Existing working baseline: Crocodile integration, AllyHeroAbilityUI and five-sector TeamMapPings; prior WTG/WCT order repair already implemented.
3. Implemented and compiled: WOSUI.j, 13 normal FRAME parent migrations, 10 shared UI assets/importer, Z release-to-send/no sector labels. Actual game verification NOT done.
4. Current implementation: WOSUI native layout (0.20s), existing HeroUnitPanelStats rewritten, test help replaces tags, top HP/MP guards and hide-subtree. Compile PASS; toolbar wired to real shop/K handlers; window styles incomplete. MAIN not written yet.
5. Open next: WOSUI.j, DefaultArmorChangeStable_Copy.j, WoS_Hero_Icons_Init.j, Systems/ButtonPressed.j, ChatCommand.j; ARCHITECTURE.md + FRAME_INVENTORY.md.
6. Risks: hidden Console parents; native SIMPLEFRAME cannot be reparented to normal FRAME; local handle allocation; hidden enemy HP/MP. No new compile error known.
7. HUD/native/privacy/shop/import tests: `python -m unittest discover -s tools -p test_wos_ui.py` (9 PASS). Full compile 146697 lines PASS. Fast bounded full compile: `python tools/check_wos_ui.py` (PASS); full build `.vscode/build-run-w3-map.ps1 -Target Main -NoLaunch`; tests `python -m unittest discover -s tools -p test_team_map_pings.py` (21 PASS), `test_sync_war3_triggers.py`, `test_test_map_workflow.py`.
8. Continue: pick/shop window skins/layout; CaptainDraft/UI_CAREER/MusicPlayer alias parents still need inspection. Inspect source before each change.
9. Do not recreate hero selection/shop/HeroIcons/ability data or repeat audit/root migration/Z fix/trigger order repair. Do not rerun tools/migrate_wos_ui_roots.py without a new reason. Do not restore current dirty files wholesale.
10. Agreed style: compact graphite/black, thin gold, native icons/logos, actual combat stats, seven real QWERTFG abilities, preserve all handlers and hotkeys.

Native MAIN is a Scenario Folder at `C:/Users/Gear/Documents/Warcraft III/Maps/WoS/Anime_WOS2_0.32.w3x`.
World Editor must be closed before native saves. Inspect its process state each time.
Do not claim compiled-only code works in game. Completion statuses and runtime
verification are separate. No subagents were requested.
