# Algoritmi - Roberto Scaramuzzino
# Capitolo 22
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

from functools import lru_cache

def modi_memo(n, tabella=None):
    if tabella is None:
        tabella = {}
    if n <= 1:
        return 1
    if n not in tabella:
        tabella[n] = (modi_memo(n - 1, tabella)
                      + modi_memo(n - 2, tabella))
    return tabella[n]

@lru_cache(maxsize=None)
def modi_cache(n):
    if n <= 1:
        return 1
    return modi_cache(n - 1) + modi_cache(n - 2)

def modi_tabella(n):
    if n <= 1:
        return 1
    t = [1] * (n + 1)
    for i in range(2, n + 1):
        t[i] = t[i - 1] + t[i - 2]
    return t[n]

def modi_due_variabili(n):
    a, b = 1, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b

print([modi_tabella(n) for n in range(8)])
print(modi_memo(80), modi_cache(80))
print(modi_tabella(80), modi_due_variabili(80))


def resto_minimo(importo, tagli):
    inf = float('inf')
    m = [0] + [inf] * importo
    ultima = [None] * (importo + 1)
    for v in range(1, importo + 1):
        for t in tagli:
            if t <= v and m[v - t] + 1 < m[v]:
                m[v] = m[v - t] + 1
                ultima[v] = t
    if m[importo] == inf:
        return None
    monete, v = [], importo
    while v > 0:
        monete.append(ultima[v])
        v -= ultima[v]
    return monete

print(resto_minimo(6, [1, 3, 4]))
print(resto_minimo(68, [1, 2, 5, 10, 20, 50]))
print(resto_minimo(6, [5, 2]), resto_minimo(3, [5, 2]))


def cammino_minimo(griglia):
    righe, colonne = len(griglia), len(griglia[0])
    c = [[0] * colonne for _ in range(righe)]
    for r in range(righe):
        for k in range(colonne):
            if r == 0 and k == 0:
                prima = 0
            elif r == 0:
                prima = c[r][k - 1]
            elif k == 0:
                prima = c[r - 1][k]
            else:
                prima = min(c[r - 1][k], c[r][k - 1])
            c[r][k] = griglia[r][k] + prima
    # ricostruzione a ritroso
    r, k = righe - 1, colonne - 1
    cammino = [(r, k)]
    while (r, k) != (0, 0):
        if r == 0:
            k -= 1
        elif k == 0:
            r -= 1
        elif c[r - 1][k] <= c[r][k - 1]:
            r -= 1
        else:
            k -= 1
        cammino.append((r, k))
    return c[-1][-1], cammino[::-1]

griglia = [[1, 3, 1, 2],
           [1, 5, 1, 9],
           [4, 2, 1, 1]]
costo, cammino = cammino_minimo(griglia)
print(costo)
print(cammino)


def taglio_asta(prezzo, n):
    # prezzo[i]: prezzo di un pezzo lungo i; prezzo[0] = 0
    r = [0] * (n + 1)
    primo = [0] * (n + 1)
    for k in range(1, n + 1):
        for i in range(1, min(k, len(prezzo) - 1) + 1):
            if prezzo[i] + r[k - i] > r[k]:
                r[k] = prezzo[i] + r[k - i]
                primo[k] = i
    pezzi, k = [], n
    while k > 0:
        pezzi.append(primo[k])
        k -= primo[k]
    return r[n], pezzi

prezzo = [0, 1, 5, 8, 9, 10, 17, 17, 20]
for n in (4, 7, 8):
    print(n, taglio_asta(prezzo, n))
