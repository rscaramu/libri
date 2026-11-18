# Algoritmi - Roberto Scaramuzzino
# Capitolo 6
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def copie(n, cresci):
    capacita, presenti, copiati = 0, 0, 0
    for _ in range(n):
        if presenti == capacita:
            copiati += presenti
            capacita = cresci(capacita)
        presenti += 1
    return copiati

def raddoppia(c):
    return max(1, 2 * c)

def piu_cento(c):
    return c + 100

for n in (1000, 10000, 100000):
    r = copie(n, raddoppia)
    f = copie(n, piu_cento)
    print(f'{n:>6} {r:>7} {r / n:.2f} {f:>9} {f / n:.1f}')


def incrementa(b):
    cambi = 0
    i = 0
    while i < len(b) and b[i] == 1:
        b[i] = 0
        cambi += 1
        i += 1
    if i < len(b):
        b[i] = 1
        cambi += 1
    return cambi

for n in (16, 1000, 100000):
    b = [0] * 20
    totale = sum(incrementa(b) for _ in range(n))
    print(n, totale, round(totale / n, 5))


def confronti_ricerca(a, x):
    for i in range(len(a)):
        if a[i] == x:
            return i + 1
    return len(a)

for n in (10, 101, 1000):
    a = list(range(n))
    totale = sum(confronti_ricerca(a, x) for x in a)
    print(n, totale / n, (n + 1) / 2)


import random

def aggiornamenti(a):
    m, volte = a[0], 0
    for i in range(1, len(a)):
        if a[i] > m:
            m = a[i]
            volte += 1
    return volte

random.seed(7)
for n in (10, 100, 1000):
    prove = 4000
    totale = 0
    for _ in range(prove):
        a = list(range(n))
        random.shuffle(a)
        totale += aggiornamenti(a)
    atteso = sum(1 / k for k in range(2, n + 1))
    print(n, round(totale / prove, 2), round(atteso, 2))
