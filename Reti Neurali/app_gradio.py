"""Interfaccia web minima: python app_gradio.py, poi aprire il link stampato."""
import json, torch
import gradio as gr
from torch import nn
from torchvision import models

classi = json.load(open("gatti_cani.json"))["classi"]
modello = models.resnet18(weights=None)
modello.fc = nn.Linear(512, len(classi))
modello.load_state_dict(torch.load("gatti_cani.pt", weights_only=True))
modello.eval()
prep = models.ResNet18_Weights.DEFAULT.transforms()

def classifica(immagine):
    x = prep(immagine.convert("RGB")).unsqueeze(0)
    with torch.no_grad():
        prob = torch.softmax(modello(x), dim=1)[0]
    return {c: float(p) for c, p in zip(classi, prob)}

gr.Interface(fn=classifica, inputs=gr.Image(type="pil"), outputs=gr.Label(num_top_classes=2),
             title="Gatto o cane?").launch()
