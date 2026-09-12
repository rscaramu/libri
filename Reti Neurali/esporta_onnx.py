"""Esporta gatti_cani.pt in ONNX e verifica che i logit coincidano con PyTorch."""
import json, os, time
import numpy as np
import torch
from torch import nn
from torchvision import models
from PIL import Image

classi = json.load(open("gatti_cani.json"))["classi"]
modello = models.resnet18(weights=None)
modello.fc = nn.Linear(512, len(classi))
modello.load_state_dict(torch.load("gatti_cani.pt", weights_only=True))
modello.eval()

esempio = torch.zeros(1, 3, 224, 224)
torch.onnx.export(modello, esempio, "gatti_cani.onnx",
                  input_names=["immagine"], output_names=["logit"],
                  dynamo=False,
                  dynamic_axes={"immagine": {0: "batch"}, "logit": {0: "batch"}})
print("gatti_cani.onnx:", round(os.path.getsize("gatti_cani.onnx") / 1e6, 1), "MB")


def prep_numpy(percorso):
    """Riproduce ResNet18_Weights.DEFAULT.transforms() con PIL e NumPy."""
    im = Image.open(percorso).convert("RGB")
    w, h = im.size
    s = 256 / min(w, h)
    im = im.resize((round(w * s), round(h * s)), Image.BILINEAR)
    w, h = im.size
    l, t = (w - 224) // 2, (h - 224) // 2
    im = im.crop((l, t, l + 224, t + 224))
    x = np.asarray(im, dtype=np.float32) / 255
    x = (x - [0.485, 0.456, 0.406]) / [0.229, 0.224, 0.225]
    return x.transpose(2, 0, 1)[None].astype(np.float32)      # [1, 3, 224, 224]


import onnxruntime as ort
sessione = ort.InferenceSession("gatti_cani.onnx")
x = np.random.randn(2, 3, 224, 224).astype(np.float32)
logit_onnx = sessione.run(None, {"immagine": x})[0]
with torch.no_grad():
    logit_torch = modello(torch.from_numpy(x)).numpy()
print("Differenza massima ONNX/PyTorch:", np.abs(logit_onnx - logit_torch).max())

x = np.random.randn(1, 3, 224, 224).astype(np.float32)
for nome, f in (("onnxruntime", lambda: sessione.run(None, {"immagine": x})),
                ("pytorch", lambda: modello(torch.from_numpy(x)))):
    with torch.no_grad():
        f(); t0 = time.perf_counter()
        for _ in range(5): f()
    print(f"{nome}: {1000*(time.perf_counter()-t0)/5:.0f} ms per immagine")
