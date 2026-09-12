"""Costruisce foto/{train,val,test}/{gatto,cane} dal dataset pubblico Cats vs Dogs
(mirror Hugging Face, formato Parquet). 500/100/200 immagini per classe.
Sostituire le foto con le proprie: basta rispettare la struttura delle cartelle."""
import io, os, urllib.request
import pandas as pd
from PIL import Image

BASE = "https://huggingface.co/api/datasets/microsoft/cats_vs_dogs/parquet/default/train/"
NOMI = {0: "gatto", 1: "cane"}
QUOTE = (500, 100, 200)          # train, val, test

def sotto(k):
    if k < QUOTE[0]: return "train"
    if k < QUOTE[0] + QUOTE[1]: return "val"
    return "test"

for shard, classe in ((0, 0), (1, 1)):        # shard 0 contiene i gatti, shard 1 i cani
    print(f"scarico shard {shard} ...")
    d = urllib.request.urlopen(BASE + f"{shard}.parquet", timeout=300).read()
    df = pd.read_parquet(io.BytesIO(d))
    df = df[df["labels"] == classe].sample(frac=1, random_state=42)
    k = 0
    for _, riga in df.iterrows():
        if k >= sum(QUOTE): break
        try:
            im = Image.open(io.BytesIO(riga["image"]["bytes"])).convert("RGB")
        except Exception:
            continue
        cartella = f"foto/{sotto(k)}/{NOMI[classe]}"
        os.makedirs(cartella, exist_ok=True)
        im.save(f"{cartella}/{k:04d}.jpg", quality=90)
        k += 1
    print(f"  {NOMI[classe]}: {k} immagini")
