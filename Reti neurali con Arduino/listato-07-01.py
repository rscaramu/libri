# listato-07-01.py — Conversione e quantizzazione int8 completa di un modello Keras. Le ultime tre impostazioni obbligano tutte le op a int8, ingresso e uscita compresi; se una op non lo supporta, la conversione fallisce qui e non sulla scheda.

import tensorflow as tf

def rappresentativi():
    for x in X_train[:200]:        # 200 esempi reali bastano
        yield [x.reshape(1, -1).astype("float32")]

conv = tf.lite.TFLiteConverter.from_keras_model(modello)
conv.optimizations = [tf.lite.Optimize.DEFAULT]
conv.representative_dataset = rappresentativi
conv.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
conv.inference_input_type  = tf.int8
conv.inference_output_type = tf.int8
open("modello.tflite", "wb").write(conv.convert())
