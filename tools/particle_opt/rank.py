import json, sys, os, glob
d = None
src = ''
for p in glob.glob('triggers/**/*.j', recursive=True):
    src += open(p, encoding='utf-8', errors='ignore').read().lower()
od = ''
for p in glob.glob('object-data/*.json'):
    od += open(p, encoding='utf-8', errors='ignore').read().lower()
BS = chr(92)
od = od.replace(BS + BS, BS)
src = src.replace(BS + BS, BS)

def uses(path):
    b = os.path.splitext(path.lower())[0].split(BS)[-1]
    return src.count(b + '.md'), od.count(b + '.md')

if __name__ == '__main__':
    d = json.load(open(sys.argv[1])); key = sys.argv[2]
    rows = sorted(d['rows'], key=lambda r: -r[key])
    for r in rows[:int(sys.argv[3])]:
        c, o = uses(r['path'])
        print('%6d %6d %6d %6dK %3dem code=%d obj=%d  %s' % (r['pcost'], r['faces'], r['verts'], r['size'] // 1024, r['nemit'], c, o, r['path']))
