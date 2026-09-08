# listato-11-01.py — Caricamento del dataset esportato da Studio e taglio in finestre di 128 campioni con passo 20 (200 ms a 100 Hz). La normalizzazione divide per 4: la stessa riga andrà nello sketch.

import numpy as np, pandas as pd, glob, json
import tensorflow as tf
from tensorflow import keras

def carica(cartella):
    X, y = [], []
    for f in glob.glob(f"{cartella}/*.json"):     # export di Studio
        d = json.load(open(f))
        val = np.array(d["payload"]["values"])     # [n, 3]
        cls = f.split("/")[-1].split(".")[0]
        for i in range(0, len(val) - 128, 20):     # passo 200 ms
            X.append(val[i:i+128].flatten())       # 384 valori
            y.append(cls)
    return np.array(X, dtype="float32"), np.array(y)

X_tr, y_tr = carica("training")
X_te, y_te = carica("testing")
classi = sorted(set(y_tr)); print(classi)          # cerchio croce fermo
y_tr = np.array([classi.index(c) for c in y_tr])
y_te = np.array([classi.index(c) for c in y_te])
X_tr /= 4.0; X_te /= 4.0                           # ±4 g -> ±1
