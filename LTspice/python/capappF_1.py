import numpy as np
import matplotlib.pyplot as plt
from leggi_raw import leggi_raw, passi

fig, (a1, a2) = plt.subplots(2, 1, sharex=True,
                             figsize=(6, 4))
for i, p in enumerate(passi(leggi_raw("rca.raw"))):
    f = np.real(p["frequency"])
    v = p["V(out)"]
    st = dict(color="black", ls=["-", "--"][i % 2])
    a1.semilogx(f, 20 * np.log10(np.abs(v)),
                label=f"passo {i + 1}", **st)
    a2.semilogx(f, np.degrees(np.angle(v)), **st)
a1.set_ylabel("Modulo (dB)")
a2.set_ylabel("Fase (gradi)")
a2.set_xlabel("Frequenza (Hz)")
a1.legend()
for a in (a1, a2):
    a.grid(True, which="both")
fig.tight_layout()
fig.savefig("bode.png", dpi=200)
