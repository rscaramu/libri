# Algoritmi - Roberto Scaramuzzino
# Capitolo 15
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def fondi(s, d):
    r = []
    i = j = 0
    while i < len(s) and j < len(d):
        if s[i] <= d[j]:
            r.append(s[i])
            i += 1
        else:
            r.append(d[j])
            j += 1
    r.extend(s[i:])
    r.extend(d[j:])
    return r

confronti = 0

def merge_sort(a, basso=0, alto=None, aus=None):
    global confronti
    if alto is None:
        alto = len(a) - 1
        aus = a[:]              # un solo array ausiliario
    if basso >= alto:
        return
    medio = basso + (alto - basso) // 2
    merge_sort(a, basso, medio, aus)
    merge_sort(a, medio + 1, alto, aus)
    aus[basso:alto + 1] = a[basso:alto + 1]
    i, j = basso, medio + 1
    for k in range(basso, alto + 1):
        if j > alto:
            a[k] = aus[i]
            i += 1
        elif i > medio:
            a[k] = aus[j]
            j += 1
        else:
            confronti += 1
            if aus[i] <= aus[j]:
                a[k] = aus[i]
                i += 1
            else:
                a[k] = aus[j]
                j += 1

print(fondi([1, 4, 9], [2, 3, 10, 12]))
dati = [38, 27, 43, 3, 9, 82, 10]
merge_sort(dati)
print(dati)


import math
import random

random.seed(11)
for n in (1000, 10000, 100000):
    dati = list(range(n))
    random.shuffle(dati)
    atteso = sorted(dati)
    confronti = 0
    merge_sort(dati)
    assert dati == atteso
    stima = round(n * math.log2(n))
    ins = n * n // 4
    print(f'{n:>6} {confronti:>8} {stima:>8} {ins:>11}')


def merge_sort_chiave(a, chiave):
    if len(a) <= 1:
        return a[:]
    medio = len(a) // 2
    s = merge_sort_chiave(a[:medio], chiave)
    d = merge_sort_chiave(a[medio:], chiave)
    r = []
    i = j = 0
    while i < len(s) and j < len(d):
        if chiave(s[i]) <= chiave(d[j]):
            r.append(s[i])
            i += 1
        else:
            r.append(d[j])
            j += 1
    return r + s[i:] + d[j:]

persone = [('Anna', 'Roma'), ('Bruno', 'Bari'),
           ('Carla', 'Roma'), ('Dario', 'Bari'),
           ('Elena', 'Asti')]
for p in merge_sort_chiave(persone, lambda p: p[1]):
    print(p)


def merge_sort_dal_basso(a):
    n = len(a)
    ampiezza = 1
    while ampiezza < n:
        for basso in range(0, n - ampiezza, 2 * ampiezza):
            medio = basso + ampiezza
            alto = min(basso + 2 * ampiezza, n)
            s, d = a[basso:medio], a[medio:alto]
            a[basso:alto] = fondi(s, d)
        ampiezza *= 2

dati = [38, 27, 43, 3, 9, 82, 10]
merge_sort_dal_basso(dati)
print(dati)


def conta_inversioni(a):
    if len(a) <= 1:
        return a[:], 0
    medio = len(a) // 2
    s, x = conta_inversioni(a[:medio])
    d, y = conta_inversioni(a[medio:])
    r, z = [], 0
    i = j = 0
    while i < len(s) and j < len(d):
        if s[i] <= d[j]:
            r.append(s[i])
            i += 1
        else:
            r.append(d[j])
            j += 1
            z += len(s) - i
    return r + s[i:] + d[j:], x + y + z

def inversioni_ingenuo(a):
    n = len(a)
    return sum(1 for i in range(n) for j in range(i + 1, n)
               if a[i] > a[j])

for prova in ([2, 4, 1, 3, 5], [5, 4, 3, 2, 1], [1, 2, 3]):
    veloce = conta_inversioni(prova)[1]
    print(veloce, inversioni_ingenuo(prova))
