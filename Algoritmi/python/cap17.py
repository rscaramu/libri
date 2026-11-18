# Algoritmi - Roberto Scaramuzzino
# Capitolo 17
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

confronti = 0

def scendi_max(a, i, n):
    global confronti
    while True:
        maggiore = i
        s, d = 2 * i + 1, 2 * i + 2
        if s < n:
            confronti += 1
            if a[s] > a[maggiore]:
                maggiore = s
        if d < n:
            confronti += 1
            if a[d] > a[maggiore]:
                maggiore = d
        if maggiore == i:
            return
        a[i], a[maggiore] = a[maggiore], a[i]
        i = maggiore

def heapsort(a):
    n = len(a)
    for i in range(n // 2 - 1, -1, -1):
        scendi_max(a, i, n)
    for fine in range(n - 1, 0, -1):
        a[0], a[fine] = a[fine], a[0]
        scendi_max(a, 0, fine)

dati = [5, 13, 2, 25, 7, 17, 20, 8, 4]
n = len(dati)
for i in range(n // 2 - 1, -1, -1):
    scendi_max(dati, i, n)
print(dati)
for fine in range(n - 1, n - 4, -1):
    dati[0], dati[fine] = dati[fine], dati[0]
    scendi_max(dati, 0, fine)
    print(dati[:fine], dati[fine:])
heapsort(dati)
print(dati)


import math
import random

def confronti_merge(a):
    if len(a) <= 1:
        return a, 0
    m = len(a) // 2
    s, x = confronti_merge(a[:m])
    d, y = confronti_merge(a[m:])
    r, c, i, j = [], 0, 0, 0
    while i < len(s) and j < len(d):
        c += 1
        if s[i] <= d[j]:
            r.append(s[i])
            i += 1
        else:
            r.append(d[j])
            j += 1
    return r + s[i:] + d[j:], x + y + c

random.seed(8)
print('     n   limite    merge     heap')
for n in (10, 100, 1000, 10000):
    limite = math.ceil(math.log2(math.factorial(n)))
    dati = list(range(n))
    random.shuffle(dati)
    cm = confronti_merge(dati)[1]
    confronti = 0
    copia = dati[:]
    heapsort(copia)
    assert copia == sorted(dati)
    print(f'{n:>6} {limite:>8} {cm:>8} {confronti:>8}')
