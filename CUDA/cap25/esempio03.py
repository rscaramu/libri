import csv

with open("kern_cuda_gpu_kern_sum.csv") as f:
    righe = list(csv.DictReader(f))
cum = 0.0
for r in righe[:3]:
    cum += float(r["Time (%)"])
    nome = r["Name"][:40]
    print(f"{r['Time (%)']:>6}%  cum {cum:5.1f}%  {nome}")
