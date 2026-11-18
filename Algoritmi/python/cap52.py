# Algoritmi - Roberto Scaramuzzino
# Capitolo 52
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

from itertools import combinations

def copertura_approssimata(archi):
    c = set()
    for u, v in archi:
        if u not in c and v not in c:
            c.update((u, v))
    return c

def copertura_golosa(n, archi):
    restanti, c = set(archi), set()
    while restanti:
        grado = [0] * n
        for u, v in restanti:
            grado[u] += 1
            grado[v] += 1
        scelto = grado.index(max(grado))
        c.add(scelto)
        restanti = {a for a in restanti if scelto not in a}
    return c

def copertura_ottima(n, archi):
    for k in range(n + 1):
        for s in combinations(range(n), k):
            c = set(s)
            if all(u in c or v in c for u, v in archi):
                return c

import random
random.seed(34)
peggiore = 0.0
for _ in range(300):
    n = random.randint(4, 11)
    archi = list({tuple(sorted(random.sample(range(n), 2)))
                  for _ in range(random.randint(3, 16))})
    ottimo = len(copertura_ottima(n, archi))
    appr = copertura_approssimata(archi)
    assert all(u in appr or v in appr for u, v in archi)
    peggiore = max(peggiore, len(appr) / ottimo)
print(peggiore)

stella = [(0, i) for i in range(1, 8)]
print(len(copertura_approssimata(stella)),
      len(copertura_golosa(8, stella)),
      len(copertura_ottima(8, stella)))


def zaino_approssimato(pesi, valori, capacita):
    ordine = sorted(range(len(pesi)),
                    key=lambda i: valori[i] / pesi[i],
                    reverse=True)
    totale, resto = 0, capacita
    for i in ordine:
        if pesi[i] <= resto:
            totale += valori[i]
            resto -= pesi[i]
    singolo = max((valori[i] for i in range(len(pesi))
                   if pesi[i] <= capacita), default=0)
    return max(totale, singolo), totale

def zaino_esatto(pesi, valori, capacita):
    v = [0] * (capacita + 1)
    for p, val in zip(pesi, valori):
        for c in range(capacita, p - 1, -1):
            v[c] = max(v[c], val + v[c - p])
    return v[capacita]

print(zaino_approssimato([1, 100], [2, 100], 100),
      zaino_esatto([1, 100], [2, 100], 100))

random.seed(35)
peggiore = 1.0
for _ in range(2000):
    n = random.randint(1, 8)
    pesi = [random.randint(1, 30) for _ in range(n)]
    valori = [random.randint(1, 60) for _ in range(n)]
    ottimo = zaino_esatto(pesi, valori, 50)
    if ottimo:
        appr = zaino_approssimato(pesi, valori, 50)[0]
        peggiore = min(peggiore, appr / ottimo)
print(round(peggiore, 3))


import math
from itertools import permutations

def giro_approssimato(punti):
    n = len(punti)
    d = [[math.dist(p, q) for q in punti] for p in punti]
    # Prim su matrice
    nell_albero = [False] * n
    minimo = [math.inf] * n
    genitore = [None] * n
    minimo[0] = 0.0
    figli = [[] for _ in range(n)]
    peso_albero = 0.0
    for _ in range(n):
        u = min((v for v in range(n) if not nell_albero[v]),
                key=lambda v: minimo[v])
        nell_albero[u] = True
        peso_albero += minimo[u]
        if genitore[u] is not None:
            figli[genitore[u]].append(u)
        for v in range(n):
            if not nell_albero[v] and d[u][v] < minimo[v]:
                minimo[v], genitore[v] = d[u][v], u
    # visita anticipata dell'albero
    giro, pila = [], [0]
    while pila:
        u = pila.pop()
        giro.append(u)
        pila.extend(reversed(figli[u]))
    lunghezza = sum(d[giro[i]][giro[(i + 1) % n]]
                    for i in range(n))
    return giro, lunghezza, peso_albero

def giro_ottimo(punti):
    n = len(punti)
    migliore = math.inf
    for p in permutations(range(1, n)):
        giro = (0,) + p
        lunghezza = sum(math.dist(punti[giro[i]],
                                  punti[giro[(i + 1) % n]])
                        for i in range(n))
        migliore = min(migliore, lunghezza)
    return migliore

random.seed(36)
peggiore = 0.0
for _ in range(40):
    punti = [(random.random(), random.random())
             for _ in range(8)]
    giro, lunghezza, albero = giro_approssimato(punti)
    ottimo = giro_ottimo(punti)
    assert albero <= ottimo <= lunghezza <= 2 * albero + 1e-9
    peggiore = max(peggiore, lunghezza / ottimo)
print(round(peggiore, 3))


def impacchetta(oggetti, capacita):
    spazi = []
    for x in sorted(oggetti, reverse=True):
        for i, s in enumerate(spazi):
            if s >= x:
                spazi[i] -= x
                break
        else:
            spazi.append(capacita - x)
    return len(spazi)

def in_arrivo(oggetti, capacita):
    spazi = []
    for x in oggetti:
        for i, s in enumerate(spazi):
            if s >= x:
                spazi[i] -= x
                break
        else:
            spazi.append(capacita - x)
    return len(spazi)

random.seed(37)
oggetti = [random.randint(10, 60) for _ in range(200)]
limite = math.ceil(sum(oggetti) / 100)
print(limite, impacchetta(oggetti, 100),
      in_arrivo(oggetti, 100))
