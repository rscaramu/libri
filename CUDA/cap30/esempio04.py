import numpy as np
import pycuda.autoinit
import pycuda.driver as drv
from pycuda.compiler import SourceModule

mod = SourceModule(r"""
__global__ void scala(float *v, float k, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) v[i] *= k;
}
""")
scala = mod.get_function("scala")
n = 1000
h = np.arange(n, dtype=np.float32)
d = drv.mem_alloc(h.nbytes)
drv.memcpy_htod(d, h)
scala(d, np.float32(2.0), np.int32(n),
      block=(256, 1, 1), grid=((n + 255) // 256, 1))
drv.memcpy_dtoh(h, d)
print(h[-1])        # 1998.0
