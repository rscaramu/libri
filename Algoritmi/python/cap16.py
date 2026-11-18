# Algoritmi - Roberto Scaramuzzino
# Capitolo 16
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

import random

confronti = 0

def partiziona(a, basso, alto):
    global confronti
    perno = a[alto]
    i = basso
    for j in range(basso, alto):
        confronti += 1
        if a[j] <= perno:
            a[i], a[j] = a[j], a[i]
            i += 1
    a[i], a[alto] = a[alto], a[i]
    return i

def quicksort(a, casuale=True):
    basso, alto = 0, len(a) - 1
    pila = [(basso, alto)]
    while pila:
        basso, alto = pila.pop()
        while basso < alto:
            if casuale:
                r = random.randint(basso, alto)
                a[r], a[alto] = a[alto], a[r]
            p = partiziona(a, basso, alto)
            # prima la parte piu' piccola, poi si prosegue
            if p - basso < alto - p:
                pila.append((p + 1, alto))
                alto = p - 1
            else:
                pila.append((basso, p - 1))
                basso = p + 1

dati = [9, 3, 7, 1, 8, 2, 5]
quicksort(dati)
print(dati)

random.seed(2)
n = 2000
ordinata = list(range(n))
mescolata = ordinata[:]
random.shuffle(mescolata)
casi = (('mescolata', mescolata), ('ordinata', ordinata))
for nome, dati in casi:
    for casuale in (False, True):
        copia = dati[:]
        confronti = 0
        quicksort(copia, casuale)
        assert copia == ordinata
        print(f'{nome:<10} {str(casuale):<6} {confronti:>8}')


def quicksort_tre_vie(a):
    global confronti
    pila = [(0, len(a) - 1)]
    while pila:
        basso, alto = pila.pop()
        if basso >= alto:
            continue
        r = random.randint(basso, alto)
        a[basso], a[r] = a[r], a[basso]
        perno = a[basso]
        mino, i, mag = basso, basso, alto
        while i <= mag:
            confronti += 1
            if a[i] < perno:
                a[mino], a[i] = a[i], a[mino]
                mino += 1
                i += 1
            elif a[i] > perno:
                a[i], a[mag] = a[mag], a[i]
                mag -= 1
            else:
                i += 1
        pila.append((basso, mino - 1))
        pila.append((mag + 1, alto))

random.seed(4)
poche = [random.randint(1, 5) for _ in range(2000)]
uguali = [7] * 2000
casi = (('5 chiavi', poche), ('tutti uguali', uguali))
for nome, dati in casi:
    copia = dati[:]
    confronti = 0
    quicksort(copia)
    c1 = confronti
    copia2 = dati[:]
    confronti = 0
    quicksort_tre_vie(copia2)
    assert copia == copia2 == sorted(dati)
    print(f'{nome:<13} {c1:>8} {confronti:>6}')
