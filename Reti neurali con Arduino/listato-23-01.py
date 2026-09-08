# listato-23-01.py — Il lato Python del rilevatore di cadute in App Lab. Il modello gira su Linux dal file .eim; lo sketch manda le finestre e riceve l'allarme dal Bridge. I nomi delle API del Bridge sono quelli della documentazione di App Lab al momento della stesura e vanno verificati.

from edge_impulse_linux.runner import ImpulseRunner
from arduino.app_bricks import bridge

runner = ImpulseRunner("cadute.eim"); info = runner.init()
classi = info["model_parameters"]["labels"]

def su_finestra(valori):                 # 1200 float dal Bridge
    r = runner.classify(valori)["result"]["classification"]
    classe = max(r, key=r.get)
    if classe == "caduta" and r[classe] > 0.8:
        bridge.send("ALLARME")
        notifica("Caduta rilevata")
bridge.on("FINESTRA", su_finestra)
