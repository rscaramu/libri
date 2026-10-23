import cupy as cp
import numpy as np

codice = r"""
extern "C" __global__
void somma_blocchi(const float *in, float *out, int n) {
    __shared__ float s[256];
    int t = threadIdx.x;
    int i = blockIdx.x * blockDim.x * 2 + t;
    float v = 0.0f;
    if (i < n) v += in[i];
    if (i + blockDim.x < n) v += in[i + blockDim.x];
    s[t] = v;
    __syncthreads();
    for (int st = blockDim.x / 2; st > 32; st >>= 1) {
        if (t < st) s[t] += s[t + st];
        __syncthreads();
    }
    if (t < 32) {
        v = s[t] + s[t + 32];
        for (int off = 16; off > 0; off >>= 1)
            v += __shfl_down_sync(0xffffffff, v, off);
    }
    if (t == 0) out[blockIdx.x] = v;
}
"""

kern = cp.RawKernel(codice, "somma_blocchi")

def somma(x):
    n = x.size
    B = 256
    nb = (n + 2 * B - 1) // (2 * B)
    out = cp.empty(nb, dtype=cp.float32)
    kern((nb,), (B,), (x, out, np.int32(n)))
    # secondo livello: nb e' piccolo, basta CuPy
    return float(out.sum())

x = cp.ones(10_000_001, dtype=cp.float32)
print("somma =", somma(x))
print("attesa =", float(x.sum()))
