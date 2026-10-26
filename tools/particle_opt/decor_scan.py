import os, sys, json, re, glob
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import mdx, sim
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
MAP = r'C:/Users/Gear/Documents/Warcraft III/Maps/WoS/Anime_WOS2_0.32.w3x'
BS = chr(92)

def norm(p):
    p = p.replace('/', BS).replace(BS + BS, BS).lower().strip()
    return os.path.splitext(p)[0]

files = {}
for dp, dn, fn in os.walk(MAP):
    for f in fn:
        if f.lower().endswith('.mdx'):
            rel = os.path.relpath(os.path.join(dp, f), MAP)
            files[norm(rel)] = rel

groups = {'decor_model': set(), 'decor_fx': set(), 'dummy': set(), 'sukuna_roundend': set()}
# 1. destructable models
d = json.load(open(ROOT + '/object-data/destructables.json', encoding='utf-8'))
for src_file in ('destructables.json', 'doodads.json'):
    try:
        dd = json.load(open(ROOT + '/object-data/' + src_file, encoding='utf-8'))
    except FileNotFoundError:
        continue
    for oid, o in dd.items():
        for k, v in o.items():
            if isinstance(v, str) and k in ('field_bfil', 'field_dfil', 'model', 'file') and v:
                base = norm(v)
                groups['decor_model'].add(base)
                for i in range(10):  # variations: <model><n>.mdx
                    groups['decor_model'].add(base + str(i))
# 2. effects spawned in decor destruction code
src = open(ROOT + '/triggers/Systems/DecorDestroy_and_Erza_Debuff.j', encoding='utf-8').read()
a = src.index('function decordestroy takes nothing returns nothing')
e = src.index('function DecorRestore takes nothing returns nothing')
for m in re.findall(r'"([^"]+\.md[lx])"', src[a:e], re.I):
    groups['decor_fx'].add(norm(m))
# 3. dummy units (locust)
u = json.load(open(ROOT + '/object-data/units.json', encoding='utf-8'))
for oid, o in u.items():
    if 'Aloc' in str(o.get('normal_abilities', '')):
        for k, v in o.items():
            if isinstance(v, str) and (k == 'model' or k == 'field_umdl') and v:
                groups['dummy'].add(norm(v))
# 4. round end (Sukuna)
src = open(ROOT + '/triggers/Round_End/RoundEnd.j', encoding='utf-8').read()
for m in re.findall(r'"([^"]+\.md[lx])"', src, re.I):
    groups['sukuna_roundend'].add(norm(m))

# usage elsewhere (heroes)
hero_src = ''
for p in glob.glob(ROOT + '/triggers/Heroes/**/*.j', recursive=True):
    hero_src += open(p, encoding='utf-8', errors='ignore').read().lower().replace(BS + BS, BS)

out = []
for g, names in groups.items():
    for n in sorted(names):
        rel = files.get(n)
        if not rel:
            continue
        info, _ = mdx.analyze(os.path.join(MAP, rel))
        pk = sim.model_peak(info)
        base = n.split(BS)[-1]
        out.append(dict(group=g, path=rel, peak=round(pk[0]), fill=round(pk[1], 1), faces=info['faces'],
                        hero=(base + '.md') in hero_src, nemit=len([x for x in info['emitters'] if x['kind'] == 'PRE2'])))
json.dump(out, open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'decor_scan.json'), 'w'), indent=1)
for r in sorted(out, key=lambda r: (r['group'], -r['peak'])):
    if r['peak'] or r['faces'] > 3000:
        print('%-15s %5d %6.1fM %6df hero=%d %s' % (r['group'], r['peak'], r['fill'], r['faces'], r['hero'], r['path'].encode('ascii', 'replace').decode()))
print({g: len(v) for g, v in groups.items()}, 'found', len(out))
