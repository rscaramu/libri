
"""Monitoraggio della deriva sui cuscinetti: le finestre a 0 HP (test) seguite da quelle a 1 HP,
viste dal modello addestrato a 0 HP (../cap07_segnali/cwru_cnn.pt). Confidenza e PSI degli ingressi."""
import sys; sys.path.insert(0, "..")
import numpy as np, torch, matplotlib.pyplot as plt
from torch import nn
import dati
sys.path.insert(0, "../cap07_segnali")

class CNN1D(nn.Module):
    def __init__(self, classi=10):
        super().__init__()
        def blocco(i, o, k, stride=1): return nn.Sequential(nn.Conv1d(i, o, k, stride=stride, padding=k // 2), nn.BatchNorm1d(o), nn.ReLU())
        self.conv = nn.Sequential(blocco(1, 16, 64, stride=8), nn.MaxPool1d(2), blocco(16, 32, 3), nn.MaxPool1d(2), blocco(32, 64, 3), nn.MaxPool1d(2), blocco(64, 64, 3), nn.AdaptiveAvgPool1d(1))
        self.fc = nn.Sequential(nn.Flatten(), nn.Dropout(0.3), nn.Linear(64, classi))
    def forward(self, x): return self.fc(self.conv(x))

def psi(riferimento, nuovo, bins=10):
    q = np.quantile(riferimento, np.linspace(0, 1, bins + 1)); q[0], q[-1] = -np.inf, np.inf
    p_rif = np.histogram(riferimento, q)[0] / len(riferimento) + 1e-6; p_new = np.histogram(nuovo, q)[0] / len(nuovo) + 1e-6
    return float(((p_new - p_rif) * np.log(p_new / p_rif)).sum())

def bande(X):
    F = np.abs(np.fft.rfft(X, axis=1)) ** 2; e = F[:, :512]; tot = e.sum(1, keepdims=True) + 1e-8
    return np.stack([e[:, a:b].sum(1) / tot[:, 0] for a, b in ((0, 64), (64, 128), (128, 256), (256, 512))], 1)

if __name__ == "__main__":
    m = CNN1D(); m.load_state_dict(torch.load("../cap07_segnali/cwru_cnn.pt", weights_only=True)); m.eval()
    seg0, seg1 = dati.cuscinetti(0), dati.cuscinetti(1)
    Xtr = dati.normalizza_finestre(dati.finestre_cuscinetti(seg0, 0, 0.7)[0]); Xte = dati.normalizza_finestre(dati.finestre_cuscinetti(seg0, 0.85, 1.0)[0]); X1 = dati.normalizza_finestre(dati.finestre_cuscinetti(seg1, 0, 1.0)[0])
    with torch.no_grad():
        conf = lambda X: torch.softmax(m(torch.from_numpy(X[:, None, :]).float()), 1).max(1).values.numpy()
        c_te, c_1 = conf(Xte), conf(X1)
    print(f"confidenza < 0.9: test 0 HP {(c_te < 0.9).mean():.1%}   1 HP {(c_1 < 0.9).mean():.1%}")
    b_tr, b_te, b_1 = bande(Xtr), bande(Xte), bande(X1)
    for j, nome in enumerate(["0-750 Hz", "750-1500", "1500-3000", "3000-6000"]):
        print(f"PSI {nome:10s} test 0 HP {psi(b_tr[:, j], b_te[:, j]):.2f}   1 HP {psi(b_tr[:, j], b_1[:, j]):.2f}   (soglia 0.2)")
    seq = np.r_[c_te, c_1]; blocchi = [seq[i:i + 50].mean() for i in range(0, len(seq), 50)]
    plt.plot(np.arange(len(blocchi)) * 50, blocchi); plt.axvline(len(c_te), color="red", ls="--"); plt.xlabel("finestre elaborate"); plt.ylabel("confidenza media"); plt.grid(alpha=0.3); plt.savefig("deriva.png", dpi=150); print("grafico: deriva.png")
