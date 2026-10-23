import torch
import cupy as cp

t = torch.arange(12, dtype=torch.float32,
                 device="cuda").reshape(3, 4)

# vista CuPy senza copia (stesso puntatore)
c = cp.from_dlpack(t)
c *= 10
print(t)                     # la modifica si vede in torch
print(c.data.ptr == t.data_ptr())

# viceversa: da CuPy a torch
x = cp.ones((2, 2), dtype=cp.float32)
tx = torch.from_dlpack(x)
tx[0, 0] = 5
print(x)
