# listato-17-03.py — Transfer learning in due fasi: prima si addestra solo lo strato finale con la base congelata, poi si sblocca tutto con un learning rate cento volte più basso. Lo strato Lambda replica il canale grigio su tre, perché i pesi di ImageNet sono a colori.

base = keras.applications.MobileNetV2(
    input_shape=(96, 96, 3), alpha=0.35,
    include_top=False, weights="imagenet")
base.trainable = False                    # prima fase: solo la testa

modello = keras.Sequential([
    keras.layers.Input(shape=(96, 96, 1)),
    keras.layers.Lambda(lambda x: tf.repeat(x, 3, -1)),  # 1 -> 3
    base,
    keras.layers.GlobalAveragePooling2D(),
    keras.layers.Dropout(0.2),
    keras.layers.Dense(4, activation="softmax"),
])
modello.compile(optimizer=keras.optimizers.Adam(1e-3),
                loss="sparse_categorical_crossentropy",
                metrics=["accuracy"])
modello.fit(X_tr, y_tr, epochs=20, validation_data=(X_va, y_va))

base.trainable = True                     # seconda fase: fine tuning
modello.compile(optimizer=keras.optimizers.Adam(1e-5),
                loss="sparse_categorical_crossentropy",
                metrics=["accuracy"])
modello.fit(X_tr, y_tr, epochs=10, validation_data=(X_va, y_va))
