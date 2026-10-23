import ctypes as ct
import numpy as np

lib = ct.CDLL("./libstencil.so")
fp = ct.POINTER(ct.c_float)
lib.stencil_alloc.argtypes = [ct.POINTER(fp), ct.c_int]
lib.stencil_free.argtypes = [fp]
lib.stencil_upload.argtypes = [fp, fp, ct.c_int]
lib.stencil_download.argtypes = [fp, fp, ct.c_int]
lib.stencil_run.argtypes = [fp, fp, ct.c_int,
                            ct.c_float, ct.c_int]
lib.stencil_errstr.restype = ct.c_char_p

def check(code):
    if code != 0:
        msg = lib.stencil_errstr(code).decode()
        raise RuntimeError("CUDA: " + msg)

n = 1 << 20
h = np.zeros(n, dtype=np.float32)
h[n // 2] = 1.0
hp = h.ctypes.data_as(fp)
u, v = fp(), fp()
check(lib.stencil_alloc(ct.byref(u), n))
check(lib.stencil_alloc(ct.byref(v), n))
check(lib.stencil_upload(u, hp, n))
check(lib.stencil_upload(v, hp, n))  # bordi di v a zero
check(lib.stencil_run(u, v, n, 0.25, 100))
check(lib.stencil_download(hp, u, n))
print("massa: %.6f  centro: %.6f" % (h.sum(), h[n // 2]))
check(lib.stencil_free(u))
check(lib.stencil_free(v))
