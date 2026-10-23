import cupy as cp
import numpy as np
from cupyx.profiler import benchmark

src = r"""
extern "C" __global__
void hist(const unsigned char *x, unsigned int *h, int n) {
    __shared__ unsigned int s[256];
    for (int b = threadIdx.x; b < 256; b += blockDim.x)
        s[b] = 0;
    __syncthreads();
    int stride = gridDim.x * blockDim.x;
    for (int i = blockIdx.x * blockDim.x + threadIdx.x;
         i < n; i += stride)
        atomicAdd(&s[x[i]], 1u);
    __syncthreads();
    for (int b = threadIdx.x; b < 256; b += blockDim.x)
        if (s[b]) atomicAdd(&h[b], s[b]);
}
"""
k = cp.RawKernel(src, "hist")

def hist_raw(x):
    h = cp.zeros(256, dtype=cp.uint32)
    k((1024,), (256,), (x, h, np.int32(x.size)))
    return h

x = cp.random.randint(0, 256, 50_000_000,
                      dtype=cp.int32).astype(cp.uint8)
h1 = hist_raw(x)
h2 = cp.bincount(x, minlength=256)
print("uguali:", bool((h1 == h2).all()))
for f in (hist_raw, lambda a: cp.bincount(a, minlength=256)):
    t = benchmark(f, (x,), n_repeat=10)
    print("%.3f ms" % (t.gpu_times.mean() * 1e3))
