import re, subprocess
import numpy as np
from leggi_raw import leggi_raw

LTSPICE = r"C:\Program Files\ADI\LTspice\LTspice.exe"
subprocess.run([LTSPICE, "-b", "c24_es1.cir"], check=True)
log = open("c24_es1.log", errors="ignore").read()
m = re.search(r"^tsal=([-+0-9.eE]+)", log, re.M)
tsal = float(m.group(1))
d = leggi_raw("c24_es1.raw")
t, v = d["time"], d["V(out)"]
s = t < 5e-3
dt = np.interp(0.9, v[s], t[s]) - np.interp(0.1, v[s], t[s])
print(f".meas: {tsal*1e3:.6f} ms  Python: {dt*1e3:.6f} ms")
