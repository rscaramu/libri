# listato-11-02.py — La rete 384→32→3 del capitolo 2, con dropout ed early stopping. Il conto dei parametri stampato da summary deve dare 12.387: è la verifica del paragrafo 2.5.

modello = keras.Sequential([
    keras.layers.Input(shape=(384,)),
    keras.layers.Dense(32, activation="relu"),
    keras.layers.Dropout(0.25),
    keras.layers.Dense(3, activation="softmax"),
])
modello.compile(optimizer=keras.optimizers.Adam(1e-3),
                loss="sparse_categorical_crossentropy",
                metrics=["accuracy"])
modello.summary()                                  # 12.387 parametri
stop = keras.callbacks.EarlyStopping(patience=8,
                                     restore_best_weights=True)
storia = modello.fit(X_tr, y_tr, epochs=100, batch_size=32,
                     validation_split=0.2, callbacks=[stop])
print("test:", modello.evaluate(X_te, y_te)[1])
