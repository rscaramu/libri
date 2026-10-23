import numpy as np
from numba import cuda, float32

@cuda.jit
def somma_warp(x, out):
    i = cuda.grid(1)
    v = float32(0.0)
    if i < x.shape[0]:
        v = x[i]
    off = 16
    while off > 0:
        v += cuda.shfl_down_sync(0xffffffff, v, off)
        off //= 2
    if cuda.threadIdx.x % 32 == 0:
        cuda.atomic.add(out, 0, v)

n = 1 << 22
x = cuda.to_device(np.full(n, 0.25, dtype=np.float32))
out = cuda.to_device(np.zeros(1, dtype=np.float32))
somma_warp[(n + 255) // 256, 256](x, out)
print("somma:", out.copy_to_host()[0], " attesa:", n * 0.25)
