"""Le quattro varianti della CNN su CIFAR-10 (§ 5.7). Uso: python cap5exp.py base|aug|bn|augbn [epoche]
Salva un checkpoint a ogni epoca (checkpoint_<variante>.pt) e riprende da lì se interrotto."""
import os, sys, time, json, random, numpy as np, torch
from torch import nn
from torchvision import transforms
from torch.utils.data import DataLoader, TensorDataset, Dataset
def fissa_seme(s=42): random.seed(s); np.random.seed(s); torch.manual_seed(s)
T0 = time.time(); EPOCHE = int(sys.argv[2]) if len(sys.argv) > 2 else 8
import sys; sys.path.insert(0, "..")
import dati
def prepara(X, y):
    X = torch.from_numpy(X).permute(0, 3, 1, 2).float()/255; return (X-0.5)/0.5, torch.from_numpy(y.copy()).long()
Xa, ya, Xb, yb = dati.cifar10_mirror(); Xtr, ytr = prepara(Xa, ya); Xte, yte = prepara(Xb, yb)
test_dl = DataLoader(TensorDataset(Xte, yte), batch_size=500)
class AugDS(Dataset):
    def __init__(s, X, y, aug): s.X, s.y, s.aug = X, y, aug
    def __len__(s): return len(s.X)
    def __getitem__(s, i):
        x = s.X[i]
        if s.aug:
            # RandomCrop(32, padding=4) + RandomHorizontalFlip, su tensore
            x = nn.functional.pad(x, (4, 4, 4, 4), mode="reflect")
            i0, j0 = random.randint(0, 8), random.randint(0, 8); x = x[:, i0:i0+32, j0:j0+32]
            if random.random() < 0.5: x = x.flip(2)
        return x, s.y[i]
class CNN(nn.Module):
    def __init__(s, bn=False):
        super().__init__()
        def blocco(i, o):
            l = [nn.Conv2d(i, o, 3, padding=1)] + ([nn.BatchNorm2d(o)] if bn else []) + [nn.ReLU(), nn.MaxPool2d(2)]
            return nn.Sequential(*l)
        s.conv = nn.Sequential(blocco(3, 32), blocco(32, 64), blocco(64, 128))
        s.fc = nn.Sequential(nn.Flatten(), nn.Dropout(0.3), nn.Linear(2048, 256), nn.ReLU(), nn.Dropout(0.3), nn.Linear(256, 10))
    def forward(s, x): return s.fc(s.conv(x))
fn = nn.CrossEntropyLoss()
def valuta(m):
    m.eval(); c = 0; l = 0.0
    with torch.no_grad():
        for xb, yb in test_dl: o = m(xb); l += fn(o, yb).item()*len(yb); c += (o.argmax(1) == yb).sum().item()
    return l/len(yte), c/len(yte)
nome = sys.argv[1] if len(sys.argv) > 1 else "base"; aug = "aug" in nome; bn = "bn" in nome
ck = f"checkpoint_{nome}.pt"
fissa_seme(42); m = CNN(bn); opt = torch.optim.Adam(m.parameters(), lr=1e-3); start = 0; st = []
if os.path.exists(ck):
    c = torch.load(ck); m.load_state_dict(c["m"]); opt.load_state_dict(c["o"]); start = c["e"]; st = c["st"]; torch.set_rng_state(c["rng"]); random.setstate(c["py"])
dl = DataLoader(AugDS(Xtr, ytr, aug), batch_size=64, shuffle=True)
for e in range(start, EPOCHE):
    m.train(); s = 0; n = 0
    for xb, yb in dl:
        l = fn(m(xb), yb); opt.zero_grad(); l.backward(); opt.step(); s += l.item()*len(yb); n += len(yb)
    lt, at = valuta(m); st.append((s/n, lt, at))
    print(f"{nome} Epoca {e+1}: train {s/n:.4f} | test {lt:.4f} | acc {at:.2%} ({time.time()-T0:.0f}s)", flush=True)
    torch.save({"m": m.state_dict(), "o": opt.state_dict(), "e": e+1, "st": st, "rng": torch.get_rng_state(), "py": random.getstate()}, ck)
    
print("FINE", nome, [round(a[2], 4) for a in st])
