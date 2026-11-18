# Algoritmi - Roberto Scaramuzzino
# Capitolo 23
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def zaino(pesi, valori, capacita):
    n = len(pesi)
    v = [[0] * (capacita + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        p, val = pesi[i - 1], valori[i - 1]
        for c in range(capacita + 1):
            v[i][c] = v[i - 1][c]
            if p <= c and val + v[i - 1][c - p] > v[i][c]:
                v[i][c] = val + v[i - 1][c - p]
    scelti, c = [], capacita
    for i in range(n, 0, -1):
        if v[i][c] != v[i - 1][c]:
            scelti.append(i - 1)
            c -= pesi[i - 1]
    return v[n][capacita], scelti[::-1]

def zaino_compatto(pesi, valori, capacita):
    v = [0] * (capacita + 1)
    for p, val in zip(pesi, valori):
        for c in range(capacita, p - 1, -1):
            v[c] = max(v[c], val + v[c - p])
    return v[capacita]

def zaino_illimitato(pesi, valori, capacita):
    v = [0] * (capacita + 1)
    for p, val in zip(pesi, valori):
        for c in range(p, capacita + 1):
            v[c] = max(v[c], val + v[c - p])
    return v[capacita]

pesi, valori = [10, 20, 30], [60, 100, 120]
print(zaino(pesi, valori, 50))
print(zaino_compatto(pesi, valori, 50))
print(zaino_illimitato(pesi, valori, 50))
print(zaino([1, 3, 4, 5], [1, 4, 5, 7], 7))


def somme_raggiungibili(numeri):
    s = sum(numeri)
    p = [True] + [False] * s
    for x in numeri:
        for c in range(s, x - 1, -1):
            if p[c - x]:
                p[c] = True
    return p

def partizione_bilanciata(numeri):
    p = somme_raggiungibili(numeri)
    totale = sum(numeri)
    meta = max(c for c in range(totale // 2 + 1) if p[c])
    return meta, totale - meta

numeri = [3, 34, 4, 12, 5, 2]
p = somme_raggiungibili(numeri)
print(p[9], p[30], p[13])
print(partizione_bilanciata([8, 7, 6, 5, 4]))
print(partizione_bilanciata([10, 1, 1, 1]))


from bisect import bisect_left

def scp_quadratica(a):
    if not a:
        return []
    n = len(a)
    lung = [1] * n
    prec = [-1] * n
    for i in range(n):
        for j in range(i):
            if a[j] < a[i] and lung[j] + 1 > lung[i]:
                lung[i] = lung[j] + 1
                prec[i] = j
    i = max(range(n), key=lambda k: lung[k])
    risultato = []
    while i != -1:
        risultato.append(a[i])
        i = prec[i]
    return risultato[::-1]

def lunghezza_scp(a):
    code = []
    for x in a:
        k = bisect_left(code, x)
        if k == len(code):
            code.append(x)
        else:
            code[k] = x
    return len(code)

dati = [10, 9, 2, 5, 3, 7, 101, 18, 4]
print(scp_quadratica(dati), lunghezza_scp(dati))
print(lunghezza_scp([5, 5, 5]), lunghezza_scp([]))

import random
random.seed(13)
for _ in range(500):
    n = random.randint(0, 12)
    a = [random.randint(0, 9) for _ in range(n)]
    assert len(scp_quadratica(a)) == lunghezza_scp(a)
print('500 prove superate')


def catena_di_matrici(d):
    n = len(d) - 1
    m = [[0] * n for _ in range(n)]
    taglio = [[0] * n for _ in range(n)]
    for lunghezza in range(2, n + 1):
        for i in range(n - lunghezza + 1):
            j = i + lunghezza - 1
            m[i][j] = float('inf')
            for k in range(i, j):
                costo = (m[i][k] + m[k + 1][j]
                         + d[i] * d[k + 1] * d[j + 1])
                if costo < m[i][j]:
                    m[i][j] = costo
                    taglio[i][j] = k

    def parentesi(i, j):
        if i == j:
            return f'A{i + 1}'
        k = taglio[i][j]
        return f'({parentesi(i, k)} {parentesi(k + 1, j)})'

    return m[0][n - 1], parentesi(0, n - 1)

print(catena_di_matrici([10, 100, 5, 50]))
print(catena_di_matrici([30, 35, 15, 5, 10, 20, 25]))


from itertools import permutations

def commesso(dist):
    n = len(dist)
    inf = float('inf')
    tutti = 1 << n
    d = [[inf] * n for _ in range(tutti)]
    d[1][0] = 0                   # solo la citta' 0
    for s in range(1, tutti):
        if not s & 1:
            continue              # la citta' 0 c'e' sempre
        for j in range(n):
            if not s & (1 << j) or d[s][j] == inf:
                continue
            for k in range(n):
                if s & (1 << k):
                    continue
                t = s | (1 << k)
                costo = d[s][j] + dist[j][k]
                if costo < d[t][k]:
                    d[t][k] = costo
    finale = tutti - 1
    return min(d[finale][j] + dist[j][0] for j in range(1, n))

def commesso_ingenuo(dist):
    n = len(dist)
    migliore = float('inf')
    for giro in permutations(range(1, n)):
        percorso = (0,) + giro + (0,)
        lunghezza = sum(dist[percorso[i]][percorso[i + 1]]
                        for i in range(n))
        migliore = min(migliore, lunghezza)
    return migliore

dist = [[0, 10, 15, 20],
        [10, 0, 35, 25],
        [15, 35, 0, 30],
        [20, 25, 30, 0]]
print(commesso(dist), commesso_ingenuo(dist))

import random
random.seed(14)
n = 8
citta = [[0] * n for _ in range(n)]
for i in range(n):
    for j in range(i + 1, n):
        citta[i][j] = citta[j][i] = random.randint(1, 99)
print(commesso(citta), commesso_ingenuo(citta))
