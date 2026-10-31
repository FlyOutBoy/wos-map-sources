"""Milim-only copy without the embedded Blood Mage Flame Strike sound events."""
from pathlib import Path
import json,re
from particle_opt.mdx import chunks
ROOT=Path(__file__).resolve().parents[1]
OUTPUT=ROOT/'assets/effects/war3mapImported/wos_MilimW2_Silent.mdx'
def repair(data):
 result=bytearray(data[:4])
 for tag,offset,size in chunks(data):
  if tag=='EVTS':
   assert re.findall(rb'SND[^\0]+',data[offset:offset+size])==[b'SNDxAHFS',b'SNDxAHFT']
   continue
  result.extend(data[offset-8:offset+size])
 return bytes(result)
def main():
 config=json.loads((ROOT/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
 source=Path(config['mainMap'])/'war3mapImported/wos_file00001145.mdx'
 result=repair(source.read_bytes());assert repair(result)==result
 OUTPUT.parent.mkdir(parents=True,exist_ok=True);OUTPUT.write_bytes(result)
 print('Milim W2 copy: removed only SNDxAHFS / SNDxAHFT event chunk')
if __name__=='__main__':main()
