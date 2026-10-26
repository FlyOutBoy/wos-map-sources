# TEST: выбранный герой

TEST build automatically names the map `<testHero> — TEST` (for example,
`Frostnova — TEST`) in native `war3map.w3i`, generated `SetMapName`, and an
existing HM3W lobby header. `tools/test_map_identity.py` replaces only the map
name field, leaving other W3I fields and WTS strings intact. The builder reads
fresh W3I from the selected saved archive before applying the title, so editor
metadata changes survive. The archive filename remains `Heroes/<testHero>.w3x`.

## Native TEST UI by default (2026-10-22)

Normal TEST builds keep the complete gameplay systems and their initialization:
GearSystems/GearSystems2, the original CastCheck, DmgSys, Death, level-up,
items, mouse/unit events and companion hero libraries. Their timer/event
registrations are not removed. The earlier broad minimal-runtime cuts have
been withdrawn after the user narrowed the requirement to presentation only.

Custom WOS UI, UniversalTooltips and TooltipBuilder are excluded from compiler
roots and dependency discovery; their WTG entries remain disabled snapshots.
Generated MinimalUI preserves public signatures. Only WUI_HeroProgress/Text
render isolated hero bars with the existing MAIN style helpers; other APIs stay
inert. No HUD bootstrap, tooltip queues, UI poller or TOC is enabled. Other custom presentation owners do not
bootstrap their picker/shop/scoreboard interfaces. Gameplay owners such as
DamageStats, shared armor formulas, SaveLoad and hero initializers stay intact.
Music and the old foreign-MP3 probe remain disabled. The small native charge
counter stays active without custom TOC assets or a private timer.

The legacy local `testMinimalRuntime` option now selects this UI/audio policy;
it no longer strips gameplay. `testNativeUI` still forces the stock Warcraft HUD.
Full UI testing requires explicitly setting both options to false.

TEST registers CastCheck's SPELL_EFFECT directly once for all players. The
otherwise unchanged level-up handler skips only its duplicate player-specific
SPELL_EFFECT subscription. CreateKeys runs before test hero creation; the shared
hs table is preserved. Escape keeps the targeted native HP/mana/charge reset.
Generated guards are reversible on source import; MAIN files are unchanged by
this presentation pass. Ordinary builds preserve all saved imports and modify
native code/objects/title. The requested hero-bar layer adds only its six
missing UI/WOS textures (panel, empty, bar-back, meter-fill, divider-h/v);
existing asset bytes and all existing import records are preserved. Other
explicit import operations remain separate.

Source/object tests and compilation do not establish that a native engine hang
has been resolved. Reports and the real R -> DmgSys/shared-clock interpreter
scenario are under `_build/frostnova-r-freeze/`.

The 2026-10-22 native hang capture identified a separate model defect:
`war3mapImported/arknights_sx01.mdx` contains 256 matrix groups in its first
geoset. The renderer's 8-bit loop wraps at that limit. The corrected asset in
`assets/FrostnovaModel/` splits this mesh into palettes of 255 and 9 groups;
all 7613 triangles and their skin/normal/UV attributes are retained. Its import
name is unchanged. `tools/fix_frostnova_model.py source.mdx destination.mdx`
reproduces the repair; `test_fix_frostnova_model.py` covers preservation and
idempotence. This is an explicit replacement of that one saved model payload,
not an ordinary build import hook. Other imports and `war3map.imp` are retained.

## Standard Warcraft UI and current VS Code tasks (2026-10-20)

TEST defaults to `testNativeUI: true` in the local build configuration.
The generated TestHero adapter provides `WOSTestNativeUI`; shared WOSUI keeps
its input defaults and gameplay-facing APIs, then returns before starting the
custom HUD/menu bootstrap. The stock console, command grid, inventory and
tooltips keep their native layout. Charge values remain stored for hero logic,
with lightweight native TasChargeBox counters; custom HUD/progress bars stay disabled. This policy applies to existing
and newly selected TEST profiles and does not change MAIN UI behavior.
For custom UI tests, explicitly disable both minimal runtime and native UI as described above.

Frostnova's TEST Q/W/E/R/T mana costs are zero at every rank. MAIN keeps its
25/80/100/120/150 costs. `stage_frostnova.py` preserves this distinction.
Both hero sources group IDs and tuning globals under COMMON/Q/W/E/R/T/F/G
headings; G is unassigned. Public spell entry points have matching section labels.

В меню **Terminal → Run Task** основные действия находятся под `TEST:` и `MAIN:`.
Для обоих профилей нумерация одинакова:

| Задача | Когда запускать | Результат |
| --- | --- | --- |
| `1. Карта → проект — получить ВСЁ из World Editor` | После Ctrl+S в World Editor | Импортирует J, WCT/WTG и все объекты в проект с бэкапом локальных файлов |
| `2. Проект → карта — сохранить ВСЁ, собрать и ЗАПУСТИТЬ` | После изменений J/JSON в VS Code | Проверяет и сохраняет объекты и код, собирает карту с ассетами и запускает Warcraft III |
| `3. Проект → карта — сохранить ВСЁ и собрать без запуска` | Нужна готовая карта без игры | Тот же полный процесс без запуска игры |

`Ctrl+Shift+B` запускает TEST: 3. TEST выбирается через `testHero` в локальном
`.vscode/wos-build.json`; MAIN — через `mainMap`. Импорт читает сохранённые
файлы на диске: несохранённые изменения из памяти World Editor недоступны.
Перед направлением проект → карта закройте World Editor без повторного сохранения.
После импорта из World Editor повторно импортировать перед сборкой не требуется.

`COMMON | ...` — вспомогательные задачи: импорт только кода/триггеров, только
объектов, выбор другой папки MAIN, проверки без записи, подготовка TEST-профиля,
Hero Transfer, копирование J и обслуживание импортов. Отдельный экспорт MAIN
дублировал импорт объектов и удалён из меню; прямой CLI `export` остаётся доступен.
Подготовка TEST-профиля создаёт отсутствующий профиль, а существующий не перечитывает.

`tools/wos_map_workflow.py` объединяет существующие импорт/синхронизацию/сборку.
При сборке TEST `--no-build` откладывает внутреннюю сборку `check-save`, после
чего общий build/run собирает ровно один раз. Ошибка проверки/сохранения блокирует
сборку и запуск. Основной импорт MAIN сначала проверяет оба набора данных,
включая compiled/source parity, затем сохраняет полный бэкап и применяет их;
ошибка применения восстанавливает весь выбранный набор файлов проекта.
Проектные JSON с выделенными ID сохраняются при импорте объектов.

MAIN Compile indexes live source roots instead of scanning project backups and
TEST snapshots. It validates library dependencies, then preserves the enabled
MAIN import order from trigger-settings.json, matching check_wos_ui.py. Legacy
plain JASS functions depend on this order without library declarations.
Compiler failures are bounded to 30 seconds instead of waiting indefinitely on
a hidden JassHelper error dialog. `test_vscode_tasks.py` audits task paths, CLI
entry points, MAIN/TEST routes, PowerShell syntax/parameters and source closure.

## One-command prepared hero transfer (2026-10-22)

VS Code: `HERO: TEST → MAIN — перенести код героя и собрать карту`.
From the project root: `python tools/hero_transfer.py --active-test-hero --build-main`.
The command selects the current `testHero` source (including an imported TEST
override), transfers J and existing registration hooks, saves MAIN JSON/WCT/WTG,
and builds without launching Warcraft. Close World Editor before running it.
First use asks category/difficulty/items/buyer; answers are retained per hero in
local `.vscode/wos-build.json` under `heroTransferProfiles`. Later runs reuse them;
explicit CLI options override remembered values. `--dry-run` writes nothing and
never starts a build; `--yes` is suitable once required answers are supplied.

`triggers/WOS_Start/BuildsForChars.j` contains `WOS_EnableTestHero = false`.
Change it to `true` and run the task to expose the current test hero to everyone
in MAIN. `WOS_TestHeroId` is maintained by the task; no per-hero switch is needed.
The flag controls only catalog/dummy/MaxHeroes registration (also random/captain
pools), not whether the hero code compiles. It remains unchanged by transfers.
MAIN object data/imports remain authoritative: the command does not replace them
with TEST zero-mana balance or copy the TEST archive/import list. For a brand-new
hero, object/assets and custom CastCheck/tooltip hooks must be prepared first,
as in the Hero Transfer procedure below. Frostnova already has those code hooks.

## Frostnova profile (2026-10-20)

Current release contract (2026-10-24): Q/W add 50/100 flat magic damage.
Q range is 1400/1450/1500/1550/1600; one charge recovers every 20/19/18/17/16 sec.
Q speed is 2310 (+10%); TQ is another 30% faster (3003). Orbiting crystals stay
light with a separate dark haze. TQ flight retains the original blue art plus a
40% translucent black-ice material layer. No raster recoloring or UV change.
Q/W/E ranks unlock at hero levels 1/5/9/13/17; R at 10/14/18/22/26; T at 25.
F requires the existing `h002` unit named `12 lvl`, with a level-12 script guard.
W cooldown is 24/23/22/21/20, E is 25, R is 30/29/28/27/26, T is 50 sec.
R lasts 4/5/6/7/8 sec at a fixed 1050 radius, also used by its targeting marker.
TR adds independent 450-radius damage bursts every 0.36 sec and roots initially
for two seconds. Enemies moving outward at the edge are rooted for two seconds
and surrounded by four crystals; each target can trigger the exit trap once and all
crystals disappear with that field. TE aura and art are 20% larger (750 radius);
the two attachment models have the scale baked into their coordinates, never
applied to a unit attachment at runtime. E's burst deals INT x 2/3/4/5/6;
its stationary field retains INT x 0.35/0.45/0.55/0.65/0.75 each second.
TE deals INT x 0.75/sec. TF deals INT x 0.15 per stack/sec, up to x0.75 at five.
R's normal field deals INT x 1/sec (x4/5/6/7/8 total); TR bursts remain additional.
VisionTimed follows Q/W at twice their radius; E/R reveal 1.5 times their radius.
F/T also grant a timed reveal. Hero environment work calls ordinary DecorRemove
like Natsu/Milim: Q 20, W/E 50, R 50/sec, using actual ability radii. Q/W sample
on the shared listener at 0.12 sec; the common decor system owns per-object hit
cooldowns. No DecorRemoveLine path or extra hero timer is used.
T refills Q, reduces remaining W/E/R cooldowns by 10 sec, switches
QWER icons and grants a native five-second shield (`A1F2` / `B0F3`). A real
T2/T3/T4 voice start refreshes it; a cast skipped by the speech lock does not.
MAIN damage uses the normal full-shield/piercing contract. `Starts.j` owns MAIN's
Shielded display; minimal TEST uses the same title as native buff art.

Frostnova is now maintained in MAIN only while Altair owns the active TEST.
The saved Frostnova TEST source/archive are intentionally older snapshots; do
not copy them over MAIN during maintenance. MAIN's shield has a dedicated caster
per hero, resets native Frost Armor state/autocast on every song continuation,
and keeps the previous buff until the recast applies. Slow/E orders cannot
overwrite its native cast. The caster follows the hero and is removed with it.
Current MAIN growth: STR 1.20, AGI 1.85, INT 2.25 per level. W fog emission is
20% lower than the initial polish, retaining opacity and the level fog plane.

The reviewed packet is `assets/FrostnovaRelease/manifest.json`: 26 MDX models,
their custom texture dependencies, 22 supplied icons and 28 supplied MP3s.
Custom models/textures use `war3mapImported\wos_*`; icons retain standard paths.
The supplied hero/portrait replace the placeholder; the largest palette remains
255. Q's invalid final-mesh palette index is repaired without changing geometry.
W's full-resolution textures are restored in isolated imports; source-followup/
retains the originals. polish_frostnova_effects.py raises only fog emission and
opacity, flattens its vertical motion and preserves crystal emitters byte-for-byte.
source-polish/ makes these changes reproducible without repeated multiplication.
Other dense PRE2 rates/tangents are capped; lifespan, alpha and UVs are retained.
Installation is additive via `install_frostnova_release_assets.py`; MAIN's normal
asset installer retains the packet. Ordinary TEST builds leave imports alone.
Scoped TEST updates preserve its saved WTG and unrelated code, objects/imports.
`stage_frostnova_release_objects.py` resolves WTS/skin values and copies only hero
objects. MAIN spell mana follows Ainz (Q 100/110/120/130/140, W 90/105/120/135/150,
E 125, R 125/140/155/170/185, T 225); TEST stays zero. Helpers keep explicit zero
mana/cooldown and unrestricted native target flags. F/anti-heal use a dedicated
caster owned by Frostnova; copying MAIN mana must never strip helper cost fields.

The transfer task remembers buyer/category/difficulty locally. Frostnova is in
Gacha / Arknights, Normal difficulty; `WOS_EnableTestHero` now exposes her to all
players. Current tests: `test_frostnova.py`, `test_frostnova_release_assets.py`,
`test_fix_frostnova_model.py`, `test_hero_transfer.py`. Older paragraphs below
record implementation history; this contract takes precedence.

The active local `testHero` is `Frostnova`. All three generic TEST tasks select
`Heroes/Frostnova.w3x`; the initial arena was copied from Crocodile without
changing Crocodile's archive. Its startup and editable objects are independent
under `test_map/profiles/Frostnova/`. Startup creates `H002`, equips A116-A11B
(Q/W/E/R/T/F), and calls `Frostnova_Register`. The TEST unit model is war3mapImported/arknights_sx01.mdx, with Arknights_sx1.blp
and Arknights_sxwq.blp at archive root. These user-owned imports are preserved by
ordinary builds; the editable unit property is model (native umdl).

`test_map/heroes/Frostnova.j` and `triggers/Heroes/Frostnova.j` currently match.
The selected TEST source is the former; transfer its changes into MAIN with
Hero Transfer. Shared CastCheck and Map Header now come from current MAIN.
The old Crocodile CastCheck override is obsolete: MAIN already contains its T
order/stack fixes, while the frozen override missed new hero dispatch and the
new DarkShiki T signature. MAIN's header now supplies EnvironmentRoundRules.
TEST startup provides only the missing shop/picker globals required by current
shared systems; it does not start the MAIN picker or shop.

Frostnova uses one lazy `GearTimer03Listeners` callback and balanced timer
acquire/release calls. Missiles, debuffs, fields and orbit visuals use active
lists. Q uses the same shared `KS_SpellStacks` tracker as TojiE:
`SpellStacksStart` / `SpellStacksTryUse`, with `SpellStacksResetForEscape`
on TEST reset and `SpellStacksFill` on T/death. There is no second Frostnova
charge/recharge counter. Its capacity is 2/2/4/4/6 at **ability ranks** 1-5,
with one charge restored per 6 seconds and TojiE's shared 0.25-second use pause.
The shared tracker owns the cooldown scheduling. F caps at five 5% slow stacks for
4 seconds; enhanced F uses 8% per stack for 6 seconds and Int x 0.12 per stack
each second. Debuffs can be dispelled. E grants 0.6 seconds of invulnerability;
T lasts 20 seconds, fully restores Q and feeds WUI_HeroProgress with its real
remaining duration, as AlterSaber R does. TEST renders that bar above the stock
HUD; completion/death explicitly hides it, and recast refreshes its duration. Enhanced R grows up to eight blocking
crystals, with occupied positions skipped; each adds 50 field radius and deals
Int x 0.25 damage and a one-second root on first contact within 180 range. All are removed with the field.
Q charges have persistent floating icicle effects on both sides of the hero;
they follow movement, hide during invisibility, disappear on death, and launch
from their actual positions. Enhanced W sends three waves at -30/0/+30 degrees
with one shared hit set, so overlapping waves cannot hit an enemy three times.
Native Slow A11C is dedicated to Frostnova: levels 1-5 apply F, levels 6-10
apply enhanced F. Each tier has its own buff; no direct movement-speed edits.
Q uses the user-selected ice_shard-7716D.mdx; only flying
projectiles add [skillm]als-tx (6).mdx (previously Extra14). W combines
file00002579_1.mdx and tx026_1.mdx. Models use
their original basenames under war3mapImported, without renamed effect folders.
All six Q slots differ in height and rotate around the hero at 1.4 rad/sec;
each pair has its own radius, with its center at the hero XY (no backward offset).
Orbit base height is 25, with 35-unit layers: the lowest charges are near the
feet and smoothly rise toward flight height. Q speed is 2100 (40% above 1500).
Orbit scale is one third of flight scale; ScaleEffDummy restores flight size
over 0.18 seconds on launch. The projectile descends linearly to height 150 over
0.30 seconds, with the secondary effect 40 lower. Launch uses the same current
orbit angle, not the initial idle position. Any observed charge gain clears Q
cooldown on the shared hero tick, including early grants with charges remaining.
Q rank changes are observed by the shared clock; no HERO_SKILL callback mutates
abilities or frames. Existing shards are retained when rank 1 becomes rank 2.
Rank 3/5 grants the two newly added charges. Orbit effects play their own Stand
animation without a hard-coded seek: the selected ice_shard model's Stand ends
at 833 ms, so seeking to 1000 ms is invalid. Only the local viewer's visibility can
hide the orbit; neutral-player vision does not control other players' effects.
Auto-selection is MAIN-only: TestMode blocks both the 0.25-second HUD selector
and DmgSys's damage-triggered re-selection, even with saved preferences enabled.
DmgSys previously ignored the option, causing selection jumps while it was off.
The current MAIN source checks the saved flag in both paths; TEST has no
auto-select toggle or selection timer startup. test_auto_select_policy covers it.

TEST Start owns Escape; `InitTrig_ESC` is guarded in TEST to prevent the second
MAIN handler from also running `UnitResetCooldown` on the same key press.
Ground fields survive caster death, but end if the caster unit is removed.
W prepares for 0.6 seconds with the saved hand effect and StartSpellUnit2 /
StopSpellUnit2 (TW uses the invulnerable variant); radius grows from 80 to 250.
E prepares for 0.75 seconds, then explodes and leaves a seven-second field.
R forms over 0.5 seconds and lasts eight seconds after formation, pulsing once
per second. All preparation, formation and voice locks use the same hero listener.
Normal Q cycles Q1-Q5 on every cast without waiting; Q6/Q7 remain independent
launch/hit sounds. Normal W/W2 then W3, E/E2 then E3/E4 and R/R2 then R3 also
bypass the voice lock. Sounds match the saved map / folder (16) byte-for-byte.
T lasts 20 seconds and always plays T1/T5. Only a Q/W/E/R cast can start
T2/T3/T4 in that cycle, independent of the spell slot. Casts during another
voice are skipped without advancing the cycle; the clock never starts a line.
Only the primary W/E/R voices are muted during T: W2/W3, E2/E3/E4 and R2/R3
remain unconditional effect sounds. The isolated meter anchors above the stock minimap.
T uses the saved file00000456.mdx aura and adds dark particle sources to
normal idle/flying ice_shard-7716D.mdx shards. Both models have 20% smaller PRE2 particle scales.
The T model uses Blend materials/emitters instead of Additive, dark segment colors
and four transparent sprite textures from assets/FrostnovaEffects/dark-particles-source.png.
Its ice surface uses black-ice-source.png. Geometry/nodes/animation remain intact.
tools/tune_frostnova_shards.py takes an explicit untuned source; never use its
output as the next input unless another size reduction is intended. T clears Q cooldown immediately.
Ability Start methods follow Loop; public CastCheck entry points remain below
all ability structures. Only Q1-Q5 game copies are trimmed; unrelated imports are preserved.
Current saved-map follow-up: sounds were replaced byte-for-byte from the user's
folder (16), superseding those trimmed copies; no additional re-encoding.
All Q/W/E/R hits use the one F debuff with five normal tiers and five enhanced
tiers. A11C is the sole ten-level native Slow helper; the unused A11D was removed
from TEST. Existing ten buff IDs were retained and renamed to F/TF tiers, keeping
their edited icons/effects. Ordinary Q art stays present during T, with a second
dark source (existing ice_shard-7716D-dark.mdx) following each idle/flying shard.
No model payload changes or additional timers. A small qUsePause preserves the
shared throw pause while the hero tick clears any late refill cooldown write
when a charge is already available, even if the gain was observed earlier.
For this follow-up the actual saved Frostnova WCT was adopted first to retain the
user's edited models, balance and animations. Only compiled Frostnova functions /
globals and its single WCT block changed; all other saved script functions,
WTG, units and model/texture/import payloads were verified unchanged. The only
object changes were the F cleanup/names; the 23 sounds match folder (16).
Enhanced R places crystals randomly, with at most eight placement attempts per
spawn. Its traps scan every 0.10 seconds on the existing hero listener. Each
waits for one valid enemy, applies the shared RootUnit for one second, F and its
crystal hit damage, then consumes that crystal. Unused traps are removed at R
end; consumed null handles are skipped. Blocking placement clearance is 48,
rather than the former 160-unit exclusion that rejected crowded spawn points.

October 23 field follow-up: the saved hero WCT was adopted before editing, so
its R radius 1050, file00005537_3.mdx, alpha, E effects and animations are retained.
E refreshes a 0.36-second native marker every 0.12 seconds: B0F0 gives the caster
30% all-damage resistance in its own stationary field; B0F1 reduces enemy health
restoration by 35%. DmgSys applies the reduction after DamageBlock; GetPhysRes /
GetMagRes compose the same factor, and GetHealMultiplierNoBlock handles the cut.
Helpers A1F0/A1F1 have no native armor, damage, attack-speed or movement modifiers.
TE attaches file00000883_1.mdl to origin after preparation and deals Int x 0.25
damage each second in radius 700 around the moving caster for the saved E duration;
the stationary field remains. Recasting and death release the attached effect.
TW uses StartSpellUnit / StopSpellUnit, preserving preexisting invulnerability.
W clips its push distance to the active Icefields that contained the victim.
TQ pierces with a per-flight hit group, one hit per target; normal Q still stops.
Its hit art is a separate wos_file00003436_2-dark.mdx copy using the existing
transparent dark particle textures. Its original 2x2 / 4x4 emitter UV sheets
are reset to single-sprite intervals. The opaque BlackIce surface must never be
assigned to a Blend particle: that caused the reported expanding square.
One geoset also retained 0..1/3 UVs and texture animation 0 from a 3x3 atlas.
The dark copy normalizes its UVs to 0..1 and disables atlas translation;
positions/bones/animation tracks stay intact. TQ scales only hit effects to 0.5.
E creates its eight-spike ring only once. EffectSpawn's sixth argument is scale,
not playback speed: the accidental scale 4 is now 1, with timescale 1.25.
The Splat model has a one-second looping Stand, so its burst handle is removed
at 0.75 seconds. Its fixed scale 1 is independent of gameplay AOE; the separate
snow field and TE aura retain the saved E duration and all damage pulses.
Build it with build_frostnova_impact.py
from assets/FrostnovaEffects/source/wos_file00003436_2.mdx; the original stays intact.
F rejects friendly targets, and its dedicated dummy explicitly disables Slow autocast.
October 24 revision supersedes the TR crystal/cage mechanic: there are no
spawned shards, collision objects, edge cages or radius increments. R retains
its fixed gameplay radius and only scales visually during initial formation.
The saved wos_emt-8.mdl effect at scale 2 and a two-second initial RootUnit pass
run only for TR. During its active lifetime TR adds a random radius-180
microburst every 0.25 seconds, each dealing Int x 0.25 extra magic damage plus F.
The old helper objects/imports remain untouched and simply are not instantiated.
E now deals its ordinary damage immediately alongside initial F/push, in addition
to periodic damage. The saved E radius 850, duration 10, model scale 3.25, spike
scale 4 and retained field art are user edits and must not be reset to older values.
TE additionally attaches the independent FrostnovaTE_Area.mdx placeholder to origin;
replace that import in World Editor to choose the final AOE art. Its model path
is a separate global; unit attachments inherit native scale, and recast/death/end clean it with the original aura.
TE visibility follow-up: the current saved model is wos_az_aachristmas_t1_700_1.mdx.
Its Stand opacity stays at 1, but the ring lies at Z~10 with ordinary depth testing;
the retained E splat can occlude it. MODL also has zero bounds despite valid
sequence extents. fix_frostnova_te_area.py enables NoDepthTest/NoDepthSet and
fills MODL from sequence bounds, preserving geometry, textures, alpha and tracks.
E explicitly plays Stand on its area/aura after attaching. No attached effect
receives BlzSetSpecialEffectScale; T's old attachment scale was removed too.
TQ retains its requested half-size hit as a short-lived world effect at the
victim's position/height, avoiding scaling the target's attachment transform.
The saved W angle/visual-radius edits and TR model/rate/scale edits were adopted
before patching. Only the selected area model and hero source/runtime changed;
objects, other imports, WTG and import records stay byte-identical. Native
visibility in Warcraft still needs confirmation; deterministic checks establish
lifetime/attachment ownership and exact binary preservation, not rendered pixels.

Enhanced W's radius is at least StartAoe + travelled*sin(half lane angle), closing
the gaps between the three rays near and far. All three retain one shared hit set:
a victim receives W damage, F and push only once per cast.
The scoped TEST write changed only Frostnova plus four shared buff hooks in WCT /
compiled J, appended those five objects and one model import, and preserved every
existing object/import payload. WTG is byte-identical. Verification: 52 executed
hero tests, additive-object/model checks, MAIN/TEST compilation, pjass and packed
payload/source audits. Native rendering and buff timing still need a game test.

The single hero library groups globals first, then shared state and separate
F/Q/W/E/R/T structures. Each ability owns its Start/Loop; public CastCheck
wrappers are grouped at the bottom. E reuses one field/group per caster:
recasting moves it to the caster and refreshes duration instead of stacking
six-second fields. Its aura/burst and owned invulnerability are cleaned by its
own shared-clock loop; recasts retain at most two E effects, without adding
shared delayed-effect jobs. T also refreshes one owner instance.
The first balance has no damage amplification, damage reduction or HP drain.

Initial object staging uses `python tools/stage_frostnova.py` after
the COMMON TEST preparation task has created the Frostnova profile. Allocated IDs are recorded in
`object-data/frostnova-ids.json`; the lossless object API preserves other objects.
The stager also refreshes TEST's shared stun/slow/root/silence/doom ranks.
After initial staging, `python tools/stage_frostnova_followup.py` applies the
current ten-tier Slow, crystal model and descriptions without resetting the hero
model or TEST mana costs. Do not rerun initial staging to update these fields.
The explicit effect packet is `assets/FrostnovaEffects/manifest.json` (17 models,
71 unique textures). Texture references retain required import paths; conflicting
custom textures are remapped inside copied MDX files. Ordinary builds preserve
the saved map's imports and never install this packet automatically.
Zero-duration global animation cycles in three supplied MDX copies are given a
positive period; source files are unchanged. MPQ named payload I/O uses UTF-8
buffers, preserving original Unicode effect filenames instead of ANSI '?'.

Seven icons use official PERISH IN FROST stills; crops and URLs are recorded in
`assets/frostnova_icons_src/sources.json`. Rebuild with a Python environment
containing Pillow:
`python tools/build_frostnova_icons.py --button-manager <installed-directory>`.
This runs the installed Button Manager Clear using a private configuration copy
and verifies all fourteen 64x64 BTN/DISBTN BLP outputs. The user's settings stay
untouched. Icons are imported explicitly during initial hero setup. TEST: 2 and
TEST: 3 preserve the saved map imports without copying project assets again.

Verification: `test_frostnova.py` executes the JASS methods with the existing
deterministic harness. MAIN and TEST compilation, WCT/WTG parsing/order/counts,
object round trips, packed source/icon identity and repeated TEST saves are
checked separately. Native buff timing, projectile visuals, pathing and
multiplayer still require a Warcraft III playtest.

С 2026-10-15 пользователь одобрил перенос стабильной Range3 в MAIN.
Рабочий источник кругов — `triggers/WOS_Start/AbilityRangePreview.j` (включён).
Hold/V удалён целиком; остались круги при наведении. Шаблон в `ability_range/`
также обновлён, старые инструкции ниже описывают историю изолированной сборки.
MAIN теперь включает исправления магазина/фокуса/счётчиков/хоткеев Range3.

Индикатор дальности UI (изолированный полный FIX12-кандидат): исходник
`ability_range/AbilityRangePreview.j` не включён в MAIN. Интеграция в копию
полного проекта — `python tools/prepare_ability_range_test.py --workspace <TEST-workspace>`.
Скрипт отказывается работать в основном checkout и с профилем настоящей MAIN.
Он подключает источник Range билдера, существующий hover/tick AHUI и read-only
блокировку по окнам. Range2 также добавляет мгновенные AoE, удержание на V
(сменяемая сохраняемая клавиша), общие актуальные формулы дальности и UI-правки
Menu/Stats/Pick/Random. Источники пишет только в изолированную копию; новые четыре
Pick/Random TGA и их импорты записывает в её scenario с резервной копией.
Дальше применяются штатные check/save/build
через профиль изолированной копии. Ресурсы устанавливаются отдельно командой
`python tools/install_ability_range_assets.py --map <scenario-directory>` и затем
проверяются в собранном архиве. MAIN разрешено менять только ресурсы/war3map.imp.
Для Range2 см. `ability_range/HeroRangeRules.j`,
`tools/prepare_ability_range_hold_test.py`, `tools/prepare_range_ui_followup.py`
и последний раздел Ability Range в `docs/ui-redesign/RESUME.md`.
Range3 продолжает эту цепочку через `tools/prepare_ability_range_fixes_test.py`:
геометрия магазина/метров, Kyoraku G, повторный Swap, Pick focus, F3/F4,
конфликты хоткеев и `ability_range/KillmeProgress.j` остаются только в TEST.
Аудит каждой HUD-кнопки: `tools/audit_hero_range_sources.py --output <report.json>`.
Радиусы выше 2500 скрываются, включая Patriot T2; T1 показывается.

Чтобы сменить тестовую карту, измените только `testHero` в
`.vscode/wos-build.json`, например:

```json
"testHero": "Beluga"
```

Затем используйте основные `TEST: 1/2/3` из таблицы выше. После изменений
в World Editor запускайте TEST: 1; после изменений в VS Code — TEST: 2 или TEST: 3.
Раздельный импорт доступен в `COMMON | TEST: Карта → проект — только код и триггеры
(J, WCT/WTG)` и `COMMON | TEST: Карта → проект — только объекты (JSON)`.

Перед импортом сохраните карту в World Editor. Задачи читают архив на диске,
поэтому несохранённые изменения не импортируются. Перед заменой файлов сохраняются
резервные копии в `backups/test-map-import` и `backups/test-source-import`.
Обновление из карты намеренно заменяет локальные файлы выбранного типа.
Изменения общих триггеров сохраняются как TEST overrides; MAIN не перезаписывается.
После редактирования кода/JSON закройте редактор без повторного сохранения карты
и используйте TEST: 2 для сборки с запуском или TEST: 3 без запуска.

После импорта кода выбранный герой берётся из
`test_map/heroes/<Hero>.j`; задача выводит полный путь этого файла и подтверждает,
что он выбран для сборки. Он имеет приоритет перед MAIN-кодом в
`triggers/Heroes/<Hero>.j` и прежней копией в `profiles/<Hero>/imported-hero`.
Для переноса в MAIN откройте актуальный `test_map/heroes/<Hero>.j` и запустите
`COMMON | Герой: Перенести открытый J из TEST в MAIN (Hero Transfer)`. Задача спросит ник покупателя, заменит BanImmuneHero1 и приоритетный пик на текущий <Hero>_ID, сохранив ThunderGear. Задача покажет исходный файл и MAIN-путь, скопирует выбранный код
в `triggers/Heroes/<Hero>.j`, зарегистрирует героя и включит MAIN-триггер.
Старый MAIN-код и изменённые файлы сохраняются в `backups/hero-transfer`.
Повторный перенос обновляет код без дублирования регистрации. После переноса
задача MAIN: 2 или MAIN: 3 сохраняет его в WTG/WCT и собирает основную карту. Hero Transfer переносит J-код и регистрацию; данные объектов
и импортированные модели/звуки должны быть подготовлены отдельно в MAIN.
Импорт TEST без указанного пути каждый раз читает сохранённый архив `.w3x`,
а не старую папку `unpacked`. При отсутствии J выбранного героя в архиве задача
завершается ошибкой и сохраняет локальный код.
Тестовый ID создаваемого юнита редактируется
в `base/Init/Start.j` активного профиля (для текущего Crocodile —
`test_map/base/Init/Start.j`). Изменение `Crocodile_ID` само по себе не меняет
rawcode в вызове `CreateUnit`. TEST 2 переносит текущий `Start.j` как
в исполняемый код карты, так и в текст триггера для World Editor.


Сборка ищет `Heroes/Beluga.w3x` в `testMapsDir`. Если карта существует, используется
она. Если отсутствует — создаётся копия предыдущей выбранной карты. Для самого
первого запуска запасной архив задаёт `testMapTemplate`; его не нужно менять при
переключении героя. Порядок поиска кода: `triggers/Heroes/<Hero>.j`/папка героя,
затем `test_map/heroes`. Если кода нет, создаётся пустой
`test_map/heroes/Beluga.j`. Существующий файл не перезаписывается.

Каждый профиль хранит свои объекты, импортированные триггеры и карты под
`test_map/profiles/<Hero>`. При первом запуске текущий Crocodile использует
имеющиеся `test_map/base`, `test_map/unpacked` и JSON, сохраняя локальные правки.
Переключение обратно возвращает его данные. Общие системы всегда берутся из
актуальных `triggers`, а подготовленные файлы лежат в `_build/test-sources`.
Профиль и пути выбранного JSON записываются в `_build/test-profile.json`.

Новая карта наследует ландшафт, объекты и тестовый юнит предыдущей карты.
Пустой J — заготовка для реализации героя; его способности не генерируются.
Тестовый старт вызывает `<Hero>_Register(unit)`, если такая функция есть,
через автоматически создаваемый адаптер. При пустом файле адаптер ничего не вызывает.

Успешная сборка обновляет и `_build/<Hero>_Test.w3x`, и выбранный архив в
`Heroes`, предварительно сохранив резервную копию в `backups/test-maps/<Hero>`.
Если выходной слот занят игрой, используется `<Hero>_Test_2.w3x`.

Для запуска TEST 3 использует обновлённый архив Heroes и рабочую папку `_retail_`.
Параметр `testMapProfile` задаёт локальный профиль тестирования редактора; если
его нет, launcher читает последний `-testmapprofile` из War3Log. Данные входа
Battle.net не изменяются.

## Source ownership and closure

Previously TEST imported frozen base copies and the entire configured hero family,
and merely asserted declared dependencies. It did not synchronize MAIN Systems
or consume `test-source-manifest.json`.

Each build now follows:

`triggers -> manifest origins -> _build/test-sources -> dependency closure -> TestCurrent.vj -> JassHelper -> built map -> launcher`

After resolution, the complete closure is materialized into staging, including
shared roots and compatibility sources missing from the imported TEST WTG.
Validate + Save uses this same preparation. BUILD synchronizes the resolved set
into WTG/WCT in a dedicated `_build/test-editor-triggers` copy and inserts it into
the output archive. Thus opening the built map in World Editor has the same
enabled libraries as the command-line compile. Historical sources outside the
closure remain disabled. On successful TEST compilation, the selected Heroes archive is updated with a backup. The original unpacked folder remains the editable input.

Manifest format 2 records `shared`, `test`, and `testHero` origins per file.
Shared entries are copied from current MAIN `triggers`; local TEST definitions
retain priority. Historical shared copies in `base` are not compilation inputs.
Obsolete generated J files are removed only from the dedicated build staging
directory. `source-provenance.json` records source paths, origin kinds and hashes;
`test-resolution.json` records the actual closure. Staged trigger/dependency
metadata is refreshed from current declarations.

The resolver extracted from `compile-vjass.ps1` is shared by MAIN/editor and TEST.
Declared `requires/uses/needs` are followed transitively. Missing required
providers, ambiguous providers, cycles and unindexed seeds fail preparation.
Optional absent FrameLoader is allowed. Enabled TEST infrastructure supplies
seeds; trigger settings can further disable them. Disabled snapshot providers,
including `Systems_Copy.j`, cannot win selection.

The first matching hero source directory wins, allowing a TEST-only hero override.
`testCompanionSourceDirs` preserves the existing MAIN hero family because legacy
Systems call many hero functions/globals without declared library edges. This is
a directory-level compatibility requirement, not a maintained filename list.
The two existing tooltip roots remain in `sharedSources`; further declared
dependencies resolve from MAIN automatically. Crocodile currently resolves 71 files, including the selected hero registration adapter.

Changes to MAIN DmgSys, Systems1/2, CastCheck, CastAItems, Death, Items and other
shared origins enter the next TEST build automatically. Actual filenames are
`CastAItems.j` and `hpset.j`; this project has no `CastItems.j`.
`Systems/Items.j` maps to MAIN `Items/Items.j`; `ErzaDebuff_Copy.j` maps to current
`Systems/DecorDestroy_and_Erza_Debuff.j`, whose Murasame implementation is required
by the current damage system. The old TEST Death API patch is superseded by
current MAIN Death code in staging. Historical copies are retained safely.

## TEST overrides

Reasons and replaced MAIN paths are explicit in `test-source-manifest.json`:

- Empty `Map_Header.j`.
- `Systems/Starts_Copy.j`: TEST startup/keys, replacing MAIN `WOS_Start/Starts.j`.
- `Systems/ArrowUp.j`, `ArrowLeft.j`, `ArrowRight.j`: arena keys; MAIN versions
  invoke the full MAIN hero picker.
- `Systems/UnitEnter.j` and `Thunder_Gear/ARUP.j`: TEST entry/key-up handling.
- All six `Init/*.j`: TEST startup, arena loops, controls and health/level handling.
- `WOS_Start/TestUnit.j`: TEST selection helper, currently disabled.
- `Systems/Systems_Copy.j`: preserved disabled legacy combined systems snapshot.

Other disabled TEST-only gameplay snapshots are retained for WTG/WCT round-trip,
and excluded from the compilation provider pool. Minimal compatibility edits:
remove duplicate `ahk_delay` from TEST Start (current MAIN CastCheck owns it),
initialize `KEY_INVUL`/`KEY_SHIELD` in TEST startup, and provide two Kyoraku sound
handles in `compatibility/KyorakuSounds.j`. Those workflow compatibility edits
did not patch MAIN J files. The subsequent hero implementation adds generic
spell/damage/timer listeners and CC protection to shared Systems, plus the E/F
counter cleanup in TasBox; the implementation report lists those changes.

## Object data and Validate before Save

`object-data.test.config.json` selects the current hero through `test_profile`.
The old `object-data.crocodile.config.json` is a compatibility alias to the same
selection. JSON/raw metadata and unpacked archives are independent per profile;
object, trigger and packed-map backups are under `backups/test-*`.

Task 2 stages current sources, validates objects and triggers before either save,
saves the editable payload, then compiles and updates `Heroes/<testHero>.w3x`.
A compiler failure leaves the packed Heroes archive unchanged. Task 3 builds and
launches the selected map. Close World Editor before saving/updating its map.
MAIN synchronization arguments and paths retain their existing behavior.

Crocodile's WTG omits category-id-0's tombstone. Only the TEST config permits
reading stale allocation counts. Synchronization restores missing unreferenced
tombstones, preserving allocation counters/live ids; MAIN retains strict count
validation. GUI support and WCT byte/count checks are not relaxed.

## Milim references

No active config selects `Milim.w3x` or `map_source/Milim.vj` as TEST input.
Milim remains a real MAIN hero and required compatibility companion: shared
Systems reference its APIs. Original WTG handle names remain. The unused old
mapscript, backups, MAIN object data and match records retain meaningful history
or gameplay references.

## Files changed

Existing: `.gitignore`, `.vscode/tasks.json`, local `.vscode/wos-build.json`,
`.vscode/wos-build.example.json`, `.vscode/build-run-w3-map.ps1`,
`.vscode/compile-vjass.ps1`, `.vscode/import-triggers-and-code-from-map.ps1`,
`tools/create-main-mapscript.ps1`, `tools/extract_war3_triggers.py`,
`tools/sync_war3_project.py`, `tools/sync_war3_triggers.py`, TEST `Init/Start.j`,
`Systems/Starts_Copy.j`, `test-source-manifest.json`, `map_source/TestBase.vj`,
and this README.

New: `.vscode/jass-source-resolver.ps1`, `.vscode/prepare-test-map.ps1`,
`.vscode/test-map-archive.ps1`, `object-data.crocodile.config.json`,
`tools/test_map_sources.py`, `tools/test_test_map_workflow.py`,
`tools/test_jass_source_resolver.ps1`, TEST trigger/settings/dependency manifests,
`heroes/Crocodile.j`, `compatibility/KyorakuSounds.j`. Unpacked binaries, editable
TEST JSON and generated build files are local outputs. Old tracked compiler
logs/backup indexes were restored after verification.

## Verification

65 Python checks pass: 53 execute Crocodile logic, 8 cover synchronization,
and 4 cover map/profile selection, source preservation and returning to a prior
hero. Resolver checks cover transitive, missing, cyclic and unindexed sources.
Full compilation succeeded for Crocodile and, in an isolated project copy,
Beluga with an empty source and a second new map copied from Beluga. Returning
to the existing Beluga and its complete Check + Save also succeeded. TEST import
validation succeeded. Profile state survives clearing generated build JSON.

Full TEST build succeeded using the Windows PowerShell executable used by VS Code.
`-PrepareOnly` resolves/prepares without compiler/game; `-NoLaunch` builds without
Warcraft III or Battle.net. TEST task 3 was also launched after restoring the editor test profile; the user confirmed Crocodile opened. Gameplay visuals still require review in game.

## Same-path duplicate audit

These copies originated in extracted TEST WTG/WCT. Shared snapshots are retained,
but current MAIN files supply their staged replacements. The manifest also maps
renamed/moved files; filename matching alone does not determine ownership.

| TEST base path | Compared with MAIN | Role |
| --- | --- | --- |
| `Map_Header.j` | different | TEST override |
| `Systems/ArrowLeft.j` | different | TEST override |
| `Systems/ArrowRight.j` | different | TEST override |
| `Systems/ArrowUp.j` | different | TEST override |
| `Systems/CastAItems.j` | different | shared snapshot; MAIN used in staging |
| `Systems/CastCheck.j` | different | shared snapshot; MAIN used in staging |
| `Systems/Death.j` | different | shared snapshot; MAIN used in staging |
| `Systems/DmgSys.j` | different | shared snapshot; MAIN used in staging |
| `Systems/hpset.j` | different | shared snapshot; MAIN used in staging |
| `Systems/ItemEnter.j` | different | shared snapshot; MAIN used in staging |
| `Systems/MouseMove.j` | different | shared snapshot; MAIN used in staging |
| `Systems/Systems1.j` | different | shared snapshot; MAIN used in staging |
| `Systems/Systems2.j` | different | shared snapshot; MAIN used in staging |
| `Systems/TasBox.j` | different | shared snapshot; MAIN used in staging |
| `WOS_Start/Leave.j` | different | shared snapshot; MAIN used in staging |
| `WOS_Start/Starts.j` | different | shared snapshot; MAIN used in staging |
| `WOS_Start/TestUnit.j` | different | TEST override |
| `WOS_Start/WoS_Hero_Icons_Init.j` | different | shared snapshot; MAIN used in staging |
| `WOS_Start/WoS_Pick_Init.j` | different | shared snapshot; MAIN used in staging |
| `WOS_Start/WoS_Shop_Init.j` | different | shared snapshot; MAIN used in staging |

Импорт кода выбранного героя сохраняется в `test_map/profiles/<Hero>/imported-hero/<Hero>.j`.
TEST использует эту копию в приоритетном порядке; `triggers/Heroes` и данные MAIN импорт не изменяет.
