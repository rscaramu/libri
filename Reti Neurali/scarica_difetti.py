
"""Scarica sei classi di difetti superficiali dell'acciaio dal dataset SteelDefectX (Hugging Face, CC-BY 4.0)
in difetti/{train,val,test}/<classe>/ : 150/30/60 immagini per classe."""
import urllib.request, json, os, random, io, concurrent.futures as cf
from PIL import Image
BASE = "https://huggingface.co/datasets/Zhaosxian/SteelDefectX/resolve/main/"
SCELTE = {"cracking": "crazing", "in": "inclusione", "pa": "macchie", "ps": "vaiolatura", "rs": "scaglia_laminata", "bs": "graffio_chiaro"}
QUOTE = (150, 30, 60)
m = json.loads(urllib.request.urlopen("https://huggingface.co/api/datasets/Zhaosxian/SteelDefectX", timeout=60).read())
nomi = [s["rfilename"] for s in m["siblings"] if s["rfilename"].endswith(".jpg")]
random.seed(42); lista = []
for pref, cl in SCELTE.items():
    f = [n for n in nomi if n.split("/")[1].split("_")[0] == pref]; random.shuffle(f)
    for k, n in enumerate(f[:sum(QUOTE)]):
        sub = "train" if k < QUOTE[0] else ("val" if k < QUOTE[0] + QUOTE[1] else "test")
        lista.append((n, f"difetti/{sub}/{cl}/{os.path.basename(n)}"))
def scarica(a):
    n, dst = a
    if os.path.exists(dst): return 1
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    d = urllib.request.urlopen(BASE + n, timeout=60).read(); Image.open(io.BytesIO(d)).convert("RGB").save(dst, quality=92); return 1
with cf.ThreadPoolExecutor(16) as ex: print("scaricate", sum(ex.map(scarica, lista)), "immagini")
