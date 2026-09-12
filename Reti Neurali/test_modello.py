"""Verifica che il modello salvato classifichi correttamente un piccolo insieme di foto note.
Uso: python test_modello.py   (si aspetta ../cap05_cnn/foto/test/<classe>/*.jpg)"""
import glob, json, sys, torch
from torch import nn
from torchvision import models
from PIL import Image

classi = json.load(open("gatti_cani.json"))["classi"]
modello = models.resnet18(weights=None)
modello.fc = nn.Linear(512, len(classi))
modello.load_state_dict(torch.load("gatti_cani.pt", weights_only=True))
modello.eval()
prep = models.ResNet18_Weights.DEFAULT.transforms()

corretti, totale = 0, 0
for k, classe in enumerate(classi):
    for percorso in sorted(glob.glob(f"../cap05_cnn/foto/test/{classe}/*.jpg"))[:10]:
        with torch.no_grad():
            pred = modello(prep(Image.open(percorso).convert("RGB")).unsqueeze(0)).argmax().item()
        corretti += (pred == k); totale += 1
print(f"{corretti}/{totale} corretti")
sys.exit(0 if corretti >= 0.9 * totale else 1)
