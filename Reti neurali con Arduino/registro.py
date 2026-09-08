# strumenti/registro.py — capitolo 20: legge dalla seriale il registro degli eventi (CSV: t,classe,conf,384 valori int8)
# e ricostruisce le finestre in g con scala e zero point del modello, salvandole per l'etichettatura.
import sys, csv, numpy as np, serial
porta, scala, zp = sys.argv[1], float(sys.argv[2]), int(sys.argv[3])     # es. /dev/ttyACM0 0.00784 -1
ser = serial.Serial(porta, 115200, timeout=5)
ser.write(b"R\n")                                                         # lo sketch stampa il registro a richiesta
righe = []
while True:
    r = ser.readline().decode(errors="ignore").strip()
    if not r or r == "FINE": break
    righe.append(r.split(","))
with open("registro.csv", "w", newline="") as fh:
    w = csv.writer(fh)
    for r in righe:
        t, classe, conf = r[:3]; q = np.array(r[3:], dtype=int)
        x = (q - zp) * scala * 4.0                                        # dequantizza e toglie la normalizzazione /4
        w.writerow([t, classe, conf] + [f"{v:.4f}" for v in x])
print(len(righe), "finestre salvate in registro.csv")
