# MAIN integration after editor closure

User confirmed closure and checkpoint 10 integration has completed successfully.
These steps are retained for subsequent changes; do not bypass the process guard.
World Editor does not reload external WTG/WCT and can overwrite corrected sources.
The build now rejects an open editor before changing MAIN source/imports; a later
compiled-script guard also protects against the editor opening during compilation.

## 1. Confirm process state, then push

Run from C:/Users/Gear/Desktop/WOS/VS WOS. Record git status before build. No native
writes until user confirms closure AND the process check below returns False.

```powershell
python -c "import sys;sys.path.insert(0,'tools');import sync_war3_project as p;print(p.world_editor_running())"
python -c "import sys;sys.path.insert(0,'tools');import sync_war3_project as p;import sync_war3_triggers as t;from pathlib import Path;assert not p.world_editor_running(),'World Editor is running';t.push(Path('object-data.config.json').resolve(),Path('triggers').resolve(),Path('backups/trigger-sync').resolve())"
```

Native scenario: C:/Users/Gear/Documents/Warcraft III/Maps/WoS/Anime_WOS2_0.32.w3x.
Sync creates backups and validates source identities/category traversal. Expect
109 native trigger/script sources (new WOSUI). Review generated manifest/settings.

## 2. Build real MAIN and verify native map

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .vscode/build-run-w3-map.ps1 -Target Main -NoLaunch
python tools/verify_wos_ui.py
```

Expect 13 UI + 16 ping resources, old imports retained, full MAIN logic compiled.
_build/WoS_Test.w3x is the packed MAIN test output. tools/check_wos_ui.py uses an
empty main solely to validate source; NEVER use its output as playable map script.

## 3. Independently compare packed archive

```powershell
python tools/verify_wos_ui.py --names-output _build/ui-redesign/archive-names.json
powershell -NoProfile -ExecutionPolicy Bypass -File .vscode/test-map-archive.ps1 -Mode Extract -Map _build/WoS_Test.w3x -Directory _build/ui-redesign/archive -Library "E:/WAR3REF/Warcraft III/_retail_/x86_64/JassHelper/sfmpq.dll" -NamesFile _build/ui-redesign/archive-names.json
python tools/verify_wos_ui.py --archive _build/ui-redesign/archive
```

Extraction script handles 32-bit SFmpq compatibility. All 33 entries must match
native map bytes: WTG/WCT/imp/compiled script + 29 resources. Verifier derives WCT
identities directly from WTG names/categories, independent of the new manifest.

## 4. Save checkpoint and retain verification boundary

Record actual compile result, backup paths, archive path/hash, source/resource
counts and checks in PROGRESS/PLAN/ARCHITECTURE/RESUME. Commit coherent owned edits.
Build can dirty five tracked generated files; restore ONLY if proven clean before
this build: map_source/backups/backupsdata.txt and map_source/logs/currentmapscript.j,
inputwar3map.j, outputwar3map.j, pjass.txt. Preserve actual map source/imports and
all unrelated user work. Never blanket-reset.

Native/archive success is not a game test. Complete OWNER_STATUS.md runtime matrix
when actual Warcraft interaction/visual/multiplayer evidence is available. Until
then report native input/hover/drag/menu/resolution/fog behavior as unverified.
