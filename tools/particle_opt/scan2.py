import os, sys, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import mdx, sim, rank
root = sys.argv[1]
rows = []
for dp, dn, fn in os.walk(root):
    for f in fn:
        if not f.lower().endswith('.mdx'):
            continue
        p = os.path.join(dp, f)
        try:
            info, _ = mdx.analyze(p)
            pk = sim.model_peak(info)
        except Exception as ex:
            print('ERR', f, ex); continue
        rel = os.path.relpath(p, root)
        c, o = rank.uses(rel)
        rows.append(dict(path=rel, peak=round(pk[0]), fill=round(pk[1], 2), seq=pk[2], faces=info['faces'], verts=info['verts'],
                         nemit=len(info['emitters']), code=c, obj=o, size=info['size']))
json.dump(rows, open(sys.argv[2], 'w'), indent=0)
used = [r for r in rows if r['code'] or r['obj']]
print('models', len(rows), 'used', len(used))
for key in ('peak', 'fill', 'faces'):
    print('--- top by', key)
    for r in sorted(used, key=lambda r: -r[key])[:int(sys.argv[3])]:
        print('%6d %6.1fM %6d f  code=%-2d obj=%d  %s' % (r['peak'], r['fill'], r['faces'], r['code'], r['obj'], r['path'].encode('ascii', 'replace').decode()))
for th in (300, 400, 600, 1000):
    print('peak >', th, sum(1 for r in used if r['peak'] > th))
