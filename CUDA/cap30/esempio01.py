import cupy as cp
import numpy as np
from cupyx.profiler import benchmark

# identica per NumPy e CuPy: cambia solo il tipo di a
def normalizza_righe(a):
    m = a.mean(axis=1, keepdims=True)
    s = a.std(axis=1, keepdims=True) + 1e-6
    return (a - m) / s

h = np.random.rand(8192, 4096).astype(np.float32)
d = cp.asarray(h)
r_np = normalizza_righe(h)
r_cp = normalizza_righe(d)
print("errore max:", float(cp.abs(cp.asarray(r_np)
                                   - r_cp).max()))
t = benchmark(normalizza_righe, (d,), n_repeat=20)
print("cupy: %.2f ms" % (t.gpu_times.mean() * 1e3))
