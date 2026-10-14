import math

with open("chirp.txt", "w") as f:
    n = 2000
    for i in range(n + 1):
        t = i * 10e-3 / n
        f0, f1, T = 100, 2000, 10e-3
        fase = 2 * math.pi * (f0 * t
                              + (f1 - f0) * t * t / (2 * T))
        f.write(f"{t:.6e} {math.sin(fase):.6f}\n")
