# Isolated TEST map source

`base/` was extracted from the current `Milim.w3x` WTG/WCT. `TestBase.vj`
preserves the representative TEST map's World Editor initialization and imports
only enabled TEST infrastructure. Original `Heroes` and `Erza` implementations
are excluded to avoid duplicate hero code.

During a TEST build, `.vscode/build-run-w3-map.ps1` replaces
`// __ACTIVE_HERO_SOURCE__` in `map_source/TestBase.vj` and writes
`_build/TestCurrent.vj`. Hero files are read only from the explicitly configured
`testHeroSourceDirs`; shared files are read only from `sharedSources`.

Compatibility additions required by the current external hero tree:

- `base/Systems/Death.j` passes both arguments required by the current
  `PatriotEE_Start(td, c)` API. The original source and patched hash are recorded
  in `base/test-source-manifest.json`.
- `TestBase.vj` declares and initializes the two Kyoraku sound handles used by
  the current external Kyoraku source.
- `TooltipBuilder.j` and `UniversalTooltips.j` are the only explicitly shared
  files from `triggers/WOS_Start`; the directory is never scanned.

MAIN `Systems`, `Items`, `Round_End`, startup triggers, and dependency discovery
are not used by the TEST build.
