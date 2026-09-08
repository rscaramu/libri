# listato-15-02.py — Spettro e autoencoder in Keras. La rete impara a riprodurre l'ingresso (fit riceve Xn due volte); mu e sd vanno salvati perché la scheda dovrà standardizzare con gli stessi valori.

def spettro(finestra):                    # finestra: [256, 3]
    f = np.abs(np.fft.rfft(finestra - finestra.mean(0), axis=0))
    return np.log1p(f[1:65].mean(1))       # 64 bin, media sugli assi

X = np.array([spettro(w) for w in finestre_normali])   # [n, 64]
mu, sd = X.mean(0), X.std(0) + 1e-6
Xn = (X - mu) / sd                                      # standardizza

ae = keras.Sequential([
    keras.layers.Input(shape=(64,)),
    keras.layers.Dense(16, activation="relu"),
    keras.layers.Dense(4,  activation="relu"),   # collo di bottiglia
    keras.layers.Dense(16, activation="relu"),
    keras.layers.Dense(64),                      # ricostruzione
])
ae.compile(optimizer="adam", loss="mse")
ae.fit(Xn, Xn, epochs=200, batch_size=32, validation_split=0.2,
       callbacks=[keras.callbacks.EarlyStopping(patience=15,
                  restore_best_weights=True)])
