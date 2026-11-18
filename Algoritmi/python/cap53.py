# Algoritmi - Roberto Scaramuzzino
# Capitolo 53
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

import math
import random

def lunghezza(giro, d):
    n = len(giro)
    return sum(d[giro[i]][giro[(i + 1) % n]]
               for i in range(n))

def vicino_piu_vicino(d, partenza=0):
    n = len(d)
    giro, visti = [partenza], {partenza}
    while len(giro) < n:
        ultimo = giro[-1]
        liberi = (c for c in range(n) if c not in visti)
        prossimo = min(liberi, key=lambda c: d[ultimo][c])
        giro.append(prossimo)
        visti.add(prossimo)
    return giro

def due_opt(giro, d):
    n = len(giro)
    giro = giro[:]
    migliorato = True
    while migliorato:
        migliorato = False
        for i in range(n - 1):
            for j in range(i + 2, n):
                if i == 0 and j == n - 1:
                    continue           # stessi due archi
                a, b = giro[i], giro[i + 1]
                c, e = giro[j], giro[(j + 1) % n]
                delta = d[a][c] + d[b][e] - d[a][b] - d[c][e]
                if delta < -1e-12:
                    tratto = giro[i + 1:j + 1]
                    giro[i + 1:j + 1] = reversed(tratto)
                    migliorato = True
    return giro

def ricottura(giro, d, t, raffreddamento, passi):
    n = len(giro)
    giro = giro[:]
    costo = lunghezza(giro, d)
    migliore, costo_migliore = giro[:], costo
    for _ in range(passi):
        i, j = sorted(random.sample(range(n), 2))
        if j - i < 2 or (i == 0 and j == n - 1):
            continue
        a, b = giro[i], giro[i + 1]
        c, e = giro[j], giro[(j + 1) % n]
        delta = d[a][c] + d[b][e] - d[a][b] - d[c][e]
        accetta = delta < 0
        if not accetta:
            accetta = random.random() < math.exp(-delta / t)
        if accetta:
            giro[i + 1:j + 1] = reversed(giro[i + 1:j + 1])
            costo += delta
            if costo < costo_migliore:
                migliore, costo_migliore = giro[:], costo
        t *= raffreddamento
    return migliore

def albero_minimo(d):
    n = len(d)
    dentro = [False] * n
    minimo = [math.inf] * n
    minimo[0], totale = 0.0, 0.0
    for _ in range(n):
        u = min((v for v in range(n) if not dentro[v]),
                key=lambda v: minimo[v])
        dentro[u] = True
        totale += minimo[u]
        for v in range(n):
            if not dentro[v] and d[u][v] < minimo[v]:
                minimo[v] = d[u][v]
    return totale

random.seed(38)
punti = [(random.random(), random.random())
         for _ in range(80)]
d = [[math.dist(p, q) for q in punti] for p in punti]
casuale = list(range(80))
random.shuffle(casuale)
costruito = vicino_piu_vicino(d)
locale = due_opt(costruito, d)
ricotto = ricottura(costruito, d, 0.1, 0.99995, 200000)
ricotto = due_opt(ricotto, d)
ripartenze = min((due_opt(random.sample(range(80), 80), d)
                  for _ in range(5)),
                 key=lambda g: lunghezza(g, d))
for nome, g in (('casuale', casuale), ('vicino', costruito),
                ('2-opt', locale), ('ripartenze', ripartenze),
                ('ricottura', ricotto)):
    assert sorted(g) == list(range(80))
    print(f'{nome:<11} {lunghezza(g, d):.3f}')
print(f'{"albero":<11} {albero_minimo(d):.3f}')


def genetico(n_bit, idoneita, individui=40, generazioni=60):
    def casuale():
        return [random.randint(0, 1) for _ in range(n_bit)]

    popolazione = [casuale() for _ in range(individui)]

    def torneo():
        sfidanti = random.sample(popolazione, 3)
        return max(sfidanti, key=idoneita)

    for _ in range(generazioni):
        popolazione.sort(key=idoneita, reverse=True)
        nuova = popolazione[:2]                  # elitismo
        while len(nuova) < individui:
            p1, p2 = torneo(), torneo()
            taglio = random.randint(1, n_bit - 1)
            figlio = p1[:taglio] + p2[taglio:]
            for i in range(n_bit):
                if random.random() < 1 / n_bit:
                    figlio[i] ^= 1
            nuova.append(figlio)
        popolazione = nuova
    return max(popolazione, key=idoneita)

# zaino: i bit dicono quali oggetti prendere
random.seed(39)
pesi = [random.randint(5, 40) for _ in range(30)]
valori = [random.randint(10, 90) for _ in range(30)]
capacita = 250

def idoneita(bit):
    peso = sum(p for p, b in zip(pesi, bit) if b)
    valore = sum(v for v, b in zip(valori, bit) if b)
    return valore if peso <= capacita else 0

def zaino_esatto():
    v = [0] * (capacita + 1)
    for p, val in zip(pesi, valori):
        for c in range(capacita, p - 1, -1):
            v[c] = max(v[c], val + v[c - p])
    return v[capacita]

print(idoneita(genetico(30, idoneita)), zaino_esatto())
