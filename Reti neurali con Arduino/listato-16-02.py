# listato-16-02.py — La rete per il keyword spotting. Due coppie convoluzione-pooling e uno strato d'uscita; è la struttura standard delle reti audio piccole, e Studio la propone come predefinita per il blocco MFCC.

modello = keras.Sequential([
    keras.layers.Input(shape=(49, 13, 1)),
    keras.layers.Conv2D(8, 3, activation="relu", padding="same"),
    keras.layers.MaxPooling2D(2),                   # 24 x 6 x 8
    keras.layers.Conv2D(16, 3, activation="relu", padding="same"),
    keras.layers.MaxPooling2D(2),                   # 12 x 3 x 16
    keras.layers.Flatten(),                         # 576
    keras.layers.Dropout(0.3),
    keras.layers.Dense(4, activation="softmax"),
])                                      # circa 3.600 parametri
