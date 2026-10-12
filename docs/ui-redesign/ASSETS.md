# UI assets

Checkpoint 20 (Claude, 2026-10-09): `tools/build_wos_ui_textures_cp20.py` generates
27 deterministic RGBA TGA (no external art): line-h/line-v hairlines, gem,
fill-normal/hover/pressed/selected/disabled/primary, tab, panel-soft (graphite with
baked alpha 228), slot-empty, divider-v/h, icon-attack/phys/magic, pip-empty/full/
ready, learn-glow, badge, glyph-repick/swap/camera, slider-track/thumb. It also
rebuilds ornate-top/bottom/left/right by replicating the corner rail-exit pixel
profiles (32 px thick, centred), removing stray crop rows. Corner art unchanged.
New FDF: WOSControls.fdf (SLIDER "WOSVerticalSlider"), last entry of Templates.toc.
WOSNativeEmptyAbility now uses slot-empty.tga. Installer total: 55 UI/WOS TGA.

Checkpoint16 adds code-generated UI/WOS/empty.tga:32x32 uncompressed RGBA,
all alpha zero. BACKDROP vertex tint was ignored by the user's Warcraft build.
Installer/verifier reject opaque pixels. Builder now produces22 shared TGA;
expected total41 resources/46 compared packed entries. Original generated gold
slices/graphite are unchanged; corner and rail dimensions grow15% in WOSUI.j.

Checkpoint 13 adds ONE built-in imagegen asset, saved unchanged as
`assets/UI/WOS/source/ornate-frame.png` (RGBA 1254x1254, transparent interior and
exterior). Mode: built-in tool, new transparent generation, no external API/CLI.
Prompt and provenance: `assets/UI/WOS/source/ornate-frame.json`.
Four 256x256 corner crops, two 128x32 horizontal rails and two 32x128 vertical rails
are exported as `ornate-{tl,tr,bl,br,top,bottom,left,right}.tga`. Corners stay square
in game; rails stretch independently. Cropping/resampling only, no repainting.
`WOSHUD.fdf`/TOC now define the IGNORETRACKEVENTS passive FRAME template,
opaque native BACKGROUND chassis and seven passive empty native ability cells.
Texture initialization is explicit; do not call unsafe visibility/scale on native Texture children.
Verified packaging: 21 shared TGA + 16 ping TGA + clock MDX + FDF/TOC = 40
resources; with native WTG/WCT/imports/script/skin = 45 verified packed entries.
Latest source changes have compile/test evidence; final Warcraft appearance still
requires a new actual game screenshot after integration.

- Built-in imagegen source: `assets/UI/WOS/source/graphite.png` (unchanged copied output).
- Production request: ONE seamless square almost-black #0d1118 graphite material,
  very low contrast, no objects, borders, writing, logos, bright corner gradients,
  ornaments or glow. Intended as actual game-panel background behind small text.
- Deterministic pixel geometry for accurate small states/borders: `tools/build_wos_ui_assets.py`.
- Production TGA assets in `assets/UI/WOS`: panel (512²), border/button/hover/pressed/
  selected/disabled (128²), hp/mp/meter/bar-back (256×16), checked/unchecked (64x64), all 32-bit RGBA.
- Registration/copy: `python tools/install_wos_ui_assets.py --map <MAIN folder>`;
  installer preserves existing import bytes and backs up changed resources.
- Existing `assets/UI/TeamPings` 16 wheel/minimap/toolbar textures remain usable.
- No downloaded/external runtime resources. Every game path is inside map imports.
- Runtime style quality has not yet been inspected in Warcraft.
- Checkpoint 10: all 13 shared UI + 16 ping resources installed/registered in MAIN;
  extracted packed archive bytes match the native scenario and project assets.

- Checkpoint 12 adds UI/WOS/empty-clock.mdx: classic v800 MDX header, one Stand
  sequence, no render geometry, textures or emitters. Replaces TimeOfDayIndicator.
- Ten owned CustomSkin keys blank stock console, two overlay textures and inventory
  cover; installer preserves other skin sections/keys and backs up changes.
- MAIN now includes 30 UI/ping resources. Skin + model included in packed-byte
  verification (35 entries). Engine appearance remains unverified.

TOC parser contract (checkpoint 15): WOSHUD.toc is UTF-8 without BOM, exact CRLF
plus empty ending line. Git preserves bytes (-text); installer validates before
mutating MAIN and verifier checks project/native/packed copies. Passive normal
containers now use transparent BACKDROP independent of this FDF load. Native
chassis and seven empty SIMPLEFRAME cells still require the loaded definitions.
