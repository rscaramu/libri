import numpy as np
from numba import cuda, float32

@cuda.jit
def stencil3(u, v, k):
    i = cuda.grid(1)
    if 0 < i < u.shape[0] - 1:
        lap = u[i-1] - float32(2.0) * u[i] + u[i+1]
        v[i] = u[i] + k * lap

@cuda.jit
def somma(x, out):
    i = cuda.grid(1)
    if i < x.shape[0]:
        cuda.atomic.add(out, 0, x[i])

n = 1 << 20
u = np.zeros(n, dtype=np.float32)
u[n // 2] = 1.0
d_u = cuda.to_device(u)
d_v = cuda.to_device(np.zeros_like(u))
B = 256
G = (n + B - 1) // B
for p in range(100):
    stencil3[G, B](d_u, d_v, np.float32(0.25))
    d_u, d_v = d_v, d_u

d_tot = cuda.to_device(np.zeros(1, dtype=np.float32))
somma[G, B](d_u, d_tot)
print("massa conservata: %.6f" % d_tot.copy_to_host()[0])
