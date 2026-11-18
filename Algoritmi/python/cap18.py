# Algoritmi - Roberto Scaramuzzino
# Capitolo 18
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def ordina_per_conteggio(a, k, chiave=lambda x: x):
    conta = [0] * k
    for x in a:
        conta[chiave(x)] += 1
    totale = 0
    for c in range(k):
        conta[c], totale = totale, totale + conta[c]
    b = [None] * len(a)
    for x in a:
        b[conta[chiave(x)]] = x
        conta[chiave(x)] += 1
    return b

print(ordina_per_conteggio([3, 0, 2, 3, 1, 0, 3], 4))
voti = [('Anna', 7), ('Bruno', 5), ('Carla', 7), ('Dario', 6),
        ('Elena', 5)]
for r in ordina_per_conteggio(voti, 11, lambda r: r[1]):
    print(r)


def ordina_per_cifre(a, base=10):
    if not a:
        return a
    massimo = max(a)
    divisore = 1
    while massimo // divisore > 0:
        a = ordina_per_conteggio(
            a, base, lambda x: x // divisore % base)
        divisore *= base
    return a

dati = [329, 457, 657, 839, 436, 720, 355, 7]
divisore = 1
passo = dati
for _ in range(3):
    passo = ordina_per_conteggio(
        passo, 10, lambda x: x // divisore % 10)
    print(passo)
    divisore *= 10
print(ordina_per_cifre(dati, 16))


def ordina_a_secchi(a):
    n = len(a)
    if n == 0:
        return []
    minimo, massimo = min(a), max(a)
    if minimo == massimo:
        return a[:]
    ampiezza = (massimo - minimo) / n
    secchi = [[] for _ in range(n)]
    for x in a:
        i = min(int((x - minimo) / ampiezza), n - 1)
        secchi[i].append(x)
    risultato = []
    for s in secchi:
        for i in range(1, len(s)):      # inserimento
            x, j = s[i], i - 1
            while j >= 0 and s[j] > x:
                s[j + 1] = s[j]
                j -= 1
            s[j + 1] = x
        risultato.extend(s)
    return risultato

import random
random.seed(9)
dati = [round(random.uniform(10, 20), 2) for _ in range(8)]
print(ordina_a_secchi(dati))

uniformi = [random.random() for _ in range(10000)]
ammassati = [random.random() ** 8 for _ in range(10000)]
casi = (('uniformi', uniformi), ('ammassati', ammassati))
for nome, d in casi:
    assert ordina_a_secchi(d) == sorted(d)
    n = len(d)
    lo, hi = min(d), max(d)
    occ = [0] * n
    for x in d:
        occ[min(int((x - lo) / ((hi - lo) / n)), n - 1)] += 1
    print(nome, max(occ), sum(c * c for c in occ))
