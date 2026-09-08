# listato-11-03.py — Conversione e quantizzazione int8. Le ultime quattro righe aprono il file appena creato e stampano scala e zero point del tensore d'ingresso: sono i due numeri che lo sketch del capitolo 12 dovrà usare.

def rappresentativi():
    for x in X_tr[:200]:
        yield [x.reshape(1, 384)]

conv = tf.lite.TFLiteConverter.from_keras_model(modello)
conv.optimizations = [tf.lite.Optimize.DEFAULT]
conv.representative_dataset = rappresentativi
conv.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
conv.inference_input_type = tf.int8
conv.inference_output_type = tf.int8
tflite = conv.convert()
open("gesti.tflite", "wb").write(tflite)
print(len(tflite), "byte")                          # circa 14.000

interp = tf.lite.Interpreter(model_content=tflite)
interp.allocate_tensors()
inp = interp.get_input_details()[0]
print(inp["quantization"])              # (scala, zero point)
