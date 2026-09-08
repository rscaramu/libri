# train-gesti.py — modelli della Parte II/III su dati sintetici (Iris è reale)
import os, numpy as np, tensorflow as tf
from tensorflow import keras
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "3"
tf.random.set_seed(0); np.random.seed(0)
OUT = "modelli"; os.makedirs(OUT, exist_ok=True)

def to_header(tflite, name, path):
    toks = [f"0x{b:02x}" for b in tflite]
    body = [",".join(" " + t for t in toks[i:i+12]).lstrip() for i in range(0, len(toks), 12)]
    open(path, "w").write(f"// {os.path.basename(path)} — modello quantizzato int8, {len(tflite)} byte\n#pragma once\n#include <cstdint>\nalignas(16) const unsigned char {name}[] = {{\n  " + ",\n  ".join(body) + f"\n}};\nconst unsigned int {name}_len = {len(tflite)};\n")

def convert_int8(model, rep, shape):
    """Conversione int8 completa. Il modello viene clonato con batch fisso a 1: senza, Flatten/Reshape
    producono SHAPE/STRIDED_SLICE/PACK per il batch dinamico, op inutili sul microcontrollore."""
    cfg = model.get_config(); cfg["layers"][0]["config"]["batch_shape"] = [1] + list(shape[1:])
    m1 = keras.Sequential.from_config(cfg); m1.set_weights(model.get_weights())
    def rappresentativi():
        for x in rep[:200]: yield [x.reshape(shape).astype("float32")]
    conv = tf.lite.TFLiteConverter.from_keras_model(m1)
    conv.optimizations = [tf.lite.Optimize.DEFAULT]
    conv.representative_dataset = rappresentativi
    conv.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
    conv.inference_input_type = tf.int8; conv.inference_output_type = tf.int8
    return conv.convert()

# ---------------- Iris 4-8-3 (listato 5.1), float, pesi esatti ----------------
from sklearn.datasets import load_iris
X, y = load_iris(return_X_y=True)
iris = keras.Sequential([keras.layers.Input((4,)), keras.layers.Dense(8, activation="relu"), keras.layers.Dense(3, activation="softmax")])
iris.compile(optimizer=keras.optimizers.Adam(0.02), loss="sparse_categorical_crossentropy", metrics=["accuracy"])
iris.fit(X, y, epochs=300, verbose=0)
acc = iris.evaluate(X, y, verbose=0)[1]
W1, b1 = iris.layers[0].get_weights(); W2, b2 = iris.layers[1].get_weights()
def cmat(M, ind="  "):
    return ",\n".join(ind + "{" + ", ".join(f"{v:6.3f}" for v in row) + "}" for row in M)
c = f"""// pesi-iris.h — rete 4-8-3 addestrata in Keras su Iris (acc. {acc:.3f})
const float W1[4][8] = {{
{cmat(W1)}}};
const float b1[8] = {{{", ".join(f"{v:6.3f}" for v in b1)}}};
const float W2[8][3] = {{
{cmat(W2)}}};
const float b2[3] = {{{", ".join(f"{v:6.3f}" for v in b2)}}};
"""
open(f"{OUT}/pesi-iris.h", "w").write(c)
p = iris.predict(np.array([[5.1, 3.5, 1.4, 0.2]]), verbose=0)[0]
print(f"iris: acc {acc:.3f}; setosa -> classe {p.argmax()} p={np.round(p,3)}")

# ---------------- gesti sintetici: cerchio, croce, fermo ----------------
def gesto(cls, rng, n=128, fs=100):
    t = np.arange(n) / fs; x = np.zeros((n, 3)); x[:, 2] = 1.0
    if cls == 0:  # cerchio: sinusoidi sfasate su x,y
        f0 = rng.uniform(0.8, 1.3); a = rng.uniform(0.4, 0.9); ph = rng.uniform(0, 2*np.pi); d = rng.uniform(0.7, 1.1)
        m = (t > 0.1) & (t < 0.1 + d); x[m, 0] += a*np.sin(2*np.pi*f0*t[m] + ph); x[m, 1] += a*np.cos(2*np.pi*f0*t[m] + ph)
    elif cls == 1:  # croce: due impulsi
        for c, s in ((rng.uniform(0.3, 0.5), 1), (rng.uniform(0.75, 0.95), -1)):
            a = rng.uniform(0.8, 1.5); w = rng.uniform(0.05, 0.1)
            x[:, 0] += s*a*np.exp(-((t-c)/w)**2); x[:, 1] += a*0.8*np.exp(-((t-c-0.08)/w)**2)
    else:  # fermo o movimento lento
        x[:, 0] += rng.uniform(-0.15, 0.15) * np.sin(2*np.pi*rng.uniform(0.1, 0.4)*t)
        x[:, 1] += rng.uniform(-0.15, 0.15) * np.cos(2*np.pi*rng.uniform(0.1, 0.4)*t)
    # orientamento casuale (rotazione piccola) e rumore
    th = rng.uniform(-0.4, 0.4); R = np.array([[np.cos(th), -np.sin(th), 0], [np.sin(th), np.cos(th), 0], [0, 0, 1]])
    x = x @ R.T + 0.03*rng.standard_normal((n, 3))
    return np.roll(x, rng.integers(-15, 15), axis=0)

def dataset(seed, per_cls):
    rng = np.random.default_rng(seed); X, y = [], []
    for c in range(3):
        for _ in range(per_cls): X.append(gesto(c, rng).flatten()); y.append(c)
    return np.array(X, "float32") / 4.0, np.array(y)
X_tr, y_tr = dataset(1, 400); X_te, y_te = dataset(2, 100)   # "persona" diversa = seed diverso
np.savetxt(f"{OUT}/gesti-test.csv", np.c_[y_te, X_te], delimiter=",", fmt="%.4f")

g = keras.Sequential([keras.layers.Input((384,)), keras.layers.Dense(32, activation="relu"), keras.layers.Dropout(0.25), keras.layers.Dense(3, activation="softmax")])
g.compile(optimizer=keras.optimizers.Adam(1e-3), loss="sparse_categorical_crossentropy", metrics=["accuracy"])
stop = keras.callbacks.EarlyStopping(patience=8, restore_best_weights=True)
g.fit(X_tr, y_tr, epochs=100, batch_size=32, validation_split=0.2, callbacks=[stop], verbose=0)
print("gesti: parametri", g.count_params(), "acc test float", round(g.evaluate(X_te, y_te, verbose=0)[1], 3))
tfl = convert_int8(g, X_tr, (1, 384)); open(f"{OUT}/gesti.tflite", "wb").write(tfl); to_header(tfl, "gesti_tflite", f"{OUT}/gesti_modello.h")
# verifica int8 e vettore di riferimento per il test 12.5
it = tf.lite.Interpreter(model_content=tfl); it.allocate_tensors(); inp = it.get_input_details()[0]; out = it.get_output_details()[0]
s, z = inp["quantization"]; so, zo = out["quantization"]; ok = 0
for x, yy in zip(X_te, y_te):
    q = np.clip(np.round(x / s) + z, -128, 127).astype("int8"); it.set_tensor(inp["index"], q.reshape(1, 384)); it.invoke()
    ok += it.get_tensor(out["index"])[0].argmax() == yy
print(f"gesti: .tflite {len(tfl)} byte; acc test int8 {ok/len(y_te):.3f}; scala {s:.5f} zp {z}; uscita scala {so:.5f} zp {zo}")
q = np.clip(np.round(X_te[0] / s) + z, -128, 127).astype("int8"); it.set_tensor(inp["index"], q.reshape(1, 384)); it.invoke(); o = it.get_tensor(out["index"])[0]
open(f"{OUT}/gesti_riferimento.h", "w").write("// finestra nota (classe %d) e uscita attesa int8: %s\nconst int8_t rifIngresso[384] = {%s};\nconst int8_t rifUscita[3] = {%s};\n" % (y_te[0], list(o), ", ".join(map(str, q)), ", ".join(map(str, o))))
tf.lite.experimental.Analyzer.analyze(model_content=tfl)
