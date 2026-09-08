# train-oggetti.py — MobileNetV2 0.35 96x96 con testa a 4 classi, quantizzata int8 (immagini sintetiche: verifica dimensioni e op)
import os, numpy as np, tensorflow as tf
from tensorflow import keras
os.environ["TF_CPP_MIN_LOG_LEVEL"]="3"; tf.random.set_seed(0); np.random.seed(0)
src=open("train-gesti.py").read(); ns={}
exec(src[src.index("def to_header"):src.index("# ---------------- Iris")], {"os":os,"tf":tf,"np":np,"keras":keras}, ns)
base = keras.applications.MobileNetV2(input_shape=(96,96,3), alpha=0.35, include_top=False, weights="imagenet")
base.trainable = False
inp = keras.layers.Input((96,96,1), batch_size=1)
x = keras.layers.Concatenate()([inp, inp, inp])           # 1 -> 3 canali senza Lambda
x = base(x); x = keras.layers.GlobalAveragePooling2D()(x); x = keras.layers.Dropout(0.2)(x)
out = keras.layers.Dense(4, activation="softmax")(x)
m = keras.Model(inp, out)
# immagini sintetiche: quattro pattern (verifica della catena, non dell'accuratezza)
rng = np.random.default_rng(0)
def img(c):
    a = rng.uniform(0.2,0.5)*np.ones((96,96)); yy,xx = np.mgrid[:96,:96]
    if c==0: a[((xx-48)**2+(yy-48)**2)<400]=0.9
    if c==1: a[(abs(xx-yy)<4)|(abs(xx+yy-95)<4)]=0.9
    if c==2: a[30:66,20:76]=0.85
    return (a+0.05*rng.standard_normal((96,96)))[...,None].astype("float32")
X = np.array([img(c) for c in range(4) for _ in range(40)]); y = np.repeat(np.arange(4),40)
m.compile(optimizer=keras.optimizers.Adam(1e-3), loss="sparse_categorical_crossentropy", metrics=["accuracy"])
m.fit(X, y, epochs=3, batch_size=1, verbose=0)
conv = tf.lite.TFLiteConverter.from_keras_model(m)
conv.optimizations=[tf.lite.Optimize.DEFAULT]
def rep():
    for i in range(0,160,2): yield [X[i:i+1]]
conv.representative_dataset=rep; conv.target_spec.supported_ops=[tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
conv.inference_input_type=tf.int8; conv.inference_output_type=tf.int8
tfl = conv.convert(); open("modelli/oggetti.tflite","wb").write(tfl); ns["to_header"](tfl,"oggetti_tflite","modelli/oggetti_modello.h")
fl = tf.lite.TFLiteConverter.from_keras_model(m).convert()
it = tf.lite.Interpreter(model_content=tfl); it.allocate_tensors()
ops = sorted(set(d["op_name"] for d in it._get_ops_details()))
print("oggetti: parametri", m.count_params(), "int8", len(tfl), "byte; float32", len(fl), "byte; op", ops)
