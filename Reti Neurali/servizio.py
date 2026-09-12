"""Servizio REST: python servizio.py  →  http://127.0.0.1:8000/docs"""
import io, json, torch
from fastapi import FastAPI, File, UploadFile
from torch import nn
from torchvision import models
from PIL import Image

app = FastAPI(title="Gatto o cane")
classi = json.load(open("gatti_cani.json"))["classi"]
modello = models.resnet18(weights=None); modello.fc = nn.Linear(512, len(classi))
modello.load_state_dict(torch.load("gatti_cani.pt", weights_only=True)); modello.eval()
prep = models.ResNet18_Weights.DEFAULT.transforms()

@app.post("/classifica")
async def classifica(file: UploadFile = File(...)):
    img = Image.open(io.BytesIO(await file.read())).convert("RGB")
    with torch.no_grad():
        prob = torch.softmax(modello(prep(img).unsqueeze(0)), dim=1)[0]
    return {"classe": classi[prob.argmax().item()], "probabilita": {c: round(p.item(), 4) for c, p in zip(classi, prob)}}

@app.get("/salute")
def salute():
    return {"stato": "ok", "modello": "resnet18", "classi": classi}

if __name__ == "__main__":
    import uvicorn; uvicorn.run(app, host="127.0.0.1", port=8000)
