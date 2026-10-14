import random
random.seed(1)
a = open("rumore.txt", "w")
b = open("quadra.txt", "w")
for i in range(5001):
    t = i * 2e-6
    r = random.gauss(0, 0.1)
    q = 1.0 if (t % 1e-3) < 0.5e-3 else 0.0
    a.write(f"{t:.6e} {r:.6f}\n")
    b.write(f"{t:.6e} {q + r:.6f}\n")
a.close()
b.close()
