"""Reduce PRE2 emission in particle-heavy, used models of the MAIN map folder.

usage: optimize.py <map_dir> <scan2.json> <project_dir> [--apply]
"""
import os, sys, json, struct
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import mdx, sim

CAP_ALIVE = 400.0      # target peak alive particles per instance
CAP_FILL = 15.0        # target peak fill (alive * size^2 / 1e6)
FLOOR = 0.5            # never cut emission below half
MIN_EMITTER_ALIVE = 8  # leave tiny emitters (single glows/flashes) untouched
SIZE_COMP_POW = 0.25   # particle size *= f^-0.25 for count-driven cuts

MANUAL = {
    'war3mapimported\\wos_[doft]crocodilesanding3.mdx': 0.5,
    'war3mapimported\\wos_brandi_sandq.mdx': 0.5,
}
SKIP = {
    'war3mapimported\\wos_wtw-1r2-cang11.mdx',  # Gojo orbs, already halved 2026-10-19
    'war3mapimported\\wos_wtw-1r2-he11.mdx',
    'war3mapimported\\wos_loadingscreen.mdx',
}

def emitter_max_alive(info):
    """max alive particles per PRE2 emitter across all sequences"""
    ems = [e for e in info['emitters'] if e['kind'] == 'PRE2']
    best = [0.0] * len(ems)
    for seq in (info['seqs'] or [('static', 0, 1000, 0)]):
        name, s, e, flags = seq
        if e < s:
            continue
        loops = 1 if flags & 1 else 3
        for k, em in enumerate(ems):
            ser = sim.emission_series(em, s, e) * loops
            w = max(1, int(round(max(0.0, em['life']) * 1000 / sim.DT)))
            run = 0.0
            for i in range(len(ser)):
                run += ser[i]
                if i - w >= 0:
                    run -= ser[i - w]
                if run > best[k]:
                    best[k] = run
    return ems, best

def plan_factor(row):
    key = row['path'].lower()
    if key in SKIP:
        return None, ''
    if key in MANUAL:
        return MANUAL[key], 'manual'
    f1 = CAP_ALIVE / row['peak'] if row['peak'] > CAP_ALIVE else 1.0
    # fill-driven cuts only where there are enough particles for a density change to stay invisible
    f2 = max(0.6, CAP_FILL / row['fill']) if row['fill'] > CAP_FILL and row['peak'] >= 100 else 1.0
    f = max(FLOOR, min(f1, f2))
    if f > 0.9:
        return None, ''
    return round(f, 3), ('count' if f1 <= f2 else 'fill')

def apply_factor(data, info, f, comp):
    buf = bytearray(data)
    ems, best = emitter_max_alive(info)
    touched = 0
    s_mul = f ** -SIZE_COMP_POW if comp else 1.0
    for em, alive in zip(ems, best):
        if alive < MIN_EMITTER_ALIVE:
            continue
        touched += 1
        struct.pack_into('<f', buf, em['rate_off'], em['rate'] * f)
        for fr, v, vo in em['anim'].get('KP2E', []):
            struct.pack_into('<f', buf, vo, v * f)
        if s_mul != 1.0:
            sc = struct.unpack_from('<3f', buf, em['scale_off'])
            struct.pack_into('<3f', buf, em['scale_off'], *(x * s_mul for x in sc))
    return bytes(buf), touched

def main():
    map_dir, scan_path, proj = sys.argv[1:4]
    do_apply = '--apply' in sys.argv
    rows = json.load(open(scan_path))
    asset_index = {}
    for dp, dn, fn in os.walk(os.path.join(proj, 'assets')):
        for fname in fn:
            if fname.lower().endswith('.mdx') and 'original' not in dp.lower():
                asset_index.setdefault(fname.lower(), []).append(os.path.join(dp, fname))
    log = []
    for row in sorted(rows, key=lambda r: -r['peak']):
        if not (row['code'] or row['obj']):
            continue
        f, why = plan_factor(row)
        if f is None:
            continue
        path = os.path.join(map_dir, row['path'])
        data = open(path, 'rb').read()
        info, _ = mdx.analyze(path)
        new, touched = apply_factor(data, info, f, why in ('count', 'manual'))
        if not touched:
            continue
        targets = [path] + [p for p in asset_index.get(os.path.basename(path).lower(), [])
                            if open(p, 'rb').read() == data]
        tmp = os.path.join(os.path.dirname(os.path.abspath(__file__)), '_tmp.mdx')
        open(tmp, 'wb').write(new)
        pk2 = sim.model_peak(mdx.analyze(tmp)[0])
        if do_apply:
            for t in targets:
                open(t, 'wb').write(new)
        log.append(dict(path=row['path'], factor=f, why=why, emitters=touched, peak=row['peak'], fill=row['fill'],
                        peak_after=round(pk2[0]), fill_after=round(pk2[1], 2), copies=len(targets) - 1))
        print('%5.2f %-5s em=%2d  peak %5d -> %5s  fill %5.1f -> %5s  +%d  %s' % (
            f, why, touched, row['peak'], log[-1]['peak_after'], row['fill'], log[-1]['fill_after'], len(targets) - 1,
            row['path'].encode('ascii', 'replace').decode()))
    json.dump(log, open(os.path.join(os.path.dirname(scan_path), 'optimize_log.json'), 'w'), indent=1)
    print('models', len(log))

if __name__ == '__main__':
    main()
