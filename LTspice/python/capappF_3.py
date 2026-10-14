import csv, re, subprocess
from pathlib import Path

LTSPICE = [r"C:\Program Files\ADI\LTspice\LTspice.exe"]
CARTELLA = Path("progetti")
RIF = CARTELLA / "riferimento.csv"
NUM = r"([-+]?[0-9.]+(?:[eE][-+]?[0-9]+)?)"
FINE = r"(?: at| FROM|$)"
RIGHE = [re.compile(r"^(\w+): .* AT " + NUM, re.M),
         re.compile(r"^(\w+): .*=" + NUM + FINE, re.M),
         re.compile(r"^(\w+)=" + NUM, re.M)]

def misure(cir):
    subprocess.run(LTSPICE + ["-b", str(cir)], check=True)
    log = cir.with_suffix(".log").read_text(errors="ignore")
    ris = {}
    for r in RIGHE:
        for m in r.finditer(log):
            ris.setdefault(m.group(1), float(m.group(2)))
    for nome in re.findall(r'Measurement "(\w+)" FAIL', log):
        ris[nome] = None
    return ris

attuali = {}
for cir in sorted(CARTELLA.glob("*.cir")):
    for nome, val in misure(cir).items():
        attuali[f"{cir.stem}.{nome}"] = val

if not RIF.exists():
    with open(RIF, "w", newline="") as f:
        csv.writer(f).writerows(sorted(attuali.items()))
    print("riferimento creato:", len(attuali), "misure")
else:
    rif = {k: float(v) if v else None
           for k, v in csv.reader(open(RIF))}
    for k, v in rif.items():
        a = attuali.get(k)
        if a is None or v is None:
            if a != v:
                print(f"{k}: {v} -> {a}")
        elif abs(a - v) > 1e-3 * abs(v):
            print(f"{k}: {v:.6g} -> {a:.6g}")
    print("confronto terminato:", len(rif), "misure")
