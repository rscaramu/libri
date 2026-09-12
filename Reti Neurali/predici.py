"""Uso: python predici.py foto1.jpg [foto2.jpg ...]"""
import sys, json, time, torch
from torch import nn
from torchvision import models
from PIL import Image

meta = json.load(open("gatti_cani.json"))
classi = meta["classi"]

modello = models.resnet18(weights=None)               # architettura, senza scaricare pesi
modello.fc = nn.Linear(512, len(classi))
modello.load_state_dict(torch.load("gatti_cani.pt", weights_only=True))
modello.eval()
prep = models.ResNet18_Weights.DEFAULT.transforms()

for percorso in sys.argv[1:]:
    img = prep(Image.open(percorso).convert("RGB")).unsqueeze(0)
    t0 = time.perf_counter()
    with torch.no_grad():
        prob = torch.softmax(modello(img), dim=1)[0]
    k = prob.argmax().item()
    print(f"{percorso}: {classi[k]} ({prob[k]:.1%}) — {1000*(time.perf_counter()-t0):.0f} ms")
