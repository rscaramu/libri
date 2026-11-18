# Algoritmi - Roberto Scaramuzzino
# Capitolo 54
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

import math
import random

class Statistiche:
    def __init__(self):
        self.n, self.media, self.scarti = 0, 0.0, 0.0

    def aggiorna(self, x):
        self.n += 1
        delta = x - self.media
        self.media += delta / self.n
        self.scarti += delta * (x - self.media)

    def varianza(self):
        return self.scarti / self.n

random.seed(40)
dati = [random.gauss(1e9, 2.0) for _ in range(100000)]
s = Statistiche()
for x in dati:
    s.aggiorna(x)
media = math.fsum(dati) / len(dati)
vera = math.fsum((x - media) ** 2 for x in dati) / len(dati)
ingenua = (math.fsum(x * x for x in dati) / len(dati)
           - media * media)
print(round(s.varianza(), 4), round(vera, 4))
print(round(ingenua, 4))

mobile, alfa = 0.0, 0.1
for t in range(200):
    segnale = 10.0 if t >= 100 else 0.0
    mobile = alfa * segnale + (1 - alfa) * mobile
    if t in (99, 105, 120, 199):
        print(t, round(mobile, 3))


import hashlib
from collections import Counter

def misra_gries(flusso, k):
    c = {}
    for x in flusso:
        if x in c:
            c[x] += 1
        elif len(c) < k - 1:
            c[x] = 1
        else:
            for y in list(c):
                c[y] -= 1
                if c[y] == 0:
                    del c[y]
    return c

def impronta(x, seme):
    dati = f'{seme}:{x}'.encode()
    return int.from_bytes(hashlib.blake2b(dati, digest_size=8)
                          .digest(), 'big')

class CountMin:
    def __init__(self, colonne, righe):
        self.w, self.d = colonne, righe
        self.tabella = [[0] * colonne for _ in range(righe)]

    def aggiungi(self, x):
        for r in range(self.d):
            self.tabella[r][impronta(x, r) % self.w] += 1

    def stima(self, x):
        return min(self.tabella[r][impronta(x, r) % self.w]
                   for r in range(self.d))

random.seed(41)
parole = [f'p{i}' for i in range(5000)]
pesi = [1 / (i + 1) for i in range(5000)]
flusso = random.choices(parole, pesi, k=50000)
veri = Counter(flusso)
print(veri.most_common(4))
candidati = misra_gries(flusso, 20)
print(sorted(candidati.items(), key=lambda p: -p[1])[:4])
print(len(candidati), len(veri))

cm = CountMin(1000, 4)
for x in flusso:
    cm.aggiungi(x)
for x in ('p0', 'p3', 'p400'):
    print(x, cm.stima(x), veri[x])


class HyperLogLog:
    def __init__(self, b=11):
        self.b, self.m = b, 1 << b
        self.registri = [0] * self.m

    def aggiungi(self, x):
        h = impronta(x, 'hll')
        j = h >> (64 - self.b)
        resto = h & ((1 << (64 - self.b)) - 1)
        zeri = (64 - self.b) - resto.bit_length()
        self.registri[j] = max(self.registri[j], zeri + 1)

    def stima(self):
        m = self.m
        alfa = 0.7213 / (1 + 1.079 / m)
        somma = sum(2.0 ** -r for r in self.registri)
        e = alfa * m * m / somma
        vuoti = self.registri.count(0)
        if e <= 2.5 * m and vuoti:
            e = m * math.log(m / vuoti)      # insiemi piccoli
        return round(e)

    def fondi(self, altro):
        self.registri = [max(a, b) for a, b in
                         zip(self.registri, altro.registri)]

for n in (100, 10000, 300000):
    h = HyperLogLog()
    for i in range(n):
        h.aggiungi(f'utente-{i}')
        if i % 3 == 0:
            h.aggiungi(f'utente-{i}')          # ripetizioni
    stima = h.stima()
    print(n, stima, f'{abs(stima - n) / n:.1%}')

lunedi, martedi = HyperLogLog(), HyperLogLog()
for i in range(20000):
    lunedi.aggiungi(f'utente-{i}')
for i in range(15000, 40000):
    martedi.aggiungi(f'utente-{i}')
lunedi.fondi(martedi)
print(lunedi.stima(), len(lunedi.registri))
