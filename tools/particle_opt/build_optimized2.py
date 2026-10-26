"""One pass from the untouched originals into assets/optimized/war3mapImported (+ land_wos)."""
import os, sys, json, shutil
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import mdx, sim, optimize

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
ORIG = ROOT + '/backups/models/20261024-particles-all/map'
OUT = ROOT + '/assets/optimized'
TMP = os.path.join(HERE, '_opt_tmp.mdx')
BS = chr(92)

# cap alive, cap fill(M), floor, fill floor, size compensation, min emitter alive
TIERS = {
    'decor_model':  (30.0, 1.5, 0.20, 0.30, False, 4),
    'decor_hard':   (80.0, 3.0, 0.10, 0.30, False, 4),
    'decor_shared': (180.0, 6.0, 0.35, 0.45, False, 6),
    'effect':       (250.0, 10.0, 0.40, 0.55, True, 8),
    'unit_model':   (400.0, 15.0, 0.50, 0.60, True, 8),
    # Buff art stays on units for the whole buff (2026-10-25).
    'buff_art':     (120.0, 3.0, 0.25, 0.40, True, 6),
}
BUFF_ART = set()
for _o in json.load(open(ROOT + '/object-data/buffs.json', encoding='utf-8')).values():
    if isinstance(_o, dict):
        for _v in _o.values():
            if isinstance(_v, str):
                for _p in _v.split(','):
                    _p = _p.strip().lower().replace('/', chr(92))
                    if _p.endswith('.mdl') or _p.endswith('.mdx'):
                        BUFF_ART.add(_p[:-4] + '.mdx')
SKIP = {'wos_wtw-1r2-cang11.mdx', 'wos_wtw-1r2-he11.mdx', 'wos_loadingscreen.mdx'}
SKIP |= {n.lower() for n in os.listdir(ROOT + '/assets/FrostnovaRelease/files/war3mapImported')}
MANUAL = {'wos_[doft]crocodilesanding3.mdx': 0.5, 'wos_brandi_sandq.mdx': 0.5,
          'wos_sandpoff.mdx': 0.6, 'wos_newdirtexnofire.mdx': 0.6}
# Few huge particles spawned at scale 2.5-4 (Patriot W burst; shared with Frieren, Gojo,
# DarkShiki, Mahoraga...): overdraw, not count. Emission cut without size compensation,
# small emitters included (2026-10-25).
MANUAL_FILL = {'wos_az_ts_tzred.mdx': 0.5, 'wos_zarakiwcrack1.mdx': 0.55, 'wos_satsu-rsfx-4.mdx': 0.6,
               'wos_yz-leimitx13.mdx': 0.6, 'wos_by_wood_effect_order_dange_yueyun_2withoutred.mdx': 0.6,
               'wos_satsu-hit-red.mdx': 0.6}
MANUAL_FILL_MIN_ALIVE = 4

def analyze(data):
    open(TMP, 'wb').write(data)
    info, _ = mdx.analyze(TMP)
    return info, sim.model_peak(info)

decor = {r['path'].lower(): r for r in json.load(open(os.path.join(HERE, 'decor_scan.json')))}
rows = json.load(open(os.path.join(HERE, 'scan2.json')))
report = []
for row in rows:
    rel = row['path']; key = rel.lower(); name = key.split(BS)[-1]
    if name in SKIP:
        continue
    d = decor.get(key)
    if key in BUFF_ART:
        tier = 'buff_art'
    elif d and d['group'] == 'decor_model':
        tier = 'decor_model'
    elif d:
        tier = 'decor_shared' if d['hero'] else 'decor_hard'
    elif row['code'] or row['obj']:
        tier = 'unit_model' if row['obj'] and not row['code'] else 'effect'
    else:
        continue
    src = os.path.join(ORIG, rel)
    data = open(src, 'rb').read()
    info, pk = analyze(data)
    cap, fcap, floor, ffloor, comp, minalive = TIERS[tier]
    if name in MANUAL_FILL:
        f, why, minalive = MANUAL_FILL[name], 'fill', MANUAL_FILL_MIN_ALIVE
    elif name in MANUAL:
        f, why = MANUAL[name], 'manual'
    else:
        f1 = cap / pk[0] if pk[0] > cap else 1.0
        f2 = max(ffloor, fcap / pk[1]) if pk[1] > fcap and pk[0] >= 3 * minalive else 1.0
        f = max(floor, min(f1, f2)); why = 'count' if f1 <= f2 else 'fill'
    if f > 0.9:
        continue
    optimize.MIN_EMITTER_ALIVE = minalive
    new, touched = optimize.apply_factor(data, info, f, comp and why != 'fill')
    if not touched:
        continue
    after = analyze(new)[1]
    dst = os.path.join(OUT, rel.replace(BS, '/'))
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    open(dst, 'wb').write(new)
    report.append(dict(tier=tier, path=rel, factor=round(f, 2), peak=round(pk[0]), peak_after=round(after[0]),
                       fill=round(pk[1], 1), fill_after=round(after[1], 1)))
json.dump(report, open(os.path.join(HERE, 'optimized2_report.json'), 'w'), indent=1)
by = {}
for r in report:
    by.setdefault(r['tier'], [0, 0, 0])
    by[r['tier']][0] += 1; by[r['tier']][1] += r['peak']; by[r['tier']][2] += r['peak_after']
for t, (n, a, b) in by.items():
    print('%-13s models %3d  particles %6d -> %6d' % (t, n, a, b))
print('total', len(report))
