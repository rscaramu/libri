import numpy as np
def load(name, shape):
    return np.fromfile(name, dtype=np.float32).reshape(
        shape, order="F")
X = load("x.bin", (784, 2))
y = np.fromfile("y.bin", np.int32)
W1 = load("w1.bin", (128, 784)); b1 = load("b1.bin", (128, 1))
W2 = load("w2.bin", (10, 128)); b2 = load("b2.bin", (10, 1))
A1 = np.maximum(W1 @ X + b1, 0)
Z2 = W2 @ A1 + b2
P = np.exp(Z2 - Z2.max(0)); P /= P.sum(0)
P[y, np.arange(2)] -= 1
dZ2 = P / 2
dW2 = dZ2 @ A1.T
ref = load("dw2.bin", (10, 128))
print("errore max:", np.abs(dW2 - ref).max())
