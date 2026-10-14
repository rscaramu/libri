import re, subprocess

LTSPICE = r"C:\Program Files\ADI\LTspice\LTspice.exe"
PROVE = ["c34_op", "c34_ac", "c34_mc", "c34_rumore",
         "c34_gradino"]

def numero(s):
    r = re.match(r"\(?([-+\d.eE]+)", s.strip())
    return float(r.group(1))

def misure(nome):
    """Misure di un log: valori e tabelle dei passi."""
    t = open(nome + ".log", encoding="utf-8").read()
    t = t.replace("\r", "")
    m = {}
    for riga in t.split("\n"):
        r = re.match(r"(\w+): (.*)", riga)
        if not r or r.group(1) == "Measurement":
            continue
        resto = r.group(2)
        if " AT " in resto:
            m[r.group(1)] = numero(resto.split(" AT ")[1])
        elif "=" in resto:
            m[r.group(1)] = numero(resto.split("=")[-1])
    tab = re.findall(r"Measurement: (\w+)\n.*\n"
                     r"((?:\s+\d+\t.*\n?)+)", t)
    for nome_m, corpo in tab:
        m[nome_m] = [numero(x.split("\t")[1])
                     for x in corpo.strip("\n").split("\n")]
    return m

m = {}
for p in PROVE:
    subprocess.run([LTSPICE, "-b", p + ".cir"], check=True)
    m.update(misure(p))

g, vo, cm = m["g1"], m["vo"], min(m["cmrr"])
rumore = m["vno"] / g * 1e6
assest = (m["ts"] - 1e-3) * 1e3
requisiti = [
    ("R1 guadagno", g, abs(g / 400 - 1) <= 0.01),
    ("R2 fondo scala (V)", vo, abs(vo / 4 - 1) <= 0.02),
    ("R3 taglio (Hz)", m["f3"], 90 <= m["f3"] <= 110),
    ("R3 attenuazione 1 kHz (dB)", m["a1k"], m["a1k"] >= 35),
    ("R4 CMRR minima (dB)", cm, cm >= 80),
    ("R5 rumore (uV)", rumore, rumore <= 0.1),
    ("R6 sovraelongazione (%)", m["ov"], m["ov"] <= 5),
    ("R6 assestamento (ms)", assest, assest <= 15),
]
for testo, valore, ok in requisiti:
    esito = "OK" if ok else "NO"
    print(f"{testo:30s}{valore:10.4g}  {esito}")
