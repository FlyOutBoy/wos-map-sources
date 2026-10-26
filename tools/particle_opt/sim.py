"""Peak-alive particle simulation for PRE2 emitters over each sequence."""
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import mdx

DT = 10  # ms

def value_at(keys, interp, t, s, e, static):
    ks = [(f, v) for f, v, _ in keys if s <= f <= e]
    if not ks:
        return static
    if t <= ks[0][0]:
        return ks[0][1]
    for i in range(len(ks) - 1):
        f0, v0 = ks[i]; f1, v1 = ks[i + 1]
        if f0 <= t < f1:
            if interp == 0 or f1 == f0:
                return v0
            return v0 + (v1 - v0) * (t - f0) / (f1 - f0)
    return ks[-1][1]

def track_val(em, tag, t, s, e, static):
    keys = em['anim'].get(tag)
    if not keys:
        return static
    interp, gs = em['meta'][tag]
    if gs is not None and gs >= 0:
        return max(v for _, v, _ in keys)
    return value_at(keys, interp, t, s, e, static)

def emission_series(em, s, e):
    """particles emitted in each DT step of [s,e]"""
    n = max(1, (e - s) // DT + 1)
    out = [0.0] * n
    mult = 2 if em['head_or_tail'] == 2 else 1
    if em['squirt']:
        keys = em['anim'].get('KP2E')
        if keys:
            for f, v, _ in keys:
                if s <= f <= e and v > 0 and track_val(em, 'KP2V', f, s, e, 1.0) > 0.5:
                    out[(f - s) // DT] += v * mult
        return out
    for i in range(n):
        t = s + i * DT
        if track_val(em, 'KP2V', t, s, e, 1.0) <= 0.5:
            continue
        r = track_val(em, 'KP2E', t, s, e, em['rate'])
        if r > 0:
            out[i] = r * DT / 1000.0 * mult
    return out

def model_peak(info, emitters=None):
    """returns (peakAlive, peakFill, worstSeqName, perEmitterPeak{idx: alive at worst time})"""
    ems = [e for e in (emitters or info['emitters']) if e['kind'] == 'PRE2']
    seqs = info['seqs'] or [('static', 0, 1000, 0)]
    best = (0.0, 0.0, '', {})
    for name, s, e, flags in seqs:
        if e < s:
            continue
        loops = 1 if flags & 1 else 3
        n1 = max(1, (e - s) // DT + 1)
        n = n1 * loops
        alive_tot = [0.0] * n; fill_tot = [0.0] * n
        per = []
        for em in ems:
            ser = emission_series(em, s, e) * loops
            w = max(1, int(round(max(0.0, em['life']) * 1000 / DT)))
            run = 0.0; alive = [0.0] * n
            for i in range(n):
                run += ser[i]
                if i - w >= 0:
                    run -= ser[i - w]
                alive[i] = run
            sz = (em['scale'][0] + em['scale'][1] + em['scale'][2]) / 3.0
            for i in range(n):
                alive_tot[i] += alive[i]; fill_tot[i] += alive[i] * sz * sz
            per.append(alive)
        if not ems:
            continue
        i_max = max(range(n), key=lambda i: alive_tot[i])
        if alive_tot[i_max] > best[0]:
            best = (alive_tot[i_max], max(fill_tot) / 1e6, name,
                    {k: per[k][i_max] for k in range(len(ems))})
    return best

if __name__ == '__main__':
    info, _ = mdx.analyze(sys.argv[1])
    pk = model_peak(info)
    print('peak alive %.0f fill %.1fM seq %s' % pk[:3])
    ems = [e for e in info['emitters'] if e['kind'] == 'PRE2']
    for k, a in sorted(pk[3].items(), key=lambda kv: -kv[1]):
        e = ems[k]
        print('  %6.0f  %-28s rate=%.0f life=%.2f squirt=%d scale=%s' % (a, e['name'].encode('ascii', 'replace').decode(), e['rate'], e['life'], e['squirt'], tuple(round(x) for x in e['scale'])))
