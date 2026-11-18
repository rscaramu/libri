# Algoritmi - Roberto Scaramuzzino
# Capitolo 19
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def limite_inferiore(a, x):
    basso, alto = 0, len(a)
    while basso < alto:
        medio = basso + (alto - basso) // 2
        if a[medio] < x:
            basso = medio + 1
        else:
            alto = medio
    return basso

def limite_superiore(a, x):
    basso, alto = 0, len(a)
    while basso < alto:
        medio = basso + (alto - basso) // 2
        if a[medio] <= x:
            basso = medio + 1
        else:
            alto = medio
    return basso

dati = [2, 4, 4, 4, 7, 9, 9, 12]
for x in (4, 5, 1, 20):
    inf = limite_inferiore(dati, x)
    sup = limite_superiore(dati, x)
    print(x, inf, sup, sup - inf)
tra = limite_superiore(dati, 9) - limite_inferiore(dati, 4)
print(tra)


def primo_vero(basso, alto, p):
    while basso < alto:
        medio = basso + (alto - basso) // 2
        if p(medio):
            alto = medio
        else:
            basso = medio + 1
    return basso

def radice_intera(n):
    return primo_vero(0, n + 2, lambda r: r * r > n) - 1

def giorni_necessari(pesi, capacita):
    giorni, carico = 1, 0
    for p in pesi:
        if carico + p > capacita:
            giorni += 1
            carico = 0
        carico += p
    return giorni

def capacita_minima(pesi, g):
    return primo_vero(
        max(pesi), sum(pesi) + 1,
        lambda c: giorni_necessari(pesi, c) <= g)

prove = (0, 1, 15, 16, 17, 10 ** 20)
print([radice_intera(n) for n in prove])
pesi = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
for g in (1, 2, 5, 10):
    c = capacita_minima(pesi, g)
    print(g, c, giorni_necessari(pesi, c))


import random

def selezione_rapida(a, k):
    a = a[:]                     # non modifica l'originale
    basso, alto = 0, len(a) - 1
    while True:
        if basso == alto:
            return a[basso]
        r = random.randint(basso, alto)
        a[r], a[alto] = a[alto], a[r]
        perno, p = a[alto], basso
        for j in range(basso, alto):
            if a[j] < perno:
                a[p], a[j] = a[j], a[p]
                p += 1
        a[p], a[alto] = a[alto], a[p]
        if k == p:
            return a[p]
        if k < p:
            alto = p - 1
        else:
            basso = p + 1

random.seed(6)
dati = [31, 8, 45, 12, 27, 3, 19, 40, 8]
print(sorted(dati))
print([selezione_rapida(dati, k) for k in (0, 4, 8)])

for _ in range(1000):
    n = random.randint(1, 30)
    a = [random.randint(0, 20) for _ in range(n)]
    k = random.randrange(n)
    assert selezione_rapida(a, k) == sorted(a)[k]
print('1000 prove superate')
