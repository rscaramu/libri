# listato-14-03.py — Augmentation per segnali IMU: rumore, cambio di scala del 10%, spostamento fino a 200 ms. Ogni finestra ne genera quattro nuove, tutte plausibili, e il dataset diventa cinque volte più grande senza raccogliere nulla.

def aumenta(X, y, volte=4, rng=np.random.default_rng(0)):
    Xa, ya = [X], [y]
    for _ in range(volte):
        Xn = X.copy()
        Xn += rng.normal(0, 0.02, Xn.shape)            # rumore
        Xn *= rng.uniform(0.9, 1.1, (len(X), 1, 1))    # scala
        sh = rng.integers(-20, 20, len(X))             # spostamento
        for i, s in enumerate(sh): Xn[i] = np.roll(Xn[i], s, axis=0)
        Xa.append(Xn); ya.append(y)
    return np.concatenate(Xa), np.concatenate(ya)

X_tr, y_tr = aumenta(X_tr, y_tr)                       # 5x
