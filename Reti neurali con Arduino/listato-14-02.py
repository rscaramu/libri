# listato-14-02.py — La rete convoluzionale 1D per le cadute. Tre coppie convoluzione-pooling riducono 200 campioni a 9, poi la media globale li condensa in 32 valori per lo strato d'uscita. Il commento a destra segue le dimensioni strato per strato.

modello = keras.Sequential([
    keras.layers.Input(shape=(200, 6)),
    keras.layers.Conv1D(8, 5, activation="relu"),   # 200 -> 196 x 8
    keras.layers.MaxPooling1D(4),                    # 49 x 8
    keras.layers.Conv1D(16, 5, activation="relu"),  # 45 x 16
    keras.layers.MaxPooling1D(4),                    # 11 x 16
    keras.layers.Conv1D(32, 3, activation="relu"),  # 9 x 32
    keras.layers.GlobalAveragePooling1D(),          # 32
    keras.layers.Dropout(0.3),
    keras.layers.Dense(4, activation="softmax"),
])
modello.summary()                       # circa 2.600 parametri
