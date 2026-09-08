# strumenti/fft-verifica.py — capitolo 15: genera una finestra sintetica (sinusoide a 25 Hz, 256 campioni a 100 Hz),
# stampa lo spettro come lo calcola Python e un header C con i campioni, da confrontare con l'uscita dello sketch.
import numpy as np
fs, n, f0 = 100, 256, 25.0
t = np.arange(n) / fs
x = 1.0 + 0.02 * np.sin(2 * np.pi * f0 * t)            # modulo dell'accelerazione, in g
w = np.hanning(n)
f = np.abs(np.fft.rfft((x - x.mean()) * w))
spettro = np.log1p(f[1:65])
open("finestra_verifica.h", "w").write("const float finestra[256] = {%s};\n" % ", ".join(f"{v:.5f}" for v in x))
print("bin 1..64 (log1p del modulo):"); print(np.round(spettro, 3))
print("picco atteso al bin", int(round(f0 / (fs / n))), "->", round(spettro[int(round(f0 / (fs / n))) - 1], 3))
