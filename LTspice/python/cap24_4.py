import re
import subprocess
from pathlib import Path

LTSPICE = [r"C:\Program Files\ADI\LTspice\LTspice.exe"]
CARTELLA = Path(".")

MODELLO = """* Filtro RC: taglio con R = {r}
V1 in 0 0 AC 1
R1 in out {r}
C1 out 0 100n
Rl out 0 10k
.ac dec 200 10 100k
.meas AC g0 FIND mag(V(out)) AT 10
.meas AC fc WHEN mag(V(out))=g0/sqrt(2)
.end
"""

def simula(r):
    cir = CARTELLA / "ottimizza.cir"
    cir.write_text(MODELLO.format(r=r))
    subprocess.run(LTSPICE + ["-b", str(cir)], check=True)
    log = (CARTELLA / "ottimizza.log").read_text(
        errors="ignore")
    m = re.search(r"^fc: .* AT ([-+0-9.eE]+)", log, re.M)
    return float(m.group(1))

def cerca(obiettivo, r0, r1, toll=1e-4):
    f0 = simula(r0) - obiettivo
    f1 = simula(r1) - obiettivo
    while abs(f1) > toll * obiettivo:
        r0, r1 = r1, r1 - f1 * (r1 - r0) / (f1 - f0)
        f0, f1 = f1, simula(r1) - obiettivo
        fc = f1 + obiettivo
        print(f"R = {r1:.2f} ohm, fc = {fc:.3f} Hz")
    return r1

print(cerca(1000.0, 1000.0, 2000.0))
