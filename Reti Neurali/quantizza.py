
"""Quantizza gatti_cani.onnx a int8 (dinamica e statica) e misura dimensione, accuratezza e latenza.
Uso: python quantizza.py   (dopo esporta_onnx.py; servono le foto in ../cap05_cnn/foto/test)"""
import os, glob, json, time, numpy as np, torch
from torch import nn
from torchvision import models
from PIL import Image
import onnxruntime as ort
from onnxruntime.quantization import quantize_dynamic, quantize_static, QuantType, QuantFormat, CalibrationDataReader
from onnxruntime.quantization.shape_inference import quant_pre_process

classi = json.load(open("gatti_cani.json"))["classi"]; prep = models.ResNet18_Weights.DEFAULT.transforms()
foto = sorted(glob.glob("../cap05_cnn/foto/test/gatto/*.jpg"))[:40] + sorted(glob.glob("../cap05_cnn/foto/test/cane/*.jpg"))[:40]
y = np.array([classi.index("gatto")] * 40 + [classi.index("cane")] * 40)
X = torch.stack([prep(Image.open(f).convert("RGB")) for f in foto]).numpy()

quantize_dynamic("gatti_cani.onnx", "gatti_cani_int8_dinamica.onnx", weight_type=QuantType.QInt8)
class Lettore(CalibrationDataReader):
    def __init__(self): self.it = iter([{"immagine": X[i:i + 1]} for i in range(0, 80, 4)])
    def get_next(self): return next(self.it, None)
quant_pre_process("gatti_cani.onnx", "gatti_cani_pre.onnx")
quantize_static("gatti_cani_pre.onnx", "gatti_cani_int8.onnx", Lettore(), quant_format=QuantFormat.QDQ, weight_type=QuantType.QInt8, activation_type=QuantType.QUInt8, per_channel=True)

for nome, f in (("float32", "gatti_cani.onnx"), ("int8 dinamica", "gatti_cani_int8_dinamica.onnx"), ("int8 statica", "gatti_cani_int8.onnx")):
    s = ort.InferenceSession(f, providers=["CPUExecutionProvider"])
    pred = np.concatenate([s.run(None, {"immagine": X[i:i + 8]})[0].argmax(1) for i in range(0, 80, 8)])
    lat = {}
    for b in (1, 8, 32):
        xb = X[:b]; s.run(None, {"immagine": xb}); t = time.perf_counter()
        for _ in range(3): s.run(None, {"immagine": xb})
        lat[b] = (time.perf_counter() - t) / 3 * 1000
    print(f"{nome:14s} {os.path.getsize(f)/1e6:5.1f} MB  accuratezza {(pred == y).mean():.1%}  latenza batch 1/8/32: {lat[1]:.0f} / {lat[8]:.0f} / {lat[32]:.0f} ms")
