# Particle optimization (2026-10-24)

Rebuilds `assets/optimized/` from the untouched originals in `backups/models/20261024-particles-all/map`.
Run from the project root, in order:

    python tools/particle_opt/scan2.py "<MAIN map folder>" tools/particle_opt/scan2.json 30
    python tools/particle_opt/decor_scan.py
    python tools/particle_opt/build_optimized2.py

Tiers (peak alive particles / floor): decor models 30 / x0.2, decor-break FX + dummies + Sukuna round end 80 / x0.1,
the same when also used by heroes 180 / x0.35, other effects 250 / x0.4, hero unit models 400 / x0.5.
`tools/install_project_assets.py` copies `assets/optimized` into the map on every BUILD MAIN.
When a map import also exists in the effect or Frostnova release assets, the optimized copy
takes precedence. The installer resolves these paths case-insensitively before comparing
them with the map, so a repeated build keeps the optimized files.
