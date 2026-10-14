import re, subprocess, math
from pathlib import Path
from scipy.optimize import minimize

LTSPICE = [r"C:\Program Files\ADI\LTspice\LTspice.exe"]
CARTELLA = Path(".")

MODELLO = """* Sallen-Key: C1 = {c1:.6g}, C2 = {c2:.6g}
V1 in 0 0 AC 1
R1 in a 10k
R2 a b 10k
C1 a out {c1:.6g}
C2 b 0 {c2:.6g}
XU1 b out vcc vee out level2 Avol=1Meg GBW=10Meg Slew=10Meg
Vcc vcc 0 15
Vee vee 0 -15
.lib UniversalOpAmp2.lib
.ac dec 200 10 100k
.meas AC f3 WHEN mag(V(out))=1/sqrt(2)
.meas AC f90 WHEN ph(V(out))=-90
.end
"""

def misura(c1, c2):
    cir = CARTELLA / "sk.cir"
    cir.write_text(MODELLO.format(c1=c1, c2=c2))
    subprocess.run(LTSPICE + ["-b", str(cir)], check=True)
    log = (CARTELLA / "sk.log").read_text(errors="ignore")
    val = {}
    for nome in ("f3", "f90"):
        m = re.search(rf"^{nome}: .* AT ([-+0-9.eE]+)",
                      log, re.M)
        val[nome] = float(m.group(1)) if m else 1e9
    return val

def scarto(x):
    v = misura(10 ** x[0], 10 ** x[1])
    e3 = (v["f3"] - 1000) / 1000
    e90 = (v["f90"] - 1000) / 1000
    return e3 ** 2 + e90 ** 2

ris = minimize(scarto, [math.log10(10e-9), math.log10(10e-9)],
               method="Nelder-Mead",
               options={"xatol": 1e-4, "fatol": 1e-8})
c1, c2 = 10 ** ris.x
print(f"C1 = {c1*1e9:.2f} nF, C2 = {c2*1e9:.2f} nF, "
      f"simulazioni: {ris.nfev}")
print(misura(c1, c2))
