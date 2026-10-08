# UI assets

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
