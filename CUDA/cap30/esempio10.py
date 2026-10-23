import torch
import cupy as cp

t = torch.linspace(-2, 2, 9, device="cuda")
c = cp.from_dlpack(t)
clamp_scale(c, -1.0, 1.0, 10.0, c)   # output = input
torch.cuda.synchronize()
print(t)
print("stesso puntatore:", c.data.ptr == t.data_ptr())
